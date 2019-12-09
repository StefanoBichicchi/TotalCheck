@echo off

CHCP 65001
CLS

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

SET /P variable="Controllare File System? [s/n] "
IF "%variable%"=="s" (
    echo Controllo File System
    sfc /scannow
    echo
)

SET /P variable="Controllare integrità Windows? [s/n] "
IF "%variable%"=="s" (
    echo Controllo integrità Windows
    dism /online /cleanup-image /restorehealth
    echo
)

SET /P variable="Controllare errori Hard disk? [s/n] "
IF "%variable%"=="s" (
    echo Controllo errori Hard Disks
    chkdsk C: /spotfix
    chkdsk D: /spotfix
    echo
)

SET /P variable="Controllare integrità RAM? [s/n] "
IF "%variable%"=="s" (
    echo Controllo integrità RAM
    mdsched.exe
    echo
)

pause