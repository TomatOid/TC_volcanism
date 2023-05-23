%% Import all contents of a NetCDF
%This script opens the specified NetCDF file, finds the names of all variables in the file,
%and then reads in the data for each variable and assigns it to a variable in the MATLAB
%workspace with the same name as the variable in the NetCDF file.
%Note that this assumes that the size of the data in the NetCDF can fit
%within the workspace. This may be inappropriate for large NetCDFs. Use
%with care. -R Sullivan May 2023

%read in names of netCDFs is the directory.
NetCDF = dir('*.nc');  %Script must be directed towards folder containing NetCDFs

%Display available NetCDFs
files = {NetCDF.name}';
disp(files);

prompt = 'Select a NetCDF for analysis (number) '; %Select NetCDF from directory numerically
select = input(prompt);
ncfile = getfield(NetCDF,{select},'name');

% Open the NetCDF file
ncid = netcdf.open(ncfile, 'NC_NOWRITE'); 

% Get the number of variables in the NetCDF file
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

% Loop over each variable in the NetCDF file
for varid=0:numvars-1
    % Get the variable's name
    [varname, vartype, vardimids, varnatts] = netcdf.inqVar(ncid, varid);
    
    % Get the variable's data
    data = netcdf.getVar(ncid, varid);
    
    % Save the variable to the workspace using its name from the NetCDF file
    assignin('base', varname, data);
end

% Close the NetCDF file
netcdf.close(ncid);

clear numdims ncid numglobalatts numvars prompt select unlimdimID vardimids varid varname vartype data varnatts files NetCDF