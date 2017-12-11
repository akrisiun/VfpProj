* d:\beta\fcmd\vfpproj\xfilerw\lib.vcx
**************************************************
*-- Class Library:  d:\beta\fcmd\vfpproj\xfilerw\lib.vcx
**************************************************


**************************************************
*-- Class:        d_memotext (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*
DEFINE CLASS d_memotext AS textbox

  BackColor = RGB(212,212,212)
  BorderStyle = 0
  ColorScheme = 1
  ColorSource = 0
  DisabledBackColor = RGB(255,255,255)
  DisabledForeColor = RGB(64,128,128)
  FontName = "MS Sans Serif"
  FontSize = 9
  ForeColor = RGB(0,0,0)
  Height = 18
  Name = "memotext"
  SelectedBackColor = RGB(128,128,128)
  Width = 103
  assignhead = .F.
  realcontrolsource = ""

  
  PROCEDURE GotFocus
    IF NOT INLIST( TYPE( THIS.RealControlSource ), "N", "D" )
       THISFORM.memo.ControlSource = THIS.RealControlSource
    ENDIF
    
  ENDPROC
  
  PROCEDURE Init
    WITH THIS.Parent         && WITH Grid column
    	IF .Width  < 20      &&   Grid Column 
    	       .Width = 70
    	ENDIF
    	IF .Header1.Caption = "Header1"
    		  LOCAL lcStr1, ln1 
    		  lcStr1=THIS.ControlSource
    		  ln1=RAT( ".", lcStr1)
    		  IF ln1!=0 
    		   lcStr1=SUBSTR( lcStr1, ln1+1)
    		 ENDIF
    		 lcStr1=UPPER( SUBSTR( lcStr1, 1, 1 ) ) + SUBSTR( lcStr1, 2 )
    	     .Header1.Caption = lcStr1
    	ENDIF 
    	THIS.RealControlSource=THIS.ControlSource
    	 IF TYPE(THIS.ControlSource)='M'
    	  	       THIS.Parent.ControlSource="RIGHT("+THIS.Parent.ControlSource+",150)"
    	  	       THIS.ReadOnly = .T.
    	  	       THIS.Parent.ReadOnly = .T.
    	  	       THIS.Parent.ForeColor = RGB( 0, 0, 160 )
    	   	  ENDIF     
    	THIS.BackColor = RGB( 220, 220, 220 )
    ENDWITH
  ENDPROC
  
  PROCEDURE Refresh
    *THIS.Parent.Header1.Caption = THIS.ControlSource
    *WAIT WIND " REfresh Memo"
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: d_memotext
**************************************************



**************************************************
*-- Class:        d_textbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  l_textbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- BaseClass:    textbox
*-- Collate Source - Teksto ivedimas su Collate
*
DEFINE CLASS d_textbox AS l_textbox

  Height = 25
  Name = "d_textbox"
  StatusBarText = "."
  Width = 114
  calias =[]
  ccontrolfield =[]
  ischeckegzist = .T.
  iscollate = .F.

  
  PROCEDURE Init
    This.ControlSource = .F.
    DO CASE
     CASE (EMPTY(This.cControlField) OR EMPTY(This.cAlias)) AND ;
          This.IsCheckEgzist
      		    WAIT WINDOW TIME 3 "Klaida nustatant cAlias objektui " + This.Name
    		      This.Enabled = .F.
     CASE This.IsCheckEgzist AND ;
        TYPE( This.cAlias + "." + This.cControlField ) = "U" 
          WAIT WINDOW TIME 3 "Trukta duomenø lauko "+;
                   This.cAlias + "." + This.cControlField  +;
                           " ( objektas "+This.Name +") "
        This.cAlias = ""
        This.cControlField = .F.                       
        This.Enabled = .F.
        This.Visible = .F.
    ENDCASE
    RETURN bc_textbox::Init()
  ENDPROC
  
  PROCEDURE LostFocus
    IF LASTKEY() # 28                                && jei ne Esc
       This.Save()
    ENDIF
  ENDPROC
  
  PROCEDURE Refresh
    This.Restore()
    NODEFAULT
  ENDPROC
  
  PROCEDURE restore
    LOCAL  lcControl, lnSele
    
    lnSele = ALIAS()
    WITH THIS
         IF NOT .Visible OR EMPTY( .cAlias ) OR EMPTY( .cControlField )
            RETURN .F.
         ENDIF
    			  SELECT (.cAlias)
    			  lcControl = .cControlField
    			  IF TYPE(lcControl) = "C" AND .isCollate     && jei simbolinis laukas 
            .Value = SYS(15, TranslateDW, EVALUATE(lcControl))
    			  ELSE      
    			     IF TYPE(lcControl) = "D"                 && datos laukas
    			        .Value = DTOC(EVALUATE(lcControl))
    			     ELSE
       	       .Value = EVALUATE(lcControl)
       	    ENDIF
    			  ENDIF   
    ENDWITH
    SELECT (lnSele)
  ENDPROC
  
  PROCEDURE save
    LOCAL  lcControl, lnSele
    
    lnSele = SELECT()
    WITH THIS
         IF NOT .Visible OR EMPTY(.cAlias ) OR EMPTY(.cControlField )
            RETURN .F.
         ENDIF
    			  SELECT (.cAlias)
    			  lcControl = .cControlField
     		  IF TYPE(lcControl) = "C" AND .isCollate 
      		    IF SYS(15, TranslateWD, .Value) # EVALUATE(lcControl)    && jei simbolinis laukas 
    		         REPLACE &lcControl WITH SYS(15, TranslateWD, .Value)
     		     ENDIF    
    			  ELSE      
    			     IF TYPE(lcControl) = "D"
       	 	     IF .Value # DTOC(EVALUATE(lcControl))
    		            REPLACE &lcControl WITH CTOD(.Value)
       			     ENDIF 
     		     ELSE
       	 		    IF .Value # EVALUATE(lcControl)
    		     	      REPLACE &lcControl WITH .Value
        		     ENDIF 
       			  ENDIF
    			  ENDIF   
    ENDWITH  
    SELECT (lnSele)
    
    RETURN .T.
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: d_textbox
**************************************************



**************************************************
*-- Class:        frmparameters (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  l_form2 (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- BaseClass:    form
*
DEFINE CLASS frmparameters AS l_form2

  BorderStyle = 2
  Caption = "Parameters form"
  DoCreate = .T.
  Height = 236
  Icon = (goApp.cIconName)
  Left = 1
  MaxButton = .F.
  MinButton = .F.
  Name = "frmparameters"
  Top = 0
  Width = 375
  WindowType = 1
  capplicationname = "goApp"
  cinifilename = ""
  conkeyf1 = .F.
  ispressedcancel = .F.
  isrestoreposition = .T.
  lconfirm = .F.
  lpatvirtinti = .F.
  nokclickcount = 0
  uretval = .F.

  ADD OBJECT cntyesno AS l_container WITH ; && lib.vcx 
        BorderWidth = 0 ;
      , Height = 27 ;
      , Left = 109 ;
      , Name = "cntYesNo" ;
      , Top = 198 ;
      , Width = 153 ;
      , calignment = ("001001")

  ADD OBJECT cntyesno.cmdok AS l_commandbutton WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "OK" ;
      , Height = 24 ;
      , Left = 10 ;
      , Name = "cmdOk" ;
      , StatusBarText = "Ávedimo patvirtinimas" ;
      , Top = 2 ;
      , Width = 60

  ADD OBJECT cntyesno.cmdcancel AS l_commandbutton WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Cancel = .T. ;
      , Caption = "Cancel" ;
      , Height = 24 ;
      , Left = 78 ;
      , Name = "cmdCancel" ;
      , StatusBarText = "Atsisakyti" ;
      , Top = 2 ;
      , Width = 60

  
  PROCEDURE Activate
    SET MESSAGE TO (This.Caption)
    RETURN l_form2::Activate()
    
  ENDPROC
  
  PROCEDURE Deactivate
    SET MESSAGE TO "."
    RETURN l_form2::Deactivate()
  ENDPROC
  
  PROCEDURE Destroy
    This.SaveWindowPos()                         && save window position
    *This.Release()
    RETURN l_form2::Destroy()
    
    
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    
    ** RETURN ObjectError( This, nError, cMethod, nLine )
    MessageBox( "Klaida #"+TRANSF( nError ) + ;
           TRANSF( MESSAGE() ) +CHR(13)+;
            " Metodas "+ TRANSF( This.Name ) + "::"+ TRANSF( cMethod ) + " Eil #"+ TRANSF( nLine )  )
            
  ENDPROC
  
  PROCEDURE Init
    LOCAL lRet
    
    lRet = l_form2::Init()
    This.RestoreWindowPos()                          
    This.isPressedCancel = .F.                       
    This.uRetVal = .F.                               
    RETURN lRet
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    
    DO CASE
       CASE nShiftAltCtrl = 2 AND INLIST( nKeyCode, 23, 10 )    
                                                     && Ctrl + End, Ctrl+Enter
         NODEFAULT
         ThisForm.nOKClickCount = 0
         ThisForm.cntYesNo.cmdOk.Click( )
      CASE nKeyCode = 13 AND nShiftAltCtrl = 0 AND ;
         TYPE( "ThisForm.ActiveControl.Name" ) = "C" AND ;
         ThisForm.ActiveControl.BaseClass  = "Optionbutton"  AND ;
         ThisForm.ActiveControl.TabIndex < ThisForm.ActiveControl.Parent.ButtonCount
         KEYBOARD "{TAB}"
      CASE nKeyCode = 27 AND nShiftAltCtrl = 0       && Escape
         NODEFAULT
         ThisForm.cntYesNo.cmdCancel.Click()
    ENDCASE
    
    RETURN l_form2::KeyPress( nKeyCode, nShiftAltCtrl )
  ENDPROC
  
  PROCEDURE refreshform
    WITH This
      .LockScreen = .T.
      .Refresh()
      .LockScreen = .F.
    ENDWITH
  ENDPROC
  
  PROCEDURE restorewindowpos
    LPARAMETERS tcEntry
    
    LOCAL  lcBuffer, lcOldError,  llError, llError2
    LOCAL  lnTop, lnLeft, lnWidth, lnHeight,;
           lnCommaPos,lnCommaPos2,lnCommaPos3, ;
           lcEntry, lnScrWidth,  lnScrHeight 
    
    IF NOT This.IsRestorePosition  OR EMPTY( This.cIniFileName )
       RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    lcBuffer = SPACE(20) + CHR(0)
    lcOldError = ON('ERROR')
    
    *-- Read the window position from the INI file
    IF GetPrivStr("WindowPositions", lcEntry, "", ;
                   @lcBuffer, LEN(lcBuffer), ;
                   CURDIR() + This.cIniFileName ) > 0
       *-- If an error occurs while parsing the string, 
       *-- just ignore the string and use the form's 
       *-- defaults
       ON ERROR llError = .T.
       lnCommaPos = AT(",", lcBuffer)
       lnCommaPos2 = IIF( AT(",", lcBuffer, 2) # 0, AT(",", lcBuffer, 2), LEN(lcBuffer) )
       lnTop  = VAL(LEFT(lcBuffer, lnCommaPos - 1))
       lnLeft = VAL(SUBSTR(lcBuffer, lnCommaPos + 1,lnCommaPos2-lnCommaPos ))
       llError2 = llError
       IF This.BorderStyle = 3                    && jeigu sizeable border
          lnCommaPos3 = AT(",", lcBuffer, 3)
          lnHeight = VAL(SUBSTR(lcBuffer, lnCommaPos2 + 1,lnCommaPos3-lnCommaPos2 ))
          lnWidth =  VAL(SUBSTR(lcBuffer, lnCommaPos3 + 1))
          IF NOT llError 
             This.Width  = lnWidth
             This.Height = lnHeight
    
             This.Resize()
          ENDIF  
       ENDIF   
       lnWidth = This.Width  
       lnHeight = This.Height 
       IF NOT llError2
          lnScrWidth  = SYSMETRIC(1)
          lnScrHeight = SYSMETRIC(2)- 48
          IF ( lnScrWidth > MAX( 600, lnWidth ) ) AND ;
             ( lnLeft + lnWidth  > lnScrWidth )
              lnLeft = lnScrWidth - lnWidth
          ENDIF
          IF ( lnScrHeight > MAX( 350, lnHeight ) ) AND ;
             ( lnTop + lnHeight > lnScrHeight )
              lnTop = lnScrHeight - lnHeight 
          ENDIF
          This.Top = lnTop
          This.Left = lnLeft
       ENDIF   
       ON ERROR &lcOldError
    ENDIF
    
  ENDPROC
  
  PROCEDURE savewindowpos
    LPARAMETERS tcEntry
    
    LOCAL lcValue, lcEntry
    
    IF EMPTY( This.cIniFileName )
        RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    lcValue = ALLT(STR(MAX(This.Top, 0))) + ',' + ;
              ALLT(STR(MAX(This.Left, 0))) 
    IF This.BorderStyle = 3          
       lcValue = lcValue + ',' + ;
              ALLT(STR(MAX(This.Height, 0))) + ',' + ;
              ALLT(STR(MAX(This.Width, 0)))
    ENDIF
             
    *-- Write the entry to the INI file
    =WritePrivStr("WindowPositions", lcEntry, ;
                  lcValue, CURDIR() + This.cIniFileName )
    
  ENDPROC
  
  PROCEDURE showentererror
    LPARAMETER cValidErrorMessage                    && klaidos pranesimas
    
    ThisForm.nOKClickCount = ThisForm.nOKClickCount + 1
    ?? CHR(7)
    IF TYPE("cValidErrorMessage") == "C"             && parametras simbolinis
       WAIT WINDOW cValidErrorMessage TIMEOUT gnWaitLaikas
    ELSE                                             && parametras ne simbolinis
       WAIT WINDOW "Klaidingas ávedimas !" TIMEOUT gnWaitLaikas
    ENDIF
  ENDPROC
  
  PROCEDURE Unload
    SET MESSAGE TO "."
    l_form2::Unload()
    RETURN (ThisForm.uRetVal)
  ENDPROC
  
  PROCEDURE upkey
    RETURN INLIST( LASTKEY(), 27, 5, 15 ) OR This.isPressedCancel
    
  ENDPROC
  
  PROCEDURE valid
    LPARAMETERS oObj, isRecurs                    
    * oObj         (O)              conteineris, kuriam tikrina obj
    * isRecurs     (L,DEFAULT .F.)  ar rekursinis iskvietimas
                                                     
    
    LOCAL lRet                                       && grazinam reiksme
    LOCAL nI                                         && darbinis indeksas
    LOCAL nMinTab                                    && maziausia controlo tabIndex reiksme
    LOCAL nTab                                       && einama tabIndex reiksme 
    LOCAL nMinRange                                  && maziausia perziurima tabIndex reiksme
    LOCAL nFirst, nLastIndex                         && pirmas bei paskutinio tinkamo controlo indeksas
    LOCAL nM, nActive
    
    DO CASE
      CASE TYPE( "oObj" ) = "L"
       oObj = This
      CASE TYPE( "oObj" ) # "O"
       WAIT WINDOW "Wrong parameters frm::Valid() function"
       RETURN .F. 
    ENDCASE
    IF NOT isRecurs
        ThisForm.isPressedCancel = .F.               && uztvirtinama, kad Escape nebuvo spaustas
    	IF ThisForm.UpKey()                          && jei del paskutinio klaviso isijunges Escape
    	   KEYBOARD "{END}"                          && idedame atsitiktini klavisa
    	   INKEY()                                   && ir is karto ji istraukiame is buferio
    	                                             && tam, kad numusti LASTKEY() = 27 (ESCAPE)  
    	ENDIF   
    ENDIF
    
    lRet = .T.
    
    WITH oObj                                        && apdorojami oObj objekto ivedimo laukai
    
      nMinRange  = 0                                 && maziausia perziurima tabIndex reiksme
      nLastIndex = 1                                 && paskutinio tinkamo controlo indeksas
      nFirst = 1                                     && pirmas ivedimo laukas
      DO WHILE nLastIndex > 0                        && ciklas kol dar like netikrintu ivedimo lauku
         nI = nFirst 
         nFirst = -1  
         nMinTab = .ControlCount
         nLastIndex = -1
         DO WHILE nI <= .ControlCount                && ciklas per likusius ivedimo laukus
                                                     && isrenkant maziausia pagal Tab isdestymo tvarka lauka
    		  IF ( INLIST( UPPER( .Controls( nI ).BaseClass ),;
    			       "TEXTBOX", "CHECKBOX", "SPINNER"  ) OR ;
    			       TYPE( ".Controls( nI ).ControlCount" ) = "N"  OR ;
    			       TYPE( ".Controls( nI ).PageCount" ) = "N"           )  AND ;
    		     .Controls( nI ).Enabled               
    		                                         && jei tai ivedamas laukas ir jei jis aktyvus
    		     nTab = .Controls( nI ).TabIndex
    		     IF nTab >= nMinRange
    			     IF nFirst < 0 
    			        nFirst = nI
    			     ENDIF
    			     IF nMinTab > nTab
    			     nLastIndex = nI                 && nustatomas tinkamo lauko indeksas
    			        nMinTab = nTab
    			        IF nTab = nMinRange          && jeigu rastas maziausias reikalingas ived.langas
    			           EXIT                      && iseina is While ciklo
    			        ENDIF
    			     ENDIF
               ENDIF
            ENDIF
            nI = nI + 1
        ENDDO
        
        IF nLastIndex > 0                            && jei geras controlo indeksas
    
     	 DO CASE 
    	  CASE TYPE( ".Controls( nLastIndex ).ControlCount" ) = "N" 
    
             lRet = ThisForm.Valid( .Controls( nLastIndex ), .T.  ) 
                                                     && konteinerio validu apdirbimas
                                                     && rekursiniu iskvietimu
    
    		  CASE TYPE( ".Controls( nLastIndex ).PageCount" ) = "N" 
    
    		    WITH .Controls( nLastIndex )
    				    nActive = .ActivePage
    				    nM = nActive
    				    lRet = ThisForm.Valid( .Pages( nActive ), .T.  )
    				    IF TYPE( "lRet" ) = "L" AND lRet 
    		    				    nM = 1 
          				    DO WHILE nM <= .PageCount
          				       IF nM # nActive
          				            lRet = ThisForm.Valid( .Pages( nM ), .T. )
          				            IF TYPE( "lRet" ) # "L" OR NOT lRet 
          				               .ActivePage = nM
          				               EXIT          && jei grazino .F.
          				            ENDIF
          				       ENDIF
          				       nM = nM + 1
          				    ENDDO
          				  ENDIF
          				  
                ENDWITH    				        
    
             OTHERWISE
    
    	        lRet = .Controls( nLastIndex ).Valid()
    	                                              && kvieciamas valid'as
    		       IF TYPE( "lRet" ) = "L" AND lRet      && jei grazino .T.
    	             lRet = .Controls( nLastIndex ).LostFocus()
    	                                              && dar kvieciamas LostFocus
    		       ENDIF                                     
    		       
    	    ENDCASE   
    
           IF TYPE( "lRet" ) # "L" OR NOT lRet 
              IF NOT ( TYPE( ".Controls( nLastIndex ).ControlCount" ) = "N"  OR ;
      	             TYPE( ".Controls( nLastIndex ).PageCount" ) = "N"   ) 
                             	                     && jei ivedimo lauke klaidinga reikme
                 .Controls( nLastIndex ).SetFocus() 
                                                     && pereinama i ta ivedimo lauka
              ENDIF
              RETURN .F.                             && grazinama .F.
           ENDIF
           nMinRange = nMinTab + 1
        ENDIF
    
      ENDDO 
      
    ENDWITH
    
    RETURN .T.  
    
    
  ENDPROC
  
  PROCEDURE cntyesno.cmdok.Click
    
    WITH ThisForm
      .RefreshForm()                                 && refreshina forma
      .nOKClickCount = .nOKClickCount + 1
      .lConfirm = .T.
      
      IF TYPE( ".ActiveControl.Name" ) = "C"  AND ;
         .ActiveControl.Name # This.Name  AND ;
         ( .nOKClickCount > 1  OR NOT .ActiveControl.LostFocus()  )
         .lConfirm = .F.
         RETURN .F.
      ENDIF
    
    	 IF .Valid()                                 && jei visi ivedimo laukai OK   
                This.SetFocus()         
    
                IF TYPE( ".ActiveControl.Name" ) = "C"  AND ;
                  .ActiveControl.Name = This.Name  AND ;
                  .AfterValid()
           		                                               
    		      .uRetVal = .T.                     && grazinam formos reikme
             	  .Hide()
    		    ENDIF
    		ELSE
                .lConfirm = .F.
    		    RETURN .F.                           && kitaip grazina False
    		ENDIF    
      .lConfirm = .F.
    ENDWITH		
    RETURN .T.
  ENDPROC
  
  PROCEDURE cntyesno.cmdok.GotFocus
      ThisForm.nOKClickCount = 0
      ThisForm.lConfirm = .F.
      RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE cntyesno.cmdok.LostFocus
      ThisForm.lConfirm = .F.
      RETURN DODEFAULT()
    
  ENDPROC
  
  PROCEDURE cntyesno.cmdok.MouseDown
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
    
    ThisForm.nOKClickCount = ThisForm.nOKClickCount + 1
    RETURN l_commandbutton::MouseDown( nButton, nShift, nXCoord, nYCoord )
  ENDPROC
  
  PROCEDURE cntyesno.cmdcancel.Click
    IF ThisForm.AfterCancel()                        && veiksmai po cancel click
                                                     && pvz. =TableRevert( <> )
       ThisForm.uRetVal = .F.
       ThisForm.Hide()
    ELSE 
       RETURN .F.   
    ENDIF
    RETURN .T.
  ENDPROC
  
  PROCEDURE cntyesno.cmdcancel.LostFocus
    ThisForm.isPressedCancel = .F.
    RETURN l_form2::LostFocus()
    
  ENDPROC
  
  PROCEDURE cntyesno.cmdcancel.MouseDown
    LPARAMETERS nButton, nShift, nXCoord, nYCoord
    
    ThisForm.isPressedCancel = .T.
    RETURN l_commandbutton::MouseDown( nButton, nShift, nXCoord, nYCoord )
  ENDPROC


ENDDEFINE
*
*-- EndDefine: frmparameters
**************************************************



**************************************************
*-- Class:        gc_textbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  l_textbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- BaseClass:    textbox
*-- grid control bazine klase
*
DEFINE CLASS gc_textbox AS l_textbox

  Alignment = 0
  BorderStyle = 0
  DisabledBackColor = (This.SelectedBackColor)
  DisabledForeColor = RGB(255,255,255)
  Enabled = .T.
  Height = 13
  Margin = 0
  Name = "gc_textbox"
  ReadOnly = .T.
  SelectOnEntry = .F.
  SelectedForeColor = RGB(255,255,255)
  Width = 118

  
  PROCEDURE DblClick
    IF TYPE( "This.Parent.Parent.nSelRecno" ) = "N"  && jei egzistuoja toks GRID'o laukas
        This.Parent.Parent.OnDoubleClick( This )
    ENDIF
    return l_textbox::DblClick()        
  ENDPROC
  
  PROCEDURE GotFocus
    LOCAL cMacro, oldLock
    
    *!*	IF NOT EMPTY( This.Parent.Parent.RecordSource ) AND ;
    *!*	   NOT EOF( (This.Parent.Parent.RecordSource) ) 
    *!*	   
    *!*		IF TYPE( "This.Parent.Parent.cRecName" ) = "C" AND ;
    *!*		   TYPE( This.Parent.Parent.cRecName ) = "N" 
    *!*		      cMacro = This.Parent.Parent.cRecName
    *!*		      IF RECNO( (This.Parent.Parent.RecordSource) ) # ;
    *!*		         EVAL( cMacro )
    *!*		         
    *!*		         &cMacro = RECNO( (This.Parent.Parent.RecordSource) )
    *!*	*!*		         IF NOT CHRSAW( 0 ) 
    *!*	*!*	  	            oldLock = ThisForm.LockScreen
    *!*	*!*		            ThisForm.LockScreen = .T.
    *!*	*!*	      	        This.Parent.Parent.Refresh()
    *!*	*!*		            ThisForm.LockScreen = oldLock
    *!*	*!*		            *ThisForm.Paint()
    *!*	*!*		         ENDIF   
    *!*		      ENDIF
    *!*		ENDIF
    *!*	ENDIF
    
    RETURN l_textbox::GotFocus()
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    
    LOCAL lRet
    
    DO CASE
       CASE nShiftAltCtrl = 0 AND nKeyCode = 13
            NODEFAULT
    		IF TYPE( "This.Parent.Parent.nSelRecno" ) = "N"  && jei egzistuoja toks GRID'o laukas
    		    This.Parent.Parent.OnDoubleClick( This )
    		ENDIF
    		RETURN .T.
       CASE nShiftAltCtrl = 1      && jeigu paspausta shift
            NODEFAULT
       CASE nKeyCode = 4  AND nShiftAltCtrl = 0     && right
            NODEFAULT
            KEYBOARD "{END}{END}"
    ENDCASE
    
    **RETURN .T.
    
    lRet = .T.
    *lRet = This.Parent.Parent.KeyPress(  nKeyCode, nShiftAltCtrl )        
                                     && kviecia grid'o keypress
    IF NOT lRet
       NODEFAULT 
       RETURN .T.
    ENDIF
    RETURN l_textbox::KeyPress(  nKeyCode, nShiftAltCtrl )        
  ENDPROC


ENDDEFINE
*
*-- EndDefine: gc_textbox
**************************************************



**************************************************
*-- Class:        l_checkbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Bazinë Check Box'o klasë
*
DEFINE CLASS l_checkbox AS checkbox

  Alignment = 0
  AutoSize = .T.
  Caption = "Check1"
  FontName = "MS Sans Serif"
  Height = 15
  Name = "bc_checkbox"
  StatusBarText = "."
  Width = 55
  calignment = ("000000")
  ischeckegzist = .F.

  
  PROCEDURE Init
    IF This.IsCheckEgzist AND NOT EMPTY( This.ControlSource ) AND ;
        TYPE( This.ControlSource ) = "U" 
        
        WAIT WINDOW TIME 3 "Trukta duomenø lauko "+;
                   This.ControlSource +;
                           " ( objektas "+This.Name +") "
        IF TYPE( "ThisForm.IsIgnoreErrors" ) = "L"
           ThisForm.IsIgnoreErrors = .T.                       
           This.ControlSource = .F.
           ThisForm.IsIgnoreErrors = .F.                       
        ENDIF
        This.Enabled = .F.
        This.Visible = .F.
    ENDIF
    
  ENDPROC
  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_checkbox
**************************************************



**************************************************
*-- Class:        l_combobox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  combobox
*-- BaseClass:    combobox
*-- Bazinë Combo Box'o klasë
*
DEFINE CLASS l_combobox AS combobox

  ColumnWidths = ""
  FontName = "MS Sans Serif"
  Height = 24
  Name = "bc_combobox"
  Width = 137
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_combobox
**************************************************



**************************************************
*-- Class:        l_commandbutton (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Bazinë Command Button'o klasë
*
DEFINE CLASS l_commandbutton AS commandbutton

  AutoSize = .F.
  Caption = "Command1"
  FontName = "MS Sans Serif"
  FontSize = 9
  Height = 24
  Name = "bc_commandbutton"
  StatusBarText = "."
  Width = 94
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_commandbutton
**************************************************



**************************************************
*-- Class:        l_container (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Bazinë Container'io klasë
*
DEFINE CLASS l_container AS container

  BackStyle = 0
  BorderWidth = 0
  Height = 34
  Name = "l_container"
  Width = 219
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas yra PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas yra normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    
         This.ObjectCtrlAlign( nDeltaY, nDeltaX )
         
    ENDWITH
    
  ENDPROC
  
  PROCEDURE objectctrlalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         FOR lI = 1 TO .ControlCount                           && per formos objektus
             IF TYPE(".Controls(lI).cAlignment") = "C" AND ;
                NOT EMPTY(.Controls(lI).cAlignment) AND ;
                AT( "1", .Controls(lI).cAlignment) != 0
                .Controls(lI).ObjectAlign(nDeltaY, nDeltaX)
             ENDIF
         ENDFOR
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_container
**************************************************



**************************************************
*-- Class:        l_control (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  control
*-- BaseClass:    control
*-- Bazinë Control'o klasë
*
DEFINE CLASS l_control AS control

  BackStyle = 0
  BorderWidth = 0
  Height = 132
  Name = "bc_control"
  Width = 358
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_control
**************************************************



**************************************************
*-- Class:        l_custom (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Bazinë Custom klasë
*
DEFINE CLASS l_custom AS custom

  Height = 60
  Name = "bc_custom"
  Width = 160




ENDDEFINE
*
*-- EndDefine: l_custom
**************************************************



**************************************************
*-- Class:        l_editbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  editbox
*-- BaseClass:    editbox
*-- Bazinë Edit Box'o klasë
*
DEFINE CLASS l_editbox AS editbox

  FontName = "MS Sans Serif"
  Height = 100
  Name = "bc_editbox"
  Width = 200
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_editbox
**************************************************



**************************************************
*-- Class:        l_form (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Bazinë Form'os klasë
*
#INCLUDE "d:\beta\fcmd\vfpproj\xfilerw\setv.h"
*
DEFINE CLASS l_form AS form

  Caption = "L_Form"
  DoCreate = .T.
  FontName = "MS Sans Serif"
  Height = 118
  KeyPreview = .T.
  Left = 0
  Name = "l_form"
  ShowTips = .T.
  Top = -1
  Width = 375
  cinifilename = ("App.Ini")
  isignoreerrors = .F.
  isrestoreposition = .T.
  noldheight =[]
  noldwidth =[]
  uretval = .F.

  
  PROCEDURE Destroy
    This.SaveWindowPos()
    RETURN .T.
  ENDPROC
  
  PROCEDURE Init
    WITH This
          .RestoreWindowPos()
    
    	  .Icon = _SCREEN.Icon
    	  IF .Left > _SCREEN.ViewPortWidth  - .Width 
    	     .Left = _SCREEN.ViewPortWidth  - .Width - 6
    	  ENDIF
    	  IF .Top > _SCREEN.ViewPortWidth  - .Height
    	     .Top = _SCREEN.ViewPortWidth  - .Height - 6
    	  ENDIF
          .ExternalInit()
          .Visible = .T.
    ENDWITH
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE Load
    WITH This
          .cIniFileName = FULLPATH( This.cIniFileName )       
          DEBUGOUT .cIniFileName
          DO CASE
            CASE LEFT( .cIniFileName, 2 ) = 'W:'
             .cIniFileName = ADDBS( SYS( 2023) ) + ;
                             JUSTFNAME( .cIniFileName )
            CASE FILE( THIS_PATH + "Lib.vcx" )         
               .cIniFileName = THIS_PATH + JUSTFNAME( .cIniFileName )
            CASE DIRECTORY( VFPLIB_PATH )    
               .cIniFileName = VFPLIB_PATH + JUSTFNAME( .cIniFileName )
          ENDCASE
          DEBUGOUT .cIniFileName
          
         .nOldHeight = .Height
         .nOldWidth =  .Width
    ENDWITH 
    
  ENDPROC
  
  PROCEDURE objectalign
    LPARAMETERS oThis, nDeltaY, nDeltaX              && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH oThis
         IF .Parent.BaseClass = "Page"               && objektas yra PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas yra normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    
         && This.ObjectCtrlAlign( nDeltaY, nDeltaX )
         
    ENDWITH
    
  ENDPROC
  
  PROCEDURE onerror
    LPARAMETERS nError, cMsg, cMethod, nLine
    
    oObject = This
    
    ** #INCLUDE foxpro.h
    
    LOCAL llHandledError, ;
    	  lcMessage, cMessage, ;
    	  lnAnswer
    LOCAL laError[ 7 ]    && 7= AERRORARRAY
    		      
    *LOCAL cMacro		      
    LOCAL nI, cPrg
        
        lcMessage = MESSAGE()
        
    	=AERROR(laError)
    
    	IF TYPE( "oObject.IsIgnoreErrors" ) = "L" AND oObject.IsIgnoreErrors
    	   RETURN .T.
    	ENDIF
    
    	*-- Loads the laError array with error information ------------------
        ?? CHR(7)
        lcMessage = "Klaida " + IIF( TYPE( "nError" ) = "N",;
                                  ALLT( STR( nError )), '' ) + " : "  + lcMessage
        DO CASE
           CASE nError = 108   && File is used by another user
             lsMessage = " Duomenys apdorojami kitoje darbo vietoje..."+;
                     CHR(13)+ "("+ lcMessage + ")"
           CASE nError = 39    && Numeric overlow. Data was lost
             lsMessage = " Numerio reikðmës perpildymas. Duomenys praràsti "+;
                    CHR(13)+"(" + lcMessage + ")"                  
        ENDCASE
        
        lcMessage = lcMessage + CHR(13) + ;
                " objektas "+IIF( TYPE("oObject.Name")="C", oObject.Name + CHR(13), "'', " )
                
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
            lcMessage = lcMessage + " funkcija "+;
                         IIF( EMPTY( cPrg ), "-", cPrg +;
                          IIF( LEN( cPrg ) > 15, CHR(13), '' ) )
            cPrg = PROGRAM( nI - 1 )                     
            IF NOT EMPTY( cPrg )
                lcMessage = lcMessage + "  ( " + cPrg  +;
                                    IIF( LEN( cPrg ) > 15, CHR(13), '' )
                cPrg = PROGRAM( nI - 2 )                     
                IF NOT EMPTY( cPrg )
                   lcMessage = lcMessage + "  \ " + cPrg  + ;
                                    IIF( LEN( cPrg ) > 15, CHR(13), '' )
                ENDIF
                lcMessage = lcMessage + " ) "
             ENDIF
           IF nError # 39 AND ;
              nError # 108  
                             && 108-File is used by another ...
                             && 39- Numeric overlow. Data was lost
            
      		IF INLIST( UPPER( SUBSTR( cMethod, RAT( ".", cMethod )+1 ) ),;
    		             "ACTIVATE", "REFRESH" )
    		             
    		    RETURN .T.      && jeigu "ACTIVATE" arba "REFRESH" dingstam
    		 ELSE
    		   * cMacro = "msg( lcMessage )"
               * &cMacro
        	 ENDIF
            ENDIF
     	ENDIF             
        
        IF TYPE( "goApp.IsDebugMsg" ) = "L" AND ;
           goApp.IsDebugMsg                 && jei yra debugerio msg
             goApp.DebugMsg( lcMessage )
        ENDIF
        
    	lnAnswer = MessageBox( lcMessage, ;
    	                  16 + 2 + 512, ;
    	                  " Klaida "+ALLTRIM( STR( nError ) ) )
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
    
    
    
  ENDPROC
  
  PROCEDURE refreshform
    WITH This
      .LockScreen = .T.
      .Refresh()
      .LockScreen = .F.
    ENDWITH
    
  ENDPROC
  
  PROCEDURE Resize
    LPARAMETERS  lNotLock 
    
    LOCAL lI, lJ, lK                                           && darbiniai skaitliukai
    LOCAL nDeltaY, nDeltaX                                     && formos aukscio, plocio pokyciai
    LOCAL cOldLock
    LOCAL oThis
    
    WITH ThisForm
         lOldLock = .LockScreen
         IF ! lNotLock AND .Visible 
            .LockScreen = .T.
         ENDIF   
         
         nDeltaY = .Height - .nOldHeight                       && formos aukscio pokytis
         nDeltaX = .Width - .nOldWidth                         && formos plocio pokytis
         FOR lI = 1 TO .ControlCount                           && per formos objektus
             oThis = .Controls(lI)
             WITH .Controls(lI)
               IF TYPE(".cAlignment") = "C" ;
                 AND NOT EMPTY(.cAlignment) AND AT( "1", .cAlignment) != 0
                  DO CASE
                    CASE  PEMSTATUS( oThis, 'ObjectAlign', 5 )
                        .ObjectAlign( nDeltaY, nDeltaX )
                    OTHERWISE    
                        ThisForm.ObjectAlign( oThis, nDeltaY, nDeltaX )
                  ENDCASE      
               ENDIF
             ENDWITH
             IF UPPER(.Controls(lI).BaseClass) = "PAGEFRAME"   && PageFrame
                FOR lJ = 1 TO .Controls(lI).PageCount          && per PageFrame'o puslapius
                    WITH .Controls( lI ).Pages( lJ )
    
                       FOR lK = 1 TO .ControlCount             && per puslapio objektus
                             oThis = .Controls(lK)
                             WITH .Controls(lK)
                               IF TYPE(".cAlignment") = "C" ;
                                 AND NOT EMPTY(.cAlignment) AND AT( "1", .cAlignment) != 0
                                  DO CASE
                                    CASE  PEMSTATUS( oThis, 'ObjectAlign', 5 )
                                        .ObjectAlign( nDeltaY, nDeltaX )
                                    OTHERWISE    
                                        ThisForm.ObjectAlign( oThis, nDeltaY, nDeltaX )
                                  ENDCASE      
                               ENDIF
                             ENDWITH
                         ENDFOR
                    ENDWITH
                ENDFOR
             ENDIF
         ENDFOR
    
         .nOldHeight = .Height                                 && irasom auksti
         .nOldWidth = .Width                                   && irasom ploti
         IF ! lNotLock AND .Visible 
            .LockScreen = lOldLock 
         ENDIF
    
    ENDWITH
  ENDPROC
  
  PROCEDURE restoreprop
    LPARAMETERS lcParKey, lcKey
    
    DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
      String cSection, String cKey, String cDefault, String @cBuffer, ;
      Integer nBufferSize, String cINIFile
    
    DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
      String cSection, String cKey, String cValue, String cINIFile
    
    LOCAL lcBuffer, lnLen
    
    lcBuffer = SPACE(200)+CHR(0)
    lnLen    =  0
    IF FILE( This.cIniFileName )
       This.cIniFileName = FULLPATH( This.cIniFileName ) 
       lnLen =  GetPrivStr( lcParKey, lcKey, "", ;
                             @lcBuffer, LEN(lcBuffer), This.cIniFileName ) 
    ENDIF                         
    IF lnLen = 0
       RETURN ""
    ENDIF
    lcBuffer = LEFT( lcBuffer, lnLen )
    RETURN lcBuffer 
  ENDPROC
  
  PROCEDURE restorewindowpos
    LPARAMETERS tcEntry
    
    LOCAL  lcBuffer, lcOldError,  llError, llError2
    LOCAL  lnTop, lnLeft, lnWidth, lnHeight,;
           lnCommaPos,lnCommaPos2,lnCommaPos3, ;
           lcEntry, lnScrWidth,  lnScrHeight 
    
    IF NOT This.IsRestorePosition  OR EMPTY( This.cIniFileName )
       RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    *lcBuffer = SPACE(20) + CHR(0)
    lcBuffer   = CHR(0)
    lcBuffer   = This.RestoreProp( "WindowPositions", lcEntry )
    lcOldError = ON('ERROR')
    
    *-- Read the window position from the INI file
    IF ! EMPTY( lcBuffer ) 
       *-- If an error occurs while parsing the string, 
       *-- just ignore the string and use the form's 
       *-- defaults
       ON ERROR llError = .T.
       lnCommaPos = AT(",", lcBuffer)
       lnCommaPos2 = IIF( AT(",", lcBuffer, 2) # 0, AT(",", lcBuffer, 2), LEN(lcBuffer) )
       lnTop  = VAL(LEFT(lcBuffer, lnCommaPos - 1))
       lnLeft = VAL(SUBSTR(lcBuffer, lnCommaPos + 1,lnCommaPos2-lnCommaPos ))
       
       llError2 = llError
       IF NOT llError2 AND This.BorderStyle = 3                    && jeigu sizeable border
          lnCommaPos3 = AT(",", lcBuffer, 3)
          lnHeight = VAL(SUBSTR(lcBuffer, lnCommaPos2 + 1,lnCommaPos3-lnCommaPos2 ))
          lnWidth =  VAL(SUBSTR(lcBuffer, lnCommaPos3 + 1))
       ENDIF   
       IF NOT llError2
          lnScrWidth  = SYSMETRIC(1)
          lnScrHeight = SYSMETRIC(2)- 48
          IF ( lnScrWidth > MAX( 600, lnWidth ) ) AND ;
             ( lnLeft + lnWidth  > lnScrWidth )
              lnLeft = lnScrWidth - lnWidth
          ENDIF
          IF ( lnScrHeight > MAX( 350, lnHeight ) ) AND ;
             ( lnTop + lnHeight > lnScrHeight )
              lnTop = lnScrHeight - lnHeight 
          ENDIF
          This.Top = lnTop
          This.Left = lnLeft
       ENDIF   
       IF TYPE( "lnWidth" ) = "N" AND lnWidth > 0 AND ;
          TYPE( "lnHeight" ) = "N" AND lnHeight > 0
    
             This.Width  = lnWidth
             This.Height = lnHeight
             This.Resize()
       ENDIF  
       
       lnWidth = This.Width  
       lnHeight = This.Height 
       ON ERROR &lcOldError
    ENDIF
    
    
  ENDPROC
  
  PROCEDURE saveprop
    LPARAMETERS tcParKey, tcKey, tcValue
    
    *-- Write the entry to the INI file
    DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
      String cSection, String cKey, String cValue, String cINIFile
    
    =WritePrivStr( tcParKey, tcKey, tcValue, This.cIniFileName )
    
    
  ENDPROC
  
  PROCEDURE savewindowpos
    LPARAMETERS tcEntry
    
    LOCAL lcValue, lcEntry
    
    IF EMPTY( This.cIniFileName ) 
       RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    lcValue = ALLT(STR(MAX(This.Top, 0))) + ',' + ;
              ALLT(STR(MAX(This.Left, 0))) 
    IF This.BorderStyle = 3          
       lcValue = lcValue + ',' + ;
              ALLT(STR(MAX(This.Height, 0))) + ',' + ;
              ALLT(STR(MAX(This.Width, 0)))
    ENDIF
    
    This.SaveProp("WindowPositions", lcEntry, lcValue )
    
  ENDPROC
  
  PROCEDURE setrect
    LPARAMETERS tLeft, tTop, tWidth, tHeight
    
    WITH This
      .Left = tLeft
      .Top  = tTop
      .Width  = tWidth
      .Height = tHeight
    ENDWITH
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_form
**************************************************



**************************************************
*-- Class:        l_form2 (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Bazinë Form'os klasë 2

*
DEFINE CLASS l_form2 AS form

  Caption = "Form"
  DoCreate = .T.
  FontName = "MS Sans Serif"
  Height = 118
  KeyPreview = .T.
  Left = 0
  Name = "l_form2"
  ShowTips = .T.
  Top = 0
  Width = 375
  cinifilename = ("App.Ini")
  isignoreerrors = .F.
  isrestoreposition = .T.
  noldheight =[]
  noldwidth =[]
  uretval = .F.

  
  PROCEDURE Destroy
    This.SaveWindowPos()
    RETURN .T.
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    
    oObject = This
    
    ** #INCLUDE foxpro.h
    
    LOCAL llHandledError, ;
    	  lcMessage, cMessage, ;
    	  lnAnswer
    LOCAL laError[ 7 ]    && 7= AERRORARRAY
    		      
    *LOCAL cMacro		      
    LOCAL nI, cPrg
        
        lcMessage = MESSAGE()
        
    	=AERROR(laError)
    
    	IF TYPE( "oObject.IsIgnoreErrors" ) = "L" AND oObject.IsIgnoreErrors
    	   RETURN .T.
    	ENDIF
    
    	*-- Loads the laError array with error information ------------------
        ?? CHR(7)
        lcMessage = "Klaida " + IIF( TYPE( "nError" ) = "N",;
                                  ALLT( STR( nError )), '' ) + " : "  + lcMessage
        DO CASE
           CASE nError = 108   && File is used by another user
             lsMessage = " Duomenys apdorojami kitoje darbo vietoje..."+;
                     CHR(13)+ "("+ lcMessage + ")"
           CASE nError = 39    && Numeric overlow. Data was lost
             lsMessage = " Numerio reikðmës perpildymas. Duomenys praràsti "+;
                    CHR(13)+"(" + lcMessage + ")"                  
        ENDCASE
        
        lcMessage = lcMessage + CHR(13) + ;
                " objektas "+IIF( TYPE("oObject.Name")="C", oObject.Name + CHR(13), "'', " )
                
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
            lcMessage = lcMessage + " funkcija "+;
                         IIF( EMPTY( cPrg ), "-", cPrg +;
                          IIF( LEN( cPrg ) > 15, CHR(13), '' ) )
            cPrg = PROGRAM( nI - 1 )                     
            IF nI > 1 AND NOT EMPTY( cPrg ) AND TYPE( 'cPrg' ) = "C"
                lcMessage = lcMessage + "  ( " + cPrg  +;
                                    IIF( LEN( cPrg ) > 15, CHR(13), '' )
                cPrg = PROGRAM( nI - 2 )                     
                IF nI > 2 AND NOT EMPTY( cPrg ) AND TYPE( 'cPrg' ) = "C"
                   lcMessage = lcMessage + "  \ " + cPrg  + ;
                                    IIF( LEN( cPrg ) > 15, CHR(13), '' )
                ENDIF
                lcMessage = lcMessage + " ) "
             ENDIF
           IF nError # 39 AND ;
              nError # 108  
                             && 108-File is used by another ...
                             && 39- Numeric overlow. Data was lost
            
      		IF INLIST( UPPER( SUBSTR( cMethod, RAT( ".", cMethod )+1 ) ),;
    		             "ACTIVATE", "REFRESH" )
    		             
    		    RETURN .T.      && jeigu "ACTIVATE" arba "REFRESH" dingstam
    		 ELSE
    		   * cMacro = "msg( lcMessage )"
               * &cMacro
        	 ENDIF
            ENDIF
     	ENDIF             
        
        IF TYPE( "goApp.IsDebugMsg" ) = "L" AND ;
           goApp.IsDebugMsg                 && jei yra debugerio msg
             goApp.DebugMsg( lcMessage )
        ENDIF
        
    	lnAnswer = MessageBox( lcMessage, ;
    	                  16 + 2 + 512, ;
    	                  " Klaida "+ALLTRIM( STR( nError ) ) )
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
    
    
    
  ENDPROC
  
  PROCEDURE Init
    WITH This
         .nOldHeight = .Height
         .nOldWidth =  .Width
         .RestoreWindowPos()
    ENDWITH
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE refreshform
    WITH This
      .LockScreen = .T.
      .Refresh()
      .LockScreen = .F.
    ENDWITH
    
  ENDPROC
  
  PROCEDURE Resize
    LOCAL lI, lJ, lK                                           && darbiniai skaitliukai
    LOCAL nDeltaY, nDeltaX                                     && formos aukscio, plocio pokyciai
    LOCAL cOldLock
    WITH ThisForm
         cOldLock = .LockScreen
         .LockScreen = .T.
         nDeltaY = .Height - .nOldHeight                       && formos aukscio pokytis
         nDeltaX = .Width - .nOldWidth                         && formos plocio pokytis
         FOR lI = 1 TO .ControlCount                           && per formos objektus
             IF TYPE(".Controls(lI).cAlignment") = "C" AND ;
                NOT EMPTY(.Controls(lI).cAlignment) AND ;
                AT( "1", .Controls(lI).cAlignment) != 0
                .Controls(lI).ObjectAlign(nDeltaY, nDeltaX)
             ENDIF
             IF UPPER(.Controls(lI).BaseClass) = "PAGEFRAME"   && PageFrame
                FOR lJ = 1 TO .Controls(lI).PageCount          && per PageFrame'o puslapius
                    WITH .Controls(lI).Pages(lJ)
                         FOR lK = 1 TO .ControlCount           && per puslapio objektus
                             IF TYPE(".Controls(lK).cAlignment") = "C" AND ;
                                NOT EMPTY(.Controls(lK).cAlignment) AND ;
                                 AT( "1", .Controls(lK).cAlignment) != 0
                                .Controls(lK).ObjectAlign(nDeltaY, nDeltaX)
                             ENDIF
                         ENDFOR
                    ENDWITH
                ENDFOR
             ENDIF
         ENDFOR
         .nOldHeight = .Height                                 && irasom auksti
         .nOldWidth = .Width                                   && irasom ploti
         .LockScreen = cOldLock
    ENDWITH
  ENDPROC
  
  PROCEDURE restorewindowpos
    LPARAMETERS tcEntry
    
    LOCAL  lcBuffer, lcOldError,  llError, llError2
    LOCAL  lnTop, lnLeft, lnWidth, lnHeight,;
           lnCommaPos,lnCommaPos2,lnCommaPos3, ;
           lcEntry, lnScrWidth,  lnScrHeight 
    
    IF NOT This.IsRestorePosition  OR EMPTY( This.cIniFileName )
       RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    lcBuffer = SPACE(20) + CHR(0)
    lcOldError = ON('ERROR')
    
    DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
      String cSection, String cKey, String cDefault, String @cBuffer, ;
      Integer nBufferSize, String cINIFile
    
    DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
      String cSection, String cKey, String cValue, String cINIFile
    
    *-- Read the window position from the INI file
    IF GetPrivStr("WindowPositions", lcEntry, "", ;
                   @lcBuffer, LEN(lcBuffer), ;
                   This.cIniFileName ) > 0
       *-- If an error occurs while parsing the string, 
       *-- just ignore the string and use the form's 
       *-- defaults
       ON ERROR llError = .T.
       lnCommaPos = AT(",", lcBuffer)
       lnCommaPos2 = IIF( AT(",", lcBuffer, 2) # 0, AT(",", lcBuffer, 2), LEN(lcBuffer) )
       lnTop  = VAL(LEFT(lcBuffer, lnCommaPos - 1))
       lnLeft = VAL(SUBSTR(lcBuffer, lnCommaPos + 1,lnCommaPos2-lnCommaPos ))
       
       llError2 = llError
       IF NOT llError2 AND This.BorderStyle = 3                    && jeigu sizeable border
          lnCommaPos3 = AT(",", lcBuffer, 3)
          lnHeight = VAL(SUBSTR(lcBuffer, lnCommaPos2 + 1,lnCommaPos3-lnCommaPos2 ))
          lnWidth =  VAL(SUBSTR(lcBuffer, lnCommaPos3 + 1))
       ENDIF   
       IF NOT llError2
          lnScrWidth  = SYSMETRIC(1)
          lnScrHeight = SYSMETRIC(2)- 48
          IF ( lnScrWidth > MAX( 600, lnWidth ) ) AND ;
             ( lnLeft + lnWidth  > lnScrWidth )
              lnLeft = lnScrWidth - lnWidth
          ENDIF
          IF ( lnScrHeight > MAX( 350, lnHeight ) ) AND ;
             ( lnTop + lnHeight > lnScrHeight )
              lnTop = lnScrHeight - lnHeight 
          ENDIF
          This.Top = lnTop
          This.Left = lnLeft
       ENDIF   
       IF TYPE( "lnWidth" ) = "N" AND lnWidth > 0 AND ;
          TYPE( "lnHeight" ) = "N" AND lnHeight > 0
    
             This.Width  = lnWidth
             This.Height = lnHeight
             This.Resize()
       ENDIF  
       
       lnWidth = This.Width  
       lnHeight = This.Height 
       ON ERROR &lcOldError
    ENDIF
    
    
  ENDPROC
  
  PROCEDURE savewindowpos
    LPARAMETERS tcEntry
    
    LOCAL lcValue, lcEntry
    
    IF EMPTY( This.cIniFileName ) 
       RETURN .F.
    ENDIF
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
    lcValue = ALLT(STR(MAX(This.Top, 0))) + ',' + ;
              ALLT(STR(MAX(This.Left, 0))) 
    IF This.BorderStyle = 3          
       lcValue = lcValue + ',' + ;
              ALLT(STR(MAX(This.Height, 0))) + ',' + ;
              ALLT(STR(MAX(This.Width, 0)))
    ENDIF
             
    *-- Write the entry to the INI file
    =WritePrivStr("WindowPositions", lcEntry, ;
                  lcValue, This.cIniFileName )
    
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_form2
**************************************************



**************************************************
*-- Class:        l_formset (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  formset
*-- BaseClass:    formset
*-- Bazinë Form Set'o klasë
*
DEFINE CLASS l_formset AS formset

  Name = "l_formset"

  ADD OBJECT form1 AS form WITH ;
        Caption = "Form1" ;
      , DoCreate = .T. ;
      , Name = "Form1"




ENDDEFINE
*
*-- EndDefine: l_formset
**************************************************



**************************************************
*-- Class:        l_grid (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Bazinë Grid'o klasë
*
DEFINE CLASS l_grid AS grid

  ColumnCount = 0
  FontName = "MS Sans Serif"
  Height = 200
  Name = "l_grid"
  Width = 320
  calignment = ("000000")
  clocvalues = ("!@#$%^&*()_0123456789_AaÀàBbCcÈèDdEeÆæËëFfGgHhIiÁáYyJjKkLlMmNnOoPpQqRrSsÐðTtUuØøÛûVvWwZzÞþXx.,")
  nselrecno = 0

  
  PROCEDURE DblClick
    This.OnDoubleClick( This )
    RETURN .T.
  ENDPROC
  
  PROCEDURE gridsetup
    LPARAMETERS oObject
    
    LOCAL nI                                         && darbinis skaitliukas
    LOCAL cFontName                                  && fonto vardas
    LOCAL nGridWidth                                 && GRID'o plotis
    LOCAL nColorBackSel
    LOCAL nColorBack
    LOCAL nBeg
    
    IF TYPE( "oObject.Name" ) # "C"
      oObject = ThisForm
    ENDIF
    
    WITH This
         cFontName = .FontName
         nGridWidth = SYSMETRIC(14) * 2 - 3          && GRID'o plotis ScroolBar'o plotis
         nColorBackSel = RGB( 0, 0, 128 )
         nColorBack = RGB( 128, 128, 128 )
         nColorBack = .BackColor
         nBeg = This.ColumnCount
         FOR nI =  + 1 TO   oObject.nGridColumnsCount 
             .AddColumn(nI + nBeg )
             WITH .Columns(nI + nBeg )
             
                  .Name = "col" + oObject.aGridProperties[nI, 1]
                  ThisForm.IsIgnoreErrors = .T.
                  .ControlSource = oObject.aGridProperties[nI, 2]
                  IF .ControlSource != oObject.aGridProperties[ nI, 2 ] 
                     GetMessage( "Klaida : nepasisekë priskirti lentelës stulpelio "+ CR +;
                                 "iðraiðka : "+ oObject.aGridProperties[ nI, 2 ], 0 )
                  ENDIF
                  ThisForm.IsIgnoreErrors = .F.
                  
                  WITH .Header1
                       .Name = "hdr" + oObject.aGridProperties[nI, 1]                                                    
                       .Caption = oObject.aGridProperties[nI, 4]
                       .Alignment = 2
                       .FontName = cFontName
                       .FontBold = .T.
                   ENDWITH
    
                  .RemoveObject( "Text1" )
                  IF TYPE( ".Text1.Name" ) # "C"
                     .AddObject( "Text1", "gc_textbox" )
                  ENDIF
                  nColorBackSel = .Text1.SelectedBackColor
    
                  WITH .Text1
                        .Name = "txt" + oObject.aGridProperties[nI, 1]
                        .FontName = cFontName                        
                        .DisabledForeColor = 0
                        .Enabled = .T.
                        .ReadOnly = .T.
                        .Visible = .T.
                        .Alignment = oObject.aGridProperties[nI, 5]
                        .SelectOnEntry = .F.
                  ENDWITH
    
                  .Alignment = oObject.aGridProperties[nI, 5]
                  .FontName = cFontName
                  .Enabled = .T.
                  .SelectOnEntry = .F.
                  .Width = IIF(oObject.aGridProperties[nI, 3] > LEN(oObject.aGridProperties[nI, 4]), ;
                               oObject.aGridProperties[nI, 3] * FONTMETRIC(6, .FontName, .FontSize), ;
                               LEN(oObject.aGridProperties[nI, 4]) * FONTMETRIC(6, .FontName, .FontSize, "B"))
                  IF NOT oObject.aGridProperties[nI, 6]
                     nGridWidth = nGridWidth + .Width + 1
                  ENDIF
                  
              ENDWITH                   
         ENDFOR
    
    *!*	     This.SetAll( "DynamicBackColor", ;
    *!*	       "IIF( TYPE( '"+This.cRecName + "' ) = 'N' AND "+;
    *!*	       "RECNO() = " + This.cRecName + " ,"+ STR( nColorBackSel ) +" ,"+;
    *!*	         STR( nColorBack ) + " )",;
    *!*		   "Column")  
    
    *!*	     This.SetAll( "DynamicForeColor", ;
    *!*	       "IIF( TYPE( '"+This.cRecName + "' ) = 'N' AND "+;
    *!*	       "RECNO() = " + This.cRecName + " ,"+ STR( RGB( 192, 192, 192 )) +" ,"+;
    *!*	         STR( 0 ) + " )",;
    *!*		   "Column")  
    
    ENDWITH
    
    
  ENDPROC
  
  PROCEDURE Init
    This.OnInit()
    
  ENDPROC
  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas randasi PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas randasi normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY - .HeaderHeight > 0    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX - .HeaderHeight  > 0    && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC
  
  PROCEDURE ondoubleclick
    LPARAMETERS oObject
    
    IF TYPE( "oObject.SelStart" ) = "N"
      oObject.SelStart = 1
      oObject.SelLength = 0
    ENDIF
    
  ENDPROC
  
  PROCEDURE oninit
    This.Parent.AddObject("linGridH", "l_line")
    WITH This.Parent.linGridH
         .Top = This.Top + This.Height
         .Left = This.Left
         .Width = This.Width
         .Height = 0
         .cAlignment = "0110"
         .BorderColor = RGB(255,255,255)
         .Visible = .T.
    ENDWITH
    This.Parent.AddObject("linGridV", "l_line")
    WITH This.Parent.linGridV
         .Top = This.Top 
         .Left = This.Left + This.Width
         .Width = 0
         .Height = This.Height
         .cAlignment = "1001"
         .BorderColor = RGB(255, 255, 255)
         .Visible = .T.
    ENDWITH
    
    *!*	cMacro = "gn"+ThisForm.Name 
    *!*	This.cRecName = cMacro
    *!*	PUBLIC &cMacro
    *!*	&cMacro = 0
    
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_grid
**************************************************



**************************************************
*-- Class:        l_image (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  image
*-- BaseClass:    image
*-- Bazinë Image klasë
*
DEFINE CLASS l_image AS image

  Height = 68
  Name = "bc_image"
  Width = 68
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_image
**************************************************



**************************************************
*-- Class:        l_label (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Bazinë Label'o klasë
*
DEFINE CLASS l_label AS label

  AutoSize = .T.
  Caption = "Label1"
  FontName = "MS Sans Serif"
  Height = 15
  Name = "bc_label"
  Width = 34
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_label
**************************************************



**************************************************
*-- Class:        l_line (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  line
*-- BaseClass:    line
*-- Bazinë Line  klasë
*
DEFINE CLASS l_line AS line

  Height = 68
  Name = "bc_line"
  Width = 68
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas randasi PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas randasi normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    ENDWITH
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_line
**************************************************



**************************************************
*-- Class:        l_listbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Bazinë List Box'o klasë
*
DEFINE CLASS l_listbox AS listbox

  FontName = "MS Sans Serif"
  Height = 68
  Name = "bc_listbox"
  SelectedItemBackColor = RGB(0,0,128)
  Width = 99
  calignment = ("000000")

  
  PROCEDURE GotFocus
    **This.SelectedItemBackColor = RGB(0, 0, 128)
  ENDPROC
  
  PROCEDURE LostFocus
    **This.SelectedItemBackColor = RGB(0, 128, 128)
  ENDPROC
  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_listbox
**************************************************



**************************************************
*-- Class:        l_listview (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  olecontrol
*-- BaseClass:    olecontrol
*-- OLEObject = C:\WINNT\System32\mscomctl.ocx
*-- List View control
*
DEFINE CLASS l_listview AS olecontrol

  Height = 100
  Name = "l_listview"
  Width = 100
  calignment = ("0000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas randasi PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas randasi normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_listview
**************************************************



**************************************************
*-- Class:        l_pageframe (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  pageframe
*-- BaseClass:    pageframe
*-- Bazinë Page Frame'o klasë
*
DEFINE CLASS l_pageframe AS pageframe

  ActivePage = 0
  ErasePage = .T.
  Height = 79
  Name = "bc_pageframe"
  PageCount = 0
  Width = 160
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height  + nDeltaY > .Height -.PageHeight
                                                     && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"  AND ;
            .Width + nDeltaX > 2                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_pageframe
**************************************************



**************************************************
*-- Class:        l_shape (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Bazinë Shape klasë
*
DEFINE CLASS l_shape AS shape

  BackStyle = 0
  Height = 68
  Name = "bc_shape"
  SpecialEffect = 0
  Width = 68
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas randasi PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas randasi normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    ENDWITH
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_shape
**************************************************



**************************************************
*-- Class:        l_spinner (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Bazinë Spinner'io klasë
*
DEFINE CLASS l_spinner AS spinner

  FontName = "MS Sans Serif"
  Height = 24
  Name = "bc_spinner"
  Width = 107
  calignment = ("000000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_spinner
**************************************************



**************************************************
*-- Class:        l_textbox (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Bazinë Text Box'o klasë
*
DEFINE CLASS l_textbox AS textbox

  FontName = "MS Sans Serif"
  Height = 24
  Name = "l_textbox"
  Width = 113
  calignment = ("000000")
  lishelp = .F.

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((.Parent.Height - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((.Parent.Width - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_textbox
**************************************************



**************************************************
*-- Class:        l_toolbar (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Bazinë Tool Bar'o klasë
*
DEFINE CLASS l_toolbar AS toolbar

  Caption = "Toolbar1"
  Height = 22
  Left = 0
  Name = "bc_toolbar"
  Top = 0
  Width = 33




ENDDEFINE
*
*-- EndDefine: l_toolbar
**************************************************



**************************************************
*-- Class:        l_treeview (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  olecontrol
*-- BaseClass:    olecontrol
*-- OLEObject = C:\WINNT\System32\mscomctl.ocx
*-- treeview control
*
DEFINE CLASS l_treeview AS olecontrol

  Height = 100
  Name = "l_treeview"
  Width = 100
  calignment = ("0000")

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
         IF .Parent.BaseClass = "Page"               && objektas randasi PageFrame'o lape (nera properciu Height ir Width)
            nHeight = .Parent.Parent.PageHeight
            nWidth  = .Parent.Parent.PageWidth
         ELSE                                        && objektas randasi normaliame objekte
            nHeight = .Parent.Height
            nWidth  = .Parent.Width
         ENDIF
         IF LEN(.cAlignment) > 0 AND ;
            SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
            .Height + nDeltaY > 0                    && Resize pagal Y
            .Height = .Height + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 1 AND ;
            SUBSTR(.cAlignment, 2, 1) = "1" AND ;
            .Width + nDeltaX > 0                     && Resize pagal X
            .Width = .Width + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 2 AND ;
            SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
            .Top = .Top + nDeltaY
         ENDIF
         IF LEN(.cAlignment) > 3 AND ;
            SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
            .Left = .Left + nDeltaX
         ENDIF
         IF LEN(.cAlignment) > 4 AND ;
            SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
            .Top = INT((nHeight - .Height) / 2)
         ENDIF
         IF LEN(.cAlignment) > 5 AND ;
            SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
            .Left = INT((nWidth - .Width) / 2)
         ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_treeview
**************************************************



**************************************************
*-- Class:        vcr (d:\beta\fcmd\vfpproj\xfilerw\lib.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- generic vcr buttons
*
DEFINE CLASS vcr AS container

  BackColor = RGB(192,192,192)
  BorderWidth = 0
  Height = 28
  Name = "vcr"
  Width = 167
  enabledisableoninit = .T.
  skiptable =[]

  ADD OBJECT cmdtop AS commandbutton WITH ;
        Caption = "\<First" ;
      , FontBold = .F. ;
      , FontName = "MS Sans Serif" ;
      , FontSize = 9 ;
      , Height = 23 ;
      , Left = 0 ;
      , Name = "cmdTop" ;
      , TabIndex = 1 ;
      , TabStop = .F. ;
      , ToolTipText = "Top" ;
      , Top = 0 ;
      , Width = 41

  ADD OBJECT cmdprior AS commandbutton WITH ;
        Caption = "\<Prev" ;
      , FontBold = .F. ;
      , FontName = "MS Sans Serif" ;
      , FontSize = 9 ;
      , Height = 23 ;
      , Left = 40 ;
      , Name = "cmdPrior" ;
      , TabIndex = 2 ;
      , TabStop = .F. ;
      , ToolTipText = "Prior" ;
      , Top = 0 ;
      , Width = 41

  ADD OBJECT cmdnext AS commandbutton WITH ;
        Caption = "\<Next" ;
      , FontBold = .F. ;
      , FontName = "MS Sans Serif" ;
      , FontSize = 9 ;
      , Height = 23 ;
      , Left = 80 ;
      , Name = "cmdNext" ;
      , TabIndex = 3 ;
      , TabStop = .F. ;
      , ToolTipText = "Next" ;
      , Top = 0 ;
      , Width = 41

  ADD OBJECT cmdbottom AS commandbutton WITH ;
        Caption = "\<Last" ;
      , FontBold = .F. ;
      , FontName = "MS Sans Serif" ;
      , FontSize = 9 ;
      , Height = 23 ;
      , Left = 120 ;
      , Name = "cmdBottom" ;
      , TabIndex = 4 ;
      , TabStop = .F. ;
      , ToolTipText = "Bottom" ;
      , Top = 0 ;
      , Width = 41

  
  PROCEDURE beforerecordpointermoved
    IF !EMPTY(This.SkipTable)
    	SELECT (This.SkipTable)
    ENDIF
    
  ENDPROC
  
  PROCEDURE enabledisablebuttons
    LOCAL nRec, nTop, nBottom
    THIS.beforerecordPointerMoved
    IF EOF() && Table empty or no records match a filter
    	THIS.SetAll("Enabled", .F.)
    	RETURN
    ENDIF
    
    nRec = RECNO()
    GO TOP
    nTop = RECNO()
    GO BOTTOM
    nBottom = RECNO()
    GO nRec
    
    DO CASE
    	CASE nRec = nTop
    		THIS.cmdTop.Enabled = .F.
    		THIS.cmdPrior.Enabled = .F.
    		THIS.cmdNext.Enabled = .T.
    		THIS.cmdBottom.Enabled = .T.
    	CASE nRec = nBottom
    		THIS.cmdTop.Enabled = .T.
    		THIS.cmdPrior.Enabled = .T.
    		THIS.cmdNext.Enabled = .F.
    		THIS.cmdBottom.Enabled = .F.
    	OTHERWISE
    		THIS.SetAll("Enabled", .T.)
    ENDCASE
  ENDPROC
  
  PROCEDURE Error
    Parameters nError, cMethod, nLine
    #define NUM_LOC "Error Number: "
    #define PROG_LOC "Procedure: "
    #define MSG_LOC "Error Message: "
    #define CR_LOC CHR(13)
    #define SELTABLE_LOC "Select Table:"
    #define OPEN_LOC "Open"
    #define SAVE_LOC "Do you want to save your changes anyway?"
    #define CONFLICT_LOC "Unable to resolve data conflict."
    
    DO CASE
    	CASE nError = 13 && Alias not found
    	*-----------------------------------------------------------
    	* If the user tries to move the record pointer when no
    	* table is open or when an invalid SkipTable property has been
    	* specified, prompt the user for a table to open.
    	*-----------------------------------------------------------
    		cNewTable = GETFILE('DBF', SELTABLE_LOC, OPEN_LOC)
    		IF FILE(cNewTable)
    			SELECT 0
    			USE (cNewTable)
    			This.SkipTable = ALIAS()
    		ELSE
    			This.SkipTable = ""
    		ENDIF
    	OTHERWISE
    	*-----------------------------------------------------------
    	* Display information about an unanticipated error.
    	*-----------------------------------------------------------
    		lcMsg = NUM_LOC + ALLTRIM(STR(nError)) + CR_LOC + CR_LOC + ;
    				MSG_LOC + MESSAGE( )+ CR_LOC + CR_LOC + ;
    				PROG_LOC + PROGRAM(1)
    		lnAnswer = MESSAGEBOX(lcMsg, 2+48+512)
    		DO CASE
    			CASE lnAnswer = 3 &&Abort
    				CANCEL
    			CASE lnAnswer = 4 &&Retry
    				RETRY
    			OTHERWISE
    				RETURN
    		ENDCASE
    ENDCASE
    
  ENDPROC
  
  PROCEDURE Init
    IF THIS.EnableDisableOnInit
    	THIS.EnableDisableButtons
    ENDIF
  ENDPROC
  
  PROCEDURE recordpointermoved
    THISForm.Refresh
    
  ENDPROC
  
  PROCEDURE Refresh
    THIS.EnableDisableButtons
  ENDPROC
  
  PROCEDURE cmdtop.Click
    THIS.Parent.BeforeRecordPointerMoved
    
    GO TOP
    
    THIS.Parent.RecordPointerMoved
    THIS.Parent.EnableDisableButtons
    
  ENDPROC
  
  PROCEDURE cmdtop.Error
    Parameters nError, cMethod, nLine
    This.Parent.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdprior.Click
    THIS.Parent.BeforeRecordPointerMoved
    
    
    SKIP -1
    THISFORM.Grid1.SetFocus
    THIS.SetFocus
    
    IF BOF()
    	GO TOP
    ENDIF
    
    THIS.Parent.RecordPointerMoved
    THIS.Parent.EnableDisableButtons
    
  ENDPROC
  
  PROCEDURE cmdprior.Error
    Parameters nError, cMethod, nLine
    This.Parent.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdnext.Click
    THIS.Parent.BeforeRecordPointerMoved
    
    SKIP 1
    THISFORM.Grid1.SetFocus
    THIS.SetFocus
    
    IF EOF()
    	GO BOTTOM
    ENDIF
    
    THIS.Parent.RecordPointerMoved
    THIS.Parent.EnableDisableButtons
    
  ENDPROC
  
  PROCEDURE cmdnext.Error
    Parameters nError, cMethod, nLine
    This.Parent.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdbottom.Click
    THIS.Parent.BeforeRecordPointerMoved
    
    GO BOTTOM
    
    THIS.Parent.EnableDisableButtons
    THIS.Parent.RecordPointerMoved
  ENDPROC
  
  PROCEDURE cmdbottom.Error
    Parameters nError, cMethod, nLine
    This.Parent.Error(nError, cMethod, nLine)
  ENDPROC


ENDDEFINE
*
*-- EndDefine: vcr
**************************************************
