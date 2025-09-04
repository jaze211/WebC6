# ---- Stage 1: Build with Ant ----
FROM openjdk:8-jdk AS build

WORKDIR /app

# Install Ant + wget
RUN apt-get update && apt-get install -y ant wget && rm -rf /var/lib/apt/lists/*

# Copy project
COPY . /app

# Tải servlet-api.jar để compile
RUN mkdir -p lib && \
    wget -O lib/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar

# Build WAR
RUN ant clean && ant dist

# ---- Stage 2: Run with Tomcat ----
FROM tomcat:9-jdk11-openjdk

# Copy WAR vào Tomcat (dùng ROOT.war để truy cập trực tiếp /)
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
