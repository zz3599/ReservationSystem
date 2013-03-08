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
        HttpSession session = request.getSession();
        if (!Utils.isNullOrEmpty(eventid)) {
            int id = Integer.parseInt(eventid);
            EventDAO.Event event = EventDAO.selectEvent(id);
            List<ReservationDAO.Reservation> reservations = ReservationDAO.getAllEventReservations(id);
            Map<Integer, ReservationDAO.Reservation> reservedslots = new HashMap<Integer, ReservationDAO.Reservation>();

            for (ReservationDAO.Reservation r : reservations) {
                reservedslots.put(r.slotnum, r);
            }

            long eventStart = event.startTime.getTime();
            long duration = TimeUnit.MINUTES.toMillis(event.duration);
            SimpleDateFormat formatter = new SimpleDateFormat("h:mm a");
            //to be used to display time of event
            String startDate = new SimpleDateFormat("EEE, MMM d, yyyy").format(event.startTime);
            event.setDate(startDate);

            List<SlotData> slots = new ArrayList<SlotData>();
            for (int i = 0; i < event.numslots; i++) {
                long starttime = eventStart + i * duration;
                long endtime = starttime + duration;

                Timestamp slotstart = new Timestamp(starttime);
                Timestamp slotend = new Timestamp(endtime);
                String formatstart = formatter.format(slotstart);
                String formatend = formatter.format(slotend);
                SlotData data = new SlotData(i, formatstart, formatend);
                ReservationDAO.Reservation reserve = reservedslots.get(i);
                if (reserve != null) {
                    UserDAO.User user = reserve.user;
                    data.user = user;
                }
                slots.add(data);
            }
            UserDAO.User user = (UserDAO.User) session.getAttribute("user");
            int userid = user.id;
            int usertype = user.usertype;
            if (usertype == UserDAO.USER) {
                ReservationDAO.Reservation yourslot = ReservationDAO.getUserReservation(userid, id);
                //long userstarttime = eventStart + yourslot.slotnum* duration;
                //String r = formatter.format(new Timestamp(userstarttime));
                if (yourslot != null) {
                    SlotData data = slots.get(yourslot.slotnum);
                    //Timestamp starttime = yourslot.startTime;
                    //String r = formatter.format(starttime);
                    session.setAttribute("yourslot", data);//the user reserved time representation
                }
            }
            session.setAttribute("event", event);
            session.setAttribute("slots", slots);

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
        } else if (action.equals("reserve")) {
            //somebody clicked to make a reservation - only process if user            
            HttpSession session = request.getSession();
            UserDAO.User currentuser = (UserDAO.User) session.getAttribute("user");
            if (currentuser.usertype != UserDAO.USER) {
                out.write("denied");
            } else {
                int userid = currentuser.id;
                int eventid = ((EventDAO.Event) session.getAttribute("event")).id;
                java.util.Date date = new java.util.Date();
                Timestamp timereserved = new Timestamp(date.getTime());
                int slotnum = Integer.parseInt(request.getParameter("slotnum"));
                //calculate the time of the slot
                EventDAO.Event event = (EventDAO.Event) session.getAttribute("event");
                Timestamp eventstart = event.startTime;
                long starttime = eventstart.getTime() + TimeUnit.MINUTES.toMillis(event.duration * slotnum);
                Timestamp s_time = new Timestamp(starttime);

                ReservationDAO.Reservation res = ReservationDAO.createReservation(userid, eventid, timereserved, s_time, slotnum);
                //format the time for easy display
                SimpleDateFormat formatter = new SimpleDateFormat("h:mm a");
                res.stime = formatter.format(s_time);
                if (res != null) {
                    //out.write("success");
                    out.write(Utils.toJSON(res));
                } else {
                    out.write("fail");
                }
            }
        }
        out.flush();
        out.close();
    }
    

    public static class SlotData {

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

        public SlotData(int id, String start, String end) {
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
