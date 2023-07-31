load 'sst_annual_raw';
smoothed = movmean(SST, 3, 3);
before = smoothed(:, :, 1 : end - 3);
after  = smoothed(:, :, 4 : end);

delta = after - before;
SST = delta;

lat_desired = 0;
lon_desired = -110;
[~, latidx] = min(abs(lat - lat_desired), [], 'linear');
[~, lonidx] = min(abs(lon - mod(lon_desired + 360, 360)), [], 'linear');

corr_im = zeros(size(SST(:, :, 1)));
shape = size(corr_im);
p_im = zeros(shape);

for x = 1 : shape(1)
    for y = 1 : shape(2)
        [cc, p] = corrcoef(SST(lonidx, latidx, :), SST(x, y, :));
        corr_im(x, y) = cc(1, 2);
        p_im(x, y) = p(1, 2);
    end
end

clf;
s = pcolor(lon, lat, corr_im.');
hold on;
set(s, 'edgecolor', 'none');
s.FaceColor = 'interp';
[LON, LAT] = meshgrid(lon, lat);
stipple(LON, LAT, p_im.' < 0.0005)
caxis([-1, 1]);
colorbar();
ax = gca;
ax.Color = '#f2eee9';
%borders('countries', 'color', 'k');
