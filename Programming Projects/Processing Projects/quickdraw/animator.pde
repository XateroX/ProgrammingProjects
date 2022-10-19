PImage animate(ArrayList<PImage> iFrames, int framesPerImage, int currentFrame){
    /*
    Give a list to images to animate, how fast the animation plays and where you currently are in the animation
    Loops back around to the start if overuns
    returns the image to show
    */
    return iFrames.get( floor(currentFrame / framesPerImage) % (framesPerImage*iFrames.size()) );
}