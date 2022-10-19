PVector pos1  = new PVector(0,0);
PVector pos2  = new PVector(0,0);
PVector vel1  = new PVector(0,0);
PVector vel2  = new PVector(0,0);
PVector acc1  = new PVector(0,0);
PVector acc2  = new PVector(0,0);
float ballRad = 300;
float coeffRestitution = -1.0;

boolean bounced = false;

void setup()
{
    size(1000,1000);

    pos1 = new PVector(  2*width/4, 2*height/3);
    pos2 = new PVector(3*width/4, height/3);

    vel1 = new PVector( 0.5,-0.5);
    vel2 = new PVector(-3.0,0.25);
}

void draw()
{
    background(0);

    vel1.add(acc1);
    vel2.add(acc2);
    pos1.add(vel1);
    pos2.add(vel2);

    fill(200);
    stroke(255);
    strokeWeight(2);
    ellipse(pos1.x,pos1.y,ballRad,ballRad);
    ellipse(pos2.x,pos2.y,ballRad,ballRad);

    if ( dist(pos2.x, pos2.y, pos1.x, pos1.y) < (ballRad+ballRad)/2 && !bounced)
    {
        bounceOff();
        bounced = true;
    }



    PVector dir = new PVector(pos2.x-pos1.x,pos2.y-pos1.y);
    dir.normalize();
    PVector dir2 = new PVector(-pos2.x+pos1.x,-pos2.y+pos1.y);
    dir2.normalize();

    println("dir: ", dir.x,  " " ,dir.y);
    println("dir: ", dir2.x, " " ,dir2.y);

    float correctionAng1 = PVector.angleBetween(dir,vel1);
    float correctionAng2 = PVector.angleBetween(dir2,vel2);

    println("correctionAng1: ", correctionAng1);
    println("correctionAng2: ", correctionAng2);
    
    PVector tempVel1 = new PVector( vel1.x*cos(correctionAng1), vel1.y*sin(correctionAng1));
    PVector tempVel2 = new PVector( vel2.x*cos(correctionAng2), vel2.y*sin(correctionAng2));

    PVector t_tempVel1 = new PVector(tempVel1.x,tempVel1.y);
    PVector t_tempVel2 = new PVector(tempVel2.x,tempVel2.y);

    
    fill(0,0,255);
    strokeWeight(5);
    ellipse(pos1.x+t_tempVel1.x*300,pos1.y+t_tempVel1.y*300, 20, 20);
    line(pos1.x,pos1.y, pos1.x+t_tempVel1.x*300,pos1.y+t_tempVel1.y*300);

    fill(0,0,255);
    strokeWeight(5);
    ellipse(pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300);
    

    println("vel: ", vel1.x, " ",vel1.y);
    println("t_tempVel1: ", t_tempVel1.x, " ",t_tempVel1.y);
    println("correctionAng2: ", correctionAng2);

    t_tempVel1.x = tempVel2.x*(coeffRestitution-1.0)/(2.0*coeffRestitution) + tempVel1.x*(coeffRestitution+1.0)/(2.0*coeffRestitution);
    t_tempVel2.x = tempVel2.x*(coeffRestitution+1.0)/(2.0*coeffRestitution) + tempVel1.x*(coeffRestitution-1.0)/(2.0*coeffRestitution);


    /*
    fill(0,255,255);
    strokeWeight(5);
    ellipse(pos1.x+t_tempVel1.x*300,pos1.y+t_tempVel1.y*300, 20, 20);
    line(pos1.x,pos1.y, pos1.x+t_tempVel1.x*300,pos1.y+t_tempVel1.y*300);

    fill(0,255,255);
    strokeWeight(5);
    ellipse(pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300);
    */

    PVector XComp = new PVector(dir.x,dir.y);
    XComp.mult(t_tempVel1.x);
    println("XComp: ", XComp.x, " ",XComp.y);
    PVector YComp = new PVector(dir.x,dir.y);
    YComp.rotate(PI/2);
    YComp.mult(t_tempVel1.y);
    println("YComp: ", YComp.x, " ",YComp.y);
    PVector newVel = new PVector(XComp.x+YComp.x, XComp.y+YComp.y);
    //vel1 = newVel.copy();
    println("newVel: ", newVel.x, " ",newVel.y);
    fill(255,255,0);
    strokeWeight(5);
    ellipse(pos1.x+newVel.x*300,pos1.y+newVel.y*300, 20, 20);
    line(pos1.x,pos1.y, pos1.x+newVel.x*300,pos1.y+newVel.y*300);


    XComp = new PVector(dir2.x,dir2.y);
    XComp.mult(-t_tempVel2.x);
    YComp = new PVector(dir2.x,dir2.y);
    YComp.rotate(-PI/2);
    YComp.mult(t_tempVel2.y);
    newVel = new PVector(XComp.x+YComp.x, XComp.y+YComp.y);
    //vel2 = new PVector(newVel.x,newVel.y);
    fill(255,255,0);
    strokeWeight(5);
    ellipse(pos2.x+newVel.x*300,pos2.y+newVel.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+newVel.x*300,pos2.y+newVel.y*300);

    fill(255);
    strokeWeight(5);
    ellipse(pos2.x+XComp.x*300,pos2.y+XComp.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+XComp.x*300,pos2.y+XComp.y*300);

    fill(random(255));
    strokeWeight(5);
    ellipse(pos2.x+YComp.x*300,pos2.y+YComp.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+YComp.x*300,pos2.y+YComp.y*300);

    

    fill(0,255,255);
    strokeWeight(5);
    ellipse(pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+t_tempVel2.x*300,pos2.y+t_tempVel2.y*300);



    fill(255,0,0);
    strokeWeight(5);
    ellipse(pos1.x+vel1.x*300,pos1.y+vel1.y*300, 20, 20);
    line(pos1.x,pos1.y, pos1.x+vel1.x*300,pos1.y+vel1.y*300);

    fill(255,0,0);
    strokeWeight(5);
    ellipse(pos2.x+vel2.x*300,pos2.y+vel2.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+vel2.x*300,pos2.y+vel2.y*300);



    fill(0,255,0);
    strokeWeight(5);
    ellipse(pos1.x+dir.x*300,pos1.y+dir.y*300, 20, 20);
    line(pos1.x,pos1.y, pos1.x+dir.x*300,pos1.y+dir.y*300);

    fill(0,255,0);
    strokeWeight(5);
    ellipse(pos2.x+dir2.x*300,pos2.y+dir2.y*300, 20, 20);
    line(pos2.x,pos2.y, pos2.x+dir2.x*300,pos2.y+dir2.y*300);
}


void bounceOff()
{
    PVector dir = new PVector(pos2.x-pos1.x,pos2.y-pos1.y);
    dir.normalize();
    PVector dir2 = new PVector(-pos2.x+pos1.x,-pos2.y+pos1.y);
    dir2.normalize();

    println("dir: ", dir.x,  " " ,dir.y);
    println("dir: ", dir2.x, " " ,dir2.y);

    float correctionAng1 = PVector.angleBetween(dir,vel1);
    float correctionAng2 = PVector.angleBetween(dir2,vel2);

    println("correctionAng1: ", correctionAng1);
    println("correctionAng2: ", correctionAng2);
    
    PVector tempVel1 = new PVector( vel1.x*cos(correctionAng1), vel1.y*sin(correctionAng1));
    PVector tempVel2 = new PVector( vel2.x*cos(correctionAng2), vel2.y*sin(correctionAng2));

    PVector t_tempVel1 = new PVector(tempVel1.x,tempVel1.y);
    PVector t_tempVel2 = new PVector(tempVel2.x,tempVel2.y);

    println("vel: ", vel1.x, " ",vel1.y);
    println("t_tempVel1: ", t_tempVel1.x, " ",t_tempVel1.y);
    println("correctionAng2: ", correctionAng2);

    t_tempVel1.x = tempVel2.x*(coeffRestitution-1.0)/(2.0*coeffRestitution) + tempVel1.x*(coeffRestitution+1.0)/(2.0*coeffRestitution);
    t_tempVel2.x = tempVel2.x*(coeffRestitution+1.0)/(2.0*coeffRestitution) + tempVel1.x*(coeffRestitution-1.0)/(2.0*coeffRestitution);

    PVector XComp = new PVector(dir.x,dir.y);
    XComp.mult(t_tempVel1.x);
    println("XComp: ", XComp.x, " ",XComp.y);
    PVector YComp = new PVector(dir.x,dir.y);
    YComp.rotate(PI/2);
    YComp.mult(t_tempVel1.y);
    println("YComp: ", YComp.x, " ",YComp.y);
    PVector newVel = new PVector(XComp.x+YComp.x, XComp.y+YComp.y);
    vel1 = newVel.copy();
    println("newVel: ", newVel.x, " ",newVel.y);

    XComp = new PVector(dir2.x,dir2.y);
    XComp.mult(-t_tempVel2.x);
    YComp = new PVector(dir2.x,dir2.y);
    YComp.rotate(-PI/2);
    YComp.mult(t_tempVel2.y);
    newVel = new PVector(XComp.x+YComp.x, XComp.y+YComp.y);
    vel2 = new PVector(newVel.x,newVel.y);

    pos1.add(vel1); 
    pos2.add(vel2);
}
