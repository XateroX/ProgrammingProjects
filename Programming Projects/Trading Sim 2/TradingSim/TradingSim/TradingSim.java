package TradingSim;

import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.TargetDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.Timer;
import javax.swing.event.MouseInputListener;

import java.awt.event.MouseWheelListener;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import java.awt.GridLayout;

/**
 * TradingSim
 */
public class TradingSim extends JPanel implements ActionListener, KeyListener, MouseInputListener, MouseWheelListener{

    Timer timer = new Timer(20,this);
    static JFrame f;
    
    // Basic colors
    Color black;
    Color white;
    Color gray;
    Color yellow;
    Color red;

    // Pro colors
    Color niceRed;
    Color niceGreen;
    Color niceBlue;
    Color oceanBlue;
    Color grassGreen;
    Color hardGrassGreen;

    // Color options
    Boolean stroke;

    // Assets
    Image coinImage;
    Image breadImage;

    // Transformations
    ArrayList<Integer> T;
    ArrayList<ArrayList<Integer>> TStack;
    int[] totalDragOffset;
    int[] tempTotalDragOffset;

    // Grid transformations
    Double scaleFactor;
    Double scaleValue;



    // Trading Sim Specific Attributes
    Tile[][] grid;
    int gridw;
    int gridh;
    ArrayList<int[]> city_locs;
    ArrayList<int[]> port_locs;
    ArrayList<int[]> air_locs;
    ArrayList<car> cars;


    // Gameplay
    int nResources;


    // Properties of the world
    int city_count;
    int land_buffer_count;
    int terrain_roughness;


    // 'Gameplay' / Asthetic variables
    Boolean setupPhase;
    String MODE;
    Boolean menuOpened;


    // Misc
    int counter;


    // Input
    Boolean mouseHeld;
    Boolean draggingMap;
    int [] mouseLastClicked;
    private boolean rMouseHeld;
    private Point firstSelected;
    private Point secondSelected;
    Point mouseCurrentWindowOffset;


    // Window settings
    ArrayList<window> windows;
    int latestLabel;
    Point menu;
    Point menudims;
    protected boolean regenerate;


    // Audio
    String[] MusicStrings;
    String[] SoundEffectStrings;
    AudioFormat format;
    Clip line;
    DataLine.Info info;

    public void paint(Graphics g){

        counter++;
        clearScreen(g);

        if (MODE.equals("openingMenu"))
        {
            if (!menuOpened)
            {
                
            }
        }
        else if (MODE.equals("gameplayScreen"))
        {
            if (setupPhase)
            {generate_world();}

            if (mouseHeld && draggingMap)
            {
                Double sfAdj = 1.0D;//getScaleFactor();
                tempTotalDragOffset[0] = intify(sfAdj*(MouseXY().x - mouseLastClicked[0]));
                tempTotalDragOffset[1] = intify(sfAdj*(MouseXY().y - mouseLastClicked[1]));
            }

            if (rMouseHeld){
                secondSelected = hoveredGridPoint();
                if (secondSelected.x - firstSelected.x > secondSelected.y - firstSelected.y){
                    secondSelected.y = firstSelected.y + (secondSelected.x - firstSelected.x);
                }else{
                    secondSelected.x = firstSelected.x + (secondSelected.y - firstSelected.y);
                }
                draw_selection_box(g);
            }
            
            if (Math.random() < 0.1){
                for (int i = 0; i < city_locs.size(); i++)
                {
                    int[] randomCity = city_locs.get( intify(Math.random()*(city_locs.size()-1)) );
                    grid[city_locs.get(i)[0]][city_locs.get(i)[1]].sendCarTo(grid[randomCity[0]][randomCity[1]].name);   
                }
            }
            iterateCarLogic();

            draw_grid(g);
            setCursorTile();

            draw_cars(g);
            draw_windows(g);
            cull_windows();
            cull_cars();
            

            draw_menu_button(g);
        }
    }

    private void iterateCarLogic() {
        for (int i = 0; i < cars.size(); i++)
        {
            cars.get(i).iterate();
        }
    }

    private void draw_menu_button(Graphics g) {
        menudims = new Point(getWidth()/10,              intify(0.3*getWidth()/10));
        menu     = new Point(getWidth()/2 - menudims.x/2,intify(0.3*getWidth()/10) - menudims.y/2);

        pushMatrix();

        translate(g,menu.x,menu.y-menudims.y/2);
        g.setColor(black);
        g.fillRect(0,0, menudims.x,menudims.y);
        
        popMatrix(g);
    }

    public TradingSim()
    {
        MusicStrings  = new String[3];
        MusicStrings[0] = "/resources/" + "GeneralMusic"   + ".wav";
        MusicStrings[1] = "/resources/" + "AlienHiveMusic" + ".wav";
        MusicStrings[2] = "/resources/" + "MidgameMusic"   + ".wav";

        SoundEffectStrings = new String[1];
        SoundEffectStrings[0] = "/resources/" + "ClickSound" + ".wav";

        playMusic(0);

        menudims = new Point(getWidth()/20,              getHeight()/40);
        menu     = new Point(getWidth()/2 - menudims.x/2,getHeight()/2 - menudims.y/2);

        MODE = "";
        gridw = 30;
        gridh = 30;
        grid = new Tile[gridw][gridh];

        T = new ArrayList<Integer>(2); T.add(0); T.add(0);
        TStack = new ArrayList<ArrayList<Integer>>();

        setupSwingWindow();
        setColors();
        setInputParameters();
        setWorldProperties();
        loadAssets();

        menuOpened = true;
        regenerate = true;
        
        totalDragOffset = new int[2];
        totalDragOffset[0] = getWidth()/2 - gridw*getCurrentSidelen()/2; 
        totalDragOffset[1] = getHeight()/2 - gridw*getCurrentSidelen()/2;

        ArrayList<Tile> tileList = new ArrayList<Tile>();
        tileList.add( new city(1,1, this) );

        Tile[][] tileActualList = new Tile[1][1];
        tileActualList[0][0] = new city(1,1, this);

        windows = new ArrayList<window>();
        latestLabel = 1;

        OpenMenu();

        grid = new Tile[gridw][gridh];
        create_grid_skeleton();

        nResources = 2;
    }

    private void loadAssets() {
        BufferedImage img = null;
        try {
            img = ImageIO.read(new File("/resources/"+"GoldCoin"+".png"));
        } catch (IOException e) {
            print(e);
            print("Couldnt load img");
        }
        coinImage = img;

        img = null;
        try {
            img = ImageIO.read(new File("/resources/"+"Bread"+".png"));
        } catch (IOException e) {
            print(e);
            print("Couldnt load img");
        }
        breadImage = img;

    }

    public static void main(String[] args) {
        TradingSim TradingSimInstance = new TradingSim();
    }

    private void setupSwingWindow()
    {
        addKeyListener(this);
        addMouseListener(this);
        addMouseWheelListener(this);
        setFocusable(true);
        timer.start();

        f = new JFrame();  
        f.add(this);  
        f.pack();
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //f.setLayout(new GridLayout(2,1));  
        f.setSize(1000,700);
        //f.setVisible(true); 
        f.setResizable(true);

        scaleValue  = 1.0D;
        scaleFactor = getScaleFactor();
    }




    // ---- Rendering Methods ---- //
        //BASIC//
    private void clearScreen(Graphics g)
    {
        g.setColor(white);
        g.fillRect(0,0, getWidth(), getHeight());
    }




    // ---- Core return methods ---- //
    public static int getWindowWidth()
    {
        return f.getWidth();
    }
    public static int getWindowHeight()
    {
        return f.getHeight();
        
    }


    // ---- Transformation Manipulation ---- //

    public void translate(Graphics g, Double x_trans, Double y_trans)
    {
        g.translate(intify(x_trans),intify(y_trans));
        ArrayList<Integer> dT = new ArrayList<Integer>(); dT.add(intify(x_trans));dT.add(intify(y_trans));
        T_ADD(dT);
    }
    public void translate(Graphics g, int x_trans, int y_trans)
    {
        g.translate(x_trans,y_trans);
        ArrayList<Integer> dT = new ArrayList<Integer>(); dT.add(x_trans);dT.add(y_trans);
        T_ADD(dT);
    }
    public void T_ADD(ArrayList<Integer> dT)
    {
        // Add a transformation to the overall transformation
        Integer x = T.get(0); 
        Integer y = T.get(1);
                x += dT.get(0);       
                y += dT.get(1); 
        T = new ArrayList<Integer>();
                T.add(x); T.add(y);

    }
    public void pushMatrix()
    {
        TStack.add(T);
    }
    public void popMatrix(Graphics g)
    {
        ArrayList<Integer> summand = new ArrayList<Integer>(); summand.add(0); summand.add(0);
        summand.set(0, TStack.get(TStack.size()-1).get(0));
        summand.set(1, TStack.get(TStack.size()-1).get(1));

        summand.set(0, summand.get(0) - T.get(0));
        summand.set(1, summand.get(1) - T.get(1));
        translate(g,summand.get(0),summand.get(1));
        TStack.remove(TStack.size()-1);
    }

    public void setScaleValue(Double nScaleValue)
    {
        scaleValue = nScaleValue;
    }
    public Double getScaleFactor()
    {
        Double tScaleFactor = 1.0D;
        if (scaleValue <= 0)
        {
            tScaleFactor = 1/(Math.abs(scaleValue)+1);
        }else
        {
            tScaleFactor = scaleValue;
        }
        return tScaleFactor; 
    }


    // ---- Input ---- //

    // ---Keyboard--- //
    @Override
    public void keyTyped(KeyEvent e) {
        // TODO Auto-generated method stub
        //System.out.println("Typed: " + e.getKeyChar());
    }

    @Override
    public void keyPressed(KeyEvent e) {
        // TODO Auto-generated method stub
        //System.out.println("Pressed: " + e.getKeyChar());
        if (e.getKeyChar() == 'd'){
            for (window c_window : windows){
                if (c_window.beingDragged){
                    c_window.removeable = true;
                    break;
                }
            }
        }
    }

    @Override
    public void keyReleased(KeyEvent e) {
        // TODO Auto-generated method stub
        //System.out.println("Released: " + e.getKeyChar());
    }

    @Override
    public void actionPerformed(ActionEvent e) {
            // Should only do this every so often or even not at all to start with
        repaint();
    }

    // ---Mouse---//
    @Override
    public void mouseClicked(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Clicked---");
    }

    @Override
    public void mousePressed(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("     Mouse Pressed at: " + MouseXY().x + "   " + MouseXY().y);
        if (e.getButton() == 1){
            playSound(0);
            if (overlappingMenu()){
                OpenMenu();
            }
            else{
                mouseHeld = true;
                mouseLastClicked = new int[]{MouseXY().x, MouseXY().y};

                boolean windowDragCondition = true;
                for (window c_window : windows){
                    if (c_window.overlapping()){
                        c_window.currentWindow = true;
                        c_window.beingDragged = true;
                        windowDragCondition = false;

                        mouseCurrentWindowOffset.x = c_window.gPos[0] - MouseXY().x;
                        mouseCurrentWindowOffset.y = c_window.gPos[1] - MouseXY().y;
                        break;
                    }
                }
                if (grid[hoveredGridPoint().x][hoveredGridPoint().y].getClass() == (new city(-1,-1,this)).getClass()){
                    openCityInspectionWindow(hoveredGridPoint().x,hoveredGridPoint().y);
                }
                if (overlappingMap() && windowDragCondition){
                    draggingMap = true;
                }
            }
        }
        if (e.getButton() == 3){
            rMouseHeld = true;
            firstSelected = hoveredGridPoint();
            //print("Right clicked");
            //print("Firstselected: " + firstSelected);

            makeNewGridWindow(firstSelected, firstSelected);
            window c_window = windows.get(windows.size()-1);
            c_window.currentWindow = true;
            windows.remove(windows.size()-1);
            windows.add(c_window);
        }
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        // TODO Auto-generated method stub
        if (e.getButton() == 1){
            //print("---Mouse Released---");
            mouseHeld = false;
            draggingMap = false;
            totalDragOffset[0] += tempTotalDragOffset[0];
            totalDragOffset[1] += tempTotalDragOffset[1];
            tempTotalDragOffset[0] = 0;
            tempTotalDragOffset[1] = 0;
            for (window c_window : windows){
                c_window.currentWindow = false;
                c_window.beingDragged  = false;
            }
        }
        if (e.getButton() == 3)
        {
            rMouseHeld = false;
            secondSelected = hoveredGridPoint();
            //print("Right click released");
            //print("Secondselected: " + secondSelected);

            for (window c_window : windows){
                c_window.currentWindow = false;
            }
        }
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Entered---");
    }

    @Override
    public void mouseExited(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Exited---");
    }

    @Override
    public void mouseDragged(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Dragged---");
    }

    @Override
    public void mouseMoved(MouseEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Moved---");
        //print(e);
    }

    @Override
    public void mouseWheelMoved(MouseWheelEvent e) {
        // TODO Auto-generated method stub
        //print("---Mouse Wheel Moved---");
        //print("    " + e.getPreciseWheelRotation());
        //print("");
        Double OSF = getScaleFactor();
        Point originalMouseGridOffset = hoveredGridPoint();
        originalMouseGridOffset.x *= getCurrentSidelen();
        originalMouseGridOffset.y *= getCurrentSidelen();
        //print("originalMouseGridOffset.x: " + originalMouseGridOffset.x + "      originalMouseGridOffset.y: " + originalMouseGridOffset.y);
        setScaleValue(scaleValue-e.getPreciseWheelRotation());
        Double NSF = getScaleFactor();
        //print("NSF: " + NSF + "      OSF: " + OSF);
        Double M = NSF/OSF - 1;
        //print("M: " + M);
        
        totalDragOffset[0] -= originalMouseGridOffset.x * M;
        totalDragOffset[1] -= originalMouseGridOffset.y * M;

        //print("Offset x: " + originalMouseGridOffset.x * M);
        //print("Offset y: " + originalMouseGridOffset.y * M);
    }





    public Point MouseXY()
    {
        Point returnPoint = new Point();
        returnPoint.x = MouseInfo.getPointerInfo().getLocation().x;
        returnPoint.y = MouseInfo.getPointerInfo().getLocation().y;

        return returnPoint;
    }
    private Point screen_to_grid(Point screenPoint)
    {
        Double calc_x = screenPoint.getX();
        Double calc_y = screenPoint.getY();

        calc_x -= totalOffset()[0];
        calc_y -= totalOffset()[1];

        calc_x /= getCurrentSidelen();
        calc_y /= getCurrentSidelen();

        calc_x = Math.floor(calc_x+0.3);
        calc_y = Math.floor(calc_y+0.2-1);

        screenPoint.x = intify(calc_x);
        screenPoint.y = intify(calc_y);

        if (screenPoint.x > gridw-1){
            screenPoint.x = gridw-1;
        }
        if (screenPoint.x < 0){
            screenPoint.x = 0;
        }
        if (screenPoint.y > gridh-1){
            screenPoint.y = gridh-1;
        }
        if (screenPoint.y < 0){
            screenPoint.y = 0;
        }

        return screenPoint;
    }
    public Point hoveredGridPoint()
    {
        return screen_to_grid(MouseXY());
    }

    public int[] totalOffset()
    {
        int [] returned_offset = new int[2];
        returned_offset[0] = (totalDragOffset[0] + tempTotalDragOffset[0]);
        returned_offset[1] = (totalDragOffset[1] + tempTotalDragOffset[1]);

        return returned_offset;
    }


    private void setCursorTile()
    {
        for (int x = 0; x < grid.length; x++)
        {
            for (int y = 0; y < grid[0].length; y++)
            {
                grid[x][y].cursorHovered = false;
            }
        } 

        Point mouseInGrid = screen_to_grid(MouseXY());

        //print("mouseInGrid.x:  " + mouseInGrid.x);
        //print("mouseInGrid.y:  " + mouseInGrid.y);
        //print("");

        if (mouseInGrid.x <= gridw-1 && mouseInGrid.x >= 0)
        {
            if (mouseInGrid.y <= gridh-1 && mouseInGrid.y >= 0)
            {
                grid[mouseInGrid.x][mouseInGrid.y].cursorHovered = true;
            }
        }
    }




                //----  GENERAL DEV METHODS  ----//
    public static void print(Object ...x)
    {
        for (Object c_x : x)
        {
            System.out.println(c_x);
        }
    }

    public int intify(Double tar){
        return (int)Math.round(tar);
    }

    private void setColors()
    {
        stroke = true;

        black          = new Color(  0,  0,  0);
        white          = new Color(255,255,255);
        gray           = new Color(100,100,100);
        yellow         = new Color(237,195, 26);
        red            = new Color(255,  0,  0);

        niceRed        = new Color(255,200,200);
        niceGreen      = new Color(200,255,200);
        niceBlue       = new Color(200,200,255);

        oceanBlue      = new Color( 26,152,219);
        grassGreen     = new Color( 14,201, 83);
        hardGrassGreen = new Color(  6,145, 43);
    }

    private void setInputParameters()
    {
        mouseHeld = false;
        draggingMap = false;
        totalDragOffset = new int[]{0,0};
        tempTotalDragOffset = new int[]{0,0};
        mouseCurrentWindowOffset = new Point(0,0);

        firstSelected = new Point(-1,-1);
        secondSelected = new Point(-1,-1);
    }



                // ---------- CORE ---------- //
        // ----- Construction ----- //
    private void setWorldProperties()
    {
        MODE = "openingMenu";
        menuOpened = false;
        setupPhase = true;
        city_count = Math.min(gridw/5, gridh/5);
        land_buffer_count = Math.min(3*gridw, 3*gridh);
        terrain_roughness = 0;//Math.min(gridw, gridh);

        city_locs = new ArrayList<int[]>();
        port_locs = new ArrayList<int[]>();
        air_locs  = new ArrayList<int[]>();
    }
    private void create_grid_skeleton()
    {
        city_locs = new ArrayList<int[]>();
        port_locs = new ArrayList<int[]>();
        air_locs  = new ArrayList<int[]>();

        // Create a blank array of Tiles within the grid structure
        for (int x = 0; x < gridw; x++)
        {
            for (int y = 0; y < gridh; y++)
            {
                grid[x][y] = new ocean(x,y, this);
            }
        }
    }

    private void generate_world()
    {
        if (regenerate)
        {
            cars = new ArrayList<car>();
            windows = new ArrayList<window>();

            grid = new Tile[gridw][gridh];
            create_grid_skeleton();
            generate_landscape();
            buffer_land();
            generate_terrain();
            generate_roads();
            setupPhase = false;
            regenerate = false;
        }else
        {
            print("     !error! Cant regenerate world, regenerate is set to false");
        }
    }
    private void buffer_land()
    {
        //print("Land Buffer Count: " + land_buffer_count);
        for (int i = 0; i < land_buffer_count; i++)
        {
            for (int[] city_loc : city_locs)
            { 
                //print("         CITY " + cityno);
                boolean recurse = true;
                add_adjacent_land(recurse, city_loc); 
            }
        }
    }
    private void generate_terrain()
    {
        // List of rough sites for buffering later
        ArrayList<Point> rough_sites = new ArrayList<Point>();

        // Create rough terrain sites
        for (int i = 0; i < terrain_roughness; i++)
        {
            boolean finding_point = true;
            while (finding_point)
            {
                int rand_rough_x = intify(Math.random()*(gridw-1));
                int rand_rough_y = intify(Math.random()*(gridh-1));

                if (grid[rand_rough_x][rand_rough_y].getClass() == (new land(1,1,this)).getClass()) 
                {
                    finding_point = false;
                    grid[rand_rough_x][rand_rough_y] = new hardLand(rand_rough_x,rand_rough_y, this);
                    rough_sites.add( new Point(rand_rough_x,rand_rough_y) );
                }
            }
        }

        // Make the sites grow a bit
        for (Point n_site : rough_sites)
        {
            for (int i = 0; i < terrain_roughness/5.0D; i++)
            {
                int[] t_n_site = new int[2];
                t_n_site[0] = n_site.x;
                t_n_site[1] = n_site.y;
                add_adjacent_hardLand(true,t_n_site);
            }
        }

    }
    private void generate_roads()
    {
        for (int iA = 0; iA<city_locs.size(); iA++){
            int[] c_cityA = new int[2];
            c_cityA[0] = city_locs.get(iA)[0];
            c_cityA[1] = city_locs.get(iA)[1];
            String nameA = grid[c_cityA[0]][c_cityA[1]].name;
            /*
            Double closestCityDistance = gridh*gridw*1.0D;
            int[] closestCity = new int[2];
            closestCity[0] = -1;
            closestCity[1] = -1;
            for (int[] c_cityB : city_locs){
                if (cityDistance(c_cityA,c_cityB) < closestCityDistance && !(c_cityA[0]==c_cityB[0] && c_cityA[1]==c_cityB[1])){
                    closestCityDistance = cityDistance(c_cityA,c_cityB);
                    closestCity[0] = c_cityB[0];
                    closestCity[1] = c_cityB[1];
                }
            }
            

            // Find the road connecting the two cities
            int[] roadSet = FloodFillRoadGenerator(c_cityA,closestCity);
            if (roadSet[0] == -1){
                continue;
            }
            */
            //print(" ");
            for (int iB = 0; iB<city_locs.size(); iB++){
                int[] c_cityB = new int[2];
                c_cityB[0] = city_locs.get(iB)[0];
                c_cityB[1] = city_locs.get(iB)[1];
                String nameB = grid[c_cityB[0]][c_cityB[1]].name;
                boolean skip = false;
                //print("CityA: " + c_cityA[0] + "  " + c_cityA[1]);
                //print("CityB: " + c_cityB[0] + "  " + c_cityB[1]);
                //print(" ");
                if (c_cityA[0]==c_cityB[0] && c_cityA[1]==c_cityB[1]){
                    skip = true;
                }
                if (!skip)
                {
                    int[] roadSet = FloodFillRoadGenerator(c_cityA,c_cityB);

                    // Placeholders for the next place to continue the road from
                    int nx,ny;
                    nx = c_cityA[0];
                    ny = c_cityA[1];
                    for (int c_roadDir : roadSet){
                        if      (c_roadDir == 0){
                            nx += -1; 
                            grid[nx+1][ny].roadConnection.y=0;
                            grid[nx][ny].roadConnection.x=2; 
                            grid[nx+1][ny].addCityFlag( grid[nx+1][ny].roadConnection.x,0,nameA,nameB );}
                        else if (c_roadDir == 1){
                            ny += -1; 
                            grid[nx][ny+1].roadConnection.y=1;
                            grid[nx][ny].roadConnection.x=3;
                            grid[nx][ny+1].addCityFlag( grid[nx][ny+1].roadConnection.x,1,nameA,nameB );}
                        else if (c_roadDir == 2){
                            nx +=  1; 
                            grid[nx-1][ny].roadConnection.y=2;
                            grid[nx][ny].roadConnection.x=0;
                            grid[nx-1][ny].addCityFlag( grid[nx-1][ny].roadConnection.x,2,nameA,nameB );}
                        else if (c_roadDir == 3){
                            ny +=  1;
                            grid[nx][ny-1].roadConnection.y=3;
                            grid[nx][ny].roadConnection.x=1;
                            grid[nx][ny-1].addCityFlag( grid[nx][ny-1].roadConnection.x,3,nameA,nameB );}

                        grid[nx][ny].hasRoad = true;
                    }
                }
            }
        }
    }
    private void generate_landscape()
    {
        int city_x = 0;
        int city_y = 0;
        for (int i = 0; i < city_count; i++)
        {
            city_x = intify(Math.random() * (gridw-1));
            city_y = intify(Math.random() * (gridh-1));
            grid[city_x][city_y] = new city(city_x, city_y, this);
            //print(city_x + " City on creation" + city_y);
            city_locs.add( new int[] {city_x,city_y} );
            //print(city_locs.get(city_locs.size()-1)[0]+ " City on added to list" + city_locs.get(city_locs.size()-1)[1]);
        }
        
    }
    private void add_adjacent_land(boolean recurse, int[] addFrom)
    {
        Double randval = Math.random();
        // U
        if (randval<=0.25 && addFrom[1]>0)
        {
            if (!(grid[addFrom[0]][addFrom[1]-1].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]][addFrom[1]-1].getClass() == (new land(0,0, this)).getClass()))
                {
                    grid[addFrom[0]][addFrom[1]-1] = new land(addFrom[0],addFrom[1]-1, this);
                    recurse = false;
                }else
                {
                    add_adjacent_land(recurse, new int[]{addFrom[0],addFrom[1]-1});
                }
                
            }
        }
        // R
        else if (randval<=0.5 && addFrom[0]<=gridw-2)
        {
            if (!(grid[addFrom[0]+1][addFrom[1]].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]+1][addFrom[1]].getClass() == (new land(0,0, this)).getClass()))
                {
                    grid[addFrom[0]+1][addFrom[1]] = new land(addFrom[0]+1,addFrom[1], this);
                    recurse = false;
                }else
                {
                    add_adjacent_land(recurse, new int[]{addFrom[0]+1,addFrom[1]});
                }
            }
        }
        // D
        else if (randval<=0.75 && addFrom[1]<=gridh-2)
        {
            if (!(grid[addFrom[0]][addFrom[1]+1].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]][addFrom[1]+1].getClass() == (new land(0,0, this)).getClass()))
                {
                    grid[addFrom[0]][addFrom[1]+1] = new land(addFrom[0],addFrom[1]+1, this);
                    recurse = false;
                }else
                {
                    add_adjacent_land(recurse, new int[]{addFrom[0],addFrom[1]+1});
                }
            }
        }
        // L
        else if (randval<=1 && addFrom[0]>0)
        {
            if (!(grid[addFrom[0]-1][addFrom[1]].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]-1][addFrom[1]].getClass() == (new land(0,0, this)).getClass()))
                {
                    grid[addFrom[0]-1][addFrom[1]] = new land(addFrom[0]-1,addFrom[1], this);
                    recurse = false;
                }else
                {
                    add_adjacent_land(recurse, new int[]{addFrom[0]-1,addFrom[1]});
                }
            }
        }
    }
    private void add_adjacent_hardLand(boolean recurse, int[] addFrom)
    {
        Double randval = Math.random();
        // U
        if (randval<=0.25 && addFrom[1]>0)
        {
            if (!(grid[addFrom[0]][addFrom[1]-1].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]][addFrom[1]-1].getClass() == (new hardLand(0,0, this)).getClass()))
                {
                    grid[addFrom[0]][addFrom[1]-1] = new hardLand(addFrom[0],addFrom[1]-1, this);
                    recurse = false;
                }else
                {
                    add_adjacent_hardLand(recurse, new int[]{addFrom[0],addFrom[1]-1});
                }
                
            }
        }
        // R
        else if (randval<=0.5 && addFrom[0]<=gridw-2)
        {
            if (!(grid[addFrom[0]+1][addFrom[1]].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]+1][addFrom[1]].getClass() == (new hardLand(0,0, this)).getClass()))
                {
                    grid[addFrom[0]+1][addFrom[1]] = new hardLand(addFrom[0]+1,addFrom[1], this);
                    recurse = false;
                }else
                {
                    add_adjacent_hardLand(recurse, new int[]{addFrom[0]+1,addFrom[1]});
                }
            }
        }
        // D
        else if (randval<=0.75 && addFrom[1]<=gridh-2)
        {
            if (!(grid[addFrom[0]][addFrom[1]+1].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]][addFrom[1]+1].getClass() == (new hardLand(0,0, this)).getClass()))
                {
                    grid[addFrom[0]][addFrom[1]+1] = new hardLand(addFrom[0],addFrom[1]+1, this);
                    recurse = false;
                }else
                {
                    add_adjacent_hardLand(recurse, new int[]{addFrom[0],addFrom[1]+1});
                }
            }
        }
        // L
        else if (randval<=1 && addFrom[0]>0)
        {
            if (!(grid[addFrom[0]-1][addFrom[1]].getClass() == (new city(0,0, this)).getClass()))
            {
                if (!(grid[addFrom[0]-1][addFrom[1]].getClass() == (new hardLand(0,0, this)).getClass()))
                {
                    grid[addFrom[0]-1][addFrom[1]] = new hardLand(addFrom[0]-1,addFrom[1], this);
                    recurse = false;
                }else
                {
                    add_adjacent_hardLand(recurse, new int[]{addFrom[0]-1,addFrom[1]});
                }
            }
        }
    }



        // ----- Utility ----- //
    public int getCurrentSidelen()
    {
        int sidelen = 5;
        if (getWidth()/gridw < getHeight()/gridh)
        { sidelen = (getWidth()/gridw); }
        else if (getWidth()/gridw > getHeight()/gridh)
        { sidelen = (getHeight()/gridh); }
        sidelen = intify(getScaleFactor()*sidelen);
        return sidelen;
    }
    public Double cityDistance(int[] A, int[] B)
    {
        Double distance = Math.sqrt(Math.pow(A[0]-B[0],2) + Math.pow(A[1]-B[1],2));
        return distance;
    }
    public int getCurrentSidelen(boolean scalef)
    {
        int sidelen = 1;
        if (getWidth()/gridw < getHeight()/gridh)
        { sidelen = (getWidth()/gridw); }
        if (getWidth()/gridw > getHeight()/gridh)
        { sidelen = (getHeight()/gridh); }
        if (scalef){
            sidelen = intify(getScaleFactor()*sidelen);
        }
        return sidelen;
    }
    public int[] AStarRoadGenerator(int[] A, int[] B)
    {
        ArrayList<Integer> roadSetArrList = new ArrayList<Integer>();
        // Do the AStar Algorithm on the grid



        // Convert ArrayList to int[]
        int[] roadSet = new int[roadSetArrList.size()];
        for (int i = 0; i < roadSetArrList.size(); i++)
        {roadSet[i] = roadSetArrList.get(i);}
        return roadSet;
    }
    public int[] FloodFillRoadGenerator(int[] A, int[] B)
    {
        ArrayList<Integer> roadSetArrList = new ArrayList<Integer>();
        // Do the Floodfill Algorithm on the grid
        int[][] labelGrid = new int[gridw][gridh];

        // Initialize grid to -1
        for (int x = 0; x < gridw; x++)
        {
            for (int y = 0; y < gridh; y++)
            {
                labelGrid[x][y] = -1;
            }    
        }



        labelGrid[A[0]][A[1]] = 0;
        int currentDistanceVal = 0;
        boolean foundDestination = false;
        boolean nolabel = false;
        boolean stopIterating = false;
        int iteratorCounter=0;
        while (!foundDestination && !stopIterating && !nolabel)
        {
            nolabel = true;
            iteratorCounter++;
            if (iteratorCounter >= gridw*gridh){
                stopIterating = true;
                print("     !error! Reached Iteration Limit for floodfill");
            }

            for (int x = 0; x < gridw; x++)
            {
                for (int y = 0; y < gridh; y++)
                {
                    if (labelGrid[x][y] == currentDistanceVal && grid[x][y].getClass() != (new ocean(1,1,this)).getClass() && grid[x][y].getClass() != (new hardLand(1,1,this)).getClass() )
                    {
                        // make sure not to go out of bounds checking
                        if (x+1 <= gridw-1    && grid[x+1][y].getClass() != (new ocean(1,1,this)).getClass() && grid[x+1][y].getClass() != (new hardLand(1,1,this)).getClass())// && !grid[x+1][y].hasRoad)
                            {if (labelGrid[x+1][y] == -1){labelGrid[x+1][y] = currentDistanceVal+1; nolabel=false;}}

                        if (x-1 >= 0          && grid[x-1][y].getClass() != (new ocean(1,1,this)).getClass() && grid[x-1][y].getClass() != (new hardLand(1,1,this)).getClass())// && !grid[x-1][y].hasRoad)
                            {if (labelGrid[x-1][y] == -1){labelGrid[x-1][y] = currentDistanceVal+1; nolabel=false;}}

                        if (y+1 <= gridh-1    && grid[x][y+1].getClass() != (new ocean(1,1,this)).getClass() && grid[x][y+1].getClass() != (new hardLand(1,1,this)).getClass())// && !grid[x][y+1].hasRoad)
                            {if (labelGrid[x][y+1] == -1){labelGrid[x][y+1] = currentDistanceVal+1; nolabel=false;}}

                        if (y-1 >= 0          && grid[x][y-1].getClass() != (new ocean(1,1,this)).getClass() && grid[x][y-1].getClass() != (new hardLand(1,1,this)).getClass())// && !grid[x][y-1].hasRoad)
                            {if (labelGrid[x][y-1] == -1){labelGrid[x][y-1] = currentDistanceVal+1; nolabel=false;}}


                        // If adjacent to desired place has been labelled...
                        if ((x+1 == B[0] && y   == B[1]) ||
                            (x-1 == B[0] && y   == B[1]) ||
                            (x   == B[0] && y+1 == B[1]) ||
                            (x   == B[0] && y-1 == B[1]))
                        {
                            // Stop the algorithm
                            foundDestination = true;
                            print("Found the destination city");
                        }
                    }
                }    
            }
            currentDistanceVal++;
        }
        if (nolabel)
        {
            print("No road was able to be made between the cities anymore");
            return new int[] {-1};
        }


        for (int i = currentDistanceVal; i >= 0; i--)
        {
            if (B[0]+1 <= gridw-1)
                {if (labelGrid[B[0]+1][B[1]] == i){B[0] += 1; roadSetArrList.add(0);}}
            if (B[0]-1 >= 0)
                {if (labelGrid[B[0]-1][B[1]] == i){B[0] -= 1; roadSetArrList.add(2);}}
            if (B[1]+1 <= gridh-1)
                {if (labelGrid[B[0]][B[1]+1] == i){B[1] += 1; roadSetArrList.add(1);}}
            if (B[1]-1 >= 0)
                {if (labelGrid[B[0]][B[1]-1] == i){B[1] -= 1; roadSetArrList.add(3);}}
        }

        // Flip the list
        ArrayList<Integer> roadSetArrListTemp = new ArrayList<Integer>();
        for (int i = roadSetArrList.size()-1; i>=0; i--){
            roadSetArrListTemp.add(roadSetArrList.get(i));
        }
        // Replace the proper list with the newly ordered list
        for (int i = 0; i < roadSetArrListTemp.size(); i++){
            roadSetArrList.remove(i);
            roadSetArrList.add(i,roadSetArrListTemp.get(i));
            //print(roadSetArrListTemp.get(i));
        }
        



        // Convert ArrayList to int[]
        int[] roadSet = new int[roadSetArrList.size()];
        for (int i = 0; i < roadSetArrList.size(); i++)
        {roadSet[i] = roadSetArrList.get(i);}
        return roadSet;
    }
    public Boolean overlappingMap(){
        if (MouseXY().x > totalOffset()[0] && MouseXY().x < totalOffset()[0]+gridw*getCurrentSidelen()){
            if (MouseXY().y > totalOffset()[1] && MouseXY().y < totalOffset()[1]+gridh*getCurrentSidelen()){
                return true;
            }
        }
        return false;
    }
    public Boolean overlappingMenu() {
        if (MouseXY().x >= menu.x            && 
            MouseXY().x <= menu.x+menudims.x && 
            MouseXY().y >= menu.y            &&
            MouseXY().y <= menu.y+menudims.y){
            return true;
        }
        return false;
    }
    public Tile getCity(String cityName){
        for (int i = 0; i < city_locs.size(); i++)
        {
            if (grid[city_locs.get(i)[0]][city_locs.get(i)[1]].name.equals(cityName)){
                return grid[city_locs.get(i)[0]][city_locs.get(i)[1]];
            }
        }
        return null;
    }
    
        // ----- Visual ----- //
    private void draw_grid(Graphics g)
    {
        pushMatrix();
        translate(g,totalOffset()[0],totalOffset()[1]);

        int sidelen = 0;
        sidelen = getCurrentSidelen();

        g.setColor(black);
        pushMatrix();
        for (int x = 0; x < grid.length; x++)
        {
            pushMatrix();
            for (int y = 0; y < grid[0].length; y++) 
            {
                pushMatrix();
                grid[x][y].drawMe(g);
                popMatrix(g);
                translate(g, 0, sidelen);
            }    
            popMatrix(g);   
            translate(g,sidelen,0);         
        }
        popMatrix(g);
        popMatrix(g);
    }

    /*
    private void draw_city_names(Graphics g) {
        for (int i = 0; i < city_locs.size(); i++){
            int[] c_city = new int[2];
            c_city[0] = city_locs.get(i)[0];
            c_city[1] = city_locs.get(i)[1];

            grid[c_city[0]][c_city[1]].drawName(g);
        }
    }
    */

    private void draw_selection_box(Graphics g)
    {
        int ax = 0;
        int bx = 0;

        int ay = 0;
        int by = 0;

        if (firstSelected.x < secondSelected.x)
        {
            ax = firstSelected.x;
            bx = secondSelected.x;
        }else
        {
            ax = secondSelected.x;
            bx = firstSelected.x;
        }

        if (firstSelected.y < secondSelected.y)
        {
            ay = firstSelected.y;
            by = secondSelected.y;
        }else
        {
            ay = secondSelected.y;
            by = firstSelected.y;
        }


        for (int x = ax; x <= bx; x++){
            for (int y = ay; y <= by; y++){
                grid[x][y].cursorHovered = true;
            }
        }
    }
    

    // ---- Sound ---- //
    /*
    private static void playSound(String sound){
        // cl is the ClassLoader for the current class, ie. CurrentClass.class.getClassLoader();
        URL file = cl.getResource(sound);
        final Media media = new Media(file.toString());
        final MediaPlayer mediaPlayer = new MediaPlayer(media);
        mediaPlayer.play();
    }
    */
    
    // ---- Menus and windows ---- //
    public void OpenMenu() {
        JFrame newParent = new JFrame();

        int areYouSure = 0;
        if (!setupPhase)
        {
            areYouSure = JOptionPane.showConfirmDialog(newParent, "Changing the settings of a world will reset it. Are you sure you want to adjust the settings of the world?");
        }
        if (areYouSure == 0)
        {

            JButton enterGame = new JButton();
            enterGame.setText("Start Game");
            Font font = enterGame.getFont();
            float size = font.getSize() + 40.0f;
            enterGame.setFont( font.deriveFont(size) );
            JTextArea enterGameText = new JTextArea();

            JButton gridSize = new JButton();
            gridSize.setText("Set Grid Size");
            font = gridSize.getFont();
            size = font.getSize() + 20.0f;
            gridSize.setFont( font.deriveFont(size) );
            gridSize.setBounds(0,200, 200,200);
            JTextArea gridSizeText = new JTextArea();
            font = gridSizeText.getFont();
            size = font.getSize() + 40.0f;
            gridSizeText.setFont( font.deriveFont(size) );
            gridSizeText.setText("X:" + gridw + "  Y:" + gridh);

            JButton cityCount = new JButton();
            cityCount.setText("Set Number of Cities");
            font = cityCount.getFont();
            size = font.getSize() + 20.0f;
            cityCount.setFont( font.deriveFont(size) );
            cityCount.setBounds(0,400, 200,200);
            JTextArea cityCountText = new JTextArea();
            font = cityCountText.getFont();
            size = font.getSize() + 40.0f;
            cityCountText.setFont( font.deriveFont(size) );
            cityCountText.setText(String.valueOf(city_count));

            JButton landscapeRoughness = new JButton();
            landscapeRoughness.setText("Set the Roughness Value of the Landscape");
            font = landscapeRoughness.getFont();
            size = font.getSize() + 20.0f;
            landscapeRoughness.setFont( font.deriveFont(size) );
            landscapeRoughness.setBounds(0,600, 200,200);
            JTextArea landscapeRoughnessText = new JTextArea();
            font = landscapeRoughnessText.getFont();
            size = font.getSize() + 40.0f;
            landscapeRoughnessText.setFont( font.deriveFont(size) );
            landscapeRoughnessText.setText(String.valueOf(terrain_roughness));

            JButton landBufferCount = new JButton();
            landBufferCount.setText("Set the Land Buffer");
            font = landBufferCount.getFont();
            size = font.getSize() + 20.0f;
            landBufferCount.setFont( font.deriveFont(size) );
            landBufferCount.setBounds(0,800, 200,200);
            JTextArea landBufferCountText = new JTextArea();
            font = landBufferCountText.getFont();
            size = font.getSize() + 40.0f;
            landBufferCountText.setFont( font.deriveFont(size) );
            landBufferCountText.setText(String.valueOf(land_buffer_count));

            newParent.add(enterGame);
            newParent.add(enterGameText);
            newParent.add(gridSize);
            newParent.add(gridSizeText);
            newParent.add(cityCount);
            newParent.add(cityCountText);
            newParent.add(landscapeRoughness);
            newParent.add(landscapeRoughnessText);
            newParent.add(landBufferCount);
            newParent.add(landBufferCountText);

            newParent.pack();
            newParent.setSize(700,500);
            newParent.setLayout(new GridLayout(5,2));
            newParent.setVisible(true);
            newParent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);



            // Button click event listeners
            enterGame.addActionListener(new java.awt.event.ActionListener(){
                @Override
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    MODE = "gameplayScreen"; 
                    regenerate = true;
                    setupPhase = true;
                    newParent.dispose();
                    f.setVisible(true); 

                    print("     -Start Button Pressed-");
                }
            });
            gridSize.addActionListener(new java.awt.event.ActionListener(){
                @Override
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    String gridx = JOptionPane.showInputDialog(newParent, "Enter Grid X Dimension: ");
                    String gridy = JOptionPane.showInputDialog(newParent, "Enter Grid Y Dimension: ");
                    gridw = Integer.parseInt(gridx);
                    gridh = Integer.parseInt(gridy);

                    gridSizeText.setText("X:" + gridw + "  Y:" + gridh);
                }
            });
            cityCount.addActionListener(new java.awt.event.ActionListener(){
                @Override
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    String cityCountString = JOptionPane.showInputDialog(newParent, "Enter the number of starting Cities: ");
                    city_count = Integer.parseInt(cityCountString);

                    cityCountText.setText(String.valueOf(city_count));
                }
            });
            landscapeRoughness.addActionListener(new java.awt.event.ActionListener(){
                @Override
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    String landscapeRoughnessString = JOptionPane.showInputDialog(newParent, "Enter the Landscape Roughness: ");
                    terrain_roughness = Integer.parseInt(landscapeRoughnessString);

                    landscapeRoughnessText.setText(String.valueOf(terrain_roughness));
                }
            });
            landBufferCount.addActionListener(new java.awt.event.ActionListener(){
                @Override
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    String landBufferCountString = JOptionPane.showInputDialog(newParent, "Enter the Landscape Roughness: ");
                    land_buffer_count = Integer.parseInt(landBufferCountString);

                    landBufferCountText.setText(String.valueOf(land_buffer_count));
                }
            });
        }
    }
    public void cull_windows(){
        for (int i = windows.size()-1; i >= 0 ; i--)
        {
            if (windows.get(i).removeable)
            {windows.remove(i);}
        }
    }
    public void cull_cars(){
        //print(cars.size());
        for (int i = cars.size()-1; i >= 0 ; i--)
        {
            if (!cars.get(i).alive)
            {cars.remove(i);
            print("Car removed");}
        }
    }
    private void draw_windows(Graphics g)
    {
        for (window c_window : windows){
            c_window.drawWindow(g);
        }
    }
    public void draw_cars(Graphics g){
        pushMatrix();
        translate(g,totalOffset()[0],totalOffset()[1]);
        for (int i = 0; i < cars.size(); i++)
        {
            pushMatrix();
            translate(g,cars.get(i).gPos[0]*getCurrentSidelen(),cars.get(i).gPos[1]*getCurrentSidelen());
            cars.get(i).drawMe(g);
            popMatrix(g);
        }
        popMatrix(g);
    }
    // Overloaded for the gridwindow class to draw only the cars in bounds
    public void draw_cars(Graphics g, int ax, int bx, int ay, int by, Double currentSideLen){
        pushMatrix();
        car c_car = new car(-1,-1,this);
        for (int i = 0; i < cars.size(); i++)
        { 
            c_car = cars.get(i);
            if (c_car.gPos[0] >= ax 
            &&  c_car.gPos[0] <= bx
            &&  c_car.gPos[1] >= ay
            &&  c_car.gPos[1] <= by ){
                //print("True");
                pushMatrix();
                translate(g,(c_car.gPos[0]-ax)*currentSideLen,(c_car.gPos[1]-ay)*currentSideLen);
                c_car.drawMe(g);
                popMatrix(g);
            }
        }
        popMatrix(g);
    }
    public void openCityInspectionWindow(int a, int b) {
        TradingSim masterInstance = this;

        JFrame parent = new JFrame();
        String[] columnNames = {"Name",
                        "gPos[0]",
                        "gPos[1]"};
        city tarCity = (city) grid[a][b];
        Object[][] data = {{tarCity.name, tarCity.gPos[0], tarCity.gPos[1]}};

        JTable info = new JTable(data, columnNames);
        parent.add(info);

        JButton carMaker = new JButton();
        carMaker.setText("Make a new car");

        carMaker.addActionListener( new java.awt.event.ActionListener() {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent e) {
                print("New car added");
                for (int i = 0; i < city_locs.size(); i++)
                {
                    int[] randomCity = city_locs.get( intify(Math.random()*(city_locs.size()-1)) );
                    grid[city_locs.get(i)[0]][city_locs.get(i)[1]].sendCarTo(grid[randomCity[0]][randomCity[1]].name);   
                }
            }
        } );

        parent.add(carMaker);

        parent.setLayout(new GridLayout(2,1));

        parent.pack();
        parent.setVisible(true);
        parent.setAutoRequestFocus(true);
    }




    // ---- Audio ---- //
    private void playMusic(int choice) 
    {
        if (line != null && line.isOpen()){
            line.close();
        }

        format = null;
        line = null;
        info = new DataLine.Info(Clip.class, format); // format is an AudioFormat object

        if (!AudioSystem.isLineSupported(info)) {
            // Handle the error.
            }
            // Obtain and open the line.
        try {
            //print("  ---  ");
            line = (Clip) AudioSystem.getLine(info);
            if (line.isActive()){
                line.close();
            }
            AudioInputStream audioInputStream = null;
            try{
                InputStream inputStream = TradingSim.class.getResourceAsStream(MusicStrings[choice]);
                //print(inputStream);
                //print(inputStream.available());
                audioInputStream = AudioSystem.getAudioInputStream(inputStream);
                //print("  ---  ");
            }catch (IOException e){
                //print(e);
                //print("  ---  ");
            }catch (UnsupportedAudioFileException e){
                //print(e);
                //print("  ---  ");
            }
            try{
                line.open(audioInputStream);
                //print("Line Opened");
                //print("  ---  ");
            }catch (IOException e){
                //print(e);
                //print("     There was an issue opening the line");
                //print("  ---  ");
            }catch (Exception e){
                //print("Unpreempted exception: ");
                //print(e);
            }
            
        } catch (LineUnavailableException ex) {
                // Handle the error.
            //... 
            print("  ISSUE BIG  ");
        }

        try{
            FloatControl gainControl = (FloatControl) line.getControl(FloatControl.Type.MASTER_GAIN); 
            double gain = .5D; // number between 0 and 1 (loudest)
            float dB = (float) (Math.log(gain) / Math.log(10.0) * 20.0);
            gainControl.setValue(dB);
    
            //print(line.getLevel());
            line.start();
            //print("Started playing audio");
        }finally{}
    }
    private void playSound(int choice) 
    {
        format = null;
        line = null;
        info = new DataLine.Info(Clip.class, format); // format is an AudioFormat object

        if (!AudioSystem.isLineSupported(info)) {
            // Handle the error.
            }
            // Obtain and open the line.
        try {
            //print("  ---  ");
            line = (Clip) AudioSystem.getLine(info);
            AudioInputStream audioInputStream = null;
            try{
                InputStream inputStream = TradingSim.class.getResourceAsStream(SoundEffectStrings[choice]);
                //print(inputStream);
                //print(inputStream.available());
                audioInputStream = AudioSystem.getAudioInputStream(inputStream);
                //print("  ---  ");
            }catch (IOException e){
                //print(e);
                //print("  ---  ");
            }catch (UnsupportedAudioFileException e){
                //print(e);
                //print("  ---  ");
            }
            try{
                line.open(audioInputStream);
                //print("Line Opened");
                //print("  ---  ");
            }catch (IOException e){
                //print(e);
                //print("     There was an issue opening the line");
                //print("  ---  ");
            }catch (Exception e){
                //print("Unpreempted exception: ");
                //print(e);
            }
            
        } catch (LineUnavailableException ex) {
                // Handle the error.
            //... 
            print("  ISSUE BIG  ");
        }

        try{
            FloatControl gainControl = (FloatControl) line.getControl(FloatControl.Type.MASTER_GAIN); 
            double gain = .5D; // number between 0 and 1 (loudest)
            float dB = (float) (Math.log(gain) / Math.log(10.0) * 20.0);
            gainControl.setValue(dB);
    
            //print(line.getLevel());
            line.start();
            //print("Started playing audio");
        }finally{}
    }


    // ---- GUI ---- //
    private void makeNewGridWindow(Point startPoint, Point endPoint)
    {
        gridWindow newWindow = new gridWindow(9*getWidth()/10, getHeight()/10, this, startPoint, endPoint);
        windows.add(newWindow);
        latestLabel++;

    }

    public boolean withinObservedTiles(int x, int y) {
        /*
            Return true if the coordinates fall within the bounds of any windows observations 
        */

        for (int i = 0; i < windows.size(); i++)
        {
            gridWindow classExGridwindow = new gridWindow(0, 0, this, new Point(-1,-1), new Point(-1,-1));
            window c_window = windows.get(i);
            if (c_window.getClass() == classExGridwindow.getClass()){
                gridWindow n_c_window = (gridWindow) c_window;
                int ax = 0;
                int bx = 0;

                int ay = 0;
                int by = 0;

                if (n_c_window.startingGridPoint.x < n_c_window.endingGridPoint.x)
                {
                    ax = n_c_window.startingGridPoint.x;
                    bx = n_c_window.endingGridPoint.x;
                }else
                {
                    ax = n_c_window.endingGridPoint.x;
                    bx = n_c_window.startingGridPoint.x;
                }

                if (n_c_window.startingGridPoint.y < n_c_window.endingGridPoint.y)
                {
                    ay = n_c_window.startingGridPoint.y;
                    by = n_c_window.endingGridPoint.y;
                }else
                {
                    ay = n_c_window.endingGridPoint.y;
                    by = n_c_window.startingGridPoint.y;
                }

                if (by-ay > bx-ax){
                    bx = ax+(by-ay);
                }else{
                    by = ay+(bx-ax);
                }
                if (x >= ax && x <= bx
                &&  y >= ay && y <= by){
                    return true;
                }
            }
        }

        return false;
    }
}
