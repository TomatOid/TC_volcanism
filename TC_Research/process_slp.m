clear

ncfile = 'prmsl_MCruns_ensemble_mean_LMRv2.1.nc';

slp_years = 0 : 2000;
lat = ncread(ncfile, 'lat');
lon = ncread(ncfile, 'lon');

SLP_size = ncinfo(ncfile, 'prmsl').Size;
SLP_sum = zeros([SLP_size(1), SLP_size(2), SLP_size(4)]);

for i = 1 : SLP_size(3)
    SLP_sum = SLP_sum + squeeze(ncread(ncfile, 'prmsl', [1, 1, i, 1], [Inf, Inf, 1, Inf]));
end

SLP = SLP_sum / SLP_size(3);

clear ncfile SLP_size SLP_sum i;
save('slp_annual_raw.mat');
