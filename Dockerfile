# ---- Stage 1: Build with Ant ----
FROM openjdk:8-jdk AS build

WORKDIR /app

# Install Ant + wget
RUN apt-get update && apt-get install -y ant wget && rm -rf /var/lib/apt/lists/*

# Copy toàn bộ source
COPY . /app

# Tải servlet-api để compile
RUN mkdir -p lib && \
    wget -O lib/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar

# Build từng project
WORKDIR /app/ch06email
RUN ant clean dist

WORKDIR /app/ch06_ex1_email_sol
RUN ant clean dist

WORKDIR /app/ch06_ex2_survey_sol
RUN ant clean dist


# ---- Stage 2: Run with Tomcat ----
FROM tomcat:9-jdk11-openjdk

# Copy từng WAR sang webapps với context path mong muốn
COPY --from=build /app/ch06email/dist/*.war /usr/local/tomcat/webapps/part1.war
COPY --from=build /app/ch06_ex1_email_sol/dist/*.war /usr/local/tomcat/webapps/part2.war
COPY --from=build /app/ch06_ex2_survey_sol/dist/*.war /usr/local/tomcat/webapps/part3.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
