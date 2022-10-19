//(1) DRAW commands specifiy the texture location for object
//(2) COLLIDE commands specify the loci of collisons for the object, RETURNS reue or false (meaning keep velocity,o rmeaning stop velocity)

boolean buildingCollision(int n, PVector posEntity, int objTile, PVector vel, boolean IsUser){//Index n (of object at currentTile), current position of entity, currentTile position, gives rules for its collision
  if ((objTile > 0) && (objTile < (colNum*rowNum)) )
  {

    if(IsUser == false)//Not user
    {
      //relativePosEntity  = findRelativeCoordinatesEntity( posEntity );
      //## BECAUSE THE FINDRELATIVECORRDINATESENTITY WON'T RETURN NON INTEGER VALUES ##//
      relativeDifference.x = (posEntity.x - relativePos.x);
      relativeDifference.y = (posEntity.y - relativePos.y);
      relativePosEntity.x = (screenWidth /2)+(relativeDifference.x);
      relativePosEntity.y = (screenHeight/2)+(relativeDifference.y);
      //## BECAUSE THE FINDRELATIVECORRDINATESENTITY WON'T RETURN NON INTEGER VALUES ##//
    }
    else               //Is user
    {
      relativePosEntity.x = posEntity.x;//( (relativePos.x-screenWidth /2) + user.pos.x);
      relativePosEntity.y = posEntity.y;//( (relativePos.y-screenHeight/2) + user.pos.y);
      //##USER VALUE##
    }
    
    relativeObjPosTemp = findRelativeCoordinates(objTile);
    
    if (n == 1){//Wall
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
      
    }
    if (n == 2){//Barrel
    
      //pushStyle();                                                                   //*****//
      //println("posEntity; ",posEntity);                                              //*****//
      //println("###objPosTemp (for 2/barrels)###; ",objPosTemp);                      //*****//
      //fill(20,20,220);                                                               //*****//
      //ellipse(objPosTemp.x, objPosTemp.y, 15,15);                                    //*****//
      //popStyle();                                                                    //*****//
      
      if ( pow( ( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) ,2 ) + pow( ( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) ,2 ) < ( pow((wallWidth/3),2) ) )
      {
        return true; //In the collision zone
      }
      else
      {
        return false; //Not in the collision zone
      }
    }
    if (n == 3){//Door
      /*
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x ) < ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y ) < ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
      */
      //## NO COLLISION FOR DOOR ATM ##//
      
      return false;
    }
    if (n == 4){//Table
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }//##########################
    }
    if (n == 5){//Stool
      //No collision planned, can walk over it / sit on it
    }
    if (n == 6){//Counter
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth/2  ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }//####################
    if (n==7)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==8)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==9)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==11)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==12)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//

      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==13)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==15)  //Invisible collider, for multi-tiles
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==16)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    if (n==17)
    {
      pushStyle();                                                //*****//
      fill(150,255,150);                                          //*****//
      ellipse(relativeObjPosTemp.x,relativeObjPosTemp.y, 10,10);  //*****//
      popStyle();                                                 //*****//
     
      rectCollisionCond1 = ( abs( relativePosEntity.x - relativeObjPosTemp.x +vel.x ) <= ( wallWidth /2 ) );//Width vibe check  -->Change this to make specific for your given shape
      rectCollisionCond2 = ( abs( relativePosEntity.y - relativeObjPosTemp.y +vel.y ) <= ( wallHeight/2 ) );//Height vibe check -->"" ""
      if( rectCollisionCond1 && rectCollisionCond2 )//If within width and height specified
      {
        return true;
      }
      else
      {
        return false;
      }
    }

  }
  return false; //If it finds no other solution (e.g nothing there to collide with / n==0, => keep vel the same)
}



void drawEmpty(PVector pos, int n){
  //Has spaces => draw floor
  drawFloor(pos, n);
}

void drawWall(PVector pos, int n){
  
}

//1--2   quad(1,2,3,4)
//|  |
//4--3, quad coordinate labelling

//##POSSIBLY CHANGE TO LINES##//
//#### TRY TO USE RECTS FOR EASE OF ADDING TEXTURES ####//

void drawBarrel(PVector pos, int n){
  
}

void drawDoor(PVector pos, int n){ //##BREAKS IF TWO DOORS POSSIBLE##//
  
}
//##MAKE DOORS TILE TOGETHER IN STRIAGHT LINES ONLY##//

void drawTable(PVector pos, int n){
  
}
//##TILE TOGETHER IN RECTANGLES ONLY##//


void drawStool(PVector pos, int n){
  
}

void drawCounter(PVector pos, int n){
  
}

void drawTree(PVector pos, int n){
  
}

void drawLrgTree(PVector pos, int n){
  
}

void drawWater(PVector pos, int n){
  
}

void drawPump(PVector pos, int n){
  
}

void drawVat(PVector pos, int n){
  
}

void drawMachinery(PVector pos, int n){
  
}

void drawField(PVector pos, int n){
  
}

void drawInvisibleCollider(PVector pos, int n){  //Is invisible -> used for multi-tiles
  
}

void drawFireContained(PVector pos, int n){
  
}

//Multi-Tile
void drawTradingOutpost(PVector pos, int n){
  
}

void drawPort(PVector pos, int n){
  
}
//###########################################################//
//##FIX MULTITILES NOT BEING DRAWN WHEN MOVING OUT OF FRAME##//
//###########################################################//

void drawFloor(PVector pos, int n){
  if (Tiles.get(n).floorType == 0) //Natural floor
  {
    relativeObjPos = findRelativeCoordinates(n);
    borderIndicesFinal = findTileBorder(n, 6);
    tileset = (Tiles.get(n).tSetF);
    pushStyle();
    imageMode(CENTER);
    if ( (0  <= tileset) && (tileset < 85) ){                                               //85% chance
      image(naturalFloorPlain, relativeObjPos.x, relativeObjPos.y);}
    if ( (85 <= tileset) && (tileset < 95) ){                                               //10% chance
      image(naturalFloorFlowered, relativeObjPos.x, relativeObjPos.y);}
    if ( (95 <= tileset) && (tileset < 100) ){                                              //5% chance
      image(naturalFloorStone, relativeObjPos.x, relativeObjPos.y);}
    popStyle();
  }
  
  if (Tiles.get(n).floorType == 1) //Magic floor
  {
    relativeObjPos = findRelativeCoordinates(n);
    borderIndicesFinal = findTileBorder(n, 6);
    tileset = (Tiles.get(n).tSetF);
    pushStyle();
    imageMode(CENTER);
    //tSet currently ranges from 
    if ( (0  <= tileset) && (tileset < 88) ){                                                      
      //88% chance
      image(magicFloorPlain, relativeObjPos.x, relativeObjPos.y);}
    if ( (88 <= tileset) && (tileset < 98) ){                                                      //10% chance
      image(magicFloorBricked, relativeObjPos.x, relativeObjPos.y);}
    if ( (98 <= tileset) && (tileset < 100) ){                                                     //2% chance
      image(magicFloorFancy, relativeObjPos.x, relativeObjPos.y);}
    popStyle();
  }
}


void drawSquareMultiTile(PVector pos, int n){ //For all multi-tile structures, given index in here
  //->'p' is multiWidth, 'q' is multiHeight, 'ind' is the index of the multi-tile, n is tile number pressed over
  relativeObjPos = findRelativeCoordinates(n);  
  borderIndicesFinal = findTileBorder(n, 7);
  
  imageMode(CENTER);
  pushStyle();
  //fill(255,200,200);                                               //*****//
  //ellipse(relativeObjPos.x, relativeObjPos.y, 10,10);              //*****//
  squarePos = findSquarePosition(borderIndicesFinal);
  
  if( squarePos==0 ){
  image(test1, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==1 ){
  image(test2, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==2 ){
  image(test3, relativeObjPos.x, relativeObjPos.y);}
  //---
  if( squarePos==3 ){
  image(test4, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==4 ){
  image(test5, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==5 ){
  image(test6, relativeObjPos.x, relativeObjPos.y);}
  //---
  if( squarePos==6 ){
  image(test7, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==7 ){
  image(test8, relativeObjPos.x, relativeObjPos.y);}
  if( squarePos==8 ){
  image(test9, relativeObjPos.x, relativeObjPos.y);}
  
  popStyle();
  
  //## POSSIBLY MAKE IT DIFFERENTIATE BETWEEN ADJECENT MULTI-TILES, SO NO SPLICING OCCURS, ??HOWEVER COULD BE GOOD?? ##//
  //## MAKE ALL TILES IN 3X3 REVERT BACK (TO SOMETHING) WHEN ONE OF THEM IS CHANGED ##//
}

/*#####################################################
1. Add new "void draw..." -> specify shape here
(2.) Add "drawFloor" function if the texture has spaces where floor is visible (e.g not walls)
3. Add "n==..." in 'Grid' for this item's key
(4.) Add to collision lost in "Index" if needed, and therefore add collison condition above in 'collide' section
5. Add 'collideables' in index for collision

->If a multi-tile
1. Add ghost in "Overlays"
2. Add its draw normally (in this file)
3. Add placing in "key_bindings", multi-tile section
#####################################################*/
