%% MatlabTutorial ENSO 
% (El Nino-Southern Oscillation)
% What you will need (from STELLAR):
% Two data files:
% 1.  BOM_SOI.txt
% 2.  HadISST.mat
% and three m files:
% 1.  cast_example.m  (which contains a sample, based on the Matlab-Intro, of how I'd like the handed in work to be presented)
% 2.  MatlabTutorial_ENSO.m (instructions for this tutorial)
% 3.  findnearestval.m a function to find the nearest value in a vector of numbers
% 
% Work through MatlabTutorial_ENSO.m filling in the blanks '...' 
% You can run parts of the file by selecting it and then hitting CTRL-F7.

clear; close all 

%% Load in the SOI data. 
% (NB. Full dataset is from 1876 to present is available at http://www.bom.gov.au/climate/current/soi2.shtml)
load 'BOM_SOI.txt'

% The text file contains two colums. Column 1 is the date, column 2 is the Southern Ocillation Index (SOI)
% This creates a variable BOM_SOI (i.e. the same name as the file). Split this up into 2 seperate variables: soi and soi_time
soi=BOM_SOI(:,2);
soi_time=BOM_SOI(:,1);

% You no longer need the BOM_SOI variable, so you can remove it using the clear command
clear BOM*

%~~~~~~~~ Plot a timeseries of the SOI ~~~~~~~~~~
% Create a new blank figure, 
figure(1); clf
% Now use the 'plot' function to produce a graph of SOI versus date. Also try using the 'smooth' function to plot a running average. 
% Remember to use 'hold on' if you want to plot multiple lines on top of each other. 
% Use the 'help' command to learn how to use these functions and the various options they offer.
plot(soi_time,soi);hold on
plot(soi_time,smoothdata(soi,'movmean',6),'k','linewidth',2)


% You can also try using the 'bar' function as an alternative to 'plot'
figure(2);clf
bar(soi_time,smooth(soi,6))

%~~~~~~~~ Plotting a histogram ~~~~~~~~~~
% Create a new figure
figure(3)
% Try:
hist(soi)
% and
hist(soi,50)
% what are these functions showing? What do they tell us about the data?



%% Load in the data
% (NB More information on this data is available at
% http://www.metoffice.gov.uk/hadobs/hadisst/, you can also download the
% full dataset which is higher resolution than the version you will use and goes from 1871 to present day) 
load 'HadISST.mat'

% This is a matlab data file. It contains multiple variables
time; %in decimal years e.g. January 2001 is 2001.04166, December 2001 is 2001.9583 etc
% (NB time and soi_time are the same i.e the observations are for the same dates)
lon; % longitude
lat; % latitude
sst; % sea surface temperatue. This is a 3 dimensional matrix in the form sst(time,lon,lat)

% Type: format long
% enter
% This displays numbers to more decimal places
% 
% Now type: time(1)
% enter
% This is the value for the first time i.e. 1.960041666666667e+03
% This mean 1960 plus 0.04166 years

% What is 0.04166 of a year in days?
% 365 days/yr * 0.04166 year = 15.2059 days

% What day of the year are the 2nd and 3rd times taken on?
% time (2) = 1960.125
% 365 days/yr * 0.125 year = 45.625 days
% time (3) = 1960.20833
% 365 days/yr * 0.20833 year =  76.0404 days
%% 

%~~~~~~~~ Plot an animation of SST ~~~~~~~~~~
% We will now learn how to create map plots to show 2D data. The easiest
% way to do this is using the pcolor command. This has the form pcolor(X,Y,data(Y,X))

% Create a loop to plot maps of sst at each time; the loop pauses after each plot until you press enter
% NB if you want to break out of the loop pres CTRL-C
figure(3);clf
for t=1:length(time)
    pcolor(lon,lat,squeeze(sst(t,:,:)))
    shading flat
    colorbar
    pause
end

% What does the 'shading flat' command do: Clue try:
pcolor(lon,lat,squeeze(sst(t,:,:)))

%The default shading is faceted which is essentially flat shading with
%overlying black mesh grid lines. Specififying shading flat removes these
%grid lines.

% On the figure use the magnifying glass to zoom into a small part of the plot
% Now type 'shading flat'. What happens?

% The black mesh lines around each grid box disappear.

% What does the squeeze command do? Clue try: 
tmp=sst(t,:,:);
% what is the size of the tmp matrix? (hint, use the size() function). Now try:
tmp=squeeze(sst(t,:,:));
% what has changed?

%The squeeze command removes all the singleton dimensions from an array.
%Before using the squeeze command, the array tmp has dimensions [1,61,180].
%After the usage of the squeeze command, the array tmp loses its singleton
%and has dimensions [61,180].

%~~~~~~~~ Plot a time mean SST map ~~~~~~~~~~
% When you run the loop above, can you see a problem with the color bar that makes it hard to interpret what is happening?

% The problem with color bar is that it doesn't have fixed limits. The range
% of color shown is changing and the values that go with each color are also
% changing. This makes it difficult to track the changes in SST occuring
% because many of the changes shown over time result from the changing
% limits of the colorbar not the actual oceanic conditions.

% use the caxis command to solve this problem
%%
figure(3);clf
for t=1:length(time)
    pcolor(lon,lat,squeeze(sst(t,:,:)))
    
    % sets limits for the color bar axis
    caxis([-5 , 35])
    
    % converts the decimal year dates to month/day/year time format and
    % displays as the title
    yearfrac=time(t);
    year=fix(yearfrac);
    day=yearfrac-year;
    date = datestr(datenum(year,1,1)+day*366); 
    mytext = ['Sea Surface Temperature for ', num2str(date)];
    title(mytext);
    
    shading flat
    colorbar
     pause
end
%%

% Try adding a title that shows the changing date (clue you will need to use the num2str function introduced in the Matlab-Intro tutorial)

% In a new figure plot the mean sst adding appropriate title/labels/colorbar etc
% Hint you will need to average across all times. Time is the first
% dimension in the 612x61x81 sst matrix, so you will use squeeze(mean(sst,1)). N.B
% the mean function averages over the first dimension by default, so this
% is the same as squeeze(mean(sst)).
%%
figure (4) ; clf
pcolor(lon,lat,squeeze(mean(sst,1)));
shading flat;
c = colorbar;
ylabel(c,'SST in deg C')
xlabel('Latitude'); ylabel('Longtiude');
title('Average Global Sea Surface Temperatures from 1960-2011');
%%
%~~~~~~~~ Plotting the seasonal cycle ~~~~~~~~~~
% Next we'll look at the seasonal cycle of SST

% Type:
1:12:100
% and press enter
% what does this produce?

% It creates an array that moves from 1 to 100 in increments of 12. 

% Type:
time(1:12:end)
% and press enter
% what is this showing? 

% It is showing every 12th value in the time array starting with the first
% to the end.

% So, what would 
sst(1:12:end,:,:)
% represent?

% This is showing the January temperatures for every year in the dataset.

% And what would 
sst(2:12:end,:,:)
% represent?

% This is showing the February temperatures for every year in the dataset.
%%
% So to plot the mean SST for all Februarys you could do
figure(5);clf
pcolor(lon,lat,squeeze(mean(sst(2:12:end,:,:))));shading flat
c = colorbar;
ylabel(c,'SST in deg C')
xlabel('Latitude'); ylabel('Longtiude');
title('Mean February SST')

%%
%create cell array with the months
monthname = [{'January'} {'February'} {'March'} {'April'}  {'May'}  {'June'}  {'July'}  {'August'}  {'September'}  {'October'}  {'November'}  {'December'}];

% Complete the following loop so that it plots the mean SST for Jan, Feb ... Dec
for m=1:12
    pcolor(lon,lat,squeeze(mean(sst(m:12:end,:,:))));
    caxis([-5 , 35]);
    c = colorbar;
    ylabel(c,'SST in deg C')
    xlabel('Latitude'); ylabel('Longtiude');
    shading flat
    title(monthname(m));
    pause
end
%%
%create cell array with the months
monthname = [{'January'} {'February'} {'March'} {'April'}  {'May'}  {'June'}  {'July'}  {'August'}  {'September'}  {'October'}  {'November'}  {'December'}];

% Instead of plotting these one after another we can put them all on one plot
for m=1:12
    subplot(3,4,m)
    pcolor(lon,lat,squeeze(mean(sst(m:12:end,:,:))));
    caxis([-5 , 35]);
    c = colorbar;
    ylabel(c,'SST in deg C')
    xlabel('Latitude'); ylabel('Longtiude'); shading flat;
    title(monthname(m))
end
%%
% These 12 monthly averages are called a climatology of SST (i.e. average temperature for jan, feb ...)
% The following loop to creates a new variable that contains the
% SST climatology in the form climSST(month,lon,lat) where month goes from 1 to 12
for m=1:12
    climSST(m,:,:)=mean(sst(m:12:end,:,:));
end


% So the climatology tells us what temperature we might expect in each
% month on average. But, of course, in any given month it could be warmer
% or colder than the long-term average. The difference is called an anomaly

%~~~~~~~~ Plotting the SST anomalies ~~~~~~~~~~
% Next we need to produce a variable that contains SST anomalies i.e. the
% difference between SST and the normal SST climatolgy. This tells is how
% much hotter or colder temperature is than normal for each month

% To do this we need to get the SST for a particular month and subtract the corresponding climatological SST for that month
% E.g. SST(1,:,:) is the SST for January 1961 and climSST(1,:,:) is the
% average SST for all Januaries. The SST anomaly for January 1961 is:
% SST(1,:,:) - climSST(1,:,:)
% The SST for February 1962 would be SST(14,:,:) while the average for all
% Februaries is climSST(2,:,:). So the SST anomaly for February 1962 is
% SST(14,:,:) - climSST(2,:,:)

count = 1;
for ii=1:12:13872
anomSST(count,:,:) = sst(ii:ii+3,:,:) - climSST(1:4,:,:)
count = count +1;
end 

anomSST(ninayears,:,:)

% So we want to write a code that will do the following:
anomSST(1,:,:) = sst(1,:,:) - climSST(1,:,:); %SST from the first january minus the average of all Januaries
anomSST(2,:,:) = sst(2,:,:) - climSST(2,:,:); %SST from the first February minus the average of all Febuaries
anomSST(3,:,:) = sst(3,:,:) - climSST(3,:,:);
anomSST(4,:,:) = sst(4,:,:) - climSST(4,:,:);
anomSST(5,:,:) = sst(5,:,:) - climSST(5,:,:);
anomSST(6,:,:) = sst(6,:,:) - climSST(6,:,:);
anomSST(7,:,:) = sst(7,:,:) - climSST(7,:,:);
anomSST(8,:,:) = sst(8,:,:) - climSST(8,:,:);
anomSST(9,:,:) = sst(9,:,:) - climSST(9,:,:);
anomSST(10,:,:) = sst(10,:,:) - climSST(10,:,:);
anomSST(11,:,:) = sst(11,:,:) - climSST(11,:,:);
anomSST(12,:,:) = sst(12,:,:) - climSST(12,:,:);
anomSST(13,:,:) = sst(13,:,:) - climSST(1,:,:);
anomSST(14,:,:) = sst(14,:,:) - climSST(2,:,:);
anomSST(15,:,:) = sst(15,:,:) - climSST(3,:,:);
...
anomSST(612,:,:) = sst(612,:,:) - climSST(12,:,:);

% This is a lot of typing, so better to use a loop. There a a few different
% ways you could do ths. One is using the 'mod' command (look it up using 'help mod')
% Type: 
mod(1,12)
mod(5,12)
mod(12,12)
mod(13,12)
mod(14,12)
% What does it do?

% Try to run this bit of code:
for t=1:length(time)
    month=mod(t,12);
    if month==0
        month=12;
    end
    disp(['month=',num2str(month)])
end

% What is it doing? 

% Now complete to calculate the anomalies
for t=1:length(time)
    disp(t)
    month=mod(t,12);
    if month==0
        month=12;
    end
    anomSST(t,:,:)= sst(t,:,:) - climSST(month,:,:);
end


% Try the following:
index=findnearestval(time,2001);   
% What does the variable index represent? [clue type: index and then enter; type: time(index) and enter


% Below is a plot of the SST anonmaly for January 1998 [remember you will need to use the squeeze command]
index=findnearestval(time,1998);  
figure(4);clf
pcolor(lon,lat,squeeze(anomSST(index,:,:)));shading flat;colorbar;caxis([-3 3])

%~~~~~~~~ Plotting the SST anomalies for yourself ~~~~~~~~~~
% What does it show? What was the SOI doing at this time?

% Pick a date when the SOI was in a different phase and do a plot of this.
% Describe the SST anomalies?
index=findnearestval(time,1962);  
figure(5);clf
pcolor(lon,lat,squeeze(anomSST(index,:,:)));shading flat;colorbar;caxis([-3 3])

%~~~~~~~~ Plotting the relationship between SST and SOI ~~~~~~~~~~
% Now we will look at the relationship between SST and SOI in different regions.

% to find the index of the latitude closest to the equator
lat_0=findnearestval(0,lat)
% use the findnearest command to find the longitude closest to the 240E
lon_240=findnearestval(240 , lon) 
% now create a variable that contains the timeseries of SST anomalies at 240E on the equator
anomSST_0_240E=anomSST(:,lat_0,lon_240);
%%
% Create a 2 panel figure. The top panel should show the SOI timeseries and
% the bottom the anomSST_0_240E timeseries. Apply a 6-month moving average
% to both time series (using the smooth function)
figure(6);clf
subplot(2,1,1)
plot(soi_time,soi);hold on
plot(soi_time,smooth(soi,6),'k','linewidth',2)
xlim([1960 2012]);
xlabel('Time(yr)')
ylabel('SOI index')
legend('Observed data', '6 month running average')
subplot(2,1,2)
plot(time,anomSST_0_240E);hold on
plot(time,smooth(anomSST_0_240E,6),'k','linewidth',2)
xlim([1960 2012]);
xlabel('Time(yr)')
ylabel('SST anomaly (deg C)')
legend('Observed data', '6 month running average')
%%
% Plot a scatter plot of SOI versus anomSST_0_240E. What does it tell you?
% On the figure window click on the Tools menu> Basic Fitting > Linear > Show equation
% This will add a trend line for you
figure(7);clf
scatter ( soi , anomSST_0_240E); 

% There is a negative trendline with a slope of -0.059 for the scatter plot
% which suggests that the SOI index and SST anomalies along 240E are inversely proportional.
% As theas the SOI index decreases, there are more positive SST anomalies.

% Using the corr finction you can calculate the correlation between soi and
% anomSST_0_240E and the associated p-value; use [R,P]=corr(..
% For those of you that havent done much statistics, look up what p-value means. 
% Its extremely important in science for testing hypothesis
[r,p]=corr(soi,anomSST_0_240E)


%% OPTIONAL EXTRAS 
% For those of you after a challenge or who think they will use matlab in
% the future here's some extra things you could try ...
% 1. Write a code that will plot a map of the seasonal range in SST 
%    (i.e the difference between the maximum and minimum climatological SST
% 2. Find all the dates when the SOI is big (e.g. >1 standard deviation) 
%    and plot the average SST anomaly for these dates. Repeat for small values of SOI. 
%    (This is called a composite analysis)
% 3. Try using the contourf command instead of the the pcolor command. This
%    can produce much cleaner figures
% 4. The findnearestval command finds the location of the nearest value in a
%    matrix to a given value e.g. I=findnearestval(2000.5,time)
%    you can do the same thing using [Y,I]=min(abs(time-2000));
%    Try and work out how this works 


