load sst_annual_20.mat
SST = t_surf_seasonal;
sst_years = min(Years) : max(Years); 

mask = get_landmask(lon, lat);
mask(mask == 1) = NaN;
SST = SST + repmat(mask, 1, 1, length(SST));

lon_wrap = wrapTo180(lon);
lon_wrap = circshift(lon_wrap, length(lon) / 2);
SST = circshift(SST, length(lon) / 2, 1);

% Year ranges = 850 - 1400, 1450 - 1850

range_1 = SST(:, :, find(sst_years == 850, 1) : find(sst_years == 1400, 1));
range_2 = SST(:, :, find(sst_years == 1450, 1) : find(sst_years == 1850, 1));


SST_anom = (SST - mean(SST, 3, 'omitnan')) ./ std(SST, 1, 3, 'omitnan');
range_1_anom = SST_anom(:, :, find(sst_years == 850, 1) : find(sst_years == 1400, 1));
range_2_anom = SST_anom(:, :, find(sst_years == 1450, 1) : find(sst_years == 1850, 1));

clf;

%tiledlayout(1, 3);
nexttile;
colormap(redblue);
s = pcolor(lon_wrap, lat, mean(range_1_anom, 3).');
xlim([-150, 0]);
ylim([-20, 40]);
%caxis([280, 300]);
s.FaceColor = 'interp';
set(s, 'edgecolor', 'none');
title('850 - 1400 SST anom');
hold on;
borders('countries', 'color', 'k');
hold on;
colorbar();
nexttile;
s = pcolor(lon_wrap, lat, mean(range_2_anom, 3).');
xlim([-150, 0]);
ylim([-20, 40]);
%caxis([280, 300]);
s.FaceColor = 'interp';
set(s, 'edgecolor', 'none');
title('1450 - 1850 SST anom');
hold on;
borders('countries', 'color', 'k');
colorbar();
%%
nexttile;
s = pcolor(lon_wrap, lat, mean(range_2, 3).' - mean(range_1, 3).');
xlim([-150, 0]);
ylim([-20, 40]);
s.FaceColor = 'interp';
set(s, 'edgecolor', 'none');
title('diff');
hold on;
borders('countries', 'color', 'k');
colorbar();
