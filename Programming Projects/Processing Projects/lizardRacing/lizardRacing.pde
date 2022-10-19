/*
Build such that can be adapted to C, so processing can just handle display of the simulation
C used to calculate values and store in txt document

NOTES;
------
Currently, most lizards are dying from generateion to generation and so at an nth generation, the population is essentially still random.
Need to give a nudge in the right direction or give easier goals / introduce less spare rewards.

E.G

Distance gives + to score, more + for closer dist, +0 at infinity
Also need to add tanh squishifer function
Do back propogation for 0th lizard that player controls (to create network that matches player actions)

Do a fruit scenario generator
Make so one of the scenarios is just get to large blob in centre

[X] Try with controls being just move L/R/U/D, so no turning is involved
*/
void setup(){
    fullScreen();//size(800,800);

    initStandardNetwork();

    createInitialLizards(lizardNumber, standardSize, standardLength);
    fillFruitPosSets();
    createFruitFlags(fruitNumber, fruitDetectRad);
}
void draw(){
    //situation1();
    situation2();
    //situation3();
}

void keyPressed(){
    //## MOVE THESE INTO ANOTHER FUNCTION TO HANDLE LIZARD CONTROLS ##
    //## OR JUST REMOVE AND USE ONLY AS BUG FIXING ##
    if(key == '1'){
        lowPolyMode = !lowPolyMode;
    }
    if(key == 'w'){
        lizards.get(0).accelerate = true;
    }
    if(key == 's'){
        lizards.get(0).brake = true;
    }
    if(key == 'a'){
        lizards.get(0).turnLeft = true;
    }
    if(key == 'd'){
        lizards.get(0).turnRight = true;
    }
}
void keyReleased(){
    if(key == 'w'){
        lizards.get(0).accelerate = false;
    }
    if(key == 's'){
        lizards.get(0).brake = false;
    }
    if(key == 'a'){
        lizards.get(0).turnLeft = false;
    }
    if(key == 'd'){
        lizards.get(0).turnRight = false;
    }
    if (key == '=')
    {
        frameSkip = ceil((float)frameSkip*1.1);
        println("INCREASE FOR FUCK SAKE");
    }
    if (key == '-')
    {
        frameSkip = floor((float)frameSkip/1.1);
        if (frameSkip <= 1)
        {
            frameSkip = 1;
        }
    }
}
