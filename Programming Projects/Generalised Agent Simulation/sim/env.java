package sim;

import java.util.ArrayList;
import java.io.Serializable;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class env implements Serializable {
    /*
        Environment class

        The simulation contains Agents (agts) that interact with
        an Environment (env). The env has properties that can be
        manipulated by the agts and itself contains the agts,
        thereby allowing the agts to interact with eachother as
        another property.
        
        
        ArrayList<agent> agents;         - ArrayList of agts within the env.
        ArrayList<property> properties;  - ArrayList containing all the properties
                                         that the agts can interact with and their 
                                         interaction behaviours.



        Interaction:
        Agts should probe this class by requesting information about the different
        properties (agts or otherwise) to be returned and also requesting changes 
        to be made to those properties via methods that coordinate all the requests 
        from other agts ensuring no clashing results in the final env. 

    */

    private static final long serialVersionUID = 14672609912364060L;

    // List of agts within the env
    private ArrayList<agent>    agents; 

    // List of properties that the env has/manages
    private ArrayList<property> properties;


    public env()
    {
        agents = new ArrayList<agent>();
        properties = new ArrayList<property>();
    }
    public env(env newEnv)
    {
        this.agents = new ArrayList<agent>();
        this.properties = new ArrayList<property>();

        /*
            Firstly, new agent and property lists are constructed to remove 
            all pointer references from the other env, then they are assigned
            as the values of the real lists
        */

        // Create and fill the new agent list
        for (int i = 0; i < newEnv.getAgents().size(); i++)
        {
            agent cAgent   = newEnv.getAgent(i);
            agent newAgent = agent.newInstance(cAgent);
            this.agents.add( agent.newInstance(newAgent));
        }

        // Create and fill the new property list
        for (int i = 0; i < newEnv.getProperties().size(); i++)
        {
            property cProperty   = newEnv.getPropertyByInd(i);
            property newProperty = property.newInstance(cProperty);
            this.properties.add(newProperty);
        }
    }
    public env(env newEnv, boolean serial)
    {
        this.agents = new ArrayList<agent>();
        this.properties = new ArrayList<property>();

        /*
            Firstly, new agent and property lists are constructed to remove 
            all pointer references from the other env, then they are assigned
            as the values of the real lists
        */

        // Create and fill the new agent list
        for (int i = 0; i < newEnv.getAgents().size(); i++)
        {
            agent cAgent   = newEnv.getAgent(i);
            agent newAgent = agent.newSerializableInstance(cAgent, serial);
            this.agents.add(newAgent);
        }

        // Create and fill the new property list
        for (int i = 0; i < newEnv.getProperties().size(); i++)
        {
            property cProperty   = newEnv.getPropertyByInd(i);
            property newProperty = property.newInstance(cProperty);
            this.properties.add(newProperty);
        }
    }


    // ------------------------------------------- public get/set methods ----------------------------------------- //

    public property getProperty(String reqName)
    {
        property retProperty = null;
        for (property cProperty : properties)
        {
            if (cProperty.getName().equals(reqName))
            {
                retProperty = property.newInstance(cProperty);
            }
        }
        return retProperty;
    }
    public property getPropertyByInd(int i) {return properties.get(i);}
    public ArrayList<property> getProperties() {return properties;}
    public void setProperties(ArrayList<property> newProperties) {properties = newProperties;}
    public void setProperty(int i, property newProperty)
    {
        if (i<properties.size()) {properties.remove(i);}
        properties.add(i, newProperty);
    }
    public void setNewProperty(property newProperty) 
    {
        int pInd = getProperties().size();
        setProperty(pInd, newProperty);
    }





        // General get/set for agents
    public agent getAgent(int i) { return agents.get(i); }
    public agent getAgentByid(Long id)        
    {
        for (agent cAgent:getAgents())
        {
            if (cAgent.getId() == id){return cAgent;}       
        }
        return null;
    }
    public ArrayList<agent> getAgents() { return agents; }
    public void setAgent(agent newAgent, int ind)
    { 
        agents.remove(ind); 
        agents.add(ind, newAgent);
    }
    public void setAgentById(agent newAgent, int id)
    { 
        for (int i = 0; i < getAgents().size(); i++)
        {
            if (getAgent(i).getId() == id)
            {
                agents.remove(i); 
                agents.add(i, newAgent);
            }
        }
    }
        // Last agent specific version of get/set for easy coding
    public agent getLastAgent(){ return agents.get(agents.size()-1); }
    public void setLastAgent(agent newAgent)
    { 
        this.agents.remove(this.agents.size()-1); 
        this.agents.add( agent.newInstance(newAgent) );
    }
    public void setAgents(ArrayList<agent> newAgents) 
    {
        agents = new ArrayList<agent>();
        for (int i = 0; i < newAgents.size(); i++)
        {
            agents.add( newAgents.get(i) );
        }
        //System.out.println("Done");
    }
    public void setNewAgent(agent newAgent) {this.agents.add(newAgent);}


    public static env newInstance(env E)
    { return new env(E); }
    public static env newSerializableInstance(env E)
    { return new env(E, true); }


    // ------------------------ Simulation methods -------------------------- //

    public env executeAgentBehaviours(env bufferEnv)
    {
        ArrayList<agent> agentList = getAgents();
        for (agent cAgent : agentList)
        {
                // Executing all the behaviours of each agent on the buffer env (based on the realEnv information)
            bufferEnv = cAgent.executeBehaviour(bufferEnv, this);
        }
        return bufferEnv;
    }


    public void saveState(){
            // Makes a new version of the environment that is serializable (removes the agent...
            // ... dependance on behaviour functions)
        
        //System.out.println("Behaviour strings pre-serializable conversion: " + this.getLastAgent().getBehaviourStrings());
        env serializableEnv = env.newSerializableInstance(this);
        try {
            FileOutputStream fileOut = new FileOutputStream("C:\\SaveStateLoc\\obj.txt\\");
            ObjectOutputStream objectOut = new ObjectOutputStream(fileOut);
            objectOut.writeObject(serializableEnv);
            //System.out.println("Behaviour strings pre-save: " + serializableEnv.getLastAgent().getBehaviourStrings());
            objectOut.close();
            //System.out.println("The Object  was succesfully written to a file");
 
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    public env loadState(){
        // Loads a version of the environment that is serialized (removed the agent...
        // ... dependance on behaviour functions)
        try {
            FileInputStream fileIn = new FileInputStream("C:\\SaveStateLoc\\obj.txt\\");
            ObjectInputStream objectIn = new ObjectInputStream(fileIn);

            Object obj = objectIn.readObject();

            //System.out.println("The Object has been read from the file");
            objectIn.close();
            return (env)obj;

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
}
