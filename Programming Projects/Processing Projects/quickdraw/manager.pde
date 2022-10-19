void drawScreen(){
    /*
    Screens take up for space / are large and overpowering
    Given in order of display importance
    */
    if(screenHome){
        drawScreenHome();
    }
    else if(screenGame){
        drawScene();
    }
    drawAllButtons();
}
void drawMenu(){
    /*
    Menus take up small portions of the screen and overlay
    Given in order of display importance, but reversed (now least -> most)
    */
    if(menuOverlay){
        overlay();
    }
    if(menuResults){
        showRoundResults();
    }
    if(menuLost){
        showLoseMenu();
    }
    if(menuScores){
        showPlayerScorings();
    }
}


void calcScreen(){
    /*
    Screens take up for space / are large and overpowering
    Given in order of display importance
    */
    if(screenHome){
        //pass
    }
    else if(screenGame){
        playGameType();
    }
}
void calcMenu(){
    /*
    Menus take up small portions of the screen and overlay
    Given in order of display importance, but reversed (now least -> most)
    */
    if(menuOverlay){
        //pass
    }
    if(menuResults){
        //pass
    }
    if(menuLost){
        //pass
    }
}


void mousePressedManager(){
    checkForButtonPressed();
    if(screenHome){
        //pass
    }
    else if(screenGame){
        if(roundOver){
            roundStarted = false;
        }
        else if(roundStarted && !screenHome){
            //Bots game
            if(typeBots){
                cPlayer.hasHit = true;
            }
            //Player game
            if(typePlayer){
                float distZone = vecDist(fCharacters.get(0).pos, fCharacters.get(1).pos) /2.0;
                for(int i=0; i<fCharacters.size(); i++){
                    boolean mouseInZone = vecDist(new PVector(mouseX,mouseY), fCharacters.get(i).pos) < distZone;
                    if(mouseInZone){
                        fCharacters.get(i).hasHit = true;
                    }
                }
            }
        }
    }
}
void mouseReleasedManager(){
    if(screenHome){
        //pass
    }
    else if(screenGame){
        //pass
    }
}