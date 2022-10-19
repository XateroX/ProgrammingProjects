//package TradingSim;
import java.awt.Point;
import java.awt.Graphics;

public class gridWindow extends window {
    Point startingGridPoint;
    Point endingGridPoint;

    public gridWindow(int ix, int iy, TradingSim imaster, Point startingPoint, Point endingPoint)
    {
        super(ix, iy, imaster);
        startingGridPoint = new Point(0,0);
        startingGridPoint.x = startingPoint.x;
        startingGridPoint.y = startingPoint.y;
        endingGridPoint = new Point(0,0);
        endingGridPoint.x = endingPoint.x;
        endingGridPoint.y = endingPoint.y;
    }

    @Override
    public void drawContents(Graphics g)
    {
        master.pushMatrix();
        master.translate(g,windowWidth/10,0);
        for (int i = 0; i < label; i++){
            master.translate(g, (8*windowWidth/10)/(label+1), 0);
            g.setColor(master.black);
            g.fillOval(-5,-5, 30, 30);
            g.setColor(master.white);
            g.fillOval(0,0, 20, 20);
        }
        
        master.popMatrix(g);


        master.translate(g, bufferAmt/2, 3*bufferAmt/2);

        if (currentWindow && !beingDragged){
            endingGridPoint.x = master.hoveredGridPoint().x;
            endingGridPoint.y = master.hoveredGridPoint().y;
        }

        master.pushMatrix();
        int ax = 0;
        int bx = 0;

        int ay = 0;
        int by = 0;

        if (startingGridPoint.x < endingGridPoint.x)
        {
            ax = startingGridPoint.x;
            bx = endingGridPoint.x;
        }else
        {
            ax = endingGridPoint.x;
            bx = startingGridPoint.x;
        }

        if (startingGridPoint.y < endingGridPoint.y)
        {
            ay = startingGridPoint.y;
            by = endingGridPoint.y;
        }else
        {
            ay = endingGridPoint.y;
            by = startingGridPoint.y;
        }

        if (by-ay > bx-ax){
            bx = ax+(by-ay);
        }else{
            by = ay+(bx-ax);
        }

        Double scalefactor;
        if (bx-ax < by-ay){
            scalefactor = (1.0D*windowWidth/(bx-ax+1)) / master.getCurrentSidelen(false);
        }else{
            scalefactor = (1.0D*windowHeight/(by-ay+1)) / master.getCurrentSidelen(false);
        }
        
        Double previousScaleValue = master.scaleValue;
        master.setScaleValue(scalefactor);

        master.translate(g, master.getCurrentSidelen()/2, master.getCurrentSidelen()/2);
        for (int x = ax; x <= bx; x++){
            master.pushMatrix();
            for (int y = ay; y <= by; y++){
                master.grid[x][y].drawMe(g);
                master.translate(g,0,windowHeight/(by-ay+1));
            }
            master.popMatrix(g);
            master.translate(g,windowWidth/(bx-ax+1),0); 
        }
        master.popMatrix(g);


        master.pushMatrix();
        master.translate(g, master.getCurrentSidelen()/2, master.getCurrentSidelen()/2);
        master.draw_cars(g, ax, bx, ay, by, windowHeight/(by-ay+1.0));
        master.popMatrix(g);

        master.setScaleValue(previousScaleValue);
    }
}
