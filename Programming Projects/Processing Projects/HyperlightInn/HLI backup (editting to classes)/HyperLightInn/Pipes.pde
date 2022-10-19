class Pipe{  
  int tileNum;        //Tile which pipe is situated over
  int lastDir;        //The direction the last pipe took to get to the current pipe, the opposite direction is then ignored in connections (e.g, lastDir=7, =>ignore 1s in connections)
  int ignoreDir;      //Opposite pipe direction to last dir, should be ignored in connections
  int fluidType ;     //Type of fluid within the pipe, e.g water, beer, etc
  //##CAN EASILY BE FOUND USING TILE PIPEIND-->SHOULD REMOVE##//
  int pipeNetworkNum; //Which network this pipe is within (in the 'pipeNetwork' ArrayList)
  int pipeFunction;   //States whether it is an input, output or connecting pipe; 1=output, 2=input, 3=connecting
 
  ArrayList<Integer> connections = new ArrayList<Integer>();  //Which directions this pipe has connections to other pipes
  
  float fluidIn   ;//Fluid (Quantity) into the given pipe
  float fluidOut  ;//Fluid (Quantity)leaving the given pipe
  
  PVector pos;    //Posion of pipe, is equivalent to the relative
  
  Pipe(PVector position, int tileNumber, int pipeNetworkIndexNumber, int pipeFunctionIO)
  {
    tileNum = tileNumber;
    pos     = position;
    pipeNetworkNum = pipeNetworkIndexNumber;
    pipeFunction = pipeFunctionIO;
  }
  void drawPipe(){
    borderIndicesFinal = findPipeBorderPipeFunctions(tileNum);
    relativeObjPos = findRelativeCoordinates(tileNum);
    pushStyle();
    pushMatrix();
    imageMode(CENTER);
    
    if(pipeFunction == 1){
    fill(180,120,30);}
    if(pipeFunction == 2){
    fill(50,100,150);}
    if(pipeFunction == 3){
    fill(120,120,120);}
    
    //    0
    //  1   2
    //    3
    // >0 = any pipe is here
    
    translate(relativeObjPos.x, relativeObjPos.y);
    
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate(0);
      ellipse(0,0,20,20);  //#####//
      image (pipeOpenClosed, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate((1.5)*(PI));
      ellipse(0,0,20,20);  //#####//
      image (pipeOpenClosed, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate((0.5)*(PI));
      ellipse(0,0,20,20);  //#####//
      image (pipeOpenClosed, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate(PI);
      ellipse(0,0,20,20);  //#####//
      image (pipeOpenClosed, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate(0);
      image (pipeCorner, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate((0.5)*(PI));
      image (pipeCorner, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate((1.5)*PI);
      image (pipeCorner, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate(PI);
      image (pipeCorner, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate(0);
      image (pipeOpenOpen, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate((0.5)*(PI));
      image (pipeOpenOpen, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate(0);
      image (pipeThreeJunction, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate((1.5)*(PI));
      image (pipeThreeJunction, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate((0.5)*(PI));
      image (pipeThreeJunction, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate(PI);
      image (pipeThreeJunction, 0,0);}
    if( ((borderIndicesFinal.get(0) > 0)&&(borderIndicesFinal.get(1) > 0)) && ((borderIndicesFinal.get(2) > 0)&&(borderIndicesFinal.get(3) > 0)) ){
      rotate(0);
      image (pipeFourJunction, 0,0);}
    if( ((borderIndicesFinal.get(0) < 0)&&(borderIndicesFinal.get(1) < 0)) && ((borderIndicesFinal.get(2) < 0)&&(borderIndicesFinal.get(3) < 0)) ){
      rotate(0);
      ellipse(0,0,20,20);  //#####//
      image (pipeAlone, 0,0);}
    
    popMatrix();
    popStyle();
  }
}

void increasePipeNetwork(int tileNum, int pipeUse){
  //tileNum = Tile index where pipe is to be added to
  
  //Find out what network a pipe belongs to
  //=> Either;
  //(1)Add to the network of adjacent pipes (CHOOSE WHETHER TO KEEP SEPARATE OR COMBINE)
  //(2)Create a new network if it isnt connected to other pipes of a network
  //(3)Merge two networks if pipe connects them (AND CHOSEN TO COMBINE AND NOT KEEP SEPARATE)
  if(Tiles.get(tileNum).pipeInd.x > -1)  //If there is a pipe already here
  {
    //From pipe after one being removed, to end of that network
    for(int i=int(Tiles.get(tileNum).pipeInd.y)+1; i<pipeNetwork.get( int(Tiles.get(tileNum).pipeInd.x) ).size(); i++ )
    {
      Tiles.get( pipeNetwork.get(int(Tiles.get(tileNum).pipeInd.x)).get(i).tileNum ).pipeInd.y -= 1;
    }
    pipeNetwork.get( int(Tiles.get(tileNum).pipeInd.x) ).remove( int(Tiles.get(tileNum).pipeInd.y) );
    Tiles.get(tileNum).pipeInd.x = -1;
    Tiles.get(tileNum).pipeInd.y = -1;
  }
  borderIndicesFinal.clear();
  borderIndicesFinal = findPipeBorderNetworks(tileNum);
  adjacentPipe        = -1;
  adjacentPipeChanges = -1;
  for(int i=0; i<borderIndicesFinal.size(); i++)       //Check that surrounding 3x3 (just the plus sign shape however, as they are the only tiles directly adjacent)
  {
    if( borderIndicesFinal.get(i) > -1 )               //If any are pipes, Make it so this pipe will become that pipe network type
    {
      if( borderIndicesFinal.get(i) != adjacentPipe )  //If the network seen is new, increment (to keep track of the number of different networks involved)
      {
        adjacentPipeChanges++;
      }
      adjacentPipe = borderIndicesFinal.get(i);
    }
  }
  //##BE GIVEN A PROMPT AS TO WHICH NETWORK IT WANTS TO JOIN FOR THESE AS WELL, IN CASE THEY WANT TO BUILD TWO NETWORKS ADJACENT TO EACH OTHER##
  //println("borderIndicesFinal; ",borderIndicesFinal);        //*****//
  //println("adjacentPipe; ",adjacentPipe);                    //*****//
  //println("adjacentPipeChanges; ",adjacentPipeChanges);      //*****//
  if(adjacentPipeChanges == -1)    //No pipes nearby => create new network
  {
    Pipe newPipe = new Pipe( Tiles.get(tileNum).pos ,tileNum, pipeNetwork.size(), pipeUse );
    pipeNetwork.add(new ArrayList<Pipe>());
    pipeNetwork.get( pipeNetwork.size()-1 ).add( newPipe );
    Tiles.get(tileNum).pipeInd.x =  pipeNetwork.size()-1;
    Tiles.get(tileNum).pipeInd.y =( pipeNetwork.get( pipeNetwork.size()-1 ).size() )-1;
  }
  if(adjacentPipeChanges ==  0)    //One pipe network nearby => add to that network
  {
    Pipe newPipe = new Pipe( Tiles.get(tileNum).pos ,tileNum, adjacentPipe, pipeUse );
    pipeNetwork.get( adjacentPipe ).add( newPipe );
    Tiles.get(tileNum).pipeInd.x =  adjacentPipe;
    Tiles.get(tileNum).pipeInd.y =( pipeNetwork.get( adjacentPipe ).size() )-1;
  }
  if(adjacentPipeChanges >   0)    //Multiple pipe networks nearby =>##BE GIVEN A PROMPT AS TO WHICH NETWORK IT WANTS TO JOIN##
  {
    //##BE GIVEN A PROMPT AS TO WHICH NETWORK IT WANTS TO JOIN##
    //(1)Add the pipe
    Pipe newPipe = new Pipe( Tiles.get(tileNum).pos ,tileNum, adjacentPipe, pipeUse );
    pipeNetwork.get( adjacentPipe ).add( newPipe );
    Tiles.get(tileNum).pipeInd.x =  adjacentPipe;
    Tiles.get(tileNum).pipeInd.y =( pipeNetwork.get( adjacentPipe ).size() )-1;
    
    //(2)Move over network's pipes over to this network
    for(int i=0; i<borderIndicesFinal.size(); i++)     //Go through each adjacent tile...
    {
      if(borderIndicesFinal.get(i) > -1)               //If the tile has a pipe...
      {
        if(borderIndicesFinal.get(i) != adjacentPipe)  //If the pipe is not the target network (target being the last seen before, adjacentPipe)...
        {
          pipeNetworkSize = pipeNetwork.get( borderIndicesFinal.get(i) ).size();
          for(int j=0; j<pipeNetworkSize; j++)    //Go through each pipe in that network and...
          {
            //(1)Change their respective tiles' pipeInds
            //(2)Add to the target network, and remove from old network
            Tiles.get( pipeNetwork.get(borderIndicesFinal.get(i)).get(0).tileNum ).pipeInd.x = adjacentPipe;
            Tiles.get( pipeNetwork.get(borderIndicesFinal.get(i)).get(0).tileNum ).pipeInd.y = pipeNetwork.get(adjacentPipe).size();  //Added to end
            pipeNetwork.get(adjacentPipe).add( pipeNetwork.get( borderIndicesFinal.get(i) ).get(0) );
            pipeNetwork.get( borderIndicesFinal.get(i) ).remove(0);
          }
        }
      }
    }
    
  }
  
}

void clearPipeNetwork(){
  for(int i=0; i<pipeNetwork.size(); i++)               //Go through all networks...
  {
    if(pipeNetwork.get(i).size() == 0)                  //If any empty / unused...
    {
      for(int j=i+1; j<pipeNetwork.size(); j++)         //Go through all networks higher than one being deleted...
      {
        for(int z=0; z<pipeNetwork.get(j).size(); z++)  //Go through all pipes for each given network...
        {
          Tiles.get( pipeNetwork.get(j).get(z).tileNum ).pipeInd.x -= 1;  //And lower each of their network numbers by 1
        }
      }
      pipeNetwork.remove(i);
    }
  }
}

void calcPipes(){
  //(1)Remove unnecessary networks
  clearPipeNetwork();
  
  //(2)Draw pipes in all networks
  for(int i=0; i<pipeNetwork.size(); i++)             //Go through each pipe
  {                                                   //
    for(int j=0; j<pipeNetwork.get(i).size(); j++)    //
    {
      pipeNetwork.get(i).get(j).drawPipe();           //Draw each pipes
    }
  }
}

//##IF REMOVING SPLITS PIPE INTO TWO SEPARATE PIECES, THEY WILL NOT FORM INTO NEW NETWORKS##//
void removePipeNetwork(int tileNum){
  if(Tiles.get(tileNum).pipeInd.x > -1)  //If there is a pipe already here
  {
    //From pipe after one being removed, to end of that network
    for(int i=int(Tiles.get(tileNum).pipeInd.y)+1; i<pipeNetwork.get( int(Tiles.get(tileNum).pipeInd.x) ).size(); i++ )
    {
      Tiles.get( pipeNetwork.get(int(Tiles.get(tileNum).pipeInd.x)).get(i).tileNum ).pipeInd.y -= 1;
    }
    pipeNetwork.get( int(Tiles.get(tileNum).pipeInd.x) ).remove( int(Tiles.get(tileNum).pipeInd.y) );
    Tiles.get(tileNum).pipeInd.x = -1;
    Tiles.get(tileNum).pipeInd.y = -1;
  }
}


//############################################################//
//##MAKE WORK FOR PUMPS, VAT AND MACHINERY-> ON OUTPUT PIPES##//  
//############################################################//
void calcPipeStarts(){
  //(0)Repeat process for all networks
  //(1)Find output pipe to start fluid flow ##WONT WORK FOR MULTIPLE OUTPUT SYSTEMS YET##
  //(2)Find its fluidIn and fluidType (from pump) ##FOR NOW JUST USE ASSUMED VALUES FOR FLOW AND ASSUME ALWAYS WATER->PUMP WILL NEED STATS STORED##
  outputPipesTemp.clear();
  for(int i=0; i<pipeNetwork.size(); i++)               //Go through all networks...
  {
    //(1)Find output pipe
    startPipeFound = false;
    for(int j=0; j<pipeNetwork.get(i).size(); j++)      //Go through all pipes in given network...
    {
      if(pipeNetwork.get(i).get(j).pipeFunction == 1){  //If is an output...
        startPipe = pipeNetwork.get(i).get(j);
        outputPipesTemp.add(startPipe);
        startPipeFound = true;
        continue;                                       //##OR BREAK, WANT TO STOP 2nd FOR BUT NOT 1st ???##
      }
    }
    if(startPipeFound == false)
    {
      //Pipe(PVector position, int tileNumber, int pipeNetworkIndexNumber, int pipeFunctionIO
      startPipe = new Pipe(new PVector(-1,-1), -1, -1, 1);  //To indicate that it is a dummy pipe          
      outputPipesTemp.add(startPipe);
    }
    if(startPipeFound == true)                          //If there is an output pipe to cause a flow...
    {
      //(2)Find fluidIn value and fluidType
      //Look for pump/vat/machinery around output pipe
      borderIndicesFinal.clear();
      borderIndicesFinal = findBorderTilesInd( startPipe.tileNum );
      nearFluidSource = false;
      for(int j=0; j<borderIndicesFinal.size(); j++)
      {
        if( borderIndicesFinal.get(j) == 11 )  //If pump present
        {
          if(j==0){                   //j is ignoreDir, we need lastDir
          startPipe.lastDir=7;}
          if(j==1){
          startPipe.lastDir=5;}
          if(j==2){
          startPipe.lastDir=3;}
          if(j==3){
          startPipe.lastDir=1;}
          nearFluidSource = true;
          //println(startPipe.lastDir);          //*****//
        }
        if( borderIndicesFinal.get(j) == 12 )  //If vat present
        {
          if(j==0){                   //j is ignoreDir, we need lastDir
            startPipe.lastDir=7;
            if( vatList.get( ((Vat)Tiles.get( startPipe.tileNum -colNum )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==1){
            startPipe.lastDir=5;
            if( vatList.get( ((Vat)Tiles.get( startPipe.tileNum -1 )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==2){
            startPipe.lastDir=3;
            if( vatList.get( ((Vat)Tiles.get( startPipe.tileNum +1 )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==3){
            startPipe.lastDir=1;
            if( vatList.get( ((Vat)Tiles.get( startPipe.tileNum +colNum )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
        }
        if( borderIndicesFinal.get(j) == 13 )  //If machinery present
        {
          if(j==0){                   //j is ignoreDir, we need lastDir
            startPipe.lastDir=7;
            if( machineryList.get( ((Machinery)Tiles.get( startPipe.tileNum -colNum )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==1){
            startPipe.lastDir=5;
            if( machineryList.get( ((Machinery)Tiles.get( startPipe.tileNum -1 )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==2){
            startPipe.lastDir=3;
            if( machineryList.get( ((Machinery)Tiles.get( startPipe.tileNum +1 )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
          if(j==3){
            startPipe.lastDir=1;
            if( machineryList.get( ((Machinery)Tiles.get( startPipe.tileNum +colNum )).inputterInd ).fluidIn >0 ){  //If this inputter has fluid in it
            nearFluidSource = true;}
          }
        }
      }
      if(nearFluidSource==true){
        startPipe.fluidIn   = 1.5;   //##DEFAULT VALUES, NEED TO BE CHANGED TO SPECIFICS TO DO WITH PIPE##//
        startPipe.fluidType = 1;}    //## "" "" ##//
      else{
        startPipe.fluidIn   = 0;   //##DEFAULT VALUES, NEED TO BE CHANGED TO SPECIFICS TO DO WITH PIPE##//
        startPipe.fluidType = 0;}    //## "" "" ##//
    }
  }
  
}

void calcPipeConnections(int networkNum){  //##CAN MAKE LESS LABOUR INTENSIVE BY ONLY DOING IT FOR GIVEN NETWORKS##//
  //Finds what direction each pipe is connected in within its network
  if(networkNum > -1)  //If the selected tile is a pipe network...
  {
    for(int j=0; j<pipeNetwork.get(networkNum).size(); j++)    //Go through all pipes in given network...
    {
      pipeNetwork.get(networkNum).get(j).connections.clear();  //Clear whats already here, ready for fresh calculation
      borderIndicesFinal = findPipeBorderNetworks( pipeNetwork.get(networkNum).get(j).tileNum );
      //println(borderIndicesFinal);                        //*****//
      for(int z=0; z<borderIndicesFinal.size(); z++)
      {
        if(borderIndicesFinal.get(z) > -1)            //If there is a pipe nearby...
        {
          pipeNetwork.get(networkNum).get(j).connections.add( (2*z)+1 );
        }
      }
    }
  }
}

void calcPipePaths( ArrayList<Pipe> outputPipesTemp, int networkNum ){
  //Give that fluidIn as fluidOut to all connected pipes, by adding connected pipes to a list, which is worked through until empty
  //(0)Choose first item in pipePathTemp
  //(1)Find ignoreDir from lastDir
  //(2)Remove connections that are ignoreDir
  //(3)Add tileNums of left over connections to pipePathTemp (pipes being processed)
  //(4)Repeat for all networks
  pipePathTemp.clear();
  if(networkNum > -1)  //If this is a network be selected...
  {
    
    if(outputPipesTemp.get(networkNum).tileNum > -1)    //If not a dummy pipe...
    {
      //---
      pipePathTemp.clear();
      pipePathTemp.add( outputPipesTemp.get(networkNum) );     //Initially add the output pipe, so it will start from the output
      allPipesProcessed = false;
      while( allPipesProcessed == false )  //Go through all pipes in given network with an output
      {        
        //(0)
        currentPipe = pipePathTemp.get(0);                      //Get next pipe to be processed
        currentPipe.fluidOut = currentPipe.fluidIn;
        pipePathTemp.remove(0);                                 //Remove that pipe (as it has been processed)
        
        //(1)Find direction to ignore
        if(currentPipe.lastDir==1){
        currentPipe.ignoreDir=7;}
        if(currentPipe.lastDir==3){
        currentPipe.ignoreDir=5;}
        if(currentPipe.lastDir==5){
        currentPipe.ignoreDir=3;}
        if(currentPipe.lastDir==7){
        currentPipe.ignoreDir=1;}
        
        //(2)
        connectionsTemp.clear();
        for(int z=0; z<currentPipe.connections.size(); z++)  //Go through all of given pipe's connections...
        {
          if(currentPipe.connections.get(z) != currentPipe.ignoreDir)  //If this connection has NOT been processed...
          {
            connectionsTemp.add( currentPipe.connections.get(z) );     //Then add to list of pipes to be processed
          }
        }
        
        //(3)
        //println("Mousedtile              ; ",findMouseTile());              //***//
        //println("TileOfCurrentPipe       ; ",currentPipe.tileNum);          //***//
        //println("lastDir                 ; ",currentPipe.lastDir);          //*****//
        //println("ignoreDir               ; ",currentPipe.ignoreDir);        //*****//
        //println("connectionsOfcurrentPipe; ",currentPipe.connections);      //*****//
        //println("TempConnections         ; ",connectionsTemp);              //*****//
        for(int z=0; z<connectionsTemp.size(); z++)  //Go through each connectionTemp, add to pipePathTemp
        {
          if( (currentPipe.fluidOut > 0) && (currentPipe.fluidType > 0) )  //##CAN REMOVE IF YOU WANT, SHOULDN'T MAKE A DIFFERENCE, JUST TO ENSURE WATER ISNT WEIRDLY REMOVED##//
          {
            if(connectionsTemp.get(z)==1)  //-colNum
            {
              tileNumTemp = currentPipe.tileNum -colNum;
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidIn   = currentPipe.fluidOut;   //Give fluid to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidType = currentPipe.fluidType;  //Give fluidType to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).lastDir   = connectionsTemp.get(z); //Give lastDir
              pipePathTemp.add( pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ) );                //Add pipe of connection
            }
            if(connectionsTemp.get(z)==3)  //-1
            {
              tileNumTemp = currentPipe.tileNum -1;
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidIn = currentPipe.fluidOut;     //Give fluid to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidType = currentPipe.fluidType;  //Give fluidType to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).lastDir   = connectionsTemp.get(z); //Give lastDir
              pipePathTemp.add( pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ) );                //Add pipe of connection
            }
            if(connectionsTemp.get(z)==5)  //+1
            {
              tileNumTemp = currentPipe.tileNum +1;
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidIn = currentPipe.fluidOut;     //Give fluid to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidType = currentPipe.fluidType;  //Give fluidType to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).lastDir   = connectionsTemp.get(z); //Give lastDir
              pipePathTemp.add( pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ) );                //Add pipe of connection
            }
            if(connectionsTemp.get(z)==7)  //+colNum
            {
              tileNumTemp = currentPipe.tileNum +colNum;
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidIn = currentPipe.fluidOut;     //Give fluid to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).fluidType = currentPipe.fluidType;  //Give fluidType to next pipe
              pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ).lastDir   = connectionsTemp.get(z); //Give lastDir
              pipePathTemp.add( pipeNetwork.get( int(Tiles.get(tileNumTemp).pipeInd.x) ).get( int(Tiles.get(tileNumTemp).pipeInd.y) ) );                //Add pipe of connection
            }
          }
        }
        
        if(pipePathTemp.size() == 0)
        {
          allPipesProcessed = true;
        }
        
      }
      //This will then repeat for connections flagged here, until list is empty
      //---
    }
  }
}

void calcDisplayPipeFluid(){
  if(showPipeFluidFlow == true)
  {
    displayPipeFluid();
    displayVatFluid();
    displayMachineryFluid();
  }
}

void displayPipeFluid(){
  for(int i=0; i<pipeNetwork.size(); i++)  //For all networks...
  {
    for(int j=0; j<pipeNetwork.get(i).size(); j++)     //For all pipes in each network...
    {
      relativeObjPos = findRelativeCoordinates( pipeNetwork.get(i).get(j).tileNum );
      if(pipeNetwork.get(i).get(j).fluidType == 1){    //Water
      fill(158, 230, 232);}
      if(pipeNetwork.get(i).get(j).fluidType == 2){    //Beer
      fill(217, 185, 72);}
      
      pushStyle();
      ellipse(relativeObjPos.x, relativeObjPos.y, 10*pipeNetwork.get(i).get(j).fluidIn, 10*pipeNetwork.get(i).get(j).fluidIn);
      popStyle();
    }
  }
}

//Finds the network numbers of the pipes nearby (if any), in a plus shape in the 3x3
//-1   = no pipes nearby
//>=0  = the network number of the pipe found
ArrayList findPipeBorderNetworks(int n){
  //n   = tile currently on
  borderIndices.clear();
  
  //Search within table
  //Up
  if( Tiles.get(n-colNum).pipeInd.x > -1 ){
  borderIndices.add( int(Tiles.get(n-colNum).pipeInd.x) );}
  else{
  borderIndices.add( -1 );}
  
  //Left
  if( Tiles.get(n-1).pipeInd.x > -1 ){
  borderIndices.add( int(Tiles.get(n-1).pipeInd.x) );}
  else{
  borderIndices.add( -1 );}
  
  //Right
  if( Tiles.get(n+1).pipeInd.x > -1 ){
  borderIndices.add( int(Tiles.get(n+1).pipeInd.x) );}
  else{
  borderIndices.add( -1 );}
  
  //Down
  if( Tiles.get(n+colNum).pipeInd.x > -1 ){
  borderIndices.add( int(Tiles.get(n+colNum).pipeInd.x) );}
  else{
  borderIndices.add( -1 );}
    
  //println(borderIndices);              //*****//
  return ( borderIndices ); //Returns the pipeNetwork value of pipe (if there) in its respective position
}

ArrayList findPipeBorderPipeFunctions(int n){
  //n        = tile currently on
  //pipeFunc = function number you are looking for
  borderIndices.clear();
  
  //Search within table
  //Up
  if( Tiles.get(n-colNum).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n-colNum).pipeInd.x) ).get( int(Tiles.get(n-colNum).pipeInd.y) ).pipeFunction );}
  else{
  borderIndices.add( -1 );}
  
  //Left
  if( Tiles.get(n-1).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n-1).pipeInd.x) ).get( int(Tiles.get(n-1).pipeInd.y) ).pipeFunction );}
  else{
  borderIndices.add( -1 );}
  
  //Right
  if( Tiles.get(n+1).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n+1).pipeInd.x) ).get( int(Tiles.get(n+1).pipeInd.y) ).pipeFunction );}
  else{
  borderIndices.add( -1 );}
  
  //Down
  if( Tiles.get(n+colNum).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n+colNum).pipeInd.x) ).get( int(Tiles.get(n+colNum).pipeInd.y) ).pipeFunction );}
  else{
  borderIndices.add( -1 );}
    
  //println(borderIndices);              //*****//
  return ( borderIndices ); //Returns the pipeNetwork value of pipe (if there) in its respective position
}

ArrayList findPipeBorderFluidTypes(int n){
  //n        = tile currently on
  //pipeFunc = function number you are looking for
  borderIndices.clear();
  
  //Search within table
  //Up
  if( Tiles.get(n-colNum).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n-colNum).pipeInd.x) ).get( int(Tiles.get(n-colNum).pipeInd.y) ).fluidType );}
  else{
  borderIndices.add( -1 );}
  
  //Left
  if( Tiles.get(n-1).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n-1).pipeInd.x) ).get( int(Tiles.get(n-1).pipeInd.y) ).fluidType );}
  else{
  borderIndices.add( -1 );}
  
  //Right
  if( Tiles.get(n+1).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n+1).pipeInd.x) ).get( int(Tiles.get(n+1).pipeInd.y) ).fluidType );}
  else{
  borderIndices.add( -1 );}
  
  //Down
  if( Tiles.get(n+colNum).pipeInd.x > -1 ){
  borderIndices.add( pipeNetwork.get( int(Tiles.get(n+colNum).pipeInd.x) ).get( int(Tiles.get(n+colNum).pipeInd.y) ).fluidType );}
  else{
  borderIndices.add( -1 );}
    
  //println(borderIndices);              //*****//
  return ( borderIndices ); //Returns the pipeNetwork value of pipe (if there) in its respective position
}

//for cross shape, not full 3x3
//##MAKE IT LOOK FOR VATS, PUMPS AND MACHINERY ON OUTPUT##//
ArrayList findBorderTilesInd(int n){
  //n   = tile currently on
  borderIndices.clear();
  
  //Search within table
  //Up
  if( Tiles.get(n-colNum).type > -1 ){
  borderIndices.add( int(Tiles.get(n-colNum).type) );}
  else{
  borderIndices.add( -1 );}
  
  //Left
  if( Tiles.get(n-1).type > -1 ){
  borderIndices.add( int(Tiles.get(n-1).type) );}
  else{
  borderIndices.add( -1 );}
  
  //Right
  if( Tiles.get(n+1).type > -1 ){
  borderIndices.add( int(Tiles.get(n+1).type) );}
  else{
  borderIndices.add( -1 );}
  
  //Down
  if( Tiles.get(n+colNum).type > -1 ){
  borderIndices.add( int(Tiles.get(n+colNum).type) );}
  else{
  borderIndices.add( -1 );}
    
  //println(borderIndices);              //*****//
  return ( borderIndices ); //Returns the pipeNetwork value of pipe (if there) in its respective position
}

int findPipeBorderFluidTypesSize(int n){
  //n        = tile currently on
  //pipeFunc = function number you are looking for
  
  fluidTypeNum =0;
  
  //Search within table
  //Up
  if( pipeNetwork.get( int(Tiles.get(n-colNum).pipeInd.x) ).get( int(Tiles.get(n-colNum).pipeInd.y) ).fluidType > -1 ){
  fluidTypeNum++;}
  
  //Left
  if( pipeNetwork.get( int(Tiles.get(n-1).pipeInd.x) ).get( int(Tiles.get(n-1).pipeInd.y) ).fluidType > -1 ){
  fluidTypeNum++;}
  
  //Right
  if( pipeNetwork.get( int(Tiles.get(n+1).pipeInd.x) ).get( int(Tiles.get(n+1).pipeInd.y) ).fluidType > -1 ){
  fluidTypeNum++;}
  
  //Down
  if( pipeNetwork.get( int(Tiles.get(n+colNum).pipeInd.x) ).get( int(Tiles.get(n+colNum).pipeInd.y) ).fluidType > -1 ){
  fluidTypeNum++;}
  
  return ( fluidTypeNum ); //Returns number of different fluids surrounding tile
}
