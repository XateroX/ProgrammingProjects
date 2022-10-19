class character{
    PVector pos     = new PVector(0,0);
    PVector dim     = new PVector(0,0);
    PVector hmPos   = new PVector(0,0);

    int cType;  //Character type
    String name;

    boolean hitCounted = false;
    boolean hasHit = false;
    int hitTime = 0;

    float drawSpeed; //Probability of drawing on a given frame, after min human reaction time
    float moveSpeed;
    int botTimer = 0;
    float whiffProb = 0.0001;

    character(){
        //pass
    }

    void display(){
        //pass
    }
    void calcBotAi(){
        if(!hasHit){
            //Play hit properly
            if(indicatorSent && !roundOver){

                if(botTimer >= minReactionTime){
                    float rVal1 = random(0.0, 1.0);
                    if(rVal1 < drawSpeed){
                        //Hit goes through
                        hasHit = true;
                    }
                }
                botTimer++;
            }
            //Whiff a hit prob
            float rVal2 = random(0.0, 1.0);
            if(rVal2 < whiffProb){
                hasHit = true;
            }
        }
    }
}
class drifter extends character{
    //pass

    drifter(){
        cType = 0;
        name = "Drifter";
    }

    @Override
    void display(){
        /*
        ## NEEDS AN ANIMATED TEXTURE ##
        */
        pushStyle();

        imageMode(CENTER);

        image(characterPlate, pos.x, pos.y +3.0*dim.y/10.0, 1.5*dim.x, 1.5*dim.y);
        image(drifterBackStatic, pos.x, pos.y, dim.x, dim.y);

        if(hasHit){
            image(hitMarker, pos.x +hmPos.x, pos.y +hmPos.y, dim.x/3.0, dim.y/3.0);
        }

        popStyle();
    }
}
class botPrime extends character{
    //pass

    botPrime(){
        cType = 1;
        name = "Bot-Prime";
    }

    @Override
    void display(){
        /*
        ## NEEDS AN ANIMATED TEXTURE ##
        */
        pushStyle();

        imageMode(CENTER);

        image(characterPlate, pos.x, pos.y +3.0*dim.y/10.0, 1.5*dim.x, 1.5*dim.y);
        image(botPrimeFrontStatic, pos.x, pos.y, dim.x, dim.y);

        if(hasHit){
            image(hitMarker, pos.x +hmPos.x, pos.y +hmPos.y, dim.x/3.0, dim.y/3.0);
        }

        popStyle();
    }
}
class monk extends character{
    //pass

    monk(){
        cType = 2;
        name = "Monk";
    }

    @Override
    void display(){
        /*
        ## NEEDS AN ANIMATED TEXTURE ##
        */
        pushStyle();

        imageMode(CENTER);

        image(characterPlate, pos.x, pos.y +3.0*dim.y/10.0, 1.5*dim.x, 1.5*dim.y);
        image(monkFrontStatic, pos.x, pos.y, dim.x, dim.y);

        if(hasHit){
            image(hitMarker, pos.x +hmPos.x, pos.y +hmPos.y, dim.x/3.0, dim.y/3.0);
        }

        popStyle();
    }
}
class ghost extends character{
    //pass

    ghost(){
        cType = 3;
        name = "Ghost";
    }

    @Override
    void display(){
        /*
        ## NEEDS AN ANIMATED TEXTURE ##
        */
        pushStyle();

        imageMode(CENTER);

        image(characterPlate, pos.x, pos.y +3.0*dim.y/10.0, 1.5*dim.x, 1.5*dim.y);
        image(ghostFrontStatic, pos.x, pos.y, dim.x, dim.y);

        if(hasHit){
            image(hitMarker, pos.x +hmPos.x, pos.y +hmPos.y, dim.x/3.0, dim.y/3.0);
        }

        popStyle();
    }
}
class tire extends character{
    //pass

    tire(){
        cType = 4;
        name = "Tire";
    }

    @Override
    void display(){
        /*
        ## NEEDS AN ANIMATED TEXTURE ##
        */
        pushStyle();

        imageMode(CENTER);

        image(characterPlate, pos.x, pos.y +3.0*dim.y/10.0, 1.5*dim.x, 1.5*dim.y);
        image(tireFrontStatic, pos.x, pos.y, dim.x, dim.y);

        if(hasHit){
            image(hitMarker, pos.x +hmPos.x, pos.y +hmPos.y, dim.x/3.0, dim.y/3.0);
        }

        popStyle();
    }
}