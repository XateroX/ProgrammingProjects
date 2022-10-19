//1.Roughly 8-15 frames ; ##-->12 is good<--##
//2.Stitch together here, while entity.vel > or < ...
//3.Ignore every x frames to make animation last giving time set and transition evenly and smoothly
//(4).If flickering, missing a <= (has empty frames on edge)

/*images; => 10 frames, 60 FPS, => For 1 second of animation (on set 
               of steps to make-up the run), frame every 6 frames.
  test1
  test2
  test3
  ...
  ...
  test10
  */

//## CONVERT ALL TO INTERVAL METHOD ##//

//Running up
void userRunAnimUp(PVector pos){//pos is the position of the user
  frameTotal  = 60;
  perFrame    = frameTotal / 10;
  frameTimerY += 1;
  if((     0     < frameTimerY) && (frameTimerY <= perFrame*1)){
    image(test1, pos.x, pos.y);}
  if((perFrame*1 < frameTimerY) && (frameTimerY <= perFrame*2)){
    image(test2, pos.x, pos.y);}
  if((perFrame*2 < frameTimerY) && (frameTimerY <= perFrame*3)){
    image(test3, pos.x, pos.y);}
  if((perFrame*3 < frameTimerY) && (frameTimerY <= perFrame*4)){
    image(test4, pos.x, pos.y);}
  if((perFrame*4 < frameTimerY) && (frameTimerY <= perFrame*5)){
    image(test5, pos.x, pos.y);}
  if((perFrame*5 < frameTimerY) && (frameTimerY <= perFrame*6)){
    image(test6, pos.x, pos.y);}
  if((perFrame*6 < frameTimerY) && (frameTimerY <= perFrame*7)){
    image(test7, pos.x, pos.y);}
}


//Running down
void userRunAnimDown(PVector pos){//pos is the position of the user
  frameTotal  = 60;
  perFrame    = frameTotal / 10;
  frameTimerY += 1;
  if((     0     < frameTimerY) && (frameTimerY <= perFrame*1)){
    image(userFrontRun1, pos.x, pos.y);}
  if((perFrame*1 < frameTimerY) && (frameTimerY <= perFrame*2)){
    image(userFrontRun2, pos.x, pos.y);}
  if((perFrame*2 < frameTimerY) && (frameTimerY <= perFrame*3)){
    image(userFrontRun3, pos.x, pos.y);}
  if((perFrame*3 < frameTimerY) && (frameTimerY <= perFrame*4)){
    image(userFrontRun4, pos.x, pos.y);}
  if((perFrame*4 < frameTimerY) && (frameTimerY <= perFrame*5)){
    image(userFrontRun5, pos.x, pos.y);}
  if((perFrame*5 < frameTimerY) && (frameTimerY <= perFrame*6)){
    image(userFrontRun6, pos.x, pos.y);}
  if((perFrame*6 < frameTimerY) && (frameTimerY <= perFrame*7)){
    image(userFrontRun7, pos.x, pos.y);}
}


//Running left
void userRunAnimLeft(PVector pos){//pos is the position of the user
  frameTotal  = 60;
  perFrame    = frameTotal / 10;
  frameTimerX += 1;
  if((     0     < frameTimerX) && (frameTimerX <= perFrame*1)){
    image(test1, pos.x, pos.y);}
  if((perFrame*1 < frameTimerX) && (frameTimerX <= perFrame*2)){
    image(test2, pos.x, pos.y);}
  if((perFrame*2 < frameTimerX) && (frameTimerX <= perFrame*3)){
    image(test3, pos.x, pos.y);}
  if((perFrame*3 < frameTimerX) && (frameTimerX <= perFrame*4)){
    image(test4, pos.x, pos.y);}
  if((perFrame*4 < frameTimerX) && (frameTimerX <= perFrame*5)){
    image(test5, pos.x, pos.y);}
  if((perFrame*5 < frameTimerX) && (frameTimerX <= perFrame*6)){
    image(test6, pos.x, pos.y);}
  if((perFrame*6 < frameTimerX) && (frameTimerX <= perFrame*7)){
    image(test7, pos.x, pos.y);}
  if((perFrame*7 < frameTimerX) && (frameTimerX <= perFrame*8)){
    image(test8, pos.x, pos.y);}
  if((perFrame*8 < frameTimerX) && (frameTimerX <= perFrame*9)){
    image(test9, pos.x, pos.y);}
  if((perFrame*9 < frameTimerX) && (frameTimerX <= perFrame*10)){
    image(test10, pos.x, pos.y);}
}


//Running right
void userRunAnimRight(PVector pos){//pos is the position of the user
  frameTotal  = 60;
  perFrame    = frameTotal / 10;
  frameTimerX += 1;
  if((     0     < frameTimerX) && (frameTimerX <= perFrame*1)){
    image(userRightRun1, pos.x, pos.y);}
  if((perFrame*1 < frameTimerX) && (frameTimerX <= perFrame*2)){
    image(userRightRun2, pos.x, pos.y);}
  if((perFrame*2 < frameTimerX) && (frameTimerX <= perFrame*3)){
    image(userRightRun3, pos.x, pos.y);}
  if((perFrame*3 < frameTimerX) && (frameTimerX <= perFrame*4)){
    image(userRightRun4, pos.x, pos.y);}
  if((perFrame*4 < frameTimerX) && (frameTimerX <= perFrame*5)){
    image(userRightRun5, pos.x, pos.y);}
  if((perFrame*5 < frameTimerX) && (frameTimerX <= perFrame*6)){
    image(userRightRun6, pos.x, pos.y);}
  if((perFrame*6 < frameTimerX) && (frameTimerX <= perFrame*7)){
    image(userRightRun7, pos.x, pos.y);}
  if((perFrame*7 < frameTimerX) && (frameTimerX <= perFrame*8)){
    image(userRightRun8, pos.x, pos.y);}
  if((perFrame*8 < frameTimerX) && (frameTimerX <= perFrame*9)){
    image(userRightRun9, pos.x, pos.y);}
  if((perFrame*9 < frameTimerX) && (frameTimerX <= perFrame*10)){
    image(userRightRun10, pos.x, pos.y);}
  if((perFrame*10< frameTimerX) && (frameTimerX <= perFrame*11)){
    image(userRightRun11, pos.x, pos.y);}
  if((perFrame*11< frameTimerX) && (frameTimerX <= perFrame*12)){
    image(userRightRun12, pos.x, pos.y);}
}

//Stationary fron (set1)
void userStatAnimFront(PVector pos){//pos is the position of the user
  frameTotal  = 120;
  perFrame    = frameTotal / 10;
  frameTimerX += 1;
  if((     0     < frameTimerX) && (frameTimerX <= perFrame*1)){
    image(userFrontStat1Set1, pos.x, pos.y);}
  if((perFrame*1 < frameTimerX) && (frameTimerX <= perFrame*5)){
    image(userFrontStat1Set5, pos.x, pos.y);}
  if((perFrame*5 < frameTimerX) && (frameTimerX <= perFrame*9)){
    image(userFrontStat1Set9, pos.x, pos.y);}
  if((perFrame*9 < frameTimerX) && (frameTimerX <= perFrame*13)){
    image(userFrontStat1Set13, pos.x, pos.y);}
  if((perFrame*13< frameTimerX) && (frameTimerX <= perFrame*17)){
    image(userFrontStat1Set17, pos.x, pos.y);}
  if((perFrame*17< frameTimerX) && (frameTimerX <= perFrame*18)){
    image(userFrontStat1Set18, pos.x, pos.y);}
  if((perFrame*18< frameTimerX) && (frameTimerX <= perFrame*19)){
    image(userFrontStat1Set19, pos.x, pos.y);}
  if((perFrame*19< frameTimerX) && (frameTimerX <= perFrame*20)){
    image(userFrontStat1Set20, pos.x, pos.y);}
  if((perFrame*20< frameTimerX) && (frameTimerX <= perFrame*21)){
    image(userFrontStat1Set21, pos.x, pos.y);}
  if((perFrame*21< frameTimerX) && (frameTimerX <= perFrame*22)){
    image(userFrontStat1Set22, pos.x, pos.y);}
  if((perFrame*22< frameTimerX) && (frameTimerX <= perFrame*23)){
    image(userFrontStat1Set23, pos.x, pos.y);}
  if((perFrame*23< frameTimerX) && (frameTimerX <= perFrame*24)){
    image(userFrontStat1Set24, pos.x, pos.y);}
}
