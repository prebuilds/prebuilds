@echo off
setlocal enabledelayedexpansion

:: Exits if there are no arguments
if "%~1"=="" exit /b 1

:: Creates the prefix directory
mkdir C:\prefix 2>nul
cd /d C:\prefix || exit /b 1

:: Gets the source code link
set "SOURCECODE=%~1"

:: Convert to lowercase for comparison
set "LOWERSOURCE=%SOURCECODE%"
for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "LOWERSOURCE=!LOWERSOURCE:%%A=%%a!"
)

:: Choose which tool to use for downloading and extracting
if "!LOWERSOURCE!"=="!LOWERSOURCE:.git=!" if "!SOURCECODE:*.=!"=="!SOURCECODE!" (
    :: Git link given, use Git to make a shallow clone of the repo
    git clone --depth 1 "%SOURCECODE%" src || exit /b 1
) else if "!LOWERSOURCE!"=="!LOWERSOURCE:.tar.=!" (
    :: Link to a compressed TAR file given, download it with Wget and extract it two times with 7-Zip
    wget "%SOURCECODE%" -O "src.tar.!SOURCECODE:*.=!" || exit /b 1
    7z x -y "src.tar.!SOURCECODE:*.=!"
    del "src.tar.!SOURCECODE:*.=!"
    7z x -y src.tar -o.\src
    del src.tar
) else (
    :: Link to regular ZIP or TAR file, download it with Wget and extract it with 7-Zip
    wget "%SOURCECODE%" -O "src.!SOURCECODE:*.=!" || exit /b 1
    7z x -y "src.!SOURCECODE:*.=!" -o.\src
    del "src.!SOURCECODE:*.=!"
)

endlocal
exit /b 0
