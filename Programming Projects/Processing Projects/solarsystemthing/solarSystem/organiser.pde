/*
Functions related to;
0. Misc
1. CelestialBodies
2. Moons
3. Planets
4. Stars
5. ...
*/

//0
void simRun1(){
    //Regular
    camera( toPixelConversion(camPos.x),toPixelConversion(camPos.y),camDist,  toPixelConversion(camPos.x),toPixelConversion(camPos.y),0,  0,1,0);

    drawBackground();
    if(showAxis){
        drawAxis();}

    calcCelestialBodies();
    drawCelestialBodies();
    celestialTracker();
    updateCamPos();

    if(showHotkeys){
        overlay();}
}
void simRun2(){
    //Faster
    camera( toPixelConversion(camPos.x),toPixelConversion(camPos.y),camDist,  toPixelConversion(camPos.x),toPixelConversion(camPos.y),0,  0,1,0);

    drawBackground();
    drawAxis();

    for(int i=0; i<frameSkip; i++){
        calcCelestialBodies();
    }
    drawCelestialBodies();
    updateCamPos();

    overlay();
}
void simRun3(){
    //Skip time
    
    for(int i=0; i<frameSkip; i++){
        calcCelestialBodies();
        frameTicker++;
    }

    if(frameTicker > frameWanted)
    {
        camera( toPixelConversion(camPos.x),toPixelConversion(camPos.y),camDist,  toPixelConversion(camPos.x),toPixelConversion(camPos.y),0,  0,1,0);

        drawBackground();
        drawAxis();
        drawCelestialBodies();
        updateCamPos();

        overlay();
    }
}





float vecMag(PVector v){
    float mag = sqrt( pow(v.x, 2) + pow(v.y,2) + pow(v.z,2) );
    return mag;
}
float vecDist(PVector v1, PVector v2){
    float dist = sqrt( pow(v1.x - v2.x, 2) + pow(v1.y - v2.y,2) + pow(v1.z - v2.z,2) );
    return dist;
}
PVector vecNormalise(PVector v){
    float mag = vecMag(v);
    PVector newVec = new PVector(v.x /mag, v.y /mag, v.z /mag);
    return newVec;
}
float logAdapted(float val){
    float logVal;
    if(val == 0){
        return -1.0*pow(10,30);  //### EXTREMELY QUESTIONABLE
    }
    else if(val < 0){
        return -1.0*log(abs(val));
    }
    else{
        return log(val);
    }
}





void drawBackground(){
    background(30,30,30);
}
void overlay(){
    pushStyle();

    fill(255);
    text("FrameRate -> "+frameRate                , 30, 20);
    text("Hotkeys                                ", 30, 40);
    text("-------                                ", 30, 60);
    text("wasd ->* pan camera                    ", 30, 80);
    text("qe   ->* axis zoom (Not Recommended)   ", 30, 100);
    text("1,3  ->* Scalar zoom (Recommended)     ", 30, 120);
    text("x,z  ->* Change time scale             ", 30, 140);
    text("t    ->  Tracked selected              ", 30, 160);
    text("g    ->  Hide tracked                  ", 30, 180);
    text("y    ->  Change tracked                ", 30, 200);
    text("0    ->  Toggle axis                   ", 30, 220);
    text("9    ->  Show hotkeys                  ", 30, 240);
    text("Note; at large time skips planets go crazy from bad estimations", 30, 260);

    popStyle();
}
float toPixelConversion(float realDist){
    /*
    Converts real values (metres) to pixel values (e.g 1*10^6 m = 100 pixels)
    */
    float pixelDist = unitConv * realDist;
    return pixelDist;
}





void updateCamPos(){
    camStep = 5.0 / unitConv;
    if(camYu){
        camPos.y += camStep;}
    if(camYd){
        camPos.y -= camStep;}
    if(camXu){
        camPos.x += camStep;}
    if(camXd){
        camPos.x -= camStep;}
    if(camZoomIn){
        camDist  += camDistStep;}
    if(camZoomOut){
        camDist  -= camDistStep;}
    if(scaleZoomIn){
        unitConv *= 1.1;}
    if(scaleZoomOut){
        unitConv /= 1.1;}
}
void drawAxis(){
    drawXaxis();
    drawYaxis();
    drawZaxis();
}
void drawXaxis(){
    pushStyle();
    float xMax = toPixelConversion( 40.0*AU);
    float xMin = toPixelConversion(-40.0*AU);
    float xStep= toPixelConversion( 1.0 *AU);
    stroke(255,0,0);
    noFill();
    textSize(20.0);
    for(float i=xMin; i<xMax; i+=xStep){
        pushMatrix();
        translate(i,0,0);
        box(10);
        popMatrix();
    }
    popStyle();
}
void drawYaxis(){
    pushStyle();
    float yMax = toPixelConversion( 40.0*AU);
    float yMin = toPixelConversion(-40.0*AU);
    float yStep= toPixelConversion( 1.0 *AU);
    stroke(0,255,0);
    noFill();
    textSize(20.0);
    for(float i=yMin; i<yMax; i+=yStep){
        pushMatrix();
        translate(0,i,0);
        box(10);
        popMatrix();
    }
    popStyle();
}
void drawZaxis(){
    pushStyle();
    float zMax = toPixelConversion( 40.0*AU);
    float zMin = toPixelConversion(-40.0*AU);
    float zStep= toPixelConversion( 1.0 *AU);
    stroke(0,0,255);
    noFill();
    textSize(20.0);
    for(float i=zMin; i<zMax; i+=zStep){
        pushMatrix();
        translate(0,0,i);
        box(10);
        popMatrix();
    }
    popStyle();
}


void celestialTracker(){
    showTrackedObject();
    trackToObject();
}
void showTrackedObject(){
    if(showTracking){
        pushMatrix();
        pushStyle();

        println("T-obj; ",trackedObject);
        rectMode(CENTER);
        PVector coords = new PVector( toPixelConversion(celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.x), toPixelConversion(celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.y), toPixelConversion(celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.z) );
        float length = 10.0;
        float theta  = ( (frameCount/60.0)*PI ) / 6.0;
        stroke(255,0,0);
        strokeWeight(3);
        noFill();

        centeredTriangle(coords, length, theta);

        popStyle();
        popMatrix();
    }
}
void trackToObject(){
    if(tracking){
        camPos.x = celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.x;
        camPos.y = celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.y;
        //camPos.z = celestialBodies.get(int(trackedObject.x)).get(int(trackedObject.y)).pos.z;
    }
}
void centeredTriangle(PVector center, float l, float theta){
    translate( toPixelConversion(center.x), toPixelConversion(center.y), toPixelConversion(center.z) );

    rect(center.x, center.y, l, l);
}


//1
void initialiseCelestialBodies(){
    for(int i=0; i<celestialBodyTypeNum; i++){ //## for # of celestial bodies available, CHANGE if more added
        celestialBodies.add( new ArrayList<celestialBody>() );
    }
}
void solarSystemSim1(){
    /*
    Our solar system, MerVenuEarMarsJupitSaturUranNeptPluto
    */
    float mercuryAng    = 1.0*PI/3.0;   float mercurySpd    = 4.8*pow(10,4);
    float venusAng      = 2.0*PI/3.0;   float venusSpd      = 3.4*pow(10,4);
    float earthAng      = 0;            float earthSpd      = 3.0*pow(10,4); float moonSpd = 1.035*pow(10,3);
    float marsAng       = 3.0*PI/3.0;   float marsSpd       = 2.2*pow(10,4);
    float jupiterAng    = 4.0*PI/3.0;   float jupiterSpd    = 1.2*pow(10,4);
    float saturnAng     = 4.0*PI/3.0;   float saturnSpd     = 1.0*pow(10,4);
    float uranusAng     = 2.0*PI/3.0;   float uranusSpd     = 6.9*pow(10,3);
    float neptuneAng    = 5.0*PI/3.0;   float neptuneSpd    = 5.3*pow(10,3);
    float plutoAng      = 0;            float plutoSpd      = 4.7*pow(10,3);
    createMoon(  "Moon"   ,moonCol     ,   new PVector(1.001974*AU*cos(earthAng),1.001974*AU*sin(earthAng),0),  new PVector(-moonSpd       *sin(earthAng), (moonSpd+earthSpd)*cos(earthAng),0), new PVector(0,0,0), 7.35*pow(10,22), 1.74*pow(10,6) );//Moon
    createPlanet("Mercury", mercuryCol ,   new PVector(0.39*AU*cos(mercuryAng), 0.39*AU*sin(mercuryAng),0),    new PVector( -mercurySpd   *sin(mercuryAng),  mercurySpd   *cos(mercuryAng),0), new PVector(0,0,0), 3.29*pow(10,23), 2.44*pow(10,6) );//Mercury
    createPlanet("Venus"  , venusCol   ,   new PVector(0.71*AU*cos(venusAng  ), 0.71*AU*sin(venusAng  ),0),    new PVector( -venusSpd     *sin(venusAng  ),  venusSpd     *cos(venusAng  ),0), new PVector(0,0,0), 4.87*pow(10,24), 6.05*pow(10,6) );//Venus
    createPlanet("Earth"  , earthCol   ,   new PVector(1.00*AU*cos(earthAng  ), 1.00*AU*sin(earthAng  ),0),    new PVector( -earthSpd     *sin(earthAng  ),  earthSpd     *cos(earthAng  ),0), new PVector(0,0,0), 5.97*pow(10,24), 6.37*pow(10,6) );//Earth
    createPlanet("Mars"   , marsCol    ,   new PVector(1.37*AU*cos(marsAng   ), 1.37*AU*sin(marsAng   ),0),    new PVector( -marsSpd      *sin(marsAng   ),  marsSpd      *cos(marsAng   ),0), new PVector(0,0,0), 6.39*pow(10,23), 3.39*pow(10,6) );//Mars
    createPlanet("Jupiter",jupiterCol  ,   new PVector( 4.89*AU*cos(jupiterAng), 4.89*AU*sin(jupiterAng),0),    new PVector( -jupiterSpd   *sin(jupiterAng),  jupiterSpd   *cos(jupiterAng),0), new PVector(0,0,0), 1.90*pow(10,27), 6.99*pow(10,7) );//Jupiter
    createPlanet("Saturn" , saturnCol  ,   new PVector(9.71*AU*cos(saturnAng ), 9.71*AU*sin(saturnAng ),0),    new PVector( -saturnSpd    *sin(saturnAng ),  saturnSpd    *cos(saturnAng ),0), new PVector(0,0,0), 5.68*pow(10,26), 5.82*pow(10,7) );//Saturn
    createPlanet("Uranus" ,uranusCol   ,   new PVector(19.38*AU*cos(uranusAng ),19.38*AU*sin(uranusAng ),0),    new PVector(-uranusSpd     *sin(uranusAng ), uranusSpd     *cos(uranusAng ),0), new PVector(0,0,0), 8.68*pow(10,25), 2.54*pow(10,7) );//Uranus
    createPlanet("Neptune",neptuneCol  ,   new PVector(29.44*AU*cos(neptuneAng),29.44*AU*sin(neptuneAng),0),    new PVector(-neptuneSpd    *sin(neptuneAng), neptuneSpd    *cos(neptuneAng),0), new PVector(0,0,0), 1.02*pow(10,26), 2.46*pow(10,7) );//Neptune
    createPlanet("Pluto"  ,plutoCol    ,   new PVector(38.82*AU*cos(plutoAng  ),38.82*AU*sin(plutoAng  ),0),    new PVector(-plutoSpd      *sin(plutoAng  ), plutoSpd      *cos(plutoAng  ),0), new PVector(0,0,0), 1.31*pow(10,22), 1.19*pow(10,6) );//Pluto
    createStar(  "Sun"    , sunCol     ,   new PVector(0,     0,0),    new PVector(0,0,0), new PVector(0,0,0), 1.99*pow(10,30), 6.96*pow(10,8) );//Sun
    
}
void calcCelestialBodies(){
    for(int i=0; i<celestialBodies.size(); i++){
        for(int j=0; j<celestialBodies.get(i).size(); j++){
            celestialBodies.get(i).get(j).updateVals();
        }
    }
    for(int i=0; i<celestialBodies.size(); i++){
        for(int j=0; j<celestialBodies.get(i).size(); j++){
            celestialBodies.get(i).get(j).updatePos();
        }
    }
}
void drawCelestialBodies(){
    for(int i=0; i<celestialBodies.size(); i++){
        for(int j=0; j<celestialBodies.get(i).size(); j++){
            celestialBodies.get(i).get(j).display();
        }
    }
}


//2
void createMoon(String name, PVector col, PVector pos, PVector vel, PVector acc, float m, float r){
    moon newMoon = new moon(name, col, pos, vel, acc, m, r);
    celestialBodies.get(0).add(newMoon);
}


//3
void createPlanet(String name, PVector col, PVector pos, PVector vel, PVector acc, float m, float r){
    planet newPlanet = new planet(name, col, pos, vel, acc, m, r);
    celestialBodies.get(1).add(newPlanet);
}


//4
void createStar(String name, PVector col, PVector pos, PVector vel, PVector acc, float m, float r){
    star newStar = new star(name, col, pos, vel, acc, m, r);
    celestialBodies.get(2).add(newStar);
}


//5
//pass
