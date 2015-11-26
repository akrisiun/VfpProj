@REM run as admin

set dir=%~dp0Lib\Debug
@REM regsvr32 /i %dir%\VfpProjDLL.dll
c:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe %dir%\VfpProjDLL.dll

@PAUSE