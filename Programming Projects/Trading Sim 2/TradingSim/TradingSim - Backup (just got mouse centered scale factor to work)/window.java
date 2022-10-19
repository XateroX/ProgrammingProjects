package TradingSim;

import java.awt.Color;
import java.awt.Graphics;

public class window {
    // Master class
    TradingSim master;

    // Window Parameters
    int[] gPos;
    int windowWidth;
    int windowHeight;
    int bufferAmt;
    
    int label;
    boolean currentWindow;
    boolean beingDragged;
    
    public window(int ix, int iy, TradingSim imaster)
    {
        gPos = new int[2];
        gPos[0] = ix;
        gPos[1] = iy;
        master = imaster;

        windowWidth  = 300;
        windowHeight = 300;
        bufferAmt = windowWidth/10;

        label = master.latestLabel;

        currentWindow = false;
        beingDragged = false;
    }

    public void drawWindow(Graphics g)
    {
        if (currentWindow){
            gPos[0] = master.MouseXY().x + master.mouseCurrentWindowOffset.x;
            gPos[1] = master.MouseXY().y + master.mouseCurrentWindowOffset.y;
        }

        master.pushMatrix();

        master.translate(g, gPos[0] - bufferAmt/2, gPos[1] - bufferAmt/2);
        g.setColor(new Color(100,100,100,220));
        g.fillRect(0,0, windowWidth + bufferAmt, windowHeight + 2*bufferAmt);

        drawContents(g);

        master.popMatrix(g);
    }
    public void drawContents(Graphics g)
    {
        System.out.println("-- Draw contents --");
    }
    public boolean overlapping()
    {
        if (master.MouseXY().x > gPos[0] && master.MouseXY().x < gPos[0]+windowWidth){
            if (master.MouseXY().y > gPos[1] && master.MouseXY().y < gPos[1]+windowHeight){
                return true;
            }
        }
        return false;
    }
}
