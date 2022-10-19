PImage baseImage;
PImage baseColourSelector;

PImage unit;

float sw;
float sh;

color col;

float seed = 0;

PImage[] AnimationImages;
int animationLength;
float animationPosition;

void setup(){
    fullScreen();
    imageMode(CENTER);

    baseImage          = loadImage("BaseTemplate.png");
    baseColourSelector = loadImage("baseColourSelector.png");
    unit               = loadImage("unit.png");
    
    sw = 0;
    sh = 0;
    
    col = color( random(255),random(255),random(255) );

    outputFolderContents();
    animationLength = 20;
    animationPosition = 0.0;
}

void draw(){
    clear();
    background(255);

    pushMatrix();
    pushStyle();
    translate(width/2 - 2*width/5, height/2);
    scale(2);
    drawBase();
    popStyle();
    popMatrix();

    
    pushMatrix();
    pushStyle();
    translate(width/2 - 1*width/5, height/2);
    scale(2);
    drawColourSelector();
    popMatrix();
    popStyle();
    
    
    pushMatrix();
    pushStyle();
    translate(width/2, height/2);
    scale(3);
    drawUnit();
    popMatrix();
    popStyle();
    
    /*    
    pushMatrix();
    pushStyle();
    translate(width/2 + width/5, height/2);
    scale(2);
    drawBlackShaddow();
    popMatrix();
    popStyle();
    */


    pushMatrix();
    pushStyle();
    translate(width/2 - width/4, height/2);
    scale(1);
    drawAnimatedObject();
    popMatrix();
    popStyle();
    
    
    pushMatrix();
    pushStyle();
    translate(width/2 + width/4, height/2);
    scale(1);
    drawUnitWalking();
    popMatrix();
    popStyle();
}

void mouseClicked(){
  sw = 0;
  sh = 0;
  
  col = color( random(255),random(255),random(255) );
}
