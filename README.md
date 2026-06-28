# Nexis Employee Management System (EMS)

A Java Web MVC application (Servlets, JSP, JDBC, MySQL) designed to organize employee registries, department structures, and administrative operational workflows in real-time.

---

## 🚀 Running the Project

You can run this project on your machine in two ways: using **Docker Compose** (recommended and easiest) or via **Manual IDE Setup**.

### Method 1: Docker Compose (Recommended)

This method packages the application and database together. You only need Docker installed.

1. **Prerequisites:** Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. **Launch:** Open your terminal in the project root folder and run:
   ```bash
   docker-compose up --build
   ```
3. **Access the App:**
   * Open your browser and go to: [http://localhost:8080](http://localhost:8080)
   * The MySQL database is configured automatically with the table schema.

---

### Method 2: Manual IDE & Tomcat Setup

If you prefer to compile and run the project using your local IntelliJ IDEA / Tomcat instance:

#### 1. Setup MySQL Database
1. Make sure MySQL Server is running locally on port `3306`.
2. Connect to MySQL (e.g. using Command Line or Workbench) and run the SQL commands from the [schema.sql](schema.sql) file to create the database and tables:
   ```bash
   mysql -u root -p < schema.sql
   ```
   *(Note: The application connects using the username `root` and password `1234`. If yours is different, update the values in `EmployeeDao.java`)*.

#### 2. Run in IntelliJ IDEA
1. Open the project folder in IntelliJ IDEA.
2. Install the **Smart Tomcat** plugin (File -> Settings -> Plugins).
3. Create a Run Configuration:
   * Select **Smart Tomcat**.
   * Set **Tomcat Server** to your local Tomcat 10.x installation path.
   * Set **Deployment Directory** to `webapp`.
   * Set **Context Path** to `/` (ROOT).
4. Run the project.
5. Open [http://localhost:8080](http://localhost:8080) in your browser.

---

## 📊 Features & Core Systems
* **Dynamic Analytics:** Displays total headcount, gross payroll, and average department salaries. Computes real-time analytics using Chart.js.
* **Smart ID Creation:** Insertion automatically scans for missing IDs (sequence gaps) to optimize primary keys.
* **Audit Logging:** Logs all administrative actions (`INSERT`, `UPDATE`, `DELETE`) with the admin user's identity to the database.
* **Secure Auth:** Admin login/signup panels protect registry modification controls.
