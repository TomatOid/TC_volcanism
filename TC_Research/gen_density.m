load('LMR21_combined.mat', 'latstore', 'lonstore');
load('sst_annual_raw.mat', 'lon', 'lat');


annual_storms = 500;
genesis_density = zeros([length(lon), length(lat), length(latstore) / annual_storms]);


delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore) / annual_storms
    lat_slice = latstore(annual_storms * (i - 1) + 1 : annual_storms * i, 1);
    lon_slice = lonstore(annual_storms * (i - 1) + 1 : annual_storms * i, 1);
    genesis_density(:, :, i) = histcounts2(lon_slice, lat_slice, lon_edges, lat_edges);
end

save('genesis_density_LMR21_combined.mat', 'lon', 'lat', 'genesis_density');
