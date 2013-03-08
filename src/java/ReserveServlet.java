/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author brook
 */
public class ReserveServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventid = request.getParameter("eventid");
        if (!Utils.isNullOrEmpty(eventid)) {
            int id = Integer.parseInt(eventid);
            EventDAO.Event event = EventDAO.selectEvent(id);
            List<ReservationDAO.Reservation> reservations = ReservationDAO.getAllEventReservations(id);
            Map<Integer, ReservationDAO.Reservation> reservedslots = new HashMap<Integer, ReservationDAO.Reservation>();
            
            for(ReservationDAO.Reservation r : reservations){
                reservedslots.put(r.slotnum, r);
            }
            
            long eventStart = event.startTime.getTime();
            long duration = TimeUnit.MINUTES.toMillis(event.duration);
            SimpleDateFormat formatter = new SimpleDateFormat("h:mm a");
            //to be used to display time of event
            String startDate = new SimpleDateFormat("EEE, MMM d, yyyy").format(event.startTime);
            event.setDate(startDate);
            
            List<SlotData> slots = new ArrayList<SlotData>();
            for(int i = 0; i < event.numslots; i++){                
                long starttime = eventStart + i*duration;
                long endtime = starttime + duration;
                
                Timestamp slotstart = new Timestamp(starttime);
                Timestamp slotend = new Timestamp(endtime);
                String formatstart = formatter.format(slotstart);
                String formatend = formatter.format(slotend);
                SlotData data = new SlotData(i, formatstart, formatend);
                ReservationDAO.Reservation reserve = reservedslots.get(i);
                if(reserve != null){
                    UserDAO.User user = reserve.user;
                    data.user = user;
                }
                slots.add(data);
            }           
            request.getSession().setAttribute("event", event);
            request.getSession().setAttribute("slots", slots);
            request.getRequestDispatcher("/app/reserve.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (Utils.isNullOrEmpty(action)) {
            return;
        }
        PrintWriter out = response.getWriter();
        if (action.equals("getall")) {
            List<ReservationDAO.Reservation> reservations = ReservationDAO.getAllReservations();
            String json = Utils.toJSON(reservations);
            out.write(json);
        } else if (action.equals("makereservation")) {
            //user made it himself, so no adminid 
            HttpSession session = request.getSession();
            UserDAO.User currentuser = (UserDAO.User) session.getAttribute("user");
            int userid = currentuser.id;
            int eventid = Integer.parseInt(request.getParameter("eventid"));
            java.util.Date date = new java.util.Date();
            Timestamp timereserved = new Timestamp(date.getTime());
            ReservationDAO.Reservation res = null;//ReservationDAO.createReservation(userid, null, eventid, timereserved);
            if (res != null) {
                out.write("success");
            } else {
                out.write("fail");
            }
        }
        out.flush();
        out.close();
    }

    public static class SlotData{
        public int id;
        public String start; 
        public String end;
        public UserDAO.User user;

        public int getId() {
            return id;
        }

        public String getStart() {
            return start;
        }

        public String getEnd() {
            return end;
        }

        public UserDAO.User getUser() {
            return user;
        }
        public SlotData (int id, String start, String end){
            this.id = id;
            this.start = start;
            this.end = end;
        }
        
    }
    private void makeReservation(int userid, int adminid, int eventid, Timestamp time, PrintWriter out) {
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
