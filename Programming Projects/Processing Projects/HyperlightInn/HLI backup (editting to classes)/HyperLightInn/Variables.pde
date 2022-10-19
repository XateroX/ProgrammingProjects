User user = new User( 30, new PVector(400,400), new PVector(199,10,250) ); //Describes the user
UserFollower followerU = new UserFollower( new PVector(user.pos.x+40/2, user.pos.y+40/2) );   //##40 FOR WALL HEIGHT/WIDTH##//

float dist;

boolean placeBool = false;
boolean DespawnCond1;        //Determines if an entity off screen, and so despawn --> ##WILL NEED TO BE CHANGED IN FUTURE SO ORCS CAN EXIST OUTSIDE OF VISION##
boolean DespawnCond2;
boolean collision;
boolean foundBorder;
boolean rectCollisionCond1;  //Determines rectangle based collision zone
boolean rectCollisionCond2;
boolean onScreenCond1;       //Is entity on the board, if not do not calc collisions, to avoid 'out of index' (for Tiles Arraylist) error
boolean onScreenCond2;
boolean boardEdgeCond1;      //User too close to edge of board, stop centering
boolean boardEdgeCond2;
boolean screenEdgeCond1;     //User is close enough to edge of screen for position to scroll across board
boolean screenEdgeCond2;
boolean IsUser;
boolean userMoving;
boolean counterJoined;
boolean doorJoined;
boolean homeScreen         = true ;  //To determine whether or not the home screen should be shown
boolean optionsScreen      = false;  //To determine whether or not the options menu should be shown
boolean tileStatScreen     = false;  //To determine whether or not to show the stats panel for tiles
boolean inventoryScreen    = false;  //To determine whether or not to show the full inventory
boolean itemInInventory;             //Whether an item is in the user's inventory, and if so increase the quantity of that item
boolean followerUstatTravel= false;  //Whether the user's follower should stay a stat panel or go back to user
boolean startPipeFound;              //For determining pipe fluid flow, used to determine whether an output pipe is present in a network
boolean allPipesProcessed;           //Determining when to stop the loop to keep transfering fluid to pipes processed yet
boolean showPipeFluidFlow  = true;   //Whether to show the water moving within the pipes
boolean hotkeyMenuScreen   = false;  //Whether to show hotkeys for current mode
boolean indexMenu          = false;  //Whether to show a list of which index is which object
boolean pumpExistsHere;
boolean vatExistsHere;
boolean machineryExistsHere;
boolean nearFluidSource;
boolean eventCurrentlyHovered;
boolean structurePlaceable;          //Whether a ghost structure can be placed
boolean alreadyDrawn;
boolean barrelExistsHere;
boolean tradingOutpostExistsHere;
boolean showContainer      = false;       //Whether or not the container hovered should show its contents
boolean innStatus          = false;       //Whether or not the inn is open to recieve customers, (starts NOT open)
boolean playerTorchActive  = false;
boolean itemInContainer;
boolean allItemsDisplayed;                //Used to determine whether more container contents should be shown (e.g if at end of item list it holds)
boolean pathTilePlaced;                   //Whether or not the path tile in question has been added yet, to break out of its for loop
boolean followerPathFollow = false;
boolean translateCustomText;              //Whether or not to keep as processing font or use custom font (declared in the function)
boolean pathBlocked;                      //Determines whether larger entities can fit into areas during pathing
boolean routeFound;                       //To cancel out of final step of adding to pathFinal
boolean structureBlocked = true;          //Temp placeable structure value
boolean structureToggle  = false;
boolean pieToggle        = false;         //Whether or not to display the pie selector wheel
boolean catalogueToggle  = false;         //Whether or not to display the catalogue
boolean scannerToggle    = false;         //Whether or not to display the scanner
boolean catalogueCheck;                   //Whether the searched list has a type that matches the requested type

Object objType;

String itemExchangeName;   //Name of item being exchanged
String textWord;           //The current word from the text being formatted
String textLine;           //The current line of text being formatted
String textCharacter;      //## CAN CHANGE TO CHARACTER TYPE, BUT CAUSES STRING TO CHARACTER ERRORS WHEN FINDING SUBSTRING ##//

/*
catalogueItemIndices = {"Wall"            : 1,
                        "Barrel"          : 2,
                        "Door"            : 3,
                        "Table"           : 4,
                        "Chair"           : 5,
                        "Counter"         : 6,
                        "MiscMachine"     : 7,
                        "Tree"            : 8,
                        "Water"           : 9,
                        "lrgTree"         :10,
                        "Pump"            :11,
                        "Vat"             :12,
                        "Machinery"       :13,
                        "Field"           :14,
                        "invisBlock"      :15,
                        "Fire opened"     :16,
                        "Trading Outpost" :17,
                        "Port"            :18}
*/

int tileset;
int boardWidth   = 2400;   //Size of entire board (whole map)
int boardHeight  = 2400;   //
int screenWidth  = 800 ;  //Size of visible screen (window size)
int screenHeight = 800 ;  //
int colNum       = 60  ;  //Number of columns across the enitre board (##best to keep as a square##)
int rowNum       = 60  ;  //
int borderTile;
int closestTile;
int currentTile;
int indCounter;
int colEncounterLower;    //For calculating where the screen should be placed, and the relative coordinates of everything 
int colEncounterUpper;    //
int rowEncounterLower;    //
int rowEncounterUpper;    //
int tileToDraw;
int userTile;            //When loading board, finds tile of user
int startTile;           //Top-left most tile in which to load the board
int mouseTile;           //Tile mouse is hovering over
int frameTimerX;
int frameTimerY;
int frameTotal;
int perFrame;
int tileTypeSel  = 0;           //The index the main tile will be changed to when given key pressed
int floorTypeSel = 0;           //The index the floor tile will be changed to when given key pressed
int squarePos;
int bubbleDispFloat = 30;      //Space between each bubble (when maxed out)
int currentStatTile;
int inventoryCols = 5;
int inventoryRows = 15;
int inventoryRowsSpare = 2;    //Rows left spare in inventory so description can be written there
int waterNearby;               //For map generation (tiles of water present determine likelyhood of new water spawning)
int itemInInventoryInd;        //For adding items to inventory
int itemInInventoryVal;        //
int followerSpeed = 4;         //Speed of all followers
int followerRestTolerance= 50; //The radius^2 at which the follower will come to rest (around its waypoint) ; ~25-100 is good
int prob;                      //Probability temporary value
int invCursorInd;              //Index of item being hovered by cursor in inventory
int invDisplayNum;             //Number of items dusplayed in bubbles (first X)
int invDisplayMax = 9;        //Max number of items that can be displayed as bubbles
int modeSelector  = 0;         //Determines mode which you are in, determining actions that can be performed
int adjacentPipe;              //Used when calculating whether to add a pipe to a network or form a new network
int adjacentPipeChanges;       //
int pipeNetworkSize;           //Stores the size of a network temporarily (when moving its pipes over to another network)
int tileNumTemp;               //The temporary value of the tileNum for the next pipe, when filling new pipes
int networkNum;                //The network of the tile being hovered by the mouse
int hotkeySize = 14;           //Size of hotkey text in hotkey menu
int hotkeyIncr = 2*hotkeySize; //The increments in the y-axis for each item in the hotkey
int fluidTypeNum;
int cropSelector = 0;          //Determines which crop will be placed
int cropType;
int maxEventSize = 15;         //Max number of events that can show up in the notification box
int eventInd;                  //Index of event in eventsShort/Description being hovered
int rightTemp;                 //Temporarily holds the number of tiles to the right from the given the current tile being looked at is (used to interpet findTileBorderIndices)
int downTemp;                  //
int multiTwidth;               //Dimensions of the multi-tile being drawn, used in "key-bindings" when placing invisible and real tiles
int multiTheight;              //
int tWidthTemp;
int tHeightTemp;
int dayLength = 20;   //In seconds, time one day cycle will last
int dayNumber = 0;
int containerTile;
int hoveredInd;
int backgroundMusicStart = -99999;    //Starting frame of background music, starts at beginning of game (hence the -ve a large number)
int footstepStart        = 0;       //Starting frame of stepping soundwidth
int itemInContainerInd;             //For adding items to containers, position of item in container and number of item in that container (on that inv space)
int itemInContainerVal;             //
int containerCursorInd;
int pathEnd;                        //The final tile / destination of a path
int pathTile;                       //The tile currently being looked at when calculating the path for an entity
int pathStart;                      //The starting tile for an entity travelling to another tile
int pathCheckTile;                  //A temporary value for the tileNum being checked in an N x N area when calculating pathing
int pathCheckTileTemp;
int pathRoute;                      //A temporary value for the tileNum used to complete the final route, working backwards using this variable
int routeTravelNum;
int tileTemp;                       //Generic temporary tile number
int closestOfIndex;                 //Used in path finding, storing the tileNumber of the closest tile containing that index ##NEED TO MODIFY, CHECK ORC FUNCTIONS##
int sentenceLength;                 //Length of the current sentence being formed, used to see if the sentence will fir in the text box (in the text formatter)
int pathLwrBnd;                     //The lower and upper bound of where to check around an entity during path calculation so it can fir its nXn size
int pathUprBnd;                     //
int drinkPossibility;               //Used to give probability for different events after drinking a beer
int duringDrinkOutcome;             //Used to decide which action will be taken while drinking the beer
int drinkingRate = 10;              //Number of frames between taking another swig of entity's drink
int talkingRate  = 6*drinkingRate;  //Rate at which entities will talk while drinking ## MAY NEED TO BE EXTENDED TO OTHER OPTIONS AS WELL ##
int hoveredIndCata;                 //Which index in the catalogue is being hovered over
int hoveredIndPie;                  //Which index in the pie selector is being hovered over
int scannerQuantityTemp;            //Temporarily holds the value of the number of items the scanner current has
int scannerMode = 0;                //Which scan type the scanner will perform (when in scanner mode)
int maxScannerMode = 1;     //** Need to change to be whatever the MAX scanner mode value is **//
int scannerTileTotal;               //Total number of tiles of selected types (that have been scanned)
int majorStructureTile;             //Tile where the placed major structure will be located around

PVector centerXY           = new PVector(0,0);
PVector unitVec            = new PVector();
PVector resultVec          = new PVector();
PVector initialVel         = new PVector();
PVector initialDist        = new PVector();
PVector objPosTemp         = new PVector();
PVector relativePos        = new PVector(boardWidth/2, boardHeight/2); //Start in centre of whole board, is used as though in centre of screen
PVector relativeDifference = new PVector();
PVector relativeCoords     = new PVector();
PVector relativeObjPos     = new PVector();
PVector relativeObjPosTemp = new PVector();
PVector relativePosEntity  = new PVector();
PVector relativeUserPos    = new PVector();
PVector bubbleLen          = new PVector((screenWidth - 10*bubbleDispFloat) / (invDisplayMax), (screenWidth - 10*bubbleDispFloat) / (invDisplayMax));//Spacing of bubbles for inventory display at top of screen
PVector followerWaypointU  = new PVector(); //Position USER'S follower needs to travel to
PVector moveWaypointTemp   = new PVector();
PVector relativePoint      = new PVector(0,0);

float wallWidth  = boardWidth /colNum;
float wallHeight = boardHeight/rowNum;
float centerX;         //Cursor (centralised with each tile) position
float centerY;         //
float vecDist;         //For VecDist function
float vecMag ;         //For VecMag function
float initialDistMag;
float edgeTolerance = 250;     //How close to the edge of the screen you need to be before it starts to scroll
float tileCursorTolerance = 15;//How many pixels of space is left in middle of tile cursor (repeated for both sides)
float homeButtonWidth   = screenWidth/6;    //**Used for all menu buttons**
float homeButtonHeight  = screenHeight/16;  //
float homeButtonSpacing = 60;               //
float inventoryX = 2*screenWidth /3;       //Coordinates of center of inventory (items section, not the player character overlay)
float inventoryY =   screenHeight/2;       //
float inventoryWidth  = (3*screenWidth)/10;
float inventoryHeight = (8*screenHeight)/10;
float inventoryXspace;  //Width of boxes in inventory
float inventoryYspace;  //Height ...
float InvXcoord;        //Temp values for position of icon in inventory, similar calculation to finding tile position in grid
float InvYcoord;        //
float hotkeyCenterX     = screenWidth /2;       //Center X point of hotkey menu box
float hotkeyCenterY     = screenHeight/2;       //
float hotkeyBoxWidth    =  (1*screenWidth )/2;  //Width of hotkey menu box
float hotkeyBoxHeight   = (4*screenHeight)/5;   //
float hotkeyOffsetMulti = (4*20)/hotkeySize;    //Determines the offset of the 1st and 2nd half of hotkey text from menu's centre line
float eventBoxX         = screenWidth-130;      //Coordinates of top-left corner of event notification box
float eventBoxY         = 120;                   //
float eventBoxWidth     = 120;                  //Dimensions of event notification box
float eventBoxHeight;                           //
float eventBoxSpacing   = 30;                   //Spacing in Y-axis of event notification box
float eventDescX        = screenWidth/4;        //Description event box coordinates of top-left corner
float eventDescY        = screenHeight/16;      //
float eventDescWidth    = screenWidth/2;        //Description event box dimensions
float eventDescHeight   = screenHeight/8;       //
float containerBoxX;                    //Position of container inventory screen top-left corner
float containerBoxY;                    //
float widthTemp;
float heightTemp;
float timeDisplayX          = screenWidth /10;                  //Position of center of time display
float timeDisplayY          = screenHeight/10;                  //
float timeDisplaySunRadi    = 80;     //##REPLACED WHEN TEXTURE COMES##//
float timeDisplayMoonRadi   = 70;     //##REPLACED WHEN TEXTURE COMES##//
float innStatusSignX        = screenWidth - (screenWidth /10);  //Position of center of inn sign display
float innStatusSignY        = screenHeight/10;                  //
float innStatusSignWidth    = 100;     //##REPLACED WHEN TEXTURE COMES##//
float innStatusSignHeight   = 50;      //##REPLACED WHEN TEXTURE COMES##//
float sleepBarX             = screenWidth/2;
float sleepBarY             = screenHeight - (screenHeight/12);
float sleepBarRadi          = 60; //##REPLACED WHEN TEXTURE COMES##//        //NOT ACTUALLY RADI, IS DIAMETER, MISNAMED #######
float urgencyBarX           = screenWidth/2 - sleepBarRadi;
float urgencyBarY           = screenHeight - (screenHeight/14);
float urgencyBarRadi        = 50; //##REPLACED WHEN TEXTURE COMES##//
float forecastBarX          = screenWidth/2 + sleepBarRadi;
float forecastBarY          = screenHeight - (screenHeight/14);
float forecastBarRadi       = 50; //##REPLACED WHEN TEXTURE COMES##//
float factionBarX           = 20;
float factionBarY           = screenHeight/4;
float factionBarHeight      = 10;
float factionBarSpacing     = 40;
float factionBarMax         = 80;   //Max length of faction bar
float factionBarIconSpacing = 20;   //
float bubbleBorder          = 110;  //The border from each side that the inventory bubbles will be between
float factionInterestTemp;
float daylightMultiplier;
float darknessMaxMultiplier = 0.85;
float dayStart = 0;
float dayEnd   = dayLength*60;
float invToContainerOffset = 20;
float invCharacterOverlayWidth  = 200;      //Dimensions of charcter overlay panel in inventory (on left)
float invCharacterOverlayHeight = 400;      //
float morningProportion = 0.1;             //Proportion of the full day which will be a transition into day, and a transition into night (the left over proportion will be bright daylight)
float eveningProportion = 0.1;             //
float pathCheckTotalWeight;                //The running + dist weight of a path (the main measure used to order tiles into priority order)
float pathCycleTotalWeight;                //
float pathCheckDist;                       //The distance from the tile in question to the destination, used for A* algorithm
float pathCycleDist;                       //
float pathTileDiffX;
float pathTileDiffY;
float workingDist;                         //The distances used to calculate which tile of a given index is closer when finding end destination for entities looking for given index
float leadingDist;                         //
float waypointTolerance = wallWidth/2;     //Tolerance for entities to follow their waypoints when moving
float drinkSpeedMultipler = 2.0;           //Adjust, globally, how fast entities drink beer
float tempDrinkVolume;
float segAngle;                            //Angle between each segment in the pie selector
float mouseAng;                            //Angle between the mouse and centre of the circle, adjusted when in different CAST directions
float pieIconDist = 0.65;                  //How far into the pie selector the icon are displayed
float removalRadius;                       //Radius of the removal circle in the pie selector
float scannerRunningAng;                   //The running total of angle found so far when calculating scanner pie chart

int screenCols = ceil(screenWidth /wallWidth ) +1;//##POSSIBLY ERRORS, MAY HAVE BEEN FIXED##//
int screenRows = ceil(screenHeight/wallHeight) +1;

ArrayList<Tile> Tiles  = new ArrayList<Tile>();
ArrayList<Integer> borderIndices       = new ArrayList<Integer>();    //Temp store for borderIndicesFinal
ArrayList<Integer> borderIndicesFinal  = new ArrayList<Integer>();    //Stores position of specified tile in 3x3 surrounding it
ArrayList<Integer> borderIndFinalTemp  = new ArrayList<Integer>();    //Stores position of specified tile in 3x3 surrounding it (2nd available one to use)
ArrayList<Integer> indList             = new ArrayList<Integer>();
ArrayList<Pipe> pipePathTemp           = new ArrayList<Pipe>();       //Temporarily holds the next pipes that need to be filled by fluid
ArrayList<Integer> connectionsTemp     = new ArrayList<Integer>();    //Temporarily holds the connections that are valid
ArrayList<Pipe> outputPipesTemp        = new ArrayList<Pipe>();       //Holds all of the output pipes in all networks
ArrayList<Pump> pumpList               = new ArrayList<Pump>();       //Holds information about pumps present
ArrayList<Vat> vatList                 = new ArrayList<Vat>();        //Holds information about vats present
ArrayList<Machinery> machineryList     = new ArrayList<Machinery>();  //Holds information about machinery present
ArrayList<String> eventsShort          = new ArrayList<String>();     //The pop-up name in events short hand
ArrayList<String> eventsDescription    = new ArrayList<String>();     //The full description when hovered over
ArrayList<String> floorItemNames       = new ArrayList<String>();
ArrayList<PVector> floorItemPos        = new ArrayList<PVector>();
ArrayList<Integer> floorItemQuantity   = new ArrayList<Integer>();
ArrayList<PImage> factionIcon          = new ArrayList<PImage>();   //Stores icon for each faction
ArrayList<Float> factionInterest       = new ArrayList<Float>();    //Stores how much each faction likes the inn (as a multiplier)
ArrayList<Integer> pathUnchecked       = new ArrayList<Integer>();  //Stores the tiles that have yet to be checked around, when calculating the path an entity will travel
ArrayList<Integer> pathFinal           = new ArrayList<Integer>();  //Stores the final, completed route an entity will travel to get to a destination -> should be copied over to its personal memory so this variable can be reuded indefinately
ArrayList<Integer> pathResult          = new ArrayList<Integer>();
ArrayList<String> textSeparated        = new ArrayList<String>();   //List containing a formatted text, split into lines (indicated by each index in the list)
ArrayList<Integer> scannerTile         = new ArrayList<Integer>();  //List containing the type of tile and how many of it have been encountered
ArrayList<Integer> scannerTileQuantity = new ArrayList<Integer>();  //

/*
ArrayList<Empty> Tiles0           = new ArrayList<Empty>();
ArrayList<Wall> Tiles1            = new ArrayList<Wall>();
ArrayList<Barrel> Tiles2          = new ArrayList<Barrel>();
ArrayList<Door> Tiles3            = new ArrayList<Door>();
ArrayList<Table> Tiles4           = new ArrayList<Table>();
ArrayList<Stool> Tiles5           = new ArrayList<Stool>();
ArrayList<Counter> Tiles6         = new ArrayList<Counter>();
ArrayList<MiscMachine> Tiles7     = new ArrayList<MiscMachine>();
ArrayList<Tree> Tiles8            = new ArrayList<Tree>();
ArrayList<Water> Tiles9           = new ArrayList<Water>();
ArrayList<LrgTree> Tiles10        = new ArrayList<LrgTree>();
ArrayList<Pump> Tiles11           = new ArrayList<Pump>();
ArrayList<Vat> Tiles12            = new ArrayList<Vat>();
ArrayList<Machinery> Tiles13      = new ArrayList<Machinery>();
ArrayList<Field> Tiles14          = new ArrayList<Field>();
ArrayList<InvisFiller> Tiles15    = new ArrayList<InvisFiller>();
ArrayList<ContainedFire> Tiles16  = new ArrayList<ContainedFire>();
ArrayList<TradingOutpost> Tiles17 = new ArrayList<TradingOutpost>();
ArrayList<Port> Tiles18           = new ArrayList<Port>();
*/

ArrayList<ArrayList<Container>> containerList = new ArrayList<ArrayList<Container>>();  //Holds information about items stored in barrel
ArrayList<ArrayList<Crop>> cropList           = new ArrayList<ArrayList<Crop>>();       //Holds information about crop present
ArrayList<ArrayList<entity>> entityList       = new ArrayList<ArrayList<entity>>();     //Holds every entity, in an index specific to the type of entity it is
ArrayList<ArrayList<Pipe>> pipeNetwork        = new ArrayList<ArrayList<Pipe>>();       //Holds all pipe networks

ArrayList<Integer> pieSelected         = new ArrayList<Integer>();  //List of the categories on the pie wheel   ## MAY NEED TO EXPAND, FOR MULTIPLE WHEELS / WHEELS INTO WHEELS ##
ArrayList<String> catalogueNames       = new ArrayList<String>();   //List of all items available to be selected in the large list; Their names at given index
ArrayList<PImage> catalogueIcons       = new ArrayList<PImage>();   //List of all items available to be selected in the large list; Their icons at given index
ArrayList<Object> catalogueObjects     = new ArrayList<Object>();   //List of all object types of the items available

IntList containerCatalogue = new IntList(2,17);       //Stores the type numbers which are containers
IntList seatCatalogue      = new IntList(5);          //Stores the type numbers which are seats
IntList fluidCatalogue     = new IntList(11,12,13);   //Stores the type numbers which are fluid interacters

IntList drinkPrices   = new IntList(1,3,2);   //Prices of each type of beer per ml

Pipe startPipe;             //Temporary pipe that holds the output pipe for a given network, where it is then given its initial values (by the pump)
Pipe currentPipe;           //Temporary pipe that holds the pipe currently having its fluid moved to another pipe (when calculating flow path)
Container containerTemp;    //Temporary conatiner that is used when items are being moved between containers

//Custom fonts

//Default HLI
//PFont DefaultHLI; //## LIKELY WONT WORK, CURRENTLY NOT WORKING ##//
PImage a_DefaultHLI;
PImage A_DefaultHLI;
PImage b_DefaultHLI;
PImage B_DefaultHLI;
PImage c_DefaultHLI;
PImage C_DefaultHLI;
PImage d_DefaultHLI;
PImage D_DefaultHLI;
PImage e_DefaultHLI;
PImage E_DefaultHLI;
PImage f_DefaultHLI;
PImage F_DefaultHLI;
PImage g_DefaultHLI;
PImage G_DefaultHLI;
PImage h_DefaultHLI;
PImage H_DefaultHLI;
PImage i_DefaultHLI;
PImage I_DefaultHLI;
PImage j_DefaultHLI;
PImage J_DefaultHLI;
PImage k_DefaultHLI;
PImage K_DefaultHLI;
PImage l_DefaultHLI;
PImage L_DefaultHLI;
PImage m_DefaultHLI;
PImage M_DefaultHLI;
PImage n_DefaultHLI;
PImage N_DefaultHLI;
PImage o_DefaultHLI;
PImage O_DefaultHLI;
PImage p_DefaultHLI;
PImage P_DefaultHLI;
PImage q_DefaultHLI;
PImage Q_DefaultHLI;
PImage r_DefaultHLI;
PImage R_DefaultHLI;
PImage s_DefaultHLI;
PImage S_DefaultHLI;
PImage t_DefaultHLI;
PImage T_DefaultHLI;
PImage u_DefaultHLI;
PImage U_DefaultHLI;
PImage v_DefaultHLI;
PImage V_DefaultHLI;
PImage w_DefaultHLI;
PImage W_DefaultHLI;
PImage x_DefaultHLI;
PImage X_DefaultHLI;
PImage y_DefaultHLI;
PImage Y_DefaultHLI;
PImage z_DefaultHLI;
PImage Z_DefaultHLI;

//Beers
PImage beerMugBack1;
PImage beerLiquid1;
PImage beerMug1;

//Entity chatter
PImage orcChatter1;
PImage orcChatter2;
PImage orcChatter3;

//Entity (beer) requests
PImage requestBeer1;

//Icons

PImage coinIcon;
PImage removeIcon;

//Custom textures
PImage sludgeMonsterFrontStat;
PImage sludgeMonsterBackStat;
PImage sludgeMonsterLeftStat;
PImage sludgeMonsterRightStat;

PImage orcFrontStat;

PImage userFollower1Left;
PImage userFollower1Right;

PImage characterOverlay;

PImage explorationCursor;
PImage buildingCursor;
PImage pipingCursor;
PImage cropCursor;

PImage nightFilter;

PImage innStatusOpen;
PImage innStatusClosed;

PImage factionIcon1;
PImage factionIcon2;
PImage factionIcon3;
PImage factionIcon4;

PImage sunOuterTimeDisplay;
PImage moonFullTimeDisplay;
PImage sunTimeDisplay;
PImage moonTimeDisplay;
PImage sleepBar;
PImage urgencyBar;
PImage forecastBarRain;

PImage greenBuildingGhost;
PImage redBuildingGhost;

PImage pump;
PImage vat;
PImage machinery;

PImage buildingModeEdgeEffect;
PImage pipingModeEdgeEffect;
PImage cropModeEdgeEffect;

PImage menu1;

PImage eventBoxTop;
PImage eventBoxMiddle;    //##CAN COMBINE INTO ONE TEXTURE IF NEEDED
PImage eventBoxTextBox;   //##

PImage field;
PImage barleyStg1;
PImage barleyStg2;
PImage barleyStg3;
PImage barleyStg4;

PImage tree;
PImage lrgTree;

PImage waterCenter;
PImage waterFront;

PImage userFront;      //1
PImage userBack;       //2
PImage userLeft;       //3
PImage userRight;      //4

PImage magicWallMiddle;
PImage magicWallHidden;
PImage magicBarrel;
PImage magicCounterMiddle;
PImage magicCounterCornerLeft;
PImage magicCounterCornerRight;
PImage magicCounterCornerLeftDown;
PImage magicCounterCornerRightDown;
PImage magicCounterCornerLeftUpDown;
PImage magicCounterCornerRightUpDown;
PImage magicCounterHidden;
PImage magicCounterUpper;
PImage magicCounterLower;
PImage magicTable;
PImage fireContained;
PImage tradingOutpost;
PImage port;
//Round multi-tile
PImage magicTableRoundCentre;
PImage magicTableRoundLeftMiddle;
PImage magicTableRoundRightMiddle;
PImage magicTableRoundBottomMiddle;
PImage magicTableRoundTopMiddle;
PImage magicTableRoundLeftUpper;
PImage magicTableRoundRightUpper;
PImage magicTableRoundLeftLower;
PImage magicTableRoundRightLower;
//
PImage magicStool;
PImage magicDoor;
PImage magicDoorSideway;
PImage magicFloorPlain;
PImage magicFloorBricked;
PImage magicFloorFancy;

PImage naturalFloorPlain;
PImage naturalFloorFlowered;
PImage naturalFloorStone;

PImage userRightRun1;
PImage userRightRun2;
PImage userRightRun3;
PImage userRightRun4;
PImage userRightRun5;
PImage userRightRun6;
PImage userRightRun7;
PImage userRightRun8;
PImage userRightRun9;
PImage userRightRun10;
PImage userRightRun11;
PImage userRightRun12;

PImage userFrontRun1;
PImage userFrontRun2;
PImage userFrontRun3;
PImage userFrontRun4;
PImage userFrontRun5;
PImage userFrontRun6;
PImage userFrontRun7;

PImage userFrontStat1Set1;
PImage userFrontStat1Set5;
PImage userFrontStat1Set9;
PImage userFrontStat1Set13;
PImage userFrontStat1Set17;
PImage userFrontStat1Set18;
PImage userFrontStat1Set19;
PImage userFrontStat1Set20;
PImage userFrontStat1Set21;
PImage userFrontStat1Set22;
PImage userFrontStat1Set23;
PImage userFrontStat1Set24;

PImage pipeAlone;
PImage pipeOpenClosed;
PImage pipeCorner;
PImage pipeOpenOpen;
PImage pipeThreeJunction;
PImage pipeFourJunction;

PImage test1;
PImage test2;
PImage test3;
PImage test4;
PImage test5;
PImage test6;
PImage test7;
PImage test8;
PImage test9;
PImage test10;

//Sounds
//## MAKE THEM LESS MUDDY, MORE CONFIDENCE TO THEM e.g LIKE CUBE WORLD LVL UP SOUND ##//
SoundFile backgroundMusic1;
SoundFile traditionalSong1;
SoundFile footstepsGrass;
SoundFile buttonSelectionSound;
SoundFile generalClickSound;
SoundFile largeEventSound;
SoundFile smallEventSound;
SoundFile openInventorySound;
SoundFile placeTileSound;
