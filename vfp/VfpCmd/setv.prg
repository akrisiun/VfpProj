* SETV
* Revision 1.4  2008/02/12 10:56:45  andriusk  * APP version
* Revision 1.10  2004/11/29 12:31:55 andriusk * PrjVw2 call
* Revision 1.3  2004/05/20 06:36:55  andriusk  * Fix [] in macros, ".LITE" param

* SETV **********************************************************8
LPARAMETERS tExtra1, tExtra2  

#DEFINE DEBUG_VERSION .F. && VERSION(2) <> 0 
#DEFINE APP_VERSION .T. 
#DEFINE THISPATH ""

#IF NOT APP_VERSION 
    #DEFINE SYSPATH D:\Vfplib\Sys\
    #DEFINE VFPLIBROOT    [D:\Vfplib\]
    #DEFINE VFPLIBPATH    [D:\Vfplib\Prg\]
    #DEFINE PRGPATH       [D:\Vfplib\Prg\]
    #DEFINE EXTPATH       [D:\Vfplib\Ext\]
    #DEFINE FILEV FILE
#ELSE 
    #DEFINE SYSPATH
    #DEFINE VFPLIBROOT    []
    #DEFINE VFPLIBPATH    []
    #DEFINE PRGPATH       []
    #DEFINE EXTPATH       []
    *#DEFINE FILEV FILEV2
    #DEFINE FILEV  !EMPTY
#ENDIF 
*IF ! DEBUG_VERSION 
*   RETURN .F. 
*ENDIF

IF WEXIST( "Standard"  )
   HIDE WINDOW "Standard" 
ENDIF 
IF _VFP.Caption = "Palaukite..."  OR "Microsoft" $ _VFP.Caption  
   _VFP.Caption = ADDBS( FULLPATH( CURDIR() ) ) 
   _SCREEN.BackColor = RGB( 124, 177, 143 )
   *_SCREEN.BackColor = RGB( 50, 96, 152 )
ENDIF

tExtra1 = IIF( TYPE( "tExtra1" ) # "C", "", tExtra1  )

IF VERSION( 5) >= 800 
TRY
    RELEASE PAD _MWI_CASCADE OF _MWINDOW 

    RELEASE PAD _MWI_ARRAN OF _MWINDOW
    RELEASE PAD _MWI_SP100 OF _MWINDOW

    DEFINE BAR _MWI_VIEW OF _MWINDOW ;
       PROMPT "\<Data session (SET)" KEY Ctrl+F5, "Ctrl+F5"

    DEFINE BAR _MWI_PROPERTIES OF _MWINDOW ;
       PROMPT "\<Properties Window" KEY Alt+F5, "Alt+F5"  

    DEFINE BAR _MFI_CLOSE OF _MFILE  AFTER _MFI_OPEN ;
       PROMPT "\<Close" KEY Ctrl+F4, "Ctrl+F4"

    SET SKIP OF BAR _MFI_CLALL OF _MFILE  .F. 

    DEFINE BAR _MFI_CLALL OF _MFILE      PROMPT "Close All" ;
         AFTER _MFI_CLOSE 

    SET SKIP OF BAR _MFI_CLALL OF _MFILE  .F. 

CATCH
 * menu error
ENDTRY 
ENDIF 


IF ! "DEF_LIB" $ UPPER( SET( "PROCEDURE" )  )  
   
   DO CASE
     CASE FILE("d:\vfplib\prg\Def_Lib.prg")  
       SET PROCEDURE TO ("d:\vfplib\prg\Def_Lib.prg") ADDITIVE  
     *CASE APP_VERSION 
     *  SET PROCEDURE TO Def_Lib.prg   
   ENDCASE   
ENDIF  

SET ASSERTS ON 
* ASSERT .F.  
IF TYPE( "_SCREEN.oMnuSetV.Name" ) # "C" AND FILEV([SYSPATH] + "setvhook.prg" )
  WITH  _SCREEN
     .AddProperty( "oMnuSetV", .F. ) 
     .oMnuSetV = NEWOBJECT( "MenuBarRef_Hook", [SYSPATH] + "setvhook.prg" ) 
     =TYPE( ".oMnuSetV.Name" ) = 'C' AND .oMnuSetV.Refresh() 

    .AddProperty("cSetVSysPath", [SYSPATH])
    .AddProperty("cSetVPrgPath", PRGPATH )
    .AddProperty("cApp", .F. )
  ENDWITH      
ENDIF  
IF TYPE( "_SCREEN.oMnuSetV.Name" ) # "C" 
   RETURN .F. 
ENDIF 

IF FILE( "d:\Vfplib\CopyDbc.App") AND ATC(".LITE", tExtra1 ) = 0 
   
   LOCAL lSaveIcon , lSaveCapt
   lSaveIcon = _SCREEN.Icon 
   lSaveCapt = _SCREEN.Caption 

   _SCREEN.LockScreen = .T.
   
   *IF FILEV("Def_Lib.prg")     
   *   SET PROCEDURE TO ("Def_Lib") ADDITIVE 
   *ENDIF 
   _SCREEN.oMnuSetV.AddProperty( "cApp", "d:\Vfplib\CopyDbc.App" ) 
   
   SET PROCEDURE TO ("d:\Vfplib\CopyDbc.App") ADDITIVE 
   
   DO ("d:\Vfplib\CopyDbc.App")

   _SCREEN.LockScreen = .T.

   IF TYPE( "_SCREEN.oDSET" ) = 'O' 

      _SCREEN.oDSET.Hide()
      _SCREEN.oDSET.Release()
      _SCREEN.oDSET = .F. 
 
   ENDIF
   ACTIVATE SCREEN 
   RELEASE PROCEDURE ("d:\Vfplib\CopyDbc.App")  
   
   _SCREEN.Icon    = lSaveIcon 
   _SCREEN.Caption = lSaveCapt 
   _SCREEN.LockScreen = .F.

ENDIF 
     
=IniMenu()  
SET SYSMENU SAVE  

IF "Unknown Project" $ _SCREEN.Caption  ;
   AND FILE( "d:\Vfplib\sys\start.prg" ) 

    _SCREEN.Caption  = "Unknown"
    DO GetPrj IN  d:\Vfplib\sys\start.prg
ENDIF  


*#########################################################################
FUNCTION CleanMenu 


SET SYSMENU TO DEFAULT 
SET SYSMENU TO _MSM_FILE, _MEDIT, _MSM_TEXT, _MVIEW, _MWINDOW, _MPROG, _MTOOLS 

IF TYPE("_SCREEN.appsetvname") = 'C' AND FILEV( "d:\Vfplib\sys\SetV.prg")
   DO ("d:\Vfplib\sys\SetV.prg") WITH ".LITE" 
ENDIF 

IF FILE("D:\beta\Start.prg")
   DO ("D:\beta\Start")
ENDIF 

SET SYSMENU SAVE 
RETURN .T. 


FUNCTION SetVLite 
  RETURN SetV( ".LITE" )  

*#########################################################################
FUNCTION CleanPath 

IF FILEV( "d:\Vfplib\prg\def_lib.prg")
   DO ("DefIniPath") IN ("d:\Vfplib\prg\def_lib.prg")
ENDIF

*#########################################################################
FUNCTION IniMenu
* DO IniMenu IN d:\Vfplib\sys\setV 

IF TYPE( "_SCREEN.AppSetVName" ) # "C" 
   _SCREEN.AddProperty("AppSetVName", "?") 
   *_SCREEN.oMnuSetV = .F. 
ENDIF    
IF (TYPE("_SCREEN.AppSetVName" ) # "C" OR ! FILE(_SCREEN.AppSetVName)) ;
   AND FILE(SYS(16, 1)) 
      _SCREEN.AppSetVName = SYS(16, 1)
ENDIF 

DEFINE PAD _padTools  OF _MSYSMENU PROMPT "SetV-extensions" COLOR SCHEME 3 

#DEFINE SKIP_NAPP   SKIP FOR TYPE( "_SCREEN.oMnuSetV.cApp" ) # "C"  ;
                         AND TYPE( "_SCREEN.oDSET.Name" ) # "C" 
                         
#DEFINE INAPP   IN  (_SCREEN.AppSetVName) 


ON PAD     _padTools  OF _MSYSMENU ACTIVATE POPUP popTools
*-----------          ---------------------------------------
DEFINE POPUP popTools MARGIN RELATIVE SHADOW COLOR SCHEME 4

DEFINE BAR       1 OF popTools PROMPT "Data Sessions" SKIP_NAPP ;
        MESSAGE " Bar 1 OF popTools  :" + "DO DSet.prg IN " + _SCREEN.AppSetVName 
ON SELECTION BAR 1 OF popTools DO Call_Dset IN ([SYSPATH] +"SetV.prg")
 
DEFINE BAR       2 OF popTools PROMPT "Browse" ;      
        SKIP FOR !FILE(FULLPATH([SYSPATH] + "..\Ext\Br.prg")) ;
        MESSAGE " Bar 1 OF popTools  :" + "DO Br.prg IN " ;
                + FULLPATH([SYSPATH] + "..\Ext\Br.prg") 
                
ON SELECTION BAR 2 OF popTools DO (FULLPATH([SYSPATH] + "..\Ext\Br.prg"))

DEFINE BAR       3 OF popTools PROMPT "View structure" ;
                   SKIP FOR !FILEV([SYSPATH] + "VStru.prg")  
ON SELECTION BAR 3 OF popTools DO ([SYSPATH] +"VStru.prg")

DEFINE BAR       4 OF popTools PROMPT "CopyDbc.scx" SKIP_NAPP ;
        MESSAGE " Bar 4 OF popTools  :" ;
        + "DO FORM " + [SYSPATH] + "CopyDbc.scx IN " + _SCREEN.AppSetVName  

*TODO:             SKIP FOR ! FILEV([THISPATH] + "CopyDbc.scx")  
ON SELECTION BAR 4 OF popTools  DO CopyDbc

** ON SELECTION BAR 4 OF popTools EXECSCRIPT( [DO ("]+VFPLIBROOT+[CopyDbc1.app")] ;
                               + CHR(13) + [DO ("]+[SYSPATH]+[setv.prg")] ) 

* DEFINE BAR       5 OF popTools PROMPT "Data Sql"  SKIP_NAPP
* ON SELECTION BAR 5 OF popTools DO (THISPATH + "frm\DSql.prg") INAPP

DEFINE BAR       6 OF popTools PROMPT "VFP commands*"  ; 
                SKIP FOR ! FILEV( [SYSPATH] + "SetV.prg" )   ; 
        MESSAGE " Bar 6 OF popTools  :" + "DO Call_VfpCmd IN "+ [SYSPATH] +"SetV.prg" 
ON SELECTION BAR 6 OF popTools DO Call_VfpCmd IN ([SYSPATH] +"SetV.prg")
*ON SELECTION BAR 6 OF popTools DO (THISPATH + "frm\VfpCmd.prg")  INAPP

LOCAL ln1 
ln1 = 30    && 7  

  
IF DEBUG_VERSION   

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "VFP Objects/properties "  ; 
            SKIP FOR  ! FILEV( [SYSPATH] +"VFPProp.prg" )
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] +"VFPProp.prg")

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "\-" 

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "Program Combo (SYS\PCbo)" ;
                              SKIP FOR ! FILEV([SYSPATH] + "PCbo.prg")  
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "PCbo.prg")  

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "DSet Combo (SYS\DCbo)" ;
                              SKIP FOR ! FILEV([SYSPATH] + "DCbo.prg")  
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "DCbo.prg")  

*!*        ln1 = ln1 +  1 
*!*        DEFINE BAR       (ln1) OF popTools PROMPT "Vfp Commands (SYS\VfpCmd)" ;
*!*                                  SKIP FOR ! FILEV([SYSPATH] + "VfpCmd.prg")  
*!*        ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "VfpCmd.prg")  

    ln1 = ln1 +  1 
    =RefreshCurDir( ln1 ) 
    ln1 = ln1 +  2
    
    DEFINE BAR       (ln1) OF popTools PROMPT "Project view (SYS\PrjVw2)" ;
                              SKIP FOR ! FILEV([SYSPATH] + "PrjVw2.prg")  
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "PrjVw2.prg")  

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "ViewVcx SHOW" ;
                              SKIP FOR ! FILEV([SYSPATH] + "ViewVcx.prg")  
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "ViewVcx.prg") ;
                                          WITH ".SHOW" 
    * DO d:\vfplib\sys\viewvcx.prg WITH ".NOSHOW" 

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "FilerW" ;
                              SKIP FOR ! FILEV([SYSPATH] + "FilerW.prg")  ;
                                    OR ! FILEV(VFPLIBROOT + "FilerW.App" )  
                                         
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "FilerW.prg")  

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "Cursor Field values -> String SYS\Curs2Str.prg" ;
                              SKIP FOR ! FILEV([SYSPATH] + [Curs2Str.prg])  
    ON SELECTION BAR (ln1) OF popTools ;
                  EXECSCRIPT([DO ] + [SYSPATH] + [Curs2Str.prg])  

    ln1 = ln1 +  1  

    DEFINE BAR       (ln1) OF popTools PROMPT "Browse Resources" ;
            SKIP FOR ! FILEV([SYSPATH] + "BrowRes.prg" )
    ON SELECTION BAR (ln1) OF popTools DO ([SYSPATH] + "BrowRes.prg")  

    ln1 = ln1 +  1 

    DEFINE BAR       (ln1) OF popTools PROMPT "Browse VCX/SCX" ;
                        SKIP FOR ! FILEV([SYSPATH] + "BrowF2.prg" )  
    ON SELECTION BAR (ln1) OF popTools ;
                  EXECSCRIPT( [DO ] + [SYSPATH] + [BrowF2.prg] )  

    ln1 = ln1 +  1  
    DEFINE BAR       (ln1) OF popTools PROMPT "ClipF - Clipboard " ;
                        SKIP FOR ! FILEV(EXTPATH + "ClipF.prg" )  
    ON SELECTION BAR (ln1) OF popTools ;
                  EXECSCRIPT( [DO ] + EXTPATH + [ClipF.prg] )  

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "\-"

    ln1 = ln1 +  1 
    DO InitScr WITH (ln1)

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "CleanUp2 ALL" ;
            SKIP FOR ! FILEV(VFPLIBPATH + "CleanUp2.prg" ) 
    ON SELECTION BAR (ln1) OF popTools ;
                  EXECSCRIPT( [DO ] + VFPLIBPATH + [CleanUp2.prg] )  

                  * DO (VFPLIBPATH + "CleanUp2.prg")   

    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "CleanObj IN CleanUp2 " ;
            SKIP FOR ! FILEV(VFPLIBPATH + "CleanUp2.prg" ) 
            
    ON SELECTION BAR (ln1) OF popTools ;
                 EXECSCRIPT( "DO CleanObj IN "+ VFPLIBPATH + "CleanUp2.prg" )  
    
    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "SET PATH EXT (PS in CleanUp2)" ;
            SKIP FOR ! FILEV(VFPLIBPATH + "CleanUp2.prg" ) 
    
    ON SELECTION BAR (ln1) OF popTools ;
                 EXECSCRIPT( "DO PS IN "+ VFPLIBPATH + "CleanUp2.prg" )  

    LOCAL lcCmd 
    lcCmd = "DO d:\vfplib\sys\setv.prg" 
    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "Reinit Operations (SetV)"
    ON SELECTION BAR (ln1) OF popTools &lcCmd

    LOCAL lcCmd 
    lcCmd = "DO d:\webstack\start.prg" 
    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "START Extend (Start)" ;
                           SKIP FOR ! FILE("d:\webstack\start.prg" ) 
    ON SELECTION BAR (ln1) OF popTools &lcCmd

    lcCmd = "DO c_base IN d:\vfplib\Prg\cleanup.prg" 
    ln1 = ln1 +  1  
    DEFINE BAR       (ln1) OF popTools PROMPT "Clean BaseObj IN CleanUp" ;
                           SKIP FOR ! FILEV("CleanUp.prg" ) 
    ON SELECTION BAR (ln1) OF popTools &lcCmd

    lcCmd = "DO CleanMenu IN d:\vfplib\sys\setv.prg" 
    ln1 = ln1 +  1 
    DEFINE BAR       (ln1) OF popTools PROMPT "Lite Menu (CleanMenu IN SetV, \S\Start)"
    ON SELECTION BAR (ln1) OF popTools &lcCmd
    
ENDIF 

FUNCTION CopyDbc

  DO FORM ([SYSPATH] + "CopyDbc.scx") 

FUNCTION RefreshCurDir(ln1)
 
 IF EMPTY(ln1)
    ln1 = 9 
 ENDIF
 LOCAL lcWhen 
 lcWhen = ".F." 
 && [! TYPE("_VFP.ActiveProject.HomeDir" ) = "C"]  
 ** ".F."  && RefreshCurDir( "+ TRANSFORM( ln1 ) +" )" 
                           
 IF TYPE("_VFP.ActiveProject.HomeDir") = "C"  
    DEFINE BAR       (ln1) OF popTools PROMPT "CD Project HomeDir " ;
                         +  UPPER( _VFP.ActiveProject.HomeDir ) ;
                SKIP FOR &lcWhen ;
                MESSAGE  EVALUATE( [" Bar "+ TRANSFORM( ln1 ) + " OF popTools  :"] ) + ;
                         EVALUATE( ["CurrentDir= " + FULLPATH( CURDIR() ) ;
                               +  " Prj= " + FULLPATH( _VFP.ActiveProject.HomeDir )] ) 
    ON SELECTION BAR (ln1) OF popTools CD (_VFP.ActiveProject.HomeDir)

    ln1 = ln1 + 1 
    DEFINE BAR (ln1) OF popTools PROMPT "Requery " + FORCEEXT(_VFP.ActiveProject.Name, "XML") ;
                SKIP FOR &lcWhen ;
                MESSAGE " Prj= " + ADDBS(FULLPATH(_VFP.ActiveProject.HomeDir)) ;
                                   + FORCEEXT(_VFP.ActiveProject.Name, "XML")    

    ON SELECTION BAR (ln1) OF popTools DO PrjXmlRequery IN ([SYSPATH] + [PrjVwHook.prg]) 
    
 ELSE 
    DEFINE BAR (ln1) OF popTools PROMPT "Requery PROJECT ?" ;
                SKIP FOR &lcWhen ;
                MESSAGE  EVALUATE( [" Bar "+ TRANSFORM( ln1 ) + " OF popTools  :"] ) + ;
                         EVALUATE( ["CurrentDir= " + FULLPATH( CURDIR() ) ;
                               +  " Prj= <no>"] ) 
    ON SELECTION BAR (ln1) OF popTools DO PrjXmlRequery IN ([SYSPATH] + [PrjVwHook.prg]) 
 ENDIF 
 RETURN .F. 
 
DEFINE CLASS BarRef_Hook  AS Custom 

   FUNCTION Refresh
  
ENDDEFINE


*!*    #DEFINE DEBUG_VERSION  VERSION(2) <> 0 
*!*    #DEFINE THISPROG ("d:\prg\setv.prg") 

*!*    IF WEXIST( "Standard"  )
*!*       HIDE WINDOW "Standard" 
*!*    ENDIF 
*!*    *ASSERT .F. 

*!*    WITH _SCREEN
*!*        IF TYPE( ".oSetV" ) = 'U' 
*!*            _SCREEN.AddProperty( "oSetV", .F. ) 
*!*        ENDIF 
*!*        IF TYPE( ".oSetV" ) = 'U' 
*!*           RETURN .F.
*!*        ENDIF 

*!*        IF TYPE( ".oSetV.Name" ) # 'C' 
*!*           .oSetV = NEWOBJECT( "OSETV_Object", "", "", tExtra1 )
*!*        ENDIF 
*!*        IF TYPE( ".oSetV.Name" ) # 'C' 
*!*           RETURN .F. 
*!*        ENDIF 
*!*        .oSetV.Reinit( tExtra1 )
*!*    ENDWITH 
*!*    RETURN .T. 


*!*    DEFINE CLASS OSetV_Object AS Custom 

*!*      cApp =  "d:\Vfplib\CopyDbc.App"
*!*      cParam1 = ""

*!*      lSaveIcon = _SCREEN.Icon 
*!*      lSaveCapt = _SCREEN.Caption 

*!*      FUNCTION Init ( tExtra1, tExtra2 ) 
*!*        SET ASSERTS ON 
*!*        RETURN .T. 
*!*        
*!*      FUNCTION  Reinit ( tExtra1 )
*!*       WITH This 
*!*            .cParam1 = tExtra1 

*!*            IF FILE( .cApp )
*!*                DO (.cApp)

*!*                IF TYPE( "_SCREEN.oDSET" ) = 'O' 
*!*                  _SCREEN.oDSET.Release()
*!*                  _SCREEN.oDSET = .F.
*!*                ENDIF 
*!*               _SCREEN.Icon    = .lSaveIcon 
*!*               _SCREEN.Caption = .lSaveCapt 
*!*            ENDIF 

*!*            
*!*            * .ReinitMenu()
*!*            .ReinitMenuMin()

*!*       ENDWITH 
*!*       _SCREEN.oSetV = This 

*!*      FUNCTION  ReinitMenuMin()

*!*        DEFINE PAD _padTools  OF _MSYSMENU PROMPT "\<Operations" COLOR SCHEME 3 ;
*!*            KEY ALT+O, "" 
*!*            
*!*        ON PAD     _padTools  OF _MSYSMENU ACTIVATE POPUP popTools
*!*       
*!*      FUNCTION  ReinitMenu()
*!*      
*!*          DEFINE PAD _padTools  OF _MSYSMENU PROMPT "Operat\<ions" COLOR SCHEME 3 ;
*!*            KEY ALT+I, "" 

*!*            ON PAD     _padTools  OF _MSYSMENU ACTIVATE POPUP popTools
*!*            *-----------          ---------------------------------------
*!*            DEFINE POPUP popTools MARGIN RELATIVE SHADOW COLOR SCHEME 4

*!*           #DEFINE INAPP    IN (_SCREEN.oSetV.cApp)
*!*           #DEFINE SKIP_NAPP  SKIP FOR TYPE( "_SCREEN.oSetV.cApp" ) # 'C'
*!*           
*!*            DEFINE BAR       1 OF popTools PROMPT "Data Sessions" SKIP_NAPP
*!*            ON SELECTION BAR 1 OF popTools DO ("DSet.prg") INAPP

*!*            DEFINE BAR       2 OF popTools PROMPT "Browse" SKIP_NAPP
*!*            ON SELECTION BAR 2 OF popTools DO ("Brow.prg") INAPP

*!*            DEFINE BAR       3 OF popTools PROMPT "View structure" SKIP_NAPP
*!*            ON SELECTION BAR 3 OF popTools DO ("ViewStru.prg") INAPP

*!*            DEFINE BAR       4 OF popTools PROMPT "Copy dbc"   SKIP_NAPP
*!*            ON SELECTION BAR 4 OF popTools DO FORM ("CopyDbc") INAPP

*!*            DEFINE BAR       5 OF popTools PROMPT "Data Sql"  SKIP_NAPP
*!*            ON SELECTION BAR 5 OF popTools DO FORM ("DSql") INAPP

*!*            DEFINE BAR       6 OF popTools PROMPT "VFP commands"  SKIP_NAPP
*!*            ON SELECTION BAR 6 OF popTools DO ("VfpCmd.prg") IN INAPP

*!*            IF DEBUG_VERSION 
*!*                DEFINE BAR       20 OF popTools PROMPT "\-"

*!*                DEFINE BAR       21 OF popTools PROMPT "Sysmenu default"
*!*                ON SELECTION BAR 21 OF popTools SET SYSMENU TO DEFAULT 

*!*                DEFINE BAR       22 OF popTools PROMPT "Reinit "
*!*                ON SELECTION BAR 22 OF popTools DO THISPROG
*!*            ENDIF 
*!*            
*!*       ENDFUNC          
*!*      
*!*    ENDDEFINE 

*!*    *####################################################################################
*!*     FUNCTION SetV_MenuTools
*!*    *####################################################################################

*!*    #DEFINE THISPATH ""

*!*    DEFINE PAD _padTools  OF _MSYSMENU PROMPT "\<Operations" COLOR SCHEME 3 ;
*!*        KEY ALT+O, "" 
*!*        
*!*    ON PAD     _padTools  OF _MSYSMENU ACTIVATE POPUP popTools
*!*    *-----------          ---------------------------------------
*!*    DEFINE POPUP popTools MARGIN RELATIVE SHADOW COLOR SCHEME 4

*!*    DEFINE BAR       1 OF popTools PROMPT "Data Sessions"
*!*    ON SELECTION BAR 1 OF popTools DO (THISPATH + "frm\DSet")

*!*    DEFINE BAR       2 OF popTools PROMPT "Browse"
*!*    ON SELECTION BAR 2 OF popTools DO (THISPATH + "frm\Brow")

*!*    DEFINE BAR       3 OF popTools PROMPT "View structure"
*!*    ON SELECTION BAR 3 OF popTools DO (THISPATH + "frm\ViewStru")

*!*    DEFINE BAR       4 OF popTools PROMPT "Copy dbc"
*!*    ON SELECTION BAR 4 OF popTools DO FORM (THISPATH + "frm\CopyDbc")

*!*    DEFINE BAR       5 OF popTools PROMPT "Data Sql"
*!*    ON SELECTION BAR 5 OF popTools DO FORM (THISPATH + "frm\DSql")

*!*    DEFINE BAR       6 OF popTools PROMPT "VFP commands"
*!*    ON SELECTION BAR 6 OF popTools DO (THISPATH + "frm\VfpCmd")

*!*    IF DEBUG_VERSION 
*!*        DEFINE BAR       20 OF popTools PROMPT "\-"
*!*        DEFINE BAR       21 OF popTools PROMPT "Sysmenu default"
*!*        ON SELECTION BAR 21 OF popTools SET SYSMENU TO DEFAULT 
*!*    ENDIF 


*!*    *####################################################################################
*!*    FUNCTION SetV_EditMenu
*!*    *####################################################################################

*!*    IF VERSION(2)=0                             && jei exe'kas
*!*       SET SYSMENU TO
*!*    ENDIF   
*!*    SET SYSMENU AUTOMATIC

*!*    DEFINE PAD _MSM_EDIT OF _MSYSMENU PROMPT "\<Edit" COLOR SCHEME 3 ;
*!*        AFTER _MFILE ;
*!*        KEY ALT+E, ""
*!*    ON PAD _MSM_EDIT OF _MSYSMENU ACTIVATE POPUP _Medit

*!*    DEFINE POPUP _medit MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*    DEFINE BAR _MED_UNDO OF _medit PROMPT "\<Undo" ;
*!*        KEY CTRL+U, "^U"
*!*    DEFINE BAR _MED_REDO OF _medit PROMPT "\<Redo" ;
*!*        KEY CTRL+R, "^R"
*!*    DEFINE BAR _MED_SP100 OF _medit PROMPT "\-"
*!*    DEFINE BAR _MED_CUT OF _medit PROMPT "Cu\<t" ;
*!*        KEY CTRL+X, "^X"
*!*    DEFINE BAR _MED_COPY OF _medit PROMPT "\<Copy" ;
*!*        KEY CTRL+C, "^C"
*!*    DEFINE BAR _MED_PASTE OF _medit PROMPT "\<Paste" ;
*!*        KEY CTRL+V, "^V"
*!*    DEFINE BAR _MED_CLEAR OF _medit PROMPT "Clear"
*!*    DEFINE BAR _MED_SP200 OF _medit PROMPT "\-"
*!*    DEFINE BAR _MED_SLCTA OF _medit PROMPT "Select \<All" ;
*!*        KEY CTRL+A, "^A"

*!*    DEFINE BAR _MED_SP300 OF _medit PROMPT "\-"
*!*    DEFINE BAR _MED_GOTO OF _medit PROMPT "Goto \<Line..."
*!*    DEFINE BAR _MED_FIND OF _medit PROMPT "\<Find..." ;
*!*        KEY CTRL+F, "^F"
*!*    DEFINE BAR _MED_FINDA OF _medit PROMPT "Find A\<gain" ;
*!*        KEY CTRL+G, "^G"
*!*    DEFINE BAR _MED_REPL OF _medit PROMPT "R\<eplace And Find Again" ;
*!*        KEY CTRL+E, "^E"
*!*    DEFINE BAR _MED_REPLA OF _medit PROMPT "Replace All"

*!*    DEFINE BAR _MED_SP400 OF _medit PROMPT "\-"
*!*    DEFINE BAR _MED_PREF OF _medit PROMPT "Prefere\<nces..."



FUNCTION Call_DSet 

IF TYPE([_SCREEN.AppSetVName]) # 'C' ;
   OR ! FILE(_SCREEN.AppSetVName) 
   RETURN .F. 
ENDIF 

* SET PROCEDURE TO Def_Lib ADDITIVE  
DO ("DSet.prg") INAPP 

IF TYPE( "_SCREEN.oDSET" ) # 'O' 
   RETURN .F.
ENDIF  
WITH _SCREEN.oDSET 
  .MinHeight = 60
  .MaxHeight = 1000
  .MaxWidth  = 500 
  .lst1.ColumnWidths = "80,360"
ENDWITH 


FUNCTION Call_VfpCmd 

* DO (THISPATH + "frm\VfpCmd.prg")  INAPP
* RELEASE PROCEDURE VfpCmd 

CLEAR PROGRAM VfpCmd 
IF FILE( [D:\Vfplib\Sys\VfpCmd.Prg]  ) 
   DO ([D:\Vfplib\Sys\VfpCmd.Prg]) 
ENDIF 
ON KEY LABEL CTRL+F3 
 

FUNCTION FileNames 

PUBLIC oFSO AS Scripting.FileSystemObject 
oFSO = CreateObject("Scripting.FileSystemObject")
PUBLIC aDriv  AS Object 
aDriv = oFSO.Drives
DISPLAY MEMORY LIKE aDriv


oFSO = CreateObject("Scripting.FileSystemObject")
oFSO.CopyFile("c:\temp\TEST.TXT", "c:\My Documents\TEST.TXT")


FUNCTION Trans1 
 ? TRANSFORM( RECNO(), '@0' )            && hex 
 ? TRANSFORM( RECNO(), "@L 9999999999")  && PADL 0 at left 
 
FUNCTION FILEV2(tcFile)
  RETURN FILE(tcFile) OR UPPER(JUSTEXT(tcFile)) = "PRG" AND APP_VERSION 

FUNCTION InitScr(ln1, lNorm)
 
 ASSERT ln1 > 0 
 IF ! lNorm
    DEFINE BAR  (ln1) OF popTools PROMPT "Maximize Scr" ;
            SKIP FOR ! FILEV([SYSPATH] + "SetV.prg" )    
    EXECSCRIPT( "ON SELECTION BAR " + TRANSFORM(ln1) + " OF popTools " ;
              + [DO MaxScr IN ] + [SYSPATH] + [SetV.prg WITH ]+ TRANSFORM(ln1) )  
 ELSE
    DEFINE BAR  (ln1) OF popTools PROMPT "Normal Scr" ;
            SKIP FOR ! FILEV([SYSPATH] + "SetV.prg" )    
    EXECSCRIPT( "ON SELECTION BAR " + TRANSFORM(ln1) + " OF popTools " ;
               + [DO NormScr IN ] + [SYSPATH] + [SetV.prg WITH ]+ TRANSFORM(ln1) ) 
 
 ENDIF 

 IF TYPE([gedset.Name])='C' AND PEMSTATUS(geDSet, "POS", 5 )
    gedset.pos()
 ENDIF 
 
FUNCTION MaxScr(ln1)

 _SCREEN.TitleBar = 0
 _SCREEN.WindowState = 2
 IF TYPE([ln1])='N' 
    DO InitScr WITH ln1, .T. 
 ENDIF 
 
FUNCTION NormScr(ln1)

 _SCREEN.TitleBar = 1
 _SCREEN.WindowState = 2
 IF TYPE([ln1])='N' 
    DO InitScr WITH ln1
 ENDIF 
