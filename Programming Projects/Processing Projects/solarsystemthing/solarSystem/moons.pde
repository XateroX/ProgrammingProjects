class moon extends celestialBody{
    //pass

    moon(String name, PVector col, PVector pos, PVector vel, PVector acc, float m, float r){
        super(name, col, pos, vel, acc, m, r);
    }

    @Override
    void display(){
        displayTrail();
        displayBody();     
    }
    void displayBody(){
        pushStyle();
        pushMatrix();

        float pixelRadius = toPixelConversion(r);
        float minRes = 10.0;

        noStroke();
        translate( toPixelConversion(pos.x), toPixelConversion(pos.y), toPixelConversion(pos.z) );
        if(pixelRadius > minRes){
            fill(col.x, col.y, col.z,255);
            sphere( pixelRadius );
            displayStats();
        }
        else{
            fill(col.x, col.y, col.z,120);
            ellipse(0,0, minRes,minRes);
        }

        popMatrix();
        popStyle();
    }
}