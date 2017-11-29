
set dir=%~dp0
d:
cd "%dir%"

set MSBuild=%ProgramFiles(x86)%\MSBuild\15.0\Bin\MSBuild.exe
set vssdk=%ProgramFiles%\MSBuild\Microsoft\VisualStudio\v14.0\VSSDK\Microsoft.VSSDK.targets

@REM @if exist "%MSBuild%" @set MSBuild=%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe
@REM @if exist %vssdk_x86% @set MSBuild=%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe
@if not exist "%MSBuild%" @set MSBuild=%ProgramFiles%\MSBuild\15.0\Bin\MSBuild.exe
@if not exist "%MSBuild%" set MSBuild=%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe

nuget restore VfpLanguage15.sln

@REM "%MSBuild%" 
MSBuild15 /v:m VfpLanguage15.sln

@PAUSE