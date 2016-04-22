* VFP CMDs 
* Revision 1.4  2008/02/12 10:56:46  andriusk * APP version
* Revision 1.2  2005/02/03 08:51:47  andriusk * Browse cmd fix
* Revision 1.1  2004/07/09 15:39:56  andriusk * started

#DEFINE RELEASE_VERSION VERSION(2) = 0 
#DEFINE CR   CHR(13)
#DEFINE CRLF CHR(13) + CHR(10)
* #DEFINE LIBPATH D:\Vfplib\sys\
#DEFINE LIBPATH 
 
IF "Microsoft" $ _SCREEN.Caption ;
   OR "Wait" $ _SCREEN.Caption ;
   OR "Palaukite" $ _SCREEN.Caption
   _SCREEN.Caption = "Vfp Cmds " + FULLPATH(CURDIR())
ENDIF
  
IF POPUP([_MWINDOW]) AND TYPE([SKPBAR(_MWI_CMD, _MWINDOW)]) = 'L' 
    DEFINE BAR _MWI_CMD OF _MWINDOW ;
       PROMPT "Command Window (Orig)"  KEY CTRL+F2, "" 

    DEFINE BAR 501 OF _MWINDOW ;
       PROMPT "\<Command Window (Ext)" ;
       KEY Ctrl+F3, "Ctrl+F3" BEFORE _MWI_CMD 
    ON SELECTION BAR 501  OF _MWINDOW  DO VfpCmd 
ENDIF 

ON KEY LABEL CTRL+F8  DO VfpCmd


IF TYPE( "_SCREEN.oCmd.Name" ) # 'C'
   _SCREEN.AddProperty("oCmd", .NULL.)
   IF RELEASE_VERSION AND ATC([LCtrLib], SET([PROCEDURE])) = 0 
      SET PROCEDURE TO ([LIBPATH] + [LCtrLib.prg])  ADDITIVE
   ENDIF  
   _SCREEN.oCmd = NEWOBJECT("VfpCmd", [LIBPATH] + [VfpCmd.prg]) 
ENDIF
IF TYPE( "_SCREEN.oCmd.Name" ) = 'C'
   _SCREEN.oCmd.Show() 
ENDIF 
IF VERSION( 2) = 0 AND _SCREEN.FormCount > 0 
   READ EVENTS 
ENDIF 

DEFINE CLASS VfpCmd AS L_Form OF LCtrLib.prg

    Left = 10 
    Top  = 10 
    Height = 400
    Width  = 264
    AutoCenter = .F.
    HalfHeightCaption = .T. 
    Caption = "Commands"
    Icon = _SCREEN.Icon 
    Name = "Vfpcmd"
    CurCmd  = ""
    LastCmd = ""
    WindowState = 0
    OldHeight = 0
    OldWidth  = 0
    OldState  = 0
    ErrLast   = 0
    DIMENSION aCmdSrc[1]
    DIMENSION aCmdTrg[1]
    DIMENSION aCmdSrc2[1]
    DIMENSION aCmdTrg2[1]
    Result = "" 
    PrgStr = "" 
    lShutDown = .F. 
    Visible   = .F. 
        
    ADD OBJECT txtCmd AS  Editbox WITH ;
        FontName = "Courier New", FontSize = 8,;
        Alignment = 0, Margin = 1,;
        Left = -1,;
        TabIndex = 2,;
        OleDragMode = 1,;       && Drag Automatic 
        ScrollBars = 2,;        && Vertical Scrolls 
        Name = "txtCmd"

    ADD OBJECT oSplitter AS shape WITH ;
        Top = 100, Left = -1, ;
        Height = 6, Width = 354, ;
        MousePointer = 7, ;
        BorderStyle = 0, BackColor = RGB(192,192,192), ;
        Name = "oSplitter"

    ADD OBJECT cmdExec AS CommandButton WITH ;
        Top = 90, Left = 10, Width = 50, Height=18,;
        Caption = "\<Exec",  TabIndex = 3,;
        FontName = "Tahoma", FontSize = 8, FontBold=.T.,;
        Visible = .T., ;
        Name = "cmdExec"

    ADD OBJECT cmdCopy AS CommandButton WITH ;
        Top = 90, Left = 60, Width = 50, Height=18,;
        Caption = "\<Copy", TabIndex = 4,;
        FontName = "Tahoma", FontSize = 8, Visible = .T., ;
        Name = "cmdCopy"

    ADD OBJECT cmdPaste AS CommandButton WITH ;
        Width = 50, Height=18,;
        Caption = "\<Paste", TabIndex = 4,;
        FontName = "Tahoma", FontSize = 8, Visible = .F., ;
        Name = "cmdPaste"

    ADD OBJECT lstHistory AS listbox WITH ;
        FontName = "Courier New", FontSize = 8, ;
        ColumnCount = 1, ColumnWidths = "900", ;
        ColumnLines = .F., ;
        Left = -1, Top  = -1, ;
        OleDragMode = 1,;       && Drag Automatic 
        Sorted = .F., MultiSelect = .T. ,;
        TabIndex = 1, ;
        BorderColor = RGB(192,192,192), ;
        Name = "lstHistory"


    FUNCTION Resize
        IF ThisForm.Visible 
           ThisForm.LockScreen = .T.
        ENDIF
        WITH This
        IF .WindowState = 0
            IF .OldState # .WindowState
               .Height = .OldHeight 
               .Width  = .OldWidth 
            ENDIF 
            IF .Height < 21
                .Height = 21
            ENDIF
            IF .Width < 50
                .Width = 50
            ENDIF
            DO CASE
              CASE This.MaxWidth  < .Width + 10  AND .Width > 200 ;
                   AND .Width > .OldWidth
                This.MaxWidth  = .Width * 2
              CASE This.MaxWidth  > .Width / 2   AND .Width > 150 ;
                   AND .Width < .OldWidth
                This.MaxWidth  = .Width + 50 
            ENDCASE

        ENDIF 

        IF ! .lstHistory.Width = .Width + 1
            .lstHistory.Width = .Width + 1
            .txtCmd.Width     = .lstHistory.Width 
            .oSplitter.Width  = .Width
            .oSplitter.Height = 4
            .oSplitter.Zorder( 1 ) 
        ENDIF 
        IF ! .OldHeight = 0 AND ! .OldHeight = .Height ;
           AND .Height - .txtCmd.Height > 0
             .oSplitter.Top  = .Height - .txtCmd.Height - 3
        ENDIF 
        IF  .oSplitter.Top > .Height - 20
            .oSplitter.Top = .Height - 20
        ENDIF
        IF .oSplitter.Top > 0
          .lstHistory.Height = .oSplitter.Top 
          .lstHistory.Visible = .T. 
        ELSE 
          .lstHistory.Visible = .F. 
        ENDIF
        .txtCmd.Top    = .oSplitter.Top + 4
        .txtCmd.Height = .Height - .txtCmd.Top + 1
        
        .cmdExec.Top   = .oSplitter.Top - 2 
        .cmdExec.Left  = .Width - .cmdExec.Width - 15 
        .cmdCopy.Top   = .cmdExec.Top 
        .cmdCopy.Left  = .cmdExec.Left - .cmdCopy.Width 

        IF .OldState  = .WindowState
           .OldHeight = .Height 
           .OldWidth  = .Width 
        ELSE 
            .OldState  = .WindowState
        ENDIF 
        IF ThisForm.Visible 
           ThisForm.LockScreen = .F.
        ENDIF
      ENDWITH   
    ENDFUNC

    FUNCTION Load 
        This.OldState  = This.WindowState
        This.OldHeight = This.Height 
        This.OldWidth  = This.Width 
        This.MaxWidth  = 300
    
 
    FUNCTION Init
        SET ASSERTS ON 
        
        This.InitArrays() 
        This.oSplitter.Top = This.Height - 31 
        THIS.Resize()
        This.txtCmd.SetFocus() 
        ThisForm.Visible = .T. 
        
        _SCREEN.Visible = .T.
        IF EMPTY( ON( "SHUTDOWN" ) )
           This.lShutDown = .T.
           ON SHUTDOWN  _SCREEN.oCmd.Destroy()
        ENDIF      
        
        IF RELEASE_VERSION 
           ON KEY LABEL CTRL+F2  ACTIVATE WINDOW VfpCmd 
        ENDIF        
    ENDFUNC

    FUNCTION QueryUnload 
        IF This.Visible ;
           AND MESSAGEBOX(IIF(RELEASE_VERSION, [Quit?], [Close?]), 4) # 6
           NODEFAULT 
           RETURN .F.
        ENDIF 
        This.Hide() 
        RETURN .T. 

    FUNCTION Deactivate
        ACTIVATE SCREEN 

    FUNCTION Destroy

        IF ATC([VfpCmd], ON([KEY], [CTRL+F2])) > 0 
           ON KEY LABEL CTRL+F2    
        ENDIF    
        IF This.lShutDown 
           ON SHUTDOWN
           CLEAR EVENTS
        ENDIF 
    
    FUNCTION Error
        LPARAMETERS nError, cMethod, nLine
        
        This.ErrLast = nError
        LOCAL lnAnw
        lnAnw = MESSAGEBOX( "Error "+ TRANSFORM( nError ) ;
            + CR +MESSAGE()  ;
            + CR + CR + "While executing: " ;
            + CR + TRANSFORM( This.CurCmd ), 48 + 2 + 512, "Cmd Error")

        DO CASE
           CASE lnAnw = 4 && IDRETRY 
             RETRY
           CASE lnAnw = 3 && IDABORT
             SET ASSERTS ON 
             ASSERT .F. 
        ENDCASE 
    ENDFUNC


    FUNCTION lstHistory.Valid
        * This.Parent.txtCmd.SetFocus()
    ENDFUNC

    FUNCTION lstHistory.LostFocus
        * This.parent.txtCmd.SetFocus()
    ENDFUNC

    FUNCTION lstHistory.GotFocus
        IF This.ListCount > 0
            This.Parent.ItemAssign( THIS.List( THIS.ListIndex, 1 )  )
        ELSE
            KEYBOARD "{TAB}"
        ENDIF
    ENDFUNC

    FUNCTION lstHistory.Init 
           This.Parent.cmdExec.Zorder( )
           This.Parent.cmdCopy.Zorder( )
           This.ZOrder( 1 ) 
           STORE  .F.  TO This.Parent.cmdExec.Visible,;
                          This.Parent.cmdCopy.Visible 

    FUNCTION lstHistory.When
        ThisForm.LockScreen  = .T.
        This.Parent.ItemAssign( THIS.List( THIS.ListIndex, 1 )  )

        STORE  This.ListItemId > 0  TO This.Parent.cmdExec.Visible,;
                                       This.Parent.cmdCopy.Visible 
        IF This.ListItemId > 0                                        
           This.Parent.Refresh()
           ThisForm.Draw() 
        ENDIF
        ThisForm.LockScreen  = .F.
        RETURN .T. 
    ENDFUNC
    
    FUNCTION lstHistory.KeyPress 
        LPARAMETERS nKeyCode, nShiftAltCtrl

        DO CASE
           CASE nKeyCode = 7     && Delete
              NODEFAULT
              IF This.ListItemID > 0 
                 This.RemoveItem( This.ListItemID )
              ENDIF 
           ** OR nKeyCode = 32   && Space -> select
           CASE nKeyCode  = 13   && Return
              NODEFAULT
              This.Parent.txtCmd.SetFocus()
           CASE nKeyCode = 24 ;  && ArrowDown
              AND ( This.ListItemID = This.ListCount ;
                    OR This.ListItemID = 0 ) 
                 NODEFAULT
                 This.Parent.txtCmd.SetFocus()
        ENDCASE     
    ENDFUNC

    FUNCTION lstHistory.DblClick 
        IF This.ListIndex > 0 
           IF This.Parent.GetPrgStr()            
              RETURN This.Parent.CommandPrg( )
           ENDIF 
        ENDIF 
        This.Parent.CommandDo( (This.List( This.ListIndex, 1 ))  )
    ENDFUNC
    
    FUNCTION cmdExec.Click
           IF This.Parent.GetPrgStr()            
              RETURN This.Parent.CommandPrg( )
           ENDIF        

    FUNCTION cmdCopy.Click
           IF This.Parent.GetPrgStr()            
              _CLIPTEXT = This.Parent.PrgStr
           ENDIF    

   FUNCTION GetPrgStr 

       LOCAL lcPrgStr 
       lcPrgStr = ""
       WITH This.lstHistory 
           LOCAL lnIdx
           lnIdx = .ListIndex 
           IF lnIdx > 0 ;
              AND (     .Selected( lnIdx ) ;
                    OR  lnIdx > 1 AND .Selected( lnIdx-1 ) ;
                    OR  lnIdx < .ListCount ;
                        AND .Selected( lnIdx+1 ) ) 
              
              lnLen = .ListCount 
              FOR lnI = 1 TO lnLen
                IF .Selected( lnI )
                   lcItem = .ListITem( lnI, 1 )
                   lcItem = STRTRAN( lcItem, ';/', ';' + CRLF )
                   lcPrgStr = IIF( !EMPTY(lcPrgStr);
                                 , lcPrgStr + CRLF, "" )  ;
                            + lcItem
                ENDIF
              ENDFOR
          ENDIF     
       ENDWITH     
       IF LEN( lcPrgStr ) > 0 
          This.PrgStr = lcPrgStr
          RETURN .T.
       ENDIF
       RETURN .F.
              
        
    FUNCTION ItemAssign 
      LPARAMETERS tcStr
      LOCAL lcStr
      lcStr = tcStr
      lcStr = STRTRAN( lcStr, ";/", ";"+ CRLF )  
      This.txtCmd.value = lcStr
    
    FUNCTION HistoryAdd
      LPARAMETERS tcStr 

      LOCAL lcStr
      lcStr = tcStr
      WITH This.lstHistory
        lcStr = STRTRAN( lcStr, ";"+ CRLF, ";/" )  
        lcStr = STRTRAN( lcStr, CRLF, " " )  
        IF .ListCount = 0 ;
           OR ! .ListItem( .ListCount, 1 ) == lcStr 
            .AddItem( lcStr ) 
            .ListItemID = .ListCount
        ENDIF
      ENDWITH
    ENDFUNC

    FUNCTION  CommandPrg
     LPARAMETERS tcPrgStr 
      
      LOCAL lcPrgStr, lcPrgFile, lcFxpFile 
       
       lcPrgStr = tcPrgStr
       IF EMPTY( lcPrgStr )
          lcPrgStr = This.PrgStr 
       ENDIF
       IF EMPTY( lcPrgStr )
          RETURN .F.
       ENDIF 
       IF ! CR $ lcPrgStr 
          RETURN This.CommandDO( (lcPrgStr) ) 
       ENDIF
       
          lcPrgFile = ADDBS( SYS(2023) ) + SYS(2015)+".prg" 
          STRTOFILE( lcPrgStr, lcPrgFile )
          COMPILE (lcPrgFile)
          lcFxpFile = FORCEEXT( lcPrgFile, "fxp" )
          IF FILE( lcFxpFile )
             ACTIVATE SCREEN 
             DO ( lcFxpFile )           
             ERASE ( lcFxpFile )
          ENDIF           
          ERASE (lcPrgFile)
          IF WONTOP() == "SCREEN"
             ThisForm.Activate()
          ENDIF 
          RETURN .T.
     
    FUNCTION  CommandDO
     LPARAMETERS tcCmd

     LOCAL cCmd
        cCmd = tcCmd      
        IF EMPTY( cCmd )
           cCmd = This.txtCmd.Value
        ENDIF
        IF EMPTY( cCmd )
           RETURN .F. 
        ENDIF
        cCmd = STRTRAN( cCmd, ";" + CRLF, " " ) 
        cCmd = STRTRAN( cCmd, CRLF, " " ) 
  
        ACTIVATE SCREEN

        WITH This
          .CurCmd  = cCmd 
          .ErrLast = 0
          
          LOCAL lcExact
          LOCAL lnIdx
          
          lcExact = SET([Exact])
          SET EXACT ON 
          
          cCmd  = UPPER(cCmd)
          lnIdx = ASCAN(.aCmdSrc, cCmd)
          IF lnIdx > 0 
             cCmd = .aCmdTrg[ lnIdx ]
          ELSE 
             lnIdx = ASCAN( .aCmdSrc2, LEFT(cCmd, 2) )
             IF lnIdx = 0 
                lnIdx = ASCAN( .aCmdSrc2, LEFT(cCmd, 5) )
             ENDIF
             IF lnIdx > 0 AND TYPE( ".aCmdTrg2[ lnIdx ]" ) = 'C'
                 cCmd  = EVALUATE( .aCmdTrg2[ lnIdx ] )
             ELSE
                 cCmd = .CurCmd 
             ENDIF 
          ENDIF
          IF lcExact = [OFF]
             SET EXACT OFF
          ENDIF    
          
          *--------------- komandos vykdymas -------------------------- 
          &cCmd 
          
          IF .ErrLast = 0 
             .HistoryAdd( .CurCmd )
             IF LEFT( cCmd, LEN( "This.Result =" ) ) == "This.Result ="
                .HistoryAdd( This.Result ) 
             ENDIF 
             .LastCmd = .CurCmd
             .txtCmd.Value = ""        && Clear Cmd 
          ENDIF 
        ENDWITH 
        IF WONTOP() == "SCREEN"
           ThisForm.Activate()
        ENDIF 
        RETURN .T.

    FUNCTION InitArrays 
     WITH This 
         DIMENSION .aCmdSrc[100]
         DIMENSION .aCmdTrg[100]
         LOCAL ln1 
         ln1 = 1
         .aCmdSrc[ ln1 ] = "MODI PROJ"
         .aCmdTrg[ ln1 ] = "MODI PROJ ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "MODIFY PROJECT"
         .aCmdTrg[ ln1 ] = "MODI PROJ ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "MODI COMM"
         .aCmdTrg[ ln1 ] = "MODI COMM ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "MODIFY COMMAND"
         .aCmdTrg[ ln1 ] = "MODI COMM ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "MODI FORM"
         .aCmdTrg[ ln1 ] = "MODI FORM ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "MODIFY FORM"
         .aCmdTrg[ ln1 ] = "MODI FORM ? NOWAIT"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "BROW"
         .aCmdTrg[ ln1 ] = "BROW NOWAIT IN SCREEN"
         ln1 = ln1 + 1
         .aCmdSrc[ ln1 ] = "DSET"
         .aCmdTrg[ ln1 ] = "DO d:\prg\dset"

         DIMENSION .aCmdSrc[ ln1 ]
         DIMENSION .aCmdTrg[ ln1 ]

         DIMENSION .aCmdSrc2[100]
         DIMENSION .aCmdTrg2[100]
         LOCAL ln1 
         ln1 = 1
         .aCmdSrc2[ ln1 ] = "BROW"
         .aCmdTrg2[ ln1 ] = [cCmd ] ;
                          + [+ IIF(!" NOWAIT" $ cCmd, " NOWAIT", "" )] ; 
                          + [+ IIF(!" SAVE" $ cCmd, " SAVE", "" )]

         ln1 = ln1 + 1
         .aCmdSrc2[ ln1 ] = "? "
         .aCmdTrg2[ ln1 ] = ['This.Result = TRANSFORM('+] ;
                          + [SUBSTR( cCmd, 2 )+] ;
                          + [' )']

         DIMENSION .aCmdSrc2[ ln1]
         DIMENSION .aCmdTrg2[ ln1]

     ENDWITH 

    FUNCTION txtCmd.GotFocus 
        STORE  .F.  TO This.Parent.cmdExec.Visible,;
                       This.Parent.cmdCopy.Visible 
     
    FUNCTION txtCmd.KeyPress
        LPARAMETERS nKeyCode, nShiftAltCtrl

        LOCAL cCmd
        cCmd = ALLTRIM( This.Value )
        DO CASE
         CASE  nKeyCode = 13     && Enter 

                DO CASE
                  CASE RIGHT( cCmd, 2 ) == CRLF 
                    cCmd = LEFT( cCmd, LEN( cCmd ) - 2 )
                  CASE RIGHT( cCmd, 1 ) = ";" 
                    This.Value = This.Value + CRLF
                    RETURN .T.
                ENDCASE 
                IF EMPTY(cCmd)
                   RETURN .T.
                ENDIF 
                This.Parent.HistoryAdd( (cCmd) )
                This.Parent.CommandDO( (cCmd) )
                NODEFAULT

*!*            CASE INLIST(nKeyCode, 24 ) AND LEN( cCmd ) > 0
*!*        
*!*                This.Parent.HistoryAdd( (cCmd) )
*!*                This.Value = ""        && Clear Cmd 
            
        CASE INLIST(nKeyCode, 5,56,50 ) AND LEN( cCmd ) = 0
                     
            KEYBOARD "{TAB}"

        ENDCASE
    ENDFUNC


    FUNCTION osplitter.MouseMove
        LPARAMETERS nButton, nShift, nXCoord, nYCoord

        IF nButton # 0
            LOCAL nUp, nDown
            nMaxUp   = 2
            nMaxDown = This.Parent.Height - 10

            IF nButton # 0    ;
                AND nYCoord >= nMaxUp  AND nYCoord <= nMaxDown
                This.Top = nYCoord
            ENDIF
            IF This.Top < nMaxUp
                This.Top = nMaxUp
            ENDIF
            IF This.Top > nMaxDown
                This.Top = nMaxDown
            ENDIF
            This.Parent.Resize()
        ENDIF
    ENDFUNC

    FUNCTION AddCmd( lcCmd ) 
   
    This.txtCmd.Value = lcCmd 
    This.CommandDo() 

ENDDEFINE
*
*-- EndDefine: VfpCmd
**************************************************


FUNCTION CodeSense_SetMenu

* LPARAMETER oFoxcode
oFoxcode = .NULL.
IF FILE(_CODESENSE)
    ASSERT .F. 
    LOCAL eRetVal, loFoxCodeLoader
    SET PROCEDURE TO (_CODESENSE) ADDITIVE
    loFoxCodeLoader = CreateObject("FoxCodeLoader")
    eRetVal = loFoxCodeLoader.Start(m.oFoxCode)
    loFoxCodeLoader = NULL
    IF ATC(_CODESENSE,SET("PROC"))#0
        RELEASE PROCEDURE (_CODESENSE)
    ENDIF
    RETURN m.eRetVal
ENDIF

DEFINE CLASS FoxCodeLoader as FoxCodeScript

    * Some folks do not like to have entire SET command expanded for them.
    * For example: selecting STEP would autoexpand to STEP ON
    * lEnableFullSetDisplay controls if we expand to STEP or STEP ON
    lEnableFullSetDisplay = .T.
    
    PROCEDURE Main()
        LOCAL lcMenu, lcItem, lcCmd, lEnableFullSetDisplay, lcFirstWord
        DO CASE
        CASE !EMPTY(THIS.oFoxcode.MenuItem) OR THIS.oFoxcode.ParamNum=0
            * Next time to display value
              lcMenu = THIS.oFoxcode.menuitem
              IF EMPTY(m.lcMenu)
                RETURN
              ENDIF
              lcCmd = UPPER(LEFT(THIS.oFoxCode.FullLine, ATC(' ', THIS.oFoxCode.FullLine)))
            THIS.GetCmdTip(m.lcCmd+m.lcMenu)
            lcFirstWord = GETWORDNUM(m.lcMenu,1)
            IF VARTYPE(THIS.lEnableFullSetDisplay)="L" AND !THIS.lEnableFullSetDisplay ;
                AND !INLIST(UPPER(lcFirstWord),"COLLATE","DATABASE","STRICTDATE") ;
                AND !INLIST(UPPER(m.lcMenu),"STATUS BAR")
                lcMenu = lcFirstWord
            ENDIF
            THIS.oFoxcode.ValueType = "V"
            RETURN m.lcMenu
        CASE RIGHT(THIS.oFoxcode.FullLine,1) = ' ' AND UPPER(GETWORDNUM(THIS.oFoxcode.FullLine,1)) = "SET"
            * First time to display entire SET list
            lcItem = ALLTRIM(THIS.oFoxcode.Expanded)
            THIS.GetItemList(m.lcItem,.T.,"setmenu","",.T.)
            RETURN THIS.AdjustCase()
        OTHERWISE
            RETURN ""
        ENDCASE
    ENDPROC
    
ENDDEFINE
