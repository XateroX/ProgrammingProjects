shooter playerShooter;
boolean held;
float ballSize;

ArrayList<ArrayList<ball>> groups;

ArrayList<colorClass> colors;

ArrayList<Integer> powers;

boolean starting;

float score;
String[] scores;

particleEngine particles;

textEngine texts;

int previousScore;
int c_frame;
float scoreScale;


int ballsDestroyed;
int comboMultiplier;
boolean comboBreak;

int linkage;
boolean showMenu;

float bottomSteps;
float stepSize;
float transitionVal;
float stageOffset;

int startFrame;
boolean finishTransition;
boolean transitioningState;

int ballsShot;

int lostFrameStart;
int winFrameStart;

boolean lost;
boolean win;

boolean colorblind;

String highestScore;

//PImage ball1asset;

void setup(float previousScore)
{
    //size(563,1000);
    fullScreen();
    background(0);
    orientation(PORTRAIT); 

    try {
        scores = loadStrings("highscores.txt");
        highestScore = scores[scores.length-1];    
    }catch (Exception e) {
        e.printStackTrace();
        String[] saveStringDefault = new String[1];
        saveStringDefault[0] = "0";
        
        saveStrings("highscores.txt", saveStringDefault);
        highestScore = str(0);
    }

    starting = true;

    powers = new ArrayList<Integer>();
    for (int i = 0; i < 5; i++)
    {
        powers.add( powers.size() );
    }

    colors = new ArrayList<colorClass>();

    colorblind = true;

    if (!colorblind)
    {
        colors.add( new colorClass(200,0,0) );
        colors.add( new colorClass(0,0,200) );
        colors.add( new colorClass(200,200,100) );

        colors.add( new colorClass(100,100,200) );
        colors.add( new colorClass(100,200,100) );
        colors.add( new colorClass(200,100,100) );
    }else {
        colors.add( new colorClass(255,0,0) );
        colors.add( new colorClass(0,0,160) );
        colors.add( new colorClass(0,130,0) );

        colors.add( new colorClass(255,255,0) );
        //colors.add( new colorClass(130,0,255) );
        colors.add( new colorClass(255,0,255) );
        colors.add( new colorClass(0,255,255) );
    }
    

    playerShooter = new shooter();

    ballSize = width/10;

    groups = new ArrayList<ArrayList<ball>>();

    score = previousScore;
    previousScore = 0;
    c_frame = 0;
    ballsDestroyed = 0;

    comboMultiplier = 1;
    comboBreak = false;

    particles = new particleEngine();
    texts     = new textEngine();

    scoreScale = 1;

    linkage = 3;
    showMenu = false;

    bottomSteps   = 0;
    stepSize      = height/50;
    transitionVal = 0;
    finishTransition = false;
    transitioningState = false;

    ballsShot = 0;

    lostFrameStart = -1;
    winFrameStart  = -1;

    lost = false;
    win  = false;
}

void setup()
{
    //size(563,1000);
    fullScreen();
    background(0);
    orientation(PORTRAIT);
    
    // Wipe highscore
    String[] saveStringDefault = new String[1];
    saveStringDefault[0] = "0";
    //saveStrings("highscores.txt", saveStringDefault);
    
    try {
        String[] scores = loadStrings("highscores.txt");
        highestScore = scores[scores.length-1];    
    }catch (Exception e) {
        e.printStackTrace();
        saveStringDefault = new String[1];
        saveStringDefault[0] = "0";
        
        saveStrings("highscores.txt", saveStringDefault);
        highestScore = str(0);
    }
    

    //ball1asset = loadImage("ball1Asset.png");

    starting = true;

    powers = new ArrayList<Integer>();
    for (int i = 0; i < 5; i++)
    {
        powers.add( powers.size() );
    }

    colors = new ArrayList<colorClass>();

    colorblind = true;

    if (!colorblind)
    {
        colors.add( new colorClass(200,0,0) );
        colors.add( new colorClass(0,0,200) );
        colors.add( new colorClass(200,200,100) );

        colors.add( new colorClass(100,100,200) );
        colors.add( new colorClass(100,200,100) );
        colors.add( new colorClass(200,100,100) );
    }else {
        colors.add( new colorClass(255,0,0) );
        colors.add( new colorClass(0,0,160) );
        colors.add( new colorClass(0,130,0) );

        colors.add( new colorClass(255,255,0) );
        //colors.add( new colorClass(130,0,255) );
        colors.add( new colorClass(255,0,255) );
        colors.add( new colorClass(0,255,255) );
    }
    

    playerShooter = new shooter();

    ballSize = width/10;

    groups = new ArrayList<ArrayList<ball>>();

    score = 0;
    previousScore = 0;
    c_frame = 0;
    ballsDestroyed = 0;

    comboMultiplier = 1;
    comboBreak = false;

    particles = new particleEngine();
    texts     = new textEngine();

    scoreScale = 1;

    linkage = 3;
    showMenu = false;

    bottomSteps   = 0;
    stepSize      = height/50;
    transitionVal = 0;
    finishTransition = false;
    transitioningState = false;

    ballsShot = 0;

    lostFrameStart = -1;
    winFrameStart  = -1;

    lost = false;
    win  = false;
}

void draw()
{
    pushMatrix();
    translate(-playerShooter.pos.x + playerShooter.basePos.x, -playerShooter.pos.y + playerShooter.basePos.y);

    if (starting && frameCount%5==0)
    {
        playerShooter.ang = random(-PI/3, PI/3);
        playerShooter.shoot();
    }
    if (starting && playerShooter.balls.size() >= 40){
        starting = false;
        ballsDestroyed = 0;
    }

    if (frameCount%20==0 && ballsDestroyed != 0 && !starting  &&  !lost)
    {
        score += pow(2,ballsDestroyed) * comboMultiplier;
        texts.acknoledgeScore(pow(2,ballsDestroyed));
        scoreScale = map(ballsDestroyed,3,15,1.5,6);
        ballsDestroyed = 0;
        comboMultiplier *= 2;
        comboBreak = false;

        if (noWallBalls() && !starting && !texts.modes.get(1))
        {
            //println("CONGRATS");
            texts.congratulations();
            win = true;
        }
    }

    if (lost)
    {
        //println("CONGRATS");
        if (!texts.modes.get(6))
        {
            texts.youLose();
        }
        if (frameCount % 4 == 0)
        {
            playerShooter.popFarthestBall();
        }
    }

    if (comboBreak && playerShooter.allStuck() && frameCount%20==0)
    {
        comboMultiplier = 1;
    }

    if (!starting)
    {
        for (int i = 0; i < playerShooter.balls.size()-2; i++)
        {
            ball c_ball = playerShooter.balls.get(i);
            if (dist(c_ball.pos.x,c_ball.pos.y, playerShooter.pos.x,playerShooter.pos.y) < width/5+ballSize/4 || c_ball.pos.y > playerShooter.pos.y+(height-playerShooter.basePos.y))
            {
                print("dead");
                lost = true;
                lostFrameStart = frameCount;
            }
            if (c_ball.pos.x > width || c_ball.pos.x < 0)
            {
                c_ball.alive = false;
            }
        }
    }

    background(0);

    fill(200+55*((float)frameCount%300/300.0),0,0);
    rectMode(CORNER);
    rect(0,-height,width,height);

    if (held)
    {
        PVector mouse = new PVector(mouseX,mouseY);
        mouse.sub(playerShooter.basePos);
        float mouseAng = mouse.heading() + PI/2;
        playerShooter.ang = mouseAng;
    }

    playerShooter.draw();

    for (int i = 0; i < 100; i++)
    {
        if (i%50 == 0)
        {
            playerShooter.addShaddowBalls();
        }
        playerShooter.update();
    }
    


    for (int i = groups.size()-1; i >= 0; i--)
    {
        if (groups.get(i).size() >= linkage)
        {
            ballsDestroyed += groups.get(i).size();
            for (int j = groups.get(i).size()-1; j >= 0 ; j--)
            {
                particles.createExplosion( groups.get(i).get(j).pos );

                groups.get(i).get(j).alive = false;
                groups.get(i).remove(j);
            }
            
        }

        boolean groupDetached = true;
        for (int j = groups.get(i).size()-1; j >= 0; j--)
        {
            if (groups.get(i).get(j).backwall)
            {
                groupDetached = false;
                break;
            }

            if ( !attachedGroupIsDetached(i, 0) )
            {
                groupDetached = false;
                break;
            }
        }
        if (groupDetached)
        {
            if (groups.get(i).size()>0)
            {
                ballsDestroyed += groups.get(i).size();
            }
            for (int j = groups.get(i).size()-1; j >= 0; j--)
            {
                particles.createExplosion( groups.get(i).get(j).pos );

                groups.get(i).get(j).alive = false;
                groups.get(i).remove(j);
            }
        }

        if (groups.get(i).size()>1)
        {
            for ( int j = 0; j < groups.get(i).size()-1; j++ )
            {
                stroke(255, 50+155*((float)groups.get(i).get(j).aniCounter%5000/5000.0));
                strokeWeight(25);
                line(groups.get(i).get(j).pos.x,groups.get(i).get(j).pos.y,  groups.get(i).get(j+1).pos.x, groups.get(i).get(j+1).pos.y);
            }
        }

        for ( int j = groups.get(i).size()-1; j >= 0; j-- )
        {
            if (!groups.get(i).get(j).alive)
            {
                groups.get(i).remove(j);
            }
        }
    }
    
    //translate(playerShooter.pos.x - playerShooter.basePos.x, playerShooter.pos.y - playerShooter.basePos.y);
    particles.update();
    texts.update();
    particles.draw();
    popMatrix();
    texts.draw();

    pushStyle();
    fill(200*abs(sin(PI + 2*PI*(float)frameCount/720)), 255*abs(sin(PI/2 + 2*PI*(float)frameCount/720)), 255*abs(sin(PI/2 + 2*PI*(float)frameCount/720)));
    scoreScale = lerp(scoreScale,1,0.02);
    textSize(scoreScale * width/7 * (1+0.2*abs(sin(2*PI*(float)frameCount/720))));
    textAlign(CENTER,CENTER);
    text(str(score), width/2,max(playerShooter.basePos.y-playerShooter.pos.y - height/10, height/10));
    popStyle();

    pushStyle();
    fill(255*abs(sin(PI + 2*PI*(float)frameCount/720)), 255*abs(sin(PI/2 + 2*PI*(float)frameCount/720)), 255*abs(sin(PI/2 + 2*PI*(float)frameCount/720)));
    scoreScale = lerp(scoreScale,1,0.03);
    textSize(scoreScale * width/10 * (1+0.2*abs(sin(2*PI*(float)frameCount/720))));
    textAlign(CENTER,CENTER);
    text("X" + str(comboMultiplier), width/2,max(playerShooter.basePos.y-playerShooter.pos.y - height-15, height/5) + (scoreScale-1) * width/4);
    popStyle();

    //println("groups: ", groups.size());
    //for (ArrayList<ball> group : groups)
    //{
       //println("group size: ", group.size());
    //}

    //println("score:", score);
    //println("previousScore", previousScore);

    if (showMenu)
    {
        drawMenu();
    }

    if (transitioningState && !finishTransition)
    {
        transitionVal += 1.0/50.0;

        stageOffset = bottomSteps*stepSize + stepSize * (cos(PI+transitionVal*PI)+1)/2.0;
        playerShooter.pos.y = playerShooter.basePos.y - stageOffset;
        playerShooter.balls.get( playerShooter.balls.size()-1 ).pos.y = playerShooter.basePos.y - stageOffset;
        //println(transitionVal);
        if (transitionVal >= 1.0)
        {
            finishTransition = true;
            bottomSteps += 1;
            transitioningState = false;
            //println(bottomSteps);
        }
    }

    if (ballsShot % 4 == 0 && ballsShot > 0)
    {
        transitionStage();
        ballsShot = 0;
    }

    
    textSize(height/50);
    fill(255);
    text("Highscore: "+highestScore, width/3, height/15);
}

boolean noWallBalls()
{
    for (int i = 0; i < playerShooter.balls.size()-1; i++)
    {
        ball c_ball = playerShooter.balls.get(i);
        if (c_ball.attachedGroup == -1)
        {
            return false;
        }
    }
    return true;
}

void transitionStage()
{
    transitionVal = 0.0;
    finishTransition = false;
    transitioningState = true;
}


void drawMenu()
{
    pushMatrix();
    pushStyle();

    translate(width/4, height/10);
    fill(0,200);
    stroke(255, 200);
    strokeWeight(width/30);
    rect(0,0,2*width/4,8*height/10);

    fill(255);
    textSize(width/30);
    text("Linkage = " + str(linkage), 0.1*width/2,0.1*width/2);
    text("l = +, k = -", 0.6*width/2,0.1*width/2);

    popStyle();
    popMatrix();
}

boolean attachedGroupIsDetached(int i, int lvl)
{
    //println("Group: ", i);
    lvl = lvl+1;
    if (lvl > 50)
    {
        return false;
    }

    for (int j = groups.get(i).size()-1; j >= 0; j--)
    {
        if (groups.get(i).get(j).attachedGroup != i)
        {
            if ( groups.get(i).get(j).attachedGroup==-1 )
            {
                return false;
            }
            if ( attachedGroupIsDetached( groups.get(i).get(j).attachedGroup, lvl ) )
            {
                return true;
            }
            if ( groups.get(groups.get(i).get(j).attachedGroup).size()==0 )
            {
                return true;
            }
        }
    }

    return false;
}


class shooter{
    PVector pos;
    PVector basePos;
    boolean canShoot;
    float ang;

    ArrayList<ball> balls;

    ball nextBall;

    ArrayList<Integer> powerups;

    shooter()
    {
        pos = new PVector(width/2,height*0.9);
        basePos = new PVector(width/2,height*0.9);
        canShoot = true;
        ang = 0;

        balls = new ArrayList<ball>();
        nextBall = new ball(ang);

        balls.add( new ball(ang) );
        balls.get( balls.size()-1 ).pos = new PVector(pos.x,pos.y);
        balls.get( balls.size()-1 ).ballInd = balls.size()-1;
        balls.get( balls.size()-1 ).speed = (float)height/2000;
        balls.get( balls.size()-1 ).pause();

        powerups = new ArrayList<Integer>();
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        fill(150);
        noStroke();
        pushMatrix();
        translate(pos.x,pos.y);
        ellipse(0,0,width/5,width/5);
        popMatrix();
        
        drawSightLine();

        drawBalls();

        popStyle();
        popMatrix();
    }

    void drawSightLine()
    {
        pushMatrix();
        pushStyle();

        PVector d  = new PVector(0,-30);
        d.rotate(ang);
        strokeWeight(10);
        for (int i = 0; i < 30; i++)
        {
            stroke(100, 200 * (1.0 - (float)i/30));
            fill(  100, 200 * (1.0 - (float)i/30));
            line(playerShooter.pos.x+2*i*d.x,playerShooter.pos.y+2*i*d.y,  playerShooter.pos.x+(2*i+1)*d.x,playerShooter.pos.y+(2*i+1)*d.y);
        }

        popStyle();
        popMatrix();
    }

    boolean allStuck()
    {
        for (int i = 0; i < balls.size()-1; i++)
        {
            ball c_ball = balls.get(i);
            if (!c_ball.stuck)
            {
                return false;
            }
        }

        //println(transitioningState);
        if (transitioningState || win || lost)
        {
            return false;
        }

        return true;
    }

    void drawBalls()
    {
        pushMatrix();
        pushStyle();

        for (ball c_ball : balls){
            c_ball.draw();
        }

        popStyle();
        popMatrix();
    }

    void shoot()
    {
        balls.get( balls.size()-1 ).ang = ang;
        balls.get( balls.size()-1 ).resume();
        balls.add( new ball(ang)  );
        balls.get( balls.size()-1 ).pause();
        balls.get( balls.size()-1 ).pos = new PVector(pos.x,pos.y);
        balls.get( balls.size()-1 ).ballInd = balls.size()-1;

        comboBreak = true;

        if (!starting)
        {
            ballsShot += 1;
        }
        
    }

    void activatePower(int powInd)
    {
        playerShooter.powerups.add(powInd);
    }

    void reOrganiseBalls()
    {
        boolean overlapping = true;
        while (overlapping)
        {
            overlapping = false;
            for (int i = 0; i < balls.size()-1; i++)
            {
                ball c_ball_a = balls.get(i);
                for (int j = 0; j < balls.size()-1; j++)
                {
                    ball c_ball_b = balls.get(j);
                    if (dist(c_ball_a.pos.x,c_ball_a.pos.y,c_ball_b.pos.x,c_ball_b.pos.y) < ballSize/2 && dist(c_ball_a.pos.x,c_ball_a.pos.y,c_ball_b.pos.x,c_ball_b.pos.y) > 0)
                    {
                        PVector adja = new PVector(c_ball_a.pos.x-c_ball_b.pos.x,  c_ball_a.pos.y-c_ball_b.pos.y);
                        PVector adjb = new PVector(c_ball_b.pos.x-c_ball_a.pos.x,  c_ball_b.pos.y-c_ball_a.pos.y);
                        adja.setMag(dist(c_ball_a.pos.x,c_ball_a.pos.y,c_ball_b.pos.x,c_ball_b.pos.y)/2);
                        adja.setMag(dist(c_ball_a.pos.x,c_ball_a.pos.y,c_ball_b.pos.x,c_ball_b.pos.y)/2);

                        c_ball_a.pos.add(adja);
                        c_ball_b.pos.add(adjb);

                        overlapping = false;
                    }
                }   
            }
        }
    }

    void popFarthestBall()
    {
        if (balls.size()>=1)
        {
            ball maxBall = balls.get(0);
            float maxDist = 0;
            for (ball c_ball : balls)
            {
                if (c_ball.pos.y > maxDist)
                {
                    maxBall = c_ball;
                    maxDist = c_ball.pos.y;
                }
            }
            maxBall.alive = false;
            particles.createExplosion(maxBall.pos);
        }
    }

    void update()
    {
        for (int i = powerups.size()-1; i >= 0; i--)
        {
            if (balls.size()>0)
            {
                int powInd = powerups.get(i);
                if (powInd == 1)
                {
                    balls.get(balls.size()-1).powerups.add(1);
                    texts.powerText(1);
                }
                if (powInd == 2)
                {
                    balls.get(balls.size()-1).powerups.add(2);
                    texts.powerText(2);
                }
                if (powInd == 3)
                {
                    balls.get(balls.size()-1).powerups.add(3);
                    texts.powerText(3);
                    balls.get(balls.size()-1).speed = (float)height/20000;
                }
                if (powInd == 4)
                {
                    balls.get(balls.size()-1).powerups.add(4);
                    texts.powerText(4);
                }
                if (powInd == 5)
                {
                    balls.get(balls.size()-1).powerups.add(5);
                    texts.powerText(5);
                }
            }
            powerups.remove(i);
        }

        for (int i = 0; i < balls.size(); i++)
        {
            balls.get(i).update();
        }
        for (int i = balls.size()-1; i >= 0; i--)
        {
            if (!balls.get(i).alive)
            {
                playerShooter.activatePower(balls.get(i).powerup);
                if (balls.get(i).powerup == 3)
                {
                    playerShooter.balls.get( playerShooter.balls.size()-1 ).col = balls.get(i).col;
                }
                if (balls.get(i).powerup == 4)
                {
                    playerShooter.balls.get( playerShooter.balls.size()-1 ).col = balls.get(i).col;
                }

                balls.remove(i);
            }
        }

        //reOrganiseBalls();
    }

    void addShaddowBalls()
    {
        for (int i = 0; i < playerShooter.balls.size()-1; i++)
        {
            ball c_ball = playerShooter.balls.get(i);
            if (!c_ball.stuck )
            {
                particles.addBallShaddow(c_ball);
            }
        }
    }
}

colorClass getRandomColorOnBoard()
{
    ArrayList<colorClass> cols = new ArrayList<colorClass>();
    for (int i = 0; i < playerShooter.balls.size()-1; i++)
    {
        ball c_ball = playerShooter.balls.get(i);
        cols.add(c_ball.col);
    }

    int ind = floor(random( 0,cols.size() ));
    return cols.get(ind);
}

class ball{
    float power1Rad;

    int id;

    PVector pos;
    float ang;
    PVector vel;
    float speed;
    PVector velTemp;

    int aniCounter;

    ArrayList<Integer> powerups;

    boolean stuck;
    boolean alive;
    boolean backwall;
    boolean paused;
    colorClass col;

    int ballInd;
    int groupInd;

    int powerup;

    int gravityTimer;

    int attachedGroup;

    ball(float angle)
    {
        id = floor(random(1000000));

        power1Rad = ballSize*3;

        if (starting)
        {
            int ind = floor(random(0,colors.size()));
            col = colors.get(ind);
        }else {
            col = getRandomColorOnBoard();
        }

        speed = (float)height/2000;
        ang = angle;
        vel = new PVector(0,-1);
        vel.mult(speed);
        vel.rotate(ang);
        velTemp = new PVector(0,-1);
        velTemp.mult(speed);
        velTemp.rotate(ang);

        pos = new PVector( 0,0 );

        ballInd = -1;

        alive = true;
        groupInd = -1;
        attachedGroup = -1;

        backwall = false;
        paused = false;

        powerup = 0;
        if (random(0,1)>0.75)
        {
            if (random(0,1)>0.95)
            {
                powerup = 1;
            }else if (random(0,1)>0.7){
                powerup = 4;    
            }else {
                powerup = 4;
                while (powerup == 4){
                    powerup = floor(random(2,powers.size()));    
                }
            }
        }
        
        powerups = new ArrayList<Integer>();

        aniCounter = 0;
        gravityTimer = 0;
    }

    void pause()
    {
        vel.setMag(0);
        paused = true;
    }

    void resume()
    {
        //vel = new PVector( velTemp.x, velTemp.y );
        vel = new PVector(0,-1);
        vel.mult(speed);
        vel.rotate(ang);
        paused = false;
        gravityTimer = 0;
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        translate(pos.x,pos.y);
        drawBallByPowerup();
        drawPowerLogo();

        //text(groupInd,0,0);
        //text(attachedGroup,0,40);
        popStyle();
        popMatrix();
    }

    void drawPowerLogo()
    {
        pushStyle();
        if (powerup == 1)
        {
            colorMode(RGB);
            fill(255,0,0,200+155*(((float)frameCount%2000)/2000.0));
            rectMode(CENTER);
            rotate(PI * sin(2*PI * ((float)frameCount%60)/60.0) );
            stroke(0);
            strokeWeight(5);
            rect(0,0, ballSize/2,ballSize/2);
        }
        if (powerup == 2)
        {
            colorMode(HSB);
            fill(255*((float)(aniCounter%3000)/3000.0), 255, 255, 255*((float)(aniCounter%6000)/6000.0));
            noStroke();
            ellipse(0,0, ballSize/2, ballSize/2);

            //rotate();
            textSize(ballSize/10);
            //text(Rainbow,0,-ballSize);
        }
        if (powerup == 3)
        {
            colorMode(RGB);
            fill(10, 10, 10, 255);
            ellipse(0,0, ballSize/2, ballSize/2);
        }
        if (powerup == 4)
        {
            pushStyle();
            colorMode(RGB);
            noStroke();
            fill(col.red, col.green, col.blue);
            stroke(0);
            strokeWeight(4);
            ellipse(-(ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), (ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), ballSize/3, ballSize/3);
            fill(100);
            ellipse( (ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0),-(ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), ballSize/3, ballSize/3);
            popStyle();
        }
        popStyle();
    }

    void drawBallByPowerup()
    {
        pushStyle();
        if (hasPowerup(3) || hasPowerup(2))
        {
            noStroke();
            fill(col.red, col.green, col.blue);
            ellipse(0,0, ballSize*1.1,ballSize*1.1); 
        }
        
        if (hasNoPowerup())
        {
            noStroke();
            fill(col.red, col.green, col.blue);
            ellipse(0,0, ballSize,ballSize); 
        }
        

        if (hasPowerup(2))
        {
            noStroke();
            colorMode(HSB);
            fill(255*(((float)frameCount%30)/30.0), 255, 255, 255);
            ellipse(0,0, ballSize,ballSize);
        }

        if (hasPowerup(3))
        {
            noStroke();
            colorMode(RGB);
            fill(0);
            ellipse(0,0, ballSize*abs(sin(2*PI * ((float)frameCount%60)/60.0)),ballSize*abs(sin(2*PI * (((float)frameCount%60)/60.0))));
        }

        if (hasPowerup(4))
        {
            colorMode(RGB);
            fill(col.red, col.green, col.blue);
            ellipse(-(ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), (ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), ballSize/1.5, ballSize/1.5);
            fill(100);
            ellipse( (ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0),-(ballSize/4)*sin(2*PI * ((float)frameCount%30)/30.0), ballSize/1.5, ballSize/1.5);
        }

        if (hasPowerup(1))
        {
            noStroke();
            fill(col.red, col.green, col.blue);
            ellipse(0,0, ballSize,ballSize); 
            colorMode(RGB);
            fill(255,0,0,255);
            rectMode(CENTER);
            rotate( PI * sin(2*PI * ((float)frameCount%60)/60.0) );
            stroke(0);
            strokeWeight(5);
            rect(0,0, ballSize,ballSize);
        }
        
        //pushMatrix();
        //scale(0.25);
        //translate(-1.77*ballSize,-1.77*ballSize);
        //image(ball1asset,0,0);
        //popMatrix();
        

        popStyle();
    }

    void update()
    {
        if (stuck)
        {
            if (hasPowerup(4))
            {
                removePow(4);
            }
            if (hasPowerup(2))
            {
                removePow(2);
                particles.createRainbowHit(pos);
            }
        }

        aniCounter += 1;
        if (!paused)
        {
            gravityTimer += 1;
        }

        if ( hasPowerup(3) && !paused )
        {
            float g = 0.0001;
            PVector acc = new PVector(0,-g);
            vel.add(acc);
            pos.add(vel);

            if (pos.x > width-ballSize/2 || pos.x < ballSize/2)
            {
                vel.x *= -0.5;
            }
            if (pos.y > height-ballSize/2)
            {
                vel.y *= -0.5;
                if (vel.mag() < 0.1)
                {
                    vel.setMag(0.1);
                }
            }
            if (pos.y < ballSize/2)
            {
                vel.y *= -0.5;
                if (vel.mag() < 0.1)
                {
                    vel.setMag(0.1);
                }
            }
            if (pos.y > height-ballSize/2)
            {
                pos.y = height-(ballSize/2)-1;
            }
            if (pos.y < ballSize/2)
            {
                pos.y = (ballSize/2)+1;
            }
            if (pos.x > width-ballSize/2)
            {
                pos.x = width-(ballSize/2)-1;
            }
            if (pos.x < ballSize/2)
            {
                pos.x = (ballSize/2)+1;
            }
            pos.add(vel);

            for (int i = 0; i < playerShooter.balls.size(); i++)
            {
                ball c_ball = playerShooter.balls.get(i);
                if (c_ball.pos.dist(pos) < ballSize*1 && c_ball.pos.dist(pos) > 0 && c_ball.stuck )
                {
                    particles.createGlanceHit(pos,c_ball.pos);
                    if ( hasPowerup(1) )
                    {
                        particles.createExplosion( pos );
                        particles.createExplosion( playerShooter.balls.get(i).pos );

                        alive = false;
                        playerShooter.balls.get(i).alive = false;
                        ballsDestroyed += 1;
                        destroySurroundingBalls(pos);
                    }

                    if ( hasPowerup(4) )
                    {
                        //PVector c_ball_old_pos = new PVector(pos.x,pos.y);
                        //pos = new PVector(c_ball.pos.x,c_ball.pos.y);
                        //c_ball.pos = new PVector(c_ball_old_pos.x,c_ball_old_pos.y);
                        colorClass oldCol = new colorClass(col.red,col.green,col.blue);
                        col = new colorClass(c_ball.col.red,c_ball.col.green,c_ball.col.blue);
                        c_ball.col = new colorClass(oldCol.red,oldCol.green,oldCol.blue);

                        removePow(4);
                        particles.createLineExplosion(pos,c_ball.pos, col, c_ball.col);
                        for (int j = 0; j < playerShooter.balls.size(); j++)
                        {
                            ball c_ball_2 = playerShooter.balls.get(j);
                            if (c_ball_2.pos.dist(c_ball.pos) < ballSize*1.2 && c_ball_2.pos.dist(c_ball.pos) > 0 && c_ball_2.stuck && sameColor(c_ball.col, c_ball_2.col) && c_ball_2.id != id)
                            {
                                groups.get( c_ball_2.groupInd ).add( c_ball );
                                c_ball.groupInd = c_ball_2.groupInd;
                                c_ball.attachedGroup = c_ball_2.groupInd;
                            }
                        }
                    }

                    if ( sameColor(c_ball.col,this.col) || (hasPowerup(2) && !hasPowerup(3)) )
                    {
                        stuck = true;
                        vel = new PVector(0,0);
                        groups.get( c_ball.groupInd ).add( this );
                        groupInd = c_ball.groupInd;
                        attachedGroup = c_ball.groupInd;
                        removePow(3);
                        if (hasPowerup(2))
                        {
                            col = c_ball.col;
                            removePow(2);
                            particles.createRainbowHit(c_ball.pos);
                        }
                    }

                    vel.mult(0.9);
                    PVector dv = new PVector(pos.x-c_ball.pos.x, pos.y-c_ball.pos.y);
                    dv.setMag( vel.mag()*0.2 );
                    vel.add(dv);
                    if (vel.mag() < 0.1)
                    {
                        vel.setMag(0.1);
                    }
                    pos.add(vel);
                    pos.add(vel);
                    pos.add(vel);
                    pos.add(vel);
                    pos.add(vel);

                    vel.mult(0.9);
                }
            }

            if (gravityTimer>30000)
            {
                removePow(3);
                vel.setMag(0.5);
            }

        }
        else 
        {
            if (!stuck)
            {
                pos.add( vel );
            }
            

            if (!stuck)
            {

                if (pos.x > width-ballSize/2 || pos.x < ballSize/2)
                {
                    vel.x *= -1;
                }
                if (pos.y > height-ballSize/2)
                {
                    vel.y *= -1;
                }
                if (pos.y < ballSize/2)
                {
                    vel = new PVector(0,0);
                    stuck = true;

                    groups.add(new ArrayList<ball>());
                    groups.get(groups.size()-1).add(this);
                    groupInd = groups.size()-1;
                    //println("group added");

                    backwall = true;
                    attachedGroup = -1;

                    if ( hasPowerup(1) )
                    {
                        particles.createExplosion(pos);
                        alive = false;
                        ballsDestroyed += 1;
                        destroySurroundingBalls(pos);
                    }
                }

                if (pos.y > height)
                {
                    pos.y = height-1;
                }
                if (pos.y < 0)
                {
                    pos.y = 1;
                }
                if (pos.x > width)
                {
                    pos.x = width-1;
                }
                if (pos.x < 0)
                {
                    pos.x = 1;
                }

                for (int i = 0; i < playerShooter.balls.size(); i++)
                {
                    ball c_ball = playerShooter.balls.get(i);
                    if (c_ball.pos.dist(pos) < ballSize*1 && c_ball.pos.dist(pos) > 0 && c_ball.stuck )
                    {
                        if ( hasPowerup(1) )
                        {
                            particles.createExplosion(pos);
                            particles.createExplosion(playerShooter.balls.get(i).pos);

                            alive = false;
                            playerShooter.balls.get(i).alive = false;
                            ballsDestroyed += 2;
                            destroySurroundingBalls(pos);
                        }

                        stuck = true;
                        vel = new PVector(0,0);

                        if ( hasPowerup(4) )
                        {
                            //PVector c_ball_old_pos = new PVector(pos.x,pos.y);
                            //pos = new PVector(c_ball.pos.x,c_ball.pos.y);
                            //c_ball.pos = new PVector(c_ball_old_pos.x,c_ball_old_pos.y);
                            colorClass oldCol = new colorClass(col.red,col.green,col.blue);
                            col = new colorClass(c_ball.col.red,c_ball.col.green,c_ball.col.blue);
                            c_ball.col = new colorClass(oldCol.red,oldCol.green,oldCol.blue);
                            

                            removePow(4);
                            particles.createLineExplosion(pos,c_ball.pos, col, c_ball.col);
                            for (int j = 0; j < playerShooter.balls.size(); j++)
                            {
                                ball c_ball_2 = playerShooter.balls.get(j);
                                if (c_ball_2.pos.dist(c_ball.pos) <= ballSize*1.0 && c_ball_2.pos.dist(c_ball.pos) > 0 && c_ball_2.stuck && sameColor(c_ball.col, c_ball_2.col) && c_ball_2.id != id)
                                {
                                    groups.get( c_ball_2.groupInd ).add( c_ball );
                                    removeBallFromGroupByID(c_ball.groupInd, c_ball);
                                    c_ball.groupInd = c_ball_2.groupInd;
                                    c_ball.attachedGroup = c_ball_2.groupInd;
                                }
                            }
                            //checkBallCollision(this);
                            //checkBallCollision(c_ball);
                        }

                        if ( sameColor(c_ball.col,this.col) || hasPowerup(2) || ( c_ball.hasPowerup(2) && sameColor(this.col,groups.get(c_ball.groupInd).get(0).col) ) )
                        {
                            groups.get( c_ball.groupInd ).add( this );
                            groupInd = c_ball.groupInd;
                            attachedGroup = c_ball.groupInd;
                            if (hasPowerup(2))
                            {
                                col = c_ball.col;
                                removePow(2);
                                particles.createRainbowHit(c_ball.pos);
                            }
                            
                        }
                        else if (c_ball.hasPowerup(2) && groups.get( c_ball.groupInd ).size()==1){
                            groups.get( c_ball.groupInd ).add( this );
                            groupInd = c_ball.groupInd;
                            attachedGroup = c_ball.groupInd;
                        }
                        else{
                            groups.add(new ArrayList<ball>());
                            groups.get(groups.size()-1).add(this);
                            groupInd = groups.size()-1;
                            attachedGroup = c_ball.groupInd;
                        }
                        
                    }
                }

            }

        }
        
    }

    void removeBallFromGroupByID(int c_groupInd, ball tarBall)
    {
        if (c_groupInd == -1)
        {
            c_groupInd = 0;
        }
        println(c_groupInd);
        ArrayList<ball> ballGroup = groups.get(c_groupInd);
        for (int i = 0; i < ballGroup.size(); i++)
        {
            if (ballGroup.get(i).id == tarBall.id)
            {
                groups.get(c_groupInd).remove(i);
                break;
            }
        }
    }


    void checkBallCollision(ball targetBall)
    {
        for (int i = 0; i < playerShooter.balls.size(); i++)
        {
            ball c_ball = playerShooter.balls.get(i);
            if (c_ball.pos.dist(targetBall.pos) < ballSize*1.1 && c_ball.pos.dist(targetBall.pos) > 0 && c_ball.stuck )
            {
                if ( hasPowerup(1) )
                {
                    particles.createExplosion(targetBall.pos);
                    particles.createExplosion(playerShooter.balls.get(i).pos);

                    targetBall.alive = false;
                    playerShooter.balls.get(i).alive = false;
                    ballsDestroyed += 2;
                    destroySurroundingBalls(targetBall.pos);
                }

                targetBall.stuck = true;
                targetBall.vel = new PVector(0,0);

                if ( hasPowerup(4) )
                {
                    PVector c_ball_old_pos = new PVector(targetBall.pos.x,targetBall.pos.y);
                    targetBall.pos = new PVector(c_ball.pos.x,c_ball.pos.y);
                    c_ball.pos = new PVector(c_ball_old_pos.x,c_ball_old_pos.y);
                    removeBallFromGroupByID(c_ball.groupInd, c_ball);
                    groups.get(c_ball.groupInd).add( this );
                    groupInd = c_ball.groupInd;

                    groups.add(new ArrayList<ball>());
                    groups.get(groups.size()-1).add(c_ball);
                    attachedGroup = c_ball.attachedGroup;
                    c_ball.attachedGroup = groupInd;
                    c_ball.groupInd = groups.size()-1;
                    removePow(4);
                    particles.createLineExplosion(pos,c_ball.pos, col, c_ball.col);
                }

                if ( sameColor(c_ball.col,targetBall.col) || hasPowerup(2) || ( c_ball.hasPowerup(2) && sameColor(targetBall.col,groups.get(c_ball.groupInd).get(0).col) ) )
                {
                    groups.get( c_ball.groupInd ).add( targetBall );
                    targetBall.groupInd = c_ball.groupInd;
                    targetBall.attachedGroup = c_ball.groupInd;
                }
                else if (c_ball.hasPowerup(2) && groups.get( c_ball.groupInd ).size()==1){
                    groups.get( c_ball.groupInd ).add( targetBall );
                    targetBall.groupInd = c_ball.groupInd;
                    targetBall.attachedGroup = c_ball.groupInd;
                }
                else{
                    groups.add(new ArrayList<ball>());
                    groups.get(groups.size()-1).add(targetBall);
                    targetBall.groupInd = groups.size()-1;
                    targetBall.attachedGroup = c_ball.groupInd;
                }
                
            }
        }
    }


    void destroySurroundingBalls(PVector origin)
    {
        for (int i = 0; i < playerShooter.balls.size(); i++)
        {
            if (origin.dist(playerShooter.balls.get(i).pos) < power1Rad && origin.dist(playerShooter.balls.get(i).pos) > 0)
            {
                playerShooter.balls.get(i).alive = false;
                ballsDestroyed += 1;
            }
        }
        particles.createDangerExplosion(origin);
    }

    boolean hasPowerup(int powInd)
    {
        for (int i = 0; i < powerups.size(); i++)
        {
            if (powerups.get(i) == powInd)
            {
                return true;
            }
        }
        return false;
    }

    boolean hasNoPowerup()
    {
        if (powerups.size() == 0)
        {
            return true;
        }
        return false;
    }

    void removePow(int powInd)
    {
        for (int i = 0; i < powerups.size(); i++)
        {
            if (powerups.get(i)==powInd)
            {
                powerups.remove(i);
                break;
            }
        }
    }

    boolean sameColor(colorClass col1, colorClass col2)
    {
        if (col1.red == col2.red && col1.green == col2.green && col1.blue == col2.blue)
        {
            return true;
        }
        return false;
    }
}

void mousePressed()
{
    held = true;
    PVector mouse = new PVector(mouseX,mouseY);
    mouse.sub(playerShooter.basePos);
    float mouseAng = mouse.heading() + PI/2;
    playerShooter.ang = mouseAng;
}
void mouseReleased()
{
    held = false;

    if (playerShooter.allStuck())
    {
        playerShooter.shoot();
    }
}


class colorClass
{
    int red;
    int green;
    int blue;
    colorClass(int ired, int igreen, int iblue)
    {
        red   = ired;
        green = igreen;
        blue  = iblue;
    }
}

class particleEngine
{
    ArrayList<particle> particleList;

    particleEngine()
    {
        particleList = new ArrayList<particle>();
    }

    void update()
    {
        for (int i = particleList.size()-1; i >= 0; i--)
        {
            particleList.get(i).update();
            if (!particleList.get(i).alive)
            {
                particleList.remove(i);
            }
        }
    }

    void addBallShaddow(ball targetBall)
    {
        particleList.add( new particle( new PVector(targetBall.pos.x,targetBall.pos.y), new PVector(0,0) ) );
        particleList.get( particleList.size()-1 ).shaddow = true;
        particleList.get( particleList.size()-1 ).col = targetBall.col;
        particleList.get( particleList.size()-1 ).size = ballSize;
        particleList.get( particleList.size()-1 ).lifetime = 20;
    }

    void createExplosion(PVector o)
    {
        
        for (int i = 0; i < 100; i++)
        {
            PVector pDir = new PVector(0,random(20,30));
            pDir.rotate(random(2*PI));
            particleList.add( new particle( new PVector(o.x,o.y), new PVector(pDir.x, pDir.y) ) );
        }
    }

    void createDangerExplosion(PVector pos)
    {
        int partCount = 50;
        for (int i = 0; i < partCount; i++)
        {
            PVector pDir = new PVector(0,10);
            pDir.setMag(random(3,10));
            float ang = (float)i/partCount;
            pDir.rotate(2*PI * (ang));
            particleList.add( new particle( new PVector(pos.x,pos.y), new PVector(pDir.x,pDir.y) ) );
            particleList.get( particleList.size()-1 ).col = new colorClass( 255,0,0);
            particleList.get( particleList.size()-1 ).noAcc = true;
            particleList.get( particleList.size()-1 ).useHSB = false;
            particleList.get( particleList.size()-1 ).danger = true;
            particleList.get( particleList.size()-1 ).size = height/20;
            particleList.get( particleList.size()-1 ).lifetime = floor(random(60,180));
        }
    }

    void createRainbowHit(PVector pos)
    {
        int partCount = 100;
        for (int i = 0; i < partCount; i++)
        {
            PVector pDir = new PVector(0,10);
            pDir.setMag(random(8,10));
            float ang = (float)i/partCount;
            pDir.rotate(2*PI * (ang));
            particleList.add( new particle( new PVector(pos.x,pos.y), new PVector(pDir.x,pDir.y) ) );
            particleList.get( particleList.size()-1 ).col = new colorClass( floor(255*ang),255,255);
            particleList.get( particleList.size()-1 ).noAcc = true;
            particleList.get( particleList.size()-1 ).useHSB = true;
            particleList.get( particleList.size()-1 ).size = height/100;
            particleList.get( particleList.size()-1 ).lifetime = 100;
        }
    }

    void createGlanceHit(PVector a, PVector b)
    {
        int partCount = 3;
        for (int i = 0; i < partCount; i++)
        {
            PVector pDir = new PVector(b.x-a.x,b.y-a.y);
            pDir.setMag(random(5,10));
            float ang = (float)i/partCount;
            if (random(1)>0.5)
            {
                pDir.rotate(PI/2);
            }else {
                pDir.rotate(-PI/2);
            }
            pDir.rotate(random(-PI/8,PI/8));
            particleList.add( new particle( new PVector((a.x+b.x)/2,(a.y+b.y)/2), new PVector(pDir.x,pDir.y) ) );
            particleList.get( particleList.size()-1 ).col = new colorClass( floor(255*ang),100,0);
            particleList.get( particleList.size()-1 ).noAcc = true;
            particleList.get( particleList.size()-1 ).size = height/200;
            particleList.get( particleList.size()-1 ).lifetime = 20;
        }
    }

    void createLineExplosion(PVector a, PVector b, colorClass cola, colorClass colb)
    {
        int partCount = 100;
        for (int i = 0; i < partCount; i++)
        {
            PVector pDir = new PVector(b.x-a.x,b.y-a.y);
            pDir.setMag(random(5,10));
            pDir.rotate(PI/2);
            if (random(0,1)>0.5)
            {
                pDir.rotate(PI);
            }
            pDir.rotate(random(-(float)PI/10.0,(float)PI/10.0));
            PVector c = new PVector(a.x*((float)i/partCount)+b.x*(1-(float)i/partCount), a.y*((float)i/partCount)+b.y*(1-(float)i/partCount));
            particleList.add( new particle( new PVector(c.x,c.y), new PVector(pDir.x,pDir.y) ) );

            if (random(1)>0.5)
            {
                particleList.get( particleList.size()-1 ).col = cola;
            }else {
                particleList.get( particleList.size()-1 ).col = colb;
            }

            particleList.get( particleList.size()-1 ).noAcc = true;
            particleList.get( particleList.size()-1 ).size = height/100;
            particleList.get( particleList.size()-1 ).lifetime = 90;
        }
    }

    void draw()
    {
        for (particle c_part : particleList)
        {
            c_part.draw();
        }
    }
}

class particle{
    PVector pos;
    PVector vel;
    float size;

    int life;
    int lifetime;

    boolean alive;
    boolean noAcc;
    boolean useHSB;
    boolean shaddow;
    boolean danger;

    colorClass col;

    particle(PVector ipos, PVector ivel)
    {
        pos = new PVector(ipos.x,ipos.y);
        vel = new PVector(ivel.x,ivel.y);

        size = height/200;

        life = 0;
        lifetime = 20;

        alive = true;
        noAcc = false;
        useHSB = false;
        shaddow = false;
        danger = false;

        col = new colorClass(255,255,255);
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        if (useHSB)
        {
            colorMode(HSB);
        }else {
            colorMode(RGB);
        }
        fill(col.red, col.green, col.blue, 255*((float)(lifetime-life)/(float)lifetime));
        noStroke();
        translate(pos.x, pos.y);
        if (shaddow)
        {
            ellipse(0,0, size*((float)(lifetime-life)/(float)lifetime),size*((float)(lifetime-life)/(float)lifetime));
        }
        else if (danger)
        {
            float cVal = ((float)(lifetime-life)/(float)lifetime);
            pushMatrix();
            rotate(5*PI*cVal);
            translate(sin(2*PI*cVal)*height/10,0);
            fill(255,0,0);
            stroke(0);
            strokeWeight(5);
            rect(0,0,size*abs(sin(PI*cVal)),size*abs(sin(PI*cVal)));
            popMatrix();
            
        }
        else{
            ellipse(0,0, size,size);    
        }
        

        popStyle();
        popMatrix();
    }

    void update()
    {
        PVector acc = new PVector(0,0);
        if (!noAcc)
        {
            acc = new PVector(0,0.1);
        }
        
        vel.add(acc);
        pos.add(vel);

        life += 1;

        if (life>lifetime)
        {
            alive = false;
        }
    }
}


class textEngine{
    ArrayList<Integer> timers;
    ArrayList<Integer> timerDurations;
    ArrayList<Boolean> modes;


    textEngine()
    {
        timers = new ArrayList<Integer>();
        timerDurations = new ArrayList<Integer>();
        modes  = new ArrayList<Boolean>();

        for (int i = 0; i < 7; i++)
        {
            timers.add( 0 );
            timerDurations.add( 0 );
            modes.add( false );
        }

        //modes[0] -> niceshot
        //modes[1] -> congratulations
        //modes[2] -> danger
        //modes[3] -> rainbow
        //modes[4] -> gravity
        //modes[5] -> swap
        //modes[6] -> youLose
    }

    void powerText(int powInd)
    {
        if (!starting)
        {
            
          if (powInd == 1)
          {
              modes.remove(2);
              modes.add(2,true);
              timers.remove(2);
              timers.add(2,0);
              timerDurations.remove(2);
              timerDurations.add(2,120);
          }
          if (powInd == 2)
          {
              modes.remove(3);
              modes.add(3,true);
              timers.remove(3);
              timers.add(3,0);
              timerDurations.remove(3);
              timerDurations.add(3,120);
          }
          if (powInd == 3)
          {
              modes.remove(4);
              modes.add(4,true);
              timers.remove(4);
              timers.add(4,0);
              timerDurations.remove(4);
              timerDurations.add(4,120);
          }
          if (powInd == 4)
          {
              modes.remove(5);
              modes.add(5,true);
              timers.remove(5);
              timers.add(5,0);
              timerDurations.remove(5);
              timerDurations.add(5,120);
          }
       }
    }

    void nICESHOT()
    {
      if (!starting)
      {
        modes.remove(0);
        modes.add(0,true);
        timers.remove(0);
        timers.add(0,0);
        timerDurations.remove(0);
        timerDurations.add(0,60);
      }
    }

    void congratulations()
    {
      if (!starting)
        {
        modes.remove(1);
        modes.add(1,true);
        timers.remove(1);
        timers.add(1,0);
        timerDurations.remove(1);
        timerDurations.add(1,360);
        }
    }

    void youLose()
    {
      if (!starting)
        {
        modes.remove(6);
        modes.add(6,true);
        timers.remove(6);
        timers.add(6,0);
        timerDurations.remove(6);
        timerDurations.add(6,360);
        }
    }

    void acknoledgeScore(float val)
    {
        if (val > pow(2,5))
        {
            nICESHOT();
        }
    }

    void update()
    {
        for (int i = 0; i < modes.size(); i++)
        {
            if (modes.get(i))
            {
                int val = timers.get(i);
                timers.remove(i);
                timers.add(i,val+1);
            }
        }
        
        //textTimer2 += 1;
        //textTimer3 += 1;
    }

    void draw()
    {
        pushMatrix();
        pushStyle();
        translate(0,height/3);
        if (modes.get(0) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer = timers.get(0);
            int textDuration = timerDurations.get(0);
            if (textTimer <= textDuration/3)
            {
                textSize((height/5) * abs(sin( PI/2 * (float)textTimer/((float)textDuration/3) )));
                text("NICE SHOT", 0,(-height/10)-(height/2)*sin( PI/2 * (float)textTimer/((float)textDuration/3) ));
            }
            else if (textTimer < 2*textDuration/3)
            {
                textSize(height/5);
                text("NICE SHOT", 0,(-height/10)-height/2);
            }
            else if (textTimer >= 2*textDuration/3)
            {
                textSize((height/5) *  abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                text("NICE SHOT", 0,(-height/10)-(height/2)*sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) ));
            }
            if (textTimer > textDuration){
                modes.remove(0);
                modes.add(0,false);
            }
            popMatrix();
            popStyle();
        }
        if (modes.get(1) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(-width/2,-height/2);
            int textTimer = timers.get(1);
            int textDuration = timerDurations.get(1);
            colorMode(HSB);
            fill(255*abs(sin( 2*PI * (float)textTimer/((float)textDuration/3) )),255,255);
            if (textTimer <= textDuration/3)
            {
                textSize((height/16) * abs(sin( PI/2 * (float)textTimer/((float)textDuration/3) )));
                text("Congratulations", width/2,2*(-height/20)+height/2); //height/2*sin( PI/2 * (float)textTimer/((float)textDuration/3) ));
            }
            else if (textTimer < 2*textDuration/3)
            {
                textSize((height/16));
                text("Congratulations", width/2,2*(-height/20)+height/2);
                textSize((height/20) * abs(sin( PI/2 * (float)(textTimer-textDuration/3)/((float)textDuration/3) )));
                text("Clear the next Screen", width/2,2*(-height/20)+height/2 + (height/4)*sin( PI/2 * (float)(textTimer-textDuration/3)/((float)textDuration/3) ));
            }
            else if (textTimer >= 2*textDuration/3)
            {
                textSize((height/16)  *  abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                text("Congratulations", width/2,2*(-height/20)+height/2);//-(height/2)*sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) ));
                textSize((height/20)  * abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                text("Clear the next Screen", width/2,2*(-height/20)+height/2 + height/4 - (height/4)* abs(sin( PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
            }
            if (textTimer > textDuration){
                modes.remove(1);
                modes.add(1,false);
                setup(score);
            }
            popMatrix();
            popStyle();
        }

        if (modes.get(2) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer1 = timers.get(2);
            int textDuration = timerDurations.get(2);
            if (textTimer1 <= textDuration/3)
            {
                textSize((height/12)  * abs(sin( PI/2 * (float)textTimer1/((float)textDuration/3) )));
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,3*(-height/20)-(height/2)*sin( PI/2 * (float)textTimer1/((float)textDuration/3) ));
            }
            else if (textTimer1 < 2*textDuration/3)
            {
                textSize((height/12));
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,3*(-height/20)-height/2);
            }
            else if (textTimer1 >= 2*textDuration/3)
            {
                textSize((height/12) *  abs(sin( PI/2 + PI/2 * (float)(textTimer1-2*textDuration/3)/((float)textDuration/3) )));
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,3*(-height/20)-height/2);
            }
            if (textTimer1 > textDuration){
                modes.remove(2);
                modes.add(2,false);
            }
            popMatrix();
            popStyle();
        }
        
        if (modes.get(3) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer2 = timers.get(3);
            int textDuration = timerDurations.get(3);
            if (textTimer2 <= textDuration/3)
            {
                textSize((height/12) * abs(sin( PI/2 * (float)textTimer2/((float)textDuration/3) )));
                colorMode(HSB);
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,4*(-height/20)-(height/2)*sin( PI/2 * (float)textTimer2/((float)textDuration/3) ));
            }
            else if (textTimer2 < 2*textDuration/3)
            {
                textSize((height/12));
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,4*(-height/20)-height/2);
            }
            else if (textTimer2 >= 2*textDuration/3)
            {
                textSize((height/12) *  abs(sin( PI/2 + PI/2 * (float)(textTimer2-2*textDuration/3)/((float)textDuration/3) )));
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,4*(-height/20)-height/2);
            }
            if (textTimer2 > textDuration){
                modes.remove(3);
                modes.add(3,false);
            }
            popMatrix();
            popStyle();
        }

        if (modes.get(4) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer3 = timers.get(4);
            int textDuration = timerDurations.get(4);
            if (textTimer3 <= textDuration/3)
            {
                textSize((height/12) * abs(sin( PI/2 * (float)textTimer3/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,5*(-height/20)-(height/2)*sin( PI/2 * (float)textTimer3/((float)textDuration/3) ));
            }
            else if (textTimer3 < 2*textDuration/3)
            {
                textSize((height/12));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,5*(-height/20)-height/2);
            }
            else if (textTimer3 >= 2*textDuration/3)
            {
                textSize((height/12) *  abs(sin( PI/2 + PI/2 * (float)(textTimer3-2*textDuration/3)/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,5*(-height/20)-height/2);
            }
            if (textTimer3 > textDuration){
                modes.remove(4);
                modes.add(4,false);
            }
            popMatrix();
            popStyle();
        }

        if (modes.get(5) &&  !lost)
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer3 = timers.get(5);
            int textDuration = timerDurations.get(5);
            if (textTimer3 <= textDuration/3)
            {
                textSize((height/12) * abs(sin( PI/2 * (float)textTimer3/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Swap Ball", 0,6*(-height/20)-(height/2)*sin( PI/2 * (float)textTimer3/((float)textDuration/3) ));
            }
            else if (textTimer3 < 2*textDuration/3)
            {
                textSize((height/12));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Swap Ball", 0,6*(-height/20)-height/2);
            }
            else if (textTimer3 >= 2*textDuration/3)
            {
                textSize((height/12) *  abs(sin( PI/2 + PI/2 * (float)(textTimer3-2*textDuration/3)/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Swap Ball", 0,6*(-height/20)-height/2);
            }
            if (textTimer3 > textDuration){
                modes.remove(5);
                modes.add(5,false);
            }
            popMatrix();
            popStyle();
        }

        if (modes.get(6))
        {
            pushMatrix();
            pushStyle();
            translate(0,height);
            int textTimer = timers.get(6);
            int textDuration = timerDurations.get(6);
            if (textTimer <= textDuration/3)
            {
                textSize((height/10) * abs(sin( PI/2 * (float)textTimer/((float)textDuration/3) )));
                colorMode(RGB);
                fill(150+105*((float)(frameCount%60)/60.0),0,0);
                //strokeWeight(3);
                text("YOU LOSE", 0,-(height/2)*sin( PI/2 * (float)textTimer/((float)textDuration/3) ));
            }
            else if (textTimer < 2*textDuration/3)
            {
                textSize((height/10));
                colorMode(RGB);
                fill(150+105*((float)(frameCount%60)/60.0),0,0);
                //strokeWeight(3);
                text("YOU LOSE", 0,-height/2);
            }
            else if (textTimer >= 2*textDuration/3)
            {
                textSize((height/10) *  abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                colorMode(RGB);
                fill(150+105*((float)(frameCount%60)/60.0),0,0);
                //strokeWeight(3);
                text("YOU LOSE", 0,-height/2);
            }
            if (textTimer > textDuration){
                modes.remove(6);
                modes.add(6,false);
                scores = loadStrings("highscores.txt");
                if (score > Float.valueOf(scores[scores.length-1]))
                {
                    String[] scores = new String[1];
                    scores[0] = str((float)score);
                    saveStrings("highscores.txt", scores);
                }
                
                setup(0);
            }
            popMatrix();
            popStyle();
        }
        popStyle();
        popMatrix();
    }
}


void keyPressed()
{
    if (key == 'p')
    {
        showMenu = !showMenu;
    }

    if (showMenu)
    {
        if (key == '=')
        {
            linkage += 1;
        }
        if (key == '-')
        {
            linkage -= 1;
        }
    }
}
