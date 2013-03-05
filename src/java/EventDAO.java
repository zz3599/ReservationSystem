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
    private static final String CREATEEVENT = "Insert into Events(adminid, startTime, endTime, duration, location, supervisor)"
            + "values(?, ?, ?, ?, ?, ?)";
    private static final String SELECTALLEVENTS = "Select * from Events";
    
    public static Event createEvent(int adminid, Timestamp s, Timestamp e, int duration, String location, String supervisor){ 
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(CREATEEVENT, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, adminid);
            ps.setTimestamp(2, s);
            ps.setTimestamp(3, e);
            ps.setInt(4, duration);
            ps.setString(5, location);
            ps.setString(6, supervisor);
            int result = ps.executeUpdate();
            ResultSet res = ps.getGeneratedKeys();
            if(res.next()){
                return new Event(res.getInt(1), adminid, s, e, duration, location, supervisor);
            }            
        } catch(Exception ex){ }
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
        } catch(Exception ex){ }
        return null;
    }
    
    public static Event extractEvent(ResultSet result) throws Exception{
        int id = result.getInt("id");
        int userid = result.getInt("adminid");
        Timestamp startTime = result.getTimestamp("starTime");
        Timestamp endTime = result.getTimestamp("endTime");
        int duration = result.getInt("duration");
        String location = result.getString("location");
        String supervisor = result.getString("supervisor");
        Event res = new Event(id, userid, startTime, endTime, duration, location, supervisor);
        return res;
        
    }
    public static class Event {
        public int id;
        public int adminid;
        public Timestamp startTime;
        public Timestamp endTime;
        public int duration;
        public String location;
        public String supervisor;
        
        public Event(int id, int adminid, Timestamp startTime, Timestamp endTime, int duration, String location, String supervisor) {
            this.id = id;
            this.adminid = adminid;
            this.startTime = startTime;
            this.endTime = endTime;
            this.duration = duration;
            this.location = location;
            this.supervisor = supervisor;
        }
        
        public int getAdminID(){
            return this.adminid;
        }
        
        public boolean isValid(){
            return this.id != 0 && this.adminid != 0 && !Utils.isNullOrEmpty(location) && !Utils.isNullOrEmpty(supervisor);
        }

        public int getId() {
            return id;
        }

        public int getAdminid() {
            return adminid;
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
        
        
    }
    
}
