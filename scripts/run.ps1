# Run Hello World Application (one-time execution)
# PowerShell script that runs the container once and shows the output

Write-Host "======================================" -ForegroundColor Green
Write-Host "Running Hello World Application" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Check if Docker is running
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

# Check if the image exists
Write-Host "Checking for Docker image..." -ForegroundColor Yellow
$imageExists = docker images hello-world-app:latest -q 2>$null
if (-not $imageExists -or $LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker image 'hello-world-app:latest' not found" -ForegroundColor Red
    Write-Host "Please run 'scripts\build.ps1' first to build the image" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image found!" -ForegroundColor Green

Write-Host "Running container (one-time execution)..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Green

docker run --rm hello-world-app:latest

Write-Host "======================================" -ForegroundColor Green
Write-Host "Application execution completed!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

Read-Host "Press Enter to continue"