* d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx
**************************************************
*-- Class Library:  d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx
**************************************************


**************************************************
*-- Class:        frm_foxcode (d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\foxcode.h"
*
DEFINE CLASS frm_foxcode AS form

  BorderStyle = 2
  Caption = "XCode IntelliSense Manager"
  DataSession = 2
  DoCreate = .T.
  FontName = "MS Sans Serif"
  FontSize = 8
  Height = 296
  HelpContextID = 1230986
  Left = 13
  MaxButton = .F.
  Name = "frm_foxcode"
  ShowTips = .T.
  Top = 7
  Visible = .F.
  Width = 446
  ccmdcap =[]
  cdefaultcase =[]
  cfunccap =[]
  csavemessage = .F.
  haderror = .F.
  nlangopt = .F.
  nsaveshowplan = .F.

  ADD OBJECT pf1 AS pageframe WITH ;
        ErasePage = .T. ;
      , Height = 269 ;
      , Left = 1 ;
      , Name = "pf1" ;
      , Page1.Caption = "\<General" ;
      , Page1.FontName = "Tahoma" ;
      , Page1.FontSize = 8 ;
      , Page1.Name = "Page1" ;
      , Page1.PageOrder = 1 ;
      , Page2.Caption = "T\<ypes" ;
      , Page2.FontName = "Tahoma" ;
      , Page2.FontSize = 8 ;
      , Page2.Name = "Page2" ;
      , Page2.PageOrder = 2 ;
      , Page3.Caption = "C\<ustom" ;
      , Page3.FontName = "Tahoma" ;
      , Page3.FontSize = 8 ;
      , Page3.Name = "Page3" ;
      , Page3.PageOrder = 3 ;
      , Page4.Caption = "Adva\<nced" ;
      , Page4.FontName = "Tahoma" ;
      , Page4.FontSize = 8 ;
      , Page4.Name = "Page4" ;
      , Page4.PageOrder = 4 ;
      , PageCount = 4 ;
      , TabIndex = 1 ;
      , TabStyle = 1 ;
      , Top = 0 ;
      , Width = 446

  ADD OBJECT pf1.page1.command2 AS commandbutton WITH ;
        Caption = "\<Tips" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 340 ;
      , Name = "Command2" ;
      , TabIndex = 14 ;
      , ToolTipText = "Displays window showing command/function syntax." ;
      , Top = 55 ;
      , Width = 72

  ADD OBJECT pf1.page1.label1 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Functions:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 40 ;
      , Name = "Label1" ;
      , TabIndex = 7 ;
      , Top = 118 ;
      , Width = 52

  ADD OBJECT pf1.page1.cbofunccap AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 134 ;
      , Name = "cboFuncCap" ;
      , Style = 2 ;
      , TabIndex = 8 ;
      , ToolTipText = "Changes capitalization for expansion of functions." ;
      , Top = 115 ;
      , Width = 144

  ADD OBJECT pf1.page1.label2 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Commands:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 40 ;
      , Name = "Label2" ;
      , TabIndex = 9 ;
      , Top = 142 ;
      , Width = 58

  ADD OBJECT pf1.page1.cbocmdcap AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 134 ;
      , Name = "cboCmdCap" ;
      , Style = 2 ;
      , TabIndex = 10 ;
      , ToolTipText = "Changes capitalization for expansion of commands." ;
      , Top = 139 ;
      , Width = 144

  ADD OBJECT pf1.page1.label3 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Capitalization / Expansion" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 16 ;
      , Name = "Label3" ;
      , TabIndex = 6 ;
      , Top = 91 ;
      , Width = 125

  ADD OBJECT pf1.page1.chkreserved AS checkbox WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Apply changes to Visual FoxPro language only" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 52 ;
      , Name = "chkReserved" ;
      , TabIndex = 13 ;
      , ToolTipText = "Only affect Visual FoxPro native commands and functions." ;
      , Top = 189 ;
      , Value = .F. ;
      , Width = 238

  ADD OBJECT pf1.page1.cmdbrowse AS commandbutton WITH ;
        Caption = "\<Browse" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 340 ;
      , Name = "cmdBrowse" ;
      , TabIndex = 15 ;
      , ToolTipText = "Browse FoxCode table." ;
      , Top = 31 ;
      , Width = 72

  ADD OBJECT pf1.page1.cbodefaultcase AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 134 ;
      , Name = "cboDefaultCase" ;
      , Style = 2 ;
      , TabIndex = 12 ;
      , ToolTipText = "Changes default capitalization for commands and functions." ;
      , Top = 163 ;
      , Width = 144

  ADD OBJECT pf1.page1.label4 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "FoxCode \<default:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 40 ;
      , Name = "Label4" ;
      , TabIndex = 11 ;
      , Top = 166 ;
      , Width = 86

  ADD OBJECT pf1.page1.chkintellisense AS checkbox WITH ;
        BackStyle = 0 ;
      , Caption = "\<Enable IntelliSense" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 16 ;
      , Name = "chkIntellisense" ;
      , TabIndex = 1 ;
      , ToolTipText = "Globally enables/disables IntelliSense in Visual FoxPro." ;
      , Top = 10 ;
      , Value = .T. ;
      , Width = 164

  ADD OBJECT pf1.page1.shape2 AS shape WITH ;
        Height = 2 ;
      , Left = 148 ;
      , Name = "Shape2" ;
      , SpecialEffect = 0 ;
      , Top = 98 ;
      , Width = 265

  ADD OBJECT pf1.page1.cbolistmembers AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 134 ;
      , Name = "cboListMembers" ;
      , Style = 2 ;
      , TabIndex = 3 ;
      , ToolTipText = "Control display of dropdown items for objects and commands." ;
      , Top = 31 ;
      , Width = 144

  ADD OBJECT pf1.page1.cboquickinfo AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 134 ;
      , Name = "cboQuickInfo" ;
      , Style = 2 ;
      , TabIndex = 5 ;
      , ToolTipText = "Control display of quick tips for commands and functions." ;
      , Top = 55 ;
      , Width = 144

  ADD OBJECT pf1.page1.label5 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<List members:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 40 ;
      , Name = "Label5" ;
      , TabIndex = 2 ;
      , Top = 34 ;
      , Width = 68

  ADD OBJECT pf1.page1.label6 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Quick info tips:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 40 ;
      , Name = "Label6" ;
      , TabIndex = 4 ;
      , Top = 58 ;
      , Width = 73

  ADD OBJECT pf1.page1.lblfunc AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 280 ;
      , Name = "lblfunc" ;
      , TabIndex = 17 ;
      , Top = 118 ;
      , Width = 2

  ADD OBJECT pf1.page1.lblcmd AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 280 ;
      , Name = "lblcmd" ;
      , TabIndex = 16 ;
      , Top = 142 ;
      , Width = 2

  ADD OBJECT pf1.page1.shape1 AS shape WITH ;
        Height = 2 ;
      , Left = 132 ;
      , Name = "Shape1" ;
      , SpecialEffect = 0 ;
      , Top = 19 ;
      , Width = 281

  ADD OBJECT pf1.page2.cmdtypelib AS commandbutton WITH ;
        Caption = "\<Type Libraries..." ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 109 ;
      , Name = "cmdTypelib" ;
      , TabIndex = 3 ;
      , ToolTipText = "Add COM component reference to Types dropdown." ;
      , Top = 198 ;
      , Width = 100

  ADD OBJECT pf1.page2.oletypes AS olecontrol WITH ;
        Height = 176 ;
      , Left = 9 ;
      , Name = "oleTypes" ;
      , TabIndex = 1 ;
      , Top = 12 ;
      , Width = 408

  ADD OBJECT pf1.page2.cmdaddclass AS commandbutton WITH ;
        Caption = "\<Classes..." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 213 ;
      , Name = "cmdAddClass" ;
      , TabIndex = 4 ;
      , ToolTipText = "Add VFP class reference to Types dropdown." ;
      , Top = 198 ;
      , Width = 100

  ADD OBJECT pf1.page2.cmdedit AS commandbutton WITH ;
        Caption = "\<Edit" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 51 ;
      , Name = "cmdEdit" ;
      , TabIndex = 2 ;
      , ToolTipText = "Edit record of this item." ;
      , Top = 198 ;
      , Width = 54

  ADD OBJECT pf1.page2.command1 AS commandbutton WITH ;
        Caption = "\<Web Services..." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 317 ;
      , Name = "Command1" ;
      , TabIndex = 5 ;
      , ToolTipText = "Add web service reference to Types dropdown." ;
      , Top = 198 ;
      , Width = 100

  ADD OBJECT pf1.page3.olecustom AS olecontrol WITH ;
        Height = 134 ;
      , Left = 16 ;
      , Name = "oleCustom" ;
      , TabIndex = 11 ;
      , Top = 53 ;
      , Width = 396

  ADD OBJECT pf1.page3.label1 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Type:" ;
      , FontName = "MS Sans Serif" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 16 ;
      , Name = "Label1" ;
      , TabIndex = 5 ;
      , Top = 201 ;
      , Width = 29

  ADD OBJECT pf1.page3.cmdadd AS commandbutton WITH ;
        Caption = "\<Add" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 287 ;
      , Name = "cmdAdd" ;
      , TabIndex = 9 ;
      , ToolTipText = "Add/Replace item in FoxCode." ;
      , Top = 197 ;
      , Width = 60

  ADD OBJECT pf1.page3.cmddelete AS commandbutton WITH ;
        Caption = "\<Delete" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 353 ;
      , Name = "cmdDelete" ;
      , TabIndex = 10 ;
      , ToolTipText = "Delete item in FoxCode." ;
      , Top = 197 ;
      , Width = 60

  ADD OBJECT pf1.page3.txtabbrev AS textbox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 17 ;
      , MaxLength = 24 ;
      , Name = "txtAbbrev" ;
      , TabIndex = 2 ;
      , Top = 29 ;
      , Width = 96

  ADD OBJECT pf1.page3.txtexpanded AS textbox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 114 ;
      , MaxLength = 26 ;
      , Name = "txtExpanded" ;
      , SelectOnEntry = .T. ;
      , TabIndex = 4 ;
      , Top = 29 ;
      , Width = 298

  ADD OBJECT pf1.page3.lblreplace AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Re\<place:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 20 ;
      , Name = "lblReplace" ;
      , TabIndex = 1 ;
      , Top = 13 ;
      , Width = 44

  ADD OBJECT pf1.page3.lblwith AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Wit\<h:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 115 ;
      , Name = "lblWith" ;
      , TabIndex = 3 ;
      , Top = 13 ;
      , Width = 28

  ADD OBJECT pf1.page3.cmdscript AS commandbutton WITH ;
        Caption = "\<Script" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 155 ;
      , Name = "cmdScript" ;
      , TabIndex = 7 ;
      , ToolTipText = "Edit script for this item." ;
      , Top = 197 ;
      , Width = 60

  ADD OBJECT pf1.page3.cmdedit AS commandbutton WITH ;
        Caption = "\<Edit" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 221 ;
      , Name = "cmdEdit" ;
      , TabIndex = 8 ;
      , ToolTipText = "Edit record of this item." ;
      , Top = 197 ;
      , Width = 60

  ADD OBJECT pf1.page3.cbotype AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 21 ;
      , Left = 48 ;
      , Name = "cboType" ;
      , Style = 2 ;
      , TabIndex = 6 ;
      , ToolTipText = "Changes capitalization for expansion of functions." ;
      , Top = 197 ;
      , Width = 100

  ADD OBJECT pf1.page4.shape1 AS shape WITH ;
        Height = 2 ;
      , Left = 112 ;
      , Name = "Shape1" ;
      , SpecialEffect = 0 ;
      , Top = 19 ;
      , Width = 301

  ADD OBJECT pf1.page4.lblreplace AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Custom Properties" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 16 ;
      , Name = "lblReplace" ;
      , TabIndex = 1 ;
      , Top = 11 ;
      , Width = 90

  ADD OBJECT pf1.page4.label1 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "This option allows you to edit custom properties that affect core and user-defined IntelliSense behavior." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 28 ;
      , Left = 76 ;
      , Name = "Label1" ;
      , TabIndex = 2 ;
      , Top = 35 ;
      , Width = 253 ;
      , WordWrap = .T.

  ADD OBJECT pf1.page4.cmdimport AS commandbutton WITH ;
        Caption = "Edit \<Properties..." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 292 ;
      , Name = "cmdImport" ;
      , TabIndex = 3 ;
      , ToolTipText = "Brings up dialog to edit custom properties." ;
      , Top = 79 ;
      , Width = 106

  ADD OBJECT pf1.page4.label2 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Maintenance" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 16 ;
      , Name = "Label2" ;
      , TabIndex = 4 ;
      , Top = 119 ;
      , Width = 63

  ADD OBJECT pf1.page4.label3 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "This option allows you to restore your FoxCode table, cleanup Most Recently Used file lists, and perform other IntelliSense maintenance routines." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 41 ;
      , Left = 76 ;
      , Name = "Label3" ;
      , TabIndex = 5 ;
      , Top = 143 ;
      , Width = 260 ;
      , WordWrap = .T.

  ADD OBJECT pf1.page4.command1 AS commandbutton WITH ;
        Caption = "\<Clean Up..." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 292 ;
      , Name = "Command1" ;
      , TabIndex = 6 ;
      , ToolTipText = "Brings up dialog to perform various maintenance tasks on IntelliSense components." ;
      , Top = 187 ;
      , Width = 106

  ADD OBJECT pf1.page4.image1 AS image WITH ;
        Height = 32 ;
      , Left = 28 ;
      , Name = "Image1" ;
      , Picture = "fc_custom.bmp" ;
      , Top = 37 ;
      , Width = 32

  ADD OBJECT pf1.page4.image2 AS image WITH ;
        Height = 32 ;
      , Left = 28 ;
      , Name = "Image2" ;
      , Picture = "fc_maint.bmp" ;
      , Top = 145 ;
      , Width = 32

  ADD OBJECT pf1.page4.shape2 AS shape WITH ;
        Height = 2 ;
      , Left = 88 ;
      , Name = "Shape2" ;
      , SpecialEffect = 0 ;
      , Top = 127 ;
      , Width = 325

  ADD OBJECT command2 AS commandbutton WITH ;
        Caption = "OK" ;
      , Default = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 296 ;
      , Name = "Command2" ;
      , TabIndex = 2 ;
      , Top = 272 ;
      , Width = 72

  ADD OBJECT command1 AS commandbutton WITH ;
        Cancel = .T. ;
      , Caption = "Cancel" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 373 ;
      , Name = "Command1" ;
      , TabIndex = 3 ;
      , Top = 272 ;
      , Width = 72

  ADD OBJECT ofoxreg AS foxreg WITH ; && registry.vcx 
        Height = 17 ;
      , Left = 42 ;
      , Name = "oFoxReg" ;
      , Top = 271 ;
      , Width = 32

  
  PROCEDURE cancelhandler
    THISFORM.Release()
  ENDPROC
  
  PROCEDURE Deactivate
    IF EMPTY(THIS.cSaveMessage)
    	SET MESSAGE TO
    ELSE
    	SET MESSAGE TO (THIS.cSaveMessage)
    ENDIF
    ACTIVATE SCREEN
    
  ENDPROC
  
  PROCEDURE Destroy
    _oIntMgr=""
    RELEASE _oIntMgr
    IF THIS.nlangopt#0
    	_VFP.LanguageOptions=THIS.nlangopt
    ENDIF
    
    SYS(3054,INT(VAL(THIS.nSaveShowPlan)))
    
    IF EMPTY(THIS.cSaveMessage)
    	SET MESSAGE TO
    ELSE
    	SET MESSAGE TO (THIS.cSaveMessage)
    ENDIF
    
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    THIS.haderror = .T.
    IF nError = 3
      MESSAGEBOX(ERR_FCODEINUSE_LOC)
      RETURN
    ENDIF
  ENDPROC
  
  PROCEDURE getcasecap
    LPARAMETER eValue,eType
    	
    IF PCOUNT()=2
    	* Used only for default case
    
    	DO CASE
    	CASE UPPER(eValue) = "U"
      		RETURN CAPCASE_UPPER_LOC
    	CASE UPPER(eValue) = "L"
      		RETURN CAPCASE_LOWER_LOC
    	CASE UPPER(eValue) = "P"
      		RETURN CAPCASE_PROPER_LOC
    	CASE UPPER(eValue) = "X"
      		RETURN CAPCASE_NONE_LOC
    	CASE UPPER(eValue) = "M"
      		RETURN CAPCASE_MIXED_LOC
      	OTHERWISE
      		RETURN CAPCASE_DEFAULT2_LOC
      	ENDCASE
    ELSE
    	DO CASE
    	CASE eValue = CAPCASE_UPPER_LOC
      		RETURN "U"
    	CASE eValue = CAPCASE_LOWER_LOC
      		RETURN "L"
    	CASE eValue = CAPCASE_PROPER_LOC
      		RETURN "P"
    	CASE eValue = CAPCASE_MIXED_LOC
      		RETURN "M"
    	CASE eValue = CAPCASE_DEFAULT_LOC
      		RETURN ""
    	CASE eValue = CAPCASE_NONE_LOC
      		RETURN "X"
      	OTHERWISE
      		RETURN ""
      	ENDCASE
    ENDIF
    
  ENDPROC
  
  PROCEDURE getsettings
    * Get Core Intellisense Settings
    WITH THIS.pf1.Page1
    	IF ATC("L",_VFP.EditorOptions)#0 OR ATC("Q",_VFP.EditorOptions)#0
    		* Get List Members setting
    		DO CASE
    		CASE AT("L",_VFP.EditorOptions)#0
    			.cboListMembers.Listindex = 1
    		CASE AT("l",_VFP.EditorOptions)#0
    			.cboListMembers.Listindex = 2
    		OTHERWISE
    			.cboListMembers.Listindex = 3
    		ENDCASE
    		* Get Quick Info setting
    		DO CASE
    		CASE AT("Q",_VFP.EditorOptions)#0
    			.cboQuickInfo.Listindex = 1
    		CASE AT("q",_VFP.EditorOptions)#0
    			.cboQuickInfo.Listindex = 2
    		OTHERWISE
    			.cboQuickInfo.Listindex = 3
    		ENDCASE
    	ELSE
    		.chkIntellisense.Value = .F.
    		.cboListMembers.Enabled = .F.
    		.cboQuickInfo.Enabled = .F.
    	ENDIF
    ENDWITH
    
    * Get Function capitalization
    DIMENSION aCapCase[1]
    SELECT case, count(case) FROM foxcode;
    	WHERE UPPER(type) = "F" and UPPER(source) = "RESERVED";
    	GROUP BY case INTO ARRAY aCapCase
    
    IF _TALLY = 1
    	THIS.pf1.Page1.lblfunc.Caption = "("+THIS.getcasecap(aCapCase[1],1)+")"
    ELSE
    	THIS.pf1.Page1.lblfunc.Caption = "("+CAPCASE_VARIOUS_LOC+")"	
    ENDIF
    
    WITH THIS.pf1.Page1.cboFuncCap
    	.AddItem(CAPCASE_UPPER_LOC)
    	.AddItem(CAPCASE_LOWER_LOC)
    	.AddItem(CAPCASE_PROPER_LOC)
    	.AddItem(CAPCASE_MIXED_LOC)
    	.AddItem(CAPCASE_DEFAULT_LOC)
    	.AddItem(CAPCASE_NONE_LOC)
    	.AddItem(CAPCASE_OTHER_LOC)
    	IF ALEN(aCapCase,1)=1
    		THIS.cFuncCap=aCapCase[1]
    	ENDIF
    	.ListIndex=7
    ENDWITH
    
    * Get Command capitalization
    DIMENSION aCapCase[1]
    SELECT case, count(case) FROM foxcode;
    	WHERE UPPER(type) = "C" and UPPER(source) = "RESERVED";
    	GROUP BY case INTO ARRAY aCapCase
    
    IF _TALLY = 1
    	THIS.pf1.Page1.lblcmd.Caption = "("+THIS.getcasecap(aCapCase[1],1)+")"
    ELSE
    	THIS.pf1.Page1.lblcmd.Caption = "("+CAPCASE_VARIOUS_LOC+")"	
    ENDIF
    
    WITH THIS.pf1.Page1.cboCmdCap
    	.AddItem(CAPCASE_UPPER_LOC)
    	.AddItem(CAPCASE_LOWER_LOC)
    	.AddItem(CAPCASE_PROPER_LOC)
    	.AddItem(CAPCASE_MIXED_LOC)
    	.AddItem(CAPCASE_DEFAULT_LOC)
    	.AddItem(CAPCASE_NONE_LOC)
    	.AddItem(CAPCASE_OTHER_LOC)
    	IF ALEN(aCapCase,1)=1
    		THIS.cCmdCap=aCapCase[1]
    	ENDIF
    	.ListIndex=7
    ENDWITH
    
    * Get Default capitalization
    DIMENSION aCapCase[1]
    aCapCase[1] = ""
    SELECT case FROM foxcode WHERE UPPER(type) = "V" INTO ARRAY aCapCase
    IF _TALLY>0
    	THIS.cDefaultCase = UPPER(ALLTRIM(aCapCase))
    ENDIF
    WITH THIS.pf1.Page1.cboDefaultCase
    	.AddItem(CAPCASE_UPPER_LOC)
    	.AddItem(CAPCASE_LOWER_LOC)
    	.AddItem(CAPCASE_PROPER_LOC)
    	.AddItem(CAPCASE_MIXED_LOC)
    	.AddItem(CAPCASE_NONE_LOC)
    	.Value = THIS.GetCaseCap(THIS.cDefaultCase,0)
    ENDWITH
    
  ENDPROC
  
  PROCEDURE gettype
    LOCAL lcType
    lcType = ThisForm.pf1.Page3.cboType.ListIndex
    DO CASE
    CASE lcType=2
    	RETURN "F"
    CASE lcType=3
    	RETURN "P"
    CASE lcType=4
    	RETURN "S"
    OTHERWISE
    	RETURN "U"
    ENDCASE
    
  ENDPROC
  
  PROCEDURE Init
    
    LOCAL lcEditOptions,lcFCODE,lcOptionValue,lcOptionName,lnFoxCodeVer
    LOCAL lcFoxCode,lcBackupFile,lnFileCount,lcFileName
    
    THIS.nSaveShowPlan=SYS(3054)
    SYS(3054,0)
    
    * This gets a Fox Option
    lcOptionValue = ""
    lcOptionName = "_FOXCODE"
    * cOptionValue = ""
    * cOptionName = "_FOXCODE"
    
    THIS.oFoxReg.GetFoxOption( m.lcOptionName, @lcOptionValue )
    
    * Validate Foxcode files exist:
    * Check for _FOXCODE
    * Check for HOME()+"Foxcode"
    IF EMPTY(_FOXCODE) OR !FILE(_FOXCODE) OR !FILE(HOME()+"FOXCODE.DBF")
    	IF MESSAGEBOX(RESTOREFCODE_LOC,52)#6
    		RETURN .F.
    	ENDIF
    	lcEditOptions = _VFP.EditorOptions
    	IF ATC("Q",lcEditOptions)=0
    		lcEditOptions="Q"+lcEditOptions
    	ENDIF
    	IF ATC("L",lcEditOptions)=0
    		lcEditOptions="L"+lcEditOptions
    	ENDIF
    	_VFP.EditorOptions=""
    	
    	USE "FXCDE_BACK.DBF" SHARED ALIAS FXCDEBACK
    	
    	* Restore the HOME one if needed
    	IF !FILE(HOME()+"FOXCODE.DBF")
    		COPY TO (HOME()+"FOXCODE.DBF")
    	ENDIF
    	
    	* Check for missing registered _FOXCODE file
    	lcFCODE = _FOXCODE
    	IF EMPTY(_FOXCODE)
    		* This gets a Fox Option in Registry
    		lcOptionValue = ""
    		lcOptionName = "_FOXCODE"
    		THIS.oFoxReg.GetFoxOption(lcOptionName,@lcOptionValue)
    		IF !EMPTY(lcOptionValue)
    			lcFCODE = ALLTRIM(lcOptionValue)
    			IF LEFT(lcOptionValue,1) = ["]
    				lcFCODE = CHRTRAN(lcFCODE,["],"")				
    			ENDIF
    		ELSE
    			_FOXCODE = HOME()+"FOXCODE.DBF"
    		ENDIF
    	ENDIF
    	IF !EMPTY(lcFCODE) 
    		IF !FILE(lcFCODE)
    			COPY TO (lcFCODE)
    		ENDIF
    		IF FILE(lcFCODE)
    			_FOXCODE = lcFCODE
    		ELSE
    			_FOXCODE = HOME()+"FOXCODE.DBF"		
    		ENDIF
    	ENDIF
    	
    	USE IN FXCDEBACK
    	_VFP.EditorOptions=lcEditOptions
    ENDIF
    
    USE (_FOXCODE) AGAIN SHARED ALIAS FOXCODE
    IF EMPTY(ALIAS())
    	RETURN .F.
    ENDIF
    
    * Check for valid version of _FOXCODE
    IF !UPPER(HOME()+"FOXCODE.DBF")==UPPER(_FOXCODE)
    	SELECT 0
    	USE (HOME()+"FOXCODE.DBF") AGAIN SHARED ALIAS HOMEFXCDE
    	GO TOP
    	lnFoxCodeVer = VAL(expanded)
    	SELECT FOXCODE
    	GO TOP
    	IF lnFoxCodeVer # VAL(expanded)
    		lcFCODE = _FOXCODE
    		_VFP.EditorOptions=""
    		lnFileCount = 0
      		lcFileName = ADDBS(JUSTPATH(lcFCODE ))+JUSTSTEM(lcFCODE )
    		DO WHILE .T.
      		  	lnFileCount=lnFileCount+1
      		  	lcBackupFile = lcFileName + "_" + TRANSFORM(lnFileCount) + ".DBF"
      			IF !FILE(lcBackupFile)
    		    		EXIT
      			ENDIF
        		ENDDO
    		COPY TO (lcBackupFile)
    		USE
    		DELETE FILE (lcFCODE)
    		DELETE FILE (FORCEEXT(lcFCODE,"FPT"))
    		SELECT HOMEFXCDE
    		COPY TO (lcFCODE)		
    		_VFP.EditorOptions=lcEditOptions
    		MESSAGEBOX(OLDFOXCODE_VERSION_LOC)
    		RETURN .F.
    	ENDIF
    	USE IN HOMEFXCDE
    	SELECT FOXCODE
    ENDIF
    
    * Get Screen Settings for Intellisense Manager
    LOCATE FOR UPPER(type) = "V"
    IF FOUND()
    	LOCAL lnTop,lnLeft,laProps, lnPos
    	DIMENSION laProps[1]
    	IF  ALINES(laProps,ALLTRIM(user)) > 0
    		lnTop = 10
    		lnLeft = 10
    		lnPos = ASCAN(laProps,"top =",-1,-1,-1,5)
    		IF lnPos>0
    			lnTop = VAL(STREXTRACT(laProps[lnPos],"top =","",1,1))
    		ENDIF
    		lnPos = ASCAN(laProps,"left =",-1,-1,-1,5)
    		IF lnPos>0
    			lnLeft = VAL(STREXTRACT(laProps[lnPos],"left =","",1,1))
    		ENDIF
    		THIS.Top = lnTop
    		THIS.Left = lnLeft
    	ENDIF
    ENDIF
    
    THIS.refreshtypes()
    THIS.refreshcustom()
    
    WITH THIS.pf1.page3.oleCustom
    	IF .ListItems.Count > 0
    		.SelectedItem = .ListItems(1)
    	ENDIF
    ENDWITH
    
    THIS.nLangOpt=_VFP.LanguageOptions
    IF THIS.nlangopt#0
    	_VFP.LanguageOptions=0
    ENDIF
    PUBLIC _oIntMgr
    _oIntMgr=THIS
    
    THIS.GetSettings()
    THIS.pf1.page1.SetFocus()
    
  ENDPROC
  
  PROCEDURE Load
    SET TALK OFF
  ENDPROC
  
  PROCEDURE QueryUnload
    IF THIS.ReleaseType=1
    	THIS.setsettings()
    ENDIF
  ENDPROC
  
  PROCEDURE refreshcustom
    SELECT foxcode
    LOCAL oNewItem, oItems, lhasItems 
    
    oItems = THIS.pf1.Page3.oleCustom
    
    THIS.pf1.Page3.txtAbbrev.Value=""
    THIS.pf1.Page3.txtExpanded.Value=""
    oItems.ListItems.Clear()
    
    IF THIS.pf1.ActivePage=3
    	THIS.pf1.Page3.txtAbbrev.SetFocus()
    ENDIF
    
    * Add user-defined classes
    SCAN FOR UPPER(source) # "RESERVED"	AND ATC(Type,"UCFPSZ")#0 AND !EMPTY(abbrev) AND !DELETED()
    	oNewItem = oItems.Listitems.Add(,"Z_"+TRANSFORM(RECNO()),ALLTRIM(abbrev))
      	oNewItem.SubItems(1) = ALLTRIM(expanded)
      	oNewItem.SubItems(2) = IIF(!EMPTY(data),"* "," ")
      	oNewItem.Checked = !DELETED()
    ENDSCAN
    
    IF oItems.ListItems.Count > 0
    	oItems.SelectedItem = oItems.ListItems(1)
    ENDIF
    
  ENDPROC
  
  PROCEDURE refreshtypes
    
    SELECT foxcode
    LOCAL oNewItem
    LOCAL oItems
     
    oItems = THIS.pf1.Page2.oleTypes
    oItems.ListItems.Clear()
    
    * Add type libraries first
    SCAN FOR UPPER(Type) = "O"
    	oNewItem = oItems.Listitems.Add(,"O_"+TRANSFORM(RECNO()),ALLTRIM(tip))
      	oNewItem.SubItems(1) = TYPES_TYPELIB_LOC
      	oNewItem.SubItems(2) = IIF(!EMPTY(cmd),"* "," ")
      	oNewItem.Checked = !DELETED()
    ENDSCAN
    
    * Add user-defined classes
    SCAN FOR UPPER(Type) = "T" AND UPPER(source) # "RESERVED"
    	oNewItem = oItems.Listitems.Add(,"C_"+TRANSFORM(RECNO()),ALLTRIM(data))
      	oNewItem.SubItems(1) = TYPES_CLASSES_LOC
      	oNewItem.SubItems(2) = IIF(!EMPTY(cmd),"* "," ")
      	oNewItem.Checked = !DELETED()
    ENDSCAN
    
    * Add reserved baseclasses and data types
    SCAN FOR UPPER(Type) = "T" AND UPPER(source) = "RESERVED"
    	oNewItem = oItems.Listitems.Add(,"T_"+TRANSFORM(RECNO()),ALLTRIM(data))
      	oNewItem.SubItems(1) = TYPES_TYPES_LOC
      	oNewItem.SubItems(2) = IIF(!EMPTY(cmd),"* "," ")
      	oNewItem.Checked = !DELETED()
    ENDSCAN
    
    IF oItems.ListItems.Count > 0
    	oItems.SelectedItem = oItems.ListItems(1)
    ENDIF
    
  ENDPROC
  
  PROCEDURE setsettings
    LOCAL lcGetCap,lReserveStr,lcSaveOpts,i,lcPEMStr,lcNewOpts
    
    SELECT foxcode
    lReserveStr = IIF(THIS.pf1.Page1.chkReserved.Value,'AND UPPER(Source) = "RESERVED"','')
    
    * Set Function capitalization
    IF THIS.pf1.Page1.cboFuncCap.ListIndex#7
    	lcGetCap= THIS.GetCaseCap(THIS.pf1.Page1.cboFuncCap.Value)
    	IF !THIS.cFuncCap==lcGetCap
    	  REPLACE case WITH lcGetCap FOR Type = "F" &lReserveStr.
    	ENDIF
    ENDIF
    
    * Set Command capitalization
    IF THIS.pf1.Page1.cboCmdCap.ListIndex#7
    	lcGetCap= THIS.GetCaseCap(THIS.pf1.Page1.cboCmdCap.Value)
    	IF !THIS.cCmdCap==lcGetCap
    	  REPLACE case WITH lcGetCap FOR AT(Type,"CU")#0 &lReserveStr.
    	ENDIF
    ENDIF
    
    * Set Default capitalization
    lcGetCap = THIS.GetCaseCap(THIS.pf1.Page1.cboDefaultCase.Value)
    IF ATC(THIS.cDefaultcase+lcGetCap," M ")=0 OR !THIS.cCmdCap==lcGetCap
      REPLACE case WITH lcGetCap FOR Type = "V"
    ENDIF
    
    * Reset Intellisense
    lcSaveOpts = _VFP.EditorOptions
    lcNewOpts = CHRTRAN(lcSaveOpts,"LlQq","")
    _VFP.EditorOptions = ""
    IF THIS.pf1.Page1.chkIntellisense.Value
    	DO CASE 
    	CASE THIS.pf1.Page1.cboListMembers.ListIndex=1
    		lcNewOpts = lcNewOpts + "L"
    	CASE THIS.pf1.Page1.cboListMembers.ListIndex=2
    		lcNewOpts = lcNewOpts + "l"
    	ENDCASE
    	DO CASE 
    	CASE THIS.pf1.Page1.cboQuickInfo.ListIndex=1
    		lcNewOpts = lcNewOpts + "Q"
    	CASE THIS.pf1.Page1.cboQuickInfo.ListIndex=2
    		lcNewOpts = lcNewOpts + "q"
    	ENDCASE
    ENDIF
    _VFP.EditorOptions = lcNewOpts
    
    * Save positions of Intellisense Manager
    LOCATE FOR UPPER(type) = "V"
    IF FOUND()
    	LOCAL laProps,lnPos,lnLines,lcPropStr,i
    	DIMENSION laProps[1]
    	laProps=""
    	lnLines=ALINES(laProps,ALLTRIM(user))
    	lnPos = ASCAN(laProps,"top =",-1,-1,-1,5)
    	IF lnPos#0
    		laProps[lnPos]="top = "+TRANSFORM(THISFORM.top)
    	ELSE
    		DIMENSION laProps[ALEN(laProps)+1]
    		laProps[ALEN(laProps)]="top = "+TRANSFORM(THISFORM.top)
    	ENDIF
    	lnPos = ASCAN(laProps,"left =",-1,-1,-1,5)
    	IF lnPos#0
    		laProps[lnPos]="left = "+TRANSFORM(THISFORM.left)
    	ELSE
    		DIMENSION laProps[ALEN(laProps)+1]
    		laProps[ALEN(laProps)]="left = "+TRANSFORM(THISFORM.left)
    	ENDIF
    	lcPropStr=""
    	FOR i = 1 TO ALEN(laProps)
    		lcPropStr = lcPropStr + laProps[m.i] +CHR(13)
    	ENDFOR
    	REPLACE User WITH lcPropStr
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page1.command2.Click
    IF TYPE("_oFoxCodeTips.baseclass")#"C"
    	PUBLIC _oFoxCodeTips
        DO CASE 
         CASE FILE( "foxcode.vcx" ) 
           _oFoxCodeTips=NEWOBJECT("frmtips","foxcode.vcx", "" )
         CASE FILE( _CODESENSE ) AND ATC(".APP", _CODESENSE ) > 0 
           _oFoxCodeTips=NEWOBJECT("frmtips","foxcode.vcx", _CODESENSE )
         OTHERWISE
           RETURN .F. 
        ENDCASE
    	_oFoxCodeTips.Show
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page1.cmdbrowse.Click
    SELECT foxcode
    GO TOP
    BROWSE LAST NORMAL NOWAIT
  ENDPROC
  
  PROCEDURE pf1.page1.cmdbrowse.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE pf1.page1.chkintellisense.Click
    THIS.Parent.cboListMembers.Enabled = THIS.Value 
    THIS.Parent.cboQuickInfo.Enabled = THIS.Value
    
  ENDPROC
  
  PROCEDURE pf1.page1.cbolistmembers.Init
    THIS.AddItem(INTELLI_AUTO_LOC)
    THIS.AddItem(INTELLI_MANUAL_LOC)
    THIS.AddItem(INTELLI_DISABLE_LOC)
    THIS.Listindex=1
  ENDPROC
  
  PROCEDURE pf1.page1.cboquickinfo.Init
    THIS.AddItem(INTELLI_AUTO_LOC)
    THIS.AddItem(INTELLI_MANUAL_LOC)
    THIS.AddItem(INTELLI_DISABLE_LOC)
    THIS.Listindex=1
  ENDPROC
  
  PROCEDURE pf1.page2.cmdtypelib.Click
    
    *!*    DO FORM typelibs
    *!*    THIS.Parent.oleTypes.ListItems.Clear()
    *!*    THISFORM.refreshtypes()
    
  ENDPROC
  
  PROCEDURE pf1.page2.oletypes.ColumnClick
    *** ActiveX Control Event ***
    LPARAMETERS columnheader
    LOCAL lnOldkey,lnNewkey,lSorted
    
    lSorted = THIS.Sorted
    lnOldkey = THIS.SortKey
    lnNewkey = ColumnHeader.Index - 1
    
    THIS.SortKey = lnNewkey
    
    DO CASE
    CASE !lSorted 	&&first time not sorted
    	THIS.SortOrder=0
    CASE lnOldkey=lnNewkey AND THIS.SortOrder#0
    	THIS.SortOrder=0
    CASE lnOldkey=lnNewkey
    	THIS.SortOrder=1
    OTHERWISE
    	THIS.SortOrder=0
    ENDCASE
    
    THIS.Sorted = .T.
    
  ENDPROC
  
  PROCEDURE pf1.page2.oletypes.DblClick
    *** ActiveX Control Event ***
    THIS.Parent.cmdEdit.Click()
  ENDPROC
  
  PROCEDURE pf1.page2.oletypes.ItemCheck
    *** ActiveX Control Event ***
    LPARAMETERS item
    LOCAL lnRec
    IF VARTYPE(item)#"O"
    	RETURN
    ENDIF
    lnRec = VAL(SUBSTR(item.key,3))
    SELECT foxcode
    Go lnRec
    IF item.checked
      RECALL
    ELSE
      DELETE
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page2.oletypes.KeyPress
    *** ActiveX Control Event ***
    LPARAMETERS keyascii
    IF keyascii=27
    	THISFORM.cancelhandler()
    ENDIF
  ENDPROC
  
  PROCEDURE pf1.page2.cmdaddclass.Click
    LOCAL lcFile,lcClass,lcStr,aMyClass,oNewItem,lcIndex
    DIMENSION aMyClass[1]
    IF aGetClass(aMyClass)
      	lcFile = aMyClass[1]
    	lcClass = aMyClass[2]
      	IF !FILE(lcFile) OR EMPTY(lcClass)
      		MESSAGEBOX(BADCLASSFILE_LOC,48)
      		RETURN
      	ENDIF
      	lcStr = LOWER(lcClass) + ' OF HOME()+"' + LOWER(SYS(2014,lcFile,HOME())) +'"'
      	
      	* check if file exists already
      	LOCATE FOR type="T" AND DATA=lcStr
      	IF FOUND()
      		WAIT WINDOW CLASS_EXISTS_LOC NOWAIT TIMEOUT 1
    		lcIndex = "C_"+TRANSFORM(RECNO())  	
      	ELSE
    		INSERT INTO foxcode (type, data, timestamp, save);
    			  VALUES ("T", lcStr, DATETIME(), .T.)
    		lcIndex = "C_"+TRANSFORM(RECNO())
    		oNewItem = THIS.Parent.oleTypes.Listitems.Add(,lcIndex,ALLTRIM(data))
    	  	oNewItem.SubItems(1) = TYPES_CLASSES_LOC
    	  	oNewItem.Checked = .T.
    	ENDIF
    	THIS.Parent.oleTypes.SelectedItem = THIS.Parent.oleTypes.ListItems(lcIndex)
    	THIS.Parent.oleTypes.ListItems(lcIndex).EnsureVisible()
    	THIS.Parent.oleTypes.SetFocus()
    ENDIF
    THISFORM.refreshtypes()
    
  ENDPROC
  
  PROCEDURE pf1.page2.cmdaddclass.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE pf1.page2.cmdedit.Click
    LOCAL lnRec,lcScript,lcData
    lnRec = VAL(SUBSTR(THIS.Parent.oleTypes.SelectedItem.key,3))
    SELECT foxcode
    Go lnRec
    lnRec = RECNO()
    lcData = ALLTRIM(Data)
    lcScript = ALLTRIM(STREXTRACT(ALLTRIM(cmd),"{","}"))
    IF EMPTY(lcScript)
    	BROWSE NORMAL LAST NODELETE NOAPPEND FOR RECNO()=lnRec
    ELSE
    	BROWSE NORMAL LAST NODELETE NOAPPEND FOR RECNO()=lnRec OR;
    		(ATC("S",TYPE)#0 AND UPPER(lcScript)==UPPER(ALLTRIM(abbrev)))
    ENDIF
    Go lnRec
    * Check if name changed
    IF !ALLTRIM(data) == lcData
    	THISFORM.refreshtypes()
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page2.command1.Click
    DO (_WIZARD) WITH "PROJECT",,"WEB","INTELLISENSE"
    THISFORM.refreshtypes()
    
  ENDPROC
  
  PROCEDURE pf1.page2.command1.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE pf1.page3.olecustom.DblClick
    *** ActiveX Control Event ***
    THIS.Parent.cmdEdit.Click()
  ENDPROC
  
  PROCEDURE pf1.page3.olecustom.GotFocus
    THIS.ItemClick(THIS.Parent.oleCustom.SelectedItem)
  ENDPROC
  
  PROCEDURE pf1.page3.olecustom.ItemClick
    *** ActiveX Control Event ***
    LPARAMETERS item
    
    LOCAL lnRec
    
    IF VARTYPE(item)#"O"
    	RETURN
    ENDIF
    lnRec = VAL(SUBSTR(item.key,3))
    SELECT foxcode
    Go lnRec
    
    THIS.Parent.txtAbbrev.Value = ALLTRIM(item.text)
    THIS.Parent.txtExpanded.Value = ALLTRIM(expanded)
    
    DO CASE
    CASE UPPER(type) = "F"
    	THIS.Parent.cboType.ListIndex=2
    CASE UPPER(type) = "P"
    	THIS.Parent.cboType.ListIndex=3
    CASE UPPER(type) = "S"
    	THIS.Parent.cboType.ListIndex=4
    CASE UPPER(type) = "Z"
    	THIS.Parent.cboType.ListIndex=5
    OTHERWISE
    	THIS.Parent.cboType.ListIndex=1	
    ENDCASE
    
    THIS.Parent.cmdAdd.Caption = BTNADD2_LOC
    THIS.Parent.cmdAdd.Enabled = .F.
    THIS.Parent.cmdAdd.Default = .F.
    THIS.Parent.cmdDelete.Enabled = .T.
    THIS.Parent.cmdScript.Enabled = .T.
    THIS.Parent.cmdEdit.Enabled = .T.
    
  ENDPROC
  
  PROCEDURE pf1.page3.olecustom.KeyPress
    *** ActiveX Control Event ***
    LPARAMETERS keyascii
    IF keyascii=27
    	THISFORM.cancelhandler()
    ENDIF
  ENDPROC
  
  PROCEDURE pf1.page3.cmdadd.Click
    * Add record to FoxCode
    LOCAL lcIndex,oNewItem,lAddMode,lcType,lcCase
    lAddMode = (THIS.Caption=BTNADD1_LOC)
    lcType = THISFORM.gettype()
    lcCase = "M"	&&use Mixed case by default (if empty then it adopts default record)
    
    IF lAddMode
    	* Add new record to FoxCode
    	INSERT INTO foxcode (type, abbrev, expanded, timestamp, save, case) ;
    	  VALUES (lcType, ALLTRIM(THIS.Parent.txtAbbrev.Value), ;
    	  ALLTRIM(THIS.Parent.txtExpanded.Value), ;
    	  DATETIME(), .T.,lcCase)
    
    	* Add record to Listview
    	lcIndex = "Z_"+TRANSFORM(RECNO())
    	oNewItem = THIS.Parent.oleCustom.Listitems.Add(, lcIndex,ALLTRIM(abbrev))
    	oNewItem.SubItems(1) = ALLTRIM(expanded)
    	oNewItem.SubItems(2) = IIF(!EMPTY(data),"* "," ")
    	oNewItem.Checked = .T.
    	THIS.Parent.oleCustom.SelectedItem = oNewItem 
    	oNewItem.EnsureVisible()
    	THIS.Parent.oleCustom.SetFocus()
    ELSE
    	lcIndex = "Z_"+TRANSFORM(RECNO())
    	REPLACE expanded WITH ALLTRIM(THIS.Parent.txtExpanded.Value), ;
    			timestamp WITH DATETIME(), ;
    			type WITH lcType
    	oNewItem = THIS.Parent.oleCustom.Listitems(lcIndex)
    	oNewItem.SubItems(1) = ALLTRIM(expanded)
    	oNewItem.SubItems(2) = IIF(!EMPTY(data),"* "," ")
    	THIS.Parent.oleCustom.SelectedItem = oNewItem 
    	oNewItem.EnsureVisible()
    	THIS.Parent.oleCustom.SetFocus()
    ENDIF
    
    THIS.Caption = BTNADD2_LOC
    THIS.Enabled = .F.
    THIS.Default = .F.
    THIS.Parent.cmdScript.Enabled = .T.
    THIS.Parent.cmdEdit.Enabled = .T.
    THIS.Parent.cmdDelete.Enabled = .T.
    
  ENDPROC
  
  PROCEDURE pf1.page3.cmddelete.Click
    IF MESSAGEBOX(DELETEREC_LOC,36) = 6
    	LOCAL lnRec
    	lnRec = VAL(SUBSTR(THIS.Parent.oleCustom.SelectedItem.key,3))
    	SELECT foxcode
    	Go lnRec
    	DELETE
    	THISFORM.refreshcustom()
    	THIS.Enabled= .F.
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page3.txtabbrev.InteractiveChange
    LOCAL lNewItem,lcValue,lcType
    lcValue = UPPER(ALLTRIM(THIS.Value))
    lcType = THISFORM.gettype()
    
    LOCATE FOR UPPER(type)=lcType AND;
       lcValue==UPPER(ALLTRIM(abbrev)) AND !DELETED()
    lNewItem = !FOUND()
    
    DO CASE
    CASE LEN(lcValue)<2
    	THIS.Parent.cmdAdd.Caption = BTNADD1_LOC
    	THIS.Parent.cmdAdd.Enabled = .F.
    	THIS.Parent.cmdAdd.Default  = .F.
    	THIS.Parent.cmdDelete.Enabled = .F.
    	THIS.Parent.cmdScript.Enabled = .F.
    	THIS.Parent.cmdEdit.Enabled = .F.
    CASE !lNewItem
    	THIS.Parent.cmdAdd.Caption = BTNADD2_LOC
    	THIS.Parent.cmdAdd.Enabled = .T.
    	THIS.Parent.cmdAdd.Default  = .T.
    	THIS.Parent.cmdDelete.Enabled = .T.
    	THIS.Parent.cmdScript.Enabled = .T.
    	THIS.Parent.cmdEdit.Enabled = .T.
    OTHERWISE
    	THIS.Parent.cmdAdd.Caption = BTNADD1_LOC
    	THIS.Parent.cmdAdd.Enabled = .T.
    	THIS.Parent.cmdAdd.Default  = .T.
    	THIS.Parent.cmdDelete.Enabled = .F.
    	THIS.Parent.cmdScript.Enabled = .F.
    	THIS.Parent.cmdEdit.Enabled = .F.
    ENDCASE
    
  ENDPROC
  
  PROCEDURE pf1.page3.txtexpanded.InteractiveChange
    THIS.Parent.cmdAdd.Enabled = .T.
    THIS.Parent.cmdAdd.Default = .T.
    
  ENDPROC
  
  PROCEDURE pf1.page3.cmdscript.Click
    LOCAL lcScript,lcType,lcScript2,lnRec
    lcScript = ALLTRIM(data)
    lcType = THISFORM.gettype()
    IF THIS.Parent.cmdAdd.Caption=BTNADD2_LOC
    	*Replace only
    	lnRec = VAL(SUBSTR(THIS.Parent.oleCustom.SelectedItem.key,3))
    	SELECT foxcode
    	Go lnRec
    	IF EMPTY(lcScript)
    		REPLACE data WITH "LPARAMETER oFoxCode"+CRLF
    	ENDIF
    	MODIFY MEMO DATA
    	lcScript2 = ALLTRIM(data)
    	IF EMPTY(ALLTRIM(cmd))
    		DO CASE
    		CASE GETWORDCOUNT(lcScript2)>2 AND ;
    		  (EMPTY(lcScript) OR lcScript=="LPARAMETER oFoxCode"+CRLF)
    			REPLACE cmd WITH "{}"
    		CASE EMPTY(lcScript) AND lcScript2=="LPARAMETER oFoxCode"+CRLF
    			REPLACE data WITH ""
    		ENDCASE
    	ENDIF
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page3.cmdedit.Click
    LOCAL lnRec,lcScript,lcFor
    IF THIS.Parent.oleCustom.ListItems.Count = 0
    	RETURN
    ENDIF
    lnRec = VAL(SUBSTR(THIS.Parent.oleCustom.SelectedItem.key,3))
    SELECT foxcode
    Go lnRec
    lnRec = RECNO()
    
    lcFor = 'RECNO() = '+TRANSFORM(lnrec)
    
    lcScript = ALLTRIM(STREXTRACT(ALLTRIM(cmd),"{","}"))
    IF EMPTY(lcScript)
    	BROWSE NORMAL LAST NODELETE NOAPPEND FOR &lcFor
    ELSE
    	BROWSE NORMAL LAST NODELETE NOAPPEND FOR &lcFor OR;
    		(ATC("S",TYPE)#0 AND UPPER(lcScript)==UPPER(ALLTRIM(abbrev)))
    ENDIF
    THISFORM.refreshcustom() 
  ENDPROC
  
  PROCEDURE pf1.page3.cbotype.Init
    THIS.AddItem(TYPE_COMMAND_LOC)
    THIS.AddItem(TYPE_FUNCTION_LOC)
    THIS.AddItem(TYPE_PROPERTY_LOC)
    THIS.AddItem(TYPE_SCRIPT_LOC)
    THIS.ListIndex=1
  ENDPROC
  
  PROCEDURE pf1.page3.cbotype.InteractiveChange
    THIS.ProgrammaticChange()
    THIS.Parent.cmdAdd.Enabled = .T.
    THIS.Parent.cmdAdd.Default = .T.
    
  ENDPROC
  
  PROCEDURE pf1.page3.cbotype.ProgrammaticChange
    THIS.Parent.txtExpanded.Enabled = (THIS.ListIndex<3)
    IF THIS.ListIndex>2
    	THIS.Parent.txtExpanded.Value=""
    	THIS.Parent.lblReplace.Caption = LBLREPLACE2_LOC
    	THIS.Parent.lblWith.Caption = ""
    ELSE
    	THIS.Parent.lblReplace.Caption = LBLREPLACE1_LOC
    	THIS.Parent.lblWith.Caption = LBLWITH_LOC
    ENDIF
    
  ENDPROC
  
  PROCEDURE pf1.page4.cmdimport.Click
    LOCAL oForm
    
    DO CASE 
     CASE FILE( "foxcode.vcx" ) 
       oForm=NEWOBJECT( "frmcustomprops", "foxcode.vcx" , "", THISFORM )
     CASE FILE( _CODESENSE ) AND ATC(".APP", _CODESENSE ) > 0 
       oForm=NEWOBJECT( "frmcustomprops", "foxcode.vcx" , _CODESENSE, THISFORM )
     OTHERWISE 
       RETURN .F. 
    ENDCASE
    oForm.Show()
    
  ENDPROC
  
  PROCEDURE pf1.page4.command1.Click
    
    LOCAL oForm
    DO CASE 
     CASE FILE( "foxcode.vcx" ) 
       oForm=NEWOBJECT("frmmaintenance","foxcode.vcx", "",THISFORM )
     CASE FILE( _CODESENSE ) AND ATC(".APP", _CODESENSE ) > 0 
       oForm=NEWOBJECT("frmmaintenance","foxcode.vcx", _CODESENSE , THISFORM )
     OTHERWISE
       RETURN .F. 
    ENDCASE
    oForm.Show()
    THISFORM.refreshtypes()
    THISFORM.refreshcustom()
  ENDPROC
  
  PROCEDURE command2.Click
    THISFORM.setsettings()
    THISFORM.Release
    
  ENDPROC
  
  PROCEDURE command1.Click
    THISFORM.cancelhandler()
  ENDPROC


ENDDEFINE
*
*-- EndDefine: frm_foxcode
**************************************************



**************************************************
*-- Class:        frmcustomprops (d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\foxcode.h"
*
DEFINE CLASS frmcustomprops AS form

  AutoCenter = .T.
  BorderStyle = 2
  Caption = "Custom Properties"
  DoCreate = .T.
  Height = 227
  HelpContextID = 1230986
  MaxButton = .F.
  MinButton = .F.
  Name = "frmcustomprops"
  Width = 396
  WindowType = 1
  custompemsid = "CustomPEMs"
  haderror = .F.
  lupdatecustompems = .F.

  ADD OBJECT lblreplace AS label WITH ;
        AutoSize = .T. ;
      , Caption = "\<Property" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 12 ;
      , Name = "lblReplace" ;
      , TabIndex = 1 ;
      , Top = 8 ;
      , Width = 44

  ADD OBJECT lstcustompems AS listbox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 130 ;
      , IntegralHeight = .T. ;
      , ItemTips = .T. ;
      , Left = 12 ;
      , Name = "lstCustomPEMs" ;
      , TabIndex = 2 ;
      , Top = 24 ;
      , Width = 144

  ADD OBJECT txtvalue AS textbox WITH ;
        BackStyle = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Format = "K" ;
      , Height = 24 ;
      , InputMask = (REPLICATE("X",255)) ;
      , Left = 48 ;
      , Name = "txtValue" ;
      , TabIndex = 6 ;
      , Top = 162 ;
      , Width = 336

  ADD OBJECT label1 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 1 ;
      , Caption = "\<Value" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 12 ;
      , Name = "Label1" ;
      , TabIndex = 5 ;
      , Top = 165 ;
      , Width = 28

  ADD OBJECT txtdesc AS textbox WITH ;
        Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 124 ;
      , Left = 168 ;
      , Name = "txtDesc" ;
      , ReadOnly = .T. ;
      , TabIndex = 4 ;
      , Top = 24 ;
      , Width = 216

  ADD OBJECT label2 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "\<Description" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 168 ;
      , Name = "Label2" ;
      , TabIndex = 3 ;
      , Top = 8 ;
      , Width = 55

  ADD OBJECT cmdclose AS commandbutton WITH ;
        Cancel = .T. ;
      , Caption = "Close" ;
      , Default = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 312 ;
      , Name = "cmdClose" ;
      , TabIndex = 7 ;
      , Top = 196 ;
      , Width = 72

  
  PROCEDURE Destroy
    THIS.setsettings()
  ENDPROC
  
  PROCEDURE displaycustompem
    LPARAMETERS nIndex
    LOCAL lnPos
    IF nIndex = 0
    	RETURN
    ENDIF
    THIS.txtValue.Value = THIS.aCustomPEMsDesc[nIndex,2]
    THIS.txtDesc.Value = THIS.aCustomPEMsDesc[nIndex,3]
    
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    THIS.haderror = .T.
    IF nError = 3
      MESSAGEBOX(ERR_FCODEINUSE_LOC)
      RETURN
    ENDIF
  ENDPROC
  
  PROCEDURE getcustompems
    LOCAL aTmpItems, lcProperty, lcPropValue, aTmpData, aTmpData2
    LOCAL lnLInes,i,lcDesc,j
    DIMENSION aTmpItems[1]
    SELECT data,tip FROM (_FoxCode) ;
      WHERE UPPER(ALLTRIM(abbrev)) == UPPER(THIS.CustomPEMsID) ;
      INTO ARRAY aTmpItems
    IF _TALLY = 0
    	RETURN
    ENDIF
    DIMENSION THIS.aCustomPEMsDesc[1,3]
    STORE "" TO THIS.aCustomPEMsDesc
    DIMENSION aTmpData[1], aTmpData2[1]
    lnLines = ALINES(aTmpData,ALLTRIM(aTmpItems[1]))
    lnLines2 = ALINES(aTmpData2,ALLTRIM(aTmpItems[2]))
    FOR i = 1 TO lnLInes
    	lcProperty =  ALLTRIM(GETWORDNUM(aTmpData[m.i],1,"="))
    	lcPropValue = ALLTRIM(SUBSTR(aTmpData[m.i],ATC("=",aTmpData[m.i])+1))
    	lcType = TYPE('EVALUATE(lcPropValue)')
    	DO CASE
    	CASE INLIST(lcType,"N","D","L","C")
    		lcPropValue = EVALUATE(lcPropValue)
    	CASE lcType="U" AND TYPE('lcPropValue')="C"
    		* Property is Char, but doesn't need evaluating
    	OTHERWISE
    		LOOP
    	ENDCASE
    	lcDesc = ""
    	FOR j = 1 TO lnLInes2
    		IF UPPER(ALLTRIM(GETWORDNUM(aTmpData2[m.j],1))) == UPPER(lcProperty)
    			lcDesc = ALLTRIM(SUBSTR(aTmpData2[m.j],ATC(" ",aTmpData2[m.j])+1))
    			EXIT
    		ENDIF
    	ENDFOR
    	IF !EMPTY(THIS.aCustomPEMsDesc)
    		DIMENSION THIS.aCustomPEMsDesc[ALEN(THIS.aCustomPEMsDesc,1)+1,3]
    	ENDIF
    	THIS.aCustomPEMsDesc[ALEN(THIS.aCustomPEMsDesc,1),1] = lcProperty
    	THIS.aCustomPEMsDesc[ALEN(THIS.aCustomPEMsDesc,1),2] = lcPropValue
    	THIS.aCustomPEMsDesc[ALEN(THIS.aCustomPEMsDesc,1),3] = lcDesc
    	THIS.lstCustomPEMs.AddItem(lcProperty)
    ENDFOR
    THIS.lstCustomPEMs.ListIndex = 1
    
  ENDPROC
  
  PROCEDURE Init
    LPARAMETERS oForm 
    THIS.Left = oForm.Left + 24
    THIS.Top = oForm.Top + 24
    THIS.GetCustomPEMs()
    IF THIS.lstCustomPEMs.ListCount > 0
    	THIS.lstCustomPEMs.ListIndex = 1
    	THIS.DisplayCustomPEM(1)
    ENDIF
    
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF nKeyCode=27
    	THISFORM.Release()
    ENDIF
  ENDPROC
  
  PROCEDURE setsettings
    * Write out Custom PEMs
    IF THIS.lUpdateCustomPEMs
    	lcPEMStr=""
    	FOR i = 1 TO ALEN(THIS.aCustomPEMsDesc,1)
    		IF EMPTY(THIS.aCustomPEMsDesc[m.i,1]) OR VARTYPE(THIS.aCustomPEMsDesc[m.i,1])#"C"
    			LOOP
    		ENDIF
    		lcPEMStr = lcPEMStr + THIS.aCustomPEMsDesc[m.i,1] + " = " + ALLTRIM(TRANSFORM(THIS.aCustomPEMsDesc[m.i,2])) + CRLF
    	ENDFOR
    	IF !EMPTY(lcPEMStr)
    		REPLACE data WITH lcPEMStr FOR UPPER(ALLTRIM(abbrev)) == UPPER(THIS.CustomPEMsID)
    	ENDIF
    ENDIF
    
  ENDPROC
  
  PROCEDURE lstcustompems.InteractiveChange
    THISFORM.DisplayCustomPEM(THIS.ListIndex)
    
  ENDPROC
  
  PROCEDURE txtvalue.InteractiveChange
    THISFORM.lupdatecustompems=.T.
    THISFORM.acustompemsdesc[THIS.Parent.lstCustomPEMs.ListIndex,2] = THIS.Value
  ENDPROC
  
  PROCEDURE txtdesc.Init
    THIS.DisabledForeColor  = THIS.ForeColor
  ENDPROC
  
  PROCEDURE cmdclose.Click
    THISFORM.setsettings()
    THISFORM.Release()
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: frmcustomprops
**************************************************



**************************************************
*-- Class:        frmmaintenance (d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\foxcode.h"
*
DEFINE CLASS frmmaintenance AS form

  BorderStyle = 2
  Caption = "Maintenance"
  DoCreate = .T.
  Height = 271
  HelpContextID = 1230986
  Left = 20
  MaxButton = .F.
  MinButton = .F.
  Name = "frmmaintenance"
  Top = 21
  Width = 480
  WindowType = 1
  haderror = .F.

  ADD OBJECT cmdcleanmru AS commandbutton WITH ;
        Caption = "Clean Up \<Lists" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 348 ;
      , Name = "cmdCleanMRU" ;
      , TabIndex = 8 ;
      , ToolTipText = "This option removes non-existent file entries from Most Recently Used Files lists." ;
      , Top = 156 ;
      , Width = 120

  ADD OBJECT cmdcleanfoxcode AS commandbutton WITH ;
        Caption = "\<Clean Up FoxCode" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 348 ;
      , Name = "cmdCleanFoxCode" ;
      , TabIndex = 5 ;
      , ToolTipText = "This option cleans up your Foxcode table." ;
      , Top = 84 ;
      , Width = 120

  ADD OBJECT cmdzapmru AS commandbutton WITH ;
        Caption = "\<Zap Lists" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 348 ;
      , Name = "cmdZapMRU" ;
      , TabIndex = 10 ;
      , ToolTipText = "This option deletes all Most Recently Used Files lists." ;
      , Top = 192 ;
      , Width = 120

  ADD OBJECT cmdrestore AS commandbutton WITH ;
        Caption = "\<Restore FoxCode" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 348 ;
      , Name = "cmdRestore" ;
      , TabIndex = 3 ;
      , ToolTipText = "This option restores your Foxcode table to the original default one. " ;
      , Top = 36 ;
      , Width = 120

  ADD OBJECT lblreplace AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Most Recently Used File Lists" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 12 ;
      , Name = "lblReplace" ;
      , TabIndex = 6 ;
      , Top = 132 ;
      , Width = 140

  ADD OBJECT label1 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "This option removes obsolete file entries." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 72 ;
      , Name = "Label1" ;
      , TabIndex = 7 ;
      , Top = 156 ;
      , Width = 197 ;
      , WordWrap = .T.

  ADD OBJECT image1 AS image WITH ;
        Height = 32 ;
      , Left = 24 ;
      , Name = "Image1" ;
      , Picture = "fc_mru.bmp" ;
      , Top = 164 ;
      , Width = 32

  ADD OBJECT label2 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "This option restores the original FoxCode table which stores native Visual FoxPro commands and functions." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 28 ;
      , Left = 72 ;
      , Name = "Label2" ;
      , TabIndex = 2 ;
      , Top = 36 ;
      , Width = 257 ;
      , WordWrap = .T.

  ADD OBJECT label3 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "This option removes deleted records from your FoxCode table." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 28 ;
      , Left = 72 ;
      , Name = "Label3" ;
      , TabIndex = 4 ;
      , Top = 84 ;
      , Width = 226 ;
      , WordWrap = .T.

  ADD OBJECT shape2 AS shape WITH ;
        Height = 2 ;
      , Left = 156 ;
      , Name = "Shape2" ;
      , SpecialEffect = 0 ;
      , Top = 140 ;
      , Width = 312

  ADD OBJECT label4 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "This option deletes all MRU file content." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 72 ;
      , Name = "Label4" ;
      , TabIndex = 9 ;
      , Top = 192 ;
      , Width = 189 ;
      , WordWrap = .T.

  ADD OBJECT label5 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Clean Up and Restore" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 12 ;
      , Name = "Label5" ;
      , TabIndex = 1 ;
      , Top = 12 ;
      , Width = 107

  ADD OBJECT shape1 AS shape WITH ;
        Height = 2 ;
      , Left = 120 ;
      , Name = "Shape1" ;
      , SpecialEffect = 0 ;
      , Top = 20 ;
      , Width = 349

  ADD OBJECT image2 AS image WITH ;
        Height = 32 ;
      , Left = 24 ;
      , Name = "Image2" ;
      , Picture = "fc_maint.bmp" ;
      , Top = 36 ;
      , Width = 32

  ADD OBJECT cmdclose AS commandbutton WITH ;
        Cancel = .T. ;
      , Caption = "Close" ;
      , Default = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 396 ;
      , Name = "cmdClose" ;
      , TabIndex = 11 ;
      , Top = 240 ;
      , Width = 72

  ADD OBJECT shape3 AS shape WITH ;
        Height = 2 ;
      , Left = 12 ;
      , Name = "Shape3" ;
      , SpecialEffect = 0 ;
      , Top = 228 ;
      , Width = 456

  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    THIS.haderror = .T.
    IF nError = 3
      MESSAGEBOX(ERR_FCODEINUSE_LOC)
      RETURN
    ENDIF
  ENDPROC
  
  PROCEDURE Init
    LPARAMETERS oForm 
    THIS.Left = oForm.Left + 24
    THIS.Top = oForm.Top + 24
    
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF nKeyCode=27
    	THISFORM.Release()
    ENDIF
  ENDPROC
  
  PROCEDURE cmdcleanmru.Click
    IF MESSAGEBOX(CLEAN_MRU_LOC,292)=6
        LOCAL lcMRUStr,aCHRZEROS,nCHRZEROS,aMRUFiles,i,lCleaned
    	SET RESOURCE OFF
      	SELECT 0
    	USE (SYS(2005)) AGAIN
    	ACTIVATE SCREEN
      	SCAN FOR LEFT(id,3)="MRU" AND !DELETED()
    		* skip for classes 
      		IF LEFT(id,4)="MRUI"
      			LOOP
      		ENDIF
    	  	lCleaned=.F.
    		lcMRUStr=data
    		nCHRZEROS = OCCURS(CHR(0),lcMRUStr)
    		DIMENSION aCHRZEROS[nCHRZEROS]
    		DIMENSION aMRUFiles[nCHRZEROS-2]
    		FOR i = 1 TO nCHRZEROS
    			aCHRZEROS[m.i] = ATC(CHR(0),lcMRUStr,m.i)
    		ENDFOR
    		FOR i = 1 TO nCHRZEROS-2
    			aMRUFiles[m.i] = SUBSTR(lcMRUStr,aCHRZEROS[m.i]+1,aCHRZEROS[m.i+1]-aCHRZEROS[m.i]-1)
    			DO CASE
    			CASE LEFT(id,4)="MRUT"
    				IF !DIRECTORY(aMRUFiles[m.i])
    					lCleaned=.T.
    					aMRUFiles[m.i] = ""
    				ENDIF				
    			OTHERWISE
    				IF !FILE(aMRUFiles[m.i])
    					lCleaned=.T.
    					aMRUFiles[m.i] = ""
    				ENDIF
    			ENDCASE
    		ENDFOR
    		IF lCleaned
    			lcMRUStr=CHR(4)+CHR(0)
    			FOR i = 1 TO nCHRZEROS-2
    				IF !EMPTY(aMRUFiles[m.i])
    					lcMRUStr=lcMRUStr+aMRUFiles[m.i]+CHR(0)
    				ENDIF
    			ENDFOR
    			lcMRUStr=lcMRUStr+CHR(0)
    			IF LEN(lcMRUStr)>3
    				REPLACE data WITH lcMRUStr, ckval WITH VAL(SYS(2007,SUBSTR(lcMRUStr,3)))
    			ELSE
    			  	REPLACE id WITH "*"+ALLTRIM(id)
    			  	DELETE
    			ENDIF
    		ENDIF
        ENDSCAN
      	USE
      	SET RESOURCE ON
      	WAIT WINDOW DONE_MRU_LOC TIMEOUT 1
    ENDIF
  ENDPROC
  
  PROCEDURE cmdcleanmru.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdcleanfoxcode.Click
    LOCAL lcSaveOptions, lcData
    IF MESSAGEBOX(CLEAN_FOXCODE_LOC,292)=6
      SELECT foxcode
      BLANK FOR UPPER(type) = "O" AND DELETED()
      BLANK FOR UPPER(type) = "T" AND DELETED() AND SAVE
      lcSaveOptions = _VFP.EditorOptions
      lcData = DBF()
      _VFP.EditorOptions = ""
      USE (lcData) EXCLUSIVE ALIAS foxcode
      IF !EMPTY(ALIAS())
    	  PACK
    	  USE
      	  _VFP.EditorOptions = lcSaveOptions
    	  USE (lcData) SHARED ALIAS foxcode
    	  WAIT WINDOW DONE_CLEAN_LOC TIMEOUT 1
      ELSE
    	  _VFP.EditorOptions = lcSaveOptions
    	  USE (lcData) SHARED ALIAS foxcode
      ENDIF
    ENDIF
    
  ENDPROC
  
  PROCEDURE cmdcleanfoxcode.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdzapmru.Click
    IF MESSAGEBOX(ZAP_MRU_LOC,292)=6
    	SET RESOURCE OFF
      	SELECT 0
    	USE (SYS(2005)) AGAIN
    	DELETE FOR LEFT(id,3)="MRU"
      	REPLACE id WITH "*"+ALLTRIM(id) FOR LEFT(id,3)="MRU"
      	USE
      	SET RESOURCE ON
      	WAIT WINDOW DONE_MRU_LOC TIMEOUT 1
    ENDIF
    
  ENDPROC
  
  PROCEDURE cmdzapmru.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdrestore.Click
    IF MESSAGEBOX(RESTORE_FOXCODE_LOC,292)=6
    	LOCAL lcEditOptions,lnFileCount,lcBackFile,lcSafe,lcBackFile2,lcPath
      	lnFileCount=0
      	lcBackFile2="_"+SYS(3)
      	SELECT FOXCODE
    	USE
    	lcEditOptions = _VFP.EditorOptions
    	_VFP.EditorOptions=""
    	USE (_FOXCODE) EXCLUSIVE ALIAS FOXCODE
    	lcPath = ADDBS(JUSTPATH(_FOXCODE))
      	IF !EMPTY(ALIAS())
    		DO WHILE .T.
    	  	  	lnFileCount=lnFileCount+1
    	  	  	lcBackFile = lcPath + "FOXCODE_" + TRANSFORM(lnFileCount) + ".DBF"
    	  		IF !FILE(lcBackFile)
    	    		EXIT
    	  		ENDIF
        	ENDDO
    	    lcSafe=SET("SAFETY")
    	    SET SAFETY OFF
        	COPY TO (lcBackFile)
        	COPY TO (lcBackFile2) FOR Save AND !DELETED() AND ATC("RESERVE",Source)=0
    	  	USE IN FOXCODE
    		USE "FXCDE_BACK.DBF" SHARED ALIAS FXCDEBACK
        	COPY TO (_FOXCODE)
    		USE IN FXCDEBACK
    		USE (_FOXCODE) EXCLUSIVE ALIAS FOXCODE
      		APPEND FROM (lcBackFile2)
      		DELETE FILE (FORCEEXT(lcBackFile2,"dbf"))
      		DELETE FILE (FORCEEXT(lcBackFile2,"fpt"))
      		SET SAFETY &lcSafe
      	ENDIF
    	_VFP.EditorOptions=lcEditOptions
    	USE (_FOXCODE) AGAIN SHARED ALIAS FOXCODE
    
      	IF !THISFORM.Haderror
      	  	MESSAGEBOX(DONE_RESTORE_LOC+lcBackFile)
      	ENDIF 	
      	
      	THISFORM.Haderror=.F.
    ENDIF
    
  ENDPROC
  
  PROCEDURE cmdrestore.Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.Error(nError, cMethod, nLine)
  ENDPROC
  
  PROCEDURE cmdclose.Click
    THISFORM.Release()
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: frmmaintenance
**************************************************



**************************************************
*-- Class:        frmtips (d:\beta\fcmd\vfpproj\xfoxcode\foxcode.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
DEFINE CLASS frmtips AS form

  Caption = "Command Tip Window"
  DoCreate = .T.
  HalfHeightCaption = .T.
  Height = 192
  Left = 44
  Name = "frmtips"
  Top = 9
  Width = 372

  ADD OBJECT edttips AS editbox WITH ;
        FontName = "Courier New" ;
      , Height = 193 ;
      , Left = 0 ;
      , Name = "edtTips" ;
      , ReadOnly = .T. ;
      , Top = 0 ;
      , Width = 373

  
  PROCEDURE Deactivate
    ACTIVATE SCREEN
    
  ENDPROC
  
  PROCEDURE Destroy
    RELEASE _oFoxCodeTips
    
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF nKeyCode=27
    	THISFORM.Release()
    ENDIF
  ENDPROC
  
  PROCEDURE Resize
    *THIS._resizable1.adjustcontrols()
  ENDPROC


ENDDEFINE
*
*-- EndDefine: frmtips
**************************************************
