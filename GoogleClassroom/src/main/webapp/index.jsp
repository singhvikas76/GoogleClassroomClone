<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Classroom</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
body {
    margin: 0;
    font-family: 'Inter', sans-serif;
    background: #f4f5f7;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #333;
}

.container {
    width: 420px;
    background: #ffffff;
    border-radius: 16px;
    padding: 40px 35px;
    box-shadow: 0 12px 40px rgba(0,0,0,0.06);
    position: relative;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

h2 {
    text-align: center;
    color: #111;
    font-weight: 700;
    font-size: 26px;
    margin-bottom: 25px;
    letter-spacing: -0.5px;
}

h3 {
    color: #444;
    font-weight: 600;
    margin-bottom: 20px;
    font-size: 20px;
}

input, select {
    width: 100%;
    padding: 14px 16px;
    margin: 10px 0;
    border: 1px solid #e2e4e8;
    border-radius: 10px;
    background: #fafbfc;
    font-family: 'Inter', sans-serif;
    font-size: 15px;
    color: #333;
    transition: all 0.3s ease;
    box-sizing: border-box;
    outline: none;
}

input:focus, select:focus {
    border-color: #1a73e8;
    background: #ffffff;
    box-shadow: 0 0 0 4px rgba(26, 115, 232, 0.1);
}

button {
    width: 100%;
    padding: 14px;
    background: #111;
    color: #fff;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    margin-top: 15px;
    font-size: 15px;
    font-weight: 600;
    transition: all 0.3s ease;
    display: flex;
    justify-content: center;
    align-items: center;
}

button:hover {
    background: #333;
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}

button:active {
    transform: translateY(0);
}

.toggle {
    text-align: center;
    margin-top: 20px;
    color: #666;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    transition: color 0.3s ease;
}

.toggle:hover {
    color: #1a73e8;
}

.form {
    opacity: 0;
    transform: translateY(10px);
    pointer-events: none;
    position: absolute;
    width: calc(100% - 70px);
    visibility: hidden;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.form.active {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
    position: relative;
    visibility: visible;
    width: 100%;
}
</style>

</head>

<body>

<div class="container">

    <h2>Classroom</h2>
    
    <%
String msg = (String) session.getAttribute("msg");
if (msg != null) {
%>
    <div style="background:#d4edda; color:#155724; padding:10px; border-radius:6px; margin-bottom:10px;">
        <%= msg %>
    </div>
<%
    session.removeAttribute("msg");
}
%>

    <!-- LOGIN FORM -->
    <div id="loginForm" class="form active">

        <h3>Login</h3>

        <form action="LoginServlet" method="post">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit">Login</button>
        </form>

        <div class="toggle" onclick="showRegister()">
            Don't have an account? Register
        </div>
    </div>

    <!-- REGISTER FORM -->
    <div id="registerForm" class="form">

        <h3>Register</h3>

        <form action="RegisterServlet" method="post">

            <input type="text" name="name" placeholder="Name" required>

            <input type="email" name="email" placeholder="Email" required>

            <input type="password" name="password" placeholder="Password" required>

            <select name="role">
                <option value="teacher">Teacher</option>
                <option value="student">Student</option>
            </select>

            <button type="submit">Register</button>
        </form>

        <div class="toggle" onclick="showLogin()">
            Already have an account? Login
        </div>
    </div>

</div>

<script>
function showRegister() {
    const login = document.getElementById("loginForm");
    const register = document.getElementById("registerForm");
    
    login.classList.remove("active");
    setTimeout(() => register.classList.add("active"), 200);
}

function showLogin() {
    const login = document.getElementById("loginForm");
    const register = document.getElementById("registerForm");

    register.classList.remove("active");
    setTimeout(() => login.classList.add("active"), 200);
}

window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const show = urlParams.get("show");

    if (show === "login") {
        showLogin();
    }
};
</script>

</body>
</html>
