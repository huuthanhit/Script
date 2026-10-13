# Script

@echo off
echo Dang xoa ten dang nhap Admin khoi man hinh Logon...

:: Xóa Username lưu tạm thời trong LogonUI
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnSAMUser /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnDisplayName /t REG_SZ /d "" /f >nul 2>&1


runas /user:masan\admin.thanhnh17 cmd
net localgroup administrators masan\  /add
###
