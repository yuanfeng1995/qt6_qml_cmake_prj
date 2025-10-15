taskkill /IM explorer.exe /F
cd /d %localappdata%\
del IconCache.db /a
cd /d %localappdata%\Microsoft\Windows\Explorer
del iconcache* /a
start explorer.exe
