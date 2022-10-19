#include <Servo.h>
Servo myservo;
int ang = 0;
 
void setup() {
  // put your setup code here, to run once:
  myservo.attach(9);
  myservo.write(90);// move servos to center position -> 90°
}

void loop() {
  // put your main code here, to run repeatedly:
  ang += 1;
  myservo.write(ang);
  delay(50);
  if (ang >= 180)
  {
   ang = 0; 
  }
}
