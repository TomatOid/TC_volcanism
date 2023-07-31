% sst_annual_raw is already in anomoly format
load 'sst_annual_raw.mat'

% Niño 3.4 reigion is defined as -5 to 5 lattitude and -170 to -120 longitude

lat_window = find_nearest([-5, 5], lat);
lon_window = find_nearest(mod([-170, -120] + 360, 360), lon);
nino_mean = squeeze(mean(SST(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan'));
