/*
 * Event Database Manager
 */

/**
 *
 * @author brook
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {
    private static final String CREATEEVENT = "Insert into Events(startTime, endTime, duration, numslots, location, supervisor, title) "
            + "values(?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECTALLEVENTS = "Select * from Events order by startTime";
    private static final String SELECTUSEREVENTS = "Select * from Events E, EventAssignments A "
            + "where E.id = A.eventid and A.userid = ?";
    private static final String GETEVENT = "Select * from Events where id=?";
    
    public static Event createEvent(Timestamp s, Timestamp e, int duration, int numslots, String location, String supervisor, String title){ 
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(CREATEEVENT, Statement.RETURN_GENERATED_KEYS);
            ps.setTimestamp(1, s);
            ps.setTimestamp(2, e);
            ps.setInt(3, duration);
            ps.setInt(4, numslots);
            ps.setString(5, location);
            ps.setString(6, supervisor);
            ps.setString(7, title);
            int result = ps.executeUpdate();
            ResultSet res = ps.getGeneratedKeys();
            if(res.next()){
                return new Event(res.getInt(1), s, e, duration, numslots, location, supervisor, title);
            }            
        } catch(Exception ex){ }
        return null;
    }
    
    public static Event selectEvent(int eventid){
        try{
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETEVENT);
            ps.setInt(1, eventid);
            ResultSet result = ps.executeQuery();
            if(result.first()){
                return extractEvent(result);
            }          
        } catch(Exception ex){ 
            ex.printStackTrace();
        }
        return null;
    }
    
    public static List<Event> selectAllEvents(){
        try{
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(SELECTALLEVENTS);
            ResultSet result = ps.executeQuery();
            List<Event> events = new ArrayList<Event>();
            while(result.next()){
                events.add(extractEvent(result));
            }
            return events;            
        } catch(Exception ex){ 
            ex.printStackTrace();
        }
        return null;
    }
    
    public static List<Event> selectUserEvents(int userid){
        try{
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(SELECTUSEREVENTS);
            ps.setInt(1, userid);
            ResultSet result = ps.executeQuery();
            List<Event> events = new ArrayList<Event>();
            while(result.next()){
                events.add(extractEvent(result));
            }
            return events;            
        } catch(Exception ex){ 
            ex.printStackTrace();
        }
        return null;
    }
    
    private static Event extractEvent(ResultSet result) throws Exception{
        int id = result.getInt("id");
        Timestamp startTime = result.getTimestamp("startTime");
        Timestamp endTime = result.getTimestamp("endTime");
        int duration = result.getInt("duration");
        int numslots = result.getInt("numslots");
        String location = result.getString("location");
        String supervisor = result.getString("supervisor");
        String title= result.getString("title");
        Event event = new Event(id, startTime, endTime, duration, numslots, location, supervisor, title);
        return event;        
    }
    
    public static class Event {
        public int id;
        public Timestamp startTime;
        public Timestamp endTime;
        public int duration;
        public int numslots;
        public String location;
        public String supervisor;
        public String title;
        public String date;//this is to represent only the date
        
        public Event(int id, Timestamp startTime, Timestamp endTime, int duration, int numslots, String location, String supervisor, String title) {
            this.id = id;
            this.startTime = startTime;
            this.endTime = endTime;
            this.duration = duration;
            this.numslots = numslots;
            this.location = location;
            this.supervisor = supervisor;      
            this.title = title;
        }                

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public int getId() {
            return id;
        }

        public Timestamp getStartTime() {
            return startTime;
        }

        public Timestamp getEndTime() {
            return endTime;
        }

        public int getDuration() {
            return duration;
        }

        public String getLocation() {
            return location;
        }

        public String getSupervisor() {
            return supervisor;
        }

        public int getNumslots() {
            return numslots;
        }

        public String getTitle() {
            return title;
        }

        
    }
    
}
