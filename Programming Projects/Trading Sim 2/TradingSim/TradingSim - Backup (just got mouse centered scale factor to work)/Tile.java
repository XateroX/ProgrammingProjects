package TradingSim;

import java.awt.Color;

/**
 * Tile
 */

import java.awt.Graphics;

/**
 * Tile
 */
public class Tile {
    int[] gPos;
    TradingSim master;
    Boolean cursorHovered; 

    public Tile(int ix,int iy, TradingSim imaster)
    {
        gPos = new int[2];
        gPos[0] = ix;
        gPos[0] = iy;

        master = imaster;
        cursorHovered = false;
    }

    public void drawMe(Graphics g)
    {
        System.out.println("Hello!");
    }
    public void drawHoveredCursor(Graphics g)
    {
        int sidelen = master.getCurrentSidelen();

        master.pushMatrix();
        master.translate(g, -sidelen/2,-sidelen/2);
        g.setColor(master.gray);

        g.fillRect(0,0, sidelen/10, sidelen/3);
        g.fillRect(0,0, sidelen/3, sidelen/10);

        master.translate(g, sidelen - sidelen/10,0);

        g.fillRect(0,0, sidelen/10, sidelen/3);
        master.translate(g, sidelen/10,0);
        master.translate(g, -sidelen/3,0);
        g.fillRect(0,0, sidelen/3, sidelen/10);
        master.translate(g, sidelen/3,0);

        master.translate(g, -sidelen/10,sidelen - sidelen/3);

        g.fillRect(0,0, sidelen/10, sidelen/3);
        master.translate(g, sidelen/10 - sidelen/3,sidelen/3-sidelen/10);
        g.fillRect(0,0, sidelen/3,sidelen/10);
        master.translate(g, sidelen/3,sidelen/10);


        master.translate(g, -sidelen,-sidelen/10);
        g.fillRect(0,0, sidelen/3, sidelen/10);
        master.translate(g, 0,sidelen/10-sidelen/3);
        g.fillRect(0,0, sidelen/10, sidelen/3);

        master.popMatrix(g);
    }
}
