class mainScreen
{
    ArrayList<ring> rings;
    ArrayList<target> targets;
    PVector lastTarget;
    int     nTargets;
    boolean mousePressedWrongTime;
    boolean gameOver;
    float   minimumTargetDist;

    float screenTextSize;
    float maxScreenTextSize;

    color backgroundColor;
    float backgroundFadeTimer;
    float backgroundFadeTimerMax;
    color lastBackgroundColor;

    int score;

    boolean mouseHeld;
    int mouseHeldDuration;
    int mouseHeldMaxDuration;

    ArrayList<particle> particles;


    gameManager GM;
    mainScreen(gameManager GMi)
    {
        GM = GMi;
    }

    void draw()
    {
        colorMode(RGB);
        background(backgroundColor);

        if (mouseHeld)
        {
            mouseHeldDuration += 1;
        }
        if (mouseHeldDuration >= mouseHeldMaxDuration   )
        {
            setup();
        }

        backgroundColor = color(lerp(red(backgroundColor),0,1.0/80.0),lerp(green(backgroundColor),0,1.0/80.0),lerp(blue(backgroundColor),0,1.0/80.0));

        if (!gameOver)
        {
            if (targets.size() < nTargets)
            {
                println("empty targets");
                addNewTarget(lastTarget);
            }

            pushMatrix();
            pushStyle();
            
            drawRings();
            drawTargets();
            drawParticles();
            drawValues(); //Score, etc.

            updateTargets();
            updateRings();
            updateParticles();
            
            popStyle();
            popMatrix();


            if (ringsAllOut() || mousePressedWrongTime)
            {
                println("Ringout or mousepressed    ");
                println(ringsAllOut());
                println(mousePressedWrongTime);
                gameOver();
            }
        }else {
            pushMatrix();
            pushStyle();
            
            drawRings();
            drawTargets();
            drawValues(); //Score, etc.

            updateRings();
            updateTargets();
            
            popStyle();
            popMatrix();


            pushStyle();
            screenTextSize = lerp(screenTextSize,maxScreenTextSize,(1.0 /120.0));
            textSize(screenTextSize+1);
            stroke(255, screenTextSize/maxScreenTextSize);
            textAlign(CENTER,CENTER);
            text("Game Over", width/2,height/3);
            popStyle();

            if (abs(screenTextSize - maxScreenTextSize) < maxScreenTextSize*0.1)
            {
                setup();
            }
        }
    }
    void setup()
    {
        backgroundColor        = color(0,0,0);
        lastBackgroundColor    = color(0,0,0);
        backgroundFadeTimer    = 0;
        backgroundFadeTimerMax = 120;

        score = 0;
        mouseHeld            = false;
        mouseHeldDuration    = 0;
        mouseHeldMaxDuration = 30;

        mousePressedWrongTime = false;
        gameOver = false;
        nTargets = 1;

        maxScreenTextSize = width/10;
        screenTextSize    = 0;

        minimumTargetDist = width/3;

        rings     = new ArrayList<ring>();
        targets   = new ArrayList<target>();
        particles = new ArrayList<particle>();

        rings.add ( new ring(   new PVector(random(0,width),3*height/4) ) ); 
        for (int i = 0; i < nTargets; i++)
        {
            targets.add( new target( new PVector(random(0,width),random(0,height/5)) ) );    
        }
        PVector lastTarget = new PVector(random(0,width),random(0,height/10));

        rings.get(0).growSpeed = 5;
        targets.get(0).col = color(100,100,100);
    }
    void mousePressed()
    {
        mousePressedWrongTime = true;
        println("mousePressed");
        for (target c_target : targets)
        {
            c_target.mousePressed(rings);
            if (c_target.intersectingWithAny(rings))
            {
                mousePressedWrongTime = false;
                println("mousepressedwrongtime");
            }
        }
        if (mousePressedWrongTime)
        {
            println("gameOver: mousepressed");
            gameOver();
        }

        if (gameOver)
        {
            mouseHeld         = true;
            mouseHeldDuration = 0;
        }
    }
    void mouseReleased()
    {
        mouseHeld = false;
    }
    void keyPressed(){}
    void keyReleased(){}

    void drawRings()
    {
        pushMatrix();
        pushStyle();
        
        for (ring c_ring : rings)
        {
            c_ring.draw();
        }
        
        popStyle();
        popMatrix();
    }

    void drawTargets()
    {
        pushMatrix();
        pushStyle();
        
        for (target c_target : targets)
        {
            c_target.draw();
        }
        
        popStyle();
        popMatrix();
    }

    void drawParticles()
    {
        for (particle c_particle : particles)
        {
            c_particle.draw();
        }
    }

    void updateTargets()
    {
        if (!gameOver)
        {
            for (int i = targets.size()-1; i>=0; i--)
            {
                if (targets.get(i).dead)
                {
                    println("target removed");
                    lastTarget   = targets.get(i).targetCenter;
                    color newCol = targets.get(i).col;
                    targets.remove(i);
                    rings.add( new ring( lastTarget ) );
                    rings.get( rings.size()-1 ).col = newCol;
                    backgroundColor     = newCol;
                    lastBackgroundColor = newCol;

                    score += 1;
                }
            }
        }else 
        {
            for (int i = targets.size()-1; i>=0; i--)
            {
                targets.get(i).targetCenter = new PVector( lerp(targets.get(i).targetCenter.x,width/2,0.03),lerp(targets.get(i).targetCenter.y,height/2,0.03) );
            }    
        }
    }

    void updateRings()
    {
        for (ring c_ring : rings)
        {
            c_ring.update();
        }
        for (int i = rings.size()-1; i>=0; i--)
        {
            if (rings.get(i).dead)
            {
                rings.remove(i);
            }
        }
    }

    void updateParticles()
    {
        for (particle c_particle : particles)
        {
            c_particle.update();
        }
    }

    void addNewTarget(PVector currentRingSpawn)
    {
        PVector newPos = new PVector(random(width),random(height));
        while (dist(newPos.x,newPos.y, currentRingSpawn.x,currentRingSpawn.y) < minimumTargetDist)
        {
            newPos = new PVector(random(width),random(height));
        }
        targets.add( new target( newPos ) );
        println("new ring added");
    }

    void gameOver()
    {
        mouseHeld = false;
        gameOver = true;
        for (ring c_ring : rings)
        {
            c_ring.shrinking = true;
            c_ring.hitTarget = true;
            c_ring.growSpeed = 2.5;
        }
    }

    boolean ringsAllOut()
    {
        for (ring c_ring : rings)
        {
            for (target c_target : targets)
            {
                if (dist(c_target.targetCenter.x,c_target.targetCenter.y,   c_ring.ringCenter.x,c_ring.ringCenter.y) > c_ring.ringRadius*(1.0/1.3))
                {
                    return false;
                }
            }
        }
        println("ringsallout");
        if (targets.size() >= 1)
        {
            return true;
        }else {
            return false;
        }
    }

    void drawValues()
    {
        pushMatrix();
        pushStyle();
        
        textSize((sin((float)frameCount/60)*width/20) + width/10);
        textAlign(CENTER,CENTER);
        fill(lastBackgroundColor);
        text(score,width/2,height/2);

        if (mouseHeld)
        {
            noFill();
            stroke(255);
            strokeWeight(width/200);
            arc(width/2,height/2 + height/50,(sin((float)frameCount/30)*width/40) + width/10,(sin((float)frameCount/30)*width/40) + width/10, 0, 2*PI * ((float)mouseHeldDuration/(float)mouseHeldMaxDuration));
        }
        
        popStyle();
        popMatrix();
    }
}