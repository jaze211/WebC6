# ---- Stage 1: Build with Ant ----
FROM openjdk:8-jdk AS build

WORKDIR /app

# Cài Ant + wget
RUN apt-get update && apt-get install -y ant wget && rm -rf /var/lib/apt/lists/*

# Copy toàn bộ source code
COPY . /app

# Tạo thư mục libs và tải servlet-api 4.0.1
RUN mkdir -p /app/libs && \
    wget -O /app/libs/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

# Build từng project
WORKDIR /app/ch06email
RUN ant clean dist

WORKDIR /app/ch06_ex1_email_sol
RUN ant clean dist

WORKDIR /app/ch06_ex2_survey_sol
RUN ant clean dist

# ---- Stage 2: Run with Tomcat 9 ----
FROM tomcat:9-jdk11-openjdk

# Copy WAR sang Tomcat webapps
COPY --from=build /app/ch06email/dist/*.war /usr/local/tomcat/webapps/part1.war
COPY --from=build /app/ch06_ex1_email_sol/dist/*.war /usr/local/tomcat/webapps/part2.war
COPY --from=build /app/ch06_ex2_survey_sol/dist/*.war /usr/local/tomcat/webapps/part3.war

# Copy các jar cần thiết (JSTL + servlet-api) vào Tomcat lib
COPY --from=build /app/libs/*.jar /usr/local/tomcat/lib/

# Expose port
EXPOSE 8080

# Chạy Tomcat
CMD ["catalina.sh", "run"]
