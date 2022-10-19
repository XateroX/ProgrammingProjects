/*

GameLibrary is a java library for processing which allows the creation 
of simple games within processing.

The principle of the library is that games follow a flow which takes 
the user between different program types (games, menus, selection 
screens etc), and that the programming infrastructure should reflect this
design requirement.

class gameManager - class that contains the overarching logic which commands
                    what 'program' the main script should be showing the user.
                    This class is responsible for the following tasks:
                        -Responding to requests for information about different
                         modes (menu requesting game information, gam requesting
                         selection screen choices etc).
                        -Containing and managing the mode that the main script draws (the 'gamestate').
                        -Facilitating each program to have seperate keybinding management
                        -*Facilitating cross-program communication for the purposes of 
                         overlaying one mode ontop of another (meta-running of the scripts)
                        -*Allowing for some form of saving 


class animator    - class that allows for animated elements of scripts, including particles,
                    sprites and backgrounds
                    This class is responsible for the following tasks:
                        -Facilitating the creation of animated elements within a game


class mouseMaster - class that simplifies the task of checking mouse collision.
                    This class is responsible for the following tasks:
                        -Simplifying the process of calculating and managing mouse collision


class uiObject    - class that can be extended to create a variety of user interactable objects
                    within the context of the game
                    This class is responsible for the following tasks:
                        -Creating an easy to extend framework for user interactivity, including
                         buttons, sliders, windows and scrollable objects like menus and dropdowns
                        

Typical workflow with GameLibrary should look something like this:
1. Instantiate a gameManager
2. Provide multiple processing 'source' programs as the different modes that the game operates in 
   (these should assume themselves to be almost entirely independant from eachother excluding 
   SPECIFIC key information critical to the other programs)
3. Arrange these with gameManager into a general flow by labelling them as 'menu', 'game', 'select screen'
   etc. 
4. Use uiObjects and animators to construct good-looking gameplay assets for the game using existing assets
5. Put into place the logic for switching between the modes using the uiObjects as eventInstancers for this
   and the internal logic of each program to dictate the flow of the game.
6. Tune each program individually in their own contexts to make the pieces of the game work as intended.
7. Profit.



Below is the 'main' program for your game using this library. It contains the draw() and setup() functions that
will be treated as the default in your program.

*/



gameManager GameManager;

void settings()
{
    //size(1000,1000);
    fullScreen();
    //orientation(PORTRAIT);
}
void setup()
{
    GameManager = new gameManager();
    GameManager.currentStateSetup();
}

void draw()
{
    clear();
    GameManager.currentStateDraw();
}

void mousePressed()
{
    GameManager.currentStateMousePressed();
}

void mouseReleased()
{
    GameManager.currentStateMouseReleased();
}

void keyPressed()
{
  GameManager.currentStateKeyPressed();
}
void keyReleased()
{
  GameManager.currentStateKeyReleased();
}
