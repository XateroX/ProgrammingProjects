#include "pitches.h"

int n = 0;
int tar = 0;

#define LASER   8
#define SPEAKER 7
#define stickX  0
#define stickY  1

float val = 0;

void setup() {
  pinMode(LASER,OUTPUT);
  pinMode(SPEAKER,OUTPUT);
  digitalWrite(LASER,HIGH);

  Serial.begin(9600);
}

void loop() {
  //tar = abs(analogRead(stickX)-512)/4.0;
  //val = (tar*0.999 + val*0.01);

  for (int i = 200; i < 300; i++)
  {
    tone(SPEAKER, i, 200);
    delay(200);
  }

  //tone()

  //digitalWrite(SPEAKER,HIGH);
  //delay(min(200,1000.0/(2*val)));
  //digitalWrite(SPEAKER,LOW);
  //delay(min(200,1000.0/(2*val)));
  

  
  //analogWrite(LASER,stickX);
  //analogWrite(6, abs(val/4.0));//255 * (1+sin((float)n/1000000.0 * 2*PI))/2.0);
  //delay(500);
}
