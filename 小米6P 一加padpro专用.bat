@echo off
setlocal enabledelayedexpansion

title 专用下载系统包

:start
cls
echo.
echo ====================================================
echo                消失的老圣佑  V：sygg8264
echo ====================================================
echo.
echo ============================
echo 请选择操作：
echo 0. 自定义系统包
echo 1. 下载1402系统包
echo 2. 下载1405Rec系统包
echo 3. 下载1409系统包
echo 4. 下载14239系统包
echo 5. 下载14602系统包
echo ============================

set /p choice=请输入选项（0-5）： 

if "%choice%"=="0" (
    call :download_system
) else if "%choice%"=="1" (
    set "download_url=https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V14.0.2.0.TMYCNXM/liuqin_images_V14.0.2.0.TMYCNXM_20230411.0000.00_13.0_cn_a3e7f3b440.tgz"
    call :download_system
) else if "%choice%"=="2" (
    set "download_url=https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V14.0.5.0.TMYCNXM/miui_LIUQIN_V14.0.5.0.TMYCNXM_e266871c8a_13.0.zip"
    call :download_system
) else if "%choice%"=="3" (
    set "download_url=https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V14.0.9.0.TMYCNXM/liuqin_images_V14.0.9.0.TMYCNXM_20230907.0000.00_13.0_cn_58bf72f5e6.tgz"
    call :download_system
) else if "%choice%"=="4" (
    set "download_url=https://gauss-componentotacostmanual-cn.allawnfs.com/remove-08a6d906f67b42658e7338222f2f681e/component-ota/24/07/23/61256489f7e141c8969add4eaeb60242.zip"
    call :download_system
) else if "%choice%"=="5" (
    set "download_url=https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/V14.0.9.0.TMYCNXM/liuqin_images_V14.0.9.0.TMYCNXM_20230907.0000.00_13.0_cn_58bf72f5e6.tgz"
    call :download_system
) else (
    echo 无效的选项，请输入0-5之间的数字！
    timeout /t 2 /nobreak >nul
)
goto :start

:download_system
cls
echo ============================
echo 下载系统包
echo ============================
echo.
if "%choice%"=="0" (
    set /p download_url=请输入下载链接: 
    set /p filename=请输入保存的文件名(包含扩展名): 
)

if "!download_url!"=="" (
    echo 下载链接不能为空！
    timeout /t 2 /nobreak >nul
    goto :download_system
)

echo 开始下载系统包...
echo 配置下载参数...
:: 优化下载参数以提高速度和稳定性
if "%choice%"=="1" (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o 1402fast.tgz
) else if "%choice%"=="2" (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o 1405Rec.zip
) else if "%choice%"=="3" (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o 1409fast.tgz
) else if "%choice%"=="4" (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o 14239.zip
) else if "%choice%"=="5" (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o 14602.tgz
) else (
    aria2c.exe --split=32 --max-connection-per-server=16 --min-split-size=1M --disk-cache=64M ^
        --continue=true --max-tries=5 --retry-wait=3 --connect-timeout=60 --timeout=60 ^
        --max-concurrent-downloads=5 --file-allocation=none --optimize-concurrent-downloads=true ^
        --auto-file-renaming=true --allow-overwrite=true --conditional-get=true ^
        "!download_url!" -o "!filename!"
)

if %errorlevel% neq 0 (
    echo 下载失败，请检查网络连接或下载链接是否正确！
    echo 3秒后自动重试...
    timeout /t 3 /nobreak >nul
    goto :download_system
)

echo.
if "%choice%"=="1" (
    echo 1402系统包下载完成！
    echo 文件保存为: 1402fast.tgz
) else if "%choice%"=="2" (
    echo 1405Rec系统包下载完成！
    echo 文件保存为: 1405Rec.zip
) else if "%choice%"=="3" (
    echo 1409系统包下载完成！
    echo 文件保存为: 1409fast.tgz
) else if "%choice%"=="4" (
    echo 14239系统包下载完成！
    echo 文件保存为: 14239.zip
) else if "%choice%"=="5" (
    echo 14602系统包下载完成！
    echo 文件保存为: 14602.tgz
) else (
    echo 系统包下载完成！
    echo 文件保存为: !filename!
)
pause
goto :eof
