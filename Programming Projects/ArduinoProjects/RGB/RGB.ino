#include <Servo.h>

Servo wiggleMotor;

#define BLUE 11
#define GREEN 5
#define RED 3
#define wigglePin 6

int redValue   = 0;
int greenValue = 0;
int blueValue  = 0;
int i = 0;
int lightTimer = 0;

float wiggleAngle = 90;

int colours[6][3] = {{1,3,4},{1,1,1},{4,1,3},{2,1,2},{1,2,2},{2,2,1}};

float n = 0;

void setColour(int redValue, int greenValue, int blueValue){
  analogWrite(RED, redValue);
  analogWrite(GREEN, greenValue);
  analogWrite(BLUE, blueValue);
}

void setup() {
  // put your setup code here, to run once:
  pinMode(RED,OUTPUT);
  pinMode(GREEN,OUTPUT);
  pinMode(BLUE,OUTPUT);

  wiggleMotor.attach(wigglePin);

  //digitalWrite(RED,HIGH);
  //digitalWrite(GREEN,LOW);
  //digitalWrite(BLUE,LOW);

  wiggleMotor.write(80);

  Serial.begin(9600);
}

void loop() {

  if (millis() > lightTimer)
  {
    setColour(colours[i][0],colours[i][1],colours[i][2]);
    Serial.println(String(colours[i][0])+ " " + String(colours[i][1])+ " " + String(colours[i][2]));
    i += 1;
    i %= 6;
    lightTimer = millis()+30000;
  }

  wiggleMotor.write( round(wiggleAngle) );
  wiggleAngle = 80 + 20*sin(n);

  n+=2*PI * 0.001;
  delay(3);
  
}
