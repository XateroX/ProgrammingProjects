void findHoveredType(int n){
  if(Tiles.get(n).type == 8)   //If interacting with tree
    {
     addItemToInventory("Sticks", 1);
    }
  if(Tiles.get(n).type == 9)   //If interacting with water
  {
    addItemToInventory("Water Bucket", 1);
  }
}


void addItemToInventory(String itemName, int quantity){
  itemInInventory = false;
  for(int i=0; i<user.inventoryItems.size(); i++)  //Is item in inventory?
  {
    if(user.inventoryItems.get(i) == itemName){
    itemInInventory = true;
    itemInInventoryInd = i;}
  }
  if(itemInInventory == true)                      //If item already in inventory / under max limit
  {
    itemInInventoryVal = user.inventoryQuantity.get(itemInInventoryInd);
    itemInInventoryVal += quantity;
    user.inventoryQuantity.remove(itemInInventoryInd);
    user.inventoryQuantity.add(itemInInventoryInd, itemInInventoryVal);  //##Index, then value##//
  }
  else                                             //If item not in inventory
  {
    user.inventoryItems.add(itemName);
    user.inventoryQuantity.add(quantity);
  }
}


//##SHOULD BE WORKING, POSSIBLY NOT???##//
void addItemToContainer(String itemName, int quantity, int containerType, int containerNum){
  Container currentContainer = ((Container)(containerList.get(containerType).get(containerNum)));
  itemInContainer = false;
  for(int i=0; i<currentContainer.contentItem.size(); i++)  //Is item in container?
  {
    if(currentContainer.contentItem.get(i) == itemName){
    itemInContainer = true;
    itemInContainerInd = i;}
  }
  if(itemInContainer == true)                      //If item already in container / under max limit
  {
    itemInContainerVal = containerList.get(containerType).get(containerNum).contentQuantity.get(itemInContainerInd);
    itemInContainerVal += quantity;
    containerList.get(containerType).get(containerNum).contentQuantity.remove(itemInContainerInd);
    containerList.get(containerType).get(containerNum).contentQuantity.add   (itemInContainerInd, itemInContainerVal);  //**Index, then value**//
  }
  else                                             //If item not in container
  {
    containerList.get(containerType).get(containerNum).contentItem    .add(itemName);
    containerList.get(containerType).get(containerNum).contentQuantity.add(quantity);
  }
}

void displayGhost(int n, int tWidth, int tHeight){
  //n       = mouse tile
  //tWidth  = tiles wide
  //tHeight = tiles tall ##SHOULD ALWAYS BE = tWidth FOR NOW => NOT REALLY USED CURRENTLY##
  
  //Will draw at bottom left-most corner
  //Will fill other tiles with no specific colliders
  
  //Red ghost   = something in the way
  //Green ghost = nothing in the way
  
  //Returns whether structure is placeable in given region
  
  borderIndicesFinal = findTileBorderIndices(n, tWidth);
  pushStyle();
  imageMode(CENTER);
  
  for(int i=0; i<borderIndicesFinal.size(); i++)
  {
    rightTemp = (i % tWidth) - floor(tWidth/2);
    downTemp  = floor(i / tWidth) - floor(tHeight/2);  //##MAYBE NOT HEIGHT, SHOULD BE FINE FOR MOST CASES HOWEVER##//
    borderTile = n + (rightTemp) + (colNum*downTemp);
    relativeObjPos = findRelativeCoordinates(borderTile);
    if(borderIndicesFinal.get(i) <= 0){                                //If tile empty     => can place
      image(greenBuildingGhost, relativeObjPos.x, relativeObjPos.y);
    }
    else{                                                              //If tile not empty => cannot place
      image(redBuildingGhost, relativeObjPos.x, relativeObjPos.y);
    }
  }
  
  popStyle();
}

boolean calcStructurePlaceable(int n, int tWidth, int tHeight){
  //n       = mouse tile
  //tWidth  = tiles wide
  //tHeight = tiles tall ##SHOULD ALWAYS BE = tWidth FOR NOW => NOT REALLY USED CURRENTLY##
  
  //Will draw at bottom left-most corner
  //Will fill other tiles with no specific colliders
  
  //Returns whether structure is placeable in given region
  
  borderIndicesFinal = findTileBorderIndices(n, tWidth);
  
  structurePlaceable = true;
  for(int i=0; i<borderIndicesFinal.size(); i++)
  {
    rightTemp = (i % tWidth) - floor(tWidth/2);
    downTemp  = floor(i / tWidth) - floor(tHeight/2);  //##MAYBE NOT HEIGHT, SHOULD BE FINE FOR MOST CASES HOWEVER##//
    borderTile = n + (rightTemp) + (colNum*downTemp);
    relativeObjPos = findRelativeCoordinates(borderTile);
    if(borderIndicesFinal.get(i) > 0)  //If not tile empty     => cannot place
    {
      structurePlaceable = false;
    }

  }
  
  return structurePlaceable;
}

//## COULD MAYBE ADD A QUANOTTY ARGUEMENT, SHOWNING TEXTURES WITH MORE ITEMS IF LOTS OF ITEMS ,POSSIBLY ##//
void drawGeneralIcon(String itemName){
  if(itemName == "Sticks")
  {
    //pass
  }
  if(itemName == "Water Bucket")
  {
    //pass
  }
  if(itemName == "Spade")
  {
    //pass
  }
  if(itemName == "Seeds")
  {
    //pass
  }
}

void textFormatted(String displayText, PVector displayPosition, int displaySize, PVector textBoxDim, PVector textColour){
  //displayText     = The text needed to be drawn
  //displayPosition = The position of where the text will be drawn from (**the X is the CENTER, and the Y is the TOP**)
  //displaySize     = The size of the text
  //textBoxDim      = The width and height of the text box (that the text will be drawn within)
  //textColour      = The RGB colour of the text
  //## EITHER HAVE "textSize" AS AN ARGUEMENT OR CALCULATE HERE ##//

  //(1)Split text into words (one at a time)
  //(2)Determine if the word will fit in the box;
  //  (3)If it will, add to end of current line
  //  (4)If not, move it to the next line
  //(5)Repeat until at end of the text
  //(6)Translate to custom font (NOT REQUIRED)
  //(7)Display the text (at position specified)

  textSeparated.clear();  //Reset variable values
  sentenceLength = 0;     //
  textWord = "";          //
  textLine = "";          //

  //println("###### STARTING ######");                //*****//
  for(int i=0; i<displayText.length(); i++)           //Go through all characters in the text you want to display
  {
    textCharacter = displayText.substring(i, i+1);    //**Includes 1st arguement, discludes 2nd**//
    //println("Character;",textCharacter,";");        //*****//

    //## if (p.equals("potato"))
    //Form the next word
    if( !textCharacter.equals(" ") )                  //Keep going until end of the word
    {
      sentenceLength++;
      textWord      = textWord + textCharacter;       //Stick next character to end of last, forming the word
    }
    else
    {
      //Determine which line word is to be placed in
      if( (sentenceLength*displaySize) < textBoxDim.x )  //If the word WILL fit in the text box
      {
        //Add to end of current line
        textLine = textLine + " " + textWord;
      }
      else  //If the word will NOT fit in the text box
      {
        //Start a new line
        textSeparated.add( textLine );      //Fill that line with what fits
        textLine = textWord;                //Place current word in next slot ready
        sentenceLength = textLine.length(); //Reset sentence length
      }

      textWord = "";

    }
    //## MAY CAUSE PROBLEMS WITH LAST SENTENCE BEING 1 CHARCTER TOO LARGE ##//
    if( i == (displayText.length() -1) )  //If at end of the text...
    {

      textLine = textLine + " " + textWord;
      textSeparated.add( textLine );

    }

  }
  //Translate to custom font
  //## WILL NEED MORE ARGUEMENTS IF MORE CUSTOM FONTS ARE ADDED ##//
  translateCustomText = false;


  //Draw the text formatted
  if( translateCustomText == false )  //DO NOT translate
  {

    pushStyle();
    textSize(displaySize);
    textAlign(CENTER);
    fill(textColour.x, textColour.y, textColour.z);
    for(int i=0; i<textSeparated.size(); i++) //Go through all lines...
    {
      //Draw each line from the CENTER
      text( textSeparated.get(i), displayPosition.x, (displayPosition.y + ( (i+1)*(displaySize) )) );
    }
    popStyle();

  }
  if( translateCustomText == true )  //Do translate
  {

    for(int i=0; i<textSeparated.size(); i++)             //Go through each line...
    {
      textLine = textSeparated.get(i);
      for(int j=0; j<textSeparated.get(i).length(); j++)  //Go through each character in line...
      {
        textCharacter = textLine.substring(j,j+1);
        //If it is a space, it will leave the slot empty
        if(textCharacter.equals("a")){
          image(    a_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("A")){
          image(    A_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("b")){
          image(    b_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("B")){
          image(    B_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("c")){
          image(    c_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("C")){
          image(    C_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("d")){
          image(    d_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("D")){
          image(    D_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("e")){
          image(    e_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("E")){
          image(    E_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("f")){
          image(    f_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("F")){
          image(    F_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("g")){
          image(    g_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("G")){
          image(    G_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("h")){
          image(    h_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("H")){
          image(    H_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("i")){
          image(    i_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("I")){
          image(    I_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("j")){
          image(    j_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("J")){
          image(    J_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("k")){
          image(    k_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("K")){
          image(    K_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("l")){
          image(    l_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("L")){
          image(    L_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("m")){
          image(    m_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("M")){
          image(    M_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("n")){
          image(    n_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("N")){
          image(    N_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("o")){
          image(    o_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("O")){
          image(    O_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("p")){
          image(    p_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("P")){
          image(    P_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("q")){
          image(    q_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("Q")){
          image(    Q_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("r")){
          image(    r_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("R")){
          image(    R_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("s")){
          image(    s_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("S")){
          image(    S_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("t")){
          image(    t_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("T")){
          image(    T_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("u")){
          image(    u_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("U")){
          image(    U_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("v")){
          image(    v_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("V")){
          image(    V_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("w")){
          image(    w_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("W")){
          image(    W_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("x")){
          image(    x_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("X")){
          image(    X_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("y")){
          image(    y_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("Y")){
          image(    Y_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("z")){
          image(    z_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }
        if(textCharacter.equals("Z")){
          image(    Z_DefaultHLI, displayPosition.x + (displaySize*j) - textBoxDim.x/2, (displayPosition.y + ( (i+1)*(displaySize) )), displaySize, displaySize    );
        }

      }
    }

  }

  //println("###### ENDING ######");          //*****//

}
