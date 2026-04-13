<%@ page import="java.sql.*" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Classroom Dashboard</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                :root {
                    --bg-color: #f4f5f7;
                    --sidebar-bg: #111;
                    --sidebar-text: #fff;
                    --sidebar-text-muted: #aaa;
                    --sidebar-hover: rgba(255, 255, 255, 0.1);
                    --main-bg: #f4f5f7;
                    --text-main: #333;
                    --text-heading: #111;
                    --text-muted: #555;
                    --text-lighter: #666;
                    --card-bg: #ffffff;
                    --card-shadow: rgba(0, 0, 0, 0.02);
                    --card-shadow-hover: rgba(0, 0, 0, 0.06);
                    --topbar-bg: #ffffff;
                    --border-color: #e2e4e8;
                    --input-bg: #fafbfc;
                    --btn-bg: #111;
                    --btn-text: #fff;
                    --btn-hover: #333;
                    --modal-overlay: rgba(255, 255, 255, 0.5);
                }

                body.dark-mode {
                    --bg-color: #121212;
                    --sidebar-bg: #1a1a1a;
                    --sidebar-text: #e0e0e0;
                    --sidebar-text-muted: #888;
                    --sidebar-hover: rgba(255, 255, 255, 0.05);
                    --main-bg: #121212;
                    --text-main: #e0e0e0;
                    --text-heading: #ffffff;
                    --text-muted: #a0a0a0;
                    --text-lighter: #888888;
                    --card-bg: #1e1e1e;
                    --card-shadow: rgba(0, 0, 0, 0.3);
                    --card-shadow-hover: rgba(0, 0, 0, 0.5);
                    --topbar-bg: #1e1e1e;
                    --border-color: #333;
                    --input-bg: #2c2c2c;
                    --btn-bg: #ffffff;
                    --btn-text: #111111;
                    --btn-hover: #e0e0e0;
                    --modal-overlay: rgba(0, 0, 0, 0.7);
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    font-family: 'Inter', sans-serif;
                }

                body {
                    display: flex;
                    background: var(--bg-color);
                    color: var(--text-main);
                    height: 100vh;
                    overflow: hidden;
                    transition: background 0.3s ease, color 0.3s ease;
                }

                /* SIDEBAR */
                .sidebar {
                    width: 260px;
                    height: 100vh;
                    background: var(--sidebar-bg);
                    color: var(--sidebar-text);
                    padding: 40px 20px;
                    display: flex;
                    flex-direction: column;
                    box-shadow: 2px 0 20px rgba(0, 0, 0, 0.05);
                    z-index: 10;
                    transition: background 0.3s ease;
                }

                .sidebar h2 {
                    font-size: 22px;
                    font-weight: 700;
                    margin-bottom: 40px;
                    color: var(--sidebar-text);
                    text-align: center;
                    letter-spacing: 0.5px;
                }

                .sidebar ul {
                    list-style: none;
                    flex: 1;
                }

                .sidebar ul li {
                    padding: 14px 20px;
                    margin: 8px 0;
                    background: transparent;
                    border-radius: 10px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    display: flex;
                    align-items: center;
                    font-weight: 500;
                    color: var(--sidebar-text-muted);
                    font-size: 15px;
                }

                .sidebar ul li:hover {
                    background: var(--sidebar-hover);
                    color: var(--sidebar-text);
                    transform: translateX(4px);
                }

                .sidebar a {
                    color: inherit;
                    text-decoration: none;
                    width: 100%;
                    display: block;
                }

                /* MAIN */
                .main {
                    flex: 1;
                    padding: 40px 50px;
                    background: var(--main-bg);
                    height: 100vh;
                    overflow-y: auto;
                    transition: background 0.3s ease;
                }

                .topbar {
                    background: var(--topbar-bg);
                    padding: 20px 30px;
                    border-radius: 16px;
                    margin-bottom: 40px;
                    box-shadow: 0 4px 20px var(--card-shadow);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 16px;
                    color: var(--text-muted);
                    transition: background 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
                }

                .topbar b {
                    color: var(--text-heading);
                    font-weight: 600;
                    margin-left: 5px;
                }

                .main>h2 {
                    font-weight: 700;
                    margin-bottom: 15px;
                    color: var(--text-heading);
                    font-size: 28px;
                    letter-spacing: -0.5px;
                }

                .main>p {
                    color: var(--text-lighter);
                    margin-bottom: 40px;
                    font-size: 16px;
                }

                /* CARDS */
                .cards {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                    gap: 30px;
                }

                .card {
                    background: var(--card-bg);
                    padding: 30px;
                    border-radius: 16px;
                    box-shadow: 0 4px 15px var(--card-shadow);
                    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                    display: flex;
                    flex-direction: column;
                    gap: 15px;
                    position: relative;
                    overflow: hidden;
                }

                .card::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 4px;
                    background: var(--btn-bg);
                    transform: scaleX(0);
                    transform-origin: left;
                    transition: transform 0.4s ease, background 0.3s ease;
                }

                .card:hover {
                    transform: translateY(-8px);
                    box-shadow: 0 15px 35px var(--card-shadow-hover);
                }

                .card:hover::before {
                    transform: scaleX(1);
                }

                .card h3 {
                    font-size: 22px;
                    color: var(--text-heading);
                    font-weight: 700;
                }

                .card p {
                    color: var(--text-muted);
                    font-size: 15px;
                    line-height: 1.5;
                }

                .card p b {
                    color: var(--text-main);
                }

                .card a {
                    text-decoration: none;
                    margin-top: auto;
                }

                /* BUTTONS */
                .btn {
                    padding: 12px 20px;
                    background: var(--btn-bg);
                    color: var(--btn-text);
                    border: none;
                    border-radius: 10px;
                    cursor: pointer;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    font-size: 14px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 100%;
                }

                .btn:hover {
                    background: var(--btn-hover);
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                }

                .btn:active {
                    transform: translateY(0);
                }

                .btn-danger {
                    background: transparent !important;
                    color: #ea4335 !important;
                    border: 1px solid #ea4335 !important;
                }

                .btn-danger:hover {
                    background: #ea4335 !important;
                    color: #fff !important;
                    box-shadow: 0 8px 20px rgba(234, 67, 53, 0.15) !important;
                }

                /* MODAL */
                .modal {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: var(--modal-overlay);
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
                    background: var(--card-bg);
                    padding: 40px;
                    border-radius: 16px;
                    width: 400px;
                    text-align: center;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
                    transform: translateY(30px) scale(0.95);
                    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                    border: 1px solid var(--border-color);
                }

                .modal.show .modal-content {
                    transform: translateY(0) scale(1);
                }

                .modal-content h3 {
                    margin-bottom: 25px;
                    color: var(--text-heading);
                    font-weight: 700;
                    font-size: 24px;
                    letter-spacing: -0.5px;
                }

                .modal-content input,
                .modal-content textarea {
                    width: 100%;
                    padding: 14px 16px;
                    margin: 10px 0;
                    border: 1px solid var(--border-color);
                    border-radius: 10px;
                    font-size: 14px;
                    transition: all 0.3s ease;
                    font-family: 'Inter', sans-serif;
                    outline: none;
                    background: var(--input-bg);
                    color: var(--text-main);
                }

                .modal-content input:focus,
                .modal-content textarea:focus {
                    border-color: var(--btn-bg);
                    background: var(--card-bg);
                }

                .modal-content textarea {
                    resize: vertical;
                    min-height: 120px;
                }

                .modal-content .btn-group {
                    display: flex;
                    gap: 15px;
                    justify-content: center;
                    margin-top: 25px;
                }

                .modal-content .btn {
                    flex: 1;
                }
            </style>
        </head>

        <body>

            <% String user=(String) session.getAttribute("user"); String role=(String) session.getAttribute("role");
                Integer idObj=(Integer) session.getAttribute("id"); if (user==null || idObj==null) {
                response.sendRedirect("index.jsp"); return; } int id=idObj; String view=request.getParameter("view"); if
                (view==null) view="home" ; %>

                <!-- SIDEBAR -->
                <div class="sidebar">
                    <h2>Classroom</h2>

                    <ul>
                        <li><a href="dashboard.jsp">🏠 Home</a></li>

                        <li><a href="dashboard.jsp?view=myclasses">📚 My Classes</a></li>

                        <% if ("TEACHER".equalsIgnoreCase(role)) { %>
                            <li onclick="openModal()">➕ Create Class</li>
                            <% } else { %>
                                <li onclick="openJoinModal()">➕ Join Class</li>
                                <% } %>
                                    <li><a href="dashboard.jsp?view=profile">👤 Profile</a></li>
                                    <li><a href="dashboard.jsp?view=settings">⚙️ Settings</a></li>

                                    <li>🚪 Logout</li>
                    </ul>
                </div>

                <!-- MAIN -->
                <div class="main">

                    <div class="topbar">
                        Welcome, <b>
                            <%= user %>
                        </b>
                    </div>

                    <!-- MESSAGE -->
                    <% String msg=(String) session.getAttribute("msg"); if (msg !=null) { %>
                        <div
                            style="background: #e8f5e9; color: #2e7d32; padding: 15px 20px; margin-bottom: 25px; border-radius: 12px; font-weight: 500; border-left: 4px solid #4caf50; box-shadow: 0 2px 10px rgba(0,0,0,0.02);">
                            <%= msg %>
                        </div>
                        <% session.removeAttribute("msg"); } %>

                            <!-- HOME -->
                            <% if ("home".equals(view)) { %>
                                <h2>Dashboard Home 🎉</h2>
                                <p>Select My Classes</p>
                                <% } %>

                                    <!-- TEACHER CLASSES -->
                                    <% if ("myclasses".equals(view) && "TEACHER" .equalsIgnoreCase(role)) { Connection
                                        con=DriverManager.getConnection( "jdbc:mysql://localhost:3307/classroom_db"
                                        , "root" , "" ); PreparedStatement
                                        ps=con.prepareStatement( "SELECT * FROM classes WHERE teacher_id=?" );
                                        ps.setInt(1, id); ResultSet rs=ps.executeQuery(); %>

                                        <h2>📚 My Classes</h2>

                                        <div class="cards">

                                            <% while (rs.next()) { %>

                                                <div class="card">
                                                    <h3>
                                                        <%= rs.getString("class_name") %>
                                                    </h3>
                                                    <p>
                                                        <%= rs.getString("subject") %>
                                                    </p>
                                                    <p><b>Code:</b>
                                                        <%= rs.getString("class_code") %>
                                                    </p>

                                                    <!-- 🔥 IMPORTANT BUTTON -->
                                                    <a href="classroom.jsp?classId=<%= rs.getInt("class_id") %>">
                                                        <button class="btn">Open Class</button>
                                                    </a>
                                                </div>

                                                <% } %>

                                        </div>

                                        <% } %>

                                            <!-- STUDENT CLASSES -->
                                            <% if ("myclasses".equals(view) && "STUDENT" .equalsIgnoreCase(role)) {
                                                Connection
                                                con=DriverManager.getConnection( "jdbc:mysql://localhost:3307/classroom_db"
                                                , "root" , "" ); PreparedStatement
                                                ps=con.prepareStatement( "SELECT c.* FROM classes c JOIN enrolled_classes e ON c.class_id=e.class_id WHERE e.student_id=?"
                                                ); ps.setInt(1, id); ResultSet rs=ps.executeQuery(); %>

                                                <h2>📚 Joined Classes</h2>

                                                <div class="cards">

                                                    <% while (rs.next()) { %>

                                                        <div class="card">
                                                            <h3>
                                                                <%= rs.getString("class_name") %>
                                                            </h3>
                                                            <p>
                                                                <%= rs.getString("subject") %>
                                                            </p>
                                                            <a href="classroom.jsp?classId=<%= rs.getInt("class_id") %>">
                                                                <button class="btn">Open Class</button>
                                                            </a>
                                                        </div>

                                                        <% } %>

                                                </div>

                                                <% } %>

                                                    <!-- SETTINGS SECTION -->
                                                    <% if ("settings".equals(view)) { %>
                                                        <h2>⚙️ Settings</h2>
                                                        <div class="card" style="max-width: 500px; margin-top: 20px;">
                                                            <h3>Appearance</h3>
                                                            <p>Choose your preferred theme for the dashboard.</p>
                                                            <div style="display: flex; gap: 15px; margin-top: 20px;">
                                                                <button class="btn"
                                                                    style="flex: 1; background: #e0e0e0; color: #111;"
                                                                    onclick="toggleTheme('light')">🌞 Light
                                                                    Mode</button>
                                                                <button class="btn"
                                                                    style="flex: 1; background: #1a1a1a; color: #fff;"
                                                                    onclick="toggleTheme('dark')">🌙 Dark Mode</button>
                                                            </div>
                                                        </div>
                                                        <% } %>

                                                            <!-- PROFILE SECTION -->
                                                            <% if ("profile".equals(view)) { Connection conP=null;
                                                                PreparedStatement psP=null; ResultSet rsP=null; try {
                                                                conP=DriverManager.getConnection("jdbc:mysql://localhost:3307/classroom_db", "root"
                                                                , "" ); psP=conP.prepareStatement("SELECT * FROM users WHERE id=?");
                                                                psP.setInt(1, id); rsP=psP.executeQuery();
                                                                if (rsP.next()) { %>
                                                                <h2>👤 My Profile</h2>
                                                                <div class="card"
                                                                    style="max-width: 500px; margin-top: 20px;">
                                                                    <h3>Profile Details</h3>
                                                                    <div
                                                                        style="margin-top: 15px; display: flex; flex-direction: column; gap: 10px;">
                                                                        <p><b>Name:</b>
                                                                            <%= rsP.getString("name") %>
                                                                        </p>
                                                                        <p><b>Email:</b>
                                                                            <%= rsP.getString("email") %>
                                                                        </p>
                                                                        <p><b>Role:</b> <span
                                                                                style="background: var(--btn-bg); color: var(--btn-text); padding: 5px 10px; border-radius: 5px; font-size: 13px; font-weight: bold;">
                                                                                <%= rsP.getString("role") %>
                                                                            </span></p>
                                                                        <p><b>User ID:</b> #<%= rsP.getInt("id") %>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <% } } catch(Exception e) { out.println("<p>Error loading profile.</p>");
                                                                    } finally {
                                                                    if(rsP!=null) try{rsP.close();}catch(Exception e){}
                                                                    if(psP!=null) try{psP.close();}catch(Exception e){}
                                                                    if(conP!=null) try{conP.close();}catch(Exception
                                                                    e){}
                                                                    }
                                                                    }
                                                                    %>

                </div>

                <!-- CREATE CLASS MODAL -->
                <div class="modal" id="classModal">
                    <div class="modal-content">

                        <h3>Create Class</h3>

                        <form action="CreateClassServlet" method="post">
                            <input name="className" placeholder="Class Name" required>
                            <input name="subject" placeholder="Subject" required>
                            <textarea name="description" placeholder="Description"></textarea>

                            <div class="btn-group">
                                <button class="btn" type="submit">Create</button>
                                <button type="button" class="btn btn-danger" onclick="closeModal()">Close</button>
                            </div>
                        </form>

                    </div>
                </div>

                <!-- JOIN CLASS MODAL -->
                <div class="modal" id="joinModal">
                    <div class="modal-content">

                        <h3>Join Class</h3>

                        <form action="${pageContext.request.contextPath}/JoinClassServlet" method="post">
                            <input name="classCode" placeholder="Enter Class Code" required>

                            <div class="btn-group">
                                <button class="btn" type="submit">Join</button>
                                <button type="button" class="btn btn-danger" onclick="closeJoinModal()">Close</button>
                            </div>
                        </form>

                    </div>
                </div>

                <script>
                    // Theme Initialization
                    const savedTheme = localStorage.getItem('theme');
                    if (savedTheme === 'dark') {
                        document.body.classList.add('dark-mode');
                    } else {
                        document.body.classList.remove('dark-mode');
                    }

                    function toggleTheme(theme) {
                        if (theme === 'dark') {
                            document.body.classList.add('dark-mode');
                            localStorage.setItem('theme', 'dark');
                        } else {
                            document.body.classList.remove('dark-mode');
                            localStorage.setItem('theme', 'light');
                        }
                    }

                    function openModal() {
                        document.getElementById("classModal").classList.add("show");
                    }

                    function closeModal() {
                        document.getElementById("classModal").classList.remove("show");
                    }

                    function openJoinModal() {
                        document.getElementById("joinModal").classList.add("show");
                    }

                    function closeJoinModal() {
                        document.getElementById("joinModal").classList.remove("show");
                    }
                </script>

        </body>

        </html>
