flowControl main_flowControl;
state home;
state recipies;
state cupboard;
state shopping; 

void setup()
{
    fullScreen();
    background(0);

    main_flowControl = new flowControl();

    home     = new state("HOME");
    recipies = new state("RECIPIES");
    cupboard = new state("CUPBOARD");
    shopping = new state("SHOPPING");

    recipies.addLinkedState(cupboard);

    home.addLinkedState(recipies);
    home.addLinkedState(cupboard);
    home.addLinkedState(shopping);

    main_flowControl.setState(home);

    main_flowControl.addStateToStateList(home);
    main_flowControl.addStateToStateList(recipies);
    main_flowControl.addStateToStateList(cupboard);
    main_flowControl.addStateToStateList(shopping);

    main_flowControl.printFlowTree();
    main_flowControl.printFlowTree();
}

void draw()
{
    background(0);
    clear();

    text(frameCount, 10,10);
}