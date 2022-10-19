class flowControl
{
    String state;
    ArrayList<state> stateList;
    state currentState;

    flowControl()
    {
        state = "";
        currentState = null;

        stateList = new ArrayList<state>();
    }

    public void draw()
    {
        currentState.draw();
    }


    public void setState(state newState)
    {
        state = newState.name;
        currentState = newState;
    }

    public void addStateToStateList(state newState)
    {
        if (!stateList.contains(newState))
        {
            stateList.add(newState);
        }
    }

    public void printFlowTree()
    {
        currentState.printSubStateTree(currentState);
        for (state c_state : stateList)
        {
            c_state.haveBeenSubtreed=false;
        }
    }
}
