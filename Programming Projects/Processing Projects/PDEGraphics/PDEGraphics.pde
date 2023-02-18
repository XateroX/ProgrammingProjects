ArrayList<PVector> points;
float pointsize;
int speedUp;

int lifetime;
int lifetime_step;

void setup()
{
    size(1000,1000);
    points    = new ArrayList<PVector>();
    pointsize = 1;

    speedUp   = 100;

    lifetime  = 3000;
    lifetime_step = 0; 

    addPoints(0.001);
    background(0);
}

void draw()
{
    //background(0);
    translate(width/2,height/2);
    for (int i = 0; i < speedUp; i++)
    {
        iteratePoints();
        drawPoints();
        lifetime_step += 1;

        if (lifetime_step > lifetime)
        {
            lifetime_step = 0;
            points = new ArrayList<PVector>();
            addPoints(0.001);
        }
    }


}

void iteratePoints()
{
    for (int i = 0; i < points.size(); i++)
    {
        PVector c_point = points.get(i);
        points.remove(i);

        PVector new_point = new PVector(c_point.x,c_point.y);
        PVector diff      = diff(c_point);
        new_point.x += diff.x;
        new_point.y += diff.y;
        points.add(i,new_point);
    }
}

PVector diff(PVector point)
{
    return new PVector(dx(point),dy(point));
}

Float dx(PVector point)
{
    float value = 0;

    float x = point.x/500;
    float y = point.y/500;

    value = 0.5*x + y - x*(pow(x,3) + pow(y,2));

    if (random(1) < 0.01)
    {
        value *= 20;
    }

    return value;
}
Float dy(PVector point)
{
    float value = 0;

    float x = point.x/500;
    float y = point.y/500;

    value = -x + 0.5*y - y*(pow(x,2) + pow(y,2));

    if (random(1) < 0.01)
    {
        value *= 20;
    }

    return value;
}   

void drawPoints()
{
    for (PVector c_point : points)
    {
        pushMatrix();
        pushStyle();

        colorMode(HSB);
        //fill(255* (1-((float)lifetime_step / (float)lifetime)), 255, 255);
        colorMode(RGB);
        fill(255);
        noStroke();
        ellipse(c_point.x,c_point.y,pointsize,pointsize);
        
        popStyle();
        popMatrix();
    }
}

void addPoints(Float prop)
{
    float n = prop;

    for (int x = -width/2; x < width/2; x++)
    {
        for (int y = -height/2; y < height/2; y++)
        {
            if (random(1) > (1-prop))
            {
                points.add( new PVector(x,y) );
                //n = 0;
            }
            //n += prop;
        }
    }
}
