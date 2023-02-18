package sim;

import java.util.ArrayList;

public class mathMethods
{
    public static ArrayList<Double> addArr(ArrayList<Double> vec1, ArrayList<Double> vec2)
    {
        for (int i = 0; i < vec1.size(); i++)
        {
            Double comp_vec1 = vec1.get(i);
            Double comp_vec2 = vec2.get(i);
            vec1.remove(i);
            vec1.add(i, comp_vec1+comp_vec2);
        }
        return vec1;
    }
    public static ArrayList<Double> addArr(ArrayList<Double> vec1, Double[] arr2)
    {
        for (int i = 0; i < vec1.size(); i++)
        {
            Double comp_vec1 = vec1.get(i);
            Double comp_vec2 = arr2[i];
            vec1.remove(i);
            vec1.add(i, comp_vec1+comp_vec2);
        }
        return vec1;
    }
}