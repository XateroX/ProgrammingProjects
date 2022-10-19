/*
Introduced Variables;
----------------------
In Tiles  ; pathChecked  , pathLast, runningWeight
In general; pathUnchecked, pathEnd , pathTile     , pathTotalWeight, pathDist, pathFinal, pathStart, pathCheckTile, pathRoute
            + some others added after the fact
*/


ArrayList<Integer> oneTilePath(int pathStart, int pathEnd){     //For 1x1 entities
    //---Non-looped
    //(0) Reset variable values for all tiles
    //(1) Give start tile (e.g where the orcs spawn), with pathLast as -1
    //(2) Find and store pathEnd (e.g the counter you are looking for)
    //(3) Set all tiles to pathLast = -2, for an empty value
    //---Looped
    //(1) Go to first item in pathUnchecked list
    //(2) Assign item to pathTile then remove the item from list
    //(3) Go through each of the 4 spaces it can move to next
    //  (6) Check if any of the surrounding 3x3 tiles are the end tiles
    //      ( 7) DON'T check if at border Edge #### --> NEEDS TO BE ADDED <-- ######
    //      ( 8) If so; end the process of checking, mark current tile as checked
    //      ( 9) Start a while loop, add current tile to pathFinal, loop(Adding pathLasts to pathFinal) until -1 pathLast is hit (STARTING TILE)
    //      (10) Add to pathUnchecked if not a collideable or if pathChecked == false
    //      (11) Add to pathUnchecked in correct pathTotalWeight order (runningWeight + pathDist) +1 for the movement itself, AND pathLast to pathTile
    //(4) If no tiles left in pathUnchecked (size==0), then there is no route to the destination, so return pathFinal with a -1 added to it
    //(5) If pathFinal.size() > 0 (anything has been added to it), end the while loop (EITHER not possible or solution found, both add something to the list) --> INSIDE THE WHILE

    //Non-looped
    for(int i=0; i<Tiles.size(); i++)   //(0) Go through all tiles...
    {
        Tiles.get(i).pathChecked   = false;
        Tiles.get(i).pathLast      = -2;
        Tiles.get(i).runningWeight = 0; //##CAN PROBABLY JUST DO THIS FOR THE STARTING TILE AND NONE OF THE OTHERS AND WILL WORK THE SAME##//
    }
    pathUnchecked.clear();
    pathFinal.clear();
    pathUnchecked.add( pathStart );

    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println("----------------------");          //*****//
    //println("Before Looping / SETUP");          //*****//
    //println("----------------------");          //*****//
    //print("pathStart    ; ",pathStart)    ;print("  //  ");println("pathEnd  ; ",pathEnd  );
    //print("pathUnchecked; ",pathUnchecked);print("  //  ");println("pathFinal; ",pathFinal);

    //Looped
    while ( pathFinal.size() == 0 )  //While end not found
    {
        //println(" ");                     //*****//
        //println("------------------");    //*****//
        //println("During Loop / MAIN");    //*****//
        //println("------------------");    //*****//
        //--
        //println("pathUnchecked START; ",pathUnchecked); //*****//
        pathTile = pathUnchecked.get(0);
        //println("pathTile beginning; ",pathTile);   //*****//
        Tiles.get(pathTile).pathChecked = true;
        pathUnchecked.remove(0);

        //--- Check the 3x3 for pathEnd
        for(int q=-1; q<2; q++)
        {
            for(int p=-1; p<2; p++)
            {
                pathCheckTileTemp = pathTile + p + q*colNum;
                //println("--J pathCheckTile; ",pathCheckTile); //*****//
                if( (pathCheckTileTemp) == (pathEnd) )
                {
                    //println("---FOUND end (in J)");   //*****//
                    //----
                    //##CAN OPTIMISE BY CANCELLING CHECK OF 3x3 EARLIER##//
                    Tiles.get(pathCheckTileTemp).pathLast = pathTile;
                    pathRoute = pathCheckTileTemp;
                    while (pathRoute != pathStart)    //Keep going until at beginning of path again
                    {
                        //println("----Backtracking...");     //*****//
                        //println("Route-->",pathRoute);      //*****//
                        pathFinal.add(0, pathRoute);                    //**This ordering means -1 will NOT be included in the list**//
                        pathRoute = Tiles.get(pathRoute).pathLast;      //
                    }
                }
            }
        }

        //**i and j for loops have repeated insides, just to check the same things against the bottom and top and left and right**//
        //--
        for(int j=-1; j<=1; j+=2)   //Checks (j= -1) and (j= 1) --> Tiles below and above
        {
            pathCheckTile = pathTile + j*colNum;

            //println("Checking...; ",pathCheckTile); //*****//
            //--- Collideable and pathChecked check
            if( ( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 ) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z);   //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");    //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }
                //println("Current Unchecked Order; ",Tiles.get(pathCheckTile).runningWeight);

            }

        }
        for(int i=-1; i<=1; i+=2)   //Checks (i= -1) and (i= 1) --> Tiles to left and right
        {
            pathCheckTile = pathTile + i;

            //println("Checking...; ",pathCheckTile); //*****//
            //--- Collideable and pathChecked check
            if( ( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 ) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast    = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z); //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");  //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }

            }

        }

        //println("pathUnchecked END; ",pathUnchecked); //*****//

        //--
        if( pathUnchecked.size() == 0 ) //If nothing left to check...
        {
            pathFinal.add(-1);  //Add an empty value to signify the end of the empty path
        }

    }

    return pathFinal;   //The array containing the route of tiles the entity will take to travel to destination
}


//##
//##POSSIBLY HAVE MULTIPLE PARSES, THAT SMOOTH OUT THE PATHING FOR MORE NATURAL LOOKING MOVEMENT##//
//##

ArrayList<Integer> threeTilePath(int pathStart, int pathEnd){   //For 3x3 entities
    //(1)Same as one tile, except AFTER determining the cross position your are going to (pathCheckTile) and confirming that it 
    //   is [not collideable and not checked], check around it in a 3x3 for [just collideables]. If none, follow the same process

    //Non-looped
    for(int i=0; i<Tiles.size(); i++)   //(0) Go through all tiles...
    {
        Tiles.get(i).pathChecked   = false;
        Tiles.get(i).pathLast      = -2;
        Tiles.get(i).runningWeight = 0; //##CAN PROBABLY JUST DO THIS FOR THE STARTING TILE AND NONE OF THE OTHERS AND WILL WORK THE SAME##//
    }
    pathUnchecked.clear();
    pathFinal.clear();
    pathUnchecked.add( pathStart );

    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println("----------------------");          //*****//
    //println("Before Looping / SETUP");          //*****//
    //println("----------------------");          //*****//
    //print("pathStart    ; ",pathStart)    ;print("  //  ");println("pathEnd  ; ",pathEnd  );
    //print("pathUnchecked; ",pathUnchecked);print("  //  ");println("pathFinal; ",pathFinal);

    //Looped
    while ( pathFinal.size() == 0 )  //While end not found
    {
        //println(" ");                     //*****//
        //println("------------------");    //*****//
        //println("During Loop / MAIN");    //*****//
        //println("------------------");    //*****//
        //--
        //println("pathUnchecked START; ",pathUnchecked); //*****//
        pathTile = pathUnchecked.get(0);
        //println("pathTile beginning; ",pathTile);   //*****//
        Tiles.get(pathTile).pathChecked = true;
        pathUnchecked.remove(0);

        //--- Check the 5x5 for pathEnd
        for(int q=-2; q<3; q++)
        {
            for(int p=-2; p<3; p++)
            {
                pathCheckTileTemp = pathTile + p + q*colNum;
                //println("--J pathCheckTile; ",pathCheckTile); //*****//
                if( (pathCheckTileTemp) == (pathEnd) )
                {
                    //println("---FOUND end (in J)");   //*****//
                    //----
                    //##CAN OPTIMISE BY CANCELLING CHECK OF 3x3 EARLIER##//
                    Tiles.get(pathCheckTileTemp).pathLast = pathTile;
                    pathRoute = pathCheckTileTemp;
                    while (pathRoute != pathStart)    //Keep going until at beginning of path again
                    {
                        //println("----Backtracking...");     //*****//
                        //println("Route-->",pathRoute);      //*****//
                        pathFinal.add(0, pathRoute);                    //**This ordering means -1 will NOT be included in the list**//
                        pathRoute = Tiles.get(pathRoute).pathLast;      //
                    }
                }
            }
        }

        //**i and j for loops have repeated insides, just to check the same things against the bottom and top and left and right**//
        //--
        for(int j=-1; j<=1; j+=2)   //Checks (j= -1) and (j= 1) --> Tiles below and above
        {
            pathCheckTile = pathTile + j*colNum;

            //println("Checking...; ",pathCheckTile); //*****//
            //Check if it fits in the 3x3
            pathBlocked = false;
            for(int q=-1; q<2; q++)
            {
                for(int p=-1; p<2; p++)
                {

                    pathCheckTileTemp = pathCheckTile + p + q*colNum;
                    if( collideables.get( Tiles.get(pathCheckTileTemp).type ) == 1 )    //If tile is collideable...
                    {
                        //Set this position as impossible
                        pathBlocked = true;
                    }

                }
            }

            //--- Collideable and pathChecked check
            if( (( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 )) && (pathBlocked == false) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z);   //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");    //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }
                //println("Current Unchecked Order; ",Tiles.get(pathCheckTile).runningWeight);

            }

        }
        for(int i=-1; i<=1; i+=2)   //Checks (i= -1) and (i= 1) --> Tiles to left and right
        {
            pathCheckTile = pathTile + i;

            //println("Checking...; ",pathCheckTile); //*****//
            //Check if it fits in the 3x3
            pathBlocked = false;
            for(int q=-1; q<2; q++)
            {
                for(int p=-1; p<2; p++)
                {

                    pathCheckTileTemp = pathCheckTile + p + q*colNum;
                    if( collideables.get( Tiles.get(pathCheckTileTemp).type ) == 1 )    //If tile is collideable...
                    {
                        //Set this position as impossible
                        pathBlocked = true;
                    }

                }
            }

            //--- Collideable and pathChecked check
            if( (( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 )) && (pathBlocked == false) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast    = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z); //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");  //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }

            }

        }

        //println("pathUnchecked END; ",pathUnchecked); //*****//

        //--
        if( pathUnchecked.size() == 0 ) //If nothing left to check...
        {
            pathFinal.add(-1);  //Add an empty value to signify the end of the empty path
        }

    }

    return pathFinal;   //The array containing the route of tiles the entity will take to travel to destination
}



//## CAN REMOVE THE ABOVE ##//



ArrayList<Integer> tilePathing(int pathStart, int pathEnd, int n){    //For nXn size entities

    //(1)Same as one tile, except AFTER determining the cross position your are going to (pathCheckTile) and confirming that it 
    //   is [not collideable and not checked], check around it in a 3x3 for [just collideables]. If none, follow the same process

    //Non-looped
    for(int i=0; i<Tiles.size(); i++)   //(0) Go through all tiles...
    {
        Tiles.get(i).pathChecked   = false;
        Tiles.get(i).pathLast      = -2;
        Tiles.get(i).runningWeight = 0; //##CAN PROBABLY JUST DO THIS FOR THE STARTING TILE AND NONE OF THE OTHERS AND WILL WORK THE SAME##//
    }
    pathUnchecked.clear();
    pathFinal.clear();
    pathUnchecked.add( pathStart );

    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println(" ");                               //*****//
    //println("----------------------");          //*****//
    //println("Before Looping / SETUP");          //*****//
    //println("----------------------");          //*****//
    //print("pathStart    ; ",pathStart)    ;print("  //  ");println("pathEnd  ; ",pathEnd  );
    //print("pathUnchecked; ",pathUnchecked);print("  //  ");println("pathFinal; ",pathFinal);

    //Looped
    while ( pathFinal.size() == 0 )  //While end not found
    {
        //println(" ");                     //*****//
        //println("------------------");    //*****//
        //println("During Loop / MAIN");    //*****//
        //println("------------------");    //*****//
        //--
        //println("pathUnchecked START; ",pathUnchecked); //*****//
        pathTile = pathUnchecked.get(0);
        //println("pathTile beginning; ",pathTile);   //*****//
        Tiles.get(pathTile).pathChecked = true;
        pathUnchecked.remove(0);

        //--- Check the (n+2)X(n+2) for pathEnd -> e.g the next size bigger
        pathLwrBnd = int( ceil( (n+2) / 2.0 ) - (n+2) );
        pathUprBnd = int( ceil( (n+2) / 2.0 )         );
        for(int q=pathLwrBnd; q<pathUprBnd; q++)
        {
            for(int p=pathLwrBnd; p<pathUprBnd; p++)
            {
                pathCheckTileTemp = pathTile + p + q*colNum;
                //println("--J pathCheckTile; ",pathCheckTile); //*****//
                if( (pathCheckTileTemp) == (pathEnd) )
                {
                    //println("---FOUND end (in J)");   //*****//
                    //----
                    //##CAN OPTIMISE BY CANCELLING CHECK OF 3x3 EARLIER##//
                    Tiles.get(pathCheckTileTemp).pathLast = pathTile;
                    pathRoute = pathCheckTileTemp;
                    while (pathRoute != pathStart)    //Keep going until at beginning of path again
                    {
                        //println("----Backtracking...");     //*****//
                        //println("Route-->",pathRoute);      //*****//
                        pathFinal.add(0, pathRoute);                    //**This ordering means -1 will NOT be included in the list**//
                        pathRoute = Tiles.get(pathRoute).pathLast;      //
                    }
                }
            }
        }

        //**i and j for loops have repeated insides, just to check the same things against the bottom and top and left and right**//
        //--
        for(int j=-1; j<=1; j+=2)   //Checks (j= -1) and (j= 1) --> Tiles below and above
        {
            pathCheckTile = pathTile + j*colNum;

            //println("Checking...; ",pathCheckTile); //*****//
            //Check if it fits in the nXn
            pathBlocked = false;
            pathLwrBnd = int( ceil(n / 2.0) - n );
            pathUprBnd = int( ceil(n / 2.0)     );
            for(int q=pathLwrBnd; q<pathUprBnd; q++)
            {
                for(int p=pathLwrBnd; p<pathUprBnd; p++)
                {

                    pathCheckTileTemp = pathCheckTile + p + q*colNum;
                    if( collideables.get( Tiles.get(pathCheckTileTemp).type ) == 1 )    //If tile is collideable...
                    {
                        //Set this position as impossible
                        pathBlocked = true;
                    }

                }
            }

            //--- Collideable and pathChecked check
            if( (( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 )) && (pathBlocked == false) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z);   //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");    //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }
                //println("Current Unchecked Order; ",Tiles.get(pathCheckTile).runningWeight);

            }

        }
        for(int i=-1; i<=1; i+=2)   //Checks (i= -1) and (i= 1) --> Tiles to left and right
        {
            pathCheckTile = pathTile + i;

            //println("Checking...; ",pathCheckTile); //*****//
            //Check if it fits in the nXn
            pathBlocked = false;
            pathLwrBnd = int( ceil(n / 2.0) - n );
            pathUprBnd = int( ceil(n / 2.0)     );
            for(int q=pathLwrBnd; q<pathUprBnd; q++)
            {
                for(int p=pathLwrBnd; p<pathUprBnd; p++)
                {

                    pathCheckTileTemp = pathCheckTile + p + q*colNum;
                    if( collideables.get( Tiles.get(pathCheckTileTemp).type ) == 1 )    //If tile is collideable...
                    {
                        //Set this position as impossible
                        pathBlocked = true;
                    }

                }
            }

            //--- Collideable and pathChecked check
            if( (( Tiles.get(pathCheckTile).pathChecked == false ) && ( collideables.get( Tiles.get(pathCheckTile).type ) == 0 )) && (pathBlocked == false) )
            {

                //## TEMPORARY, MAY BREAK SYSTEM ##//
                Tiles.get(pathCheckTile).pathChecked = true;
                //## TEMPORARY, MAY BREAK SYSTEM ##//
                //println("-->Empty tile found; ", pathCheckTile);       //*****//
                //pathTile is original, pathCheckTile is the branch
                Tiles.get( pathCheckTile ).pathLast    = pathTile;
                //Diff in end and check
                pathTileDiffX        = abs(        (pathCheckTile % colNum)   -        (pathEnd % colNum)   );
                pathTileDiffY        = abs( floor( (pathCheckTile / colNum) ) - floor( (pathEnd / colNum) ) );
                pathCheckDist        = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for pathCheckTile
                pathCheckTotalWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight + pathCheckDist;
                Tiles.get(pathCheckTile).runningWeight = 1 + Tiles.get( int(Tiles.get(pathCheckTile).pathLast) ).runningWeight;

                for(int z=0; z<pathUnchecked.size(); z++)
                {

                    //println("##Start##");
                    //Diff in end and cycle
                    pathTileDiffX        = abs(        (pathUnchecked.get(z) % colNum)   -        (pathEnd % colNum)   );
                    pathTileDiffY        = abs( floor( (pathUnchecked.get(z) / colNum) ) - floor( (pathEnd / colNum) ) );
                    pathCycleDist = sqrt( pow(pathTileDiffX ,2) + pow(pathTileDiffY ,2) );   //Distance for the pathUnchecked items
                    pathCycleTotalWeight = Tiles.get( pathUnchecked.get(z) ).runningWeight + pathCycleDist;

                    if(pathCheckTotalWeight < pathCycleTotalWeight) //New path tile is quicker, put higher up priority (before this tile's index)
                    {
                        //println("Added at INDEX ",z); //*****//
                        pathUnchecked.add(z, pathCheckTile);    //Add at index, moving others to the right
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    if( ( z == (pathUnchecked.size() -1) ) && (pathCheckTotalWeight >= pathCycleTotalWeight) )    //If at last item, and still not small enough, then add to very end
                    {
                        //println("Added at END");  //*****//
                        pathUnchecked.add(pathCheckTile);       //Add to end
                        //println("----------BREAK-");
                        break;                                  //Tile added => no more checking needed => break out of for loop
                    }
                    //println("##End##");

                }
                if(pathUnchecked.size() == 0)   //If adding to an empty list...
                {
                    //println("FIRST item added");  //*****//
                    pathUnchecked.add(pathCheckTile);       //Add to end
                }

            }

        }

        //println("pathUnchecked END; ",pathUnchecked); //*****//

        //--
        if( pathUnchecked.size() == 0 ) //If nothing left to check...
        {
            pathFinal.add(-1);  //Add an empty value to signify the end of the empty path
        }

    }

    return pathFinal;   //The array containing the route of tiles the entity will take to travel to destination
}

//#######################################################################################################################################################################//
//#######################################################################################################################################################################//
//## COULD ADD A PARSE IN ANOTHER FUNCTION THAT LOOKS FOR VERTICAL/HORIZONTAL LINES IN ROUTES, AND SIMPLIFIES IT TO LESS TILES, WHICH ARE THEN INTERPOLATED FOR TRAVEL ##//
//#######################################################################################################################################################################//
//#######################################################################################################################################################################//
