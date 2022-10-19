void FPScounter(){
  pushStyle();
  textSize(20);
  textAlign(LEFT);
  text(floor(frameRate), 0,10);
  popStyle();
}
void keyBindings(){
  //The Result
  pushStyle();
  fill(0);
  textSize(10);
  //Regardless
  //##MOVE TO MENU, WHERE OPTIONS ARE LOCATED-> FOR ESSENTIAL HOTKEYS##//
  text("Home screen; ", width -120, 20);text("u",   width-30, 20);
  text("Hotkey menu; ", width -120, 40);text("h",   width-30, 40);
  if(hotkeyMenuScreen == true)
  {
    if(modeSelector==0)  //Exploration mode
    {
      displayExplortionHotkeys();
    }
    if(modeSelector==1)  //Building mode
    {
      displayBuildingHotkeys();
    }
    if(modeSelector==2)  //Piping mode
    {
      displayPipingHotkeys();
    }
    if(modeSelector==3)  //Piping mode
    {
      displayCropHotkeys();
    }
  }
  popStyle();
  
}

void GeneralisedBugFixing(){
  println("StartTile; ", startTile);
  println("Urgency; ", user.urgency);
  println("///");
  println("Orcs Present; ", entityList.get(0).size() );
  print  ("UserPosition;     ", user.pos);                         print("   ///   ");println("TileNumber over mouse; ",findMouseTile());
  print  ("3x3 Border;       ", borderIndicesFinal);               print("   ///   ");
  print  ("[RelativePos X] ; ",relativePos.x);                     print("   ,  ");  println("[RelativePos Y]; ",relativePos.y);
  println("GIVEN TilePos; ", Tiles.get( Tiles.size()-1 ).pos);
  print  ("tileTypeSel      ; ",tileTypeSel);                        print("   ///   ");println("floorTypeSel; ",floorTypeSel);
  println("---");
  print("pipeInd; ",Tiles.get( findMouseTile() ).pipeInd );print("   ///   ");println("pipNetworkSize; ",pipeNetwork.size());
  if( Tiles.get( findMouseTile() ).pipeInd.x > -1 ){
  print("fluidIn; ", pipeNetwork.get( int(Tiles.get( findMouseTile() ).pipeInd.x) ).get( int(Tiles.get( findMouseTile() ).pipeInd.y) ).fluidIn);print("   ///   ");println("fluidType; ",pipeNetwork.get( int(Tiles.get( findMouseTile() ).pipeInd.x) ).get( int(Tiles.get( findMouseTile() ).pipeInd.y) ).fluidType);}

  println("---");
  print("PipeNetwork; ");print("( ");
  for(int i=0; i<pipeNetwork.size(); i++)
  {
    print(pipeNetwork.get(i).size());print(", ");
  }
  println(" )");
  println("---");
  
  println(cropList);
  
  println("---");
  println("->MouseX; ",mouseX);
  println("->MouseY; ",mouseY);
  println("---");
}

void mapOverlay(){
  pushStyle();
  pushMatrix();
  
  translate(60,60);
  rectMode(CENTER);
  fill(200,200,200);
  ellipse(0,0,(boardWidth)/30, (boardHeight)/30);
  fill(255,200,200);
  rect( 0, 0, (boardWidth)/50, (boardHeight)/50 );//Board
  fill(200,255,200);
  rect( ( relativePos.x - boardWidth/2 )/50, ( relativePos.y - boardHeight/2 )/50, (screenWidth)/50, (screenHeight)/50 );//Screen
  fill(0);
  ellipse( ( (relativePos.x + (user.pos.x - screenWidth/2)) - boardWidth/2 )/50, ( (relativePos.y + (user.pos.y - screenHeight/2)) - boardHeight/2 )/50, (2), (2));//User
  
  popMatrix();
  popStyle();
}

void calcInventory(){
  
  //(1)Remove excess items in inventory
  //println("Current size of inv; ", user.inventoryItems.size() );
  //println("Max room in inv    ; ", ( inventoryCols*(inventoryRows-inventoryRowsSpare) ) );
  if( (user.inventoryItems.size()) > (inventoryCols*(inventoryRows-inventoryRowsSpare)) )
  {
    println("*Not enough inventory space*");
    user.inventoryItems.remove( user.inventoryItems.size()-1 );
    user.inventoryQuantity.remove( user.inventoryItems.size()-1 );
  }
}
//## MAKE SO WILL EXPAND BUBBLE (AND SHIFT OTHERS) WHEN MOUSED OVER ##//

void displayInventory(){

  //(1)Draw bubbles, texture and text for each inventory item
  if(user.inventoryItems.size() < invDisplayMax){
  invDisplayNum = user.inventoryItems.size();}
  else{
  invDisplayNum = invDisplayMax;}
  
  for(int i=0; i<invDisplayNum; i++)
  {
    pushStyle();
    
    strokeWeight(2);
    fill(200,255,200); 
    ellipse( bubbleBorder + ( (i+1)*(screenWidth - 2*bubbleBorder) / ( invDisplayNum+1 ) ), (bubbleLen.y), bubbleLen.x, bubbleLen.y);         //Bubble
    
    imageMode(CENTER);
    image(test1, bubbleBorder + ( (i+1)*(screenWidth - 2*bubbleBorder) / ( invDisplayNum+1 ) ), (bubbleLen.y));                               //Texture
    
    textAlign(CENTER);
    fill(0);
    textSize(18);
    text(user.inventoryQuantity.get(i), bubbleBorder + ( (i+1)*(screenWidth - 2*bubbleBorder) / ( invDisplayNum+1 ) ), (bubbleLen.y*(2.1)));  //Quantity
    
    fill(0);
    textSize(13);
    text(user.inventoryItems.get(i), bubbleBorder + ( (i+1)*(screenWidth - 2*bubbleBorder) / ( invDisplayNum+1 ) ), (bubbleLen.y*(1.75)));    //Item Name
    
    popStyle();
  }
}

void displayTileCursor(){
  relativeObjPos = findRelativeCoordinates( findMouseTile() );
  pushStyle();
  
  stroke(240,220,120);
  strokeWeight(2);
  
  //TopLeft
  line(relativeObjPos.x-wallWidth/2,relativeObjPos.y-wallHeight/2,   relativeObjPos.x-wallWidth/2,relativeObjPos.y-tileCursorTolerance);
  line(relativeObjPos.x-wallWidth/2,relativeObjPos.y-wallHeight/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y-wallHeight/2);
  
  //TopRight
  line(relativeObjPos.x+wallWidth/2,relativeObjPos.y-wallHeight/2,   relativeObjPos.x+wallWidth/2,relativeObjPos.y-tileCursorTolerance);
  line(relativeObjPos.x+wallWidth/2,relativeObjPos.y-wallHeight/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y-wallHeight/2);
  
  //BottomLeft
  line(relativeObjPos.x-wallWidth/2,relativeObjPos.y+wallHeight/2,   relativeObjPos.x-wallWidth/2,relativeObjPos.y+tileCursorTolerance);
  line(relativeObjPos.x-wallWidth/2,relativeObjPos.y+wallHeight/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y+wallHeight/2);
  
  //BottomRight
  line(relativeObjPos.x+wallWidth/2,relativeObjPos.y+wallHeight/2,   relativeObjPos.x+wallWidth/2,relativeObjPos.y+tileCursorTolerance);
  line(relativeObjPos.x+wallWidth/2,relativeObjPos.y+wallHeight/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y+wallHeight/2);
  
  popStyle();
}

int calcInvCursor(){
  if( ((mouseX>=(inventoryX-inventoryWidth/2))&&(mouseX<=(inventoryX+inventoryWidth/2))) && ((mouseY>=(inventoryY-inventoryHeight/2))&&(mouseY<=(inventoryY+inventoryHeight/2))) ) //Only draw when hovering over inventory
  {
    invCursorInd = floor( floor(mouseX-(inventoryX - inventoryWidth /2))/(inventoryXspace) ) + floor( floor(mouseY-(inventoryY - inventoryHeight/2))/(inventoryYspace) ) * ( inventoryCols );
    println("InvCursorLoc; ",invCursorInd);                  //*****//
  }
  return invCursorInd;
}

int calcContainerCursor(){
  if( (containerBoxX<=mouseX)&&(mouseX<=(containerBoxX + (widthTemp*tWidthTemp))) && ( (containerBoxY<=mouseY)&&(mouseY<=(containerBoxY + (heightTemp*tHeightTemp))) ) ) //Only draw when hovering over inventory
  {
    //containerCursorInd = floor( floor(mouseX-containerBoxX)/(widthTemp) ) + floor( floor(mouseY-containerBoxY)/(heightTemp) ) * ( tWidthTemp );
    //In the form; --> containerCursorInd = ( X ) + ( Y )*(ColNumber);
    containerCursorInd = ( floor( (mouseX-containerBoxX)/(widthTemp) ) ) + ( floor( (mouseY-containerBoxY)/(heightTemp) ) )*( tWidthTemp );
    println("ContainerCursorLoc; ",containerCursorInd);      //*****//
  }
  return containerCursorInd;
}

void displayInvCursor(){
  if( ((mouseX>=(inventoryX-inventoryWidth/2))&&(mouseX<=(inventoryX+inventoryWidth/2))) && ((mouseY>=(inventoryY-inventoryHeight/2))&&(mouseY<=(inventoryY+inventoryHeight/2))) ) //Only draw when hovering over inventory
  {
    //Not actually relative, just easier to use this
    relativeObjPos.x = (inventoryX - inventoryWidth /2 + inventoryXspace/2) + ( floor((mouseX-(inventoryX - inventoryWidth /2)) / (inventoryXspace))*(inventoryXspace) );
    relativeObjPos.y = (inventoryY - inventoryHeight/2 + inventoryYspace/2) + ( floor((mouseY-(inventoryY - inventoryHeight/2)) / (inventoryYspace))*(inventoryYspace) );
    pushStyle();
    
    stroke(240,220,20);
    strokeWeight(4);
    
    //TopLeft
    line(relativeObjPos.x-inventoryXspace/2,relativeObjPos.y-inventoryYspace/2,   relativeObjPos.x-inventoryXspace/2,relativeObjPos.y-tileCursorTolerance);
    line(relativeObjPos.x-inventoryXspace/2,relativeObjPos.y-inventoryYspace/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y-inventoryYspace/2);
    
    //TopRight
    line(relativeObjPos.x+inventoryXspace/2,relativeObjPos.y-inventoryYspace/2,   relativeObjPos.x+inventoryXspace/2,relativeObjPos.y-tileCursorTolerance);
    line(relativeObjPos.x+inventoryXspace/2,relativeObjPos.y-inventoryYspace/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y-inventoryYspace/2);
    
    //BottomLeft
    line(relativeObjPos.x-inventoryXspace/2,relativeObjPos.y+inventoryYspace/2,   relativeObjPos.x-inventoryXspace/2,relativeObjPos.y+tileCursorTolerance);
    line(relativeObjPos.x-inventoryXspace/2,relativeObjPos.y+inventoryYspace/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y+inventoryYspace/2);
    
    //BottomRight
    line(relativeObjPos.x+inventoryXspace/2,relativeObjPos.y+inventoryYspace/2,   relativeObjPos.x+inventoryXspace/2,relativeObjPos.y+tileCursorTolerance);
    line(relativeObjPos.x+inventoryXspace/2,relativeObjPos.y+inventoryYspace/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y+inventoryYspace/2);
    
    popStyle();
  }
}

void displayContainerCursor(){
  if( ((mouseX>=(containerBoxX))&&(mouseX<(containerBoxX + (widthTemp*tWidthTemp)))) && ((mouseY>=(containerBoxY))&&(mouseY<(containerBoxY + (heightTemp*tHeightTemp)))) ) //Only draw when hovering over inventory
  {
    
    //Not actually relative, just easier to use this
    relativeObjPos.x = containerBoxX + widthTemp /2 + ( floor( (mouseX-containerBoxX)/(widthTemp ) ) )*( widthTemp  );
    relativeObjPos.y = containerBoxY + heightTemp/2 + ( floor( (mouseY-containerBoxY)/(heightTemp) ) )*( heightTemp );
    pushStyle();
    
    stroke(240,220,20);
    strokeWeight(4);
    
    //TopLeft
    line(relativeObjPos.x-widthTemp/2,relativeObjPos.y-heightTemp/2,   relativeObjPos.x-widthTemp/2,relativeObjPos.y-tileCursorTolerance);
    line(relativeObjPos.x-widthTemp/2,relativeObjPos.y-heightTemp/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y-heightTemp/2);
    
    //TopRight
    line(relativeObjPos.x+widthTemp/2,relativeObjPos.y-heightTemp/2,   relativeObjPos.x+widthTemp/2,relativeObjPos.y-tileCursorTolerance);
    line(relativeObjPos.x+widthTemp/2,relativeObjPos.y-heightTemp/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y-heightTemp/2);
    
    //BottomLeft
    line(relativeObjPos.x-widthTemp/2,relativeObjPos.y+heightTemp/2,   relativeObjPos.x-widthTemp/2,relativeObjPos.y+tileCursorTolerance);
    line(relativeObjPos.x-widthTemp/2,relativeObjPos.y+heightTemp/2,   relativeObjPos.x-tileCursorTolerance,relativeObjPos.y+heightTemp/2);
    
    //BottomRight
    line(relativeObjPos.x+widthTemp/2,relativeObjPos.y+heightTemp/2,   relativeObjPos.x+widthTemp/2,relativeObjPos.y+tileCursorTolerance);
    line(relativeObjPos.x+widthTemp/2,relativeObjPos.y+heightTemp/2,   relativeObjPos.x+tileCursorTolerance,relativeObjPos.y+heightTemp/2);
    
    popStyle();
  }
}

void calcCursorType(){
  if(inventoryScreen==true)
  {
    displayInvCursor();
  }
  if(showContainer==true)
  {
    displayContainerCursor();
  }
  if( (inventoryScreen==false) && (showContainer==false) )
  {
    displayTileCursor();
  }
}


void displayCursor(){
  pushStyle();
  imageMode(CENTER);
  noCursor();
  if(modeSelector==0)
  {
    image(explorationCursor, mouseX, mouseY);
  }
  if(modeSelector==1)
  {
    image(buildingCursor, mouseX, mouseY);
  }
  if(modeSelector==2)
  {
    image(pipingCursor, mouseX, mouseY);
  }
  if(modeSelector==3)
  {
    image(cropCursor, mouseX, mouseY);
  }
  popStyle();
}

void displayMode(){
  pushStyle();
  textAlign(CENTER);
  textSize(20);
  fill(255);
  
  if(modeSelector==0){
  text("Exploration Mode", screenWidth/2, 60);}
  if(modeSelector==1){
  text("Building Mode", screenWidth/2, 60);}
  if(modeSelector==2){
  text("Piping Mode", screenWidth/2, 60);}
  if(modeSelector==3){
  text("Crop Mode", screenWidth/2, 60);}
  
  popStyle();
}

void displayTileTypeSel(){
  pushStyle();
  textSize(15);
  textAlign(LEFT);
  fill(0);
  text(tileTypeSel, mouseX-10, mouseY-10);
  popStyle();
}
void displayFloorTypeSel(){
  pushStyle();
  textSize(13);
  textAlign(LEFT);
  fill(0);
  text(floorTypeSel, mouseX+10, mouseY+10);
  popStyle();
}

void displayCropIndSel(){
  pushStyle();
  textSize(13);
  textAlign(LEFT);
  fill(0);
  text(cropSelector, mouseX-10, mouseY-10);
  popStyle();
}

void modeSpecificOverlays(){
  if(modeSelector==0)  //Exploration mode
  {
    //pass
  }
  if(modeSelector==1)  //Building mode
  {
    
    pushStyle();
    imageMode(CENTER);
    image(buildingModeEdgeEffect, width/2, height/2);
    popStyle();
    displayTileTypeSel();
    displayFloorTypeSel();

    //-------------------------//
    //Multi-Tile ghost displays//
    //-------------------------//
    if(tileTypeSel == 7)  //undefined multi-tile
    {
      displayGhost(findMouseTile(), 3, 3);  //##SEPARATE CALCULATIONS AND DRAWING##//
    }
    if(tileTypeSel == 10)  //undefined multi-tile
    {
      displayGhost(findMouseTile(), 3, 3);  //##SEPARATE CALCULATIONS AND DRAWING##//
    }
    if(tileTypeSel == 17)  //undefined multi-tile
    {
      displayGhost(findMouseTile(), 7, 7);  //##SEPARATE CALCULATIONS AND DRAWING##//
    }
    if(tileTypeSel == 18)  //undefined multi-tile
    {
      displayGhost(findMouseTile(), 9, 9);  //##SEPARATE CALCULATIONS AND DRAWING##//
    }

  }
  if(modeSelector==2)  //Piping mode
  {
    pushStyle();
    imageMode(CENTER);
    image(pipingModeEdgeEffect, width/2, height/2);
    popStyle();
  }
  if(modeSelector==3)  //Crop mode
  {
    pushStyle();
    imageMode(CENTER);
    image(cropModeEdgeEffect, width/2, height/2);
    displayCropIndSel();
    popStyle();
  }
}

void displayExplortionHotkeys(){
  pushStyle();
  fill(219, 240, 185);
  textSize( hotkeySize );
  textAlign(LEFT);
  rectMode(CENTER);  //##REPLACE RECT WITH A TRANSLUCENT RECTANGLE, WITH SOME PATTERNS OR SOMETHING##//
  imageMode(CENTER);
  
  rect(hotkeyCenterX, hotkeyCenterY, hotkeyBoxWidth, hotkeyBoxHeight);
  
  fill(0);
  text("Add items   ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("o",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Remove items;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("p",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Interact    ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("e",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Move        ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("wasd",  hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("UrgencyUp   ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("n",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("UrgencyDwn  ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("m",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Stat screen ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("v",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Add event   ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("k",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("FacInterest+;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("9",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("FacInterest-;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("8",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Container++ ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (11*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("1",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (11*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Container-- ;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (12*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("2",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (12*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  
  popStyle();
}

void displayBuildingHotkeys(){
  pushStyle();
  fill(219, 240, 185);
  textSize( hotkeySize );
  textAlign(LEFT);
  rectMode(CENTER);  //##REPLACE RECT WITH A TRANSLUCENT RECTANGLE, WITH SOME PATTERNS OR SOMETHING##//
  imageMode(CENTER);
  
  rect(hotkeyCenterX, hotkeyCenterY, hotkeyBoxWidth, hotkeyBoxHeight);
  
  fill(0);
  text("Next tile  ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("1",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Last tile  ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("2",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Place tile ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("3",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Next floor ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("4",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Last floor ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("5",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Place floor; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("6",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("F tSetUp1% ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("j",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("F tSetDwn1%; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("k",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("O tSetUp1% ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("g",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("O tSetDwn1%; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("h",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  
  popStyle();
}

void displayPipingHotkeys(){
  pushStyle();
  fill(219, 240, 185);
  textSize( hotkeySize );
  textAlign(LEFT);
  rectMode(CENTER);  //##REPLACE RECT WITH A TRANSLUCENT RECTANGLE, WITH SOME PATTERNS OR SOMETHING##//
  imageMode(CENTER);
  
  rect(hotkeyCenterX, hotkeyCenterY, hotkeyBoxWidth, hotkeyBoxHeight);
  
  fill(0);
  text("Output pipe    ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("1",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Input pipe     ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("2",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Connecting pipe; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("3",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Remove pipe    ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("4",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("ReleaseFluid   ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("5",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("TglFluidDisplay; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("6",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  
  popStyle();
}

void displayCropHotkeys(){
  pushStyle();
  fill(219, 240, 185);
  textSize( hotkeySize );
  textAlign(LEFT);
  rectMode(CENTER);  //##REPLACE RECT WITH A TRANSLUCENT RECTANGLE, WITH SOME PATTERNS OR SOMETHING##//
  imageMode(CENTER);
  
  rect(hotkeyCenterX, hotkeyCenterY, hotkeyBoxWidth, hotkeyBoxHeight);
  
  fill(0);
  text("cropSelector++ ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("1",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("cropSelector-- ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("2",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Place crop     ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("3",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("Remove crop    ; ", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("4",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  
  popStyle();
}

void displayIndexMenu(){
  pushStyle();
  fill(219, 240, 185);
  textSize( hotkeySize );
  textAlign(CENTER);
  rectMode(CENTER);  //##REPLACE RECT WITH A TRANSLUCENT RECTANGLE, WITH SOME PATTERNS OR SOMETHING##//
  imageMode(CENTER);
  
  fill(0);
  text("INDEX",   hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,(0*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("OBJECT",       hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (0*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("-------", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,(0.5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("--------",   hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (0.5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 0;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Empty tile",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 0;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Empty tile",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (1*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 1;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Wall",           hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (2*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 2;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Barrel",         hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (3*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 3;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Door",           hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (4*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 4;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Table",          hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (5*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 5;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Stool",          hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (6*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 6;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Counter",        hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (7*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 7;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Multi-Tile",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (8*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 8;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Tree",           hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti,  (9*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text(" 9;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Water",          hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (10*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("10;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (11*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Large Tree",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (11*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("11;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (12*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Water pump",     hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (12*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("12;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (13*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Brewing vat",    hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (13*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("13;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (14*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Machinery",      hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (14*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  text("14;", hotkeyCenterX-hotkeyBoxWidth/hotkeyOffsetMulti, (14*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2));text("Field",          hotkeyCenterX+hotkeyBoxWidth/hotkeyOffsetMulti, (14*hotkeyIncr)+(hotkeyCenterY - hotkeyBoxHeight/2) );
  
  popStyle();
}

void timeOverlay(){
  pushStyle();
  rectMode(CENTER);
  imageMode(CENTER);

  //(1)Draw Sun
  image(sunTimeDisplay, timeDisplayX, timeDisplayY);

  //(2)Draw moon overlapping
  //image(moonTimeDisplay, timeDisplayX, timeDisplayY);   //Crescent moon
  daylightMultiplier = timeTransition();
  image(moonFullTimeDisplay, timeDisplayX + daylightMultiplier*100 - 100, timeDisplayY); //Full moon

  //(3)Draw outer border for sun
  image(sunOuterTimeDisplay, timeDisplayX, timeDisplayY);

  //## NEED COVER MECHANICS FOR MOON OVER SUN ##//

  popStyle();
}

void innStatusSign(){
  //(1)Display current status
  pushStyle();
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(20);

  //fill(237, 221, 140);
  //rect(innStatusSignX, innStatusSignY, innStatusSignWidth,innStatusSignHeight);

  fill(0);
  if(innStatus == true){
    //textFormatted(...);
    //text("OPEN", innStatusSignX, innStatusSignY);
    image(innStatusOpen, innStatusSignX, innStatusSignY);
  }
  else{
    //textFormatted(...);
    //text("CLOSED", innStatusSignX, innStatusSignY);
    image(innStatusClosed, innStatusSignX, innStatusSignY);
  }

  popStyle();

  //(2)Click on sign to switch status
  //pass
}

void sleepBar(){
  pushStyle();
  imageMode(CENTER);

  fill(140, 237, 235);
  image(sleepBar, sleepBarX, sleepBarY);
  //ellipse(sleepBarX, sleepBarY, sleepBarRadi, sleepBarRadi);
  //## NEED COVER MECHANICS ##//

  popStyle();
}

void urgencyBar(){
  pushStyle();
  imageMode(CENTER);

  fill(179, 101, 89);
  image(urgencyBar, urgencyBarX, urgencyBarY);
  //ellipse(urgencyBarX, urgencyBarY, urgencyBarRadi, urgencyBarRadi);
  //## NEED COVER MECHANICS ##//

  popStyle();
}

void forecastBar(){
  pushStyle();
  imageMode(CENTER);

  fill(110, 217, 106);
  image(forecastBarRain, forecastBarX, forecastBarY); //Add if statement to determine which weather effect will occur
  //ellipse(forecastBarX, forecastBarY, forecastBarRadi, forecastBarRadi);
  //## NEED COVER MECHANICS ##//

  popStyle();
}

void factionRelationsBars(){
  pushStyle();
  imageMode(CENTER);
  rectMode(CORNER);

  fill(224, 186, 146);
  for(int i=0; i<factionIcon.size(); i++)
  {
    image( factionIcon.get(i) , factionBarX, factionBarY + i*factionBarSpacing );
    rect(factionBarX + factionBarIconSpacing, factionBarY + i*factionBarSpacing, factionBarMax*(factionInterest.get(i)), factionBarHeight ); //##+40 FOR ICON WIDTH##//
  }

  popStyle();
}

void nightOverlay(){
  pushStyle();
  imageMode(CENTER);
  rectMode(CENTER);

  //image(nightFilter, screenWidth/2, screenHeight/2);  //NOT NEEDED, BETTER WITH PROCESSING COLOURS, BUT CAN USE FOR STARS, ETC
  daylightMultiplier = timeTransition();// * darknessMaxMultiplier;
  //println(daylightMultiplier);                                            //*****//
  fill(20,20,20,   255*daylightMultiplier);  //RGB, Opacity
  rect(screenWidth/2, screenHeight/2, screenWidth, screenWidth);

  popStyle();
}

void playerTorch(){
  if(playerTorchActive == true)
  {
    pushStyle();
    noStroke();

    //fill(235, 233, 195,   120);  //RGB, Opacity
    fill(20,20,20,   80);
    ellipse(user.pos.x, user.pos.y, 300, 300);

    popStyle();
  }
}

void dayNumberDisplay(){
  pushStyle();
  textSize(30);
  textAlign(CENTER);

  text(dayNumber, timeDisplayX, timeDisplayY+75);

  popStyle();
}

void displayUserMoney(){
  pushStyle();
  imageMode(CENTER);
  textSize(20);
  textAlign(LEFT);

  image(coinIcon  , 17*screenWidth/20,          screenHeight/20    );
  text( user.coins, 17*screenWidth/20 +20,      screenHeight/20 +10);

  popStyle();
}
