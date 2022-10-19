class player{
    PVector acc         = new PVector(0,0);
    PVector vel         = new PVector(0,0);
    PVector pos;
    PVector dirVec      = new PVector(0,-1);    //Is a unit vector
    PVector perpDirVec  = new PVector(1,0);     //"" ""
    PVector col;


    PVector wallPiecePos    = new PVector(0,0);     //The positoin of the wall piece being looked at
    PVector cWall           = new PVector(0,0);     //The wall number, and piece number of the wall you are travelling on
    int tInd;
    int pInd;
    boolean wallForwardDir  = false;                //Whether to travel in the forward or reverse direction of the wall (+-1)


    boolean isAlive         = true;
    boolean isDashing       = false;
    boolean isWallRunning   = false;
    boolean wallRunningOnCD = false;
    boolean inPit           = false;
    boolean isShot          = false;
    boolean colliding;


    boolean wIsPressed      = false;
    boolean aIsPressed      = false;
    boolean sIsPressed      = false;
    boolean dIsPressed      = false;
    boolean spaceIsPressed  = false;


    int currentWall;


    float r;
    float tarGroundSpeed = 4;
    float speed          = 4;//Initial speed of player
    float wallSpeed      = tarGroundSpeed * 0.5;  //Speed when wallRunning
    float tarWallSpeed   = tarGroundSpeed * 2;
    float turnSpeed      = 0.08;         //The angle at which the player turns every frame when left/right is held
    float weaponSize     = 30;           //Length of the sword
    float wallColRad     = 20;           //The distance from a wall piece before the user runs along the wall


    player(PVector initialPosition, float radius, PVector colour){
        pos     = initialPosition;
        r       = radius;
        col     = colour;
    }



    void drawMe(){
        //Draws the player at its position
        //(1)Draws player
        //(2)Draws player weapon


        //println(pos);
        //(1)
        pushStyle();
        fill(col.x, col.y, col.z);
        ellipse(pos.x, pos.y, r, r);
        popStyle();



        //(2)
        pushStyle();
        fill(0, 0, 0);
        strokeWeight(2);
        line(pos.x +(perpDirVec.x*r), pos.y +(perpDirVec.y*r),  pos.x +(perpDirVec.x*r) +(dirVec.x*weaponSize), pos.y +(perpDirVec.y*r) +(dirVec.y*weaponSize));
        popStyle();
    }
    void update(){
        //Updates player values, such as positions, velocities, accelerations, etc
        calcTurnDir();
        checkBlink();
        updateAcc();
        updateVel();
        updatePos();
        updateAlive();
        updateWallRunning();
    }
    void calcTurnDir(){
        //Determines how to turn
        println("--A-- ",aIsPressed);
        if(aIsPressed)    //If left
        {
            turnDir(-turnSpeed);
        }
        if(dIsPressed)    //If right
        {
            turnDir(turnSpeed);
        }
    }
    void turnDir(float theta){
        //Turns the direction of the entity
        dirVec.rotate(theta);
        perpDirVec.rotate(theta);
    }
    void updateAcc(){
        //## Condition needed ##
        acc.x = 0;
        acc.y = 0;
    }
    void updateVel(){
        //Acting to slow the player to normal speed
        if (!isWallRunning && (speed - tarGroundSpeed > 0))
        {
          speed *= 0.99;
        }
      
        //Running+
        vel.x = dirVec.x *speed;
        vel.y = dirVec.y *speed;

        //Wall-Running+
        if (isWallRunning && pInd > map.get(tInd).pieces.size()-2)
        {
            isWallRunning = false;
            wallRunningOnCD = true;
        }
        if(isWallRunning && !wallRunningOnCD)
        {
                // James' Solution //
            // PVector unitVec = new PVector(0,0);
            // unitVec.x = map.get( int(cWall.x) ).pieces.get( int(cWall.y) ).x;
            // unitVec.y = map.get( int(cWall.x) ).pieces.get( int(cWall.y) ).y;

            // unitVec.normalize();
            // dirVec.x = -unitVec.x;
            // dirVec.y = -unitVec.y;


            // vel.x = unitVec.x * wallSpeed;
            // vel.y = unitVec.y * wallSpeed;




                // Dan's Solution //
            PVector unitVec = new PVector(0,0);
            if (pInd != 0)
            {
                unitVec.x = map.get( tInd ).pieces.get( pInd+1 ).x - map.get( tInd ).pieces.get( pInd ).x;
                unitVec.y = map.get( tInd ).pieces.get( pInd+1 ).y - map.get( tInd ).pieces.get( pInd ).y;
            }

            unitVec.setMag(speed);
            speed = lerp(speed,tarWallSpeed,0.1);
            dirVec.x = unitVec.x;
            dirVec.y = unitVec.y;
            dirVec.normalize();

            vel.x = unitVec.x;
            vel.y = unitVec.y;


            PVector nextPiecePos = new PVector(0,0);
            for(int q=0; q<pInd+2; q++)  //For all pieces in walls...
            {
                nextPiecePos.x = map.get(tInd).pieces.get(q).x;
                nextPiecePos.y = map.get(tInd).pieces.get(q).y;
            }
            if (dist(nextPiecePos.x,nextPiecePos.y,pos.x,pos.y) < 10)
            {
                pInd+=1;
            }
            
        }


        //Acceleration+
        vel.x += acc.x;
        vel.y += acc.y;
    }
    void updatePos(){
        pos.x += vel.x;
        pos.y += vel.y;
    }
    boolean updatePitCollision(){
        //Checks whether the player is colliding with a pit
        colliding = false;
        for(int i=0; i<pits.size(); i++)   //For all pits...
        {
            //if colliding with a pit
            if( (( (pits.get(i).center.x -((pits.get(i).w)/2.0)) <= pos.x  )&&( pos.x <= (pits.get(i).center.x +((pits.get(i).w)/2.0)) )) && (( (pits.get(i).center.y -((pits.get(i).h)/2.0)) <= pos.y  )&&( pos.y <= (pits.get(i).center.y +((pits.get(i).h)/2.0)) )) )
            {
                colliding = true;
            }
        }



        if(colliding == true)
        {
            return true;
        }
        else
        {
            return false;
        }



    }
    boolean updateBulletCollision(){
        //Checks whether the player is colliding with a bullet
        colliding = false;
        for(int i=0; i<bullets.size(); i++)   //For all pits...
        {
            //if colliding with a pit
            if( pow( ( pos.x - bullets.get(i).pos.x ), 2) + pow( ( pos.y - bullets.get(i).pos.y ), 2) <= pow( (r), 2) )
            {
                colliding = true;
            }
        }



        if(colliding == true)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    void updateAlive(){
        //Checks whether the player should be alive
        //(1)Are they not on ground AND not dashing
        //(2)Are they colliding with a bullet



        //(1)
        inPit = updatePitCollision();
        if( inPit )                 //If not on ground
        {
            if( !isDashing )        //If not dashing
            {
                isAlive = false;
            }
        }



        //(2)
        isShot = updateBulletCollision();
        if( isShot )
        {
            isAlive = false;
        }



    }
    void checkBlink(){
        //Blinks the user when space is pressed
        if(spaceIsPressed)
        {
            pos.x += (mouseX - pos.x)/10;
            pos.y += (mouseY - pos.y)/10;
        }
    }
    void updateWallRunning(){

            // James' Solution //

        // //Determines whether the player is wall running
        // isWallRunning = false;
        // for(int p=0; p<map.size(); p++)             //For all walls...
        // {
        //     wallPiecePos.x = 0;
        //     wallPiecePos.y = 0;
        //     for(int q=0; q<map.get(p).pieces.size(); q++)  //For all pieces in walls...
        //     {


        //         wallPiecePos.x += map.get(p).pieces.get(q).x;
        //         wallPiecePos.y += map.get(p).pieces.get(q).y;
        //         if( pow( (pos.x - wallPiecePos.x), 2) + pow( (pos.y - wallPiecePos.y), 2) < pow( (wallColRad), 2) )
        //         //if( dist(pos.x,pos.y, wallPiecePos.x,wallPiecePos.y) < pow( (wallColRad), 2) )    //if within range...
        //         {
        //             pos.x   = wallPiecePos.x;
        //             pos.y   = wallPiecePos.y;
        //             cWall.x = p;
        //             cWall.y = q;
        //             isWallRunning = true;


        //             wallForwardDir = false;
        //             break;
        //         }


        //     }
        // }

        // if (isWallRunning)
        // {
        //     if( (map.get( int(cWall.x) ).pieces.size()-1 == int(cWall.y) ))
        //     {
        //         pos.x += -map.get( int(cWall.x) ).pieces.get(int(cWall.y)).x*10;
        //         pos.y += -map.get( int(cWall.x) ).pieces.get(int(cWall.y)).y*10;
        //     }else if (cWall.y == 0){
        //         pos.x += -map.get( int(cWall.x) ).pieces.get(1).x*10;
        //         pos.y += -map.get( int(cWall.x) ).pieces.get(1).y*4;
        //     }
        // }

        println(!wallRunningOnCD);
            // Dan's Solution //
        if (!isWallRunning && !wallRunningOnCD)
        {
            debuggerpoint1 = true;
            for(int p=0; p<map.size(); p++)             //For all walls...
            {
                wallPiecePos.x = 0;
                wallPiecePos.y = 0;
                for(int q=0; q<map.get(p).pieces.size(); q++)  //For all pieces in walls...
                {


                    wallPiecePos.x = map.get(p).pieces.get(q).x;
                    wallPiecePos.y = map.get(p).pieces.get(q).y;
                    if( pow( (pos.x - wallPiecePos.x), 2) + pow( (pos.y - wallPiecePos.y), 2) < pow( (wallColRad), 2) )
                    //if( dist(pos.x,pos.y, wallPiecePos.x,wallPiecePos.y) < pow( (wallColRad), 2) )    //if within range...
                    {
                        pos.x   = wallPiecePos.x;
                        pos.y   = wallPiecePos.y;
                        tInd = p;
                        pInd = q;
                        isWallRunning = true;

                        wallForwardDir = true;
                        break;
                    }


                }
            }
        }else if (wallRunningOnCD)
        {
          wallRunningOnCD = false;
          for(int p=0; p<map.size(); p++)             //For all walls...
            {
                wallPiecePos.x = 0;
                wallPiecePos.y = 0;
                for(int q=0; q<map.get(p).pieces.size(); q++)  //For all pieces in walls...
                {


                    wallPiecePos.x = map.get(p).pieces.get(q).x;
                    wallPiecePos.y = map.get(p).pieces.get(q).y;
                    
                    if( pow( (pos.x - wallPiecePos.x), 2) + pow( (pos.y - wallPiecePos.y), 2) < 2*pow( (wallColRad), 2) )
                    //if( dist(pos.x,pos.y, wallPiecePos.x,wallPiecePos.y) < pow( (wallColRad), 2) )    //if within range...
                    {
                        wallRunningOnCD = true;
                        break;
                    }
                }
            }
        }
    }
    
}
