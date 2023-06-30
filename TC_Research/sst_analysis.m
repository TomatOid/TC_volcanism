%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 5;
% additional time before the window where no eruptions are allowed
before_window_filter = 1;
after = 10;

threshold = 0.13;
control_threshold = 0.007;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

load 'sst_annual.mat'
load 'track_density.mat'
SST = track_density;

%lon = lon - 180;

%filtered_events = [1258, 1284, 1809, 1815];

[sea, pscore] = map_sea(sst_years, SST, filtered_events, control_index, before, after);

%% Drawing Code

%land = readgeotable('landareas.shp');
lon_wrap = wrapTo180(lon);
lon_wrap = circshift(lon_wrap, length(lon) / 2);
image_sea = circshift(sea, length(lon) / 2, 1);
image_pscore = circshift(pscore, length(lon) / 2, 1);
[LAT, LON] = meshgrid(lat, lon_wrap);

% read file
fname = 'WorldLandBitMap.dat'; % little endian case
fid = fopen(fname,'r');
bmap = fread(fid,[36000/32 18000], '*uint32'); % for little endian machine
fclose(fid);

NSX1 = 36000 / 32;
NSX = NSX1 * 32;
NSY = 18000;

 % vectorized
lon180 = mod(LON + 360, 360);
lon180(lon180 > 0) = lon180(lon180 > 0) - 360;
ix = round((lon180 + 180)*100);
ix(ix < 0) = ix(ix < 0) + NSX;
ix(ix >= NSX) = ix(ix >= NSX) - NSX;
ix1 = floor(ix / 32);
ix2 = ix - ix1 * 32;
iy = round((LAT + 90)*100);
iy(iy < 0) = 0;
iy(iy >= NSY) = NSY - 1;

land_bit = ~bitget(bmap(ix1 + iy * NSX1 + 1), ix2, 'uint32');

mask = cast(reshape(land_bit, [length(lon), length(lat)]), 'single');
mask(mask == 1) = NaN;
for i = 1 : before + after + 1
    %image_sea(:, :, i) = image_sea(:, :, i) + mask;
    %image_pscore(:, :, i) = image_pscore(:, :, i) + mask;
    %image_sea(:, :, i) = (image_sea(:, :, i) - mean(image_sea(:, :, i), 'all', 'omitnan')) / std(image_sea(:, :, i), 1, 'all', 'omitnan');
end
%image_sea = (image_sea - repmat(mean(image_sea, 3), 1, 1, before + after + 1)) ./ repmat(std(image_sea, 1, 3), 1, 1, before + after + 1);

image_sea(image_sea == 0) = NaN;
image_sea = permute(image_sea, [2, 1, 3]);
image_pscore = permute(image_pscore, [2, 1, 3]);
%image_sea(isnan(image_sea)) = 0;
%axesm;

% [lat_min, lat_max, lon_min, lon_max]
map_bounds = [0, 60, -120, 0];
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
clf;
%tiledlayout(4, 4);

for loop_num = 1 : 1
    for i = 4 : 7
        nexttile
        is_signif = ((image_pscore(:, :, i) > 0.95 | image_pscore(:, :, i) < 0.05)) & ~isnan(image_sea(:, :, i));
        s = pcolor(image_lon, image_lat, image_sea(:, :, i));
        set(s, 'edgecolor', 'none');
        hold on;
        [points_lat, points_lon] = find(~isnan(image_sea(:, :, i)));
        bound_idx = boundary(points_lon, points_lat);
        plot(image_lon(points_lon(bound_idx)), image_lat(points_lat(bound_idx)), 'linewidth', 2, 'color', 'k');
        ylim([map_bounds(1) - 2, map_bounds(2) + 2]);
        xlim([map_bounds(3) - 2, map_bounds(4) + 2]);
        hold on;

        borders('countries', 'color', 'k');
        %stipple(stipple_lon, stipple_lat, is_signif, 'marker', 'x');
        colormap(redblue);
        colorbar();
        caxis([lo_color, hi_color]);
        title(['SST, t = ', num2str(i - before - 1), ', AOD threshold = ', num2str(threshold)]);
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
