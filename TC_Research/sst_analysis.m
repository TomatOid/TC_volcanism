%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 5;
% additional time before the window where no eruptions are allowed
before_window_filter = 1;
after = 10;

threshold = 0.22;
control_threshold = 0.007;
test_var_name = 'rel_sst';

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

load 'sst_annual.mat'

filtered_events = [1808];
mask_land = 1;
map_bounds = [0, 60, -100, 0];

switch (test_var_name)
    case 'sst'
        test_var = SST;
        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after, control_index);
        plot_str = 'SST';
        is_zero_centered = 0;
    case 'sst_spac_anom'
        mask = get_landmask(lon, lat);
        mask(mask == 1) = NaN;
        SST_anom = SST + repmat(mask, 1, 1, length(SST));
        test_var = (SST_anom - mean(SST_anom, [1, 2], 'omitnan')) ./ std(SST_anom, 1, [1, 2], 'omitnan');

        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after, control_index);
        plot_str = 'SST Spacial Anomaly';
        is_zero_centered = 1;
    case 'sst_temp_anom'
        mask = get_landmask(lon, lat);
        mask(mask == 1) = NaN;
        SST_anom = SST + repmat(mask, 1, 1, length(SST));
        test_var = (SST_anom - mean(SST_anom, 3, 'omitnan')) ./ std(SST_anom, 1, 3, 'omitnan');

        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after);
        plot_str = 'SST Temporal Anomaly';
        is_zero_centered = 1;
    case 'rel_sst'
        % 1D version is same box - (30S to 30N) range
        mask = get_landmask(lon, lat);
        mask(mask == 1) = NaN;
        SST_relative = SST + repmat(mask, 1, 1, length(SST));
        lat_window = find_nearest([7.5, 22.5], lat);
        lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
        tropical_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');

        SST_relative = SST_relative - tropical_mean;
        test_var = SST_relative;

        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after, control_index);
        plot_str = 'Relative SST';
        is_zero_centered = 0;
    case 'gen_density'
        load 'genesis_density.mat'
        test_var = genesis_density;
        %test_var = imgaussfilt(test_var, 1);
        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after);
        plot_str = 'Genesis Density';
        is_zero_centered = 0;
        map_bounds = [10, 40, -100, -40];
    case 'track_density'
        load 'track_density.mat'
        test_var = track_density;
        [sea, pscore] = map_sea(sst_years, test_var, filtered_events, before, after);
        plot_str = 'Track Density';
        is_zero_centered = 0;
        mask_land = 0;
        map_bounds = [10, 40, -100, -40];
end

%% Drawing Code


%land = readgeotable('landareas.shp');
lon_wrap = wrapTo180(lon);
lon_wrap = circshift(lon_wrap, length(lon) / 2);
image_sea = circshift(sea, length(lon) / 2, 1);
image_pscore = circshift(pscore, length(lon) / 2, 1);

if (mask_land)
    mask = get_landmask(lon_wrap, lat);
    mask(mask == 1) = NaN;

    for i = 1 : before + after + 1
        image_sea(:, :, i) = image_sea(:, :, i) + mask;
        image_pscore(:, :, i) = image_pscore(:, :, i) + mask;
        %image_sea(:, :, i) = (image_sea(:, :, i) - mean(image_sea(:, :, i), 'all', 'omitnan')) / std(image_sea(:, :, i), 1, 'all', 'omitnan');
    end
end
%image_sea = (image_sea - repmat(mean(image_sea, 3), 1, 1, before + after + 1)) ./ repmat(std(image_sea, 1, 3), 1, 1, before + after + 1);

image_sea(image_sea == 0) = NaN;
image_sea = permute(image_sea, [2, 1, 3]);
image_pscore = permute(image_pscore, [2, 1, 3]);
%image_sea(isnan(image_sea)) = 0;
%axesm;

% [lat_min, lat_max, lon_min, lon_max]
bounds_idx = [find_nearest(map_bounds(1 : 2), lat), find_nearest(map_bounds(3 : 4), lon_wrap)];

image_sea = image_sea(bounds_idx(1) : bounds_idx(2), bounds_idx(3) : bounds_idx(4), :);
image_pscore = image_pscore(bounds_idx(1) : bounds_idx(2), bounds_idx(3) : bounds_idx(4), :);
image_lat = lat(bounds_idx(1) : bounds_idx(2));
image_lon = lon_wrap(bounds_idx(3) : bounds_idx(4));

%frames(before + after + 1) = struct('cdata', [], 'colormap', []);%
hi_color = max(image_sea, [], 'all');
lo_color = min(image_sea, [], 'all');
[stipple_lon, stipple_lat] = meshgrid(image_lon, image_lat);
filename = ['gen_density_animation_aod_' num2str(threshold) '.gif']; 
%image_sea(image_sea < 101900) = NaN;
clf;
%tiledlayout(4, 4);

for loop_num = 1 : 1
    for i = 3 : 11
        nexttile
        is_signif = ((image_pscore(:, :, i) > 0.95 | image_pscore(:, :, i) < 0.05)) & ~isnan(image_sea(:, :, i));
        s = pcolor(image_lon, image_lat, image_sea(:, :, i));
        set(s, 'edgecolor', 'none');
        s.FaceColor = 'interp';
        hold on;
        %[points_lat, points_lon] = find(image_sea(:, :, i) > 101900);
        %bound_idx = boundary(points_lon, points_lat);
        %plot(image_lon(points_lon(bound_idx)), image_lat(points_lat(bound_idx)), 'linewidth', 2, 'color', 'k');
        %contour(image_lon, image_lat, image_sea(:, :, i), [101900 102000], 'linewidth', 1.5, 'color', 'k');
        ylim([map_bounds(1) - 2, map_bounds(2) + 2]);
        xlim([map_bounds(3) - 2, map_bounds(4) + 2]);
        hold on;

        borders('countries', 'color', 'k');
        stipple(stipple_lon, stipple_lat, is_signif);
        if (is_zero_centered)
            colormap(redblue);
        else
            colormap(jet);
        end
        colorbar();
        %caxis([lo_color, hi_color]);
        title([plot_str, ', t = ', num2str(i - before - 1), ', AOD threshold = ', num2str(threshold)]);
        drawnow


        %frame = getframe(gcf);
        %img = frame2im(frame);
        %[img, cmap] = rgb2ind(img, 256);

        %if (loop_num == 1)
        %    if (i == 1)
        %        imwrite(img, cmap, filename, 'gif', 'LoopCount', Inf, 'DelayTime', 1);
        %    else
        %        imwrite(img, cmap, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1);
        %    end
        %end
        %pause(0.5);
    end
end
%borders();
%movie(frames, 10, 1);
