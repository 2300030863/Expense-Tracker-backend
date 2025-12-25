# Multi-stage build for Spring Boot application
# Stage 1: Build the application
FROM maven:3.9.5-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies (layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built artifact from build stage
COPY --from=build /app/target/ExpenseTrackerApplication.war /app/app.war

# Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Expose port (Render will set PORT env variable)
EXPOSE 8080

# Use environment variable for port
ENV PORT=8080
ENV SPRING_PROFILES_ACTIVE=mysql

# Run the application
# Use exec form to properly handle signals
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${PORT} -jar /app/app.war"]
