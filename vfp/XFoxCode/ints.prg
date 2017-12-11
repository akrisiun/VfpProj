* ints.prg - Interfaces 
FUNCTION ints(toForm as Form)
* cmdTypeLib
* DO typelibs WITH ThisForm
*!*    THIS.Parent.oleTypes.ListItems.Clear()
*!*    THISFORM.refreshtypes()

IF VERSION(2) = 2 AND !FILE([typelibs.vcx])
   CD (_VFP.ActiveProject.HomeDir)
ENDIF

PUBLIC goints as ints OF typelibs.vcx 

goInts = NEWOBJECT("ints", "typelibs.vcx")
goInts.lDebug = .T.
goInts.HookPrg = FULLPATH("ints.prg")
goInts.Show() 

* DO Browse In Ints.prg 
FUNCTION Browse

USE ("C:\PROGRAM FILES (X86)\MICROSOFT VISUAL FOXPRO 8\FOXREFS.DBF") AGAIN 

BROWSE NOWAIT IN SCREEN 