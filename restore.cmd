@REM nuget config -set HTTP_PROXY=http://192.168.2.106:5865 -set HTTP_PROXY.USER= 

if not exist .nuget mkdir .nuget

set NURL=https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
set NUGET=.nuget\nuget.exe
if not exist %~dp0%NUGET% @powershell Invoke-WebRequest %NURL% -OutFile %NUGET%

%NUGET% install -outputDirectory packages Newtonsoft.Json -version 9.0.1
nuget install -outputDirectory Packages   MSTest.TestAdapter -version 1.1.4-preview
nuget install -outputDirectory Packages   MSTest.TestFramework -version 1.0.5-preview
nuget install -outputDirectory Packages   xunit -version 2.1.0
nuget install -outputDirectory Packages   xunit.abstractions -version 2.0.0
nuget install -outputDirectory Packages   xunit.assert -version 2.1.0
nuget install -outputDirectory Packages   xunit.core -version 2.1.0
nuget install -outputDirectory Packages   xunit.extensibility.core -version 2.1.0
nuget install -outputDirectory Packages   xunit.extensibility.execution -version 2.1.0
  
@PAUSE