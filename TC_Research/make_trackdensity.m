%load('../Storm Sets/LMR21_Atl_storms.mat');
%track_density = zeros([24, 54, length(yearstore_LMR21_all)]);
%for i = 1 : length(freqyear_LMR21_all)
%    latstore = latstore_LMR21_all((i - 1) * 100 + 1 : i * 100);
%    longstore = longstore_LMR21_all((i - 1) * 100 + 1 : i * 100);
%    yearstore = yearstore_LMR21_all((i - 1) * 100 + 1 : i * 100);
%    vnet = vnet_LMR21_all((i - 1) * 100 + 1 : i * 100);
%    vstore = vstore_LMR21_all((i - 1) * 100 + 1 : i * 100);
%    vmax = vmax_LMR21_all((i - 1) * 100 + 1 : i * 100);
%
%    [lon, lat, track_density(:, :, i)] = trackdensity_lizzie('AL', latstore, longstore, freqyear_LMR21_all(i), yearstore, vnet, vstore, vmax);
%end

load('../Storm Sets/LMR21_Atl_storms.mat', 'latstore_LMR21_all', 'longstore_LMR21_all');
load('sst_annual.mat', 'lon', 'lat');

track_density = zeros([length(lon), length(lat), length(latstore_LMR21_all) / 100]);


delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore_LMR21_all) / 100
    lat_slice = latstore_LMR21_all(100 * (i - 1) + 1 : 100 * i, :);
    lon_slice = longstore_LMR21_all(100 * (i - 1) + 1 : 100 * i, :);
    indices = find((lat_slice ~= 0) | (lon_slice ~= 0));
    
    track_density(:, :, i) = histcounts2(lon_slice(indices), lat_slice(indices), lon_edges, lat_edges);
end


save('track_density.mat', 'lon', 'lat', 'track_density');
