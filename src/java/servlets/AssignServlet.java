package servlets;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import db.EventAssignmentsDAO;
import db.EventDAO;
import db.UserDAO;
import utils.Utils;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author brook
 */
public class AssignServlet extends HttpServlet {

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
        UserDAO.User user = (UserDAO.User) request.getSession().getAttribute("user");
        int usertype = (Integer) request.getSession().getAttribute("usertype");
        List<EventDAO.Event> events = null;
        if (usertype != UserDAO.ADMIN) {
            response.sendRedirect("../index.jsp");
            return;
        }
        events = EventDAO.selectAllEvents();
        request.setAttribute("events", events);
        try {
            request.getRequestDispatcher("/app/assign.jsp").forward(request, response);
        } catch (Exception e) {
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
        if (action.equals("assignuser")) {
            //admin is assigning a user
            int eventid = Integer.parseInt(request.getParameter("eventid"));
            int userid = Integer.parseInt(request.getParameter("userid"));
            int adminid = ((UserDAO.User) request.getSession().getAttribute("user")).id;
            java.util.Date date = new java.util.Date();
            Timestamp timereserved = new Timestamp(date.getTime());
            EventAssignmentsDAO.EventAssignment assignment = EventAssignmentsDAO.assignUser(eventid, userid, adminid, timereserved);
            if (assignment != null) {
                out.write("success");
            } else {
                out.write("fail");
            }
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
