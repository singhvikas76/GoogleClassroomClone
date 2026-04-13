package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/CreateClassServlet")
public class CreateClassServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // 🔥 CLASS CODE GENERATOR
    public String generateCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();

        for (int i = 0; i < 5; i++) {
            int index = (int) (Math.random() * chars.length());
            code.append(chars.charAt(index));
        }

        return code.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String className = request.getParameter("className");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        HttpSession session = request.getSession();

        // 🔥 SAFE CHECK
        Object idObj = session.getAttribute("id");
        if (idObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int teacherId = (int) idObj;

        // 🔥 GENERATE CLASS CODE
        String classCode = generateCode();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/classroom_db",
                    "root",
                    ""
            );

            String sql = "INSERT INTO classes (class_name, subject, description, teacher_id, class_code) VALUES (?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, className);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.setInt(4, teacherId);
            ps.setString(5, classCode);

            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("msg",
                        "Class created successfully 🎉 Code: " + classCode);
            } else {
                session.setAttribute("msg",
                        "Failed to create class ❌");
            }

            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error occurred ❌");
            response.sendRedirect("dashboard.jsp");
        }
    }
}