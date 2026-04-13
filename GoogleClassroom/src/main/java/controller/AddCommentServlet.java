package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddCommentServlet")
public class AddCommentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        int postId = Integer.parseInt(request.getParameter("postId"));
        String comment = request.getParameter("comment");

        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");

        if (userIdObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = userIdObj;

        String classId = request.getParameter("classId");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/classroom_db",
                    "root",
                    ""
            );

            String sql = "INSERT INTO comments (post_id, user_id, comment_text) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);

            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, comment);

            int result = ps.executeUpdate();   // ✅ ONLY ONCE

            if (result > 0) {
                session.setAttribute("msg", "Comment added successfully 💬");
            } else {
                session.setAttribute("msg", "Failed to add comment ❌");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error occurred while adding comment ❌");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("classroom.jsp?classId=" + classId);
    }
}