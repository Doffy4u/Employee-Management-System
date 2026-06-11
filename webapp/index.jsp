<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nexis EMS | Enterprise Portal</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; color: #333; display: flex; flex-direction: column; }

        /* Navbar */
        .navbar { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .logo { font-size: 24px; font-weight: 700; color: #1e3c72; text-decoration: none; letter-spacing: 0.5px; }
        .logo span { color: #00a8cc; }
        .nav-links a { text-decoration: none; color: #555; font-weight: 600; margin-left: 25px; transition: color 0.3s; }
        .nav-links a:hover { color: #1e3c72; }
        .btn-portal { background: linear-gradient(to right, #1e3c72, #2a5298); color: white !important; padding: 10px 20px; border-radius: 20px; box-shadow: 0 4px 15px rgba(30,60,114,0.2); }
        .btn-portal:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(30,60,114,0.3); }

        /* Hero Section */
        .hero { flex: 1; display: flex; align-items: center; justify-content: space-between; padding: 0 80px; max-width: 1400px; margin: 0 auto; width: 100%; gap: 50px; }
        .hero-text { flex: 1; animation: fadeInUp 0.8s ease-out; }
        .hero-text h1 { font-size: 48px; color: #1e3c72; line-height: 1.2; margin-bottom: 20px; }
        .hero-text p { font-size: 18px; color: #666; line-height: 1.6; margin-bottom: 30px; }

        /* Project Details Table Card */
        .details-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); width: 100%; max-width: 500px; animation: fadeInRight 0.8s ease-out; }
        .details-card h3 { color: #1e3c72; margin-bottom: 15px; border-bottom: 2px solid #f0f2f5; padding-bottom: 10px; }
        .details-table { width: 100%; border-collapse: collapse; }
        .details-table td { padding: 12px 0; border-bottom: 1px solid #f0f2f5; font-size: 15px; }
        .details-table td:first-child { font-weight: 600; color: #777; width: 40%; }
        .details-table td:last-child { color: #333; font-weight: 500; }

        /* Feature Grid */
        .features { display: flex; justify-content: space-between; gap: 20px; width: 100%; margin-top: 20px; }
        .feat-box { background: rgba(255, 255, 255, 0.7); border: 1px solid rgba(255,255,255,0.8); padding: 15px; border-radius: 8px; flex: 1; text-align: center; }
        .feat-box h4 { color: #1e3c72; margin-bottom: 5px; }
        .feat-box p { font-size: 13px; color: #777; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="#" class="logo">Nexis<span>EMS</span></a>
        <div class="nav-links">
            <a href="list">View Directory</a>
            <a href="login.jsp" class="btn-portal">Admin Console</a>
        </div>
    </nav>

    <main class="hero">
        <div class="hero-text">
            <h1>Automate Workspace Management & Insights</h1>
            <p>Welcome to Nexis EMS—a robust relational environment designed to securely organize employee registries, department structures, and administrative operational workflows in real-time.</p>

            <div class="features">
                <div class="feat-box">
                    <h4>Direct CRUD</h4>
                    <p>Seamlessly create, update, and manage entities records.</p>
                </div>
                <div class="feat-box">
                    <h4>Secure Auth</h4>
                    <p>Protected operations layer restricted to system administrators.</p>
                </div>
                <div class="feat-box">
                    <h4>Relational DB</h4>
                    <p>Persistent storage powered by structured MySQL server instances.</p>
                </div>
            </div>
        </div>

        <div class="details-card">
            <h3>System Specification Workspace</h3>
            <table class="details-table">
                <tr>
                    <td>Project Title</td>
                    <td>Employee Management System</td>
                </tr>
                <tr>
                    <td>Environment Architecture</td>
                    <td>Java Web MVC (Servlets, JSP, JDBC)</td>
                </tr>
                <tr>
                    <td>Database Instance</td>
                    <td>MySQL Server 8.0 / 9.0</td>
                </tr>
                <tr>
                    <td>Current System Target</td>
                    <td>Operational Employee Database Management</td>
                </tr>
                <tr>
                    <td>Deployment Runtime</td>
                    <td>Apache Tomcat Enterprise Container Server</td>
                </tr>
            </table>
        </div>
    </main>

</body>
</html>