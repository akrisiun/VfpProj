* lib.vcx
**************************************************
*-- Class Library:  lib.vcx
**************************************************

**************************************************
*-- Class:        l_checkbox (\lib.vcx)
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
  Name = "l_checkbox"
  StatusBarText = "."
  Width = 55
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
*-- EndDefine: l_checkbox
**************************************************



**************************************************
*-- Class:        l_combobox (\lib.vcx)
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
*-- Class:        l_commandbutton (\lib.vcx)
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
*-- Class:        l_container (\lib.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Bazinë Container'io klasë
*
* #INCLUDE "\setv.h"
*
DEFINE CLASS l_container AS container

  BackStyle = 0
  BorderWidth = 0
  Height = 90
  Name = "l_container"
  Width = 376
  calignment = ("0000")
  hookclass = "HookContainer"
  hookclasslib = ([ThisForm.ThisPath+"L_cls.prg"])
  ogrid = .NULL.
  ohook = .NULL.

  
  PROCEDURE Destroy
    WITH This
      .NewObject( 'oHook2', .HookClass, .Hookclasslib, "", This )
      .oHook = .oHook2
      .oHook.OnDestroy( This ) 
      .oHook = .NULL.
      .RemoveObject( 'oHook2' )
    ENDWITH
    
  ENDPROC
  
  PROCEDURE GotFocus
    This.oHook.OnGotFocus()
  ENDPROC
  
  PROCEDURE Init
    #INCLUDE ".\SetV.h"
    
    WITH This
      SET ASSERTS ON 
    
      IF "+" $ This.HookClasslib 
         This.HookClasslib = EVALUATE( This.HookClasslib )
      ENDIF
      
      .NewObject( "oHook1", .HookClass, .Hookclasslib, "", This )
      .oHook = .oHook1   
      
    ENDWITH 
    
  ENDPROC
  
  PROCEDURE LostFocus
    This.oHook.OnLostFocus()
  ENDPROC
  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti
    
    WITH This
    	 .oHook.ObjectAlign( nDeltaY, nDeltaX )
    	 
    *!*	     IF .Parent.BaseClass = "Page"               && objektas yra PageFrame'o lape (nera properciu Height ir Width)
    *!*	        nHeight = .Parent.Parent.PageHeight
    *!*	        nWidth  = .Parent.Parent.PageWidth
    *!*	     ELSE                                        && objektas yra normaliame objekte
    *!*	        nHeight = .Parent.Height
    *!*	        nWidth  = .Parent.Width
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 0 AND ;
    *!*	        SUBSTR(.cAlignment, 1, 1) = "1"  AND ;
    *!*	        .Height + nDeltaY > 0                    && Resize pagal Y
    *!*	        .Height = .Height + nDeltaY
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 1 AND ;
    *!*	        SUBSTR(.cAlignment, 2, 1) = "1" AND ;
    *!*	        .Width + nDeltaX > 0                     && Resize pagal X
    *!*	        .Width = .Width + nDeltaX
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 2 AND ;
    *!*	        SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
    *!*	        .Top = .Top + nDeltaY
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 3 AND ;
    *!*	        SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
    *!*	        .Left = .Left + nDeltaX
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 4 AND ;
    *!*	        SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
    *!*	        .Top = INT((nHeight - .Height) / 2)
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 5 AND ;
    *!*	        SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
    *!*	        .Left = INT((nWidth - .Width) / 2)
    *!*	     ENDIF
    
         This.ObjectCtrlAlign( nDeltaY, nDeltaX )
         
    ENDWITH
    
  ENDPROC
  
  PROCEDURE objectctrlalign
    LPARAMETERS nDeltaY, nDeltaX                     && Cordinates deltas
    
    WITH This
         This.oHook.ObjectCtrlAlign( nDeltaY, nDeltaX )
    
    *!*	     FOR lI = 1 TO .ControlCount                 && cycle in objects
    *!*	         IF TYPE(".Controls(lI).cAlignment") = "C" AND ;
    *!*	            NOT EMPTY(.Controls(lI).cAlignment) AND ;
    *!*	            AT( "1", .Controls(lI).cAlignment) != 0
    *!*	            .Controls(lI).ObjectAlign( nDeltaY, nDeltaX )
    *!*	         ENDIF
    *!*	     ENDFOR
    ENDWITH
    
  ENDPROC
  
  PROCEDURE ohook_access
    *To do: Modify this routine for the Access method
    WITH This
    	IF TYPE( ".oHook.oTarget" ) # 'O'
    	   ASSERT .F. MESSAGE "Re Assign oHook." + This.Name 
    	   && .oHook = NEWOBJECT( .HookClass, .Hookclasslib, "", This )
    	ENDIF 
    	RETURN .oHook
    ENDWITH
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_container
**************************************************



**************************************************
*-- Class:        l_control (\lib.vcx)
*-- ParentClass:  control
*-- BaseClass:    control
*-- Bazinë Control'o klasë
*
DEFINE CLASS l_control AS control

  BackStyle = 0
  BorderWidth = 0
  Height = 40
  Name = "l_control"
  Width = 205
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
*-- Class:        l_custom (\lib.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Bazinë Custom klasë
*
DEFINE CLASS l_custom AS custom

  Height = 60
  Name = "l_custom"
  Width = 160




ENDDEFINE
*
*-- EndDefine: l_custom
**************************************************



**************************************************
*-- Class:        l_editbox (\lib.vcx)
*-- ParentClass:  editbox
*-- BaseClass:    editbox
*-- Bazinë Edit Box'o klasë
*
DEFINE CLASS l_editbox AS editbox

  FontName = "MS Sans Serif"
  Height = 100
  Name = "l_editbox"
  Width = 200
  calignment = ("0000")

  
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
*-- Class:        l_form (\lib.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*-- Bazinë Form'os klasë
*
*#INCLUDE "\setv.h"
*
DEFINE CLASS l_form AS form

  Caption = "L_Form"
  DoCreate = .T.
  FontName = "MS Sans Serif"
  Height = 118
  KeyPreview = .T.
  Left = 12
  LockScreen = .T.
  MDIForm = .T.
  Name = "l_form"
  ShowTips = .T.
  Top = 3
  Visible = .F.
  Width = 375
  cinifilename = ([.ThisPath + "setv.Ini"])
  hookclass = "HookForm"
  hookclasslib = ([.ThisPath+"L_cls.prg"])
  isignoreerrors = .F.
  isrestoreposition = .T.
  noldheight =[]
  noldwidth =[]
  oaction = .NULL.
  oappobject = .NULL.
  ogrid = .NULL.
  ohook = .NULL.
  opgf = .NULL.
  thispath = (THIS_PATH)
  uretval = .F.

  
  PROCEDURE Destroy
    This.oHook.OnDestroy( This )
    
    Form::Destroy()
    
    *!*	IF This.ControlCount = 0
    *!*	   RETURN .T.
    *!*	ENDIF
    *!*	WITH This
    *!*	  && ASSERT .F. MESSAGE "Left controls.." 
    *!*	  FOR lnI = 1 TO .ControlCount 
    *!*	     oObj = .Controls( .ControlCount )
    *!*	     DEBUGOUT "Force destroy "+ oObj.Name 
    *!*	     .RemoveObject( oObj.Name )
    *!*	  ENDFOR
    *!*	ENDWITH 
    
  ENDPROC
  
  PROCEDURE Init
    LPARAMETERS tParam1
    
    RETURN This.oHook.OnInit( tParam1 )
    
  ENDPROC
  
  PROCEDURE Load
    #INCLUDE ".\SetV.h"
    
    WITH This
      	 SET ASSERTS ON 
    
     	 .ThisPath  = THIS_PATH 
    	 IF "+" $ .cIniFilename 
       	    .cIniFilename = EVALUATE( .cIniFileName )
       	 ENDIF   
    	 IF "+" $ .Hookclasslib
    	    .Hookclasslib = EVALUATE( .Hookclasslib )
         ENDIF
         .nOldHeight = .Height
         .nOldWidth =  .Width
         
         .NewObject( "oHook1", .HookClass, .Hookclasslib, "", This )
         .oHook = .oHook1         
    
         .oHook.OnLoad()
    ENDWITH 
    
  ENDPROC
  
  PROCEDURE ohook_access
    *To do: Modify this routine for the Access method
    WITH This
    	IF TYPE( ".oHook.oForm" ) # 'O'
    	   ASSERT .F. MESSAGE "Re Assign oHook" + This.Name
    	   &&& .oHook = NEWOBJECT( .HookClass, .Hookclasslib, "", This )
    	ENDIF 
    	RETURN .oHook
    ENDWITH
  ENDPROC
  
  PROCEDURE onerror
    LPARAMETERS tnError, tcMsg, tcMethod, tnLine
    
    IF ! This.isIgnoreErrors 
    	This.oAppObject.OnError( tnError, tcMsg )
    ENDIF
    
    
    
    
    
  ENDPROC
  
  PROCEDURE refreshform
    WITH This
      .LockScreen = .T.
      .Refresh()
      .LockScreen = .F.
    ENDWITH
    
  ENDPROC
  
  PROCEDURE Resize
    LPARAMETERS tNotLock
    
    This.oHook.OnResize( tNotLock )
    
  ENDPROC
  
  PROCEDURE restoreprop
    RETURN This.oHook.RestoreProp()
    
  ENDPROC
  
  PROCEDURE Unload
    WITH This
    
        && .oHook = NewObject( .HookClass, .Hookclasslib, "", This )
        .NewObject( 'oHook2', .HookClass, .Hookclasslib, "", This )
        .oHook = .oHook2
           .oHook.OnUnload( This )
    	.oHook = .NULL.
    	.RemoveObject( 'oHook2' )
    	RETURN (.uRetVal)
    ENDWITH 
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_form
**************************************************



**************************************************
*-- Class:        l_grid (\lib.vcx)
*-- ParentClass:  grid
*-- BaseClass:    grid
*-- Bazinë Grid'o klasë
*
*#INCLUDE "\setv.h"
*
DEFINE CLASS l_grid AS grid

  ColumnCount = 0
  FontName = "MS Sans Serif"
  Height = 200
  Name = "l_grid"
  RecordSourceType = 1
  Width = 320
  calignment = ("000000")
  clocvalues = ("!@#$%^&*()_0123456789_AaÀàBbCcÈèDdEeÆæËëFfGgHhIiÁáYyJjKkLlMmNnOoPpQqRrSsÐðTtUuØøÛûVvWwZzÞþXx.,")
  def_highlightbackcolor = (RGB(0,0,0))
  def_lowlightbackcolor = (RGB(255,255,255))
  hookclass =[]
  hookclasslib =[]
  lon_autoinit = .T.
  nselrecno = 0
  ohook = .NULL.
  thispath =[]

  
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
    
    *!*	IF TYPE( "oObject.Name" ) # "C"
    *!*	  oObject = ThisForm
    *!*	ENDIF
    
    WITH This
    
    *!*	     cFontName = .FontName
    *!*	     nGridWidth = SYSMETRIC(14) * 2 - 3          && GRID'o plotis ScroolBar'o plotis
    *!*	     nColorBackSel = RGB( 0, 0, 128 )
    *!*	     nColorBack = RGB( 128, 128, 128 )
    *!*	     nColorBack = .BackColor
    *!*	     nBeg = This.ColumnCount
    *!*	     FOR nI =  + 1 TO   oObject.nGridColumnsCount 
    
    *!*	         .AddColumn(nI + nBeg )
    *!*	         WITH .Columns(nI + nBeg )
    *!*	         
    *!*	              .Name = "col" + oObject.aGridProperties[nI, 1]
    *!*	              ThisForm.IsIgnoreErrors = .T.
    *!*	              .ControlSource = oObject.aGridProperties[nI, 2]
    *!*	              IF .ControlSource != oObject.aGridProperties[ nI, 2 ] 
    *!*	                 GetMessage( "Klaida : nepasisekë priskirti lentelës stulpelio "+ CR +;
    *!*	                             "iðraiðka : "+ oObject.aGridProperties[ nI, 2 ], 0 )
    *!*	              ENDIF
    *!*	              ThisForm.IsIgnoreErrors = .F.
    *!*	              
    *!*	              WITH .Header1
    *!*	                   .Name = "hdr" + oObject.aGridProperties[nI, 1]                                                    
    *!*	                   .Caption = oObject.aGridProperties[nI, 4]
    *!*	                   .Alignment = 2
    *!*	                   .FontName = cFontName
    *!*	                   .FontBold = .T.
    *!*	               ENDWITH
    
    *!*	              .RemoveObject( "Text1" )
    *!*	              IF TYPE( ".Text1.Name" ) # "C"
    *!*	                 .AddObject( "Text1", "gc_textbox" )
    *!*	              ENDIF
    *!*	              nColorBackSel = .Text1.SelectedBackColor
    
    *!*	              WITH .Text1
    *!*	                    .Name = "txt" + oObject.aGridProperties[nI, 1]
    *!*	                    .FontName = cFontName                        
    *!*	                    .DisabledForeColor = 0
    *!*	                    .Enabled = .T.
    *!*	                    .ReadOnly = .T.
    *!*	                    .Visible = .T.
    *!*	                    .Alignment = oObject.aGridProperties[nI, 5]
    *!*	                    .SelectOnEntry = .F.
    *!*	              ENDWITH
    
    *!*	              .Alignment = oObject.aGridProperties[nI, 5]
    *!*	              .FontName = cFontName
    *!*	              .Enabled = .T.
    *!*	              .SelectOnEntry = .F.
    *!*	              .Width = IIF(oObject.aGridProperties[nI, 3] > LEN(oObject.aGridProperties[nI, 4]), ;
    *!*	                           oObject.aGridProperties[nI, 3] * FONTMETRIC(6, .FontName, .FontSize), ;
    *!*	                           LEN(oObject.aGridProperties[nI, 4]) * FONTMETRIC(6, .FontName, .FontSize, "B"))
    *!*	              IF NOT oObject.aGridProperties[nI, 6]
    *!*	                 nGridWidth = nGridWidth + .Width + 1
    *!*	              ENDIF
    *!*	              
    *!*	          ENDWITH                   
    *!*	     ENDFOR
    
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
    WITH This
    	IF .lOn_AutoInit
    	   .OnInit()
    	ENDIF
    ENDWITH 
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
  
  PROCEDURE ongotfocus
    WITH This
     	.HighlightBackColor = .def_HighlightBackColor
    ENDWITH  	
    
  ENDPROC
  
  PROCEDURE oninit
    #INCLUDE .\setv.h
    
    WITH This 
    	This.ThisPath = THIS_PATH 
    	.HighlightStyle = 2
    	&& .def_HighlightBackColor = .HighlightBackColor
        
        .def_HighlightBackColor = COLOR_HIGHLIGHT
    	.def_LowLightBackColor  = COLOR_LOWLIGHT
    
    *!*		IF VERSION(5) <= 800
    *!*			This.Parent.AddObject( "linGridH", "l_line" )
    *!*			WITH This.Parent.linGridH
    *!*			     .Top = This.Top + This.Height
    *!*			     .Left = This.Left
    *!*			     .Width = This.Width
    *!*			     .Height = 0
    *!*			     .cAlignment = "0110"
    *!*			     .BorderColor = RGB(255,255,255)
    *!*			     .Visible = .T.
    *!*			ENDWITH
    *!*			This.Parent.AddObject("linGridV", "l_line")
    *!*			WITH This.Parent.linGridV
    *!*			     .Top = This.Top 
    *!*			     .Left = This.Left + This.Width
    *!*			     .Width = 0
    *!*			     .Height = This.Height
    *!*			     .cAlignment = "1001"
    *!*			     .BorderColor = RGB(255, 255, 255)
    *!*			     .Visible = .T.
    *!*			ENDWITH
    *!*		ENDIF 
    	
    	*!*	cMacro = "gn"+ThisForm.Name 
    	*!*	This.cRecName = cMacro
    	*!*	PUBLIC &cMacro
    	*!*	&cMacro = 0
    
    ENDWITH 
  ENDPROC
  
  PROCEDURE onlostfocus
    WITH This
     	.HighlightBackColor = .def_LowLightBackColor  
    ENDWITH  	
    
  ENDPROC
  
  PROCEDURE SetFocus
    
    This.OnSetFocus()
  ENDPROC
  
  PROCEDURE setup
    LPARAMETERS tcAlias
    
    WITH This
      .ColumnCount  = 0
      .RecordSource = tcAlias
      .ColumnCount  = 0
      .ColumnCount  = FCOUNT( .RecordSource )
      .Visible = .T.
      
    ENDWITH 
    
      
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_grid
**************************************************



**************************************************
*-- Class:        l_image (\lib.vcx)
*-- ParentClass:  image
*-- BaseClass:    image
*-- Bazinë Image klasë
*
DEFINE CLASS l_image AS image

  Height = 68
  Name = "l_image"
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
*-- Class:        l_label (\lib.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Bazinë Label'o klasë
*
DEFINE CLASS l_label AS label

  AutoSize = .T.
  Caption = "Label1"
  FontName = "MS Sans Serif"
  Height = 15
  Name = "l_label"
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
*-- Class:        l_line (\lib.vcx)
*-- ParentClass:  line
*-- BaseClass:    line
*-- Bazinë Line  klasë
*
DEFINE CLASS l_line AS line

  Height = 68
  Name = "l_line"
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
*-- Class:        l_listbox (\lib.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Bazinë List Box'o klasë
*
DEFINE CLASS l_listbox AS listbox

  FontName = "MS Sans Serif"
  Height = 68
  Name = "l_listbox"
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
*-- Class:        l_listview (\lib.vcx)
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
*-- Class:        l_pageframe (\lib.vcx)
*-- ParentClass:  pageframe
*-- BaseClass:    pageframe
*-- Bazinë Page Frame'o klasë
*
DEFINE CLASS l_pageframe AS pageframe

  ActivePage = 0
  ErasePage = .T.
  Height = 174
  Name = "l_pageframe"
  PageCount = 0
  Width = 226
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
*-- Class:        l_shape (\lib.vcx)
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Bazinë Shape klasë
*
DEFINE CLASS l_shape AS shape

  BackStyle = 0
  Height = 68
  Name = "l_shape"
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
*-- Class:        l_spinner (\lib.vcx)
*-- ParentClass:  spinner
*-- BaseClass:    spinner
*-- Bazinë Spinner'io klasë
*
DEFINE CLASS l_spinner AS spinner

  FontName = "MS Sans Serif"
  Height = 24
  Name = "l_spinner"
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
*-- Class:        l_textbox (\lib.vcx)
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
  hookclass =[]
  hookclasslib =[]
  lishelp = .F.
  ohook = .NULL.

  
  PROCEDURE objectalign
    LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio
    
    WITH This
           
           IF ! ISNULL( .oHook )
              .oHook.ObjectAlign( nDeltaY, nDeltaX )
           ENDIF  
           
    *!*	     IF LEN(.cAlignment) > 0 AND ;
    *!*	        SUBSTR(.cAlignment, 1, 1) = "1"          && Resize pagal Y
    *!*	        .Height = .Height + nDeltaY
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 1 AND ;
    *!*	        SUBSTR(.cAlignment, 2, 1) = "1"          && Resize pagal X
    *!*	        .Width = .Width + nDeltaX
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 2 AND ;
    *!*	        SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
    *!*	        .Top = .Top + nDeltaY
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 3 AND ;
    *!*	        SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
    *!*	        .Left = .Left + nDeltaX
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 4 AND ;
    *!*	        SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
    *!*	        .Top = INT((.Parent.Height - .Height) / 2)
    *!*	     ENDIF
    *!*	     IF LEN(.cAlignment) > 5 AND ;
    *!*	        SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
    *!*	        .Left = INT((.Parent.Width - .Width) / 2)
    *!*	     ENDIF
    ENDWITH
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: l_textbox
**************************************************



**************************************************
*-- Class:        l_toolbar (\lib.vcx)
*-- ParentClass:  toolbar
*-- BaseClass:    toolbar
*-- Bazinë Tool Bar'o klasë
*
DEFINE CLASS l_toolbar AS toolbar

  Caption = "Toolbar1"
  Height = 19
  Left = 0
  Name = "l_toolbar"
  Top = 0
  Width = 33




ENDDEFINE
*
*-- EndDefine: l_toolbar
**************************************************



**************************************************
*-- Class:        l_treeview (\lib.vcx)
*-- ParentClass:  olecontrol
*-- BaseClass:    olecontrol
*-- OLEObject = C:\WINDOWS\System32\MSCOMCTL.OCX
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
