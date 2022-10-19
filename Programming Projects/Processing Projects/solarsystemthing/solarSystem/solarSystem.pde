//############################   ##################################
//## ADD ASTERIODS + COMETS ##   ## PLANET TRAILS + OTHER TRAILS ##
//############################   ##################################
//##########################################
//## ROCKET EQUATION INCLUSION SOMEHOW??? ##
//##########################################
PFont font;
void setup(){
    fullScreen(P3D);
    //ortho();

    initialiseCelestialBodies();
    solarSystemSim1();

    font = createFont("Courier",16,true);
    textFont(font,18); 
}
void draw(){
    simRun1();
    //simRun2();
    //simRun3();
}
void keyPressed(){
    if(key == 's'){
        camYu = true;}
    if(key == 'w'){
        camYd = true;}
    if(key == 'a'){
        camXd = true;}
    if(key == 'd'){
        camXu = true;}
    if(key == 'q'){
        camZoomIn  = true;}
    if(key == 'e'){
        camZoomOut = true;}
    if(key == '3'){
        scaleZoomIn  = true;}
    if(key == '1'){
        scaleZoomOut = true;}
    if(key == 'x'){
        timeFactor++;
        timeScale = 1.0*pow(10,timeFactor);}
    if(key == 'z'){
        timeFactor--;
        timeScale = 1.0*pow(10,timeFactor);}
    //Tracking
    if(key == 't'){
        tracking = !tracking;
    }
    if(key == 'g'){
        showTracking = !showTracking;
    }
    if(key == 'y'){
        trackedObject.y += 1;
        if(trackedObject.y >= celestialBodies.get(int(trackedObject.x)).size()){
            trackedObject.x += 1;
            trackedObject.y  = 0;
            if(trackedObject.x >= celestialBodies.size()){
                trackedObject.x = 0;
            }
        }
    }
    if(key == '9'){
        showAxis = !showAxis;
    }
    if(key == '0'){
        showHotkeys = !showHotkeys;
    }

}
void keyReleased(){
    if(key == 's'){
        camYu = false;}
    if(key == 'w'){
        camYd = false;}
    if(key == 'a'){
        camXd = false;}
    if(key == 'd'){
        camXu = false;}
    if(key == 'q'){
        camZoomIn  = false;}
    if(key == 'e'){
        camZoomOut = false;}
    if(key == '3'){
        scaleZoomIn  = false;}
    if(key == '1'){
        scaleZoomOut = false;}
}
void mousePressed(){
    calcMouseMovementPressed();
}
void mouseReleased(){
    calcMouseMovementReleased();
}


// TO HELP BE USED ON MOBILE
void calcMouseMovementPressed(){
    if( (mouseY > 2.0*height/3.0) && ( (0<mouseX) && (mouseX<width/4.0) ) ){
        trackedObject.y += 1;
        if(trackedObject.y >= celestialBodies.get(int(trackedObject.x)).size()){
            trackedObject.x += 1;
            trackedObject.y  = 0;
            if(trackedObject.x >= celestialBodies.size()){
                trackedObject.x = 0;
            }
        }
    }
    else if( (mouseY > 2.0*height/3.0) && ( (width/4.0<mouseX) && (mouseX<2.0*width/4.0) ) ){
        tracking = !tracking;
    }
    else if( (mouseY > 2.0*height/3.0) && ( (2.0*width/4.0<mouseX) && (mouseX<3.0*width/4.0) ) ){
        timeFactor--;
        timeScale = 1.0*pow(10,timeFactor);
    }
    else if( (mouseY > 2.0*height/3.0) && ( (3.0*width/4.0<mouseX) && (mouseX<4.0*width/4.0) ) ){
        timeFactor++;
        timeScale = 1.0*pow(10,timeFactor);
    }
    else if(mouseX > width/2.0){
        scaleZoomIn = true;
    }
    else if(mouseX < width/2.0){
        scaleZoomOut = true;
    }
}
void calcMouseMovementReleased(){
    scaleZoomIn  = false;
    scaleZoomOut = false;
}