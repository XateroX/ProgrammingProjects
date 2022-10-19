#define BLUE 3
#define GREEN 5
#define RED 6

int redValue   = 255;
int greenValue = 0;
int blueValue  = 0;

float ang = 0;

void setColour(int redValue, int greenValue, int blueValue){
  analogWrite(RED, redValue);
  analogWrite(GREEN, greenValue);
  analogWrite(BLUE, blueValue);
  delay(10);
}

void setup() {
  // put your setup code here, to run once:
  pinMode(RED,OUTPUT);
  pinMode(GREEN,OUTPUT);
  pinMode(BLUE,OUTPUT);

  digitalWrite(RED,HIGH);
  digitalWrite(GREEN,LOW);
  digitalWrite(BLUE,LOW);
}

void loop() {
  ang = ang + 0.1;
  redValue   = round(255 * ((sin(ang)+1)/2));
  greenValue = round(255 * ((sin(2*ang)+1)/2));
  blueValue  = round(255 * ((sin(3*ang)+1)/2));
  // put your main code here, to run repeatedly:
  setColour(redValue,greenValue,blueValue);
}
