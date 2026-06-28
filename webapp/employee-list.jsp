<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Employee" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nexis EMS | Command Console</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <canvas id="salaryChart" width="400" height="200"></canvas>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #f8fafc; color: #334155; padding: 30px; }

        .header-bar { background: white; padding: 20px 30px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .header-title h2 { color: #1e3c72; font-size: 24px; }
        .btn-auth { padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.2s; }
        .login-btn { background-color: #1e3c72; color: white; }
        .logout-btn { background-color: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }

        /* Analytics Overview Cards */
        .analytics-container { display: flex; gap: 20px; margin-bottom: 25px; }
        .analytics-card { background: white; padding: 20px; border-radius: 12px; flex: 1; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border-left: 5px solid #1e3c72; }
        .analytics-card.green { border-left-color: #10b981; }
        .analytics-card.amber { border-left-color: #f59e0b; }
        .analytics-card h4 { font-size: 13px; text-transform: uppercase; color: #64748b; letter-spacing: 0.5px; }
        .analytics-card p { font-size: 24px; font-weight: 700; color: #1e293b; margin-top: 5px; }

        /* Controls Toolkit Bar Layout */
        .toolkit-bar { background: white; padding: 15px 25px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .search-input { width: 350px; padding: 10px 15px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; }
        .search-input:focus { outline: none; border-color: #1e3c72; }
        .btn-export { background-color: #0284c7; color: white; text-decoration: none; padding: 10px 15px; border-radius: 8px; font-size: 13px; font-weight: 600; }

        .container { display: flex; gap: 30px; align-items: flex-start; }
        .form-box { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); width: 340px; border-top: 4px solid #1e3c72; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #475569; font-size: 13px; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }

        button { color: white; padding: 12px; border: none; border-radius: 6px; cursor: pointer; width: 100%; font-size: 14px; font-weight: 600; }
        .btn-save { background-color: #10b981; }
        .btn-update { background-color: #eab308; color: #1e293b; }

        .table-box { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); flex-grow: 1; }
        table { border-collapse: collapse; width: 100%; text-align: left; }
        th, td { padding: 14px 16px; font-size: 14px; border-bottom: 1px solid #f1f5f9; }
        th { background-color: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; cursor: pointer; user-select: none; }
        th:hover { color: #1e3c72; background-color: #f1f5f9; }
        .actions a { text-decoration: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; margin-right: 5px; }
        .edit-lnk { background-color: #fef9c3; color: #713f12; }
        .del-lnk { background-color: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>

    <%
        String adminUser = (session != null) ? (String) session.getAttribute("adminUser") : null;
        boolean isAdmin = (adminUser != null);
        Employee empToEdit = (Employee) request.getAttribute("employee");
        boolean isEditMode = (empToEdit != null);

        // Calculate Core Runtime Metrics Profile Data Summary
        List<Employee> listEmployee = (List<Employee>) request.getAttribute("listEmployee");
        int totalStaff = (listEmployee != null) ? listEmployee.size() : 0;
        double aggregatePayroll = 0;
        for(Employee e : listEmployee) { aggregatePayroll += e.getSalary(); }
        double meanSalary = (totalStaff > 0) ? (aggregatePayroll / totalStaff) : 0;
    %>

    <header class="header-bar">
        <div class="header-title">
            <h2>Corporate Database Registry</h2>
            <p><%= isAdmin ? "Authorized Configuration Terminal" : "Public Reference View Only" %></p>
        </div>
        <div>
            <% if(isAdmin) { %>
                <a class="btn-auth logout-btn" href="logout">Sign Out</a>
            <% } else { %>
                <a class="btn-auth login-btn" href="login.jsp">Admin Console</a>
            <% } %>
        </div>
    </header>

    <section class="analytics-container">
        <div class="analytics-card">
            <h4>Total Headcount</h4>
            <p><%= totalStaff %> active profiles</p>
        </div>
        <div class="analytics-card green">
            <h4>Gross Financial Payroll</h4>
            <p>$<%= String.format("%,.2f", aggregatePayroll) %></p>
        </div>
        <div class="analytics-card amber">
            <h4>Average Resource Allocation</h4>
            <p>$<%= String.format("%,.2f", meanSalary) %></p>
        </div>
    </section>

    <div class="toolkit-bar">
        <input type="text" id="tableSearch" class="search-input" onkeyup="filterTable()" placeholder="🔍 Quick search by name, domain, or ID reference..." />
        <a href="#" class="btn-export" onclick="exportToCSV()">📊 Export Registry to CSV</a>
    </div>

    <div class="container">
        <% if(isAdmin) { %>
        <div class="form-box">
            <h3><%= isEditMode ? "Modify Employee Record" : "Register Employee Profile" %></h3>
            <form action="<%= isEditMode ? "update" : "insert" %>" method="post">
                <% if(isEditMode) { %>
                    <input type="hidden" name="id" value="<%= empToEdit.getId() %>" />
                <% } %>
                <div class="form-group">
                    <label>Employee Name</label>
                    <input type="text" name="name" value="<%= isEditMode ? empToEdit.getName() : "" %>" placeholder="Rahul Sharma" required />
                </div>
                <div class="form-group">
                    <label>Email ID</label>
                    <input type="email" name="email" value="<%= isEditMode ? empToEdit.getEmail() : "" %>" placeholder="rahul@company.com" required />
                </div>
                <div class="form-group">
                    <label>Assigned Department</label>
                    <input type="text" name="department" value="<%= isEditMode ? empToEdit.getDepartment() : "" %>" placeholder="Engineering" required />
                </div>
                <div class="form-group">
                    <label>Annual Salary ($)</label>
                    <input type="number" step="0.01" min="0" name="salary"
                               value="<%= isEditMode ? empToEdit.getSalary() : "" %>"
                               placeholder="65000" required />
                </div>
                <button type="submit" class="<%= isEditMode ? "btn-update" : "btn-save" %>">
                    <%= isEditMode ? "Apply Modifications" : "Commit Record" %>
                </button>
            </form>
        </div>
        <% } %>
        <%-- Show error message if it exists --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div style="background: #fee2e2; color: #991b1b; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fecaca;">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="table-box">
            <table id="employeeTable">
                <thead>
                    <tr>
                        <th onclick="sortTable(0)">ID Reference ⇅</th>
                        <th onclick="sortTable(1)">Full Name ⇅</th>
                        <th onclick="sortTable(2)">Email Domain ⇅</th>
                        <th onclick="sortTable(3)">Department ⇅</th>
                        <th onclick="sortTable(4)">Comp Salary ⇅</th>
                        <% if(isAdmin) { %><th style="text-align: center;">Active Controls</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if(listEmployee != null && !listEmployee.isEmpty()) {
                            for(Employee emp : listEmployee) {
                    %>
                    <tr>
                        <td><strong>#<%= emp.getId() %></strong></td>
                        <td><%= emp.getName() %></td>
                        <td><%= emp.getEmail() %></td>
                        <td><%= emp.getDepartment() %></td>
                        <td data-salary="<%= emp.getSalary() %>">$<%= String.format("%,.2f", emp.getSalary()) %></td>
                        <% if(isAdmin) { %>
                        <td class="actions" style="text-align: center;">
                            <a class="edit-lnk" href="edit?id=<%= emp.getId() %>">Edit</a>
                            <a class="del-lnk" href="delete?id=<%= emp.getId() %>" onclick="return confirm('Are you sure you want to drop this system profile?');">Delete</a>
                        </td>
                        <% } %>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="<%= isAdmin ? 6 : 5 %>" style="text-align: center; color: #94a3b8; padding: 40px 0;">No records stored inside database cluster.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // 1. LIVE SEARCH FILTER SYSTEM
        function filterTable() {
            let input = document.getElementById("tableSearch").value.toUpperCase();
            let rows = document.getElementById("employeeTable").getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            for (let i = 0; i < rows.length; i++) {
                let textContent = rows[i].textContent || rows[i].innerText;
                rows[i].style.display = textContent.toUpperCase().indexOf(input) > -1 ? "" : "none";
            }
        }

        // 2. DYNAMIC SORTING LOGIC ENGINE
        let sortDirections = [true, true, true, true, true];
        function sortTable(columnIndex) {
            let table = document.getElementById("employeeTable");
            let tbody = table.getElementsByTagName("tbody")[0];
            let rows = Array.from(tbody.getElementsByTagName("tr"));
            let ascending = sortDirections[columnIndex];

            if(rows.length <= 1 && rows[0].cells.length === 1) return; // Ignore if table is empty

            rows.sort((rowA, rowB) => {
                let cellA = rowA.cells[columnIndex].innerText.replace(/[$,#]/g, '').trim();
                let cellB = rowB.cells[columnIndex].innerText.replace(/[$,#]/g, '').trim();

                // Check if sorting numbers (ID or Salary)
                if (!isNaN(cellA) && !isNaN(cellB)) {
                    return ascending ? cellA - cellB : cellB - cellA;
                }
                // Text sorting
                return ascending ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
            });

            sortDirections[columnIndex] = !ascending;
            rows.forEach(row => tbody.appendChild(row)); // Re-append sorted rows
        }

        // 3. EXPORT REGISTRY DATA TO EXCEL / CSV SHEET
        function exportToCSV() {
            let rows = document.getElementById("employeeTable").querySelectorAll("tr");
            let csvContent = "";

            for (let i = 0; i < rows.length; i++) {
                let cols = rows[i].querySelectorAll("td, th");
                let rowData = [];
                // Skip the last column (Actions) if exporting as an admin
                let limit = <%= isAdmin %> ? cols.length - 1 : cols.length;

                for (let j = 0; j < limit; j++) {
                    rowData.push('"' + cols[j].innerText.replace(/"/g, '""') + '"');
                }
                if(rowData.length > 0) csvContent += rowData.join(",") + "\n";
            }

            let blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            let link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.setAttribute("download", "Nexis_Employee_Registry.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        const ctx = document.getElementById('
        a').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Dept A', 'Dept B', 'Dept C'], // You'll fetch these from your list
                datasets: [{ label: 'Average Salary', data: [12000, 19000, 3000] }]
            }
        });

    </script>
</body>
</html>