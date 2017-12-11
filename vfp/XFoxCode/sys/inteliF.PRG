* Inteli F 
* intelif.prg
* Revision 1.2  2004/11/26 16:08:07  andriusk
* NotActPM manual delete Active=10->11
* Revision 1.1  2004/05/20 06:34:38  andriusk

FUNCTION InteliF 

BrowFCode() 
* DO Tbls IN \vfplib\Sys\inteliF

FUNCTION BrowFCode

IF ! USED( "FoxCode" ) 
   SELECT 0 
   USE (_FOXCODE) ALIAS FoxCode SHARED 
   SET FILT TO Type="S" 
   * .NOT.INLIST(type,"F","C")
ELSE 
   SELECT FoxCode 
ENDIF 

BROW SAVE NOWAIT  TITLE DBF() + " FLT:"+ SET( "FILTER" )  


FUNCTION Types 

* S - script 

FUNCTION IntOn 
_VFP.EditorOptions = "LQ"

FUNCTION IntOff
_VFP.EditorOptions = ""


FUNCTION Default_Script

* Default script triggered by a space -- used for commands only
LPARAMETER oFoxCode
LOCAL loFoxCodeLoader, lcLine, lcCmd, lnWords, lcLastCmd && , lcTalk

lcLine = ALLTRIM(oFoxCode.FullLine)
lcCmd  = UPPER(ALLTRIM(GETWORDNUM(lcLine,1)))
lnWords = GETWORDCOUNT(lcLine)
lcLastCmd = GETWORDNUM(lcLine,lnWords)

IF EMPTY(lcLine) OR LEFT(lcLine,1)="*" ;
   OR ATC("L", _VFP.EditorOptions)=0 ;
   OR UPPER(lcLastCmd)=="AS"

    DEBUGOUT "ignore script..." 
    RETURN ""
ENDIF

IF FILE(_CODESENSE)
    SET PROCEDURE TO (_CODESENSE) ADDITIVE
    loFoxCodeLoader = CreateObject("Default_FoxCodeLoader")
    DEBUGOUT "Default script..." 
    loFoxCodeLoader.Start(m.oFoxCode)
    loFoxCodeLoader = NULL
    IF ATC(_CODESENSE,SET("PROC"))#0
        RELEASE PROCEDURE (_CODESENSE)
    ENDIF
    RETURN ""
ENDIF

DEFINE CLASS Default_FoxCodeLoader AS FoxCodeScript
    cAbbrev = "Default" 
    
    PROCEDURE Main()
        THIS.DefaultScript()
    ENDPROC
    
ENDDEFINE



FUNCTION Setmenu_Init( oFoxcode ) 

IF FILE("D:\Vfplib\sys\inteliF.prg") 
    LOCAL eRetVal, loFoxCodeLoader

    SET PROCEDURE TO (_CODESENSE) ADDITIVE
    SET PROCEDURE TO ("D:\Vfplib\sys\inteliF.prg") ADDITIVE

    loFoxCodeLoader = CreateObject("Setmenu_FoxCodeLoader")
    eRetVal = loFoxCodeLoader.Start(m.oFoxCode)
    loFoxCodeLoader = NULL

    IF ATC(_CODESENSE,SET("PROC"))#0
        RELEASE PROCEDURE ("D:\Vfplib\sys\inteliF.prg")
        RELEASE PROCEDURE (_CODESENSE)
    ENDIF
    RETURN m.eRetVal
ENDIF 

FUNCTION Setmenu_Script
LPARAMETER oFoxcode
IF FILE(_CODESENSE)
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

DEFINE CLASS Setmenu_FoxCodeLoader AS FoxCodeScript
    cAbbrev = "setmenu" 
    
    * Some folks do not like to have entire SET command expanded for them.
    * For example: selecting STEP would autoexpand to STEP ON
    * lEnableFullSetDisplay controls if we expand to STEP or STEP ON
    lEnableFullSetDisplay = .T.
    
*!*        FUNCTION Init() 
*!*    *!*           SYS(2030,1)   
*!*    *!*           SET ASSERTS ON 
*!*    *!*           ASSERT .F.
*!*           RETURN FoxCodeScript::Init() 
    
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
            This.GetItemList( m.lcItem,.T.,"setmenu","",.T. )
            RETURN THIS.AdjustCase()
        OTHERWISE
            RETURN ""
        ENDCASE
    ENDPROC
    
ENDDEFINE



*-- The following will add an IntelliSense script that works in VFP 8
*-- This script is used to get a list of tables or fields in a table
*-- The process used to setup the tables can be invoked by typing PRJ followed by a space
*-- To get a list of tables type TBLS followed by a space
*-- To get a list of fields in a table type the tablename followed by a period and space
*-- This script will fire every time a space is typed in a Program, Method, or Command Window
*-- For those that work on SQL backends, Changing the methods, AddTable and AddProcess will be needed.
*-- This Script, in the AddTable process, formats the Tablename and Fieldnames.
*-- You may want to change this before running the PRG.

FUNCTION MyTables 
=Tbls()

FUNCTION Tbls

Local lcAddScript, lcDefaultScripts, lcScriptName, lcTableName, lcScreenProp, lcProjects
*-- This is the tablename the table and field list is kept in.
* lcTableName = "C:\Work\Builders\myTables.dbf"
lcTableName = "D:\Prg\Tbls.dbf"
*-- This is the Screen property used to keep the Active Project
lcScreenProp = "cActiveProject"
*-- This is the script name to open the table list.
lcScriptName = "Tbls"
*-- This is the key to call the Project Add/Select screeen
lcProjects = "Prj"

RemoveProperty(_Screen, lcScreenProp)
lcDefaultScripts = "CustomDefaultScripts"
If Not File(_FoxCode)
   =MESSAGEBOX(_FoxCode + " does not exist.",0,"Add Script")
   Return .F.
EndIf

*-- The Script
Text To lcAddScript NOSHOW TEXTMERGE
*-- Author: Tracy Pearson
*-- Date: May 16, 2004
*-- This script runs after a space is typed in the Command Window, a Program
*-- Window, or a Method window
*-- Using the last word typed, this could open a Project Selection window,
*-- and/or drop down a list of tables in a Project already selected, or
*-- drop down a list of fields in the tablename of the given project
*-- The keywords this script use are as follows:
*-- <<lcProjects>> opens the Project Selection window
*-- <<lcScriptName>> opens the list of tables
*-- A tablename (in the current selected project) followed by a period
*-- opens the list of fields in the table.
LParameters oFoxScript
LOCAL loTableList
loTableList = CreateObject("cTableList",oFoxScript)
*-- To keep the rest of the scripts running, when this one didn't process return False
*-- When this object processes the ValueType will be set to "L"
Return IIF(TYPE("oFoxScript.oFoxCode.ValueType") = "C", oFoxScript.oFoxCode.ValueType = "L", .F.)

Define Class cTableList AS Form

AutoCenter = .T.
BorderStyle = 2
Caption = "Project Selection"
DataSession = 2
Height = 55
MaxButton = .F.
MinButton = .F.
WindowType = 1
Width = 350

Dimension aProjects[1]
aTables[1] = ""
cDirectory = ""
cFxToolLib = Sys(2004) + "FoxTools.fll"
cLastWord = ""
*-- This is the table the structures are kept in.
cTableName = "<<lcTableName>>"
oFoxScript = NULL
oInput = NULL
cScreenProp = "_Screen.<<lcScreenProp>>"

Add Object lblProjects As Label With ;
   AutoSize = .T., ;
   Caption = "Projects:", ;
   Left = 6, ;
   Top = 8

Add Object cboProjects As ComboBox With ;
   ControlSource = This.cScreenProp, ;
   Left = 60, ;
   Top = 4, ;
   Width = 125, ;
   Style = 0 , ;
   Format = "!"

Add Object cmdAdd As CommandButton With ;
   Caption = "Add", ;
   Left = 191, ;
   Height = 22, ;
   Top = 5, ;
   Width = 75

Add Object cmdClose As CommandButton With ;
   Caption = "Select", ;
   Left = 267, ;
   Height = 22, ;
   Top = 5, ;
   Width = 75

ADD OBJECT lblInfo As Label WITH ;
   Caption = "Type a new name and click Add, or Alt+DownArrow for the list.", ;
   Left = 6, ;
   Top = 32, ;
   AutoSize = .T.

Procedure cmdClose.Click
   ThisForm.Visible = .F.
EndProc

Procedure Load
   If Not PemStatus(_Screen, "<<lcScreenProp>>", 5)
      AddProperty(_Screen, "<<lcScreenProp>>", "")
   EndIf
EndProc

Procedure Init(toFoxScript)
   If Type("toFoxScript") <> "O"
      Return .F.
   EndIf
   This.oFoxScript = toFoxScript

   If Not File(This.cFxToolLib)
      Return .F.
   ENDIF

   DO CASE 
   CASE TYPE([This.oFoxScript.cLastWord]) = 'C'
      IF Empty(This.oFoxScript.cLastWord)
         RETURN .F.
      ENDIF 
      *-- Get the last word typed in and prep it.
      This.cLastWord = SUBSTR(This.oFoxScript.cLastWord, RAT("(",This.oFoxScript.cLastWord)+1)
   CASE TYPE([This.oFoxScript.FullLine]) = 'C'
      * ASSERT !EMPTY(This.oFoxScript.FullLine)
      IF EMPTY(This.cLastWord)
         This.cLastWord = This.oFoxScript.FullLine
      ENDIF 
   ENDCASE

   This.cLastWord = UPPER(ALLTRIM(This.cLastWord))
   This.Process()
   *-- I found something changes the _VFP.StatusBar = "", which prevents the Line: ## Col: ##
   *-- from appearing on the status bar. Clear it with this command corrects it.
   SET MESSAGE TO
   *-- Return False, closing the object
   Return .F.
EndProc

Procedure Process
   If "<<UPPER(lcProjects)>>" == This.cLastWord
      This.SetProjectList()
      This.Show()
      This.cLastWord = "<<UPPER(lcScriptName)>>"
   ENDIF

   If Not File(This.cTableName)
      CREATE TABLE (This.cTableName) ;
          (cProject c(30), cTable c(30), cField c(30), cDesc c(50))
   ENDIF
   If Not File(This.cTableName)
      Return
   EndIf

   If .F. && Empty(Evaluate(ThisForm.cScreenProp))
      Return
   Endif
   If "<<UPPER(lcScriptName)>>" == This.cLastWord
      This.TableList()
   EndIf
   If Right(This.cLastWord,1) = "."
      This.FieldList()
   EndIf
EndProc

Procedure SetProjectList
   This.OpenTable()
   If Used("myTables")
      Select Distinct cProject From myTables Into Array laProjects WHERE NOT DELETED()
      Dimension Thisform.aProjects[_Tally]
      ACopy(laProjects, ThisForm.aProjects)
      With This.cboProjects
         .RowSource="ThisForm.aProjects"
         .RowSourceType=5
      EndWith
   EndIf
EndProc

Procedure TableList

   This.OpenTable()
   
   *-- Get the list of tables
   Local lcProject, lcWord, laTables[1]
   lcProject = Evaluate(ThisForm.cScreenProp)
   IF TYPE([This.oFoxScript.cLastWord]) = 'C'
       WITH This.oFoxScript
          *-- .cLastWord might be <<lcProjects>> or <<lcScriptName>>
          *-- to prevent SubStr(<<lcScriptName>> from being replaced look for the (
          lcWord = SUBSTR(.cLastWord,1,RAT("(",.cLastWord))
          Select cField, cDesc From myTables ;
             Into Array laTables Where cProject = lcProject And "TableName" = cTable ;
             AND NOT DELETED()
          .ReplaceWord(lcWord)
       ENDWITH
   ENDIF 
   This.FillList(@laTables)
EndProc

Procedure FieldList
   This.OpenTable()
   Local laTables[1], lcLastWord, lcProject
   lcProject = Evaluate(ThisForm.cScreenProp)
   *-- Get the list of fields
   Select cField, cDesc From myTables ;
      Into Array laTables ;
      Where (This.cLastWord) == Upper(AllTrim(cTable))+"." ;
      AND cProject = lcProject AND NOT DELETED()
   If _Tally = 0
      Return .F.
   EndIf
   This.FillList(@laTables)
EndProc

Procedure FillList(laList)
   *-- Load dropdown list
   IF TYPE("laList") = "C" AND TYPE("This.oFoxScript.oFoxCode.Items[1]") # "U"
      With This.oFoxScript.oFoxCode
         .ValueType = "L"
         Dimension .Items(ALen(laList,1),2)
         ACopy(laList, .Items)
      ENDWITH
   ENDIF
   This.RemoveSpace()
EndProc

Procedure OpenTable
   If Not Used("MyTables") and File(This.cTableName)
      Use (This.cTableName) In 0 Shared Alias MyTables
   Endif
EndProc

Procedure RemoveSpace
   *-- Remove the space entered to get to this script
   *-- on a slow machine, one can see the space turn black and disappear
   IF TYPE([This.oFoxScript.oFoxCode.FullLine]) = 'C' ;
      AND Asc(Right(This.oFoxScript.oFoxCode.FullLine,1))=32
      This.Visible=.F.
      Set Library To (This.cFxToolLib) Additive
      lnWinHdl = _WOnTop()
      _WSelect(lnWinHdl)
      _EdSelect(lnWinHdl, _EdGetPos(lnWinHdl), _EdGetPos(lnWinHdl) - 1)
      _EdDelete(lnWinHdl)
   EndIf
EndProc

Procedure cmdAdd.Click
   If Ascan(ThisForm.aProjects,ThisForm.cboProjects.DisplayValue,-1,-1,1) <> 0
      IF MESSAGEBOX("Overwrite this project?" + CHR(13) + CHR(10) + ;
                    ThisForm.cboProjects.DisplayValue,4+32,"Add project") = 7
         RETURN
      ENDIF
      ThisForm.OpenTable()
      IF USED("myTables")
         DELETE ALL FOR cProject = ThisForm.cboProjects.DisplayValue
      ELSE
         MESSAGEBOX('Unable to cleanup the current project entries.',0,"Add Project")
         RETURN
      ENDIF
   ENDIF
   ThisForm.AddProcess()
   ThisForm.SetProjectList()
EndProc
 
Procedure AddProcess
   Local lnDbfs, laTables[1], lcDir
   This.cDirectory = GETDIR("","","Data Directory",0,.F.)
   If Empty(This.cDirectory)
      Return
   EndIf
   Create Cursor curTemp (cProject c(30), cTable c(30), cField c(30), cDesc c(50))
   Scatter Name This.oInput
   This.oInput.cProject = ThisForm.cboProjects.DisplayValue
   lnDbfs = ADir("laTables",ALLTRIM(This.cDirectory) + "\*.dbf","",1)
   For lnLoop = 1 To lnDbfs
      This.AddTable(laTables(lnLoop, 1))
   Next
   Select curTemp
   Scatter Name This.oInput Blank
   llCreate = .T.
   This.OpenTable()
   If Used("myTables")
      Select myTables
      *-- Be sure the table has the same fields
      Scatter Name oOutput Blank
      If CompObj(oOutput, This.oInput)
         Append From Dbf("curTemp")
         llCreate = .F.
      EndIf
      Use
   EndIf
   If llCreate
      Select curTemp
      Copy To (This.cTableName)
   ENDIF
   STORE ThisForm.cboProjects.DisplayValue TO (ThisForm.cScreenProp)
EndProc

Procedure AddTable
   LParameters lcTable
   Local lnLoop, laFields[1]
   This.oInput.cTable = "TableName"
   This.oInput.cField = JustStem(lcTable)
   IF .T. && My tablename formating
      This.oInput.cField = PROPER(This.oInput.cField)
      This.oInput.cField = STUFF(This.oInput.cField,3,1,UPPER(SUBSTR(This.oInput.cField,3,1)))
   ENDIF
   This.oInput.cDesc = ""
   Insert Into curTemp From Name This.oInput
   This.oInput.cTable = JustStem(lcTable)
   Use (AddBS(This.cDirectory) + lcTable) In 0 Shared Alias curInsert
   For lnLoop = 1 TO AFields("laFields", "curInsert")
      This.oInput.cField = Proper(laFields[lnLoop,1]) && My fieldname formating
      This.oInput.cDesc = laFields[lnLoop, 2] +"(" ;
                        + Transform(laFields[lnLoop, 3]) + ",";
                        + Transform(laFields[lnLoop, 4]) + ")"
      Insert Into curTemp From Name This.oInput
   Next
   Use In Select("curInsert")
EndProc
EndDefine
EndText

IF NOT USED("curFoxCode")
   Use (_FoxCode) Alias curFoxCode Shared In 0 AGAIN
ENDIF
Select "curFoxCode"
Locate For Abbrev = lcDefaultScripts
If Not Found()
   Wait Window lcDefaultScripts + " is not found"
   Use In Select("curFoxCode")
   Return .F.
EndIf
ALines(laLines, curFoxCode.Data)
If Ascan(laLines, lcScriptName, 1, ALen(laLines, 1), 1, 1 + 2 + 4 + 8) = 0
   REPLACE Data WITH Data + CHR(13) + CHR(10) + lcScriptName
ENDIF
LOCATE FOR Abbrev = lcScriptName
IF NOT FOUND()
   INSERT INTO curFoxCode (Type, Abbrev, Data, Case, Save, TimeStamp);
      VALUES ("S", lcScriptName, lcAddScript, "M", .T., DATETIME())
ELSE
   REPLACE Data WITH lcAddScript, TimeStamp WITH DATETIME()
ENDIF
USE IN SELECT("curFoxCode")

