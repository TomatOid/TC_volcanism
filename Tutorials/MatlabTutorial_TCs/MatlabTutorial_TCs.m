%At the top of every script you write, include a summary of what the script
%does.

% Please place your name and the date the script was last updated at the
% top
% Lizzie Wallace
% 01/19/2022

% What you need
% 2 data files:
% 1.  attracks.mat
% 2.  m_coasts.mat
% and one function:
% 1.  plotmap.m a function to plot coastlines


clear all; close all

%% Load in and plot a tropical cyclone (TC) track
%  Load in the TC data
load 'attracks.mat';

% These variables are atlantic tropical cyclone tracks (1851-2020). 
% Useful variables for you are:
% longm - longitude of storm in 6 hourly points; rows are individual tracks
% and columns are time point along each track
% latm - latitude of storm in 6 hourly points; rows are individual tracks
% and columns are time point along each track
% vsm -wind speed of storm in 6 hourly points (m/s); rows are individual tracks
% and columns are time point along each track
% yeari - year the storm occurred


% Plot the first track
figure(1);clf
% Now plot the buoy data
plot(longm(1,:),latm(1,:),'o-')

% You will see a line that goes to [0,0]. since each track 
% is a different length, zeros are placed at the end of each matrix to 
% denote the end of the track. before plotting, convert zeros to NaNs
latm(latm==0)=NaN;
longm(longm==0)=NaN;
vsm(vsm==0)=NaN;


% Plot the first track again
figure(1);clf
% Now plot the track data
plot(longm(1,:),latm(1,:),'o-')

%% PLOT A STORM TRACK

% use plotmap, xlim and ylim to orient yourself
% overlay the location of the genesis latitude and longitude (in a different
% color), so you know which way the track travelled (remember to hold on)
figure(1);clf
plotmap; hold on;
plot(longm(1,:),latm(1,:),'-')
plot(longm(1,1),latm(1,1), 'g*-');
xlabel ('Latitude')
ylabel('Longitude')
xlim([250 310])
ylim([10 40])
%% PLOTTING MORE THAN ONE STORM TRACK
%now lets plot all the storms that happened in 1851
indx_1851 = find(yeari==1851);

figure(2);clf
plotmap; hold on;
%to plot more than one track we need a for loop
for ii=1:length(indx_1851)
plot(longm(ii,:),latm(ii,:),'-or')
end %for ii
xlabel ('Latitude')
ylabel('Longitude')
xlim([250 310])
ylim([10 40])

%you can see that three of these tracks only have one point
indx1940 = find(yeari>1940);

%now can you plot all the storms that happened after 1940?
figure(3);
clf

%now can you plot only the genesis points of storms that happened after 1940?
figure(4);
clf


%% PLOT STORM FREQUENCY

% to plot storm frequency, we need to know how many storm occurred each
% year
yr_obs = [min(yeari):max(yeari)];
nTC = zeros(length(yr_obs),1);
% use a for loop to count how many tropical cyclones occur each year
for ii=1:length(yr_obs)
    nTC(ii) = length(find(yeari == yr_obs(ii)));
end %for ii

figure(5);clf
plot(yr_obs,nTC)


% we often categorize storms based on their intensity using the saffir
% simpson scale. https://en.wikipedia.org/wiki/Saffir%E2%80%93Simpson_scale

%find the max wind speed (m/s) of each storm in our dataset
max_vsm = max(vsm,[],2);

% can we plot how many hurricanes occured each year (cat 1 and above)
nhurr = zeros(length(yr_obs),1);
% use a for loop to count how many tropical cyclones occur each year
for ii=1:length(yr_obs)
    indx_hurr = find(yeari == yr_obs(ii));
    nhurr(ii) = length(find(max_vsm(indx_hurr)>=33))
end %for ii

figure(6);clf
plot(yr_obs,nhurr)

% can you plot how many intense hurricanes occured each year (cat 3 and above)



figure(7);clf

%% HISTOGRAM OF HURRICANE INTENSITY

%we may also want to plot the distribution of storm intensities
% we can use a histogram to do this
f = figure;
histogram(max_vsm)

% ksdensity is another matlab function that allows you to plot
% distributions

