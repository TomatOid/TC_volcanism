% TODO
% Isolate single eruptions completely : Done
% Make debug SEA plots of AOD to test the SEA code : Done

load 'volcano_data.mat'

% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3) or aod
test_var_name = 'intensity';
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nt';
before = 5;
% additional time before the window where no eruptions are allowed
before_window_filter = 1;
after = 10;

threshold = 0.13;
control_threshold = 0.007;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold)

%figure(1);
%clf;
%hold on;
%plot(time, aod550)
%yline(threshold, '--');
%xline(filtered_events);
%makepretty_axes('Year', 'Optical Aerosol Depth');

%% SEA Analysis

storm_years = 850 : 1900;
folder_name = test_var_name;

switch test_var_name
    case 'duration'
        load('LMR20_Atl_storms_lite.mat', 'duration_LMR21_all');
        test_var = duration_LMR21_all(1 : length(storm_years));
        plot_str = 'Storm Duration';
        y_str = 'Storm Duration (hours)';
    case 'frequency'
        load('LMR20_Atl_storms_lite.mat', 'freqyear');
        test_var = freqyear(1 : length(storm_years));
        plot_str = 'Storm Frequency';
        y_str = 'Storm Frequency';
    case 'intensity'
        load('LMR20_Atl_storms_lite.mat', 'vnetmax');
        test_var = mean(reshape(vnetmax, [100, length(vnetmax) / 100]));
        test_var = test_var(1 : length(storm_years));
        plot_str = 'Storm Intensity';
        y_str = 'Average Max Wind Velocity (knots)';
    case 'aod'
        test_var = max(reshape(aod550, [12, length(aod550) / 12]));
        plot_str = 'Optical Aerosol Depth';
        y_str = 'Change in AOD';
    case {'cluster1', 'cluster2', 'cluster3'}
        load '3_clusters.mat'
        LMR_cluster = eval(sprintf('LMR_%s', test_var_name));


        load('LMR20_Atl_storms_lite.mat', 'yearstore_LMR21_all');
        test_var = hist(yearstore_LMR21_all(LMR_cluster), 850 : 1999);
        test_var = test_var(1 : length(storm_years));
        
        plot_str = sprintf('Cluster %s Membership', test_var_name(end));
        y_str = 'Cluster Membership (storms / year)';
        folder_name = 'cluster';
    case 'genlat'
        load('LMR20_Atl_storms_lite.mat', 'latstore_LMR21_all');
        genesis_lats = latstore_LMR21_all(:, 1);
        delete latstore_LMR21_all;
        test_var = mean(reshape(genesis_lats, [100, length(genesis_lats) / 100]));
        test_var = test_var(1 : length(storm_years));
        
        plot_str = 'Genesis Lattitudes';
        y_str = 'Average Genisis Lattitude';
    case 'genlon'
        load('LMR20_Atl_storms_lite.mat', 'longstore_LMR21_all');
        genesis_lons = longstore_LMR21_all(:, 1);
        delete longstore_LMR21_all;
        test_var = mean(reshape(genesis_lons, [100, length(genesis_lons) / 100]));
        test_var = test_var(1 : length(storm_years));

        plot_str = 'Genesis Longitudes';
        y_str = 'Average Genesis Longitudes';
    case 'relsst'
        load 'SST_aso.mat'
        SST = SST_seasonal;
        % 1D version is same box - (30S to 30N) range
        mask = get_landmask(lon, lat);
        mask(mask == 1) = NaN;
        SST_relative = SST + repmat(mask, 1, 1, length(SST));
        lat_window = find_nearest([7.5, 22.5], lat);
        lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
        MDR_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');

        lat_window = find_nearest([-30, 30], lat);
        lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
        tropical_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');

        test_var = squeeze(MDR_mean - tropical_mean).';
        test_var = test_var(1 : length(storm_years));

        plot_str = 'Relative SSTs';
        y_str = 'MDR mean - tropical mean';
end

% add smoothing, we don't want anything that happens over a scale of 15-years influencing our results
% 15 years is longer than an ENSO cycle

%test_var = test_var - movmean(test_var, 15);

time_series = transpose([storm_years; test_var]);

[test_seas, control_seas] = sea_with_control(time_series, floor(filtered_events), control_index, before, after);

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
subtitle(['AOD threshold = ' num2str(threshold) ', N = ' num2str(length(filtered_events))]);
xline(0, '--');
if ~isfolder(folder_name)
    mkdir(folder_name);
end
print([folder_name '/sea_' test_var_name '_20_thr_' num2str(threshold) '.png'], '-dpng', '-r300');
