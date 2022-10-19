/*
    This file contains the main game loop for Colour Game.
*/

void game()
{
  
    scaleint = lerp(scaleint,tarScaleint,0.1);

    if (!newGameInitialized) {initalizeNewGame(); println("Initalized the game");}      // If a new game has just been started, then initalize the relevant parts of it
    drawGame(); // Draw the game state to the screen
    //drawIngameMenu();

    if (middleMouseHeld)
    {
            // Shift the world slightly every frame that the user is dragging with middle click held
        world.move(mouseX-dragReference.x, mouseY-dragReference.y);
        dragReference = new PVector(mouseX,mouseY);
    }
}

void drawGame()
{
    pushMatrix();
    pushStyle();
    
    drawWorldGrid();
    
    popStyle();
    popMatrix();

    //if (scaleint != tarScaleint)
    //{
    //    scaleint = tarScaleint;
    //}
}

void initalizeNewGame()
{
    world = new grid(width*0.9, new PVector(width/2,height/2));
    world.depth = 0;
    world.subdivide(worldSubdivisionDepth);

    newGameInitialized = true;
}


void checkCollision()
{
    mouse = new PVector(mouseX,mouseY);
}


grid getGridByTree(ArrayList<Integer> tree)
{
    grid currentGrid;
    currentGrid = world.subgrids[tree.get(0)];
    tree.remove(0);
    for (Integer gridChoice : tree)
    {
        currentGrid = currentGrid.subgrids[gridChoice];
    }
    return currentGrid;
}

grid getGridByIndex(int depth, int index)
{
    grid currentGrid;
  
    //Need to tell the method the depth to work at and the index within that paradigm

    ArrayList<Integer> tree = new ArrayList<Integer>();

    int col = floor(index%pow(3,depth));
    int row = floor(index/pow(3,depth));

    int N = depth;
    int ncol;
    int nrow;

    while (N!=0)
    {
        ncol = floor(col/3);
        nrow = floor(row/3);

        int choice = (col%3) + 3*(row%3);
        tree.add(choice);

        col = ncol;
        row = nrow;
        N--;
    }

    ArrayList<Integer> bufferTree = new ArrayList<Integer>();
    for (int i = tree.size()-1; i >= 0; i--)
    {
        bufferTree.add(tree.get(i));
    }
    tree = bufferTree;

    currentGrid = getGridByTree(tree);

    return currentGrid;
}


void drawWorldGrid()
{
    world.drawme();
}

void drawIngameMenu()
{
    pushMatrix();
    pushStyle();
    
    fill(((sin(frameCount/60.0 * 2*PI)+1)/2 + 1)*100,200);  // Weird fill, i know, but its a simple oscillating color button so its cool dw about it
    translate((width/40) * getScaleFactor(), (width/40) * getScaleFactor());
    rect(0,0,(width/20) * getScaleFactor(),(width/20) * getScaleFactor());
    
    popStyle();
    popMatrix();

    pushStyle();
    
        // Cool screen darkening effect
    fill(0, ingameOptionsMenuDarkening*150);
    rect(width/2,height/2, width,height);
    popStyle();

    if (ingameOptionsMenu)
    {
        pushMatrix();
        pushStyle();
        
        ingameOptionsMenuDarkening = lerp(ingameOptionsMenuDarkening,1.0,0.1);

        

        pushMatrix();
        pushStyle();
        
        translate(ingameOptionsMenuPos.x,ingameOptionsMenuPos.y);
        fill(0,200);
        rect(0,0, ingameOptionsMenuDims.x,ingameOptionsMenuDims.y);
        
        popStyle();
        popMatrix();

        pushMatrix();
        pushStyle();
        
        textSize(width/50);
        translate(ingameOptionsMenuPos.x, ingameOptionsMenuPos.y);
        fill(255);
        text("Options Menu", 0,0);        
        
        popStyle();
        popMatrix();

        
        popStyle();
        popMatrix();
    }
    else
    {
        if (ingameOptionsMenuDarkening!=0.0) {ingameOptionsMenuDarkening = lerp(ingameOptionsMenuDarkening,0.001,0.1);}
    }
}


void adjustWorldSize()
{
    world.adjustSize(getScaleFactor());
}
