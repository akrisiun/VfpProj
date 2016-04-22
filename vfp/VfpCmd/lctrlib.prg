*$Id: lctrlib.prg,v 1.3 2008/02/12 10:56:45 andriusk Exp $
* LCtrLib.prg: L_* Ctrl's Library 

*$Log: lctrlib.prg,v $
*Revision 1.3  2008/02/12 10:56:45  andriusk
*APP version
*
*Revision 1.7  2006/03/15 14:15:33  andriusk
*Geri pakeitimai 2006-03
*
*Revision 1.6  2005/03/29 06:39:06  andriusk
*Agen, AXSP tables H:\ECOM" usecfg.xml
*
*Revision 1.5  2005/03/04 16:43:25  andriusk
*Less debugout (minimal)
*
*Revision 1.4  2005/02/18 09:21:49  andriusk
*KeyPress .oActive = .ActiveControl
*FormTreeKey - keypress lookup
*FormCmd() - macro/ExecScript
*
*Revision 1.3  2005/02/03 08:53:09  andriusk
*LObj RightClick, some fixes
*
*Revision 1.2  2004/11/29 12:30:59  andriusk
*uRetVal fixes, L_Save/Restore Pos funcs

#DEFINE ASSERT_DEB  ASSERT .F. MESSAGE 
#DEFINE VFPLIB_PATH D:\Vfplib

#DEFINE APP_VERSION .T. 
* TYPE([_SCREEN.AppSetVName]) = 'C'
#IF APP_VERSION 
   #DEFINE LIB_PATH
#ELSE
   #DEFINE LIB_PATH D:\Vfplib\Sys\
#ENDIF 
#DEFINE DEFFONT [MS Sans Serif]

#DEFINE TEST_TREEKEY .T. 

*######################################################################## 
DEFINE CLASS L_FORM AS Form

    Top = -1
    Left = 0
    Height = 118
    Width = 375
    DoCreate = .T.
    ShowTips = .T.
    Caption = "L_Form"
    FontName = "Tahoma"
    
    Visible = .T. 
    KeyPreview = .T.

    DSID = 0
    Cmd_Last = "" 
    XML = "" 
    
    noldHeight = 0
    noldWidth = 0
    cIniFilename = [LIB_PATH] + [Def.Ini] 
    isRestoreposition = .T.
    isIgnoreerrors = .F.
    Last_WOnTop = ""

    uRetVal = .T.
    uReturnVal = .NULL.             && Form's return value
    lNoDefault = .NULL. 
    
    MinButton = .F. 
    MaxHeight = 1200 
    MaxWidth = 500
   
    HookPrg = ""
    oHook = .NULL. 
    oAction = .NULL.
    oActive = .NULL. 
    oAppObject = .NULL.
    oCfg = .NULL. 
    oFirstCtrl = .NULL. 

    FUNCTION Exec( tcCmd ) 
      DO FormCmd WITH This, tcCmd        && IN THISFILE 
      RETURN This.uRetVal 

    *######################################################################## 
    FUNCTION RefreshForm
        WITH This
          .LockScreen = .T.
          .Refresh()
          .LockScreen = .F.
        ENDWITH

    *######################################################################## 
    FUNCTION SaveProp( tcParKey, tcKey, tcValue )

        *-- Write the entry to the INI file
        DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
          String cSection, String cKey, String cValue, String cINIFile

        =WritePrivStr( tcParKey, tcKey, tcValue, This.cIniFileName )

    *######################################################################## 
    FUNCTION RestoreProp( lcParKey, lcKey )

        DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
             String cSection, String cKey, String cDefault, String @cBuffer ;
           , Integer nBufferSize, String cINIFile

        DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
          String cSection, String cKey, String cValue, String cINIFile

        LOCAL lcBuffer, lnLen

        lcBuffer = SPACE(200)+CHR(0)
        lnLen    =  0
        IF FILE( This.cIniFileName )
           This.cIniFileName = FULLPATH( This.cIniFileName ) 
           lnLen =  GetPrivStr( lcParKey, lcKey, "" ;
                              , @lcBuffer, LEN(lcBuffer), This.cIniFileName ) 
        ENDIF                         
        IF lnLen = 0
           RETURN ""
        ENDIF
        lcBuffer = LEFT( lcBuffer, lnLen )
        RETURN lcBuffer 

    *######################################################################## 
    FUNCTION SetRect( tObject, tLeft, tTop, tWidth, tHeight )

        WITH tObject 
          .Left = tLeft
          .Top  = tTop
          .Width  = tWidth
          .Height = tHeight
        ENDWITH


    *######################################################################## 
    FUNCTION Load
        WITH This
             .DSID = SET( "DATASESSION" )  
             SET ASSERTS ON 
             .uRetVal = .T. 
             .cIniFileName = FULLPATH( This.cIniFileName )       

             DO CASE
                CASE LEFT( .cIniFileName, 2 ) > 'D:'
                 .cIniFileName = ADDBS( SYS( 2023) ) ;
                               + JUSTFNAME( .cIniFileName )
                CASE DIRECTORY( [VFPLIB_PATH] )    
                   .cIniFileName = ADDBS( [VFPLIB_PATH] ) ;
                                 + JUSTFNAME( .cIniFileName )
             ENDCASE
             DEBUGOUT .Name + ".cIni="+ .cIniFileName
              
             .nOldHeight = .Height
             .nOldWidth =  .Width
             RETURN .uRetVal 
        ENDWITH 

    *######################################################################## 
    FUNCTION Resize( lNotLock )

        LOCAL lI, lJ, lK                                           && counters
        LOCAL nDeltaY, nDeltaX                                     && delta of X,Y
        LOCAL lOldLock
        LOCAL oThis

        WITH ThisForm
             lOldLock = .LockScreen
             IF ! lNotLock AND .Visible 
                .LockScreen = .T.
             ENDIF   
             
             nDeltaY = .Height - .nOldHeight                       && form's height delta
             nDeltaX = .Width - .nOldWidth                         && form's width delta

             .EveResize() 
             
             .nOldHeight = .Height                                 && irasom auksti
             .nOldWidth = .Width                                   && irasom ploti
             IF ! lNotLock AND .Visible 
                .LockScreen = lOldLock 
             ENDIF

        ENDWITH

    
  *######################################################################## 
  FUNCTION KeyPress( nKeyCode, nShiftAltCtrl )

    This.lNoDefault = .NULL. 
    IF TYPE( [This.ActiveControl.Name] ) = "C" 
       This.oActive = This.ActiveControl 
    ENDIF 
    DO CASE 
      CASE TYPE( [This.oActive.SingleSel] ) = 'L' ;
           AND TYPE( [This.oActive.SelectedItem.Key] ) = 'C'
           
           DO FormTreeKey WITH This, This.oActive, nKeyCode,  nShiftAltCtrl 
                            && IN THISFILE
    ENDCASE 
    IF NVL( This.lNoDefault, .F. ) 
       NODEFAULT 
    ENDIF  
    RETURN .NULL. 
  ENDPROC

  *######################################################################## 
  FUNCTION PrevObj( toCtrl AS Control )  
    RETURN TYPE( "ThisForm.ActiveControl.Name" ) # "C" 

  *######################################################################## 
  FUNCTION onError( nError, cMsg, cMethod, nLine, tObject )
    
    LOCAL oObject
    oObject = tObject 
    IF TYPE( "tObject.Name" ) # "C"
       oObject = This
    ENDIF 

    LOCAL llHandledError, lcMessage, cMessage, lnAnswer
    LOCAL laError[ 7 ]    && 7= AERRORARRAY
                  
    LOCAL nI, cPrg
        
        lcMessage = MESSAGE()
        
        =AERROR(laError)

        IF TYPE( "oObject.IsIgnoreErrors" ) = "L" AND oObject.IsIgnoreErrors
           RETURN .T.
        ENDIF

        *-- Loads the laError array with error information ------------------
        ?? CHR(7)
        lcMessage = "Error " + IIF( TYPE( "nError" ) = "N" ;
                                , ALLT( STR( nError )), '' ) ;
                                + " : "  + lcMessage
        
        lcMessage = lcMessage + CHR(13)  ;
            + " objektas "+IIF( TYPE("oObject.Name")="C", oObject.Name + CHR(13), "'', " )
                
        IF  TYPE( "cMethod" ) = "C" AND NOT EMPTY( cMethod )
            lcMessage = lcMessage +;        
                    " metodas " + cMethod + IIF( LEN( cMethod ) > 30, CHR(13), "" ) +;
                     IIF( EMPTY( nLine ), "",  " eilute " + ALLT(STR(nLine)) + CHR( 13 ) )
        ENDIF

        IF  RIGHT( SYS( 16, 0 ), 4 ) # ".EXE"           && ne exe'as

            nI = 1
            DO WHILE NOT EMPTY( PROGRAM( nI ) ) 
               nI = nI + 1
            ENDDO
            nI = nI - 1
            DO WHILE nI > 0 AND INLIST( RIGHT( PROGRAM(nI), 6 ), "TERROR", ".ERROR" )
               nI = nI - 1
            ENDDO

            cPrg = PROGRAM( nI )
            lcMessage = lcMessage + " function "+;
                         IIF( EMPTY( cPrg ), "-", cPrg +;
                          IIF( LEN( cPrg ) > 15, CHR(13), '' ) )
            cPrg = PROGRAM( nI - 1 )                     
            IF NOT EMPTY( cPrg )
                lcMessage = lcMessage + "  ( " + cPrg  +;
                                    IIF( LEN( cPrg ) > 15, CHR(13), '' )
                cPrg = PROGRAM( nI - 2 )                     
                IF NOT EMPTY( cPrg )
                   lcMessage = lcMessage + "  \ " + cPrg   ;
                             + IIF( LEN( cPrg ) > 15, CHR(13), '' )
                ENDIF
                lcMessage = lcMessage + " ) "
             ENDIF
           IF nError # 39   ;
            AND nError # 108  
                             && 108-File is used by another ...
                             && 39- Numeric overlow. Data was lost
            
              IF INLIST( UPPER( SUBSTR( cMethod, RAT( ".", cMethod )+1 ) ),;
                         "ACTIVATE", "REFRESH" )
                         
                RETURN .T.      && if "ACTIVATE" of "REFRESH" then out 
             ELSE
               * cMacro = "msg( lcMessage )"
               * &cMacro
             ENDIF
            ENDIF
         ENDIF             
        
        IF TYPE( "goApp.IsDebugMsg" ) = "L"   ;
            AND goApp.IsDebugMsg                 && if debug msg 
                goApp.DebugMsg( lcMessage )
        ENDIF
        
        lnAnswer = MessageBox( lcMessage ;
                           , 16 + 2 + 512 ;
                           , " Klaida "+ALLTRIM( STR( nError ) ) )
                          && MB_ICONSTOP + MB_ABORTRETRYIGNORE+ MB_DEFBUTTON3
        DO CASE
           CASE lnAnswer = 3        &&   IDABORT
                SUSPEND
           CASE lnAnswer = 4        &&   IDRETRY
                RETRY
           OTHERWISE
                RETURN
        ENDCASE
        RETURN llHandledError


    *######################################################################## 
    FUNCTION Activate 
      This.Last_WOnTop = WONTOP() 
      IF TYPE( [.ActiveControl.Name] ) = 'C' 
        .oActive = .ActiveControl 
      ENDIF 
      RETURN .T. 


    *######################################################################## 
    FUNCTION Deactivate 
      ACTIVATE SCREEN 
      RETURN .T. 
    
    *######################################################################## 
    FUNCTION QueryUnload       
      This.oActive = .NULL.
      RETURN .T. 

    *######################################################################## 
    FUNCTION Destroy
        This.Deactivate() 
        RETURN .T.

    *######################################################################## 
    FUNCTION Init
        WITH This
              .Icon = _SCREEN.Icon
              IF .Left > _SCREEN.ViewPortWidth  - .Width 
                 .Left = _SCREEN.ViewPortWidth  - .Width - 6
              ENDIF
              IF .Top > _SCREEN.ViewPortWidth  - .Height
                 .Top = _SCREEN.ViewPortWidth  - .Height - 6
              ENDIF
              .ExternalInit()
           RETURN .uRetVal 
        ENDWITH

    *######################################################################## 
    FUNCTION ExternalInit
       RETURN .T. 

    FUNCTION Show 
       This.EveShow() 
       IF ! This.Visible 
          This.Visible = .T. 
       ENDIF 
       IF VARTYPE( This.oFirstCtrl ) = "O"
          This.oFirstCtrl.SetFocus() 
       ENDIF 
       RETURN This.uRetVal 

    FUNCTION Hide 
       IF ! This.EveHide() 
          RETURN .F.
       ENDIF 
       This.Visible = .F. 
    
    FUNCTION EveShow

    FUNCTION EveHide

    FUNCTION EveResize( oObject, nDeltaY, nDeltaX, cAlignment, nDeltaT, nDeltaL  )
             && Event resize
    
    *     oObject,;              && (O) resaizinamas objektas, 
    *     nDeltaY, nDeltaX,;     && (N) formos aukscio ir plocio pokyciai
    *     cAlignment,;            
    *     nDeltaT, nDeltaL       && (N) delta Top, delta Left 
    
    LOCAL lnI, lnJ, lnK                              && darbiniai skaitliukai
    
    #DEFINE ISNEEDOBJALIGN  ( TYPE( ".cAlignment" ) == "C"  AND ! "H" $ .cAlignment )
    
    #DEFINE ISNEEDALIGN  (TYPE(".Controls(lnI).cAlignment") == "C" ;
                         AND LEN(.Controls(lnI).cAlignment) > 0  ;
                         AND   "1" $ .Controls(lnI).cAlignment   ;
                         AND ! "H" $ .Controls(lnI).cAlignment)
                                                     && Alignment H- hide (ignore)
                                                     && Alignment X- call method .ObjectAlign 
    #DEFINE SPECALIGN    "X" $ .Controls(lnI).cAlignment 
    
     *** -AND- PEMSTATUS( .Controls(lnI), "OBJECTALIGN", 5 )
                         
    oObject = IIF( TYPE( "oObject.Name" ) # 'C', This, oObject )             
    WITH oObject 
     IF UPPER(oObject.BaseClass) = 'FORM'
        * Init reikia : .AddProperty( "nOldWidth",  .Width  )
        *               .AddProperty( "nOldHeight", .Height ) 
         IF ! ISNEEDOBJALIGN 
            RETURN .T. 
         ENDIF
         .LockScreen = .T.                          && uzrakinam ekrana
         nDeltaY = .Height - .nOldHeight            && formos aukscio pokytis
         nDeltaX = .Width -  .nOldWidth             && formos plocio pokytis
    
         FOR lnI = 1 TO .ControlCount               && per formos objektus
             ASSERT !EMPTY( .Controls( lnI ).Name ) MESSAGE "Bad Ctrl "  
             IF ISNEEDALIGN 
                IF SPECALIGN 
                   .Controls(lnI).ObjectAlign( nDeltaY, nDeltaX)                        
                ELSE    
                   This.EveResize( .Controls(lnI), (nDeltaY), (nDeltaX),;
                                   .Controls(lnI).cAlignment  )
                 ENDIF 
             ENDIF
         ENDFOR
         IF PEMSTATUS( oObject, "OnResize", 5 )
            .OnResize()                              && papildomas 
         ENDIF    
    
         .nOldHeight = .Height                       && irasom nauja auksti
         .nOldWidth  = .Width                        && irasom nauja ploti
         .LockScreen = .F.
         RETURN .T. 
     ENDIF 
    
     LOCAL nHeight, nWidth
      
      IF .Parent.BaseClass = "Page"               && objektas yra PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
      ELSE                                        && objektas yra normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
      ENDIF
      cAlignment = IIF( EMPTY( cAlignment ), .cAlignment, cAlignment )
    
      IF ! "X" $ cAlignment 
      
         IF LEN(cAlignment) > 4 ;
            AND SUBSTR(cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(cAlignment) > 5 ;
            AND  SUBSTR(cAlignment, 6, 1) = "1"         && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
         IF LEN(cAlignment) > 2 ;
            AND SUBSTR(cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(cAlignment) > 3 ;
            AND SUBSTR(cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         
         *******
         LOCAL lnSaveDeltaY, lnSaveDeltaX
         STORE 0 TO lnSaveDeltaY, lnSaveDeltaX
         
         IF TYPE( ".aSaveDelta[1]" ) = "N" AND ! "Y" $ cAlignment 
            IF .aSaveDelta[1] # 0  
               nDeltaY = nDeltaY - .aSaveDelta[1]
               .aSaveDelta[1] = 0 
            ENDIF 
            IF .aSaveDelta[1] # 0  
               nDeltaX = nDeltaX - .aSaveDelta[2]
               .aSaveDelta[2] = 0 
            ENDIF 
         ENDIF  
         DO CASE 
            CASE .BaseClass = "Grid" 
    
              IF nDeltaY # 0 AND .Height + nDeltaY  < 20
                 lnSaveDeltaY = nDeltaY 
                 nDeltaY = 0  
              ENDIF 
              IF nDeltaX # 0 AND .Width  + nDeltaX < 10
                 lnSaveDeltaX = nDeltaX  
                 nDeltaX = 0 
              ENDIF 
              
            CASE .BaseClass = "Pageframe" 
    
              IF nDeltaY # 0 AND .PageHeight + nDeltaY  < 20
                 lnSaveDeltaY = nDeltaY 
                 nDeltaY = 0  
              ENDIF 
              IF nDeltaX # 0 AND .PageWidth + nDeltaX < 10
                 lnSaveDeltaX = nDeltaX  
                 nDeltaX = 0 
              ENDIF 
    
         ENDCASE 
         IF nDeltaY # 0  AND .Height + nDeltaY  < 1 
             lnSaveDeltaY = nDeltaY 
             nDeltaY = 0  
         ENDIF      
         IF nDeltaX # 0  AND .Width + nDeltaX  < 1 
             lnSaveDeltaX = nDeltaX 
             nDeltaX = 0  
         ENDIF      
         
         IF lnSaveDeltaY # 0 OR lnSaveDeltaX # 0 
            IF TYPE( ".aSaveDelta[1]" ) # "N" 
               .AddProperty( "aSaveDelta[4]" ) 
            ENDIF 
            .aSaveDelta[ 1 ] = - lnSaveDeltaY 
            .aSaveDelta[ 2 ] = - lnSaveDeltaX 
         ENDIF
         
         IF LEN(cAlignment) > 0 AND SUBSTR(cAlignment, 1, 1) = "1" ;
            AND .Height + nDeltaY > 0                   && Resize pagal Y
              .Height = .Height + nDeltaY
         ELSE 
            nDeltaY = 0   
         ENDIF
         IF LEN(cAlignment) > 1 AND SUBSTR(cAlignment, 2, 1) = "1" ;
            AND .Width + nDeltaX > 0                    && Resize pagal X
              .Width = .Width + nDeltaX
         ELSE 
            nDeltaX = 0   
         ENDIF
         
         
         *   nDeltaT, nDeltaL       && (N) delta Top, delta Left 
     ELSE 
         .ObjectAlign( nDeltaY, nDeltaX )          
         RETURN .T.
     ENDIF 
      
     IF nDeltaX = 0 AND nDeltaY = 0
         RETURN .T.
     ENDIF
     
     DO CASE     
      CASE UPPER(oObject.BaseClass) = "CONTAINER" 
       FOR lnI = 1 TO oObject.ControlCount           && per konteinerio objektus
           WITH oObject
             IF ISNEEDALIGN 
                IF SPECALIGN 
                   .Controls(lnI).ObjectAlign( nDeltaY, nDeltaX )                        
                ELSE    
                   This.EveResize( .Controls(lnI), (nDeltaY), (nDeltaX),;
                                   .Controls(lnI).cAlignment )
                ENDIF 
             ENDIF
           ENDWITH
       ENDFOR
     CASE UPPER(oObject.BaseClass) = "PAGEFRAME"
       IF ISNEEDOBJALIGN
         FOR lnJ = 1 TO oObject.PageCount              && per PageFrame'o puslapius
           WITH oObject.Pages(lnJ)
                FOR lnI = 1 TO .ControlCount         && per puslapio objektus
                   IF ISNEEDALIGN 
                     IF SPECALIGN 
                       .Controls(lnI).ObjectAlign( nDeltaY, nDeltaX)                        
                     ELSE    
                       This.EveResize( .Controls(lnI), (nDeltaY), (nDeltaX),;
                                       .Controls(lnI).cAlignment  )
                     ENDIF 
                   ENDIF   
                ENDFOR
           ENDWITH
         ENDFOR
       ENDIF
         
     ENDCASE 
    
    ENDWITH 
  
  FUNCTION CheckHook
    RETURN ! EMPTY( This.HookPrg ) AND FILE( This.HookPrg ) 

ENDDEFINE
#DEFINE EOF_l_form
**************************************************

*######################################################################## 
DEFINE CLASS L_checkbox AS checkbox

  * AutoSize = .T.
  BackStyle = 0
  Caption = "Check1"
  FontName = DEFFONT
  Name = "chk"
  StatusBarText = "."
  Value = .F.

  calignment = ("000000")
  lactioncompatible = .T.
  lnodefault = .F.
  savekey = [.Name] 
  savesource =[]
  uolvalue = .NULL.
  uretval = .T.
  
  FUNCTION Event(  tnAction )

  FUNCTION Objectalign(  tnDeltaY, tnDeltaX )

ENDDEFINE
*-- EndDefine: L_checkbox
**************************************************


**************************************************
DEFINE CLASS L_combobox AS Combobox

  DisabledForeColor = RGB(0,0,0)
  DisplayCount = 20
  FontName = DEFFONT
  Height = 22
  Name = "cbo"
  StatusBarText = "."
  Width = 137
  calignment = ("000000")
  lactioncompatible = .T.
  ncbowidth = 0
  uoldvalue = .NULL.
  uRetVal = .T.

  FUNCTION Init
    This.uRetVal = .T.
  
  FUNCTION objectalign( tnDeltaY, tnDeltaX )
  
  FUNCTION readonly_assign(  vNewVal )
    This.ReadOnly = m.vNewVal
    This.Enabled  = ! m.vNewVal

ENDDEFINE
**************************************************

DEFINE CLASS L_cbobutton AS L_combobox 
  Height = 24
  Width  = 20 

ENDDEFINE

**************************************************
DEFINE CLASS L_Label AS Label

  Caption = "Command1"
  FontName = DEFFONT
  FontSize = 9
  AutoSize = .T.
  calignment = ("0000")

ENDDEFINE 

**************************************************
DEFINE CLASS L_commandbutton AS commandbutton

  Caption = "Command1"
  FontName = DEFFONT
  FontSize = 9
  Height = 24
  Name = "cmd"
  StatusBarText = "."
  Width = 71
  backstyle = 1
  Themes = .T. 
  calignment = ("0000")
  lactioncompatible = .T.
  uretval = .F.
  
  FUNCTION Init
    This.uRetval = .T.
    IF TYPE( "This.Themes" ) = 'L'
       This.Themes = .F. 
    ENDIF 
    IF This.BackStyle = 0        && Opaque backstyle 
       IF TYPE( 'This.Parent.Parent.Class' ) = 'C' ;
          AND "PAGE" $ UPPER( This.Parent.Parent.Class ) ;
          AND TYPE( "This.Parent.Parent.BackColor" ) = 'N'
            This.BackColor = This.Parent.Parent.BackColor 
       ELSE    
            This.BackColor = This.Parent.BackColor 
       ENDIF 
    ENDIF 
    RETURN This.uRetVal 
  
  FUNCTION objectalign( tnDeltaY, tnDeltaX )

ENDDEFINE
**************************************************


DEFINE CLASS L_listbox AS listbox

  DisabledItemForeColor = RGB(0,0,0)
  FontName = DEFFONT
  Height = 68
  Name = [L_listbox]
  PrefName = "lst"
  SelectedItemBackColor = RGB(0,0,128)
  StatusBarText = "."
  Width = 99
  calignment = ("000000")
  hooklist =[]
  lactioncompatible = .T.
  readonly = .F.
  uRetVal = .T.
  
  FUNCTION GotFocus
    This.SelectedItemBackColor = RGB(0, 0, 128)
  
  FUNCTION LostFocus
    This.SelectedItemBackColor = RGB(0, 128, 128)
  
  FUNCTION objectalign( tnDeltaY, tnDeltaX )                
  
  FUNCTION readonly_assign( vNewVal )
    THIS.readonly = m.vNewVal
  
  FUNCTION RightClick( lcKey )
    IF ! EMPTY( This.HookList ) ;
        AND ( ! "_Lib" $ This.HookList ;
              OR "_LIB" $ UPPER(SET( "PROCEDURE" ))  )
       DO ObjRClick IN (This.HookList) WITH This, lcKey
    ENDIF 

ENDDEFINE
**************************************************


**************************************************
DEFINE CLASS L_container AS container

  BackStyle = 0
  BorderWidth = 0
  Height = 105
  Name = "cnt"
  Width = 310
  calignment = ("0000")
  hookcnt =[]
  lactioncompatible = .T.
  ofirstctrl = .NULL.
  readonly = .F.
  uretval = .T.

  
  FUNCTION enabled_assign( vNewVal )
    
    LOCAL lCtrl
    FOR EACH lCtrl IN This.Controls 
       IF TYPE( "lCtrl.lActionCompatible" ) # "L" ;
          OR lCtrl.lActionCompatible
             lCtrl.Enabled = m.vNewVal
       ENDIF 
    ENDFOR 
    This.Enabled = m.vNewVal
    
  FUNCTION event( tnEvent )
  
  FUNCTION objectalign( tnDeltaY, tnDeltaX )
    ASSERT_DEB "For whom ObjectAlign " + This.Parent.Name + "." + This.Name +" ?"
    RETURN .F. 
  
  FUNCTION readonly_assign( vNewVal )
    
    LOCAL lCtrl
    FOR EACH lCtrl IN This.Controls 
       IF TYPE( "lCtrl.ReadOnly" ) # "U" ;
          AND ( TYPE( "lCtrl.lActionCompatible" ) # "L" ;
                OR lCtrl.lActionCompatible ) 
          lCtrl.ReadOnly = m.vNewVal
       ENDIF
    ENDFOR 
    This.readonly = m.vNewVal
    
  
  FUNCTION RecordAction( tnAction )
  
  FUNCTION Valid( tObj )
    IF TYPE( "tObj.Name" ) # "C"
       RETURN ThisForm.ContainerValid( This ) 
    ENDIF
    RETURN .T.
    
  FUNCTION visible_assign( vNewVal )
    This.Visible = m.vNewVal
  
  FUNCTION When
    RETURN .T.

ENDDEFINE
**************************************************


FUNCTION ObjRClick( tObj AS Object, tcKey AS String )

RETURN .F. 

**************************************************
DEFINE CLASS L_spinner AS spinner

  DisabledForeColor = RGB(0,0,0)
  FontName = DEFFONT
  Height = 22

  Width = 113
  calignment = ("0000")

ENDDEFINE 

**************************************************
DEFINE CLASS L_textbox AS textbox

  DisabledForeColor = RGB(0,0,0)
  FontName = DEFFONT
  Height = 22
  Name = [L_textbox]
  PrefName = "txt"
  StatusBarText = "."
  Width = 113
  calignment = ("0000")
  hookctrl = [LIB_PATH] + [LCtrLib.prg]
  lactioncompatible = .T.
  lishelp = .T.
  lnodefault = .F.
  nlastkey = 0
  nnextobj = 1
  onextobj = .NULL.
  savekey = ("(.Name)")
  savesource =[]
  uoldvalue = .NULL.
  uretval = .T.

  
  FUNCTION Destroy
    This.Unload() 
    
  FUNCTION event
    LPARAMETERS tnEvent
    
  FUNCTION GotFocus
    
    This.uOldValue = This.Value 
    This.nLastkey  = 0 
    ASSERT INLIST( TYPE( "This.nNextObj" ), "N", "L", "O" )  
    
    IF This.lNoDefault 
       NODEFAULT
       This.uRetVal = .F. 
    ENDIF 
    RETURN This.uRetVal 
    
  FUNCTION Init
    IF EMPTY( This.SaveSource ) OR ! This.lActionCompatible 
       RETURN .T. 
    ENDIF 
    IF EMPTY( This.nNextobj )        && Next Obj # 0, .F. 
       This.nNextObj = 1 
    ENDIF
    IF ! EMPTY( This.ControlSource  ) 
       IF TYPE( "This.ControlSource" ) # "U" 
          This.SaveSource = This.ControlSource 
       ENDIF 
       IF TYPE( This.ControlSource ) = "U" 
          This.ControlSource = "" 
       ENDIF 
    ENDIF 
    IF This.lActionCompatible 
       This.InitSource() 
    ENDIF 
    RETURN This.uRetVal 
    
  FUNCTION initsource
    
    ASSERT TYPE( "ThisForm.Visible" ) = 'L'  
    IF TYPE( "ThisForm.Visible" ) = 'L' ;
       AND ! ThisFOrm.Visible  
       
         IF   ! EMPTY( This.ControlSource ) ;
              AND TYPE( This.ControlSource ) = 'U' 
    
            This.Comment = This.ControlSource 
            ASSERT .F. MESSAGE "" + LEFT( This.Comment, 20 )  ;
                            +  " No field  " ;
                            + " On "+ This.Name + " \ " + This.Parent.Name ;
                            + " in Form "+ ThisForm.Name     
            This.ControlSource = "" 
         ENDIF
    ENDIF 
    IF ! EMPTY( This.SaveKey ) 
       This.SaveUndo( .F. ) 
    ENDIF
    RETURN This.uRetVal 
          
  FUNCTION KeyPress( nKeyCode, nShiftAltCtrl )
    
    This.nLastKey =  nKeyCode + 1000 * nShiftAltCtrl   
    IF nKeyCode = 28 AND nShiftAltCtrl = 0 ;   && F1
       AND This.lIsHelp 
         NODEFAULT
         This.HelpClick()
       RETURN .T.
    ENDIF

    IF nKeyCode = 93 AND nShiftAltCtrl = 1     && WinProperties key 
       This.RightClick( "KEY" )
       RETURN .T. 
    ENDIF 
    * - textbox::KeyPress(  nKeyCode, nShiftAltCtrl ) 
    
  FUNCTION LostFocus
    
    This.uRetVal = .T. 
    IF TYPE( "This.oNextObj.Visible" ) = 'L' 
       This.oNextObj.SetFocus() 
       This.oNextObj = .NULL. 
    ENDIF 
    RETURN This.uRetVal 
       
  FUNCTION nextobj
    * NextObj 
    IF TYPE( [ThisForm.ActiveControl.Name] ) = 'C';
       AND ThisForm.ActiveControl.Name = This.Name 
       
       IF INLIST( This.nLastKey, 13 )  
          DO CASE 
             CASE TYPE( "This.nNextObj.Name" )  = 'C' 
                  This.oNextObj = This.nNextObj     && Next as object 
                  RETURN 1  
          ENDCASE    
          This.uRetVal = This.nNextObj
       ENDIF 
    ENDIF
    RETURN  This.uRetVal 
    
  FUNCTION objectalign( tnDeltaY, tnDeltaX  )       && Y, X koordinaciu pokyciai po formos Resize() event'o
    
  FUNCTION PrevObj 
    IF PEMSTATUS( ThisForm, "PREVOBJ", 5 )  AND ThisForm.PrevObj( This ) 
       This.uRetVal = .F. 
       RETURN .T. 
    ENDIF
    RETURN .F. 
    
  FUNCTION RightClick
    LPARAMETERS lcKey
    
    IF ! EMPTY( This.HookCtrl ) ;
        AND (  ! "def_lib" $ This.HookCtrl ;
              OR "def_lib" $ LOWER(SET( "PROCEDURE" ))  )
       DO LObjRClick IN (This.HookCtrl) WITH This, lcKey
    ENDIF 
  
  FUNCTION SaveUndo( lSave, tcKey )         && Control'o save/undo
    RETURN .F. 
  
  FUNCTION textvalid
    This.uRetVal = .T. 
  
  FUNCTION unload
    IF ! EMPTY( This.SaveKey ) 
       This.SaveUndo( .T. ) 
    ENDIF
  
  FUNCTION Valid
    ASSERT PEMSTATUS( ThisForm, "PREVOBJ", 5 ) 
    IF This.PrevObj() 
       RETURN .T. 
    ENDIF 
    
    This.uRetVal   = .T. 
    This.uOldValue = This.Value 
    *------------------------------------------------------------------- 
    This.TextValid() 
    *-------------------------------------------------------------------
    This.NextObj() 
    RETURN This.uRetVal  

ENDDEFINE
**************************************************

**************************************************
DEFINE CLASS L_EditBox AS EditBox

  DisabledForeColor = RGB(0,0,0)
  FontName = DEFFONT
  Height = 22
  Name = [L_EditBox]
  PrefName = "txt"
  StatusBarText = "."
  Width = 113
  calignment = ("0000")
  hookctrl = [LIB_PATH] + [LCtrLib.prg]

  lactioncompatible = .T.
  lishelp = .T.
  lnoDefault = .F.

  nlastkey = 0
  nnextobj = 1
  onextobj = .NULL.

  savekey = [(.Name)]
  savesource = []

  uoldvalue = .NULL.
  uretval = .T.

  
  FUNCTION Destroy
    This.Unload() 
    
  FUNCTION event
    LPARAMETERS tnEvent
    
  FUNCTION GotFocus
    
    This.uOldValue = This.Value 
    This.nLastkey  = 0 
    ASSERT INLIST( TYPE( "This.nNextObj" ), "N", "L", "O" )  
    
    IF This.lNoDefault 
       NODEFAULT
       This.uRetVal = .F. 
    ENDIF 
    RETURN This.uRetVal 
    
  FUNCTION Init
    IF EMPTY( This.SaveSource ) OR ! This.lActionCompatible 
       RETURN .T. 
    ENDIF 
    IF EMPTY( This.nNextobj )        && Next Obj # 0, .F. 
       This.nNextObj = 1 
    ENDIF
    IF ! EMPTY( This.ControlSource  ) 
       IF TYPE( "This.ControlSource" ) # "U" 
          This.SaveSource = This.ControlSource 
       ENDIF 
       IF TYPE( This.ControlSource ) = "U" 
          This.ControlSource = "" 
       ENDIF 
    ENDIF 
    IF This.lActionCompatible 
       This.InitSource() 
    ENDIF 
    RETURN This.uRetVal 
    
  FUNCTION initsource
    
    ASSERT TYPE( "ThisForm.Visible" ) = 'L'  
    IF TYPE( "ThisForm.Visible" ) = 'L' ;
       AND ! ThisFOrm.Visible  
       
         IF   ! EMPTY( This.ControlSource ) ;
              AND TYPE( This.ControlSource ) = 'U' 
    
            This.Comment = This.ControlSource 
            ASSERT .F. MESSAGE "" + LEFT( This.Comment, 20 )  ;
                            +  " No field  " ;
                            + " On "+ This.Name + " \ " + This.Parent.Name ;
                            + " in Form "+ ThisForm.Name     
            This.ControlSource = "" 
         ENDIF
    ENDIF 
    IF ! EMPTY( This.SaveKey ) 
       This.SaveUndo( .F. ) 
    ENDIF
    RETURN This.uRetVal 
    
  FUNCTION KeyPress( nKeyCode, nShiftAltCtrl )
    
    This.nLastKey =  nKeyCode + 1000 * nShiftAltCtrl   
    IF nKeyCode = 28 AND nShiftAltCtrl = 0 ;   && F1
       AND This.lIsHelp 
         NODEFAULT
         This.HelpClick()
       RETURN .T.
    ENDIF
    IF nKeyCode = 93 AND nShiftAltCtrl = 1     && WinProperties key 
       This.RightClick( "KEY" )
       RETURN .T. 
    ENDIF 
    * - textbox::KeyPress(  nKeyCode, nShiftAltCtrl ) 
    
  FUNCTION LostFocus
    
    This.uRetVal = .T. 
    IF TYPE( "This.oNextObj.Visible" ) = 'L' 
       This.oNextObj.SetFocus() 
       This.oNextObj = .NULL. 
    ENDIF 
    RETURN This.uRetVal 
       
  FUNCTION nextobj
    * NextObj 
    IF TYPE( [ThisForm.ActiveControl.Name] ) = 'C';
       AND ThisForm.ActiveControl.Name = This.Name 
       
       IF INLIST( This.nLastKey, 13 )  
          DO CASE 
             CASE TYPE( "This.nNextObj.Name" )  = 'C' 
                  This.oNextObj = This.nNextObj     && Next as object 
                  RETURN 1  
          ENDCASE    
          This.uRetVal = This.nNextObj
       ENDIF 
    ENDIF
    RETURN  This.uRetVal 
    
  FUNCTION objectalign
    LPARAMETERS tnDeltaY, tnDeltaX                   && Y, X koordinaciu pokyciai po formos Resize() event'o
    
  
  FUNCTION prevObj
    IF PEMSTATUS( ThisForm, "PREVOBJ", 5 )  AND ThisForm.PrevObj( This ) 
       This.uRetVal = .F. 
       RETURN .T. 
    ENDIF
    RETURN .F. 
    
  FUNCTION RightClick( lcKey )
    
    IF ! EMPTY( This.HookCtrl ) ;
        AND (  ! "def_lib" $ This.HookCtrl ;
              OR "def_lib" $ LOWER(SET( "PROCEDURE" ))  )
       DO LObjRClick IN (This.HookCtrl) WITH This, lcKey
    ENDIF 
  
  FUNCTION SaveUndo( lSave, tcKey )         && Control'o save/undo
    RETURN .F. 
  
  FUNCTION textvalid
    This.uRetVal = .T. 
  
  FUNCTION unload
    IF ! EMPTY( This.SaveKey ) 
       This.SaveUndo( .T. ) 
    ENDIF
  
  FUNCTION Valid
    ASSERT PEMSTATUS( ThisForm, "PREVOBJ", 5 ) 
    IF This.PrevObj() 
       RETURN .T. 
    ENDIF 
    
    This.uRetVal   = .T. 
    This.uOldValue = This.Value 
    *------------------------------------------------------------------- 
    This.TextValid() 
    *-------------------------------------------------------------------
    This.NextObj() 
    RETURN This.uRetVal  

ENDDEFINE
**************************************************

**************************************************
DEFINE CLASS L_timer AS timer

  Enabled = .F.
  Height = 23
  Name = "tmr"
  Width = 23
  uRetVal = .T.

ENDDEFINE
**************************************************

**************************************************
DEFINE CLASS L_toolbar AS toolbar

  Caption = ""
  Name = "tbr"
  DSID = 0
  uRetVal = .T.

  FUNCTION Init
    This.DSID = SET( "DATASESSION" )  
    RETURN This.uRetVal

ENDDEFINE
**************************************************


*######################################################################## 
DEFINE CLASS L_EmptyFrame AS pageframe

    PageCount = 0 
    ActivePage = 0

    uRetVal = .T.
    calignment = "0000"
    
ENDDEFINE

*######################################################################## 
DEFINE CLASS l_pageframe AS pageframe
*######################################################################## 

    TabStyle = 1  
    ErasePage = .T.
    
    PageCount = 0 
    ActivePage = 0
    Width = 160
    Height = 79
    Visible = .T. 
    
    uRetVal = .T.
    calignment = "0000"
    
    nState = .F.  
    nSaveHeight = 0 
    
    ADD OBJECT Page1 AS L_Page WITH ;
        Caption = "Page1" 

ENDDEFINE
**************************************************

*######################################################################## 
DEFINE CLASS L_Page AS Page 

  FontName = "Tahoma"  
  FontSize = 7 
  Caption = "Page"  
  uRetVal = .T. 
  
   FUNCTION Init 

ENDDEFINE 

**************************************************
*-- OLEObject = c:\WINNT\System32\mscomctl.ocx
*-- Bazinë TreeView'o klasë
#DEFINE TREE_NODECLICK 1 
#DEFINE TREE_NODECHECK 2

DEFINE CLASS l_treeview AS olecontrol
  
   #IF .F.
     LOCAL This AS PrjTree OF LCtrLib.prg  
   #ENDIF 

    Name = "tree"
    uRetVal = .T. 
    
    OleClass = "MsComCtlLib.TreeCtrl.2"  
    
    Visible = .T.
    Top = 1
    Left = 0
    Height = 225
    Width  = 155
    calignment = ("1100")
    
    Style = 7  
    Scroll = .T. 
    LineStyle = 1 
    CheckBoxes = .F. 
    HideSelection = .F. 
    FullRowSelect = .F. 
    HotTracking = .T. 
    SingleSel = .F. 
    Sorted = .F.  
    LabelEdit = 1 
    LineStyle = 0  
    
    OleDragMode = 1
    OleDropMode = 0     && accepts no ole in 
    PathSeparator = "\" 
    
    nClickMode = 0  

    *######################################################################## 
    FUNCTION Init

        This.Visible = .T. 
        This.Object.Font = "Tahoma" 
        This.Object.Font.Size = 9

        This.Object.Indentation = 10.0        && butina nustatyti reiksme 
        This.Object.LabelEdit = 0 
        This.Object.HotTracking = .T. 
        This.Object.FullRowSelect = .F. 
        This.Object.SingleSel = .F. 
        This.Object.HideSelection = .F. 

        This.Object.Checkboxes = This.Checkboxes
        *.Imagelist.ImageWidth  = 24
       
    FUNCTION objectalign( tnDeltaY, tnDeltaX )

    *######################################################################## 
    FUNCTION Expand
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECLICK, node.key )
        ENDIF
        Node.Expanded = .T.

    *######################################################################## 
    FUNCTION Nodeclick
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECLICK, node.key )
        ENDIF

    *######################################################################## 
    FUNCTION KeyDown
        LPARAMETERS keycode, shift

        This.nClickMode = 2 

    FUNCTION KeyUp
        LPARAMETERS keycode, shift

        This.nClickMode = 0 

    *######################################################################## 
    FUNCTION MouseDown
        LPARAMETERS button, shift, x, y

        This.nClickMode = 1 
        IF button = 2 ;
           AND PEMSTATUS( ThisForm, "RIGHTMENU", 5 )
           ThisForm.RightMenu()
        ENDIF

    *######################################################################## 
    FUNCTION MouseUp
        LPARAMETERS button, shift, x, y

        This.nClickMode = 0 

    *######################################################################## 
    FUNCTION DblClick
        IF TYPE( "This.SelectedItem.key" ) = 'C' ;
           AND PEMSTATUS( ThisForm, "TREECLICK", 5 )
           
           ThisForm.TreeClick( TREE_NODECHECK, This.SelectedItem.key )
        ENDIF

    *######################################################################## 
    FUNCTION Nodecheck
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C' ;
           AND PEMSTATUS( ThisForm, "TREECLICK", 5 )

           ThisForm.TreeClick( TREE_NODECHECK, node.key )
        ENDIF

ENDDEFINE 
*######################################################################## 


*######################################################################## 
DEFINE CLASS l_shape AS Shape 
   lActionCompatible = .F.
   cAlignment = "0000" 
   uRetVal = .T.
   
ENDDEFINE 


*######################################################################## 
FUNCTION L_Restorewindowpos( toForm AS L_Form, tcEntry )
 
  WITH toForm  
    LOCAL  lcBuffer, lcOldError,  llError, llError2
    LOCAL  lnTop, lnLeft, lnWidth, lnHeight 
    LOCAL  lnCommaPos,lnCommaPos2,lnCommaPos3 
    LOCAL  lcEntry, lnScrWidth,  lnScrHeight 

    IF NOT .IsRestorePosition  OR EMPTY( .cIniFileName )
       RETURN .F.
    ENDIF

    lcEntry = IIF( TYPE( "tcEntry" ) # "C", .Name, tcEntry )
    lcBuffer   = CHR(0)
    lcBuffer   = .RestoreProp( [WindowPositions], lcEntry )
    lcOldError = ON('ERROR')

    *-- Read the window position from the string 
    IF EMPTY( lcBuffer ) 
       RETURN .F.
    ENDIF 
   *-- If an error occurs while parsing the string, 
   *-- just ignore the string and use the form's 
   *-- defaults
   ON ERROR llError = .T.
   lnCommaPos = AT(",", lcBuffer)
   lnCommaPos2 = IIF( AT(",", lcBuffer, 2) # 0, AT(",", lcBuffer, 2), LEN(lcBuffer) )
   lnTop  = VAL(LEFT(lcBuffer, lnCommaPos - 1))
   lnLeft = VAL(SUBSTR(lcBuffer, lnCommaPos + 1,lnCommaPos2-lnCommaPos ))
   
   llError2 = llError
   IF NOT llError2 AND .BorderStyle = 3                    && jeigu sizeable border
      lnCommaPos3 = AT(",", lcBuffer, 3)
      lnHeight = VAL(SUBSTR(lcBuffer, lnCommaPos2 + 1,lnCommaPos3-lnCommaPos2 ))
      lnWidth =  VAL(SUBSTR(lcBuffer, lnCommaPos3 + 1))
   ENDIF   
   IF NOT llError2
      lnScrWidth  = SYSMETRIC(1)
      lnScrHeight = SYSMETRIC(2)- 48
      IF ( lnScrWidth > MAX( 600, lnWidth ) )   ;
          AND ( lnLeft + lnWidth  > lnScrWidth )
          lnLeft = lnScrWidth - lnWidth
      ENDIF
      IF ( lnScrHeight > MAX( 350, lnHeight ) )   ;
        AND ( lnTop + lnHeight > lnScrHeight )
          lnTop = lnScrHeight - lnHeight 
      ENDIF
      .Top = lnTop
      .Left = lnLeft
   ENDIF   
   IF TYPE( "lnWidth" ) = "N" AND lnWidth > 0   ;
        AND TYPE( "lnHeight" ) = "N" AND lnHeight > 0

         .Width  = lnWidth
         .Height = lnHeight
         .Resize()
   ENDIF  
   
   lnWidth = .Width  
   lnHeight = .Height 
   ON ERROR &lcOldError
   RETURN .T. 
ENDWITH    

*######################################################################## 
FUNCTION L_SaveWindowPos( toForm AS L_Form, tcEntry ) 

 WITH toForm 
    IF EMPTY( .cIniFileName ) 
       RETURN .F.
    ENDIF
    LOCAL lcValue, lcEntry 

    lcEntry = IIF( TYPE( "tcEntry" ) # "C", .Name, tcEntry )
    lcValue = ALLT(STR(MAX(.Top, 0))) + ',' ;
            + ALLT(STR(MAX(.Left, 0))) 
    IF .BorderStyle = 3          
       lcValue = lcValue + ','  ;
            + ALLT(STR(MAX(.Height, 0))) + ','  ;
            + ALLT(STR(MAX(.Width, 0)))
    ENDIF

    .SaveProp( [WindowPositions], lcEntry, lcValue )
    RETURN .T.
ENDWITH 


*###############################################################################
FUNCTION LObjRClick      && Object right click 
*###############################################################################
LPARAMETERS tObject, tcOptions 

WITH tObject 
   tcOptions = IIF( VARTYPE( tcOptions ) # "C", "", tcOptions ) 
   IF ! INLIST( TYPE( ".Value" ), "C", "N", "Y", "D" ) 
      RETURN .F.
   ENDIF 
    
    LOCAL  lcSysEdit      
    LOCAL  lnStatusBarSpace, lnBar
    LOCAL  lnOP_Cut, lnOP_Copy, lnOP_Paste, lnOp_SelAll
    LOCAL  lcPict_Cut,  lcPict_Copy, lcPict_Paste, lcPict_SelAll
    lnStatusBarSpace = 5 
    lnBar = 0 
    
    lcSysEdit   = "_MEDIT"
    lnOP_Cut    = _MED_CUT
    lnOp_Copy   = _MED_COPY
    lnOp_Paste  = _MED_PASTE
    lnOp_SelAll = _MED_SLCTA 
    
    IF TYPE( "SKPBAR( lcSysEdit, lnOp_Cut )" ) # "L"
       RETURN .F.
    ENDIF

    STORE "" TO lcPict_Cut, lcPict_Copy, lcPict_Paste 
    IF VFP8_VERSION 
        lcPict_Cut   = "PICTRES lnOp_Cut"
        lcPict_Copy  = "PICTRES lnOp_Copy"
        lcPict_Paste = "PICTRES lnOp_Paste"
    ENDIF
    *** Menu:  Undo | Cut, Copy, Paste, Delete | Select All 
    LOCAL lnRow, lnCol
    
    lnRow = MROW()
    lnCol = MCOL()
    IF ATC( "KEY", tcOptions ) # 0 
       lnRow = OBJTOCLIENT( tObject, 2 ) / 7
       lnCol = OBJTOCLIENT( tObject, 1 ) / 7 
    ENDIF
    
    && RELATIVE FROM lnRow, lnCol IN SCREEN 
    DEFINE POPUP P_Shortcut SHORTCUT RELATIVE FROM lnRow, lnCol ;
                 FONT "Ms Sans Serif", 9 

    LOCAL lErr

    lErr = .F.
        IF TYPE([SKPBAR(lcSysEdit, lnOp_Cut)]) # "L"
            lErr = .T.
        ENDIF        

    #IF VERSION(5) >= 800  && VFP8_VERSION
        TRY 
            DEFINE BAR _MED_UNDO OF P_Shortcut PROMPT "Undo" ;
                   SKIP FOR  SKPBAR( lcSysEdit, lnOp_Cut ) 

        CATCH   
            lErr = .T.
            ASSERT_DEB "ERROR " + TRANSF(MESSAGE())
        ENDTRY 
    #ELSE
        DEFINE BAR _MED_UNDO OF P_Shortcut PROMPT "Undo" ;
               SKIP FOR  SKPBAR(lcSysEdit, lnOp_Cut) 
    #ENDIF 

    IF lErr
       RETURN .F.
    ENDIF 

    DEFINE BAR _MED_SP100 OF P_Shortcut PROMPT "\-"

    DEFINE BAR lnOp_CUT OF  P_Shortcut  PROMPT "Cut" ;
            &lcPict_Cut SKIP FOR  SKPBAR( lcSysEdit, lnOp_Cut ) 

    DEFINE BAR lnOp_COPY OF P_Shortcut  PROMPT "Copy" ;
            &lcPict_Copy  SKIP FOR  SKPBAR( lcSysEdit, lnOp_Copy ) 
            
    DEFINE BAR lnOp_PASTE OF P_Shortcut PROMPT "Paste" ;
            &lcPict_Paste SKIP FOR  SKPBAR( lcSysEdit, lnOp_Paste ) 

    DEFINE BAR _MED_CLEAR OF P_Shortcut PROMPT "Clear" ;
            SKIP FOR SKPBAR( lcSysEdit, _MED_CLEAR ) 
                
    DEFINE BAR _MED_SP200 OF P_Shortcut PROMPT "\-"
    DEFINE BAR _MED_SLCTA OF P_Shortcut PROMPT "Select all" ;
            SKIP FOR SKPBAR( lcSysEdit, _MED_SLCTA ) 
            
    #DEFINE   MAKE_USERBAR   DEFINE BAR (lnUser-1) OF P_Shortcut PROMPT "\-"            

    LOCAL lnUser, ln1 
    STORE 50 TO ln1,  lnUser 
    DO CASE 
       CASE INLIST( VARTYPE( tObject.Value ) , 'D' )

         MAKE_USERBAR    
         ln1 = ln1 + 1
         DEFINE BAR (ln1) OF P_Shortcut   PROMPT "Date: today"  
      
         ln1 = ln1 + 1
         DEFINE BAR (ln1) OF P_Shortcut   PROMPT "Date: end of month"  
        
         ln1 = ln1 + 1
         DEFINE BAR (ln1) OF P_Shortcut   PROMPT "Date: begin of month"  
             
    ENDCASE 
    
    ON SELECTION POPUP P_Shortcut  lnBar = BAR() 
    ACTIVATE POPUP  P_Shortcut 
    RELEASE  POPUP  P_Shortcut
    
    IF  BETWEEN( lnBar, lnUser, 100 )
        DO CASE 
           CASE VARTYPE( tObject.Value ) = 'D'         
              WITH tObject
                  DO CASE 
                     CASE lnBar = lnUser + 1 
                         .Value = DATE() 
                     CASE lnBar = lnUser + 2 
                         .Value = GOMONTH( DATE() - DAY( DATE() ) - 1, 1 )
                     CASE lnBar = lnUser + 3
                         .Value = DATE() - DAY( DATE() ) + 1
                  ENDCASE        
              ENDWITH            
        ENDCASE   
    ENDIF 
  
    
ENDWITH 
RETURN .T.

FUNCTION FormCmd( toFormPar AS L_Form OF LCtrLib.prg, tcCmd ) 

    PRIVATE toForm 
    toForm = toFormPar
    IF EMPTY( tcCmd )  
       RETURN .F.
    ENDIF 
    IF "This." $ tcCmd
       tcCmd = STRTRAN( STRTRAN( tcCmd, "THIS.", "This." ) ;
                                , "This.", "toForm." )
    ENDIF 
    ACTIVATE SCREEN 
    
    LOCAL lcMacro, lcRet
    lcMacro = tcCmd
    toForm.Cmd_Last = lcMacro 
    
    IF ATC( CHR(13), lcMacro ) = 0  
        &lcMacro   
    ELSE     
        EXECSCRIPT( lcMacro ) 
    ENDIF 
    lcRet = _TALLY 

 FUNCTION FormTreeKey ( toForm AS bc_form OF BaseObj.vcx ;
                      , toTree AS MsComCtlLib.TreeCtrl ;
                      , nKeyCode AS Integer ,  nShiftAltCtrl AS Integer ) 
                      
 IF TYPE( [toForm.lNoDefault] ) = "U" 
    RETURN .T. 
 ENDIF 
 WITH toForm 
    toTree = IIF( TYPE( [toForm.ActiveControl] ) = "O", toForm.ActiveControl ;
                , IIF( TYPE( [toForm.oActive] ) = "O" , toForm.oActive, .NULL. ) )
    IF TYPE( [toTree.SelectedItem.Key] ) # "C" 
       RETURN .F.  
    ENDIF             
    LOCAL lcKey AS String 
    lcKey = toTree.SelectedItem.Key 
    .lNoDefault = .T.
    IF ! BETWEEN( nKeyCode, ASC("0")+ 32 , ASC("Z")+ 32 ) 
       RETURN .T.
    ENDIF 
    ASSERT ! TEST_TREEKEY MESSAGE "Form "+ .Name ;
        + " TreeView " + toTree.Name + " Key "+ TRANSFORM( nKeyCode ) 

    LOCAL lcChar, lcKey1
    lcChar = CHR( nKeyCode - 32 ) 
    WITH toTree
       lcKey1 = lcKey  
       lcKey1 = IIF( .Nodes( lcKey1 ).Children # 0 AND .Nodes( lcKey1 ).Expanded ;
                   , .Nodes( lcKey1 ).Child.Key, .Nodes( lcKey1 ).Next.Key )
       DO WHILE ! EMPTY( lcKey1 ) 
          IF LEFT( .Nodes( lcKey1 ).Text, 1 ) = lcChar 
             .SelectedItem = .Nodes( lcKey1 ) 
             toTree.NodeCheck( .Nodes( lcKey1 ) ) 
             RETURN .T.    
          ENDIF    
          IF TYPE( [.Nodes( lcKey1 ).Next.Key] ) # "C"
             EXIT  
          ENDIF 
          lcKey1 = .Nodes( lcKey1 ).Next.Key 
       ENDDO 
    ENDWITH 
ENDWITH             

#DEFINE EOF1    