% TODO
% Isolate single eruptions completely : Done
% Make debug SEA plots of AOD to test the SEA code : Done

load 'volcano_data.mat'

% === set your control variables ===
% can be duration, frequency, intensity, or AOD
test_var_name = 'frequency';
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nt';
before = 3;
% additional time before the window where no eruptions are allowed
before_window_filter = 4;
after = 8;

threshold = 0.07;
control_threshold = 0.003;
eruption_times = time(find(diff(aod550 >= threshold) == 1));
eruption_stops = time(find(diff(aod550 >= threshold) == -1));

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

figure(1);
clf;
hold on;
plot(time, aod550)
yline(threshold, '--');
xline(filtered_events);
makepretty_axes('Year', 'Optical Aerosol Depth');

%% SEA Analysis

load '../Storm Sets/LMR21_Atl_storms.mat';

storm_years = 850 : 1900;

switch test_var_name
    case 'duration'
        test_var = duration_LMR21_all(1 : length(storm_years));
        plot_str = 'Storm Duration';
        y_str = 'Storm Duration (Hours)';
    case 'frequency'
        test_var = freqyear_LMR21_all(1 : length(storm_years));
        plot_str = 'Storm Frequency';
        y_str = 'Storm Frequency';
    case 'intensity'
        test_var = mean(reshape(vnetmax_LMR21_all, [100, length(vnetmax_LMR21_all) / 100]));
        test_var = test_var(1 : length(storm_years));
        plot_str = 'Storm Intensity';
        y_str = 'Change in Average Max Wind Velocity (knots)';
    case 'aod'
        test_var = max(reshape(aod550, [12, length(aod550) / 12]));
        plot_str = 'Optical Aerosol Depth';
        y_str = 'Change in AOD';
end

time_series = transpose([storm_years; test_var]);

non_eruption_index = find(mean(reshape(aod550, [12, length(aod550) / 12])) < control_threshold);

[alligned, avg, rnd] = sea_with_control(time_series, floor(filtered_events), non_eruption_index, before, after);

%% SEA plotting code

time_window = -before : after;
figure(2);
clf;
plot(time_window, alligned, ':');
hold on;
plot(time_window, avg, '.-', 'MarkerSize', 10, 'LineWidth', 1, 'Color', 'k');
hold on;

% compute 95% CI
rnd_ci = quantile(rnd, [0.05, 0.95], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower_quint = rnd_ci(:, 1).';
upper_quint = rnd_ci(:, 2).';
y_area = [lower_quint, upper_quint(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

% compute inner 2 quartiles
rnd_ci = quantile(rnd, [0.25, 0.75], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower_quint = rnd_ci(:, 1).';
upper_quint = rnd_ci(:, 2).';
y_area = [lower_quint, upper_quint(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

axis([-before, after, -inf, inf]);
makepretty_axes('Lag (Years)', y_str);
title(['SEA of ' plot_str '; ' hemi_str]);
subtitle(['AOD threshold = ' num2str(threshold) ', N = ' num2str(length(filtered_events))]);
xline(0, '--');
print(['sea_' test_var_name '_fix_thr_' num2str(threshold) '.png'], '-dpng', '-r400');
