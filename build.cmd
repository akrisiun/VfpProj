
set MSBuild="%ProgramFiles%\MSBuild\15.0\Bin\MSBuild.exe"
@if not exist %MSBuild% @set MSBuild="%ProgramFiles(x86)%\MSBuild\15.0\Bin\MSBuild.exe"

%MSBuild% VfpProj20.sln /v:m

@PAUSE