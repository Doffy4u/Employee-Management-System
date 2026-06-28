<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nexis EMS | Authentication</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .login-container { background: rgba(255, 255, 255, 0.95); padding: 40px; border-radius: 16px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); width: 100%; max-width: 400px; text-align: center; }
        h3 { color: #1e3c72; font-size: 26px; margin-bottom: 8px; }
        .subtitle { color: #777; font-size: 14px; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #444; font-size: 14px; }
        .form-group input { width: 100%; padding: 12px; border: 2px solid #e1e5eb; border-radius: 8px; font-size: 15px; transition: border-color 0.3s; }
        .form-group input:focus { outline: none; border-color: #1e3c72; }
        button { background: linear-gradient(to right, #1e3c72, #2a5298); color: white; padding: 12px; border: none; border-radius: 8px; cursor: pointer; width: 100%; font-size: 16px; font-weight: 600; margin-top: 10px; box-shadow: 0 5px 15px rgba(30,60,114,0.3); transition: transform 0.2s, box-shadow 0.2s; }
        button:hover { transform: translateY(-1px); box-shadow: 0 8px 20px rgba(30,60,114,0.4); }
        .error-msg { background: #fde8e8; color: #e53e3e; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 20px; border: 1px solid #f8b4b4; }
        .back-home { display: inline-block; margin-top: 20px; color: #2a5298; text-decoration: none; font-size: 14px; font-weight: 500; }
        .back-home:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="login-container">
        <h3>Welcome Back</h3>
        <p class="subtitle">Sign in to unlock admin modifications panel</p>

        <% String error = (String) request.getAttribute("errorMessage");
           if(error != null) { %>
            <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="login" method="post">

            <% String success = (String) request.getAttribute("successMessage");
               if(success != null) { %>
                <div style="background: #e6fffa; color: #047481; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 20px; border: 1px solid #b2f5ea;"><%= success %></div>
            <% } %>

            <div style="margin-top: 25px; display: flex; justify-content: space-between; font-size: 13px;">
                <a href="signup.jsp" style="color: #2a5298; text-decoration: none; font-weight: 500;">Create Console Account</a>
                <a href="forgot-password.jsp" style="color: #64748b; text-decoration: none;">Forgot Password?</a>
            </div>
            <div class="form-group">
                <label>Admin Username</label>
                <input type="text" name="username" placeholder="Enter username" required />
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required />
            </div>

            <button type="submit">Authenticate</button>
        </form>
        <a href="index.jsp" class="back-home">← Return to Home</a>

    </div>

</body>
</html>