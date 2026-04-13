package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdatePostServlet")
public class UpdatePostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int postId = Integer.parseInt(request.getParameter("postId"));
        int classId = Integer.parseInt(request.getParameter("classId"));

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        HttpSession session = request.getSession(); // 🔥 yaha le aao

        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/classroom_db",
                "root",
                ""
            );

            String sql = "UPDATE posts SET title=?, content=? WHERE post_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, postId);

            int result = ps.executeUpdate(); // ✅ sirf ek baar

            if (result > 0) {
                session.setAttribute("msg", "✏️ Post updated successfully");
            } else {
                session.setAttribute("msg", "Failed to update post ❌");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error updating post ❌");
        }

        // ✅ sirf ek hi redirect
        response.sendRedirect("classroom.jsp?classId=" + classId);
    }
}