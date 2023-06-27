%% === set your control variables ===
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 5;
% additional time before the window where no eruptions are allowed
before_window_filter = 1;
after = 10;

threshold = 0.07;
control_threshold = 0.007;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);

load 'sst_annual.mat'

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
    image_sea(:, :, i) = image_sea(:, :, i) + mask;
    image_pscore(:, :, i) = image_pscore(:, :, i) + mask;
    %image_sea(:, :, i) = (image_sea(:, :, i) - mean(image_sea(:, :, i), 'all', 'omitnan')) / std(image_sea(:, :, i), 1, 'all', 'omitnan');
end
image_sea = (image_sea - repmat(mean(image_sea, 3), 1, 1, before + after + 1)) ./ repmat(std(image_sea, 1, 3), 1, 1, before + after + 1);

image_sea = permute(image_sea, [2, 1, 3]);
image_pscore = permute(image_pscore, [2, 1, 3]);
%image_sea(isnan(image_sea)) = 0;
%axesm;
image_sea = image_sea(25 : end - 17, :, :);
image_pscore = image_pscore(25 : end - 17, :, :);
image_lat = lat(25 : end - 17);
%frames(before + after + 1) = struct('cdata', [], 'colormap', []);%
hi_color = max(image_sea, [], 'all');
lo_color = min(image_sea, [], 'all');
[stipple_lon, stipple_lat] = meshgrid(lon_wrap, image_lat);
filename = ['sst_animation_aod_' num2str(threshold) '.gif']; 

for loop_num = 1 : 1
    clf;
    for i = 1 : before + after + 1
        is_signif = (image_pscore(:, :, i) > 0.95 | image_pscore(:, :, i) < 0.05);
        s = pcolor(lon_wrap, image_lat, image_sea(:, :, i));
        hold on;
        %stipple(stipple_lon, stipple_lat, is_signif);
        colorbar();
        caxis([lo_color, hi_color]);
        set(s, 'edgecolor', 'none');
        title(['SST, t = ', num2str(i - before - 1), ', AOD threshold = ', num2str(threshold)]);
        drawnow

        frame = getframe(gcf);
        img = frame2im(frame);
        [img, cmap] = rgb2ind(img, 256);

        if (i == 1)
            imwrite(img, cmap, filename, 'gif', 'LoopCount', Inf, 'DelayTime', 1);
        else
            imwrite(img, cmap, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1);
        end
        pause(0.5);
    end
end
%borders();
%movie(frames, 10, 1);
