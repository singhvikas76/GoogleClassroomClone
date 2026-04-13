<%@ page import="java.sql.*" %>
<%! 
public String timeAgo(java.sql.Timestamp timestamp) {
    long diff = System.currentTimeMillis() - timestamp.getTime();
    long seconds = diff / 1000;
    long minutes = seconds / 60;
    long hours = minutes / 60;
    long days = hours / 24;

    if (seconds < 60) {
        return "just now";
    } else if (minutes < 60) {
        return minutes + " min ago";
    } else if (hours < 24) {
        return hours + " hr ago";
    } else {
        return days + " days ago";
    }
}
%>
<%
String user = (String) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

String role = (String) session.getAttribute("role");
int loggedInUserId = (int) session.getAttribute("id");

String classIdStr = request.getParameter("classId");
int classId = Integer.parseInt(classIdStr);

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3307/classroom_db",
    "root",
    ""
);

// CLASS DETAILS
PreparedStatement ps = con.prepareStatement(
    "SELECT c.*, u.name FROM classes c JOIN users u ON c.teacher_id = u.id WHERE c.class_id=?"
);
ps.setInt(1, classId);

ResultSet rs = ps.executeQuery();

String className = "";
String subject = "";
String teacher = "";
String code = "";

if (rs.next()) {
    className = rs.getString("class_name");
    subject = rs.getString("subject");
    teacher = rs.getString("name");
    code = rs.getString("class_code");
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Classroom</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background: #f4f5f7;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* HEADER */
        .header {
            background: #111;
            color: white;
            padding: 40px 50px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
            margin-bottom: 40px;
        }

        .header h2 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .header p {
            font-size: 16px;
            opacity: 0.8;
            margin-bottom: 5px;
        }

        /* SECTION / ANNOUNCEMENTS */
        .section {
            margin-top: 20px;
        }

        .section h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 25px;
            color: #111;
            letter-spacing: -0.5px;
        }

        /* POST FORM */
        .post-form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
            margin-bottom: 40px;
            border: 1px solid #eaeaea;
        }

        /* POSTS */
        .post {
            background: #ffffff;
            padding: 30px;
            margin-bottom: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
            border: 1px solid #eaeaea;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .post:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
        }

        .post h4 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 12px;
            color: #111;
        }

        .post p {
            font-size: 15px;
            line-height: 1.6;
            color: #555;
            margin-bottom: 20px;
        }

        .post small {
            color: #888;
            font-size: 13px;
        }

        hr {
            border: 0;
            border-top: 1px solid #f0f0f0;
            margin: 20px 0;
        }

        /* INPUTS & FORMS */
        input, textarea {
            width: 100%;
            padding: 14px 16px;
            margin-top: 10px;
            border: 1px solid #e2e4e8;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            outline: none;
            background: #fafbfc;
            box-sizing: border-box;
        }

        input:focus, textarea:focus {
            border-color: #111;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(0, 0, 0, 0.05);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* BUTTONS */
        .btn {
            padding: 12px 24px;
            margin-top: 15px;
            background: #111;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn:hover {
            background: #333;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-danger {
            background: #fff !important;
            color: #ea4335 !important;
            border: 1px solid #ea4335 !important;
        }

        .btn-danger:hover {
            background: #ea4335 !important;
            color: #fff !important;
            box-shadow: 0 8px 20px rgba(234, 67, 53, 0.15) !important;
        }

        .btn-warning {
            background: #fff !important;
            color: #f2a500 !important;
            border: 1px solid #f2a500 !important;
        }

        .btn-warning:hover {
            background: #f2a500 !important;
            color: #fff !important;
            box-shadow: 0 8px 20px rgba(251, 188, 4, 0.15) !important;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 15px;
        }

        /* COMMENTS */
        .comment-container {
            margin-left: 20px;
            padding: 20px;
            background: #fafbfc;
            border-radius: 12px;
            margin-bottom: 15px;
            border: 1px solid #eaeaea;
        }

        .comment-container b {
            color: #111;
        }

        .comment-container small {
            color: #888;
        }
        
        .comment-text {
            margin-top: 8px;
            color: #444;
            line-height: 1.6;
        }

        /* MESSAGES */
        .msg-box {
            background: #fff;
            color: #2e7d32;
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-weight: 500;
            border-left: 4px solid #4caf50;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            transition: all 0.4s ease;
        }

        /* MODALS */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            justify-content: center;
            align-items: center;
            z-index: 9999;
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .modal.show {
            display: flex;
            opacity: 1;
        }

        .modal-content {
            background: #ffffff;
            padding: 40px;
            border-radius: 16px;
            width: 450px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
            transform: translateY(30px) scale(0.95);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #eee;
        }

        .modal.show .modal-content {
            transform: translateY(0) scale(1);
        }

        .modal-content h3 {
            margin-bottom: 25px;
            color: #111;
            font-weight: 700;
            font-size: 24px;
        }

        .modal-content .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 25px;
        }

        .modal-content .btn {
            flex: 1;
            margin-top: 0;
        }

        /* BACK BUTTON */
        .back-link {
            display: inline-flex;
            align-items: center;
            margin-bottom: 25px;
            color: #555;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .back-link:hover {
            color: #111;
            transform: translateX(-4px);
        }
        .back-link::before {
            content: "<--";
            margin-right: 8px;
            font-size: 18px;
        }
    </style>
</head>
<body>

<div class="container">

    <a href="dashboard.jsp" class="back-link">Back to Dashboard</a>

    <!-- HEADER -->
    <div class="header">
        <h2><%= className %></h2>
        <p><%= subject %></p>
        <p>Teacher: <%= teacher %></p>
        <p><b>Class Code:</b> <%= code %></p>
    </div>

    <!-- ANNOUNCEMENTS -->
    <div class="section">
    
<%
String msg = (String) session.getAttribute("msg");
if (msg != null) {
%>
<div class="msg-box">
    <%= msg %>
</div>
<%
    session.removeAttribute("msg");
}
%>
    
        

        <!-- TEACHER POST FORM -->
        <!-- TEACHER POST FORM WITH FILE UPLOAD -->
<% if ("TEACHER".equalsIgnoreCase(role)) { %>

<div class="post-form-container">

    <h3 style="margin-bottom:10px;">Create Announcement</h3>

    <form action="CreatePostServlet" method="post" enctype="multipart/form-data">

        <input type="hidden" name="classId" value="<%= classId %>">

        <input type="text" name="title" placeholder="Announcement Title" required>

        <textarea name="content" placeholder="Write announcement details here..." required></textarea>

        <!-- 🔥 FILE UPLOAD (OPTIONAL) -->
        <input type="file" name="file">
        <small style="color:gray;">Optional: Attach file (PDF, Image, Docs)</small>
        <br>

        <button class="btn" type="submit">Post Announcement</button>

    </form>

</div>

<% } %>
		<h3>Announcements</h3>

<%
PreparedStatement psPost = con.prepareStatement(
    "SELECT p.*, u.name FROM posts p JOIN users u ON p.user_id = u.id WHERE class_id=? ORDER BY created_at DESC"
);

psPost.setInt(1, classId);

ResultSet postRs = psPost.executeQuery();
boolean hasPost = false;

while (postRs.next()) {
    hasPost = true;
%>

        <div class="post">
            <h4><%= postRs.getString("title") %></h4>
            <p><%= postRs.getString("content") %></p>
            <%
String file = postRs.getString("file_path");
if (file != null) {
%>

<div style="margin-top:10px;">
    Attachment: 
    <a href="uploads/<%= file %>" target="_blank">
        Download File
    </a>
</div>

<%
}
%>
            <small>
            	By <%= postRs.getString("name") %>
            	<br>
            	<%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(postRs.getTimestamp("created_at")) %>
            </small>
            
            <% if (loggedInUserId == postRs.getInt("user_id")) { %>
                <div class="btn-group">
                    <!-- DELETE -->
                    <a href="DeletePostServlet?postId=<%= postRs.getInt("post_id") %>&classId=<%= classId %>">
                        <button class="btn btn-danger">Delete</button>
                    </a>

                    <!-- EDIT -->
                    <button class="btn btn-warning" onclick="openEditModal(
                        '<%= postRs.getInt("post_id") %>',
                        '<%= postRs.getString("title").replace("'", "\\'") %>',
                        '<%= postRs.getString("content").replace("'", "\\'") %>'
                    )">Edit</button>
                </div>
            <% } %>
            
            <hr>
            
            <form action="AddCommentServlet" method="post" style="display:flex; gap:10px; align-items:center;">
                <input type="hidden" name="postId" value="<%= postRs.getInt("post_id") %>">
                <input type="hidden" name="classId" value="<%= classId %>">
                <input type="text" name="comment" placeholder="Write a comment..." required style="margin-top:0;">
                <button class="btn" style="margin-top:0; white-space:nowrap;">Comment</button>
            </form>

            <hr>

<%
PreparedStatement psCmt = con.prepareStatement(
    "SELECT c.*, u.name FROM comments c JOIN users u ON c.user_id=u.id WHERE post_id=? ORDER BY created_at ASC"
);

psCmt.setInt(1, postRs.getInt("post_id"));
ResultSet rsCmt = psCmt.executeQuery();

while (rsCmt.next()) {
%>

<div>Comments</div>
<br>
<div class="comment-container">
    <div>
        <b><%= rsCmt.getString("name") %></b>
        <small> |  <%= timeAgo(rsCmt.getTimestamp("created_at")) %></small>
    </div>
    
    <div class="comment-text">
        <%= rsCmt.getString("comment_text") %>
    </div>

    <% if (loggedInUserId == rsCmt.getInt("user_id") || "TEACHER".equalsIgnoreCase(role)) { %>
        <!-- DELETE BUTTON -->
        <a href="DeleteCommentServlet?commentId=<%= rsCmt.getInt("comment_id") %>&classId=<%= classId %>">
            <button class="btn btn-danger" style="padding: 6px 10px; font-size: 12px; margin-top: 10px;">Delete</button>
        </a>
    <% } %>
</div>

<% } %>
        </div>

        <% } %>

        <% if (!hasPost) { %>
            <div style="background: white; padding: 30px; text-align: center; border-radius: 16px; color: #888;">
                <p>No announcements yet...</p>
            </div>
        <% } %>

    </div>
</div>

<!-- EDIT POST MODAL -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <h3>Edit Post</h3>

        <form action="UpdatePostServlet" method="post">
            <input type="hidden" name="postId" id="editPostId">
            <input type="hidden" name="classId" value="<%= classId %>">

            <input type="text" name="title" id="editTitle" required>
            <textarea name="content" id="editContent" required></textarea>

            <div class="btn-group">
                <button class="btn" type="submit">Update</button>
                <button type="button" class="btn btn-danger" onclick="closeEditModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditModal(id, title, content) {
    document.getElementById("editModal").classList.add("show");
    document.getElementById("editPostId").value = id;
    document.getElementById("editTitle").value = title;
    document.getElementById("editContent").value = content;
}

function closeEditModal() {
    document.getElementById("editModal").classList.remove("show");
}

setTimeout(() => {
    const msg = document.querySelector(".msg-box");
    if (msg) {
        msg.style.opacity = "0";
        setTimeout(() => msg.remove(), 300);
    }
}, 3000);
</script>
</body>
</html>