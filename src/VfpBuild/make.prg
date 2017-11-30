* Make.prg, run as Administrator

_SCREEN.AddProperty("IsConsole", .T.)

CD (_VFP.ActiveProject.HomeDir)

* BUILD DLL ..\..\bin\vfpBuild.dll FROM VfpBuild RECOMPILE

BUILD DLL c:\Sanitex\vfpbuild.dll FROM VfpBuild RECOMPILE
