%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nt';
before = 3;
% additional time before the window where no eruptions are allowed
before_window_filter = 0;
after = 3;

threshold = 0.22;
control_threshold = 0.07;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

%filtered_events = [1902, 1912, 1932, 1963, 1982, 1991];
%sort(filtered_events);

load 'track_density_lmr20.mat'
%load 'track_density_cera.mat'
%load 'slp_annual_raw.mat'
load 'sst_annual.mat'
lat = cast(lat, 'single');
lon = cast(lon, 'single');
SST = track_density;
%sst_years = slp_years;
%sst_years = 1901 : 2010;

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
do_multipanel = 0;
if (do_multipanel)
    [change, p_value] = three_yr_twopanel(sst_years, SST, filtered_events, control_index);
else
    [change, p_value] = three_yr_diff_wilcoxon(sst_years, SST, filtered_events);
    %[change, p_value] = three_yr_diff(sst_years, SST, filtered_events, control_index);
    change = reshape(change, [size(change), 1]);
    p_value = reshape(p_value, [size(p_value), 1]);
end

mask = get_landmask(lon, lat);
mask = zeros(size(mask));
mask(mask == 1) = NaN;
im_change = change + mask;
im_p_value = p_value + mask;

lon_wrap = wrapTo180(lon);
rotate_by = length(lon) - find(lon_wrap < 0, 1) + 1;
lon_wrap = circshift(lon_wrap, rotate_by);

im_change = circshift(im_change, rotate_by, 1);
im_p_value = circshift(im_p_value, rotate_by, 1);

im_change = permute(im_change, [2, 1, 3]);
im_p_value = permute(im_p_value, [2, 1, 3]);

%% 
clf;
data_size = size(change);
if (length(data_size) == 2)
    data_size = [data_size, 1];
    cm = redblue;
    c_scale = max(abs(min(im_change, [], 'all')), max(im_change, [], 'all'));
    ca = [-c_scale, c_scale];
else
    cm = jet;
    ca = [min(im_change, [], 'all'), max(im_change, [], 'all')];
end

load_volcanic_lookup;

for i = 1 : data_size(end);
    nexttile;
    s = pcolor(lon_wrap, lat, im_change(:, :, i));
    %datatip_z2cdata(s);
    hold on;
    c = contour(lon_wrap, lat, im_change(:, :, i), 'linewidth', 1, 'linecolor', '#aaaaaa');
    hold on;
    ax = gca;
    ax.Color = '#f2eee9';
    set(s, 'edgecolor', 'none');
    s.FaceColor = 'interp';
    colormap(cm);
    [LON, LAT] = meshgrid(lon_wrap, lat);
    if (~do_multipanel)
        %is_signif = (im_p_value(:, :, i) > 0.99 | im_p_value(:, :, i) < 0.01) & ~isnan(im_change(:, :, i));
        is_signif = (im_p_value(:, :, i) < 0.1) & ~isnan(im_change(:, :, i));
        stipple(LON, LAT, is_signif);
        hold on;
    else
        t_cell = {'before', 'after'};
        title(t_cell{i});
    end
    colorbar();
    caxis(ca);
    xlim([-100, 0]);
    ylim([-10, 60]);
    borders('countries', 'color', 'k');
    hold on;

    [~, volc_idx] = intersect(volcano_years, floor(filtered_events));
    scatter(volcano_lon(volc_idx), volcano_lat(volc_idx), 30, 'filled', '^', 'MarkerFaceColor', '#D95319', 'MarkerEdgeColor', '#A2142F');
end
