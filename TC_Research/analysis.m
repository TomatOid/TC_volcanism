% TODO
% Isolate single eruptions completely : Done
% Make debug SEA plots of AOD to test the SEA code

load 'volcano_data.mat'

before = 3;
after = 8;

threshold = 0.13;
eruption_times = time(find(diff(aod550 >= threshold) == 1));
eruption_stops = time(find(diff(aod550 >= threshold) == -1));

dir_indexes = find_nearest(eruption_times, event_time);

unfiltered_times = eruption_times;

% remove eruptions that are shortly followed by another eruption
% this should remove noise from the SEA analysis
diff_filter_after  = [diff(transpose(eruption_times)) inf] > after;
diff_filter_before = [inf diff(transpose(eruption_stops))] > before;
eruption_times = eruption_times(diff_filter_before & diff_filter_after);

% now use the matched datasets to bin eruption times into three
% lattitude reigions
south = [];
tropics = [];
north = [];

for i = 1 : length(eruption_times)
    if (lat(dir_indexes(i)) < -10)
        south = [south eruption_times(i)];
    elseif (lat(dir_indexes(i)) > 10)
        north = [north eruption_times(i)];
    else
        tropics = [tropics eruption_times(i)];
    end
end

% only include the tropics and the north to reduce noise
filtered_events = sort([north tropics]);

figure(1);
clf;
hold on;
plot(time, aod550)
yline(threshold, '--');
xline(filtered_events);
makepretty_axes('Year', 'Optical Aerosol Depth');

%% SEA Analysis

%load '../Storm Sets/LMR21_Atl_storms.mat';
storm_years = 850 : 1900;

%freqyear = freqyear_LMR21_all(1 : length(storm_years));

%vmax_LMR21_all = sqrt(mean(reshape(vmax_LMR21_all .^ 2, [100, length(vmax_LMR21_all) / 100])));

%duration = duration_LMR21_all(1 : length(storm_years));
yearly_binned_aod = max(reshape(aod550, [12, length(aod550) / 12]))

fy_time_series = transpose([storm_years; yearly_binned_aod]);

[fy_events, fy_comp] = coral_sea(fy_time_series, floor(filtered_events) - 849, before, after);

non_eruption_index = find(mean(reshape(aod550, [12, length(aod550) / 12])) < threshold / 6);
non_eruption_index = non_eruption_index(non_eruption_index > before & non_eruption_index + after < length(aod550) / 12);
num_resample = 1000;
n_events = length(filtered_events);
window = before + after + 1;
rnd = zeros(window, num_resample);
event_indices = zeros(1, n_events);

for i = 1 : num_resample
    event_indices = randsample(non_eruption_index, n_events);
    [~, rnd(:, i)] = coral_sea(fy_time_series, event_indices, before, after);
end

%% SEA plotting code

time_window = -before : after;
figure(2);
clf;
plot(time_window, fy_events, ':');
hold on;
plot(time_window, fy_comp, '.-', 'MarkerSize', 10, 'LineWidth', 1, 'Color', 'k');
hold on;

% compute 95% CI
rnd_ci = quantile(rnd, [0.05, 0.95], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower = rnd_ci(:, 1).';
upper = rnd_ci(:, 2).';
y_area = [lower, upper(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

% compute inner 2 quartiles
rnd_ci = quantile(rnd, [0.25, 0.75], 2);

t_area = [time_window, time_window(end : -1 : 1)];
lower = rnd_ci(:, 1).';
upper = rnd_ci(:, 2).';
y_area = [lower, upper(end : -1 : 1)];
fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
hold on;

axis([-before, after, -inf, inf]);
makepretty_axes('Lag (Years)', 'Change in Storm Duration (Hours)');
title(['SEA of Storm Duration, -10 to 90 degrees N']);
subtitle(['AOD threshold = ' num2str(threshold) ', N = ' num2str(n_events)]);
xline(0, '--');
print(['sea_duration_nt_thr_' num2str(threshold) '.png'], '-dpng', '-r400');
