@echo off


title һ���ֻ�ˢ������

:menu
cls
echo ====== һ���ֻ�ˢ������ ======
echo [1] ����Bootloader
echo [2] ����Bootloader
echo [3] �˳�����
echo.
set /p "choice=��ѡ����� [1-3]: "

if "%choice%"=="1" goto unlock
if "%choice%"=="2" goto lock  
if "%choice%"=="3" exit /b
echo [����] ��Ч��ѡ�������ԣ�
timeout /t 2 >nul
goto menu

:unlock
cls
echo ====== ����Bootloader ======
echo [��Ϣ] ��ȷ��:
echo  1. �ֻ��ѿ���������ѡ���OEM����
echo  2. �ֻ��ѽ���Fastbootģʽ
echo  3. �ֻ�����ȷ���ӵ���
echo.
echo [����] ����Bootloader������ֻ��������ݣ�
echo.
set /p "confirm=�Ƿ������(Y/N): "
if /i "%confirm%"=="y" (
    echo.
    echo [��Ϣ] ���ڽ���Bootloader...
    fastboot flashing unlock
    if %errorlevel% equ 0 (
        echo [�ɹ�] Bootloader������ɣ�
    ) else (
        echo [����] Bootloader����ʧ�ܣ�
    )
) else (
    echo [��Ϣ] ��ȡ������
)
echo.
pause
goto menu

:lock
cls
echo ====== ����Bootloader ======
echo [��Ϣ] ��ȷ��:
echo  1. �ֻ��ѽ���Fastbootģʽ
echo  2. �ֻ�����ȷ���ӵ���
echo.
echo [����] ����Bootloader������ֻ��������ݣ�
echo.
set /p "confirm=�Ƿ������(Y/N): "
if /i "%confirm%"=="y" (
    echo.
    echo [��Ϣ] ��������Bootloader...
    fastboot flashing lock
    if %errorlevel% equ 0 (
        echo [�ɹ�] Bootloader������ɣ�
    ) else (
        echo [����] Bootloader����ʧ�ܣ�
    )
) else (
    echo [��Ϣ] ��ȡ������
)
echo.
pause
goto menu
