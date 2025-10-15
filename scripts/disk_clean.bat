@echo off
chcp 65001 >nul
title Windows 11 磁盘清理工具 - 增强版
color 0A

:: 自动请求管理员权限
setlocal EnableDelayedExpansion
set "batchPath=%~0"
set "batchArgs=%*"

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
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

:: 主菜单
:main_menu
cls
echo.
echo ========================================
echo    Windows 11 磁盘清理工具 - 增强版
echo ========================================
echo.
echo 请选择操作：
echo.
echo [1] 快速清理（自动清理临时文件等）
echo [2] 深度清理（包含系统文件）
echo [3] 自定义清理
echo [4] 退出
echo.
set /p choice=请输入选项 (1-4):

if "%choice%"=="1" goto quick_clean
if "%choice%"=="2" goto deep_clean
if "%%choice%"=="3" goto custom_clean
if "%choice%"=="4" exit /b 0
echo 无效选项，请重新选择！
pause
goto main_menu

:: 快速清理
:quick_clean
cls
echo.
echo ========================================
echo    快速清理模式
echo ========================================
echo.
echo 即将清理以下项目：
echo   - 临时文件
echo   - 系统缓存
echo   - 浏览器缓存
echo   - 回收站
echo   - Windows更新缓存
echo   - 日志文件
echo.
set /p confirm=是否继续清理？(Y/N):
if /i "%confirm%" neq "Y" goto main_menu

echo.
echo 开始快速清理...
echo.

:: 清理临时文件
echo [1/6] 清理临时文件...
del /f /s /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
del /f /s /q C:\Windows\Temp\*.* >nul 2>&1
rd /s /q C:\Windows\Temp >nul 2>&1
echo     ✓ 临时文件清理完成

:: 清理系统缓存
echo [2/6] 清理系统缓存...
del /f /s /q C:\Windows\Prefetch\*.* >nul 2>&1
echo     ✓ 系统缓存清理完成

:: 清理回收站
echo [3/6] 清理回收站...
rd /s /q C:\$Recycle.Bin >nul 2>&1
echo     ✓ 回收站清理完成

:: 清理Windows更新缓存
echo [4/6] 清理Windows更新缓存...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q C:\Windows\SoftwareDistribution\*.* >nul 2>&1
rd /s /q C:\Windows\SoftwareDistribution >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
echo     ✓ Windows更新缓存清理完成

:: 清理日志文件
echo [5/6] 清理日志文件...
del /f /s /q C:\Windows\Logs\*.* >nul 2>&1
del /f /s /q C:\Windows\System32\LogFiles\*.* >nul 2>&1
wevtutil el | for /f %%i in ('wevtutil el') do wevtutil cl "%%i" >nul 2>&1
echo     ✓ 日志文件清理完成

:: 清理浏览器缓存
echo [6/6] 清理浏览器缓存...
del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2\*.*" >nul 2>&1
echo     ✓ 浏览器缓存清理完成

echo.
echo 快速清理完成！
pause
goto main_menu


:: 深度清理
:deep_clean
cls
echo.
echo ========================================
echo    深度清理模式
echo ========================================
echo.
echo 警告：深度清理将清理更多系统文件，请谨慎操作！
echo 即将清理以下项目：
echo   - 快速清理的所有项目
echo   - 系统还原点（保留最近一个）
echo   - Windows.old文件夹
echo   - 休眠文件（如果不使用休眠功能）
echo.
set /p confirm=是否继续深度清理？(Y/N):
if /i "%confirm%" neq "Y" goto main_menu

call :quick_clean

echo.
echo [7/8] 清理系统还原点...
vssadmin delete shadows /all /quiet >nul 2>&1
echo     ✓ 系统还原点清理完成

echo [8/8] 清理Windows.old文件夹...
rd /s /q C:\Windows.old >nul 2>&1
echo     ✓ Windows.old文件夹清理完成

echo [9/9] 清理休眠文件...
powercfg -h off >nul 2>&1
echo     ✓ 休眠文件清理完成

echo.
echo 深度清理完成！
pause
goto main_menu

:: 自定义清理
:custom_clean
cls
echo.
echo ========================================
echo    自定义清理模式
echo ========================================
echo.
echo 请选择要清理的项目：
echo.
echo [1] 临时文件
echo [2] 浏览器缓存
echo [3] 回收站
echo [4] 日志文件
echo [5] Windows更新缓存
echo [6] 系统缓存
echo [7] 返回主菜单
echo.
set /p custom_choice=请输入选项 (1-7):

if "%custom_choice%"=="7" goto main_menu
if "%custom_choice%" geq "1" if "%custom_choice%" leq "6" (
    echo.
    set /p confirm=确认清理此项目？(Y/N):
    if /i "%confirm%"=="Y" (
        if "%custom_choice%"=="1" (
            echo 清理临时文件...
            del /f /s /q %temp%\*.* >nul 2>&1
            rd /s /q %temp% >nul 2>&1
            del /f /s /q C:\Windows\Temp\*.* >nul 2>&1
            rd /s /q C:\Windows\Temp >nul 2>&1
        )
        if "%custom_choice%"=="2" (
            echo 清理浏览器缓存...
            del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
            del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
            del /f /s /q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2\*.*" >nul 2>&1
        )
        if "%custom_choice%"=="3" (
            echo 清理回收站...
            rd /s /q C:\$Recycle.Bin >nul 2>&1
        )
        if "%custom_choice%"=="4" (
            echo 清理日志文件...
            del /f /s /q C:\Windows\Logs\*.* >nul 2>&1
            del /f /s /q C:\Windows\System32\LogFiles\*.* >nul 2>&1
            wevtutil el | for /f %%i in ('wevtutil el') do wevtutil cl "%%i" >nul 2>&1
        )
        if "%custom_choice%"=="5" (
            echo 清理Windows更新缓存...
            net stop wuauserv >nul 2>&1
            net stop bits >nul 2>&1
            del /f /s /q C:\Windows\SoftwareDistribution\*.* >nul 2>&1
            rd /s /q C:\Windows\SoftwareDistribution >nul 2>&1
            net start bits >nul 2>&1
            net start wuauserv >nul 2>&1
        )
        if "%custom_choice%"=="6" (
            echo 清理系统缓存...
            del /f /s /q C:\Windows\Prefetch\*.* >nul 2>&1
        )
        echo 清理完成！
    )
    pause
    goto custom_clean
) else (
    echo 无效选项，请重新选择！
    pause
    goto custom_clean
)