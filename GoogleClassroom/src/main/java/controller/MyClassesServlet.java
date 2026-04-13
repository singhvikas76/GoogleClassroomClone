package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/MyClassesServlet")
public class MyClassesServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object idObj = session.getAttribute("id");

        if (idObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int teacherId = (int) idObj;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/classroom_db",
                    "root",
                    ""
            );

            String sql = "SELECT * FROM classes WHERE teacher_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, teacherId);

            ResultSet rs = ps.executeQuery();

            request.setAttribute("classes", rs);

            RequestDispatcher rd = request.getRequestDispatcher("myclasses.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}