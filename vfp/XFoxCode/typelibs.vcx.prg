* d:\beta\fcmd\vfpproj\xfoxcode\typelibs.vcx
**************************************************
*-- Class Library:  d:\beta\fcmd\vfpproj\xfoxcode\typelibs.vcx
**************************************************


**************************************************
*-- Class:        ints (d:\beta\fcmd\vfpproj\xfoxcode\typelibs.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\foxcode.h"
*
DEFINE CLASS ints AS form

  AlwaysOnTop = .T.
  AutoCenter = .T.
  BorderStyle = 3
  Caption = "Type Library References"
  DataSession = 2
  Desktop = .T.
  DoCreate = .T.
  HalfHeightCaption = .T.
  Height = 301
  HelpContextID = 1230986
  MaxButton = .F.
  MinButton = .F.
  Name = "ints"
  ShowTips = .T.
  Width = 626
  WindowType = 0
  cretval = .F.
  csafety = .F.
  haderror = .F.
  ldebugscripts = .F.
  uretval = .F.

  ADD OBJECT shape1 AS shape WITH ;
        Height = 30 ;
      , Left = 133 ;
      , Name = "Shape1" ;
      , SpecialEffect = 0 ;
      , Style = 3 ;
      , Top = 3 ;
      , Width = 380

  ADD OBJECT cmdclose AS commandbutton WITH ;
        Caption = "\<Select" ;
      , Default = .T. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 539 ;
      , Name = "cmdClose" ;
      , TabIndex = 8 ;
      , Top = 10 ;
      , Width = 74

  ADD OBJECT wizlabel1 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Select \<Reference:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 7 ;
      , Name = "Wizlabel1" ;
      , TabIndex = 1 ;
      , Top = 10 ;
      , Width = 88

  ADD OBJECT txtpath AS textbox WITH ;
        BorderStyle = 0 ;
      , ControlSource = "foxrefs.cfname" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 19 ;
      , Left = 139 ;
      , Name = "txtPath" ;
      , ReadOnly = .T. ;
      , SelectOnEntry = .T. ;
      , TabIndex = 10 ;
      , Top = 8 ;
      , Width = 362

  ADD OBJECT lsttypelibs AS listbox WITH ;
        ColumnCount = 2 ;
      , ColumnLines = .F. ;
      , ColumnWidths = "200,400" ;
      , FirstElement = 1 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 124 ;
      , IntegralHeight = .T. ;
      , ItemTips = .T. ;
      , Left = 5 ;
      , Name = "lstTypelibs" ;
      , NumberOfElements = 0 ;
      , RowSource = "foxrefs.cactivex,cfName" ;
      , RowSourceType = 6 ;
      , TabIndex = 2 ;
      , Top = 36 ;
      , Width = 508

  ADD OBJECT lstints AS listbox WITH ;
        ColumnCount = 0 ;
      , ColumnWidths = "" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 126 ;
      , IntegralHeight = .T. ;
      , ItemTips = .T. ;
      , Left = 419 ;
      , Name = "lstInts" ;
      , TabIndex = 4 ;
      , Top = 176 ;
      , Width = 205

  ADD OBJECT label2 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Pick \<Interface:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 419 ;
      , Name = "Label2" ;
      , TabIndex = 3 ;
      , Top = 161 ;
      , Width = 72

  ADD OBJECT cmdcancel AS commandbutton WITH ;
        Cancel = .T. ;
      , Caption = "\<Cancel" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 539 ;
      , Name = "cmdCancel" ;
      , TabIndex = 9 ;
      , Top = 37 ;
      , Width = 74

  ADD OBJECT chkfavs AS checkbox WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<Add to favorites" ;
      , Enabled = .F. ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 521 ;
      , Name = "chkFavs" ;
      , TabIndex = 5 ;
      , Top = 142 ;
      , Value = .F. ;
      , Visible = .F. ;
      , Width = 96

  ADD OBJECT label3 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "\<ProgID:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 5 ;
      , Name = "Label3" ;
      , TabIndex = 6 ;
      , Top = 255 ;
      , Width = 39

  ADD OBJECT cboprogids AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 5 ;
      , Name = "cboProgIDs" ;
      , Style = 0 ;
      , TabIndex = 7 ;
      , Top = 275 ;
      , Width = 195

  ADD OBJECT lblfilter AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "Filter:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 5 ;
      , Name = "lblFilter" ;
      , TabIndex = 1 ;
      , Top = 170 ;
      , Width = 30

  ADD OBJECT cbofilter AS combobox WITH ;
        FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 36 ;
      , Name = "cboFilter" ;
      , Style = 0 ;
      , TabIndex = 7 ;
      , Top = 166 ;
      , Width = 162

  ADD OBJECT lstprogids AS listbox WITH ;
        ColumnCount = 0 ;
      , ColumnWidths = "" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 126 ;
      , IntegralHeight = .T. ;
      , ItemTips = .T. ;
      , Left = 205 ;
      , Name = "lstProgIds" ;
      , TabIndex = 4 ;
      , Top = 176 ;
      , Width = 211

  ADD OBJECT label4 AS label WITH ;
        AutoSize = .T. ;
      , BackStyle = 0 ;
      , Caption = "ProgID list" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 205 ;
      , Name = "Label4" ;
      , TabIndex = 3 ;
      , Top = 161 ;
      , Width = 51

  
  PROCEDURE getimplementscode
    LPARAMETERS tcFileName, tcInterface, tcProgID
    
    LOCAL lcFile, loTLI, i, j, lnIntRef, cIntName, loParm, lcProgID, lotyplibobj
    LOCAL lnMemCount, lnParmCount, lnIntCount, loMember, lchelp
    
    * Check for valid file
    lcFile = tcFileName
    IF VARTYPE(lcFile)#"C" OR !FILE(lcFile)
    	RETURN ""
    ENDIF
    * Check for interface name
    lcIntName = tcInterface
    IF VARTYPE(lcIntName )#"C" OR EMPTY(lcIntName )
    	RETURN ""
    ENDIF
    * Check for optional ProgID
    lcProgID = tcProgID
    IF VARTYPE(lcProgID)#"C" OR EMPTY(lcProgID)
    	lcProgID=""
    ENDIF
    
    lotyplibobj = CreateObject("TLI.TLIApplication")
    loTLI = lotyplibobj.TypeLibInfoFromFile(lcFile)
    lnIntCount = loTLI.Interfaces.Count
    
    * TEMP
    * lcIntName = loTLI.Interfaces[1].Name
    
    IF EMPTY(lcProgID)
    	lcProgID = loTLI.ContainingFile
    ENDIF
    
    FOR i = 1 TO loTli.CoClasses.Count
    	IF loTli.CoClasses(m.i).DefaultInterface.Name = ALLTRIM(lcIntName)
    		lcProgID = loTli.Name + "." + loTli.CoClasses(m.i).Name
    	ENDIF
    ENDFOR
    
    * Find interface in typelib
    lnIntCount = loTli.Interfaces.Count
    FOR i = 1 TO lnIntCount 
    	IF UPPER(loTli.Interfaces(m.i).Name) = UPPER(lcIntName)
    		lnIntRef = m.i
    		EXIT
    	ENDIF
    ENDFOR
    
    SET TEXTMERGE ON 
    SET TEXTMERGE TO MEMVAR lcIntCode NOSHOW
    
    \<<lcIntName>> IN "<<lcProgID>>"
    \
    * Get member count of interface and loop
    lnMemCount = loTli.Interfaces(lnIntRef).Members.Count
    FOR i = 1 TO lnMemCount
    	* Check for restricted and skip
    	* -- should we also skip for hidden members???
    	loMember = loTli.Interfaces(lnIntRef).Members(m.i)
    	IF BITTEST(loMember.AttributeMask,0)
    		LOOP
    	ENDIF
    	\PROCEDURE <<lcIntName>>_
    	IF loMember.InvokeKind = 2  && INVOKE_PROPERTYGET
    		\\get_
    	ENDIF
    	IF loMember.InvokeKind = 4  && INVOKE_PROPERTYPUT
    		\\put_
    	ENDIF
    	\\<<loMember.Name>>(
    	lnParmCount = loMember.Parameters.COunt
    	FOR j = 1 TO lnParmCount
    		loParm = loMember.Parameters(m.j)		
    		IF m.j > 1
    			\\, 
    		ENDIF
    		* Need to check for reserved words which could conflict with VFP here
    		IF INLIST(UPPER(loParm.Name),"APPLICATION")
    			\\_<<loParm.Name>> AS 
    		ELSE
    			\\<<loParm.Name>> AS 
    		ENDIF
    		\\<<THIS.VarTypeToString(loParm.VarTypeInfo.VarType)>>
    		IF BITAND(loParm.flags,3) = 3
    			\\ @
    		ENDIF
    	ENDFOR
    	DO CASE
    	CASE loMember.InvokeKind = 4  && INVOKE_PROPERTYPUT
    		\\eValue AS <<THIS.VarTypeToString(loMember.ReturnType.VarType)>> @)
    	OTHERWISE
    		\\)
    		lcRetval = THIS.VarTypeToString(loMember.ReturnType.VarType)
    		IF !EMPTY(lcRetval)
    			\\ AS <<lcRetval>>
    		ENDIF
    	ENDCASE
    	lchelp = loMember.HelpString
    	IF ATC(chr(0),lchelp)>0
    		lchelp = LEFT(lchelp,ATC(CHR(0),lchelp)-1)
    	ENDIF
    	IF !EMPTY(lchelp)
    		\\;
    		\			HELPSTRING "<<lchelp>>"
    	ENDIF
    	\	* add user code here
    	\
  ENDPROC
  
  PROCEDURE Init
    
    ThisForm.lsttypelibs.ListIndex=1
    ThisForm.cboFilter.Click() 
    
    This.lstTypelibs.AddProperty([cAlignment], [1100])
    
    This.cmdCancel.AddProperty([cAlignment], [0001])
    This.cmdClose.AddProperty([cAlignment], [0001])
    This.chkFavs.AddProperty([cAlignment], [0001])
    
    This.lstInts.AddProperty([cAlignment], [0010])
    This.Label2.AddProperty([cAlignment], [0010])
    This.Label3.AddProperty([cAlignment], [0010])
    This.Label4.AddProperty([cAlignment], [0010])
    
    This.chkFavs.AddProperty([cAlignment], [0010])
    This.cboProgIDs.AddProperty([cAlignment], [0010])
    This.lstProgIDs.AddProperty([cAlignment], [0010])
    
    This.lblFilter.AddProperty([cAlignment], [0010])
    This.cboFilter.AddProperty([cAlignment], [0010])
    
    
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF nKeyCode=27
    	THISFORM.Release()
    ENDIF
  ENDPROC
  
  PROCEDURE Load
    * Ints::Load
    LOCAL lcActxDBF
    lcActxDBF = HOME() + "foxrefs.dbf"
    IF !FILE(lcActxDBF)
        RETURN .F.
    ENDIF
    SELECT 0 
    USE (lcActxDBF) AGAIN EXCLUSIVE ALIAS foxrefs
    IF !USED([foxrefs])
       ERROR [File ] + lcActxDBF + [ open error]
       RETURN .F. 
    ENDIF 
    
    IF TAGCOUNT() > 1 
       * Inteli order:
       * INDEX ON UPPER(LEFT(CFNAME,70)+LEFT(CACTIVEX,10)) TAG CFNAMEACT   
       SET ORDER TO TAG(2)
    ENDIF 
    
    ASSERT TYPE([This.lDebugscripts]) # [U] 
    DO FrmResizeLoad WITH This IN FoxCode.fxp
    
    RETURN This.uRetVal
    
  ENDPROC
  
  PROCEDURE Resize
    * Ints::Resize 
    DO FrmResize WITH This IN FoxCode.fxp
  ENDPROC
  
  PROCEDURE Unload
    RETURN THIS.cRetval
  ENDPROC
  
  PROCEDURE vartypetostring
    LPARAMETERS nType
    DO CASE
    CASE ntype = 0		&& VT_EMPTY
    	RETURN "VARIANT"
    CASE ntype = 1		&& VT_NULL
    	RETURN "NULL"
    CASE ntype = 2		&& VT_I2
    	RETURN "INTEGER"
    CASE nType = 3		&& VT_I4
    	RETURN "Number"
    CASE nType = 4		&& VT_R4
    	RETURN "Number"
    CASE nType = 5		&& VT_R8
    	RETURN "Number"
    CASE nType = 6		&& VT_CT
    	RETURN "Currency"
    CASE ntype = 7
    	RETURN "DATE"
    CASE ntype = 8
    	RETURN "STRING"
    CASE ntype = 9		&& VT_DISPATCH
    	RETURN "VARIANT"
    CASE nType = 11
    	RETURN "LOGICAL"
    CASE nType = 12		&& VT_VARIANT
    	RETURN "VARIANT"
    CASE nType = 16 	&& VT_I1
    	RETURN "NUMBER"
    CASE nType = 17 	&& VT_UI1
    	RETURN "NUMBER"
    CASE nType = 18 	&& VT_UI2
    	RETURN "NUMBER"
    CASE nType = 19 	&& VT_UI4
    	RETURN "NUMBER"
    CASE nType = 22		&& VT_INT
    	RETURN "Integer"
    CASE nType = 23		&& VT_UINT
    	RETURN "Integer"
    CASE nType = 24		&& VT_VOID
    	RETURN "VOID"
    CASE nType = 25		&& VT_HRESULT
    	RETURN "VOID"
    OTHERWISE
    	RETURN "VARIANT"
    ENDCASE
    
  ENDPROC
  
  PROCEDURE cmdclose.Click
    LOCAL lcFile, lcInterface, lcProgID, lcRetVal, loImp
    lcFile = ALLTRIM(THISFORM.txtPath.Value)
    lcInterface = ALLTRIM(THISFORM.lstInts.DisplayValue)
    lcProgID = ALLTRIM(THISFORM.cboProgIDs.DisplayValue)
    lcDesc = ""
    lcRetval = THISFORM.GetImplementsCode(lcFile , lcInterface , lcProgID)
    THISFORM.cRetval=lcRetval
    THISFORM.Release()
  ENDPROC
  
  PROCEDURE lsttypelibs.Error
    LPARAMETERS nError, cMethod, nLine
  ENDPROC
  
  PROCEDURE lsttypelibs.InteractiveChange
    LOCAL lotypelib , lotyplibobj, lcFileName, lnIntCount, i
    THISFORM.txtPath.Value=foxrefs.cfname
    lcFileName = ALLTRIM(foxrefs.cfname)
    IF !FILE(lcFileName)
    	RETURN
    ENDIF
    lotyplibobj = CreateObject("TLI.TLIApplication")
    lotypelib = lotyplibobj.TypeLibInfoFromFile(lcFileName)
    IF VARTYPE(lotypelib) #"O"
    	RETURN
    ENDIF
    lnIntCount = lotypelib.Interfaces.Count
    IF lnIntCount = 0
    	RETURN
    ENDIF
    
    THISFORM.lstInts.Clear()
    FOR i = 1 TO lnIntCount
    	IF TYPE("lotypelib.Interfaces[m.i].Name") = "C"
    		THISFORM.lstInts.AddItem(lotypelib.Interfaces[m.i].Name)
    	ENDIF
    ENDFOR
    
    THISFORM.cboProgIDs.Clear()
    ThisForm.lstProgIds.Clear() 
    lnIntCount = lotypelib.CoClasses.Count
    FOR i = 1 TO lnIntCount
    	IF TYPE("lotypelib.CoClasses[m.i].Name")="C"	
    		ThisForm.cboProgIDs.AddItem(loTypelib.Name+"."+lotypelib.CoClasses[m.i].Name)
            ThisForm.lstProgIds.AddItem(loTypelib.Name+"."+lotypelib.CoClasses[m.i].Name)
    	ENDIF
    ENDFOR
    
    IF THISFORM.lstInts.ListCount > 0
    	THISFORM.lstInts.ListIndex=1
    ENDIF
    
    IF THISFORM.cboProgIDs.ListCount > 0
    	THISFORM.cboProgIDs.ListIndex=1
    ENDIF
    
  ENDPROC
  
  PROCEDURE lsttypelibs.ProgrammaticChange
    THIS.InteractiveChange()
  ENDPROC
  
  PROCEDURE lstints.InteractiveChange
    THISFORM.txtPath.Value=foxrefs.cfname
  ENDPROC
  
  PROCEDURE cmdcancel.Click
    THISFORM.Release()
    
  ENDPROC
  
  PROCEDURE cbofilter.Click
    * cboFilter.Valid 
    IF !USED([FoxRefs]) OR LASTKEY() = 27 
       RETURN .T.
    ENDIF 
    
    LOCAL lcStr, lnPos
    lnPos = This.SelStart + This.SelLength 
    lcStr = ALLTRIM(This.DisplayValue)
    IF LEN(lcStr) < lnPos
       lcStr = PADR(lcStr, lnPos)
    ENDIF
    
    SELECT FoxRefs
    IF EMPTY(lcStr)
       SET FILTER TO
    ELSE 
        lcStr = ["] + lcStr + ["] 
        LOCATE FOR ATC(&lcStr, foxrefs.cactivex +  foxrefs.cfname) > 0
        IF FOUND() 
           SET FILTER TO ATC(&lcStr, foxrefs.cactivex +  foxrefs.cfname) > 0
        ELSE
           WAIT WINDOW NOWAIT [Not found ] + lcStr    
        ENDIF 
    ENDIF
    ThisForm.lstTypelibs.Requery() 
    RETURN .T.
  ENDPROC
  
  PROCEDURE cbofilter.Init
    
    This.AddItem([ctl])
    This.AddItem([ms])
    This.AddItem([mscom])
    This.AddItem([Microsoft])
    This.AddItem([system32\])
    This.AddItem([Program Files\])
    This.AddItem([Common Files\])
    This.ListItemId = 1
  ENDPROC
  
  PROCEDURE cbofilter.KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    
    IF nKeyCode = 9
        IF This.ListItemId = 0 AND ! EMPTY(This.DisplayValue)
           This.Click()
        ENDIF 
    ENDIF 
  ENDPROC
  
  PROCEDURE cbofilter.LostFocus
    
    IF This.ListItemId = 0 AND ! EMPTY(This.DisplayValue)
       This.Click()
    ENDIF 
  ENDPROC
  
  PROCEDURE lstprogids.Click
    
    IF This.ListItemId > 0 
       ThisForm.cboProgIDs.DisplayValue = This.ListItem(This.ListItemId)
    ENDIF 
  ENDPROC
  
  PROCEDURE lstprogids.InteractiveChange
    THISFORM.txtPath.Value=foxrefs.cfname
  ENDPROC


ENDDEFINE
*
*-- EndDefine: ints
**************************************************



**************************************************
*-- Class:        typelibs (d:\beta\fcmd\vfpproj\xfoxcode\typelibs.vcx)
*-- ParentClass:  form
*-- BaseClass:    form
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\foxcode.h"
*
DEFINE CLASS typelibs AS form

  AutoCenter = .T.
  BorderStyle = 3
  Caption = "Type Library References"
  DataSession = 2
  DoCreate = .T.
  Height = 292
  HelpContextID = 1230986
  MaxButton = .F.
  MinButton = .F.
  Name = "typelibs"
  ShowTips = .T.
  Width = 566
  WindowType = 0
  csafety = .F.
  haderror = .F.

  ADD OBJECT shape1 AS shape WITH ;
        Height = 53 ;
      , Left = 12 ;
      , Name = "Shape1" ;
      , SpecialEffect = 0 ;
      , Top = 229 ;
      , Width = 433

  ADD OBJECT txtlocale AS textbox WITH ;
        BorderStyle = 0 ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 20 ;
      , Left = 24 ;
      , Name = "txtLocale" ;
      , ReadOnly = .T. ;
      , TabIndex = 8 ;
      , Top = 258 ;
      , Width = 408

  ADD OBJECT cmdclose AS commandbutton WITH ;
        Caption = "\<Done" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 451 ;
      , Name = "cmdClose" ;
      , TabIndex = 3 ;
      , Top = 2 ;
      , Width = 74

  ADD OBJECT wizlabel1 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "\<Select References:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 12 ;
      , Name = "Wizlabel1" ;
      , TabIndex = 1 ;
      , Top = 8 ;
      , Width = 93

  ADD OBJECT cmdtypelibs AS commandbutton WITH ;
        Caption = "" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 24 ;
      , Left = 530 ;
      , Name = "cmdTypelibs" ;
      , Picture = "fc_refresh.bmp" ;
      , TabIndex = 4 ;
      , ToolTipText = "Reload references from registry." ;
      , Top = 2 ;
      , Width = 24

  ADD OBJECT txtpath AS textbox WITH ;
        BorderStyle = 0 ;
      , ControlSource = "_instActiveX.cfname" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 20 ;
      , Left = 24 ;
      , Name = "txtPath" ;
      , ReadOnly = .T. ;
      , SelectOnEntry = .T. ;
      , TabIndex = 7 ;
      , Top = 234 ;
      , Width = 408

  ADD OBJECT oletypes AS olecontrol WITH ;
        Height = 188 ;
      , Left = 12 ;
      , Name = "oleTypes" ;
      , TabIndex = 2 ;
      , Top = 30 ;
      , Width = 543

  ADD OBJECT oreg AS registry WITH ; && registry.vcx 
        Height = 17 ;
      , Left = 456 ;
      , Name = "oReg" ;
      , Top = 264 ;
      , Width = 16

  ADD OBJECT label2 AS label WITH ;
        AutoSize = .T. ;
      , Caption = "Displa\<y:" ;
      , FontName = "Tahoma" ;
      , FontSize = 8 ;
      , Height = 15 ;
      , Left = 450 ;
      , Name = "Label2" ;
      , TabIndex = 5 ;
      , Top = 224 ;
      , Width = 40

  ADD OBJECT cbodisplay AS combobox WITH ;
        FontName = "MS Sans Serif" ;
      , FontSize = 8 ;
      , Height = 22 ;
      , Left = 450 ;
      , Name = "cboDisplay" ;
      , Style = 2 ;
      , TabIndex = 6 ;
      , Top = 240 ;
      , Width = 102

  
  PROCEDURE Destroy
    IF THIS.cSafety="ON"
    	SET SAFETY ON
    ENDIF
    CLOSE DATA
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    THISFORM.haderror = .T.
    IF nError = 3
      MESSAGEBOX(ERR_FCODE2INUSE_LOC)
      RETURN
    ENDIF
  ENDPROC
  
  PROCEDURE getactivex
    PARAMETER aControls
    
    LOCAL cOptPath, cExtn, cActiveXFile,i,j,nPos,lcFile,lcSysVar, lcEnvVal, lcSvrKey
    LOCAL aCLSIDs,aVersions,aKeys,aFlag,aDesc,nTotDone,nErr,aProgID,aServerName,aControlName
    
    DIMENSION aControls[1,3]
    DIMENSION aCLSIDs[1,1]
    
    cOptPath = CLSID_KEY+"\"
    cExtn = ""
    cActiveXFile = ""
    oReg = THIS.oReg
    
    WAIT WINDOW NOWAIT MSG_ADDACTIVEX7_LOC
    IF oReg.EnumOptions(@aCLSIDs, CLSID_KEY, HKEY_CLASSES_ROOT, .T.) # 0
    	WAIT CLEAR
    	RETURN .F.
    ENDIF
    
    FOR i = 1 TO ALEN(aCLSIDs)
    	nTotDone = ROUND(m.i/ALEN(aCLSIDs)*100,0)
    	IF m.nTotDone%5 = 0
    		WAIT WINDOW NOWAIT MSG_ADDACTIVEX5_LOC+ALLTRIM(STR(m.nTotDone))+MSG_ADDACTIVEX3_LOC
    	ENDIF
    	DIMENSION aKeys[1]
    	DIMENSION aProgID[1,2]
    	DIMENSION aServerName[1,2]
    	DIMENSION aControlName[1,2]
    	STORE "" TO aProgID,aControlName,aServerName,aKeys
    	
    	IF oReg.EnumOptions(@aKeys,m.cOptPath+aCLSIDs[m.i],"",.T.) = 0
    		IF ASCAN(aKeys,CONTROL_KEY,1,-1,-1,1) = 0
    			LOOP
    		ENDIF	
    		lcSvrKey = IIF(ASCAN(aKeys,LOCALSVR_KEY,1,-1,-1,1)=0, INPROC_KEY, LOCALSVR_KEY)
    		oReg.EnumOptions(@aServerName,cOptPath+aCLSIDs[m.i]+"\"+lcSvrKey)
    		IF EMPTY(m.cActiveXFile) OR (UPPER(aServerName[2])=UPPER(m.cActiveXFile))
    			oReg.EnumOptions(@aControlName,cOptPath+aCLSIDs[m.i])
    			oReg.EnumOptions(@aProgID,cOptPath+aCLSIDs[m.i]+PROGID_KEY)
    			IF !EMPTY(aControls[1,1])
    				DIMENSION aControls[ALEN(aControls,1)+1,3]
    			ENDIF			
    			aControls[ALEN(aControls,1),1] = aControlName[2]
    			aControls[ALEN(aControls,1),2] = aProgID[2]
    			aControls[ALEN(aControls,1),3] = aServerName[2]
    		ENDIF
    	ENDIF
    ENDFOR
    
    ASORT(aControls,1)
    SELECT _instActiveX
    FOR i = 1 TO ALEN(aControls,1)
    	lcFile = aControls[i,3]
    	* Need to check if any system environment vars are used
    	* ex. %Systemroot%\system32\ImgEdit.ocx
    	IF ATC("%",lcFile)#0
    		lcSysVar = STREXTRACT(lcFile,"%","%")
    		IF !EMPTY(lcSysVar)
    			lcEnvVal = GETENV(lcSysVar)
    			IF !EMPTY(lcEnvVal)
    				lcFIle = STRTRAN(lcFIle,"%"+lcSysVar+"%",lcEnvVal)
    			ENDIF
    		ENDIF
    	ENDIF 
    	IF !FILE(lcFile) OR LEFT(aControls[i,1],1)="{"
    		LOOP
    	ENDIF
    	INSERT INTO _instActiveX (cActiveX,	cFName, lControl) VALUES (aControls[i,1],lcFile,.T.)
    NEXT
    WAIT CLEAR
    RETURN .T.
  ENDPROC
  
  PROCEDURE gettypelibs
    PARAMETER aControls
    
    LOCAL cOptPath, cActiveXFile, i , j, oReg, lcFile
    LOCAL aTypelibGuids,aVersions,aKeys,aFlag,aDesc,nPos,nTotDone,nErr
    
    DIMENSION aTypelibGuids[1,1]
    DIMENSION aControls[1,3]
    
    cOptPath = TYPELIB_KEY+"\"
    cActiveXFile = ""
    oReg = THIS.oReg
    
    WAIT WINDOW NOWAIT MSG_ADDACTIVEX6_LOC
    IF oReg.EnumOptions(@aTypelibGuids, TYPELIB_KEY, HKEY_CLASSES_ROOT, .T.) # 0
    	WAIT CLEAR
    	RETURN .F.
    ENDIF
    
    FOR i = 1 TO ALEN(aTypelibGuids)
    	nTotDone = ROUND(m.i/ALEN(aTypelibGuids)*100,0)
    	IF m.nTotDone%5 = 0
    		WAIT WINDOW NOWAIT MSG_ADDACTIVEX5_LOC+ALLTRIM(STR(m.nTotDone))+MSG_ADDACTIVEX3_LOC
    	ENDIF
    	DIMENSION aVersions[1,2]
    	STORE "" TO aVersions
    	
        * Check for no versions available
       	IF oReg.EnumOptions(@aVersions,m.cOptPath+aTypelibGuids[m.i],"",.T.)#0
            LOOP
        ENDIF
    
        FOR j = 1 TO ALEN(aVersions)    &&each version
            DIMENSION aKeys[1,2]
            STORE "" TO aKeys
            nErr = oReg.EnumOptions(@aKeys,m.cOptPath+aTypelibGuids[m.i]+"\"+aVersions[m.j],"",.T.)
        	IF nErr=0       
                * Check for Flags key
                nPos = ASCAN(aKeys,"FLAGS")
               	DIMENSION aFlag[1,2]
    			STORE "" TO aFlag
       			IF m.nPos#0
    	    		oReg.EnumOptions(@aFlag,cOptPath+aTypelibGuids[m.i]+"\"+aVersions[m.j]+"\"+aKeys[nPos])
    		    ENDIF
    
    			IF INLIST(aFlag[2],"1","2","4","6")
    				LOOP
    			ENDIF
                
                * Get Typelib Description
                DIMENSION aDesc[1,2]
    			STORE "" TO aDesc
        		oReg.EnumOptions(@aDesc,cOptPath+aTypelibGuids[m.i]+"\"+aVersions[m.j])
                IF EMPTY(aDesc[2])
                	LOOP
                ENDIF
                
               	DIMENSION aTypelibs[1,2]
            	STORE "" TO aTypelibs
        		oReg.EnumOptions(@aTypelibs,cOptPath+aTypelibGuids[m.i]+"\"+aVersions[m.j]+"\"+aKeys[1]+"\"+"win32")
    			
       			IF !EMPTY(aControls[1,1])
    				DIMENSION aControls[ALEN(aControls,1)+1,3]
    			ENDIF
    			aControls[ALEN(aControls,1),1] = aDesc[2]		&&desc
    			aControls[ALEN(aControls,1),2] = aTypelibs[2]	&&typelib file
    			aControls[ALEN(aControls,1),3] = aKeys[1]		&&localeid
            ENDIF       
        ENDFOR    &&versions
    ENDFOR    &&typelibs
    
    ASORT(aControls,1)
    SELECT _instActiveX
    FOR i = 1 TO ALEN(aControls,1)
    	lcFile = aControls[i,2]
    	* Need to check if any system environment vars are used
    	* ex. %Systemroot%\system32\ImgEdit.ocx
    	IF ATC("%",lcFile)#0
    		lcSysVar = STREXTRACT(lcFile,"%","%")
    		IF !EMPTY(lcSysVar)
    			lcEnvVal = GETENV(lcSysVar)
    			IF !EMPTY(lcEnvVal)
    				lcFIle = STRTRAN(lcFIle,"%"+lcSysVar+"%",lcEnvVal)
    			ENDIF
    		ENDIF
    	ENDIF 
    	IF !FILE(lcFile)
    		LOOP
    	ENDIF
    	IF UPPER(JUSTEXT(lcFile))="OCX"
    		LOOP
    	ENDIF
    	INSERT INTO _instActiveX (;
    			cActiveX, ;
    			cFName, ;
    			cLocale) ;
    		VALUES ( ;
    			aControls[i,1],;
    			lcFile,;
    			aControls[i,3])
    ENDFOR
    WAIT CLEAR
    
  ENDPROC
  
  PROCEDURE Hide
    *TypeLibs.Hide
    This.Release() 
    
  ENDPROC
  
  PROCEDURE Init
    * TypeLibs::Init
    
    LOCAL lcActxDBF, lcLib, lHasFoxRef
    LOCAL ARRAY aControls[1,3]
    LOCAL aflds[1]
    
    THIS.csafety=SET("SAFETY")
    SET SAFETY OFF
    USE (_foxcode) ALIAS foxcode AGAIN SHARED
    IF USED("_instActiveX")
    	USE IN _instActiveX
    ENDIF
    SELECT 0
    lcActxDBF = HOME()+"foxrefs.dbf"
    lHasFoxRef = FILE(lcActxDBF)
    IF m.lHasFoxRef
      	USE (lcActxDBF) AGAIN EXCLUSIVE ALIAS _instActiveX
    	IF EMPTY(ALIAS())
    		RETURN .F.
    	ENDIF
    	IF AFIELDS(aflds)#5
    		USE
    		DELETE FILE (lcActxDBF)
    		DELETE FILE FORCEEXT(lcActxDBF,"FPT")
    		lHasFoxRef= .F.
    	ENDIF
    ENDIF
    
    IF !lHasFoxRef
    	CREATE TABLE (lcActxDBF) ;
    		(cActiveX C(150), cFName C(254), cLocale c(10), lHide L, lControl L)
      	USE (lcActxDBF) AGAIN EXCLUSIVE ALIAS _instActiveX
    	THIS.GetTypelibs(@aControls)
    	DIMENSION aControls[1,3]
    	THIS.GetActiveX(@aControls)
    ENDIF
    
    This.Caption = [XType Library References foxrefs - ] + DBF() 
    INDEX ON UPPER(cActiveX) TAG cActiveX UNIQUE
    INDEX ON UPPER(left(cfname,70)+LEFT(cActiveX,10)) TAG cfNameAct
    THIS.refreshtypelibs()
    
    This.oleTypes.AddProperty([cAlignment], [1100])
    This.shape1.AddProperty([cAlignment], [0010])
    This.txtPath.AddProperty([cAlignment], [0010])
    This.txtLocale.AddProperty([cAlignment], [0010])
    This.label2.AddProperty([cAlignment], [0010])
    This.cboDisplay.AddProperty([cAlignment], [0010])
    
    
  ENDPROC
  
  PROCEDURE KeyPress
    LPARAMETERS nKeyCode, nShiftAltCtrl
    IF nKeyCode=27
    	THISFORM.UpdateFoxCode()
    	THISFORM.Hide()
    ENDIF
  ENDPROC
  
  PROCEDURE Load
    * Typelibs::Load
    DO FrmResizeLoad WITH This IN FoxCode.fxp
    
  ENDPROC
  
  PROCEDURE Refresh
    DO CASE
    CASE ALLTRIM(_instActiveX.cLocale) = "9"
    	THIS.txtLocale.Value = "English/Standard"
    CASE ALLTRIM(_instActiveX.cLocale) = "409"
    	THIS.txtLocale.Value = "English/United States"
    OTHERWISE
    	THIS.txtLocale.Value = "Standard"
    ENDCASE
    
  ENDPROC
  
  PROCEDURE refreshtypelibs
    LOCAL oNewItem,lnDisplay
    
    lnDisplay = THIS.cboDisplay.ListIndex
    
    THISFORM.oleTypes.ListItems.Clear()
    
    SELECT _instActiveX
    SCAN FOR !DELETED() AND !lHide
    	DO CASE
    	CASE lnDisplay = 1 AND lControl
    		LOOP
    	CASE lnDisplay = 2 AND !lControl
    		LOOP
    	ENDCASE
    	oNewItem = THIS.oleTypes.Listitems.Add(,"O_"+TRANSFORM(RECNO()),ALLTRIM(cActiveX))
        oNewItem.SubItems(1)=ALLTRIM(cFName)
        oNewItem.SubItems(2)=IIF(lControl, [C], [ ])
      	oNewItem.SubItems(3)=ALLTRIM(cActiveX)
        *cActiveX, cFName, lControl
    ENDSCAN
    
    * Check for items in FoxCode and check
    SELECT foxcode
    SCAN FOR UPPER(TYPE) = "O"
    	lcLib = UPPER(ALLTRIM(tip))
    	SELECT _instActiveX
    	LOCATE FOR UPPER(ALLTRIM(cActivex)) == lcLib
    	IF FOUND()
    		THIS.oleTypes.Listitems("O_"+TRANSFORM(RECNO())).Checked = .T.
    		THIS.oleTypes.Listitems("O_"+TRANSFORM(RECNO())).SubItems(3) 
                                   = "_"+ALLTRIM(cActiveX)
    	ENDIF
    	SELECT foxcode
    ENDSCAN
    SELECT _instActiveX
    GO TOP
    THIS.oleTypes.SortKey=2
    THIS.oleTypes.SortOrder=0
    THIS.oleTypes.Sorted = .T.
    THIS.oleTypes.ListItems(1).Selected = .T.
    THIS.Refresh()
  ENDPROC
  
  PROCEDURE Resize
    * Typelibs::Resize 
    DO FrmResize WITH This IN FoxCode.fxp
  ENDPROC
  
  PROCEDURE updatefoxcode
    LOCAL otypelibobj, otypelib, lcLibName, lcGuid, lcVersion, lcLCID
    LOCAL item,lnIndex,lcKey, lcFileName
    THIS.oleTypes.Sorted = .T.
    otyplibobj = CreateObject("TLI.TLIApplication")
    FOR EACH item IN THIS.oleTypes.ListItems
    	lcKey=item.SubItems(3)
      	lcFirstItem = LEFT(lcKey,1)
    	IF !INLIST(lcFirstItem,"_","*")
    		EXIT
    	ENDIF
    	DO CASE
    	CASE lcFirstItem="*" AND !item.Checked()
    		* User checked item and then changed mind - don't add.
    		LOOP
    	CASE lcFirstItem="*"
    		* Add new item
    		lnRec = VAL(SUBSTR(item.key,3))
    		SELECT _instActiveX
    		Go lnRec
            lcFileName = ALLTRIM(_instActiveX.cFName)
            SELECT foxcode
            LOCATE FOR UPPER(TYPE)="O" AND;
                UPPER(ALLTRIM(data))==UPPER(lcFileName)
            IF !FOUND()
            	otypelib = otyplibobj.TypeLibInfoFromFile(lcFileName)
            	lcLibName = ALLTRIM(_instActiveX.cActivex)
            	lcLibName = otypelib.name
            	lcGuid = otypelib.GUID
              	*lcHelp = otypelib.HelpString
            	lcHelp = ALLTRIM(_instActiveX.cActivex)
              	lcVersion = TRANS(otypelib.MajorVersion)+"."+TRANS(otypelib.MinorVersion)
    			lcLCID = TRANS(otypelib.LCID)
    			LOCATE FOR UPPER(TYPE)="O" AND;
    				UPPER(ALLTRIM(tip))==UPPER(ALLTRIM(item.Text))
      			IF !FOUND()
    				INSERT INTO foxcode (type, abbrev, tip, data, save, timestamp);
    					VALUES ("O", lcLibName, lcHelp, lcGuid+"#"+lcVersion, .T., DATETIME())
      			ENDIF
            ENDIF
    	CASE !item.Checked
    		* User unchecked existing item
    		SELECT foxcode
    		LOCATE FOR UPPER(TYPE)="O" AND;
    			UPPER(ALLTRIM(tip))==UPPER(ALLTRIM(item.Text))
    		IF FOUND()
    			BLANK
    		    DELETE
    		ENDIF
    	ENDCASE
    ENDFOR
    
  ENDPROC
  
  PROCEDURE txtlocale.When
    RETURN .F.
  ENDPROC
  
  PROCEDURE cmdclose.Click
    THISFORM.UpdateFoxCode()
    THISFORM.Hide()
    
  ENDPROC
  
  PROCEDURE cmdtypelibs.Click
    *- build list of installed ActiveX controls
    LOCAL ARRAY aControls[1,3]
    SELECT _instActiveX
    ZAP
    IF !THIS.Parent.GetActiveX(@aControls)
    	*- failed
    	MESSAGEBOX(NOREFRESH_LOC)
    	RETURN .F.
    ENDIF
    DIMENSION aControls[1,3]
    IF !THIS.Parent.GetTypelibs(@aControls)
    	*- failed
    	MESSAGEBOX(NOREFRESH_LOC)
    	RETURN .F.
    ENDIF
    THISFORM.refreshtypelibs()
    THIS.Enabled = .F.
    
  ENDPROC
  
  PROCEDURE oletypes.HitTest
    *** ActiveX Control Method ***
    LPARAMETERS x, y
    
  ENDPROC
  
  PROCEDURE oletypes.ItemCheck
    *** ActiveX Control Event ***
    LPARAMETERS item
    LOCAL lnRec
    lnRec = VAL(SUBSTR(item.key,3))
    SELECT _instActiveX
    Go lnRec
    IF item.checked
    	item.SubItems(3) = "*"+ALLTRIM(cActiveX)
    ENDIF
    
  ENDPROC
  
  PROCEDURE oletypes.ItemClick
    *** ActiveX Control Event ***
    LPARAMETERS item
    LOCAL lnRec
    lnRec = VAL(SUBSTR(item.key,3))
    SELECT _instActiveX
    Go lnRec
    THISFORM.Refresh()
  ENDPROC
  
  PROCEDURE oletypes.KeyPress
    *** ActiveX Control Event ***
    LPARAMETERS keyascii
    IF keyascii=27
    	THISFORM.Hide()
    ENDIF
  ENDPROC
  
  PROCEDURE cbodisplay.Init
    THIS.AddItem("COM Servers")
    THIS.AddItem("ActiveX Controls")
    THIS.AddItem("Both")
    THIS.ListIndex=1
  ENDPROC
  
  PROCEDURE cbodisplay.InteractiveChange
    THISFORM.refreshtypelibs()
  ENDPROC


ENDDEFINE
*
*-- EndDefine: typelibs
**************************************************
