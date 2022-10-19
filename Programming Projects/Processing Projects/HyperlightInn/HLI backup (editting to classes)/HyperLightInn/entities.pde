 //######################################//
//## NEED TO MOVE ORC STUFF OVER HERE ##//
//######################################//

class entity{
    PVector pos;
    PVector vel = new PVector(0,0);
    PVector acc = new PVector(0,0);
    PVector moveWaypoint = new PVector(boardWidth/2, boardHeight/2);
    PVector pathEnds     = new PVector(0,0);

    int lastState = 2;  //Which motion was last displayed, used to determine where the entity should face (2 is facing downwards initially)int routeNum = 0;
    int routeNum = 0;
    int entitySize;

    float speed;
    float alcholicness = 0; //Measure of how much alcohol is in an entity, determining some of their behaviours

    ArrayList<Integer> currentRoute        = new ArrayList<Integer>();  //Entity's memorised route
    ArrayList<Integer> givenTypeList       = new ArrayList<Integer>();  //List of all tiles of a given index on the board, used in path finding
    ArrayList<Integer> availableTypeList   = new ArrayList<Integer>();  //List of all tiles of a given index on the board that can be reached in a path
    ArrayList<Integer> currentDrink        = new ArrayList<Integer>();  //The drink type the entity is currently holding, and its related statistics (stored in specific indices)
    //**currentDrink; (0)Drink type, (1)Volume, (2)Bitterness, (3)Sweetness, (4)Alcoholicness, (5)Quality**
    //568 ml = 1 pint
    //######
    //## CHANGE CURRENTDRINK TO FLOAT NOT INT ##
    //######

    boolean initialPathSetup = false;
    boolean entityMoving     = false;   //Used to determine when animations should be played
    boolean counterNear      = false;   //Used in behaviour, to see if they should order a drink
    boolean newlySpawned     = true;    //Used to initially trigger the "move to the inn" behaviour on spawn
    boolean paidDrink        = true;    //Initially true, so it doesn't trigger paying money too early on the first cycle
    boolean deliveredDrink   = false;   //
    boolean hasDrink         = false;   //
    boolean leaving          = false;   //

    //float radius, PVector initialPosition, float orcNaturalSpeed, PVector skinColour, int n
    entity(PVector initialPosition, float naturalSpeed, int entityTileSize){
        pos          = initialPosition;
        speed        = naturalSpeed;
        entitySize   = entityTileSize;
        for(int i=0; i<=5; i++){    //Fill current drink with empty values
            currentDrink.add(-1);   //
        }                           //
    }

    //## ALL based off of using waypoints to move
    void updateAcc(){
        //pass
    }
    void updateVel(){
        vel.x += acc.x;
        vel.y += acc.y;

        //(1)Find if entity is moving
        if( (vel.x > 0) || (vel.y > 0) ){
            entityMoving = true;}
        else{
            entityMoving = false;}

        //(2)Find entity's state
        if(vel.y < 0){      //Up/Down
            lastState = 1;
        }
        if(vel.x > 0){
            lastState = 2;
        }
        if(vel.x < 0){      //Left/Right <-- Takes priority
            lastState = 3;
        }
        if(vel.x > 0){
            lastState = 4;
        }

        //### WORK IN PROGRESS ##//

        if( pow(moveWaypoint.x - pos.x, 2) + pow(moveWaypoint.y - pos.y, 2) < pow(waypointTolerance, 2) )    //##BECAUSE 'unitDirVector' BUGS OUT WHEN VALUES ARE THE SAME (BECOME INFINITY)##//
        {
            vel.x = 0;
            vel.y = 0;
            moveWaypoint.x = pos.x;
            moveWaypoint.y = pos.y;
        }
        else
        {
            unitVec = unitDirVector(pos, moveWaypoint);
            vel.x = unitVec.x * speed;
            vel.y = unitVec.y * speed;
        }

        //### WORK IN PROGRESS ##//
    }
    void updatePos(){
        pos.x += vel.x;
        pos.y += vel.y;
    }

    void colliding(){
        onScreenCond1 = ( (pos.x < (relativePos.x + screenWidth /2)) && (pos.x > (relativePos.y - screenHeight/2)) );
        onScreenCond2 = ( (pos.y < (relativePos.y + screenHeight/2)) && (pos.y > (relativePos.y - screenHeight/2)) );
        if ( onScreenCond1 && onScreenCond2 ) //If on screen
        {
            //(0)Find index of all tiles that can be collided with
            indList.clear();                           //##CAN BE MOVED TO INITALISATION, ONLY NEEDS TO BE DONE ONCE, THEN NO CLEAR NEEDED OR REPETITION NEEDED##//
            for (int i=0; i<collideables.size(); i++)  //##
            {                                          //##
                if (collideables.get(i) == 1)          //##
                {                                      //##
                    indList.add(i);                    //##
                }                                      //##
            }                                          //##CAN BE MOVED TO INITALISATION, ONLY NEEDS TO BE DONE ONCE, THEN NO CLEAR NEEDED OR REPETITION NEEDED##//

            //(1)Find Closest tile
            closestTile = floor( (pos.x)/(wallWidth) )+(colNum)*(floor( (pos.y)/(wallHeight) ));  
                                                                                                                //############################################//
            //(2)Check 3x3                                                                                      //##NEEDS TO BE CHANGED TO WORK FOR ANY SIZE##//
            borderIndicesFinal = findTileBorderArray(closestTile, indList);                                     //############################################//

            //(3)Move back if colliding  
            indCounter = 0;                                                                                       //############################################//
            for (int j=-1; j<2; j++)                                                                              //##NEEDS TO BE CHANGED TO WORK FOR ANY SIZE##//
            {                                                                                                     //############################################//
                for (int i=-1; i<2; i++)
                {
                    currentTile = closestTile + i + (colNum*j);
                    //ellipse( Tiles.get(currentTile).pos.x, Tiles.get(currentTile).pos.y, 10,10 );     //*****//                                         // ############### //
                    collision = buildingCollision( borderIndicesFinal.get( indCounter ), pos, currentTile, vel, false);//## FIND POS OF OBJECT FROM TABLE OF ##--> 3X3 <--## //
                    if (collision == true)                                                                                                                // ############### //
                    {
                        vel.x = 0;
                        vel.y = 0;
                    }
                    indCounter++;
                }
            }
        }
    }

    PVector calcPathEnds(int requiredType){
    //calc start point (uses orc's stored position)
    pathEnds.x = convertPosToTile( pos );

    //(1)Find all tiles of given index and store them
    givenTypeList.clear();
    availableTypeList.clear();
    for(int i=0; i<Tiles.size(); i++)           //Go through al tiles...
    {
      if( Tiles.get(i).type == requiredType ) //If index of given tile is what we are looking for...
      {
        givenTypeList.add(i);                  //Then add the tile number to givenTypeList
      }
    }

    //(2)Check if list is empty, if so return a null value
    if(givenTypeList.size() == 0)  //If none of given index found...
    {
      tileTemp = -1;                //Empty value to signify no end destination
    }
    //(3)If there is a selection
    else                            //If values are found...
    {

      //(4)Go through all available and chose the closest

      //println("--FINDING REACHABLE INDICES--");
      //(1)Check if is reachable                    //#################### VERY VERY INEFFICIENT ########################//
      for(int i=0; i<givenTypeList.size(); i++)     //Check them all to find shortest distance  //## EDIT NEEDED HERE TO ENSURE IT IS ALSO REACHABLE ##//
      {
        pathResult = tilePathing(int(pathEnds.x), int( givenTypeList.get(i) ), entitySize);
        if( pathResult.get(0) != -1 ){
            availableTypeList.add( givenTypeList.get(i) );
        }
      }
      //(2)Go through all reachable, and choose the closest one
      if(availableTypeList.size() > 0)
      {
        tileTemp = availableTypeList.get(0);              //Make first item shortest by default
        pathTileDiffX        = abs(        (tileTemp % colNum)   -        (pathEnds.x % colNum)   );
        pathTileDiffY        = abs( floor( (tileTemp / colNum) ) - floor( (pathEnds.x / colNum) ) );
        leadingDist          = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );
        for(int i=0; i<availableTypeList.size(); i++)
        {
            //Calc dists here
            pathTileDiffX        = abs(        (availableTypeList.get(i) % colNum)   -        (pathEnds.x % colNum)   );
            pathTileDiffY        = abs( floor( (availableTypeList.get(i) / colNum) ) - floor( (pathEnds.x / colNum) ) );
            workingDist          = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );
            if( workingDist < leadingDist)               //If this item is a shorter distance...
            {
            tileTemp = givenTypeList.get(i);          //Then make it the leading value
            leadingDist = workingDist;
            }
        }
      }
      else
      {
          tileTemp = -1;    //If nothing, return a null value
      }

    }
    pathEnds.y = tileTemp;

    return pathEnds;
  }

  void memoriseRoute(ArrayList<Integer> route){
    currentRoute.clear();                 //Forget old route
    for(int i=0; i<route.size(); i++){    //Copy over new route for entity to remember
      currentRoute.add( route.get(i) );
    }
  }

  void travelPath(ArrayList<Integer> route){
    if( route.get(0) == -1 )    //If no route found (returns -1)...
    {
        currentRoute.clear();               //Remove old, useless route
        route.clear();                      //
        currentRoute.add( convertPosToTile(pos) ); //Set new route to be closest tile
        route.add( convertPosToTile(pos) );        //
    }
    if( routeNum == route.size() )  //Makes the follower loop the path
    {
        routeNum = 0;          //**Makes it loop**
        currentRoute.clear();  //**Finishes its route**
        initialPathSetup = false;
    }
    else
    {

        //println("RouteNum; ", routeNum);                      //*****//
        //println("RouteTile; ", route.get(routeNum));          //*****//
        relativeObjPosTemp = Tiles.get( route.get(routeNum) ).pos;
        moveWaypoint.x     = relativeObjPosTemp.x;
        moveWaypoint.y     = relativeObjPosTemp.y;

        //line(findRelativeCoordinatesEntity( pos ).x, findRelativeCoordinatesEntity( pos ).y, findRelativeCoordinatesEntity(moveWaypoint).x, findRelativeCoordinatesEntity(moveWaypoint).y );               //*****//

        if( pow(relativeObjPosTemp.x - pos.x ,2) + pow(relativeObjPosTemp.y - pos.y ,2) < pow(waypointTolerance ,2) )  //If within range of next tile...
        {
            routeNum++;
        }

    }
  }

  void calcPathing(int pathIndex){
    //########################################################################################################################//
    //## MAY NEED TO ADJUST, AS EACH ENTITY WILL REACT DIFFERENTLY, E.G GOBLINS MAY WANT TO GO TO NEARBY TREES NOT COUNTERS ##//
    //########################################################################################################################//
    //pathIndex = tile type you are pathing to

    //Perform process for entity to start travelling the desired route
    //(1)Set start and end points (for given conditions)
    //(2)Calculate the route to be travelled
    //(3)Remember route
    //(4)Travel route

    //Performed just once per path
    if(initialPathSetup == false)
    {
        pathEnds   = calcPathEnds(pathIndex);
        pathResult = tilePathing(int(pathEnds.x), int(pathEnds.y), entitySize);
        memoriseRoute(pathResult);                                                //Once
        initialPathSetup = true;
    }

    //Execute path to follow
    if(initialPathSetup == true)
    {
      //**This function will set "initialPathSetup" to false once it completes its route**
      travelPath(currentRoute);                           //Every frame
    }
  }

  void drawPath(ArrayList<Integer> route) //Draws signals at all tiles in a given route
  {
    pushStyle();
    textAlign(CENTER);
    textSize(10);

    for(int i=0; i<route.size(); i++)
    {
        fill(217, 37, 230);
        relativeObjPos = findRelativeCoordinates( route.get(i) );
        ellipse(relativeObjPos.x, relativeObjPos.y,   wallWidth/3, wallHeight/3);

        //fill(0);
        //text( floor( Tiles.get( route.get(i) ).runningWeight ), relativeObjPos.x, relativeObjPos.y );
    }

    popStyle();
  }

  void calcBehaviour(){
    //Spawned --> Go to counter
    if(newlySpawned == true){
        calcPathing(6);
        if(currentRoute.size() == 0){
            newlySpawned = false;
        }
        println("---(1)To spawn");
        return;
    }

    //At counter --> Ask for a drink and wait until delivered
    counterNear = false;
    borderIndicesFinal = findTileBorderIndices(convertPosToTile( pos ), entitySize+2);
    for(int i=0; i<borderIndicesFinal.size(); i++){
        if(borderIndicesFinal.get(i) == 6){
            counterNear  = true;
        }
    }

    if( (counterNear == true) && (deliveredDrink == false) ){
        //###########################################//
        //## ASK FOR BEER USING PICTURE ABOVE HEAD ##//
        //###########################################//
        //###############################//
        //## OR WAIT FOR REST OF PARTY ##//
        //###############################//
        relativeObjPos = findRelativeCoordinatesEntity(pos);
        //######################################################//
        //## CHANGE TO WORK FOR ANY GIVEN BEER TYPE ASKED FOR ##//
        //######################################################//
        image(requestBeer1, relativeObjPos.x +10, relativeObjPos.y -wallHeight);
        if(currentDrink.get(0) != -1){
            deliveredDrink = true;
            paidDrink      = false;
        }
        println("---(2)Wait for drink");
        return;
    }

    //If drink is nearby --> take drink
    //**Drink is given by player by clicking on entity**

    //Recieved drink --> Pay for drink AND go to chair
    if( (currentDrink.get(0) != -1) && (paidDrink == false) ){
        //** Price of the beer = (beerType cost per ml) * (ml ordered) **
        user.coins += drinkPrices.get( currentDrink.get(0) ) * currentDrink.get(1);
        calcPathing(5);
        hasDrink  = true;
        paidDrink = true;
        println("---(3)Recieve drink");
        return;
    }

    //Drinking beer --> Tell story OR make noise/pop-ups
    if(currentDrink.get(1) > 0){
        //#############################//
        //## MAKE NOISE / TELL STORY ##// --> ALL IN PICTURES
        //#############################//

        //** Entities drink at the movement speed * drinkSpeedMultipler **//
        //** Entities drunkness increases by amount drunk * alcholicness of drink **//

        relativeObjPos = findRelativeCoordinatesEntity(pos);
        if(frameCount % talkingRate == 0)
        {
            //Determine inconsequential action
            duringDrinkOutcome = floor( random(10) );  //** => 0,1,2,3,4,5,6,7,8,9
        }

        //Inconsequential action
        if(duringDrinkOutcome == 0){
            image(orcChatter1, relativeObjPos.x +10, relativeObjPos.y -wallHeight);
        }
        if(duringDrinkOutcome == 1){
            image(orcChatter2, relativeObjPos.x +10, relativeObjPos.y -wallHeight);
        }
        if(duringDrinkOutcome == 2){
            image(orcChatter3, relativeObjPos.x +10, relativeObjPos.y -wallHeight);
        }
        //No reaction for 1,2

        if(frameCount % drinkingRate == 0)
        {
            //Drinking action
            if(currentDrink.get(1) - (speed * drinkSpeedMultipler) > 0){ //Drink full amount
                alcholicness +=  (speed * drinkSpeedMultipler) * currentDrink.get(4);
                tempDrinkVolume = currentDrink.get(1);
                currentDrink.remove(1);
                currentDrink.add( 1, int(tempDrinkVolume - (speed * drinkSpeedMultipler)) );
            }
            else{ //Drink remainder to empty
                alcholicness += (currentDrink.get(1)) * currentDrink.get(4);
                currentDrink.remove(1);
                currentDrink.add(1, 0);
                hasDrink = false;
            }
            println("---(4)Drink drink");
        }
        
        return;
    }

    //Finish beer --> Ask for room OR ((leave a tip OR start fight) AND Leave inn)
    if( ((leaving == false) && (hasDrink == false)) && ((paidDrink == true) && (deliveredDrink == true)) ){
        //#################//
        //## LEAVE A TIP ##//
        //#################//
        //##################//
        //## ASK FOR ROOM ##//
        //##################//

        drinkPossibility = floor( random(2) );  //** => 0,1
        if(drinkPossibility == 0){  //Buy another beer
            calcPathing(6);
            deliveredDrink = false;
            paidDrink      = false;
            for(int i=0; i<currentDrink.size(); i++)
            {
                currentDrink.remove(i);
                currentDrink.add(i, -1);
            }
            println("---(5.1)Buy another drink");
        }
        if(drinkPossibility == 1){  //Leave
            leaving = true;
            calcPathing(17); //## CHANGE TO PATH BACK TO PORT, WHERE ENTITIES CAME FROM ##//
            println("--PATHING TO 17");
            for(int i=0; i<currentDrink.size(); i++)
            {
                currentDrink.remove(i);
                currentDrink.add(i, -1);
            }
            println("---(5.2)Leave inn");
        }
        //if(drinkPossibility == 2){  //...
        //    //pass
        //}

        currentDrink.remove(1);
        currentDrink.add(1, -1); //To signify that the drink is no longer JUST finished, but has BEEN FINISHED FOR A WHILE
        hasDrink = false;
        println("---(5)Finish drink");
        return;
    }

    //Leaving inn --> walk to exit
    if(leaving == true){
        calcPathing(17);
    }

    //println("----");
    //println("Beer type         ; ", currentDrink.get(0));
    //println("Beer volume       ; ", currentDrink.get(1));
    //println("Beer bitterness   ; ", currentDrink.get(2));
    //println("Beer sweetness    ; ", currentDrink.get(3));
    //println("Beer alcoholicness; ", currentDrink.get(4));
    //println("Beer quality      ; ", currentDrink.get(5));
    //println("----");

  }

}

class Orc extends entity{
    //Orc specific variables

    Orc(PVector pos, float speed, int entitySize){
        super(pos, speed, entitySize);
    }

    void display(){
        //Draws the entity based off of which direction it just moved (for LEFT/RIGHT or FRONT/BACK)
        pushStyle();
        imageMode(CENTER);
        fill(102, 196, 148); //## REMOVE THIS, JUST FOR TEMPORARY ORC ELLIPSE COLOUR ##//

        relativeObjPos = findRelativeCoordinatesEntity( pos );

        if(hasDrink == true)
        {
            pushStyle();
            //## WILL NEED NORE EXPANDING FOR UP/DOWN IN ORDER TO LOOK GOOD, BUT FINE FOR NOW ##//
            if(lastState == 3)
            {
                pushMatrix();

                //## WILL NEED TO TAKE IMAGES FROM A PIMAGE LIST, CONTAINING EACH COMPONENT IN GIVEN INDICES ##//

                translate(relativeObjPos.x, relativeObjPos.y);
                scale(-1,1);

                //Mug back
                image(beerMugBack1, 20, 0);
                //Fluid -> scaled height to see how much is left in beer glass  ## IN FUTURE CHANGE THE 568 TO "maxDrinkSize" ##
                image(beerLiquid1 , 20,  ( 30.0 - (30*(currentDrink.get(1)/568.0) ))/2.0, 30, 30.0*(currentDrink.get(1)/568.0)); //## NEED TO CHANGE IF START SERVING IN DIFFERENT INCREMENTS E.G NOT 1 PINTS ##//
                //Mug front
                image(beerMug1    , 20, 0);
                
                popMatrix();
            }
            else
            {
                //Mug back
                image(beerMugBack1, relativeObjPos.x+20, relativeObjPos.y);
                //Fluid -> scaled height to see how much is left in beer glass  ## IN FUTURE CHANGE THE 568 TO "maxDrinkSize" ##
                image(beerLiquid1 , relativeObjPos.x+20, relativeObjPos.y + ( 30.0 - (30.0*(currentDrink.get(1)/568.0) ))/2.0, 30.0, 30.0*(currentDrink.get(1)/568.0)); //## NEED TO CHANGE IF START SERVING IN DIFFERENT INCREMENTS E.G NOT 1 PINTS ##//
                //Mug front
                image(beerMug1    , relativeObjPos.x+20, relativeObjPos.y);
            }
            
            popStyle();
        }

        if(entityMoving == true)    //Moving animations
        {

            if(lastState == 1){ //Up / Down
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test1, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 2){
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test2, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 3){ //Left / Right <-- Takes priority
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test3, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 4){
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test4, relativeObjPos.x, relativeObjPos.y);
            }

        }
        else                        //Stationary animations
        {

            if(lastState == 1){ //Up / Down  
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test1, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 2){
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 3){ //Left / Right <-- Takes priority
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test3, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 4){
                image(orcFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test4, relativeObjPos.x, relativeObjPos.y);
            }

        }
        
        popStyle();
    }
}
//#################################################//     ###                                                   ###
//## FIX ORCS GOING OFF SCREEN TRYING TO COLLIDE ##// --> ### JUST COLLISION / DESPAWNING OFF-SCREEN IN GENERAL ###
//#################################################//     ###                                                   ###

class sludgeMonster extends entity{
    //SludgeMonster specific variables

    sludgeMonster(PVector pos, float speed, int entitySize){
        super(pos, speed, entitySize);
        //pass
    }

    void display(){
        //Draws the entity based off of which direction it just moved (for LEFT/RIGHT or FRONT/BACK)
        pushStyle();
        imageMode(CENTER);

        relativeObjPos = findRelativeCoordinatesEntity( pos );

        if(hasDrink == true)
        {
            pushStyle();
            //## WILL NEED NORE EXPANDING FOR UP/DOWN IN ORDER TO LOOK GOOD, BUT FINE FOR NOW ##//
            if(lastState == 3)
            {
                pushMatrix();

                //## WILL NEED TO TAKE IMAGES FROM A PIMAGE LIST, CONTAINING EACH COMPONENT IN GIVEN INDICES ##//
                
                translate(relativeObjPos.x, relativeObjPos.y);
                scale(-1,1);

                //Mug back
                image(beerMugBack1, 20, 0);
                //Fluid -> scaled height to see how much is left in beer glass  ## IN FUTURE CHANGE THE 568 TO "maxDrinkSize" ##
                image(beerLiquid1 , 20,  ( 30.0 - (30*(currentDrink.get(1)/568.0)) )/2.0 , 30, 30.0*(currentDrink.get(1)/568.0)); //## NEED TO CHANGE IF START SERVING IN DIFFERENT INCREMENTS E.G NOT 1 PINTS ##//
                //Mug front
                image(beerMug1    , 20, 0);
                
                popMatrix();
            }
            else
            {
                //Mug back
                image(beerMugBack1, relativeObjPos.x+20, relativeObjPos.y);
                //Fluid -> scaled height to see how much is left in beer glass  ## IN FUTURE CHANGE THE 568 TO "maxDrinkSize" ##
                image(beerLiquid1 , relativeObjPos.x+20, relativeObjPos.y + ( 30.0 - (30.0*(currentDrink.get(1)/568.0) ))/2.0, 30.0, 30.0*(currentDrink.get(1)/568.0)); //## NEED TO CHANGE IF START SERVING IN DIFFERENT INCREMENTS E.G NOT 1 PINTS ##//
                //Mug front
                image(beerMug1    , relativeObjPos.x+20, relativeObjPos.y);
            }
            
            popStyle();
        }

        if(entityMoving == true)    //Moving animations
        {

            if(lastState == 1){ //Up / Down  
                image(sludgeMonsterBackStat, relativeObjPos.x, relativeObjPos.y);
                image(test1, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 2){
                image(sludgeMonsterFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test2, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 3){ //Left / Right <-- Takes priority
                image(sludgeMonsterLeftStat, relativeObjPos.x, relativeObjPos.y);
                image(test3, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 4){
                image(sludgeMonsterRightStat, relativeObjPos.x, relativeObjPos.y);
                image(test4, relativeObjPos.x, relativeObjPos.y);
            }

        }
        else                        //Stationary animations
        {

            if(lastState == 1){ //Up / Down
                image(sludgeMonsterBackStat, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 2){
                image(sludgeMonsterFrontStat, relativeObjPos.x, relativeObjPos.y);
                image(test2, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 3){ //Left / Right <-- Takes priority
                image(sludgeMonsterLeftStat, relativeObjPos.x, relativeObjPos.y);
                image(test3, relativeObjPos.x, relativeObjPos.y);
            }
            if(lastState == 4){
                image(sludgeMonsterRightStat, relativeObjPos.x, relativeObjPos.y);
                image(test4, relativeObjPos.x, relativeObjPos.y);
            }

        }
        
        popStyle();
    }

}

//Troll ...

//Elf ...

//Dwarf ...

//...

//Follower from entity??
