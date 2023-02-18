package sim;

import java.util.ArrayList;
import java.util.function.BiFunction;

import SimulationMaker.SimulationMaker;

//import java.io.FileInputStream;
//import java.io.FileOutputStream;
//import java.io.ObjectInputStream;
//import java.io.ObjectOutputStream;
import java.io.Serializable;

@SuppressWarnings("unchecked")

public class simManager implements Serializable{
    /*
        simManager class

        This class should manage all of the running related technicalities with the simulation
        and manage the processes of the env class.


        env E;                          - The environment of the simulation.
        Long tick;                      - Tick count of the simulation (age)
    */

    private static final long serialVersionUID = 1420672609912364060L;

    private SimulationMaker master;

    // env variable containing all the data associated with the environment
    private env E;

    // Long tracking the number of simulation ticks since the start of the simulation
    //private Long tick; 

    behaviourFunctions behaviour_functions;

    public simManager(SimulationMaker myMaster)
    {
        master = myMaster;
        E    = new env();
        //tick = 0L;
        behaviour_functions = new behaviourFunctions();
    }

    // ------------------------------------ Get/Set methods -------------------------------------- //
    public env getEnv() {return E;}
    // ------------------------------------------------------------------------------------------- //

    // ------------------------------------ Example Simulations ---------------------------------------- //

        // Create a simple env from simple conditions
    public void createEnv1()
    {
        /*
            Now creates env, agts, behaviours for agts (bounding box alert for right hand side),
            simple position properties for agts, bounding box property for env, implements full
            structure from nothing to a simple behaviour.

            Now need to create rest of the framework (maybe simple movement) and a render method 
            externally to see how its going.
        */



        // Create bounding box of 'map' the agents act on 
        ArrayList<Double> bounds = new ArrayList<Double>();
        bounds.add(500D);
        bounds.add(500D);
        E.setNewProperty( new property("boundingBox", bounds, "Box dimensions that define a bounding box for the environment" )  ); 

        ArrayList<agent> newAgentsList = new ArrayList<agent>();
        // Add 5 agents to the environment with random positions in the bounding box
        for (int i = 0; i < 3; i++)
        {
                // Constructing the position property for each agent
            ArrayList<Double> agentPosition = new ArrayList<Double>();
            ArrayList<Double> envBounds = (ArrayList<Double>) E.getProperty("boundingBox").getValue();
            Double agentX = Math.random() * (  envBounds.get(0)  );
            Double agentY = Math.random() * (  envBounds.get(1)  );
            agentPosition.add(agentX);
            agentPosition.add(agentY);
            agent newAgent = new agent();
            newAgent.setNewProperty(new property("position",agentPosition,"The position of the agent within the bounding box of the environment")  );
            newAgent.setNewBehaviour( behaviour_functions.getBehaviourList().get("movement") );
            newAgent.addNewBehaviourString("movement");
            newAgent.setNewBehaviour( behaviour_functions.getBehaviourList().get("boundaryCollision") );
            newAgent.addNewBehaviourString("boundaryCollision");
            
            newAgentsList.add(newAgent);
        }
        this.E.setAgents(newAgentsList);
        //System.out.println("Done");
    }
    // ------------------------------------------------------------------------------------------ //






    public void createEnv2()
    {
        /*
            Single player game experiment, 
        */



        // Create bounding box of 'map' the agents act on 
        ArrayList<Double> bounds = new ArrayList<Double>();
        bounds.add(500D);
        bounds.add(500D);
        E.setNewProperty( new property("boundingBox", bounds, "Box dimensions that define a bounding box for the environment" )  ); 

        ArrayList<agent> newAgentsList = new ArrayList<agent>();
        // Add 5 agents to the environment with random positions in the bounding box
        for (int i = 0; i < 5; i++)
        {
                // Constructing the position property for each agent
            ArrayList<Double> agentPosition = new ArrayList<Double>();
            ArrayList<Double> envBounds = (ArrayList<Double>) E.getProperty("boundingBox").getValue();
            Double agentX = Math.random() * (  envBounds.get(0)  );
            Double agentY = Math.random() * (  envBounds.get(1)  );
            agentPosition.add(agentX);
            agentPosition.add(agentY);
            agent newAgent = new agent();
            newAgent.setNewProperty(new property("position",agentPosition,"The position of the agent within the bounding box of the environment")  );
            newAgent.setNewBehaviour( behaviour_functions.getBehaviourList().get("boundaryCollision") );
            newAgent.addNewBehaviourString("boundaryCollision");
            
            newAgentsList.add(newAgent);
        }
        this.E.setAgents(newAgentsList);
    }

    public void createEnv3()
    {
        // Adding the boundary conditions of the simulation
        ArrayList<Double> bounds = new ArrayList<Double>();
        bounds.add(500.0D); bounds.add(500.0D);
        this.E.setNewProperty( new property("boundingBox", bounds, "Values that determine the boundary dimensions of the environment area. Interpretted as the max x and y coordinate (below 0,0 is outside the boundary)") );


        // Adding Grid definition to the environment
        ArrayList<Integer> gridDims = new ArrayList<Integer>();
        gridDims.add(10); gridDims.add(10);
        this.E.setNewProperty( new property("gridDims", gridDims, "Values that define the number of grid squares in each dimension, (x,y)") );


        // Adding the walls to the system
        int wallNumber = 30;
            // This arraylist structure allows for each item to be 4 integers, which define a pair of vector positions in the grid, forming a wall
        ArrayList< ArrayList<Integer> > wallPairs = new ArrayList< ArrayList<Integer> >();
        for (int i = 0; i < wallNumber; i++)
        {
            // Add a wall to the set of walls
            ArrayList<Integer> newWallPair = new ArrayList<Integer>();
            ArrayList<Double> l_Bounds = ((ArrayList<Double>)this.getEnv().getProperty("boundingBox").getValue());
            Double x_bound = l_Bounds.get(0);
            Double y_bound = l_Bounds.get(1);


            ArrayList<Integer> gridDimList = (ArrayList<Integer>)E.getProperty("gridDims").getValue();
            // First coordinate of the wall (in grid points)
            int randomXPoint1 = intify(Math.random()* gridDimList.get(0));
            int randomYPoint1 = intify(Math.random()* gridDimList.get(0));

            // Second coordinate of the wall (in grid points)
            int randomXPoint2 = randomXPoint1;
            int randomYPoint2 = randomYPoint1;

            // Keep it orthogonal
            if (Math.random() <= 0.5)
            {randomXPoint2 = randomXPoint1 + intify(Math.random() * (gridDimList.get(0)-randomXPoint1));}
            else
            {randomYPoint2 = randomYPoint1 + intify(Math.random() * (gridDimList.get(1)-randomYPoint1));}

            // Construct new wall pair
            //      Wall pair looks like {x1,y1,x2,y2}
            newWallPair.add(randomXPoint1); newWallPair.add(randomYPoint1); 
            newWallPair.add(randomXPoint2); newWallPair.add(randomYPoint2); 

            wallPairs.add(newWallPair);
        }
        this.E.setNewProperty( new property("wallPairs", wallPairs, "A list of arraylists of integers. Each bottom array list is {x1,y1,x2,y2} for the pair of coordinates for the wall points") );
    }



    public void createEnv4()
    {
        /*
            Now creates env, agts, behaviours for agts (bounding box alert for right hand side),
            simple position properties for agts, bounding box property for env, implements full
            structure from nothing to a simple behaviour.

            Now need to create rest of the framework (maybe simple movement) and a render method 
            externally to see how its going.
        */



        // Create bounding box of 'map' the agents act on 
        ArrayList<Double> bounds = new ArrayList<Double>();
        bounds.add(500D);
        bounds.add(500D);
        E.setNewProperty( new property("boundingBox", bounds, "Box dimensions that define a bounding box for the environment" )  ); 

        ArrayList<agent> newAgentsList = new ArrayList<agent>();
        // Add 5 agents to the environment with random positions in the bounding box
        for (int i = 0; i < 3; i++)
        {
                // Constructing the position property for each agent
            ArrayList<Double> agentPosition = new ArrayList<Double>();
            ArrayList<Double> envBounds = (ArrayList<Double>) E.getProperty("boundingBox").getValue();
            Double agentX = Math.random() * (  envBounds.get(0)  );
            Double agentY = Math.random() * (  envBounds.get(1)  );
            agentPosition.add(agentX);
            agentPosition.add(agentY);
            agent newAgent = new agent();
            newAgent.setNewProperty(new property("position",agentPosition,"The position of the agent within the bounding box of the environment")  );
            newAgent.setNewBehaviour( behaviour_functions.getBehaviourList().get("movement") );
            newAgent.addNewBehaviourString("movement");
            newAgent.setNewBehaviour( behaviour_functions.getBehaviourList().get("boundaryCollision") );
            newAgent.addNewBehaviourString("boundaryCollision");
            
            newAgentsList.add(newAgent);
        }
        this.E.setAgents(newAgentsList);
        //System.out.println("Done");
    }
    // ------------------------------------------------------------------------------------------ //








    // ------------------------------------ Simulation methods ---------------------------------- //
    public void saveSimulationState(){
        this.E.saveState();
    }
    public void loadSimulationState(){
        env loadedEnv = this.E.loadState();
        this.E = env.newInstance(loadedEnv);
            // Return the behaviours to the agents after deserialization (removed 
            // beforehand due to issues with serialization of Bifunction object)
        for (int i=0; i < this.E.getAgents().size(); i++)
        {
            agent cAgent = this.E.getAgent(i);
            //System.out.println("Behaviour strings post load: " + cAgent.getBehaviourStrings());
            ArrayList<behaviour> newBehaviours = new ArrayList<behaviour>();
            for (String behaviourString : cAgent.getBehaviourStrings())
            {
                newBehaviours.add( behaviour_functions.getBehaviourList().get(behaviourString) );
            }
            cAgent.setBehaviours(newBehaviours);
        }
    }


    public void simulate(int iters)
    {
        env bufferEnv = new env();

            // Set the simulation buffer so that we dont get agent order corruptions
        bufferEnv = env.newInstance(E);
        for (int i = 0; i < iters; i++)
        {
            bufferEnv = getEnv().executeAgentBehaviours(bufferEnv);
            E = env.newInstance(bufferEnv);
            master.writeIteration();
        }
        //System.out.println("    -Completed " + iters + " iterations of simulation");
    }

    public int intify(Double tar){
        return (int)Math.round(tar);
    }

    // ------------------------------------------------------------------------------------------ //
}
