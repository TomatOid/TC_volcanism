load 'Atlantic_AL_cera20c_reanal.mat' 'freqyear' 'latstore' 'longstore' 'vstore'

% we want the position of the storm to freeze at the end of its track to make velocity calculations easier
pos_size = size(latstore);
% is this the end of the row?
is_term = (latstore == 0) & (longstore == 0);
% find the last valid position index of each storm
[~, last_idx] = max(is_term, [], 2);
% convert into absolute linear indices
last_lin = sub2ind(pos_size, 1 : pos_size(1), squeeze(last_idx.') - 1);
% create arrays which are filled with the last valid position
lat_rep = repmat(latstore(last_lin).', 1, pos_size(2));
lon_rep = repmat(longstore(last_lin).', 1, pos_size(2));

latstore_safe = latstore;
latstore_safe(is_term) = lat_rep(is_term);
longstore_safe = longstore;
longstore_safe(is_term) = lon_rep(is_term);

% units are knots
% assumes 2 hour measurement interval
v_track = haversine_delta(latstore_safe(:, 1 : end - 1), longstore_safe(:, 1 : end - 1), latstore_safe(:, 2 : end), longstore_safe(:, 2 : end)) / 2;
v_net = vstore(:, 1 : end - 1) + v_track;
vnetmax = max(v_net, [], 2);
duration = sum(~is_term, 2) * 2;
duration = mean(reshape(duration, 100, []), 1);

save 'cera20_standardized.mat' 'freqyear' 'latstore' 'longstore' 'vnetmax' 'duration'
