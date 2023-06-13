% This script used cctoolbox to sort the cesm/LMR past millennium storms into different
% clusters using regression mixture models. The goal is to recreate the
% results of Kossin et al. 2010
% Lizzie Wallace
% 2/4/2021
% Modified by R1chard Sullivan 4/3/2023

%initialize the toolbox (only needs to happen once)
%  setcctpath();

%% Load data

%meta = dir('*.mat');  %Script must be directed towards folder containing unclustered storm .mat files (kerry's prep.m output)
load '../Storm Sets/LMR21_Atl_storms.mat'

%files = {meta.name}';
%disp(files);
%
%R1 = 'What dataset are we clustering? ';
%S = input(R1);
%Data= getfield(meta,{S},'name');
%
%R1 = (['Loading: ', getfield(meta,{S},'name')]);
%disp(R1);
%
% %load the whole atlantic storm dataset
%load(Data);  
    
    
    %load cluster data to add new clusters to cluster.mat file. Not needed
    %for experimenting with cluster size.
    % load .mat; %name of cluster file.

%end %if loadflag
clear R1 files
%% Wildcard to find variables and eval to assign data to correct variable name


olat=whos('*lat*');
lat=eval(olat.name);

olon=whos('*lon*');
lon=eval(olon.name);

oyear=whos('year*');
year=eval(oyear.name);


clear olat olon oyear
%% Try out a bunch of cluster numbers 

lon = wrapTo180(lon);

Y = cell(size(lat,1),1);
X = cell(size(lat,1),1);

for ii=1:size(lat,1)
    eot = min(find(lat(ii,:)==0))-1; %identify end of track point
    latii_eot = lat(ii,1:eot)'; %cutoff long and lats
    longii_eot = lon(ii,1:eot)';
    Y{ii} = [longii_eot,latii_eot]; %store the tracks in a cell array
    X{ii}=[1:eot]';
end %for ii

%create a SCALAR structure with elements X (time) and Y (lon lat)
s = struct('X',{},'Y',{});
s(1).X = X;
s(1).Y = Y;

prompt = 'How many clusters (number) '; 
nclus = input(prompt);


Lhood_LMR = zeros(nclus,1);
clust_LMR = zeros(length(year),nclus);

    for jj=1:nclus  %number of clusters to try
        %set the model options
        ops.method = 'lrm';  % select clustering method; see listmodels() for all methods
        ops.K = jj;           % number of clusters
        ops.order = 2;       % order of regression; specify 1 for linear, 2 for quadratic, etc.
        ops.zero = 'none';   % select data normalization; see trajs2seq() for values

        % We are going to use standard linear/polynomial regression mixtures as 
        % specified by 'lrm', and we are seeking four groups in the data. We
        % choose to use quadratic polynomial regression, and we do not want
        % to perform any preprocessing or normalization of the data.

        %set the EM options
        ops.NumEMStarts = 1;   % number of random EM starts to perform
        %For our current demo, we only set the number of random EM starts.

        %run the model
        model = curve_clust(s,ops);

        clust_LMR(:,jj) = model.C;
        Lhood_LMR(jj) = model.TrainLhood_ppt; 
    end %for jj

    %  save('cesm_clust_EM1.mat','clust_LMR','Lhood_LMR');

%Plot likelihood of cluter number. Steeper slopes means greater probability
    
f = figure;
plot([1:nclus],Lhood_LMR(1:nclus),'-o','linewidth',1.5)
xlabel('# Clusters'); ylabel('Log Likelihood');
% print('cesm_clust_LHood','-dpng', '-r300');
%%
%pick 4 clusters to copy Kossin 2010
%nclus = 4;
%%
%sort cluster
for ii = 1:nclus;
   xc = find(clust_LMR(:,nclus)==ii);
   eval(sprintf('LMR_cluster%d = [xc];', ii))
end
    

%plot all the tracks in the clusters (identified by color)
%% 

col = 4; %set number of columns in final figure
row = 2; % set number of rows in final figure

%load the coastline data (coastlat, coastlon)
     load coastlines;
     %load 'clusters.mat';

f = figure; 
subplot(row,col,1); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
     p1 = plot(Y{LMR_cluster1(ii)}(:,1), Y{LMR_cluster1(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.25;
end %for ii
title('cluster 1'); ylabel('Latitude');xlabel('Longitude');
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

subplot(row,col,2); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
    plot(Y{LMR_cluster1(ii)}(1,1), Y{LMR_cluster1(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     p1 = plot(Y{indx_cluster1(ii)}(:,1), Y{indx_cluster1(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.5;
end %for ii
title('cluster 1'); ylabel('Latitude');xlabel('Longitude');
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');


subplot(row,col,3); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
     p2 = plot(Y{LMR_cluster2(ii)}(:,1), Y{LMR_cluster2(ii)}(:,2),'-k','linewidth',1);p2.Color(4) = 0.25;
end %for ii
title('cluster 2'); ylabel('Latitude');xlabel('Longitude');
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

subplot(row,col,4); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
    plot(Y{LMR_cluster2(ii)}(1,1), Y{LMR_cluster2(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     p2 = plot(Y{indx_cluster2(ii)}(:,1), Y{indx_cluster2(ii)}(:,2),'-k','linewidth',1);p2.Color(4) = 0.5;
end %for ii
title('cluster 2'); ylabel('Latitude');xlabel('Longitude');
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

subplot(row,col,5); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
     p3 = plot(Y{LMR_cluster3(ii)}(:,1), Y{LMR_cluster3(ii)}(:,2),'-k','linewidth',1);p3.Color(4) = 0.25;
end
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
title('cluster 3'); ylabel('Latitude');xlabel('Longitude');

subplot(row,col,6); hold on;
plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
for ii=1:250
    plot(Y{LMR_cluster3(ii)}(1,1), Y{LMR_cluster3(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     p3 = plot(Y{indx_cluster3(ii)}(:,1), Y{indx_cluster3(ii)}(:,2),'-k','linewidth',1);p3.Color(4) = 0.5;
end
ylim([0 60]); xlim([-100 -10]);
set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
title('cluster 3'); ylabel('Latitude');xlabel('Longitude');

%subplot(row,col,7); hold on; 
%plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
%for ii=1:250
%     p4 = plot(Y{LMR_cluster4(ii)}(:,1), Y{LMR_cluster4(ii)}(:,2),'-k','linewidth',1);p4.Color(4) = 0.25;
%end    
%title('cluster 4'); ylabel('rowLatitude');xlabel('Longitude');
%ylim([0 60]); xlim([-100 -10]);
%set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
%
%subplot(row,col,8); hold on; 
%plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
%for ii=1:250
%    plot(Y{LMR_cluster4(ii)}(1,1), Y{LMR_cluster4(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%%     p4 = plot(Y{indx_cluster4(ii)}(:,1), Y{indx_cluster4(ii)}(:,2),'-k','linewidth',1);p4.Color(4) = 0.5;
%end    
%title('cluster 4'); ylabel('Latitude');xlabel('Longitude');
%ylim([0 60]); xlim([-100 -10]);
%set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

% subplot(row,col,9); hold on;
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%      p1 = plot(Y{LMR_cluster5(ii)}(:,1), Y{LMR_cluster5(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.25;
% end %for ii
% title('cluster 5'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
% title('cluster 5'); ylabel('Latitude');xlabel('Longitude');
% 
% subplot(row,col,10); hold on; 
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%     plot(Y{LMR_cluster5(ii)}(1,1), Y{LMR_cluster5(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     % p5 = plot(Y{indx_cluster5ii)}(:,1), Y{indx_cluster5(ii)}(:,2),'-k','linewidth',1);p5.Color(4) = 0.5;
% end    
% title('cluster 5'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

% subplot(row,col,11); hold on;
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%      p1 = plot(Y{LMR_cluster6(ii)}(:,1), Y{LMR_cluster6(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.25;
% end %for ii
% title('cluster 6'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
% title('cluster 6'); ylabel('Latitude');xlabel('Longitude');
% 
% subplot(row,col,12); hold on; 
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%     plot(Y{LMR_cluster6(ii)}(1,1), Y{LMR_cluster6(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     % p5 = plot(Y{indx_cluster5ii)}(:,1), Y{indx_cluster5(ii)}(:,2),'-k','linewidth',1);p5.Color(4) = 0.5;
% end    
% title('cluster 6'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');

% subplot(row,col,13); hold on;
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%      p1 = plot(Y{LMR_cluster7(ii)}(:,1), Y{LMR_cluster7(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.25;
% end %for ii
% title('cluster 7'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
% title('cluster 7'); ylabel('Latitude');xlabel('Longitude');
% 
% subplot(row,col,14); hold on; 
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%     plot(Y{LMR_cluster7(ii)}(1,1), Y{LMR_cluster7(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     % p5 = plot(Y{indx_cluster5ii)}(:,1), Y{indx_cluster5(ii)}(:,2),'-k','linewidth',1);p5.Color(4) = 0.5;
% end    
% title('cluster 7'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
% 
% subplot(row,col,15); hold on;
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%      p1 = plot(Y{LMR_cluster8(ii)}(:,1), Y{LMR_cluster8(ii)}(:,2),'-k','linewidth',1);p1.Color(4) = 0.25;
% end %for ii
% title('cluster 8'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');
% title('cluster 8'); ylabel('Latitude');xlabel('Longitude');
% 
% subplot(row,col,16); hold on; 
% plot(coastlon, coastlat, '-k',  'linewidth', 1.5);
% for ii=1:250
%     plot(Y{LMR_cluster8(ii)}(1,1), Y{LMR_cluster8(ii)}(1,2),'ok','MarkerSize',5,'linewidth',1);
%     % p5 = plot(Y{indx_cluster5ii)}(:,1), Y{indx_cluster5(ii)}(:,2),'-k','linewidth',1);p5.Color(4) = 0.5;
% end    
% title('cluster 8'); ylabel('Latitude');xlabel('Longitude');
% ylim([0 60]); xlim([-100 -10]);
% set(gca,'fontweight','bold',  'linewidth', 1.5,'box','on');


print('cesm_clust8','-dpng', '-r300');

   
clear col row Data eot ii jj nclus prompt Rt S xc
