@echo off
chcp 65001 > nul

:: Bat'ı yönetici olarak başlatmaya yarayan kod

if not "%1"=="amirequested" (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 amirequested' -Verb RunAs"
    exit
)

:: DISM, Cache(Prefetch & Temp Klasörü) temizleme ve SFC komutları

del /s /q C:\Windows\Prefetch\* && del /s /q C:\Windows\Temp\*

dism.exe /online /cleanup-image /analyzecomponentstore

:: Kullanıcıya temizlik yapıp yapmayacağını sorma
echo.
echo DISM analiz tamamlandı. Bileşen temizliği yapmak ister misiniz? (E/H)
choice /c EH /m "Seciminiz: "
if errorlevel 2 goto sfc_only

:: Temizlik işlemi
dism.exe /online /cleanup-image /startcomponentcleanup && dism.exe /online /cleanup-image /restorehealth

:sfc_only
sfc /scannow

dism.exe /online /cleanup-image /ScanHealth && dism.exe /online /cleanup-image /analyzecomponentstore

echo.
echo Islem tamamlanmistir.

:end
pause
