function [ landtemp ] = landcalc( x,y )
%
% Calculates whether a point (x,y) is over land or ocean based on a
% bathymetry/topography data set
%    Copyright WindRiskTech, L.L.C., 2011
%    Last modified December, 2011
%-------------------------------------------------------------------------
load bathymetry
n=max(size(x));
m=max(size(y));
landtemp=zeros(n,m);
%
for i=1:n,
    for j=1:m,
        lati=y(j);
        longi=x(i);
        %
        ib=1+floor(4.*longi);
        if ib > 1440
            ib=ib-1440;
        end    
        if ib < 1
            ib=ib+1440;
        end    
        ibp=ib+1;
        if ibp > 1440
            ibp=1;
        end    
        jb=1+floor(4.*(lati+90));
        b1=-bathy(ib,jb);
        b2=-bathy(ib,jb+1);
        b3=-bathy(ibp,jb);
        b4=-bathy(ibp,jb+1);
        dely=1+4.*(lati+90)-jb;
        delx=1+4.*longi-ib;
        d1=(1.-delx).*(1.-dely);
        d2=dely.*(1.-delx);
        d3=delx.*(1.-dely);
        d4=delx.*dely;
        landtemp(i,j)=d1*b1+d2*b2+d3*b3+d4*b4;
    end
end
landtemp=-landtemp;
landtemp=min(landtemp,1);
landtemp=max(landtemp,0);
%
end