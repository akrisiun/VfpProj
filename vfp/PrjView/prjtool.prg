* Main of PRJ

#DEFINE NEED_TOAPP .F. 
#DEFINE BMPDIR     ""
* [D:\Vfplib\Sys\Bmp\]
* -- MessageBox parameters
#DEFINE MB_OK                   0       && OK button only
#DEFINE MB_OKCANCEL             1       && OK and Cancel buttons
#DEFINE MB_ABORTRETRYIGNORE     2       && Abort, Retry, and Ignore buttons
#DEFINE MB_YESNOCANCEL          3       && Yes, No, and Cancel buttons
#DEFINE MB_YESNO                4       && Yes and No buttons
#DEFINE MB_RETRYCANCEL          5       && Retry and Cancel buttons

#DEFINE MB_ICONSTOP             16      && Critical message
#DEFINE MB_ICONQUESTION         32      && Warning query
#DEFINE MB_ICONEXCLAMATION      48      && Warning message
#DEFINE MB_ICONINFORMATION      64      && Information message

*-- MsgBox return values
#DEFINE IDOK            1       && OK button pressed
#DEFINE IDCANCEL        2       && Cancel button pressed
#DEFINE IDABORT         3       && Abort button pressed
#DEFINE IDRETRY         4       && Retry button pressed
#DEFINE IDIGNORE        5       && Ignore button pressed
#DEFINE IDYES           6       && Yes button pressed
#DEFINE IDNO            7       && No button pressed

WITH _SCREEN
    IF TYPE([._oProjectToolbar.ThisFile]) # "C"  
        .AddProperty('_oProjectToolbar',NULL)
        ._OProjectToolbar = NEWOBJECT('CProjectToolbar') 
        ._OProjectToolbar.ThisFile = SYS(16) 
    ENDIF 
    * ._OProjectToolbar.Dock( 0 )
    ._OProjectToolbar.Top  = 5 
    ._OProjectToolbar.Left = .Width - 100
    ._OProjectToolbar.Visible = .T.
ENDWITH

**************************************************
*-- Class:        cprojecttoolbar (\projecttoolbar.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*
DEFINE CLASS cprojecttoolbar AS toolbar

  Caption = "Build Project"
  Height = 28
  Left = 10
  Name = "cprojecttoolbar" 
  Top = 10 
  
  ThisFile = PROGRAM() 
  Width = 109
  rebuildguids = .F.

  ADD OBJECT cmdbuild AS commandbutton WITH ;
        Caption = "" ;
      , Enabled = .F. ;
      , Height = 22 ;
      , Left = 5 ;
      , Name = "cmdBuild" ;
      , Picture = BMPDIR + "Prjbuildapp.bmp" ;
      , SpecialEffect = 2 ;
      , ToolTipText = "Build Project" ;
      , Top = 3 ;
      , Width = 23
 
 #IF NEED_TOAPP
  ADD OBJECT cmdrebuildalltoapp AS commandbutton WITH ;
        Caption = "" ;
      , Enabled = .F. ;
      , Height = 22 ;
      , Left = 28 ;
      , Name = "cmdRebuildAllToApp" ;
      , Picture = BMPDIR + "Prjrebuildall.bmp" ;
      , SpecialEffect = 2 ;
      , ToolTipText = "Rebuild All" ;
      , Top = 3 ;
      , Width = 23
 #ENDIF 

  ADD OBJECT cmdrebuildallnoexe AS commandbutton WITH ;
        Caption = "" ;
      , Enabled = .F. ;
      , Height = 22 ;
      , Left = 51 ;
      , Name = "cmdRebuildAllNoEXE" ;
      , Picture = BMPDIR + "Prjcompile.bmp" ;
      , SpecialEffect = 2 ;
      , ToolTipText = "Recompile All" ;
      , Top = 3 ;
      , Width = 23

  ADD OBJECT separator1 AS separator WITH ;
        Height = 0 ;
      , Left = 81 ;
      , Name = "Separator1" ;
      , Style = 1 ;
      , Top = 3 ;
      , Width = 0

  ADD OBJECT cmdoptions AS commandbutton WITH ;
        Caption = "" ;
      , Enabled = .F. ;
      , Height = 22 ;
      , Left = 81 ;
      , Name = "cmdOptions" ;
      , Picture = BMPDIR + "Prjoptions.bmp" ;
      , SpecialEffect = 2 ;
      , ToolTipText = "Options" ;
      , Top = 3 ;
      , Width = 23

  ADD OBJECT tmrProject AS Timer WITH ;
        Height = 0 ;
      , Interval = 300 ;
      , Left = 103 ;
      , Name = "tmrProject" ;
      , Top = 3 ;
      , Width = 0

  FUNCTION MouseMove(nButton,nShift, nXCoord, nYCoord)
     IF This.cmdOptions.Enabled # (TYPE([_vfp.ActiveProject.Name]) = "C") 
        This.FoundProject()
     ENDIF 
  
  FUNCTION FoundProject

     DO CASE
       CASE TYPE([_vfp.ActiveProject.Name]) # "C"
        This.SetAll([Enabled], .F.)
        RETURN .F.
       CASE ! This.cmdOptions.Enabled 
        This.SetAll([Enabled], .T.)
     ENDCASE
     RETURN .T. 
     
  
  PROCEDURE buildproject
    ***********************************************************************************************
    * Version....: 1.0
    * VFP Version: 08.00.0000.3117
    * Author.....: Richard E. Hamm
    * Date.......: 2/2/2004 
    ***********************************************************************************************
    * Notes....:
    *
    ***********************************************************************************************
    * Modifications:
    
    ***********************************************************************************************
    LPARAMETERS tlRebuildAll as Boolean
    
    IF ! This.FoundProject()
       RETURN .F.
    ENDIF 
    
    LOCAL oProject as Object ;
        , lnOldWorkArea as Integer ;
        , lsBuildName as String
    
    lnOldWorkArea = SELECT(0)
    
    IF !USED('ProjectToolbar')
        USE (HOME(0) + 'ProjectToolbar.dbf') IN 0 ;
            ALIAS ProjectToolbar ORDER ProjID
        IF !USED('ProjectToolbar')
           ERROR [no ]+ HOME(0) + 'ProjectToolbar.dbf' 
           RETURN .F.
        ENDIF 
    ENDIF
    
    GO TOP IN ProjectToolbar
    
    && Do we have an entry?
    IF !SEEK(VAL(SYS(2007, UPPER(_vfp.ActiveProject.Name), 0, 1)), 'ProjectToolbar', 'ProjID')
        IF MESSAGEBOX("Project Options have not been set. Set them now?" ;
            ,   MB_ICONEXCLAMATION + MB_YESNO) = IDYES
    
            This.cmdOptions.Click() 
            RETURN .F.
    
        ENDIF
    ENDIF
    
    SELECT ProjectToolbar
    SCATTER NAME oProject MEMO
    USE IN (SELECT('ProjectToolbar'))
    
    lsBuildName = IIF(EMPTY(oProject.BldName) ;
                , LOWER(ADDBS(JUSTPATH(_vfp.ActiveProject.Name)) ;
                  + JUSTSTEM(_VFP.ActiveProject.Name)  ;
                  + IIF(oProject.BuildType >= 4, ".dll" ;
                      , IIF(oProject.BuildType = 3, ".exe",".app"))) ;
                , oProject.BldName)
    
    && Uses new setting for the BldName.
    lsExecute = "_VFP.ActiveProject.Build('" + lsBuildName + "', "  ;
                  + TRANSFORM(oProject.BuildType, "@R 9") + ", "  ;
                  + TRANSFORM(tlRebuildAll) + ", "  ;
                  + TRANSFORM(oProject.DispErr) + ", "  ;
                  + TRANSFORM(THIS.RebuildGUIDS) + ")"
    
    EXECSCRIPT(lsExecute)
    
    THIS.RebuildGUIDs = .F.
    SELECT (lnOldWorkArea)
    
    IF oProject.RunAftBld AND INLIST(oProject.BuildType, 2, 3)
       DO (oProject.BldName)
    ENDIF
  ENDPROC
  
  PROCEDURE Init
    ***********************************************************************************************
    * Version....: 1.0
    * VFP Version: 08.00.0000.3117
    * Author.....: Richard E. Hamm
    * Date.......: 2/2/2004 
    ***********************************************************************************************
    * Notes....: 
    *
    ***********************************************************************************************
    * Modifications:
    && Modified the ProjectToolbar.dbf to use a CRC32-Checksum (SYS(2007,X,0,1)) instead of ProjName as key
    && Modified the ProjectToolbar.dbf to use a user formatted file name for the EXE/DLL.
    && Included a section to update the DBF to new record format. 
    && Unable to come up with a way to salvage old data though
    
    ***********************************************************************************************
    
    SET ASSERTS ON 
    
    IF ! FILE( HOME(0) + 'ProjectToolbar.dbf' )

        IF MESSAGEBOX("Project Toolbar table does not exist. Do you want to create it now?" ;
                , MB_ICONQUESTION + MB_YESNO) = IDYES
            
            CREATE TABLE (HOME(0) +'ProjectToolbar.dbf') FREE ;
                (FullProj M NOCPTRANS ;
                , UniqueID B(0) ;
                , BuildType I ;
                , DispErr L ;
                , RunAftBld L ;
                , BldName M NOCPTRANS ;
               )
    
            SELECT ProjectToolbar
            INDEX ON UniqueID TAG ProjID
            
            USE IN (SELECT('ProjectToolbar'))
    
        ELSE
            RETURN FALSE
    
        ENDIF
    ELSE
        IF USED([ProjectToolbar])
           USE IN ProjectToolbar
        ENDIF 
        USE (HOME(0) + 'ProjectToolbar.dbf') IN 0 ;
            ALIAS ProjectToolbar EXCLUSIVE
    
        IF RECSIZE('ProjectToolbar') != 23
            IF MESSAGEBOX("Your Project Toolbar table needs to be updated before using this version. "  ;
                  + "You will lose your current settings. Continue?" ;
                        , MB_ICONEXCLAMATION + MB_YESNO) = IDYES
    
                SELECT ProjectToolbar
                DELETE TAG ALL 
                DELETE FROM ProjectToolbar
                ALTER TABLE ProjectToolbar DROP ProjName
                ALTER TABLE ProjectToolbar ADD UniqueID B(0)
                ALTER TABLE ProjectToolbar ADD BldName M NOCPTRANS
                INDEX ON UniqueID TAG ProjID CANDIDATE
    
            ELSE
                USE IN (SELECT('ProjectToolbar'))
                RETURN FALSE
            ENDIF    
        ENDIF
    
        USE IN (SELECT('ProjectToolbar'))
    
    ENDIF
  ENDPROC
  
  PROCEDURE cmdbuild.Click
    This.Parent.BuildProject(.F.)

#IF NEED_TOAPP
   
  PROCEDURE cmdrebuildalltoapp.Click
    THIS.Parent.BuildProject(.T.)
#ENDIF 

  PROCEDURE cmdrebuildallnoexe.RightClick
    THIS.Parent.BuildProject(.T.)
  ENDPROC

  
  PROCEDURE cmdrebuildallnoexe.Click

    LOCAL oProject as Object 
    LOCAL lnOldWorkArea as Integer
    
    lnOldWorkArea = SELECT(0)

    ASSERT !USED('ProjectToolbar')
    IF !USED('ProjectToolbar')
        USE (HOME(0) + 'ProjectToolbar.dbf') IN 0 ;
            ALIAS ProjectToolbar ORDER ProjID
    ENDIF 
        
    IF !SEEK(VAL(SYS(2007, UPPER(_vfp.ActiveProject.Name), 0, 1)), 'ProjectToolbar', 'ProjID')
        IF MESSAGEBOX("Project Options have not been set. Set them now?" ;
            , MB_ICONEXCLAMATION + MB_YESNO) = IDYES
            
            THIS.cmdOptions.Click
            RETURN .F.
    
        ENDIF
    ENDIF
    
    SELECT ProjectToolbar
    SCATTER NAME oProject MEMO
    USE IN (SELECT('ProjectToolbar'))
    
    SELECT (lnOldWorkArea)
    
    _VFP.ActiveProject.Build(, 1, .T. ;
                , oProject.DispErr ;
                , THIS.Parent.RebuildGUIDs )
  ENDPROC

  PROCEDURE cmdoptions.RightClick 
    ThisForm.tmrProject.Enabled = .F. 
  
  PROCEDURE cmdoptions.Click 
    
    IF ! This.Parent.FoundProject() 
       RETURN .F.
    ENDIF 
    DO OptionsForm  
    
  ENDPROC
  
  PROCEDURE tmrProject.Timer
    IF TYPE('_VFP.ActiveProject') != "O"
        THIS.Parent.SetAll('Enabled', .F., 'COMMANDBUTTON')
    ELSE
        THIS.Parent.SetAll('Enabled', .T., 'COMMANDBUTTON')
    ENDIF
    This.Enabled = .F. 

ENDDEFINE
*
*-- EndDefine: cprojecttoolbar
**************************************************


**************************************************
*-- Class:        coptionsform (\projecttoolbar.vcx)
*-- ParentClass:  form
*-- BaseClass:    form 

FUNCTION OptionsForm 

    LOCAL o AS cOptionsForm 

    o = NEWOBJECT( "cOptionsForm" ) 
    o.SHow() 

ENDFUNC 


DEFINE CLASS coptionsform AS form

  AutoCenter = .T.
  BorderStyle = 2
  Caption = "Project Options"
  DoCreate = .T.
  Height = 361
  MaxButton = .F.
  MinButton = .F.
  Name = "coptionsform"
  Width = 345
  WindowType = 1
  versioncomments =[]
  versioncompany =[]
  versioncopyright =[]
  versionfiledescript =[]
  versionlanguageid = 0
  versionproductname =[]
  versiontrademarks =[]

  ADD OBJECT cmdok AS commandbutton WITH ;
        Caption = "OK" ;
      , Default = .T. ;
      , FontName = "MS Sans Serif" ;
      , Height = 24 ;
      , Left = 188 ;
      , Name = "cmdOK" ;
      , Top = 334 ;
      , Width = 71

  ADD OBJECT cmdcancel AS commandbutton WITH ;
        Cancel = .T. ;
      , Caption = "Cancel" ;
      , FontName = "MS Sans Serif" ;
      , Height = 24 ;
      , Left = 267 ;
      , Name = "cmdCancel" ;
      , Top = 334 ;
      , Width = 71

  ADD OBJECT pgfbuildoptions AS pgf_pageframe WITH ;
        ErasePage = .T. ;
      , Height = 322 ;
      , Left = 6 ;
      , Name = "pgfBuildOptions" ;
      , pagBuildOptions.Caption = "Build Options" ;
      , pagBuildOptions.FontName = "MS Sans Serif" ;
      , pagVersionData.Caption = "Version Data" ;
      , pagVersionData.FontName = "MS Sans Serif" ;
      , TabStyle = 1 ;
      , Top = 6 ;
      , Width = 334

   * , PageCount = 2 ;


  PROCEDURE Init

    ***********************************************************************************************
    * Version....: 1.0        Author.....: Richard E. Hamm   Date.......: 2/2/2004 
    LOCAL oProject as Object
    
    IF !USED('ProjectToolbar')
        USE (HOME(0) + 'ProjectToolbar.dbf') IN 0;
            ALIAS ProjectToolbar;
            ORDER ProjID
    
    ENDIF
    
    GO TOP IN ProjectToolbar
    IF !SEEK(VAL(SYS(2007, UPPER(_VFP.ActiveProject.Name),0,1)), 'ProjectToolbar','ProjID')
        INSERT INTO ProjectToolbar;
            (UniqueID,;
            FullProj,;
            BuildType,;
            DispErr,;
            RunAftBld,;
            BldName);
            VALUES;
            (VAL(SYS(2007, UPPER(_VFP.ActiveProject.Name), 0, 1)),;
            _VFP.ActiveProject.Name,;
            2,;        && Build_App
            .T.,;
            .F.,;
            "")
    
    ENDIF
    
    GO TOP IN ProjectToolbar
    IF SEEK(VAL(SYS(2007, UPPER(_VFP.ActiveProject.Name), 0, 1)), 'ProjectToolbar','ProjID')
        SELECT ProjectToolbar
        SCATTER NAME oProject MEMO
    
        USE IN (SELECT('ProjectToolbar'))
    
        IF UPPER(ALLTRIM(_VFP.ActiveProject.Name)) == UPPER(ALLTRIM(oProject.FullProj))
            WITH THISFORM.pgfBuildOptions.pagBuildOptions
                .cboBuildType.ListIndex = oProject.BuildType - 1
                .chkRunAfterBuild.Value = oProject.RunAftBld
                .chkShowErrors.Value = oProject.DispErr
                .txtFileName.Value = oProject.BldName
    
            ENDWITH    && THISFORM
    
            WITH THISFORM.pgfBuildOptions.pagVersionData
                .chkAutoIncrement.Value = _VFP.ActiveProject.AutoIncrement
                .txtMajor.Value = LEFT(_VFP.ActiveProject.VersionNumber,;
                                   ATC('.', _VFP.ActiveProject.VersionNumber) - 1)
    
                .txtMinor.Value = SUBSTR(_VFP.ActiveProject.VersionNumber,;
                                    ATC('.', _VFP.ActiveProject.VersionNumber) + 1,;
                                    ATC('.', _VFP.ActiveProject.VersionNumber, 2) -;
                                    ATC('.',_VFP.ActiveProject.VersionNumber) - 1)
    
                .txtRevision.Value = RIGHT(_VFP.ActiveProject.VersionNumber,;
                                      LEN(_VFP.ActiveProject.VersionNumber) -;
                                      ATC('.', _VFP.ActiveProject.VersionNumber, 2))
    
                .lstVersionType.ListIndex = 1
    
            ENDWITH
    
            WITH _VFP.ActiveProject
                THISFORM.VersionComments = .VersionComments
                THISFORM.VersionCompany = .VersionCompany
                THISFORM.VersionCopyright = .VersionCopyright
                THISFORM.VersionFileDescript = .VersionDescription
                THISFORM.VersionProductName = .VersionProduct
                THISFORM.VersionLanguageID = .VersionLanguage
                THISFORM.VersionTrademarks = .VersionTrademarks
    
            ENDWITH
        ENDIF
    ENDIF
    
    THISFORM.Caption = "Project Options for " + LOWER(JUSTSTEM(_vfp.ActiveProject.Name))
  ENDPROC
  
  PROCEDURE cmdok.Click
    ***********************************************************************************************
    * Version....: 1.0
    * VFP Version: 08.00.0000.3117
    * Author.....: Richard E. Hamm
    * Date.......: 2/2/2004 
    ***********************************************************************************************
    * Notes....:
    *
    ***********************************************************************************************
    * Modifications:
    
    ***********************************************************************************************
    LOCAL oProject, lnOldWorkArea, lnBuildType, llRunAfterBuild,;
         llDispErr, lsBuildName, lnUniqueID, lsFullProj
    
    lnOldWorkArea = SELECT(0)
    
    WITH THISFORM.pgfBuildOptions

        WITH .pagBuildOptions
            USE (HOME(0) + 'ProjectToolbar.dbf') IN 0;
                ALIAS ProjectToolbar;
                ORDER ProjID
    
            lsFullProj = _vfp.ActiveProject.Name
            lnBuildType = .cboBuildType.ListIndex + 1
            llDispErr = .chkShowErrors.Value
            llRunAfterBuild = .chkRunAfterBuild.Value
            lsBuildName = ALLTRIM(.txtFileName.Value)
            lnUniqueID = VAL(SYS(2007, UPPER(_VFP.ActiveProject.Name), 0, 1))
    
            UPDATE ProjectToolbar ;
                  SET FullProj = lsFullProj ;
                    , BuildType = lnBuildType ;
                    , DispErr = llDispErr ;
                    , RunAftBld = llRunAfterBuild ;
                    , BldName = lsBuildName ;
                WHERE UniqueID = lnUniqueID
            
            IF TYPE( "_SCREEN._oProjectToolbar.RebuildGUIDs" ) # "U" 
                _SCREEN._oProjectToolbar.RebuildGUIDs = .chkRegenerateGUIDs.Value
            ENDIF 
    
            USE IN (SELECT('ProjectToolbar'))
    
        ENDWITH
    ENDWITH    && THISFORM.pgfBuildOptions
    
    WITH _VFP.ActiveProject
        .AutoIncrement = THISFORM.pgfBuildOptions.pagVersionData.chkAutoIncrement.Value 
        .VersionComments = THISFORM.VersionComments
        .VersionCompany = THISFORM.VersionCompany
        .VersionCopyright = THISFORM.VersionCopyright
        .VersionDescription = THISFORM.VersionFileDescript
        .VersionLanguage = THISFORM.VersionLanguageID
        .VersionTrademarks = THISFORM.VersionTrademarks
        .VersionProduct = THISFORM.VersionProductName
        .VersionNumber = ALLTRIM(THISFORM.pgfBuildOptions.pagVersionData.txtMajor.Value) + "."  ;
                  + ALLTRIM(THISFORM.pgfBuildOptions.pagVersionData.txtMinor.Value) + "."  ;
                  + ALLTRIM(THISFORM.pgfBuildOptions.pagVersionData.txtRevision.Value)
    
    ENDWITH
    
    SELECT (lnOldWorkArea)
    THISFORM.Release
  ENDPROC
  
  PROCEDURE cmdcancel.Click
    THISFORM.Release
  ENDPROC


  PROCEDURE pgfbuildoptions.pagBuildOptions.cbobuildtype.Init
    THIS.AddItem("Application (app)", 1)
    THIS.AddItem("Win 32 executable/COM Server (exe)", 2)
    THIS.AddItem("Single-threaded COM Server (dll)", 3)
    THIS.AddItem("Multi-threaded COM Server (dll)", 4)
  ENDPROC
  
  PROCEDURE pgfbuildoptions.pagBuildOptions.cmdfilename.Click
    ***********************************************************************************************
    * Version....: 1.0
    * VFP Version: 08.00.0000.3117
    * Author.....: Richard E. Hamm
    * Date.......: 6/25/2004 
    ***********************************************************************************************
    * Notes....:
    *
    ***********************************************************************************************
    * Modifications:
    
    ***********************************************************************************************
    LOCAL lsOldFileName,;
         lsNewFileName
    
    lsOldFileName = IIF(EMPTY(THIS.Parent.txtFileName.Value),;
                    ADDBS(JUSTPATH(_VFP.ActiveProject.Name))  ;
                  + JUSTSTEM(_VFP.ActiveProject.Name)  ;
                  + IIF(THIS.Parent.cboBuildType.ListIndex + 1>=4,;
                        ".dll",;
                        IIF(THIS.Parent.cboBuildType.ListIndex + 1=3,;
                            ".exe",;
                            ".app")),;
                    THIS.Parent.txtFileName.Value)
    
    lsNewFileName = PUTFILE("FileName", lsOldFileName, "exe;app;dll")
    
    IF EMPTY(lsNewFileName)
        RETURN
    
    ENDIF
    
    THIS.Parent.txtFileName.Value = LOWER(ALLTRIM(lsNewFileName))
  ENDPROC
  
  PROCEDURE pgfbuildoptions.pagVersionData.lstversiontype.Init
    WITH THIS
        .AddItem('Comments', 1)
        .AddItem('Company Name', 2)
        .AddItem('File Description', 3)
        .AddItem('Legal Copyright', 4)
        .AddItem('Legal Trademarks', 5)
        .AddItem('Product Name', 6)
        .AddItem('Language ID', 7)
    
    ENDWITH    && THIS
  ENDPROC
  
  PROCEDURE pgfbuildoptions.pagVersionData.lstversiontype.InteractiveChange
    
    ***********************************************************************************************
    DO CASE 
        CASE THIS.ListIndex = 1
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionComments'
            THIS.Parent.edtValue.MaxLength = 254
        
        CASE THIS.ListIndex = 2
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionCompany'
            THIS.Parent.edtValue.MaxLength = 254
    
        CASE THIS.ListIndex = 3
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionFileDescript'
            THIS.Parent.edtValue.MaxLength = 254
    
        CASE THIS.ListIndex = 4
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionCopyright'
            THIS.Parent.edtValue.MaxLength = 254
    
        CASE THIS.ListIndex = 5
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionTrademarks'
            THIS.Parent.edtValue.MaxLength = 254
    
        CASE THIS.ListIndex = 6
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionProductName'
            THIS.Parent.edtValue.MaxLength = 254
    
        CASE THIS.ListIndex = 7
            THIS.Parent.edtValue.ControlSource = 'THISFORM.VersionLanguageID'
            THIS.Parent.edtValue.MaxLength = 19
    
    ENDCASE
  ENDPROC
   
  PROCEDURE pgfbuildoptions.pagVersionData.lstversiontype.ProgrammaticChange
    this.InteractiveChange() 
  ENDPROC


ENDDEFINE
*
*-- EndDefine: coptionsform
**************************************************



DEFINE CLASS pgf_pageframe AS PageFrame 

   ErasePage = .T. 
   Height = 322 
   Left = 6 
   Name = "pgfBuildOptions" 
   PageCount = 0  
   
   *    PageCount = 2  
  
  ADD OBJECT pagBuildOptions AS BuildPage With ;     
        Caption = "Build Options" ;
      , FontName = "MS Sans Serif" ;

*        Name = "pagBuildOptions" ;

  ADD OBJECT pagVersionData AS VersionPage With ;     
         Caption = "Version Data" ;
       , FontName = "MS Sans Serif" ;

 *       , Name = "pagVersionData" ;




ENDDEFINE 


DEFINE CLASS BuildPage  AS Page 
 
  ADD OBJECT txtfilename AS textbox WITH ;
        FontName = "MS Sans Serif" ;
      , Height = 23 ;
      , Left = 14 ;
      , Name = "txtFileName" ;
      , Top = 181 ;
      , Width = 283

  ADD OBJECT shpbuildoptions AS shape WITH ;
        Height = 134 ;
      , Left = 14 ;
      , Name = "shpBuildOptions" ;
      , SpecialEffect = 0 ;
      , Top = 17 ;
      , Width = 267

  ADD OBJECT cbobuildtype AS combobox WITH ;
        FontName = "MS Sans Serif" ;
      , Height = 24 ;
      , Left = 88 ;
      , Style = 2 ; 
      , Name = "cboBuildType" ;
      , Top = 28 ;
      , Width = 179

  ADD OBJECT lblbuildtype AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Build Type:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 29 ;
      , Name = "lblBuildType" ;
      , Top = 33 ;
      , Width = 55

  ADD OBJECT chkshowerrors AS checkbox WITH ;
        AutoSize = .T. ;
      , Caption = "Show Errors after build" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 88 ;
      , Name = "chkShowErrors" ;
      , Top = 65 ;
      , Value = .T. ;
      , Width = 124

  ADD OBJECT chkregenerateguids AS checkbox WITH ;
        AutoSize = .T. ;
      , Caption = "Regenerate Component IDs" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 88 ;
      , Name = "chkRegenerateGUIDs" ;
      , Top = 91 ;
      , Value = .F. ;
      , Width = 150

  ADD OBJECT chkrunafterbuild AS checkbox WITH ;
        AutoSize = .T. ;
      , Caption = "Run After Build" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 88 ;
      , Name = "chkRunAfterBuild" ;
      , Top = 117 ;
      , Value = .F. ;
      , Width = 89

  ADD OBJECT lblfilename AS label WITH ;
        AutoSize = .T. ;
      , Caption = "EXE/DLL file name:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 14 ;
      , Name = "lblFileName" ;
      , Top = 166 ;
      , Width = 96

  ADD OBJECT cmdfilename AS commandbutton WITH ;
        Caption = "..." ;
      , Height = 23 ;
      , Left = 296 ;
      , Name = "cmdFileName" ;
      , Top = 181 ;
      , Width = 23

ENDDEFINE 


DEFINE CLASS VersionPage AS Page 


  ADD OBJECT shpversioninfo AS shape WITH ;
        Height = 149 ;
      , Left = 10 ;
      , Name = "shpVersionInfo" ;
      , SpecialEffect = 0 ;
      , Top = 138 ;
      , Width = 304

  ADD OBJECT shpversionnumber AS shape WITH ;
        Height = 90 ;
      , Left = 10 ;
      , Name = "shpVersionNumber" ;
      , SpecialEffect = 0 ;
      , Top = 21 ;
      , Width = 242

  ADD OBJECT lblversionnumber AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Version Number:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 15 ;
      , Name = "lblVersionNumber" ;
      , Top = 12 ;
      , Width = 80

  ADD OBJECT lblmajor AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Major:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 27 ;
      , Name = "lblMajor" ;
      , Top = 37 ;
      , Width = 31

  ADD OBJECT lblminor AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Minor:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 101 ;
      , Name = "lblMinor" ;
      , Top = 37 ;
      , Width = 31

  ADD OBJECT lblrevision AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Revision:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 170 ;
      , Name = "lblRevision" ;
      , Top = 37 ;
      , Width = 46

  ADD OBJECT txtmajor AS textbox WITH ;
        FontName = "MS Sans Serif" ;
      , Format = "KTR" ;
      , Height = 23 ;
      , InputMask = "9999" ;
      , Left = 20 ;
      , Name = "txtMajor" ;
      , Top = 56 ;
      , Width = 54

  ADD OBJECT txtminor AS textbox WITH ;
        FontName = "MS Sans Serif" ;
      , Format = "KTR" ;
      , Height = 23 ;
      , InputMask = "9999" ;
      , Left = 99 ;
      , Name = "txtMinor" ;
      , Top = 56 ;
      , Width = 54

  ADD OBJECT txtrevision AS textbox WITH ;
        FontName = "MS Sans Serif" ;
      , Format = "KTR" ;
      , Height = 23 ;
      , InputMask = "9999" ;
      , Left = 173 ;
      , Name = "txtRevision" ;
      , Top = 56 ;
      , Width = 54

  ADD OBJECT chkautoincrement AS checkbox WITH ;
        AutoSize = .T. ;
      , Caption = "Auto-Increment" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 22 ;
      , Name = "chkAutoIncrement" ;
      , Top = 88 ;
      , Width = 90

  ADD OBJECT lstversiontype AS listbox WITH ;
        FontName = "MS Sans Serif" ;
      , Height = 108 ;
      , Left = 16 ;
      , Name = "lstVersionType" ;
      , Top = 171 ;
      , Width = 103

  ADD OBJECT edtvalue AS editbox WITH ;
        FontName = "MS Sans Serif" ;
      , Height = 109 ;
      , Left = 123 ;
      , Name = "edtValue" ;
      , Top = 170 ;
      , Width = 164

  ADD OBJECT lblvalue AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Value:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 123 ;
      , Name = "lblValue" ;
      , Top = 152 ;
      , Width = 32

  ADD OBJECT lbltype AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Type:" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 20 ;
      , Name = "lblType" ;
      , Top = 152 ;
      , Width = 29

  ADD OBJECT lblversioninfo AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Version Information" ;
      , FontName = "MS Sans Serif" ;
      , Height = 15 ;
      , Left = 15 ;
      , Name = "lblVersionInfo" ;
      , Top = 130 ;
      , Width = 92

ENDDEFINE 



FUNCTION PFiles_Tree 

* ProjFiles ( File, Index, Type, Comment, KeyFile ) 
*  FName, Ext, SubDir, Modif, Size * 



