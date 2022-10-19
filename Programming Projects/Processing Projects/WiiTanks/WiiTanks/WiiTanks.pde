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

    for (int i = 0; i < 20; i++)
    {
        game.tankList.add( game.newTank(false) );
    }

}

void draw()
{
    //println("touches: ", touches.length);

    background(100);
    lights();
    cameraPos = new PVector(width/2,width/2-400*width/100,-2.5*width);
    cameraTar = new PVector(width/2,width/2,0);
    camera(cameraPos.x,cameraPos.y,cameraPos.z,  cameraTar.x,cameraTar.y,cameraTar.z  ,0,0,1);
    perspective(PI/30.0,(float)width/height,1,100000);
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

    PVector lStickPos = new PVector(width/3, 2*height/3);
    float lStickrad   = width/5;
    PVector rStickPos = new PVector(2*width/3, 2*height/3);
    float rStickrad   = width/5;

    Game()
    {
        assets = new ArrayList<PShape>();
        tankList = new ArrayList<Tank>();
    }



    void draw()
    {
        pushMatrix();
        
        shape(assets.get(0));
        translate(-(float)width/20.0,-(float)width/20.0);

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

            pos = new PVector(random(-width/2,width/2),random(-width/2,width/2), -150);
            vel = new PVector(0,1);
            vel.rotate(-bodyAng);

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
            translate( pos.x + 200*vel.x, pos.y + 200*vel.y, pos.z );
            //translate(cameraPos.x,cameraPos.y,cameraPos.z);
            fill(200*sin((float)frameCount/10.0));
            ellipse(0,0, 50,50);
            popMatrix();
        }


        void update()
        {}


        void processInput()
        {
            for (int i=0; i < touches.length; i++)
            {
                PVector c_touch = new PVector(touches[i].x, touches[i].y);
                if (dist(c_touch.x,c_touch.y, game.lStickPos.x,game.lStickPos.y) < game.lStickrad)
                {
                    PVector diff = new PVector(c_touch.x-game.lStickPos.x, c_touch.y-game.lStickPos.y);
                    diff.setMag(vel.mag());
                    vel = new PVector(diff.x,diff.y);
                    bodyAng = -PVector.angleBetween(vel,new PVector(0,1));
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