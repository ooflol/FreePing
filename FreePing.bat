@echo off
title FreePing By ExplicitEdits
CLS
color a
ECHO  FreePing 2.0
ECHO 1. Optimize Minecraft (Less Lag)
ECHO 2. Optimize Valorant (Less Lag)
ECHO 3. Optimize your Internet using Cloudflare's DNS servers (Less Lag)
ECHO 4. Optimize your Internet using Google's DNS servers (Worse cloudflare)
ECHO 5. Exit
ECHO.

CHOICE /C 12345 /M "Enter A Number: "

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO Exit
IF ERRORLEVEL 4 GOTO GoogleDNS
IF ERRORLEVEL 3 GOTO CloudflareDNS
IF ERRORLEVEL 2 GOTO Valorant
IF ERRORLEVEL 1 GOTO Minecraft

:minecraft
cls
:admincheck
if not "%1"=="am_admin" (
    title Requesting admin permissions...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

:optimize
cls
echo Setting svchost process to idle...
wmic process where name="svchost.exe" CALL setpriority "idle"
cls
echo Pinging localhost...
ping 127.0.0.1 -n 5 >nul
cls
echo Setting Minecraft's processes to high priority...
wmic process where name="javaw.exe" CALL setpriority "realtime priority"
wmic process where name="javaw.exe" CALL setpriority "realtime priority"
cls
echo Flushing DNS...
echo *This will change your IP address only if you have a dynamic IP address, nothing else will be changed*
timeout 1 /nobreak > nul
ipconfig /flushdns
cls
title Finished
echo Finished optimizing your PC, enjoy!
sc start BITS
goto Exit


:Valorant
cls
:admincheck
if not "%1"=="am_admin" (
    title Requesting admin permissions...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)
title Fortnite
cls
echo Setting Fortnite's processes to high priority...
wmic process where name="VALORANT.exe" CALL setpriority "realtime priority"
wmic process where name="VALORANT-Win64-Shipping.exe" CALL setpriority "realtime priority"
cls
echo Setting svchost process to idle...
wmic process where name="svchost.exe" CALL setpriority "idle"
echo Flushing DNS...
echo *This will change your IP address only if you have a dynamic IP address, nothing else will be changed*
timeout 1 /nobreak > nul
ipconfig /flushdns
cls
echo Pinging localhost...
ping 127.0.0.1 -n 5 >nul
cls
title Finished
echo Finished optimizing your PC, enjoy!
sc start BITS
goto Exit

:CloudflareDNS
cls
title FreePing - Cloudflare DNS
if not "%1"=="am_admin" (
    title Latenzy - Requesting admin permissions...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)
title Cloudflare DNS
CLS
echo Please input the name of your network adapter here (ex: "Wi-Fi")
echo You can open the Performance tab in Task Manager to find out.
set /p adapterName="Network adapter name: "
cls
FOR /F "tokens=* delims=:" %%a IN ('IPCONFIG ^| FIND /I "ETHERNET ADAPTER"') DO (
SET adapterName=%%a
 
REM Removes "Ethernet adapter" from the front of the adapter name
SET adapterName=!adapterName:~17!
 
REM WinXP Remove some weird trailing chars (dunno what they are)
FOR /l %%a IN (1,1,255) DO IF NOT "!adapterName:~-1!"==":" SET adapterName=!adapterName:~0,-1!
 
REM Removes the colon from the end of the adapter name
SET adapterName=!adapterName:~0,-1!
echo !adapterName!
GOTO:EOF
netsh interface ip set dns name="!adapterName!" static 1.1.1.1 primary
netsh interface ip add dns name="!adapterName!" 1.0.0.1 index=2
)
goto Exit


:GoogleDNS
cls
title Latenzy - Google DNS
if not "%1"=="am_admin" (
    title Latenzy - Requesting admin permissions...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)
title Google DNS
CLS
echo Please input the name of your network adapter here (ex: "Wi-Fi")
echo You can open the Performance tab in Task Manager to find out.
set /p adapterName="Network adapter name: "
cls
FOR /F "tokens=* delims=:" %%a IN ('IPCONFIG ^| FIND /I "ETHERNET ADAPTER"') DO (
SET adapterName=%%a
 
REM Removes "Ethernet adapter" from the front of the adapter name
SET adapterName=!adapterName:~17!
 
REM WinXP Remove some weird trailing chars (dunno what they are)
FOR /l %%a IN (1,1,255) DO IF NOT "!adapterName:~-1!"==":" SET adapterName=!adapterName:~0,-1!
 
REM Removes the colon from the end of the adapter name
SET adapterName=!adapterName:~0,-1!
echo !adapterName!
GOTO:EOF
netsh interface ip set dns name="!adapterName!" static 8.8.8.8 primary
netsh interface ip add dns name="!adapterName!" 8.8.4.4 index=2
)
goto Exit

:Exit
cls
echo Exiting FreePing...
timeout 3 /nobreak > nul
exit