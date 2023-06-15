% TODO
% Isolate single eruptions completely : Done
% Make debug SEA plots of AOD to test the SEA code : Done

load 'vssi_data.mat'
load 'volcano_data.mat'

% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3) or aod
test_var_name = 'frequency';
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 10;
% additional time before the window where no eruptions are allowed
before_window_filter = 0;
after = 10;

threshold = 20;
control_threshold = 1;
eruption_times = vssi_year(vssi_global > threshold);
%eruption_times = eruption_times(eruption_times > 1200);
%eruption_stops = eruption_stops(eruption_stops > 1200);

eruption_times  = eruption_times(eruption_times > 850 & eruption_times < 1900);
dir_indexes = find_nearest(eruption_times, event_time);

unfiltered_times = eruption_times;

% remove eruptions that are shortly followed by another eruption
% this should remove noise from the SEA analysis
diff_filter_after  = [diff(transpose(eruption_times)) inf] > after;
diff_filter_before = [inf diff(transpose(eruption_times))] > before + before_window_filter;
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
plot(vssi_year, vssi_global)
yline(threshold, '--');
xline(filtered_events);
makepretty_axes('Year', 'Volcanic Stratospheric Suphur Injection');

%% SEA Analysis

storm_years = 850 : 2000;
folder_name = test_var_name;

switch test_var_name
    case 'duration'
        load('../Storm Sets/AL_cesm_volc1.mat', 'duration_LMR21_all');
        test_var = duration_LMR21_all(1 : length(storm_years));
        plot_str = 'Storm Duration';
        y_str = 'Storm Duration (hours)';
    case 'frequency'
        load('../Storm Sets/AL_cesm_volc1.mat', 'freqyear_AL_cesm_volc1');
        test_var = freqyear_AL_cesm_volc1(1 : length(storm_years));
        plot_str = 'Storm Frequency';
        y_str = 'Storm Frequency';
    case 'intensity'
        load('../Storm Sets/AL_cesm_volc1.mat', 'vnetmax_AL_cesm_volc1');
        test_var = mean(reshape(vnetmax_AL_cesm_volc1, [100, length(vnetmax_AL_cesm_volc1) / 100]));
        test_var = test_var(1 : length(storm_years));
        plot_str = 'Storm Intensity';
        y_str = 'Change in Average Max Wind Velocity (knots)';
    case 'aod'
        test_var = max(reshape(aod550, [12, length(aod550) / 12]));
        plot_str = 'Optical Aerosol Depth';
        y_str = 'Change in AOD';
    case {'cluster1', 'cluster2', 'cluster3'}
        load '3_clusters.mat'
        LMR_cluster = eval(sprintf('LMR_%s', test_var_name));


        load('../Storm Sets/AL_cesm_volc1.mat', 'yearstore_AL_cesm_volc1');
        test_var = hist(yearstore_AL_cesm_volc1(LMR_cluster), 850 : 1999);
        test_var = test_var(1 : length(storm_years));
        
        plot_str = sprintf('Cluster %s Membership', test_var_name(end));
        y_str = 'Change in Cluster Membership (storms / year)';
        folder_name = 'cluster';
end

time_series = transpose([storm_years; test_var]);

non_eruption = vssi_global < control_threshold;
% This filter was causing there to be an upward trend in the CI
control_index = find(forward_distance(~non_eruption) > before & flip(forward_distance(flip(~non_eruption))) > after);
%control_index = find(non_eruption);


[test_seas, control_seas] = sea_with_control(time_series, floor(filtered_events), control_index, ceil(length(filtered_events) * 2 / 3), before, after);
%% SEA plotting code

time_window = -before : after;
control_seas_ci = quantile(control_seas, [0.05, 0.95], 2);
figure(2);
clf;
plot(time_window, control_seas_ci(:, 1), '--', 'MarkerSize', 10, 'LineWidth', 1, 'Color', 'k');
hold on;
plot(time_window, control_seas_ci(:, 2), '--', 'MarkerSize', 10, 'LineWidth', 1, 'Color', 'k');
hold on;

% compute 95% CI
test_seas_ci = quantile(test_seas, [0.05, 0.95], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower_quint = test_seas_ci(:, 1).';
upper_quint = test_seas_ci(:, 2).';
y_area = [lower_quint, upper_quint(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

% compute inner 2 quartiles
test_seas_ci = quantile(test_seas, [0.25, 0.75], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower_quint = test_seas_ci(:, 1).';
upper_quint = test_seas_ci(:, 2).';
y_area = [lower_quint, upper_quint(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

axis([-before, after, -inf, inf]);
makepretty_axes('Lag (Years)', y_str);
title(['SEA of ' plot_str '; ' hemi_str]);
subtitle(['VSSI threshold = ' num2str(threshold) ', N = ' num2str(length(filtered_events))]);
xline(0, '--');
if ~isfolder(folder_name)
    mkdir(folder_name);
end
print([folder_name '/sea_' test_var_name '_cesm_thr_' num2str(threshold) '.png'], '-dpng', '-r300');
