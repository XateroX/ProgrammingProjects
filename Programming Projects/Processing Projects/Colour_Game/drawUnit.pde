void drawUnit(){
    pushMatrix();
    pushStyle();

    noStroke();

    float angPhaser = 3*frameCount / 60.0;
    float orbitd = 5;
    
    
    
  
      // RED Component
    pushMatrix();
    pushStyle();
    translate(orbitd*sin(angPhaser),orbitd*cos(angPhaser));
    fill(255, 0, 0,230*(red(col)/255));
    ellipse(0,0,90,90);
    popMatrix();
    popStyle();

      // GREEN Component
    pushMatrix();
    pushStyle();
    translate(orbitd*sin(angPhaser+(2*PI/3)),orbitd*cos(angPhaser+(2*PI/3)));
    fill(0, 255, 0,230*(green(col)/255));
    ellipse(0,0,90,90);
    popMatrix();
    popStyle();

      // BLUE Component
    pushMatrix();
    pushStyle();
    translate(orbitd*sin(angPhaser+(2 * 2*PI/3)),orbitd*cos(angPhaser+(2 * 2*PI/3)));
    fill(0, 0, 255,230*(blue(col)/255));
    ellipse(0,0,90,90);
    popMatrix();
    popStyle();

    
    
    pushMatrix();
    pushStyle();
    fill(col,230);
    ellipse(0,0,90,90);
    popMatrix();
    popStyle();


    popMatrix();
    popStyle();
}



void drawUnitWalking()
{
  pushMatrix();
  pushStyle();
  
  image(unit,0,0,300,300);
  
  popMatrix();
  popStyle();
}
