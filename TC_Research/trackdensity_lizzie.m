function [x, y, z] = trackdensity_lizzie(bas,latstore,longstore,freqyear,yearstore,vnet,vstore,vmax)
% [x y z] = trackdensity_lizzie(bas,latstore,longstore,freqyear,yearstore,vnet,vstore,vmax) 
% x = longitude of gendensity, y = latitude of gendensity, z = gendensity
% This script contours the number density of all 2 hour track points,  
% filtered (if desired) to include only those events whose winds speeds 
% exceed some threshold, peakv. It requires installation of the
% "m_map" routines.
% Copyright 2009 WindRiskTech L.L.C.
% Last modified August, 2015
%------------------------------------------------------------------------
%
params    %  Load parameters
%
[nn,m]=size(vstore);
if strcmp(bas,'GB')
    projection=gproject;
end    
if exist('yearstore','var') == 0
    yearstore=2000+zeros(1,nn);
    freqyear=freq;
end
%
pi=acos(-1);
pifac=pi/180;
%
latmask=min(ceil(abs(latstore)),1);
if strcmp(bas,'MT') || max(latstore(:,1)) >= 55   %  For Mediterranean basin, or polar lows rectify longitudes
    for i=1:nn
        for j=1:m
            if longstore(i,j) >= 200
                longstore(i,j)=longstore(i,j)-360.001;  %#ok<SAGROW> The 0.001 prevents artificial zeros
            end
        end    
    end
end    
%
if strcmp(mapmode,'auto')
    xmin=min(nonzeros(longstore))-dellong;
    xmax=max(nonzeros(longstore))+dellong;
    ymin=min(nonzeros(latstore))-dellat;
    ymax=max(nonzeros(latstore))+dellat;
    xmin=mres*floor(xmin/mres);
    xmax=mres*ceil(xmax/mres);
    ymin=mres*floor(ymin/mres);
    ymax=mres*ceil(ymax/mres);
else
    xmin=longmin;
    xmax=longmax;
    ymin=latmin;
    ymax=latmax;
end 
if (strcmp(bas,'AL') && max(latstore(:,1)) < 55) || strcmp(bas,'EW')
    xmin=max(xmin,200);
    xmax=min(xmax,360);
    ymin=max(ymin,0);
    %ymax=80;
%elseif strcmp(bas,'GB')
%    xmin=0;
%    xmax=360;
%    ymin=-84;
%    ymax=84;
end    
x=xmin:mres:xmax;
y=ymin:mres:ymax;
an=max(size(y));
am=max(size(x));
z=zeros(an,am);
%
vmax2(:,1)=ceil(min(max(vmax-peakv,0),1));  
vmax3=repmat(vmax2,[1,m]);
atemp=ismember((min(yearstore):max(yearstore)),yearstore);
atemp=cast(atemp,'like',yearstore);
yearset=nonzeros(atemp.*(min(yearstore):max(yearstore)));
[~,nyy]=ismember(yearstore,yearset);
freqmask=freqyear(nyy);
freqmask2=repmat(freqmask,[1,m]);
dum=nonzeros(vmax3'.*latstore'.*latmask');
latr=mres*floor(dum/mres);
latr=latr+mod(y(1),mres);
dum=nonzeros(vmax3'.*(longstore+0.001)'.*latmask');
longr=mres*floor(dum/mres);
longr=longr+mod(x(1),mres);
clear dum
vl=ceil(min(max((nonzeros(vmax3'.*vnet'.*latmask')-minv),0),1));
%
[latl,ay]=ismember(latr,y);
[longl,ax]=ismember(longr,x);
ax=max(ax,1);
ay=max(ay,1);
%
N=max(size(vl));
den=freqmask2(1:N)'.*vl(1:N).*latl(1:N).*longl(1:N)./cos(pifac*latr(1:N));
%
for i=2:N
    if ay(i) ~= ay(i-1) || ax(i) ~= ax(i-1)  % This test insures that each track is counted only once per lat-long box
                                             % though it will count tracks that leave a box and then re-enter it
        z(ay(i),ax(i))=z(ay(i),ax(i))+den(i);
    end    
end
%
z=z./(nn*mres^2);
