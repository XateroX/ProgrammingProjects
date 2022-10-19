/*
Game screen
-----------------   X = player
|       ..   00 |   0 = Enemy
|       ..   00 |   . = other potential enemies
|               |
| XX         .. |
| XX         .. |
-----------------



####################################################################################################################
# MAKE SO LOSER IS JUST ELIMINATED, AND NEXT GAME CONTINUES WITH REMAINING CHARACTERS UNTIL ONE IS LEFT WITH A DUB #
####################################################################################################################
*/
void drawStage(){
    /*
    ## NEED TO MAKE ANIMATED ##
    */
    pushStyle();

    imageMode(CENTER);
    image(mStages.get(cStage), width/2.0, height/2.0, width, height);

    popStyle();
}
void drawCharacters(){
    for(int i=0; i<fCharacters.size(); i++){
        fCharacters.get(i).display();
    }
}
void drawBackDetails(){
    /*
    ## NEED TO MAKE ANIMATED ##
    */
    pushStyle();

    imageMode(CENTER);
    image(bStages.get(cStage), 10,10, 20,20);
    
    popStyle();
}
void drawForeDetails(){
    /*
    ## NEED TO MAKE ANIMATED ##
    */
    pushStyle();

    imageMode(CENTER);
    image(fStages.get(cStage), 30,30, 20,20);
    
    popStyle();
}
void drawScene(){
    drawStage();
    drawBackDetails();
    drawCharacters();
    drawForeDetails();
}
void showPlayerZone(){
    pushStyle();

    textSize(width/40.0);
    stroke(30,30,30,130);
    strokeWeight(4);

    for(int i=0; i<fCharacters.size(); i++){
        float distZone = vecDist(fCharacters.get(0).pos, fCharacters.get(1).pos) /2.0;
        
        noFill();
        ellipse(fCharacters.get(i).pos.x, fCharacters.get(i).pos.y, 2.0*distZone, 2.0*distZone);

        fill(0);
        text(i, fCharacters.get(i).pos.x -distZone, fCharacters.get(i).pos.y);
    }
    popStyle();
}


/*
Different game types and modes;
--Types-- -> determines who is in control
Bot game    = player vs bots   vs bots   vs ...
Player game = player vs player vs player vs ...
Auto game   = bots   vs bots   vs bots   vs ...

--Modes-- -> determines which match-ups picked
Tournament game = Works in a tournament structure until a sole winner is found (if a BOT game, will end once player loses)      ## AT ANOTHER TIME ##
Points game     = Keep playing games until you lose in order to get a max wins (if a PLAYER game, cycles through each player)
(all game can be of n players for n>=2)
*/
void playGameType(){
    if(typeBots){
        singlePlayerGame();
    }
    if(typeMode2){
        mode2Game();
    }
    if(typePlayer){
        allPlayerGame();
    }
    if(typeAuto){
        noPlayerGame();
    }
}
void singlePlayerGame(){
    //If in fight, continue that fight
    if(!menuLost){
        if(roundStarted && !roundOver){
            continueRound();
        }
        if(roundOver){
            showRoundResults();
        }
        //If finished with round, find new matching
        if(!roundStarted && roundOver){
            if(fCharacters.size() > 1){
                //Remove loser
                int iLoser = calcLoser();
                fCharacters.remove(iLoser);
                if(iLoser == fCharacters.size()){
                    menuLost = true;
                }
            }
            if(fCharacters.size() <= 1){
                //Make new set
                if(!menuLost){
                    incrementScore(playerTurn);}
                chooseRandomStage();
                generateWeighted();
                loadRound();
            }
            if(fCharacters.size() > 1){
                storeRound();
                loadRound();
            }
            resetRoundValues();
            roundStarted = true;
            roundOver    = false;
        }
    }
}

void mode2Game(){
    //If in fight, continue that fight
    if(!menuLost){
        if(roundStarted && !roundOver){
            continueRound_mode2();
        }
        if(roundOver){
            showRoundResults();
        }
        //If finished with round, find new matching
        if(!roundStarted && roundOver){
            
            if(fCharacters.size() <= 1){
                //Make new set
                if(!menuLost){
                    incrementScore(playerTurn);}
                chooseRandomStage();
                generateWeighted();
                loadRound();
            }

            resetRoundValues();
            roundStarted = true;
            roundOver    = false;
        }
    }
}

void allPlayerGame(){
    if(roundStarted && !roundOver){
        continueRound();
    }
    if(roundOver){
        showRoundResults();
    }
    //If finished with round, find new matching
    if(!roundStarted && roundOver){
        //Give winner points
        incrementScore( calcWinner() );
        //Start new round
        if(fCharacters.size() > 1){
            storeRound();
            loadRound();
        }
        //Reset values
        resetRoundValues();
        roundStarted = true;
        roundOver    = false;
    }
}
void noPlayerGame(){
    //pass
}


void generateWeighted(){
    /*
    Generates an enemy set, but leans towards 1 enemy
    */
    int rVal = ceil(random(0.0, 1.0));
    int spawnNum = 0;
    if(rVal <= 1.0){
        spawnNum++;}
    if(rVal <= 0.2){
        spawnNum++;}
    if(rVal <= 0.05){
        spawnNum++;}
    generateRound(spawnNum, true);
}
void chooseRandomStage(){
    int rVal = floor(random(0,maxStage));
    cStage = rVal;
}
void incrementScore(int p){
    /*
    +1 to score of p th player
    */
    int newScore = playerScores.get(p) +1;
    playerScores.remove(p);
    playerScores.add(p, newScore);
}
void resetRoundValues(){
    iPos = new PVector( random(width/3.0, 2.0*width/3.0), random(height/3.0, 2.0*height/3.0) );
    roundTimer = 0;
    indicatorTimer = 0;
    parrys.clear();
    resetCharacterHits();
}
void resetCharacterHits(){
    for(int i=0; i<fCharacters.size(); i++){
        fCharacters.get(i).botTimer   = 0;

        fCharacters.get(i).hitCounted = false;
        fCharacters.get(i).hasHit     = false;
        fCharacters.get(i).hitTime    = 0;
    }
}


void continueRound(){
    /*
    Plays out a round of quickdraw;
    1. Characters move onto stage
    2. They wait for some time
    3. An indicator goes off
    4. They try to hit as quick to this time as possible
    5. A short time is waited after
    6. Results are then given

    Hitting early is an automatic loss -> eliminates them from this round                       #### POSSIBLY IF LOTS OF PLAYERS, IS A LOSER ELIMINATION INSTEAD ##########
    Scoring is based on quickest time to hit after indicator -> player must win to proceed
    */

    if(roundTimer < animTime){
        //Spend first 3 seconds animating characters in
        //println("Characters moving in ...");
        lerpCharPos();
    }
    else if(!indicatorSent){
        //println("Indicator waiting ...");
        calcIndicator(graceTime, 0.05);
    }
    if(typePlayer){
        showPlayerZone();}
    showParrys();
    showIndicator();

    forceCharacterHits();
    if(!typePlayer){
        calcBotActions();}
    calcHits();
    calcParryHit(parryTime);

    calcRoundEnd();

    roundTimer++;
}
void continueRound_mode2(){
    /*
    Plays out a round of quickdraw;
    1. Characters move onto stage
    2. They wait for some time
    3. An indicator goes off
    4. They try to hit as quick to this time as possible
    5. A short time is waited after
    6. Results are then given

    Hitting early is an automatic loss -> eliminates them from this round                       #### POSSIBLY IF LOTS OF PLAYERS, IS A LOSER ELIMINATION INSTEAD ##########
    Scoring is based on quickest time to hit after indicator -> player must win to proceed
    */

    if(roundTimer < animTime){
        //Spend first 3 seconds animating characters in
        //println("Characters moving in ...");
        lerpCharPos();
    }
    else if(!indicatorSent){
        //println("Indicator waiting ...");
        calcIndicator(graceTime, 0.05);
    }
    if(typePlayer){
        showPlayerZone();}
    showParrys();
    showIndicator();

    forceCharacterHits();
    if(!typePlayer){
        calcBotActions();}
    calcHits();
    calcParryHit(parryTime);

    calcRoundEnd();

    roundTimer++;
}
void lerpCharPos(){
    for(int i=0; i<fCharacters.size(); i++){
        if(i != fCharacters.size()-1){      //Enemies -> from RHS
            fCharacters.get(i).pos.x -= fCharacters.get(i).moveSpeed;}
        else{                               //Player -> from LHS
            fCharacters.get(i).pos.x += fCharacters.get(i).moveSpeed;}
    }
}
void calcIndicator(int tGrace, float tRand){
    /*
    A random timer + some grace time to decide when players must hit
    */
    if(indicatorTimer > tGrace){
        float rVal = random(0.0, 1.0);
        if(rVal <= tRand){
            indicatorSent = true;
        }
    }
    indicatorTimer++;
}
void showParrys(){
    pushStyle();
    imageMode(CENTER);
    for(int i=0; i<parrys.size(); i++){
        parrys.get(i).display();
    }
    popStyle();
}
void showIndicator(){
    if(indicatorSent && !roundOver){
        pushStyle();
        imageMode(CENTER);
        image(indicator, iPos.x, iPos.y, width/8.0, width/8.0);
        popStyle();
    }
}
void forceCharacterHits(){
    if(roundTimer -indicatorTimer -animTime > roundMaxTime){
        for(int i=0; i<fCharacters.size(); i++){
            fCharacters.get(i).hasHit = true;
        }
    }
}
void calcHits(){
    for(int i=0; i<fCharacters.size(); i++){
        if(fCharacters.get(i).hasHit && !fCharacters.get(i).hitCounted){
            if(indicatorSent){
                //If PASSED the hit check
                fCharacters.get(i).hitTime = roundTimer -indicatorTimer -animTime;
                fCharacters.get(i).hitCounted = true;
            }
            else{
                //If FAILED the hit check
                fCharacters.get(i).hitTime = 999;
                fCharacters.get(i).hitCounted = true;
            }
        }
    }
}
void calcParryHit(int x){
    /*
    Parry hits occur if all players hit within x frames of each other
    A parry will result in the indicator being resent
    */
    if(checkAllCharactersHit()){
        boolean parryOccurs = true;
        for(int i=0; i<fCharacters.size(); i++){
            for(int j=0; j<fCharacters.size(); j++){
                if(i != j){ //**Mostly unnecessary, but saves on a SLIGHTLY more complicated calculation
                    boolean hitsTooFarApart     = fCharacters.get(i).hitTime - fCharacters.get(j).hitTime > x;
                    boolean hitsBeforeIndicator = (fCharacters.get(i).hitTime==999) || (fCharacters.get(j).hitTime==999);
                    if(hitsTooFarApart || hitsBeforeIndicator){
                        parryOccurs = false;
                        break;
                    }
                }
            }
            if(!parryOccurs){
                break;
            }
        }
        if(parryOccurs){
            //Add parry
            //println("-- PARRY --");
            float rotRange = PI/3.0;
            PVector posRange = new PVector(3.0*width/10.0, 2.0*height/10.0);   //How far from sides in X and Y directions
            parry newParry = new parry( new PVector(random(posRange.x, width-posRange.x), random(posRange.y, height-posRange.y)), random(-rotRange, rotRange) );
            newParry.say();
            parrys.add(newParry);
            //Reset indicator + attacks
            

        }
    }
}
void calcBotActions(){
    for(int i=0; i<fCharacters.size()-1; i++){
        fCharacters.get(i).calcBotAi();
    }
}
void calcRoundEnd(){
    if( checkAllCharactersHit() ){
        if(!roundOver){
            //println("--ROUND OVER--");
            roundOver     = true;
            indicatorSent = false;
        }
    }
}
boolean checkAllCharactersHit(){
    boolean allHit = true;
    for(int i=0; i<fCharacters.size(); i++){
        if(!fCharacters.get(i).hasHit){
            allHit = false;
            break;
        }
    }
    return allHit;
}


void findScoresMenuState(){
    if(roundOver){
        menuResults = true;
    }
    else{
        menuResults = false;
    }
}


int calcLoser(){
    /*
    Returns the index of the character that has lost the round
    */
    int iLoser = 0;
    for(int i=0; i<fCharacters.size(); i++){
        //** Note that the player (last in list) wins same frame hits
        if(fCharacters.get(i).hitTime > fCharacters.get(iLoser).hitTime){
            iLoser = i;
        }
    }
    return iLoser;
}
int calcWinner(){
    /*
    Returns the index of the character that has lost the round
    */
    int iWinner = 0;
    for(int i=0; i<fCharacters.size(); i++){
        if(fCharacters.get(i).hitTime < fCharacters.get(iWinner).hitTime){
            iWinner = i;
        }
    }
    return iWinner;
}


void generateRound(int nEnemies, boolean withPlayer){
    /*
    Creates enemies and places them in buffer
    THEN adds the player to the buffer too
    #################### NEEDS A DIFFICULTY SETTING TOO #################
    */
    float drawCap;
    if(playerScores.size() > 0){
        drawCap = 0.14 +(0.01*playerScores.get(playerTurn));}
    else{
        drawCap = 0.18;}
    //println("drawCap -> ",drawCap);
    bCharacters.clear();
    for(int i=0; i<nEnemies; i++){
        float rVal = random(0.0, 1.0);
        if(rVal < 0.25){
            botPrime newEnemy = new botPrime();
            newEnemy.drawSpeed = random(0.0, drawCap);
            bCharacters.add(newEnemy);
        }
        else if(rVal < 0.50){
            monk newEnemy = new monk();
            newEnemy.drawSpeed = random(0.0, drawCap);
            bCharacters.add(newEnemy);
        }
        else if(rVal < 0.75){
            ghost newEnemy = new ghost();
            newEnemy.drawSpeed = random(0.0, drawCap);
            bCharacters.add(newEnemy);
        }
        else{
            tire newEnemy = new tire();
            newEnemy.drawSpeed = random(0.0, drawCap);
            bCharacters.add(newEnemy);
        }
        //...
    }

    if(withPlayer){
        bCharacters.add(cPlayer);
    }
}
void loadRound(){
    /*
    Loads buffered characters into play
    Also sets the initial positions of the characters
    */
    //1
    fCharacters.clear();
    for(int i=0; i<bCharacters.size(); i++){
        fCharacters.add( bCharacters.get(i) );
    }
    //2
    float r = height/3.0;
    float theta = PI / (fCharacters.size()-1);
    if(fCharacters.size() == 2){
        theta = PI/4.0;
    }
    //Set values for when in scene
    if(typeBots){
        for(int i=0; i<fCharacters.size(); i++){
            if(i == fCharacters.size()-1){
                fCharacters.get(i).pos = new PVector(width/8.0, 8.0*height/10.0);
                fCharacters.get(i).dim = new PVector(height/3.0, height/3.0);
                fCharacters.get(i).hmPos = new PVector( random(-fCharacters.get(i).dim.x/2.0, fCharacters.get(i).dim.x/2.0), random(-fCharacters.get(i).dim.y/2.0, fCharacters.get(i).dim.y/2.0) );
                fCharacters.get(i).moveSpeed = (fCharacters.get(i).pos.x +1.1*fCharacters.get(i).dim.x/2.0) / (animTime);
            }
            else{
                if(fCharacters.size() == 2){
                    fCharacters.get(i).pos = new PVector(7.0*width/10.0 +r*cos(theta*(i+1) -PI/2.0), height/2.0 +r*sin(theta*(i+1) -PI/2.0));}
                else{
                    fCharacters.get(i).pos = new PVector(7.0*width/10.0 +r*cos(theta*i -PI/2.0), height/2.0 +r*sin(theta*i -PI/2.0));}
                fCharacters.get(i).dim = new PVector(0.8*height/3.0, 0.8*height/3.0);
                fCharacters.get(i).hmPos = new PVector( random(-fCharacters.get(i).dim.x/2.0, fCharacters.get(i).dim.x/2.0), random(-fCharacters.get(i).dim.y/2.0, fCharacters.get(i).dim.y/2.0) );
                fCharacters.get(i).moveSpeed = (width -fCharacters.get(i).pos.x +1.1*fCharacters.get(i).dim.x/2.0) / (animTime);
            }
        }
    }
    if(typePlayer){
        theta = 2.0*PI / (fCharacters.size());
        for(int i=0; i<fCharacters.size(); i++){
            fCharacters.get(i).pos = new PVector(width/2.0 +r*cos(theta*(i)), height/2.0 +r*sin(theta*(i)));
            fCharacters.get(i).dim = new PVector(0.8*height/3.0, 0.8*height/3.0);
            fCharacters.get(i).hmPos = new PVector( random(-fCharacters.get(i).dim.x/2.0, fCharacters.get(i).dim.x/2.0), random(-fCharacters.get(i).dim.y/2.0, fCharacters.get(i).dim.y/2.0) );
            fCharacters.get(i).moveSpeed = (width -fCharacters.get(i).pos.x +1.1*fCharacters.get(i).dim.x/2.0) / (animTime);
        }
    }
    moveOutOfScene();
}
void storeRound(){
    /*
    Stores current characters into the buffer
    */
    bCharacters.clear();
    for(int i=0; i<fCharacters.size(); i++){
        bCharacters.add( fCharacters.get(i) );
    }
}
void moveOutOfScene(){
    //Move back out of scene so can be animated in
    for(int i=0; i<fCharacters.size(); i++){
        if(i != fCharacters.size()-1){
            fCharacters.get(i).pos.x += fCharacters.get(i).moveSpeed *animTime;}
        else{
            fCharacters.get(i).pos.x -= fCharacters.get(i).moveSpeed *animTime;}
    }
}