import java.lang.reflect.Method;
import java.lang.reflect.Field;

board workshopBoard;

void setup()
{
    fullScreen();

    workshopBoard = new board("workshopBackground.png");

    scenario1();

    //println("tests run result: ", testApi());
}

void draw()
{
    background(255);

    workshopBoard.draw();

    fill(255*abs(sin((float)frameCount/60.0)));
    ellipse(470,520,width/100,width/100);
}


// Game classes

interface item
{
    public String itemId           = "-1";
    public boolean canOccupyNormal = true;
    public boolean overlapAllowed  = false;
    public boolean gridLocked      = true;

    //Need a variable for shape (maybe a list of spaces?)
    public ArrayList<space> shape = new ArrayList<space>();
    
    public PImage face = null;

    void draw();
}

interface ingredient extends item
{
    boolean transformable = true;
    boolean purchasable   = true;
    boolean compostable   = true;
    boolean moveable      = true;

    void transform();
}

class abstractIngredient implements ingredient
{
    abstractIngredient() {}
    
    void draw() 
    {
        println("trying to draw...");
        try {
            println("drawing face");
            image(face,0,0);
        } catch (Exception e) {
            println("couldntDraw");
        }
    }
    void transform() {}
}


class testMushroom extends abstractIngredient
{
    PImage face;
    String itemId;

    testMushroom()
    {
        face   = loadImage("cactus/cactus_fruit_icon.png");
        itemId = "testMushroom";
    }

    void draw() 
    {
        println("trying to draw...");
        try {
            println("drawing face");
            image(face,0,0);
        } catch (Exception e) {
            println("couldntDraw");
        }
    }
}

interface consumable extends item
{
    boolean hasBeenActivated   = false;
    boolean specialStorability = true;
    boolean moveable           = true;

    void activate();
}

class abstractConsumable implements consumable
{
    abstractConsumable() {}

    void draw() {}
    void activate() {}
}

interface augment extends item
{
    boolean hasBeenActivatedThisTurn = false;
    boolean specialStorability       = true;
    boolean moveable                 = true;

    void activate();
}

class abstractAugment implements augment
{
    abstractAugment() {}

    void draw() {}
    void activate() {}
}


interface equiptment extends item
{
    boolean moveable      = false;
    boolean exhaustive    = true;
    boolean transformable = true;

    void transform();
    void activate();
}

class abstractEquiptment implements equiptment
{
    abstractEquiptment() {}

    void draw()      {}
    void transform() {}
    void activate()  {}
}


class installation
{
    //Need a variable for shape (maybe a list of spaces?)
    ArrayList<space> shape;
    boolean moveable;
    ArrayList<space> associatedSpaces;

    installation() {}

    void draw() {}
}


class space
{
    // Space positions in overall board !!may need to be improved
    int x;
    int y;

    boolean active;
    item heldItem;

    space(boolean iactive, int ix, int iy) 
    {
        x = ix;
        y = iy;

        heldItem = null;
        active   = iactive;
    }

}



class board
{
    float spaceSize;

    PVector origin;
    ArrayList<space> spaceList;
    ArrayList<ingredient>  ingredients;
    ArrayList<consumable>  consumables;
    ArrayList<augment>     augments;
    ArrayList<equiptment>  equiptments;
    ArrayList<installation> installations;

    PImage face;

    board(String faceLoc)
    {
        spaceList     = new ArrayList<space>();
        ingredients   = new ArrayList<ingredient>();
        consumables   = new ArrayList<consumable>();
        augments      = new ArrayList<augment>();
        equiptments   = new ArrayList<equiptment>();
        installations = new ArrayList<installation>();

        face = loadImage(faceLoc);
        face.resize( floor(face.width * ((float)height / (float)face.height)), height );

        spaceSize = face.height / 23;

        //origin = new PVector((width-face.width)/2,0);
        origin = new PVector(0,0);
        
        //Add the space squares
        for (int x = 0; x < 42; x++)
        {
            for (int y = 0; y < 23; y++)
            {
                spaceList.add(  new space(true,x,y)  );
            }
        }
        
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        translate(origin.x,origin.y);

        image(face,0,0);

        /* //Draw all items
        */
        for (ingredient c_ingredient : ingredients)
        {
            c_ingredient.draw();
        }
        for (consumable c_consumable : consumables)
        {
            c_consumable.draw();
        }
        for (augment c_augment : augments)
        {
            c_augment.draw();
        }
        for (equiptment c_equiptment : equiptments)
        {
            c_equiptment.draw();
        }


        /* //Draw all installations
        */
        for (installation c_installation : installations)
        {
            c_installation.draw();
        }

        /* //Draw the grid for debugging
        */
        for (space c_space : spaceList)
        {
            pushMatrix();
            pushStyle();

            translate(c_space.x*spaceSize , c_space.y*spaceSize);
            rectMode(CORNER);
            noFill();
            if (!c_space.active)
            {
                fill(0);
            }
            stroke(0,50);
            strokeWeight(spaceSize/20.0);
            rect(0,0,spaceSize,spaceSize);

            popStyle();
            popMatrix();
            
        }   

        popStyle();
        popMatrix();
    }
}




boolean testApi()
{
    try
    {
        //item item1                  = new item();
        //ingredient ingredient1      = new ingredient();
        //consumable consumable1      = new consumable();
        //augment augment1            = new augment();
        //equiptment equiptment1      = new equiptment();
        installation installation1  = new installation();
        space space1                = new space(true,-1,-1);
        board board1                = new board("");


        // Checking all the fields and methods of the classes in
        // the game

            //Item class methods and fields//
        println("--ITEM--");
        Method[] methods = item.class.getDeclaredMethods();
        Field[] fields   = item.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //ingredient class methods and fields//
        println("--INGREDIENT--");
        methods = ingredient.class.getDeclaredMethods();
        fields  = ingredient.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //consumable class methods and fields//
        println("--CONSUMABLE--");
        methods = consumable.class.getDeclaredMethods();
        fields  = consumable.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //augment class methods and fields//
        println("--AUGMENT--");
        methods = augment.class.getDeclaredMethods();
        fields  = augment.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //equiptment class methods and fields//
        println("--EQUIPTMENT--");
        methods = equiptment.class.getDeclaredMethods();
        fields  = equiptment.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //installation class methods and fields//
        println("--INSTALLATION--");
        methods = installation.class.getDeclaredMethods();
        fields  = installation.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //space class methods and fields//
        println("--SPACE--");
        methods = space.class.getDeclaredMethods();
        fields  = space.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

            //board class methods and fields//
        println("--BOARD--");
        methods = board.class.getDeclaredMethods();
        fields  = board.class.getDeclaredFields();
        println("   -> METHODS:");
        for (Method c_method : methods) {println(c_method);}
        println("   -> FIELDS:");
        for (Field  c_field  : fields)  {println(c_field);}

        println("");
    } catch(Exception e)
    {
        println("     -> EXCEPTION THROWN: ", e);
        return false;
    }
    return true;
}



void scenario1()
{
    for (int i = 0; i < 3; i++)
    {
        testMushroom exampleIngredient = new testMushroom();
        workshopBoard.ingredients.add( exampleIngredient );
    }
}



void mousePressed()
{
}
