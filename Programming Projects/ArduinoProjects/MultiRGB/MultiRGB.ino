#define rgb1R 11
#define rgb1G 10
#define rgb1B 9

#define rgb2R 6
#define rgb2G 5
#define rgb2B 3


float ang;

void setup() {
  // put your setup code here, to run once:
  pinMode(rgb1R, OUTPUT);
  pinMode(rgb1G, OUTPUT);
  pinMode(rgb1B, OUTPUT);

  pinMode(rgb2R, OUTPUT);
  pinMode(rgb2G, OUTPUT);
  pinMode(rgb2B, OUTPUT);
  

  digitalWrite(rgb1R,LOW);
  digitalWrite(rgb1G,LOW);
  digitalWrite(rgb1B,LOW);

  digitalWrite(rgb2R,LOW);
  digitalWrite(rgb2G,LOW);
  digitalWrite(rgb2B,LOW);


  ang = 0;
}

void loop() {
  ang = ang + 0.00005;
  
  // put your main code here, to run repeatedly:
  analogWrite(rgb1R, round(255*(1+sin(10*ang))/2.0));
  analogWrite(rgb2R, round(255*(1+sin(40*ang))/2.0));

  analogWrite(rgb1G, round(255*(1+sin(ang))/2.0));
  analogWrite(rgb2G, round(255*(1+sin(2*ang))/2.0));

  analogWrite(rgb1B, round(255*(1+sin(ang))/2.0));
  analogWrite(rgb2B, round(255*(1+sin(4*ang))/2.0));
}
