%At the top of every script you write, include a summary of what the script
%does.

% Please place your name and the date the script was last updated at the
% top
% Connor McCarty
% 05/23/2023

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


% Now plot the buoy data

% You will see a line that goes to [0,0]. since each track 
% is a different length, zeros are placed at the end of each matrix to 
% denote the end of the track. before plotting, convert zeros to NaNs

% to avoid potential bugs where the latitude or longitude happen to be zero
% by chance instead of indicating termination, I will overcomplicate it

% first create a boolean mask

storm_count = size(longm, 1);
pts_max = size(longm, 2);
mask = ones(storm_count, 1);

i = pts_max;
while (i > 0)
    long_col = longm(:, i);
    lat_col = latm(:, i);
    mask = mask & (long_col == 0) & (lat_col == 0);
    long_col(mask) = NaN;
    lat_col(mask) = NaN;
    
    longm(:, i) = long_col;
    latm(:, i) = lat_col;
    i = i - 1;
end


% Plot the first track again

figure(1);
clf

plot(latm(1, :), longm(1, :), 'o-');


%% PLOT A STORM TRACK

% use plotmap, xlim and ylim to orient yourself
% overlay the location of the genesis latitude and longitude (in a different
% color), so you know which way the track travelled (remember to hold on)

%% PLOTTING MORE THAN ONE STORM TRACK
%now lets plot all the storms that happened in 1851
%you can see that three of these tracks only have one point


plotStormsByYears(1851, 1851, longm, latm, yeari, 2);

%now can you plot all the storms that happened after 1940?

plotStormsByYears(1940, 9999, longm, latm, yeari, 3);

%now can you plot only the genesis points of storms that happened after 1940?

plotStormsByYears(1940, 9999, longm(:, 1), latm(:, 1), yeari, 4);

%% PLOT STORM FREQUENCY

% to plot storm frequency, we need to know how many storm occurred each
% year
% use a for loop to count how many tropical cyclones occur each year


% we often categorize storms based on their intensity using the saffir
% simpson scale. https://en.wikipedia.org/wiki/Saffir%E2%80%93Simpson_scale

%find the max wind speed (m/s) of each storm in our dataset

max_wind = max(vsm, [], 2);
first_year = yeari(1);
last_year  = yeari(length(yeari));
storms_per_year = zeros(last_year - first_year + 1, 1);

for i = 1 : storm_count
    year = yeari(i) - first_year + 1;
    storms_per_year(year) = storms_per_year(year) + (max_wind(i) >= 33);
end

% can we plot how many hurricanes occured each year (cat 1 and above)

figure(5);
clf
plot(first_year : last_year, smoothdata(storms_per_year, 'movmean', 6));

figure(6);
clf
histogram(storms_per_year);

% use a for loop to count how many tropical cyclones occur each year








% can you plot how many intense hurricanes occured each year (cat 3 and above)





%% HISTOGRAM OF HURRICANE INTENSITY

%we may also want to plot the distribution of storm intensities
% we can use a histogram to do this



% ksdensity is another matlab function that allows you to plot
% distributions

function plotStormsByYears(lower_year, upper_year, longm, latm, yeari, fig_num)
    hold on;

    figure(fig_num);
    clf

    plotmap;

    index_range = find(yeari >= lower_year, 1) : find(yeari <= upper_year, 1, 'last');

    for i = index_range
        plot(longm(i, :), latm(i, :), 'o-g');
    end

    plot(longm(index_range, 1), latm(index_range, 1), 'x');
end
