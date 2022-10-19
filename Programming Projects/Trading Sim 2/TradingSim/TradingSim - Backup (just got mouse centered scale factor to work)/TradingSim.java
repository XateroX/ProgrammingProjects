package TradingSim;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;

import javax.swing.JFrame;
import javax.swing.JPanel; 
import javax.swing.Timer;
import javax.swing.event.MouseInputListener;
import java.awt.event.MouseWheelListener;

import java.util.ArrayList;

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

    // Pro colors
    Color niceRed;
    Color niceGreen;
    Color niceBlue;
    Color oceanBlue;
    Color grassGreen;
    Color hardGrassGreen;

    // Color options
    Boolean stroke;

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

    // Properties of the world
    int city_count;
    int land_buffer_count;
    int terrain_roughness;


    // 'Gameplay' / Asthetic variables
    Boolean setupPhase;


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

    public void paint(Graphics g){

        counter++;

        if (setupPhase)
        {generate_world();}

        clearScreen(g);
        //g.fillRect(x, y, width, height);
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
        draw_grid(g);
        setCursorTile();

        draw_windows(g);
    }

    public TradingSim(int iGridw, int iGridh)
    {
        T = new ArrayList<Integer>(2); T.add(0); T.add(0);
        TStack = new ArrayList<ArrayList<Integer>>();

        // Grid parameters
        gridw = iGridw;
        gridh = iGridh;

        
        grid = new Tile[gridw][gridh];
        setupSwingWindow();
        setWorldProperties();
        setColors();
        setInputParameters();
        
        totalDragOffset = new int[2];
        totalDragOffset[0] = getWidth()/2 - gridw*getCurrentSidelen()/2; 
        totalDragOffset[1] = getHeight()/2 - gridw*getCurrentSidelen()/2;

        ArrayList<Tile> tileList = new ArrayList<Tile>();
        tileList.add( new city(1,1, this) );

        Tile[][] tileActualList = new Tile[1][1];
        tileActualList[0][0] = new city(1,1, this);

        windows = new ArrayList<window>();
        latestLabel = 1;

        create_grid_skeleton();
    }

    public static void main(String[] args) {
        TradingSim TradingSimInstance = new TradingSim(100,100);
    }


    private void setupSwingWindow()
    {
        addKeyListener(this);
        addMouseListener(this);
        addMouseWheelListener(this);
        setFocusable(true);
        timer.start();

        f = new JFrame();  
        f.setSize(500,500);
        f.add(this);  
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //f.setLayout(null);  
        f.setVisible(true); 
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


    @Override
    public void keyTyped(KeyEvent e) {
        // TODO Auto-generated method stub
        //System.out.println("Typed: " + e.getKeyChar());
    }

    @Override
    public void keyPressed(KeyEvent e) {
        // TODO Auto-generated method stub
        System.out.println("Pressed: " + e.getKeyChar());
    }

    @Override
    public void keyReleased(KeyEvent e) {
        // TODO Auto-generated method stub
        System.out.println("Released: " + e.getKeyChar());
    }

    @Override
    public void actionPerformed(ActionEvent e) {
            // Should only do this every so often or even not at all to start with
        repaint();
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

        calc_x = Math.floor(calc_x);
        calc_y = Math.floor(calc_y);

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

    private int[] totalOffset()
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
        setupPhase = true;
        city_count = 20;
        land_buffer_count = 300;
        terrain_roughness = 50;

        city_locs = new ArrayList<int[]>();
        port_locs = new ArrayList<int[]>();
        air_locs  = new ArrayList<int[]>();
    }
    private void create_grid_skeleton()
    {
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
        generate_landscape();
        buffer_land();
        generate_terrain();
        generate_roads();
        setupPhase = false;
    }
    private void buffer_land()
    {
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

    }
    private void generate_landscape()
    {
        for (int i = 0; i < city_count; i++)
        {
            int city_x = intify(Math.random() * (gridw-1));
            int city_y = intify(Math.random() * (gridh-1));
            grid[city_x][city_y] = new city(city_x, city_y, this);
            city_locs.add( new int[] {city_x,city_y} );
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
        int sidelen = 1;
        if (getWidth()/gridw < getHeight()/gridh)
        { sidelen = (getWidth()/gridw); }
        if (getWidth()/gridw > getHeight()/gridh)
        { sidelen = (getHeight()/gridh); }
        sidelen = intify(getScaleFactor()*sidelen);
        return sidelen;
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



    public Boolean overlappingMap(){
        if (MouseXY().x > totalOffset()[0] && MouseXY().x < totalOffset()[0]+gridw*getCurrentSidelen()){
            if (MouseXY().y > totalOffset()[1] && MouseXY().y < totalOffset()[1]+gridh*getCurrentSidelen()){
                return true;
            }
        }
        return false;
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


    private void draw_windows(Graphics g)
    {
        for (window c_window : windows){
            c_window.drawWindow(g);
        }
    }


    // ----- Input ----- // 

    @Override
    public void mouseClicked(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Clicked---");
    }

    @Override
    public void mousePressed(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Pressed---");
        if (e.getButton() == 1){
            mouseHeld = true;
            mouseLastClicked = new int[]{MouseXY().x, MouseXY().y};

            boolean windowDragCondition = true;
            for (window c_window : windows){
                if (c_window.overlapping()){
                    //if (c_window.overlappingQuit())
                    //{
                        
                    //}
                    c_window.currentWindow = true;
                    c_window.beingDragged = true;
                    windowDragCondition = false;

                    mouseCurrentWindowOffset.x = c_window.gPos[0] - MouseXY().x;
                    mouseCurrentWindowOffset.y = c_window.gPos[1] - MouseXY().y;
                }
            }
            if (overlappingMap() && windowDragCondition){
                draggingMap = true;
            }
        }
        if (e.getButton() == 3){
            rMouseHeld = true;
            firstSelected = hoveredGridPoint();
            print("Right clicked");
            print("Firstselected: " + firstSelected);

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
            print("---Mouse Released---");
            mouseHeld = false;
            draggingMap = false;
            totalDragOffset[0] += tempTotalDragOffset[0];
            totalDragOffset[1] += tempTotalDragOffset[1];
            tempTotalDragOffset[0] = 0;
            tempTotalDragOffset[1] = 0;
            for (window c_window : windows){
                c_window.currentWindow = false;
            }
        }
        if (e.getButton() == 3)
        {
            rMouseHeld = false;
            secondSelected = hoveredGridPoint();
            print("Right click released");
            print("Secondselected: " + secondSelected);

            for (window c_window : windows){
                c_window.currentWindow = false;
            }
        }
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Entered---");
    }

    @Override
    public void mouseExited(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Exited---");
    }

    @Override
    public void mouseDragged(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Dragged---");
    }

    @Override
    public void mouseMoved(MouseEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Moved---");
        print(e);
    }

    @Override
    public void mouseWheelMoved(MouseWheelEvent e) {
        // TODO Auto-generated method stub
        print("---Mouse Wheel Moved---");
        print("    " + e.getPreciseWheelRotation());
        print("");
        Double OSF = getScaleFactor();
        Point originalMouseGridOffset = hoveredGridPoint();
        originalMouseGridOffset.x *= getCurrentSidelen();
        originalMouseGridOffset.y *= getCurrentSidelen();
        print("originalMouseGridOffset.x: " + originalMouseGridOffset.x + "      originalMouseGridOffset.y: " + originalMouseGridOffset.y);
        setScaleValue(scaleValue-e.getPreciseWheelRotation());
        Double NSF = getScaleFactor();
        print("NSF: " + NSF + "      OSF: " + OSF);
        Double M = NSF/OSF - 1;
        print("M: " + M);
        
        totalDragOffset[0] -= originalMouseGridOffset.x * M;
        totalDragOffset[1] -= originalMouseGridOffset.y * M;

        print("Offset x: " + originalMouseGridOffset.x * M);
        print("Offset y: " + originalMouseGridOffset.y * M);
    }


    // ---- GUI ---- //
    private void makeNewGridWindow(Point startPoint, Point endPoint)
    {
        gridWindow newWindow = new gridWindow(9*getWidth()/10, getHeight()/10, this, startPoint, endPoint);
        windows.add(newWindow);
        latestLabel++;

    }
}
