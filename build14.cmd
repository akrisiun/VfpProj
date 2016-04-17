@REM MSTools v14.0

set MSBuild="%ProgramFiles%\MSBuild\12.0\Bin\MSBuild.exe"
@if not exist %MSBuild% @set MSBuild="%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe"
@if not exist %MSBuild% @set MSBuild="%ProgramFiles%\MSBuild\15.0\Bin\MSBuild.exe"

%MSBuild% VfpProj14.sln /v:m

@PAUSE