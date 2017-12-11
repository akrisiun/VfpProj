@REM MSTools v15.0

set MSBuild="%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe"
@if not exist %MSBuild% @set MSBuild="%ProgramFiles%\MSBuild\12.0\Bin\MSBuild.exe"
@if not exist %MSBuild% @set MSBuild="%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe"

%MSBuild% VfpProj.sln /v:m

@PAUSE