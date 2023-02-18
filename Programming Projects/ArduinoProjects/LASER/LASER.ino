#define LASER 8
#define SPEAKER 7
float hz = 20;
float t = 200.0;
int n = 0;
boolean mode = 0;
float maxVol = 100.0;

void setup() {
  // put your setup code here, to run once:
  pinMode(LASER, OUTPUT);
  pinMode(SPEAKER, OUTPUT);

  digitalWrite(LASER, HIGH);
  digitalWrite(SPEAKER, HIGH);
}

void loop() {
  for (int i = 0; i < hz; i++)
  {
    digitalWrite(SPEAKER, HIGH);
    delay(t/(2.0*(float)hz)); 
    digitalWrite(SPEAKER, LOW);
    delay(t/(2.0*(float)hz)); 
  }
  hz += 1;
}
