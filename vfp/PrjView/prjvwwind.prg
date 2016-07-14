* $Header: /sntxdeve/vfp/VfpLib/Sys/prjvwwind.prg,v 1.1 2007/12/20 12:29:03 andriusk Exp $
* Windows API ...
*
* $Log: prjvwwind.prg,v $
* Revision 1.1  2007/12/20 12:29:03  andriusk
* init
*
* Revision 1.1  2006/12/15 15:52:19  andriusk
* Ikelta is Ext\ direktorijos
*#############################################################

LOCAL loWindow  AS TWindow OF PrjVwWind.prg 
 
* hAppWindow = _SCREEN.HWnd     && main VFP frame of client area (without statusbar) 
loWindow = CreateObject("Twindow", 0) 

IF ! USED([cWindTypes])
    loWindow.InitResult()
    loWindow.FillResult()
    DO FillWTypes    &&  IN PrjVwWind 
ENDIF 

ACTIVATE SCREEN
loWindow.GetListXml(loWindow.GetFrameChilds([W])) 


*##############################################################################
FUNCTION FillWTypes
*##############################################################################

    SELECT SPACE(6) AS TYPE, cWINHANDLE, cPARENTWIN ;
      , WINLEVEL, WINCHILD, WINSTYLE, WINEXSTYLE ;
      , WINTITLE, WINCLASS ;
      , WRLEFT, WRTOP, WRRIGHT, WRBOTTOM, WINWIDTH, WINHEIGHT ;
      FROM csResult ;
      ORDER BY winlevel, cparentwin INTO CURSOR cWindTypes readwrite 

    UPDATE cWindTypes SET type = 'FRAM' ; 
      WHERE WinStyle = [0x56000000 ] OR INLIST(WinExStyle, [0x00000004 ], [0x00000000 ]) 
    UPDATE cWindTypes SET type = '_SCR' ;  
      WHERE VAL(cParentWin) = 0 AND WinStyle # [0x56000000 ]
    UPDATE cWindTypes SET type = 'WMODI' ;
        WHERE WinStyle = [0x56CF0000 ]
    UPDATE cWindTypes SET type = 'TOOLB' ;
        WHERE WinStyle = [0x56840000 ]
    UPDATE cWindTypes SET type = 'WPROJ' ;
        WHERE INLIST(WinStyle, [0x568C0000 ], [0x56080000 ])
        
    UPDATE cWindTypes SET type = 'WTOOL' ;
        WHERE WinStyle IN ([0x568F0000 ], [0x468F0000 ]) 

    SET FILTER TO !Type = "FRAM" OR WinLevel < 2 IN cWindTypes

    BROWSE TITLE ALIAS() NOWAIT 
    * end of main 

*##############################################################################

#DEFINE GW_HWNDNEXT   2 
#DEFINE GW_CHILD      5 

DEFINE CLASS Twindow As Custom 
    * this class restores window parameters using recursion 
    * for all levels of child windows starting from a given window 
    #IF .F.
       PUBLIC This AS TWindow OF PrjVwWind.prg
    #ENDIF 
*##############################################################################

    hWindow = 0
    WinType = [????]
    WinTitle = []
    WinClass = []
    hParent = 0 
    WinStyle = 0x0
    WinExStyle = 0x0
    Lvl = 0

    PROCEDURE Init(lnHandle, lnParent, lnLevel) 
    
        IF lnHandle = 0 
           This.Declare()
           lnHandle = GetActiveWindow()  && main VFP window 
           IF EMPTY(lnHandle)
              RETURN .F. 
           ENDIF 
        ENDIF 
        lnLevel = EVL(lnLevel, 0) 
        lnParent = EVL(lnParent, 0) 
        THIS.lvl = lnLevel 
        THIS.hWindow = lnHandle 
        THIS.hParent = lnParent 
        THIS.GetInfo()
        RETURN .T. 
        
    #DEFINE WINDOWINFO_SIZE  60 

    FUNCTION GetInfo()    
       WITH This

            .WinTitle = LEFT(GetWinText(.hWindow), 40) 
            .WinClass = LEFT(GetWinClass(.hWindow), 40) 

            LOCAL lcBuffer, lnResult 
   
            lcBuffer = Chr(WINDOWINFO_SIZE) + REPLICATE(Chr(0), WINDOWINFO_SIZE-1) 
            lnResult = GetWindowInfo(THIS.hWindow, @lcBuffer) 
         
            .WinStyle = buf2dword(SUBSTR(lcBuffer, 37,4)) 
            .WinExStyle = buf2dword(SUBSTR(lcBuffer, 41,4))
            
            DO CASE
               CASE .hParent = 0    && .WinStyle # 0x56000000 
                  .WinType = '_SCR' 
               CASE .WinStyle = 0x56000000   
                                    && INLIST(.WinExStyle, 0x00000004, 0x00000000) 
                  .WinType = 'FRAM' 
               CASE .WinStyle = 0x56CF0000 AND !EMPTY(.WinTitle)
                  .WinType = 'WMODI' 
               CASE INLIST(.WinStyle, 0x56CD0000, 0x568D0000)  
                  .WinType = 'WVFP' 
               CASE INLIST(.WinStyle, 0x568C0000, 0x56080000)
                  .WinType = 'WPROJ' 
               CASE INLIST(.WinStyle, 0x568F0000, 0x468F0000)
                  .WinType = 'WTOOL'
                  * .WinExStyle = 0x00000104 == CMD (Command)
                  * .WinClass = vfp884000002 == DSET (Data Session) 
               CASE .WinStyle = 0x56840000
                  .WinType = 'TOOLB' 
           ENDCASE  
        ENDWITH 

    FUNCTION SetFocus()
        =SetFocusWin(This.hWindow)
       
       
    FUNCTION GetFrameChilds(tcFilter)
    
        tcFilter = EVL(tcFilter, [WMODI])
 
        LOCAL loList AS Collection 
        loList = NEWOBJECT([Collection]) 
        
        LOCAL hFrame

        hFrame = 0
        hFrame = This.GetFrame()
        IF EMPTY(hFrame)
           RETURN loList 
        ENDIF 

        * Current Frame Window 
        This.hParent = This.hWindow 
        This.hWindow = hFrame
        This.lvl = 1 
        This.GetInfo() 

        * Fill Child's 
        LOCAL hChild, hNext, lnI
        LOCAL loWindow AS TWindow OF PrjVwWind.prg
        
        hChild = GetWindow(THIS.hWindow, GW_CHILD) 
        lnI = 0 
        
        DO WHILE !EMPTY(hChild) AND lnI < 40 

           lnI = lnI + 1 
           loWindow = .NULL.
           loWindow = CreateObject("Twindow", hChild, hFrame, This.Lvl + 1) 

           * IF loWindow.WinStype # 0x000500BC  
           IF !EMPTY(loWindow.WinTitle)

              loList.Add(loWindow)
           ENDIF 
           * Next 
           hNext = GetWindow(hChild, GW_HWNDNEXT) 
           hChild = hNext 
        ENDDO 
        
        RETURN loList            

    FUNCTION GetListXml(loList AS Collection)

        IF ISNULL(loList)
           RETURN .F.
        ENDIF 
        LOCAL loItem AS TWindow OF PrjVwWind.prg  
        
        ? TIME()        
        ? "Windows of Frame: " + TRANSFORM(This.hWindow, "@0") ;
             + "  Main _VFP: " + TRANSFORM(_VFP.hWnd, "@0")

        FOR EACH loItem IN loList 
            IF TYPE([loItem.WinTITLE]) = 'C' 
               ? loItem.WinType + "  " + TRANSFORM(loItem.hWINDOW, "@0") ;
                 + "  [" +  loItem.WinTitle + "]" ;
                 + " Style=" + TRANSFORM(loItem.WinSTYLE, "@0") ;
                 + " , ex=" + TRANSFORM(loItem.WinEXSTYLE, "@0")  
            ENDIF 
        ENDFOR
        RETURN .T.  

    FUNCTION GetFrame() 
        
        LOCAL hFrame
        LOCAL hChild, hNext, hChild2, lnI
        LOCAL loWindow AS TWindow OF PrjVwWind 
        
        hFrame =  0 
        hChild2 = 0 
        hChild = GetWindow(THIS.hWindow, GW_CHILD) 
        lnI = 4 
        DO WHILE !EMPTY(hChild) AND lnI > 0 AND EMPTY(hFrame)
           lnI = lnI - 1 
           hChild2 = GetWindow(hChild, GW_CHILD) 
           IF !EMPTY(hChild2) 
               loWindow = CreateObject("Twindow", hChild2, hChild, This.lvl + 2) 
               IF loWindow.WinStyle # 0x56000000  
                  hFrame = hChild 
               ENDIF    
               RELEASE loWindow
           ENDIF 
           * Next 
           hNext = GetWindow(hChild, GW_HWNDNEXT) 
           hChild = hNext 
        ENDDO
        
        RETURN hFrame 
           
    FUNCTION FillResult()
    
        IF ! USED([csResult]) 
            This.InitResult()
        ENDIF 
        This.SaveWinInfo() 
        
        LOCAL hChild, oChild

        hChild = GetWindow(THIS.hWindow, GW_CHILD) 
        oChild = .NULL.
        IF !EMPTY(hChild) 
           oChild = CreateObject("Twindow", hChild, THIS.hWindow, THIS.lvl+1) 
           oChild.FillResult() 
           SELECT csResult 

           LOCAL lnWinChild 
           lnWinChild = 0 
           COUNT FOR VAL(cParentWin) = THIS.hWindow TO lnWinChild
           IF lnWinChild > 0 
              REPLACE IN csResult ;
                 WinChild WITH lnWinChild ;
                 FOR cWinHandle = TRANSFORM(THIS.hWindow, '@0') 
           ENDIF      
        ENDIF 
        
        IF This.hParent <> 0
           LOCAL hNext, oNext 
           hNext = GetWindow(THIS.hWindow, GW_HWNDNEXT) 
           IF !EMPTY(hNext)
              oNext = CreateObject("Twindow", hNext, This.hParent, This.lvl) 
              oNext.FillResult() 
           ENDIF 
        ENDIF 
        RETURN .T. 


    FUNCTION InitResult()
    
        CREATE CURSOR csResult (cwinhandle C(12), cparentwin C(12) ;
            , winlevel N(5), winchild N(5) ;
            , winclass C(30), wintitle C(50), wrleft N(12), wrtop N(12) ;
            , wrright N(12), wrbottom N(12), winwidth N(5), winheight N(5) ;
            , winstyle C(12), winexstyle C(12)) 


    PROCEDURE SaveWinInfo 

        INSERT INTO csResult (cwinhandle, cparentwin ;
                , winlevel, wintitle, winclass) ; 
        VALUES (TRANSFORM(THIS.hWindow, '@0') ;
               ,TRANSFORM(THIS.hParent, '@0') ;
               , THIS.lvl, THIS.WinTitle, THIS.WinClass) 
         
    *| typedef struct tagWINDOWINFO { 
    *|     DWORD cbSize;            0:4 
    *|     RECT  rcWindow;          4:16 
    *|     RECT  rcClient;         20:16 
    *|     DWORD dwStyle;          36:4 
    *|     DWORD dwExStyle;        40:4 
    *|     DWORD dwWindowStatus;   44:4 
    *|     UINT  cxWindowBorders;  48:4 
    *|     UINT  cyWindowBorders;  52:4 
    *|     ATOM  atomWindowType;   56:2 
    *|     WORD  wCreatorVersion;  58:2 
    *| } WINDOWINFO, *PWINDOWINFO, *LPWINDOWINFO; total=60 bytes 
    * #DEFINE WINDOWINFO_SIZE  60 

        LOCAL lcBuffer, lnResult 
        lcBuffer = Chr(WINDOWINFO_SIZE) +; 
            Repli(Chr(0), WINDOWINFO_SIZE-1) 

        lnResult = GetWindowInfo(THIS.hWindow, @lcBuffer) 
         
        UPDATE csResult SET; 
            wrleft = buf2dword(SUBS(lcBuffer, 5,4)) ; 
            ,wrtop  = buf2dword(SUBS(lcBuffer, 9,4)) ; 
            ,wrright = buf2dword(SUBS(lcBuffer, 13,4)) ; 
            ,wrbottom = buf2dword(SUBS(lcBuffer, 17,4)) ; 
            ,winstyle = TRANSFORM(buf2dword(SUBS(lcBuffer, 37,4)), '@0') ; 
            ,winexstyle = TRANSFORM(buf2dword(SUBS(lcBuffer, 41,4)), '@0') ; 
            ,winwidth  = wrright-wrleft+1 ; 
            ,winheight = wrbottom-wrtop+1 ; 
        WHERE VAL(csResult.cWinhandle) = THIS.hWindow 

  PROCEDURE declare 
  
    DECLARE INTEGER GetActiveWindow IN user32 
    
    DECLARE INTEGER GetWindow IN user32 INTEGER hwnd, INTEGER wFlag 
    DECLARE INTEGER GetWindowInfo IN user32 INTEGER hwnd, STRING @pwi 
    DECLARE INTEGER IsWindow IN user32 INTEGER hWindow 

    DECLARE INTEGER RealGetWindowClass IN user32 ; 
        INTEGER hWindow, STRING @pszType, INTEGER cchType 

    DECLARE INTEGER GetWindowText IN user32; 
        INTEGER hwnd, STRING @lpString, INTEGER cch 

    DECLARE INTEGER InternalGetWindowText IN user32 ; 
        INTEGER hWnd, STRING @lpString, INTEGER nMaxCount 

    DECLARE INTEGER FindWindow IN user32 ; 
        STRING lpClassName, STRING lpWindowName         

    DECLARE INTEGER GetAncestor In Win32API Integer hWnd, Integer gaFlags 

    DECLARE INTEGER SetFocus IN Win32API AS SetFocusWin  Integer hWnd

    DECLARE INTEGER GetFocus IN Win32API 
    DECLARE INTEGER SetActiveWindow IN Win32API  Integer hWnd 
    DECLARE INTEGER SwitchToThisWindow IN Win32API Integer hWnd, Integer fUnknown 
        
ENDDEFINE 

FUNCTION GetWinText(hWindow) 
* returns window title bar text -- Win9*/Me/XP/2000 
    LOCAL lcBuffer, lnResult 
    lcBuffer = Space(250) 
    lnResult = GetWindowText(hWindow, @lcBuffer, Len(lcBuffer)) 
RETURN Left(lcBuffer, lnResult) 

FUNCTION GetWinClass(hWindow) 
* returns window class 
    LOCAL lcBuffer, lnResult 
    lcBuffer = Space(250) 
    lnResult = RealGetWindowClass(hWindow, @lcBuffer, Len(lcBuffer)) 
RETURN Left(lcBuffer, lnResult) 

FUNCTION buf2dword(lcBuffer) 
RETURN Asc(SUBSTR(lcBuffer,1,1)) + ; 
    BitLShift(Asc(SUBSTR(lcBuffer,2,1)),  8)+; 
    BitLShift(Asc(SUBSTR(lcBuffer,3,1)), 16)+; 
    BitLShift(Asc(SUBSTR(lcBuffer,4,1)), 24) 

       
#DEFINE EOF1         