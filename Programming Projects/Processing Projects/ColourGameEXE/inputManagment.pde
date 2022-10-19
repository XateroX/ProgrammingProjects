void mousePressed()
{
    mouse = new PVector(mouseX,mouseY);
        // Input/controls for start menu
    if (gameState.equals("START"))
    {
            // check to see if the user clicked on the first button in the start menu
        if (dist(mouse.x,mouse.y,startButton1.x,startButton1.y) < 100*bsf /2)  // 100 is the radius of the 'unit' asset when not scaled
        {
            gameState = "GAME";
        }
    }

    else if (gameState.equals("GAME"))
    {
            // Check to see if they clicked on the ingame menu button
        if (dist(mouse.x,mouse.y,width/40,width/40) < width/20) {ingameOptionsMenu = true;}  // This should probably come with a warning or at least save the state of the game
        else if (ingameOptionsMenu && 
                    (
                    mouse.x > ingameOptionsMenuPos.x+ingameOptionsMenuDims.x/2 ||
                    mouse.x < ingameOptionsMenuPos.x-ingameOptionsMenuDims.x/2
                    )
                ) {ingameOptionsMenu = false;}       // Ingame options menu is up and you want it to go away, click off of the menu


        if (mouseButton == CENTER)
        {
            dragReference   = new PVector(mouseX,mouseY);
            middleMouseHeld = true;
        }
    }
}

void mouseReleased()
{
    mouse = new PVector(mouseX,mouseY);
        // Input/controls for start menu
    if (gameState.equals("START"))
    {
    }

    else if (gameState.equals("GAME"))
    {
        if (mouseButton == CENTER)
        {
            dragReference   = new PVector(mouseX,mouseY);
            middleMouseHeld = false;
        }
    }
}

void mouseWheel(MouseEvent e)
{
    if (e.getCount() > 0)
    {
        println("SCROLLED DOWN  ", e.getCount());
        tarScaleint -= e.getCount();
    }
    else if (e.getCount() < 0)
    {
        println("SCROLLED UP    ", e.getCount());
        tarScaleint -= e.getCount();
    }

    scaleint = tarScaleint;
    adjustWorldSize();
}
