//package TradingSim;

/**
 * Tile
 */

import java.awt.Graphics;
import java.awt.Point;
import java.util.ArrayList;

/**
 * Tile
 */
public class Tile {
    String name;

    int[] gPos;
    TradingSim master;
    Boolean cursorHovered; 

    // Roads
    Boolean hasRoad;
    Point roadConnection;
    ArrayList<cityFlag> cityFlags;

    public Tile(int ix,int iy, TradingSim imaster)
    {
        gPos = new int[2];
        gPos[0] = ix;
        gPos[1] = iy;

        master = imaster;
        cursorHovered = false;

        hasRoad = false;
        roadConnection = new Point(-1,-1);

        cityFlags = new ArrayList<cityFlag>();
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

    public void drawRoads(Graphics g)
    {
        master.pushMatrix();

        // UL Corner
        master.translate(g, -master.getCurrentSidelen()/2, -master.getCurrentSidelen()/2);

        // ML edge
        master.translate(g, 0, master.getCurrentSidelen()/2);
        
        // Slightly up ML edge
        master.translate(g, 0, -master.getCurrentSidelen()/5);

        // Middle Cube
        g.setColor(master.yellow);
        master.pushMatrix();
        master.translate(g, master.intify(1.5*master.getCurrentSidelen()/5), 0);
        g.fillRect(0,0, 2*master.getCurrentSidelen()/5,2*master.getCurrentSidelen()/5);
        master.popMatrix(g);
        
        master.translate(g, master.getCurrentSidelen()/2, master.getCurrentSidelen()/5);
        
        /*
        master.pushMatrix();
        // L>M
        if (roadConnection.x == 0){
            master.translate(g, -master.getCurrentSidelen()/2, -master.getCurrentSidelen()/5);
            g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);
        }
        // U>M
        else if (roadConnection.x == 1){
            master.translate(g, -master.getCurrentSidelen()/5, -master.getCurrentSidelen()/2);
            g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
        }
        // R>M
        else if (roadConnection.x == 2){
            master.translate(g, master.getCurrentSidelen()/5, -master.getCurrentSidelen()/5);
            g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);
        }
        // D>M
        else if (roadConnection.x == 3){
            master.translate(g, -master.getCurrentSidelen()/5, master.getCurrentSidelen()/5);
            g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
        }
        master.popMatrix(g);



        master.pushMatrix();
        // M>L
        if (roadConnection.y == 0){
            master.translate(g, -master.getCurrentSidelen()/2, -master.getCurrentSidelen()/5);
            g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);
        }
        // M>U
        else if (roadConnection.y == 1){
            master.translate(g, -master.getCurrentSidelen()/5, -master.getCurrentSidelen()/2);
            g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
        }
        // M>R
        else if (roadConnection.y == 2){
            master.translate(g, master.getCurrentSidelen()/5, -master.getCurrentSidelen()/5);
            g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);
        }
        // M>D
        else if (roadConnection.y == 3){
            master.translate(g, -master.getCurrentSidelen()/5, master.getCurrentSidelen()/5);
            g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
        }
        master.popMatrix(g);
        */

        for (int i = 0; i < cityFlags.size(); i++)
        {
            master.pushMatrix();
            cityFlag c_flag = new cityFlag(-1, -1, "", "");
            c_flag.a     = cityFlags.get(i).a;
            c_flag.b     = cityFlags.get(i).b;
            c_flag.nameA = cityFlags.get(i).nameA;
            c_flag.nameB = cityFlags.get(i).nameB;

            if (c_flag.a==0||c_flag.b==0)
            {
                master.pushMatrix();
                master.translate(g, -master.getCurrentSidelen()/2, -master.getCurrentSidelen()/5);
                g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);    
                master.popMatrix(g);
            }
            if (c_flag.a==1||c_flag.b==1)
            {
                master.pushMatrix();
                master.translate(g, -master.getCurrentSidelen()/5, -master.getCurrentSidelen()/2);
                g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
                master.popMatrix(g);
            }
            if (c_flag.a==2||c_flag.b==2)
            {
                master.pushMatrix();
                master.translate(g, master.getCurrentSidelen()/5, -master.getCurrentSidelen()/5);
                g.fillRect(0,0, master.intify(1.5*master.getCurrentSidelen()/5),2*master.getCurrentSidelen()/5);
                master.popMatrix(g);
            }
            if (c_flag.a==3||c_flag.b==3)
            {
                master.pushMatrix();
                master.translate(g, -master.getCurrentSidelen()/5, master.getCurrentSidelen()/5);
                g.fillRect(0,0, 2*master.getCurrentSidelen()/5,master.intify(1.5*master.getCurrentSidelen()/5));
                master.popMatrix(g);
            }
            master.popMatrix(g);
        }
        
        master.popMatrix(g); 
    }

    public void drawName(Graphics g){}

    public void addCityFlag(int a, int b, String nameA, String nameB){
        boolean shouldAdd = true;
        for (int i = 0; i < cityFlags.size(); i++){
            cityFlag c_flag = new cityFlag(-1,-1,"","");
            c_flag.a     = cityFlags.get(i).a;
            c_flag.b     = cityFlags.get(i).b;
            c_flag.nameA = cityFlags.get(i).nameA;
            c_flag.nameB = cityFlags.get(i).nameB;
            if (c_flag.a == a && c_flag.b == b && c_flag.nameA.equals(nameA) && c_flag.nameB.equals(nameB)){
                shouldAdd = false;
                break;
            }
        }
        if (shouldAdd){cityFlags.add( new cityFlag(a,b,nameA,nameB) );}
    }

    public void sendCarTo(String targetCity){}
}
