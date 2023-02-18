package sim;

import java.util.ArrayList;
import java.io.Serializable;

public class agent implements Serializable {
    /*
        Agent class

        Within the simulation environment (env) exists agents (agts)
        that interact with both the other agts and the env properties.

        The agts acquire new behaviours by being supplied with a new
        set of (Observation, Logic, Action) tuples. Each tuple defines 
        a type of behaviour that the agt can experience. The tuple 
        dictates that each tick the agt conducts the 'Observation'
        (obs) then checks the logic (log) and if the logic resolves to 
        true then enacts the action (act). This action is then placed
        in the queue of actions for this tick and the env resolves them
        accoring to the simulations rules for property manipulation.


        Long id;                         - The id number for this agt.
        Long creationTick;               - The tick number that the
                                          simulation was in when the 
                                          agt was instantiated.
        ArrayList<property> properties;  - The list of properties of
                                          the agt that can be 
                                          manipulated and referenced (observed).
        ArrayList<behaviour> behaviours; - The list of behaviour tuples
                                          that the agt uses to engage 
                                          with the env.
        ArrayList<propertyGoal> selfPropertyGoals;
        ArrayList<propertyGoal> envPropertyGoals;
                                         - Sets of associations that specify
                                          the goals of the agt (if any) wrt
                                          specific properties of itself and
                                          the env.   
    */ 
    private static final long serialVersionUID = 14206726099123060L;                     


    // The id number for this agt
    private Long id;

    // The tick number that the simulation was in when the agt was instantiated
    private Long creationTick;

    // The list of properties of the agt that can be manipulated and referenced (observed)
    private ArrayList<property> properties;

    // The list of behaviour tuples that the agt uses to engage with the env
    private ArrayList<behaviour> behaviours;
    private ArrayList<String> behaviourList;

    // Sets of associations that specific the goals of the agt (if any) wrt specific properties of itself and the env
    private ArrayList<propertyGoal> selfPropertyGoals;
    private ArrayList<propertyGoal> envPropertyGoals;


    public agent()
    {
        id = Math.round(Math.random()*1000000);
        //System.out.println(id);
        creationTick = 0L;

        properties = new ArrayList<property>();
        behaviours = new ArrayList<behaviour>();
        behaviourList = new ArrayList<String>();

        selfPropertyGoals = new ArrayList<propertyGoal>();
        envPropertyGoals  = new ArrayList<propertyGoal>();
    }




    // -------------------------------- public get/set methods ------------------------------------------- //
    public property getProperty(String reqName)
    {
        property retProperty = null;
        for (property cProperty : properties)
        {
            if (cProperty.getName().equals(reqName))
            {
                retProperty = cProperty;
            }
        }
        return retProperty;
    }
    public property getPropertyByInd(int ind) {return properties.get(ind);}
    public ArrayList<property> getProperties() {return properties;}
    public void setProperty(int i, property newProperty)
    {
        if (i<properties.size()) {properties.remove(i);}
        properties.add(i, newProperty);
    }
    public void setProperty(String propName, property newProperty)
    {
        for (int i = 0; i < properties.size(); i++)
        {
            if (properties.get(i).getName().equals(propName))
            {
                properties.remove(i);
                properties.add(i, newProperty);
                //System.out.println("Set property");
                break;
            }
        }
    }
    public void setNewProperty(property newProperty) {setProperty(properties.size(), newProperty);}
    public void setProperties(ArrayList<property> newProperties) {properties = newProperties;}



    public ArrayList<behaviour> getBehaviours() {return behaviours;}
    public behaviour getBehaviourByInd(int ind) {return behaviours.get(ind);}
    public ArrayList<String> getBehaviourStrings() {return behaviourList;}
    public void setNewBehaviour(behaviour newBehaviour) 
    {
        behaviours.add(newBehaviour);
        //behaviourList.add(newBehaviour.getName());
    }
    public void setBehaviours(ArrayList<behaviour> newBehaviours) 
    {
        this.behaviours = new ArrayList<behaviour>();
        for (int i = 0; i < newBehaviours.size(); i++)
        {
            this.behaviours.add(newBehaviours.get(i));
        }
    }
    public void addNewBehaviourString(String newString) {behaviourList.add(newString);}


    public void setId(Long newId) {id = newId;}


    public Long getCreationTick() {return Long.valueOf(creationTick.longValue());}
    public void setCreationTick(Long newCreationTick) {creationTick = newCreationTick;}

    

    public agent(agent copy_agent){
        properties = new ArrayList<property>();

        this.creationTick = copy_agent.getCreationTick();
        this.id = copy_agent.getId();
        this.behaviours = new ArrayList<behaviour>();
        this.behaviourList = new ArrayList<String>();
        for (behaviour c_behaviour : copy_agent.getBehaviours()){
            behaviour newBehaviour = behaviour.newInstance(c_behaviour);
            behaviours.add(newBehaviour);
        }
        for (String cBehaviourString : copy_agent.getBehaviourStrings())
        {
            behaviourList.add(cBehaviourString);
        }
        for (property c_property : copy_agent.getProperties()){
            property newProperty = property.newInstance(c_property);
            properties.add(newProperty);
        }
        
        this.selfPropertyGoals = new ArrayList<propertyGoal>();
        this.envPropertyGoals  = new ArrayList<propertyGoal>();
    }
    public agent(agent copy_agent, boolean serial){
        this.properties = new ArrayList<property>();
        this.behaviours = new ArrayList<behaviour>();
        this.behaviourList = new ArrayList<String>();

        this.creationTick = copy_agent.getCreationTick();
        this.id = copy_agent.getId();
        for (property c_property : copy_agent.getProperties()){
            property newProperty = property.newInstance(c_property);
            this.properties.add(newProperty);
        }
        for (String cbehaviourString : copy_agent.getBehaviourStrings())
        {
            this.behaviourList.add(cbehaviourString);
        }
        
        this.selfPropertyGoals = new ArrayList<propertyGoal>();
        this.envPropertyGoals  = new ArrayList<propertyGoal>();
    }
    public static agent newInstance(agent copy_agent){
        return new agent(copy_agent);
    }
    public static agent newSerializableInstance(agent copy_agent, boolean True){
        return new agent(copy_agent, True);
    }


    public long getId() {return id;}

    // --------------------------------- Simulation methods ----------------------------------- //

    public env executeBehaviour(env bufferEnv, env realEnv)
    {
        for (behaviour cBehaviour : getBehaviours())
        {
            ArrayList<Object> obsvn = cBehaviour.executeObsFn(realEnv,       getId());
            Boolean logicResult     = cBehaviour.executeLogFn(obsvn,         getId(), realEnv);
            if (logicResult) {bufferEnv = cBehaviour.executeActFn(bufferEnv, getId());}
        }
        return bufferEnv;
    }
}
