ArrayList findTileBorder(int n, int ind){ //n = tile currently on, ind = index you are looking for (check for one)
  borderIndices.clear();
  for (int j=-1; j<=1; j++)
  {
    for (int i=-1; i<=1; i++)
    {
      //EdgeCases
      borderTile = n + ((colNum)*(j))+( i );
      if ( n % colNum == 0 )                 //Far left
      {
        if (i == -1)
        {
          borderIndices.add(0);
          continue;
        }
      }
      if ( n % (colNum) == 19 )             //Far right
      {
        if (i == 1)
        {
          borderIndices.add(0);
          continue;
        }
      }
      //Search within table
      if ( (borderTile >= 0) && (borderTile < (colNum*rowNum)) )
      {
        if ( Tiles.get(borderTile).type == ind )
        {
          borderIndices.add(1);
          continue;
        }
        else
        {
          borderIndices.add(0);
          continue;
        }
      }
      else                                   //Far top or bottom
      {
        borderIndices.add(0);continue;
      }
    }
  }
  return ( borderIndices ); //Returns the BOOLEAN of whether the object is what you are LOOKING FOR (in their respective position in the 3x3)
}

//**Ignores centre piece, so it doesnt count itself**//
ArrayList findTileBorderIndices(int n, int m){
  //n = tile currently on
  //Returns all tiles in the mxm area around you  ## m MUST be odd for this to work properly ##
  //Index reurn of -1 = NULL value
  borderIndices.clear();
  for (int j=-(floor( m/2 )); j<=(floor( m/2 )); j++)    //m down
  {
    for (int i=-(floor( m/2 )); i<=(floor( m/2 )); i++)  //m across, surrounding the given tile
    {
      //EdgeCases  ##LESS IMPORTANT, NEVER AT EDGE OF BORAD DUE TO SEA##
      borderTile = n + ((colNum)*(j))+( i );
      if ( n % colNum == 0 )                 //Far left
      {
        if (i == -1)
        {
          borderIndices.add(-1);
          continue;
        }
      }
      if ( n % (colNum) == 19 )             //Far right  ##19 MAY BE BUSTED##
      {
        if (i == 1)
        {
          borderIndices.add(-1);
          continue;
        }
      }
      //Search within table
      if ( (borderTile >= 0) && (borderTile < (colNum*rowNum)) )
      {
        borderIndices.add( Tiles.get(borderTile).type );
        continue;
      }
      else                                   //Far top or bottom
      {
        borderIndices.add(0);
        continue;
      }
    }
  }
  return ( borderIndices ); //Returns the INDICES around n (in their respective position in the mXm)
}


//####################################################//

ArrayList findTileBorderArray(int n, ArrayList<Integer> ind){ //n = tile currently on, ind = indices you are looking for (check for many)
  borderIndices.clear();
  for (int j=-1; j<=1; j++)
  {
    for (int i=-1; i<=1; i++)
    {
      //EdgeCases
      borderTile = n + ((colNum)*(j))+( i );
      if ( n % colNum == 0 )                 //Far left  
      {
        if (i == -1)
        {
          borderIndices.add(0);
          continue;
        }
      }
      if ( n % (colNum) == 19 )             //Far right
      {
        if (i == 1)
        {
          borderIndices.add(0);
          continue;
        }
      }
      //Search within table
      if ( (borderTile >= 0) && (borderTile < (colNum*rowNum)) )//Within confines of rectangle
      {
        for (int z=0; z<ind.size(); z++)
        {
          if ( Tiles.get(borderTile).type == ind.get(z) )
          {
            borderIndices.add( ind.get(z) );
            foundBorder = true;
            break;
          }
          else
          {
            foundBorder = false;//##MAY BE ABLE TO GET RID OF THIS BY BREAKING ON THE "CONTINUE" + SOMETHING ELSE##//
            continue;
          }
        }
        if (foundBorder == false)
        {
          borderIndices.add(0);
        }
      }
      else                                   //Far top or bottom
      {
        borderIndices.add(0);continue;
      }
    }
  }
  return ( borderIndices ); //Returns the INDEX of the objects you are LOOKING FOR (in their respective position in the 3x3)
}
//(x-1,y-1) (x,y-1) (x+1,y-1)
//(x-1,y  ) (x,y  ) (x+1,y  )
//(x-1,y+1) (x,y+1) (x+1,y+1)

// 1, 2, 3
// 4, 5, 6
// 7, 8, 9

PVector findRelativeCoordinates(int n){ //## USE THIS FOR DRAWING INDICES, THEN REPLACE TO DRAW FOR GRID + ORCS TOO ##//
  //n is the tile
  if ( (n > 0) && (n<rowNum*colNum))//##NEW, MAY BE BROKEN##//
  {
    relativeDifference.x = (Tiles.get(n).pos.x - relativePos.x);
    relativeDifference.y = (Tiles.get(n).pos.y - relativePos.y);
    relativeCoords.x = (screenWidth /2)+(relativeDifference.x);
    relativeCoords.y = (screenHeight/2)+(relativeDifference.y);
  }
  return relativeCoords;  //Gives an output in terms of screen coordinates
}

PVector findRelativeCoordinatesEntity(PVector pos){ //## USE THIS FOR DRAWING INDICES, THEN REPLACE TO DRAW FOR GRID + ORCS TOO ##//
  //pos is the position of the entity
  relativeDifference.x = (pos.x - relativePos.x);
  relativeDifference.y = (pos.y - relativePos.y);
  relativeCoords.x = (screenWidth /2)+(relativeDifference.x);
  relativeCoords.y = (screenHeight/2)+(relativeDifference.y);
  return relativeCoords;
}

int findMouseTile(){
  mouseTile = floor( (relativePos.x-screenWidth/2 +mouseX)/(wallWidth) )+(colNum)*(floor( (relativePos.y-screenHeight/2 +mouseY)/(wallHeight) ));
  return mouseTile;
}

int findSquarePosition(ArrayList<Integer> ind){
  //Dont need to check 4, is always itself
  if( (((ind.get(0)==0 && ind.get(1)==0)&&(ind.get(2)==0 && ind.get(3)==0))&&((ind.get(5)==1 && ind.get(6)==0)&&(ind.get(7)==1 && ind.get(8)==1))) ){
    squarePos=0;}    //topLeft
  if( (((ind.get(0)==0 && ind.get(1)==0)&&(ind.get(2)==0 && ind.get(3)==1))&&((ind.get(5)==1 && ind.get(6)==1)&&(ind.get(7)==1 && ind.get(8)==1))) ){
    squarePos=1;}    //topMiddle
  if( (((ind.get(0)==0 && ind.get(1)==0)&&(ind.get(2)==0 && ind.get(3)==1))&&((ind.get(5)==0 && ind.get(6)==1)&&(ind.get(7)==1 && ind.get(8)==0))) ){
    squarePos=2;}    //topRight
  if( (((ind.get(0)==0 && ind.get(1)==1)&&(ind.get(2)==1 && ind.get(3)==0))&&((ind.get(5)==1 && ind.get(6)==0)&&(ind.get(7)==1 && ind.get(8)==1))) ){
    squarePos=3;}    //middleLeft
  if( (((ind.get(0)==1 && ind.get(1)==1)&&(ind.get(2)==1 && ind.get(3)==1))&&((ind.get(5)==1 && ind.get(6)==1)&&(ind.get(7)==1 && ind.get(8)==1))) ){
    squarePos=4;}    //middleMiddle
  if( (((ind.get(0)==1 && ind.get(1)==1)&&(ind.get(2)==0 && ind.get(3)==1))&&((ind.get(5)==0 && ind.get(6)==1)&&(ind.get(7)==1 && ind.get(8)==0))) ){
    squarePos=5;}    //middleRight
  if( (((ind.get(0)==0 && ind.get(1)==1)&&(ind.get(2)==1 && ind.get(3)==0))&&((ind.get(5)==1 && ind.get(6)==0)&&(ind.get(7)==0 && ind.get(8)==0))) ){
    squarePos=6;}    //bottomLeft
  if( (((ind.get(0)==1 && ind.get(1)==1)&&(ind.get(2)==1 && ind.get(3)==1))&&((ind.get(5)==1 && ind.get(6)==0)&&(ind.get(7)==0 && ind.get(8)==0))) ){
    squarePos=7;}    //bottomMiddle
  if( (((ind.get(0)==1 && ind.get(1)==1)&&(ind.get(2)==0 && ind.get(3)==1))&&((ind.get(5)==0 && ind.get(6)==0)&&(ind.get(7)==0 && ind.get(8)==0))) ){
    squarePos=8;}    //bottomRight
  
  return squarePos;
}

//## MAY NOT WORK, NEEDS CHECKING (used in orc pathing) ##//
PVector convertToRelativePos(PVector screenPoint){
  //println("ScreenPoint.x; ",screenPoint.x);         //*****//
  //println("ScreenPoint.y; ",screenPoint.y);         //*****//
  //println("relativePoint; ",relativePoint);         //*****//
  relativePoint.x = (screenPoint.x - screenWidth /2) + relativePos.x;
  relativePoint.y = (screenPoint.y - screenHeight/2) + relativePos.y;

  return relativePoint; //Gives an output point in terms of relativeCoordinates
}

//## MAY NOT WORK, NEEDS CHECKING (used in orc pathing) ##//
int convertPosToTile(PVector pos){
  //Takes a pos (in relative coordinates) and returns the tile number its over
  tileTemp = floor( pos.x/wallWidth ) + ( floor( pos.y/wallHeight ) )*colNum;

  return tileTemp;
}

boolean checkForType(int typeToCheck, IntList typeList){
  catalogueCheck = false;
  for(int i=0; i<typeList.size(); i++)
  {
    if(typeToCheck == typeList.get(i))
    {
      catalogueCheck = true;
      break;
    }
  }
  return catalogueCheck;
}
