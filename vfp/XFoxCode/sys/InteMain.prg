* InteMain.prg,v 1.1 2006/01/30 07:49:56 andriusk Exp $
*  InteMain : Intellisense main statment (of _FOXCODE) 
*$Log: InteMain.prg,v $
*Revision 1.1  2006/01/30 07:49:56  andriusk
*Init versions
*
*#############################################################

* Default script triggered by a space -- used for commands only

LPARAMETER oFoxCode
LOCAL loFoxCodeLoader, lcLine, lcCmd, lnWords, lcLastCmd, lcTalk
lcLine = ALLTRIM(oFoxCode.FullLine)
lcCmd =  UPPER(ALLTRIM(GETWORDNUM(lcLine,1)))
lnWords = GETWORDCOUNT(lcLine)
lcLastCmd = GETWORDNUM(lcLine,lnWords)
IF EMPTY(lcLine) OR LEFT(lcLine,1)="*" ;
    OR ATC("L", _VFP.EditorOptions)=0 ;
    OR  UPPER(lcLastCmd)=="AS"
    RETURN ""
ENDIF

IF FILE(_CODESENSE)
    IF ATC("APP", _CODESENSE) = 0 
       SET ASSERTS ON
       ASSERT .F. MESSAGE "TEST _CODESENSE="+_CODESENSE 
    ENDIF  
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
