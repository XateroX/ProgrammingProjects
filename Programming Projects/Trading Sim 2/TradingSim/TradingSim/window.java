//package TradingSim;

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

    public boolean removeable;
    
    public window(int ix, int iy, TradingSim imaster)
    {
        gPos = new int[2];
        gPos[0] = ix;
        gPos[1] = iy;
        master = imaster;

        windowWidth  = 300;
        windowHeight = 300;
        bufferAmt = windowWidth/10;

        boolean smallestLabelFound =  true;
        if (master.windows.size() == 0){
            label = 1;
        }
        else{
            for (int i = 1; i <= master.windows.size()+1; i++)
            {
                smallestLabelFound = true;
                for (int j = 0; j < master.windows.size(); j++)
                {
                    if (master.windows.get(j).label == i){
                        smallestLabelFound = false;
                        break;
                    }
                }
                if (smallestLabelFound){
                    label = i;
                    //System.out.println(i);
                    break;
                }
            }
        }

        currentWindow = false;
        beingDragged = false;
        removeable = false;
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
