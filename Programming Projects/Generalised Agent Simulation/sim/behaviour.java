package sim;

import java.util.ArrayList;
import java.util.function.BiFunction;
import java.io.Serializable;

public class behaviour implements Serializable {
    /*
        Behaviour class

        This class contains and dictates the usage of a tuple of 
        functions which describe a possible behaviour of an agt. 
        It tries to generalize the addition of behaviour traits
        to agts by abstracting the cause and effect to existing
        properties of the env.

        String name;                - The name of the behaviour trait
                                     for easy future reference.
        Long id;                    - Serves the same purpose as the 
                                    name but in numerical form.
        Function<env,ArrayList<Object>> obsFn;
                                    - The observation function that 
                                    takes as input the whole env and 
                                    outputs the particular information
                                    that the logic function needs to 
                                    decide whether or not to act.
        Function<ArrayList<Object>,Boolean> logFn;
                                    - The logic function which takes the
                                    observation of the environment and
                                    makes a decision about the action
                                    choices of the behaviour.
        Consumer<Integer> actFn;    - The action function that makes the 
                                    changes the behaviour dictates should
                                    occur when the observation yields a 
                                    logical result of true.
    */

    private static final long serialVersionUID = 142067260991236400L;

    private BiFunction<env,               Long, ArrayList<Object>> obsFn;
    private BiFunction<ArrayList<Object>, Long, Boolean>           logFn;
    private BiFunction<env,               Long, env>               actFn;

    private String name;

    public behaviour(String iname, BiFunction<env, Long, ArrayList<Object>> iobsFn, BiFunction<ArrayList<Object>, Long, Boolean> ilogFn, BiFunction<env, Long, env> iactFn)
    {
        name = iname;

        obsFn = iobsFn;
        logFn = ilogFn;
        actFn = iactFn;
    }
    public behaviour(behaviour copy_Behaviour){
        this.name  = copy_Behaviour.getName();
        this.obsFn = copy_Behaviour.getObsFn();
        this.logFn = copy_Behaviour.getLogFn();
        this.actFn = copy_Behaviour.getActFn();
    } 
    public static behaviour newInstance(behaviour copy_behaviour){
        return new behaviour(copy_behaviour);
    }
    
    public ArrayList<Object> executeObsFn(env E, long id)
    {
        return obsFn.apply(E, id);
    }
    public Boolean executeLogFn(ArrayList<Object> obsvn, Long id, env E)
    {
        return logFn.apply(obsvn, id);
    }
    public env executeActFn(env E, long id)
    {
        E = actFn.apply(E, id);
        return E;
    }



    // --------------------------------------- Get/set methods --------------------------------------------------- //
    public String getName() {return name;}
    public BiFunction<env, Long, ArrayList<Object>>     getObsFn() {return obsFn;}
    public BiFunction<ArrayList<Object>, Long, Boolean> getLogFn() {return logFn;}
    public BiFunction<env, Long, env>                   getActFn() {return actFn;}

    public void setObsFn(BiFunction<env, Long, ArrayList<Object>>     newObsFn) {obsFn = newObsFn;}
    public void setLogFn(BiFunction<ArrayList<Object>, Long, Boolean> newLogFn) {logFn = newLogFn;}
    public void setActFn(BiFunction<env, Long, env>                   newActFn) {actFn = newActFn;}
}
