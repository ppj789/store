# Stage 1: Build the application
FROM gradle:8.7-jdk17 AS build

# Set working directory
WORKDIR /app

# Copy Gradle wrapper files first for better caching
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle/

# Copy source code (dependencies are cached if build.gradle hasn't changed)
COPY src src/

# Build the application (skip tests during Docker build for speed)
RUN ./gradlew bootJar --no-daemon -x test

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine

# Add labels
LABEL maintainer="store-app"
LABEL description="Store Application - Spring Boot 3.4.2"

# Create a non-root user
RUN addgroup -S spring && adduser -S spring -G spring

# Set working directory
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Change ownership to non-root user
RUN chown spring:spring /app/app.jar

# Switch to non-root user
USER spring:spring

# Expose the application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# JVM optimization for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
