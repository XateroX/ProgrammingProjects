class bullet
{
    PVector pos;
    PVector vel;

    float rad;

    bullet(PVector ipos, PVector ivel)
    {
        pos = new PVector(0,0);
        pos.x = ipos.x;
        pos.y = ipos.y;

        vel = new PVector(0,0);
        vel.x = ivel.x;
        vel.y = ivel.y;

        rad = 10;
    }

    void update()
    {
        pos.add(vel);
    }

    void drawMe()
    {
        pushMatrix();
        pushStyle();

        stroke(255,100,0);
        strokeWeight(10);
        float tvar = random(1,2);
        line(pos.x, pos.y, pos.x-vel.x*tvar, pos.y-vel.y*tvar);
        stroke(255,200,0);
        strokeWeight(6);
        tvar = random(0.5,1);
        line(pos.x, pos.y, pos.x-vel.x*tvar, pos.y-vel.y*tvar);
        stroke(200,255,200);
        strokeWeight(2);
        tvar = random(0,0.5);
        line(pos.x, pos.y, pos.x-vel.x*tvar, pos.y-vel.y*tvar);

        stroke(0);
        strokeWeight(1);

        fill(255,0,0);
        ellipse(pos.x,pos.y,rad,rad);
        

        popStyle();
        popMatrix();
    }
}
