/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author brook
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventAssignmentsDAO {
    public static final String ASSIGNUSER = "Insert into EventAssignments (eventid, userid, adminid, timestamp, done) "
            + "values (?, ?, ?, ?, 0)";
    public static final String GETALLASSIGN = "Select * from EventAssignments";
    
    public static EventAssignment assignUser(int eventid, int userid, int adminid, Timestamp timestamp){
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(ASSIGNUSER, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, eventid);
            ps.setInt(2, userid);
            ps.setInt(3, adminid);
            ps.setTimestamp(4, timestamp);
            int result = ps.executeUpdate();
            ResultSet res = ps.getGeneratedKeys(); //to retrieve the id
            if(res.next()){
                return new EventAssignment(res.getInt(1), eventid, userid, adminid, timestamp, 0);
            }            
        } catch(Exception ex){ }
        return null;
    }   
    
    public static List<EventAssignment> getAllAssignments(){
        try{
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETALLASSIGN);
            ResultSet res = ps.executeQuery();
            List<EventAssignment> results = new ArrayList<EventAssignment>();
            while(res.next()){
                EventAssignment assign = extractAssignment(res);
                results.add(assign);
            }
            return results;
        }catch(Exception e){}
        return null;
    }
    
    public static EventAssignment extractAssignment(ResultSet res) throws Exception {
        int id = res.getInt("id");
        int eventid = res.getInt("eventid");
        int userid = res.getInt("userid");
        int adminid = res.getInt("adminid");
        Timestamp timestamp = res.getTimestamp("timestamp");
        int done = res.getInt("done");
        return new EventAssignment(id, eventid, userid, adminid, timestamp, done);
    }
    
    public static class EventAssignment {
        public int id;
        public int eventid; 
        public int userid;
        public int adminid;
        public Timestamp timestamp;
        public int done;

        public EventAssignment(int id, int eventid, int userid, int adminid, Timestamp timestamp, int done) {
            this.id = id;
            this.eventid = eventid;
            this.userid = userid;
            this.adminid = adminid;
            this.timestamp = timestamp;
            this.done = done;
        }

        public int getId() {
            return id;
        }

        public int getEventid() {
            return eventid;
        }

        public int getUserid() {
            return userid;
        }

        public int getAdminid() {
            return adminid;
        }

        public Timestamp getTimestamp() {
            return timestamp;
        }

        public int getDone() {
            return done;
        }
    }
}
