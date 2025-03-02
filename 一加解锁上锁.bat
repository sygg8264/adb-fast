@echo off


title 一加手机刷机工具

:menu
cls
echo ====== 一加手机刷机工具 ======
echo [1] 解锁Bootloader
echo [2] 上锁Bootloader
echo [3] 退出程序
echo.
set /p "choice=请选择操作 [1-3]: "

if "%choice%"=="1" goto unlock
if "%choice%"=="2" goto lock  
if "%choice%"=="3" exit /b
echo [错误] 无效的选择，请重试！
timeout /t 2 >nul
goto menu

:unlock
cls
echo ====== 解锁Bootloader ======
echo [信息] 请确保:
echo  1. 手机已开启开发者选项和OEM解锁
echo  2. 手机已进入Fastboot模式
echo  3. 手机已正确连接电脑
echo.
echo [警告] 解锁Bootloader将清除手机所有数据！
echo.
set /p "confirm=是否继续？(Y/N): "
if /i "%confirm%"=="y" (
    echo.
    echo [信息] 正在解锁Bootloader...
    fastboot flashing unlock
    if %errorlevel% equ 0 (
        echo [成功] Bootloader解锁完成！
    ) else (
        echo [错误] Bootloader解锁失败！
    )
) else (
    echo [信息] 已取消操作
)
echo.
pause
goto menu

:lock
cls
echo ====== 上锁Bootloader ======
echo [信息] 请确保:
echo  1. 手机已进入Fastboot模式
echo  2. 手机已正确连接电脑
echo.
echo [警告] 上锁Bootloader将清除手机所有数据！
echo.
set /p "confirm=是否继续？(Y/N): "
if /i "%confirm%"=="y" (
    echo.
    echo [信息] 正在上锁Bootloader...
    fastboot flashing lock
    if %errorlevel% equ 0 (
        echo [成功] Bootloader上锁完成！
    ) else (
        echo [错误] Bootloader上锁失败！
    )
) else (
    echo [信息] 已取消操作
)
echo.
pause
goto menu
