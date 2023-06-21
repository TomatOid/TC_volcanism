function [filtered_events, control_index, test_var, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold)

    load 'volcano_data.mat'

    
    eruption_times = time(find(diff(aod550 >= threshold) == 1));
    eruption_stops = time(find(diff(aod550 >= threshold) == -1));
    %eruption_times = eruption_times(eruption_times > 1200);
    %eruption_stops = eruption_stops(eruption_stops > 1200);

    dir_indexes = find_nearest(eruption_times, event_time);

    unfiltered_times = eruption_times;

    % remove eruptions that are shortly followed by another eruption
    % this should remove noise from the SEA analysis
    diff_filter_after  = [diff(transpose(eruption_times)) inf] > after;
    diff_filter_before = [inf diff(transpose(eruption_stops))] > before + before_window_filter;
    eruption_times = eruption_times(diff_filter_before & diff_filter_after);

    % now use the matched datasets to bin eruption times into three
    % lattitude reigions
    south = [];
    tropics = [];
    north = [];

    for i = 1 : length(eruption_times)
        if (lat(dir_indexes(i)) < -20)
            south = [south eruption_times(i)];
        elseif (lat(dir_indexes(i)) > 20)
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

    hemi_names{end} = ['and ' hemi_names{end}];
    if (length(hemi_names) > 2)
        hemi_str = strjoin(hemi_names, ', ');
    else
        hemi_str = strjoin(hemi_names);
    end

    filtered_events = sort(filtered_events);

    non_eruption = mean(reshape(aod550, [12, length(aod550) / 12])) < control_threshold;
    control_index = find(non_eruption);
end