# Stage 1: Build the Java classes from source
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Download Servlet API jar needed for compilation (Jakarta Servlet 6.0)
ADD https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar /app/lib/

# Copy the Java source files
COPY src/ /app/src/

# Compile the Java classes
RUN mkdir -p /app/classes
RUN javac -cp "/app/lib/*" -d /app/classes /app/src/main/model/Employee.java /app/src/main/dao/EmployeeDao.java /app/src/main/controller/EmployeeServlet.java

# Stage 2: Deploy to Tomcat 10.1 Web Server
FROM tomcat:10.1-jdk17

# Download MySQL JDBC Driver to Tomcat lib path
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/

# Copy JSP files and web configuration (WEB-INF)
COPY webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy compiled classes from the builder stage
COPY --from=builder /app/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# Expose HTTP port
EXPOSE 8080
