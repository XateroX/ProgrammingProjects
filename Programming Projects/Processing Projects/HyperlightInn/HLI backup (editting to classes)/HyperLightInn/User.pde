class User{
  PVector pos;
  PVector vel = new PVector();
  PVector col;
  
  float r;
  
  int urgency;
  int lastState = 3;       //Last state of motion entity had (before stopping movement), 3 is intital position (front facing)
  int coins     = 100;     //How much money the player has
  
  ArrayList<Integer> inventoryQuantity = new ArrayList<Integer>();  //Keeps track of number of item
  ArrayList<String>  inventoryItems    = new ArrayList<String>() ;  //Keeps track of name of item at index, can be checked against
  ArrayList<Integer> currentDrink      = new ArrayList<Integer>();  //Holds the drink currently being held by the user
  
  User(float radius, PVector initialPosition, PVector skinColour){
    r = radius;
    pos = initialPosition;
    col = skinColour;
    urgency = 4;
    for(int i=0; i<=5; i++){    //Fill current drink with empty values
      currentDrink.add(-1);     //
    }                           //
  }
  void colliding(){
    //(0)Indices to be search for
    indList.clear();                           //##CAN BE MOVED TO INITALISATION, ONLY NEEDS TO BE DONE ONCE, THEN NO CLEAR NEEDED OR REPETITION NEEDED##//
    for (int i=0; i<collideables.size(); i++)  //##
    {                                          //##
      if (collideables.get(i) == 1)            //##
      {                                        //##
        indList.add(i);                        //##
      }                                        //##
    }                                          //##CAN BE MOVED TO INITALISATION, ONLY NEEDS TO BE DONE ONCE, THEN NO CLEAR NEEDED OR REPETITION NEEDED##//
    //(1)Find Closest tile
    //closestTile = floor( (pos.x)/(wallWidth) )+(colNum)*(floor( (pos.y)/(wallHeight) ));
    closestTile = ( floor( ( (pos.x - screenWidth/2)+(relativePos.x) )/(wallWidth) )  + floor( ( (pos.y - screenHeight/2)+(relativePos.y) )/(wallHeight) )*(colNum) );
    //pushStyle();                                                                          //*****//
    //rectMode(CENTER);                                                                     //*****//
    //fill(255,200,200);                                                                    //*****//
    //square(Tiles.get(closestTile).pos.x, Tiles.get(closestTile).pos.y, 20 );              //*****//
    //popStyle();                                                                           //*****//
    //(2)Check 3x3
    borderIndicesFinal = findTileBorderArray(closestTile, indList);
    //(3)Move back if colliding
    //println("borderIndicesFinal; ", borderIndicesFinal);                                  //*****//
    indCounter = 0;
    for (int j=-1; j<2; j++)
    {
      for (int i=-1; i<2; i++)
      {
        currentTile = closestTile + i + (colNum*j); //## WILL DE DIFFERENT WITH NEW GRID METHOD ##//
        //ellipse( (Tiles.get(currentTile).pos.x - relativePos.x + screenWidth/2), (Tiles.get(currentTile).pos.y - relativePos.y + screenHeight/2), 10,10 );     //*****//
        collision = buildingCollision( borderIndicesFinal.get( indCounter ), pos, currentTile, vel, true);//## FIND POS OF OBJECT FROM TABLE OF 3X3 ##//
        if (collision == true)
        {
          vel.x = 0;
          vel.y = 0;
          //println("COLLIDED USER");                                                  //*****//
        }
        indCounter++;
      }
    }
  }
 
  void updatePos(){
    pos.x += vel.x;
    pos.y += vel.y;
  }
  void drawUser(){
    
    //## REPLACE SO ALWAYS AN ANIMATION, EITHER RUNNING ANIM OR STATIONARY ANIM ##//
    
    //CONTENTS FOR USER DRAWING;
    //(1)vel.y > 0 -> up,     state1
    //(2)vel.y < 0 -> down,   state2
    //(3)vel.x > 0 -> left,   state3
    //(4)vel.x < 0 -> right,  state4
    //(5)if given button is pressed, play animation (?, maybe kept in key bindings)
    //(6)if given state, stationary animation
    
    if(currentDrink.get(0) != -1)
    {
        pushStyle();
        //## WILL NEED NORE EXPANDING FOR UP/DOWN IN ORDER TO LOOK GOOD, BUT FINE FOR NOW ##//
        if(lastState == 3)
        {
          pushMatrix();

          //## WILL NEED TO TAKE IMAGES FROM A PIMAGE LIST, CONTAINING EACH COMPONENT IN GIVEN INDICES ##//
          
          translate(pos.x, pos.y);
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
          image(beerMugBack1, pos.x+20, pos.y);
          //Fluid -> scaled height to see how much is left in beer glass  ## IN FUTURE CHANGE THE 568 TO "maxDrinkSize" ##
          image(beerLiquid1 , pos.x+20, pos.y + ( 30.0 - (30.0*(currentDrink.get(1)/568.0) ))/2.0, 30.0, 30.0*(currentDrink.get(1)/568.0)); //## NEED TO CHANGE IF START SERVING IN DIFFERENT INCREMENTS E.G NOT 1 PINTS ##//
          //Mug front
          image(beerMug1    , pos.x+20, pos.y);
        }
        
        popStyle();
    }
    
    pushStyle();
    imageMode(CENTER);
    userMoving = false;    
    
    //(1)Running up
    if((vel.y < 0)&&(vel.x==0))
    {
      userMoving = true;
      lastState = 1;
      if(frameTimerY == 60)  //Value of 'frameTotal' for this animation, the frame at which it should loop again
      {
        frameTimerY = 0;
      }
      userRunAnimUp(pos);
    }
    
    
    //(2)Running down
    if((vel.y > 0)&&(vel.x==0))
    {
      userMoving = true;
      lastState = 2;
      if(frameTimerY == 42)  //Value of 'frameTotal' for this animation, the frame at which it should loop again
      {
        frameTimerY = 0;
      }
      userRunAnimDown(pos);
    }
    
    
    //(3)Running left  (has priority)
    if(vel.x < 0)
    {
      userMoving = true;
      lastState = 3;
      if(frameTimerX == 60)  //Value of 'frameTotal' for this animation, the frame at which it should loop again
      {
        frameTimerX = 0;
      }
      userRunAnimLeft(pos);
    }
    
    
    //(4)Running right (has priority)
    if(vel.x > 0)
    {
      userMoving = true;
      lastState = 4;
      if(frameTimerX == 60)  //Value of 'frameTotal' for this animation, the frame at which it should loop again
      {
        frameTimerX = 0;
      }
      userRunAnimRight(pos);
    }
    
    
    //(5)Button pressed (e.g interactions)
    //...
    
    
    //(6)//Stationary states
    if((lastState == 1) && (userMoving ==false)){                  //Last up   (=> back)
      image(userBack, pos.x, pos.y);
      //anim
    }
    if((lastState == 2) && (userMoving ==false)){                  //Last down (=> front)
      image(userFront, pos.x, pos.y);
      //anim
    }
    if((lastState == 3) && (userMoving ==false)){                  //Last left
      image(userLeft, pos.x, pos.y);
      //anim     
    }
    if((lastState == 4) && (userMoving ==false)){                  //Last right
      image(userRight, pos.x, pos.y);
      //anim
    }
    
    
    popStyle();
  }
}
