shooter playerShooter;
boolean held;
float ballSize;

ArrayList<ArrayList<ball>> groups;

ArrayList<colorClass> colors;

ArrayList<Integer> powers;

boolean starting;

int score;

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


void setup()
{
    //size(563,1000);
    fullScreen();
    background(0);

    powers = new ArrayList<Integer>();
    for (int i = 0; i < 4; i++)
    {
        powers.add( powers.size() );
    }

    colors = new ArrayList<colorClass>();
    colors.add( new colorClass(200,0,0) );
    //colors.add( new colorClass(230,180,50) );
    colors.add( new colorClass(0,0,200) );

    //colors.add( new colorClass(150,200,120) );
    //colors.add( new colorClass(100,50,100) );
    colors.add( new colorClass(200,200,100) );

    colors.add( new colorClass(100,100,200) );
    colors.add( new colorClass(100,200,100) );
    colors.add( new colorClass(200,100,100) );

    playerShooter = new shooter();

    ballSize = width/15;

    groups = new ArrayList<ArrayList<ball>>();

    starting = true;

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
}

void draw()
{
    if (starting && frameCount%5==0)
    {
        playerShooter.ang = random(-PI/3, PI/3);
        playerShooter.shoot();
    }
    if (starting && playerShooter.balls.size() >= 80){
        starting = false;
        ballsDestroyed = 0;
    }

    if (frameCount%20==0 && ballsDestroyed != 0 && !starting)
    {
        score += pow(2,ballsDestroyed) * comboMultiplier;
        texts.acknoledgeScore(pow(2,ballsDestroyed));
        scoreScale = map(ballsDestroyed,3,15,1.5,5);
        ballsDestroyed = 0;
        comboMultiplier *= 2;
        comboBreak = false;
    }

    if (comboBreak && playerShooter.allStuck() && frameCount%20==0)
    {
        comboMultiplier = 1;
    }

    background(0);

    if (held)
    {
        PVector mouse = new PVector(mouseX,mouseY);
        mouse.sub(playerShooter.pos);
        float mouseAng = mouse.heading() + PI/2;
        playerShooter.ang = mouseAng;
    }

    playerShooter.draw();
    for (int i = 0; i < 100; i++)
    {
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

            if ( !attachedGroupIsDetached(i) )
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
                stroke(255, 50+55*((float)groups.get(i).get(j).aniCounter%5000/5000.0));
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
    
    pushStyle();
    scoreScale = lerp(scoreScale,1,0.03);
    textSize(scoreScale * width/5);
    textAlign(CENTER,CENTER);
    text(score, width/2,5*height/6);
    popStyle();

    pushStyle();
    scoreScale = lerp(scoreScale,1,0.03);
    textSize(scoreScale * width/10);
    textAlign(CENTER,CENTER);
    text("X" + str(comboMultiplier), width/2,5*height/6 + scoreScale * width/4);
    popStyle();

    //println("groups: ", groups.size());
    //for (ArrayList<ball> group : groups)
    //{
       //println("group size: ", group.size());
    //}

    particles.update();
    particles.draw();

    texts.update();
    texts.draw();

    //println("score:", score);
    //println("previousScore", previousScore);

    if (playerShooter.balls.size() == 1 && !starting)
    {
        texts.congratulations();
    }

    if (showMenu)
    {
        drawMenu();
    }
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

boolean attachedGroupIsDetached(int i)
{
    //println("Group: ", i);

    for (int j = groups.get(i).size()-1; j >= 0; j--)
    {
        if (groups.get(i).get(j).attachedGroup != i)
        {
            if ( groups.get(i).get(j).attachedGroup==-1 )
            {
                return false;
            }
            if ( attachedGroupIsDetached( groups.get(i).get(j).attachedGroup ) )
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
    boolean canShoot;
    float ang;

    ArrayList<ball> balls;

    ball nextBall;

    ArrayList<Integer> powerups;

    shooter()
    {
        pos = new PVector(width/2,height*0.9);
        canShoot = true;
        ang = 0;

        balls = new ArrayList<ball>();
        nextBall = new ball(ang);

        balls.add( new ball(ang) );
        balls.get( balls.size()-1 ).pos = new PVector(pos.x,pos.y);
        balls.get( balls.size()-1 ).ballInd = balls.size()-1;
        balls.get( balls.size()-1 ).speed = 0.4;
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

        PVector d  = new PVector(0,-100);
        d.rotate(ang);
        strokeWeight(10);
        for (int i = 0; i < 10; i++)
        {
            stroke(100, 200 * (1.0 - (float)i/10));
            fill(  100, 200 * (1.0 - (float)i/10));
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
    }

    void activatePower(int powInd)
    {
        playerShooter.powerups.add(powInd);
    }

    void update()
    {
        for (int i = powerups.size()-1; i >= 0; i--)
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
                balls.get(balls.size()-1).speed = 0.1;
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
                balls.remove(i);
            }
        }
    }
}

class ball{
    float power1Rad;

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
        power1Rad = ballSize*3;

        int ind = floor(random(0,colors.size()));
        col = colors.get(ind);

        speed = 0.4;
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
        if (random(0,1)>0.9)
        {
            if (random(0,1)>0.95)
            {
                powerup = 1;
            }else {
                powerup = floor(random(2,powers.size()));    
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
        popStyle();
        popMatrix();
    }

    void drawPowerLogo()
    {
        pushStyle();
        if (powerup == 0)
        {}
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
        popStyle();
    }

    void drawBallByPowerup()
    {
        pushStyle();
        
        
        noStroke();
        fill(col.red, col.green, col.blue);
        ellipse(0,0, ballSize,ballSize); 

        if (hasPowerup(2))
        {
            noStroke();
            colorMode(HSB);
            fill(255*(((float)frameCount%30)/30.0), 255, 255, 255);
            ellipse(0,0, ballSize,ballSize);
        }

        if (hasPowerup(3))
        {
            colorMode(RGB);
            noStroke();
            fill(0);
            ellipse(0,0, ballSize*abs(sin(2*PI * ((float)frameCount%60)/60.0)),ballSize*abs(sin(2*PI * (((float)frameCount%60)/60.0))));
        }

        if (hasPowerup(1))
        {
            colorMode(RGB);
            fill(255,0,0,255);
            rectMode(CENTER);
            rotate( PI * sin(2*PI * ((float)frameCount%60)/60.0) );
            stroke(0);
            strokeWeight(5);
            rect(0,0, ballSize,ballSize);
        }
        
        popStyle();
    }

    void update()
    {
        aniCounter += 1;
        if (!paused)
        {
            gravityTimer += 1;
        }

        if ( hasPowerup(3) && !paused )
        {
            float g = 0.00003;
            PVector acc = new PVector(0,-g);
            vel.add(acc);
            pos.add(vel);

            if (pos.x > width-ballSize/2 || pos.x < ballSize/2)
            {
                vel.x *= -1;
            }
            if (pos.y > height-ballSize/2)
            {
                vel.y *= -0.8;
                if (vel.mag() < 0.2)
                {
                    vel.setMag(0.2);
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
            pos.add(vel);

            for (int i = 0; i < playerShooter.balls.size(); i++)
            {
                ball c_ball = playerShooter.balls.get(i);
                if (c_ball.pos.dist(pos) < ballSize*1.1 && c_ball.pos.dist(pos) > 0 && c_ball.stuck )
                {
                    if ( hasPowerup(1) )
                    {
                        particles.createExplosion( pos );
                        particles.createExplosion( playerShooter.balls.get(i).pos );

                        alive = false;
                        playerShooter.balls.get(i).alive = false;
                        ballsDestroyed += 1;
                    }

                    if ( sameColor(c_ball.col,this.col) || (hasPowerup(2) && !hasPowerup(3)) )
                    {
                        stuck = true;
                        vel = new PVector(0,0);
                        groups.get( c_ball.groupInd ).add( this );
                        groupInd = c_ball.groupInd;
                        attachedGroup = c_ball.groupInd;
                        removePow(3);
                    }

                    vel.mult(0.4);
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

                    vel.mult(0.5);
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

                for (int i = 0; i < playerShooter.balls.size(); i++)
                {
                    ball c_ball = playerShooter.balls.get(i);
                    if (c_ball.pos.dist(pos) < ballSize*1.1 && c_ball.pos.dist(pos) > 0 && c_ball.stuck )
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

                        if ( sameColor(c_ball.col,this.col) || hasPowerup(2) || ( c_ball.hasPowerup(2) && sameColor(this.col,groups.get(c_ball.groupInd).get(0).col) ) )
                        {
                            groups.get( c_ball.groupInd ).add( this );
                            groupInd = c_ball.groupInd;
                            attachedGroup = c_ball.groupInd;
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

    void createExplosion(PVector o)
    {
        for (int i = 0; i < 100; i++)
        {
            particleList.add( new particle( new PVector(o.x,o.y), new PVector(random(-30,30),random(-30,30)) ) );
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

    particle(PVector ipos, PVector ivel)
    {
        pos = new PVector(ipos.x,ipos.y);
        vel = new PVector(ivel.x,ivel.y);

        size = 10;

        life = 0;
        lifetime = 30;

        alive = true;
    }

    void draw()
    {
        pushMatrix();
        pushStyle();

        fill(255, 255*((float)(lifetime-life)/(float)lifetime));
        noStroke();
        translate(pos.x, pos.y);
        ellipse(0,0, size,size);

        popStyle();
        popMatrix();
    }

    void update()
    {
        PVector acc = new PVector(0,2);
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
    int textTimer;
    int textTimer1;
    int textTimer2;
    int textTimer3;
    int textDuration;

    int mode;

    boolean playing;

    boolean dangerMode;
    boolean rainbowMode;
    boolean gravityMode;

    textEngine()
    {
        textTimer  = 0;
        textTimer1 = 0;
        textTimer2 = 0;
        textTimer3 = 0;
        textDuration = 120;

        playing = false;

        dangerMode = false;
        rainbowMode = false;
        gravityMode = false;

        mode = 2;
    }

    void powerText(int powInd)
    {
        mode = 2;
        playing = true;
        textDuration = 180;
        textTimer = 0;
        if (powInd == 1)
        {
            dangerMode = true;
            textTimer1 = 0;
        }
        if (powInd == 2)
        {
            rainbowMode = true;
            textTimer2 = 0;
        }
        if (powInd == 3)
        {
            gravityMode = true;
            textTimer3 = 0;
        }
    }

    void nICESHOT()
    {
        mode = 0;
        playing = true;
        textDuration = 120;
    }

    void congratulations()
    {
        mode = 1;
        playing = true;
        textDuration = 360;
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
        if (playing)
        {
            if (mode == 0)
            {
                textTimer += 1;
            }
            if (dangerMode)
            {
                textTimer1 += 1;
            }
            if (rainbowMode)
            {
                textTimer2 += 1;
            }
            if (gravityMode)
            {
                textTimer3 += 1;
            }
            
            //textTimer2 += 1;
            //textTimer3 += 1;

            if (textTimer > textDuration)
            {
                playing = false;
                dangerMode = false;
                rainbowMode = false;
                gravityMode = false;
                textTimer = 0;
            }
            if (textTimer1 > textDuration)
            {
                dangerMode = false;
                textTimer1 = 0;
                playing = false;
            }
            if (textTimer2 > textDuration)
            {
                rainbowMode = false;
                textTimer2 = 0;
                playing = false;
            }
            if (textTimer3 > textDuration)
            {
                gravityMode = false;
                textTimer3 = 0;
                playing = false;
            }
        }
    }

    void draw()
    {
        pushMatrix();
        pushStyle();
        if (mode == 0)
        {
            translate(0,height);
            if (textTimer <= textDuration/3)
            {
                textSize(250 * abs(sin( PI/2 * (float)textTimer/((float)textDuration/3) )));
                text("NICE SHOT", 0,-(height/2)*sin( PI/2 * (float)textTimer/((float)textDuration/3) ));
            }
            else if (textTimer < 2*textDuration/3)
            {
                textSize(250);
                text("NICE SHOT", 0,-height/2);
            }
            else if (textTimer >= 2*textDuration/3)
            {
                textSize(250 *  abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                text("NICE SHOT", 0,-(height/2)*sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) ));
            }
        }
        if (mode == 1)
        {
            translate(width/2,height);
            if (textTimer <= textDuration/3)
            {
                textSize(150 * abs(sin( PI/2 * (float)textTimer/((float)textDuration/3) )));
                text("Congratulations", 0,-(height/2)*sin( PI/2 * (float)textTimer/((float)textDuration/3) ));
            }
            else if (textTimer < 2*textDuration/3)
            {
                textSize(150);
                text("Congratulations", 0,-height/2);
                text("Clear the next Screen", 0,height/2 - (height/4)*sin( PI/2 * (float)(textTimer-textDuration/3)/((float)textDuration/3) ));
            }
            else if (textTimer >= 2*textDuration/3)
            {
                textSize(150 *  abs(sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) )));
                text("Congratulations", 0,-(height/2)*sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) ));
                text("Clear the next Screen", 0,height/2 - (height/4)*sin( PI/2 + PI/2 * (float)(textTimer-2*textDuration/3)/((float)textDuration/3) ));
            }
        }

        if (dangerMode)
        {
            translate(0,height);
            if (textTimer1 <= textDuration/3)
            {
                textSize(150 * abs(sin( PI/2 * (float)textTimer1/((float)textDuration/3) )));
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,-(height/2)*sin( PI/2 * (float)textTimer1/((float)textDuration/3) ));
            }
            else if (textTimer1 < 2*textDuration/3)
            {
                textSize(150);
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,-height/2);
            }
            else if (textTimer1 >= 2*textDuration/3)
            {
                textSize(150 *  abs(sin( PI/2 + PI/2 * (float)(textTimer1-2*textDuration/3)/((float)textDuration/3) )));
                fill(255,0,0);
                //strokeWeight(3);
                text("Danger Ball", 0,-height/2);
            }
        }
        
        if (rainbowMode)
        {
            translate(0,height);
            if (textTimer2 <= textDuration/3)
            {
                textSize(150 * abs(sin( PI/2 * (float)textTimer2/((float)textDuration/3) )));
                colorMode(HSB);
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,-(height/2)*sin( PI/2 * (float)textTimer2/((float)textDuration/3) ));
            }
            else if (textTimer2 < 2*textDuration/3)
            {
                textSize(150);
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,-height/2);
            }
            else if (textTimer2 >= 2*textDuration/3)
            {
                textSize(150 *  abs(sin( PI/2 + PI/2 * (float)(textTimer2-2*textDuration/3)/((float)textDuration/3) )));
                fill(255*((float)(frameCount%60)/60.0),255,255);
                //strokeWeight(3);
                text("Rainbow Ball", 0,-height/2);
            }
        }

        if (gravityMode)
        {
            translate(0,height);
            if (textTimer3 <= textDuration/3)
            {
                textSize(150 * abs(sin( PI/2 * (float)textTimer3/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,-(height/2)*sin( PI/2 * (float)textTimer3/((float)textDuration/3) ));
            }
            else if (textTimer3 < 2*textDuration/3)
            {
                textSize(150);
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,-height/2);
            }
            else if (textTimer3 >= 2*textDuration/3)
            {
                textSize(150 *  abs(sin( PI/2 + PI/2 * (float)(textTimer3-2*textDuration/3)/((float)textDuration/3) )));
                fill(150+105*((float)(frameCount%60)/60.0));
                //strokeWeight(3);
                text("Gravity Ball", 0,-height/2);
            }
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