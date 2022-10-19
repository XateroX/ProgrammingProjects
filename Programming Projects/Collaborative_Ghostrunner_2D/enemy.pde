
class enemy{
    PVector acc     = new PVector(0,0);
    PVector vel     = new PVector(0,0);
    PVector pos;
    PVector dirVec      = new PVector(0,-1);    //Is a unit vector
    PVector perpDirVec  = new PVector(1,0);     //"" ""

    PVector col;

    boolean isAlive     = true;
    boolean isShot      = false;
    boolean colliding;
    int bulletShotTimer        = 0;
    int bulletShotTimerDefault = 60;

    float r;
    float speed         = 10;   //Initial speed of player
    float weaponSize    = 20;   //Length of the weapon (gun usually)
    float bulletSpeed   = 10;

    int state = 0;  //AI state, to determine its behaviour; 0= aggressive, 1= defensive

    enemy(PVector initialPosition, float radius, PVector colour){
        pos     = initialPosition;
        r       = radius;
        col     = colour;
    }

    void drawMe(){
        //Draws the player at its position
        //(1)Draws player
        //(2)Draws player weapon

        //(1)
        pushStyle();
        fill(col.x, col.y, col.z);
        ellipse(pos.x, pos.y, r, r);
        popStyle();

        //(2)
        pushStyle();
        fill(0, 0, 0);
        strokeWeight(3);
        line(pos.x +(perpDirVec.x*r), pos.y +(perpDirVec.y*r),  pos.x +(perpDirVec.x*r) +(dirVec.x*weaponSize), pos.y +(perpDirVec.y*r) +(dirVec.y*weaponSize));
        popStyle();
    }
    void update(){
        //Updates player values, such as positions, velocities, accelerations, etc
        updateAcc();
        updateVel();
        updatePos();
        updateAlive();
        updateDirection();

        //println(bulletShotTimer);
        if (dist(player.pos.x,player.pos.y,pos.x,pos.y) < 500  &&  bulletShotTimer==0)
        {
            fireBullet();
        }
        if (bulletShotTimer>0) {bulletShotTimer--;}
    }
    void updateAcc(){
        //## Condition needed ##
        acc.x = 0;
        acc.y = 0;
    }
    void updateVel(){
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


        //(2)
        isShot = updateBulletCollision();
        if( isShot )
        {
            isAlive = false;
        }

    }
    void fireBullet(){
        //Fires a pullet in front of it
        dirVec = new PVector((player.pos.x+player.vel.x*40)-pos.x,(player.pos.y+player.vel.y*40)-pos.y);
        dirVec.normalize();
        bullet newBullet = new bullet( new PVector(pos.x +(dirVec.x*r), pos.y +(dirVec.y*r)), new PVector(dirVec.x*bulletSpeed, dirVec.y*bulletSpeed) );
        bullets.add( newBullet );

        bulletShotTimer = bulletShotTimerDefault;
    }
    void AI(){
        //Decides which state to put the enemy AI in
        if(true)
        {
            state = 0;
        }
        //...
    }
    void updateDirection(){
        //Updates the direction the enemy will face
        //(1)Aggressive -> towards player
        //(2)Defensive  -> away from player

        //(1)
        if(state == 0)
        {
            //TURN UNTIL FACING PLAYER
        }

        //(2)
        if(state == 1)
        {
            //pass
        }
    }
}
