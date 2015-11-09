* Main

IF VERSION( 2) # 2
   ON SHUTDOWN CLEAR EVENTS
ENDIF

CD (_VFP.ActiveProject.HomeDir)
IF 1=2
    COPY FILE ..\lib\Clr.dll TO Clr.dll 
    COPY FILE ..\lib\Clr.pdb TO Clr.pdb
ENDIF


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
   assert .f.

    DECLARE Integer SetClrVersion IN "Clr.dll"  string    
    DECLARE Integer ClrLoad IN "Clr.dll"  string@ errMessage, integer@ dwErrorSize

    * DECLARE Integer ClrCreateInstance IN "Clr.dll" string, string, string@, integer@
    DECLARE Integer ClrCreateInstanceFrom IN "Clr.dll" string, string, string@, integer@
        
    PUBLIC nDispHandle, ret1 

    lcMessage = CHR(0) + SPACE(402) + CHR(0)
    lcDir = ADDBS(FULLPATH(CURDIR()))

    ret1 = SetClrVersion("v4.0.30319")
    * -2 : "CLRCreateInstance(CLSID_CLRMetaHost
    * nDispHandle = ClrCreateInstanceFrom("Vfp.dll", 
    
    nDispHandle = ClrCreateInstanceFrom("VfpProj.exe",;
                  "Vfp.Startup",;
                   @lcMessage, 100) 
                  
    * // "The given assembly name or codebase was invalid. o d e b a s e ,   ' % 1 ' ,   w a s   i n v a l i d  "
    * "The assembly is built by a runtime newer than the currently loaded runtime, and cannot be loaded. 
    
    ? nDispHandle 
    ? lcMessage 

ASSERT .f. 

    public goVfp
    goVfp = SYS(3096, nDispHandle)
    goVfp.Main(_VFP, .T.)

    RETURN
* Assembly.GetEntryAssembly null
*          entryLocation = new Uri(Application.ResourceAssembly.CodeBase);
* DO ClrHost in main