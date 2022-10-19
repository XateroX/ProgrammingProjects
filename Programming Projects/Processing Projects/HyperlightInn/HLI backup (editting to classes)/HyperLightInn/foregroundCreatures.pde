void drawForegroundCreatures(){
  //ALL entities
  for (int j=0; j<entityList.size(); j++)
  {

    for (int i=0; i<entityList.get(j).size(); i++)
    {
      entity currentEntity = entityList.get(j).get(i);

      currentEntity.colliding();
      currentEntity.updateAcc(); //## DOESNT REALLY DO ANYTHING ATM, THERE JUST IN CASE ##//
      currentEntity.updateVel();
      currentEntity.updatePos();
      currentEntity.calcBehaviour();
      //currentEntity.calcPathing();  //## SHOULD BE CALLED IN BEHAVIOUR, SO SHOULD BE IRRELEVENT HERE ##//
      if( j==0 )  //Orc specifics
      {
        ( (Orc)currentEntity ).display();
        //... Other entity specific functions here
      }
      if( j==1 )  //SludgeMonster specifics
      {
        ( (sludgeMonster)currentEntity ).display();
        //... Other entity specific functions here
      }
      if( j==2 )  //...
      {
        //...
      }

    }

  }
  
  //User
  user.colliding();
  user.updatePos();
  user.drawUser();
  
  //User follower
  followerU.updateWaypointPos();
  followerU.updateVel();
  followerU.updatePos();
  followerU.drawFollower();
  
  //Enitity followers
  //...
  
  //...
}
