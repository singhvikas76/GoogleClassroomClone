package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        String classId = request.getParameter("classId");

        HttpSession session = request.getSession();

        // 🔥 USER CHECK
        Object idObj = session.getAttribute("id");
        String role = (String) session.getAttribute("role");

        if (idObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) idObj;

        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/classroom_db",
                "root",
                ""
            );

            String sql;

            // 🔥 ROLE BASED DELETE
            if ("TEACHER".equalsIgnoreCase(role)) {
                // teacher kisi ka bhi delete kar sakta hai
                sql = "DELETE FROM comments WHERE comment_id=?";
            } else {
                // student sirf apna delete kare
                sql = "DELETE FROM comments WHERE comment_id=? AND user_id=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, commentId);

            if (!"TEACHER".equalsIgnoreCase(role)) {
                ps.setInt(2, userId);
            }

            int result = ps.executeUpdate();

            // 🔥 MESSAGE HANDLE
            if (result > 0) {
                session.setAttribute("msg", "Comment deleted successfully 🗑️");
            } else {
                session.setAttribute("msg", "Not allowed or comment not found ❌");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error deleting comment ❌");
        }

        response.sendRedirect("classroom.jsp?classId=" + classId);
    }
}