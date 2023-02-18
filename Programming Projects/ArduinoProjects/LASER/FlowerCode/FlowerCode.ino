#include <Servo.h>
Servo armServo;

#define rgb1R 3
#define rgb1G 5
#define rgb1B 11

#define servoPin 6
float ang;
float adj;

void setup() {
  // put your setup code here, to run once:
  pinMode(rgb1R, OUTPUT);
  pinMode(rgb1G, OUTPUT);
  pinMode(rgb1B, OUTPUT);
  
  digitalWrite(rgb1R,LOW);
  digitalWrite(rgb1G,LOW);
  digitalWrite(rgb1B,LOW);

  armServo.attach(servoPin);
  armServo.write(90);

  ang = 0;
  adj = 3;
}

void loop() {
  ang += adj;
  analogWrite(rgb1R, 50*(1+sin(ang/20))/2.0);
  analogWrite(rgb1G, 50*(1+sin(ang/20))/2.0);
  analogWrite(rgb1B, 50*(1+sin(ang/20))/2.0);

  armServo.write(round(ang));

  delay(20);

  if (ang>180 or ang<0)
  {
    adj *= -1;
  }
}
