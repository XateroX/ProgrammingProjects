/*
.Kirby quickdraw
.Quickshot McGuild -> inscryption
.Pixel art crunched
.Hyperlight themes

.Pen and Ink feel
*/
void setup(){
    size(800,360,P2D);
    //fullScreen(P2D);
    //orientation(LANDSCAPE);

    cPlayer = new drifter();

    loadTextures();
    initialiseAll();

    buildHomeScreenButtons();
}
void draw(){
    drawScreen();
    drawMenu();

    calcScreen();
    calcMenu();
}
void mousePressed(){
    mousePressedManager();
}
void mouseReleased(){
    mouseReleasedManager();
}