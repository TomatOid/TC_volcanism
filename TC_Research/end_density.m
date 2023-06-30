load('../Storm Sets/LMR21_Atl_storms.mat', 'latstore_LMR21_all', 'longstore_LMR21_all');
load('sst_annual.mat', 'lon', 'lat');

term_density = zeros([length(lon), length(lat), length(latstore_LMR21_all) / 100]);
[~, last_idx] = max(latstore_LMR21_all == 0, [], 2);
last_lin = sub2ind(size(latstore_LMR21_all), 1 : length(latstore_LMR21_all), squeeze(last_idx.') - 1);
latstore_end = latstore_LMR21_all(last_lin);
longstore_end = longstore_LMR21_all(last_lin);

delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore_LMR21_all) / 100
    lat_slice = latstore_end(100 * (i - 1) + 1 : 100 * i);
    lon_slice = longstore_end(100 * (i - 1) + 1 : 100 * i);
    term_density(:, :, i) = histcounts2(lon_slice, lat_slice, lon_edges, lat_edges);
end

save('end_density.mat', 'lon', 'lat', 'term_density');
