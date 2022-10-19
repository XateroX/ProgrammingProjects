class player{
    PVector pos;
    PVector posBall;

    PVector vel;
    PVector acc;

    PVector velBall;
    PVector accBall;

    player(){
        pos = new PVector(0,0);
        pos.x = width/2;
        pos.y = height/2;//height-groundBuffer-100;

        posBall = new PVector(0,0);
        posBall.x = 0;
        posBall.y = -120;

        vel = new PVector(0,0);
        acc = new PVector(0,0);

        velBall = new PVector(0,0);
        accBall  = new PVector(0,0);
    }

    public void drawme(){
        pushMatrix();
        translate(pos.x,pos.y);
        fill(0);
        stroke(0);
        strokeWeight(3);

        drawCurveyLine();

        line(0,0, posBall.x,posBall.y);
        popMatrix();

        pushMatrix();
        translate(pos.x,pos.y);
        pushMatrix();
        scale(round((width/5) / 100));
        image(loadImage("playerSprite.png"),0,0,width/5,width/5);
        popMatrix();

        translate(posBall.x,posBall.y);
        scale(round((width/5) / 100));
        image(loadImage("playerBallSprite.png"),0,0,width/20,width/20);
        popMatrix();

        if (canThrow){
            drawGuideArrow();
        }
    }

    void drawGuideArrow(){
        pushMatrix();
        pushStyle();
        translate(pos.x,pos.y);
        translate(posBall.x,posBall.y);

        PVector mouseDiff = new PVector(mouse.x-M1.x,mouse.y-M1.y);
        mouseDiff.setMag(100);
        stroke(0,255,0);
        strokeWeight(5);
        line(0,0,mouseDiff.x,mouseDiff.y);
        popStyle();
        popMatrix();
    }

    void drawCurveyLine(){
        pushMatrix();
        pushStyle();

        PVector Vpar = new PVector(0,0);
        Vpar.x = posBall.x;
        Vpar.y = posBall.y;

        popStyle();
        popMatrix();
    }


    void launchBall(){
        println("   ----Ball Launched----");
    }

    void iterate(){
        acc.y     = 0;
        accBall.y = 0.5;

        if (!launchMode){
            vel.add(acc);
            pos.add(vel);

            velBall.add(accBall);
            posBall.add(velBall);

            // Friction for controlled gameplay
            velBall.setMag(velBall.mag()*0.975);
        }


        // Imposing boundary conditions on player and the ball
        if (pos.x > width){
            pos.x = width-1;
            vel.x*=-1;
        }
        if (pos.x < 0){
            pos.x = 1;
            vel.x*=-1;
        }
        if (pos.y > height){
            pos.y = height-1;
            vel.y*=-1;
        }
        if (pos.y < 0){
            pos.y = 1;
            vel.y*=-1;
        }

        if (posBall.mag() > 2000 && !launchMode){
            posBall.setMag(2000);
            velBall.x = 0;
            velBall.y = 0;
        }else if (launchMode || stuckMode){
            if (dist(pos.x,pos.y, posBall.x,posBall.y) <= 2000  ){
                launchMode = false;
                stuckMode  = false;
            }
        }

        if (posBall.x+pos.x > width){
            posBall.x = width-pos.x;
            velBall.x*=-1;
        }
        if (posBall.x+pos.x < 0){
            velBall.x*=-1;
        }
        if (posBall.y+pos.y > height){
            posBall.y = height-pos.y;
            velBall.y*=-1;
        }
        if (posBall.y+pos.y < 0){
            velBall.y*=-1;
        }
    }
}
