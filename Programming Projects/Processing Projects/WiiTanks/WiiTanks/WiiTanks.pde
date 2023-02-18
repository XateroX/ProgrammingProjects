Game game;
PVector cameraPos;
PVector cameraTar;


void setup()
{
    fullScreen(P3D);
    ortho();
    game = new Game();
    game.assets.add( game.newMap(10,10) );

    game.tankList.add( game.newTank(true) );

    for (int i = 0; i < 0; i++)
    {
        game.tankList.add( game.newTank(false) );
    }

}

void draw()
{
    //println("touches: ", touches.length);

    background(100);
    lights();
    //cameraPos = new PVector(width/2,width/2+400*width/100,-2.5*width);
    cameraPos = new PVector(width/2,width/2+100,6*width);
    cameraTar = new PVector(width/2,width/2,0);
    camera(cameraPos.x,cameraPos.y,cameraPos.z,  cameraTar.x,cameraTar.y,cameraTar.z  ,0,0,1);
    perspective(PI/30.0,(float)width/height,1,1000000);
    pushMatrix();
    scale(0.5);
    translate(width,width);

    //translate(-width,-width);
    //rotateZ((float)frameCount/400.0);

    pushMatrix();
    game.draw();
    popMatrix();

    game.update();

    popMatrix();
}


class Game
{
    ArrayList<Tank> tankList;
    ArrayList<PShape> assets;
    PImage floor1;

    PVector lStickPos = new PVector(width/3, 2*height/3);
    float lStickrad   = width/5;
    PVector rStickPos = new PVector(2*width/3, 2*height/3);
    float rStickrad   = width/5;

    Game()
    {
        assets = new ArrayList<PShape>();
        tankList = new ArrayList<Tank>();

        floor1 = loadImage("floor1.png");
    }



    void draw()
    {
        pushMatrix();
        
        
        shape(assets.get(0));
        translate(-width/20.0,-width/20.0);

        //pushMatrix();
        //pushStyle();
        //resetMatrix();
        //translate(-width/2,-height/2,0);
        //scale(6);
        //image(floor1, 0,0);
        //popStyle();
        //popMatrix();

        drawTanks();

        popMatrix();
    }
    void drawTanks()
    {
        pushMatrix();
        
        for (Tank tank : tankList)
        {
            pushMatrix();
            tank.draw();
            popMatrix();
        }

        popMatrix();
    }


    void update()
    {
        for (Tank c_tank : tankList)
        {
            c_tank.processInput();
            c_tank.update();
        }
    }



    class Tank
    {
        PShape head;
        PShape body;
        PVector pos;
        PVector vel;
        float targetVel;

        float headAng;
        float bodyAng;

        boolean isPlayer;

        Tank(Boolean i_isPlayer)
        {
            isPlayer = i_isPlayer;

            head = null;
            body = null;

            headAng = random(2*PI);
            bodyAng = random(2*PI);

            pos = new PVector(random(-width/2,width/2),random(-width/2,width/2),150);
            vel = new PVector(0,5);
            vel.rotate(-bodyAng);
            targetVel = 0;

            head = loadShape("wiiTank_head.obj");
            head.resetMatrix();
            head.scale(30);
            head.translate(0,0,-300);
            
            body = loadShape("wiiTank_body.obj");
            body.resetMatrix();
            body.scale(30);
            body.translate(0,0,-300);
        }

        void draw()
        {
            pushStyle();
            pos.add(vel);

            //println("drawn at ", pos.x, pos.y);
            pushMatrix();

            translate(pos.x,pos.y,pos.z);
            rotateX(-PI/2);

            pushMatrix();
            rotateY(bodyAng);
            shape(body);
            popMatrix();
            
            pushMatrix();
            rotateY(headAng);
            shape(head);
            popMatrix();
            
            popMatrix();


            pushMatrix();
            float ellRadx = map(vel.x, 0, 3,0,200);
            float ellRady = map(vel.y, 0, 3,0,200);
            translate( 0,0, pos.z );
            line(pos.x,pos.y, pos.x + ellRadx, pos.y + ellRady);
            translate( pos.x + ellRadx, pos.y + ellRady, 5);
            //translate(cameraPos.x,cameraPos.y,cameraPos.z);
            fill(200*sin((float)frameCount/10.0));
            strokeWeight(5);
            
            ellipse(0,0, 50,50);
            popStyle();
            popMatrix();
        }


        void update()
        {
            vel.setMag(lerp(vel.mag(),targetVel, 0.05));
        }


        void processInput()
        {
            targetVel = 0;
            for (int i=0; i < touches.length; i++)
            {
                PVector c_touch = new PVector(touches[i].x, touches[i].y);
                if (dist(c_touch.x,c_touch.y, game.lStickPos.x,game.lStickPos.y) < game.lStickrad)
                {
                    float velMag = 0.1+vel.mag();
                    PVector diff = new PVector(-c_touch.x+game.lStickPos.x, c_touch.y-game.lStickPos.y);

                    //int headingE = round(diff.heading()/8)*8;
                    //diff.rotate(headingE-diff.heading());

                    targetVel = 5;//map(diff.mag(), 0, game.lStickrad, 0, 4);
                    vel = new PVector(diff.x,diff.y);
                    vel.setMag(velMag);
                    bodyAng = -vel.heading() + PI/2 ;
                }

                else if (dist(c_touch.x,c_touch.y, game.rStickPos.x,game.rStickPos.y) < game.rStickrad)
                {
                    PVector diff = new PVector(-c_touch.x+game.rStickPos.x, c_touch.y-game.rStickPos.y);
                    headAng = -diff.heading() + PI/2;
                }
            }
        }
    }

    PShape newMap(int xLen, int yLen)
    {
        PShape map = createShape(GROUP);
        float size = (float)width/(float)xLen;
        for (int x = 0; x < xLen; x++)
        {
            for (int y = 0; y < yLen; y++)
            {
                PShape c_box = createShape(BOX, (int)size);
                c_box.translate(size*x - width/2, size*y - width/2);
                c_box.setStroke(color(0,0,0,0));
                map.addChild(c_box);
            }
        }
        return map;
    }

    Tank newTank(boolean isPlayer)
    {
        Tank newTank = new Tank(isPlayer);
        return newTank;
    }
}

void mousePressed()
{
    if (mouseX < width/2)
    {
        game.lStickPos = new PVector(mouseX,mouseY);
    }

    else if (mouseX >= width/2)
    {
        game.rStickPos = new PVector(mouseX,mouseY);
    }
}
