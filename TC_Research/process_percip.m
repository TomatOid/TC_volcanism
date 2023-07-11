clear

ncfile = 'prate_MCruns_ensemble_mean_LMRv2.1.nc';

prate_years = 0 : 2000;
lat = ncread(ncfile, 'lat');
lon = ncread(ncfile, 'lon');

prate_size = ncinfo(ncfile, 'prate').Size;
prate_sum = zeros([prate_size(1), prate_size(2), prate_size(4)]);

for i = 1 : prate_size(3)
    prate_sum = prate_sum + squeeze(ncread(ncfile, 'prate', [1, 1, i, 1], [Inf, Inf, 1, Inf]));
end

prate = prate_sum / prate_size(3);

clear ncfile prate_size prate_sum i;
save('prate_annual_raw.mat');
