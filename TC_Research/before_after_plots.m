%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 3;
% additional time before the window where no eruptions are allowed
before_window_filter = 0;
after = 3;

threshold = 0.13;
control_threshold = 0.05;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

variable_name = 'lmr_gendensity';

switch (variable_name)
    case 'noaa_sst'
        filtered_events = [1902, 1912, 1932, 1963, 1982, 1991];
        load 'sst_annual_noaa.mat';
        lat = cast(lat, 'single');
        lon = cast(lon, 'single');
    case 'lmr_sst'
        load 'sst_annual_raw.mat';
    case 'lmr_trackdensity'
        load 'track_density.mat';
        load 'sst_annual.mat' 'sst_years';
        SST = track_density;
    case 'lmr_gendensity'
        load 'genesis_density_LMR21_combined.mat'
        %load 'sst_annual_raw.mat' 'sst_years';
        sst_years = 850 : 1999;
        SST = genesis_density;
    case 'cera_trackdensity';
        filtered_events = [1902, 1912, 1932, 1963, 1982, 1991];
        load 'track_density_cera.mat';
        SST = track_density;
        sst_years = 1901 : 2010;
end

do_multipanel = 0;
if (do_multipanel)
    [change, p_value] = three_yr_twopanel(sst_years, SST, filtered_events, control_index);
else
    [change, p_value] = three_yr_diff_wilcoxon(sst_years, SST, filtered_events);
    change = reshape(change, [size(change), 1]);
    p_value = reshape(p_value, [size(p_value), 1]);
end

mask = get_landmask(lon, lat);
mask = zeros(size(mask));
mask(mask == 1) = NaN;
im_change = change; % + mask;
im_p_value = p_value; % + mask;

lon_wrap = wrapTo180(lon);
rotate_by = length(lon) - find(lon_wrap < 0, 1) + 1;
lon_wrap = circshift(lon_wrap, rotate_by);

im_change = circshift(im_change, rotate_by, 1);
im_p_value = circshift(im_p_value, rotate_by, 1);

im_change = permute(im_change, [2, 1, 3]);
im_p_value = permute(im_p_value, [2, 1, 3]);

%% Plotting
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
