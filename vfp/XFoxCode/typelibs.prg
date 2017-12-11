* typelibs.prg
FUNCTION typelibs(toForm as Form)
* cmdTypeLib
* DO typelibs WITH ThisForm
*!*    THIS.Parent.oleTypes.ListItems.Clear()
*!*    THISFORM.refreshtypes()

IF VERSION(2) = 2 AND !FILE([typelibs.vcx])
   CD (_VFP.ActiveProject.HomeDir)
ENDIF

PUBLIC goTypeLibs as Typelibs OF typelibs.vcx 

SET ASSERTS ON 
ASSERT .f. 

goTypeLibs = NEWOBJECT("Typelibs", "typelibs.vcx")
goTypeLibs.Show() 


* DO GetInterface in foxCode
FUNCTION GetInterface()

DO GetInterface in foxCode

