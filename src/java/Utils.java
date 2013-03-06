/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author brook
 */
import java.util.List;
import org.json.simple.*;
import com.google.gson.*;
public class Utils {
    public static boolean isNullOrEmpty(String s){
        return s == null || s.length() == 0;
    }
    
    public static <T> String toJSON(List<T> objects){
        Gson gson = new Gson();
        String json = gson.toJson(objects);
        return json;        
    }
    
    public static <T> String toJSON(T something){
        Gson gson = new Gson();
        return gson.toJson(something);
    }
}
