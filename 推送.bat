@echo off
setlocal enabledelayedexpansion

title һ������

:start
cls
echo.
echo ====================================================

echo ��ѡ�������
echo 1. ��װ�������(MT��������SC8��KernelSU)
echo 2. �����ļ����ڲ��洢
echo 0. �˳�����
echo ============================

set /p choice=������ѡ�0,1,2���� 

if "%choice%"=="0" (
    echo �����˳�����...
    timeout /t 2 /nobreak >nul
    exit /b 0
) else if "%choice%"=="1" (
    call :download_and_install_apps
) else if "%choice%"=="2" (
    call :push_files
) else (
    echo ��Ч��ѡ�������0,1��2��
    timeout /t 2 /nobreak >nul
)
goto :start

:download_and_install_apps
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ��ʼ��װӦ��...
echo.
echo ��װMT������...
adb install apk\MT.apk

echo ��װSC8...
adb install apk\sc.apk

echo ��װKernelSU...
adb install apk\ksu.apk

echo.
echo Ӧ�ð�װ��ɣ�
pause
goto :eof

:push_files
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ��ʼ�����ļ�...
echo.

cd ����

for %%F in (*) do (
    echo ��������: %%~nxF
    adb push "%%F" "/sdcard/%%~nxF"
)

cd ..

echo.
echo �ļ�������ɣ�
pause
goto :eof
