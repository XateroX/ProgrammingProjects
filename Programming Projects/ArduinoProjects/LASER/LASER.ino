#define LASER 8
#define SPEAKER 6
float hz = 10;
float t = 0.01;
boolean mode = 0;
float vol = 1.0;

void setup() {
  // put your setup code here, to run once:
  pinMode(LASER, OUTPUT);
  pinMode(SPEAKER, OUTPUT);

  digitalWrite(LASER, HIGH);
  digitalWrite(SPEAKER, HIGH);
}

void loop() {
  analogWrite(SPEAKER, vol);
  delay(t*1000.0);
  if (mode == 0){
    hz += 10.0;
    if (hz >= 500){
      mode = 1;}
  
  }else{
    hz -= 10.0;
    if (hz <= 0){
      mode = 0;}
  }
    
}
