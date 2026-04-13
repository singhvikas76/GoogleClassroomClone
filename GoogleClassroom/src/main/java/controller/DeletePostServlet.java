package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeletePostServlet")
public class DeletePostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int postId = Integer.parseInt(request.getParameter("postId"));
        int classId = Integer.parseInt(request.getParameter("classId"));

        HttpSession session = request.getSession(); // 🔥 yaha le aao

        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/classroom_db",
                "root",
                ""
            );

            String sql = "DELETE FROM posts WHERE post_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, postId);

            int result = ps.executeUpdate(); // ✅ sirf ek baar

            if (result > 0) {
                session.setAttribute("msg", "🗑️ Post deleted successfully");
            } else {
                session.setAttribute("msg", "Failed to delete post ❌");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error deleting post ❌");
        }

        // ✅ sirf ek redirect
        response.sendRedirect("classroom.jsp?classId=" + classId);
    }
}