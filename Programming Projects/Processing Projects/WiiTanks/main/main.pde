Game game;

 assets;

void setup()
{
    fullScreen(P3D);
    game = new Game();
}

void draw()
{

}


class Game
{
    Tank tank1;
    Game()
    {
        tank1  = new Tank();
    }

    class Tank
    {
        Tank()
        {

        }
    }
}
