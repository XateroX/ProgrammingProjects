void keyPressed(){
  //----------------------//
  //## Exploration mode ##//
  //----------------------//
  if(modeSelector == 0)  //If ExplorationMode
  {
    if (key == 'w')      //Up
    {
      user.vel.y = -user.urgency;
    }
    if (key == 'a')      //Left
    {
      user.vel.x = -user.urgency;
    }
    if (key == 's')      //Down
    {
      user.vel.y =  user.urgency;
    }
    if (key == 'd')      //Right
    {
      user.vel.x =  user.urgency;
    }
    
    if (key == 'v')
    {
      //if within given area around stats box OR while not moving OR ...
      if(true)
      {
        followerUstatTravel = true;            //Move follower over to "investigate" / display description
        tileStatScreen = true;
        currentStatTile = findMouseTile();
        relativeObjPos = findRelativeCoordinates(currentStatTile); 
        followerWaypointU.x = ( relativeObjPos.x ) - wallWidth /2 -wallWidth /6;
        followerWaypointU.y = ( relativeObjPos.y ) + wallHeight/2 +wallHeight/6;
      }
    }
    if (key == 'b')
    {
      followerUstatTravel = true;   //## To allow him to move freely, should be given a more apprpporiate name ##//
      followerPathFollow = !followerPathFollow;
    }
    if(key == '1')
    {
      catalogueCheck = checkForType(containerTile, containerCatalogue);
      if( catalogueCheck == true ){ //If a container here...
        //################################################//
        //## WOULD BE MUCH BETTER WITH CATALOGUE METHOD ##//
        //################################################//
        if(Tiles.get( containerTile ).type == 2){
          exchangeItems( 5, calcInvCursor(), int( ((Barrel)(Tiles.get( containerTile ))).containerInd.x ), calcContainerCursor() );
        }
        if(Tiles.get( containerTile ).type == 17){
          exchangeItems( 5, calcInvCursor(), int(  ((TradingOutpost)(Tiles.get( containerTile ))).containerInd.x  ), calcContainerCursor() );
        }
        //exchangeItems( 5, calcInvCursor(), int(  (Tiles.get( containerTile ).classType)(Tiles.get( containerTile )).containerInd.x  ), calcContainerCursor() );
      }
    }
    if (key == 'k')
    {
      println("Filler Event Added");
      eventsShort.add      (0,"New event here");
      eventsDescription.add(0,"The lengthy description of the event in question here, formatted properly");
    }
    if (key == '9')
    {
      increaseFactionInterest(0);
    }
    if (key == '8')
    {
      decreaseFactionInterest(0);
    }
    if (key == '7')
    {
      structureToggle = !structureToggle;
    }
    if (key == '6')
    {
      calcPlaceableStructure();
    }
    if (key == '5')
    {
      println("Drink 1 added to user");
      user.currentDrink.clear();
      user.currentDrink.add(1);   //Type
      user.currentDrink.add(568); //Volume
      user.currentDrink.add(1);   //Bitterness
      user.currentDrink.add(5);   //Sweetness
      user.currentDrink.add(2);   //Alcoholicness
      user.currentDrink.add(8);   //Quality
    }
    if (key == '4')
    {
      for(int i=0; i<entityList.size(); i++) //## VERY INEFFICIENT ##//
      {
        for(int j=0; j<entityList.get(i).size(); j++)
        {
          relativeObjPos = findRelativeCoordinatesEntity( entityList.get(i).get(j).pos );
          if( pow(relativeObjPos.x - mouseX,2) + pow(relativeObjPos.y - mouseY,2) < pow(wallWidth,2) )
          {
            entityList.get(i).get(j).currentDrink.clear();
            for(int z=0; z<user.currentDrink.size(); z++){
              entityList.get(i).get(j).currentDrink.add( user.currentDrink.get(z) );
            }
            println("Drink given to entity");
            break;
          }
        }
      }
    }

    if (key == 'm')
    {
      scannerToggle = !scannerToggle;

      //#### CAN OPTIMISE BY SAYING ONLY DO THE SCAN WHEN OPENING THE SCANNER, NOT WHEN CLOSING IT TOO ####//
      //(1)Reset scanned values
      scannerTile.clear();
      scannerTileQuantity.clear();
      scannerTile.add( Tiles.get(0).type );  //To start off the process
      scannerTileQuantity.add( 0 );           //

      //(2)Re-scan the area, store all values
      for(int i=0; i<Tiles.size(); i++)           //Go through all tiles...
      {
        for(int j=0; j<scannerTile.size(); j++)   //For each, go through all currently scanned tile types recorded...
        {

          //If the tile HAS appeared before...
          if(Tiles.get(i).type == scannerTile.get(j)){
            scannerQuantityTemp = scannerTileQuantity.get(j);
            scannerTileQuantity.remove(j);
            scannerTileQuantity.add(j, scannerQuantityTemp+1);
            break;
          }

          //If the tile HAS NOT appeared before (after reaching end of list)...
          if(j == scannerTile.size() -1){
            scannerTile.add( Tiles.get(i).type );
            scannerTileQuantity.add(1);
            break;
          }
          
        }
      }

    }
  
  }
  

  //----------------------------//
  //## Available in all modes ##//
  //----------------------------//
  if (key == 'i')
  {
    inventoryScreen =! inventoryScreen;
  }
  if (key == 'u')
  {
    homeScreen =! homeScreen;
    optionsScreen = false;
    indexMenu     = false;
  }
  if (key == 'm')
  {
    user.urgency -= 1;
  }
  if (key == 't')
  {
    playerTorchActive = !playerTorchActive;
  }
  if (key == 'n')
  {
    user.urgency += 1;
  }
  if (key == 'o')
  {
    user.inventoryItems.add("Plank");
    user.inventoryQuantity.add(10);
    user.inventoryItems.add("Fertilizer");
    user.inventoryQuantity.add(2);
    user.inventoryItems.add("Board");
    user.inventoryQuantity.add(1);
    user.inventoryItems.add("Seeds");
    user.inventoryQuantity.add(5);
    user.inventoryItems.add("Spade");
    user.inventoryQuantity.add(1);
  }
  if (key == 'p')
  {
    if(user.inventoryItems.size() > 0)
    {
      user.inventoryItems.remove( user.inventoryItems.size()-1 );
      user.inventoryQuantity.remove( user.inventoryQuantity.size()-1 );
    }
    else
    {
      println("*No items in inventory*");
    }
  }
  if (key == 'e')  //Interact button
  {
    //EITHER
    //(1)Add item to inventory
    findHoveredType( findMouseTile() );
    
    //(2)OR harvest crop
    if( Tiles.get(findMouseTile()).type == 14 ){                     //If a field...
      if( ((Field)Tiles.get( findMouseTile() )).cropInd.x > -1 ){    //If crop here...
        harvestCrop( findMouseTile() );                              //Try harvest it
      }                  
    }
    
    //(3)OR open container
    //######################################################//
    //## MAY BE BROKEN, MAY NEED TO MOVE THE } FURTHER UP ##//
    //######################################################//
    catalogueCheck = checkForType( findMouseTile(), containerCatalogue);
    if( catalogueCheck == true ){
      containerTile   = findMouseTile();
      if( (showContainer == true) && (inventoryScreen == false) ){
        showContainer = false;}
      if( (showContainer == false) && (inventoryScreen == true) ){
        inventoryScreen = false;}
      showContainer   = !showContainer;
      inventoryScreen = !inventoryScreen;
    }

    //(4)OR use machine
    //...
  }
  if(key == 'h')  //Hotkey menu toggle
  {
    hotkeyMenuScreen =! hotkeyMenuScreen;
  }
  

  mouseTile = findMouseTile();
  //-------------------//
  //## Building mode ##//
  //-------------------//
  if(modeSelector == 1)  //If BuildingMode
  {
    //##ADD SCREEN DARKENING EDGE EFFECT, SLIGHTLY DIFFERENTLY HOWEVER##//
    if (key == '4'){
      pieToggle = !pieToggle;}
    if (key == '5'){
      catalogueToggle = !catalogueToggle;}

    //#################################################//
    //## NEED TO CHANGE OVER TO THE PIE SELECTOR TOO ##//
    //#################################################//
    if (key == '1'){
      floorTypeSel  += 1;}
    if (key == '2'){
      floorTypeSel -= 1;}

    if (key == '6'){
      Tiles.get( mouseTile ).floorType = floorTypeSel;}
    if (key == 'k')
    {
      Tiles.get( mouseTile ).tSetF -= 1;
    }
    if (key == 'j')
    {
      Tiles.get( mouseTile ).tSetF += 1;
    }
    if (key == 'h')
    {
      Tiles.get( mouseTile ).tSetO -= 1;
    }
    if (key == 'g')
    {
      Tiles.get( mouseTile ).tSetO += 1;
    }
  }

  //-----------------//
  //## Piping mode ##//
  //-----------------//
  if(modeSelector == 2)  //If PipingMode
  {
    networkNum = int( Tiles.get(findMouseTile()).pipeInd.x );
    if (key == '1'){      //Place output pipe
      increasePipeNetwork(findMouseTile(), 1);
      calcPipeConnections( networkNum );
      calcPipeStarts();}
    if (key == '2'){      //Place input pipe
      increasePipeNetwork(findMouseTile(), 2);
      calcPipeConnections( networkNum );
      calcPipeStarts();}
    if (key == '3'){      //Place connecting pipe
      increasePipeNetwork(findMouseTile(), 3);
      calcPipeConnections( networkNum );
      calcPipeStarts();}
    if (key == '4'){      //Place connecting pipe
      removePipeNetwork(findMouseTile());
      calcPipeConnections( networkNum );
      calcPipeStarts();}
    if (key == '5'){      //Allow water to flow
      calcPipeConnections( networkNum );
      calcPipePaths( outputPipesTemp, networkNum );
      calcInputFlows();}
    if (key == '6'){      //Toggle fluid display
      showPipeFluidFlow =! showPipeFluidFlow;}
  }

  //---------------//
  //## Crop mode ##//
  //---------------//
  if(modeSelector == 3)  //If CropMode
  {
    if (key == '1'){      //Increase crop selection
      cropSelector ++;}
    if (key == '2'){      //Decrease crop selection
      cropSelector--;}
    if (key == '3'){      //Place crop selection on hovered field
      placeCrop();}
    if (key == '4'){      //Remove crop from hovered field
      removeCrop( findMouseTile() );}
  }
      
  if (key == '0'){  //Cycle through modes
    modeSelector++;
    if(modeSelector > 3){  //**Increase value when more modes are added**
    modeSelector = 0;}
    //(0)ExplorationMode
    //(1)BuildingMode
    //(2)PipingMode
    //(3)CropMode
  }
  
}

void keyReleased(){
  if (key == 'w')      //Up
  {
    user.vel.y = 0;
    frameTimerY = 0;
  }
  if (key == 'a')      //Left
  {
    user.vel.x = 0;
    frameTimerX = 0;
  }
  if (key == 's')      //Down
  {
    user.vel.y = 0;
    frameTimerY = 0;
  }
  if (key == 'd')      //Right
  {
    user.vel.x = 0;
    frameTimerX = 0;
  }
}

void mousePressed(){
  
  //--------// HOME SCREEN //--------//
  if(homeScreen == true)
  {
    //1 , 2
    //3 , 4
    
    //1st
    if( (  (screenWidth/8-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/8+homeButtonWidth/2)  )&&(  ((3*screenWidth/8)+(2*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < ((3*screenWidth/8))+(2*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 1st home button");
      homeScreen = false;
    }
    //2nd
    if( (  (7*screenWidth/8-homeButtonWidth/2<mouseX)&&(mouseX<7*screenWidth/8+homeButtonWidth/2)  )&&(  ((3*screenWidth/8)+(2*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < ((3*screenWidth/8))+(2*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      //##NEEDS SOME TESTING, VERY RUDIMENTARY, NOT COVERING ALL BASES##//
      println("Click 2nd home button");
      entityList.clear();
      Tiles.clear();
      pipeNetwork.clear();
      user.pos.x = screenWidth/2; user.pos.y = screenHeight/2;
      initialiseValues();
      mapGeneration();
      homeScreen = false;
    }
    //3rd
    if( (  (screenWidth/8-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/8+homeButtonWidth/2)  )&&(  (((3*screenWidth/8))+(4*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < ((3*screenWidth/8))+(4*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 3rd home button");
      optionsScreen = true;
      homeScreen    = false;
    }
    //4th
    if( (  (7*screenWidth/8-homeButtonWidth/2<mouseX)&&(mouseX<7*screenWidth/8+homeButtonWidth/2)  )&&(  (((3*screenWidth/8))+(4*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < ((3*screenWidth/8))+(4*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 4th home button");
      exit();
    }
  }
  //--------// OPTIONS //--------//
  if(optionsScreen == true)
  {
    //  1
    //  2
    //  3
    //  4
    
    //1st
    if( (  (screenWidth/2-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/2+homeButtonWidth/2)  )&&(  ((screenWidth/8)+(2*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < (screenWidth/8)+(2*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 1st home button");
      optionsScreen = false;
      indexMenu     = true;
    }
    //2nd
    if( (  (screenWidth/2-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/2+homeButtonWidth/2)  )&&(  ((screenWidth/8)+(4*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < (screenWidth/8)+(4*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      //##NEEDS SOME TESTING, VERY RUDIMENTARY, NOT COVERING ALL BASES##//
      println("Click 2nd home button");
    }
    //3rd
    if( (  (screenWidth/2-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/2+homeButtonWidth/2)  )&&(  ((screenWidth/8)+(6*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < (screenWidth/8)+(6*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 3rd home button");
    }
    //4th
    if( (  (screenWidth/2-homeButtonWidth/2<mouseX)&&(mouseX<screenWidth/2+homeButtonWidth/2)  )&&(  ((screenWidth/8)+(8*homeButtonSpacing)-homeButtonHeight/2 < mouseY)&&(mouseY < (screenWidth/8)+(8*homeButtonSpacing)+homeButtonHeight/2)  ) )//xCond then yCond for 1st box
    {
      println("Click 4th home button");
      optionsScreen = false;
      homeScreen    = true;
    }
  }
  if( (homeScreen == false) && (optionsScreen == false) ) //If in-game...
  {

    if( ((pieToggle == false) && (catalogueToggle == false)) && ((modeSelector == 1) && (mouseButton == LEFT)) )  //Placing tiles --> If in game AND in building mode AND you left click AND the (pie seletcor OR catalogue) are NOT open
    {

      alreadyDrawn = false;
      //---------------------//
      //Multi-Tile conditions//
      //---------------------//
      if ( tileTypeSel==7 )      //e.g, where tile#7 is a tractor specifically
      {
        multiTwidth  = 3; 
        multiTheight = 3;
        structurePlaceable = calcStructurePlaceable(findMouseTile(), multiTwidth, multiTheight);
        if(structurePlaceable == true)
        {
          alreadyDrawn = true;
          for(int j=-floor(multiTwidth/2); j<(multiTwidth+1)/2; j++)
          {
            for(int i=-floor(multiTheight/2); i<(multiTheight+1)/2; i++)
            {
              addTileToGrid( mouseTile + i +(j*colNum), 7);     //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
            }
          }
        }
      }
      if ( tileTypeSel==10 )
      {
        multiTwidth  = 3; 
        multiTheight = 3;
        structurePlaceable = calcStructurePlaceable(findMouseTile(), multiTwidth, multiTheight);
        if(structurePlaceable == true)
        {
          alreadyDrawn = true;
          for(int j=-floor(multiTwidth/2); j<(multiTwidth+1)/2; j++)
          {
            for(int i=-floor(multiTheight/2); i<(multiTheight+1)/2; i++)
            {
              if( (i==floor(multiTheight/2))&&(j==floor(multiTwidth/2)) ){
                addTileToGrid( mouseTile + i +(j*colNum), 10);}      //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
              else{
                addTileToGrid( mouseTile + i +(j*colNum), 15);}     //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
            }
          }
        }
      }
      if ( tileTypeSel==17 ) //Trading Outpost
      {
        multiTwidth  = 7; 
        multiTheight = 7;
        structurePlaceable = calcStructurePlaceable(findMouseTile(), multiTwidth, multiTheight);
        if(structurePlaceable == true)
        {
          alreadyDrawn = true;
          for(int j=-floor(multiTwidth/2); j<(multiTwidth+1)/2; j++)
          {
            for(int i=-floor(multiTheight/2); i<(multiTheight+1)/2; i++)
            {
              if( (i==floor(multiTheight/2))&&(j==floor(multiTwidth/2)) ){
                addTileToGrid( mouseTile + i +(j*colNum), 17);}      //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
              else{
                addTileToGrid( mouseTile + i +(j*colNum), 15);}     //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
            }
          }
        }
      }
      if ( tileTypeSel==18 ) //Port
      {
        multiTwidth  = 9; 
        multiTheight = 9;
        structurePlaceable = calcStructurePlaceable(findMouseTile(), multiTwidth, multiTheight);
        if(structurePlaceable == true)
        {
          alreadyDrawn = true;
          for(int j=-floor(multiTwidth/2); j<(multiTwidth+1)/2; j++)
          {
            for(int i=-floor(multiTheight/2); i<(multiTheight+1)/2; i++)
            {
              if( (i==floor(multiTheight/2))&&(j==floor(multiTwidth/2)) ){
                addTradingOutpostToList( Tiles.get( mouseTile + i +(j*colNum)).pos, (mouseTile + i +(j*colNum)) );
                addTileToGrid( mouseTile + i +(j*colNum), 18);}      //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
              else{
                addTileToGrid( mouseTile + i +(j*colNum), 15);}     //## DOING THIS SO IT IS A ONE-OFF ASSIGNING OF TILES ##//
            }
          }
        }
      }
      //------------------//
      //Regular conditions//
      //------------------//
      if(alreadyDrawn == false)
      {
        if(structurePlaceable == true)  //##Seems to be working, double check
        {
          addTileToGrid( mouseTile, tileTypeSel);
        }
      }

    }

    if( (  (innStatusSignX - innStatusSignWidth/2<mouseX)&&(mouseX<innStatusSignX + innStatusSignWidth/2)  )&&(  (innStatusSignY - innStatusSignHeight/2 < mouseY)&&(mouseY < innStatusSignY + innStatusSignHeight/2 ) ) )
    {
      //If within inn status sign bounds...
      innStatus = !innStatus;
    }
    //##MAKE BUTTONS FLASH WHEN PRESSED##//
    if(eventsShort.size() > 0)  //If anything to remove...
    {
      if(eventCurrentlyHovered == true)
      {
        eventsShort.      remove( eventHovered() );
        eventsDescription.remove( eventHovered() );
      }
    }

    if( (mouseButton == LEFT) && ((catalogueToggle == true) && (hoveredIndCata != -1)) )  //If showing the catalogue screen AND are hovered over an item...
    {
      //Clicking LEFT CLICK adds it to the pie selector
      pieSelected.add( hoveredIndCata );
    }

    if( (mouseButton == LEFT) && (( (pieToggle == true)&&(catalogueToggle == false) ) && (hoveredIndPie != -1)) )  //If showing the pie selector screen AND are hovered over an item...
    {
      //Clicking LEFT CLICK chooses item to be placed + closing selection screen
      //#### CURRENTLY IS NOT SUPPORTING FLOOR PLACEMENT ####//
      if(hoveredIndPie > -1)
      {
        tileTypeSel = pieSelected.get( hoveredIndPie ) +1; //**Because does not inclde 0**//
        pieToggle = false;
      }
      if(hoveredIndPie == -2) //Signifies 'removal tool'
      {
        tileTypeSel = 0;
        pieToggle = false;
      }
    }
    if( (mouseButton == RIGHT) && ((pieToggle == true) && (hoveredIndPie != -1)) )  //If showing the pie selector screen AND are hovered over an item...
    {
      //Clicking RIGHT CLICK removes the item from the pie selector
      if(hoveredIndPie > -1)  //If anything available to be deleted    //## pieSelected.size() > 0 ##// BUSTED ???
      {
        pieSelected.remove( hoveredIndPie );
      }
      else
      {
        println("--Pie selector already empty--");
      }
      
    }

  }

    //Some general sounds on mouse click
    if(homeScreen == true)
    {
      buttonSelectionSound.play();
    }
    else if(inventoryScreen == true)
    {
      openInventorySound.play();
    }
    else
    {

      if(mouseButton == LEFT){
        generalClickSound.play();
      }
      else{
        placeTileSound.play();
      }
      
    }
  
}

//** +ve getCount = scroll down (towards you)
//** -ve getCount = scroll up (away from you)
void mouseWheel(MouseEvent event){
  //Scanner functionality
  if(scannerToggle == true)
  {

    if( event.getCount() < 0 ){
      scannerMode++;}
    if( event.getCount() > 0 ){
      scannerMode--;}
    
    if(scannerMode < 0){
      scannerMode = maxScannerMode;
    }
    if(scannerMode > maxScannerMode){
      scannerMode = 0;
    }

  }
  
}


//############################################################################################################//
//## WORST CASE SCENARIO, JUST DETECT PUMP AT OUTPUT, THEN MAKE ALL PIPES IN THAT NETWORK THE NEEDED VALUES ##//
//############################################################################################################//
