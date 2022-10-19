void drawBase(){
    pushMatrix();
    pushStyle();
  
    
    float angPhaser = frameCount / 60.0;
    float reduc = 0.5;
    float ratior = reduc*sin(angPhaser);
    float ratiog = reduc*cos(angPhaser+(    2*PI/3));
    float ratiob = reduc*sin(angPhaser+(2 * 2*PI/3));
    
  
    int bw = 100;
    int bh = 100;
    image(baseImage, -bw/2,-bh/2, bw,bh);
    float cor_frac = 0.685;
    PVector c1 = new PVector(-cor_frac*bw/2,-cor_frac*bh/2);
    PVector c2 = new PVector( cor_frac*bw/2,-cor_frac*bh/2);
    PVector c3 = new PVector( cor_frac*bw/2, cor_frac*bh/2);
    PVector c4 = new PVector(-cor_frac*bw/2, cor_frac*bh/2);
    
    pushStyle();
    noFill();
    stroke((1/reduc)*abs(ratior)*200+150,0,0,230);
    strokeWeight(bw/10);
    bezier(c1.x,c1.y,2*ratior*c3.x,-2*ratior*c3.y, c3.x,c3.y,c2.x,c2.y);
    popStyle();
    
    pushStyle();
    noFill();
    stroke(0,(1/reduc)*abs(ratiog)*200+150,0,230);
    strokeWeight(bw/10);
    bezier(c2.x,c2.y,2*ratiog*c3.x,-2*ratiog*c3.y, c1.x,c1.y,c4.x,c4.y);
    popStyle();
    
    pushStyle();
    noFill();
    stroke(0,0,(1/reduc)*abs(ratiob)*200+150,230);
    strokeWeight(bw/10);
    bezier(c4.x,c4.y,2*ratiob*c2.x,-2*ratiob*c2.y, c2.x,c2.y,c3.x,c3.y);
    popStyle();
    
    fill(255);
    stroke(0,240);
    strokeWeight(bw/20);
    ellipse(0,0,bw/2,bh/2);

    popStyle();
    popMatrix();
}
