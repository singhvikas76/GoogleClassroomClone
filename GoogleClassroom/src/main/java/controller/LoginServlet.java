package controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
            	    "jdbc:mysql://localhost:3307/classroom_db",
            	    "root",
            	    ""
            	);

            String sql = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	
            	
            	System.out.println("LOGIN SUCCESS");

                // LOGIN SUCCESS
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                
                session.setAttribute("id", rs.getInt("id"));
                
                // role bhi store kar lo (IMPORTANT for classroom clone)
                session.setAttribute("role", rs.getString("role"));

                response.sendRedirect("dashboard.jsp");
            } else {
                // LOGIN FAILED
                response.sendRedirect("login.jsp?error=1");
            }

        } catch (Exception e) {
//            e.printStackTrace();
        	
        	response.setContentType("text/html");
            e.printStackTrace(response.getWriter());
        }
    }
}