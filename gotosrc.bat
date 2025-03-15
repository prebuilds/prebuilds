@echo off
setlocal enabledelayedexpansion

:: Go to the source code directory
cd /d C:\prefix\src || exit /b 1

:LOOP
for /f "delims=" %%D in ('dir /b /a-d') do set "COUNT=%%D"
for /f %%C in ('dir /b /a-d ^| find /c /v ""') do set "FILECOUNT=%%C"

if "%FILECOUNT%"=="1" (
    cd /d "%COUNT%" || exit /b 1
    goto LOOP
)

endlocal
exit /b 0
