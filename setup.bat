@echo off
setlocal enabledelayedexpansion

:: Detect the right download links depending on the architecture
for /f "tokens=2 delims==" %%A in ('wmic OS get OSArchitecture /value ^| find "="') do set "ARCH=%%A"

if "%ARCH%"=="32-bit" (
    set "WGETDL=https://eternallybored.org/misc/wget/1.21.4/32/wget.exe"
    set "7ZDL=https://www.7-zip.org/a/7z2409.exe"
    set "GITDL=https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-32-bit.exe"
) else if "%ARCH%"=="64-bit" (
    set "WGETDL=https://eternallybored.org/misc/wget/1.21.4/64/wget.exe"
    set "7ZDL=https://www.7-zip.org/a/7z2409-x64.exe"
    set "GITDL=https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-64-bit.exe"
) else (
    set "WGETDL=https://eternallybored.org/misc/wget/1.21.4/a64/wget.exe"
    set "7ZDL=https://www.7-zip.org/a/7z2409-arm64.exe"
    set "GITDL=https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-arm64.exe"
)

:: Download Wget as it's needed to install other softwares
powershell -Command "(New-Object Net.WebClient).DownloadFile('%WGETDL%', 'C:\Windows\wget.exe')"
if %errorlevel% gtr 0 @bitsadmin.exe /transfer "Downloading Wget" "%WGETDL%" "C:\Windows\wget.exe"
if %errorlevel% gtr 0 @exit /b 1

:: Install needed software
set "INSTALLBUILDTOOLS=0"
for %%P in (%*) do (
    if "%%P"=="wget" (
      :: Already installed before
      echo.
    ) else if "%%P"=="7z" (
      C:\Windows\wget.exe "%7ZDL%" -O 7zinstall.exe
      7zinstall.exe /S
      del 7zinstall.exe
      mklink /H "C:\Windows\7z.exe" "C:\Program Files\7-Zip\7z.exe"
    ) else if "%%P"=="git" (
      wget "%GITDL%" -O gitinstall.exe
      gitinstall.exe /VERYSILENT /NORESTART
      del gitinstall.exe
      mklink /H "C:\Windows\git.exe" "C:\Program Files\Git\bin\git.exe"
    )

    echo gcc g++ libc6 libstdc++6 binutils make | findstr /b /c:"%%P" >nul && set "INSTALLBUILDTOOLS=1"
)

if "%INSTALLBUILDTOOLS%"=="1" (
  :: Thanks to https://silentinstallhq.com/visual-studio-build-tools-2022-silent-install-how-to-guide/
  :: Download and run the VS Installer for Build Tools
  wget https://aka.ms/vs/17/release/vs_BuildTools.exe -O vs_BuildTools.exe
  vs_BuildTools.exe --layout .\vs_BuildTools
  del vs_BuildTools.exe
  cd vs_BuildTools
  vs_setup.exe --nocache --wait --noUpdateInstaller --noWeb --allWorkloads --includeRecommended --includeOptional --quiet --norestart

  :: Create a custom configuration to install the right build tools
  echo { > CustomInstall.json
  echo   "installChannelUri": ".\ChannelManifest.json", >> CustomInstall.json
  echo   "channelUri": "https://aka.ms/vs/17/release/channel", >> CustomInstall.json
  echo   "installCatalogUri": ".\Catalog.json", >> CustomInstall.json
  echo   "channelId": "VisualStudio.17.Release", >> CustomInstall.json
  echo   "productId": "Microsoft.VisualStudio.Product.BuildTools", >> CustomInstall.json
  echo   "includeRecommended": true, >> CustomInstall.json
  echo   "includeOptional": true, >> CustomInstall.json
  echo   "quiet": true, >> CustomInstall.json
  echo   "norestart": true, >> CustomInstall.json
  echo   "addProductLang": [ >> CustomInstall.json
  echo     "en-US" >> CustomInstall.json
  echo     ], >> CustomInstall.json
  echo     "add": [ >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.AzureBuildTools", >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.DataBuildTools", >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools", >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.MSBuildTools", >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.NodeBuildTools", >> CustomInstall.json
  echo         "Microsoft.VisualStudio.Workload.OfficeBuildTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Workload.UniversalBuildTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Workload.VCTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Workload.VisualStudioExtensionBuildTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Workload.WebBuildTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Workload.XamarinBuildTools", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Component.VC.Tools.ARM64", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Component.VC.ATL.ARM64", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset.ARM64", >> CustomInstall.json
  echo 	"Microsoft.VisualStudio.Component.VC.CMake.Project.ARM64" >> CustomInstall.json
  echo     ] >> CustomInstall.json
  echo } >> CustomInstall.json

  :: Install the necessary build tools
  vs_setup.exe --quiet --nocache --wait --in CustomInstall.json
  vs_setup.exe --nocache --wait --noUpdateInstaller --noWeb --add "Microsoft.VisualStudio.Workload.MSBuildTools;includeRecommended;includeOptional" --quiet --norestart
  vs_setup.exe --nocache --wait --noUpdateInstaller --noWeb --add "Microsoft.VisualStudio.Workload.VCTools;includeRecommended;includeOptional" --quiet --norestart
)

endlocal
exit /b 0
