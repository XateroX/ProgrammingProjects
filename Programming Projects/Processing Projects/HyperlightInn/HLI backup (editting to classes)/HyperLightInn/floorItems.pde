void dropInventoryItem(){
    //(1)Have inventory open
    //(2)Select item to give 3 options to its left
    //(3)One will be 'drop item', other 3 something else
    //(4)Then add selected item to floorItem... list, with pos equal to
    //   user's pos +- some factor

    //pass
}

void pickupFloorItem(){
    //(1)Go through all dropped item pos
    //(2)Pickup first item seen within a bound of the character/mouse
    //(3)Remove from floorItem... lists

    //pass
}

void displayDroppedItems(){
    for(int i=0; i<floorItemNames.size(); i++)   //Go through all items on the floor
    {
        //##Get image from a dictionary, linking string names to images##//
        image(test1, floorItemPos.get(i).x, floorItemPos.get(i).y);
    }
}