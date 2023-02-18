package SimulationMaker;

import sim.*;
import rendering.*;


public class SimulationMaker {
    static SimulationMaker simMaker;
    public static RenderClassNew renderer;
    public static simManager manager;


    public SimulationMaker(){
        // New simulation manager
        manager = new simManager(this);
        manager.createEnv1();

        // New Renderer
        renderer = new RenderClassNew(this); 

        // Check for errors by running one simulation iteration
        manager.simulate(3);
    }

    public static void main(String[] args) { 
        simMaker = new SimulationMaker();
    }

                //---- Renderer Help Methods ----//
    public void writeIteration()
    {
        renderer.writeIteration();
    }



                //----  GENERAL DEV METHODS  ----//
    public static void print(Object ...x)
    {
        for (Object c_x : x)
        {
            System.out.println(c_x);
        }
    }

                //---- Get/Set mathods ----//
    public simManager getManager(){
        return manager;
    }
}
