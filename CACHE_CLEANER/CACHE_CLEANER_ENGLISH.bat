@echo off
chcp 65001 > nul

:: Code to run the batch file as administrator

if not "%1"=="amirequested" (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 amirequested' -Verb RunAs"
    exit
)

:: DISM, Cache (Prefetch & Temp Folder) cleanup, and SFC commands

del /s /q C:\Windows\Prefetch\* && del /s /q C:\Windows\Temp\*

dism.exe /online /cleanup-image /analyzecomponentstore

:: Ask the user whether to perform cleanup
echo.
echo DISM analysis completed. Do you want to perform a component cleanup? (Y/N)
choice /c YN /m "Your choice: "
if errorlevel 2 goto sfc_only

:: Cleanup process
dism.exe /online /cleanup-image /startcomponentcleanup && dism.exe /online /cleanup-image /restorehealth

:sfc_only
sfc /scannow

dism.exe /online /cleanup-image /ScanHealth && dism.exe /online /cleanup-image /analyzecomponentstore

echo.
echo Process completed.

:end
pause
