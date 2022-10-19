//Crop list
//----------
// 0 = wheat
// ...
class Crop{
  PVector pos;
  
  int tileNum;
  int lifeStart;  //The frame on which the crop
  int lifeTime;   //How long its been alive
  
  Crop(PVector position, int tileNumber){
    pos     = position;
    tileNum = tileNumber;
  }
}

class Wheat extends Crop{
  int lifeStage1 = (10)*(60);  //Seconds END OF until reaching 1st stage
  int lifeStage2 = (20)*(60);  //Seconds END OF until reaching 2nd stage
  //3rd stage is forever after 2nd => 3 in total
  
  boolean lifeCond1;
  boolean lifeCond2;
  boolean lifeCond3;
  Wheat(PVector pos, int tileNum){
    super(pos, tileNum);
  }
  void display(){  //Displays the crop
    //println("pos    ; ",pos);                      //*****//
    //println("tileNum; ",tileNum);                  //*****//
    relativeObjPos = findRelativeCoordinates(tileNum);
    pushStyle();
    rectMode(CENTER);
    imageMode(CENTER);
    
    if(lifeCond1 == true)
    {
      image(test1, relativeObjPos.x, relativeObjPos.y);}
    if(lifeCond2 == true)
    {
      image(test2, relativeObjPos.x, relativeObjPos.y);}
    if(lifeCond3 == true)
    {
      image(test3, relativeObjPos.x, relativeObjPos.y);}
    
    popStyle();
  }
  void calcLifeStage(){
    lifeTime = frameCount - lifeStart;
    relativeObjPos = findRelativeCoordinates(tileNum);
    lifeCond1 = false;  lifeCond2 = false;  lifeCond3 = false;
    pushStyle();
    rectMode(CENTER);
    imageMode(CENTER);
    if( (0 < lifeTime) && (lifeTime <= lifeStage1) )
    {
      lifeCond1 = true;
    }
    if( (lifeStage1 < lifeTime) && (lifeTime <= lifeStage2) )
    {
      lifeCond2 = true;
    }
    if( (lifeStage2 < lifeTime) )
    {
      lifeCond3 = true;
    }
    popStyle();
  }
}


class Barley extends Crop{
  int lifeStage1 = (5)*(60);  //Seconds END OF until reaching 1st stage
  int lifeStage2 = (10)*(60);  //Seconds END OF until reaching 2nd stage
  int lifeStage3 = (15)*(60);  //Seconds END OF until reaching 2nd stage
  //3rd stage is forever after 2nd => 3 in total
  
  boolean lifeCond1;
  boolean lifeCond2;
  boolean lifeCond3;
  boolean lifeCond4;
  Barley(PVector pos, int tileNum){
    super(pos, tileNum);
  }
  void display(){  //Displays the crop
    //println("pos    ; ",pos);                      //*****//
    //println("tileNum; ",tileNum);                  //*****//
    relativeObjPos = findRelativeCoordinates(tileNum);
    pushStyle();
    rectMode(CENTER);
    imageMode(CENTER);
    
    if(lifeCond1 == true)
    {
      image(barleyStg1, relativeObjPos.x, relativeObjPos.y);}
    if(lifeCond2 == true)
    {
      image(barleyStg2, relativeObjPos.x, relativeObjPos.y);}
    if(lifeCond3 == true)
    {
      image(barleyStg3, relativeObjPos.x, relativeObjPos.y);}
    if(lifeCond4 == true)
    {
      image(barleyStg4, relativeObjPos.x, relativeObjPos.y);}
    
    popStyle();
  }
  void calcLifeStage(){
    lifeTime = frameCount - lifeStart;
    relativeObjPos = findRelativeCoordinates(tileNum);
    lifeCond1 = false;  lifeCond2 = false;  lifeCond3 = false;
    pushStyle();
    rectMode(CENTER);
    imageMode(CENTER);
    if( (0 < lifeTime) && (lifeTime <= lifeStage1) )
    {
      lifeCond1 = true;
    }
    if( (lifeStage1 < lifeTime) && (lifeTime <= lifeStage2) )
    {
      lifeCond2 = true;
    }
    if( (lifeStage2 < lifeTime) && (lifeTime <= lifeStage3) )
    {
      lifeCond3 = true;
    }
    if( (lifeStage3 < lifeTime) )
    {
      lifeCond4 = true;
    }
    popStyle();
  }
}

void placeCrop(){
  tileNumTemp = findMouseTile();
  if(Tiles.get( tileNumTemp ).type == 14)                                                    //Can only place on fields
  {
    if( int( ((Field)( Tiles.get(tileNumTemp) )).cropInd.x) == -1 )                                       //If no crop already here...
    {
      if(cropSelector == 0)  //If wheat...
      {
        //cropList; 1st = what type of crop, 2nd = the crop itself
        //cropInd points to both
        ((Field)( Tiles.get(tileNumTemp) )).cropInd.x  = cropSelector;                                                //Updates cropInd
        ((Field)( Tiles.get(tileNumTemp) )).cropInd.y  = cropList.get( cropSelector ).size();                         //
        Wheat newWheat = new Wheat( Tiles.get( tileNumTemp ).pos, tileNumTemp );
        newWheat.lifeStart = frameCount;
        println("Wheat Added");                //*****//
        cropList.get(cropSelector).add( newWheat );                                                        //Adds crop to end of list
      }
      if(cropSelector == 1)  //If barley...
      {
        //cropList; 1st = what type of crop, 2nd = the crop itself
        //cropInd points to both
        ((Field)( Tiles.get(tileNumTemp) )).cropInd.x  = cropSelector;                                                //Updates cropInd
        ((Field)( Tiles.get(tileNumTemp) )).cropInd.y  = cropList.get( cropSelector ).size();                         //
        Barley newBarley = new Barley( Tiles.get( tileNumTemp ).pos, tileNumTemp);
        newBarley.lifeStart = frameCount;
        println("Barley Added");                //*****//
        cropList.get(cropSelector).add( newBarley );                                                        //Adds crop to end of list
      }
    }
  }
  
}
//##MAKE INTO AN EASIER TO USE FUNCTION WITH ARGUMENTS, FOR EASE OF ADDING NEW CROPS##//

void removeCrop(int tileNumTemp){
  cropType = int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x);
  if( ((Field)( Tiles.get(tileNumTemp) )).cropInd.y > -1 )
  {
    //Decrease index of all crops above one being removed
    for (int i=int(((Field)( Tiles.get(tileNumTemp) )).cropInd.y)+1; i<cropList.get( cropType ).size(); i++ )
    {
      ((Field)(Tiles.get( cropList.get(cropType).get(i).tileNum ))).cropInd.y -= 1;  //Decrease list position
    }
    println("cropRemoved");                                        //*****//
    //println("x; ",int(Tiles.get( tileNumTemp ).cropInd.x));      //*****//
    //println("y; ",int(Tiles.get( tileNumTemp ).cropInd.y));      //*****//
    cropList.get( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) ).remove( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.y) );  //Remove crop  //##NOT WORKING, -1 IND SOMEWHERE??##//
    ((Field)( Tiles.get(tileNumTemp) )).cropInd.x = -1;                                                                    //Change respective cropInd to have no crop
    ((Field)( Tiles.get(tileNumTemp) )).cropInd.y = -1;                                                                    //
  }
  
}

void harvestCrop(int tileNumTemp){
  //(0)Determine if crop exists here
  if(int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) > -1)
  {
    //(1)Determine crop
    if( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) == 0 )
    {
      //(2)If crop at end of life
      Crop currentCrop = cropList.get( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) ).get( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.y) );
      if( ((Wheat)currentCrop).lifeCond3 == true  )  //**Replace with max life cond / life cond where crop is FIRST harvestable**//
      {
        //(3)Add crop to inventory
        addItemToInventory("Wheat", 5);
        //(4)Remove crop
        removeCrop(tileNumTemp);
      }
    }
    //(1)Determine crop
    if( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) == 1 )
    {
      //(2)If crop at end of life
      Crop currentCrop = cropList.get( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.x) ).get( int(((Field)( Tiles.get(tileNumTemp) )).cropInd.y) );
      if( ((Barley)currentCrop).lifeCond4 == true  )
      {
        //(3)Add crop to inventory
        addItemToInventory("Barley", 5);
        //(4)Remove crop
        removeCrop(tileNumTemp);
      }
    }
    
  }
}


void displayWheat(){
  if( cropList.size() > 0 )  //##BECAUSE WE ARENT CLEARING EMPTY CROP LISTS##//
  {
    for(int i=0; i<cropList.get(0).size(); i++)   //Go through all wheat crops...
    {
      Crop currentCrop = cropList.get(0).get(i);  //Display that crop...
      ((Wheat)currentCrop).calcLifeStage();       //##CAN MAKE MORE EFFICIENT BY ONLY CALCULATING WHEN NEW, THEN STOPPING LATER##//
      ((Wheat)currentCrop).display();
    }
  }
}
void displayBarley(){
  if( cropList.size() > 0 )  //##BECAUSE WE ARENT CLEARING EMPTY CROP LISTS##//
  {
    for(int i=0; i<cropList.get(1).size(); i++)   //Go through all barley crops...
    {
      Crop currentCrop = cropList.get(1).get(i);  //Display that crop...
      ((Barley)currentCrop).calcLifeStage();      //##CAN MAKE MORE EFFICIENT BY ONLY CALCULATING WHEN NEW, THEN STOPPING LATER##//
      ((Barley)currentCrop).display();
    }
  }
}


void displayAllCrops(){
  displayWheat();
  displayBarley();
}


//New crop instructions;
//(1)Create new class (extending crop), stating lifeStages and supering variables from crop
//(2)Give it display and calcLifeStage methods
//(3)Increase value in 'initialisation' to accomodate for more crops (more empty spaces made)
//(4)Add another if statement in the 'placeCrop()' function in 'Crops' tab
//(5)Add another if statement in the 'harvestCrop()' funcrion in 'Crops' tab 
