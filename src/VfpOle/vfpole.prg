* VfpOle.prg
LPARAMETERS lcPath as String

lcPath = EVL(lcPath, "vfpOle.prg")
IF FILE(lcPath) OR VERSION( 2) <> 2
   _SCREEN.AddProperty("obj", NEWOBJECT("Obj", lcPath))
ENDIF

* VfpOle.Obj
DEFINE CLASS Obj as Custom OLEPUBLIC 

  oVfp = .NULL.
  oScreen = .NULL.
  DSID = 0
  uRetVal = .NULL.
  
  FUNCTION Init
  
    this.oVfp = _VFP
    this.oScreen = _SCREEN
    this.DSID = SET("DATASESSION")
    
    _SCREEN.AddProperty("uRetval", .NULL.)
    this.uRetVal = .T.
    RETURN this.uRetVal

  FUNCTION LoadVfp(oVfp, oScreen)

     this.oVfp = oVfp
     this.oScreen = oScreen

  FUNCTION GetObj(bstrExpr as string)
  
    this.uRetval = IIF(EMPTY(bstrExpr), .NULL., EVALUATE(bstrExpr))
    RETURN this.uRetval
    
  FUNCTION SetObj(obj as string, cValue as Object)

    LOCAL cMacro as String
    cMacro = obj + " = " + IIF(VARTYPE(cValue) = 'C', "'" + cValue + "'", VAL(cValue))
    &Macro
  
    this.uRetval = EVALUATE(obj)
    RETURN this.uRetval

  FUNCTION GetProp(obj as target, cProp as string)
  
    WITH obj
      this.uRetval = EVALUATE("." + cProp)
    ENDWITH 
    RETURN this.uRetval

  FUNCTION SetProp(obj as Custom, cProp as string, cValue as Object)
  
    LOCAL cMacro as String
    WITH obj
      IF TYPE("." + cProp) = 'U'
         obj.AddProperty(cProp, .NULL.)
      ENDIF
      cMacro = "." + cProp + " = " + IIF(VARTYPE(cValue) = 'C', "'" + cValue + "'", VAL(cValue))
      &cMacro
      this.uRetval = EVALUATE("." + cProp)
    ENDWITH 
    RETURN this.uRetval


  FUNCTION GetObjects(idx as int)
  
    IF !EMPTY(idx) AND idx > 0 
       RETURN _SCREEN.Objects(idx)
    ENDIF
   
    RETURN .NULL.

  FUNCTION ObjIndex(obj as custom, idx as int)
  
    IF !EMPTY(idx) AND idx > 0 
       WITH obj
          RETURN .Objects(idx)
       ENDWITH
    ENDIF
   
    RETURN .NULL.
  
  FUNCTION Eval(bstrExpr as string)
    
    this.uRetval = this.oVfp.Eval(bstrExpr)  
    RETURN this.uRetval
    
  FUNCTION DataToClip(lpvarWrkArea as Variant, lpvarNumRows as Variant, lpvarclipFormat as Variant)
    
    this.uRetval = this.oVfp.DataToClip(lpvarWrkArea, lpvarNumRows, lpvarclipFormat)
    RETURN this.uRetval
    
  FUNCTION AddProp(cProp, cvalue)
    this.oVfp.AddProperty(cProp, cValue)
    
    RETURN this.oVfp.Eval(cProp)

  * DO LoadClr in VfpOle WITH "c:\Sanitex\ClrHost.dll"
  FUNCTION LoadClr(clr, csLib)
    DO LoadClr WITH clr, csLib

ENDDEFINE 


*#######################################################################################
* DO LoadClr in VfpOle WITH "c:\Sanitex\ClrHost.dll"
FUNCTION LoadClr(clr, csLib, cObj)

    DECLARE Integer SetClrVersion IN (clr)  string    
    DECLARE Integer GetLastError IN (clr)  string    
    DECLARE Integer ClrLoad IN (clr)  string@ errMessage, integer@ dwErrorSize

    DECLARE Integer ClrCreateInstance IN (clr) string, string, string@, integer@
    DECLARE Integer ClrCreateInstanceFrom IN (clr) string@, string@, string@, integer@
    DECLARE string LoadDll IN (clr)  string@ dllName
    
    PUBLIC nDispHandle, ret1 
    
    ret1 = SetClrVersion("v4.0.30319")

    LOCAL lcMessage
    lcMessage = CHR(0) + SPACE(402) + CHR(0)
    lcDir = ADDBS(FULLPATH(CURDIR()))
    
    IF EMPTY(csLib) OR !FILE(csLib)
       _SCREEN.uRetval = .F.
       RETURN .F.
    ENDIF
    _SCREEN.uRetval = .NULL.
    cObj = EVL(cObj, "Sanitex.CsLib")

    * public static ObjectHandle CreateInstanceFrom (AppDomain domain, string assemblyFile, string typeName)
    nDispHandle = ClrCreateInstanceFrom(csLib,;
                  cObj,;
                  @lcMessage, 100) 
                  
    PUBLIC CsObj as OleControl 

    IF nDispHandle != -1 
        CsObj = SYS(3096, nDispHandle)
        _SCREEN.uRetval = CsObj
                   
        _VFP.AutoYield = .F.
        _SCREEN.AddProperty("csObj", m.csObj)
    ENDIF 
        
    DOEVENTS FORCE
    
    RETURN _SCREEN.uRetval
    


