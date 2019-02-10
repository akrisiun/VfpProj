* TestOle

PUBLIC obj as VfpOle.Obj

CD (_VFP.ActiveProject.HomeDir)

obj = NEWOBJECT("Obj", "vfpOle.prg")
* obj = NEWOBJECT("VfpOle.Obj")
_SCREEN.AddProperty("obj", obj)
