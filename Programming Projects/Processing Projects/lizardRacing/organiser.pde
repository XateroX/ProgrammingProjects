/*
Collection of random / linking functions
Helps to keep other spaces clear

0. Misc
1. Lizard functions
2. Fruit   " "
3. Networks
4. Game loop
*/

//0
void situation1(){
    //Standard version
    displayBackground();

    updateAllLizardAi();
    calcFruit();
    calcLizards();

    roundDecider();

    colBugChecker();

    overlay();
}
void situation2(){
    //Quicker version
    displayBackground();
    for(int i=0; i<frameSkip; i++){
        updateAllLizardAi();
        updateFruit();
        updateLizards();

        roundDecider();
    }
    //showAllFruit();
    showLizards();

    colBugChecker();

    overlay();
}
void situation3(){
    //Insane version
    displayBackground();
    for(int i=0; i<frameSkip; i++){
        updateAllLizardAi();
        updateFruit();
        updateLizards();

        roundDecider();
    }
    if(roundNumber > wantedRound){
        //showAllFruit();
        frameSkip = 1;
        showLizards();

        colBugChecker();

        overlay();
    }
    else{
        showProgressBar();
    }
}
void displayBackground(){
    background(90, 60, 120);
}
void overlay(){
    /*
    Shows;
    . Framerate
    . Round number
    . Round time
    . Round time max
    */
    pushStyle();
    fill(255);
    text(frameRate, 30,30);

    text("Round #;      "+roundNumber, 30,60);

    text("Current time; "+roundTime, 30,90);

    text("Max time;     "+timeMax, 30,120);
    popStyle();
}
float vecDist(PVector v1, PVector v2){
    return sqrt( pow(v1.x - v2.x,2) + pow(v1.y - v2.y,2) );
}
float vecMag(PVector v){
    return sqrt( pow(v.x,2) + pow(v.y,2) );
}
PVector vecNormalise(PVector v){
    float mag = vecMag(v);
    if(mag != 0){
        return new PVector( (1.0 / mag)*v.x, (1.0 / mag)*v.y );
    }
    else{
        return new PVector(0,0);
    }
}
void initStandardNetwork(){
    stdNetwork.add(7);
    //stdNetwork.add(6);
    //stdNetwork.add(6);
    stdNetwork.add(4);
}
void showProgressBar(){
    float maxWidth   = width/3.0;
    float maxHeight  = height/18.0;
    float sText      = maxHeight /3.0;
    float multiplier = float(roundNumber) / float(wantedRound);
    pushStyle();
    rectMode(CORNER);
    textSize(sText);
    //Box outline
    fill(0);
    strokeWeight(4);
    rect(width/2.0 - maxWidth/2.0, height/2.0 - maxHeight/2.0, maxWidth, maxHeight);
    //Box fill
    fill(255);
    strokeWeight(1);
    rect(width/2.0 - maxWidth/2.0, height/2.0 - maxHeight/2.0, maxWidth*multiplier, maxHeight);
    //Percentage value
    stroke(0);
    fill(0);
    text(round(100.0*multiplier) , width/2.0 - maxWidth/2.0 + maxWidth*multiplier -2.5*sText, height/2.0 + maxHeight/4.0);
    text("%" , width/2.0 - maxWidth/2.0 + maxWidth*multiplier -2.5*sText +1.5*sText, height/2.0 + maxHeight/4.0);
    popStyle();
}

//1
lizard generateLizard(int sze, PVector orig, float l, network linkedNet){
    /*
    Creates a lizard at a given point
    */
    float rVal = random(0,2.0*PI);
    lizard newLizard = new lizard(sze, orig, l, new PVector(cos(rVal), sin(rVal)), linkedNet);
    return newLizard;
}
void calcLizards(){
    showLizards();
    updateLizards();
}
void showLizards(){
    /*
    Draws all lizards
    */
    for(int i=0; i<lizards.size(); i++){
        lizards.get(i).display();
    }
}
void updateLizards(){
    /*
    Calculates lizard motion
    */
    for(int i=0; i<lizards.size(); i++){
        lizards.get(i).calcDynamics();
        lizards.get(i).updateState();
    }
}
void updateAllLizardAi(){
    //#####################################################
    //## CAN PUT "int i=1" instead, so 0 is controllable ##
    //#####################################################
    for(int i=0; i<lizards.size(); i++){
        lizards.get(i).updateActionAi();
    }
}

//2
void calcFruit(){
    showAllFruit();
    updateFruit();
}
void showAllFruit(){
    for(int i=0; i<sys2Fruits.get(0).size(); i++){
        sys2Fruits.get(0).get(i).display();
        pushStyle();
        textSize(20);
        text(i, sys2Fruits.get(0).get(i).pos.x, sys2Fruits.get(0).get(i).pos.y);
        popStyle();
    }
}
void updateFruit(){
    println(lizards.size());
    for(int i=0; i<lizards.size(); i++){
        for(int j=0; j<sys2Fruits.get(i).size(); j++){
            if(!sys2Fruits.get(i).get(j).eaten){
                sys2Fruits.get(i).get(j).checkCollision( lizards.get(i) );
                break;
            }
        }
    }
}
void fillFruitPosSets(){
    //For 8 fruit
    fruitPosSets.add( new PVector(eOffset,eOffset) );
    fruitPosSets.add( new PVector(width-eOffset,height-eOffset) );
    fruitPosSets.add( new PVector(width/2.0,eOffset) );
    fruitPosSets.add( new PVector(width/2.0,height-eOffset) );
    fruitPosSets.add( new PVector(width-eOffset,eOffset) );
    fruitPosSets.add( new PVector(eOffset,height-eOffset) );
    fruitPosSets.add( new PVector(eOffset,height/2.0) );
    fruitPosSets.add( new PVector(width-eOffset,height/2.0) );
}
void createFruitFlags(int fruitNum, float detectRad){
    sys2Fruits.clear();
    for(int i=0; i<lizards.size(); i++){
        sys2Fruits.add( new ArrayList<fruit>() );
    }
    for(int i=0; i<lizards.size(); i++){
        for(int j=0; j<fruitNum; j++){
            PVector pos = new PVector(fruitPosSets.get(j).x, fruitPosSets.get(j).y);
            fruit newFruit = new fruit(pos, detectRad);
            sys2Fruits.get(i).add(newFruit);
        }
    }
}

//3
//pass

//4
void createInitialLizards(int nLizards, int sze, float l){
    for(int i=0; i<nLizards; i++){
        network newNetwork = new network(stdNetwork);
        newNetwork.randomiseNet(1.0);
        PVector newPos = new PVector( random(0,width), random(0,height) );
        lizard newLizard = generateLizard(sze, new PVector(newPos.x, newPos.y), l, newNetwork);
        lizards.add(newLizard);
    }
}
void roundDecider(){
    /*
    Chooses when to end rounds and reset for next round
    */
    boolean roundOver = (roundTime >= timeMax);
    if(roundOver){
        resetRound();
        roundNumber++;
        roundTime = 0;
    }
    roundTime++;
}
void resetRound(){
    /*
    Resets round variables
    . Merges winning networks
    . Creates new lizards with these new networks
    . Places new fruit down
    */
    ArrayList<ArrayList<network>> newNetSet = createWinPairings( findWinners() );
    ArrayList<ArrayList<Float>> newScoreSet = createScorePairings( findWinnerLizards() );
    formNewLizards(newNetSet, newScoreSet, standardSize, standardLength);
    createFruitFlags(fruitNumber, fruitDetectRad);
}
ArrayList<network> findWinners(){
    /*
    Returns list of the winning networks
    */
    ArrayList<network> winNets = new ArrayList<network>();
    for(int i=0; i<lizards.size(); i++){
        if(findScore(lizards.get(i)) > 0){         //## NEED TO ADJUST WHEN DISTANCE IS INTRODUCED TO SCORE    ##
            winNets.add( lizards.get(i).brain );    //## CAREFUL IS NOT BY REFERENCE                            ##
        }
    }
    return winNets;
}
ArrayList<lizard> findWinnerLizards(){
    /*
    Returns list of the winning networks
    */
    ArrayList<lizard> winLiz = new ArrayList<lizard>();
    for(int i=0; i<lizards.size(); i++){
        if(findScore(lizards.get(i)) > 0){         //## NEED TO ADJUST WHEN DISTANCE IS INTRODUCED TO SCORE    ##
            winLiz.add( lizards.get(i) );    //## CAREFUL IS NOT BY REFERENCE                            ##
        }
    }
    return winLiz;
}
ArrayList<ArrayList<Float>> createScorePairings(ArrayList<lizard> winLiz){
    ArrayList<ArrayList<Float>> pairings = new ArrayList<ArrayList<Float>>();
    if(winLiz.size() > 0)
    {
        for(int i=0; i<winLiz.size(); i+=2){
            boolean next2exist = i+2 < winLiz.size();
            if(next2exist){
                pairings.add(new ArrayList<Float>());
                pairings.get(pairings.size()-1).add( findScore(winLiz.get(i  )) );
                pairings.get(pairings.size()-1).add( findScore(winLiz.get(i+1)) );
            }
            else{
                if(winLiz.size() == 1){
                    pairings.add(new ArrayList<Float>());
                    pairings.get(0).add( findScore(winLiz.get(0)) );
                }
                else{
                    pairings.get(pairings.size()-1).add( findScore(winLiz.get(i  )) );
                }
            }
        }
    }
    return pairings;
}
ArrayList<ArrayList<network>> createWinPairings(ArrayList<network> winNets){
    /*
    Takes all winners and splits them into groups, which are then used to spawn new lizards
    . Pairs if possible -> 3 if odd number
    . Ignore if 1 wins
    */
    ArrayList<ArrayList<network>> pairings = new ArrayList<ArrayList<network>>();
    if(winNets.size() > 0)
    {
        for(int i=0; i<winNets.size(); i+=2){
            boolean next2exist = i+2 < winNets.size();
            if(next2exist){
                pairings.add(new ArrayList<network>());
                pairings.get(pairings.size()-1).add(winNets.get(i  ));
                pairings.get(pairings.size()-1).add(winNets.get(i+1));
            }
            else{
                if(winNets.size() == 1){
                    pairings.add(new ArrayList<network>());
                    pairings.get(0).add(winNets.get(0));
                }
                else{
                    pairings.get(pairings.size()-1).add(winNets.get(i  ));
                }
            }
        }
    }
    return pairings;
}
void formNewLizards(ArrayList<ArrayList<network>> pairings, ArrayList<ArrayList<Float>> scorePairs, int sze, float l){
    ArrayList<lizard> lizardsBuffer = new ArrayList<lizard>();
    for(int i=0; i<pairings.size(); i++){
        int rVal = ceil(random(0,7));
        for(int j=0; j<rVal; j++){
            if (lizardsBuffer.size() <= lizardNumber)
            {
                network newNetwork = new network(stdNetwork);
                PVector newPos = new PVector( random(0,width), random(0,height) );
                lizard newLizard = generateLizard(sze, new PVector(newPos.x, newPos.y), l, newNetwork);
                newLizard.brain.mergeNet(pairings.get(i), scorePairs.get(i));
                lizardsBuffer.add(newLizard);
            }
        }
    }
    lizards.clear();
    for(int i=0; i<lizardsBuffer.size(); i++){
        lizards.add(lizardsBuffer.get(i));
    }
    fillRemainingLizardsFresh();
}
void fillRemainingLizardsFresh(){
    if(lizards.size() < lizardNumber){
        createInitialLizards(lizardNumber-lizards.size(), standardSize, standardLength);
    }
}
float findScore(lizard l){
    //y = e^(-x)
    float distScaler = 100.0;
    float distScore  = pow(exp(1), -1.0*( (vecDist(l.body.get(0).pos, sys2Fruits.get(0).get(int(l.score)).pos) -sys2Fruits.get(0).get(int(l.score)).r) / distScaler ));
    float flagScore  = l.score;
    float finalScore = distScore + flagScore;
    return finalScore;
}
void colBugChecker(){
    for(int i=0; i<lizards.size(); i++){
        if(lizards.get(i).score > 0){
            lizards.get(i).col = new PVector(0,255,0);
        }
    }
}