package rendering;
/**
 * sim
 */
import sim.*;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JPanel; 
import javax.swing.Timer;

import SimulationMaker.SimulationMaker;

import java.util.ArrayList;
import java.util.Vector;

@SuppressWarnings("unchecked")

public class RenderClassNew extends JPanel implements ActionListener, KeyListener{
    SimulationMaker master;
    Timer timer = new Timer(20,this);
    static JFrame f;
    
    // Basic colors
    Color black;
    Color white;

    // Pro colors
    Color niceRed;
    Color niceGreen;
    Color niceBlue;


    // Writing
    boolean writtenOneTimeInformation;



    // Transformations
    ArrayList<Integer> T;
    ArrayList<ArrayList<Integer>> TStack;

    public void paint(Graphics g){
        clearScreen(g);
        //g.fillRect(x, y, width, height);
        /*
        translate(g, 100, 100);
        g.setColor(niceRed);
        g.fillOval(0,0, 30, 30);

        pushMatrix();
        translate(g, 100, 150);
        g.setColor(niceGreen);
        g.fillOval(0,0, 30, 30);

        popMatrix(g);
        translate(g, 100, 200);
        g.setColor(niceBlue);
        g.fillOval(0,0, 30, 30);
        */
    }

    public RenderClassNew(SimulationMaker myMaster){
        master = myMaster;
        setupSwingWindow();
        setColors();

        T = new ArrayList<Integer>(2); T.add(0);
                                       T.add(0);
        TStack = new ArrayList<ArrayList<Integer>>();
    }



    private void setupSwingWindow()
    {
        addKeyListener(this);
        setFocusable(true);
        timer.start();

        f = new JFrame();  
        f.setSize(intify(((ArrayList<Double>)master.getManager().getEnv().getProperty("boundingBox").getValue()).get(0)*1.1), intify(((ArrayList<Double>)master.getManager().getEnv().getProperty("boundingBox").getValue()).get(1)*1.1));
        f.add(this);  
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //f.setLayout(null);  
        f.setVisible(true); 
        f.setResizable(true);

        writtenOneTimeInformation = false;
    }


    // ---- Rendering Methods ---- //
        //BASIC//
    private void clearScreen(Graphics g)
    {
        g.setColor(white);
        g.fillRect(0,0, getWidth(), getHeight());
    }


    public void writeIteration()
    {
        env E = master.getManager().getEnv();
        if (!writtenOneTimeInformation)
        {
            System.out.println(((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(0) + "  " + ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(1) + "  " + E.getAgents().size());
            writtenOneTimeInformation = true;
        }
        for (int i = 0; i < E.getAgents().size(); i++)
        {
            agent cAgent = E.getAgents().get(i);
            System.out.println(((ArrayList<Double>)cAgent.getProperty("position").getValue()).get(0) + "  " + ((ArrayList<Double>)cAgent.getProperty("position").getValue()).get(1));
        }
    }

                //---- Core return methods ----//
    public static int getWindowWidth()
    {
        return f.getWidth();
    }
    public static int getWindowHeight()
    {
        return f.getHeight();
    }


    // ---- Transformation Manipulation ---- //

    private void translate(Graphics g, Double x_trans, Double y_trans)
    {
        g.translate(intify(x_trans),intify(y_trans));
        ArrayList<Integer> dT = new ArrayList<Integer>(); dT.add(intify(x_trans));dT.add(intify(y_trans));
        T_ADD(dT);
    }
    private void translate(Graphics g, int x_trans, int y_trans)
    {
        g.translate(x_trans,y_trans);
        ArrayList<Integer> dT = new ArrayList<Integer>(); dT.add(x_trans);dT.add(y_trans);
        T_ADD(dT);
    }
    private void T_ADD(ArrayList<Integer> dT)
    {
        // Add a transformation to the overall transformation
        Integer x = T.get(0); 
        Integer y = T.get(1);
                x += dT.get(0);       
                y += dT.get(1); 
        T = new ArrayList<Integer>();
                T.add(x); T.add(y);

    }
    private void pushMatrix()
    {
        TStack.add(T);
    }
    private void popMatrix(Graphics g)
    {
        ArrayList<Integer> summand = new ArrayList<Integer>(); summand.add(0); summand.add(0);
        summand.set(0, TStack.get(TStack.size()-1).get(0));
        summand.set(1, TStack.get(TStack.size()-1).get(1));

        summand.set(0, summand.get(0) - T.get(0));
        summand.set(1, summand.get(1) - T.get(1));
        translate(g,summand.get(0),summand.get(1));
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
        black     = new Color(  0,  0,  0);
        white     = new Color(255,255,255);

        niceRed   = new Color(255,200,200);
        niceGreen = new Color(200,255,200);
        niceBlue  = new Color(200,200,255);
    }

    // ---- GUI ---- //

}