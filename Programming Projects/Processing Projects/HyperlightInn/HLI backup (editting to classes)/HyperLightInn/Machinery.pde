//#######################################################################################################################//
//## NEEDS TO BE FIXED, SO IT DOES REQUIRE ANOTHER I/O PIPE TO BE PLACED BEFORE RECALCULATING VALUES FOR FLUID TO MOVE ##//
//#######################################################################################################################//
void calcInputFlows(){
  for(int i=0; i<vatList.size(); i++)               //Go through all vats...
  {
    //(0)Reset fluid values for inputter
    //(1)Look around 3x3 for input pipes
    //(2)If any there, move fluidOut to correct fluidType index in the inputter
    
    //(0)
    vatList.get(i).fluidIn  = 0;
    vatList.get(i).fluidOut = 0;
    //vatList.get(i).fluidWithin.clear();  //##MAYBE NOT NECESSARY##//
    
    //(1)
    tileNumTemp = vatList.get(i).tileNum;
    borderIndicesFinal.clear();
    //borderIndFinalTemp.clear();
    borderIndicesFinal = findPipeBorderPipeFunctions( tileNumTemp );
    //borderIndFinalTemp = findPipeBorderFluidTypes( tileNumTemp );
    //fluidTypeNum       = findPipeBorderFluidTypesSize( tileNumTemp );
    for(int j=0; j<borderIndicesFinal.size(); j++)  //Go through each pipeFunction found...
    {
      if(borderIndicesFinal.get(j) == 2)            //If an input pipe
      {
        //(2)
        if(j==0){  //Up =>-colNum
          //println("fluidOut; ",pipeNetwork.get( int(Tiles.get(tileNumTemp-colNum).pipeInd.x) ).get( int(Tiles.get(tileNumTemp-colNum).pipeInd.y) ).fluidOut);//*****//
          //println("vatNum; ", i);                                                                                                                            //*****//
          vatList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp-colNum).pipeInd.x) ).get( int(Tiles.get(tileNumTemp-colNum).pipeInd.y) ).fluidOut;
        }
        if(j==1){  //Left =>-1
          vatList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp-1).pipeInd.x) ).get( int(Tiles.get(tileNumTemp-1).pipeInd.y) ).fluidOut;
        }
        if(j==2){  //Right =>+1
          vatList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp+1).pipeInd.x) ).get( int(Tiles.get(tileNumTemp+1).pipeInd.y) ).fluidOut;
        }
        if(j==3){  //Down =>+colNum
          vatList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp+colNum).pipeInd.x) ).get( int(Tiles.get(tileNumTemp+colNum).pipeInd.y) ).fluidOut;
        }
      }
    }
  }
  for(int i=0; i<machineryList.size(); i++)         //Go through all machinery...
  {
    //(0)Reset fluid values for inputter
    //(1)Look around 3x3 for input pipes
    //(2)If any there, move fluidOut to correct fluidType in the inputter
    
    //(0)
    machineryList.get(i).fluidIn  = 0;
    machineryList.get(i).fluidOut = 0;
    //machineryList.get(i).fluidWithin.clear();  //##MAYBE NOT NECESSARY##//
    
    //(1)
    tileNumTemp = machineryList.get(i).tileNum;
    borderIndicesFinal.clear();
    //borderIndFinalTemp.clear();
    borderIndicesFinal = findPipeBorderPipeFunctions( tileNumTemp );
    //borderIndFinalTemp = findPipeBorderFluidTypes( tileNumTemp );
    //fluidTypeNum       = findPipeBorderFluidTypesSize( tileNumTemp );
    for(int j=0; j<borderIndicesFinal.size(); j++)  //Go through each pipeFunction found...
    {
      if(borderIndicesFinal.get(j) == 2)            //If an input pipe
      {
        //(2)
        if(j==0){  //Up =>-colNum
          machineryList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp-colNum).pipeInd.x) ).get( int(Tiles.get(tileNumTemp-colNum).pipeInd.y) ).fluidOut;
        }
        if(j==1){  //Left =>-1
          machineryList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp-1).pipeInd.x) ).get( int(Tiles.get(tileNumTemp-1).pipeInd.y) ).fluidOut;
        }
        if(j==2){  //Right =>+1
          machineryList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp+1).pipeInd.x) ).get( int(Tiles.get(tileNumTemp+1).pipeInd.y) ).fluidOut;
        }
        if(j==3){  //Down =>+colNum
          machineryList.get(i).fluidIn += pipeNetwork.get( int(Tiles.get(tileNumTemp+colNum).pipeInd.x) ).get( int(Tiles.get(tileNumTemp+colNum).pipeInd.y) ).fluidOut;
        }
      }
    }
  }
  
}

//#########################################################################//
//## NEEDS TO BE ADDED WHEN PLACING THE PUMP, NOT EVERY TIME IT IS DRAWN ##//
//#########################################################################//
void addPumpToList(PVector pos, int n){
  pumpExistsHere = false;
  for(int i=0; i<pumpList.size(); i++)  //Check all pumps already here
  {
    if( pumpList.get(i).tileNum == n )  //If there is already a pump here
    {
      pumpExistsHere = true;
    }
  }
  if(pumpExistsHere == false)  //If there is not already a pump here
  {
    //NOT an inputter, therefore keeps its inputterInd as -1 (Doesnt recieve inputs, only exports)
    Pump newPump = new Pump(pos, n);
    newPump.fluidIn = 2;
    pumpList.add( newPump );
  }
}

void addVatToList(PVector pos, int n){
  vatExistsHere = false;
  for(int i=0; i<vatList.size(); i++)  //Check all pumps already here
  {
    if( vatList.get(i).tileNum == n )  //If there is already a pump here
    {
      vatExistsHere = true;
    }
  }
  if(vatExistsHere == false)  //If there is not already a pump here
  {
    ((Vat)Tiles.get( n )).inputterInd = vatList.size();  //##WILL BREAK IF A VAT IS REMOVED##//
    Vat newVat = new Vat(pos, n);
    vatList.add( newVat );
  }
}

void addMachineryToList(PVector pos, int n){
  machineryExistsHere = false;
  for(int i=0; i<machineryList.size(); i++)  //Check all pumps already here
  {
    if( machineryList.get(i).tileNum == n )  //If there is already a pump here
    {
      machineryExistsHere = true;
    }
  }
  if(machineryExistsHere == false)  //If there is not already a pump here
  {
    ((Machinery)Tiles.get( n )).inputterInd = machineryList.size();
    Machinery newMachinery = new Machinery(pos, n);
    machineryList.add( newMachinery );
  }
}

void displayVatFluid(){
  for(int i=0; i<vatList.size(); i++)  //For all networks...
  {
    relativeObjPos = findRelativeCoordinates( vatList.get(i).tileNum );
    fill(158, 230, 232);
    
    pushStyle();
    ellipse(relativeObjPos.x, relativeObjPos.y, 10*vatList.get(i).fluidIn, 10*vatList.get(i).fluidIn);
    popStyle();
  }
}

void displayMachineryFluid(){
  for(int i=0; i<machineryList.size(); i++)  //For all networks...
  {
    relativeObjPos = findRelativeCoordinates( machineryList.get(i).tileNum );
    fill(158, 230, 232);
    
    pushStyle();
    ellipse(relativeObjPos.x, relativeObjPos.y, 10*machineryList.get(i).fluidIn, 10*machineryList.get(i).fluidIn);
    popStyle();
  }
}
