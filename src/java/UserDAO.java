/*
 * User database manager
 */

/**
 *
 * @author brook
 */

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class UserDAO {
    public static final int ADMIN = 0;
    public static final int VIEWER = 1;
    public static final int USER = 2;
    
    private static final String CHECKUSER = "Select * from Users where username=? and password=?";
    private static final String CREATEUSER = "Insert into Users (username, password, fullname, usertype) values (?, ?, ?, ?)";
    private static final String FINDUSER = "Select * from Users where username like ? or fullname like ?";
    private static final String GETALLUSERS = "Select * from Users";
    private static final String DELETEUSER = "Delete from Users where id=?"; //TODO: implement
    
    public static User existsUser(String username, String password){
        if(Utils.isNullOrEmpty(username) || Utils.isNullOrEmpty(password)){
            return null;
        }
        try {
            Connection con = DB.getConnection();
            PreparedStatement s = con.prepareStatement(CHECKUSER);
            s.setString(1, username);
            s.setString(2, password);
            ResultSet result = s.executeQuery();
            if(result.first()){
                int id = result.getInt("id");
                String fullname = result.getString("fullname");
                int usertype = result.getInt("usertype");
                User user = new User(id, username, password, fullname, usertype);
                return user;
            }
        } catch(Exception e){ }
        return null;
    }
    
    /**
     * Returns true if a user was successfully created.
     */
    public static User createUser(String username, String password, String fullname, int usertype){
        if(username == null || password == null || usertype < ADMIN || usertype > USER){
            return null;
        }        
        try {
            Connection con = DB.getConnection();
            PreparedStatement s = con.prepareStatement(CREATEUSER, Statement.RETURN_GENERATED_KEYS);
            s.setString(1, username);
            s.setString(2, password);
            s.setString(3, fullname);
            s.setInt(4, usertype);
            int result = s.executeUpdate();
            ResultSet res = s.getGeneratedKeys();
            if(res.next()){
                return new User(res.getInt(1), username, password, fullname, usertype);
            }            
        } catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
    
    public static List<User> FindUsers(String query){
        if(Utils.isNullOrEmpty(query))
            return  null;
        try {
            Connection con = DB.getConnection();
            PreparedStatement s = con.prepareStatement(FINDUSER);
            s.setString(1, "%" + query + "%");
            s.setString(2, "%" + query + "%");
            ResultSet res = s.executeQuery();
            List<User> users = new ArrayList<User>(); 
            while(res.next()){
                users.add(extractUser(res));
            }        
            return users;
        } catch(Exception e){ }
        return null;
    }
    public static List<User> selectAllusers(){
        try {
            Connection con = DB.getConnection();
            PreparedStatement s = con.prepareStatement(GETALLUSERS);
            ResultSet res = s.executeQuery();
            List<User> users = new ArrayList<User>(); 
            while(res.next()){
                users.add(extractUser(res));
            }        
            return users;
        } catch(Exception e){ }
        return null;
    }
    
    public static boolean removeUser(int userid){
        try {
            Connection con = DB.getConnection();
            PreparedStatement s = con.prepareStatement(DELETEUSER);
            s.setInt(1, userid);
            int res = s.executeUpdate();
            if(res == 1)
                return true;
        } catch(Exception e){ }
        return false;
    }
    
    public static User extractUser(ResultSet result) throws Exception{
        int id = result.getInt("id");
        String username = result.getString("username");
        String password = result.getString("password");
        String fullname = result.getString("fullname");
        int usertype = result.getInt("usertype");
        return new User(id, username, password, fullname, usertype);
    }
    
    public static class User{
        public int id;
        public String username;
        public String password;
        public String fullname;
        public int usertype; 
        public User(int id, String username, String password, String fullname, int usertype){
            this.id = id;
            this.username = username;
            this.password  = password;
            this.fullname = fullname;
            this.usertype = usertype;
        }
        public boolean isValid(){
            return this.id != 0 && !Utils.isNullOrEmpty(username) && !Utils.isNullOrEmpty(password);
        }

        public int getId() {
            return id;
        }

        public String getUsername() {
            return username;
        }

        public String getPassword() {
            return password;
        }

        public String getFullname() {
            return fullname;
        }

        public int getUsertype() {
            return usertype;
        }
        
        
    }
}
