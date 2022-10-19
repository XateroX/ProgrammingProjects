class state
{
    // Recursive 'tree-like' definition of state linkage allows 
    // for flowing between states more smoothly, as only the states 
    // that can be reached are available to be transitioned to and from

    boolean active;
    String name;

    boolean haveBeenSubtreed;

    ArrayList<state> linkedStates;

    state(String iname)
    {
        active = false;
        haveBeenSubtreed = false;
        name = iname;
        linkedStates = new ArrayList<state>();
    }

    public void draw()
    {
    }

    public void update()
    {
    }

    public void addLinkedState(state newLinkedState)
    {
        if (!linked(newLinkedState))
        {
            linkedStates.add(newLinkedState);
            linkedStates.get( linkedStates.size() -1 ).addLinkedState(this);
        }
    }

    public boolean linked(state testState)
    {
        boolean isLinked = false;
        for (state c_state : linkedStates)
        {
            if (c_state.name.equals(testState.name))
            {   
                isLinked = true;
                break;
            }
        }
        return isLinked;
    }

    public void printSubStateTree(state parentState)
    {
        if (!haveBeenSubtreed)
        {
            println(name);
            for (state c_state : linkedStates)
            {
                println("<--> " + c_state.name);
                //print("(parentState.name="+parentState.name+"), (c_state)")
            }
            haveBeenSubtreed=true;
            for (state c_state : linkedStates)
            {
                if (!parentState.name.equals(c_state.name)) {c_state.printSubStateTree(this);}
            }
        }
    }
}