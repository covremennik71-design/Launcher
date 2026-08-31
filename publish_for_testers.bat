@echo off
title Build CoRZs Launcher for Testers
cd /d "%~dp0"

echo ========================================================
echo   Building standalone version for testers...
echo ========================================================
echo.

dotnet publish GameLauncher/GameLauncher.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Publish failed.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo [SUCCESS] Build completed!
echo Output folder:
echo GameLauncher/bin/Release/net10.0-windows/win-x64/publish/
echo.
echo You can zip this folder and send it to testers.
...
echo ========================================================
pause
