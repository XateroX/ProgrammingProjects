class target
{
    PVector targetCenter;
    float   targetRadius;
    boolean dead;
    color   col;
    float targetThickness;

    target(PVector ipos)
    {
        targetCenter    = new PVector();
        targetCenter.x  = ipos.x; targetCenter.y = ipos.y; 
        targetRadius    = width/40;
        targetThickness = width/100;

        col = color(random(0,255),random(0,255),random(0,255));
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        strokeWeight(targetThickness);

        colorMode(HSB,255,255,255);    
        stroke(hue(col),saturation(col),brightness(col));
        translate(targetCenter.x,targetCenter.y);
        ellipse(0,0, 2*targetRadius,2*targetRadius);
        
        popStyle();
        popMatrix();
    }
    void setup()
    {

    }
    void mousePressed(ArrayList<ring> rings)
    {
        println("mousePressed : target");
        for (ring c_ring : rings)
        {
            if (intersecting(c_ring) && !c_ring.dead && !c_ring.shrinking)
            {
                dead = true;
                println("dead");
                c_ring.hitTarget = true;
            }
        }
    }
    void mouseReleased(){}
    void keyPressed(){}
    void keyReleased(){}

    boolean intersecting(ring c_ring)
    {
        if ( dist(c_ring.ringCenter.x,c_ring.ringCenter.y,   targetCenter.x,targetCenter.y) < c_ring.ringRadius+c_ring.ringThickness+targetThickness 
        &&   dist(c_ring.ringCenter.x,c_ring.ringCenter.y,   targetCenter.x,targetCenter.y) > c_ring.ringRadius-c_ring.ringThickness+targetThickness)
        {
            return true;
        }
        return false;
    }

    boolean intersectingWithAny(ArrayList<ring> rings)
    {
        for (ring c_ring : rings)
        {
            if (intersecting(c_ring))
            {
                return true;
            }
        }
        return false;
    }
}