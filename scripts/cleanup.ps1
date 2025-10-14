# Clean up Docker resources for Hello World Application
# PowerShell script to stop and remove containers and optionally images

Write-Host "======================================" -ForegroundColor Green
Write-Host "Cleaning Hello World Application" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Stop and remove container
Write-Host "Stopping container..." -ForegroundColor Yellow
docker stop hello-world 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Container stopped successfully!" -ForegroundColor Green
} else {
    Write-Host "Container was not running" -ForegroundColor Gray
}

Write-Host "Removing container..." -ForegroundColor Yellow
docker rm hello-world 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Container removed successfully!" -ForegroundColor Green
} else {
    Write-Host "Container was not found" -ForegroundColor Gray
}

# Ask if user wants to remove images too
Write-Host ""
$removeImages = Read-Host "Do you want to remove Docker images too? (y/N)"
if ($removeImages -eq 'y' -or $removeImages -eq 'Y') {
    Write-Host "Removing Docker images..." -ForegroundColor Yellow
    docker rmi hello-world-app:latest 2>$null | Out-Null
    docker image prune -f 2>$null | Out-Null
    Write-Host "Images removed!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Showing remaining containers and images..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Containers:" -ForegroundColor Yellow
docker ps -a --filter "name=hello-world"
Write-Host ""
Write-Host "Images:" -ForegroundColor Yellow
docker images hello-world-app

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "Cleanup completed!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

Read-Host "Press Enter to continue"