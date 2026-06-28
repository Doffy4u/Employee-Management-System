package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Employee;

public class EmployeeDao {
    private String jdbcURL = "jdbc:mysql://localhost:3306/ems_db";
    private String jdbcUsername = "root";
    private String jdbcPassword = "1234";

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // SMART CREATE: Finds the first available empty ID gap, or appends normally
    public void insertEmployee(Employee employee , String admin) throws SQLException {
        Connection connection = getConnection();
        int targetId = -1;

        // Scan for the lowest missing ID in the sequence
        String FIND_GAP_SQL = "SELECT t1.id + 1 FROM employees t1 WHERE NOT EXISTS (SELECT t2.id FROM employees t2 WHERE t2.id = t1.id + 1) LIMIT 1;";

        // Fallback: If table is completely empty, start at 1
        String COUNT_SQL = "SELECT COUNT(*) FROM employees;";

        try (Statement stmt = connection.createStatement()) {
            ResultSet rsCount = stmt.executeQuery(COUNT_SQL);
            if (rsCount.next() && rsCount.getInt(1) == 0) {
                targetId = 1;
            } else {
                ResultSet rsGap = stmt.executeQuery(FIND_GAP_SQL);
                if (rsGap.next()) {
                    targetId = rsGap.getInt(1);
                }
            }
        }

        // Run insertion query with the smart ID assignment
        String INSERT_SQL = (targetId != -1)
                ? "INSERT INTO employees (id, name, email, department, salary) VALUES (?, ?, ?, ?, ?);"
                : "INSERT INTO employees (name, email, department, salary) VALUES (?, ?, ?, ?);";

        try (PreparedStatement ps = (targetId != -1)
                ? connection.prepareStatement(INSERT_SQL)
                : connection.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            if (targetId != -1) {
                ps.setInt(1, targetId);
                ps.setString(2, employee.getName());
                ps.setString(3, employee.getEmail());
                ps.setString(4, employee.getDepartment());
                ps.setDouble(5, employee.getSalary());
            } else {
                ps.setString(1, employee.getName());
                ps.setString(2, employee.getEmail());
                ps.setString(3, employee.getDepartment());
                ps.setDouble(4, employee.getSalary());
            }
            ps.executeUpdate();

            int insertedId = targetId;
            if (insertedId == -1) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        insertedId = generatedKeys.getInt(1);
                    }
                }
            }
            if (insertedId != -1) {
                logAction("INSERT", insertedId, admin);
            }
        } finally {
            if (connection != null) connection.close();
        }
    }

    // READ ALL
    public List<Employee> selectAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String SELECT_ALL_SQL = "SELECT * FROM employees ORDER BY id ASC;";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {
            while (rs.next()) {
                employees.add(new Employee(rs.getInt("id"), rs.getString("name"), rs.getString("email"), rs.getString("department"), rs.getDouble("salary")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return employees;
    }

    public Employee selectEmployee(int id) {
        Employee employee = null;
        String SELECT_BY_ID = "SELECT id, name, email, department, salary FROM employees WHERE id = ?;";
        try (Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                employee = new Employee(id, rs.getString("name"), rs.getString("email"), rs.getString("department"), rs.getDouble("salary"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return employee;
    }

    public boolean updateEmployee(Employee employee, String admin) throws SQLException {
        String UPDATE_SQL = "UPDATE employees SET name = ?, email = ?, department = ?, salary = ? WHERE id = ?;";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(UPDATE_SQL)) {
            statement.setString(1, employee.getName());
            statement.setString(2, employee.getEmail());
            statement.setString(3, employee.getDepartment());
            statement.setDouble(4, employee.getSalary());
            statement.setInt(5, employee.getId());
            boolean success = statement.executeUpdate() > 0;
            if (success) {
                logAction("UPDATE", employee.getId(), admin);
            }
            return success;
        }
    }

    public boolean deleteEmployee(int id, String admin) throws SQLException {
        String DELETE_SQL = "DELETE FROM employees WHERE id = ?;";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(DELETE_SQL)) {
            statement.setInt(1, id);
            boolean success = statement.executeUpdate() > 0;
            if (success) {
                logAction("DELETE", id, admin);
            }
            return success;
        }
    }

    public boolean registerAdmin(String username, String password, String email) throws SQLException {
        String INSERT_ADMIN = "INSERT INTO admins (username, password, email) VALUES (?, ?, ?);";
        try (Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(INSERT_ADMIN)) {
            ps.setString(1, username); ps.setString(2, password); ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public boolean resetAdminPassword(String username, String email, String newPassword) throws SQLException {
        String UPDATE_PASSWORD = "UPDATE admins SET password = ? WHERE username = ? AND email = ?;";
        try (Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(UPDATE_PASSWORD)) {
            ps.setString(1, newPassword); ps.setString(2, username); ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public boolean validateAdmin(String username, String password) {
        String SELECT_ADMIN = "SELECT * FROM admins WHERE username = ? AND password = ?;";
        try (Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(SELECT_ADMIN)) {
            ps.setString(1, username); ps.setString(2, password);
            return ps.executeQuery().next();
        } catch (SQLException e) { return false; }
    }

    public void logAction(String action, int empId, String admin) {
        String LOG_SQL = "INSERT INTO audit_logs (action, employee_id, admin_username) VALUES (?, ?, ?);";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(LOG_SQL)) {
            ps.setString(1, action);
            ps.setInt(2, empId);
            ps.setString(3, admin);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}