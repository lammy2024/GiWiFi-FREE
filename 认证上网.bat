@echo off
setlocal enabledelayedexpansion
goto :main

::检测区=============================================
::检查外部网络连接状态
:checkOutsideInternet
ping www.baidu.com -n 1 > nul
if errorlevel 1 (
    set "result=外部网络：未联网"
    color 4
) else (
    set "result=外部网络：已联网"
    color 2
)
goto :eof

::检查校园网认证网络连接状态
:checkInsideInternet
ping as.gwifi.com.cn -n 1 > nul
if errorlevel 1 (
    set "result=校园网认证网络：未联网"
) else (
    set "result=校园网认证网络：已联网"
)
goto :eof

::修改区=============================================
::修改MAC地址
:changeMacAddress
    set a=012345789ABCDEF
    set dew=26AE
    set /a d2=%random%%%3+1
    set /a b=%random%%%14+1
    set /a c=%random%%%14+1
    set /a d=%random%%%14+1
    set /a e=%random%%%14+1
    set /a f=%random%%%14+1
    set /a g=%random%%%14+1
    set /a h=%random%%%14+1
    set /a i=%random%%%14+1
    set /a j=%random%%%14+1
    set /a k=%random%%%14+1
    set /a l=%random%%%14+1
    set /a m=%random%%%14+1
    set MAC=!a:~%b%,1!!dew:~%d2%,1!-!a:~%d%,1!!a:~%e%,1!-!a:~%f%,1!!a:~%g%,1!-!a:~%h%,1!!a:~%i%,1!-!a:~%j%,1!!a:~%k%,1!-!a:~%l%,1!!a:~%m%,1!
    set "adapter_name=WLAN"
    set "network_name=LNSF-GiWiFi-5G"
    :: Change MAC address
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0011" /v NetworkAddress /t REG_SZ /d %MAC% /f
    ::这里的注册表的“0011”需要按照自己实际的情况进行修改
    :: Restart network adapter
    netsh interface set interface "%adapter_name%" admin=disable
    timeout /t 5
    netsh interface set interface "%adapter_name%" admin=enable
    timeout /t 5
    :: Connect to WiFi
    netsh wlan connect name="%network_name%"
    goto :eof

::重新获取IP地址
:renewIP
    ipconfig /release WLAN
    ipconfig /renew WLAN
    goto :eof

::启动挂起脚本
:HangUp
cd /d "%~dp0"
tasklist /FI "IMAGENAME eq HangUp.exe" 2>NUL | find /I /N "HangUp.exe">NUL
if "%ERRORLEVEL%"=="1" call "HangUp.exe"
goto :eof

::认证
:Verify
    echo 正在尝试认证上网...
    call :HangUp
    goto :eof

::Mac地址修改
:Mac_Change
    echo 正在尝试修改MAC地址...
    getmac
    call :changeMacAddress
    cls
    echo MAC地址修改成功,正在测试网络连接...
    call :checkOutsideInternet
    if "!result!"=="外部网络：已联网" (
        echo 已联网！
        set "attempt=1"
        goto :Verify_Loop
    )
    echo MAC地址修改成功,未联网，正在重新获取IP地址...
    timeout /t 10
    call :renewIP
    getmac
    cls
    echo IP地址修改成功,正在尝试认证上网...
    set "attempt=1"
    goto :Verify_Loop

:CheckNet
    echo 正在检查认证结果...
    call :checkOutsideInternet
    if "!result!"=="外部网络：已联网" (
        cls
        echo     ##### ##   ##  # ##   ##### ##           ##### #####   #####  #####
        echo   ##     ##  ##  ## ##  ##     ##          ##    ##  ##  ##     ##
        echo   ##     ##  ##  ## ##  ##     ##          ##    ## ##   ##     ##
        echo  ### ## ##  #   ## ##  #####  ##   ###### ##### #####   #####  #####
        echo  ##  ## ##  ### ## ##  ##     ##          ##    ####    ##     ##
        echo  ##  ##  ## ######  ## ##      ##         ##    ##  ##  ##     ##
        echo ######  ## ##  ##  ## ##      ##         ##    ##   ## ###### ######
        echo ================GiWiFi-FREE================
        call :checkOutsideInternet
        echo =             !result!            = 
        call :checkInsideInternet
        echo =          !result!         = 
        echo ===========================================
        echo =             认证成功,已联网             =
        echo ===========================================
        timeout /t 2
        set "attempt=1"
        goto :CheckNet
    )
        cls
        echo     ##### ##   ##  # ##   ##### ##           ##### #####   #####  #####
        echo   ##     ##  ##  ## ##  ##     ##          ##    ##  ##  ##     ##
        echo   ##     ##  ##  ## ##  ##     ##          ##    ## ##   ##     ##
        echo  ### ## ##  #   ## ##  #####  ##   ###### ##### #####   #####  #####
        echo  ##  ## ##  ### ## ##  ##     ##          ##    ####    ##     ##
        echo  ##  ##  ## ######  ## ##      ##         ##    ##  ##  ##     ##
        echo ######  ## ##  ##  ## ##      ##         ##    ##   ## ###### ######
        echo ================GiWiFi-FREE================
        echo ===========================================
        echo =             认证失败,未联网             =
        echo ===========================================
    set /a "attempt+=1"
    if !attempt! lss !maxAttempts! goto Verify_Loop
    echo 认证失败
    call :Mac_Change
    set "attempt=1"
    goto :Verify_Loop

::认证循环
:Verify_Loop
    set "maxAttempts=6"
    call :Verify
    echo 第%attempt%/5次尝试认证
    call :CheckNet
    goto :eof  :: Exit the loop after max attempts

::主程序=============================================
:main
title GIWiFi-FREE Version:1.0 Auth:Lammy
echo     ##### ##   ##  # ##   ##### ##           ##### #####   #####  #####
echo   ##     ##  ##  ## ##  ##     ##          ##    ##  ##  ##     ##
echo   ##     ##  ##  ## ##  ##     ##          ##    ## ##   ##     ##
echo  ### ## ##  #   ## ##  #####  ##   ###### ##### #####   #####  #####
echo  ##  ## ##  ### ## ##  ##     ##          ##    ####    ##     ##
echo  ##  ##  ## ######  ## ##      ##         ##    ##  ##  ##     ##
echo ######  ## ##  ##  ## ##      ##         ##    ##   ## ###### ######
echo .
echo ================GiWiFi-FREE================
echo =             正在检测网络环境            =
call :checkOutsideInternet
echo =             !result!            = 
call :checkInsideInternet
echo =          !result!         = 
if "!result!"=="校园网认证网络：未联网" (
    echo 正在尝试连接校园网认证网络...
    netsh wlan connect name="GiWiFi-5G"
    ::这里的“GiWiFi-5G”需要按照自己实际的情况进行修改
    timeout /t 5
    call :checkInsideInternet
    echo !result!
    if "!result!"=="校园网认证网络：未联网" (
        echo 连接校园网认证网络失败，请手动连接
        pause
        exit
    )
)
echo ===========================================
echo =     检测完毕，下面开始运行上网认证脚本  =
echo ===========================================
set "maxAttempts=6"
set "attempt=1"
goto Verify_Loop


pause