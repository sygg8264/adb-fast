@echo off
setlocal enabledelayedexpansion

title 小米刷机工具

:: 检查依赖
echo 检查依赖文件...
set missing_files=0

if not exist "AdbWinApi.dll" (
    set /a missing_files+=1
    echo 下载AdbWinApi.dll依赖文件...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/AdbWinApi.dll', 'AdbWinApi.dll')"
)

if not exist "AdbWinUsbApi.dll" (
    set /a missing_files+=1
    echo 下载AdbWinUsbApi.dll依赖文件...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/AdbWinUsbApi.dll', 'AdbWinUsbApi.dll')"
)

if not exist "adb.exe" (
    set /a missing_files+=1
    echo 下载adb.exe依赖文件...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/adb.exe', 'adb.exe')"
)

if not exist "fastboot.exe" (
    set /a missing_files+=1
    echo 下载fastboot.exe依赖文件...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/fastboot.exe', 'fastboot.exe')"
)

if !missing_files! gtr 0 (
    echo 依赖文件下载完成，请重试操作
    timeout /t 3 /nobreak >nul
) else (
    echo 所有依赖文件已存在，无需下载
)


:start
cls
echo.
echo ====================================================
echo                消失的老圣佑  V：sygg8264
echo ====================================================
echo.
echo ============================
echo 请选择操作：
echo 1. 查询ADB 设备列表
echo 2. 进入fastboot 
echo 3. 查询fastboot设备列表
echo 4. 进入fastboot并自动刷机
echo 5. 查找刷机脚本
echo 6. 性能调节菜单
echo 7. 净化设备
echo 8. 自定义指令
echo 0. 退出程序
echo ============================

set /p choice=请输入选项（0-8）： 

if "%choice%"=="0" (
    echo 正在退出程序...
    timeout /t 2 /nobreak >nul
    exit /b 0
) else if "%choice%"=="1" (
    call :check_adb_devices
) else if "%choice%"=="2" (
    call :enter_fastboot
) else if "%choice%"=="3" (
    call :check_fastboot_devices
) else if "%choice%"=="4" (
    call :enter_fastboot_and_flash
) else if "%choice%"=="5" (
    call :find_flash_script_and_flash
) else if "%choice%"=="6" (
    call :performance_menu
) else if "%choice%"=="7" (
    call :clean_device
) else if "%choice%"=="8" (
    call :custom_command
) else (
    echo 无效的选项，请输入0-8！
    timeout /t 2 /nobreak >nul
)
goto :start

:check_adb_devices
cls
echo 正在检查设备连接状态...
echo.
echo ADB设备列表:
adb devices
echo.
echo Fastboot设备列表:
fastboot devices
echo.
echo 如果设备未正常识别，请检查:
echo 1. USB线是否正常连接
echo 2. 是否已开启USB调试
echo 3. 驱动是否正常
echo.
pause
goto :eof

:enter_fastboot
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo 正在重启至Fastboot模式...
adb reboot bootloader
echo 等待设备重启...
timeout /t 10 /nobreak >nul

set "retry_count=0"
:check_fastboot_loop
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo 正在等待设备进入Fastboot模式...
    timeout /t 2 /nobreak >nul
    set /a retry_count+=1
    if !retry_count! lss 5 goto check_fastboot_loop
    echo 设备未能成功进入Fastboot模式！
    echo 请：
    echo 1. USB重新连接设备
    echo 2. 驱动是否正常
    echo 3. 手动进入Fastboot模式
    timeout /t 3 /nobreak >nul
) else (
    echo [√] 已成功进入Fastboot模式
)
goto :eof

:enter_fastboot_and_flash
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo 正在重启至Fastboot模式...
adb reboot bootloader
echo 等待设备重启...
timeout /t 10 /nobreak >nul

fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo 设备未能进入Fastboot模式！
    echo 请：
    echo 1. USB重新连接设备
    echo 2. 驱动是否正常
    echo 3. 手动进入Fastboot模式
    timeout /t 3 /nobreak >nul
) else (
    echo [√] 已成功进入Fastboot模式
    if exist "flash_all.bat" (
        echo 正在复制必要的依赖文件...
        copy /Y adb.exe flash_all.bat\..\ >nul
        copy /Y adbwinapi.dll flash_all.bat\..\ >nul 
        copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
        copy /Y fastboot.exe flash_all.bat\..\ >nul
        
        echo 开始执行刷机脚本...
        call flash_all.bat
        
        echo 正在清理临时文件...
        del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
        del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
        del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
        del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
    ) else (
        echo 未找到flash_all.bat文件！
        echo 请将flash_all.bat放置在当前目录
        timeout /t 3 /nobreak >nul
    )
)
goto :eof

:check_fastboot_devices
cls
echo 正在检查Fastboot设备...
echo.
echo Fastboot设备列表:
fastboot devices
echo.
set "device_found="
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo [!] 未检测到Fastboot设备
    echo.
    echo 请检查:
    echo 1. 重新插拔设备USB
    echo 2. 是否进入Fastboot模式
    echo 3. 驱动是否正常
) else (
    echo [√] 检测到Fastboot设备
    echo.
    echo 设备已连接，可以进行以下操作
    echo.
    echo ============================
    echo 请选择操作：
    echo 1. 全部刷入
    echo 2. 刷入boot
    echo 3. 重启至系统
    echo 0. 返回主菜单
    echo ============================
    
    set /p flash_choice=请输入选项（0-3）：
    
    if "!flash_choice!"=="1" (
        if exist "flash_all.bat" (
            echo 正在复制必要的依赖文件...
            copy /Y adb.exe flash_all.bat\..\ >nul
            copy /Y adbwinapi.dll flash_all.bat\..\ >nul
            copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
            copy /Y fastboot.exe flash_all.bat\..\ >nul
            
            call flash_all.bat
            
            echo 正在清理临时文件...
            del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
            del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
            del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
            del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
        ) else (
            echo 未找到flash_all.bat文件！
            echo 请将flash_all.bat放置在当前目录
            timeout /t 3 /nobreak >nul
        )
    ) else if "!flash_choice!"=="2" (
        call :flash_boot
    ) else if "!flash_choice!"=="3" (
        fastboot reboot
    ) else if "!flash_choice!"=="0" (
        goto :start
    ) else (
        echo 无效的选项
        timeout /t 2 /nobreak >nul
    )
)
echo.
pause
goto :eof

:find_flash_script_and_flash
cls
echo 正在搜索刷机包...
echo.

:: 首先在可能的文件夹中查找
set "found=0"
for /f "delims=" %%i in ('dir /s /b /ad "*fastboot*" "*images*" 2^>nul') do (
    if exist "%%i\flash_all.bat" (
        set /a found+=1
        set "flash_path[!found!]=%%i\flash_all.bat"
        echo !found!. %%i\flash_all.bat
    )
)

:: 如果在特定文件夹中未找到，则在所有位置查找flash_all.bat
if !found!==0 (
    for /f "delims=" %%i in ('dir /s /b flash_all.bat 2^>nul') do (
        set /a found+=1
        set "flash_path[!found!]=%%i"
        echo !found!. %%i
    )
)

if !found!==0 (
    echo [!] 未找到任何刷机包
    echo 请检查：
    echo 1. 刷机包是否解压
    echo 2. 是否存在flash_all.bat文件
    pause
    goto :start
)

echo.
echo 共找到!found!个刷机包
set /p script_choice=请选择要使用的刷机包（1-!found!）或输入0返回：

if !script_choice! equ 0 goto :start
if !script_choice! leq 0 goto :invalid_script_choice
if !script_choice! gtr !found! goto :invalid_script_choice

echo.
echo 已选择刷机包: !flash_path[%script_choice%]!
echo.
echo [警告] 刷机可能会清除设备数据！
echo 1. 请提前备份重要数据
echo 2. 确保设备电量在50%以上
echo 3. 保持USB稳定连接
echo.
set /p flash_confirm=是否继续执行刷机(Y/N)？

if /i "!flash_confirm!"=="Y" (
    echo 正在重启至Fastboot模式...
    adb reboot bootloader
    echo 等待设备重启...
    timeout /t 10 /nobreak >nul

    :: 检查设备
    echo 正在检查设备...
    
    fastboot devices | find "fastboot" >nul
    if errorlevel 1 (
        echo [!] 未检测到设备
        echo 请检查：
        echo 1. 重新连接USB
        echo 2. USB线是否正常
        echo 3. 更换USB接口
        pause
        goto :start
    )

    :: 切换到刷机包目录
    pushd "!flash_path[%script_choice%]!\..\"
    
    echo [√] 已进入Fastboot模式
    echo.
    echo 刷机过程预计需要5-10分钟
    echo 请保持设备连接并勿断开USB
    echo.
    
    :: 复制依赖文件
    echo 正在复制必要的依赖文件...
    copy /Y "%~dp0adb.exe" . >nul
    copy /Y "%~dp0adbwinapi.dll" . >nul
    copy /Y "%~dp0adbwinusbapi.dll" . >nul
    copy /Y "%~dp0fastboot.exe" . >nul
    
    :: 执行刷机
    echo 开始执行刷机...
    call flash_all.bat
    if errorlevel 1 (
        echo [!] 刷机失败！
        echo 请检查设备连接并重试
    ) else (
        echo [√] 刷机完成！
        echo 设备即将重启...
    )
    
    :: 清理文件
    echo 正在清理临时文件...
    del /F /Q adb.exe >nul 2>&1
    del /F /Q adbwinapi.dll >nul 2>&1
    del /F /Q adbwinusbapi.dll >nul 2>&1
    del /F /Q fastboot.exe >nul 2>&1
    
    popd
) else (
    echo 已取消刷机操作
    timeout /t 2 /nobreak >nul
    goto :start
)

goto :start

:performance_menu
cls
echo ============================
echo 性能调节菜单选项：
echo 1. 下载并安装性能软件
echo 2. 修改广角
echo 0. 返回主菜单
echo ============================

set /p perf_choice=请输入选项（0-2）：

if "!perf_choice!"=="1" (
    call :download_and_install_apps
) else if "!perf_choice!"=="2" (
    call :change_ultra_wide_angle
) else if "!perf_choice!"=="0" (
    goto :start
) else (
    echo 无效的选项
    timeout /t 2 /nobreak >nul
    goto :performance_menu
)
goto :performance_menu

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

echo 开始下载应用程序...
echo.
echo 下载MT管理器...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://pan.mt2.cn/mt/MT2.17.3.apk', 'MT2.17.3.apk')"

echo 下载SCene8...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/sc8.apk', 'sc8.apk')"

echo 下载Smark...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/smark.apk', 'smark.apk')"

echo 下载KernelSU...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/KernelSU_v1.0.2_11986-release.apk', 'KernelSU.apk')"

echo.
echo 开始安装应用...
echo.
echo 安装MT管理器...
adb install MT2.17.3.apk

echo 安装SC8...
adb install sc8.apk

echo 安装Smark...
adb install smark.apk

echo 安装KernelSU...
adb install KernelSU.apk

echo.
echo 清理临时文件...
del /f /q MT2.17.3.apk
del /f /q sc8.apk
del /f /q smark.apk
del /f /q KernelSU.apk

echo.
echo 应用安装完成！
pause
goto :eof

:change_ultra_wide_angle
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 下载广角修改文件...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/Active.sav', 'Active.sav')"

echo 正在推送广角文件...
adb push Active.sav /storage/emulated/0/Android/data/com.tencent.tmgp.pubgmhd/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/Active.sav

echo 清理临时文件...
del /f /q Active.sav

echo 广角修改完成，请重启游戏
pause
goto :eof

:clean_device
cls
echo 正在检查设备...
adb devices | find "device" >nul
if errorlevel 1 (
    echo 未检测到已连接的设备
    echo 请确保设备已连接并开启USB调试
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 开始卸载预装应用...
echo.

echo 卸载百度输入法...
adb uninstall com.baidu.input

echo 卸载爱奇艺...
adb uninstall com.qiyi.video.pad

echo 卸载多看阅读...
adb uninstall com.duokan.reader

echo 卸载米家...
adb uninstall com.miui.smarthome

echo 卸载快手...
adb uninstall com.smile.gifmaker

echo 卸载小米云盘...
adb uninstall com.miui.newmidrive

echo 卸载小米会员...
adb uninstall com.xiaomi.vipaccount

echo 卸载小米钱包...
adb uninstall com.mipay.wallet

echo 卸载抖音...
adb uninstall com.ss.android.ugc.aweme

echo 卸载录音机...
adb uninstall com.android.soundrecorder

echo 卸载小米相册...
adb uninstall com.miui.creation

echo.
echo 设备净化完成！
pause
goto :eof

:custom_command
cls
echo ============================
echo 自定义指令执行
echo ============================
echo.
echo 请输入要执行的指令:
echo 1. 输入adb开头的指令将执行adb命令
echo 2. 输入fastboot开头的指令将执行fastboot命令
echo 3. 输入指令0返回主菜单
echo.
set /p cmd=请输入指令: 

if "!cmd!"=="0" goto :start
if /i "!cmd:~0,3!"=="adb" (
    !cmd!
) else if /i "!cmd:~0,8!"=="fastboot" (
    !cmd!
) else (
    echo 无效的指令格式
    timeout /t 2 /nobreak >nul
)
echo.
pause
goto :custom_command

:flash_ksu
cls
echo 检查Fastboot设备...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo 未检测到Fastboot设备！
    echo 请确保设备已进入Fastboot模式！
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 请确保KSU内核文件(boot.img)已放置在当前目录
if exist "boot.img" (
    echo 正在刷入boot.img内核文件...
    fastboot flash boot boot.img
    if errorlevel 1 (
        echo 刷入失败！
        timeout /t 3 /nobreak >nul
        goto :eof
    )
    echo 刷入成功
) else (
    echo 未找到boot.img文件！
    echo 请将KSU内核文件放置在当前目录后重试
)
pause
goto :eof

:flash_system
cls
echo 开始系统刷入...
if exist "flash_all.bat" (
    echo 正在复制必要的依赖文件...
    copy /Y adb.exe flash_all.bat\..\ >nul
    copy /Y adbwinapi.dll flash_all.bat\..\ >nul
    copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
    copy /Y fastboot.exe flash_all.bat\..\ >nul
    
    call flash_all.bat
    
    echo 正在清理临时文件...
    del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
    del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
    del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
    del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
) else (
    echo 未找到flash_all.bat文件！
    echo 请将flash_all.bat放置在当前目录
    timeout /t 3 /nobreak >nul
)
pause
goto :eof

:flash_boot
cls
echo 检查Fastboot设备...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo 未检测到Fastboot设备！
    echo 请确保设备已进入Fastboot模式！
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo 请选择要刷入的分区：
echo 1. init分区
echo 2. boot分区
echo.
set /p partition_choice=请选择分区（1-2）：

if "!partition_choice!"=="1" (
    set "partition=init"
) else if "!partition_choice!"=="2" (
    set "partition=boot"
) else (
    echo 无效的选择
    timeout /t 2 /nobreak >nul
    goto :flash_boot
)

echo 搜索当前目录下的img文件...
echo.
set "count=0"
for %%f in (*.img) do (
    set /a count+=1
    set "file[!count!]=%%f"
    echo !count!. %%f
)

if !count!==0 (
    echo 当前目录下未找到任何img文件！
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo.
set /p choice=请选择要刷入的文件（1-%count%）：

if !choice! leq 0 goto :invalid_choice
if !choice! gtr !count! goto :invalid_choice

echo 正在刷入!partition!分区: !file[%choice%]!
fastboot flash !partition! "!file[%choice%]!"
if errorlevel 1 (
    echo 刷入失败！
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo !partition!分区刷入完成
pause
goto :start

:invalid_choice
echo 无效的选择
timeout /t 2 /nobreak >nul
goto :flash_boot

:invalid_script_choice
echo 无效的选择
timeout /t 2 /nobreak >nul
goto :find_flash_script_and_flash

:reboot_system
cls
echo 检查Fastboot设备...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo 未检测到Fastboot设备！
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo 正在重启系统...
fastboot reboot
echo 设备正在重启，请稍候...
timeout /t 5 /nobreak >nul
goto :eof
