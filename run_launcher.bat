@echo off
chcp 65001 > nul
title Запуск игрового лаунчера CoRZs

echo ========================================================
echo   Проверка окружения .NET...
echo ========================================================
echo.

:: Проверка наличия .NET CLI
where dotnet >nul 2>&1
if %errorlevel% neq 0 (
    echo [ВНИМАНИЕ] .NET SDK не найден на вашем компьютере.
    echo Хотите автоматически скачать и установить .NET 10 SDK?
    echo Нажмите любую клавишу для начала установки или закройте окно для отмены.
    pause >nul
    
    echo.
    echo [Загрузка] Скачивание и установка .NET 10 SDK (это может занять несколько минут)...
    
    powershell -Command "Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'; .\dotnet-install.ps1 -Channel 10.0 -InstallDir '$env:LocalAppData\dotnet'"
    
    if %errorlevel% neq 0 (
        echo [ОШИБКА] Не удалось автоматически установить .NET. Установите его вручную с сайта https://dotnet.microsoft.com/download
        pause
        exit /b 1
    )
    
    :: Добавляем установленный .NET в PATH для текущей сессии
    set "PATH=%LocalAppData%\dotnet;%PATH%"
    echo [УСПЕХ] .NET SDK успешно установлен!
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
