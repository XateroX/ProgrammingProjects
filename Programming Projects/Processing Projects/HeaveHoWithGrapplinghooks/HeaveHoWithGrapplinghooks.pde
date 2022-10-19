// Player
player player1;
boolean canThrow;
boolean launchMode;
boolean stuckMode;

// Env variables
float mapHeight;
float groundBuffer;

int n_objs;
ArrayList<PVector> obj_points;


// Screen variables
float screenScroll;
PVector mouse;
PVector M1;

boolean mouseHeld;
int mouseHeldCounter;

void setup(){
    //size(500,1000);
    fullScreen();

    mouseHeld        = false;
    mouseHeldCounter = 0;
    mouse            = new PVector(0,0);
    M1               = new PVector(0,0);

    player1    = new player();
    canThrow   = false;
    launchMode = false;
    stuckMode  = false;

    mapHeight    = height*10;
    groundBuffer = width/5;

    screenScroll = 0;

    n_objs     = 100;
    obj_points = new ArrayList<PVector>();
    obj_points = generate_new_obj_points(n_objs);

    rectMode(CENTER);
    imageMode(CENTER);
}


void draw(){
    clear();
    background(200,200,200);

    mouse = new PVector(mouseX,mouseY);

    screenScroll+=0;
    translate(0,screenScroll);

    player1.iterate();

    // Decide if the game player should enter launching mode 
    // and otherwise increment the timer

    if (mouseHeld){
        mouseHeldCounter++;
    }
    if ((mouseHeldCounter > frameRate/5)  && (dist(mouse.x,mouse.y, M1.x,M1.y)<height/10)){
        mouseHeld = false;
        canThrow  = false;

        launchMode = true;
    }


    /*
    pushMatrix();
    translate(width/2,height);
    fill(100,255,100);
    scale(round((width/5) / 100));
    rect(0,0,width,groundBuffer);
    popMatrix();
    
    pushMatrix();
    translate(0,height);
    for (PVector objCenter : obj_points){
        pushMatrix();
        translate(objCenter.x,-objCenter.y);
        fill(200,100,100);
        noStroke();
        scale(round((width/5) / 100));
        rect(0,0,100,100);
        popMatrix();
    }
    popMatrix();
    */

    
    player1.drawme();
}




// Generate the random points for the terrain
ArrayList<PVector> generate_new_obj_points(int n){
    ArrayList<PVector> n_obj_points = new ArrayList<PVector>();

    for (int i = 0; i < n; i++){
        n_obj_points.add( new PVector(random(width),random(groundBuffer,mapHeight)) );
    }

    return n_obj_points;
}




void mousePressed(){
    mouseHeld = true;
    canThrow  = true;

    M1 = new PVector(mouseX,mouseY);
    mouseHeldCounter = 0;
}
void mouseReleased(){
    mouseHeld = false;

    if (canThrow){
        if (dist(M1.x,M1.y,mouse.x,mouse.y) > height/10){
            PVector normDir = new PVector(0,0);
            normDir.x = mouse.x-M1.x;
            normDir.y = mouse.y-M1.y;
            normDir.setMag(30);
            player1.velBall.x = normDir.x;
            player1.velBall.y = normDir.y;
        }
    }
    if (launchMode){
        player1.launchBall();
        launchMode = false;
    }
}
