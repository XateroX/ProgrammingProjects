float sinusoidal(){
  return 0; 
}

float timeTransition(){
  if(frameCount >= dayEnd)
  {
    dayNumber ++;
    dayStart = frameCount;
    dayEnd = dayStart + (dayLength*60);
  }
  if( (frameCount-dayStart)/60 < (dayLength*morningProportion) )                                                                              //Morning proportion
  {
    daylightMultiplier = sin( (PI/2) + ((((frameCount - dayStart)/60 )/(dayLength))/( morningProportion )) * (PI / 2) );                  //Getting brighter
  }
  if( ( (dayLength*morningProportion) <= (frameCount-dayStart)/60 ) && ((frameCount-dayStart)/60 <= (dayLength*(1-eveningProportion))) )      //Midday proportion
  {
    daylightMultiplier = 0;                                                                                                               //Perfectly bright
  }
  if( (frameCount-dayStart)/60 > (dayLength*(1-eveningProportion)) )                                                                          //Evening proportion
  {
    //println("Prop; ", ((((((frameCount - dayStart)/60) / (dayLength)) - (1-eveningProportion)) / (eveningProportion)) * (PI/2))  );     //*****//
    daylightMultiplier = sin( ((((((frameCount - dayStart)/60) / (dayLength)) - (1-eveningProportion)) / (eveningProportion)) * (PI/2)) );//Getting darker
  }
  return daylightMultiplier;
}
