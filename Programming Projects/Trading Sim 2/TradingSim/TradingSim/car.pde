//package TradingSim;

import java.awt.Graphics;
import java.util.ArrayList;

import java.awt.Point;

public class car {
    TradingSim master;

    String homeName;
    String targetName;

    int[]  gPos;
    int[] tgPos;
    Double roadDouble;
    Double carSize;


    // Resources
    Double[] resources;


    // State
    boolean alive;

    public car(int x, int y, TradingSim masteri){
        // (starting) Grid position of the car
        gPos = new int[2];
        gPos[0] = x;
        gPos[1] = y;

        // (target final) grid position of the car (initally car has no target, it is the same as its current posiiton)
        tgPos = new int[2];
        tgPos[0] = x;
        tgPos[1] = y;

        roadDouble = 0.0D;
        carSize = 1.0D;

        homeName   = "";
        targetName = "";

        master = masteri;

        resources = new Double[master.nResources];

        alive = true;
    }

    public void drawMe(Graphics g){
        master.pushMatrix();

        // translate to the 'current' position of the car (as a fraction of the separation between the current and the goal grid points)
        Double xsep = (tgPos[0] - gPos[0])*master.getCurrentSidelen()*roadDouble;
        Double ysep = (tgPos[1] - gPos[1])*master.getCurrentSidelen()*roadDouble;
        master.translate(g, master.intify(xsep), master.intify(ysep));

        g.setColor(master.red);
        carSize = master.getCurrentSidelen()/10.0D;
        master.translate(g,-carSize/2,-carSize/2);
        g.fillOval(0, 0, master.intify(carSize), master.intify(carSize));
        master.popMatrix(g);

        if (master.withinObservedTiles(gPos[0],gPos[1]) && master.getCurrentSidelen() >= master.getWidth()/20)
        { drawResourceWindow(g); }
    }

    private void drawResourceWindow(Graphics g) {
        master.pushMatrix();

        master.translate(g,master.getCurrentSidelen()/2,-master.getCurrentSidelen()/2);

        Double xsep = (tgPos[0] - gPos[0])*master.getCurrentSidelen()*roadDouble;
        Double ysep = (tgPos[1] - gPos[1])*master.getCurrentSidelen()*roadDouble;
        master.translate(g, master.intify(xsep), master.intify(ysep));

        g.setColor(master.niceBlue);
        //g.fillRect(0,0, master.nResources*master.getWidth()/20, master.getWidth()/10);
        g.drawImage(master.coinImage, 0,0, null);
        master.translate(g, 250,250);
        g.drawImage(master.breadImage, 0,0, null);

        master.popMatrix(g);

        //System.out.println("Drawing the resource box");
    }

    public void iterate() {
        roadDouble += 1/(60.0D);

        // Resetting the cars position to be ahead in its journey by one tile
        if (roadDouble >= 1){
            roadDouble = 0.0D;
            gPos[0] = tgPos[0];
            gPos[1] = tgPos[1];

            Tile target_city = master.getCity(targetName);
            if (target_city.gPos[0] == gPos[0] && target_city.gPos[1] == gPos[1]){
                homeName = targetName;
                System.out.println("        Arrived");
            }
            else{
                ArrayList<cityFlag> currentTileCityFlags = new ArrayList<cityFlag>();
                if (master.grid[gPos[0]][gPos[1]].getClass() != (new city(-1,-1,master)).getClass())
                {
                    currentTileCityFlags = master.grid[gPos[0]][gPos[1]].cityFlags;
                }
                else{
                    currentTileCityFlags = getNeighbouringCityFlags(gPos[0],gPos[1]);
                }
                for (int i = 0; i < currentTileCityFlags.size(); i++)
                { 
                    //System.out.println("homeName      "  + homeName);
                    //System.out.println("nameA         "    + currentTileCityFlags.get(i).nameA);
                    //System.out.println("targetName    " + targetName);
                    //System.out.println("nameB         " + currentTileCityFlags.get(i).nameB);
                    if (currentTileCityFlags.get(i).nameA.equals(homeName)){
                        if (currentTileCityFlags.get(i).nameB.equals(targetName)){
                            int newDir = currentTileCityFlags.get(i).b;

                            if (newDir == 0){
                                tgPos[0] += -1;
                                tgPos[1] += 0;
                                //System.out.println("LEFT");
                                break;
                            }
                            else if (newDir == 1){
                                tgPos[0] += 0;
                                tgPos[1] += -1;
                                //System.out.println("UP");
                                break;
                            }
                            else if (newDir == 2){
                                tgPos[0] += 1;
                                tgPos[1] += 0;
                                //System.out.println("RIGHT");
                                break;
                            }
                            else if (newDir == 3){
                                tgPos[0] += 0;
                                tgPos[1] += 1;
                                //System.out.println("DOWN");
                                break;
                            }
                        }
                    } 
                    else if (currentTileCityFlags.get(i).nameB.equals(homeName)){
                        if (currentTileCityFlags.get(i).nameA.equals(targetName)){
                            int newDir = currentTileCityFlags.get(i).a;

                            if (newDir == 0){
                                tgPos[0] += -1;
                                tgPos[1] += 0;
                                //System.out.println("2LEFT");
                                break;
                            }
                            else if (newDir == 1){
                                tgPos[0] += 0;
                                tgPos[1] += -1;
                                //System.out.println("2UP");
                                break;
                            }
                            else if (newDir == 2){
                                tgPos[0] += 1;
                                tgPos[1] += 0;
                                //System.out.println("2RIGHT");
                                break;
                            }
                            else if (newDir == 3){
                                tgPos[0] += 0;
                                tgPos[1] += 1;
                                //System.out.println("2DOWN");
                                break;
                            }
                        }
                    } 
                }
                //System.out.println("gPos[0]   " + gPos[0] + "     tgPos[0]   " + tgPos[0]);
                //System.out.println("gPos[1]   " + gPos[1] + "     tgPos[1]   " + tgPos[1]);
            }
            //System.out.println(homeName.equals(targetName));
            if (homeName.equals(targetName)){
                alive = false;
                //System.out.println("Dead now");
            }
        }
    }

    public ArrayList<cityFlag> getNeighbouringCityFlags(int x, int y) {
        ArrayList<cityFlag> flags = new ArrayList<cityFlag>();
        if (x+1 <= master.gridw-1){
            for (int i = 0; i < master.grid[x+1][y].cityFlags.size(); i++)
            {
                flags.add( master.grid[x+1][y].cityFlags.get(i) );
            }
        }
        if (x-1 >= 0){
            for (int i = 0; i < master.grid[x-1][y].cityFlags.size(); i++)
            {
                flags.add( master.grid[x-1][y].cityFlags.get(i) );
            }
        }
        if (y+1 <= master.gridh-1){
            for (int i = 0; i < master.grid[x][y+1].cityFlags.size(); i++)
            {
                flags.add( master.grid[x][y+1].cityFlags.get(i) );
            }
        }
        if (y-1 >= 0){
            for (int i = 0; i < master.grid[x][y-1].cityFlags.size(); i++)
            {
                flags.add( master.grid[x][y-1].cityFlags.get(i) );
            }
        }
        //System.out.println(flags.size());
        return flags;
    }
}
