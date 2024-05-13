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
[~, combined_filter_last] = max(fliplr(combined_filter), [], 2);
combined_filter_last = data_size(2) - combined_filter_last;
last_idx = sub2ind(data_size, 1 : data_size(1), combined_filter_last.');

% wind at last crossing (if applicable)
% vnet of 399 always 0 so non-applicable storms will show vnet_cross == 0

vnet_cross = vnet(last_idx);

start_year = min(yearstore);
end_year = max(yearstore);

% count tropical depressions (between 5 and 33 knots)
n_dep = histc(yearstore((vnet_cross > 5) & (vnet_cross <= 33)), start_year : end_year);
% count tropical storms (between 33 and 63 knots)
n_ts = histc(yearstore((vnet_cross > 33) & (vnet_cross <= 63)), start_year : end_year);
% count tropical cyclones (above 63 knots)
n_tc = histc(yearstore((vnet_cross > 63)), start_year : end_year);
