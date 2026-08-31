@echo off
chcp 65001 > nul
title Запуск игрового лаунчера CoRZs

echo ========================================================
echo   Подготовка и запуск лаунчера CoRZs...
echo ========================================================
echo.

:: Проверка наличия .NET CLI
where dotnet >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] .NET SDK не найден на вашем компьютере!
    echo Для работы лаунчера необходим .NET 10 SDK (или новее).
    echo Скачайте и установите его с официального сайта:
    echo https://dotnet.microsoft.com/download/dotnet/10.0
    echo.
    pause
    exit /b 1
)

echo [.NET найден] Проверка и установка зависимостей (NuGet)...
dotnet restore GameLauncher/GameLauncher.csproj
if %errorlevel% neq 0 (
    echo [ОШИБКА] Не удалось восстановить зависимости. Проверьте интернет-соединение.
    pause
    exit /b 1
)

echo.
echo [Сборка] Компиляция проекта...
dotnet build GameLauncher/GameLauncher.csproj --configuration Release --no-restore
if %errorlevel% neq 0 (
    echo [ОШИБКА] Ошибка при компиляции проекта.
    pause
    exit /b 1
)

echo.
echo [Запуск] Запуск игрового лаунчера...
echo ========================================================
dotnet run --project GameLauncher/GameLauncher.csproj --no-build --configuration Release

pause
