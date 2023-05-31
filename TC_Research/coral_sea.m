
%====================================================================
% Function coral_sea.m

% NOTE: CHANGES TO ORIGINAL SEA CODE 3/27/18 SDEE:

% Do not normalize by the max() 
% Remove the mean of the dataset PRIOR to eruption (not the mean of the entire window). 
% (cf Anchukaitis et al, 2017), use an asymmetric window,
% 3 years before, 10 years after, this is customizable.

%====================================================================
% Superposed Epoch Analysis
%====================================================================
function [Xevents, Xcomp, tcomp]=coral_sea(X, events, before, after)

% Applies superposed Epoch Analysis to N-dim array X, at indices 'events', 
% and on a window [-before,after] 
%     Inputs:
%         - X: numpy array [time assumed to be the first dimension]
%         - events: indices of events of interest
%         - before: % years over which the pre-event mean is computed
%         - after: length of post-event window
%         
%     Outputs:    
%         - Xevents : X lined up on events; removes mean of "before" years 
%         - Xcomp  : composite of Xevents (same dimensions as X, minus the first one)
%         - tcomp  : the time axis relative to events

n_events = length(events);
sh = [length(X),n_events];  % define array shape, add number of events

%append(sh,n_events); 

sh(1) = before+after+1;     % replace time axis by time relative to window
Xevents = nan(sh);          % define empty array to hold the result 

% exception handling : 
% the first extreme year must not happen within the "before" indices
if any(ismember(events,(0:1:before)))|| any((events+after)>=length(X(:,1)))
    disp('correcting');
end

% Perform SEA:

for i=1:length(events)
    Xevents(:,i) = X(events(i)-before:events(i)+after,2);
    Xevents(:,i) = Xevents(:,i)-mean(Xevents(1:before,i)); % remove mean over "before" of window
    %Xevents(:,i) = Xevents(:,i)-mean(Xevents(:,i)); % remove mean over "before" of window
end

Xcomp = mean(Xevents,2); % compute composite

%====================================================================
 
% SDEE removed for 1-D Data/Bandpass

% % high-pass filter X along first axis  
% tcomp = (-before:1:after+1); % time axis  
% fc = 1/len(tcomp)
% 
% % reshape X to 2d
% if highpass:
%     Xr = np.reshape(X,(sh[0],np.prod(sh[1:])))
%     Xr_hp = np.empty_like(Xr)
%     ncols = Xr.shape[1]
%     for k in range(ncols):
%         Xlp = flt.butterworth(Xr[:,k],fc)
%         Xr_hp[:,k] = Xr[:,k] - Xlp
% 
%     Xhp = np.reshape(Xr_hp,sh) 
% else:
%     Xhp = X