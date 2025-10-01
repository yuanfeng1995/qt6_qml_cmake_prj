@echo off
chcp 65001 >nul
title Windows 11 磁盘清理工具
color 0A

:: 自动请求管理员权限
setlocal EnableDelayedExpansion
set "batchPath=%~0"
set "batchArgs=%*"

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""!batchPath!"" !batchArgs!", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" >nul 2>&1
    exit /b
)

:: 清理屏幕
cls

echo.
echo ========================================
echo    Windows 11 磁盘清理工具 (管理员模式)
echo ========================================
echo.
echo 注意：此脚本将清理以下项目：
echo   - 临时文件
echo   - 系统缓存
echo   - 浏览器缓存
echo   - 回收站
echo   - Windows更新缓存
echo   - 日志文件
echo.
echo 建议先关闭所有应用程序
echo.
set /p confirm=是否继续清理？(Y/N): 
if /i "%confirm%" neq "Y" (
    echo 清理已取消。
    pause
    exit /b 0
)

echo.
echo 开始清理磁盘...
echo.

:: 清理临时文件
echo [1/8] 清理临时文件...
del /f /s /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
del /f /s /q C:\Windows\Temp\*.* >nul 2>&1
rd /s /q C:\Windows\Temp >nul 2>&1
echo     ✓ 临时文件清理完成

:: 清理系统缓存
echo [2/8] 清理系统缓存...
del /f /s /q C:\Windows\Prefetch\*.* >nul 2>&1
echo     ✓ 系统缓存清理完成

:: 清理回收站
echo [3/8] 清理回收站...
rd /s /q C:\$Recycle.Bin >nul 2>&1
echo     ✓ 回收站清理完成

:: 清理Windows更新缓存
echo [4/8] 清理Windows更新缓存...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q C:\Windows\SoftwareDistribution\*.* >nul 2>&1
rd /s /q C:\Windows\SoftwareDistribution >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
echo     ✓ Windows更新缓存清理完成

:: 清理日志文件
echo [5/8] 清理日志文件...
del /f /s /q C:\Windows\Logs\*.* >nul 2>&1
del /f /s /q C:\Windows\System32\LogFiles\*.* >nul 2>&1
wevtutil el | for /f %%i in ('wevtutil el') do wevtutil cl "%%i" >nul 2>&1
echo     ✓ 日志文件清理完成

:: 清理浏览器缓存
echo [6/8] 清理浏览器缓存...
:: Chrome
del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache2\*.*" >nul 2>&1
:: Edge
del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
:: Firefox
del /f /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2\*.*" >nul 2>&1
echo     ✓ 浏览器缓存清理完成

:: 清理下载历史
echo [7/8] 清理下载历史...
del /f /s /q "%USERPROFILE%\Downloads\*.*" >nul 2>&1
echo     ✓ 下载历史清理完成

:: 运行磁盘清理工具
echo [8/8] 运行系统磁盘清理工具...
cleanmgr /sagerun:1 >nul 2>&1
echo     ✓ 系统磁盘清理工具运行完成

echo.
echo ========================================
echo    磁盘清理完成！
echo ========================================
echo.
echo 清理已完成，建议重启计算机以确保所有更改生效。
echo.
pause