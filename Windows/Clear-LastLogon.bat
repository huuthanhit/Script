@echo off
setlocal
fltmc >nul 2>&1 || (echo Run this script as Administrator.& exit /b 1)
echo Clearing last logon display values...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnSAMUser /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnDisplayName /t REG_SZ /d "" /f
endlocal