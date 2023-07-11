load('LMR20_Atl_storms_lite.mat', 'latstore', 'longstore');
load('sst_annual.mat', 'lon', 'lat');
track_density = zeros([length(lon), length(lat), length(latstore) / 100]);


delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore) / 100
    lat_slice = latstore(100 * (i - 1) + 1 : 100 * i, :);
    lon_slice = longstore(100 * (i - 1) + 1 : 100 * i, :);
    indices = find((lat_slice ~= 0) | (lon_slice ~= 0));
    
    track_density(:, :, i) = histcounts2(lon_slice(indices), lat_slice(indices), lon_edges, lat_edges);
end


save('track_density_lmr20.mat', 'lon', 'lat', 'track_density');
