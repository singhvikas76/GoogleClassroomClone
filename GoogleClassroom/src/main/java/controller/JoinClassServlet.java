package controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/JoinClassServlet")
public class JoinClassServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String classCode = request.getParameter("classCode");

        HttpSession session = request.getSession();

        Object idObj = session.getAttribute("id");
        if (idObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (int) idObj;

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/classroom_db",
                    "root",
                    ""
            );

            // 🔥 find class
            String findClass = "SELECT class_id FROM classes WHERE class_code = ?";
            PreparedStatement ps1 = con.prepareStatement(findClass);
            ps1.setString(1, classCode);

            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {

                int classId = rs.getInt("class_id");

                // 🔥 CHECK IF ALREADY JOINED
                String checkSql = "SELECT * FROM enrolled_classes WHERE class_id=? AND student_id=?";
                PreparedStatement psCheck = con.prepareStatement(checkSql);
                psCheck.setInt(1, classId);
                psCheck.setInt(2, studentId);

                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    session.setAttribute("msg", "You already joined this class ⚠️");
                } else {

                    // 🔥 insert only if not joined
                    String joinSql = "INSERT INTO enrolled_classes (class_id, student_id) VALUES (?, ?)";
                    PreparedStatement ps2 = con.prepareStatement(joinSql);
                    ps2.setInt(1, classId);
                    ps2.setInt(2, studentId);

                    ps2.executeUpdate();

                    session.setAttribute("msg", "Class joined successfully 🎉");
                }

            } else {
                session.setAttribute("msg", "Invalid Class Code ❌");
            }

            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error occurred ❌");
            response.sendRedirect("dashboard.jsp");
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}