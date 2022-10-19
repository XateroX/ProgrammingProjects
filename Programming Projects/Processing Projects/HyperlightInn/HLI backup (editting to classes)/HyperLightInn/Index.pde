//*****//         = BugFixing tool
//## --- ##//     = ToDo list
//...             = Repeat commands above but for different situations (e.g, repeat Orc class for Elves, Goblins, etc)
//**____**//      = Important notes about section piece

//---------------------------------//
//List of objects' contents value; //
//---------------------------------//
/*
-->Tiles
0  = empty
1  = wall
2  = barrel
3  = door
4  = table
5  = stool
6  = counter
7  = multiTile (UNDECIDED)
8  = tree
9  = water
10 = lrgTree
11 = pump
12 = vat
13 = machinery
14 = field
15 = invisible collider
16 = fire contained
17 = trading outpost
18 = port

-->Floors
0 = natural floor
1 = magic floor
*/
//                                 0,1  2,3  4,5  6,7  8,9  10,11  12,13  14,15  16,17  18,19
IntList collideables = new IntList(0,1, 1,0, 1,0, 1,1, 1,1,  1,1,   1,1,   0,1,   1,1,   1);  //Sorted into 2s for ease of location


//----------------------------------//
//List of cropList' contents value; //
//----------------------------------//
/*
0 = Wheat
1 = Barley
2 = ...
*/


//------------------------------------//
//List of entityList' contents value; //
//------------------------------------//
/*
0 = Orc
1 = SludgeMonster
2 = ...
*/