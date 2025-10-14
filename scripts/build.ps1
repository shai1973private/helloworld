# Build and Deploy Hello World Application
# PowerShell script for compiling Java application and building Docker container

Write-Host "======================================" -ForegroundColor Green
Write-Host "Building Hello World Application" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Check if Maven is installed
Write-Host "Checking Maven installation..." -ForegroundColor Yellow
try {
    $mvnVersion = mvn --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Maven not found"
    }
    Write-Host "Maven found successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Maven is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Maven and add it to your PATH" -ForegroundColor Red
    exit 1
}

# Check if Docker is installed
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not found"
    }
    Write-Host "Docker found successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker is not installed or not running" -ForegroundColor Red
    Write-Host "Please install Docker and make sure it's running" -ForegroundColor Red
    exit 1
}

# Step 1: Clean previous builds
Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Cyan
mvn clean -s local-settings.xml
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Maven clean failed" -ForegroundColor Red
    exit 1
}

# Step 2: Compile and package
Write-Host "Step 2: Compiling and packaging the application..." -ForegroundColor Cyan
mvn package -DskipTests -s local-settings.xml
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Maven build failed" -ForegroundColor Red
    exit 1
}

# Step 3: Build Docker image
Write-Host "Step 3: Building Docker image..." -ForegroundColor Cyan
docker build -t hello-world-app:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed" -ForegroundColor Red
    exit 1
}

# Step 4: Tag with timestamp
Write-Host "Step 4: Tagging image with timestamp..." -ForegroundColor Cyan
Write-Host "Generating timestamp..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Write-Host "Applying timestamp tag..." -ForegroundColor Yellow
docker tag hello-world-app:latest "hello-world-app:$timestamp"
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker tag failed" -ForegroundColor Red
    exit 1
}
Write-Host "Tagged as hello-world-app:$timestamp" -ForegroundColor Green

Write-Host "======================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Available Docker images:" -ForegroundColor Yellow
docker images hello-world-app
Write-Host ""
Write-Host "To run the application:" -ForegroundColor Yellow
Write-Host "  docker run --rm hello-world-app:latest"
Write-Host ""
Write-Host "To run in background:" -ForegroundColor Yellow
Write-Host "  docker run -d --name hello-world hello-world-app:latest"
Write-Host ""
Write-Host "======================================" -ForegroundColor Green

Read-Host "Press Enter to continue"