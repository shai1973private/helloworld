# Deploy Hello World Application
# PowerShell script that runs the Docker container as a background service

Write-Host "======================================" -ForegroundColor Green
Write-Host "Deploying Hello World Application" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Check if Docker is running
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not found"
    }
    Write-Host "Docker found successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker is not installed or not running" -ForegroundColor Red
    Write-Host "Please install Docker and make sure it's running" -ForegroundColor Red
    exit 1
}

# Check if the image exists
Write-Host "Checking for Docker image..." -ForegroundColor Yellow
$imageExists = docker images hello-world-app:latest -q 2>$null
if (-not $imageExists -or $LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker image 'hello-world-app:latest' not found" -ForegroundColor Red
    Write-Host "Please run 'scripts\build.ps1' first to build the image" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image found!" -ForegroundColor Green

# Stop and remove existing container if it exists
Write-Host "Checking for existing containers..." -ForegroundColor Yellow
$existingContainer = docker ps -a --filter "name=hello-world" --format "{{.Names}}" 2>$null | Where-Object { $_ -eq "hello-world" }
if ($existingContainer) {
    Write-Host "Stopping existing container..." -ForegroundColor Yellow
    docker stop hello-world 2>$null | Out-Null
    Write-Host "Removing existing container..." -ForegroundColor Yellow
    docker rm hello-world 2>$null | Out-Null
}

Write-Host "Starting new container..." -ForegroundColor Cyan
docker run -d --name hello-world hello-world-app:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "Deployment successful!" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    
    # Wait a moment for the container to start and produce output
    Write-Host "Waiting for container to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    
    # Follow logs live
    Write-Host ""
    Write-Host "Following container logs live... (Press Ctrl+C to stop)" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Yellow
    docker logs -f hello-world
    
    Write-Host ""
    Write-Host "Container Status:" -ForegroundColor Yellow
    docker ps --filter "name=hello-world"
    Write-Host ""
    Write-Host "Useful Commands:" -ForegroundColor Yellow
    Write-Host "  To view logs again:" -ForegroundColor Gray
    Write-Host "    docker logs hello-world"
    Write-Host ""
    Write-Host "  To view live logs:" -ForegroundColor Gray
    Write-Host "    docker logs -f hello-world"
    Write-Host ""
    Write-Host "  To stop the container:" -ForegroundColor Gray
    Write-Host "    docker stop hello-world"
    Write-Host ""
    Write-Host "  To remove the container:" -ForegroundColor Gray
    Write-Host "    docker rm hello-world"
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to start container" -ForegroundColor Red
    exit 1
}

Read-Host "Press Enter to continue"