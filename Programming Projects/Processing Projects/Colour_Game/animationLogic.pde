void outputFolderContents(){

    String path = "C:\\Users\\danlo\\OneDrive\\Desktop\\files\\Programming Projects\\Processing Projects\\Colour_Game\\data\\sparkle";

    // we'll have a look in the data folder
    java.io.File folder = new java.io.File(dataPath(path));
    
    // list the files in the data folder
    String[] filenames = folder.list();

    AnimationImages = new PImage[filenames.length];

    for (int i = 0; i < filenames.length; i++){
        AnimationImages[i] = loadImage(path+"\\"+filenames[i]);
    }  
}


void drawAnimatedObject(){
    if (animationPosition >= AnimationImages.length){
        animationPosition = 0;
    }
    image(AnimationImages[floor(animationPosition)], 0,0,200,200);
    animationPosition+=(float)AnimationImages.length/animationLength;
} 
