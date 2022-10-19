class button{
    /*
    0 = Close home screen, open game screen VS bots
    1 = Close home screen, open game screen VS players
    2 = ...
    */
    PVector pos;
    PVector dim;

    String name;
    int type;

    button(String buttonName, PVector position, PVector dimension, int buttonType){
        name = buttonName;
        pos  = position;
        dim  = dimension;
        type = buttonType;
    }

    void display(){
        pushStyle();

        imageMode(CENTER);
        rectMode(CENTER);
        fill(80,80,80);
        stroke(0);
        strokeWeight(2);
        rect(pos.x, pos.y, dim.x, dim.y);

        textAlign(CENTER, CENTER);
        fill(255);
        textSize(20);
        text(name, pos.x, pos.y);

        popStyle();
    }
    void doButton(){
        if(type == 0){
            setGameType(0);
            setGameStartingValues();
            nPlayers = 1;
            initPlayerScores(nPlayers);
            buildGameScreenButtons();
        }
        if(type == 1){
            setGameType(1);
            setGameStartingValues();
            nPlayers = 4;
            initPlayerScores(nPlayers);
            for(int i=1; i<playerScores.size(); i++){
                incrementScore(i);}
            generateRound(nPlayers, false);
            loadRound();
            buildGameScreenButtons();
        }
        if(type == 2){
            setGameType(2);
            setGameStartingValues();
            nPlayers = 0;
            initPlayerScores(nPlayers);
            buildGameScreenButtons();
        }
        if(type == 3){
            screenHome = true;
            screenGame = false;
            menuScores = false;
            buildHomeScreenButtons();
        }
    }
    boolean checkCollision(){
        boolean withinX = (pos.x -dim.x/2.0 < mouseX) && (mouseX < pos.x +dim.x/2.0);
        boolean withinY = (pos.y -dim.y/2.0 < mouseY) && (mouseY < pos.y +dim.y/2.0);
        if(withinX && withinY){
            return true;
        }
        else{
            return false;
        }
    }
}


void setGameType(int i){
    typeBots    = false;
    typePlayer  = false;
    typeAuto    = false;
    if(i == 0){
        typeBots = true;}
    if(i == 1){
        typePlayer = true;}
    if(i == 2){
        typeAuto = true;}
}
void setGameStartingValues(){
    screenHome = false;
    screenGame = true;
    menuLost   = false;
    menuScores = true;
    roundStarted = false;
    roundOver    = true;
    parrys.clear();
    fCharacters.clear();
    playerScores.clear();
}
void initPlayerScores(int n){
    /*
    Give n players a score of 0
    */
    for(int i=0; i<n; i++){
        playerScores.add(-1);
    }
}


void checkForButtonPressed(){
    for(int i=0; i<buttons.size(); i++){
        if( buttons.get(i).checkCollision() ){
            buttons.get(i).doButton();
        }
    }
}
void drawAllButtons(){
    for(int i=0; i<buttons.size(); i++){
        buttons.get(i).display();
    }
}


void buildHomeScreenButtons(){
    /*
    Start game button -> (For VS bots) AND (for VS friends)
    */
    buttons.clear();
    buttons.add( new button("Start bot game"    , new PVector(2.0*width/10.0, 8.0*height/10.0), new PVector(0.8*width/3.0, 0.8*2.0*height/10.0), 0) );
    buttons.add( new button("Start player game" , new PVector(5.0*width/10.0, 8.0*height/10.0), new PVector(0.8*width/3.0, 0.8*2.0*height/10.0), 1) );
    buttons.add( new button("Start auto game"   , new PVector(8.0*width/10.0, 8.0*height/10.0), new PVector(0.8*width/3.0, 0.8*2.0*height/10.0), 2) );
}
void buildGameScreenButtons(){
    /*
    Menu button (to quit out)
    */
    buttons.clear();
    buttons.add( new button("Menu", new PVector(9.0*width/10.0, 1.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 3) );
}