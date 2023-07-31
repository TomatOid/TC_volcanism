load('Atlantic_AL_cera20c_reanal.mat', 'latstore', 'longstore');
load('sst_annual.mat', 'lon', 'lat');

genesis_density = zeros([length(lon), length(lat), length(latstore) / 100]);


delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore) / 100
    lat_slice = latstore(100 * (i - 1) + 1 : 100 * i, 1);
    lon_slice = longstore(100 * (i - 1) + 1 : 100 * i, 1);
    genesis_density(:, :, i) = histcounts2(lon_slice, lat_slice, lon_edges, lat_edges);
end

save('genesis_density_cera.mat', 'lon', 'lat', 'genesis_density');
