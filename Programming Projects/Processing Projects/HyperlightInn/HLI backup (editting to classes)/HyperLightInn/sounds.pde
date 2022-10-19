//** 60 x ... is the length of the song, where ... is the time in seconds **//
//**Find exact length in audacity**//

//##MAY STRUGGLE WITH FRACTIONS, SHOULD MAKE SOUNDS TO LINE UP NICELY WITH FRAMES##//

void backgroundMusic(){
    if(frameCount - backgroundMusicStart >= 60*( 23.31 ))
    {
        //backgroundMusicStart = frameCount;
        //backgroundMusic1.play();
        backgroundMusicStart = frameCount;
        traditionalSong1.play();
    }
}

//##HAVE STEPS SCALE WITH VELOCITY FOR FASTER OR SLOWER SOUNDS##//
void footstepSounds(){
    if(frameCount - footstepStart >= 60*( 0.264 ))
    {
        footstepStart = frameCount;

        //If grass...
        footstepsGrass.play();

        //If magic floor...
        //...

        //...
    }
}

void calcSteppingSounds(){
    if( (abs(user.vel.x) > 0) || (abs(user.vel.y) > 0) )
    {
        footstepSounds();
    }
}

void birdNoise(){
    //Given random conditions, play a short bird whistle (from a selection, ensure same sound isnt played too frequently)
    //pass
}