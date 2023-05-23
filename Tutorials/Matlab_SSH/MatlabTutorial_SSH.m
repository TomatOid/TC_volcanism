%% MatlabTutorial SSH
% What you will need (from STELLAR):
% Three data files:
% 1.  buoydata.mat
% 2.  sshdata.mat
% 3.  m_coasts.mat
% and three m files:
% 1.  MatlabTutorial_SSH.m (instructions for this lab)
% 2.  plotmap.m a function to plot coastlines
% 3.  findnearestval.m a function to find the nearest value in a vector of numbers
%
% Work through MatlabTutorial_SSH.m filling in the blanks. You can run parts of
% the file by selecting it and then hitting CTR-F7. Copy the important bits
% of code into second m-file that includes code, annotated figures,
% comments and a brief report describing the data (see at the end for more
% information). Make sure that the file you hand in runs by itself, without
% producing any errors.

clear; close all

%% Load in and plot the buoy data
% In this lab, we will be investigating the behavior of one particular
% drifting buoy in the Tasman Sea. First, load in the buoy data
load 'buoydata.mat';

% look at which variables have been loaded. Do you understand what these
% are?
whos

% These variables are the latitude and longtidude of a buoy at a particular time (in datenumber format).

% Create a new blank figure,
figure(1);clf
% Now plot the buoy data
plot(buoylon,buoylat)

% You will see a very squirly line on your plot. Just to appreciate how
% much data there is on this one particluar buoy trajectory, plot it such
% that each measurement is a circle
plot(buoylon,buoylat,'o-')
% Now use the zoom-in tool in the plot toolbar to zoom in to the fine-scale
% structure of the buoy trajectory. What a wealth of data!
%%
% use plotmap, xlim and ylim to orient yourself
% overlay the location of the first latitude and longitude (in a different
% color), so you know which way the buoy travelled (remember to hold on)
figure(1);clf
plotmap; hold on;
plot(buoylon,buoylat);
plot(buoylon(1),buoylat(1), 'g*-');
xlabel ('Latitude')
ylabel('Longitude')
xlim([120 190])
ylim([-60 0])
%%
% To find out when the buoy was released, type
buoytime(1)
% This number probably doesn't make much sense, as it is in Matlab's
% datenum format. In order to see the real date, use the datestr function,
% which converts a Matlab date number to a human-readible string
datestr(buoytime(1))

% The Matlab datenum is just the number of days since some particular
% time. Which? You can find out by typing
datestr(0)

% It tells the time from the 00th of January 0000.

% Now, using the buoytime data, find out how long the buoy transmited data?
% (i.e. no. of days between the first and last transmission)
buoytimelength = buoytime(length(buoytime)) - buoytime (1);

% Before we do any other analysis, we need to know how often the buoy
% transmitted its position, and whether we have any data gaps. Since
% the buoytime is in real days, the temporal resolution of the data is
% simply the difference between the consecutive buoy measurements
figure(2);clf
plot(diff(buoytime),'.')

% What is the temporal resolution?
%% MatlabTutorial SSH
% What you will need (from STELLAR):
% Three data files:
% 1.  buoydata.mat
% 2.  sshdata.mat
% 3.  m_coasts.mat
% and three m files:
% 1.  MatlabTutorial_SSH.m (instructions for this lab)
% 2.  plotmap.m a function to plot coastlines
% 3.  findnearestval.m a function to find the nearest value in a vector of numbers
%
% Work through MatlabTutorial_SSH.m filling in the blanks. You can run parts of
% the file by selecting it and then hitting CTR-F7. Copy the important bits
% of code into second m-file that includes code, annotated figures,
% comments and a brief report describing the data (see at the end for more
% information). Make sure that the file you hand in runs by itself, without
% producing any errors.

clear; close all

%% Load in and plot the buoy data
% In this lab, we will be investigating the behavior of one particular
% drifting buoy in the Tasman Sea. First, load in the buoy data
load 'buoydata.mat';

% look at which variables have been loaded. Do you understand what these
% are?
whos

% These variables are the latitude and longtidude of a buoy at a particular time (in datenumber format).

% Create a new blank figure,
figure(1);clf
% Now plot the buoy data
plot(buoylon,buoylat)

% You will see a very squirly line on your plot. Just to appreciate how
% much data there is on this one particluar buoy trajectory, plot it such
% that each measurement is a circle
plot(buoylon,buoylat,'o-')
% Now use the zoom-in tool in the plot toolbar to zoom in to the fine-scale
% structure of the buoy trajectory. What a wealth of data!
%%
% use plotmap, xlim and ylim to orient yourself
% overlay the location of the first latitude and longitude (in a different
% color), so you know which way the buoy travelled (remember to hold on)
figure(1);clf
plotmap; hold on;
plot(buoylon,buoylat);
plot(buoylon(1),buoylat(1), 'g*-');
xlabel ('Latitude')
ylabel('Longitude')
xlim([120 190])
ylim([-60 0])
%%
% To find out when the buoy was released, type
buoytime(1)
% This number probably doesn't make much sense, as it is in Matlab's
% datenum format. In order to see the real date, use the datestr function,
% which converts a Matlab date number to a human-readible string
datestr(buoytime(1))

% The Matlab datenum is just the number of days since some particular
% time. Which? You can find out by typing
datestr(0)

% It tells the time from the 00th of January 0000.

% Now, using the buoytime data, find out how long the buoy transmited data?
% (i.e. no. of days between the first and last transmission)
buoytimelength = buoytime(length(buoytime)) - buoytime (1);

% Before we do any other analysis, we need to know how often the buoy
% transmitted its position, and whether we have any data gaps. Since
% the buoytime is in real days, the temporal resolution of the data is
% simply the difference between the consecutive buoy measurements
figure(2);clf
plot(diff(buoytime),'.')

% What is the temporal resolution?
% 0.25 units

% Are there any data gaps? How do you know?
biggest_gap = max(diff(buoytime));
% The value of biggest_gap is 0.25 so there are no gaps larger than 0.25



%% Load in and plot the ssh data
% The 3D array ssh contains ssh as a function of longitude, latitude and
% time. It's not easy to plot a 3D array, so we will first investigate the
% time-mean of the data.

load 'sshdata.mat';

% Create the time-mean of the data by issuing the command
ssh_mean=mean(ssh,3);

% What is the 3 for?
% We want to average across the 3rd dimension only (time in this case), 
% reducing it to a 2d array indexed by lattitude longitude pairs.
% The time dimension is averaged away

%%
%Plot this time-mean field with either the function contourf

figure(3);clf
contourf(sshlon, sshlat , transpose(ssh(:,:,1)))
c = colorbar;
ylabel(c,'Time mean of SSH (m)')
xlabel('Longitude'); ylabel('Latitude');
title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])

%(You might get an error message because the ssh_mean matrix is in the form lonxlat
% instead of latxlon. Just use ' to traspose the matrix)
% As always, add a colorbar and labels
%%
% In the title for this contour plot, you might want the date range for
% which this is the mean. Again, the dates are in the array sshtime. Use
% the datestr function to find out what the first date is in the ssh array.
% What is the last date? What is the temporal resolution of the ssh array?

%The last date is January 19, 2011. The temporal resolution is 7 days.
f= figure
plot(diff(sshtime),'.')

% Add a title with the date range over which the data was taken to the plot

title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])


% plot the mean sea surface height along a line at 32oS
figure(4);clf
lat_32 = findnearestval(-32,sshlat);
plot (sshlon , ssh_mean ( :, lat_32));


% Going back to figure 3, plot the buoy trajectory on top of the time-mean ssh field. For
% this, use the hold on commands. It might be helpful to make
% the buoy trajectory stand out more by adding 'linewidth',2 at the end of
% the plot command, just before the closing bracket.
%%
figure(3);clf
contourf(sshlon, sshlat , transpose(ssh_mean))
c = colorbar;
ylabel(c,'Time mean of SSH (m)')
xlabel('Longitude'); ylabel('Latitude');
title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])
hold on
plot(buoylon,buoylat, 'k' , 'linewidth',2)
hold off
% ---





%% Making a movie of SSH and the buoy trajectory

% You can get most information on how the sea surface height and the buoy
% trajectory are related by making an animation of the two. Let's first make a movie of only the sea
% surface height.

% you will have to write some code that will show
% individual snapshots in the array ssh, based on the value of the variable
% t. Note that this is very similar to what you've done in the ENSO MatlabTutorial,
% when you plotted all snapshots of SST. You might want to look back into
% that lab to see how you did it there.
%%
figure(5);clf
for t=1:length(sshtime)
    contourf(sshlon, sshlat , transpose(ssh(:,:,t)));
    c = colorbar;
    caxis([-1 , 2]);
    ylabel(c,'Time mean of SSH (cm)')
    xlabel('Longitude'); ylabel('Latitude');
    title(['SSH on ',datestr(sshtime(t))]);
    
    time_pt = sshtime(t);
    indx = find(buoytime==sshtime(t));
    hold on;
    plot(buoylon(indx),buoylat(indx), '*-k' , 'linewidth',2);
    hold off;
 
    drawnow % makes sure the figure is updated each time around the loop

end
%%
% Add suitable labels and colorbar and make sure the range doesn't jump
% around at each timestep

% Next we want to add the location of the buoy. The problem is, however,
% that the times associated with ssh and buoy data are not the same (i.e they have different temporal resolutions).
% To do this you need to
% 1. find the time associated with the ssh that you are plotting i.e sshtime(t)
% 2. find the the location in the buoytime vector that corresponds to that
% time (i.e. ind=find(buoytime==sshtime(t)); )
% 3. plot the corresponding buoylon and buoylat

time_pt = sshtime(t);
indx = find(buoytime==sshtime(t));
plot(buoylon,buoylat, 'k' , 'linewidth',2)

% Don't forget to add a colorbar, label the axes and put a title with the
% date on the top. Use datestr to convert from a matlab date to a
% human-readable date. Also, don't forget to use the caxis function to stop
% the colorbar from jumping around.
 

% Are there any data gaps? How do you know?



%% Load in and plot the ssh data
% The 3D array ssh contains ssh as a function of longitude, latitude and
% time. It's not easy to plot a 3D array, so we will first investigate the
% time-mean of the data.

load 'sshdata.mat';

% Create the time-mean of the data by issuing the command
ssh_mean=mean(ssh,3);

% What is the 3 for?


%%
%Plot this time-mean field with either the function contourf

figure(3);clf
contourf(sshlon, sshlat , ssh(:,:,1))
c = colorbar;
ylabel(c,'Time mean of SSH (m)')
xlabel('Longitude'); ylabel('Latitude');
title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])

%(You might get an error message because the ssh_mean matrix is in the form lonxlat
% instead of latxlon. Just use ' to traspose the matrix)
% As always, add a colorbar and labels
%%
% In the title for this contour plot, you might want the date range for
% which this is the mean. Again, the dates are in the array sshtime. Use
% the datestr function to find out what the first date is in the ssh array.
% What is the last date? What is the temporal resolution of the ssh array?

%The last date is January 19, 2011. The temporal resolution is 7 days.
f= figure
plot(diff(sshtime),'.')

% Add a title with the date range over which the data was taken to the plot

title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])


% plot the mean sea surface height along a line at 32oS
figure(4);clf
lat_32 = findnearestval(-32,sshlat);
plot (sshlon , ssh_mean ( :, lat_32));


% Going back to figure 3, plot the buoy trajectory on top of the time-mean ssh field. For
% this, use the hold on commands. It might be helpful to make
% the buoy trajectory stand out more by adding 'linewidth',2 at the end of
% the plot command, just before the closing bracket.
%%
figure(3);clf
contourf(sshlon, sshlat , transpose(ssh_mean))
c = colorbar;
ylabel(c,'Time mean of SSH (m)')
xlabel('Longitude'); ylabel('Latitude');
title(['SSH from ',datestr(sshtime(1)),' to ',datestr(sshtime(end))])
hold on
plot(buoylon,buoylat, 'k' , 'linewidth',2)
hold off
% ---





%% Making a movie of SSH and the buoy trajectory

% You can get most information on how the sea surface height and the buoy
% trajectory are related by making an animation of the two. Let's first make a movie of only the sea
% surface height.

% you will have to write some code that will show
% individual snapshots in the array ssh, based on the value of the variable
% t. Note that this is very similar to what you've done in the ENSO MatlabTutorial,
% when you plotted all snapshots of SST. You might want to look back into
% that lab to see how you did it there.
%%
figure(5);clf
for t=1:length(sshtime)
    contourf(sshlon, sshlat , transpose(ssh(:,:,t)));
    c = colorbar;
    caxis([-1 , 2]);
    ylabel(c,'Time mean of SSH (cm)')
    xlabel('Longitude'); ylabel('Latitude');
    title(['SSH on ',datestr(sshtime(t))]);
    
    time_pt = sshtime(t);
    indx = find(buoytime==sshtime(t));
    hold on;
    plot(buoylon(indx),buoylat(indx), '*-k' , 'linewidth',2);
    hold off;
 
    drawnow % makes sure the figure is updated each time around the loop

end
%%
% Add suitable labels and colorbar and make sure the range doesn't jump
% around at each timestep

% Next we want to add the location of the buoy. The problem is, however,
% that the times associated with ssh and buoy data are not the same (i.e they have different temporal resolutions).
% To do this you need to
% 1. find the time associated with the ssh that you are plotting i.e sshtime(t)
% 2. find the the location in the buoytime vector that corresponds to that
% time (i.e. ind=find(buoytime==sshtime(t)); )
% 3. plot the corresponding buoylon and buoylat

time_pt = sshtime(t);
indx = find(buoytime==sshtime(t));
plot(buoylon,buoylat, 'k' , 'linewidth',2)

% Don't forget to add a colorbar, label the axes and put a title with the
% date on the top. Use datestr to convert from a matlab date to a
% human-readable date. Also, don't forget to use the caxis function to stop
% the colorbar from jumping around.
 
