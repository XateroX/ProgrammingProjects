class pokedex
{
    /*
    Pokedex class should handle manipulating the 'pokedex' csv to make it easier to use
    */
    Table Pokedex;
    Table typechart;
    pokedex(String dex_location)
    {  
        Pokedex   = loadTable(dex_location, "header");
        typechart = null;
    }

    public Table loadTypechart(String chart_location)
    {
        typechart = loadTable(chart_location, "header");
        for (TableRow row : typechart.rows())
        {
            break;
        }

        return typechart;
    }

    public String[] getPokemonNames()
    {
        /*
        return a simple list containing all of the names of the pokemon in the database
        */
        String[] pokemon_names = new String[0];
        for (TableRow row : Pokedex.rows())
        {
            pokemon_names = append(pokemon_names, row.getString(2));
        }
        return pokemon_names;
    }
    public int pokemonCount()
    {
        /*
        return the number of pokemon in the database
        */
        return Pokedex.getRowCount();
    }
    public String getName(int ind)
    {
        /*
        return the name of the pokemon at index ind in the database
        */
        int i = 0;
        for (TableRow row : Pokedex.rows())
        {
            if (i == ind)
            {
                return row.getString(2);
            }
            i += 1;
        }
        return null;
    }

    public FloatDict findPokemonByName(String nameGuess)
    {
        /*
        return the pokemon index list in order of most likely to be the searched pokemon

        1-> Go through all pokemon and calculate 'score' based on the typed request
        2-> Sort all by score
        3-> Return list of indexes as a string list of the names
        */

        int[] indexArr     = new int[pokemonCount()];
        float[] scoreArr   = new float[pokemonCount()];
        String[] stringArr = new String[0];
        FloatDict data = new FloatDict(); 

        // instance the indexArr as a list of the indexes to be rearranged later into the score order
        for (int i = 0; i < pokemonCount(); i++)
        {indexArr[i] = i;}

        // 1-> Go through all pokemon and calculate 'score' based on the typed request
        for (int i = 0; i < pokemonCount(); i++)
        {
            String name  = getName(i);
            scoreArr[i]  = evaluateName(name.toLowerCase(),nameGuess.toLowerCase());
            data.set(name,scoreArr[i]);
        }
        data.sortValuesReverse();

        return data;
    }

    private float evaluateName(String realName, String guessName)
    {
        /*
        evaluate how close two names are by checking letters and allocating score points
        */
        float score = 0;
        char[] realNameArr  = stringToCharArr(realName);
        char[] guessNameArr = stringToCharArr(guessName);

        boolean firstLetter     = true;
        int firstLetterPosition = -1;
        for (char let : guessNameArr)
        {
            for (int i = 0; i < realNameArr.length; i++)
            {
                if (realNameArr[i] == let)
                {
                    // Storing the position of the first letter of the guess in the real name
                    if (firstLetter){firstLetterPosition=i; firstLetter=false;}
                    
                    score += 1.0/(float)(i+1);
                    break;
                }
            }
        }
        // TODO - Need to make this check the first letter of the guessname that is ACTUALLY in the real name   
        if (firstLetterPosition != -1)
        {
            for (int i = 0; i < guessNameArr.length; i++)
            {
                if (firstLetterPosition+i < realNameArr.length)
                {
                    if (realNameArr[firstLetterPosition+i]==guessNameArr[i])
                    {
                        score+=0.5;
                    }
                }
            }
        }
        
        return score;
    }

    public char[] stringToCharArr(String str)
    {
        /*
        convert strings to character arrays
        */
        char[] charArr = new char[str.length()];
        for (int i = 0; i < str.length(); i++)
        {
            charArr[i] = str.charAt(i);
        }
        return charArr;
    }

    public TableRow pokemonData(String pokemonName)
    {
        for (TableRow row : Pokedex.rows())
        {
            if (pokemonName.toLowerCase().equals(row.getString(2).toLowerCase()))
            {
                return row;
            }
        }
        return null;
    }
    public TableRow pokemonData(int pokemonIndex)
    {
        int n = 0;
        for (TableRow row : Pokedex.rows())
        {
            if (n == pokemonIndex)
            {
                return row;
            }
            n+=1;
        }
        return null;
    }
}
class pokemon
{
    TableRow originalPokemonRow;
    String name;
    int atk;
    int atkSp;
    int def;
    int defSp;
    int hp;
    int speed;
    String type1;
    String type2;

    pokemon(TableRow pokemonRow)
    {
        originalPokemonRow = pokemonRow;
        name  = originalPokemonRow.getString(2);
        atk   = int(originalPokemonRow.getString(4));
        atkSp = int(originalPokemonRow.getString(6));
        def   = int(originalPokemonRow.getString(5));
        defSp = int(originalPokemonRow.getString(7));
        hp    = int(originalPokemonRow.getString(3));
        speed = int(originalPokemonRow.getString(8));
        type1 = originalPokemonRow.getString(10);
        type2 = originalPokemonRow.getString(11);
    }

    void displayStats(float x, float y)
    {
        y+=width/16;
        x-=width/10;
        text(type1, x,y);
        x+=width/5;
        text(type2, x,y);
        x-=width/20;
        y+=width/16;
        text("atk:   "+atk, x,y);
        y+=width/16;
        text("def:   "+def, x,y);
        y+=width/16;
        text("atkSp: "+atkSp, x,y);
        y+=width/16;
        text("defSp: "+defSp, x,y);
        y+=width/16;
        text("hp:    "+hp, x,y);
        y+=width/16;
        text("speed: "+speed, x,y);
        
        
    }

    public ArrayList<int[]> matchup(pokemon pokeb)
    {
        ArrayList<int[]> damage = new ArrayList<int[]>();
        damage.add(new int[100]);damage.add(new int[100]);
        damage.add(new int[100]);damage.add(new int[100]);

        int[] dmg_vals1 = damage.get(0);
        for (int power = 1; power < 101; power++) //20-120 is best for power range//
        {
            dmg_vals1[power-1] = Damage(this, pokeb, power, false, type1);
        }

        int[] dmg_vals2 = damage.get(1);
        for (int power = 1; power < 101; power++)
        {
            dmg_vals2[power-1] = Damage(this, pokeb, power, true, type1);
        }

        if (!type2.equals(""))
        {
            int[] dmg_vals3 = damage.get(2);
            for (int power = 1; power < 101; power++)
            {
                dmg_vals3[power-1] = Damage(this, pokeb, power, false, type2);
            }

            int[] dmg_vals4 = damage.get(3);
            for (int power = 1; power < 101; power++)
            {
                dmg_vals4[power-1] = Damage(this, pokeb, power, true, type2);
            }
        }
        return damage;
    }


    float typematchup(pokemon pb, String atype)
    {
        int row_ind = 0;
        //println("Type: " + atype);
        for (TableRow row : Pokedex.typechart.rows())
        {
            //println(row.getString(0));
            if (row.getString(0).equals(atype))
            {
                //println("Found type" + atype + " at index " + row_ind);
                break;
            }
            row_ind+=1;
        }
        
        float multiplier                       = float(Pokedex.typechart.getStringColumn(pb.type1)[row_ind]);
        if (!pb.type2.equals("")) {multiplier *= float(Pokedex.typechart.getStringColumn(pb.type2)[row_ind]);}
        return multiplier;
    }
    
}

pdex = pokedex("pokedex.csv");

names        = pdex.getPokemonNames();
int[] hp     = new int[names.length];
int[] defs   = new int[names.length];
int[] spdefs = new int[names.length];

for (String name : names)
{
    hp     = append(hp,     pdex.pokemonData.getString(3))
    defs   = append(defs,   pdex.pokemonData.getString(5))
    spdefs = append(spdefs, pdex.pokemonData.getString(7))
}

println(hp);
println(defs);
println(spdefs);

