#include <Servo.h>
Servo LazMOTOR;
Servo SpeMOTOR;
int ang = 0;

#define LAZER 11
#define LazMOTORPin 9
#define SpeMOTORPin 10
#define buttonPin 5

int buttonState = 0;
int debugStage  = 1;
boolean seekingInput = true;

int speAngle = 0;
int lazAngle = 0;

void setup() {
  // put your setup code here, to run once:
  LazMOTOR.attach(LazMOTORPin);
  SpeMOTOR.attach(SpeMOTORPin);
  LazMOTOR.write(0);
  SpeMOTOR.write(0);
  pinMode(LAZER, OUTPUT);
  digitalWrite(LAZER, HIGH);

  pinMode(buttonPin, INPUT_PULLUP);

  Serial.begin(9600);
}

void loop() {
  if (debugStage == 0)
  {
    speAngle = 0;
  }
  if (debugStage == 1)
  {
    SpeMOTOR.write(speAngle);
    lazAngle = 0;
    LazMOTOR.write(lazAngle);
    delay(150);
    lazAngle = 40;
    LazMOTOR.write(lazAngle);
    delay(150);
    lazAngle = 0;
    LazMOTOR.write(lazAngle);
    delay(150);
    lazAngle = 40;
    LazMOTOR.write(lazAngle);
    delay(150);

    speAngle += 3;
    speAngle %= 180;
  }
  if (debugStage == 2)
  {
    LazMOTOR.write(lazAngle);
    lazAngle += 1;
    delay(250);
    if (lazAngle > 40)
    {
      lazAngle = 0;
    }
  }


  if (seekingInput)
  {
    if (digitalRead(buttonPin) == LOW)
    {
      debugStage += 1;
      debugStage %= 3;
      seekingInput = false;
    }
  } else if (digitalRead(buttonPin) == HIGH)
  {
    seekingInput = true;
  }
  Serial.println("Seeking Input:" + String(seekingInput));
  Serial.println("Debug Stage  :" + String(debugStage));
  Serial.println("Button       :" + String(digitalRead(buttonPin)));
  Serial.println("");
}
