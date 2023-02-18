int lineNo;
int nAgents;

int t;

ArrayList<ArrayList<PVector>> positions;

void setup(){
  fullScreen();
  
  lineNo = 1;
  t = 0;
  
  positions = new ArrayList<ArrayList<PVector>>();
  positions.add( new ArrayList<PVector>() );
  readFileStrings();
}

void draw(){
}



void readFile()
{
  BufferedReader reader = createReader("output.txt");
  String line = null;

  try
  {
    line = reader.readLine();
    String[] init = split(line, " ");
    nAgents = int(float(init[2]));
    
    while((line = reader.readLine()) != null)
    {
      String[] lineSplit = split(line, ' '); 
      if (lineSplit.length == 2)
      {
        println(float(lineSplit[0]));
        println(lineSplit[1]);
        positions.get(t).add(new PVector(float(lineSplit[0]), float(lineSplit[1])));
      }
    }
    reader.close();
    
    println(positions);
  } catch (IOException e)
  {
    e.printStackTrace();  
  }
}


void readFileStrings()
{
   String[] lines = loadStrings("output.txt");
   for (String s : lines)
   {
     println(s);
   }
   String[] values = split(lines[0], " ");
   println(float(values[0]));
   
}
