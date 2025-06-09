@echo off
title Windows System Maintenance Script
color 0A

echo Stopping Windows Update and related services...
net stop wuauserv 2>nul
net stop cryptSvc 2>nul
net stop bits 2>nul
net stop msiserver 2>nul

echo Renaming and moving SoftwareDistribution folder...
if exist "C:\Windows\SoftwareDistribution" (
    ren "C:\Windows\SoftwareDistribution" "SoftwareDistribution.backup"
    mkdir "D:\temp" 2>nul
    move "C:\Windows\SoftwareDistribution.backup" "D:\temp\"
)

echo Renaming and moving Catroot2 folder...
if exist "C:\Windows\System32\catroot2" (
    ren "C:\Windows\System32\catroot2" "catroot2.backup"
    mkdir "D:\temp" 2>nul
    move "C:\Windows\System32\catroot2.backup" "D:\temp\"
)

echo Restarting services...
net start wuauserv
net start cryptSvc
net start bits
net start msiserver

echo Running Disk Cleanup...
cleanmgr /dc /verylowdisk

echo Running System File Checker...
sfc /scannow

echo Running Disk Check...
chkdsk /r /f

echo Checking Windows Image Health...
Dism /Online /Cleanup-Image /CheckHealth
Dism /Online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /RestoreHealth
DISM.exe /online /cleanup-image /AnalyzeComponentStore

echo Running Disk Cleanup again...
cleanmgr /dc /verylowdisk

echo Maintenance script completed.
pause
