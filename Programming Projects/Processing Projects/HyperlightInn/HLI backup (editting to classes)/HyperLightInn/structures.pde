//Will spawn a given structure at the cursor location
void calcPlaceableStructure(){
    if(structureToggle == true)
    {
        buildStructure( findMouseTile(), 9, 8, basicInnTiles, basicInnFloor, showStructureGhost(findMouseTile(), 9, 8) );
    }
}

boolean showStructureGhost(int closeTile, int tilesWide, int tilesHigh){    //## TILES HIGH MAY NOT BE NEEDED ##//
    //closeTile    = closest tile to the cursor
    //tilesWide    = total width of structure
    //tilesHigh    = total height of structure
    //buildPlanner = list storing the indices of the tiles and floors to be placed, and where (based on the position in the list)

    //(1)Show building area (red and green ghost indicators)
    structureBlocked = false;
    pushStyle();
    for(int j=0; j<tilesHigh; j++)
    {
        for(int i=0; i<tilesWide; i++)
        {

            currentTile = closeTile + i + j*colNum;
            relativeObjPos = findRelativeCoordinates( currentTile );
            if( Tiles.get(currentTile).type == 0 ) //If is empty
            {
                image(greenBuildingGhost, relativeObjPos.x, relativeObjPos.y);
            }
            else                                    //If is not empty
            {
                image(redBuildingGhost, relativeObjPos.x, relativeObjPos.y);
                structureBlocked = true;
            }

        }
    }
    popStyle();

    return (!structureBlocked);

}
void buildStructure(int closeTile, int tilesWide, int tilesHigh, IntList buildPlannerTiles, IntList buildPlannerFloor, boolean placeable){
    //(2)If all clear, place selected indices at specified location
    if(placeable == true)   //If there is room to place the structure
    {

        for(int i=0; i<buildPlannerTiles.size(); i++)
        {

            currentTile = closeTile + (i % tilesWide) + ( (floor(i / tilesWide)) * colNum );
            Tiles.get(currentTile).type = buildPlannerTiles.get(i);

        }
        for(int i=0; i<buildPlannerFloor.size(); i++)
        {

            currentTile = closeTile + (i % tilesWide) + ( (floor(i / tilesWide)) * colNum );
            Tiles.get(currentTile).floorType = buildPlannerFloor.get(i);

        }

    }
}

//IntList collideables = new IntList(
IntList basicInnTiles = new IntList(  0,13,1, 1,1, 1,1,12, 0,
                                     16, 1,1, 2,2, 2,1, 1, 0,
                                      0, 1,0, 0,0, 0,2, 1, 0,
                                      0, 3,0, 6,6, 6,0, 3, 0,
                                      0, 1,0, 5,5, 5,4, 1, 0,
                                     16, 1,1, 4,0, 0,1, 1,16,
                                      0, 0,1, 1,3, 1,1,14,14,
                                      0, 0,0,16,0,16,0,14,14 ); //Build planner for a basic inn
IntList basicInnFloor = new IntList(  0, 0,0,0,0,0,0,0,0,
                                      1, 0,0,1,1,1,0,0,1,
                                      1, 0,1,1,1,1,1,0,1,
                                      1, 1,1,1,1,1,1,1,1,
                                      1, 0,1,1,1,1,1,0,1,
                                      1, 0,0,1,1,1,0,0,1,
                                      0, 0,0,0,1,0,0,0,0,
                                      0, 0,0,1,1,1,0,0,0 ); //