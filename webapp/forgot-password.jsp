<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Nexis EMS | Account Recovery</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .form-container { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); width: 100%; max-width: 400px; text-align: center; }
        h3 { color: #1e3c72; font-size: 24px; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #444; }
        .form-group input { width: 100%; padding: 12px; border: 2px solid #e1e5eb; border-radius: 8px; font-size: 15px; }
        button { background: linear-gradient(to right, #eab308, #ca8a04); color: #1e293b; padding: 12px; border: none; border-radius: 8px; cursor: pointer; width: 100%; font-size: 16px; font-weight: 600; }
        .error-msg { background: #fde8e8; color: #e53e3e; padding: 10px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; }
        .switch-link { display: inline-block; margin-top: 20px; color: #2a5298; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h3>Recover Identity</h3>
        <% String error = (String) request.getAttribute("errorMessage"); if(error != null) { %>
            <div class="error-msg"><%= error %></div>
        <% } %>
        <form action="resetPassword" method="post">
            <div class="form-group"><label>Confirm Username</label><input type="text" name="username" required /></div>
            <div class="form-group"><label>Registered Recovery Email</label><input type="email" name="email" required /></div>
            <div class="form-group"><label>New Choice Password</label><input type="password" name="password" required /></div>
            <button type="submit">Override & Update Password</button>
        </form>
        <a href="login.jsp" class="switch-link">Remember details? Sign In</a>
    </div>
</body>
</html>