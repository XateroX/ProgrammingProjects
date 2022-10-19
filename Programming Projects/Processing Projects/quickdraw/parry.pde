class parry{
    PVector pos;
    float rot;  //Between -PI/2 and PI/2

    parry(PVector position, float rotation){
        pos = position;
        rot = rotation;
    }

    void display(){
        pushMatrix();
        pushStyle();
        imageMode(CENTER);
        translate(pos.x, pos.y);
        rotate(rot);
        image(parryIcon, 0,0, width/8.0, width/8.0);
        popStyle();
        popMatrix();
    }
    void say(){
        /*
        Plays the parry sound
        */
    }
}