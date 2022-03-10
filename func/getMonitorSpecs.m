function [MonitorSpecs] = getMonitorSpecs(MonitorSelection)
switch MonitorSelection
    case 1 % Dell-Monitor EEG-Labor
    MonitorSpecs.width     = 530; % in mm
    MonitorSpecs.height    = 295; % in mm
    MonitorSpecs.distance  = 600;%810; % in mm
    MonitorSpecs.xResolution = 2560; % x resolution
    MonitorSpecs.yResolution = 1440;  % y resolution
    MonitorSpecs.refresh     = 120;  % refresh rate
    MonitorSpecs.PixelsPerDegree = round((2*(tan(2*pi/360*(1/2))*MonitorSpecs.distance))/(MonitorSpecs.width / MonitorSpecs.xResolution)); % pixel per degree of visual angle
    case 2 % alter Belinea-Monitor Büro
    MonitorSpecs.width     = 390; % in mm
    MonitorSpecs.height    = 290; % in mm
    MonitorSpecs.distance  = 600; % in mm
    MonitorSpecs.xResolution = 1280; % x resolution
    MonitorSpecs.yResolution = 1024;  % y resolution
    MonitorSpecs.refresh     = 60;  % refresh rate
    MonitorSpecs.PixelsPerDegree = round((2*(tan(2*pi/360*(1/2))*MonitorSpecs.distance))/(MonitorSpecs.width / MonitorSpecs.xResolution)); % pixel per degree of visual angle
    case 3 % neuer Monitor Büro, Dell P2210
    MonitorSpecs.width     = 470; % in mm
    MonitorSpecs.height    = 295; % in mm
    MonitorSpecs.distance  = 600; % in mm
    MonitorSpecs.xResolution = 1680; % x resolution
    MonitorSpecs.yResolution = 1050;  % y resolution
    MonitorSpecs.refresh     = 60;  % refresh rate
    MonitorSpecs.PixelsPerDegree = round((2*(tan(2*pi/360*(1/2))*MonitorSpecs.distance))/(MonitorSpecs.width / MonitorSpecs.xResolution)); % pixel per degree of visual angle
    MonitorSpecs.ScreenNumber    = 2;
    case 4 % Monitor Home Office, LG 24BK750Y-B, 24-inch
    MonitorSpecs.width     = 530; % in mm
    MonitorSpecs.height    = 295; % in mm
    MonitorSpecs.distance  = 600; % in mm
    MonitorSpecs.xResolution = 1920; % x resolution
    MonitorSpecs.yResolution = 1080;  % y resolution
    MonitorSpecs.refresh     = 60;  % refresh rate
    MonitorSpecs.PixelsPerDegree = round((2*(tan(2*pi/360*(1/2))*MonitorSpecs.distance))/(MonitorSpecs.width / MonitorSpecs.xResolution)); % pixel per degree of visual angle
    MonitorSpecs.ScreenNumber    = 1;
    case 5 % Alex Notebook HP Elitebook 850 6G
    MonitorSpecs.width     = 345; % in mm
    MonitorSpecs.height    = 195; % in mm
    MonitorSpecs.distance  = 600; % in mm
    MonitorSpecs.xResolution = 1920; % x resolution
    MonitorSpecs.yResolution = 1080;  % y resolution
    MonitorSpecs.refresh     = 60;  % refresh rate
    MonitorSpecs.PixelsPerDegree = round((2*(tan(2*pi/360*(1/2))*MonitorSpecs.distance))/(MonitorSpecs.width / MonitorSpecs.xResolution)); % pixel per degree of visual angle
    MonitorSpecs.ScreenNumber    = 0;
end
end
