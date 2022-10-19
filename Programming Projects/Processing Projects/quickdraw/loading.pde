void loadTextures(){
    loadTexturesCharacters();
    loadTexturesStages();
    loadTexturesMisc();
}
void loadSound(){
    //pass
}


void loadTexturesCharacters(){
    loadTexturesDrifter();
    loadTexturesBotPrime();
    loadTexturesMonk();
    loadTexturesGhost();
    loadTexturesTire();
}
void loadTexturesDrifter(){
    drifterBackStatic  = loadImage("drifter_back_static.png");
    drifterFrontStatic = loadImage("drifter_front_static.png");
}
void loadTexturesBotPrime(){
    botPrimeBackStatic  = loadImage("botPrime_back_static.png");
    botPrimeFrontStatic = loadImage("botPrime_front_static.png");
}
void loadTexturesMonk(){
    monkBackStatic  = loadImage("monk_back_static.png");
    monkFrontStatic = loadImage("monk_front_static.png");
}
void loadTexturesGhost(){
    ghostBackStatic  = loadImage("ghost_back_static.png");
    ghostFrontStatic = loadImage("ghost_front_static.png");
}
void loadTexturesTire(){
    tireBackStatic  = loadImage("tire_back_static.png");
    tireFrontStatic = loadImage("tire_front_static.png");
}


void loadTexturesStages(){
    loadTexturesStages0();
}
void loadTexturesStages0(){
    stage0MainStatic = loadImage("stage0_main_static.png");
    stage1MainStatic = loadImage("stage1_main_static.png");
    stage2MainStatic = loadImage("stage2_main_static.png");
}


void loadTexturesMisc(){
    missingTexture = loadImage("missingTexture.png");
    parryIcon      = loadImage("parry_icon.png");
    homeCover      = loadImage("home_cover.png");
    characterPlate = loadImage("character_plate.png");
    indicator = loadImage("indicator.png");
    hitMarker = loadImage("hit_marker.png");
}


//Characters
// - Drifter
PImage drifterFrontStatic;
PImage drifterBackStatic;
// - Bot-Prime
PImage botPrimeFrontStatic;
PImage botPrimeBackStatic;
// - Monk
PImage monkFrontStatic;
PImage monkBackStatic;
// - Ghost
PImage ghostFrontStatic;
PImage ghostBackStatic;
// - Tire
PImage tireFrontStatic;
PImage tireBackStatic;

//Stages
PImage stage0MainStatic;
PImage stage1MainStatic;
PImage stage2MainStatic;

//Misc
PImage missingTexture;
PImage parryIcon;
PImage homeCover;
PImage characterPlate;
PImage indicator;
PImage hitMarker;