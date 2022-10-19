class UserFollower{
  //pass
  PVector pos;                    //Same as user, NOT relative
  PVector vel  = new PVector();
  boolean left = false;           //Where user is last ran, to determine the corner in which the follower should rest at after inactivity
  boolean above= false;           //
  
  UserFollower(PVector initialPos){
    pos = initialPos;
  }
  
  void updateWaypointPos()
  {
    //            X                   ^
    //      <-                        |
    //            X (or)           X     X (or)
    //      left = true            above=true
    
    //(1)Determine correct values (Ignore if stationary)
    if(user.vel.x<0){
    left=true;}
    if(user.vel.y<0){
    above=true;}
    if(user.vel.x>0){
    left=false;}
    if(user.vel.y>0){
    above=false;}
    if(userMoving == true){
    followerUstatTravel = false;}
    
    //(2)Calculate coresponding position for follower
    //EITHER; which corner to sit in
    //        OR travel to description request / stat panel location ('v')
    if(followerUstatTravel == false)      //0//Travel around user
    {
      if(left == true)        //1//Left
      {
        followerWaypointU.x = user.pos.x + wallWidth/2;
        if(above == true)        //2//Left and Up
        {
          followerWaypointU.y = user.pos.y + wallHeight/2;
        }
        else                     //2//Left and Down
        {
          followerWaypointU.y = user.pos.y - wallHeight/2;
        }
      }
      else                    //1//Right
      {
        followerWaypointU.x = user.pos.x - wallWidth/2;
        if(above == true)        //2//Right and Up
        {
          followerWaypointU.y = user.pos.y + wallHeight/2;
        }
        else                     //2//Right and Down
        {
          followerWaypointU.y = user.pos.y - wallHeight/2;
        }
      }
    }
    //0//Travel to stat panel
 
    if(pow(pos.x-followerWaypointU.x, 2) + pow(pos.y-followerWaypointU.y, 2) < followerRestTolerance)  //Prevent glitching at location
    {
      followerWaypointU.x = pos.x;    //##MAYBE CAN COMBINE PVECTOR INTO JUST ... = pos ??##//
      followerWaypointU.y = pos.y;
    }
    
  }
  void updatePos()
  {
    pos.x += vel.x;
    pos.y += vel.y;
  }
  void updateVel()
  {
    //##MAY NOT SCALE WELL, JUST CHANGE TO v=s/t, AND GIVE A SET TIME PERIOD FOR DISTANCE
    if( (pos.x == followerWaypointU.x) && (pos.y == followerWaypointU.y) )    //##BECAUSE 'unitDirVector' BUGS OUT WHEN VALUES ARE THE SAME (BECOME INFINITY)##//
    {
      vel.x = 0;
      vel.y = 0;
    }
    else
    {
      unitVec = unitDirVector(pos, followerWaypointU);
      vel.x = unitVec.x * followerSpeed;
      vel.y = unitVec.y * followerSpeed;
    }
  }
  void drawFollower()
  {
    pushStyle();
    imageMode(CENTER);
    
    //##WILL NOT TO CHECK WHAT WAY FOLLOWER SHOULD BE FACING BASED OFF OF WHERE USER JUST MOVED (TO DRAW BACKS, FRONTS, LEFTS AND RIGHTS)##//
    if(left == true)
    {
      image(userFollower1Left , pos.x, pos.y);
    }
    else{
      image(userFollower1Right, pos.x, pos.y);
    }
    
    popStyle();
  }
  void pathTravel(ArrayList<Integer> route){
    if( routeTravelNum == route.size() )  //Makes the follower loop the path
    {
        routeTravelNum = 0;
    }

    relativeObjPos = findRelativeCoordinates( route.get(routeTravelNum) );
    followerWaypointU.x = relativeObjPos.x;
    followerWaypointU.y = relativeObjPos.y;

    if( pow(relativeObjPos.x - pos.x ,2) + pow(relativeObjPos.y - pos.y ,2) < pow(20 ,2) )  //If within range of next tile...
    {
        routeTravelNum++;
    }
  }
  
}
