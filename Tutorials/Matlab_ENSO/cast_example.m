close all % close all figures
clear % remove all variables

% Load the ARGO data for 2 different locations
% data is from Matlab-intro (available on STELLAR)
load('/Users/cummenhofer/CVD/2016/Matlab_Tutorials/Lab1/cast1.mat')
load('/Users/cummenhofer/CVD/2016/Matlab_Tutorials/Lab1/cast2.mat')

% split data into seperate depth, temperature and salinity variables
depth1=cast1(:,1);
temp1=cast1(:,2);
sal1=cast1(:,3);

depth2=cast2(:,1);
temp2=cast2(:,2);
sal2=cast2(:,3);

clear cast* % remove unneeded variables (just to keep things tidy)

%plot the 2 casts
figure(1);clf
subplot(1,2,1)
plot(temp1,-depth1,'k');hold on
plot(temp2,-depth2,'r')
ylim([-3000 0]) % NB Need to have the smallest number first
title('a) Temperature Cast 1&2') % NB the '^' creates a superscrpt
ylabel('Depth [m]'); %add axis labels
xlabel('Temperature [^oC]')
pbaspect([1 1 1]); %make the subplots square
subplot(1,2,2)
plot(sal1,-depth1,'k');hold on
plot(sal2,-depth2,'r')
ylim([-3000 0])
title('b) Salinity  Cast 1&2')
legend('cast1','cast2') % can position the legend box manually by dragging 
pbaspect([1 1 1]); %make the subplots square
xlabel('Salinity [psu]')

% Notes
% Figure 1 shows a) temperature and b) salinity from 2 location 
% Based on the temperature cast1 comes from a high latitude region with surface temperatures of ~6C. 
% There is a small mixed layer of about 20m, and a weak thermocline from about 20m to 60-70m. 
% Temperature differences below this are small ranging between 3-5C
% cast2 comes from a low latitude location with a surface temperature of about 22C.
% The thermocline extends from the surface to about 1000m. Deep
% temperatures are about the same in the high and low latitude regions.
% Salinity ...