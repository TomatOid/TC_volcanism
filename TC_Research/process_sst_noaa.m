clear

ncfile = 'sst.mnmean.nc';

sst_years = 1854 : 2022;
lat = ncread(ncfile, 'lat');
lon = ncread(ncfile, 'lon');

SST_size = ncinfo(ncfile, 'sst').Size;

SST_monthly = ncread(ncfile, 'sst');
SST_monthly = SST_monthly(:, :, 1 : floor(SST_size(3) / 12) * 12);
SST_monthly(SST_monthly <= -9.95e+36) = NaN;
SST = zeros(SST_size(1), SST_size(2), length(sst_years));
for i = 1 : length(sst_years)
    SST(:, :, i) = mean(SST_monthly(:, :, (i - 1) * 12 + 1 : i * 12), 3);
end
%mean(reshape(SST_monthly, SST_size(1), SST_size(2), [], 12), 4);

clear ncfile SST_size SST_monthly i;
save('sst_annual_noaa.mat');
