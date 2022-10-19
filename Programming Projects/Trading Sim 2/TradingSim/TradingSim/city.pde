//package TradingSim;

import java.awt.Graphics;
import java.awt.Point;
import java.util.ArrayList;

import java.awt.Font;

public class city extends Tile{
    public city(int ix, int iy, TradingSim imaster) {
        //TODO Auto-generated constructor stub
        super(ix, iy, imaster);
        name = randomCityName();
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
            master.translate(g,master.intify(strokeWidth/2),master.intify(strokeWidth/2)+1);
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
        drawName(g);
    }

    @Override
    public void drawName(Graphics g){
        Font sanSerifFont = new Font("SanSerif", Font.PLAIN, master.getCurrentSidelen()/4);
        master.pushMatrix();
        g.setColor(master.black);
        g.setFont(sanSerifFont);
        master.translate(g,master.intify(master.getCurrentSidelen()*0.20) - master.getCurrentSidelen()/2,master.getCurrentSidelen()/8);

        // If zoomed in enough, draw the names of the cities
        if (master.getCurrentSidelen() >= master.getWidth()/40){
            g.drawString(name, 0,0);
        }
        master.popMatrix(g);
    }

    public String randomCityName(){
        String[] consonants = new String[] {"b","c","d","f","g","h","j","k","m","n","p","q","r","s","t","v","w","x","y","z"};
        String[] vowels     = new String[] {"a","e","i","o","u"};
        ArrayList<String> cityName = new ArrayList<String>();
        cityName.add( consonants[(int)Math.round(Math.ceil(Math.random()*(consonants.length/2-1) ))]);
        cityName.add( vowels[(int)Math.round(Math.ceil(Math.random()*(vowels.length-1) ))]);
        int nameLength = 2+(int)Math.round(Math.random()*3);
        for (int i = 0; i < nameLength-2; i++){
            if (Math.random() < 0.75){
                cityName.add( consonants[(int)Math.round(Math.ceil(Math.random()*(consonants.length-1) ))]);
            }else{
                cityName.add( vowels[(int)Math.round(Math.ceil(Math.random()*(vowels.length-1) ))]);
            }
        }
        cityName.add( consonants[(int)Math.round(Math.ceil(Math.random()*(consonants.length-1) ))]);

        String finalName = "";
        for (int i = 0; i < cityName.size(); i++){
            finalName = finalName+cityName.get(i);
        }
        return finalName;
    }

    @Override
    public void sendCarTo(String targetCity){
        master.cars.add( new car(gPos[0],gPos[1],master) );
        ArrayList<cityFlag> flags = new ArrayList<cityFlag>();
        flags = master.cars.get(master.cars.size()-1).getNeighbouringCityFlags(gPos[0],gPos[1]);
        if (containsCityName(flags, targetCity))
        {
            master.cars.get(master.cars.size()-1).homeName   = name;   
            master.cars.get(master.cars.size()-1).targetName = targetCity;    
        }else{
            master.cars.remove(master.cars.size()-1);
        }
    }

    public boolean containsCityName(ArrayList<cityFlag> flags, String cityName){
        for (int i = 0; i < flags.size(); i++)
        {
            if (flags.get(i).nameA.equals(cityName) || flags.get(i).nameB.equals(cityName)){
                return true;
            }
        }
        return false;
    }
    
}
