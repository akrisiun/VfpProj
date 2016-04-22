* \vtools\addin\filerw\filerw.scx
**************************************************
*-- Class Library:  \vtools\addin\filerw\filerw.scx
**************************************************


**************************************************
*-- Class:        Dataenvironment (\vtools\addin\filerw\filerw.scx)
*-- ParentClass:  dataenvironment
*-- BaseClass:    dataenvironment
*
DEFINE CLASS Dataenvironment AS dataenvironment

  DataSource = .NULL.
  Height = 0
  Left = 0
  Name = "Dataenvironment"
  Top = 0
  Width = 0




ENDDEFINE
*
*-- EndDefine: Dataenvironment
**************************************************



**************************************************
*-- Class:        FilerWin (\vtools\addin\filerw\filerw.scx)
*-- ParentClass:  formset
*-- BaseClass:    formset
*
DEFINE CLASS FilerWin AS formset

  AutoRelease = .T.
  DataSession = 2
  Name = "FilerWin"
  ReadCycle = .F.
  ccurdir =[]
  cext = "*.*"
  cinidir = ("")
  cinifilename = (ThisFormSet.cIniDir + "FilerW.Ini")
  colddir =[]
  coldfilercaption =[]
  csearchstr = ("")
  cviewfile = ("")
  hookset = ([FilerHook.prg])
  isedit = .F.
  isignoreerrors = .F.
  lconfirm = .F.
  lpressedcancel = .F.
  ncounter = 0
  ngridcolumnscount = 0
  nmode = 0
  nokclickcount = 0
  uretval = .F.

  ADD OBJECT filerw AS l_form2 WITH ; && lib.vcx 
        Caption = "FilerW" ;
      , Desktop = .F. ;
      , DoCreate = .T. ;
      , Height = 475 ;
      , KeyPreview = .T. ;
      , Left = 11 ;
      , Name = "FilerW" ;
      , Top = 3 ;
      , Width = 336 ;
      , WindowType = 0 ;
      , cinifilename = ("D:\Prg\FilerW.Ini")

  ADD OBJECT filerw.shpsort AS l_shape WITH ; && lib.vcx 
        Height = 73 ;
      , Left = 299 ;
      , Name = "shpSort" ;
      , Top = 39 ;
      , Width = 36 ;
      , ZOrderSet = 0 ;
      , calignment = ("000100")

  ADD OBJECT filerw.lblfiles AS l_label WITH ; && lib.vcx 
        Caption = "\<List:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 3 ;
      , Name = "lblFiles" ;
      , TabIndex = 1 ;
      , Top = 20 ;
      , ZOrderSet = 2

  ADD OBJECT filerw.lblcurdir AS l_label WITH ; && lib.vcx 
        Caption = "\<Dir:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 182 ;
      , Name = "lblCurDir" ;
      , TabIndex = 3 ;
      , Top = 8 ;
      , ZOrderSet = 2

  ADD OBJECT filerw.txtsearch AS l_textbox WITH ; && lib.vcx 
        Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 26 ;
      , Name = "txtSearch" ;
      , TabIndex = 15 ;
      , ToolTipText = "Search..." ;
      , Top = 5 ;
      , Visible = .F. ;
      , Width = 26 ;
      , ZOrderSet = 3

  ADD OBJECT filerw.cmdfind AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<Find" ;
      , Enabled = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 302 ;
      , Name = "cmdFind" ;
      , TabIndex = 11 ;
      , Top = 135 ;
      , Width = 30 ;
      , ZOrderSet = 4 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cmdedit AS l_commandbutton WITH ; && lib.vcx 
        Caption = "Edit" ;
      , Default = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 302 ;
      , Name = "cmdEdit" ;
      , TabIndex = 12 ;
      , Top = 171 ;
      , Width = 30 ;
      , ZOrderSet = 5 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cmdbrowf AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<BrowF" ;
      , Default = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 302 ;
      , Name = "cmdBrowF" ;
      , TabIndex = 12 ;
      , Top = 207 ;
      , Width = 30 ;
      , ZOrderSet = 5 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cmdsusp AS l_commandbutton WITH ; && lib.vcx 
        Caption = "Susp" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 303 ;
      , Name = "cmdSusp" ;
      , TabIndex = 13 ;
      , Top = 411 ;
      , Width = 30 ;
      , ZOrderSet = 7 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cmdexit AS l_commandbutton WITH ; && lib.vcx 
        Cancel = .T. ;
      , Caption = "E\<xit" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 302 ;
      , Name = "cmdExit" ;
      , TabIndex = 14 ;
      , Top = 446 ;
      , Width = 30 ;
      , ZOrderSet = 8 ;
      , calignment = ("001100")

  ADD OBJECT filerw.chbname AS l_checkbox WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "D\<ate" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 302 ;
      , Name = "chbName" ;
      , Style = 1 ;
      , TabIndex = 9 ;
      , Top = 53 ;
      , Width = 30 ;
      , ZOrderSet = 9 ;
      , calignment = ("000100") ;
      , ischeckegzist = .F.

  ADD OBJECT filerw.chkcode AS l_checkbox WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "C\<od" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 303 ;
      , Name = "chkCode" ;
      , Style = 1 ;
      , TabIndex = 10 ;
      , ToolTipText = "Shows file code" ;
      , Top = 377 ;
      , Value = 0 ;
      , Width = 30 ;
      , ZOrderSet = 10 ;
      , calignment = ("000100") ;
      , ischeckegzist = .F.

  ADD OBJECT filerw.chbext AS l_checkbox WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "\<Ext" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 302 ;
      , Name = "chbExt" ;
      , Style = 1 ;
      , TabIndex = 10 ;
      , Top = 77 ;
      , Width = 30 ;
      , ZOrderSet = 10 ;
      , calignment = ("000100") ;
      , ischeckegzist = .F.

  ADD OBJECT filerw.lblsort AS l_label WITH ; && lib.vcx 
        Caption = "Sort" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 302 ;
      , Name = "lblSort" ;
      , TabIndex = 8 ;
      , Top = 33 ;
      , ZOrderSet = 11 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cbomask AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "105" ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 89 ;
      , Name = "cboMask" ;
      , NumberOfElements = 0 ;
      , RowSource = "*.prg;*.scx;*.vcx,*.dbf,*.prg,*.*" ;
      , RowSourceType = 1 ;
      , TabIndex = 7 ;
      , Top = 5 ;
      , Value = "*.prg" ;
      , Width = 90 ;
      , ZOrderSet = 12 ;
      , calignment = ("0000")

  ADD OBJECT filerw.lblmask AS l_label WITH ; && lib.vcx 
        Caption = "\<Mask:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 59 ;
      , Name = "lblMask" ;
      , TabIndex = 6 ;
      , Top = 10 ;
      , ZOrderSet = 13 ;
      , calignment = ("0000")

  ADD OBJECT filerw.cmdchdir AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<.." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , Left = 312 ;
      , Name = "cmdChDir" ;
      , TabIndex = 5 ;
      , Top = 6 ;
      , Width = 22 ;
      , ZOrderSet = 14 ;
      , calignment = ("000100")

  ADD OBJECT filerw.cbocurdir AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 199 ;
      , Name = "cboCurDir" ;
      , NumberOfElements = 0 ;
      , RowSource = "D:\,D:\Program\BalsaW,D:\Vfp5lib,D:\Program,D:\Program\BalsaW\PaskyrW" ;
      , RowSourceType = 1 ;
      , TabIndex = 4 ;
      , Top = 5 ;
      , Value = "D:\" ;
      , Width = 112 ;
      , ZOrderSet = 12 ;
      , calignment = ("0100")

  ADD OBJECT filerw.cmdclassview AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<Cls view" ;
      , Default = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 302 ;
      , Name = "cmdClassView" ;
      , TabIndex = 12 ;
      , Top = 244 ;
      , Width = 30 ;
      , ZOrderSet = 5 ;
      , calignment = ("000100")

  ADD OBJECT filerw.grdfiles AS l_grid WITH ; && lib.vcx 
        ColumnCount = 0 ;
      , DeleteMark = .F. ;
      , GridLines = 0 ;
      , Height = 435 ;
      , Left = 5 ;
      , Name = "grdFiles" ;
      , RecordSource = "TmpFil" ;
      , TabIndex = 2 ;
      , Top = 36 ;
      , Width = 291 ;
      , calignment = ("1100")

  ADD OBJECT frmsearch AS frmparameters WITH ; && lib.vcx 
        BorderStyle = 3 ;
      , Caption = "Search" ;
      , Desktop = .F. ;
      , DoCreate = .T. ;
      , Height = 222 ;
      , KeyPreview = .T. ;
      , Left = 366 ;
      , Name = "frmSearch" ;
      , Top = 4 ;
      , Visible = .F. ;
      , Width = 328 ;
      , WindowType = 1 ;
      , cntYesNO.Left = 76 ;
      , cntYesNO.Name = "cntYesNO" ;
      , cntYesNO.TabIndex = 19 ;
      , cntYesNO.Top = 189 ;
      , cntYesNO.ZOrderSet = 18 ;
      , cntYesNO.calignment = ("00") ;
      , cntYesNO.cmdCancel.Name = "cmdCancel" ;
      , cntYesNO.cmdOk.Default = .T. ;
      , cntYesNO.cmdOk.Name = "cmdOk"

  ADD OBJECT frmsearch.lblcounter AS l_label WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "???" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 39 ;
      , Name = "lblCounter" ;
      , TabIndex = 16 ;
      , Top = 194 ;
      , Visible = .F. ;
      , Width = 58 ;
      , ZOrderSet = 0

  ADD OBJECT frmsearch.lblfound AS l_label WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "???" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 14 ;
      , Left = 111 ;
      , Name = "lblFound" ;
      , TabIndex = 17 ;
      , Top = 194 ;
      , Visible = .F. ;
      , Width = 73 ;
      , ZOrderSet = 1

  ADD OBJECT frmsearch.lblfile AS l_label WITH ; && lib.vcx 
        AutoSize = .F. ;
      , Caption = "???" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 14 ;
      , Left = 13 ;
      , Name = "lblFile" ;
      , TabIndex = 18 ;
      , Top = 181 ;
      , Visible = .F. ;
      , Width = 311 ;
      , ZOrderSet = 2 ;
      , calignment = ("010000")

  ADD OBJECT frmsearch.lbldepth AS l_label WITH ; && lib.vcx 
        Caption = "Subdirs \<depth:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 30 ;
      , Name = "lblDepth" ;
      , TabIndex = 5 ;
      , Top = 85 ;
      , ZOrderSet = 3

  ADD OBJECT frmsearch.lblstring AS l_label WITH ; && lib.vcx 
        Caption = "\<String:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 12 ;
      , Name = "lblString" ;
      , TabIndex = 1 ;
      , Top = 17 ;
      , ZOrderSet = 4

  ADD OBJECT frmsearch.chkwholeword AS l_checkbox WITH ; && lib.vcx 
        Caption = "\<Whole word" ;
      , Left = 14 ;
      , Name = "chkWholeWord" ;
      , TabIndex = 3 ;
      , Top = 43 ;
      , Value = 0 ;
      , ZOrderSet = 5

  ADD OBJECT frmsearch.cbostring AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 54 ;
      , Name = "cboString" ;
      , NumberOfElements = 0 ;
      , RowSource = "" ;
      , RowSourceType = 1 ;
      , TabIndex = 2 ;
      , Top = 12 ;
      , Value =[] ;
      , Width = 267 ;
      , ZOrderSet = 6 ;
      , calignment = ("0100")

  ADD OBJECT frmsearch.chklooksubdirs AS l_checkbox WITH ; && lib.vcx 
        Caption = "\<Look in subdirectories" ;
      , Left = 14 ;
      , Name = "chkLookSubdirs" ;
      , TabIndex = 4 ;
      , Top = 65 ;
      , Value = 1 ;
      , ZOrderSet = 7

  ADD OBJECT frmsearch.chkcasesens AS l_checkbox WITH ; && lib.vcx 
        Caption = "\<Case sensitive" ;
      , Left = 168 ;
      , Name = "chkCaseSens" ;
      , TabIndex = 7 ;
      , Top = 42 ;
      , Value = 0 ;
      , ZOrderSet = 8

  ADD OBJECT frmsearch.cbomask AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "105" ;
      , Enabled = .T. ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 165 ;
      , Name = "cboMask" ;
      , NumberOfElements = 0 ;
      , RowSource = "*.prg;*.scx;*.vcx,*.dbf,*.prg,*.*" ;
      , RowSourceType = 1 ;
      , TabIndex = 9 ;
      , Top = 81 ;
      , Value = "*.prg" ;
      , Width = 157 ;
      , ZOrderSet = 9 ;
      , calignment = ("000100")

  ADD OBJECT frmsearch.lblmask AS l_label WITH ; && lib.vcx 
        Caption = "File \<mask:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 166 ;
      , Name = "lblMask" ;
      , TabIndex = 8 ;
      , Top = 65 ;
      , ZOrderSet = 10 ;
      , calignment = ("000100")

  ADD OBJECT frmsearch.lblin AS l_label WITH ; && lib.vcx 
        Caption = "S\<earch in:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Left = 12 ;
      , Name = "lblIn" ;
      , TabIndex = 10 ;
      , Top = 127 ;
      , ZOrderSet = 11

  ADD OBJECT frmsearch.cboin AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 64 ;
      , Name = "cboIn" ;
      , NumberOfElements = 0 ;
      , RowSource = "" ;
      , RowSourceType = 1 ;
      , TabIndex = 11 ;
      , Top = 122 ;
      , Value =[] ;
      , Width = 234 ;
      , ZOrderSet = 12 ;
      , calignment = ("0100")

  ADD OBJECT frmsearch.chkalso AS l_checkbox WITH ; && lib.vcx 
        Caption = "\<Also in:" ;
      , Left = 12 ;
      , Name = "chkAlso" ;
      , TabIndex = 13 ;
      , Top = 152 ;
      , Value = 0 ;
      , ZOrderSet = 13

  ADD OBJECT frmsearch.cboalso AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , Enabled = .F. ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , ItemTips = .T. ;
      , Left = 63 ;
      , Name = "cboAlso" ;
      , NumberOfElements = 0 ;
      , RowSource = "" ;
      , RowSourceType = 1 ;
      , TabIndex = 14 ;
      , Top = 148 ;
      , Value =[] ;
      , Width = 235 ;
      , ZOrderSet = 14 ;
      , calignment = ("0100")

  ADD OBJECT frmsearch.cmdalso AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<.." ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , Left = 301 ;
      , Name = "cmdAlso" ;
      , TabIndex = 15 ;
      , Top = 149 ;
      , Width = 22 ;
      , ZOrderSet = 15 ;
      , calignment = ("000100")

  ADD OBJECT frmsearch.cmdin AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<.." ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , Left = 301 ;
      , Name = "cmdIn" ;
      , TabIndex = 12 ;
      , Top = 123 ;
      , Width = 22 ;
      , ZOrderSet = 16 ;
      , calignment = ("000100")

  ADD OBJECT frmsearch.txtdepth AS l_spinner WITH ; && lib.vcx 
        Format = "Z" ;
      , Height = 24 ;
      , InputMask = "99" ;
      , KeyboardHighValue = 20 ;
      , KeyboardLowValue = 0 ;
      , Left = 103 ;
      , Name = "txtDepth" ;
      , NullDisplay = "All" ;
      , SpinnerHighValue =  20.00 ;
      , SpinnerLowValue =   0.00 ;
      , TabIndex = 6 ;
      , Top = 81 ;
      , Value = 3 ;
      , Width = 46 ;
      , ZOrderSet = 17

  ADD OBJECT frmview AS l_form2 WITH ; && lib.vcx 
        Caption = "View Function" ;
      , DoCreate = .T. ;
      , Height = 179 ;
      , Left = 357 ;
      , Name = "frmView" ;
      , Top = 297 ;
      , Visible = .F. ;
      , Width = 381 ;
      , WindowState = 0

  ADD OBJECT frmview.txtview AS l_editbox WITH ; && lib.vcx 
        AllowTabs = .T. ;
      , Enabled = .T. ;
      , FontName = "Courier New" ;
      , FontSize = 8 ;
      , Height = 155 ;
      , HideSelection = .F. ;
      , Left = 0 ;
      , Name = "txtView" ;
      , OLEDropMode = 1 ;
      , ReadOnly = .T. ;
      , ScrollBars = 2 ;
      , TabIndex = 1 ;
      , Top = 24 ;
      , Width = 380 ;
      , calignment = ("1100")

  ADD OBJECT frmview.cmdup AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<Up" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 319 ;
      , Name = "cmdUp" ;
      , TabIndex = 4 ;
      , Top = 1 ;
      , Width = 20 ;
      , ZOrderSet = 4 ;
      , calignment = ("000100")

  ADD OBJECT frmview.cmddown AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<Dn" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 338 ;
      , Name = "cmdDown" ;
      , TabIndex = 4 ;
      , Top = 1 ;
      , Width = 20 ;
      , ZOrderSet = 4 ;
      , calignment = ("000100")

  ADD OBJECT frmview.cmdrefresh AS l_commandbutton WITH ; && lib.vcx 
        Caption = "\<Rf" ;
      , Enabled = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 23 ;
      , Left = 1 ;
      , Name = "cmdRefresh" ;
      , TabIndex = 4 ;
      , Top = 0 ;
      , Width = 20 ;
      , ZOrderSet = 4 ;
      , calignment = ("0000")

  ADD OBJECT frmview.cbofunc AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , Enabled = .F. ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , ItemTips = .T. ;
      , Left = 145 ;
      , Name = "cboFunc" ;
      , NumberOfElements = 0 ;
      , RowSource = "" ;
      , RowSourceType = 1 ;
      , TabIndex = 3 ;
      , Top = 1 ;
      , Value =[] ;
      , Width = 174 ;
      , ZOrderSet = 5 ;
      , calignment = ("0100")

  ADD OBJECT frmview.cboobj AS l_combobox WITH ; && lib.vcx 
        ColumnCount = 1 ;
      , ColumnWidths = "145" ;
      , Enabled = .F. ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , ItemTips = .T. ;
      , Left = 24 ;
      , Name = "cboObj" ;
      , NumberOfElements = 0 ;
      , RowSource = "" ;
      , RowSourceType = 1 ;
      , TabIndex = 2 ;
      , Top = 1 ;
      , Value =[] ;
      , Width = 118 ;
      , ZOrderSet = 5 ;
      , calignment = ("0100")

  
  PROCEDURE Activate
    ** l_formset::Activate()
    
    IF NOT USED( "TmpFil" )
       ThisFormSet.Release()
    ENDIF
    IF NOT FULLPATH( CURDIR() ) == This.cCurDir
       This.GetDir( .F., .F. )
    ENDIF
  ENDPROC
  
  PROCEDURE classview
    PARAMETERS cFile
    
    DO FSet_ClassView WITH ThisFormSet, cFile IN (ThisFormSet.Hookset) 
    RETURN This.uRetVal 
    
    
    
  ENDPROC
  
  PROCEDURE createtmp
    LPARAMETERS cName, notNeedIdx
    
    CREATE CURSOR (cName) ( F_Name2 C(100), F_Name C(100), F_String C(160),;
       F_Ext C(10), nType N(3), F_Object C(90), F_DateTime C(20), F_Size C(12 ),;
       nType2 N(3), nLine N(6), F_Method C(70)  )
    
    SELECT TmpFil
    IF notNeedIdx
       RETURN .T.
    ENDIF
    
    INDEX ON STR( nType, 3 ) + F_Ext + F_Name + STR( nLine, 6 ) +;
    	              STR( nType2, 3 )  TAG By_Ext
    
    INDEX ON STR( 999-nType, 3 ) + F_String +;
     IIF( nType <= 5, ;
        STR( 1E10- (ASC(SUBSTR( F_Name,1,1)) *256 + ASC(SUBSTR( F_Name,2,1)) )*256 + ASC(SUBSTR( F_Name,3,1)) )+;
        STR( 1E10- (ASC(SUBSTR( F_Name,4,1)) *256 + ASC(SUBSTR( F_Name,5,1)) )*256 + ASC(SUBSTR( F_Name,6,1)) )+;
        STR( 1E10- (ASC(SUBSTR( F_Name,7,1)) *256 + ASC(SUBSTR( F_Name,8,1)) )*256 + ASC(SUBSTR( F_Name,9,1)) );               
      , F_Name )+;
     STR( 999999-nLine, 6 )+ STR( nType2, 3 )  TAG By_Name DESC
    
       
    *!*	INDEX ON STR( 999-nType, 3 ) + F_String +;
    *!*	         IIF( nType <= 5, STR( 1E15 - ;
    *!*	             ((  ASC(SUBSTR( F_Name,1,1)) *256 + ASC(SUBSTR( F_Name,2,1)) ) *256 +;
    *!*	               ASC(SUBSTR( F_Name,3,1)) )*256 + ASC(SUBSTR( F_Name,4,1))  ), F_Name )+;
    *!*		              STR( 999999-nLine, 6 )+ STR( nType2, 3 )  TAG By_Name DESC
    
    
  ENDPROC
  
  PROCEDURE Destroy
    IF USED( "TmpFil" )
       USE IN "TmpFil"
    ENDIF
    IF USED( "TmpPrg" )
       USE IN "TmpPrg"
    ENDIF
    
    CD (This.cOldDir)
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE edit
    * FileWin::Edit 
    
    DO FSET_Edit WITH ThisFormSet IN (ThisFormSet.HookSet)
    
    
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    
    **RETURN ObjectError( This, nError, cMethod, nLine )
    MessageBox( TRANSF( nError ) + " "+ MESSAGE() )
    
  ENDPROC
  
  PROCEDURE filelist
    WITH This
        .nMode = 0
        WITH .FilerW
          .Caption = "FilerWSearch"    
          .SaveWindowPos()
          .Caption = "FilerW"    
          .LockScreen = .T.
          .RestoreWindowPos()
          .LockScreen = .F.
        ENDWITH
      
    	.GridProperties( 0 )
    	
    	WITH ThisFormSet.FilerW.grdFiles
    	  FOR  i = .ColumnCount TO 1 STEP -1
    	   .DeleteColumn( i )
    	  ENDFOR
    	ENDWITH
    *	.FilerW.cmdFind.SetFocus()
        .FilerW.grdFiles.GridSetUp( This )
        .FilerW.grdFiles.SetFocus()
    	.GetDir( .F., .F. )
      
    ENDWITH
  ENDPROC
  
  PROCEDURE find
    * FilerWin::Find 
    WITH This.frmSearch
    
           .uRetVal = .F.
           STORE .F. TO .lblFile.Visible, .lblCounter.Visible, .lblFound.Visible
           STORE "" TO .lblFile.Caption, .lblCounter.Caption, .lblFound.Caption
           
           .cboMask.DisplayValue = ThisFormSet.FilerW.cboMask.DisplayValue
           .cboIn.DisplayValue =  ThisFormSet.cCurDir
           IF EMPTY(.cboAlso.DisplayValue) AND DIRECTORY("D:\Vfplib") 
              .cboAlso.DisplayValue = "D:\Vfplib"
           ENDIF
           STORE (.chkAlso.Value=1) TO .cboAlso.Enabled, .cmdAlso.Enabled
           
           * Show search form
           .Show( 1 )       
    ENDWITH
    
  ENDPROC
  
  PROCEDURE findfiles
    *---- text in files search
    PRIVATE cSrchStr, Handle
    LOCAL  nALine, nI, nIC, nFiles
    LOCAL IsCheckSubDirs
    LOCAL A_Fields
    DIMENSION A_Fields[ 10 ]
    PRIVATE nFiles, lExit
    LOCAL cExt2, cExt, cDir, cSubDir, nRet
    
    WITH This
    
    	IF TYPE( "cExt2" ) # "C"
    	   cExt2 = .cExt
    	ENDIF   
    	STORE cExt2 TO cExt, .cExt 
        
    	IF TYPE( "cDir" ) # "C"
    	   cDir = FULLPATH( CURDIR() )
    	ENDIF
    
        cDir = ALLT( cDir )
        .cCurDir = FULLPATH( CURDIR() )
        .FilerW.cboCurDir.List( 1 ) = .cCurDir
    
        cSubDir = ""
    	IF cDir = ".."
    	    CD ..
    	    IF RAT( "\", .cCurDir, 2 ) > 1
    	       cSubDir = SUBSTR( .cCurDir, RAT( "\", .cCurDir, 2 )+1 )
    	       IF RAT( "\", cSubDir ) > 1
      	          cSubDir = LEFT( cSubDir,  RAT( "\", cSubDir )-1 )
      	       ELSE
      	          cSubDir = ""
      	       ENDIF
      	    ENDIF
    	ELSE
         	CD (cDir)
        ENDIF
    
        	
        .cCurDir = FULLPATH( CURDIR() )   
        SET DEFAULT TO (.cCurDir)
        
        .FilerW.cboCurDir.DisplayValue = .cCurDir
        .FilerW.cboMask.DisplayValue = cExt
    
        
    *	cSrchStr = ThisFormset.frmSearch.cboString.DisplayValue
        cSrchStr = RTRIM( .cSearchStr )
        IgnoreCase = ( .frmSearch.chkCaseSens.Value = 0 )
        IsCheckSubDirs = (.frmSearch.chkLookSubdirs.Value = 1 )
        IF IgnoreCase
           cSrchStr = UPPER( cSrchStr )
        ENDIF
    
    	WITH ThisFormSet.frmSearch
           .cntYesNo.Visible = .F.
    	   STORE .T. TO .lblFile.Visible, .lblCounter.Visible, .lblFound.Visible
           STORE "" TO .lblFile.Caption, .lblCounter.Caption, .lblFound.Caption
    	ENDWITH
            
    	.CreateTmp( "TmpPrg", .T. )        && create cursor TmpPrg
    	SELECT TmpFil
    	DELETE ALL
    	SET ORDER TO
        
        cDir = .frmSearch.cboIn.DisplayValue 
        nFiles = 0        	&& .frmSearch.lblCounter.Caption = 
                            && "  / "+ ALLT( STR( nFiles, 4 ) )+"  "
    
    	lExit = .F.
    	SET ESCAPE ON
    	ON ESCAPE lExit = .T.
        
    	.GetDirectory( cDir )
    	
    	IF .frmSearch.chkAlso.Value = 1 AND ;
    	   NOT EMPTY( .frmSearch.cboAlso.DisplayValue )
    
    	   cDir = .frmSearch.cboAlso.DisplayValue
           .GetDirectory( cDir )
     	ENDIF
     	CD (.cCurDir)
    
        ON ESCAPE 
        SET ESCAPE OFF
    	lExit = .F.
        
        SELECT TmpFil
        *----- search by file date  descended order (ex. dates orders: 2001 2000 1999)
        INDEX ON F_DateTime TAG By_Name  DESC
        
        SET ORDER TO TAG By_Name	 
        GO TOP	
    	
    	SCAN FOR nType = 10               && - COPY TmpFil TO TmpPrg -
    	                                  && cycle for PRG (ar TXT) files
    	  SCATTER TO A_Fields             && fields to array
    	  INSERT INTO TmpPrg FROM ARRAY A_Fields
    	  SELECT TmpFil
    	ENDSCAN
    	
    
    	*------------------------------------------------------------------------
    	SELECT TmpFil
    	DELETE ALL
    	DELETE TAG All
    	
    	SELECT TmpPrg
    	
    	GO TOP
    	COUNT TO nFiles
    	ACTIVATE WINDOW (ThisFormset.frmSearch.Name)
    	
    	
    	.frmSearch.lblFile.Caption = "File: "
    	.frmSearch.lblCounter.Caption = ;
    	           "  / "+ ALLT( STR( nFiles, 4 ) )+"  "
    	GO TOP
    	.frmSearch.lblFound.Caption  = " Found :       "
    	.FilerW.Caption = .FilerW.Caption + " for "+'"'+cSrchStr+'"'
    	
    	STORE 0 TO nIC, nFound
    
    	lExit = .F.
    	SET ESCAPE ON
    	ON ESCAPE lExit = .T.
    
    	SELECT TmpPrg
    	GO TOP
    
        .FilerW.Refresh()  && Show()
        nRet = 4  && retry
    
    	DO WHILE NOT EOF( "TmpPrg") AND NOT lExit
    	
    	  SELECT TmpPrg
    	  
    	  IF NOT INLIST( ALLT(UPPER(TmpPrg->F_Ext)), ".DBF", ".SCX", ".VCX", ".PRX" )
    	  
    	 	  Handle = FOPEN( ALLT(TmpPrg->F_Name) + ALLT(TmpPrg->F_Ext) )
    		  IF Handle <= 0 
    		     SKIP 1
    		     LOOP
    		  ENDIF
    
    		  nIC = nIC + 1
    	  	  .frmSearch.lblFile.Caption = " File : " +;
    	                   	   ALLT(TmpPrg->F_Name) + TmpPrg->F_Ext + " "
    		                           
    	  	  .frmSearch.lblCounter.Caption = " "+ ALLT( STR( nIC, 4 ) )+" / "+;
    		                   ALLT( STR( nFiles, 4 ) )
    	   	  .frmSearch.lblFound.Caption = " Found : " + STR( nFound, 5 )
    	   	  
    		  .SearchText()
    
       	      =FCLOSE( Handle )
    	  ELSE
    	     SELECT SELECT(1)
    	     IF USED( "TmpForm" )
    	        USE IN "TmpForm"
    	     ENDIF
    
    	     cDbf = ALLT(TmpPrg->F_Name) + ALLT(TmpPrg->F_Ext)
    
             DO WHILE .T.
    
    		     ThisFormSet.IsIgnoreErrors = .T.
    		     USE (cDbf)  ALIAS "TmpForm" 
    		     ThisFormSet.IsignoreErrors = .F.
    
    		     IF NOT USED( "TmpForm" ) AND nRet # 5   && # Ignore
    	           nRet = MessageBox( "Can't open "+ cDbf + " file as database"+CHR(13)+;
    	                                  "", 2+256 )  &&& <Abort><Retry><Ignore>
                   IF nRet = 4  && Retry
                      LOOP 	            
                   ENDIF
    	         ENDIF
                 EXIT                      
    	     ENDDO
    	     
    	     IF NOT USED( "TmpForm" )
    	        IF nRet = 3   && Abort
    	           EXIT
    	        ENDIF
    	        
    	     ELSE
    		  nIC = nIC + 1
    	  	  .frmSearch.lblFile.Caption = " File : " + cDbf + " "
    		                           
    	  	  .frmSearch.lblCounter.Caption = " "+ ALLT( STR( nIC, 4 ) )+" / "+;
    		                   ALLT( STR( nFiles, 4 ) )
    	   	  .frmSearch.lblFound.Caption = " Found : " + STR( nFound, 5 )
    	   	  
    		  .SearchForm()
    		  
    		  USE IN TmpForm
    		  SELECT TmpFil    && restore current alias
             ENDIF
             
          ENDIF
    	  
    	  *-----------------------------
    	  SELECT TmpPrg
    	  SKIP 1
    	ENDDO
    
    	SET ESCAPE OFF
    	ON ESCAPE 
    
    	USE IN TmpPrg
    	SELECT TmpFil
    
    	GO TOP
    	IF EOF()                          && if file empty 
    	  WAIT WINDOW "String is not found : "+cSrchStr
    	  INSERT INTO "TmpFil" ( F_Name, F_Ext, nType ) ;
    	            VALUES( "..", "", 3 ;
    	                    )
        ENDIF
        
        SELECT TmpFil
    	INDEX ON STR( nType, 3 ) + F_Ext + F_Name + STR( nLine, 6 ) +;
    		              STR( nType2, 3 )  TAG By_Ext
    
    	INDEX ON  RECNO()  TAG By_Name   && DESC
    
    	WITH ThisFormSet.frmSearch
    	   STORE .F. TO .lblFile.Visible, .lblCounter.Visible, .lblFound.Visible
           STORE "" TO .lblFile.Caption, .lblCounter.Caption, .lblFound.Caption
           .cntYesNo.Visible = .T.
    	ENDWITH
    	
    ENDWITH
    RETURN .T.
    
    
  ENDPROC
  
  PROCEDURE findmode
    WITH This
        
        .nMode = 1  && find mode
        WITH .FilerW
          .Caption = "FilerW"    
          .SaveWindowPos()
          .Caption = "FilerWSearch"    
          .LockScreen = .T.
          IF NOT .RestoreWindowPos()
    	       .Width = .Width + 100
    	  ENDIF
          .LockScreen = .F.
        ENDWITH
    	
    	WITH ThisFormSet.FilerW.grdFiles
    	  FOR  i = .ColumnCount TO 1 STEP -1
    	   .DeleteColumn()
    	  ENDFOR
    	ENDWITH
    	.GridProperties( 1 )
    *	.FilerW.cmdFind.SetFocus()
    
        .FilerW.grdFiles.GridSetUp( This )
        .FilerW.grdFiles.SetFocus()
        
        WITH .FilerW
          STORE .F. TO .cboMask.Enabled, .lblMask.Enabled,;
                       .cboCurDir.Enabled, .lblCurDir.Enabled, .cmdChDir.Enabled
        ENDWITH
            
    *!*		.GetDir( .F., .F. )   && calls .FindFiles()
    
        .frmSearch.Show()
        .FindFiles()
     
    ENDWITH
  ENDPROC
  
  PROCEDURE getdir
    LPARAMETERS cExt2, lFromGet, cDir
    
    PRIVATE a_Files, nF, i, cExt, cExt3
    
    WITH This
    
    	IF TYPE( "cExt2" ) # "C"
    	   cExt2 = .cExt
    	ENDIF   
    	STORE cExt2 TO cExt, .cExt 
        
    	IF TYPE( "cDir" ) # "C"
    	   cDir = FULLPATH( CURDIR() )
    	ENDIF
    
        cDir = ALLT( cDir )
        .cCurDir = FULLPATH( CURDIR() )
        .FilerW.cboCurDir.List( 1 ) = .cCurDir
    
        cSubDir = ""
    	IF cDir = ".."
    	    CD ..
    	    IF RAT( "\", .cCurDir, 2 ) > 1
    	       cSubDir = SUBSTR( .cCurDir, RAT( "\", .cCurDir, 2 )+1 )
    	       IF RAT( "\", cSubDir ) > 1
      	          cSubDir = LEFT( cSubDir,  RAT( "\", cSubDir )-1 )
      	       ELSE
      	          cSubDir = ""
      	       ENDIF
      	    ENDIF
    	ELSE
    	    ThisFormSet.IsignoreErrors = .T.
         	CD (cDir)
         	cD2 = FULLPATH( cDir )
    	    ThisFormSet.IsignoreErrors = .F.     	
    	    IF TYPE( "cD2" ) # "C" OR ( FULLPATH( CURDIR() ) == .cCurDir  AND ;
                    	       NOT FULLPATH( CURDIR() ) == cD2 )
    	       
    	       MessageBox( "Can't read directory "+;
    	                         IIF( TYPE( "cD2" ) = "C", cD2, cDir ) )
    	       RETURN .F.
    	    ENDIF
        ENDIF
    
        IF TYPE( ".Name" ) # "C"
           RETURN .F.
        ENDIF 	
        .cCurDir = FULLPATH( CURDIR() )
        SET DEFAULT TO (.cCurDir)
        
        IF TYPE( ".Name" ) # "C" OR TYPE( ".FilerW.Name" ) # "C"
           RETURN .F.
        ENDIF 	
        .FilerW.cboCurDir.DisplayValue = .cCurDir
        .FilerW.cboMask.DisplayValue = cExt
    
    *!*	    IF .nMode = 1       && if is Find Mode --------------
    *!*	       .FindFiles()
    *!*	       RETURN .T.
    *!*	    ENDIF	
        
        &&--- normal filer files mode -----------------------------------
    	SELECT TmpFil
    	*ZAP IN TmpFil
    	DELETE ALL
    	
    *!*		msg( "test 1" )
    *!*		BROW
    	
    	GO TOP
    	nF = ADIR( a_Files, "", "D" )
    
    	FOR i = 1 TO nF
    	
    	 IF NOT( ALLT( A_Files( I, 1 ) )  == "."  )
    	  INSERT INTO "TmpFil" ( F_Name, F_Name2, F_Ext, nType, F_DateTime ) ;
    	    VALUES (  A_Files[ I, 1 ], A_Files[ I, 1 ], "    ", 5, "DIR"  )
    
    	  REPLACE F_String WITH F_DateTime
    	  IF TmpFil->F_Name = ".."
    	     REPLACE nType WITH 3
    	  ENDIF
    	 ENDIF
    	ENDFOR
    	
    	cExt3 = cExt
    	
    	DO WHILE NOT EMPTY( cExt3 )
    		j = AT( ";", cExt3  )
    		IF j # 0 
    		   cExt = LEFT( cExt3, j-1 )
    		   cExt3 =  SUBSTR( cExt3, j+ 1 )
    		ELSE
    		   cExt = cExt3
    		   cExt3 = ""   
    		ENDIF
    		
    		nF = ADIR( a_Files, cExt )
    
    		FOR i = 1 TO nF
    		  A_Files( I, 1 ) = LOWER( A_Files[ I, 1 ] )
    		  INSERT INTO "TmpFil" ( F_Name, F_Ext, nType, F_DateTime, F_Size ) ;
    		     VALUES (  LEFT(  A_Files( I, 1 ), -1+ RAT( ".", A_Files[ I, 1 ] ) ),;
    		        SUBSTR(  A_Files( I, 1 ), RAT( ".", A_Files[ I, 1 ] ) ),;
    		        10,  PADR( DTOC( A_Files( I, 3 ) ),10 ) + " "+;
    		             A_Files( I, 4 ),  STR( A_Files( I, 2 ), 10 ) + " b" ;
    		      )
    		  REPLACE F_Name2  WITH ALLT( F_Name ) + ALLT(F_Ext)
    		  REPLACE F_String WITH F_DateTime + F_Size      
    
    		ENDFOR
    		
    	ENDDO
    	GO TOP
    	
    	.FilerW.Refresh()
    	
    	IF NOT EMPTY( cSubDir )  && if was CD .. 
    	                         &&  search for last selected subdir item 
    	   **msg( "loca "+ cSubDir )
    	   LOCATE FOR F_Name = cSubDir 
    	ENDIF
    
    ENDWITH     
    RETURN .T.
    
    *********************
    
    
  ENDPROC
  
  PROCEDURE getdirectory
    LPARAMETERS cDirName, cSubDirName, nDepth
      
      LOCAL a_Files, i, nF, cCurDir, cF
      LOCAL nSubD_Rec1st, nSubD_RecLast, nRecCur && subdir recno's
      DIMENSION a_Files[ 1, 7 ]
    
      *-------------------- analyzing parameters ------------------------------------
    *!*	  msg( "!!"+TRANS(nDepth) + " cSub "+ TRANS(cSubDirName) +" dir "+ TRANS(cDirName) )
    *!*	  msg( "!!curdir "+ FULLPATH( CURDIR() ) )
      IF lExit  
         RETURN .F.
      ENDIF
      
      cCurDir = FULLPATH( CURDIR() )
      IF TYPE( "cSubDirName" ) # "C" OR EMPTY( cSubDirName )
         cSubDirName = ""
      ENDIF
      cSubDirName = ALLT( cSubDirName )
    
      IF TYPE( "cDirName" ) # "C" OR EMPTY( cDirName )
         cDirName = cCurDir        && FULLPATH( CURDIR() )
      ENDIF
      cDirName = ALLT( cDirName )
      
        IF NOT INLIST( RIGHT( cDirName, 1 ) , "\", "/" )
            cDirName = cDirName + "\"
        ENDIF
        
        IF EMPTY( cSubDirName ) AND ;
           NOT FULLPATH( cDirName ) == FULLPATH( ThisFormSet.cCurDir )
           
           cSubDirName = cDirName
        ENDIF
        IF NOT EMPTY( cSubDirName ) AND NOT INLIST( RIGHT( cSubDirName, 1 ) , "\", "/" )
            cSubDirName = cSubDirName + "\"
        ENDIF
        
        *----------------- checks, or subdirectory valid
        IF NOT FULLPATH( cSubDirName ) == FULLPATH(CURDIR())
    	     DO WHILE .T.
    
        	     ThisFormSet.IsIgnoreErrors = .T.
        	     cF = FULLPATH( cSubDirName )
    	   	     CD (cSubDirName)
    		     ThisFormSet.IsIgnoreErrors = .F.
    		     IF cF # FULLPATH(CURDIR())
    		        nRet = MessageBox( "Can't read directory: "+CHR(13)+;
    		                    FULLPATH( cSubDirName )+ CHR(13)+;
    		                    "Tray again ?", 2 ) 
    		        DO CASE
    		          CASE nRet = 5       && Ignore
    		              RETURN .T.
    		          CASE nRet = 4       && Retry
    		              LOOP
    		        ENDCASE          
    		        RETURN .F. && .F.
    		     ENDIF
    		     EXIT
    		 ENDDO
    		 
    *!*	     ELSE
    *!*	       msg( "dows check subdi " + cSubDirName + " wh "+ CURDIR() )
    	 ENDIF
      
      IF TYPE( "nDepth" ) # "N" OR nDepth <= 0
         nDepth = 0
         ThisFormSet.nCounter = 1000   && max subdirectories ....
         ThisFormSet.frmSearch.Show()
      ENDIF 
      
      ThisFormSet.nCounter = ThisFormSet.nCounter - 1
      IF (ThisFormSet.frmSearch.txtDepth.Value > 0 AND ;
          nDepth > ThisFormSet.frmSearch.txtDepth.Value )  ;
            OR nDepth > 20 OR ThisFormSet.nCounter <= 0
                          && if maximum search depth reached
         RETURN .T.
      ENDIF
      
        cCurDir = FULLPATH( CURDIR() )
        
        ThisFormSet.frmSearch.lblFile.Caption = "Dir: "+ ( cSubDirName )
        ThisFormSet.frmSearch.Show()
      **  ThisFormSet.frmSearch.lblFile.Refresh()
         
    *!*		    msg( "##"+TRANS(nDepth) + " cSub "+ cSubDirName +" dir "+ cDirName )
    *!*		    msg( "##curdir "+ FULLPATH( CURDIR() ) )
    	
    	*---------------------- reads current directory subdirectories --------------
    	nF = ADIR( a_Files, "", "D" )
        nSubD_Rec1st = 0
        
    	FOR i = 1 TO nF
    	 
    	 IF NOT EMPTY( cSubDirName ) AND ;
    	    ( ALLT( A_Files[ I, 1 ] ) == ".." OR ALLT( A_Files[ I, 1 ] ) == "." )
    	    LOOP
    	 ENDIF
    	 
    	 IF A_Files[ I, 1 ] = UPPER( A_Files[ I, 1 ] )
    	    A_Files[ I, 1 ] = PROPER( A_Files[ I, 1 ] )
    	 ENDIF
    	 
    	  *------------- insert subdirectory item
    	 INSERT INTO "TmpFil" ( F_Name, F_Name2, F_Ext, nType, F_DateTime ) ;
    	    VALUES (  cSubDirName + A_Files[ I, 1 ],;
    	       cSubDirName + A_Files[ I, 1 ], "    ", 5, "DIR"  )
    
    	  REPLACE F_String WITH F_DateTime
    
          IF nSubD_Rec1st = 0
             nSubD_Rec1st = RECNO( "TmpFil" )
          ENDIF
    *!*	      msg( "rado sub "+ ALLT(TmpFil->F_Name) + " re "+ TRANS( RECNO() )  )
          
    	ENDFOR
    	
    	nSubD_RecLast = RECNO()
        CD (cCurDir)
        
        *--------------------- gets files extension (filter) ---------------------------------
    	** cExt3 = ThisFormSet.cExt
    	cExt3 = ThisFormSet.frmSearch.cboMask.DisplayValue
    	
    *!*		msg( "get "+ cExt3+" "+ cCurDir )
    	
    	*-------------- extensions cycle -----------------------------------
    	DO WHILE NOT EMPTY( cExt3 )
    		j = AT( ";", cExt3  )
    		IF j # 0 
    		   cExt = LEFT( cExt3, j-1 )
    		   cExt3 =  SUBSTR( cExt3, j+ 1 )
    		ELSE
    		   cExt = cExt3
    		   cExt3 = ""   
    		ENDIF
    		
    		*-------------- reads current directory files by extension -----------
    		nF = ADIR( a_Files, cExt )
    
    		FOR i = 1 TO nF
    		  A_Files( I, 1 ) = PROPER( A_Files[ I, 1 ] )
    		  
    		  *------------- insert found file 
    		  INSERT INTO "TmpFil" ( F_Name, F_Ext, nType, F_DateTime, F_Size ) ;
    		     VALUES (  cSubDirName + LEFT(  A_Files( I, 1 ), -1+ RAT( ".", A_Files[ I, 1 ] ) ),;
    		        SUBSTR(  A_Files( I, 1 ), RAT( ".", A_Files[ I, 1 ] ) ),;
    		        10,  PADR( DTOC( A_Files[ I, 3 ] ),10 ) + " "+;
    		             A_Files( I, 4 ),  STR( A_Files( I, 2 ), 10 ) + " b" ;
    		      )
    		      
    		  REPLACE F_Name2  WITH ALLT( F_Name ) + ALLT(F_Ext)
    		  REPLACE F_String WITH F_DateTime + F_Size      
    
    		ENDFOR
    		
    	ENDDO
    
       
        *-------------------- recursive function call of subdirectories
    	SELECT TmpFil
    	IF nSubD_Rec1st # 0   && if found subdirectories (RECNO # 0)
    	
           CD (cCurDir)
           GO RECORD (nSubD_Rec1st)
           DO WHILE NOT EOF() 
              nRecCur = RECNO()
              IF TmpFil->nType # 5 OR INLIST( TmpFil->F_Name, "..", "." ) 
                 SKIP 1
                 LOOP
              ENDIF
              
              CD (cDirName)
              **CD (ALLT(TmpFil->F_Name) )
    
    	 	  lRet = ThisFormSet.GetDirectory( cDirName,;
    	 	                          ALLT(TmpFil->F_Name)+"\", nDepth + 1 )
              ThisFormSet.frmSearch.lblFile.Caption = "Dir: "+ ( cSubDirName )
              IF NOT lRet OR lExit
                 EXIT
              ENDIF
              
              GO RECORD (nRecCur)
              IF RECNO() >= nSubD_RecLast
                 EXIT
              ENDIF
              SKIP 1       
           ENDDO
        ENDIF
        CD (cCurDir)
    
    RETURN .T.
    
    
    *!*		     IF (ThisFormset.frmSearch.chkLookSubdirs.Value = 1 )
    *!*		        CD  ALLT(A_Files[ i, 1 ])
    *!*	   	        IF CURDIR() # cCurDir
    *!*	     	       ThisFormSet.GetDirectory( cSubDirName +;
    *!*	     	                          ALLT(A_Files[ i, 1 ])+"\" )
    *!*	           	 ENDIF
    *!*		         CD (cCurDir)
    *!*		      ENDIF
    	      
  ENDPROC
  
  PROCEDURE getprivstr
    LPARAMETERS cSection, cKey, cDefault, cBuffer, ;
                nBufferSize, cINIFile
    
    DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
      String cSection, String cKey, String cDefault, String @cBuffer, ;
      Integer nBufferSize, String cINIFile
    
    RETURN GetPrivStr( cSection, cKey, cDefault, cBuffer, ;
                       nBufferSize, cINIFile )
    
  ENDPROC
  
  PROCEDURE gridproperties
    LPARAMETERS lnMode
    
    WITH This                                     && formos GRID'o savybiu nustatymas
       DO CASE
         CASE TYPE( "lnMode" ) = "N" AND lnMode = 1  && Find mode
         
    	     .nGridColumnsCount = 4                                           && GRID'o stulpeliu skaicius
    	     DIMENSION .aGridProperties[.nGridColumnsCount, 10 ]              && GRID'o savybiu masyvas
    
    		    .aGridProperties[ 1, 1] = "F_Name2"                           && stulpelio pavadinimas
    		    .aGridProperties[ 1, 2] = "ALLT(TmpFil.F_Name2)"                    && RecordSource
    		    .aGridProperties[ 1, 3] = 28                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 1, 4] = "File"                              && stulpelio hederis
    		    .aGridProperties[ 1, 5] = 0                                   && stulpelio reiksmiu islyginimas
    
    		    .aGridProperties[ 2, 1] = "F_LineNum"                         && stulpelio pavadinimas
    		    .aGridProperties[ 2, 2] = "ALLT(TmpFil.F_Object)"
    		    .aGridProperties[ 2, 3] = 25                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 2, 4] = "Line,Func"          
    		    .aGridProperties[ 2, 5] = 0                                   && stulpelio reiksmiu islyginimas
    
    		    .aGridProperties[ 3, 1] = "F_String"                          && stulpelio pavadinimas
    		    .aGridProperties[ 3, 2] = "ALLT(TmpFil.F_String)"
    		    .aGridProperties[ 3, 3] = 85                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 3, 4] = "String"          
    		    .aGridProperties[ 3, 5] = 0                                   && stulpelio reiksmiu islyginimas
    
    		    .aGridProperties[ 4, 1] = "F_DateTime"                          && stulpelio pavadinimas
    		    .aGridProperties[ 4, 2] = "ALLT(TmpFil.F_DateTime)"
    		    .aGridProperties[ 4, 3] = 85                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 4, 4] = "Date time"          
    		    .aGridProperties[ 4, 5] = 0                                   && stulpelio reiksmiu islyginimas
         
         OTHERWISE
            
    	     .nGridColumnsCount = 3                                           && GRID'o stulpeliu skaicius
    	     DIMENSION .aGridProperties[.nGridColumnsCount, 10 ]              && GRID'o savybiu masyvas
    
    		    .aGridProperties[ 1, 1] = "F_Name"                            && stulpelio pavadinimas
    		    .aGridProperties[ 1, 2] = "ALLT(TmpFil.F_Name2)"                    && RecordSource
    		    .aGridProperties[ 1, 3] = 25                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 1, 4] = "File"                              && stulpelio hederis
    		    .aGridProperties[ 1, 5] = 0                                   && stulpelio reiksmiu islyginimas
    
    		    .aGridProperties[ 2, 1] = "F_DateTime"                        && stulpelio pavadinimas
    		    .aGridProperties[ 2, 2] = "TmpFil.F_DateTime"
    		    .aGridProperties[ 2, 3] = 20                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 2, 4] = "Date time"          
    		    .aGridProperties[ 2, 5] = 0                                   && stulpelio reiksmiu islyginimas
    
    		    .aGridProperties[ 3, 1] = "F_Size"                            && stulpelio pavadinimas
    		    .aGridProperties[ 3, 2] = "TmpFil.F_Size"
    		    .aGridProperties[ 3, 3] = 10                                  && stulpelio plotis simboliais
    		    .aGridProperties[ 3, 4] = "Size"                
    		    .aGridProperties[ 3, 5] = 1                                   && stulpelio reiksmiu islyginimas
    
        ENDCASE
    ENDWITH
    
  ENDPROC
  
  PROCEDURE Init
    * FilerWin::Init 
    
    ThisFormSet.uRetVal = .T. 
    DO FSet_Init WITH ThisFormSet IN (ThisFormSet.HookSet) 
    RETURN ThisFormSet.uRetVal 
    
    
    
  ENDPROC
  
  PROCEDURE Load
    * FilerWin::Load 
    
    ASSERT This.HookSet = [FilerHook.prg] 
    This.uRetVal = .T.
    DO FSet_Load WITH This IN (This.HookSet)
    RETURN This.uRetVal 
    
    
  ENDPROC
  
  PROCEDURE refreshform
    LPARAMETERS lForm
    
    WITH lForm
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
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Name, tcEntry )
    lcBuffer = SPACE(20) + CHR(0)
    lcOldError = ON('ERROR')
    
    *-- Read the window position from the INI file
    IF ThisFormSet.GetPrivStr("WindowPositions", lcEntry, "", ;
                   @lcBuffer, LEN(lcBuffer), ;
                   This.cIniDir + This.cIniFileName ) <= 0
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
    
  ENDPROC
  
  PROCEDURE savewindowpos
    LPARAMETERS tcEntry
    
    LOCAL lcValue, lcEntry
    
    lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Name, tcEntry )
    lcValue = ALLT(STR(MAX(This.Top, 0))) + ',' + ;
              ALLT(STR(MAX(This.Left, 0))) 
    IF This.BorderStyle = 3          
       lcValue = lcValue + ',' + ;
              ALLT(STR(MAX(This.Height, 0))) + ',' + ;
              ALLT(STR(MAX(This.Width, 0)))
    ENDIF
             
    *-- Write the entry to the INI file
    ThisFormSet.WritePrivStr("WindowPositions", lcEntry, ;
                  lcValue, This.cIniDir + This.cIniFileName)
    RETURN .T.               
    
    
  ENDPROC
  
  PROCEDURE searchform
    
    WITH ThisFormSet
    
    
      IF NOT USED( "TmpForm" ) OR  TYPE( "cSrchStr" ) # "C" 
         RETURN .F.
      ENDIF
    
    	  *----------- here is search in text file --------------------------
          cFunc = ALLT( TmpPrg->F_Name )
          nI = RAT( "\", cFunc )
          IF nI > 0
             cFunc = SUBSTR( cFunc, nI + 1 )
          ENDIF
          IF UPPER( cFunc ) = cFunc
             cFunc = PROPER( cFunc )
          ENDIF
          IF ALLT( TmpPrg->F_Ext ) = ".SCX" 
             cFunc = "Form "+ cFunc
          ENDIF
          IF ALLT( TmpPrg->F_Ext ) = ".VCX" 
             cFunc = "Class "+ cFunc
          ENDIF
    
      
      *-------------
      SELECT TmpForm
      GO TOP
    
        *Form, Class :
        *ObjName  Class ClassLoc  BaseClass Parent  Properties  Methods 
        *Reserved3 - comments Kodas <dd a komentarai> <eol>
        *Reserved7  - comments bendrai
       cEOL = " "+CHR(182)+" "     && ENd of Line
    
        IF TYPE( "TmpForm.ObjName" ) = "M"  AND ;
           TYPE( "TmpForm.Parent" ) = "M" AND ;
           TYPE( "TmpForm.Properties" ) = "M" AND ;
           TYPE( "TmpForm.Methods" ) = "M" AND ;
           TYPE( "TmpForm.BaseClass" ) = "M"
           *----- if this is Form or Class file ---------------------------------
    
          DO WHILE NOT EOF() AND NOT lExit
        
           cObj  = ALLT( TmpForm.ObjName )
           cPar  = ALLT( TmpForm.Parent )
           cBas  = ALLT( TmpForm.BaseClass )
           cProp = ALLT( TmpForm.Properties )
           cMeth = ALLT( TmpForm.Methods )
           
           
    *!*	       *-------------------- Object -----------------------------
    *!*	       cStr  = cObj
    *!*	       cStr2 = IIF( IgnoreCase, UPPER( cStr ), cStr )
    *!*		   IF cSrchStr $ cStr2
    
    *!*		         nFound = nFound + 1
    *!*	        	 .frmSearch.lblFound.Caption = " Found : "+ STR( nFound, 5 )
    
    *!*		         SELECT TmpFil
    *!*		         INSERT INTO "TmpFil" ( F_Name, F_Ext, nType ) ;
    *!*		            VALUES( TmpPrg->F_Name, TmpPrg->F_Ext, TmpPrg->nType ;
    *!*		                    )
    *!*		         REPLACE F_Name2  WITH ALLT(F_Name) + ALLT(F_Ext)
    *!*		         REPLACE nLine    WITH RECNO( "TmpForm" )
    *!*		         REPLACE F_String WITH "Object "+cStr + "Par: "+ cPar
    *!*		         REPLACE F_Object WITH TRANS( nLine ) + " Frm: "+ cFunc
    *!*		         
    *!*		         .FilerW.Refresh()  
    *!*		         
    *!*		   ENDIF
    
           *-------------------- properties -----------------------------
           cStr  = cProp
           cStr2 = IIF( IgnoreCase, UPPER( cStr ), cStr )
    	   IF cSrchStr $ cStr2         && if found value
    
                 ** ? strtran( a, CHR(13)+CHR(10), " \ " )             
                 
                 nLineMeth = 0         &&TODO
                 nI1 = AT( cSrchStr, cStr2 )  && Found value position
                 nI1 = IIF( nI1 = 0, 1, nI1 )
                 IF nI1 > 3
                   c2 =  LEFT( cStr2, nI1 )
                   nI2 = RAT( CHR(13)+CHR(10), c2 )  && Begin of Line positin
                 ENDIF
                 nI2 = IIF( nI1 <= 3 AND nI2 <= 0, 1, nI2+2 )
                 
                 cStrP = ALLT( SUBSTR( cStr, nI2, 200 ) )
                 cStrP = STRTRAN( cStrP, CHR(13)+CHR(10), cEOL )
                 cStrP = STRTRAN( cStrP, CHR(9), "    " )
                 IF RIGHT( cStrP, 1 ) = "\" 
                    cStrP = LEFT( cStrP, LEN( cStrP ) - 1 )
                 ENDIF
                    
    	         nFound = nFound + 1
            	 .frmSearch.lblFound.Caption = " Found : "+ STR( nFound, 5 )
    
    	         SELECT TmpFil
    	         INSERT INTO "TmpFil" ( F_Name, F_Ext, nType ) ;
    	            VALUES( TmpPrg->F_Name, TmpPrg->F_Ext, TmpPrg->nType ;
    	                    )
    	         REPLACE F_Name2  WITH ALLT(F_Name) + ALLT(F_Ext),;
    	                 nLine    WITH nLineMeth,;
    	                 F_DateTime WITH TmpPrg->F_DateTime
    
    	         REPLACE F_String WITH CHR(187)+"Property: "+cStrP
    	                          && CHR(149) - simbolis taskelis
    	                          && CHR(168) - didelis O
    	                          && CHR(187)+  >> simbolis
                 REPLACE F_Object WITH ;
    	                        cObj +;
    	                          IIF( NOT EMPTY( cPar), " p: "+ cPar, "" )
    	                          
    	                    &&      " c:" + cBas + " " +
    	         
    	         .FilerW.Refresh()  
    	   ENDIF
    	   
    
           *-------------------- method -----------------------------
           cStr  = cMeth
           cStr2 = IIF( IgnoreCase, UPPER( cStr ), cStr )
           cMethod = "<>"
           nLineMeth = 0 &&TODO
     
           DO WHILE NOT EMPTY( cStr2 ) AND NOT lExit
           
       	     IF NOT cSrchStr $ cStr2
       	        EXIT
       	     ENDIF
            
                 ** ? strtran( a, CHR(13)+CHR(10), " \ " )             
                 
                 nI1 = AT( cSrchStr, cStr2 )
                 nI1 = IIF( nI1 = 0, 1, nI1 )
                 IF nI1 > 3
                   c2 =  LEFT( cStr2, nI1 )
                   nI2 = RAT( CHR(13)+CHR(10), c2 )
                   nIMet = RAT( "PROCEDURE ", c2 )
                   IF nIMet # 0
                      cStr4 = SUBSTR( c2, nIMet + LEN( "PROCEDURE " ), 80 )
                      cStr4 = ALLT( cStr4 )
                      nIMet2 = AT( CHR(13), cStr4 )
                      IF nIMet2 = 0
                         nIMet2 = AT( " ", cStr4 )
                      ENDIF
                      IF nIMet2 > 2
                         cStr4 = ALLT( LEFT( cStr4, nIMet2-1 )) 
                         cMethod = LOWER( cStr4 )
                      ELSE
                        IF cMethod = "<>"
                         *  msg( cObj + " nera CHR(13) \" )
                          * msg( cStr4 )
                        ENDIF
                      ENDIF
                   ELSE
                     IF cMethod = "<>"
                      *  msg( cObj +  " nerado PROC \" )
                       * msg( c2 )
                     ENDIF
                   ENDIF
                   
                 ENDIF
                 nI2 = IIF( nI1 <= 3 AND nI2 <= 0, 1, nI2+2 )
                 
                 cStrP = ALLT( SUBSTR( cStr, nI2, 200 ) )
                 cStr2 = SUBSTR( cStr2, nI1 + 1 )
                 cStr = SUBSTR( cStr, nI1 + 1 )
                 
                 cStrP = STRTRAN( cStrP, CHR(13)+CHR(10), cEOL )
                 cStrP = STRTRAN( cStrP, CHR(9), "    " )
                 IF RIGHT( cStrP, 1 ) = "\" 
                    cStrP = LEFT( cStrP, LEN( cStrP ) - 1 )
                 ENDIF
    
                 nLineMeth = 0 &&TODO
                    
    	         nFound = nFound + 1
            	 .frmSearch.lblFound.Caption = " Found : "+ STR( nFound, 5 )
    
    	         SELECT TmpFil
    	         INSERT INTO "TmpFil" ( F_Name, F_Ext, nType ) ;
    	            VALUES( TmpPrg->F_Name, TmpPrg->F_Ext, TmpPrg->nType ;
    	                    )
    	         REPLACE F_Name2  WITH ALLT(F_Name) + ALLT(F_Ext),;
    	                 nLine    WITH nLineMeth,;
    	                 F_DateTime WITH TmpPrg->F_DateTime
    	                 
                 REPLACE F_String WITH cStrP
    	         IF cMethod = "<>"        
       	           REPLACE F_Object WITH TRANS( nLine ) + ": "+ cMeth + " Obj: "+ cObj + " p: "+ cPar
    	           **REPLACE F_Object WITH TRANS( nLine ) + " Obj: "+ cObj + " p: "+ cPar
    	         ELSE
    	           IF NOT EMPTY( cPar ) 
    	              IF RIGHT( DBF(), 4 ) = ".VCX" 
    	                cMethod = cPar +;
    	                      "." + ALLT(cObj)+ "." + cMethod
    	              ELSE
    		              nIPar1 = AT( ".", cPar )
    		              IF nIPar1 # 0
    		                cMethod = LOWER( SUBSTR(cPar,nIPar1+1) ) +;
    		                      "." + ALLT(cObj)+ "." + cMethod
    		              ENDIF
    	              ENDIF
    	           ENDIF
    	           
      	           REPLACE F_Object WITH TRANS( nLine ) + ": "+ cMethod + "()"
      	           REPLACE F_Method WITH cMethod
    	         ENDIF
    	         
    	         .FilerW.Refresh()  
    	         
    	   ENDDO
    	   
    	   SELECT TmpForm      
           SKIP 1 
         ENDDO
    	   
       ELSE
           *--------- other file -----
          * DO WHILE
         *  msg( "Not search " + DBF( "TmpForm" ) )
           
       ENDIF   
    
    ENDWITH
    
    CLEAR TYPEAHEAD
    RETURN .T.
  ENDPROC
  
  PROCEDURE searchtext
    *** must egzist  cSrchStr ----
    
      IF TYPE( "cSrchStr" ) # "C" 
         RETURN .F.
      ENDIF
    
    WITH ThisFormSet
    
    	  *----------- here is search in text file --------------------------
    	  nALine = 0
          cFunc = ALLT( TmpPrg->F_Name )
          nI = RAT( "\", cFunc )
          IF nI > 0
             cFunc = SUBSTR( cFunc, nI + 1 )
          ENDIF
          IF UPPER( cFunc ) = cFunc
             cFunc = PROPER( cFunc )
          ENDIF
    	  
    	  DO WHILE NOT FEOF( Handle ) AND NOT lExit
    	      nALine = nALine + 1
    	      cStr = FGETS( Handle, 255 )   
    	      cStr2 = ""
    	      cStr2 = IIF( IgnoreCase, UPPER( cStr ), cStr )
    	      
    	      cS2 = UPPER( cStr )
    
    	      IF "FUNC" $ cS2 AND EMPTY( LEFT( cS2, AT("FUNC",cS2 )-1 ) ) ;
    	         AND NOT "GET" $ cS2 AND ;
    	         NOT "*R" $ cS2 AND NOT '"BZ' $ cS2
    	        nI = AT( "FUNC", cS2 )
    	        c1 = IIF( nI=0, "", SUBSTR( cS2, nI + 1 ) )
    	        nI = AT( " ", c1 )
    	        IF nI # 0 AND NOT EMPTY( ALLT( SUBSTR( c1, nI+1, 15 ) )  )
    	              cFunc = ( ALLT( SUBSTR( c1, nI+1, 35 ) ) )
    	        ENDIF
    		      IF UPPER( cFunc ) = cFunc
    		         cFunc = PROPER( cFunc )     
    		      ENDIF
    	      ELSE
    	        IF "PROCEDU" $ cS2 AND EMPTY( LEFT( cS2, AT("PROC",cS2 )-1 ) ) 
    	        
    	           nI = AT( "PROCE", cS2 )
    	           c1 = IIF( nI=0, "", SUBSTR( cS2, nI + 1 ) )
    	           nI = AT( " ", c1 )
    	           IF nI # 0 AND NOT EMPTY( ALLT( SUBSTR( c1, nI+1, 15 ) )  )
    	              cFunc = ( ALLT( SUBSTR( c1, nI+1, 35 ) ) )
    	           ENDIF
    		      IF UPPER( cFunc ) = cFunc
    		         cFunc = PROPER( cFunc )
     		      ENDIF
    	        ENDIF 
    	      ENDIF
    
      	      
    	      IF cSrchStr $ cStr2      && if string found
    	      
    	         nFound = nFound + 1
            	 .frmSearch.lblFound.Caption = " Found : "+ STR( nFound, 5 )
    *!*	        	              PADR( ALLT(TmpPrg->F_Name) +;
    *!*		                         TmpPrg->F_Ext, 12 ) + " / "+ 
    
    	         SELECT TmpFil
    	         INSERT INTO "TmpFil" ( F_Name, F_Ext, nType ) ;
    	            VALUES( TmpPrg->F_Name, TmpPrg->F_Ext, TmpPrg->nType ;
    	                    )
                 cStr = STRTRAN( cStr, CHR(9), "    " )	         
    	         REPLACE F_Name2  WITH ALLT(F_Name) + ALLT(F_Ext),;
    	                 nLine    WITH nALine ,;
    	                 F_String WITH cStr,;
    	                 F_DateTime WITH TmpPrg->F_DateTime,;
    	                 F_Object   WITH ALLT(STR( nALine, 6 ))+": "+ cFunc
    	         
    	         .FilerW.Refresh()  && Show()
    	        ** .frmSearch.Show()
    	                               
    	      ENDIF  
    	  ENDDO
    
    	  RETURN .T.
    	  
    ENDWITH
  ENDPROC
  
  PROCEDURE Unload
    SET PROCEDURE TO
    SET CLASSLIB TO
    
    IF USED( "TmpFil" )
       USE IN TmpFil
    ENDIF
    RETURN .T.
  ENDPROC
  
  PROCEDURE view
    LPARAMETERS cFile, nLine, cMethod
    
    cFile = ALLT( cFile )
    IF NOT FILE( cFile )
       RETURN .F.
    ENDIF
    cExt = UPPER( RIGHT( cFile, 4 ) )
    IF INLIST( cExt, ".VCX", ".SCX" )
       This.ViewForm( cFile, nLine, cMethod )
       RETURN .T.
    ENDIF
    nHand = FOPEN( cFile )
    IF nHand <= 1 
       RETURN .F.
    ENDIF
    nMax = 3000
    isEmp = .T.
    ThisFormSet.cViewFile = cFile
    ThisFormset.frmView.Caption = "File: "+ cFile
    ThisFormset.frmView.txtView.Value = ""
    DO WHILE NOT FEOF( nHand ) AND nMax > 0
       nMax = nMax - 1
       cStr = FGETS( nHand, 200 )
       IF isEmp
          ThisFormset.frmView.txtView.Value = cStr
          isEmp = .F.
       ELSE
         ThisFormset.frmView.txtView.Value = ;
           ThisFormset.frmView.txtView.Value + CHR(13)+CHR(10)+;
           cStr
       ENDIF   
    ENDDO
    
    RETURN .T.
    
    
  ENDPROC
  
  PROCEDURE viewform
    LPARAMETERS cFile, nLine, cMethod
    
  ENDPROC
  
  PROCEDURE writeprivstr
    LPARAMETERS cSection, cKey, cValue, cINIFile
    
    DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
      String cSection, String cKey, String cValue, String cINIFile
    
    
    RETURN  WritePrivStr( cSection, cKey, cValue, cINIFile )
    
  ENDPROC
  
  PROCEDURE filerw.Activate
    ON KEY LABEL Ctrl+F  _SCREEN.ActiveForm.cmdFind.Click()
    
    ThisForm.grdFiles.SetFocus()
    ThisFormSet.frmSearch.Hide()
    IF NOT EMPTY( ThisFormSet.cOldFilerCaption ) AND ;
       NOT ThisFormSet.cOldFilerCaption == ThisFormSet.FilerW.Caption
       ThisFormSet.FilerW.Caption = ThisFormSet.cOldFilerCaption 
    ENDIF
    
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE filerw.Deactivate
    ON KEY LABEL Ctrl+F 
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE filerw.Destroy
    ON KEY LABEL Ctrl+F
    ThisFormSet.Release()
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE filerw.Init
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE filerw.KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    
    *** msg( "yra "+ Str( nkeycode, 3 )+" s"+STR( nShiftAltCtrl,1 )  )
    *!*	IF nKeyCode = 6 AND nShiftAltCtrl = 2
    *!*	   NODEFAULT
    *!*	   ThisForm.cmdFind.Click()
    *!*	   RETURN .T.
    *!*	ENDIF
    IF TYPE( "ThisForm.ActiveControl.Name" ) = "C"
      DO CASE 
       CASE ThisForm.ActiveControl.Name = "grdFiles" 
       
    	   IF nShiftAltCtrl = 0 AND ;
    	        BETWEEN( nKeyCode, 65, 122 )
    	      NODEFAULT
    	      RETURN .T.
    	   ENDIF
       
       CASE ThisForm.ActiveControl.BaseClass = "Combobox" AND ;
            nShiftAltCtrl = 0 AND ;
            INLIST( nKeyCode, 13 )
    
          NODEFAULT
          ThisForm.grdFiles.SetFocus()
          RETURN .T.
          
       ENDCASE
    ENDIF
    
    * RETURN DODEFAULT( nKeyCode, nShiftAltCtrl )
    RETURN .T. 
    
  ENDPROC
  
  PROCEDURE filerw.Show
    LPARAMETERS nStyle
    
    DODEFAULT()
    IF This.Visible
       ThisFormset.FilerW.chkCode.Value = 1
    ENDIF
  ENDPROC
  
  PROCEDURE filerw.txtsearch.LostFocus
    IF LASTKEY()=13
        ThisForm.grdFiles.SetFocus()
    ENDIF
  ENDPROC
  
  PROCEDURE filerw.cmdfind.Click
    ThisFormSet.Find()
  ENDPROC
  
  PROCEDURE filerw.cmdedit.Click
    ThisFormSet.Edit()
  ENDPROC
  
  PROCEDURE filerw.cmdbrowf.Click
    * cmdBrowF 
    
    DO FSet_BrowF WITH ThisFormSet, This IN (ThisFormSet.HookSet) 
    
    
  ENDPROC
  
  PROCEDURE filerw.cmdsusp.Click
    SUSPEND
  ENDPROC
  
  PROCEDURE filerw.cmdexit.Click
    WITH ThisFormSet
    IF ThisForm.QueryUnload()
       IF .nMode = 0
          .Release()
       ELSE
          WITH .FilerW
            STORE .T. TO .cboMask.Enabled, .lblMask.Enabled,;
                        .cboCurDir.Enabled, .lblCurDir.Enabled, .cmdChDir.Enabled
          ENDWITH
       
          .FileList()
          .FilerW.grdFiles.SetFocus()
       ENDIF
    ENDIF
    ENDWITH
  ENDPROC
  
  PROCEDURE filerw.chbname.InteractiveChange
    NODEFAULT
    IF ThisFormSet.nMode # 1              && normal mode
    	SELECT TmpFil
    	SET ORDER TO TAG By_Name          && By_Ext
    	WITH ThisFormSet
    	   ThisForm.chbExt.Value = 0
    	   ThisForm.chbName.Value = 1
    	   .GetDir( .cExt, .F. )
    	ENDWITH
    ELSE
    	SET ORDER TO TAG By_Name          && By_Ext
    	WITH ThisFormSet
    	   ThisForm.chbExt.Value = 0
    	   ThisForm.chbName.Value = 1
    	   ThisForm.Refresh()
    	ENDWITH
    ENDIF	
    
  ENDPROC
  
  PROCEDURE filerw.chkcode.InteractiveChange
    NODEFAULT
    IF ThisFormSet.nMode # 1 && normal mode
       IF This.Value = 1 OR NOT ThisFormSet.frmView.Visible
          ThisFormSet.frmView.Show()
       ELSE
          ThisFormSet.frmView.Hide()
       ENDIF   
    ELSE
       IF This.Value = 1 OR NOT ThisFormSet.frmView.Visible
          ThisFormSet.frmView.Show()
       ELSE
          ThisFormSet.frmView.Hide()
       ENDIF   
       This.Value = IIF( ThisFormSet.frmView.Visible, 1, 0 )
    ENDIF	
    
  ENDPROC
  
  PROCEDURE filerw.chbext.InteractiveChange
    NODEFAULT
    IF ThisFormSet.nMode # 1
    	SELECT TmpFil
    	SET ORDER TO TAG By_Ext         && By_Ext
    	WITH ThisFormSet
    	   ThisForm.chbExt.Value = 1
    	   ThisForm.chbName.Value = 0
    	   .GetDir( .F., .F. )
    	ENDWITH
    ELSE
    	SELECT TmpFil
    	SET ORDER TO TAG By_Ext         && By_Ext
    	WITH ThisFormSet
    	   ThisForm.chbExt.Value = 1
    	   ThisForm.chbName.Value = 0
    	   ThisForm.Refresh()
    	ENDWITH
    ENDIF	
    
  ENDPROC
  
  PROCEDURE filerw.cbomask.Click
    ThisFormSet.GetDir( This.DisplayValue, .F. )
    
  ENDPROC
  
  PROCEDURE filerw.cbomask.LostFocus
    ThisFormSet.GetDir( This.DisplayValue, .F. )
    IF LASTKEY()=13
        ThisForm.grdFiles.SetFocus()
    ENDIF
  ENDPROC
  
  PROCEDURE filerw.cmdchdir.Click
    CD ?
    WITH This.Parent.cboCurDir
    	.Value = FULLPATH(  CURDIR() )
    	.DisplayValue = FULLPATH( CURDIR() )
        ThisFormSet.GetDir( .F., .F. )
        .SetFocus()
    ENDWITH
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE filerw.cbocurdir.Click
    ThisFormSet.GetDir( .F., .F., This.DisplayValue )
    
  ENDPROC
  
  PROCEDURE filerw.cbocurdir.LostFocus
    DODEFAULT()
    This.SetFocus()
    
    IF TYPE( "This.DisplayValue" ) = "C"
       ThisFormSet.GetDir( .F., .F., This.DisplayValue )
    ENDIF
    IF LASTKEY()=13
        ThisForm.grdFiles.SetFocus()
    ENDIF
  ENDPROC
  
  PROCEDURE filerw.cbocurdir.objectalign
    LPARAMETERS lPar1, lPar2
    
    DODEFAULT( lPar1, lPar2 )
    This.ColumnWidths =  STR( This.Width )
  ENDPROC
  
  PROCEDURE filerw.cmdclassview.Click
    IF TmpFil->nType = 10 AND ;
       INLIST( ALLT(LOWER(TmpFil->F_Ext)), ".scx",".vcx" )
        && perziuri klases koda
     	ThisFormSet.ClassView( ALLT(LOWER(TmpFil->F_Name )) +;
     	             ALLT(LOWER(TmpFil->F_Ext)) )
    ELSE
       WAIT WINDOW "Valid only for Forms or Classes"
    ENDIF
    RETURN .T.
     	
  ENDPROC
  
  PROCEDURE filerw.grdfiles.ondoubleclick
    LPARAMETERS oObj
    
    DODEFAULT( oObj )
    ThisFormSet.Edit()
  ENDPROC
  
  PROCEDURE frmsearch.Activate
    ON KEY LABEL Alt+A  _SCREEN.ActiveForm.chkAlso.SetFocus()
    ON KEY LABEL Alt+L  _SCREEN.ActiveForm.chkLookSubdirs.SetFocus()
    ON KEY LABEL Alt+M  _SCREEN.ActiveForm.cboMask.SetFocus()
    ON KEY LABEL Alt+C  _SCREEN.ActiveForm.chkCaseSens.SetFocus()
    ON KEY LABEL Alt+E  _SCREEN.ActiveForm.cboIn.SetFocus()
    
    
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE frmsearch.aftervalid
    ThisFormSet.FindMode()
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE frmsearch.cntYesNO.cmdCancel.LostFocus
    ** msg( "lastkey "+ TRANS( LASTKEY() ) )
    
    IF INLIST( LASTKEY(), 24, 9 ) 
       NODEFAULT
       ThisForm.cboString.SetFocus()
       RETURN .T.
    ENDIF
    
    DODEFAULT()
    RETURN .T. 
  ENDPROC
  
  PROCEDURE frmsearch.Deactivate
    ON KEY LABEL Alt+A
    ON KEY LABEL Alt+L
    ON KEY LABEL Alt+M  
    ON KEY LABEL Alt+C  
    ON KEY LABEL Alt+E  
    
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE frmsearch.Destroy
    
    This.Deactivate()
    RETURN DODEFAULT()
    
  ENDPROC
  
  PROCEDURE frmsearch.Hide
    This.Deactivate()
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE frmsearch.KeyPress
    LPARAMETERS nkeycode,nshiftaltctrl
    
    RETURN DODEFAULT( nkeycode, nshiftaltctrl )
  ENDPROC
  
  PROCEDURE frmsearch.QueryUnload
    This.Deactivate()
    IF This.Visible  
      This.Hide()  
      NODEFAULT
      RETURN .F.
    ENDIF
    RETURN .T.
  ENDPROC
  
  PROCEDURE frmsearch.cbostring.LostFocus
    ** msg( "Lastke" + TRANS( LASTKEY() )  )
    IF INLIST( LASTKEY(), 5, 15 )     &&ThisForm.UpKey()
       NODEFAULT
       ThisForm.cntYesNO.cmdCancel.SetFocus()
       RETURN .T.
    ENDIF
    
    ThisFormSet.cSearchStr = This.DisplayValue
    DODEFAULT()
    RETURN .T.
  ENDPROC
  
  PROCEDURE frmsearch.chklooksubdirs.InteractiveChange
    STORE (This.Value=1) TO This.Parent.lblDepth.Enabled,;
                    This.Parent.txtDepth.Enabled
  ENDPROC
  
  PROCEDURE frmsearch.chklooksubdirs.SetFocus
    DODEFAULT()
    This.Value = IIF( This.Value = 0, 1, 0 )
    This.InteractiveChange()
    
  ENDPROC
  
  PROCEDURE frmsearch.chkcasesens.SetFocus
    DODEFAULT()
    This.Value = IIF( This.Value = 0, 1, 0 )
    This.InteractiveChange()
    
  ENDPROC
  
  PROCEDURE frmsearch.cbomask.Click
    ThisFormSet.GetDir( This.DisplayValue, .F. )
    
  ENDPROC
  
  PROCEDURE frmsearch.cbomask.LostFocus
    ThisFormSet.GetDir( This.DisplayValue, .F. )
    IF LASTKEY()=13
        ThisForm.grdFiles.SetFocus()
    ENDIF
  ENDPROC
  
  PROCEDURE frmsearch.cboin.LostFocus
    ThisFormSet.cSearchStr = This.DisplayValue
    RETURN .T.
  ENDPROC
  
  PROCEDURE frmsearch.chkalso.InteractiveChange
    WITH This.Parent
      STORE (This.Value=1) TO .cboAlso.Enabled, .cmdAlso.Enabled
    ENDWITH
    
  ENDPROC
  
  PROCEDURE frmsearch.chkalso.SetFocus
    DODEFAULT()
    This.Value = IIF( This.Value = 0, 1, 0 )
    This.InteractiveChange()
    
    
    
  ENDPROC
  
  PROCEDURE frmsearch.cboalso.LostFocus
    RETURN .T.
  ENDPROC
  
  PROCEDURE frmsearch.cmdalso.Click
    CD ?
    WITH This.Parent.cboAlso
    	.Value = FULLPATH(  CURDIR() )
    	.DisplayValue = FULLPATH(  CURDIR() )
        ThisFormSet.GetDir( .F., .F. )
        .SetFocus()
    ENDWITH
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE frmsearch.cmdin.Click
    CD ?
    WITH This.Parent.cboIn
    	.Value = FULLPATH(  CURDIR() )
    	.DisplayValue = FULLPATH(  CURDIR() )
        ThisFormSet.GetDir( .F., .F. )
        .SetFocus()
    ENDWITH
    RETURN .T.
    
  ENDPROC
  
  PROCEDURE frmview.Activate
    * frmView::Active
    RETURN DODEFAULT()
  ENDPROC
  
  PROCEDURE frmview.Hide
    ThisFormset.FilerW.chkCode.Value = 0
    RETURN DODEFAULT()
    
  ENDPROC
  
  PROCEDURE frmview.QueryUnload
    *!*	IF This.Visible  
    *!*	  This.Hide()  
    *!*	  NODEFAULT
    *!*	  RETURN .F.
    *!*	ENDIF
    
    RETURN  .T.
  ENDPROC
  
  PROCEDURE frmview.cmdrefresh.Click
    IF TYPE( [TmpFil.F_Name2] ) = "C" AND ;
       NOT EMPTY( TmpFil.F_Name2 ) AND ;
       FILE( ALLT(TmpFil.F_Name2) )
       
       ThisFormSet.View( ALLT(TmpFil.F_Name2), ;
           TmpFil.nLine, TmpFil.F_Method  )
       
    ENDIF
    
  ENDPROC
  
  PROCEDURE frmview.cbofunc.LostFocus
    ** msg( "Lastke" + TRANS( LASTKEY() )  )
    IF INLIST( LASTKEY(), 5, 15 )     &&ThisForm.UpKey()
       NODEFAULT
       ThisForm.cntYesNO.cmdCancel.SetFocus()
       RETURN .T.
    ENDIF
    
    ThisFormSet.cSearchStr = This.DisplayValue
    DODEFAULT()
    RETURN .T.
  ENDPROC
  
  PROCEDURE frmview.cboobj.LostFocus
    ** msg( "Lastke" + TRANS( LASTKEY() )  )
    IF INLIST( LASTKEY(), 5, 15 )     &&ThisForm.UpKey()
       NODEFAULT
       ThisForm.cntYesNO.cmdCancel.SetFocus()
       RETURN .T.
    ENDIF
    
    ThisFormSet.cSearchStr = This.DisplayValue
    DODEFAULT()
    RETURN .T.
  ENDPROC


ENDDEFINE
*
*-- EndDefine: FilerWin
**************************************************
