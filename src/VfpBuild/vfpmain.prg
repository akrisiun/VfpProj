
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
 
    This.oVFP = CREATEOBJECT("VisualFoxpro.Application")
    oVFP = this.oVFP
        
    IF TYPE("oVFP.hWnd") = 'N'
       oVFP.DoCmd("COMPILE " + cPrjFile)
       CloseVfp()
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
       CloseVfp()
    ENDIF  
    
    RETURN lOk 

 FUNCTION BuildVisible(lVisible as Boolean)
    this.oVfp.Visible = EVL(lVisible, .T.)
    
 FUNCTION CreateApplication()
    IF TYPE("This.oVFP.ProcessId") <> 'N'
       This.oVFP = CREATEOBJECT("VisualFoxpro.Application")
       this.oVFP.OLEServerBusyRaiseError = .F.
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

    * First we test to see if the project file exists
    *------------------------------------------------
    IF NOT FILE(This.cProject)

      This.ErrorMsg("Project " + This.cProject + " does not exist")

      RETURN .F.

    ENDIF

    * Next we make sure it isn't locked by another user
    *--------------------------------------------------
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
    
    IF TYPE("This.oVFP.ProcessId") <> 'N'
       This.oVFP = CREATEOBJECT("VisualFoxpro.Application")
       this.oVFP.OLEServerBusyRaiseError = .F.
    ENDIF

    * This app will kill the vfp9.exe process if it hangs up
    * on a user dialog that we can't possibly respond to.
    *---------------------------------------------------------
    DECLARE INTEGER ShellExecute IN SHELL32.DLL ;
      INTEGER nWinHandle, ;
      STRING  cOperation, ;
      STRING  cFileName, ;
      STRING  cParameters, ;
      STRING  cDirectory, ;
      INTEGER nShowWindow

    TRY
      SHELLEXECUTE(_SCREEN.HWND, "OPEN", _VFP.SERVERNAME,;
                 TRANSFORM(This.oVfp.APPLICATION.PROCESSID) + " " + m.cBuildTime, SYS(2023), .F.)
    CATCH
        * ignore temp...
    ENDTRY                 

    * Open the project
    *
    * The only time This call should error is when opening the project
    * causes a dialog box, hangs and is killed by KillProcess.exe.
    * Therefore, we don't need to call This.CloseVFP() in the CATCH.
    *-----------------------------------------------------------------
    TRY

      This.oVFP.DOCMD('MODIFY PROJECT "' + This.cProject + '" NOSHOW NOWAIT')

    CATCH

      This.ErrorMsg("Failed to open project " + This.cProject + " (KILLED)") 

      lKilled = .T.

    ENDTRY

    IF m.lKilled = .T.

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

      * BUILD DLL c:\Sanitex\vfpbuild.dll FROM VfpBuild RECOMPILE
      * BUILD EXE c:\Sanitex\vfpbuild.exe FROM VfpBuild RECOMPILE
      
      lReturn = This.oVFP.ACTIVEPROJECT.BUILD(m.cOutputPath + This.cOutputName,;
                EVL(This.nBuildAction, 3), fBuildAll, fShowErr )

      lcMsg = This.oVFP.StatusBar
      
    CATCH

      lcMsg = This.oVFP.StatusBar
      lcMsg = MESSAGE()
      This.ErrorMsg("Failed " + lcMsg + " to build project "  + This.cProject + " (KILLED)")

      lKilled = .T.

    ENDTRY

    IF m.lKilled = .T.

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

  FUNCTION SetVfp(oVfp as object)
    This.oVfp = NVL(oVfp, _VFP)

  FUNCTION CloseVfp()

    * Manually close VFP here
    *------------------------
    IF TYPE("oVFP.hWnd") = 'N'    
       This.oVFP.QUIT()
    ENDIF
 
    This.oVFP = .NULL.

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
    
    This.DSID = SET("Datasession")    
    This.fBuildAll = .F.
    This.lClose = .T.

  ENDFUNC
  

ENDDEFINE
