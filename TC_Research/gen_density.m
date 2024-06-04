load('LMR21_combined.mat', 'latstore', 'lonstore', 'vnet', 'vnetmax', 'freqyear');
load('sst_annual_raw.mat', 'lon', 'lat');

% record points only once wind speeds exceeds startv
startv = 35;
peakv = 40;
pifac = acos(-1)./180;
annual_storms = 500;
genesis_density = zeros([length(lon), length(lat), length(latstore) / annual_storms]);

delta_lat = lat(3) - lat(2);
delta_lon = lon(3) - lon(2);
lat_edges = [lat - delta_lat / 2; lat(end) + delta_lat / 2];
lon_edges = [lon - delta_lon / 2; lon(end) + delta_lon / 2];
for i = 1 : length(latstore) / annual_storms
    i
    vnet_slice = vnet(annual_storms * (i - 1) + 1 : annual_storms * i, :);
    vnetmax_slice = vnetmax(annual_storms * (i - 1) + 1 : annual_storms * i);
    [found_match, vidx] = max(vnet_slice > startv, [], 2, 'linear');
    peak_mask = (vnetmax_slice < peakv) | ~found_match | (vnet_slice(vidx) == 0);
    lat_slice = latstore(annual_storms * (i - 1) + 1 : annual_storms * i, :);
    lon_slice = lonstore(annual_storms * (i - 1) + 1 : annual_storms * i, :);

    % knock the storms that we don't want to include out of bounds of histcounts
    lat_slice(peak_mask) = NaN;
    lon_slice(peak_mask) = NaN;
    genesis_density(:, :, i) = histcounts2(lon_slice, lat_slice, lon_edges, lat_edges); 
    genesis_density(:, :, i) = genesis_density(:, :, i) .* (freqyear(i) ./ repmat(cos(pifac * lat).', ...
        [length(lon), 1]) / (annual_storms * delta_lat * delta_lon));
end


save('genesis_density_LMR21_combined.mat', 'lon', 'lat', 'genesis_density');
