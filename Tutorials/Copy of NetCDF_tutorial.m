% This is a opening netcdf file tutorial. There are two ways to open netcdf
% files in matlab. One way is using the netcdf toolbox and the other is
% just using matlab's built in functions. I'm going to show the functions
% for both methods here. You can decide which you prefer. I find the
% toolbox to be a bit glitchy sometimes but it cuts alot of lines of code.

%% Built in matlab functions

%use ncdisp to see whats in your netcdf file
ncdisp('b.e11.BLMTRC5CN.f19_g16.007.pop.h.SST.085001-089912.nc')
%this command helps you figure out the names, units and dimensions of variables
% SST variable has dimensions of TLAT, TLONG, z_t, time
% make sure you look at each of these -= their sizes and units, etc
% there is only vertical layer because this sea surface temperature, so you
% can use the squeeze function later to get rid of this dimension

% the 085001-089912 at the end of the file represents how many years are
% in the data set so this sst data from the cesm model from 01/850 to
% 12/899. The whole dataset stretches from 850-2005 CE. But you will have
% to load and concatenate all the files together.

% Opens the desired netcdf data file in matlab
ncid_cesm_850899 = netcdf.open('b.e11.BLMTRC5CN.f19_g16.007.pop.h.SST.085001-089912.nc');

% load variable ID number: lat, lon
latID_cesm_850899 = netcdf.inqVarID(ncid_cesm_850899, 'TLAT');
lonID_cesm_850899 = netcdf.inqVarID(ncid_cesm_850899, 'TLONG');
SSTID_cesm_850899 = netcdf.inqVarID(ncid_cesm_850899, 'SST');
timeID_cesm_850899 = netcdf.inqVarID(ncid_cesm_850899, 'time');

%finally get the variables 
lat_cesm_850899 = netcdf.getVar(ncid_cesm_850899, latID_cesm_850899);
lon_cesm_850899 = netcdf.getVar(ncid_cesm_850899, lonID_cesm_850899);
SST_cesm_850899 = netcdf.getVar(ncid_cesm_850899, SSTID_cesm_850899);
time_cesm_850899 = netcdf.getVar(ncid_cesm_850899, timeID_cesm_850899);

% repeat this process for every netcdf file
% concatenate the files in the time dimension (use cat function)


%% Transfer from curvilinear to rectilinear grid
% unfortunately ocean data is on a curvilinear grid so we need to
% interpolate it onto and rectilinear grid

% Make a meshgrid that you want to interpolate into: 0.5 degree grid
dx = 0.5; dy = 0.5;
[lon_grid,lat_grid] = meshgrid(0:dx:360,-80:dy:80);

%our new long and lat values are the first column of the data
lon_rect = [0:dx:360]';
lat_rect = [-80:dy:80]';

% Go ahead and reshape your coordinates and data into 1-d vectors:
X_curvi = reshape(lon_cesm_850899,[],1);
Y_curvi = reshape(lat_cesm_850899,[],1); 
 
%get rid of p level dimension on sst data
SST_cesm_850899 = squeeze(SST_cesm_850899);

%define variable outside loop
SST_rect = zeros(length(lat_rect),length(lon_rect),length(time_cesm_850899));
 %now loop through time dimension and regrid sst data to be 0.5 degree
for ti = 1:length(time_cesm_850899)
    %reshape SST data each year into 1-d vector
    data_curvi = double(reshape(SST_cesm_850899(:,:,ti),[],1));
    % and then you can use the griddata function:
    [~,~,SST_rect(:,:,ti)] = griddata(X_curvi,Y_curvi,data_curvi,lon_grid,lat_grid);
disp(ti) % track which number in the loop youre on
end %for ti

SST_rect(SST_rect>100000)=NaN;


%try plotting the data to see if looks right
%exceptionally large or small data point are probably missing data and you
%should replace with NaNs
f = figure; hold on;
contourf(lon_rect,lat_rect,squeeze(SST_rect(:,:,1)),20)
plotmap;
shading flat
colorbar
title('Jan 850 SST')
ylim([-60 60]); xlim([0 360])


% then save a .mat file so you never have to deal with netcdfs again

%% NCTOOLBOX METHOD - alternate shorter method for loading netcdf
% but takes more computation and may crash your computer (but worth a try)

% setup_nctoolbox
% this takes 1-5 minutes to load. But you only have to do it once when
% first open matlab. make sure the nctoolbox folder is on path.

direc= '/Users/lizziewallace/Library/CloudStorage/Box-Box/Postdoc Rice University/climate and tc analysis/NASH and storms/Data_files/CESM data/SST';
fhook = '*.nc';
fileList = dir(fullfile(direc,fhook));

%download the precipitation data
ncp = ncdataset(fileList(1).name)
lat_cesm = ncp.data('TLAT');
lon_cesm = ncp.data('TLONG');

%limit to 50S to 50N and 120 to 360
% Make a meshgrid that you want to interpolate into: 0.5 degree grid
dx = 1; dy = 1;
x1 = 120; x2= 360;
y1 = -50; y2=50;
[lon_grid,lat_grid] = meshgrid(x1:dx:x2,y1:dy:y2);

%our new long and lat values are the first column of the data
lon_rect = [x1:dx:x2]';
lat_rect = [y1:dy:y2]';

% Go ahead and reshape your coordinates and data into 1-d vectors:
X_curvi = reshape(lon_cesm,[],1);
Y_curvi = reshape(lat_cesm,[],1); 

%define variables for the loop
time_cesm = [];
SST_cesm = [];

for kk = 1:length(fileList)
    % extract variable IDS
    ncp = ncdataset(fileList(kk).name)
    ncid = netcdf.open(fileList(1).name);
    SST_ID = netcdf.inqVarID(ncid, 'SST');
    %open SST and time
    t = ncp.data('time');
    SST= squeeze(netcdf.getVar(ncid, SST_ID));
    %define variable outside loop
    SST_rect = zeros(length(lat_rect),length(lon_rect),length(t));
     %now loop through time dimension and regrid sst data to be 0.5 degree
    for ti = 1:length(t)
        %reshape SST data each year into 1-d vector
        data_curvi = double(reshape(SST(:,:,ti),[],1));
        % and then you can use the griddata function:
        [~,~,SST_rect(:,:,ti)] = griddata(X_curvi,Y_curvi,data_curvi,lon_grid,lat_grid);
    end %for ti
    %replace missing values with NaNs 
    SST_rect(SST_rect>100000)=NaN;
    %do some concatenating
    time_cesm = vertcat(time_cesm,t);
    SST_cesm = cat(3,SST_cesm, SST_rect);   
    % display what loop you are on
    disp(kk)
end %for kk
