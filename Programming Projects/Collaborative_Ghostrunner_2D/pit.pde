class pit
{
    PVector center;
    float w;  //Width  of pit
    float h;  //Height of pit

    pit(PVector icenter, float iw, float ih)
    {
        center = new PVector(0,0);
        center.x = icenter.x;
        center.y = icenter.y;

        w = iw;
        h = ih;
    }

    void drawMe()
    {
        pushMatrix();
        pushStyle();

        noStroke();
        fill(100,0,0);
        translate(center.x,center.y);
        rect(0,0,w,h);

        popStyle();
        popMatrix();
    }
}