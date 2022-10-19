void initialiseValues(){
  //(1)Initialise fonts
  initialiseFonts();
  //(2)Initialise textures
  loadTextures();
  //(3)Load sound files
  loadSounds();
  //(4)Prepare cropList with indices for each crop to be placed into (for each crop type)
  setupLists();
  //(5)Prepare faction starting values
  setupFactions();
  
  //##SHOULD HAVE OTHER VARIABLES SET TO INITIAL VALUE (WHEREVER SPECIFIED IN 'variables', ADD IN HERE, SO NEW GAMES CAN BE STARTED)##//
}
void setupLists(){
  catalogueNames  .clear();
  catalogueIcons  .clear();
  catalogueObjects.clear();
  //################################################//
  //## NEED TO ACCOUNT FOR WHERE EMPTYs SHOULD BE ##//
  //################################################//
  catalogueNames  .add("Wall");catalogueNames.add("Barrel");catalogueNames.add("Door");catalogueNames.add("Table");catalogueNames.add("Chair");catalogueNames.add("Counter");catalogueNames.add("MiscMachine");catalogueNames.add("Tree");catalogueNames.add("Water");catalogueNames.add("lrgTree");catalogueNames.add("Pump");catalogueNames.add("Vat");catalogueNames.add("Machinery");catalogueNames.add("Field");catalogueNames.add("##Invis##");catalogueNames.add("Contained fire");catalogueNames.add("##Outpost##");catalogueNames.add("##Port##");
  catalogueIcons  .add(magicWallMiddle);catalogueIcons.add(magicBarrel);catalogueIcons.add(magicDoor);catalogueIcons.add(magicTable);catalogueIcons.add(magicStool);catalogueIcons.add(magicCounterMiddle);catalogueIcons.add(test1);catalogueIcons.add(tree);catalogueIcons.add(waterCenter);catalogueIcons.add(lrgTree);catalogueIcons.add(pump);catalogueIcons.add(vat);catalogueIcons.add(machinery);catalogueIcons.add(field);catalogueIcons.add(test2);catalogueIcons.add(fireContained);catalogueIcons.add(tradingOutpost);catalogueIcons.add(port);
  //catalogueObjects.add(Empty);catalogueObjects.add(Wall);catalogueObjects.add(Barrel);catalogueObjects.add(Door);catalogueObjects.add(Table);catalogueObjects.add(Chair);catalogueObjects.add(Counter);catalogueObjects.add(MiscMachine);catalogueObjects.add(Tree);catalogueObjects.add(Water);catalogueObjects.add(LrgTree);catalogueObjects.add(Pump);catalogueObjects.add(Vat);catalogueObjects.add(Machinery);catalogueObjects.add(Field);catalogueObjects.add(InvisFiller);cataloguev.add(Containedfire);catalogueObjects.add(TradingOutpost);catalogueObjects.add(Port);
  //#############################################################################################################//
  //## MAYBE TRY CREATING 1 OF EACH ITEM FIRST, THEN RECORD ITS VARIABLE TYPE USING .getClass(), THEN CLEARING ##//
  //#############################################################################################################//


  cropList.clear();
  for(int i=0; i<2; i++)  //**INCREASE IF MORE CROPS ARE ADDED**//
  {
    cropList.add(new ArrayList<Crop>());
  }

  entityList.clear();
  for(int i=0; i<2; i++)  //**INCREASE IF MORE CROPS ARE ADDED**//
  {
    entityList.add(new ArrayList<entity>());
  }

  containerList.clear();
  for(int i=0; i<2; i++)  //**INCREASE IF MORE CONTAINERS ARE ADDED**//
  {
    containerList.add(new ArrayList<Container>());
  }
}

void setupFactions(){
  factionIcon.clear();
  factionIcon.add( factionIcon1 ); //1st faction
  factionIcon.add( factionIcon2 ); //2nd faction
  factionIcon.add( factionIcon3 ); //3rd faction
  factionIcon.add( factionIcon4 ); //4th faction

  //##HAVE BE RANDOM FLOATS BETWEEN 0 AND 1##//
  factionInterest.clear();
  factionInterest.add( 0.10 ); //1st faction
  factionInterest.add( 0.40 ); //2nd faction
  factionInterest.add( 0.25 ); //3rd faction
  factionInterest.add( 1.00 ); //4th faction
}

void initialiseFonts(){

  //Initialise fonts
  //DefaultHLI = createFont("DefaultHLI.ttf", 32);
  a_DefaultHLI = loadImage("a_DefaultHLI.png");
  A_DefaultHLI = loadImage("Au_DefaultHLI.png");
  b_DefaultHLI = loadImage("b_DefaultHLI.png");
  B_DefaultHLI = loadImage("Bu_DefaultHLI.png");
  c_DefaultHLI = loadImage("c_DefaultHLI.png");
  C_DefaultHLI = loadImage("Cu_DefaultHLI.png");
  d_DefaultHLI = loadImage("d_DefaultHLI.png");
  D_DefaultHLI = loadImage("Du_DefaultHLI.png");
  e_DefaultHLI = loadImage("e_DefaultHLI.png");
  E_DefaultHLI = loadImage("Eu_DefaultHLI.png");
  f_DefaultHLI = loadImage("f_DefaultHLI.png");
  F_DefaultHLI = loadImage("Fu_DefaultHLI.png");
  g_DefaultHLI = loadImage("g_DefaultHLI.png");
  G_DefaultHLI = loadImage("Gu_DefaultHLI.png");;
  h_DefaultHLI = loadImage("h_DefaultHLI.png");
  H_DefaultHLI = loadImage("Hu_DefaultHLI.png");
  i_DefaultHLI = loadImage("i_DefaultHLI.png");
  I_DefaultHLI = loadImage("Iu_DefaultHLI.png");
  j_DefaultHLI = loadImage("j_DefaultHLI.png");
  J_DefaultHLI = loadImage("Ju_DefaultHLI.png");
  k_DefaultHLI = loadImage("k_DefaultHLI.png");
  K_DefaultHLI = loadImage("Ku_DefaultHLI.png");
  l_DefaultHLI = loadImage("l_DefaultHLI.png");
  L_DefaultHLI = loadImage("Lu_DefaultHLI.png");
  m_DefaultHLI = loadImage("m_DefaultHLI.png");
  M_DefaultHLI = loadImage("Mu_DefaultHLI.png");
  n_DefaultHLI = loadImage("n_DefaultHLI.png");
  N_DefaultHLI = loadImage("Nu_DefaultHLI.png");
  o_DefaultHLI = loadImage("o_DefaultHLI.png");
  O_DefaultHLI = loadImage("Ou_DefaultHLI.png");
  p_DefaultHLI = loadImage("p_DefaultHLI.png");
  P_DefaultHLI = loadImage("Pu_DefaultHLI.png");
  q_DefaultHLI = loadImage("q_DefaultHLI.png");
  Q_DefaultHLI = loadImage("Qu_DefaultHLI.png");
  r_DefaultHLI = loadImage("r_DefaultHLI.png");
  R_DefaultHLI = loadImage("Ru_DefaultHLI.png");
  s_DefaultHLI = loadImage("s_DefaultHLI.png");
  S_DefaultHLI = loadImage("Su_DefaultHLI.png");
  t_DefaultHLI = loadImage("t_DefaultHLI.png");
  T_DefaultHLI = loadImage("Tu_DefaultHLI.png");
  u_DefaultHLI = loadImage("u_DefaultHLI.png");
  U_DefaultHLI = loadImage("Uu_DefaultHLI.png");
  v_DefaultHLI = loadImage("v_DefaultHLI.png");
  V_DefaultHLI = loadImage("Vu_DefaultHLI.png");
  w_DefaultHLI = loadImage("w_DefaultHLI.png");
  W_DefaultHLI = loadImage("Wu_DefaultHLI.png");
  x_DefaultHLI = loadImage("x_DefaultHLI.png");
  X_DefaultHLI = loadImage("Xu_DefaultHLI.png");
  y_DefaultHLI = loadImage("y_DefaultHLI.png");
  Y_DefaultHLI = loadImage("Yu_DefaultHLI.png");
  z_DefaultHLI = loadImage("z_DefaultHLI.png");
  Z_DefaultHLI = loadImage("Zu_DefaultHLI.png");

}
void loadTextures(){
  
  //Load in assets
  //##PNG ALWAYS ALPHA##//

  //Beers
  beerMugBack1 = loadImage("beerMugBack1.png");
  beerLiquid1  = loadImage("beerLiquid1.png");
  beerMug1     = loadImage("beerMug1.png");

  //Entity chatter
  orcChatter1 = loadImage("orcChatter1.png");
  orcChatter2 = loadImage("orcChatter2.png");
  orcChatter3 = loadImage("orcChatter3.png");

  //Entity (beer) request
  requestBeer1 = loadImage("requestBeer1.png");

  //Icon
  coinIcon               = loadImage("coinIcon.png");
  removeIcon             = loadImage("removeIcon.png");

  //Entities
  sludgeMonsterFrontStat = loadImage("sludgeMonster_Front_Stationary.png");
  sludgeMonsterBackStat  = loadImage("sludgeMonster_Back_Stationary.png");
  sludgeMonsterLeftStat  = loadImage("sludgeMonster_Left_Stationary.png");
  sludgeMonsterRightStat = loadImage("sludgeMonster_Right_Stationary.png");
  orcFrontStat           = loadImage("orc_front_stationary.png");

  //Followers
  userFollower1Left  = loadImage("userFollower_left_stationary.png");
  userFollower1Right = loadImage("userFollower_right_stationary.png");

  //Inventory assets
  characterOverlay = loadImage("characterOverlay.png");

  //Cursor types
  explorationCursor = loadImage("explorationCursor.png");
  buildingCursor    = loadImage("buildingCursor.png");
  pipingCursor      = loadImage("pipingCursor.png");
  cropCursor        = loadImage("cropCursor.png");

  //Daylight filters
  nightFilter = loadImage("nightFilter.png");

  //Inn sign
  innStatusOpen   = loadImage("innStatusOpen.png");
  innStatusClosed = loadImage("innStatusClosed.png");

  //Faction icons
  factionIcon1  = loadImage("factionIcon1.png");
  factionIcon2  = loadImage("factionIcon2.png");
  factionIcon3  = loadImage("factionIcon3.png");
  factionIcon4  = loadImage("factionIcon4.png");

  //3 lower attributes
  sunOuterTimeDisplay = loadImage("sunOuterTimeDisplay.png");
  moonFullTimeDisplay = loadImage("moonFullTimeDisplay.png");
  sunTimeDisplay  = loadImage("sunTimeDisplay.png");
  moonTimeDisplay = loadImage("moonTimeDisplay.png");
  sleepBar        = loadImage("sleepBar.png");
  urgencyBar      = loadImage("urgencyBar.png");
  forecastBarRain = loadImage("forecastBarRain.png");

  //Building ghosts
  greenBuildingGhost = loadImage("greenBuildingGhost.png");
  redBuildingGhost   = loadImage("redBuildingGhost.png");
  
  //Other
  pump      = loadImage("pump.png");
  vat       = loadImage("vat.png");
  machinery = loadImage("machinery.png");
  
  //Mode effects
  buildingModeEdgeEffect = loadImage("buildingModeEdgeEffect.png");
  pipingModeEdgeEffect   = loadImage("pipingModeEdgeEffect.png");
  cropModeEdgeEffect     = loadImage("cropModeEdgeEffect.png");
  
  //Menus
  menu1           = loadImage("menu1.png");
  
  //Event Box
  eventBoxTop     = loadImage("eventBoxTop.png");
  eventBoxMiddle  = loadImage("eventBoxMiddle.png");
  eventBoxTextBox = loadImage("eventBoxTextBox.png");
  
  //Crops
  field          = loadImage("field.png");
  barleyStg1     = loadImage("barleyStg1.png");
  barleyStg2     = loadImage("barleyStg2.png");
  barleyStg3     = loadImage("barleyStg3.png");
  barleyStg4     = loadImage("barleyStg4.png");
  
  //Some natural tiles
  lrgTree        = loadImage("lrgTree.png");
  tree           = loadImage("tree.png");
  waterCenter    = loadImage("water_center.png");
  waterFront     = loadImage("water_front.png");
  
  //User states
  userFront      = loadImage("lowRes_userFront_stationary.png");
  userBack       = loadImage("lowRes_userBack_stationary.png" );
  userLeft       = loadImage("lowRes_userLeft_stationary.png" );
  userRight      = loadImage("lowRes_userRight_stationary.png");
  
  //Magic building components
  magicWallMiddle          = loadImage("wallMagic_Middle.png"          );
  magicWallHidden          = loadImage("wallMagic_vertical_hidden.png" );
  magicBarrel              = loadImage("barrelMagic_plain.png"         );
  magicCounterMiddle       = loadImage("counterMagic_Middle.png"    );
  magicCounterHidden       = loadImage("counterMagic_vertical_hidden.png" );
  magicCounterUpper        = loadImage("counterMagic_vertical_endUpper.png" );
  magicCounterLower        = loadImage("counterMagic_vertical_endLower.png" );
  magicCounterCornerLeft   = loadImage("counterMagic_cornerLeft.png" );
  magicCounterCornerRight  = loadImage("counterMagic_cornerRight.png" );
  magicCounterCornerLeftDown     = loadImage("counterMagic_cornerLeft_down.png" );
  magicCounterCornerRightDown    = loadImage("counterMagic_cornerRight_down.png" );
  magicCounterCornerLeftUpDown   = loadImage("counterMagic_cornerLeft_upDown.png" );
  magicCounterCornerRightUpDown  = loadImage("counterMagic_cornerRight_upDown.png" );
  magicTable                     = loadImage("tableMagic_plain.png"        );
  fireContained                  = loadImage("fireContained.png");
  tradingOutpost                 = loadImage("tradingOutpost.png");
  port                           = loadImage("port.png");
  magicTableRoundCentre      = loadImage("tableMagic_plain_centre.png"         ); //##CHANGE FROM PLAIN TO ROUND##//
  magicTableRoundLeftMiddle  = loadImage("tableMagic_round_middleLeft.png"     );
  magicTableRoundRightMiddle = loadImage("tableMagic_round_middleRight.png"    );
  magicTableRoundLeftMiddle  = loadImage("tableMagic_round_middleLeft.png"     );
  magicTableRoundBottomMiddle= loadImage("tableMagic_round_middleBottom.png"   );
  magicTableRoundTopMiddle   = loadImage("tableMagic_round_middleTop.png"      );//##CHANGE UPPER OUT OF CAPS
  magicTableRoundLeftUpper   = loadImage("tableMagic_round_UpperLeft.png"      );//##
  magicTableRoundRightUpper  = loadImage("tableMagic_round_UpperRight.png"     );//##
  magicTableRoundLeftLower   = loadImage("tableMagic_round_lowerLeft.png"      );
  magicTableRoundRightLower  = loadImage("tableMagic_round_lowerRight.png"     );
  magicStool        = loadImage("stoolMagic_plain.png"        );
  magicDoor         = loadImage("doorMagic_plain.png"         );
  magicDoorSideway  = loadImage("doorMagic_plain_sideway.png" );
  magicFloorPlain   = loadImage("floorMagic_plain.png"        ); 
  magicFloorBricked = loadImage("floorMagic_bricked.png"      ); 
  magicFloorFancy   = loadImage("floorMagic_fancy.png"        );
  
  //Natural
  naturalFloorPlain    = loadImage("floorNatural_plain.png"   );
  naturalFloorFlowered = loadImage("floorNatural_flowered.png");
  naturalFloorStone    = loadImage("floorNatural_stone.png"   );
  
  //User run animation
  userRightRun1  = loadImage("lowRes_userRight_runAnim1.png" );
  userRightRun2  = loadImage("lowRes_userRight_runAnim2.png" );
  userRightRun3  = loadImage("lowRes_userRight_runAnim3.png" );
  userRightRun4  = loadImage("lowRes_userRight_runAnim4.png" );
  userRightRun5  = loadImage("lowRes_userRight_runAnim5.png" );
  userRightRun6  = loadImage("lowRes_userRight_runAnim6.png" );
  userRightRun7  = loadImage("lowRes_userRight_runAnim7.png" );
  userRightRun8  = loadImage("lowRes_userRight_runAnim8.png" );
  userRightRun9  = loadImage("lowRes_userRight_runAnim9.png" );
  userRightRun10 = loadImage("lowRes_userRight_runAnim10.png");
  userRightRun11 = loadImage("lowRes_userRight_runAnim11.png");
  userRightRun12 = loadImage("lowRes_userRight_runAnim12.png");
  
  userFrontRun1 = loadImage("lowRes_userFront_runAnim_1.png" );
  userFrontRun2 = loadImage("lowRes_userFront_runAnim_2.png" );
  userFrontRun3 = loadImage("lowRes_userFront_runAnim_3.png" );
  userFrontRun4 = loadImage("lowRes_userFront_runAnim_4.png" );
  userFrontRun5 = loadImage("lowRes_userFront_runAnim_5.png" );
  userFrontRun6 = loadImage("lowRes_userFront_runAnim_6.png" );
  userFrontRun7 = loadImage("lowRes_userFront_runAnim_7.png" );
  
  //User stationary front set 1
  userFrontStat1Set1  = loadImage("lowRes_userFront_stationaryAnim_set1_1.png"  );
  userFrontStat1Set5  = loadImage("lowRes_userFront_stationaryAnim_set1_5.png"  );
  userFrontStat1Set9  = loadImage("lowRes_userFront_stationaryAnim_set1_9.png"  );
  userFrontStat1Set13 = loadImage("lowRes_userFront_stationaryAnim_set1_13.png" );
  userFrontStat1Set17 = loadImage("lowRes_userFront_stationaryAnim_set1_17.png" );
  userFrontStat1Set18 = loadImage("lowRes_userFront_stationaryAnim_set1_18.png" );
  userFrontStat1Set19 = loadImage("lowRes_userFront_stationaryAnim_set1_19.png" );
  userFrontStat1Set20 = loadImage("lowRes_userFront_stationaryAnim_set1_20.png" );
  userFrontStat1Set21 = loadImage("lowRes_userFront_stationaryAnim_set1_21.png" );
  userFrontStat1Set22 = loadImage("lowRes_userFront_stationaryAnim_set1_22.png" );
  userFrontStat1Set23 = loadImage("lowRes_userFront_stationaryAnim_set1_23.png" );
  userFrontStat1Set24 = loadImage("lowRes_userFront_stationaryAnim_set1_24.png" );
  
  //Pipes
  pipeAlone         = loadImage("pipeAlone.png");
  pipeOpenClosed    = loadImage("pipeOpenClosed.png");
  pipeCorner        = loadImage("pipeCorner.png");
  pipeOpenOpen      = loadImage("pipeOpenOpen.png");
  pipeThreeJunction = loadImage("pipeThreeJunction.png");
  pipeFourJunction  = loadImage("pipeFourJunction.png");
  
  //test
  test1    = loadImage("test1.png" );
  test2    = loadImage("test2.png" );
  test3    = loadImage("test3.png" );
  test4    = loadImage("test4.png" );
  test5    = loadImage("test5.png" );
  test6    = loadImage("test6.png" );
  test7    = loadImage("test7.png" );
  test8    = loadImage("test8.png" );
  test9    = loadImage("test9.png" );
  test10   = loadImage("test10.png");
  
}

void loadSounds(){
  backgroundMusic1     = new SoundFile(this, "backgroundMusic1.wav");
  traditionalSong1     = new SoundFile(this, "traditionalSong1.wav");
  footstepsGrass       = new SoundFile(this, "footstepsGrass.wav");
  buttonSelectionSound = new SoundFile(this, "buttonSelectionSound.wav");
  generalClickSound    = new SoundFile(this, "generalClickSound.wav");
  largeEventSound      = new SoundFile(this, "largeEventSound.wav");
  smallEventSound      = new SoundFile(this, "smallEventSound.wav");
  openInventorySound   = new SoundFile(this, "openInventorySound.wav");
  placeTileSound       = new SoundFile(this, "placeTileSound.wav");
}
