void calcDisplayEvents(){
  if(eventsShort.size() > 0)  //If events to be shown...
  {
    displayEvents();
  }
}

void displayEvents(){
  pushStyle();
  imageMode(CORNER);
  rectMode(CORNER);
  textAlign(CENTER);
  textSize(15);
  
  if(eventsShort.size() < maxEventSize){
  eventBoxHeight = eventBoxSpacing * ( 3+ eventsShort.size() );}  //**+3 accounts for the "Events", "----" and space at the end lines needed**
  else{
  eventBoxHeight = eventBoxSpacing * ( 3+ maxEventSize+1 );}
  
  fill(179, 227, 202);
  //rect(eventBoxX, eventBoxY, eventBoxWidth, eventBoxHeight);
  image(eventBoxTop, eventBoxX, eventBoxY);  //Top piece
  
  fill(0);
  image(eventBoxMiddle, eventBoxX, eventBoxY + (1)*eventBoxSpacing);
  image(eventBoxMiddle, eventBoxX, eventBoxY + (2)*eventBoxSpacing);
  text("Events" , eventBoxX + eventBoxWidth/2, eventBoxY + 1*eventBoxSpacing);
  text("-------", eventBoxX + eventBoxWidth/2, eventBoxY + 2*eventBoxSpacing);
  
  for(int i=0; i<eventsShort.size(); i++)  //Go through all notifications and display shorts
  {
    if(i < maxEventSize)    //If within max notification limit
    {
      image(eventBoxMiddle, eventBoxX, eventBoxY + (3+i)*eventBoxSpacing);
      image(eventBoxTextBox, eventBoxX, eventBoxY + (3+i)*eventBoxSpacing - (0.7)*eventBoxSpacing);
      text(eventsShort.get(i), eventBoxX + eventBoxWidth/2, eventBoxY + (3+i)*eventBoxSpacing);
      if(i == eventsShort.size()-1)
      {
        pushMatrix();
        translate(eventBoxX+eventBoxWidth, eventBoxY + (5+i)*eventBoxSpacing);
        rotate(PI);
        image(eventBoxTop, 0,0);
        popMatrix();
      }
    }
    else                    //if not within limit, just display "..." after
    {
      image(eventBoxMiddle, eventBoxX, eventBoxY + (3+i)*eventBoxSpacing);
      text("...", eventBoxX + eventBoxWidth/2, eventBoxY + (3+i)*eventBoxSpacing);
      pushMatrix();
      translate(eventBoxX+eventBoxWidth, eventBoxY + (5+i)*eventBoxSpacing);
      rotate(PI);
      image(eventBoxTop, 0,0);
      popMatrix();
      break;
    }
  }
  
  popStyle();
}
//##ADD NOISE FEEDBACK WHEN EVENT FIRST APPEARS##//
//**Remember to have ".add(0,"...")", so the new eventappears at top of list


void actionOnEvent( int eventIndex ){
  if(eventCurrentlyHovered == true)
  {
    if((eventsShort.size() >= (eventIndex+1)) && (eventIndex > -1))  //If anything to display...
    {
      //(1)Show description
      pushStyle();
      rectMode(CORNER);
      imageMode(CORNER);
      
      fill(0);
      stroke(95, 117, 133);
      strokeWeight(2);
      rect(eventDescX, eventDescY, eventDescWidth, eventDescHeight);
      image(test1, eventDescX, eventDescY);
      
      fill(255);
      //(1)displayText, (2)displayPosition, (3)displaySize, (4)textBoxDim, (5)textColour
      textFormatted( eventsDescription.get(eventIndex), new PVector(eventDescX + eventDescWidth/2 , eventDescY), 15, new PVector(eventDescWidth, eventDescHeight), new PVector(245, 198, 214) );
      //text(eventsDescription.get(eventIndex), eventDescX+5, eventDescY+20);
      
      textAlign(LEFT);
      
      text("Left-click to remove event",eventDescX, eventDescY + eventDescHeight);
      
      popStyle();
      
      //(2)Dismiss event
      //eventCurrentlyHovered will be true here, and so if mousePressed, event will be removed
    }
  }
}
//##POSSIBLE EVENT HISTORY IN FUTURE, STORED SOMWHERE##//

int eventHovered(){
  //Find event being hovered
  eventCurrentlyHovered = false;
  if( (eventBoxX <= mouseX)&&(mouseX <= eventBoxX + eventBoxWidth) )  //If X coordinate is correct...
  {
    if( (eventBoxY <= mouseY)&&(mouseY <= eventBoxY + eventBoxHeight - eventBoxSpacing) )  //If Y coordinate is correct...
    {
      //Determine correct index in eventsShort / Description
      eventCurrentlyHovered = true;
      eventInd = floor( (mouseY-eventBoxY-2*eventBoxSpacing) / (eventBoxSpacing) );  //- to get to start of where event occur, / to get number of events that have occurred, floor to give number of full events occurred so far => also index
    }
  }
  return eventInd;
}
//##ADD AN ICON NEXT TO EVENTS THAT HAVE NOT BEEN READ YET##//

void increaseFactionInterest(int factionNum){
  //Triggered event will increase faction's interest with the inn
  eventsShort.add      (0, "Interest up");
  eventsDescription.add(0, "Faction "+str(factionNum +1)+" has become more interested in your inn, and will now visit more often");

  factionInterestTemp = factionInterest.get(factionNum) + 0.1;
  if(factionInterestTemp > 1){
    factionInterestTemp = 1;
    factionInterest.remove(factionNum);
    factionInterest.add(factionNum, factionInterestTemp);
  }
  else{
    factionInterest.remove(factionNum);
    factionInterest.add(factionNum, factionInterestTemp);
  }
}

void decreaseFactionInterest(int factionNum){
  //Triggered event will decrease faction's interest with the inn
  eventsShort.add      (0, "Interest down");
  eventsDescription.add(0, "Faction "+str(factionNum +1)+" has become less interested in your inn, and will not visit your inn as often");

  factionInterestTemp = factionInterest.get(factionNum) - 0.1;
  if(factionInterestTemp < 0){
    factionInterestTemp = 0;
    factionInterest.remove(factionNum);
    factionInterest.add(factionNum, factionInterestTemp);
  }
  else{
    factionInterest.remove(factionNum);
    factionInterest.add(factionNum, factionInterestTemp);
  }
}
