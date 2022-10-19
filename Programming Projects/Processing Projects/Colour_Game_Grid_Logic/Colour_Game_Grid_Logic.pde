
grid masterGrid;

void setup(){
    fullScreen();
    rectMode(CENTER);
    
    masterGrid = new grid(1000, new PVector(width/2,height/2));
    masterGrid.subdivide(1);
}

void draw(){
    clear();
    background(255);

    masterGrid.drawme();
}


void mouseClicked(){
  masterGrid.getMouseCollided().subdivide(1);
}
