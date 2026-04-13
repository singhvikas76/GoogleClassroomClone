package controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/CreatePostServlet")
@MultipartConfig
public class CreatePostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int classId = Integer.parseInt(request.getParameter("classId"));

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("id");

        Connection con = null;
        PreparedStatement ps = null;

        String fileName = null;

        try {

            // 🔥 FILE PART
            Part filePart = request.getPart("file");

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null) {

                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

                String uploadPath = request.getServletContext().getRealPath("") + "uploads";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }

            // DB CONNECTION
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/classroom_db",
                "root",
                ""
            );

            // 🔥 UPDATED QUERY (added file_path)
            String sql = "INSERT INTO posts (class_id, user_id, title, content, file_path) VALUES (?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);

            ps.setInt(1, classId);
            ps.setInt(2, userId);
            ps.setString(3, title);
            ps.setString(4, content);
            ps.setString(5, fileName); // can be NULL if no file

            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("msg", "📢 Announcement posted successfully");
            } else {
                session.setAttribute("msg", "Failed to post announcement ❌");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error posting announcement ❌");
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