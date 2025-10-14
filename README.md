# Hello World Docker Application

A simple Java "Hello World" application that demonstrates containerization with Docker and automated building with Jenkins.

## 📋 Overview

This project contains:
- **Java Application**: A simple Hello World class
- **Maven Build**: For compilation and dependency management
- **Docker Container**: To package and run the application
- **Jenkins Pipeline**: For automated CI/CD
- **Windows Scripts**: For easy local development and deployment

## 🏗️ Project Structure

```
TestHelloWorld/
├── src/main/java/com/example/
│   └── HelloWorld.java           # Main Java application
├── scripts/
│   ├── build.ps1                 # Build application and Docker image
│   ├── deploy.ps1                # Deploy container in background
│   ├── run.ps1                   # Run container once and show output
│   └── cleanup.ps1               # Clean up containers and images
├── Dockerfile                    # Docker container configuration
├── Jenkinsfile                   # Jenkins CI/CD pipeline
├── pom.xml                       # Maven build configuration
└── README.md                     # This file
```

## 🔧 Prerequisites

### Required Software:
1. **Java 11 or higher**
   ```powershell
   java -version
   ```

2. **Maven 3.6+**
   ```powershell
   mvn --version
   ```

3. **Docker Desktop**
   ```powershell
   docker --version
   ```

4. **Jenkins** (optional, for CI/CD)

### Installation Links:
- [Java 11 JDK](https://adoptium.net/)
- [Apache Maven](https://maven.apache.org/download.cgi)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Jenkins](https://www.jenkins.io/download/)

## 🚀 Quick Start

### Method 1: Using Scripts (Recommended for Windows)

1. **Build the application and Docker image:**
   ```powershell
   .\scripts\build.ps1
   ```

2. **Run the application once:**
   ```powershell
   .\scripts\run.ps1
   ```

3. **Deploy as background service:**
   ```powershell
   .\scripts\deploy.ps1
   ```

4. **Clean up when done:**
   ```powershell
   .\scripts\cleanup.ps1
   ```

### Method 2: Manual Commands

1. **Build the Java application:**
   ```powershell
   mvn clean package -s local-settings.xml
   ```

2. **Build Docker image:**
   ```powershell
   docker build -t hello-world-app:latest .
   ```

3. **Run the container:**
   ```powershell
   # One-time execution
   docker run --rm hello-world-app:latest
   
   # Background service
   docker run -d --name hello-world hello-world-app:latest
   ```

## 🔍 Verification

After running the application, you should see output like:
```
Hello World
Application started successfully!
Running from Docker container...
```

## 🏭 Jenkins CI/CD Pipeline

### Pipeline Features:
- ✅ **Checkout**: Gets source code from repository
- ✅ **Build**: Compiles Java code with Maven
- ✅ **Test**: Runs unit tests (when added)
- ✅ **Package**: Creates JAR file
- ✅ **Docker Build**: Creates container image
- ✅ **Docker Test**: Validates container functionality
- ✅ **Registry Push**: Pushes to Docker registry (on main branch)
- ✅ **Deploy**: Deploys to target environment (on main branch)

### Jenkins Setup:

1. **Install Jenkins Plugins:**
   - Docker Pipeline
   - Maven Integration
   - Email Extension

2. **Configure Global Tools:**
   - Add JDK 11 installation (name: `JDK-11`)
   - Add Maven installation (name: `Maven-3.9`)

3. **Add Credentials:**
   - Docker registry credentials (ID: `docker-registry-credentials`)

4. **Create Pipeline Job:**
   - New Item → Pipeline
   - Pipeline script from SCM
   - Repository URL: `your-git-repository-url`

### Environment Variables to Configure:
```groovy
DOCKER_REGISTRY = 'your-docker-registry.com'    // Your Docker registry
```

## 🐳 Docker Commands Reference

### Basic Operations:
```powershell
# List images
docker images hello-world-app

# List containers
docker ps -a --filter "name=hello-world"

# View logs
docker logs hello-world

# Follow logs in real-time
docker logs -f hello-world

# Stop container
docker stop hello-world

# Remove container
docker rm hello-world

# Remove image
docker rmi hello-world-app:latest
```

### Advanced Operations:
```powershell
# Run with custom name
docker run -d --name my-hello-world hello-world-app:latest

# Run with port mapping (if app had web interface)
docker run -d -p 8080:8080 --name hello-world hello-world-app:latest

# Run with environment variables
docker run -d -e JAVA_OPTS="-Xmx512m" hello-world-app:latest
```

## 🛠️ Development

### Adding Features:
1. Modify `src/main/java/com/example/HelloWorld.java`
2. Run tests: `mvn test`
3. Build: `.\scripts\build.ps1`
4. Test: `.\scripts\run.ps1`

### Adding Dependencies:
1. Add dependency to `pom.xml`
2. Rebuild: `mvn clean package`
3. Rebuild Docker: `.\scripts\build.ps1`

### Adding Tests:
1. Create test files in `src/test/java/`
2. Add JUnit dependencies (already in `pom.xml`)
3. Run: `mvn test`

## 🔧 Troubleshooting

### Common Issues:

1. **Maven not found:**
   ```
   ERROR: Maven is not installed or not in PATH
   ```
   **Solution**: Install Maven and add to PATH

2. **Docker not running:**
   ```
   ERROR: Docker is not installed or not running
   ```
   **Solution**: Start Docker Desktop

3. **Image not found:**
   ```
   ERROR: Docker image 'hello-world-app:latest' not found
   ```
   **Solution**: Run `.\scripts\build.ps1` first

4. **Port already in use:**
   ```
   ERROR: Port 8080 is already in use
   ```
   **Solution**: Use different port or stop conflicting service

### Debug Commands:
```powershell
# Check Java version
java -version

# Check Maven version
mvn --version

# Check Docker version
docker --version

# Check Docker is running
docker ps

# View Docker logs
docker logs hello-world

# Interactive shell in container
docker exec -it hello-world /bin/bash
```

## 📊 Monitoring

### Container Health:
```powershell
# Check container status
docker ps --filter "name=hello-world"

# Check resource usage
docker stats hello-world

# Check container details
docker inspect hello-world
```

### Application Logs:
```powershell
# View all logs
docker logs hello-world

# View last 50 lines
docker logs --tail 50 hello-world

# Follow logs in real-time
docker logs -f hello-world
```

## 🔄 CI/CD Best Practices

1. **Branch Strategy:**
   - `main/master`: Production deployments
   - `develop`: Integration testing
   - Feature branches: Development

2. **Testing:**
   - Unit tests run on every build
   - Integration tests on develop branch
   - Smoke tests after deployment

3. **Security:**
   - Non-root user in container
   - Minimal base image (JRE slim)
   - Regular base image updates

## 📞 Support

For issues or questions:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review Docker and application logs
3. Verify all prerequisites are installed
4. Check Jenkins pipeline logs for CI/CD issues

## 📄 License

This project is provided as-is for educational and demonstration purposes.

---

**Happy Containerizing! 🐳**