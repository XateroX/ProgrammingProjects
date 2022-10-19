
    // Debugging //
int total;
ArrayList<Integer> tree;
ArrayList<Integer> bufferTree;
int col;
int row;
int N;
int ncol;
int nrow;

    // Game state and gui/game variables //
String gameState;
boolean newGameInitialized;

boolean ingameOptionsMenu;
PVector ingameOptionsMenuPos;
PVector ingameOptionsMenuDims;
float ingameOptionsMenuDarkening;

color startMenuColor;
color startMenuHoveredColor;    // For when the player is hovering over a button

PVector startButton1;
PVector startButton2;
PVector startButton3;

color startButton1Color;
color startButton2Color;
color startButton3Color;

float bsf;  // Button scale factor (start menu)





    // Input/mechanical global variables //
PVector mouse;
boolean middleMouseHeld;
PVector dragReference;
float scaleint;
float tarScaleint;
float scaleFactor;





    // Ingame objects and variables //
grid world;
int worldSubdivisionDepth;




    // Loaded assets //
int chosenTilesetIndex;
PImage[]  tileset;
PImage[]  tileset100;
PImage[]  tileset200;
boolean[] tileLoaded;

PImage testTexture;

int baseAssetSize;


void setup()
{
    size(1000,1000, P2D);
    initializeGame();
    
    total=0;
}



void draw()
{
    clear();
    background(100,100,100);
     
        // Start by doing the relevant drawing and collision based on the game state
    if      (gameState.equals("START")) {startMenu();}
    else if (gameState.equals("GAME"))  {game();}       // Main loop of the game, runs, draws and manages the game itself
    
    //println(total);
    total=0;
    
    textSize(100);
    text(floor(frameRate),200,50);
}




    //  Things to do at the start of game running (initialization of variables)
void initializeGame()
{
    worldSubdivisionDepth = 3;


        // Arrays for the tile assets to be loaded into
    tileset    = new PImage[60];
    tileset100 = new PImage[60];
    tileset200 = new PImage[60];
    tileLoaded = new boolean[60];
        // NO textures are loaded initially
    for (int i = 0; i < tileLoaded.length; i++) {tileLoaded[i]=false;}
    baseAssetSize = 1000;//loadImage("wallassets\\tileset4\\e0c0.png").width;

    textAlign(CENTER,CENTER);
    rectMode(CENTER);

    bsf = 1.8;
    startButton1 = new PVector(-1,-1);
    startButton2 = new PVector(-1,-1);
    startButton3 = new PVector(-1,-1);
        // Figure out where everything on the start menu should be and save to variables
    configureStartMenu();

    gameState                  = "START";
    newGameInitialized         = false;
    chosenTilesetIndex         = 3;

    ingameOptionsMenu          = false;
    ingameOptionsMenuDarkening = 0.0;
    ingameOptionsMenuPos       = new PVector(width/2,height/2);
    ingameOptionsMenuDims      = new PVector(width/4,height/1.3);

    startMenuColor             = color(random(255),random(255),random(255)); 
    startMenuHoveredColor      = color(random(255),random(255),random(255)); 

    startButton1Color = startMenuColor;
    startButton2Color = startMenuColor;
    startButton3Color = startMenuColor;

    mouse             = new PVector(width/2,height/2);
    dragReference     = new PVector(0,0);
    scaleint          = 1;
    tarScaleint       = 1;
    scaleFactor       = 1;
    for (int i = 0; i < 15; i++){
      for (int j = 0; j < 4; j++){
        loadTile(i,j);
        tileset200[i+15*j] = tileset[i+15*j];
        tileset200[i+15*j].resize(200,200);
        loadTile(i,j);
        //println("tileset[",(i+15*j),"]= ", tileset[i+15*j]);
        image(tileset200[i+15*j],0,0,200,200);
      }
    }
}


void loadTile(int ind, int rotind)
{
    if (!tileLoaded[ind + rotind*15])
    {
        if (rotind == 0)
        {
            if      (ind == 0)  {tileset[0] = null; tileset[0]      = loadImage("wallassets\\tileset4\\e0c0.png");}
            else if (ind == 1)  {tileset[1]      = loadImage("wallassets\\tileset4\\e1.png");}
            else if (ind == 2)  {tileset[2]      = loadImage("wallassets\\tileset4\\e1e2.png");}
            else if (ind == 3)  {tileset[3]      = loadImage("wallassets\\tileset4\\e1e2c2.png");}
            else if (ind == 4)  {tileset[4]      = loadImage("wallassets\\tileset4\\e1e2e3e4.png");}
            else if (ind == 5)  {tileset[5]      = loadImage("wallassets\\tileset4\\e1e2e3e4c1.png");}
            else if (ind == 6)  {tileset[6]      = loadImage("wallassets\\tileset4\\e1e2e3e4c1c2.png");}
            else if (ind == 7)  {tileset[7] = null; tileset[7]      = loadImage("wallassets\\tileset4\\e1e2e3e4c1c2c3c4.png");}
            else if (ind == 8)  {tileset[8]      = loadImage("wallassets\\tileset4\\e1e2e3e4c1c2c4.png");}
            else if (ind == 9)  {tileset[9]      = loadImage("wallassets\\tileset4\\e1e2e4.png");}
            else if (ind == 10) {tileset[10]     = loadImage("wallassets\\tileset4\\e1e2e4c1.png");}
            else if (ind == 11) {tileset[11]     = loadImage("wallassets\\tileset4\\e1e2e4c1c2.png");}
            else if (ind == 12) {tileset[12]     = loadImage("wallassets\\tileset4\\e1e2e4c2.png");}
            else if (ind == 13) {tileset[13]     = loadImage("wallassets\\tileset4\\e1e3.png");}
            else if (ind == 14) {tileset[14]     = loadImage("wallassets\\tileset4\\e1e2e3e4c1c3.png");}
        }
        else if (rotind == 1)
        {
            if      (ind == 0)  {tileset[0+15]   = loadImage("wallassets\\tileset4\\r3e0c0.png");}
            else if (ind == 1)  {tileset[1+15]   = loadImage("wallassets\\tileset4\\r3e1.png");}
            else if (ind == 2)  {tileset[2+15]   = loadImage("wallassets\\tileset4\\r3e1e2.png");}
            else if (ind == 3)  {tileset[3+15]   = loadImage("wallassets\\tileset4\\r3e1e2c2.png");}
            else if (ind == 4)  {tileset[4+15]   = loadImage("wallassets\\tileset4\\r3e1e2e3e4.png");}
            else if (ind == 5)  {tileset[5+15]   = loadImage("wallassets\\tileset4\\r3e1e2e3e4c1.png");}
            else if (ind == 6)  {tileset[6+15]   = loadImage("wallassets\\tileset4\\r3e1e2e3e4c1c2.png");}
            else if (ind == 7)  {tileset[7+15]   = loadImage("wallassets\\tileset4\\r3e1e2e3e4c1c2c3c4.png");}
            else if (ind == 8)  {tileset[8+15]   = loadImage("wallassets\\tileset4\\r3e1e2e3e4c1c2c4.png");}
            else if (ind == 9)  {tileset[9+15]   = loadImage("wallassets\\tileset4\\r3e1e2e4.png");}
            else if (ind == 10) {tileset[10+15]  = loadImage("wallassets\\tileset4\\r3e1e2e4c1.png");}
            else if (ind == 11) {tileset[11+15]  = loadImage("wallassets\\tileset4\\r3e1e2e4c1c2.png");}
            else if (ind == 12) {tileset[12+15]  = loadImage("wallassets\\tileset4\\r3e1e2e4c2.png");}
            else if (ind == 13) {tileset[13+15]  = loadImage("wallassets\\tileset4\\r3e1e3.png");}
            else if (ind == 14) {tileset[14+15]  = loadImage("wallassets\\tileset4\\r3e1e2e3e4c1c3.png");}
        }
        else if (rotind == 2)
        {
            if      (ind == 0)  {tileset[0+30]   = loadImage("wallassets\\tileset4\\r2e0c0.png");}
            else if (ind == 1)  {tileset[1+30]   = loadImage("wallassets\\tileset4\\r2e1.png");}
            else if (ind == 2)  {tileset[2+30]   = loadImage("wallassets\\tileset4\\r2e1e2.png");}
            else if (ind == 3)  {tileset[3+30]   = loadImage("wallassets\\tileset4\\r2e1e2c2.png");}
            else if (ind == 4)  {tileset[4+30]   = loadImage("wallassets\\tileset4\\r2e1e2e3e4.png");}
            else if (ind == 5)  {tileset[5+30]   = loadImage("wallassets\\tileset4\\r2e1e2e3e4c1.png");}
            else if (ind == 6)  {tileset[6+30]   = loadImage("wallassets\\tileset4\\r2e1e2e3e4c1c2.png");}
            else if (ind == 7)  {tileset[7+30]   = loadImage("wallassets\\tileset4\\r2e1e2e3e4c1c2c3c4.png");}
            else if (ind == 8)  {tileset[8+30]   = loadImage("wallassets\\tileset4\\r2e1e2e3e4c1c2c4.png");}
            else if (ind == 9)  {tileset[9+30]   = loadImage("wallassets\\tileset4\\r2e1e2e4.png");}
            else if (ind == 10) {tileset[10+30]  = loadImage("wallassets\\tileset4\\r2e1e2e4c1.png");}
            else if (ind == 11) {tileset[11+30]  = loadImage("wallassets\\tileset4\\r2e1e2e4c1c2.png");}
            else if (ind == 12) {tileset[12+30]  = loadImage("wallassets\\tileset4\\r2e1e2e4c2.png");}
            else if (ind == 13) {tileset[13+30]  = loadImage("wallassets\\tileset4\\r2e1e3.png");}
            else if (ind == 14) {tileset[14+30]  = loadImage("wallassets\\tileset4\\r2e1e2e3e4c1c3.png");}
        }
        else if (rotind == 3)
        {
            if      (ind == 0)  {tileset[0+45]   = loadImage("wallassets\\tileset4\\r1e0c0.png");}
            else if (ind == 1)  {tileset[1+45]   = loadImage("wallassets\\tileset4\\r1e1.png");}
            else if (ind == 2)  {tileset[2+45]   = loadImage("wallassets\\tileset4\\r1e1e2.png");}
            else if (ind == 3)  {tileset[3+45]   = loadImage("wallassets\\tileset4\\r1e1e2c2.png");}
            else if (ind == 4)  {tileset[4+45]   = loadImage("wallassets\\tileset4\\r1e1e2e3e4.png");}
            else if (ind == 5)  {tileset[5+45]   = loadImage("wallassets\\tileset4\\r1e1e2e3e4c1.png");}
            else if (ind == 6)  {tileset[6+45]   = loadImage("wallassets\\tileset4\\r1e1e2e3e4c1c2.png");}
            else if (ind == 7)  {tileset[7+45]   = loadImage("wallassets\\tileset4\\r1e1e2e3e4c1c2c3c4.png");}
            else if (ind == 8)  {tileset[8+45]   = loadImage("wallassets\\tileset4\\r1e1e2e3e4c1c2c4.png");}
            else if (ind == 9)  {tileset[9+45]   = loadImage("wallassets\\tileset4\\r1e1e2e4.png");}
            else if (ind == 10) {tileset[10+45]  = loadImage("wallassets\\tileset4\\r1e1e2e4c1.png");}
            else if (ind == 11) {tileset[11+45]  = loadImage("wallassets\\tileset4\\r1e1e2e4c1c2.png");}
            else if (ind == 12) {tileset[12+45]  = loadImage("wallassets\\tileset4\\r1e1e2e4c2.png");}
            else if (ind == 13) {tileset[13+45]  = loadImage("wallassets\\tileset4\\r1e1e3.png");}
            else if (ind == 14) {tileset[14+45]  = loadImage("wallassets\\tileset4\\r1e1e2e3e4c1c3.png");}
        }
    }

    tileLoaded[ind + rotind*15] = false;
}




float getScaleFactor()
{
    return pow(1.41,scaleint);
}
