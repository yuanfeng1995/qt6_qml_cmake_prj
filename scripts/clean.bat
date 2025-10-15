@echo off

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


setlocal

:: Check for admin rights
whoami /groups | find "S-1-16-12288" >nul
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    pause
    exit /b
)

:: Select mode
set MODE=full
if /i "%~1"=="light" set MODE=light

:: Set total steps
if /i "%MODE%"=="light" (
    set TOTAL=5
) else (
    set TOTAL=7
)

echo =================================
echo Cleanup started at %date% %time%
echo Mode: %MODE%
echo =================================
echo.

:: Disk space before cleanup
echo Disk space before cleanup:
wmic logicaldisk get size,freespace,caption
echo.

:: Step 1: Stop services
<nul set /p ="[1/%TOTAL%] Stopping Windows Update services... "
sc stop wuauserv
sc stop bits
sc stop cryptsvc
echo Done.

:: Step 2: Clean Windows Update cache
<nul set /p ="[2/%TOTAL%] Cleaning Windows Update cache... "
del /f /s /q C:\Windows\SoftwareDistribution\Download\*
for /d %%G in (C:\Windows\SoftwareDistribution\Download\*) do rd /s /q "%%G"
echo Done.

:: Step 3: Clean temporary files
<nul set /p ="[3/%TOTAL%] Cleaning temporary files... "
del /f /s /q %TEMP%\*
for /d %%G in (%TEMP%\*) do rd /s /q "%%G"
del /f /s /q C:\Windows\Temp\*
for /d %%G in (C:\Windows\Temp\*) do rd /s /q "%%G"
echo Done.

:: Step 4: Clean browser cache
<nul set /p ="[4/%TOTAL%] Cleaning browser cache... "
rd /s /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache"
rd /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache"
rd /s /q "%LocalAppData%\Mozilla\Firefox\Profiles"
echo Done.

:: Step 5: Empty recycle bin
<nul set /p ="[5/%TOTAL%] Emptying Recycle Bin... "
rd /s /q %systemdrive%\$Recycle.Bin
echo Done.

:: Extra cleanup only in FULL mode
if /i "%MODE%"=="full" (
    :: Step 6: Clean Windows Event Logs
    <nul set /p ="[6/%TOTAL%] Cleaning Windows Event Logs... "
    for /F "tokens=*" %%G in ('wevtutil el') DO (
        wevtutil cl "%%G"
    )
    echo Done.

    :: Step 7: WinSxS cleanup
    <nul set /p ="[7/%TOTAL%] Running WinSxS component store cleanup... "
    dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
    echo Done.
)

:: Restart Windows Update services
<nul set /p ="Restarting Windows Update services... "
net start wuauserv
net start bits
net start cryptsvc
echo Done.

:: Disk space after cleanup
echo.
echo Disk space after cleanup:
wmic logicaldisk get size,freespace,caption

echo.
echo =================================
echo Cleanup finished at %date% %time%
echo Mode: %MODE%
echo =================================
pause
exit /b
