/*
GameManager - For each program within the program, 
encapsulate the entire program and its classes in a
new class and call it whatever you like. Then add it
to the structure below as the rest are.



TODO list:

P: Concurrent editing of the gameStates array
S: Make a buffer array, at the end of each cycle of draw,
   swap the arrays and clear the buffer

P: Kirby assest are read in 'manually' (the loads are not looped or automatic based on folders)
S: Copy the animator program to make the loader methods

P: Long to type new classes
S: Interfaces

*/


class gameManager
{
    ArrayList<Integer> gameStatesBuffer;
    ArrayList<Integer> gameStates;
    mainScreen s1;
    mainScreen  s2;
    mainScreen s3;
    mainScreen s4;
    mainScreen s5;
    boolean bufferSwapped;

    gameManager()
    {
        bufferSwapped    = false;
        gameStatesBuffer = new ArrayList<Integer>();
        gameStates       = new ArrayList<Integer>();
        gameStates      .add(0);
        gameStatesBuffer.add(0);

        //0
        s1   = new mainScreen(this);
        //1
        s2   = new mainScreen(this);
        //2
        s3   = new mainScreen(this);
        //3
        s4   = new mainScreen(this);
        //4
        s5   = new mainScreen(this);

    }

    void currentStateDraw()
    {
        bufferSwapped=false;
        for (int c_gameState : gameStates)
        {
        
          if (c_gameState == 0) {s1.draw(); }
          if (c_gameState == 1) {s2.draw(); }
          if (c_gameState == 2) {s3.draw(); }
          if (c_gameState == 3) {s4.draw(); }
        
        }
        //println("gameStates: "+gameStates);
        //println("gameStatesBuffer: "+gameStatesBuffer);
    }


    void currentStateSetup()
    {
        /*
        Execute all the setup functions for the programs in the current state
        array for the game
        */
        for (int c_gameState : gameStates)
        {
          
          if (c_gameState == 0) {s1.setup(); }
          if (c_gameState == 1) {s2.setup(); }
          if (c_gameState == 2) {s3.setup(); }
          if (c_gameState == 3) {s4.setup(); }
        
        }
    }
    void stateSetup(int stateNumber)
    {
        /*
        Execute the setup function for a specific state program
        */
        
        
      if (stateNumber == 0) {s1.setup(); }
      if (stateNumber == 1) {s2.setup(); }
      if (stateNumber == 2) {s3.setup(); }
      if (stateNumber == 2) {s4.setup(); }
      
    }
    public void swapStateBuffer()
    {
        if (!bufferSwapped)
        {
            gameStates = new ArrayList<Integer>();
            for (int i = 0; i < gameStatesBuffer.size(); i++)
            {
            gameStates.add(gameStatesBuffer.get(i));
            }
            bufferSwapped = true;
        }
    }


    public void changeGameState(ArrayList<Integer> newGameStates)
    {
        /*
        Change the whole state array to a new state array
        */
        gameStatesBuffer = newGameStates;
        currentStateSetup();
    }
    public void removeStates(ArrayList<Integer> removalGameStates)
    {
        /*
        Remove states from the current state array for the game (removes all 
        states that are in the array)
        */
        for (int i = gameStates.size()-1; i >= 0; i--)
        {
            if ( removalGameStates.contains(gameStates.get(i)) )
            {
                gameStatesBuffer.remove(i);
            }
        }
    }
    public void addStates(ArrayList<Integer> addedGameStates)
    {
        /*
        Add new states to the state array for the game (adds one copy of 
        all states in the given array to the current state array)
        */
        for (int i = 0; i < addedGameStates.size(); i++)
        {
            gameStatesBuffer.add( addedGameStates.get(i) );
            stateSetup(addedGameStates.get(i));
        }
    }
    public ArrayList<Integer> getGameState()
    {
        return gameStates;
    }


    public void currentStateMousePressed()
    {
        for (int c_gameState : gameStates)
        {
          
          if (c_gameState == 0) {s1.mousePressed(); }
          if (c_gameState == 1) {s2.mousePressed(); }
          if (c_gameState == 2) {s3.mousePressed(); }
          if (c_gameState == 3) {s4.mousePressed(); }
        
        }
        swapStateBuffer();
    }
    
    public void currentStateMouseReleased()
    {
        for (int c_gameState : gameStates)
        {
            if (c_gameState == 0) {s1.mouseReleased(); }
            if (c_gameState == 1) {s2.mouseReleased(); }
            if (c_gameState == 2) {s3.mouseReleased(); }
            if (c_gameState == 3) {s4.mouseReleased(); }
        }
        swapStateBuffer();
    }
    
    public void currentStateKeyPressed()
    {
        for (int c_gameState : gameStates)
        {
        
          if (c_gameState == 0) {s1.keyPressed(); }
          if (c_gameState == 1) {s2.keyPressed(); }
          if (c_gameState == 2) {s3.keyPressed(); }
          if (c_gameState == 3) {s4.keyPressed(); }
        
        }
        swapStateBuffer();
    }
    
    public void currentStateKeyReleased()
    {
        for (int c_gameState : gameStates)
        {
          
          if (c_gameState == 0) {s1.keyReleased(); }
          if (c_gameState == 1) {s2.keyReleased(); }
          if (c_gameState == 2) {s3.keyReleased(); }
          if (c_gameState == 3) {s4.keyReleased(); }
        
        }
        swapStateBuffer();
    }
}
