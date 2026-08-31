@echo off
chcp 65001 > nul
title Сборка лаунчера для тестеров

echo ========================================================
echo   Сборка автономной версии лаунчера (для тестеров)...
echo ========================================================
echo.

echo Восстановление и публикация проекта (Self-Contained)...
dotnet publish GameLauncher/GameLauncher.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true

if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось собрать проект.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo [УСПЕХ] Сборка успешно завершена!
echo Файлы лаунчера находятся в папке:
echo GameLauncher\bin\Release\net10.0-windows\win-x64\publish\
echo.
echo Вы можете запаковать эту папку в ZIP-архив и отправить тестерам.
echo Тестерам не потребуется устанавливать .NET на свой компьютер!
echo ========================================================
pause
