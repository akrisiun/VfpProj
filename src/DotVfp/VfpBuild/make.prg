* Make.prg, run as Administrator

_SCREEN.AddProperty("IsConsole", .T.)

CD (_VFP.ActiveProject.HomeDir)

* BUILD DLL ..\..\bin\vfpBuild.dll FROM VfpBuild RECOMPILE

BUILD DLL c:\bin\vfpbuild.dll FROM VfpBuild RECOMPILE

COPY FILE c:\bin\vfpbuild.dll TO .

COPY FILE c:\bin\vfpbuild.dll TO d:\Beta\VfpX\vfplanguage\src\DotVfp\bin\vfpbuild.dll
