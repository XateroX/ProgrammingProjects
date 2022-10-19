#include "pitches.h"

void setup() {
  pinMode(8,OUTPUT);
  digitalWrite(8,HIGH);

  // iterate over the notes of the melody:

  for (int thisNote = 250; thisNote < 500; thisNote+=1) {
    tone(7, thisNote, 100);
    delay(50);
    //tone(7, thisNote+2, 100);
    //delay(100);
    //Serial.print(thisNote);
  }
}

void loop() {

  // no need to repeat the melody.
}
