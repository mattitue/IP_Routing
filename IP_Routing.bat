@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  

REM Print out route to indentify interface number.
route print -4 

REM User inputs interface number.
set /p "INTERFACE_NUMBER=(May need to scroll up) What is the first number on the interface list of Realtek adapter? "

REM User inputs router ip adress.
set /p "ROUTER_ADDRESS=What is wireless router address? "

REM User inputs cell ip address	
set /p "CELL_ADDRESS=What is cell address (x.y.z.0)? "

REM Adds route base on strings from user input above
route add -p %CELL_ADDRESS%/24 mask 255.255.255.255 %ROUTER_ADDRESS% "if" %INTERFACE_NUMBER%
	
pause
