void overlay(){
    /*
    Framerate
    ...
    */
    pushStyle();
    textAlign(LEFT);
    textSize(20);

    text(frameRate, 25, 25);

    popStyle();
}