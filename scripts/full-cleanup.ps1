# Full Clean - Reset Everything to Start Fresh
# PowerShell script to remove all build artifacts, containers, and images

Write-Host "======================================" -ForegroundColor Red
Write-Host "FULL CLEANUP - Reset Everything" -ForegroundColor Red
Write-Host "======================================" -ForegroundColor Red
Write-Host ""

# Warning message
Write-Host "WARNING: This will remove:" -ForegroundColor Yellow
Write-Host "  - All Maven build artifacts (target/ directory)" -ForegroundColor Gray
Write-Host "  - All hello-world Docker containers" -ForegroundColor Gray
Write-Host "  - All hello-world-app Docker images" -ForegroundColor Gray
Write-Host "  - Temporary build files" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Are you sure you want to continue? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Cleanup cancelled." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Starting full cleanup..." -ForegroundColor Cyan

# 1. Stop and remove Docker containers
Write-Host "1. Cleaning up Docker containers..." -ForegroundColor Yellow
$containers = docker ps -a --filter "name=hello-world" -q 2>$null
if ($containers) {
    Write-Host "   Stopping containers..." -ForegroundColor Gray
    docker stop $containers 2>$null | Out-Null
    Write-Host "   Removing containers..." -ForegroundColor Gray
    docker rm $containers 2>$null | Out-Null
    Write-Host "   ✅ Containers cleaned up" -ForegroundColor Green
} else {
    Write-Host "   ✅ No containers to clean up" -ForegroundColor Green
}

# 2. Remove Docker images
Write-Host "2. Cleaning up Docker images..." -ForegroundColor Yellow
$images = docker images hello-world-app -q 2>$null
if ($images) {
    Write-Host "   Removing hello-world-app images..." -ForegroundColor Gray
    docker rmi $images -f 2>$null | Out-Null
    Write-Host "   ✅ Images cleaned up" -ForegroundColor Green
} else {
    Write-Host "   ✅ No images to clean up" -ForegroundColor Green
}

# 3. Clean Maven build artifacts
Write-Host "3. Cleaning Maven build artifacts..." -ForegroundColor Yellow
if (Test-Path "target") {
    Remove-Item -Recurse -Force "target" 2>$null
    Write-Host "   ✅ target/ directory removed" -ForegroundColor Green
} else {
    Write-Host "   ✅ No target/ directory to clean" -ForegroundColor Green
}

# 4. Clean temporary files
Write-Host "4. Cleaning temporary files..." -ForegroundColor Yellow
$tempFiles = @("temp_timestamp.txt", "*.tmp", "*.temp")
foreach ($pattern in $tempFiles) {
    if (Get-ChildItem -Path . -Name $pattern -ErrorAction SilentlyContinue) {
        Remove-Item $pattern -Force 2>$null
        Write-Host "   ✅ Removed $pattern files" -ForegroundColor Green
    }
}

# 5. Clean Docker build cache (optional)
Write-Host "5. Docker system cleanup..." -ForegroundColor Yellow
$cleanDocker = Read-Host "Do you want to clean Docker build cache too? (y/N)"
if ($cleanDocker -eq 'y' -or $cleanDocker -eq 'Y') {
    docker system prune -f 2>$null | Out-Null
    Write-Host "   ✅ Docker build cache cleaned" -ForegroundColor Green
} else {
    Write-Host "   ⏭️  Docker build cache skipped" -ForegroundColor Gray
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "FULL CLEANUP COMPLETED!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# Show current state
Write-Host "Current state after cleanup:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Maven artifacts:" -ForegroundColor Yellow
if (Test-Path "target") {
    Write-Host "   target/ directory exists" -ForegroundColor Gray
} else {
    Write-Host "   ✅ No target/ directory" -ForegroundColor Green
}

Write-Host ""
Write-Host "Docker containers:" -ForegroundColor Yellow
$remainingContainers = docker ps -a --filter "name=hello-world" 2>$null
if ($remainingContainers) {
    docker ps -a --filter "name=hello-world"
} else {
    Write-Host "   ✅ No hello-world containers" -ForegroundColor Green
}

Write-Host ""
Write-Host "Docker images:" -ForegroundColor Yellow
$remainingImages = docker images hello-world-app 2>$null
if ($remainingImages -and $remainingImages.Count -gt 1) {
    docker images hello-world-app
} else {
    Write-Host "   ✅ No hello-world-app images" -ForegroundColor Green
}

Write-Host ""
Write-Host "Ready to start fresh! Run .\scripts\build.ps1 to rebuild everything." -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to continue"