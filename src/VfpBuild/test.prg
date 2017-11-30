* Test
* d:\beta\vfpx\vfplanguage\src\vfpbuild\test.prg

CD (_VFP.Activeproject.HomeDir)

PUBLIC o as VfpBuild 

o = NEWOBJECT("VfpBuild", "vfpmain.prg")

SET ASSERTS ON 
assert .f. 

o.BuildPjx("d:\sanitex\pricesql\pricevfp.pjx", "pricevfp1.exe")

o.CreateApplication()
lcmsg = o.ApplicationMsg()

_SCREEN.oVFp.Visible = .T.
_SCREEN.oVFp.Left = 2000

o.cFolder = "d:\sanitex\pricesql\"
o.BuildPjx("pricevfp.pjx", "pricevfp1.exe")

RETURN o.uRetVal
