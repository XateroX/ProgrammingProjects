class grid{

    float baseSize;
    float size;
    PVector baseCenter;
    PVector center;
    grid[] subgrids;
    boolean subdivided;
    int depth;
    boolean isWall;
    ArrayList<Integer> gridLoc;
    
    int textureRotation;
    PImage correctWallTexture;
    int correctWallTextureInd;
    int correctWallTextureRotInd;
    boolean textureUnknown;
    boolean textureTypeUnknown;
    
    grid(float isize, PVector ipos){
        depth = -1;

        size     = isize;
        baseSize = isize;
        center = new PVector(0,0);
        center.x = ipos.x;
        center.y = ipos.y;
        baseCenter = new PVector(0,0);
        baseCenter.x = center.x;
        baseCenter.y = center.y;
        subgrids = new grid[9];

        subdivided = false;

        isWall = false;
        if (random(1) < 0.8){
            isWall = true;
        }
        textureRotation       = 0;
        textureUnknown        = true;
        textureTypeUnknown    = true;
        correctWallTexture    = createImage(1,1, RGB);
        correctWallTextureInd = -1;
        correctWallTextureRotInd =  0;

        gridLoc = new ArrayList<Integer>();
    }
  
    void subdivide(int iters){
        while (iters > 0)
        { 
            if (!subdivided)
            {
                subgrids[0] = new grid(size/3, new PVector(center.x - size/3, center.y - size/3));  
                subgrids[1] = new grid(size/3, new PVector(center.x         , center.y - size/3));
                subgrids[2] = new grid(size/3, new PVector(center.x + size/3, center.y - size/3));

                subgrids[3] = new grid(size/3, new PVector(center.x - size/3, center.y));  
                subgrids[4] = new grid(size/3, new PVector(center.x         , center.y));  
                subgrids[5] = new grid(size/3, new PVector(center.x + size/3, center.y));  

                subgrids[6] = new grid(size/3, new PVector(center.x - size/3, center.y + size/3));
                subgrids[7] = new grid(size/3, new PVector(center.x         , center.y + size/3));
                subgrids[8] = new grid(size/3, new PVector(center.x + size/3, center.y + size/3));

                for (int i = 0; i < 9; i++)
                {
                    subgrids[i].depth   = depth+1;
                    for (int a = 0; a < gridLoc.size(); a++)
                    {
                      subgrids[i].gridLoc.add(gridLoc.get(a));
                    }
                    subgrids[i].gridLoc.add(i);
                }

                subdivided = true;
            }else{
                for (int i = 0; i < 9; i++){ //<>// //<>// //<>//
                    subgrids[i].subdivide(1); //<>// //<>// //<>//
                }
            }
            iters--; //<>// //<>// //<>// //<>// //<>// //<>//
        } //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    } //<>// //<>// //<>//

    void drawme(){
        pushMatrix(); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
        pushStyle(); //<>// //<>// //<>// //<>// //<>//

        if (!subdivided)
        {   
            noFill();
            stroke(0);
            strokeWeight(width/500);
            translate(center.x,center.y);
            //rect(0,0, size,size);
            textSize(20);
            //text(getOverallGridIndex(),0,0);

            pushMatrix();
            pushStyle();

            translate(0,20);
            //text(gridLoc.get(0),0,0);
            
            popStyle();
            popMatrix();
        }

        if (!subdivided && isWall)
        {
            pushMatrix();
            pushStyle();
            
            if (textureUnknown)
            {
                if (textureTypeUnknown)
                {
                    getCorrectWallTexture();
                }
                //copyTile(correctWallTextureInd,correctWallTextureRotInd);
                //correctWallTexture.resize(size,size);
                //correctWallTexture.resize(floor(size),floor(size));
                println("FINDING TEXTURE ", frameCount, "       gridno ", getOverallGridIndex());
                textureUnknown = false;
            }
            
            //rotate(((float)frameCount/60));//-textureRotation * PI/2);
            translate(-size/2,-size/2);
            //scale(getScaleFactor());
            
            //rect(0,0, size,size);
            image(tileset200[correctWallTextureInd + 15*correctWallTextureRotInd],0,0,size,size);            
            
            popStyle();
            popMatrix();
        }


        if (subdivided)
        {
            drawSubgrids();
        }

        popMatrix();
        popStyle();
    }

    void drawSubgrids(){
        for (int i = 0; i < 9; i++){
            subgrids[i].drawme();
        }
    }

    void move(float dx, float dy)
    {
        center.x     += dx;
        center.y     += dy;

        baseCenter.x += dx;
        baseCenter.y += dy;

        if (subdivided)
        {
            for (int i = 0; i < subgrids.length; i++) {subgrids[i].move(dx,dy);}
        }
    }

    void adjustSize(float sf)
    {
        size = sf*baseSize;

        if (subdivided)
        {
            subgrids[0].size     = size/3;
            subgrids[0].center.x = center.x - size/3;
            subgrids[0].center.y = center.y - size/3;  

            subgrids[1].size     = size/3;
            subgrids[1].center.x = center.x;
            subgrids[1].center.y = center.y - size/3;

            subgrids[2].size     = size/3;
            subgrids[2].center.x = center.x + size/3;
            subgrids[2].center.y = center.y - size/3;

            subgrids[3].size     = size/3;
            subgrids[3].center.x = center.x - size/3;
            subgrids[3].center.y = center.y;

            subgrids[4].size     = size/3;
            subgrids[4].center.x = center.x;
            subgrids[4].center.y = center.y;

            subgrids[5].size     = size/3;
            subgrids[5].center.x = center.x + size/3;
            subgrids[5].center.y = center.y;

            subgrids[6].size     = size/3;
            subgrids[6].center.x = center.x - size/3;
            subgrids[6].center.y = center.y + size/3;

            subgrids[7].size     = size/3;
            subgrids[7].center.x = center.x;
            subgrids[7].center.y = center.y + size/3;

            subgrids[8].size     = size/3;
            subgrids[8].center.x = center.x + size/3;
            subgrids[8].center.y = center.y + size/3;

            for (int i = 0; i < 9; ++i) 
            {
                subgrids[i].adjustSize(sf);    
            }
        }

        textureUnknown     = true;
        textureTypeUnknown = true;
    }

    grid getMouseCollided(){
        PVector mouse = new PVector(mouseX,mouseY);

        if (!subdivided) {return this;}

            // 0
        if (mouse.x < center.x-size/6 &&
            mouse.x > center.x-size/2 &&
            
            mouse.y < center.y-size/6 &&
            mouse.y > center.y-size/2){

            return subgrids[0].getMouseCollided();
        }

            // 1
        if (mouse.x < center.x+size/6 &&
            mouse.x > center.x-size/6 &&
            
            mouse.y < center.y-size/6 &&
            mouse.y > center.y-size/2){

            return subgrids[1].getMouseCollided();
        }

            // 2
        if (mouse.x < center.x+size/2 &&
            mouse.x > center.x+size/6 &&
            
            mouse.y < center.y-size/6 &&
            mouse.y > center.y-size/2){

            return subgrids[2].getMouseCollided();
        }

            // 3
        if (mouse.x < center.x-size/6 &&
            mouse.x > center.x-size/2 &&
            
            mouse.y < center.y+size/6 &&
            mouse.y > center.y-size/6){

            return subgrids[3].getMouseCollided();
        }

            // 4
        if (mouse.x < center.x+size/6 &&
            mouse.x > center.x-size/6 &&
            
            mouse.y < center.y+size/6 &&
            mouse.y > center.y-size/6){

            return subgrids[4].getMouseCollided();
        }

            // 5
        if (mouse.x < center.x+size/2 &&
            mouse.x > center.x+size/6 &&
            
            mouse.y < center.y+size/6 &&
            mouse.y > center.y-size/6){

            return subgrids[5].getMouseCollided();
        }

            // 6
        if (mouse.x < center.x-size/6 &&
            mouse.x > center.x-size/2 &&
            
            mouse.y < center.y+size/2 &&
            mouse.y > center.y+size/6){

            return subgrids[6].getMouseCollided();
        }

            // 7
        if (mouse.x < center.x+size/6 &&
            mouse.x > center.x-size/6 &&
            
            mouse.y < center.y+size/2 &&
            mouse.y > center.y+size/6){

            return subgrids[7].getMouseCollided();
        }

            // 8
        if (mouse.x < center.x+size/2 &&
            mouse.x > center.x+size/6 &&
            
            mouse.y < center.y+size/2 &&
            mouse.y > center.y+size/6){

            return subgrids[8].getMouseCollided();
        }

        return null;
    }

    int getOverallGridIndex()
    {
        int In = 0;
            // Getting the column value
        int col = 0;
        for (int n = gridLoc.size(); n >= 1; n--)
        {
            In = gridLoc.get(gridLoc.size()-n);
            col += (pow(3,n)/(3)) * (In%3);
        }

            // Getting the row value
        int row = 0;
        for (int n = gridLoc.size(); n >= 1; n--)
        {   
            In = gridLoc.get(gridLoc.size()-n);
            row += (pow(3,n)/(3)) * ((In - In%3)/3);
        }

        return ceil(row*pow(3,depth) + col);
    }


    void getCorrectWallTexture()
    {
        total++;

        textureUnknown     = false;
        textureTypeUnknown = false;

        int cIndex = getOverallGridIndex();

        boolean[] e = new boolean[4];
        boolean[] c = new boolean[4];

        //!! ADD ERROR OUT OF BOUNDS CHECKS  !!// 

        e[0] = getGridByIndex(depth,abs(floor(cIndex-pow(3,depth)))).isWall;
        e[1] = getGridByIndex(depth,abs(floor(cIndex+1)))           .isWall;
        e[2] = getGridByIndex(depth,abs(floor(cIndex+pow(3,depth)))).isWall;
        e[3] = getGridByIndex(depth,abs(floor(cIndex-1)))           .isWall;

        c[0] = getGridByIndex(depth,abs(floor(cIndex-pow(3,depth)-1))).isWall;
        c[1] = getGridByIndex(depth,abs(floor(cIndex-pow(3,depth)+1))).isWall;
        c[2] = getGridByIndex(depth,abs(floor(cIndex+pow(3,depth)+1))).isWall;
        c[3] = getGridByIndex(depth,abs(floor(cIndex+pow(3,depth)-1))).isWall;

        c = removeNonSandwichedCorners(e,c);

        for (int i = 0; i < 4; i++)     // Add a constant to all the values and see if that is in the table (this accounts for rotation)
        {
            boolean[] C = new boolean[4];
            boolean[] E = new boolean[4];

            C[(0+i)%4]=c[0];
            C[(1+i)%4]=c[1];
            C[(2+i)%4]=c[2];
            C[(3+i)%4]=c[3];

            E[(0+i)%4]=e[0];
            E[(1+i)%4]=e[1];
            E[(2+i)%4]=e[2];
            E[(3+i)%4]=e[3];
            
            textureRotation = i;
                                // Check each of the tile identities in the table and see if any match
            //1
            if       (E[0]&&E[1]&&E[3] && C[0]&&C[1]    &&    !(E[2])&&!(C[2])&&!(C[3]))
            {
                copyTile(11,i);
                return;//return tileset[11+i*15];
            }

            //2
            else if (E[0]    &&    !(C[1])&&!(C[0])&&!(E[3])&&!(E[1])&&!(E[2])&&!(C[2])&&!(C[3]))
            {
                copyTile(1,i);
                return;//return tileset[1+i*15];
            }

            //3
            else if ((E[0]&&E[1]&&E[2]&&E[3] && C[0]&&C[1]  &&  !(C[3])&&!(C[2])))
            {
                copyTile(6,i);
                return;//return tileset[6+i*15];
            }

            //4
            else if ((E[0]&&E[1]&&E[3] && C[1]    &&    !(C[3])&&!(C[2])&&!(C[0])&&!(E[2])))
            {
                copyTile(12,i);
                return;//return tileset[12+i*15];
            }

            //5
            else if ((E[0]&&E[2]    &&    !(C[3])&&!(C[2])&&!(C[1])&&!(C[0])&&!(E[3])&&!(E[1])))
            {
                copyTile(13,i);
                return;//return tileset[13+i*15];
            }

            //6
            else if (!(E[0])&&!(E[1])&&!(E[2])&&!(E[3])&&!(C[0])&&!(C[1])&&!(C[2])&&!(C[3]))
            {
                copyTile(0,i);
                return;//return tileset[0+i*15];
            }

            //7
            else if ((E[0]&&E[1]&&E[2]&&E[3] && C[0]&&C[1]&&C[3]    &&   !(C[2])))
            {
                copyTile(8,i);
                return;//return tileset[8+i*15];
            }

            //8
            else if ((E[0]&&E[1]&&E[3] && C[0]    &&    !(C[3])&&!(C[2])&&!(C[1])&&!(E[2])))
            {
                copyTile(10,i);
                return;//return tileset[10+i*15];
            }

            //9
            else if ((E[0]&&E[1] && C[1]    &&    !(E[2])&&!(E[3])&&!(C[0])&&!(C[2])&&!(C[3])))
            {
                copyTile(3,i);
                return;//return tileset[3+i*15];
            }

            //10
            else if ((E[0]&&E[1]    &&    !(E[2])&&!(E[3])&&!(C[0])&&!(C[1])&&!(C[2])&&!(C[3])))
            {
                copyTile(2,i);
                return;//return tileset[2+i*15];
            }

            //11
            else if ((E[0]&&E[1]&&E[2]&&E[3] && C[0]     &&    !(C[1])&&!(C[2])&&!(C[3])))
            {
                copyTile(5,i);
                return;//return tileset[5+i*15];
            }

            //12
            else if ((E[0]&&E[1]&&E[2]&&E[3] && C[0]&&C[1]&&C[2]&&C[3]))
            {
                copyTile(7,i);
                return;//return tileset[7+i*15];
            }

            //13
            else if ((E[0]&&E[1]&&E[2]&&E[3]    &&    !(C[0])&&!(C[1])&&!(C[2])&&!(C[3])))
            {
                copyTile(4,i);
                return;//return tileset[4+i*15];
            }

            //14
            else if ((E[0]&&E[1]&&E[3]    &&    !(E[2])&&!(C[0])&&!(C[1])&&!(C[2])&&!(C[3])))
            {
                copyTile(9,i);
                return;
            }
            
            //15
            else if ((E[0]&&E[1]&&E[2]&&E[3]&&C[0]&&C[2]    &&    !(C[1])&&!(C[3])))
            {
                copyTile(14,i);
                return;//return tileset[14+i*15];
            }
        }
        //copyTile(floor(random(2)),0);
        //copyTile(floor((float)frameCount/60.0),0);
    }


    boolean[] removeNonSandwichedCorners(boolean[] e, boolean[] c)
    {
        boolean[] n_c = new boolean[4];

        for (int i = 0; i < 4; i++)
        {
            if (!c[i])
            {
                n_c[i] = false;
            }
            else if (e[i] && e[(4+i-1)%4])  //+4 to prevent -ve errors (and +4 will be equivalent to 0 mod 4)
            {
                n_c[i] = true;
            }else
            {
                n_c[i] = false;
            }
        }

        return n_c;
    }

    void copyTile(int ind, int i)
    {
        correctWallTextureInd    = ind;
        correctWallTextureRotInd = i;

        //loadTile(ind,i);
        //correctWallTexture = createImage(floor(sqrt(tileset[ind+i*15].pixels.length)), floor(sqrt(tileset[ind+i*15].pixels.length)), RGB);
        //for (int j = 0; j < correctWallTexture.pixels.length; j++) {
        //    correctWallTexture.pixels[j] = tileset[ind+i*15].pixels[j];
        //}
        //correctWallTexture.updatePixels();
        println("Copying tile texture for tile ", getOverallGridIndex());
        println(tileset[ind+i*15]);
        //correctWallTexture = tileset[ind+i*15];
        println("Selected tile ", ind+i*15);
    }
}
