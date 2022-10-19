
PVector dir; // Cancer dont touch //


boolean debuggerpoint1;
boolean debuggerpoint2;
boolean debuggerpoint3;
boolean debuggerpoint4;
boolean debuggerpoint5;









player player;
ArrayList<enemy> enemies;
ArrayList<terrain> map;
ArrayList<bullet> bullets;
ArrayList<pit> pits;

float mapWidth;
float mapHeight;

PVector camera;

void setup()
{
    //fullScreen();
    size(800,800);
    initialization();

    rectMode(CENTER);
}

void draw()
{
    debuggerpoint1 = false;
    debuggerpoint2 = false;
    debuggerpoint3 = false;
    debuggerpoint4 = false;
    debuggerpoint5 = false;
    pushMatrix();
  
    clear();
    background(0);
    translate(width/2-camera.x,height/2-camera.y);
    
    rect(mapWidth/2,mapHeight/2,mapWidth,mapHeight);
  
    player.update();
    updateEnemies();
    updateBullets();


    drawPits();
    drawEnemies();
    player.drawMe();
    drawBullets();
    drawMap();

        // Adjust the cameras position
    camera.x = lerp(camera.x, player.pos.x + player.vel.x*50, 0.025);
    camera.y = lerp(camera.y, player.pos.y + player.vel.y*50, 0.025);
    
    popMatrix();
    
    debugging();
}


void initialization()
{
    mapWidth  = 8000;
    mapHeight = 8000;

    player  = new player( new PVector(mapWidth/2,mapHeight/2), 50, new PVector(0,0,255) );
    enemies = new ArrayList<enemy>(); 
    map     = new ArrayList<terrain>(); 
    bullets = new ArrayList<bullet>();
    pits    = new ArrayList<pit>();

        // Generate the map and the terrain (potentially just storing the terrain though)
    generateTerrain(50);
    generatePits(10);
    generateEnemies(40);

    camera = new PVector(player.pos.x,player.pos.y);
}



    //  ----    Map Stuff    ----   //
void generateTerrain(int terrainNumber)
{
    println(mapWidth, " ", mapHeight);
    for (int i = 0; i < terrainNumber; ++i) {
        map.add( new terrain( new PVector(random(mapWidth),random(mapHeight)), 50 ) );
    }
}
void generatePits(int pitNumber)
{
    for (int i = 0; i < pitNumber; i++)
    {
        pits.add( new pit( new PVector(random(mapWidth),random(mapHeight)), random(mapWidth/10,mapWidth/3), random(mapWidth/10,mapWidth/3) ) );
    }
}
void drawMap()
{
    for (terrain c_terrain : map)
    {
        c_terrain.drawMe();
    }
}
void drawPits()
{
    for (pit c_pit : pits)
    {
        c_pit.drawMe();
    }
}
void drawEnemies()
{
    for (enemy c_enemy : enemies)
    {
        c_enemy.drawMe();
    }
}
void drawBullets()
{
    for (bullet c_bullet : bullets)
    {
        c_bullet.drawMe();
    }
}
    //  -------------------------   //





    //  ----    Update game state and agents    ----  //
void updateEnemies()
{
    for (int i = enemies.size()-1; i >= 0; i--)
    {
        enemy c_enemy = enemies.get(i); 
        c_enemy = enemies.get(i);
        c_enemy.update();
    }
}
void updateBullets()
{
    for (int i = bullets.size()-1; i >= 0; i--)
    {
        bullet c_bullet = bullets.get(i);
        c_bullet = bullets.get(i);
        c_bullet.update();
    }
}
    //  --------------------------------------------  //




    //  ----  Initalize enemy positions  ----  //
void generateEnemies(int enemyNumber)
{
    for (int i = 0; i < enemyNumber; i++)
    {
            // Generate randomly distributed enemies
        enemies.add( new enemy(new PVector(random(mapWidth),random(mapHeight)), 50, new PVector(255,255,255) ) );
    }
}
    //  -------------------------------------  //



void mousePressed()
{
    println("Mouse pressed");

        // Make the player character do a slash (will take a few frames to complete)
    //player.slash();
}

void keyPressed()
{
    println("KeyCode: ", keyCode);

    println("Key Pressed");
    if (key == 'w')
    {
        // W
        player.wIsPressed = true;
    }
    if (key == 'a')
    {
        // A
        player.aIsPressed = true;
    }
    if (key == 's')
    {
        // S
        player.sIsPressed = true;
    }
    if (key == 'd')
    {
        // D
        player.dIsPressed = true;
    }

    if (keyCode == 32)
    {
        // SPACE
        player.spaceIsPressed = true;
    }
}

void keyReleased()
{
    println("Key Released");
    if (key == 'w')
    {
        // W
        player.wIsPressed = false;
    }
    if (key == 'a')
    {
        // A
        player.aIsPressed = false;
    }
    if (key == 's')
    {
        // S
        player.sIsPressed = false;
    }
    if (key == 'd')
    {
        // D
        player.dIsPressed = false;
    }

    if (keyCode == 32)
    {
        // SPACE
        player.spaceIsPressed = false;
    }
}
















void debugging()
{
  pushStyle();
  pushMatrix();
  textSize(20);
  fill(0);
  
  
  
  translate(0,height/30);
  text("isWallRunning  " + str(player.isWallRunning),0,0);
  
  translate(0,height/30);
  text("wallRunningOnCD  " + str(player.wallRunningOnCD),0,0);
  
  translate(0,height/30);
  text("debuggerpoint1  " + str(debuggerpoint1),0,0);
  translate(0,height/30);
  text("debuggerpoint2  " + str(debuggerpoint2),0,0);
  translate(0,height/30);
  text("debuggerpoint3  " + str(debuggerpoint3),0,0);
  translate(0,height/30);
  text("debuggerpoint4  " + str(debuggerpoint4),0,0);
  translate(0,height/30);
  text("debuggerpoint5  " + str(debuggerpoint5),0,0);
  
  
  
  popStyle();
  popMatrix();
}
