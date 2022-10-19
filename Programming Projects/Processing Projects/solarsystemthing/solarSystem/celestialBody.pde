class celestialBody{
    String name;
    PVector col;
    PVector acc;
    PVector vel;
    PVector pos;
    float m;
    float r;

    ArrayList<trailer> trailPoints = new ArrayList<trailer>();

    int ID = floor(random(10000000, 99999999));

    celestialBody(String objectName, PVector colour, PVector position, PVector velocity, PVector acceleration, float mass, float radius){
        name = objectName;
        col = colour;
        pos = position;
        vel = velocity;
        acc = acceleration;
        m = mass;
        r = radius;
    }

    void display(){
        //pass
    }
    void displayTrail(){
        if(trailPoints.size() > 0)
        {
            pushStyle();
            noFill();
            strokeWeight(3);

            beginShape();
            curveVertex( toPixelConversion(trailPoints.get(0).pos.x), toPixelConversion(trailPoints.get(0).pos.y) );
            for(int i=0; i<trailPoints.size(); i++){
                stroke(col.x, col.y, col.z, 255.0*( 1.0 -((float)trailPoints.get(i).lifeCurrent / (float)trailPoints.get(i).lifeFinal)));
                curveVertex( toPixelConversion(trailPoints.get(i).pos.x), toPixelConversion(trailPoints.get(i).pos.y) );
            }
            curveVertex( toPixelConversion(trailPoints.get( trailPoints.size()-1 ).pos.x), toPixelConversion(trailPoints.get( trailPoints.size()-1 ).pos.y) );
            endShape();

            popStyle();
        }
    }
    void displayStats(){
        /*
        1. Object Name
        2. Radius
        3. Mass
        4. Distance from sun
        5. Velocity
        */
        pushMatrix();
        pushStyle();

        PVector statMenuUL = new PVector( 1.5*toPixelConversion(r), -0.8*toPixelConversion(r), 0 );
        float statMenuInc  = toPixelConversion(r)/6.0;
        fill(255,255,255);  //## COULD ADD SOME FADE IN EFFECT WITH ALPHA
        textSize(statMenuInc);
        textAlign(LEFT);

        text(name                                                                   , statMenuUL.x, statMenuUL.y + 0.0*statMenuInc);
        text("Radius; "+ r                                                  +" m"       , statMenuUL.x, statMenuUL.y + 1.0*statMenuInc);
        text("Mass  ; "+ m                                                  +" kg"      , statMenuUL.x, statMenuUL.y + 2.0*statMenuInc);
        if(celestialBodies.get(2).size() > 0){
        text("Orbit ; "+ vecDist( pos, celestialBodies.get(2).get(0).pos )  +" m"       , statMenuUL.x, statMenuUL.y + 3.0*statMenuInc);}
        text("Vel   ; "+ vecMag(vel)                                        +" ms^-1"   , statMenuUL.x, statMenuUL.y + 4.0*statMenuInc);

        popStyle();
        popMatrix();
    }
    void calcTrails(){
        //Place new points
        int placeStep = 3;
        if(frameCount % placeStep == 0){
            trailer newTrailer = new trailer(new PVector(pos.x, pos.y));
            trailPoints.add( newTrailer );
        }

        //Remove old points
        for(int i=0; i<trailPoints.size(); i++){
            if(i < trailPoints.size()){
                trailPoints.get(i).updateLife();
                if(!trailPoints.get(i).alive){
                    trailPoints.remove(i);
                }
            }
            else{
                break;
            }
        }
    }
    void updateVals(){
        calcAcc();
        calcVel();
        calcTrails();
    }
    void updatePos(){
        calcPos();
    }
    void calcAcc(){
         /*
        0. Reset force value
        1. Calculate each component's addition to the force, each frame
        */
        //0
        acc.x = 0;
        acc.y = 0;
        acc.z = 0;

        //1.1 -> Gravitational
        //F = -GMm/r^2
        for(int i=0; i<celestialBodies.size(); i++){
            for(int j=0; j<celestialBodies.get(i).size(); j++){
                if( celestialBodies.get(i).get(j).ID != ID ){
                    /*
                    1. Find direction of this body TO other body
                    2. Find magnitude of subAcc
                    3. Find component of subAcc in each direction
                    4. Increase acc by subAcc
                    */
                    //1
                    PVector vDir = new PVector(celestialBodies.get(i).get(j).pos.x -pos.x, celestialBodies.get(i).get(j).pos.y -pos.y, celestialBodies.get(i).get(j).pos.z -pos.z);
                    PVector nDir = vecNormalise(vDir);
                    //2
                    float vDist = vecMag(vDir);
                    float aMag  = exp( log(G) + log(celestialBodies.get(i).get(j).m) - 2.0*logAdapted(vDist) );    //## Logs not even needed here using this method
                    //3
                    PVector subAcc = new PVector(aMag*nDir.x, aMag*nDir.y, aMag*nDir.z);
                    //4
                    acc.x += subAcc.x;
                    acc.y += subAcc.y;
                    acc.z += subAcc.z;

                }
            }
        }

        //1.2 -> ...
        //pass
    }
    void calcVel(){
        vel.x += acc.x *timeScale;
        vel.y += acc.y *timeScale;
        vel.z += acc.z *timeScale;
    }
    void calcPos(){
        pos.x += vel.x *timeScale;
        pos.y += vel.y *timeScale;
        pos.z += vel.z *timeScale;
    }
}

class trailer{
    PVector pos;

    int lifeCurrent = 0;
    int lifeFinal   = 10*60;

    boolean alive = true;

    trailer(PVector position){
        pos = position;
    }

    void updateLife(){
        lifeCurrent++;
        if(lifeCurrent >= lifeFinal){
            alive = false;
        }
    }
}