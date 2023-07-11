function [x, y, z] = gendensity_lizzie(bas,latstore,longstore,freqyear,yearstore,vnet,vstore,vmax)
% [x y z] = gendensity_lizzie(bas,latstore,longstore,freqyear,yearstore,vnet,vstore,vmax) 
% x = longitude of gendensity, y = latitude of gendensity, z = gendensity
% This script contours the number density of genesis points , defined as 
% the first point of each track where wind speeds exceed startv,
% filtered (if desired) to include only those events whose winds speeds
% exceed some threshold, peakv. It requires installation of the
% "m_map" routines. Units are events per 1 degree latitude square per year.
% 
% Copyright 2009 WindRiskTech L.L.C.
% Last modified March, 2016
%
%------------------------------------------------------------------------
%
%params    %  Load parameters
%
clear latscat longscat y x z imin imax kmin kmax
% if exist('shearstore','var') == 0 || exist('vstore','var') == 0
%     storm=[];
%     shape='circ';
%     load('temp.mat')
% end   
%   load sorted
if strcmp(bas,'GB')
    projection=gproject;
end    
[nn,m]=size(vstore);
pifac=acos(-1)./180;
% denotes pt where track ends
[~,jmax]=min(vstore,[],2);
jmax=jmax-1;
% defines the pt where the wind speed is above startv
[~,jmin]=min(max((startv-vnet),0),[],2);
longscat=zeros(1,nn);
latscat=zeros(1,nn);
freqmask=zeros(1,nn);
if exist('yearstore','var') == 0
    yeartemp=2000+zeros(1,nn);
    freqtemp=freq;
else
    yeartemp=yearstore;
    freqtemp=freqyear;
    atemp=ismember((min(yearstore):max(yearstore)),yearstore);
    atemp=cast(atemp,'like',yearstore);
    yearset=nonzeros(atemp.*(min(yearstore):max(yearstore))); %850-2005
end 
%find the storms that have intensity over peakv and the first point they are above it as longscat
%and latscat and freqmask
n=0;
for i=1:nn
   if vmax(i) >= peakv
      n=n+1; 
      longscat(n)=longstore(i,jmin(i));
      latscat(n)=latstore(i,jmin(i));
      if (strcmp(bas,'MT')|| max(latstore(:,1)) > 50) && longscat(n) > 200
          longscat(n)=longscat(n)-360;
      end    
      [~,nyy]=ismember(yeartemp(i),yearset);
      freqmask(n)=freqtemp(nyy);
   end   
end
longscat(n+1:nn)=[];
latscat(n+1:nn)=[];
freqmask(n+1:nn)=[];

% define the bounds of the grids (gres is how many degrees you will use per grid
%if auto is on, define grids based on min and max lat longs of the data
if strcmp(mapmode,'auto')
    xmin=min(nonzeros(longscat))-dellong;
    xmax=max(longscat)+dellong;
    ymin=min(nonzeros(latscat))-dellat;
    ymax=max(latscat)+dellat;
    xmin=gres*floor(xmin/gres);
    xmax=gres*ceil(xmax/gres);
    ymin=gres*floor(ymin/gres);
    ymax=gres*ceil(ymax/gres);    
else
    xmin=longmin;
    xmax=longmax;
    ymin=latmin;
    ymax=latmax;
end 
%if we're talking about the atlantic, specify 250-360 long and start lat 0
if strcmp(bas,'AL') && max(latstore(:,1)) < 55
    xmin=max(xmin,250);
    xmax=min(xmax,360);
    ymin=max(ymin,0);
%elseif strcmp(bas,'GB')
%    xmin=0;
%    xmax=360;
end 
%define grids (x,y) and density file (z)
x=xmin:gres:xmax;
y=ymin:gres:ymax;
an=max(size(y));
am=max(size(x));
z=zeros(an,am);
% finds each grid point where the genesis points are from
% and store them as ax and ay
latr=gres*floor(latscat/gres);
latr=latr+mod(y(1),gres);
longr=gres*floor(longscat/gres);
longr=longr+mod(x(1),gres);
[latl,ay]=ismember(latr,y);
[longl,ax]=ismember(longr,x);
ax=max(ax,1);
ay=max(ay,1);
N=max(size(latl));
% i think this is some kind of correction for some grid boxes being bigger
% at the poles and frequency is different each year
ga=freqmask.*latl.*longl./cos(pifac*latr);  % Corrected March, 2016
%calculates gen density
for i=1:N
    z(ay(i),ax(i))=z(ay(i),ax(i))+ga(i);
end
z=z/(nn*gres^2); %for some reason we're dividing by the area of the box and number of tracks
