ArrayList<ArrayList<tile>> grid;
int gridrows;
int gridcols;
float tileSize;

ArrayList<agent> agents;
int agentDirsSize;
int agentCount;

int finishx;
int finishy;

int iter;

void setup()
{
    size(1000,1000);
    //frameRate(5);

    iter = 0;

    agentCount = 5;
    agents = new ArrayList<agent>();
    agentDirsSize = 100;
    for (int i = 0; i < agentCount; i++)
    {
        agents.add( new agent() );
    }

    grid = new ArrayList<ArrayList<tile>>();
    gridrows = 10;
    gridcols = 10;
    tileSize = (float)width/(float)gridcols;

    finishx = floor(random(gridcols));
    finishy = floor(random(gridrows));

    for (int x = 0; x < gridcols; x++)
    {
        grid.add(new ArrayList<tile>());
        for (int y = 0; y < gridcols; y++)
        {
            grid.get(x).add(new tile(x,y));
            if (random(0,1) < 0.2 && !(x== finishx && y==finishy) && !(x==0 && y==0))
            {
                grid.get(x).get(y).wall=true;
            }
            if (x==0 && y==0)
            {
                grid.get(x).get(y).start=true;
                grid.get(x).get(y).wall =false;
            }
            
        }
    }

    grid.get(finishx).get(finishy).finish=true;
}

void draw()
{
    //for (int i = 0; i < 1; i++)
    //{
        background(0);
        drawgrid();
        drawAgents();
        updateAgents();
        iter+=1;
        if (iter >= agentDirsSize)
        {
            
            refreshAgents();
            iter = 0;
        }
    //}
}


void drawgrid()
{
    pushMatrix();
    pushStyle();

    translate(0,0);
    fill(100);
    stroke(200);
    rect(0,0,gridcols*tileSize,gridrows*tileSize);
    for (int x = 0; x < gridcols; x++)
    {
        pushMatrix();
        translate(x*tileSize,0);
        grid.add(new ArrayList<tile>());
        for (int y = 0; y < gridcols; y++)
        {
            pushMatrix();
            translate(0,y*tileSize);
            grid.get(x).get(y).drawme();
            popMatrix();
        }
        popMatrix();
    }

    popStyle();
    popMatrix();
}

void drawAgents()
{
    pushMatrix();
    pushStyle();

    for (int i = 0; i < agents.size(); i++)
    {
        pushMatrix();

        translate(random(-0.1,0.1)*tileSize,random(-0.1,0.1)*tileSize);
        translate((agents.get(i).x+0.5)*tileSize,(agents.get(i).y+0.5)*tileSize);
        agents.get(i).drawme();

        popMatrix();
    }

    popMatrix();
    popStyle();
}

void updateAgents()
{
    for (agent c_agent : agents)
    {
        c_agent.doAction();
    }
}

void refreshAgents()
{
    ArrayList<Float> scores = new ArrayList<Float>();
    float totalScore = 0;
    for (int i = 0; i < agents.size(); i++)
    {
        agent c_agent = agents.get(i);
        float score = map(abs(c_agent.x-finishx) + abs(c_agent.y-finishy), gridcols+gridrows,0,0,100);
        scores.add( pow(score,1) );
        totalScore += pow(score,1);
        println("score=",pow(score,1));
    }

    ArrayList<agent> newAgents = new ArrayList<agent>();
    for (int i = 0; i < agents.size(); i++)
    {
        agent c_agent = agents.get(i);
        float prop = scores.get(i)/totalScore;
        int amt    = round(prop*agentCount);
        println("prop=", prop);
        println("amt=", amt);

        for (int j = 0; j < amt; j++)
        {
            agent newAgent = new agent();
            for (int n = 0; n < c_agent.dirs.size(); n++)
            {
                newAgent.dirs.remove(n);
                newAgent.dirs.add(n,c_agent.dirs.get(n));
            }
            newAgent.dirs = c_agent.dirs;
            for (int k = 0; k <= newAgent.dirs.size()*0.01; k++)
            {
                int mutationInd = floor(random(0,newAgent.dirs.size()-1));
                newAgent.dirs.remove(mutationInd);
                newAgent.dirs.add(mutationInd,floor(random(0,4)));
            }
            newAgents.add( newAgent );
        }
    }
    if (newAgents.size() < agents.size())
    {
        int diff = agents.size()-newAgents.size();
        println(diff);
        for (int l = 0; l < diff; l++)
        {
            newAgents.add( new agent() );
        }
    }
    agents = newAgents; 
}
