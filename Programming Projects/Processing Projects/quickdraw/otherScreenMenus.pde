void drawScreenHome(){
    /*
    ## HAVE BUTTONS BE PLACEABLE USING LISTS ##
    */
    pushStyle();

    imageMode(CENTER);
    image(homeCover, width/2.0, height/2.0, width *(sin( (frameCount/(60.0*2.0))%(PI) ) +0.4), height *(sin( (frameCount/(60.0*2.0))%(PI) ) +0.4));

    popStyle();
}


void showRoundResults(){
    //println("Showing round results ...");
    pushStyle();

    PVector rPos = new PVector(width/2.0, height/2.0);
    PVector rDim = new PVector(width/8.0, 8.0*height/10.0);

    imageMode(CENTER);
    rectMode(CENTER);
    fill(230, 142, 135, 200);
    stroke(0);
    strokeWeight(2);
    rect(rPos.x, rPos.y, rDim.x, rDim.y);

    float tSize = width/80.0;
    textSize(tSize);
    textAlign(LEFT);
    fill(255);
    for(int i=0; i<fCharacters.size(); i++){
        text(fCharacters.get(i).name +" -> "+ fCharacters.get(i).hitTime, rPos.x -rDim.x/2.0, rPos.y -rDim.y/2.0 +tSize*(i+1));
    }

    popStyle();
}


void showLoseMenu(){
    pushStyle();

    textAlign(CENTER, CENTER);
    textSize(width/30.0);
    fill(0);
    text("You Lose", width/2.0, height/2.0);

    popStyle();
}


void showPlayerScorings(){
    pushStyle();

    PVector scorePos = new PVector(7.0*width/10.0, 1.0*height/10.0);

    fill(0);

    if(typeBots){
        float tSize = width/30.0;
        textSize(tSize);
        if(playerTurn < playerScores.size()){
            text(playerScores.get(playerTurn), scorePos.x, scorePos.y);
        }
    }
    if(typePlayer){
        float tSize = width/60.0;
        textSize(tSize);
        for(int i=0; i<playerScores.size(); i++){
            text("Player "+i+"; "+playerScores.get(i), scorePos.x -10.0*i*tSize, scorePos.y);
        }
    }
    if(typeAuto){
        float tSize = width/30.0;
        textSize(tSize);
        text("N/A", scorePos.x, scorePos.y);
    }

    popStyle();
}