/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author brook
 */
public class EventServlet extends HttpServlet {

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
        String action = request.getParameter("action");
        if (Utils.isNullOrEmpty(action)) {
            int usertype = (Integer) request.getSession().getAttribute("usertype");
            List<EventDAO.Event> events = EventDAO.selectAllEvents();
            request.setAttribute("events", events);
            request.getRequestDispatcher("/app/events.jsp").forward(request, response);
        } else {
            if(action.equals("allevents")){
                PrintWriter out = response.getWriter();
                String json = Utils.toJSON(EventDAO.selectAllEvents());
                out.write(json);
                out.flush();
                out.close();
            }
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
        if (action.equals("addevent")) {
            UserDAO.User user = (UserDAO.User) request.getSession().getAttribute("user");
            if (user == null || !user.isValid() || !user.isAdmin()) {
                return;
            }
            int adminid = user.getId();
            String location = request.getParameter("location").trim();
            String supervisor = request.getParameter("supervisor").trim();
            Timestamp startTime = Timestamp.valueOf(request.getParameter("startTime"));
            Timestamp endTime = Timestamp.valueOf(request.getParameter("endTime"));
            int duration = (int) TimeUnit.MILLISECONDS.toMinutes(endTime.getTime() - startTime.getTime());
            EventDAO.Event event = EventDAO.createEvent(adminid, startTime, endTime, duration, location, supervisor);
            if (event != null) {
                out.write(Utils.toJSON(event));
            }
        } else if (action.equals("removeevent")) { //TODO: Implement
            response.setContentType("text/plain");
            String useridstring = request.getParameter("id");
            if (!Utils.isNullOrEmpty(useridstring)) {
                int id = Integer.parseInt(useridstring);
                UserDAO.User user = (UserDAO.User) request.getSession().getAttribute("user");
                if (user != null && user.id == id) {
                    out.write("sameuser");
                } else if (UserDAO.removeUser(id)) {
                    out.write("success");
                } else {
                    out.write("fail");
                }
            }
            out.write("fail");
        } else {
            response.setContentType("text/plain");
            out.write("fail");
        }
        out.flush();
        out.close();
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
