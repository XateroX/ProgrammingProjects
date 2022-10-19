ArrayList<Integer> stdNetwork           = new ArrayList<Integer>();
ArrayList<ArrayList<fruit>> sys2Fruits  = new ArrayList<ArrayList<fruit>>();
ArrayList<lizard> lizards               = new ArrayList<lizard>();
ArrayList<PVector> fruitPosSets         = new ArrayList<PVector>();
int lizardNumber = 200;

int wantedRound = 1000;
int roundNumber = 0;
float roundTime = 0.0;
float timeMax   = 20.0*60.0;
int frameSkip   = 100;

int standardSize     = 6;        //Adjust these **
float standardLength = 10.0;     //
int fruitNumber      = 8;
float fruitDetectRad = 250.0;
float eOffset        = 200.0;

boolean lowPolyMode = false;