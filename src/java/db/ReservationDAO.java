package db;

/*
 * Reservations Database Manager
 */

/**
 *
 * @author brook
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {    
    private static final String CREATERESERVATION = "Insert into Reservations(userid, eventid, timereserved, startTime, slotnum)"
            + " values(?, ?, ?, ?, ?)";
    private static final String UPDATERESERVATION = "Update Reservations set slotnum=?, starttime=? where userid=? and eventid=?";
    private static final String REMOVERESERVATION = "Delete from Reservations where userid=? and eventid=?";
    private static final String GETALL = "Select * from Reservations R, Users U where R.userid = U.id";
    private static final String GETALLEVENTRESERVATIONS = "Select * from Reservations R, Users U where R.userid = U.id and R.eventid=?";
    private static final String GETUSERRESERVATION = "Select * from Reservations where userid=? and eventid=?";
    private static final String GETALLUSERRESERVATION = "Select * from Reservations, Events E "
            + "where userid=? and R.eventid=E.id";

    public static Reservation createReservation(int userid, int eventid, Timestamp timereserved, Timestamp startTime, int slotnum) {
        try {
            if(getUserReservation(userid, eventid) != null){//just update the field
                Connection con = DB.getConnection();
                PreparedStatement ps = con.prepareStatement(UPDATERESERVATION, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, slotnum);
                ps.setTimestamp(2, startTime);
                ps.setInt(3, userid);
                ps.setInt(4, eventid);
                int result = ps.executeUpdate();
                if(result > 0){
                    return new Reservation(1, userid, eventid, timereserved, startTime, slotnum); //id can be bogus, not used
                }
            } else {
                Connection con = DB.getConnection();
                PreparedStatement ps = con.prepareStatement(CREATERESERVATION, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, userid);
                ps.setInt(2, eventid);
                ps.setTimestamp(3, timereserved);
                ps.setTimestamp(4, startTime);
                ps.setInt(5, slotnum);
                int result = ps.executeUpdate();
                ResultSet res = ps.getGeneratedKeys();
                if (res.next()) {
                    return new Reservation(res.getInt(1), userid, eventid, timereserved, startTime, slotnum);
                }
            }

        } catch (Exception ex) {
        }
        return null;
    }

    public static boolean removeReservation(int userid, int eventid) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(REMOVERESERVATION);
            ps.setInt(1, userid);
            ps.setInt(2, eventid);
            int result = ps.executeUpdate();
            if (result > 0) {
                return true;
            }

        } catch (Exception ex) {
        }
        return false;
    }

    public static List<Reservation> getAllReservations() {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETALL);
            ResultSet result = ps.executeQuery();
            List<Reservation> reserves = new ArrayList<Reservation>();
            while (result.next()) {
                Reservation res = extractReservation(result);
                res.user = extractUser(result);
                reserves.add(res);
            }
            return reserves;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public static List<Reservation> getAllEventReservations(int eventid) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETALLEVENTRESERVATIONS);
            ps.setInt(1, eventid);
            ResultSet result = ps.executeQuery();
            List<Reservation> reserves = new ArrayList<Reservation>();
            while (result.next()) {
                Reservation res = extractReservation(result);
                res.user = extractUser(result);
                reserves.add(res);
            }
            return reserves;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public static List<Reservation> getAllUserEventReservations(int userid) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETALLUSERRESERVATION);
            ps.setInt(1, userid);
            ResultSet result = ps.executeQuery();
            List<Reservation> reserves = new ArrayList<Reservation>();
            while (result.next()) {
                Reservation res = extractReservation(result);
                res.user = extractUser(result);
                reserves.add(res);
            }
            return reserves;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Reservation getUserReservation(int userid, int eventid) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETUSERRESERVATION);
            ps.setInt(1, userid);
            ps.setInt(2, eventid);
            ResultSet result = ps.executeQuery();
            if (result.first()) {
                Reservation res = extractReservation(result);
                return res;
            }
        } catch (Exception e) {
        }
        return null;
    }

    public static Reservation extractReservation(ResultSet result) throws Exception{
        int id = result.getInt("id");
        int userid = result.getInt("userid");        
        int eventid = result.getInt("eventid");
        Timestamp timereserved = result.getTimestamp("timereserved");
        Timestamp startTime = result.getTimestamp("startTime");
        int slotnum = result.getInt("slotnum");
        Reservation res = new Reservation(id, userid, eventid, timereserved, startTime, slotnum);
        return res;
    }

    //different from UserDAO because we joined, so different column name of id
    private static UserDAO.User extractUser(ResultSet set) throws Exception{
        int userid = set.getInt("userid");
        String fullname = set.getString("fullname");
        String username = set.getString("username");
        String password = set.getString("password");
        int usertype = set.getInt("usertype");
        return  new UserDAO.User(userid, username, password, fullname, usertype);
    }
    public static class Reservation {      

        public int id;
        public int userid;
        public int eventid;
        public Timestamp timereserved;
        public Timestamp startTime;
        public String stime;//easy string representation
        public int slotnum;
        public UserDAO.User user;

        public String getStime() {
            return stime;
        }
        
        public int getId() {
            return id;
        }

        public int getUserid() {
            return userid;
        }


        public int getEventid() {
            return eventid;
        }

        public Timestamp getTimereserved() {
            return timereserved;
        }

        public UserDAO.User getUser() {
            return user;
        }

        public Timestamp getStartTime() {
            return startTime;
        }

        public int getSlotnum() {
            return slotnum;
        }
        
        public Reservation(int id, int userid, int eventid, Timestamp timereserved, Timestamp startTime, int slotnum, UserDAO.User user){
            this(id, userid, eventid, timereserved, startTime, slotnum);
            this.user = user;
        }
        public Reservation(int id, int userid, int eventid, Timestamp timereserved, Timestamp startTime, int slotnum ) {
            this.id = id;
            this.userid = userid;
            this.eventid = eventid;
            this.timereserved = timereserved;
            this.startTime = startTime;
            this.slotnum = slotnum;
        }        
    }
}
