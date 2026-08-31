@echo off
title CoRZs Game Launcher
cd /d "%~dp0"

echo ========================================================
echo   Preparing and starting CoRZs Launcher...
echo ========================================================
echo.

where dotnet >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] .NET SDK not found on your PC.
    echo Downloading and installing .NET 10 SDK automatically...
    powershell -Command "Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'; .\dotnet-install.ps1 -Channel 10.0 -InstallDir '$env:LocalAppData\dotnet'"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to auto-install .NET. Please install it manually from https://dotnet.microsoft.com/download
        pause
        exit /b 1
    )
    set "PATH=%LocalAppData%\dotnet;%PATH%"
    echo [.NET SDK installed successfully]
)

echo [1/3] Restoring NuGet dependencies...
dotnet restore GameLauncher/GameLauncher.csproj
if %errorlevel% neq 0 (
    echo [ERROR] Failed to restore dependencies. Check your internet connection.
    pause
    exit /b 1
)

echo.
echo [2/3] Building project...
dotnet build GameLauncher/GameLauncher.csproj --configuration Release --no-restore
if %errorlevel% neq 0 (
    echo [ERROR] Build failed.
    pause
    exit /b 1
)

echo.
echo [3/3] Launching application...
echo ========================================================
dotnet run --project GameLauncher/GameLauncher.csproj --no-build --configuration Release

pause
