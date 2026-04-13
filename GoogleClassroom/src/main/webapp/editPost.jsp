<%@ page import="java.sql.*" %>

<%
int postId = Integer.parseInt(request.getParameter("postId"));
int classId = Integer.parseInt(request.getParameter("classId"));

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/classroom_db",
    "root",
    ""
);

PreparedStatement ps = con.prepareStatement("SELECT * FROM posts WHERE post_id=?");
ps.setInt(1, postId);

ResultSet rs = ps.executeQuery();

String title = "";
String content = "";

if (rs.next()) {
    title = rs.getString("title");
    content = rs.getString("content");
}
%>

<h2>Edit Post</h2>

<form action="UpdatePostServlet" method="post">
    <input type="hidden" name="postId" value="<%= postId %>">
    <input type="hidden" name="classId" value="<%= classId %>">

    <input type="text" name="title" value="<%= title %>" required><br><br>
    <textarea name="content" required><%= content %></textarea><br><br>

    <button type="submit">Update</button>
</form>