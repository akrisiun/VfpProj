* Test
* d:\beta\vfpx\vfplanguage\src\vfpbuild\test.prg

CD (_VFP.Activeproject.HomeDir)

PUBLIC obj as VfpBuild 

obj = NEWOBJECT("VfpBuild", "vfpmain.prg")

SET ASSERTS ON 
assert .f. 

obj.fMissing = .F. 
obj.BuildPjx("vfpbuild.pjx", "vfpbuild1.exe")

obj.CreateApplication()
lcmsg = obj.ApplicationMsg()
lcmsg = obj.SetVfp(obj.OVFP)
lcmsg = obj.DoCmd("_VFP.Visible = .T.")

_SCREEN.oVFp.Visible = .T.
_SCREEN.oVFp.Left = 2000

* REM obj.cFolder = "c:\bin\"
obj.lCLOSE = .F.
obj.BuildPjx("vfpbuild.pjx", "vfpbuild2.exe")

obj.CloseVfp()
IF TYPE("_SCREEN.oVfp.NAME") = 'C'
   _SCREEN.oVfp.Quit()
ENDIF 

RETURN obj.uRetVal
