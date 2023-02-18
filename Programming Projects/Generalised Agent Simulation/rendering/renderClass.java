package rendering;
/**
 * sim
 */
import sim.*;

import javax.swing.JPanel;

import SimulationMaker.SimulationMaker;

@SuppressWarnings("unchecked")

public class renderClass extends JPanel implements ActionListener, KeyListener{
    // Basic colors
    Color black;
    Color white;

    // Pro colors
    Color niceRed;
    Color niceGreen;
    Color niceBlue;

    public void paint(Graphics g){
    }

    public renderClass(SimulationMaker myMaster){
        master = myMaster;

        setupSwingWindow();
        addKeyListener(this);
        setFocusable(true);
        timer.start();

        f = new JFrame();  
        f.setSize(intify(((ArrayList<Double>)master.getManager().getEnv().getProperty("bounds").getValue()).get(0)*1.1),
                  intify(((ArrayList<Double>)master.getManager().getEnv().getProperty("bounds").getValue()).get(1)*1.1));
        f.add(this);  
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //f.setLayout(null);  
        f.setVisible(true); 
        f.setResizable(false);

        setColors();
    }





    // ---- Rendering Methods ---- //


    // ---- Core return methods ---- //
    public static int getWindowWidth()
    {
        return f.getWidth();
    }
    public static int getWindowHeight()
    {
        return f.getHeight();
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