/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
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
        request.getRequestDispatcher("/app/reserve.jsp").forward(request, response); 
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
        if(Utils.isNullOrEmpty(action))
            return;
        PrintWriter out = response.getWriter();
        if(action.equals("getall")){
            List<ReservationDAO.Reservation> reservations = ReservationDAO.getAllReservations();
            String json = Utils.toJSON(reservations);
            out.write(json);
        } else if (action.equals("assignuser")){
            //admin is assigning a user
            int userid = Integer.parseInt(request.getParameter("userid"));
            int adminid = ((UserDAO.User)request.getSession().getAttribute("user")).id;
            int eventid = Integer.parseInt(request.getParameter("eventid"));
            java.util.Date date = new java.util.Date();
            Timestamp timereserved = new Timestamp(date.getTime());
            ReservationDAO.Reservation res = ReservationDAO.createReservation(userid, adminid, eventid, timereserved);
            if(res != null){                
                out.write("sucess");
            } else {
                out.write("fail");
            }
        } else if(action.equals("makereservation")){
            //user made it himself, so no adminid 
            HttpSession session = request.getSession();
            UserDAO.User currentuser = (UserDAO.User)session.getAttribute("user");
            int userid = currentuser.id;
            int eventid = Integer.parseInt(request.getParameter("eventid"));
            java.util.Date date = new java.util.Date();
            Timestamp timereserved = new Timestamp(date.getTime());
            ReservationDAO.Reservation res = ReservationDAO.createReservation(userid, null, eventid, timereserved);
            if(res != null){                
                out.write("success");
            } else {
                out.write("fail");
            }
        }
        out.flush();
        out.close();
    }

    private void makeReservation(int userid, int adminid, int eventid, Timestamp time, PrintWriter out){
        
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
