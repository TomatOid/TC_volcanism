%  This file specifies important parameters controlling the action of
%  various scripts. It will prove handy to keep this open in an editor
%  while using the scripts.
%
%      Value             Default     Units               Description
%      -----             -------     -----               -----------
% Directory names
    edir='Event_Sets/';     %     |   -   | Directory containing event set zip files (always follow by backslash)
    trkdir='Best_tracks/';  %     |   -   | Directory containing best tracks (always follow by backslash)
% Matlab Mapping Toolbox Override
    MapOverride='y';        % 'y' |   -   | Set to 'y' to use m_map routines even when Matlab Mapping Toolbox is present 
% Unclutter workspace        
    Clearvlbs='n';          % 'n' |   -   | When set to 'y', this clears temporary variables after most scripts are run
% Display doc button on graphs for accessing descriptions of graphs
    Docdisp='n';            % 'y' |   -   | Set to 'y' to display doc access button on graphs
% Units for display
    runits='in';      %    'mm'   |   -   | Rain depth units: inches ('in') or millimeters ('mm')
    wunits='kts';     %    'kts'  |   -   | Wind speed units: knots ('kts'), MPH ('mph') or km/hr ('kmh')
% Year and month ranges, and start point filter
    startv=35;        %     35    | knots | First point wind speed must exceed this value
    filtmonths=1:12;  %    1:12   | months| Months to filter synthetic and best tracks 
    %filtyears=yearsets('none'); % | Years | Years to filter synthetic tracks when using the script prepfilter.m
                      % Note: Calls function 'yearsets'. If yearset is a numeric vector, this vector 
                      % is returned as filtyears, otherwise: 
                      % If set to 'none', all years in set are used. Type 'doc yearsets' to see other pre-set possibilities
    bestyears=0;      %      0    | Years | Set of years to draw best track data from    
                      %   Set to 0 to automatically match those in event set
% Generic plot parameters (Note: Mapping routines use a different set)
    gfont='arial';    % 'arial'   |   -   | Axis label font
    gfontsize=12;     %    12     |   pt  | Axis label font size
    gfontweight='bold';%  'bold'  |   -   | Axis label font weight
% Wind speed reduction over land
    wreduc='y';       %    'y'    |   -   | Reduce surface winds over land using local surface roughness
    wheight=30;       %    30     |   m   | Altitude above local terrain to estimate surface winds
% Treatment of closed polygon filter
    poly_area=100;    %    100    | deg^2 | Critical area (degrees latitude squared) below which closed polygons
                      %                      are considered to be open for the purposes of calculating local quanitites. 
% Storm geometry
    seyewall='y';     %    'y'    |   -   | Use secondary eyewall information?
    wprofile=3;       %     3     |   -   | Wind profile 1=Holland, 2=Emanuel (from Lilly volume), 3= Emanuel & Rotunno, 2011
    magfac=1.0;       %    1.0    |   -   | Overall scale factor for storm size (Important: see note 5 below)
    randfac='n';      %    'n'    |   -   | Draw from lognormal distribution to randomize scaling factor?
% Time series parameters
    timeres=0.5;      %    0.5    | hours | Time resolution for time series at fixed points (should divide evenly into 2)
    timelength=96;    %     96    | hours | Length of time series at fixed points
    besttrplot='y';   %     'y'   |   -   | Plot best track data on time series plots?
    vswitch=1;        %      1    |   -   | 1 for storm lifetime maximum, 2 for maximum near POI
    bthresh=30;       %     30    | knots | Wind speed above which best tracks counted in calculating duration
% Annual cycle plots
    vcritann=40;      %     40    | knots | Threshold storm lifetime maximum wind speed to be included in counts
    normalize='y';    %     'y'   |   -   | Normalize so that annual totals of synthetic and best tracks are equal? ('y' or 'n')    
% Histograms and return period plots 
    htype=2;          %      2    |   -   | 1 for storm lifetime maximum, 2 for storm maximum near POI, 3 for maximum wind at POI    
    vbeg=40;          %     40    | knots | Lowest wind speed for histograms (this will be converted into desired units automatically)
    vend=220;         %    220    | knots | Highest wind speed for histograms (this will be converted into desired units automatically)
    vres=10;          %     10    | knots | Resolution of histograms (this will be converted into desired units automatically)
    hbins='auto';     %   'auto'  |   -   | Automatic ('auto'), regular bins ('norm'), or Saffir-Simpson ('ss')
    histf='cum';      %   'cum'   |   -   | Histogram function, 'cum' for cumulative, else 'pdf'
    ebar='y';         %    'y'    |   -   | Plot confidence intervals?
    halpha=0.15;      %    0.15   |   -   | Transparency of confidence interval shading
    rgridx='y';       %    'y'    |   -   | Plot background x grid?
    rgridy='y';       %    'y'    |   -   | Plot background y grid?
% Parameters used by rain algorithms
    wrad=0.005;       %    0.005  |  m/s  | Background subsidence velocity under radiative cooling
    topores='high';   %   'high'  |   -   | Topgraphic resolution ('high'=0.1 degree, 'low'=0.25 degree)   
    q900=0.01;        %     0.01  | gm/gm | Default value of specific humidity at 900 hPa used if T600 is not available
    eprecip=0.9;      %      0.9  |   -   | Precipitation efficiency
    Cdrag=0.0015;     %    0.0015 |   -   | Surface drag coefficient over water
    Cdland=0.003;     %    0.003  |   -   | Surface drag coefficient over land
    Hcrit=300;        %      300  |   m   | Altitude governing transition of drag coefficient from sea to land
    Htrop=4000;       %     4000  |   m   | Depth of lower troposphere
    timeresw=2;       %        2  |  hrs  | Native time resolution of WRT output
    deltar=2;         %        2  |   km  | Delta radius for calculating dM/dr
    raincntrs=exp(1:8/20:10);%     | mm/hr | Levels at which rain rate and accumulated rain are contoured in rainfield.m and rainswath.m. Not used if contours are filled
% Track plot parameters
    lpthresh=0;       %      0    |  kts  | Threshold liftime peak wind speed if tracks are ordered by lifetime maximum wind speed
    cspline='n';      %     'n'   |   -   | Fit cubic spline to track? ('y' or 'n')
    trackres=0.5;     %     0.5   | hours | Time resolution in cubic spline fit (must be 6 or less)
    thick=3;          %      3    |  pt   | Thickness of track line for single track plots
    twidth=0.5;       %     0.5   |  pt   | Thickness of track line for multiple track plots
    tcolor='b';       %     'b'   |   -   | Color of track if colorcoded = 0
    colorcoded=2;     %      2    |   -   | Track coloring for single track plots. See footnote #1 at bottom of this file
    colorscheme=3;    %      3    |   -   | Track coloring scheme for multiple track plots. See footnote #2 at bottom of this file
    cbar='y';         %     'y'   |   -   | Include colorbar for intensity scale? ('y' or 'n')
    trackcolormap='jet';%  'jet'  |   -   | Colormap used for colorcoding of track line
    cplot='y';        %     'y'   |   -   | Include 00 GMT positions? ('y' or 'n')
    afactor=8;        %      8    |   -   | Scaling factor for arrowhead size used in multiple track plots
    ccol=[1 0.1 0.7]; %      -    |   -   | Color of circles (MATLAB options)
    csize=16;         %     16    |  pts  | Circle size (Matlab MarkerSize)
    dplot='y';        %     'y'   |   -  | Plot dates next to 00 GMT positions? ('y' or 'n')
    startdot='y';     %     'y'   |   -  | Place dots at genesis points on multiple track plots? ('y' or 'n')
    textlabel='n';    %     'n'   |   -  | Place track number labels on multiple track plots? ('y' or 'n')
    textcolor='k';    %     'k'   |   -   | Color of date labels (MATLAB options)
    textfontsize=8;   %      8    |  pts  | Fontsize of date labels
    textdfactor=1.2;  %     1.2   |  1.2  | Factor controling distance of text from track curve (0-3)
% Parameters used in storm snapshots (windfield.m and rainfield.m) and in swath maps   
    plottrack='y';    %     'y'   |   -   | Plot storm track?
    dellatlong=0.05;  %    0.05   |degrees| Horizontal resolution of map
    dellatlongs=0.15; %    0.15   |degrees| (Lower) Horizontal resolution of swath maps (should not be less than about 0.15 for most machines)
    radcity=300;      %    300    |   km  | Distance of storm from point of interest beyond which influence of storm is ignored   
    bound='auto';     %   'auto'  |   -   | Automatic (auto) or manual (manu) specification of map bounds
    deltax=5;         %      5    |degrees| Longitudinal distance of map boundaries from storm center if bound = 'auto'
    deltay=4;         %      4    |degrees| Latitudinal distance of map boundaries from storm center if bound = 'auto'
    bxmin=20;         %      -    |degrees| Minimum longitude of map if bounds='manu'
    bxmax=380;        %      -    |degrees| Maximum longitude of map if bounds='manu'
    bymin=-60;        %      -    |degrees| Minimum latitude of map if bounds='manu' 
    bymax=60;         %      -    |degrees| Maximum latitude of map if bounds='manu'
% Genesis, track density, and power dissipation density plot parameters
    tfilter='global'; % 'global'  |   -   | Filter tracks by global lifetime maximum wind speed ('global') or maximum wind at POI ('local')
    peakv=40;         %     40    | knots | Maximum wind speed that must be exceeded for event to be included
    minv=35;          %     35    | knots | Minimum wind speed to be counted in track density plots 
    nmax=1e6;         %    1e6    |   -   | Maximum number of points to include
    genptsize=6;      %      6    |  pts  | Size of points
    genptsizebest=12; %     12    |  pts  | Size of points for best track genesis points
    gres=4;           %      4    |degrees| Resolution of genesis density map
    gresbest=6;       %      6    |degrees| Resolution of best track genesis density maps
    mres=3;           %      3    |degrees| Resolution of track and power dissipation density maps
    mresbest=4;       %      4    |degrees| Resolution of best track density maps
% Track statistics parameters
    vmaxdisp=0;       %     0     | knots | Minimum windspeed to be included in displacement statistics
    mintracks=12;     %    12     |   -   | Minimum number of tracks in grid box to display translation speeds
    tauto='y';        %    'y'    |   -   | If 'y' use whole area covered by tracks
    tlatmin=0.0;      %     -     |degrees| Minimum latitude of area to calculate tracks statistics (if tauto='n')
    tlatmax=23.0;     %     -     |degrees| Maximum latitude of area to calculate tracks statistics (if tauto='n')
    tlongmin=60.0;    %     -     |degrees| Minimum longitude of area to calculate tracks statistics (if tauto='n')
    tlongmax=330.0;   %     -     |degrees| Maximum longitude of area to calculate tracks statistics (if tauto='n')    
    quiv_color='r';   %    'r'    |   -   | Color of quivers on map
% Best track plot properties
    besttckcolor='m'; %     'm'   |   -   | Color of best track overlays on m_map
    besttckcolmp='w'; %     'w'   |   -   | Color of best track overlays on satellite maps
    besttckwidth=0.5; %     0.5   |  pts  | Thickness of best track overlays
    bestafac=8;       %      8    |   -   | Scaling factor governing size of arrowheads on best track overlays
% Parameters used by m_map and/or Matlab Mapping Toolbox
    projection='Robinson';   %    |   -   | Map projection. See matlab mapping toolbox or m_map/map.html for documentation
    gproject='Robinson';    %     |   -   | Map projection used for global plots
    mapmode='manu';   %   'auto'  |   -   | Mode of determining lat-long bounds of map ('auto' or 'manu')
    dellat=4;         %     4     |degrees| Width of latitude buffers relative to storm track limits (affects 'auto' mode only)
    dellong=10;       %    10     |degrees| Width of longitude buffers relative to storm track limits (affects 'auto' mode only)
    longmin=0;      %     -     |degrees| Lower bound on longitude plotted ('manu' mode only, 0 to 360)    
    longmax=360;      %     -     |degrees| Upper bound on longitude plotted ('manu' mode only, 0 to 360)    
    latmin=-10;        %     -     |degrees| Lower bound on latitude plotted ('manu' mode only, -90 to 90)    
    latmax=70;        %     -     |degrees| Upper bound on latitude plotted ('manu' mode only, -90 to 90)    
    axisfont='arial'; %  'arial'  |   -   | Axis label font
    axisfontsize=13;  %     13    |   pt  | Axis label font size
    axisfontweight='bold';% 'bold'|   -   | Axis label font weight    
    gridline='none';  %   'none'  |   -   | Grid line style ('-',':','-.','--', or 'none')
    wfill='y';        %    'y'    |   -   | Use filled contours for genesis, track density, swath, and power dissipation? ('y' or 'n')
    wmap='jet';       %   'jet'   |   -   | MATLAB colormap to use for filled contour plots
    wtrans=0.3;       %    0.3    |   -   | Value of wind contour transparency (0 - 1) used in filled contour plots
    landcolor=[0.6 0.65 0.6]; %   |   -   | Color of land (only effective when no topography contoured)
    oceancolor=[0.8 0.8 0.9]; %   |   -   | Ocean color 
    swap='n';         %    'n'    |   -   | Ocean color - land cover swap ('y' or 'n'). This is sometimes necessary when m_map produces wrong coloring.
    pstates='y';      %    'y'    |   -   | Plot political boundaries? ('y' or 'n') (States only for MATLAB mapping toolbox)
    nations='y';      %    'y'    |   -   | Plot national boundaries? ('y' or 'n') (Nations only for MATLAB mapping toolbox)
    lakes='n';        %    'n'    |   -   | Plot lakes? ('y' or 'n')  (MATLAB mapping toolbox only; quite slow)
    stcolor=[.4 .4 .4];%          |   -   | Color of political boundaries (MATLAB color options)
    nacolor=[.4 .4 .4];%          |   -   | Color of national political boundaries (MATLAB mapping toolbox only)
    cres=2;           %     2     |   -   | Coastline resolution (see footnote #3 at bottom of this file)
    shorecolor=stcolor;%  stcolor |   -   | Color of shoreline ('none' or MATLAB color options)
    tres=1;           %     1     |   -   | Resolution of topography/bathymetry. See footnote #4 at bottom of this file
    cbath='n';        %    'n'    |   -   | Contour bathymetry? ('y' or 'n')
    bfill='n';        %    'n'    |   -   | Filled bathymetry? ('y' or 'n')
    bathcolor='jet';  %   'jet'   |   -   | Colormap for bathymetry
    blevels=-8000:500:-500; %     |   m   | Bathymetry contour levels 
    ctopo='n';        %    'n'    |   -   | Contour topography? ('y' or 'n')
    tfill='n';        %    'n'    |   -   | Filled topography? ('y' or 'n')
    topocolor='summer';     %     |   -   | Colormap for topography
    tlevels=[250 500 750 1000]; % |   m   | Topography contour levels
% Parameters special to track plotting with satellite map background
    imageres='low';   %    'low'  |   -   | Background image resolution (low, high, or alt1)
    displacement=20;  %      20   |   -   | Displacement of east (right) edge of map eastward from Greenwich Meridian (depends on which image used)
    bfac=0.2;         %     0.2   |   -   | Factor governing size of boundary around map
    textcolorsat='y'; %     'y'   |   -   | Color of date labels (MATLAB options) for satellite map background
    textfsizesat=8;   %      8    |  pts  | Fontsize of date labels
    textdfacsat=1.2;  %     1.2   |   -   | Factor controling distance of text from track curve (0-3)
    incr=20;          %      20   |degrees| Lat-long increment in map background grid
    gridlstyle='none';%    'none' |   -   | Background grid linestyle
    glinewidth=0.5;   %     0.5   |  pts  | Background grid line width
    gridcolor='b';    %     'b'   |   -   | Background grid color
%--------------------------------------------------------------------------
%   Footnotes
%
% 1: Line color coding by intensity (0 for none, 1 for modified Safir-Simpson, 2
%    for continuous). Modified Safir-Simpson has five categories and sub-hurricane
%    category; lower limits of categories 1 and 5 are same as normal Safir-Simspon,
%    but category boundaries are in equal increments of v^2. For continuous curve,
%    color range is linear in v, from minimum of 15 m/s to maximum of 80 m/s.
%
% 2: Set to 0 for alternating track colors; 1 for single color, 2 for modified
%    Saffir-Simpson scale, or 3 for continuous color coded by wind speed
%                       
% 3: Use 0 for none, 1 for very low, 2 for low, 3 for medium,4 for high
%    Note that higher resolution takes more memory and CPU and slows down the plot
%    You must separately download high resolution data bases for choices 3
%    and 4. See m_map/map.html.
%
% 4: Use 1 for low, 2 for high. Note that you must separately download high
%    resolution data base for choice 2. See m_map/map.html. 
%
% 5: The program was changed January 30, 2017 to include a magnification
%    factor for the storm geometry. Here we set magfac equal to its 
%    previous value of 2 for any date before that. 
%--------------------------------------------------------------------------
if exist('./stats.txt','file') 
    clear dir
    FileInfo = dir('./stats.txt');
    TimeStamp = FileInfo.datenum;
    if exist('TimeStamp','var') && TimeStamp < 736725  % Date number corresponding to 1-30-2017
        magfac=2;
    end
end
%
% Specify units factors and units labels
%
wunitsfac=1;
wunitslabel='knots';
if strcmp(wunits,'mph')
    wunitsfac=1.15078;
    wunitslabel='MPH';
elseif strcmp(wunits,'kmh')
    wunitsfac=1.852;
    wunitslabel='km/hr';
end    
runitsfac=1;
runitslabel='mm';
if strcmp(runits,'in')
    runitsfac=0.0393701;
    runitslabel='inches';
end    
%    
