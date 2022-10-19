package TradingSim;

import java.awt.Graphics;

public class hardLand extends Tile{
    public hardLand(int ix, int iy, TradingSim imaster)
    {
        super(ix,iy,imaster);
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

            g.setColor(master.hardGrassGreen);
            master.pushMatrix();
            master.translate(g,master.intify(strokeWidth/2),master.intify(strokeWidth));
            g.fillRect(0,0, master.intify(sidelen - strokeWidth), master.intify(sidelen - strokeWidth));
            master.popMatrix(g);
        }else
        {
            g.setColor(master.grassGreen);
            g.fillRect(0,0, sidelen,sidelen);
        }
        master.popMatrix(g);
        if (cursorHovered)
        {
            drawHoveredCursor(g);
        }
    }
}
