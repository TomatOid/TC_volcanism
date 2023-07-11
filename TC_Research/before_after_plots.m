%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nt';
before = 3;
% additional time before the window where no eruptions are allowed
before_window_filter = 0;
after = 3;

threshold = 0.13;
control_threshold = 0.007;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

%filtered_events = [1808];

load 'track_density_lmr20.mat'
load 'sst_annual.mat'
lat = cast(lat, 'single');
lon = cast(lon, 'single');
SST = track_density;
%sst_years = prate_years;

%mask = get_landmask(lon, lat);
%mask(mask == 1) = NaN;
%SST_relative = SST + repmat(mask, 1, 1, length(SST));
%
%lat_window = find_nearest([7.5, 22.5], lat);
%lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
%tropical_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');
%
%SST_relative = SST_relative - tropical_mean;

%SST_del2 = del2(SST);
[change, p_value] = three_yr_diff(sst_years, SST, filtered_events, control_index);


mask = get_landmask(lon, lat);
mask = zeros(size(mask));
mask(mask == 1) = NaN;
im_change = change + mask;
im_p_value = p_value + mask;

lon_wrap = wrapTo180(lon);
rotate_by = length(lon) - find(lon_wrap < 0, 1) + 1;
lon_wrap = circshift(lon_wrap, rotate_by);

im_change = circshift(im_change, rotate_by);
im_p_value = circshift(im_p_value, rotate_by);
im_mask = circshift(mask, rotate_by);

clf;
s = pcolor(lon_wrap, lat, im_change.');
datatip_z2cdata(s);
hold on;
c = contour(lon_wrap, lat, im_change.' + max(im_change, [], 'all'), 'linewidth', 1, 'linecolor', '#aaaaaa');
hold on;
ax = gca;
ax.Color = '#f2eee9';
set(s, 'edgecolor', 'none');
s.FaceColor = 'interp';
colormap(redblue);
[LON, LAT] = meshgrid(lon_wrap, lat);
is_signif = ((im_p_value > 0.95 | im_p_value < 0.05)) & ~isnan(im_change);
stipple(LON, LAT, is_signif.');
hold on;
colorbar();
caxis([-8, 8]);
xlim([-100, 0]);
ylim([-10, 60]);
borders('countries', 'color', 'k');
