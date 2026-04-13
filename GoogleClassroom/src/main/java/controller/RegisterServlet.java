package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        HttpSession session = request.getSession();

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            if (con == null) {
                session.setAttribute("msg", "Database connection failed ❌");
                response.sendRedirect("index.jsp?show=register");
                return;
            }

            String query = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(query);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int i = ps.executeUpdate();

            if (i > 0) {
                session.setAttribute("msg", "Registered successfully 🎉 Please login now");
                response.sendRedirect("index.jsp?show=login");
            } else {
                session.setAttribute("msg", "Registration failed ❌");
                response.sendRedirect("index.jsp?show=register");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error: " + e.getMessage());
            response.sendRedirect("index.jsp?show=register");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}