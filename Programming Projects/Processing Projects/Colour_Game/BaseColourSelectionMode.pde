void drawColourSelector(){
    pushMatrix();
    pushStyle();

    image(baseColourSelector, -sw/2,-sh/2, sw,sh);
    
    if (sw != 200 && sh != 200){
      sw = lerp(sw,200,0.1);
      sh = lerp(sh,200,0.1);
    }
    
    float fullness = (frameCount/3/60.0)%1;
    float crad = sw/3;
    PVector c1 = new PVector(      0,-sh/3);
    PVector c2 = new PVector( sw/3.15, sh/4);
    PVector c3 = new PVector(-sw/3.15, sh/4);
    
    noStroke();
    fill(255,0,0);
    arc(c1.x,c1.y,crad,crad,  map(fullness,0,1,PI,0) -PI/2,  2*PI - map(fullness,0,1,PI,0) -PI/2,OPEN);
    
    
    fill(0,255,0);
    arc(c2.x,c2.y,crad,crad,  map(fullness,0,1,PI,0) -PI/2,  2*PI - map(fullness,0,1,PI,0) -PI/2,OPEN);
    
    
    fill(0,0,255);
    arc(c3.x,c3.y,crad,crad,  map(fullness,0,1,PI,0) -PI/2,  2*PI - map(fullness,0,1,PI,0) -PI/2,OPEN);

    popStyle();
    popMatrix();
}
