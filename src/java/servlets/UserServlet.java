package servlets;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import db.UserDAO;
import utils.Utils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author brook
 */
public class UserServlet extends HttpServlet {
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
        int usertype = (Integer) request.getSession().getAttribute("usertype");
        if (usertype != UserDAO.ADMIN) {
            request.getRequestDispatcher("/app/home.jsp").forward(request, response);
        } else {
            List<UserDAO.User> users = UserDAO.selectAllusers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/app/users.jsp").forward(request, response);
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
        String action = request.getParameter("action").trim().toLowerCase();
        if (Utils.isNullOrEmpty(action)) {
            return;
        }
        PrintWriter out = response.getWriter();
        if (action.equals("adduser")) {
            response.setContentType("text/plain");
            String username = request.getParameter("username").trim();
            String password = request.getParameter("password").trim();
            String fullname = request.getParameter("fullname").trim();
            int usertype = Integer.parseInt(request.getParameter("usertype"));
            UserDAO.User user = null;
            if ((user=UserDAO.createUser(username, password, fullname, usertype)) != null) {
                out.write(Utils.toJSON(user));
            } else {
                out.write("fail");
            }
        } else if (action.equals("removeuser")) {
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
        } else if (action.equals("finduser")) {
            response.setContentType("application/json");
            String query = request.getParameter("query");
            if (!Utils.isNullOrEmpty(query)) {
                List<UserDAO.User> matchingusers = UserDAO.FindUsers(query);
                out.write(Utils.toJSON(matchingusers));
            }
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
