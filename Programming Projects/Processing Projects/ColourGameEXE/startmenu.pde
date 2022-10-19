
/*
    The function that handles drawing and controlling the start menu
*/

void startMenu()
{    
        // Draw the start menu to the screen then...
    drawStartMenu();
        // See if the player is overlapping their mouse with a button
    checkButtonOverlap(bsf);
}

void drawStartMenu()
{

    pushMatrix();
    pushStyle();

    textSize(width/20);
    text("Colour Game", width/2,height/7);


        // Button 1 on start menu
    pushMatrix();
    translate(startButton1.x,startButton1.y);
    scale(bsf);
    drawUnit( startButton1Color );
    popMatrix();

        // Text within button 1 on start menu
    pushMatrix();
    pushStyle();
    translate(startButton1.x,startButton1.y);
    textSize(width/40);
    text("Start Game",0,0);
    popStyle();
    popMatrix();
    
    popStyle();
    popMatrix();
}



    // Checks to see if the player is overlapping a button with the mouse
void checkButtonOverlap(float bsf)  // bsf = button scale factor
{
    mouse = new PVector(mouseX,mouseY);
    if (dist(mouse.x,mouse.y,startButton1.x,startButton1.y) < 100*bsf /2)  // 100 is the radius of the 'unit' asset when not scaled
    {
        startButton1Color = startMenuHoveredColor;
    }else{
        startButton1Color = startMenuColor;
    }
}


    // Figure out where everything on the start menu should be and save to variables
void configureStartMenu()
{
    startButton1 = new PVector(width/2,height/3);
    startButton2 = new PVector(width/2,height/3 +   height/6);
    startButton3 = new PVector(width/2,height/3 + 2*height/6);
}