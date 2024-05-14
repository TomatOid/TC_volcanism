% Connor McCarty
% Started May 13, 2024

% Simulate the Chenoweth & Divine 2008 sampling bias
% Outputs n_dep, n_ts, and n_tc

load 'LMR21_combined.mat'

%%

data_size = size(lonstore)

sample_meridian = 298.5; % longitude
upper_lim       = 18;    % latitude
lower_lim       = 12;    % latitude

end_filter = (lonstore == 0) & (latstore == 0);

latstore(end_filter) = NaN;
lonstore(end_filter) = NaN;

lon_filter = (diff(lonstore > sample_meridian, 1, 2) ~= 0) & ~isnan(diff(lonstore, 1, 2));

lat_filter = (latstore > 12) & (latstore < 18);
lat_filter = lat_filter(:, 1 : end - 1);

combined_filter = lon_filter & lat_filter;

% net speed when the storm crosses the boundary
vnet_cross = max(vnet(:, 1 : end - 1) .* combined_filter, [], 2);

start_year = min(yearstore);
end_year = max(yearstore);

multiplier = freqyear / double(data_size(1) / (end_year - start_year + 1));

% count tropical depressions (between 5 and 33 knots)
n_dep = histc(yearstore((vnet_cross > 5) & (vnet_cross <= 33)), start_year : end_year) .* multiplier;
% count tropical storms (between 33 and 63 knots)
n_ts = histc(yearstore((vnet_cross > 33) & (vnet_cross <= 63)), start_year : end_year) .* multiplier;
% count tropical cyclones (above 63 knots)
n_tc = histc(yearstore((vnet_cross > 63)), start_year : end_year) .* multiplier;

save 'chenoweth_combined.mat' n_dep n_ts n_tc
