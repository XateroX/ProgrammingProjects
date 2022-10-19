void drawBlackShaddow(){
  pushMatrix();
  pushStyle();
  
  seed += random(-15,15);
  
  fill(seed,seed,seed,30);
  noStroke();
  
  pushMatrix();
  ellipse(0,0, random(0.9,1.1)*200,200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-7,7),random(-7,7));
  ellipse(0,0, random(0.9,1.1)*200,random(0.9,1.1)*200);
  popMatrix();
  
  pushMatrix();
  ellipse(0,0, random(0.9,1.1)*200,200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-7,7),random(-7,7));
  ellipse(0,0, random(0.9,1.1)*200,random(0.9,1.1)*200);
  popMatrix();
  
  pushMatrix();
  ellipse(0,0, random(0.9,1.1)*200,200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-8,8),random(-8,8));
  ellipse(0,0, 200,random(0.9,1.1)*200);
  translate(random(-7,7),random(-7,7));
  ellipse(0,0, random(0.9,1.1)*200,random(0.9,1.1)*200);
  popMatrix();
  
  popStyle();
  popMatrix();
}
