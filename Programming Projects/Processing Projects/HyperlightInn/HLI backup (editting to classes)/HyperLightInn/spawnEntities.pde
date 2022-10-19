void spawnOrc(PVector pos, int num){
  for (int i=0; i<num; i++)
  {
    //**Position, naturalSpeed**//
    Orc newOrc = new Orc( new PVector( rand(pos.x,2*wallWidth), rand(pos.y,2*wallHeight) ),   rand(2,1), 1 );
    entityList.get(0).add( newOrc );
  }
}

void spawnSludgeMonster(PVector pos, int num){
  for (int i=0; i<num; i++)
  {
    //**Position, naturalSpeed**//
    sludgeMonster newSludgeMonster = new sludgeMonster( new PVector( rand(pos.x,2*wallWidth), rand(pos.y,boardWidth/2) ),   rand(2,1), 3 );
    entityList.get(1).add( newSludgeMonster );
  }
}

void spawn_N_every_X(int entityNum, int spawnNum, int spawnTime, PVector pos){
  //entityNum = which entity to spawn
  //spawnNum  = number of entities to spawn
  //spawnTime = time between spawning (in seconds)
  //pos       = position entities are spawned at

  if(entityNum == 0){ //Orc
    if( (frameCount % (60*spawnTime) == 0) && (innStatus == true) ){
      spawnOrc(pos, spawnNum);
      eventsShort.add      (0,"Orc spawned");
      eventsDescription.add(0,"An Orc shipment has arrived from the western docking zone, they bring many foreign gifts available for purchase or trade at the docking port outpost");
      smallEventSound.play();
    }
  }
  if(entityNum == 1){ //SludgeMonster
    if( (frameCount % (60*spawnTime) == 0) && (innStatus == true) ){
      spawnSludgeMonster(pos, spawnNum);
      eventsShort.add      (0,"Sludge spawned");
      eventsDescription.add(0,"A sludge monster has arrived. He appears to have reserved a seat in the inn's garden, and will cause chaos if denied entry");
      largeEventSound.play();
    }
  }
  //if(entityNum == 2){
  //  ...
  //}
}


//#######################################################//     ##                                                                   ##
//## NOT WORKING, NEED A GOOD SYSTEM TO DETERMINE WHEN ##// --> ## Also, maybe change to just 'despawnEntities' instead of just orcs ##
//#######################################################//     ##                                                                   ##
void deSpawnOrcs(){
  for (int i=entityList.get(0).size() -1; i>=0; i--)
  {
    DespawnCond1 = (entityList.get(0).get(i).pos.x > width) || (entityList.get(0).get(i).pos.x < 0);
    DespawnCond2 = (entityList.get(0).get(i).pos.y > height) || (entityList.get(0).get(i).pos.x < 0);
    if ( DespawnCond1 || DespawnCond2 )
    {
      entityList.get(0).remove( i );  //## MAY NOT BE CORRECT, CHANGED IT AND PROBABLY SCUFFED IT ##//
    }
  }
}
