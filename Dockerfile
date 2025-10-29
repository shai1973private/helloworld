# Use OpenJDK 11 as the base image
FROM openjdk:11-jre-slim

# Set metadata
LABEL maintainer="your-email@example.com"
LABEL description="Hello World Java Application"
LABEL version="1.0.0"

# Create application directory
WORKDIR /app

# Copy the compiled JAR file from the target directory
COPY target/hello-world-app.jar /app/hello-world-app.jar

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# Expose port (not needed for this simple app, but good practice)
EXPOSE 8080

# Set the entrypoint to run the Java application
CMD ["java", "-jar", "hello-world-app.jar"]

# Optional: Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -version || exit 1