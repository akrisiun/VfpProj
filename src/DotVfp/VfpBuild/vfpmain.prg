
* COM_Attrib flag settings for Type Library attributes support
*-------------------------------------------------------------------
*!*  #DEFINE COMATTRIB_RESTRICTED    0x1      && The property/method should not be accessible from macro languages.
*!*  #DEFINE COMATTRIB_HIDDEN        0x40     && The property/method should not be displayed to the user, although it exists and is bindable.
*!*  #DEFINE COMATTRIB_NONBROWSABLE  0x400    && The property/method appears in an object browser, but not in a properties browser.
#DEFINE COMATTRIB_READONLY      0x100000 && The property is read-only (applies only to Properties).
*!*  #DEFINE COMATTRIB_WRITEONLY     0x200000 && The property is write-only (applies only to Properties).
*!*  #DEFINE COMATTRIB_READWRITE     0x0      && .F.

#DEFINE CRLF CHR(13) + CHR(10)

DEFINE CLASS VfpBuild AS SESSION OLEPUBLIC

  * PUBLIC oVfp AS VisualFoxpro.APPLICATION
  oVfp = .NULL.
  uRetVal = .T.
  DSID = 1
  fBuildAll = .F.
  fMissing = .F.
  lClose = .T.
  cOutputName = ""
  nBuildAction = 0

  * PUBLIC cProject AS STRING
  cProject = ""
  cFolder = ""
  LastError = .NULL.

  * PUBLIC cErrorMessage  as String
  cErrorMessage = ""

  DIMENSION cErrorMessage_COMATTRIB[4]
  cErrorMessage_COMATTRIB[1] = COMATTRIB_READONLY
  cErrorMessage_COMATTRIB[2] = "Build Errors"
  cErrorMessage_COMATTRIB[3] = "cErrorMessage"
  cErrorMessage_COMATTRIB[4] = "String"

  cWarningMessage = ""

  DIMENSION cWarningMessage_COMATTRIB[4]
  cWarningMessage_COMATTRIB[1] = COMATTRIB_READONLY
  cWarningMessage_COMATTRIB[2] = "Build Warnings"
  cWarningMessage_COMATTRIB[3] = "cWarningMessage"
  cWarningMessage_COMATTRIB[4] = "String"
  
 FUNCTION Compile(cPrgFile AS STRING)
 
    This.oVFP = NEWOBJECT("VisualFoxpro.Application")
    oVFP = this.oVFP
        
    IF TYPE("oVFP.hWnd") = 'N'
       oVFP.DoCmd("COMPILE " + cPrjFile)
       this.CloseVfp()
    ELSE
      _VFP.DoCmd("COMPILE " + cPrjFile)
    ENDIF
    

 FUNCTION BuildPjx(cProjectFile AS STRING, cOutputName AS STRING)
    
    This.DSID = SET("Datasession")
 
    LOCAL lcPath, lcDir as String, lOk AS Boolean
    lcPath = FULLPATH(cProjectFile)
    lcDir = ADDBS(JUSTPATH(lcPath))
    
    lOk = This.BuildProject(lcPath, cOutputName, 0, "", "", lcDir)
    IF this.lClose
       this.CloseVfp()
    ENDIF  
    
    RETURN lOk 

 FUNCTION SetVisible(lVisible as Boolean)
    
    TRY
        this.oVfp.Visible = .T.
        this.oVfp.DoCmd("_SCREEN.Visible = .T.")
        _VFP.Visible = .T.
        _SCREEN.Visible = .T.
    CATCH
          This.ErrorMsg(MESSAGE()) 
    ENDTRY

 FUNCTION BuildVisible(lVisible as Boolean)
    this.oVfp.Visible = EVL(lVisible, .T.)
    
 FUNCTION CreateApplication()
    IF TYPE("This.oVFP.ProcessId") <> 'N'
       This.oVFP = .NULL.
       TRY
          This.oVFP = NEWOBJECT("VisualFoxpro.Application")
          This.oVFP.OLEServerBusyRaiseError = .F.
       CATCH
          This.ErrorMsg(MESSAGE()) 
       ENDTRY
    ENDIF
    _SCREEN.AddProperty("oVFP", this.ovfp)

 FUNCTION ApplicationMsg()
    
    LOCAL lcMsg as String
    lcMsg = ""
    TRY
      lcMsg = this.oVfp.Eval("MESSAGE()")
    CATCH
    ENDTRY

    RETURN lcMsg
    
 FUNCTION DoCmd(tcExpr)    
    LOCAL lRet
    IF !ISNULL(this.oVfp) AND ATC(tcExpr, "this.") = 0
       lRet = this.oVfp.DoCmd(tcExpr)
    ELSE 
       lRet = _VFP.Eval(tcExpr)
    ENDIF

    RETURN lRet
    
 FUNCTION Eval(tcExpr)    
    LOCAL lRet
    
    IF !ISNULL(this.oVfp) AND ATC(tcExpr, "this.") = 0
       lRet = this.oVfp.Eval(tcExpr)
    ELSE 
       lRet = _VFP.Eval(tcExpr)
    ENDIF

    RETURN lRet

 FUNCTION Eval2(tcExpr, lcExpr1)    
    LOCAL lRet

    IF !ISNULL(this.oVfp) AND ATC(tcExpr, "this.") = 0
       lRet = this.oVfp.Eval(tcExpr)
    ELSE 
       lRet = _VFP.Eval(tcExpr)
    ENDIF

    RETURN lRet

 FUNCTION Eval3(tcExpr, lparam1, lparam2)    
    LOCAL lRet
    
    IF !ISNULL(this.oVfp) AND ATC(tcExpr, "this.") = 0
       lRet = this.oVfp.Eval(tcExpr)
    ELSE 
       lRet = _VFP.Eval(tcExpr)
    ENDIF
    RETURN lRet
    
 FUNCTION BuildExe(cProjectFile AS STRING, cOutputName AS STRING)
 
    this.CreateApplication()

    This.cProject = cProjectFile
    
    LOCAL lcMsg as String
    lcMsg = ""
    TRY

      This.oVFP.DOCMD('MODIFY PROJECT "' + This.cProject + '" NOSHOW NOWAIT')
      This.oVFP.DOCmd("BUILD EXE " + cOutputName + " FROM " + this.cProject + " RECOMPILE")
      
      lcMsg = This.oVFP.StatusBar
      This.ErrorMsg(lcMsg) 
            
    CATCH

      lcMsg = This.oVFP.StatusBar
      This.ErrorMsg("Failed to open project " + This.cProject + " (KILLED)") 

      lKilled = .T.
    ENDTRY
    
    RETURN lcMsg
    
 FUNCTION ActiveProject() as IFoxProject
 
      LOCAL proj    
      proj = .NULL.
      TRY
         proj = this.ovfp.Application.ActiveProject
      CATCH
      ENDTRY
      RETURN proj
    
 FUNCTION BuildProject(cProjectFile AS STRING, cOutputName AS STRING ;
  		, nBuildAction AS INTEGER, cVsProjectFile AS STRING, cBuildTime AS STRING, cBuildPath AS STRING) AS Boolean

    LOCAL cProjectPath AS STRING, ;
      cOutputPath AS STRING, ;
      lReturn AS Boolean, ;
      lKilled AS Boolean, ;
      cMissingFiles AS STRING, ;
      cFile AS STRING
      
    IF EMPTY(cProjectFile)

      This.ErrorMsg("Project .PJX error: " + TRANSFORM(cProjectFile))
      RETURN .F.
    ENDIF
      
    IF VARTYPE(m.cVSProjectFile) = 'C' AND ATC(":\", m.cVSProjectFile) > 0
       cProjectPath  = JUSTPATH(m.cVSProjectFile) + "\"
    ENDIF
    
    This.cFolder = JUSTPATH(cProjectFile) + "\"
    IF EMPTY(This.cFolder)
       This.cFolder = FULLPATH(".") + "\"
    ENDIF
    This.cProject = This.cFolder + JUSTFNAME(m.cProjectFile)
    cOutputPath   = ADDBS(EVL(ALLTRIM(m.cBuildPath), this.cFolder))
    
    lReturn       = .T.
    lKilled       = .F.
    cMissingFiles = ""

    IF !This.OpenPjx(This.cProject)
        RETURN .F.
    ENDIF 



    TRY

      cType = VARTYPE(This.oVFP.ACTIVEPROJECT.NAME)

    CATCH

    ENDTRY

    IF m.cType <> "C"

      This.ErrorMsg("Failed to open project " + This.cProject) 

      This.CloseVFP()

      RETURN .F.

    ENDIF

    * Check for the output folder and create if necessary
    *----------------------------------------------------
    IF NOT DIRECTORY(m.cOutputPath)

      MD (m.cOutputPath)

    ENDIF

    * Test the project to see if it will build
    *
    * Since we'll be working from local files in all cases
    * we should "rebuild all" every time.
    *
    * The only time This call should error is when the build hangs
    * on a Locate File dialog and is killed by KillProcess.exe.
    * Therefore, we don't need to call This.CloseVFP() in the CATCH.
    *-----------------------------------------------------------------
    
    LOCAL fBuildAll as Logical, fShowErr as Logical, lcMsg as String
    
    This.cOutputName = cOutputName
    fBuildAll = This.fBuildAll
    fShowErr = .T.
    lcMsg = MESSAGE()
    
    * 1    BUILDACTION_REBUILD    (Default) Rebuilds the project
    * 2    BUILDACTION_BUILDAPP    Creates an .app
    * 3    BUILDACTION_BUILDEXE    Creates an .exe
    * 4    BUILDACTION_BUILDDLL    Creates a .dll
    * 5    BUILDACTION_BUILDMTDLL    Creates a multithreaded .dll
    * https://msdn.microsoft.com/en-us/library/aa977366%28v=vs.71%29.aspx?f=255&MSPPError=-2147217396

    TRY

      lReturn = This.oVFP.ACTIVEPROJECT.BUILD(m.cOutputPath + This.cOutputName,;
                EVL(This.nBuildAction, 3), fBuildAll, fShowErr )

      lcMsg = This.oVFP.StatusBar
      
    CATCH

      lcMsg = This.oVFP.StatusBar
      lcMsg = MESSAGE()
      This.ErrorMsg("Failed " + lcMsg + " to build project "  + This.cProject + " (KILLED)")

      lKilled = .T.

    ENDTRY

    IF m.lKilled
       RETURN .F.
    ENDIF

    cErrorFile = FORCEEXT(This.cProject, "err")

    IF FILE(m.cErrorFile)

      * If we built then the errors are just warnings
      *----------------------------------------------
      IF m.lReturn

        This.cWarningMessage = FILETOSTR(m.cErrorFile)

      ELSE

        This.ErrorMsg(FILETOSTR(m.cErrorFile))

      ENDIF

    ELSE

      IF m.lReturn = .F.

        This.ErrorMsg("Error building VFP project " + This.cProject)

      ENDIF

    ENDIF

    This.CloseVFP()

    RETURN m.lReturn

  ENDPROC
  
  FUNCTION OpenPjx(cProject as string) as Boolean
    
    This.cProject = cProject
    
    * First we test to see if the project file exists
    *------------------------------------------------
    IF NOT FILE(This.cProject)

      This.ErrorMsg("Project " + This.cProject + " does not exist")

      RETURN .F.

    ENDIF

    * Next we make sure it isn't locked by another user
    *--------------------------------------------------
    IF USED("MyProject")
       USE IN MyProject
    ENDIF
   
    IF TYPE("This.oVFP.ActiveProject.name") = 'C'
       This.oVFP.DOCMD('_VFP.ActiveProject.Close()')
    ENDIF
        
    nHandle = FOPEN(This.cProject, 12)

    FCLOSE(m.nHandle)

    IF m.nHandle < 0

      This.ErrorMsg("Project " + This.cProject + " is in use")

      RETURN .F.
    ENDIF

    * Check the project to see if all the files in the project exist
    *---------------------------------------------------------------
    
    USE (This.cProject) IN 0 ALIAS MyProject

    SELECT MyProject

    IF EMPTY(MyProject.NAME) OR EMPTY(MyProject.HOMEDIR)

      REPLACE MyProject.NAME WITH m.cProjectFile + CHR(0), ;
           MyProject.HOMEDIR WITH m.cProjectPath + CHR(0)

    ENDIF

    IF EMPTY(cProjectPath)
       cProjectPath = this.cFolder
    ENDIF
    CD (m.cProjectPath)      && Most paths are relative (ex. "..\..\test.prg")
    
    IF this.fMissing

        * Delete records have been removed.  This will still cause
        * problems when the project hasn't been rebuilt in a long time.
        *--------------------------------------------------------------
        SCAN FOR NOT DELETED()

          cFile = ALLTRIM(CHRTRAN(MyProject.NAME, CHR(0), ""))

          IF NOT FILE(m.cFile)

            cMissingFiles = IIF(EMPTY(m.cMissingFiles), m.cFile, m.cMissingFiles + ", " + m.cFile)

          ENDIF

        ENDSCAN

        USE IN MyProject

        IF NOT EMPTY(m.cMissingFiles)
           This.ErrorMsg("Project files were missing: " + m.cMissingFiles) 

          RETURN .F.
        ENDIF
    ENDIF
    IF USED("MyProject")
       USE IN MyProject
    ENDIF
    
    IF TYPE("This.oVFP.ProcessId") <> 'N'
       This.oVFP = NEWOBJECT("VisualFoxpro.Application")
       this.oVFP.OLEServerBusyRaiseError = .F.
    ENDIF

    * This app will kill the vfp9.exe process if it hangs up
    *!*        TRY
    *!*          * SHELLEXECUTE(_SCREEN.HWND, "OPEN", _VFP.SERVERNAME,;
    *!*                     TRANSFORM(This.oVfp.APPLICATION.PROCESSID) + " " + m.cBuildTime, SYS(2023), .F.)

    * Open the project
    * The only time This call should error is when opening the project
    * causes a dialog box, hangs and is killed by KillProcess.exe.
    * Therefore, we don't need to call This.CloseVFP() in the CATCH.
    *------------------------------------------------------------------------
    TRY
      This.oVFP.DOCMD('MODIFY PROJECT "' + This.cProject + '" NOSHOW NOWAIT')
      
      This.oVFP.DOCMD('CD (_VFP.ActiveProject.HomeDir)')
      lKilled = .F.
      
    CATCH
      This.ErrorMsg("Failed to open project " + This.cProject + " (KILLED)") 

      lKilled = .T.
    ENDTRY

    IF m.lKilled
       RETURN .F.
    ENDIF
    RETURN .T.
    

  FUNCTION SetVfp(oVfp as object)
    This.oVfp = NVL(oVfp, _VFP)

  FUNCTION CloseVfp()

    * Manually close VFP here
    *------------------------
    IF TYPE("This.oVFP.hWnd") = 'N'    
       This.oVFP.QUIT()
    ENDIF
 
    This.oVFP = .NULL.
    _VFP.Quit()
    
  ENDPROC

  FUNCTION ErrorSet(err as Exception) AS Exception

     this.LastError = err
     RETURN this.LastError

  FUNCTION ErrorMsg(msg as string) AS Exception

     LOCAL err as Exception
     err = NEWOBJECT("Exception")
     err.Message = msg
     
     this.cErrorMessage = msg
     this.LastError = err
     RETURN this.LastError

  PROTECTED FUNCTION ERROR(nError, cMethod, nLine) AS VOID

    SET TEXTMERGE TO (JUSTPATH(_VFP.SERVERNAME) + "\ProjectBuilderErrors-" ;
      + CHRTRAN(TRANSFORM(DATE()), "/", "-") + ".log") ADDITIVE NOSHOW

    SET TEXTMERGE ON

      \DateTime     : <<TRANSFORM(DATETIME())>>
      \Error Number : <<TRANSFORM(m.nError)>>
      \Method       : <<ALLTRIM(m.cMethod)>>
      \Line Number  : <<TRANSFORM(nLine)>>
      \Project      : <<This.cProject>>
      \Message      : <<MESSAGE()>>
      \ErrorParam   : <<SYS(2018)>>
      \Current Line : <<IIF(VARTYPE(m.nLine) <> "N", 0, m.nLine)>>
      \Stack Level  : <<MAX(1, ASTACKINFO(aCurStack) - 1)>>
      \Line Contents: <aCurStack[This.nLevel, 6]>>
      \

    SET TEXTMERGE OFF

    SET TEXTMERGE TO

  ENDPROC
  
  *#######################################################################################
  FUNCTION INIT()
  *#######################################################################################

    * See "Commands that Scope to a Data Session" in help for more info.
    *----------------------------------------------------------------------
    SET EXCLUSIVE OFF
    SET SAFETY OFF
    SET TALK OFF
    SET MULTILOCKS ON
    SET EXACT OFF
    SET DELETED ON
    SET CPDIALOG OFF
    SET REPROCESS TO 2 SECONDS
    SET CENTURY ON
    SET BELL OFF
    SET LOGERRORS OFF

    _SCREEN.AddProperty("IsConsole", .T.)
    IF TYPE('_SCREEN.oVfp.processid') <> 'N'
       _SCREEN.AddProperty("oVFP", this.ovfp)
    ELSE 
       This.ovfp = _SCREEN.oVfp
    ENDIF
    
    _VFP.OLEServerBusyRaiseError = .F.
    SET Datasession TO 1 
    This.DSID = SET("Datasession")    
    This.fBuildAll = .F.
    This.lClose = .T.
    IF USED("MyProject")
       USE IN MyProject
    ENDIF

  ENDFUNC
  

ENDDEFINE
