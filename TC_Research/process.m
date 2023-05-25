% Connor McCarty
% Created: May 24, 2023
% Process NetCDFs into useful datasets

% The data must be in Matlab's path

clear;
files(1) = netcdf.open('eVolv2k_v3_EVA_AOD_-500_1900_1.nc', 'NC_NOWRITE'); % temporal data
files(2) = netcdf.open('eVolv2k_v3_ds_1.nc', 'NC_NOWRITE'); % directory data

for ncid = files
    % Get the number of variables in the NetCDF file
    [numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

    % Loop over each variable in the NetCDF file
    for varid = 0 : numvars - 1
        % Get the variable's name
        [varname, vartype, vardimids, varnatts] = netcdf.inqVar(ncid, varid);
        
        % Get the variable's data
        data = netcdf.getVar(ncid, varid);
        
        % Save the variable to the workspace using its name from the NetCDF file
        assignin('base', varname, data);
    end

    % Close the NetCDF file
    netcdf.close(ncid);
end

clear numdims ncid numglobalatts numvars prompt select unlimdimID vardimids varid varname vartype data varnatts files NetCDF files

% now crop all data to start at 850 CE

start_idx_temporal = find(time == 850);
time = time(start_idx_temporal : end);
aod550 = mean(aod550, 1);
aod550 = aod550(start_idx_temporal : end);
reff = mean(reff, 1);
reff = reff(start_idx_temporal : end);
clear start_idx_temporal yearCE

% convert all time information into fractional years and crop based on that
event_time = year + (datenum(datetime(year, month, day)) - datenum(datetime(year, 1, 1))) ./ (365 + ((mod(year, 4) == 0) & (mod(year, 128) ~= 0)));
clear day month year
start_idx_dir = find(event_time > 850, 1, 'last');
event_time = flip(event_time(1 : start_idx_dir));
hemi       = flip(hemi(1 : start_idx_dir));
lat        = flip(lat(1 : start_idx_dir));
sigma_vssi = flip(sigma_vssi(1 : start_idx_dir));
vssi       = flip(vssi(1 : start_idx_dir));

clear start_idx_dir
save('volcano_data.mat');
