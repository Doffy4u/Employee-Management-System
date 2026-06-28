FROM tomcat:10.1-jdk17

# Download MySQL JDBC Driver to Tomcat lib path
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/

# Copy JSP files and web configuration
COPY webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy compiled classes to the web application deployment classes path
COPY ["out/production/employee management system/", "/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/"]
