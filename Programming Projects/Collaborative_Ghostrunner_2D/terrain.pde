class terrain
{
    ArrayList<PVector> pieces;

    terrain(PVector iorigin, int polyCount)
    {
        pieces = new ArrayList<PVector>();
        pieces.add( new PVector(iorigin.x, iorigin.y) );

        dir = new PVector(random(-30,30),random(-30,30));
        for (int i = 0; i < polyCount; ++i) {
            PVector newPiece = new PVector(0,0);
            newPiece.x = pieces.get(pieces.size()-1).x + dir.x;
            newPiece.y = pieces.get(pieces.size()-1).y + dir.y;
            dir.rotate(0.03);
            println(dir);
            pieces.add(newPiece);
        }
    }

    void drawMe()
    {
        pushStyle();
        pushMatrix();
        
        stroke(0,0,255);
        strokeWeight(10);
        for (int i = 1; i < pieces.size()-1; i++) {
            PVector p1 = pieces.get(i);
            PVector p2 = pieces.get(i+1);
            line(p1.x,p1.y,p2.x,p2.y); 
        }
        
        popMatrix();
        popStyle();
    }
}
