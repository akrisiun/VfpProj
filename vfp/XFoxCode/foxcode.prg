#INCLUDE FOXCODE.H

*#############################################################
LPARAMETERS cCmd, oFoxCode, parm3, parm4, parm5, parm6

LOCAL oFxCdeScript,lcRetValue,lnLangOpt,lnParms, lnDSID, lcCurDir  

IF VERSION(2) = 2 AND !FILE([typelibs.vcx])
   CD (_VFP.ActiveProject.HomeDir)
ENDIF
* _FOXCODE default
* %HOME%\appdata\roaming\microsoft\visual foxpro 8\foxcode.dbf
* c:\users\andrius\appdata\roaming\microsoft\visual foxpro 8\foxcode.dbf

lnParms= PCOUNT()
lnDSID = SET("DATASESSION") 
lcCurDir = FULLPATH(CURDIR())  
IF ! FILE("foxcode.vcx")  AND FILE(_CODESENSE) 
   CD (JUSTPATH(_CODESENSE)) 
ENDIF 
DO CASE
 CASE lnParms=0 
    IF TYPE("_oIntMgr")="O"
        _oIntMgr.Show()
    ELSE
        * DO FORM foxcode
       IF ! TYPE("goFoxCode.Name") = 'C' ; 
          AND FILE("foxcode.vcx") 
            PUBLIC goFoxCode
            goFoxCode = NEWOBJECT("frm_foxcode", "foxcode.vcx") 
       ENDIF 
       IF TYPE("goFoxCode.Name") = 'C'
          goFoxCode.Show()  
       ENDIF 
    ENDIF
    RETURN
 CASE VARTYPE(oFoxCode)#"O"
    RETURN
ENDCASE

IF ! lcCurDir == FULLPATH(CURDIR())  
   CD (lcCurDir) 
ENDIF 

lcRetValue = ""
oFxCdeScript = CREATEOBJECT("foxcodescript")
IF oFxCdeScript.lDebugScripts AND TYPE("oFoxCode.cAbbrev") = 'C' 
   DEBUGOUT "Start FxCds ."  + oFoxCode.cAbbrev 
ENDIF
oFxCdeScript.DSID = lnDSID 
oFxCdeScript.Start(@oFoxCode)

IF oFxCdeScript.lDebugScripts
   DEBUGOUT "Addi "+ cCmd + " ("+ TRANSF(lnParms) + ") " 
ENDIF 

DO CASE
CASE lnParms = 2
    lcRetValue = oFxCdeScript.&cCmd.()
CASE lnParms = 3
    lcRetValue = oFxCdeScript.&cCmd.(parm3)
CASE lnParms = 4
    lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4)
CASE lnParms = 5
    lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4, parm5)
CASE lnParms = 6
    lcRetValue = oFxCdeScript.&cCmd.(parm3, parm4, parm5, parm6)
ENDCASE
RETURN lcRetValue
*************************************************

FUNCTION CallTypelibs
    PUBLIC _loTypeLibs AS typelibs OF typelibs.vcx
    _loTypeLibs = NEWOBJECT([typelibs], [typelibs.vcx])
    =VARTYPE(_loTypeLibs) = 'O' AND _loTypeLibs.Show()

FUNCTION CallInts            && interfaces 
    PUBLIC _loInts AS Ints OF typelibs.vcx
    _loInts = NEWOBJECT([Ints], [typelibs.vcx]) 
    =VARTYPE(_loInts) = 'O' AND _loInts.Show() 


DEFINE CLASS foxcodescript AS session
  #IF .F.
     PUBLIC This AS foxcodescript OF FoxCode.prg
  #ENDIF 

PROTECTED lFoxCode2Used, cSYS3054, nLangOpt, cSYS2030
cEscapeState = ""
cTalk = ""
cMessage = ""
cExcl = ""
FoxCode2 = "FoxCode2"
cScriptType = ""
oFoxCode = ""
cCmd = ""
cCmd2 = ""
cLine = ""
nPosSt = 0 
nPosEnd = 0 
cPosChar = "" 
cPosChar0 = ""
DSID = 1 

nWords = 0
cLastWord = ""
cCustomPEMsID = "CustomPEMs"
cCustomScriptsID = "CustomDefaultScripts"
cCustomScriptName = ""
cAlias = ""
nSaveSession = 0
nWinHdl = 0
cSaveLib = ""
cSaveUDFParms = ""
lHadError = .F.
nLastKey = 0
cScriptCmd = ""
cScriptCase = ""
nSaveTally = 0
cMsgNoData = ""

lHideScriptErrors = .F.
lKeywordCapitalization = .T.
lPropertyValueEditors = .T.
lExpandCOperators = .T.
lAllowCustomDefScripts = .F.
lFoxCodeUnavailable = .F.

lDebugScripts = .T.
cFoxTools = ""

PROCEDURE Main
    * Virtual Function
ENDPROC

PROCEDURE Start(oFoxCode,cType)
    * Main start routine which should be called
    * It sets up core properties for use by other methods.
    * Check for valid oFoxCode object
    IF VARTYPE(m.oFoxCode)#"O" ;
       OR VARTYPE(m.oFoxCode.FullLine)#"C" ;
       OR EMPTY(ALLTRIM(m.oFoxCode.FullLine))  
        RETURN ""
    ENDIF
    * Avoid calling if within Foxcode itself
    IF ATC("FOXCODE.",oFoxCode.FileName)#0
        RETURN ""
    ENDIF
    This.GetEdEnv() 
    IF This.cPosChar == " " AND This.cPosChar0 == " "
       IF This.lDebugScripts
          DEBUGOUT "Ignore Line "+ oFoxCode.FullLine 
       ENDIF    
       RETURN .F. 
    ENDIF 
    
    This.nLastKey = LASTKEY()
    This.oFoxCode = oFoxCode
    This.cCmd = UPPER(ALLTRIM(GETWORDNUM(oFoxCode.FullLine,1)))
    This.cCmd2 = UPPER(LEFT(LTRIM(oFoxCode.FullLine);
                , ATC(" ", LTRIM(oFoxCode.FullLine),2)))
    This.cLine = STRTRAN(ALLTRIM(oFoxCode.FullLine),"  "," ")
    This.nWords = GETWORDCOUNT(This.cLine)
    This.cLastWord = GETWORDNUM(This.cLine,This.nWords)
    This.cScriptType = IIF(VARTYPE(cType)="C" ;
                          , cType, ALLTRIM(oFoxCode.Type))

    IF (This.cScriptType="C" AND ATC("L", _VFP.EditorOptions)=0) ;
       OR (This.cScriptType="F" AND ATC("Q", _VFP.EditorOptions)=0) ;
       AND _VFP.StartMode=0
        
        This.oFoxcode.ValueType = "V"
        RETURN This.AdjustCase(ALLTRIM(This.oFoxcode.Expanded) ;
                                      ,This.oFoxcode.Case)
    ENDIF

    IF This.lDebugScripts
        DEBUGOUT "Line "+ oFoxCode.FullLine ;
                + " Cmd=" + This.cCmd + " Cmd2="+ This.cCmd2 ; 
                + " LastKey="+ TRANSF(This.nLastKey) 
    ENDIF 
    *---------------------------------------------------------------- 
	THIS.CheckFoxCode()
	THIS.GetCustomPEMs()
	THIS.FindFoxTools()
	IF THIS.lDebugScripts
		SYS(2030,1)
	ENDIF
	RETURN THIS.Main()
ENDPROC


*#############################################################
 FUNCTION GetEdEnv()     

    STORE 0 TO This.nPosSt, This.nPosEnd, This.nWinHdl  
    STORE "" TO This.cPosChar, This.cPosChar0 
   
    LOCAL lcfxToollib , lnRetCode 
    lcfxtoollib = SYS(2004)+"FOXTOOLS.FLL"
    IF !FILE(lcfxtoollib)
        RETURN .F.
    ENDIF
    SET LIBRARY TO (m.lcfxtoollib) ADDITIVE

    This.nWinHdl = _wontop()
    IF This.nWinHdl = 0
        RETURN .F.
    ENDIF
    * Check environment of window
    * Check for selection, empty file or read-only file
    DIMENSION env[25]
    lnRetcode = _EdGetEnv(This.nWinHdl,@env)
    IF lnRetCode#1 OR (EMPTY(env[EEfilename]) AND env[EElength]=0) ;
        OR env[EElength]=0 OR env[EEreadOnly]#0
        This.nWinHdl = 0
        RETURN .F.
    ENDIF
    This.nPosSt  = env[STSEL]
    This.nPosEnd = env[ENDSEL] 
    IF This.nPosSt > 0 
       This.cPosChar  = _EDGETCHAR(This.nWinHdl, This.nPosSt - 1)
       IF This.nPosSt > 0 
          This.cPosChar0 = _EDGETCHAR(This.nWinHdl, This.nPosSt - 2)
       ENDIF      
    ENDIF  

    RETURN .T. 

*#############################################################
PROCEDURE DefaultScript()
    * This is the main default script (Type="S" and empty Abbrev field)
    * that gets called
	* when spacebar pressed and can occur anywhere within line.
    
    LOCAL leRetVal
    IF ATC(" ",This.oFoxCode.FullLine)=0
        RETURN ""
    ENDIF
    
    IF This.lDebugScripts 
        IF TYPE("This.oFoxCode.cAbbrev") = 'C'
           DEBUGOUT "DefScript " + This.oFoxCode.cAbbrev ;
                             + " from " + PROGRAM(PROGRAM(-1))  
        ELSE   
           DEBUGOUT "DefScript unknown " + " from " + PROGRAM(PROGRAM(-1))  
        ENDIF    
    ENDIF
    
    * Handle custom script handlers
    leRetVal = This.HandleCustomScripts()
    IF VARTYPE(leRetVal)#"L" OR leRetVal
        RETURN leRetVal
    ENDIF

    * Special script handler for C++ type operators (++,--,+=,-=,*=,/=)
    IF This.HandleCOps()
        RETURN ""
    ENDIF

    * Core script handler
    DO CASE
       CASE This.HandleMRU()
        * Handle MRUs
    ENDCASE    
    IF This.nWords > 1
        * Returns tool tip (not only for multi word commands)
        This.GetCmdTip(This.cLine)    && or update keywords of commands
    ENDIF 

    RETURN ""
ENDPROC

*#############################################################
PROCEDURE HandleMRU()
    * Special Handler 4 Most Recently Used files, classes
    * List of MRUs:
    *   USE, OPEN DATABASE, MODIFY DATABASE
    *   MODIFY VIEW, MODIFY CONNECTION, MODIFY QUERY
    *   MODIFY MEMO, MODIFY GENERAL, REPLACE
    *   MODIFY FILE, MODIFY COMMAND, DO
    *   MODIFY CLASS, MODIFY FORM, DO FORM
    *   MODIFY REPORT, MODIFY LABEL, REPORT FORM, LABEL FORM
    *   MODIFY PROJECT,  MODIFY MENU

    LOCAL lHasAlias,leCase
    LOCAL lnMRUOffset  &&used to handle Quick Info tip in Command Window
    lnMRUOffset = IIF(This.oFoxCode.Location#0,0,1)

    DO CASE
    CASE !INLIST(LEFT(This.cCmd,4),"USE","OPEN","MODI" ;
                ,"REPO","LABE","REPL","DO")
        * Skip if not valid MRU command 
        RETURN .F.
    CASE This.cCmd=="USE"
        * Handle USE MRU with dropdown list
        IF This.nWords>1 OR lnMRUOffset=0
            IF INLIST(UPPER(GETWORDNUM(This.ofoxcode.fullline,This.nWords)) ;
                   ,"CONNSTRING","IN","ALIAS") ;
               OR This.nWords=1
                * For certain USE keywords that require add'l string display tip
                IF This.nWords=1 AND lnMRUOffset=0
                    * Handle USE case expansion in PRG
                    LOCATE FOR UPPER(ALLTRIM(abbrev))=="USE" AND TYPE="C"
                    IF FOUND()
                        leCase = IIF(EMPTY(ALLTRIM(case)) ;
                                 ,This.oFoxCode.DefaultCase,Case)
                        IF UPPER(leCase)#"X"
                            This.ReplaceWord(This.AdjustCase("USE",case))
                        ENDIF
                    ENDIF
                ENDIF
                This.GetCmdTip("USETIP")
            ELSE
                * Display list of keywords
                LOCATE FOR UPPER(ALLTRIM(abbrev))=="USE" AND TYPE="C"
                leCase = IIF(FOUND(),Case,.F.)
                This.GetItemList(This.cCmd,.F.,"","",leCase)
            ENDIF
        ENDIF
    CASE This.cCmd=="DO"
        * Handle DO,DO Form MRU
        DO CASE
        CASE This.nWords = lnMRUOffset
        CASE ALLTRIM(CHRTRAN(This.cCmd2,CHR(9),"")) == "DO WHILE"
                This.GetCmdTip("DO WHILE")
        CASE ALLTRIM(CHRTRAN(This.cCmd2,CHR(9),"")) == "DO CASE"
                This.GetCmdTip("DO CASE")
        CASE ALLTRIM(CHRTRAN(This.cCmd2,CHR(9),"")) == "DO FORM"
            IF This.nWords > 2 OR lnMRUOffset=0
                This.GetCmdTip("DO FORM")
            ENDIF
        OTHERWISE
            IF This.nWords=1 AND lnMRUOffset=0
                * Handle DO case expansion in PRG
                LOCATE FOR UPPER(ALLTRIM(abbrev))=="DO" AND TYPE="C"
                IF FOUND()
                    leCase = IIF(EMPTY(ALLTRIM(case)),This.oFoxCode.DefaultCase,Case)
                    IF UPPER(leCase)#"X"
                        This.ReplaceWord(This.AdjustCase("DO",case))
                    ENDIF
                ENDIF
            ENDIF
            This.GetCmdTip("DOTIP")
        ENDCASE
    CASE INLIST(This.cCmd+ " ","REPL ","REPLA ","REPLAC ","REPLACE ")
        * Handle REPLACE field list
        SET DATASESSION TO (This.DSID)
        This.cAlias = ALIAS()
        SET DATASESSION TO (This.nSaveSession)
        IF This.ofoxcode.Location=0 AND !EMPTY(This.cAlias) AND This.nWords=1
            RETURN
        ENDIF
        IF This.nWords=1 AND ATC("REPLACE",This.oFoxCode.FullLine)=0
            RETURN
        ENDIF
        This.GetCmdTip("REPLTIP")
    CASE ATC("OPEN DATA",This.cCmd2)#0
        * Handle two word MRU with dropdown list (e.g. OPEN DATABASE)
        DO CASE
        CASE This.nWords=2 AND lnMRUOffset=0
            This.GetCmdTip("OPENDATATIP")
        CASE This.nWords > (1+lnMRUOffset)
            This.cCmd = "OPDB"
            LOCATE FOR UPPER(ALLTRIM(abbrev))=="OPEN" AND TYPE="C"
            leCase = IIF(FOUND(),Case,.F.)
            This.GetItemList(This.cCmd,.F.,"","",leCase)
        ENDCASE
    CASE INLIST(LEFT(This.cCmd,4),"MODI","REPO","LABE") AND This.nWords>1
        * Handle two word MRU with quick info
        DO CASE
        CASE This.nWords < 3 AND lnMRUOffset=1
            RETURN
        CASE INLIST(This.cCmd+ " ","MODI ","MODIF ","MODIFY ")
            This.cCmd = "MODIFY "+GETWORDNUM(This.cCmd2,2)
        CASE INLIST(This.cCmd+ " ","REPO ","REPOR ","REPORT ")
            This.cCmd = "REPORT FORM"
        CASE INLIST(This.cCmd+ " ","LABE ","LABEL ")
            This.cCmd = "LABEL FORM"
        OTHERWISE
            RETURN .F.
        ENDCASE
        This.GetCmdTip(This.cCmd)
    OTHERWISE
        RETURN .F.
    ENDCASE
ENDPROC

*#############################################################
PROCEDURE HandleCOps()
    * Special script handler for C++ type operators (++,--,+=,-=,*=,/=)
    LOCAL lnWordCount,lcNewWord,lclastWord,laOps,i,lnPos
    LOCAL lcVarName,lcPrefix,lcOpWord,lcSuffix
    lnWordCount=GETWORDCOUNT(This.cLine)
    IF VARTYPE(This.lExpandCOperators)#"L"  ;
               OR !This.lExpandCOperators OR lnWordCount>2
        RETURN .F.
    ENDIF
    lclastWord = GETWORDNUM(This.cLine,lnWordCount)
    lcNewWord = ""
    DIMENSION laOps[6]
    laOps[1] = "++"
    laOps[2] = "--"
    laOps[3] = "+="
    laOps[4] = "-="
    laOps[5] = "*="
    laOps[6] = "/="
    FOR i = 1 TO ALEN(laOps)
        lnPos = ATC(laOps[m.i],lclastWord)
        IF lnPos > 0
            lcVarName = LEFT(lclastWord,lnPos-1)
            IF EMPTY(lcVarName) AND lnWordCount>1
                lcPrefix = GETWORDNUM(This.cLine,lnWordCount-1)
            ELSE
                lcPrefix = lcVarName
            ENDIF
            lcOpWord = SUBSTR(lclastWord,lnPos,2)
            lcSuffix = SUBSTR(lclastWord,lnPos+2)
            EXIT
        ENDIF
    ENDFOR
    DO CASE
    CASE lnPos=0 OR (!EMPTY(lcVarName) AND lnWordCount=2) && nothing
    CASE (EMPTY(lcVarName) AND lnWordCount=1) OR (!ISALPHA(lcVarName)  ;
           AND !EMPTY(lcVarName))    && bad entry, skip it
    CASE INLIST(lcOpWord,"++","--") AND !EMPTY(lcSuffix)
                                 && skip if anything after ++, --
    CASE INLIST(RIGHT(lcVarName,1),"'","(","[")        && nothing
    OTHERWISE
        DO CASE
        CASE INLIST(lcOpWord,"++","--")
            lcSuffix = " " + LEFT(lcOpWord,1) + " 1"
        OTHERWISE
            lcSuffix = " " + LEFT(lcOpWord,1)  ;
                      + IIF(EMPTY(lcSuffix),""," ") + lcSuffix
        ENDCASE
        lcPrefix = CHRTRAN(lcPrefix,"?","")
        lcVarName = lcVarName + IIF(EMPTY(lcVarName),""," ")
        lcNewWord = lcVarName + "= " + lcPrefix + lcSuffix
        This.ReplaceWord(lcNewWord)
        RETURN
    ENDCASE
    RETURN .F.
ENDPROC

*#############################################################
PROCEDURE GetCmdTip(cCmd,cType)
    * Default CMD Tip handler -- displays a quick info tip for commands
    * Used by functions for parm tips
    * Used by default script handler
    * Skip for left and right arrows
    IF INLIST(This.nlastkey,4,19)
        RETURN
    ENDIF
    * Initialize stuff
    LOCAL aTmpItems, lSuccess, lcNewCmd, lcTip, lclastWord
    LOCAL lcScript, lnLastRec, lcWord, lcCase, i
    DIMENSION aTmpItems[1]
    IF This.lFoxCodeUnavailable
        RETURN
    ENDIF
    lcType = IIF(VARTYPE(cType)="C" AND !EMPTY(cType), cType, "C")
    lcLastWord = GETWORDNUM(This.cLine,This.nWords)
     IF !ALLTRIM(This.oFoxCode.UserTyped) == ALLTRIM(lcLastWord)
        lcLastWord = This.oFoxCode.UserTyped
    ENDIF

    * Locate Command
    SELECT tip, data, cmd, case FROM (_FoxCode) ;
      WHERE UPPER(ALLTRIM(expanded)) == UPPER(ALLTRIM(m.cCmd)) ;
                AND TYPE=UPPER(lcType) ;
      INTO ARRAY aTmpItems

    * This section is for lines multiple words SET TEXTMERGE or BROWSE
    * We need to parse word by word to try and locate actual command.
    IF _TALLY=0
        lnLastRec = 0
        lcWord = ""
        FOR i = 1 TO This.nWords
            lcWord = lcWord + UPPER(ALLTRIM(GETWORDNUM(cCmd,m.i)))
            LOCATE FOR UPPER(ALLTRIM(expanded))==lcWord AND TYPE=UPPER(lcType)
            IF FOUND()
                lnLastRec = RECNO()
                lcWord = lcWord + " "
            ELSE
                * Check for multi words such as ZOOM WINDOW -- 2nd pass only
                IF m.i=2 AND This.nWords=2
                    LOCATE FOR ATC(lcword, expanded)#0 AND TYPE=UPPER(lcType)
                    IF FOUND()
                        lnLastRec = RECNO()
                        lcWord = lcWord + " "
                    ENDIF
                ENDIF
                IF lnLastRec=0 OR (m.i=2 AND This.nWords>2)
                    lcWord = lcWord + " "
                    LOOP
                ENDIF

                * Most commands fall thru to here for Keyword
                GO lnLastRec
                IF UPPER(lcType)#"F"    &&skip for functions
                    * This function replaces typed in word with expanded keyword.
                    * Notes: issue with commands containing embedded functions --
                    *  there is no easy way to know if we're within a function or
                    *  still part of existing command:
                    *     ex. RETURN ALLTRIM(
                    *    ex. INSERT INTO foo (f1,f2) VALUES(
                    *  Also, we would have to parse all the way
                    *  parens:
                    *    ex. RETURN STRTRAN(myexpr, myexpr2,
                    *  Also, since native function is internally know, Ctrl+I to
                    *  trigger This tip.
                    This.ReplaceKeyWord(lcLastWord,Tip,case)
                ENDIF
                This.DisplayTip(ALLTRIM(Tip))
                RETURN
            ENDIF
        ENDFOR
        This.oFoxcode.ValueType = "V"
        RETURN
    ENDIF

    * SELECT statement found command
    lcTip = ALLTRIM(aTmpItems[1,1])
    lcScript = ALLTRIM(aTmpItems[1,2])
    lcNewCmd = ALLTRIM(aTmpItems[1,3])
    lcCase = ALLTRIM(aTmpItems[1,4])

    * This handles multiple commands found (e.g.,MODIFY FILE, CLEAR CLASS)
    IF EMPTY(lcNewCmd)
        IF UPPER(lcType)#"F"    &&skip for functions
            This.ReplaceKeyWord(lcLastWord,lcTip,lcCase)
        ENDIF
        This.DisplayTip(lcTip)
        RETURN
    ENDIF

    * Handle commands which have specified Scripts such as
    *  BUILD APP, SET ANSI, ON KEY LABEL
    IF ATC("{}",lcNewCmd)=0
        lcNewCmd = CHRTRAN(lcNewCmd,"{}","")
        LOCATE FOR UPPER(lcNewCmd) == UPPER(ALLTRIM(abbrev));
            AND UPPER(TYPE) = "S"
        IF !FOUND() OR EMPTY(data)
            This.DisplayTip(lcTip)
            RETURN
        ENDIF
        lcScript = ALLTRIM(data)
    ENDIF
    This.cScriptCmd = m.cCmd
    This.cScriptCase = m.lcCase
    This.oFoxCode.Case = m.lcCase
    SET DATASESSION TO (This.DSID)
    lSuccess = EXECSCRIPT(lcScript, This.oFoxCode)  && Execuates script
    SET DATASESSION TO (This.nSaveSession)

    * Display Tip
    IF VARTYPE(lSuccess)="L" AND !lSuccess
        This.DisplayTip(lcTip)
    ENDIF
    RETURN
ENDPROC

*#############################################################
PROCEDURE DisplayTip(tcValue)
    * Displays actual quick info tip
    * If Tips window is open, outputs here instead
    IF EMPTY(tcValue)
       RETURN
    ENDIF 
    IF This.lDebugScripts
       ASSERT .F. MESSAGE PROGRAM() 
    ENDIF 
    
    IF TYPE("_oFoxCodeTips.edtTips") = "O"
        
        _oFoxCodeTips.edtTips.Value = This.cLine + CHR(13) + tcValue
        This.oFoxCode.ValueType = "V"
    ELSE
        IF INLIST(This.nlastkey,4,19)
            RETURN
        ENDIF
        IF AT("q", _VFP.EditorOptions)#0 AND This.nlastkey#9
           RETURN
        ENDIF

        This.oFoxcode.ValueType = "T"
        This.oFoxcode.ValueTip = tcValue
    ENDIF
ENDPROC

*#############################################################
PROCEDURE GetCustomPEMs
    * This routine retrieves custom properties set in _Foxcode
    LOCAL laCustPEMs, lcProperty, lcPropValue, i, lcType
    IF This.lFoxCodeUnavailable
        RETURN
    ENDIF
    DIMENSION laCustPEMs[1]
    IF !This.GetFoxCodeArray(@laCustPEMs, This.cCustomPEMsID)
        RETURN
    ENDIF
    FOR i = 1 TO ALEN(laCustPEMs)
        IF EMPTY(ALLTRIM(laCustPEMs[m.i]))
            LOOP
        ENDIF
        lcProperty =  ALLTRIM(GETWORDNUM(laCustPEMs[m.i],1,"="))
        lcPropValue = ALLTRIM(SUBSTR(laCustPEMs[m.i] ;
                              ,ATC("=",laCustPEMs[m.i])+1))
        lcType = TYPE('EVALUATE(lcPropValue)')
        DO CASE
        CASE INLIST(lcType,"N","D","L","C")
            lcPropValue = EVALUATE(lcPropValue)
        CASE lcType="U" AND TYPE('lcPropValue')="C"
            * Property is Char, but doesn't need evaluating
        OTHERWISE
            LOOP
        ENDCASE
        This.AddProperty(lcProperty,lcPropValue)
    ENDFOR
ENDPROC

*#############################################################
PROCEDURE HandleCustomScripts
    * Executes custom user plug-in scripts to the default script handler
    * Note: a user custom default script must provide a single parameter
    * for ref to This object. If .F. returned, then assume that no scripts
    * were executed and continue.
    LOCAL laCustScripts, i, leScriptRetVal

    IF VARTYPE(This.lAllowCustomDefScripts)#"L" ;
        OR !This.lAllowCustomDefScripts ;
        OR This.lFoxCodeUnavailable
        RETURN .F.
    ENDIF

    DIMENSION laCustScripts[1]
    IF !This.GetFoxCodeArray(@laCustScripts, This.cCustomScriptsID)
        RETURN .F.
    ENDIF
    * Loop thru and handle all the custom scripts
    FOR i = 1 TO ALEN(laCustScripts)
        IF !This.RunScript(laCustScripts[m.i], @leScriptRetVal, .T.)
            LOOP
        ENDIF
        * leScriptRetVal return codes:
        *  .F. - script not handled, loop and try another
        *  .T. - script handled, exit
        *  Other - script handled, exit
        DO CASE
        CASE VARTYPE(leScriptRetVal)="L" AND !leScriptRetVal
            * Script not handled. Let's try another.
            * Note: a script can execute here and delegate to
            * another as long as .F. is returned.
            LOOP
        CASE VARTYPE(leScriptRetVal)="L" AND leScriptRetVal
            * Script handled properly
            RETURN
        OTHERWISE
            * Script handled properly
            RETURN leScriptRetVal
        ENDCASE
    ENDFOR
    RETURN .F.
ENDPROC

*#############################################################
PROCEDURE RunScript(cScript, leRetVal, lPassThis)
    * Generic script to  execute a script in _Foxcode.
    *   cScript - script to run (required)
    *   leRetVal - var for script return value - must be passed by ref
    *   lPassThis - whether to pass This object ref option (optional).
    *    efficient than passing a parameters since users
    IF EMPTY(ALLTRIM(cScript)) OR This.lFoxCodeUnavailable
        RETURN .F.
    ENDIF
    IF This.lDebugScripts 
        DEBUGOUT "RunScript " + cScript + " from " + PROGRAM(PROGRAM(-1))  
    ENDIF 
        
    This.cCustomScriptName = ALLTRIM(cScript)
    LOCAL aTmpItems
    DIMENSION aTmpItems[1]
    SELECT Data FROM (_FoxCode);
       WHERE UPPER(ALLTRIM(Abbrev)) == UPPER(ALLTRIM(cScript))  ;
         AND Type = "S" ;
       INTO ARRAY aTmpItems
    IF _TALLY=0 OR EMPTY(ALLTRIM(aTmpItems))
        RETURN .F.
    ENDIF
    IF VARTYPE(lPassThis)="L" AND lPassThis
        leRetVal = EXECSCRIPT(aTmpItems, This)
    ELSE
        * Default assume oFoxCode parameter like normal scripts
        leRetVal = EXECSCRIPT(aTmpItems, This.oFoxCode)
    ENDIF
ENDPROC

*#############################################################
FUNCTION GetFoxCodeArray(taArray, tcScriptID)
    * Retrieves contents of _FOXCODE as an array
    LOCAL aTmpItems, lcProperty, lcPropValue, aTmpData, i, lnLines
    IF VARTYPE(tcScriptID)#"C" OR EMPTY(tcScriptID)
        RETURN .F.
    ENDIF
    DIMENSION aTmpItems[1]
    SELECT data FROM (_FoxCode) ;
      WHERE UPPER(ALLTRIM(abbrev)) == UPPER(tcScriptID) ;
      INTO ARRAY aTmpItems
    IF _TALLY = 0 OR EMPTY(ALLTRIM(aTmpItems))
        RETURN .F.
    ENDIF
    DIMENSION aTmpData[1]
    lnLines = ALINES(aTmpData,ALLTRIM(aTmpItems[1]))
    DIMENSION taArray[ALEN(aTmpData)]
    ACOPY(aTmpData,taArray)
ENDFUNC


*#############################################################
PROCEDURE GetItemList(cKey, lDontSort, cScript ;
                     , cTipSource, eConvertCase)
    * Displays a List Members style dropdown of items for user to select
    LOCAL lnTally,aTmpItems,i,lcCase
    IF AT("q", _VFP.EditorOptions)#0 AND This.nlastkey#9
       RETURN
    ENDIF
    IF This.lDebugScripts 
       DEBUGOUT "GetItems "+ cKey + " from " + PROGRAM(PROGRAM(-1))  
    ENDIF     
    
    DIMENSION aTmpItems[1]
    cKey = UPPER(LEFT(ALLTRIM(cKey),5))
    IF EMPTY(m.cTipSource)
        cTipSource = "menutip"
    ENDIF
    IF UPPER(This.oFoxCode.Type) # "F"
        * Handle case where we want not display items already selected such
        * as keywords for USE commands
        SELECT menuitem, &cTipSource. FROM (This.FoxCode2);
            WHERE UPPER(ALLTRIM(key)) == m.cKey ;
            AND ATC(" "+ALLTRIM(menuitem),This.cLine)=0 ;
            INTO ARRAY aTmpItems
    ELSE
        SELECT menuitem, &cTipSource. FROM (This.FoxCode2);
            WHERE UPPER(ALLTRIM(key)) == m.cKey ;
            INTO ARRAY aTmpItems
    ENDIF
    lnTally = _TALLY
    IF lnTally=0
        RETURN ""
    ENDIF
    This.oFoxcode.ValueType = "L"
    IF VARTYPE(m.cScript)="C" AND !EMPTY(m.cScript)
          This.oFoxcode.ItemScript = m.cScript
    ENDIF
    IF VARTYPE(m.lDontSort)="L" AND m.lDontSort
        This.oFoxcode.ItemSort = .F.
    ENDIF
    IF VARTYPE(m.eConvertCase)="L" AND m.eConvertCase ;
       OR VARTYPE(m.eConvertCase)="C"
        lcCase = m.eConvertCase
        IF VARTYPE(lcCase)#"C"
            lcCase = UPPER(This.oFoxCode.Case)
        ENDIF
        IF EMPTY(ALLTRIM(lcCase)) && Use default case
            lcCase = This.oFoxCode.DefaultCase
        ENDIF
        IF UPPER(lcCase)="X"
            lcCase = "M"
        ENDIF
        FOR i = 1 TO ALEN(aTmpItems,1)
            aTmpItems[m.i,1] = This.AdjustCase(aTmpItems[m.i,1],lcCase)
        ENDFOR
    ENDIF
    DIMENSION This.oFoxcode.Items[lnTally ,2]
    ACOPY(aTmpItems,This.oFoxcode.Items)
    
    IF lnTally > 0 AND This.nWinHdl > 0 AND This.nPosSt > 0 ;
       AND This.cPosChar  = _EDGETCHAR(This.nWinHdl, This.nPosSt - 1) ;
       AND INLIST(This.cPosChar, "(", "=") 
         _EDINSERT(This.nWinHdl, " ", 1) 
    ENDIF 
    RETURN cKey
ENDPROC

*#############################################################
PROCEDURE GetSysTip(cItem, cKey)
    * Special handler for SYS() functions

    LOCAL lnTally,aTmpItems,lcTip
    DIMENSION aTmpItems[1]
    SELECT syntax2,menutip FROM (This.FoxCode2);
        WHERE UPPER(ALLTRIM(key)) == cKey ;
        AND UPPER(ALLTRIM(key2)) == cItem ;
        INTO ARRAY aTmpItems
    lnTally = _TALLY
    IF lnTally=0
        RETURN ""
    ENDIF
    lnTally = _TALLY
    lcTip = ALLTRIM(aTmpItems[1]) + CRLF + CRLF ;
                + ALLTRIM(aTmpItems[2]) + CRLF
    This.DisplayTip(lcTip)
ENDPROC

*#############################################################
PROCEDURE AdjustCase(cItem, cCase)
    * Adjusts case of keyword expanded to that in _Foxcode script.
    
    IF PCOUNT()=0
        cItem = ALLTRIM(This.oFoxcode.Expanded)
        cCase = This.oFoxcode.Case
    ENDIF
    * Use Version record default if empty
    IF EMPTY(ALLTRIM(m.cCase))
        cCase = This.oFoxCode.DefaultCase
        IF EMPTY(ALLTRIM(m.cCase))
            cCase = "M"
        ENDIF
    ENDIF
    DO CASE
    CASE UPPER(m.cCase)="U"
         RETURN UPPER(m.cItem)
    CASE UPPER(m.cCase)="L"
         RETURN LOWER(m.cItem)
    CASE UPPER(m.cCase)="P"
         RETURN PROPER(m.cItem)
    CASE UPPER(m.cCase)="M"
         RETURN m.cItem
    CASE UPPER(m.cCase)="X"
         RETURN ""
    OTHERWISE
         RETURN ""
    ENDCASE
ENDPROC

*#############################################################
PROCEDURE ReplaceKeyWord(cReplWord,cReplTip,cReplCase)
    * Routine used by the default script find&replace keywords.
    LOCAL lcLastWord

    IF This.lDebugScripts
       ASSERT .F. 
    ENDIF 
    
    * Skip for no expansion settings
    IF UPPER(cReplCase)="X"
        RETURN .F.
    ENDIF
    IF EMPTY(ALLTRIM(cReplCase))
        cReplCase = This.oFoxCode.DefaultCase
        IF UPPER(cReplCase)="X"
            RETURN .F.
        ENDIF
        IF EMPTY(ALLTRIM(cReplCase))
            cReplCase = "M"
        ENDIF
    ENDIF

    * Skip if comma (not supported -> REPLACE fieldname1
    IF This.nlastkey = 44
        RETURN .F.
    ENDIF

    * Skip if custom property set
    IF VARTYPE(This.lKeywordCapitalization)#"L" ;
        OR !This.lKeywordCapitalization
        RETURN .F.
    ENDIF

    lcLastWord = This.GetKeyWord(cReplWord,cReplTip)
    IF EMPTY(lcLastWord)
        RETURN .F.
    ENDIF
    lcLastWord = This.AdjustCase(lcLastWord,cReplCase)

    * Skip for first word
    IF UPPER(lcLastWord)==UPPER(GETWORDNUM(cReplTip,1))
        RETURN ""
    ENDIF

    RETURN This.ReplaceWord(lcLastWord,.T.)
ENDPROC

*#############################################################
PROCEDURE GetKeyWord(cLastWord,cTip)
    * This routine searches tip for keyword match of lcLastWord
    * delimeters include - space, tab, comma, |, [, ]

    LOCAL lcPrevWord,lnWords,i,lcNextWord,lnPos
    lcPrevWord = UPPER(ALLTRIM(GETWORDNUM(This.cLine,This.nWords-1)))
    lnWords = GETWORDCOUNT(cTip)

    * Check if we're in quotes
    IF This.IsInQuotes() && skip if within quotes
        RETURN ""
    ENDIF

    * Some special case for SQL Select since it has parser
    IF UPPER(This.cCmd)=="SELECT"
        * Skip for "FROM" clause
        IF UPPER(lcPrevWord)=="FROM"
            RETURN ""
        ENDIF
        IF This.nWords=2 AND !INLIST(UPPER(cLastWord)+" " ;
                                    ,"ALL ","TOP ","DISTINCT ")
            RETURN ""
        ENDIF
    ENDIF

    * Handle common operators
    IF INLIST(UPPER(cLastWord)+" ","AND ","OR ","NOT ")
        RETURN cLastWord
    ENDIF

    * Check for keyword followed by lists and expressions
    *  ex. BROWSE [FIELDS FieldList]
    *  ex. SUM ... [TO MemVarList | TO ARRAY ArrayName]
    IF AT(lcPrevWord+" "+UPPER(cLastWord),cTip)=0 AND This.nWords>2
        * Valid case to skip (e.g., TO ARRAY arrayname)
        * must be exact uppercase match
        FOR i = 1 TO (lnWords-1)
            IF INLIST(GETWORDNUM(cTip,m.i)+" " ;
                , "["+lcPrevWord+" ", "|"+lcPrevWord+" ", lcPrevWord+" ")
                lcNextWord = GETWORDNUM(cTip,m.i+1)
                DO CASE
                CASE LEFT(lcNextWord,1)="[" AND RIGHT(lcNextWord,1)="]"
                    IF ATC(cLastWord,STREXTRACT(lcNextWord,"[","]"))#0
                        EXIT
                    ENDIF
                    IF lnWords>m.i+1
                        lcNextWord = GETWORDNUM(cTip,m.i+2)
                    ENDIF
                CASE lcNextWord = "|" AND lnWords>m.i+1
                    lcNextWord = GETWORDNUM(cTip,m.i+2)
                    IF UPPER(lcNextWord)=lcNextWord AND lnWords>m.i+2
                        lcNextWord = GETWORDNUM(cTip,m.i+3)
                    ENDIF
                ENDCASE
                IF (ISALPHA(lcNextWord) OR ISALPHA(;
                     CHRTRAN(lcNextWord,"[",""))) AND UPPER(lcNextWord)#lcNextWord
                    RETURN ""
                ENDIF
            ENDIF
        ENDFOR
    ENDIF

    * Special case Handle for SCOPE clause
    IF ATC("[Scope]",cTip)#0  ;
      AND INLIST(UPPER(cLastWord)+" ","ALL ","REST ","NEXT " ;
               ,"RECO ","RECOR ","RECORD ")
        IF ATC(cLastWord,"RECORD")#0
            cLastWord = "RECORD"
        ENDIF
        RETURN cLastWord
    ENDIF

    DIMENSION aKeyWords[1]
    ALINES(aKeyWords,cTip,"[","|"," ","]")

    * Search for exact match
    IF ASCAN(aKeyWords,UPPER(cLastWord),-1,-1,-1,6) > 0
        RETURN cLastWord
    ENDIF

    * Search for close match expansion, skip for < 4 chars
    IF LEN(cLastWord) < 4
        RETURN ""
    ENDIF
    lnPos = ASCAN(aKeyWords,UPPER(cLastWord),-1,-1,-1,4)
    IF lnPos > 0
        RETURN aKeyWords[lnPos]
    ENDIF
    RETURN ""
ENDPROC

*#############################################################
PROCEDURE ReplaceWord(cNewWord,lComplexParse)
    * Generic routine that uses Editor API routines to replace
    * Has special parameter to handle special parsing for VFP on Quick
    * tip syntax.
    LOCAL lcfxtoollib,lnretcode,env,lcNewWord,lcChar
    LOCAL lnEndPos,lnStartPos,lcLastWord,lnDiff,lcSaveLib,lnStartPos2

    * lComplexParse - used mainly script for Complex VFP parsing
    *  of command keywords.
    IF This.lDebugScripts 
       DEBUGOUT "ReplaceWord " + " from " + PROGRAM(PROGRAM(-1))  
       * ASSERT .F. 
    ENDIF 
    
    lcNewWord = cNewWord
    IF INLIST(This.nLastKey,19,4)
        RETURN .F.
    ENDIF
    lcfxtoollib = SYS(2004)+"FOXTOOLS.FLL"
    IF !FILE(lcfxtoollib)
        RETURN .F.
    ENDIF
    SET LIBRARY TO (m.lcfxtoollib) ADDITIVE
    This.nWinHdl = _wontop()
    IF This.nWinHdl = 0
        RETURN .F.
    ENDIF

    * Check environment of window
    * Check for selection, empty file or read-only file
    DIMENSION env[25]
    lnretcode = _EdGetEnv(This.nWinHdl,@env)
    IF lnretcode#1 OR (EMPTY(env[EEfilename]) AND env[EElength]=0) ;
        OR env[STSEL]#env[ENDSEL] OR env[EElength]=0 OR env[EEreadOnly]#0
        This.nWinHdl = 0
        RETURN .F.
    ENDIF

    * Get end position of last word
    lnEndPos = env[STSEL]-1
    DO WHILE .T.
        lcChar = _EDGETCHAR(This.nWinHdl,lnEndPos)
        IF TYPE("lcChar")#"C" OR lnEndPos<=0
            * something failed
            RETURN .F.
        ENDIF
        IF !(lcChar$ENDCHARS)
            EXIT
        ENDIF
        lnEndPos = lnEndPos - 1
    ENDDO
    
    * Get start position of last word
    lnStartPos = lnEndPos
    DO WHILE .T.
        lcChar = _EDGETCHAR(This.nWinHdl,lnStartPos)
        IF VARTYPE(lcChar)#"C"
            * something failed
            RETURN .F.
        ENDIF

        * Look for character that indicates a new word
        *  ENDCHARS - CHR(13),CHR(9),CHR(32)
        IF !lComplexParse
            IF lcChar$ENDCHARS
                EXIT
            ENDIF
        ELSE
            * Quick check for valid replacement word
            IF GETWORDCOUNT(cNewWord)>1
                RETURN .F.
            ENDIF
            * Special handling for default script
            *  ex. make sure we are not in a function with a space after "("
            IF lcChar$ENDCHARS
                lnStartPos2 = lnStartPos
                DO WHILE lcChar$ENDCHARS
                    lcChar = _EDGETCHAR(This.nWinHdl,lnStartPos2)
                    IF VARTYPE(lcChar)#"C" OR lnStartPos2<1
                        EXIT
                    ENDIF
                    lnStartPos2 = lnStartPos2-1
                ENDDO
                IF !ISALPHA(lcChar) ;
                 AND !INLIST(lcChar,"'",'"',"]",")",";") AND !ISDIGIT(lcChar)
                    RETURN .F.
                ENDIF
                EXIT
            ENDIF
            IF !ISALPHA(lcChar) ;
                AND !INLIST(lcChar,"'",'"',"]",")") AND !ISDIGIT(lcChar)
                RETURN .F.
            ENDIF
        ENDIF
        lnStartPos = lnStartPos - 1
    ENDDO

    * Perform actual text replacement here
    lnStartPos = lnStartPos + 1
    lcLastWord=_EDGETSTR(This.nWinHdl,lnStartPos,lnEndPos)
    IF !lcLastWord == lcNewWord
        lnDiff = env[STSEL] - lnEndPos - 1
        _EDSELECT(This.nWinHdl,lnStartPos,lnEndPos+1)
        _EDDELETE(This.nWinHdl)
        _EDINSERT(This.nWinHdl,lcNewWord ,LEN(lcNewWord))
        _EDSETPOS(This.nWinHdl,_EDGETPOS(This.nWinHdl) + lnDiff)
    ENDIF
    This.nWinHdl = 0
ENDPROC

*#############################################################
FUNCTION IsInQuotes
    * Functions returns whether current editor position is at a location
    * that it will be part of a string when close quote is added.
    LOCAL i, lcChar, lInQuote, lcQuoteChar
    FOR i = 1 TO LEN(This.cLine)
        lcChar = SUBSTR(This.cLine,m.i,1)
        IF !lInQuote
            IF INLIST(lcChar,'"',"'","[")
                lInQuote = .T.
                lcQuoteChar = lcChar
            ENDIF
        ELSE
            IF (lcQuoteChar="[" AND lcChar="]") ;
                OR (lcChar==lcQuoteChar AND lcQuoteChar#"[")
                lInQuote = .F.
            ENDIF
        ENDIF
    ENDFOR
    RETURN lInQuote
ENDFUNC

*#############################################################
PROCEDURE CheckFoxCode
    * Checks if FoxCode can be opened
    IF EMPTY(_FOXCODE) OR !FILE(_FOXCODE)
        This.lFoxCodeUnavailable = .T.
        RETURN
    ENDIF
    This.lHideScriptErrors = .T.
    SELECT 0
    USE (_FOXCODE) SHARED
    IF EMPTY(ALIAS())
        This.lFoxCodeUnavailable = .T.
    ENDIF
    This.lHideScriptErrors = .F.
ENDPROC

*#############################################################
PROCEDURE Init
    This.cTalk = SET("TALK")
    SET TALK OFF
    This.nLangOpt = _VFP.LanguageOptions
    IF This.nLangOpt#0
        _VFP.LanguageOptions=0
    ENDIF
    This.cMessage = SET("MESSAGE",1)
    This.cMsgNoData = SET("NOTIFY",2)
    SET NOTIFY CURSOR OFF
    This.cEscapeState = SET("ESCAPE")
    SET ESCAPE OFF
    This.lFoxCode2Used=USED("FoxCode2")
    This.cExcl=SET("EXCLUSIVE")
    SET EXCLUSIVE OFF
    This.cSYS3054=SYS(3054)        && Debug mode 
    SYS(3054,0)
    This.nSaveSession = This.DataSessionId
    This.cSaveLib = SET("LIBRARY")
    This.cSaveUDFParms = SET("UDFPARMS")
    SET UDFPARMS TO VALUE
    SET EXACT ON 
    This.nSaveTally = _TALLY
    This.cSYS2030=SYS(2030)        && Rushmore optimazation
ENDPROC

*#############################################################
PROCEDURE Destroy
    LOCAL lcfxtoollib
    IF ATC("FOXTOOLS",SET("LIBRARY"))#0  ;
        AND ATC("FOXTOOLS",This.cSaveLib)=0
        lcfxtoollib = SYS(2004)+"FOXTOOLS.FLL"
        RELEASE LIBRARY (lcfxtoollib)
    ENDIF
    IF This.cEscapeState="ON"
        SET ESCAPE ON
    ENDIF
    IF USED("FoxCode2") AND !This.lFoxCode2Used
        USE IN FoxCode2
    ENDIF
    IF This.cTalk="ON"
        SET TALK ON
    ENDIF
    IF This.cExcl="ON"
        SET EXCLUSIVE ON
    ENDIF
    SYS(3054,INT(VAL(This.cSYS3054)))
    IF This.nLangOpt#0
        _VFP.LanguageOptions=This.nLangOpt
    ENDIF
    IF This.cSaveUDFParms="REFERENCE"
        SET UDFPARMS TO REFERENCE
    ENDIF
    _TALLY=This.nSaveTally
    IF This.cMsgNoData = "ON"
        SET NOTIFY CURSOR ON
    ENDIF
    SYS(2030,INT(VAL(This.cSYS2030)))
ENDPROC

*#############################################################
* DO GetInterface in foxCode
PROCEDURE GetInterface()
    LOCAL lcData
    
    PUBLIC _loInts AS Ints OF typelibs.vcx
    _loInts = NEWOBJECT([Ints], [typelibs.vcx]) 
    _loInts.Show() 
    lcData = _loInts.cRetval
    RELEASE _loInts
    RETURN lcData
ENDPROC

PROCEDURE FindFoxTools()
	* Try to locate FOXTOOLS, especiall for runtime apps.
	* User can also set it explicitly if they want.
	DO CASE
	CASE FILE(THIS.cFoxTools)
		* Skip if file is already set
	CASE FILE(SYS(2004)+"FOXTOOLS.FLL")
		THIS.cFoxTools = SYS(2004)+"FOXTOOLS.FLL"
	CASE FILE(HOME(1)+"FOXTOOLS.FLL")
		THIS.cFoxTools = HOME(1)+"FOXTOOLS.FLL"
	CASE FILE(ADDBS(JUSTPATH(_CODESENSE))+"FOXTOOLS.FLL")
		THIS.cFoxTools = ADDBS(JUSTPATH(_CODESENSE))+"FOXTOOLS.FLL"
	CASE FILE(ADDBS(JUSTPATH(_FOXCODE))+"FOXTOOLS.FLL")
		THIS.cFoxTools = ADDBS(JUSTPATH(_FOXCODE))+"FOXTOOLS.FLL"
	ENDCASE
ENDPROC


*#############################################################
PROCEDURE Error(nError,cMethod,nLine)
    LOCAL lcErr
    This.lHadError = .T.
    IF This.lHideScriptErrors
        RETURN
    ENDIF
    IF INLIST(nError,3)
        WAIT WINDOW FOXERR2_LOC+MESSAGE()
    ELSE
        TEXT TO lcErr TEXTMERGE NOSHOW PRETEXT 2
        A FoxCode script error has occured.
          Error:   <<TRANS(m.nError)>>
          Method:  <<m.cMethod>>
          Line:    <<TRANS(m.nLine)>>
          Message: <<MESSAGE()>>
        ENDTEXT
        STRTOFILE(m.lcErr, HOME()+"foxcode.err",.T.)
        ACTIVATE SCREEN
        ? lcErr
    ENDIF
    IF This.lDebugScripts
        SET STEP ON
        RETRY
    ENDIF
ENDPROC

ENDDEFINE
*#############################################################

* Function referencies of foxutil.fll for project compiler 
PROCEDURE _wontop
PROCEDURE _edgetenv
PROCEDURE _edsetenv
PROCEDURE _edgetchar
PROCEDURE _edselect
PROCEDURE _edgetstr
PROCEDURE _eddelete
PROCEDURE _edinsert
PROCEDURE _edsetpos
PROCEDURE _edgetpos

*#############################################################
#DEFINE RESIZE_SECTION 

#DEFINE ISNEEDALIGN TYPE(".Controls(lnI).cAlignment") == "C"  ;
                     AND LEN(.Controls(lnI).cAlignment) > 0   ;
                     AND ATC("1" , .Controls(lnI).cAlignment) # 0  
                     
#DEFINE SPECALIGN   ATC("X", .Controls(lnI).cAlignment) # 0 

*#############################################################
FUNCTION FrmResizeLoad(toForm as Form)

  WITH toForm 
    * for resize changes 
    .AddProperty("nOldWidth",  .Width)
    .AddProperty("nOldHeight", .Height) 

    * for some hook cases : 
    =TYPE(".uRetVal") = 'U' AND .AddProperty("uRetVal", .T.)    
    .uRetVal = .T.
  ENDWITH 

*#############################################################
FUNCTION FrmResize(toForm as Form)

 WITH toForm 
     ASSERT UPPER(.BaseClass) = 'FORM'
     ASSERT TYPE([.nOldWidth]) = 'N' 
     
     IF .Visible 
        .LockScreen = .T.                          && locks form
     ENDIF    
     nDeltaY = .Height - .nOldHeight            && formos aukscio pokytis
     nDeltaX = .Width -  .nOldWidth             && formos plocio pokytis

     FOR lnI = 1 TO .ControlCount               && per formos objektus
         ASSERT !EMPTY(.Controls(lnI).Name) MESSAGE "Bad Ctrl "  
         IF ISNEEDALIGN   
            IF .lDebugScripts 
               * ASSERT .F.
            ENDIF 
            IF SPECALIGN 
               .Controls(lnI).ObjectAlign(nDeltaY, nDeltaX)                        
            ELSE    
               =CntResize(.Controls(lnI), (nDeltaY), (nDeltaX))
                                                && recursion 
             ENDIF 
         ENDIF
     ENDFOR
     IF PEMSTATUS(toForm, "OnResize", 5)
        .OnResize()                              && additive method
     ENDIF    

     .nOldHeight = .Height                       && new size 
     .nOldWidth  = .Width                        
     IF .Visible 
        .LockScreen = .F.
     ENDIF 
     RETURN .T. 
 ENDWITH 

*####################################################################################
FUNCTION CntResize          && Container Resize 
*####################################################################################
LPARAMETERS oObject, nDeltaY, nDeltaX, cAlignment, nDeltaT, nDeltaL    

* oObject               && (O) resizing object
* nDeltaY, nDeltaX      && (N) object heigth/width changes
* cAlignment            && (C) alignment property  
* nDeltaT, nDeltaL      && (N) delta Top, delta Left 

LOCAL lnI, lnJ, lnK                              && counters

oObject = IIF(TYPE("oObject.Name") # 'C', This, oObject)             
WITH oObject 
 DEBUGOUT "CNTRESIZE(" + .Name + " of " + .BaseClass  ;
          + ", Dy "+ TRANSF(nDeltaY)  + ", Dx "+ TRANSF(nDeltaX)  ;
          + ", cAl "+ TRANSF(cAlignment)  ;
          + " = "   + IIF(TYPE(".cAlignment") = 'C', TRANSF(.cAlignment), "<->")  ;
          + ")  Frm " + IIF(TYPE("_SCREEN.ActiveForm.Caption") = 'C' ;
                  , TRANSF(_SCREEN.ActiveForm.Caption), "<no ActFrm>")
                           
 LOCAL nHeight, nWidth
 
 IF .Parent.BaseClass = "Page"               && object on PageFrame'o page (without properties Height ir Width)
    nHeight = .Parent.Parent.PageHeight
    nWidth  = .Parent.Parent.PageWidth
 ELSE                                        && object from usual container
    nHeight = .Parent.Height
    nWidth  = .Parent.Width
 ENDIF
 cAlignment = IIF(EMPTY(cAlignment), .cAlignment, cAlignment)
 IF ! ATC("X" , cAlignment ) # 0  
     IF LEN(cAlignment) > 4 ;
        AND SUBSTR(cAlignment, 5, 1) = "1"          && Center by Y
        .Top = INT((nHeight - .Height) / 2)
     ENDIF
     IF LEN(cAlignment) > 5 ;
        AND  SUBSTR(cAlignment, 6, 1) = "1"         && Center by X
        .Left = INT((nWidth - .Width) / 2)
     ENDIF

     IF LEN(cAlignment) > 2 ;
        AND SUBSTR(cAlignment, 3, 1) = "1"          && Move by Y
        .Top = .Top + nDeltaY
     ENDIF
     IF LEN(cAlignment) > 3 ;
        AND SUBSTR(cAlignment, 4, 1) = "1"          && Move by X
        .Left = .Left + nDeltaX
     ENDIF

     IF LEN(cAlignment) > 0 AND SUBSTR(cAlignment, 1, 1) = "1" ;
        AND .Height + nDeltaY > 0                   && Resize by Y
        .Height = .Height + nDeltaY
     ELSE 
        nDeltaY = 0   
     ENDIF
     IF LEN(cAlignment) > 1 AND SUBSTR(cAlignment, 2, 1) = "1" ;
        AND .Width + nDeltaX > 0                    && Resize by X
        .Width = .Width + nDeltaX
     ELSE 
        nDeltaX = 0   
     ENDIF
     *   nDeltaT, nDeltaL  - (N) Delta Top, Delta Left 
 ELSE
     .ObjectAlign(nDeltaY, nDeltaX)  
     RETURN .T. 
 ENDIF     
 IF nDeltaX = 0 AND nDeltaY = 0
     RETURN .T.
 ENDIF
 
 DO CASE     
  CASE UPPER(oObject.BaseClass) = "CONTAINER" 
   FOR lnI = 1 TO oObject.ControlCount           && cycle container's objects
       WITH oObject
         IF ISNEEDALIGN 
            IF SPECALIGN 
               .Controls(lnI).ObjectAlign(nDeltaY, nDeltaX)                        
            ELSE    
               =CntResize(.Controls(lnI), (nDeltaY), (nDeltaX))
                                                 && recursion 
            ENDIF 
         ENDIF
       ENDWITH
   ENDFOR
   
 CASE UPPER(oObject.BaseClass) = "PAGEFRAME"
   FOR lnJ = 1 TO oObject.PageCount              && cycle pageframe's objects
       WITH oObject.Pages(lnJ)
            FOR lnI = 1 TO .ControlCount         && cycle page's objects
              IF ISNEEDALIGNPG 
                 IF SPECALIGN 
                   .Controls(lnI).ObjectAlign(nDeltaY, nDeltaX)                        
                 ELSE    
                   =CntResize(.Controls(lnI), (nDeltaY), (nDeltaX))
                                                 && recursion 
                 ENDIF 
              ENDIF    
            ENDFOR
       ENDWITH
   ENDFOR
   
 ENDCASE 
 RETURN .T.                                      && for debugging 
ENDWITH 

* DEBUG 
* _CODESENSE = [D:\VfpLib\Sys\addin\XCode\foxcode.fxp]
* _CODESENSE = [E:\SYSTEM\VFPCFG\XCODE.APP]
