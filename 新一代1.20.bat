@echo off
setlocal enabledelayedexpansion

title С��ˢ������

:: �������
echo ��������ļ�...
set missing_files=0

if not exist "AdbWinApi.dll" (
    set /a missing_files+=1
    echo ����AdbWinApi.dll�����ļ�...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/AdbWinApi.dll', 'AdbWinApi.dll')"
)

if not exist "AdbWinUsbApi.dll" (
    set /a missing_files+=1
    echo ����AdbWinUsbApi.dll�����ļ�...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/AdbWinUsbApi.dll', 'AdbWinUsbApi.dll')"
)

if not exist "adb.exe" (
    set /a missing_files+=1
    echo ����adb.exe�����ļ�...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/adb.exe', 'adb.exe')"
)

if not exist "fastboot.exe" (
    set /a missing_files+=1
    echo ����fastboot.exe�����ļ�...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/adb/fastboot.exe', 'fastboot.exe')"
)

if !missing_files! gtr 0 (
    echo �����ļ�������ɣ������Բ���
    timeout /t 3 /nobreak >nul
) else (
    echo ���������ļ��Ѵ��ڣ���������
)


:start
cls
echo.
echo ====================================================
echo                ��ʧ����ʥ��  V��sygg8264
echo ====================================================
echo.
echo ============================
echo ��ѡ�������
echo 1. ��ѯADB �豸�б�
echo 2. ����fastboot 
echo 3. ��ѯfastboot�豸�б�
echo 4. ����fastboot���Զ�ˢ��
echo 5. ����ˢ���ű�
echo 6. ���ܵ��ڲ˵�
echo 7. �����豸
echo 8. �Զ���ָ��
echo 0. �˳�����
echo ============================

set /p choice=������ѡ�0-8���� 

if "%choice%"=="0" (
    echo �����˳�����...
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
    echo ��Ч��ѡ�������0-8��
    timeout /t 2 /nobreak >nul
)
goto :start

:check_adb_devices
cls
echo ���ڼ���豸����״̬...
echo.
echo ADB�豸�б�:
adb devices
echo.
echo Fastboot�豸�б�:
fastboot devices
echo.
echo ����豸δ����ʶ������:
echo 1. USB���Ƿ���������
echo 2. �Ƿ��ѿ���USB����
echo 3. �����Ƿ�����
echo.
pause
goto :eof

:enter_fastboot
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo ����������Fastbootģʽ...
adb reboot bootloader
echo �ȴ��豸����...
timeout /t 10 /nobreak >nul

set "retry_count=0"
:check_fastboot_loop
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo ���ڵȴ��豸����Fastbootģʽ...
    timeout /t 2 /nobreak >nul
    set /a retry_count+=1
    if !retry_count! lss 5 goto check_fastboot_loop
    echo �豸δ�ܳɹ�����Fastbootģʽ��
    echo �룺
    echo 1. USB���������豸
    echo 2. �����Ƿ�����
    echo 3. �ֶ�����Fastbootģʽ
    timeout /t 3 /nobreak >nul
) else (
    echo [��] �ѳɹ�����Fastbootģʽ
)
goto :eof

:enter_fastboot_and_flash
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo ����������Fastbootģʽ...
adb reboot bootloader
echo �ȴ��豸����...
timeout /t 10 /nobreak >nul

fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo �豸δ�ܽ���Fastbootģʽ��
    echo �룺
    echo 1. USB���������豸
    echo 2. �����Ƿ�����
    echo 3. �ֶ�����Fastbootģʽ
    timeout /t 3 /nobreak >nul
) else (
    echo [��] �ѳɹ�����Fastbootģʽ
    if exist "flash_all.bat" (
        echo ���ڸ��Ʊ�Ҫ�������ļ�...
        copy /Y adb.exe flash_all.bat\..\ >nul
        copy /Y adbwinapi.dll flash_all.bat\..\ >nul 
        copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
        copy /Y fastboot.exe flash_all.bat\..\ >nul
        
        echo ��ʼִ��ˢ���ű�...
        call flash_all.bat
        
        echo ����������ʱ�ļ�...
        del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
        del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
        del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
        del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
    ) else (
        echo δ�ҵ�flash_all.bat�ļ���
        echo �뽫flash_all.bat�����ڵ�ǰĿ¼
        timeout /t 3 /nobreak >nul
    )
)
goto :eof

:check_fastboot_devices
cls
echo ���ڼ��Fastboot�豸...
echo.
echo Fastboot�豸�б�:
fastboot devices
echo.
set "device_found="
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo [!] δ��⵽Fastboot�豸
    echo.
    echo ����:
    echo 1. ���²���豸USB
    echo 2. �Ƿ����Fastbootģʽ
    echo 3. �����Ƿ�����
) else (
    echo [��] ��⵽Fastboot�豸
    echo.
    echo �豸�����ӣ����Խ������²���
    echo.
    echo ============================
    echo ��ѡ�������
    echo 1. ȫ��ˢ��
    echo 2. ˢ��boot
    echo 3. ������ϵͳ
    echo 0. �������˵�
    echo ============================
    
    set /p flash_choice=������ѡ�0-3����
    
    if "!flash_choice!"=="1" (
        if exist "flash_all.bat" (
            echo ���ڸ��Ʊ�Ҫ�������ļ�...
            copy /Y adb.exe flash_all.bat\..\ >nul
            copy /Y adbwinapi.dll flash_all.bat\..\ >nul
            copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
            copy /Y fastboot.exe flash_all.bat\..\ >nul
            
            call flash_all.bat
            
            echo ����������ʱ�ļ�...
            del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
            del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
            del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
            del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
        ) else (
            echo δ�ҵ�flash_all.bat�ļ���
            echo �뽫flash_all.bat�����ڵ�ǰĿ¼
            timeout /t 3 /nobreak >nul
        )
    ) else if "!flash_choice!"=="2" (
        call :flash_boot
    ) else if "!flash_choice!"=="3" (
        fastboot reboot
    ) else if "!flash_choice!"=="0" (
        goto :start
    ) else (
        echo ��Ч��ѡ��
        timeout /t 2 /nobreak >nul
    )
)
echo.
pause
goto :eof

:find_flash_script_and_flash
cls
echo ��������ˢ����...
echo.

:: �����ڿ��ܵ��ļ����в���
set "found=0"
for /f "delims=" %%i in ('dir /s /b /ad "*fastboot*" "*images*" 2^>nul') do (
    if exist "%%i\flash_all.bat" (
        set /a found+=1
        set "flash_path[!found!]=%%i\flash_all.bat"
        echo !found!. %%i\flash_all.bat
    )
)

:: ������ض��ļ�����δ�ҵ�����������λ�ò���flash_all.bat
if !found!==0 (
    for /f "delims=" %%i in ('dir /s /b flash_all.bat 2^>nul') do (
        set /a found+=1
        set "flash_path[!found!]=%%i"
        echo !found!. %%i
    )
)

if !found!==0 (
    echo [!] δ�ҵ��κ�ˢ����
    echo ���飺
    echo 1. ˢ�����Ƿ��ѹ
    echo 2. �Ƿ����flash_all.bat�ļ�
    pause
    goto :start
)

echo.
echo ���ҵ�!found!��ˢ����
set /p script_choice=��ѡ��Ҫʹ�õ�ˢ������1-!found!��������0���أ�

if !script_choice! equ 0 goto :start
if !script_choice! leq 0 goto :invalid_script_choice
if !script_choice! gtr !found! goto :invalid_script_choice

echo.
echo ��ѡ��ˢ����: !flash_path[%script_choice%]!
echo.
echo [����] ˢ�����ܻ�����豸���ݣ�
echo 1. ����ǰ������Ҫ����
echo 2. ȷ���豸������50%����
echo 3. ����USB�ȶ�����
echo.
set /p flash_confirm=�Ƿ����ִ��ˢ��(Y/N)��

if /i "!flash_confirm!"=="Y" (
    echo ����������Fastbootģʽ...
    adb reboot bootloader
    echo �ȴ��豸����...
    timeout /t 10 /nobreak >nul

    :: ����豸
    echo ���ڼ���豸...
    
    fastboot devices | find "fastboot" >nul
    if errorlevel 1 (
        echo [!] δ��⵽�豸
        echo ���飺
        echo 1. ��������USB
        echo 2. USB���Ƿ�����
        echo 3. ����USB�ӿ�
        pause
        goto :start
    )

    :: �л���ˢ����Ŀ¼
    pushd "!flash_path[%script_choice%]!\..\"
    
    echo [��] �ѽ���Fastbootģʽ
    echo.
    echo ˢ������Ԥ����Ҫ5-10����
    echo �뱣���豸���Ӳ���Ͽ�USB
    echo.
    
    :: ���������ļ�
    echo ���ڸ��Ʊ�Ҫ�������ļ�...
    copy /Y "%~dp0adb.exe" . >nul
    copy /Y "%~dp0adbwinapi.dll" . >nul
    copy /Y "%~dp0adbwinusbapi.dll" . >nul
    copy /Y "%~dp0fastboot.exe" . >nul
    
    :: ִ��ˢ��
    echo ��ʼִ��ˢ��...
    call flash_all.bat
    if errorlevel 1 (
        echo [!] ˢ��ʧ�ܣ�
        echo �����豸���Ӳ�����
    ) else (
        echo [��] ˢ����ɣ�
        echo �豸��������...
    )
    
    :: �����ļ�
    echo ����������ʱ�ļ�...
    del /F /Q adb.exe >nul 2>&1
    del /F /Q adbwinapi.dll >nul 2>&1
    del /F /Q adbwinusbapi.dll >nul 2>&1
    del /F /Q fastboot.exe >nul 2>&1
    
    popd
) else (
    echo ��ȡ��ˢ������
    timeout /t 2 /nobreak >nul
    goto :start
)

goto :start

:performance_menu
cls
echo ============================
echo ���ܵ��ڲ˵�ѡ�
echo 1. ���ز���װ�������
echo 2. �޸Ĺ��
echo 0. �������˵�
echo ============================

set /p perf_choice=������ѡ�0-2����

if "!perf_choice!"=="1" (
    call :download_and_install_apps
) else if "!perf_choice!"=="2" (
    call :change_ultra_wide_angle
) else if "!perf_choice!"=="0" (
    goto :start
) else (
    echo ��Ч��ѡ��
    timeout /t 2 /nobreak >nul
    goto :performance_menu
)
goto :performance_menu

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

echo ��ʼ����Ӧ�ó���...
echo.
echo ����MT������...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://pan.mt2.cn/mt/MT2.17.3.apk', 'MT2.17.3.apk')"

echo ����SCene8...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/sc8.apk', 'sc8.apk')"

echo ����Smark...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/smark.apk', 'smark.apk')"

echo ����KernelSU...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/KernelSU_v1.0.2_11986-release.apk', 'KernelSU.apk')"

echo.
echo ��ʼ��װӦ��...
echo.
echo ��װMT������...
adb install MT2.17.3.apk

echo ��װSC8...
adb install sc8.apk

echo ��װSmark...
adb install smark.apk

echo ��װKernelSU...
adb install KernelSU.apk

echo.
echo ������ʱ�ļ�...
del /f /q MT2.17.3.apk
del /f /q sc8.apk
del /f /q smark.apk
del /f /q KernelSU.apk

echo.
echo Ӧ�ð�װ��ɣ�
pause
goto :eof

:change_ultra_wide_angle
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ���ع���޸��ļ�...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://oss.lsy.lat/Active.sav', 'Active.sav')"

echo �������͹���ļ�...
adb push Active.sav /storage/emulated/0/Android/data/com.tencent.tmgp.pubgmhd/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/Active.sav

echo ������ʱ�ļ�...
del /f /q Active.sav

echo ����޸���ɣ���������Ϸ
pause
goto :eof

:clean_device
cls
echo ���ڼ���豸...
adb devices | find "device" >nul
if errorlevel 1 (
    echo δ��⵽�����ӵ��豸
    echo ��ȷ���豸�����Ӳ�����USB����
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ��ʼж��ԤװӦ��...
echo.

echo ж�ذٶ����뷨...
adb uninstall com.baidu.input

echo ж�ذ�����...
adb uninstall com.qiyi.video.pad

echo ж�ض࿴�Ķ�...
adb uninstall com.duokan.reader

echo ж���׼�...
adb uninstall com.miui.smarthome

echo ж�ؿ���...
adb uninstall com.smile.gifmaker

echo ж��С������...
adb uninstall com.miui.newmidrive

echo ж��С�׻�Ա...
adb uninstall com.xiaomi.vipaccount

echo ж��С��Ǯ��...
adb uninstall com.mipay.wallet

echo ж�ض���...
adb uninstall com.ss.android.ugc.aweme

echo ж��¼����...
adb uninstall com.android.soundrecorder

echo ж��С�����...
adb uninstall com.miui.creation

echo.
echo �豸������ɣ�
pause
goto :eof

:custom_command
cls
echo ============================
echo �Զ���ָ��ִ��
echo ============================
echo.
echo ������Ҫִ�е�ָ��:
echo 1. ����adb��ͷ��ָ�ִ��adb����
echo 2. ����fastboot��ͷ��ָ�ִ��fastboot����
echo 3. ����ָ��0�������˵�
echo.
set /p cmd=������ָ��: 

if "!cmd!"=="0" goto :start
if /i "!cmd:~0,3!"=="adb" (
    !cmd!
) else if /i "!cmd:~0,8!"=="fastboot" (
    !cmd!
) else (
    echo ��Ч��ָ���ʽ
    timeout /t 2 /nobreak >nul
)
echo.
pause
goto :custom_command

:flash_ksu
cls
echo ���Fastboot�豸...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo δ��⵽Fastboot�豸��
    echo ��ȷ���豸�ѽ���Fastbootģʽ��
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ��ȷ��KSU�ں��ļ�(boot.img)�ѷ����ڵ�ǰĿ¼
if exist "boot.img" (
    echo ����ˢ��boot.img�ں��ļ�...
    fastboot flash boot boot.img
    if errorlevel 1 (
        echo ˢ��ʧ�ܣ�
        timeout /t 3 /nobreak >nul
        goto :eof
    )
    echo ˢ��ɹ�
) else (
    echo δ�ҵ�boot.img�ļ���
    echo �뽫KSU�ں��ļ������ڵ�ǰĿ¼������
)
pause
goto :eof

:flash_system
cls
echo ��ʼϵͳˢ��...
if exist "flash_all.bat" (
    echo ���ڸ��Ʊ�Ҫ�������ļ�...
    copy /Y adb.exe flash_all.bat\..\ >nul
    copy /Y adbwinapi.dll flash_all.bat\..\ >nul
    copy /Y adbwinusbapi.dll flash_all.bat\..\ >nul
    copy /Y fastboot.exe flash_all.bat\..\ >nul
    
    call flash_all.bat
    
    echo ����������ʱ�ļ�...
    del /F /Q flash_all.bat\..\adb.exe >nul 2>&1
    del /F /Q flash_all.bat\..\adbwinapi.dll >nul 2>&1
    del /F /Q flash_all.bat\..\adbwinusbapi.dll >nul 2>&1
    del /F /Q flash_all.bat\..\fastboot.exe >nul 2>&1
) else (
    echo δ�ҵ�flash_all.bat�ļ���
    echo �뽫flash_all.bat�����ڵ�ǰĿ¼
    timeout /t 3 /nobreak >nul
)
pause
goto :eof

:flash_boot
cls
echo ���Fastboot�豸...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo δ��⵽Fastboot�豸��
    echo ��ȷ���豸�ѽ���Fastbootģʽ��
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo ��ѡ��Ҫˢ��ķ�����
echo 1. init����
echo 2. boot����
echo.
set /p partition_choice=��ѡ�������1-2����

if "!partition_choice!"=="1" (
    set "partition=init"
) else if "!partition_choice!"=="2" (
    set "partition=boot"
) else (
    echo ��Ч��ѡ��
    timeout /t 2 /nobreak >nul
    goto :flash_boot
)

echo ������ǰĿ¼�µ�img�ļ�...
echo.
set "count=0"
for %%f in (*.img) do (
    set /a count+=1
    set "file[!count!]=%%f"
    echo !count!. %%f
)

if !count!==0 (
    echo ��ǰĿ¼��δ�ҵ��κ�img�ļ���
    timeout /t 3 /nobreak >nul
    goto :eof
)

echo.
set /p choice=��ѡ��Ҫˢ����ļ���1-%count%����

if !choice! leq 0 goto :invalid_choice
if !choice! gtr !count! goto :invalid_choice

echo ����ˢ��!partition!����: !file[%choice%]!
fastboot flash !partition! "!file[%choice%]!"
if errorlevel 1 (
    echo ˢ��ʧ�ܣ�
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo !partition!����ˢ�����
pause
goto :start

:invalid_choice
echo ��Ч��ѡ��
timeout /t 2 /nobreak >nul
goto :flash_boot

:invalid_script_choice
echo ��Ч��ѡ��
timeout /t 2 /nobreak >nul
goto :find_flash_script_and_flash

:reboot_system
cls
echo ���Fastboot�豸...
fastboot devices | find "fastboot" >nul
if errorlevel 1 (
    echo δ��⵽Fastboot�豸��
    timeout /t 3 /nobreak >nul
    goto :eof
)
echo ��������ϵͳ...
fastboot reboot
echo �豸�������������Ժ�...
timeout /t 5 /nobreak >nul
goto :eof
