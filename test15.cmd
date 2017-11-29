
@set TestWindow=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow

@if not exist "%TestWindow%" @set TestWindow=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow
@if not exist "%TestWindow%" @set TestWindow=%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow
@if not exist "%TestWindow%" @set C:\Program Files\Microsoft Visual Studio 12.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow

"%TestWindow%\vstest.console.exe" /UseVsixExtensions:true  bin\VfpVsixTest15.dll

@PAUSE