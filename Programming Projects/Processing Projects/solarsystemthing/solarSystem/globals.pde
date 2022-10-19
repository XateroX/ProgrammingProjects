float G  = 6.67 * pow(10,-11);  //In metres
float AU = 1.50 * pow(10, 11);

PVector camPos = new PVector(0,0,0);
float camDist     = 500;//10.0 * AU;
float camDistStep = 10.0;
boolean camXu = false;
boolean camXd = false;
boolean camYu = false;
boolean camYd = false;
boolean camZoomIn       = false;
boolean camZoomOut      = false;
boolean scaleZoomIn     = false;
boolean scaleZoomOut    = false;

boolean showAxis    = false;
boolean showHotkeys = false;

float stdSize  = 4.0;           //Take logs of relative size for radius*by this, where the radius is 10.0 for Earth
float unitConv = 25.0 / AU;     // 1 pixel = 0.04*AU e.g Earth is 25 pixels from sun => converts from m to pixels
int celestialBodyTypeNum = 3;
int frameSkip   = 1000;
int frameWanted = 1000000;
int frameTicker = 0;

PVector trackedObject   = new PVector(0,0);
boolean tracking        = false;
boolean showTracking    = true;

float camStep = 5.0 / unitConv;

int timeFactor = 4;
float timeScale = 1.0*pow(10,timeFactor);

PVector sunCol     = new PVector(245,140,40);
PVector mercuryCol = new PVector(180,180,150);
PVector venusCol   = new PVector(210,210,200);
PVector earthCol   = new PVector(90,180,140);
PVector marsCol    = new PVector(200,90,60);
PVector jupiterCol = new PVector(230,220,150);
PVector saturnCol  = new PVector(240,230,180);
PVector uranusCol  = new PVector(160,210,210);
PVector neptuneCol = new PVector(80,100,220);
PVector plutoCol   = new PVector(150,160,90);
PVector moonCol    = new PVector(255,255,255);

/*
MVEMJSUNP
Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto

Catalogue;
-------
-STARS-
-------
Sun;    mass    = 1.989*10^30 kg
        radius  = 6.96*10^8 m
        ...
---------
-PLANETS-
---------
Mercury;mass    = 3.29*10^23 kg
        radius  = 2.44*10^6 m
        ...
Venus;  mass    = 4.87*10^24 kg
        radius  = 6.05*10^6 m
        ...
Earth;  mass    = 5.97*10^24 kg
        radius  = 6.37*10^6 m
        ...
Mars;   mass    = 6.39*10^23 kg
        radius  = 3.39*10^6 m
        ...
Jupiter;mass    = 1.90*10^27 kg
        radius  = 6.99*10^7 m
        ...
Saturn; mass    = 5.68*10^26 kg
        radius  = 5.82*10^7 m
        ...
Uranus; mass    = 8.68*10^25 kg
        radius  = 2.54*10^7 m
        ...
Neptune;mass    = 1.02*10^26 kg
        radius  = 2.46*10^7 m
        ...
Pluto;  mass    = 1.31*10^22 kg
        radius  = 1.19*10^6 m
        ...
-------
-MOONS-
-------
Moon;   mass    = 7.35*10^22 kg
        radius  = 1.74*10^6 m
        ...
*/