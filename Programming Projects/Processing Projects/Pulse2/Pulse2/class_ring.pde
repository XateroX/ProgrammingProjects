class ring
{
    PVector ringCenter;
    float   ringRadius;
    float   maxRadius;
    float   ringThickness;
    float   growSpeed;

    boolean hitTarget;
    boolean shrinking;
    boolean dead;

    color col;

    ring(PVector ipos)
    {
        ringCenter = new PVector();
        ringCenter.x = ipos.x;ringCenter.y=ipos.y;

        ringRadius    = 0;
        maxRadius     = 0;
        ringThickness = ringRadius/20.0;
        growSpeed     = 15;

        dead      = false;
        hitTarget = false;
        shrinking = false;

        col = color(255,0,255);
    }

    void draw()
    {
        pushMatrix();
        pushStyle();
        
        if (!hitTarget)
        {
            noFill();
            strokeWeight(ringThickness);
            colorMode(HSB);
            stroke(hue(col), saturation(col),brightness(col));
            translate(ringCenter.x,ringCenter.y);
            ellipse(0,0, 2*ringRadius,2*ringRadius);

            for (int i = 0; i < 5; i++)
            {
                noFill();
                strokeWeight((ringThickness*0.9)*(1.0-(float)i/5.0));
                colorMode(HSB);
                stroke((sin((i*PI/3)*(float)frameCount/60.0)*hue(col)/4) + hue(col), saturation(col),brightness(col), 100);
                //translate(ringCenter.x,ringCenter.y);
                ellipse(0,0, 2*ringRadius,2*ringRadius);
            }
        }else {
            noFill();
            strokeWeight(ringThickness);
            stroke(255*(ringRadius/maxRadius),255*(ringRadius/maxRadius));
            translate(ringCenter.x,ringCenter.y);
            ellipse(0,0, 2*ringRadius,2*ringRadius);
        }

        
        popStyle();
        popMatrix();
    }
    void setup()
    {
        ringCenter    = new PVector( random(0,width),random(3*height/4,height) );
        
    }
    void update()
    {
        if (hitTarget && !shrinking)
        {
            maxRadius = ringRadius;
            shrinking = true;
            growSpeed *= 4;
        }

        if (shrinking)
        {
            ringRadius    -= growSpeed;
            ringThickness  = ringRadius/20.0;
            if (ringThickness < 0)
            {
                dead = true;
            }
        }
        else{
            ringRadius    += growSpeed;
            ringThickness  = ringRadius/20.0;
        }
    }
    void mousePressed(){}
    void mouseReleased(){}
    void keyPressed(){}
    void keyReleased(){}
}