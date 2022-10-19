class grid{
    float size;
    PVector center;
    grid[] subgrids;
    boolean subdivided;
    
    grid(float isize, PVector ipos){
        size=isize;
        center = new PVector(0,0);
        center.x = ipos.x;
        center.y = ipos.y;
        subgrids = new grid[9];

        subdivided = false;
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

                subdivided = true;
            }else{
                for (int i = 0; i < 9; i++){
                    subgrids[i].subdivide(1);
                }
            }
            iters--;
        }
    }

    void drawme(){
        pushMatrix();
        pushStyle();

        noFill();
        stroke(0);
        strokeWeight(width/500);
        translate(center.x,center.y);
        rect(0,0, size,size);

        popMatrix();
        popStyle();

        if (subdivided)
        {
            drawSubgrids();
        }

    }

    void drawSubgrids(){
        for (int i = 0; i < 9; i++){
            subgrids[i].drawme();
        }
    }

    grid getMouseCollided(){
        PVector mouse = new PVector(mouseX,mouseY);

        if (!subdivided){
            return this;
        }

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
}
