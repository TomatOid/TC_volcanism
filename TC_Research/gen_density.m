load('../Storm Sets/LMR21_Atl_storms.mat', 'latstore_LMR21_all', 'longstore_LMR21_all');
load('sst_annual.mat', 'lon', 'lat');

genesis_density = zeros([length(lon), length(lat), length(latstore_LMR21_all) / 100]);


delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore_LMR21_all) / 100
    lat_slice = latstore_LMR21_all(100 * (i - 1) + 1 : 100 * i, 1);
    lon_slice = longstore_LMR21_all(100 * (i - 1) + 1 : 100 * i, 1);
    genesis_density(:, :, i) = histcounts2(lon_slice, lat_slice, lon_edges, lat_edges);
end

save('genesis_density.mat', 'lon', 'lat', 'genesis_density');
