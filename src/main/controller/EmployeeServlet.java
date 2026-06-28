package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.EmployeeDao;
import model.Employee;

@WebServlet("/")
public class EmployeeServlet extends HttpServlet {
    private EmployeeDao employeeDao;

    public void init() {
        employeeDao = new EmployeeDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/login":
                    handleLogin(request, response);
                    break;
                case "/logout":
                    handleLogout(request, response);
                    break;
                case "/register":
                    handleRegister(request, response);
                    break;
                case "/resetPassword":
                    handleResetPassword(request, response);
                    break;
                case "/insert":
                    if (checkAuth(request, response)) insertEmployee(request, response);
                    break;
                case "/delete":
                    if (checkAuth(request, response)) deleteEmployee(request, response);
                    break;
                case "/edit":
                    if (checkAuth(request, response)) showEditForm(request, response);
                    break;
                case "/update":
                    if (checkAuth(request, response)) updateEmployee(request, response);
                    break;
                default:
                    listEmployees(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    // Helper method to protect admin actions
    private boolean checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (employeeDao.registerAdmin(username, password, email)) {
            request.setAttribute("successMessage", "Account created successfully! Please sign in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed! Username or email might already exist.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");

        if (employeeDao.resetAdminPassword(username, email, newPassword)) {
            request.setAttribute("successMessage", "Password updated successfully!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Verification mismatch! Credentials do not match our database records.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (employeeDao.validateAdmin(username, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", username);
            response.sendRedirect("list");
        } else {
            request.setAttribute("errorMessage", "Invalid Username or Password!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destroy session
        }
        response.sendRedirect("login.jsp");
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Employee> listEmployee = employeeDao.selectAllEmployees();
        request.setAttribute("listEmployee", listEmployee);
        RequestDispatcher dispatcher = request.getRequestDispatcher("employee-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employee existingEmployee = employeeDao.selectEmployee(id);
        request.setAttribute("employee", existingEmployee);

        List<Employee> listEmployee = employeeDao.selectAllEmployees();
        request.setAttribute("listEmployee", listEmployee);
        RequestDispatcher dispatcher = request.getRequestDispatcher("employee-list.jsp");
        dispatcher.forward(request, response);
    }

    private void insertEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String department = request.getParameter("department");

        // Parse salary safely
        double salary;
        try {
            salary = Double.parseDouble(request.getParameter("salary"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Error: Invalid salary format.");
            listEmployees(request, response);
            return;
        }

        // 1. Negative Salary Validation
        if (salary < 0) {
            request.setAttribute("errorMessage", "Error: Salary cannot be negative.");
            listEmployees(request, response);
            return;
        }

        // 2. Database Insertion with Error Handling
        String admin = (String) request.getSession().getAttribute("adminUser");
        Employee newEmployee = new Employee(name, email, department, salary);

        try {
            employeeDao.insertEmployee(newEmployee, admin);
            response.sendRedirect("list");
        } catch (SQLException e) {
            // Handle Duplicate Entry (Integrity Constraint)
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("errorMessage", "Error: An employee with the email " + email + " already exists!");
                listEmployees(request, response);
            } else {
                // Rethrow other unexpected database errors
                throw e;
            }
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        double salary = Double.parseDouble(request.getParameter("salary"));

        Employee updatedEmployee = new Employee(id, name, email, department, salary);
        employeeDao.updateEmployee(updatedEmployee);
        response.sendRedirect("list");
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        employeeDao.deleteEmployee(id);
        response.sendRedirect("list");
    }

    private boolean canDelete(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
}