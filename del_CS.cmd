
for /d /r . %%d in (bin,obj) do @if exist "%%d" rd /s/q "%%d"
del /s *.pdb
del /s *.vshost.exe.manifest
del /s *.vshost.exe.config
del /s *.vshost.exe
@PAUSE