@echo off
setlocal

REM Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Paths to replacement DLL files within MinecraftBedrockUnlocker structure
set "newFileSystem32=%~dp0Files\system32\windows.applicationmodel.store.dll"
set "newFileSysWOW64=%~dp0Files\SysWOW64\windows.applicationmodel.store.dll"

REM Paths to System32 and SysWOW64 DLL locations
set "targetFileSystem32=%windir%\System32\windows.applicationmodel.store.dll"
set "targetFileSysWOW64=%windir%\SysWOW64\windows.applicationmodel.store.dll"

REM Display menu
echo ===============================
echo Select an option:
echo [1] Replace in System32 only
echo [2] Replace in SysWOW64 only
echo [3] Replace in both System32 and SysWOW64
echo ===============================
set /p "choice=Enter your choice (1-3): "

REM Function to replace DLL in a given folder
:ReplaceFile
    set "newFile=%1"
    set "targetFile=%2"

    echo Taking ownership of %targetFile%
    takeown /f "%targetFile%" /a
    icacls "%targetFile%" /grant administrators:F /t

    echo Deleting the original DLL from %targetFile%
    del /f /q "%targetFile%"

    echo Copying the new file from %newFile% to %targetFile%
    copy "%newFile%" "%targetFile%"

    echo Resetting ownership and permissions for %targetFile%
    icacls "%targetFile%" /setowner "NT SERVICE\TrustedInstaller" /c /l /q
    icacls "%targetFile%" /grant:r SYSTEM:(RX)

    echo Replacement complete for %targetFile%
goto :eof

REM Execute based on user choice
if "%choice%"=="1" (
    call :ReplaceFile "%newFileSystem32%" "%targetFileSystem32%"
) else if "%choice%"=="2" (
    call :ReplaceFile "%newFileSysWOW64%" "%targetFileSysWOW64%"
) else if "%choice%"=="3" (
    call :ReplaceFile "%newFileSystem32%" "%targetFileSystem32%"
    call :ReplaceFile "%newFileSysWOW64%" "%targetFileSysWOW64%"
) else (
    echo Invalid choice. Exiting.
    exit /b
)

echo All operations completed.
pause
