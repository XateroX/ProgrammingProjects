package sim;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.function.BiFunction;

@SuppressWarnings("unchecked")

public class behaviourFunctions implements Serializable{
    public Hashtable<String,behaviour> behaviourList;

    public behaviourFunctions()
    {
        behaviourList = new Hashtable<String,behaviour>();
        behaviourList.put( "boundaryCollision", new behaviour("boundaryCollision",ObsFn1,LogFn1,ActFn1) );
        behaviourList.put( "movement", new behaviour("movement",ObsFn2,LogFn2,ActFn2) );
    }



        // -- BoundaryCollision behaviour -- //

    // Observation function for the behaviour
    public BiFunction<env,Long,ArrayList<Object>> ObsFn1 = new BiFunction<env,Long,ArrayList<Object>>(){
        public ArrayList<Object> apply(env E, Long id)
        {
                // Here, output stores all of the reportable observations 
                    // In particular, this behaviour observes the difference in x-position of the last agent
            ArrayList<Object> output = new ArrayList<Object>();
            output.add( ((ArrayList<Double>)E.getAgentByid(id).getProperty("position").getValue()).get(0) - ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(0) );
            output.add( ((ArrayList<Double>)E.getAgentByid(id).getProperty("position").getValue()).get(1) - ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(1) );
            return output;
        }
    };
    // Logic function for the behaviour
    public BiFunction<ArrayList<Object>,Long, Boolean> LogFn1 = new BiFunction<ArrayList<Object>,Long, Boolean>(){
        public Boolean apply(ArrayList<Object> iobs, Long id)
        {
            return (Double)iobs.get(0) >= 0;
        }
    };
    // Action function for the behaviour
    public BiFunction<env,Long, env> ActFn1 = new BiFunction<env,Long, env>(){
        public env apply(env E, Long id)
        {
            //System.out.println(id + " CROSSED THE SIDE OF THE SCREEN!-");
            ArrayList<Double> oldPos = (ArrayList<Double>)E.getAgentByid(id).getProperty("position").getValue();
            Double deltaX = -oldPos.get(0) + ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(0);
            Double deltaY = -oldPos.get(1) + ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(1);
            ArrayList<Double> newPos = new ArrayList<Double>();
            if (oldPos.get(0) > ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(0))
            {newPos.add( ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(0) );}
            else if (oldPos.get(0) < 0)
            {newPos.add( 0.0D );}
            else
            {newPos.add(oldPos.get(0));}


            if (oldPos.get(1) > ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(1))
            {newPos.add( ((ArrayList<Double>)E.getProperty("boundingBox").getValue()).get(1) );}
            else if (oldPos.get(1) < 0)
            {newPos.add( 0.0D );}
            else
            {newPos.add(oldPos.get(1));}
            property newProperty = new property("position", newPos);
            agent bufferAgent = E.getAgentByid(id);
            bufferAgent.setProperty("position", newProperty);
            E.setAgentById(bufferAgent, Math.round(id));
            return E;
        }
    };






        // -- movement behaviour -- //

    // Observation function for the behaviour
    public BiFunction<env,Long,ArrayList<Object>> ObsFn2 = new BiFunction<env,Long,ArrayList<Object>>(){
        public ArrayList<Object> apply(env E, Long id)
        {
                // Here, output stores all of the reportable observations 
            return new ArrayList<Object>();
        }
    };
            // Observation function for the behaviour
    public BiFunction<ArrayList<Object>,Long, Boolean> LogFn2 = new BiFunction<ArrayList<Object>,Long, Boolean>(){
        public Boolean apply(ArrayList<Object> iobs, Long id)
        {
            return true;
        }
    };
            // Observation function for the behaviour
    public BiFunction<env,Long, env> ActFn2 = new BiFunction<env,Long, env>(){
        public env apply(env E, Long id)
        {
            agent me = E.getAgentByid(id);

            ArrayList<Double> pos = ((ArrayList<Double>)me.getProperty("position").getValue());
            Double x = pos.get(0);
            Double y = pos.get(1);

            ArrayList<Double> newPos = new ArrayList<Double>();
            x -= 3;
            y += 3;
            newPos.add(x); newPos.add(y);
            
            me.getProperty("position").setValue(newPos);
            E.setAgentById(me, (int)Math.round(id));
            return E;
        }
    };



        // -- ___ behaviour -- //

    public Hashtable<String,behaviour> getBehaviourList()
    {
        return behaviourList;
    }
}
