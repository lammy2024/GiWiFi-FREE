@echo off
setlocal enabledelayedexpansion
goto :main

::�����=============================================
::����ⲿ��������״̬
:checkOutsideInternet
ping www.baidu.com -n 1 > nul
if errorlevel 1 (
    set "result=�ⲿ���磺δ����"
    color 4
) else (
    set "result=�ⲿ���磺������"
    color 2
)
goto :eof

::���У԰����֤��������״̬
:checkInsideInternet
ping as.gwifi.com.cn -n 1 > nul
if errorlevel 1 (
    set "result=У԰����֤���磺δ����"
) else (
    set "result=У԰����֤���磺������"
)
goto :eof

::�޸���=============================================
::�޸�MAC��ַ
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
    ::�����ע���ġ�0011����Ҫ�����Լ�ʵ�ʵ���������޸�
    :: Restart network adapter
    netsh interface set interface "%adapter_name%" admin=disable
    timeout /t 5
    netsh interface set interface "%adapter_name%" admin=enable
    timeout /t 5
    :: Connect to WiFi
    netsh wlan connect name="%network_name%"
    goto :eof

::���»�ȡIP��ַ
:renewIP
    ipconfig /release WLAN
    ipconfig /renew WLAN
    goto :eof

::��������ű�
:HangUp
cd /d "%~dp0"
tasklist /FI "IMAGENAME eq HangUp.exe" 2>NUL | find /I /N "HangUp.exe">NUL
if "%ERRORLEVEL%"=="1" call "HangUp.exe"
goto :eof

::��֤
:Verify
    echo ���ڳ�����֤����...
    call :HangUp
    goto :eof

::Mac��ַ�޸�
:Mac_Change
    echo ���ڳ����޸�MAC��ַ...
    getmac
    call :changeMacAddress
    cls
    echo MAC��ַ�޸ĳɹ�,���ڲ�����������...
    call :checkOutsideInternet
    if "!result!"=="�ⲿ���磺������" (
        echo ��������
        set "attempt=1"
        goto :Verify_Loop
    )
    echo MAC��ַ�޸ĳɹ�,δ�������������»�ȡIP��ַ...
    timeout /t 10
    call :renewIP
    getmac
    cls
    echo IP��ַ�޸ĳɹ�,���ڳ�����֤����...
    set "attempt=1"
    goto :Verify_Loop

:CheckNet
    echo ���ڼ����֤���...
    call :checkOutsideInternet
    if "!result!"=="�ⲿ���磺������" (
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
        echo =             ��֤�ɹ�,������             =
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
        echo =             ��֤ʧ��,δ����             =
        echo ===========================================
    set /a "attempt+=1"
    if !attempt! lss !maxAttempts! goto Verify_Loop
    echo ��֤ʧ��
    call :Mac_Change
    set "attempt=1"
    goto :Verify_Loop

::��֤ѭ��
:Verify_Loop
    set "maxAttempts=6"
    call :Verify
    echo ��%attempt%/5�γ�����֤
    call :CheckNet
    goto :eof  :: Exit the loop after max attempts

::������=============================================
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
echo =             ���ڼ�����绷��            =
call :checkOutsideInternet
echo =             !result!            = 
call :checkInsideInternet
echo =          !result!         = 
if "!result!"=="У԰����֤���磺δ����" (
    echo ���ڳ�������У԰����֤����...
    netsh wlan connect name="GiWiFi-5G"
    ::����ġ�GiWiFi-5G����Ҫ�����Լ�ʵ�ʵ���������޸�
    timeout /t 5
    call :checkInsideInternet
    echo !result!
    if "!result!"=="У԰����֤���磺δ����" (
        echo ����У԰����֤����ʧ�ܣ����ֶ�����
        pause
        exit
    )
)
echo ===========================================
echo =     �����ϣ����濪ʼ����������֤�ű�  =
echo ===========================================
set "maxAttempts=6"
set "attempt=1"
goto Verify_Loop


pause