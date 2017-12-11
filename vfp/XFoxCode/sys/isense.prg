* Default script triggered by a space -- used for commands only

FUNCTION Sense_Space 

LPARAMETER oFoxCode
LOCAL loFoxCodeLoader, lcLine, lcCmd, lnWords, lcLastCmd, lcTalk
lcLine = ALLTRIM(oFoxCode.FullLine)
lcCmd =  UPPER(ALLTRIM(GETWORDNUM(lcLine,1)))
lnWords = GETWORDCOUNT(lcLine)
lcLastCmd = GETWORDNUM(lcLine,lnWords)
IF EMPTY(lcLine) OR LEFT(lcLine,1)="*" OR ;
    ATC("L", _VFP.EditorOptions)=0 OR ;
    UPPER(lcLastCmd)=="AS"
    RETURN ""
ENDIF

IF FILE(_CODESENSE)
    SET PROCEDURE TO (_CODESENSE) ADDITIVE
    loFoxCodeLoader = CreateObject("FoxCodeLoader")
    loFoxCodeLoader.Start(m.oFoxCode)
    loFoxCodeLoader = NULL
    IF ATC(_CODESENSE,SET("PROC"))#0
        RELEASE PROCEDURE (_CODESENSE)
    ENDIF
    RETURN ""
ENDIF

DEFINE CLASS FoxCodeLoader AS FoxCodeScript
    PROCEDURE Main()
        THIS.DefaultScript()
    ENDPROC
ENDDEFINE

FUNCTION BrowSense 

_CLIPTEXT = DBF() 
* 

USE "C:\PROGRAM FILES\MICROSOFT VISUAL FOXPRO 8\FOXCODE.DBF"

SELECT foxcode
SET FILTER TO LEN( Data ) > 50 
* RESERVED

BROWSE TITLE ALIAS()  ;
 NOWAIT 



