@echo off
setlocal enabledelayedexpansion

title 一键推送

:start
cls
echo.
echo ====================================================

echo 请选择操作：
echo 1. 安装所需软件(MT管理器、SC8、KernelSU)
echo 2. 推送文件到内部存储
echo 0. 退出程序
echo ============================

set /p choice=请输入选项（0,1,2）： 

if "%choice%"=="0" (
    echo 正在退出程序...
    timeout /t 2 /nobreak >nul
    exit /b 0
) else if "%choice%"=="1" (
    call :download_and_install_apps
) else if "%choice%"=="2" (
    call :push_files
) else (
    echo 无效的选项，请输入0,1或2！
    timeout /t 2 /nobreak >nul
)
goto :start

:download_and_install_apps
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 开始安装应用...
echo.
echo 安装MT管理器...
adb install apk\MT.apk

echo 安装SC8...
adb install apk\sc.apk

echo 安装KernelSU...
adb install apk\ksu.apk

echo.
echo 应用安装完成！
pause
goto :eof

:push_files
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 开始推送文件...
echo.

cd 推送

for %%F in (*) do (
    echo 正在推送: %%~nxF
    adb push "%%F" "/sdcard/%%~nxF"
)

cd ..

echo.
echo 文件推送完成！
pause
goto :eof
