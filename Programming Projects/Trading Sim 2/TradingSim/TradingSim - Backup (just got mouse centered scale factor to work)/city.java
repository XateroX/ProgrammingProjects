package TradingSim;

import java.awt.Graphics;

public class city extends Tile{
    public city(int ix, int iy, TradingSim imaster) {
        //TODO Auto-generated constructor stub
        super(ix, iy, imaster);
    }

    @Override
    public void drawMe(Graphics g) 
    {
        // TODO Auto-generated method stub
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

            g.setColor(master.grassGreen);
            master.pushMatrix();
            master.translate(g,master.intify(strokeWidth/2),master.intify(strokeWidth/2));
            g.fillRect(0,0, master.intify(sidelen - strokeWidth),master.intify(sidelen - strokeWidth));
            master.popMatrix(g);

            master.pushMatrix();
            g.setColor(master.white);
            master.translate(g,master.intify(sidelen*0.12),master.intify(sidelen*0.12));
            g.fillOval(0,0, master.intify(sidelen*0.75), master.intify(sidelen*0.75));
            master.popMatrix(g);
        }else
        {
            g.setColor(master.grassGreen);
            g.fillRect(0,0, sidelen,sidelen);
            g.setColor(master.white);
            g.fillOval(0,0, master.intify(sidelen*0.75), master.intify(sidelen*0.75));
        }
        master.popMatrix(g);
        if (cursorHovered)
        {
            drawHoveredCursor(g);
        }
    }

}
