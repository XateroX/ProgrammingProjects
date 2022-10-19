class agent
{
    int x;
    int y;
    ArrayList<Integer> dirs;
    int currentDirInd;

    agent()
    {
        x = 0;
        y = 0;
        dirs = new ArrayList<Integer>();
        for (int i = 0; i < agentDirsSize; i++)
        {
            dirs.add( floor(random(0,4)) );
        }
        //println(agentDirsSize);
        currentDirInd = 0;
    }

    void drawme()
    {
        pushMatrix();
        pushStyle();

        rectMode(CENTER);
        fill(255,0,0,100);
        noStroke();
        rect(0,0,tileSize*0.75,tileSize*0.75);

        popStyle();
        popMatrix();
    }

    void doAction()
    {
        if (!(x==finishx && y==finishy))
        {
            if (currentDirInd >= dirs.size())
            {
                currentDirInd = 0;
            }
            if      (dirs.get(currentDirInd) == 0)
            {moveUp();}
            else if (dirs.get(currentDirInd) == 1)
            {moveDown();}
            else if (dirs.get(currentDirInd) == 2)
            {moveLeft();}
            else if (dirs.get(currentDirInd) == 3)
            {moveRight();}
        }
        currentDirInd += 1;
    }

    void moveUp()
    {
        if (y-1 >= 0)
        {
            if (!grid.get(x).get(y-1).wall)
            {
                y = y-1;
            }
        }
    }
    void moveDown()
    {
        if (y+1 <= gridrows-1)
        {
            if (!grid.get(x).get(y+1).wall)
            {
                y = y+1;
            }
        }
    }
    void moveLeft()
    {
        if (x-1 >= 0)
        {
            if (!grid.get(x-1).get(y).wall)
            {
                x = x-1;
            }
        }
    }
    void moveRight()
    {
        if (x+1 <= gridcols-1)
        {
            if (!grid.get(x+1).get(y).wall)
            {
                x = x+1;
            }
        }
    }
}