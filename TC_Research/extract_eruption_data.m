function [filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold)

    load 'volcano_data.mat'

    
    eruption_times = time(find(diff(aod550 >= threshold) == 1));
    eruption_stops = time(find(diff(aod550 >= threshold) == -1));
    %eruption_times = eruption_times(eruption_times > 1200);
    %eruption_stops = eruption_stops(eruption_stops > 1200);

    unfiltered_times = eruption_times;

    % remove eruptions that are shortly followed by another eruption
    % this should remove noise from the SEA analysis
    diff_filter_after  = [diff(transpose(eruption_times)) inf] > after;
    diff_filter_before = [inf diff(transpose(eruption_stops))] > before + before_window_filter;
    eruption_times = eruption_times(diff_filter_before & diff_filter_after);

    dir_indexes = find_nearest(eruption_times, event_time);
    % now use the matched datasets to bin eruption times into three
    % lattitude reigions
    south = [];
    tropics = [];
    north = [];

    %south = squeeze(eruption_times(hemi(dir_indexes) < 1 & hemi(dir_indexes) > 0)).';
    %north = squeeze(eruption_times(hemi(dir_indexes) > 1)).';
    %tropics = squeeze(eruption_times(hemi(dir_indexes) == 1 | hemi(dir_indexes) < 0)).';

    for i = 1 : length(eruption_times)
        if (lat(dir_indexes(i)) < -10)
            south = [south eruption_times(i)];
        elseif (lat(dir_indexes(i)) > 10)
            north = [north eruption_times(i)];
        else
            tropics = [tropics eruption_times(i)];
        end
    end

    filtered_events = [];
    hemi_names = {};
    if (contains(reigions, 'n'))
        filtered_events = [filtered_events north];
        hemi_names = [hemi_names, {'North'}];
    end
    if (contains(reigions, 't'))
        filtered_events = [filtered_events tropics];
        hemi_names = [hemi_names, {'Tropics'}];
    end
    if (contains(reigions, 's'))
        filtered_events = [filtered_events south];
        hemi_names = [hemi_names, {'South'}];
    end

    if (length(hemi_names) > 1)
        hemi_names{end} = ['and ' hemi_names{end}];
    end
    if (length(hemi_names) > 2)
        hemi_str = strjoin(hemi_names, ', ');
    else
        hemi_str = strjoin(hemi_names);
    end

    filtered_events = sort(filtered_events);

    non_eruption = mean(reshape(aod550, [12, length(aod550) / 12])) < control_threshold;
    control_index = find(non_eruption);
end
