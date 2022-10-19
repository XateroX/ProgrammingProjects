void initialiseAll(){
    initialiseStages();
}
void initialiseStages(){
    //Main
    mStages.add(stage0MainStatic);
    mStages.add(stage1MainStatic);
    mStages.add(stage2MainStatic);
    //...

    //Background
    bStages.add(missingTexture);
    bStages.add(missingTexture);
    bStages.add(missingTexture);
    //...

    //Foreground
    fStages.add(missingTexture);
    fStages.add(missingTexture);
    fStages.add(missingTexture);
    //...
}