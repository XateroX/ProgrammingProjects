//package TradingSim;

import java.awt.Graphics;

public class ocean extends Tile{

    public ocean(int ix, int iy, TradingSim imaster) {
        //TODO Auto-generated constructor stub
        super(ix, iy, imaster);
    }

    @Override
    public void drawMe(Graphics g)
    {
        master.pushMatrix();
        int sidelen = master.getCurrentSidelen();
        Double strokeWidth = master.getWidth()/1000.0D;
        if (strokeWidth > master.getHeight()/1000.0D)
        {strokeWidth = master.getHeight()/1000.0D;}

        master.translate(g, -sidelen/2,-sidelen/2);
        if (master.stroke)
        {
            g.setColor(master.gray);
            g.fillRect(0,0, sidelen,sidelen);
            g.setColor(master.oceanBlue);
            master.translate(g,master.intify(strokeWidth/2),master.intify(strokeWidth/2));
            g.fillRect(0,0, master.intify(sidelen - strokeWidth),master.intify(sidelen - strokeWidth));
        }else
        {
            g.setColor(master.oceanBlue);
            g.fillRect(0,0, sidelen,sidelen);
        }
        master.popMatrix(g);
        master.pushMatrix();
        if (cursorHovered)
        {
            drawHoveredCursor(g);
        }
        if (hasRoad)
        {
            drawRoads(g);
        }
        master.popMatrix(g);
    }
}
