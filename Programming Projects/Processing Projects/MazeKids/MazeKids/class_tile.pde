class tile
{
    int x;
    int y;
    boolean wall;
    boolean finish;
    boolean start;

    tile(int xi, int yi)
    {
        x = xi;
        y = yi;

        wall   = false;
        start  = false;
        finish = false;
    }

    void drawme()
    {
        pushMatrix();
        pushStyle();

        stroke(0);
        strokeWeight(2);
        noStroke();
        fill(100);
        if (start)
        {
            fill(0,255,0);
        }
        if (finish)
        {
            fill(255,0,0);
        }
        if (wall)
        {
            fill(30);
        }
        rect(0,0,tileSize,tileSize);

        popStyle();
        popMatrix();    
    }
}