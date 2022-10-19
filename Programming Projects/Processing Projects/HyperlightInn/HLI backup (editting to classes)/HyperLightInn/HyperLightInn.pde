import processing.sound.*;

void setup(){
  size(800,800);
  frameRate(60);
  
  //Initialise
  initialiseValues();
  mapGeneration();

  //##
  pieSelected.add(0);
  pieSelected.add(1);
  pieSelected.add(2);
  pieSelected.add(3);
  pieSelected.add(4);
  //##

}

void draw(){
  //Home Screen//
  //-----------//
  //## CAN SLIM DOWN, INTO A 'IS HOMESCREEN ON', THEN 'IS OPTIONS ON', AND SO ON TO REDUCE NUMBER OF "ELSE IF"S
  if(homeScreen == true)
  {
    background(225,105,250);
    displayHomeScreen();
    displayCursor();
  }
  else if(optionsScreen == true)
  {
    background(255,200,200);
    displayOptions();
    displayCursor();
  }
  else if(indexMenu == true)
  {
    background(255,200,200);
    displayIndexMenu();
    displayCursor();
  }
  else
  {
    structurePlaceable = true;  //##MOVE SOMEWHERE ELSE BETTER##
    //Draw background//
    //---------------//
    drawBackground();
    calcPipes();
    calcDisplayPipeFluid();
    
    //Draw foreground//
    //---------------//
    //drawForegroundCreatures();
    drawForegroundCreatures();
    drawForegroundObjects();
    //##MAYBE MOVE##//
    displayAllCrops();
    //##MAYBE MOVE##//
    
    //Draw effects//
    //------------//
    //pass
    
    //Events Occur//
    //------------//
    //** (1)entityNum, (2)spawnNum, (3)spawnTime, (4)pos **//
    spawn_N_every_X(0, 1, 10, new PVector(9*wallWidth, boardHeight/2));  //Orcs
    spawn_N_every_X(1, 1, 25, new PVector(9*wallWidth, boardHeight/2));  //SludgeMonster

    /*
    //(3)To reduce lag, only do it every few seconds
    if ( (( frameCount % ((3)*(60)) ) == 0) && (innStatus == true) )
    {
      println(entityList.get(0).size());  //Number of orcs
      println("Despawn");
      deSpawnOrcs();                    //##NEEDS REWORKING##//
    }
    */
    
    //Draw overlays//
    //-------------//
    //GeneralisedBugFixing();

    nightOverlay();
    playerTorch();
    
    if(structureToggle == true){
      showStructureGhost(findMouseTile(), 9, 8);
    }
    //Background
    calcTileStats(currentStatTile);
    calcInventoryScreen();
    calcInventory();
    keyBindings();
    displayInventory();
    //mapOverlay();
    timeOverlay();
    dayNumberDisplay();
    innStatusSign();
    displayMode();
    modeSpecificOverlays();
    calcDisplayEvents();
    actionOnEvent( eventHovered() );
    calcContainers( containerTile );
    //Mid-Fore ground
    calcPieSelector();
    calcCatalogueSelector();
    calcScannerModule();
    //Foreground
    sleepBar();
    urgencyBar();
    forecastBar();
    factionRelationsBars();
    displayUserMoney();
    FPScounter();
    calcCursorType();
    displayCursor();   

    //Sound effects//
    //-------------//
    calcSteppingSounds();

    //Music//
    //-----//
    //backgroundMusic();
    
    //BugFixing lines//
    //---------------//
    //pass
    
  }
}
