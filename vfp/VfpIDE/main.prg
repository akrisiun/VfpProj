* Main

IF VERSION( 2) # 2
   ON SHUTDOWN CLEAR EVENTS
ENDIF

CD (_VFP.ActiveProject.HomeDir)
IF 1=2
    COPY FILE ..\lib\Clr.dll TO Clr.dll 
    COPY FILE ..\lib\Clr.pdb TO Clr.pdb
ENDIF

* cd d:\Beta\VfpProj\Lib\
* c:\Windows\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /codebase /tlb ActiveXTest.dll
* d:\Beta\VfpProj\Lib\ActiveXTest.dll


SET PATH TO
CD ..\Lib

lcDir = CURDIR()
CD (lcDir)

DO Clr
* DO ClrHost

RETURN 

DO FORM Main

READ EVENTS

ON SHUTDOWN 
RETURN


FUNCTION Clr(toForm as Form)

   SET ASSERTS ON

    DECLARE Integer SetClrVersion IN "Clr.dll"  string    
    DECLARE Integer ClrLoad IN "Clr.dll"  string@ errMessage, integer@ dwErrorSize

    * DECLARE Integer ClrCreateInstance IN "Clr.dll" string, string, string@, integer@
    DECLARE Integer ClrCreateInstanceFrom IN "Clr.dll" string, string, string@, integer@
        
    PUBLIC nDispHandle, ret1 

    lcMessage = CHR(0) + SPACE(402) + CHR(0)
    lcDir = ADDBS(FULLPATH(CURDIR()))

    ret1 = SetClrVersion("v4.0.30319")
    nDispHandle = ClrCreateInstanceFrom("VfpProj.exe",;
                  "Vfp.Startup",;
                   @lcMessage, 100) 
    * // "The given assembly name or codebase was invalid. o d e b a s e ,   ' % 1 ' ,   w a s   i n v a l i d  "

    public goVfp
    goVfp = SYS(3096, nDispHandle)
    _VFP.AutoYield = .F.
    DOEVENTS FORCE 

    goVfp.LoadMain(_VFP)
    
    _VFP.AutoYield = .F.
    _SCREEN.AddProperty("ocs_inst", m.ocs_form.instance)
    
    DOEVENTS FORCE   
    _VFP.Eval("_SCREEN.ocs_inst.Show(_VFP)")
    RETURN

FUNCTION  StartupInstance
* DO StartupInstance in Main 

  PUBLIC m.o1

  m.o1 = m.ocs_form.Instance
  
  _SCREEN.AddProperty("ocs_inst", m.ocs_form.instance)
  
  * _Startup LoadMain(FoxApplication app) 
  * m.o1.LoadMain(_VFP)
  
  _SCREEN.ocs_inst.LoadMain(_VFP)
  return


FUNCTION OCS_Form

    IF TYPE("_SCREEN.ocs_form.Name") # "C"
       DO Clr
       
       _VFP.AutoYield = .F.
       DOEVENTS FORCE 

       IF TYPE([goVfp]) != 'U' AND !ISNULL(goVfp)
          goVfp.LoadMain(_VFP)
          _VFP.Eval("_SCREEN.ocs_inst.Show(_VFP)")          
       ENDIF
    ENDIF

    IF (_VFP.Projects.Count > 0)
        CD (_VFP.ActiveProject.HomeDir)
    ENDIF
    _VFP.DefaultFilePath = FULLPATH(CURDIR())
    IF TYPE([_SCREEN.ocs_form.Directory]) = 'C'
        _SCREEN.ocs_form.Directory = _VFP.DefaultFilePath
        _SCREEN.ocs_form.Text = _VFP.DefaultFilePath
    ENDIF
