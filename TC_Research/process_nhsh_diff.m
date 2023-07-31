clear

ncfile_nh = 'nhmt_MCruns_ensemble_full_LMRv2.1.nc';
ncfile_sh = 'shmt_MCruns_ensemble_full_LMRv2.1.nc';

nhsh_years = 0 : 2000;

nh_ensamble = ncread(ncfile_nh, 'nhmt');
nh_ensamble = squeeze(mean(nh_ensamble, 1));

sh_ensamble = ncread(ncfile_sh, 'shmt');
sh_ensamble = squeeze(mean(sh_ensamble, 1));

nhsh_ensamble = nh_ensamble - sh_ensamble;
nhsh_mean = mean(nhsh_ensamble, 1);
nhsh_std = std(nhsh_ensamble);
