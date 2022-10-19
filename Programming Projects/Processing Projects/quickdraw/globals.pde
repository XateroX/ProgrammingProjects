/*
fCharacters = characters currently fighting
bCharacters = characters in a buffer
all characters in fCharacters fight, scoring (e.g 1st, 2nd, 3rd, ...) obviously based on how close the hit to the indicator
*/
ArrayList<character> fCharacters = new ArrayList<character>();
ArrayList<character> bCharacters = new ArrayList<character>();
character cPlayer;

ArrayList<parry> parrys = new ArrayList<parry>();
int roundTimer = 0;
boolean roundStarted  = false;
boolean indicatorSent = false;
boolean roundOver     = false;
int indicatorTimer = 0;
PVector iPos = new PVector(0,0);

int nPlayers    = 1;    //How many players there are
int playerTurn  = 0;    //Which player's turn it is now
ArrayList<Integer> playerScores = new ArrayList<Integer>();

int animTime        = 60*3;
int graceTime       = 60*4;     //## SHOULD DECREASE AS ROUNDS PROGRESS, RANDOMNESS BECOMES MORE VARIED E.G LOWER LIKELY ##
int roundMaxTime    = 60*5;     //Maximum time AFTER indicator sent before moving on
int minReactionTime = 18;       //human reaction time ~0.283s => ~17 frames
int parryTime       = 2;        //Time allowed for a parry to occur
int parryTimeOffset = 45;       //'Grace' time after parrying

ArrayList<PImage> mStages = new ArrayList<PImage>();    //Main
ArrayList<PImage> bStages = new ArrayList<PImage>();    //Background
ArrayList<PImage> fStages = new ArrayList<PImage>();    //Foreground
int cStage   = 0;   //Current stage
int maxStage = 3;   //Number of stages available

boolean typeBots    = false;
boolean typePlayer  = false;
boolean typeAuto    = false;

boolean screenHome = true;
boolean screenGame = false;

boolean menuOverlay = true;
boolean menuResults = false;
boolean menuLost    = false;
boolean menuScores  = false;

ArrayList<button> buttons = new ArrayList<button>();