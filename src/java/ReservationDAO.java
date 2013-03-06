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

    private static final String CREATERESERVATION = "Insert into Reservations(userid, adminid, eventid, timereserved"
            + " values(?, ?, ?, ?)";
    private static final String REMOVERESERVATION = "Delete from Reservations where userid=?";
    private static final String GETALL = "Select * from Reservations";
    private static final String GETUSERRESERVATION = "Select * from Reservations where user userid=?";

    public static Reservation createReservation(int userid, int adminid, int eventid, Timestamp timereserved) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(CREATERESERVATION, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userid);
            ps.setInt(2, adminid);
            ps.setInt(3, eventid);
            ps.setTimestamp(4, timereserved);
            int result = ps.executeUpdate();
            ResultSet res = ps.getGeneratedKeys();
            if (res.next()) {
                return new Reservation(res.getInt(1), userid, adminid, eventid, timereserved);
            }

        } catch (Exception ex) {
        }
        return null;
    }

    public static boolean removeReservation(int userid) {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(REMOVERESERVATION);
            ps.setInt(1, userid);
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
                reserves.add(extractReservation(result));
            }
            return reserves;
        } catch (Exception e) {
        }
        return null;
    }

    public static Reservation getReservation() {
        try {
            Connection con = DB.getConnection();
            PreparedStatement ps = con.prepareStatement(GETUSERRESERVATION);
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
        int adminid = result.getInt("adminid");
        int eventid = result.getInt("eventid");
        Timestamp timereserved = result.getTimestamp("timereserved");
        Reservation res = new Reservation(id, userid, adminid, eventid, timereserved);
        return res;
    }

    public static class Reservation {

        public int id;
        public int userid;
        public int adminid;
        public int eventid;
        public Timestamp timereserved;

        public int getId() {
            return id;
        }

        public int getUserid() {
            return userid;
        }

        public int getAdminid() {
            return adminid;
        }

        public int getEventid() {
            return eventid;
        }

        public Timestamp getTimereserved() {
            return timereserved;
        }

        public Reservation(int id, int userid, int adminid, int eventid, Timestamp timereserved) {
            this.id = id;
            this.userid = userid;
            this.adminid = adminid;
            this.eventid = eventid;
            this.timereserved = timereserved;
        }
        
        public boolean isAdminAssigned(){
            return this.adminid != 0;
        }
        
        public boolean valid(){
            return this.userid != 0 && this.id != 0;
        }
    }
}
