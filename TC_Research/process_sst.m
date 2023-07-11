clear

ncfile = 'sst_MCruns_ensemble_mean_LMRv2.1.nc';

sst_years = 0 : 2000;
lat = ncread(ncfile, 'lat');
lon = ncread(ncfile, 'lon');

SST_size = ncinfo(ncfile, 'sst').Size;
SST_sum = zeros([SST_size(1), SST_size(2), SST_size(4)]);

for i = 1 : SST_size(3)
    SST_sum = SST_sum + squeeze(ncread(ncfile, 'sst', [1, 1, i, 1], [Inf, Inf, 1, Inf]));
end

SST = SST_sum / SST_size(3);

clear ncfile SST_size SST_sum i;
save('sst_annual_raw.mat');
