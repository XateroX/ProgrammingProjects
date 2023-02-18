import processing.video.*;
Movie testMov;

void setup()
{
  fullScreen();
  testMov = new Movie(this, "TestVideo.mov");
  testMov.play();
}

void draw()
{
  background(0);
  image(testMov, width/2 - testMov.width/2, height/2 - testMov.height/2);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
