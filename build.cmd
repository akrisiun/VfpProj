
set MSBuild=%ProgramFiles%\MSBuild\15.0\Bin\MSBuild.exe
set vssdk=%ProgramFiles%\Microsoft Visual Studio\2017\Community\MSBuild\Microsoft\VisualStudio\v15.0\VSSDK\Microsoft.VsSDK.targets
@REM set vssdk=%ProgramFiles%\MSBuild\Microsoft\VisualStudio\v14.0\VSSDK\Microsoft.VSSDK.targets
set vssdk_x86=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\Microsoft\VisualStudio\v15.0\VSSDK\Microsoft.VsSDK.targets

set MSBuild=%ProgramFiles(x86)%\MSBuild\15.0\Bin\MSBuild.exe
@if not exist %MSBuild% set MSBuild=%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe
@if not exist %MSBuild% set MSBuild=%ProgramFiles%\MSBuild\12.0\Bin\MSBuild.exe
@if not exist "%MSBuild%" @set MSBuild=%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild.exe

@REM C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\Microsoft\VisualStudio\v15.0\VSSDK\Microsoft.VsSDK.Common.targets(95,5):
@REM set vssdk_x86=%ProgramFiles(x86)%\MSBuild\Microsoft\VisualStudio\v14.0\VSSDK\Microsoft.VsSDK.targets
@REM set vssdk=%ProgramFiles%\MSBuild\Microsoft\VisualStudio\v14.0\VSSDK\Microsoft.VsSDK.targets

@if exist %vssdk% @set MSBuild=%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe

nuget restore VfpLanguage15.sln

"%MSBuild%" /v:m VfpLanguage15.sln

@PAUSE