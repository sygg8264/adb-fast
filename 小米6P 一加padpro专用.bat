@echo off
setlocal enabledelayedexpansion

title ר������ϵͳ��

:start
cls
echo.
echo ====================================================
echo                ��ʧ����ʥ��  V��sygg8264
echo ====================================================
echo.
echo ============================
echo ��ѡ�������
echo 0. �Զ���ϵͳ��
echo 1. ����1402ϵͳ��
echo 2. ����1405Recϵͳ��
echo 3. ����1409ϵͳ��
echo 4. ����14239ϵͳ��
echo 5. ����14602ϵͳ��
echo ============================

set /p choice=������ѡ�0-5���� 

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
    echo ��Ч��ѡ�������0-5֮������֣�
    timeout /t 2 /nobreak >nul
)
goto :start

:download_system
cls
echo ============================
echo ����ϵͳ��
echo ============================
echo.
if "%choice%"=="0" (
    set /p download_url=��������������: 
    set /p filename=�����뱣����ļ���(������չ��): 
)

if "!download_url!"=="" (
    echo �������Ӳ���Ϊ�գ�
    timeout /t 2 /nobreak >nul
    goto :download_system
)

echo ��ʼ����ϵͳ��...
echo �������ز���...
:: �Ż����ز���������ٶȺ��ȶ���
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
    echo ����ʧ�ܣ������������ӻ����������Ƿ���ȷ��
    echo 3����Զ�����...
    timeout /t 3 /nobreak >nul
    goto :download_system
)

echo.
if "%choice%"=="1" (
    echo 1402ϵͳ��������ɣ�
    echo �ļ�����Ϊ: 1402fast.tgz
) else if "%choice%"=="2" (
    echo 1405Recϵͳ��������ɣ�
    echo �ļ�����Ϊ: 1405Rec.zip
) else if "%choice%"=="3" (
    echo 1409ϵͳ��������ɣ�
    echo �ļ�����Ϊ: 1409fast.tgz
) else if "%choice%"=="4" (
    echo 14239ϵͳ��������ɣ�
    echo �ļ�����Ϊ: 14239.zip
) else if "%choice%"=="5" (
    echo 14602ϵͳ��������ɣ�
    echo �ļ�����Ϊ: 14602.tgz
) else (
    echo ϵͳ��������ɣ�
    echo �ļ�����Ϊ: !filename!
)
pause
goto :eof
