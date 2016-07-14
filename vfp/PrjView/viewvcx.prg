* ViewVcx - VFP .vcx/.scx -> .prg file converter ... 

* Revision 1.11  2006/05/10 06:22:22  andriusk * v3 class
* Revision 1.10  2004/11/04 16:42:14  andriusk * fixed objectname lowercase
* Revision 1.6  2004/07/14 11:04:04  andriusk * sort methods normal (not for objects), fullpath fix
* Revision 1.2  2004/05/11 16:24:28  andriusk * .VCX export indents/beautify/sort methods
* ViewVcx ###############################################################################
LPARAMETERS tcFile 

*#INCLUDE Viewvcx_Inc.h
#INCLUDE D:\VfpLib\Sys\ViewVcx_Inc.h 

#DEFINE MAXVARLEN  50 
#DEFINE MAXPATH    254  
#DEFINE RETVAL     toBrowser.vResult

#DEFINE FTEST      .F.
#DEFINE FTEST2     .F.
#DEFINE FTESTMETH  .F.

#DEFINE FTESTCURS  .F.
#DEFINE FTESTCLS   .F. 

 SET ASSERTS ON 

 PUBLIC goSBrow   AS GenericBrowser OF D:\Vfplib\sys\ViewVcx.prg  
 PUBLIC goParser  AS VcxParser      OF D:\Vfplib\sys\ViewVcx.prg   
 
 goSBrow =  NEWOBJECT( "GenericBrowser", "", "", .T. ) 
 goParser = NEWOBJECT( "VcxParser" ) 

 IF ! EMPTY( tcFile ) 
    tcFile = TRANSFORM( tcFile  )
    goSBrow.cParamStr = tcFile 
    IF ".NOSHOW" $ tcFile OR ".NOVIEW" $ tcFile 
      goSBrow.lShowFile = .F. 
    ENDIF 
    IF FILE( tcFile ) 
       goSBrow.cFileName = PROPER( tcFile ) 
    ENDIF 
 ENDIF 
 
 =BrwExportClass( goSBrow, goSBrow.lShowFile , .T. ) 
 
 IF ! FTEST2
    RELEASE goSBrow 
    RELEASE goParser 
 ENDIF

DEFINE CLASS GenericBrowser AS Custom 

 #IF .F. 
     PRIVATE This AS GenericBrowser IN D:\Vfplib\sys\ViewVcx.prg 
 #ENDIF 
 *-- ret  
  uRetVal  =  .T. 
  vResult  =  ""
 *-- modes  
  lSCXMode = .F.
  lFileMode  = .T. 
  lShowFile = .T.
  
  lRelease = .F.  
 *-- classes
  nClassCount  =  0 
  nClassListIndex = 0 
  DIMENSION aClassList[ 1, 8 ] 
  
 *-- files 
  cFileName  =  ""
  cAlias    =  "" 
  cViewCodeFileName = "" 
  cProgramPath = ""
  cParamStr = ""

  FUNCTION Init( tExtra1 )  
    * SYS(3099, 80) 
    SET ANSI  ON 
    SET EXACT ON 
    SET NEAR  ON 
    RETURN .T. 
 
  FUNCTION Destroy() 
    IF USED( "CClsList" )
       USE IN cClsList  
    ENDIF 
    SET ANSI  ON 
    SET EXACT ON 
    SET NEAR  ON 
    
    RETURN .T. 

  FUNCTION FULLPATH( lcFileName, lLower )
  
     && SYS(2014, cFileName [, Path]) - minimum path * 
     LOCAL lcStr 
     lcStr = FULLPATH( lcFileName ) 
     IF RATC( "\VFPLIB", lcStr ) # 0 
        lcStr = SUBSTR( lcStr, RATC( "\VFPLIB", lcStr ) ) 
     ENDIF 
     IF RATC( "\VFP8LIB", lcStr ) # 0 
        lcStr = SUBSTR( lcStr, RATC( "\VFP8LIB", lcStr ) ) 
     ENDIF 
     IF RATC( "\VFP6LIB", lcStr ) # 0 
        lcStr = SUBSTR( lcStr, RATC( "\VFP6LIB", lcStr ) ) 
     ENDIF 
     IF RATC( "\SYSTEM32", lcStr ) # 0 
        lcStr = SUBSTR( lcStr, RATC( "\SYSTEM32", lcStr ) ) 
     ENDIF 
     IF lLower
        lcStr = LOWER( lcStr ) 
     ENDIF 
     RETURN lcStr

  FUNCTION ParseClassLib
    
    LOCAL lcAlias, lcFileName  
    IF EMPTY( ALIAS() ) ;
         OR ( ! ".VCX" $ UPPER( DBF() ) ;
              AND  ! ".SCX" $ UPPER( DBF() )  ) 
           
        SELECT 0 
        lcAlias     =  "VCX" 
        lcFileName  =  GETFILE( "VCX,SCX" ) 
    ELSE
        lcAlias  =  ALIAS() 
        lcFileName  =  DBF() 
    ENDIF
    IF EMPTY( lcFileName ) 
       RETURN .F. 
    ENDIF
    lcAlias = JUSTSTEM( lcFileName )  
    IF USED( lcAlias ) 
       SELECT (lcAlias) 
    ENDIF 
    lcFileName = UPPER( FULLPATH( lcFileName  ) )
    
    IF FILE( lcFileName )  AND EMPTY( ALIAS() ) 
       *TryStart() 
       USE (lcFileName) ALIAS (lcAlias)  AGAIN 
    ENDIF 
    IF EMPTY( ALIAS() )  OR TYPE( ALIAS() +".ObjName" ) # "M" ;
                         OR TYPE( ALIAS() +".Parent" ) # "M" 
       RETURN .F. 
    ENDIF 
    This.cAlias = ALIAS() 
    ASSERT ! FTEST2 
    This.nClassCount = 0 
    DIMENSION This.aClassList[ 1, 8 ]
    
    *#DEFINE MAXPATH  250  
    *#DEFINE MAXVARLEN  50  
    
    lcFileName = UPPER( FULLPATH( lcFileName )   ) 
    ASSERT FILE( lcFileName ) 
    
    SELECT LEFT( IIF( ObjName==UPPER(ObjName), LOWER( ObjName ), ObjName );
                      , MAXVARLEN ) AS ObjName ;
           , RECNO() AS Rec ;
           , LEFT( BaseClass, MAXVARLEN ) AS BaseClass ;
           , LEFT( ClassLoc, MAXPATH )  AS ParClassLoc ;
           , LEFT( IIF( Parent==UPPER(Parent), LOWER( Parent ), Parent ) ;
                        , MAXVARLEN )  AS Parent ;
           , PADR( lcFileName, MAXPATH ) AS ClassLoc ;
       FROM (This.cAlias) ;
       WHERE EMPTY( Parent ) AND ! EMPTY( BaseClass ) ; 
       ORDER BY 5, 1,  2 ; 
       INTO ARRAY  This.aClassList  
    
    #DEFINE GOTARRAY_CLASSLIST  
    IF FTESTCLS
       CREATE CURSOR cClsList ( ObjName C( MAXVARLEN ) ;
                   , Rec I, BaseClass C( MAXVARLEN ) ;
                   , ParClassLoc C( MAXPATH ), Parent C( MAXVARLEN ) ;
                   , ClassLoc C( MAXPATH ) ;
                 ) 
       APPEND FROM ARRAY This.aClassList                    
    ENDIF 

    SELECT (This.cAlias) 
    This.cFileName   = LOWER( lcFileName )  
    This.lSCXMode    = ATC( ".SCX", lcFileName ) # 0  
    This.nClassCount = _TALLY            
    RETURN .T.  
  
  FUNCTION IndentText( lcTxt, tnSize ) 
    
    IF EMPTY( tnSize ) 
       * tnSize = 2  
       ASSERT .F. 
       RETURN lcTxt   
    ENDIF  
    LOCAL ARRAY laLines[ 1 ]
    LOCAL lnI, lnCnt, lcOut  
    
    lnCnt = ALINES( laLines, lcTxt )
    lcOut = ""  
    FOR lnI = 1 TO lnCnt  
        lcOut = lcOut + IIF( lnI > 1, CR_LF, "" )  ;
              + SPACE( tnSize ) + laLines[ lnI ] 
    ENDFOR 
    RETURN lcOut
    
  FUNCTION IndentNSort( lcTxt, tnSize ) 
    
    ASSERT ! EMPTY( tnSize ) 

    LOCAL laLines[ 1 ], lnI, lnCnt, lcOut  
    lnCnt = ALINES( laLines, lcTxt )
    IF lnCnt = 0
       RETURN lcTxt 
    ENDIF
    =ASORT( laLines )  
    lcOut = ""  
    FOR lnI = 1 TO lnCnt 
        lcOut = lcOut + IIF( lnI > 1, CR_LF, "" )  ;
              + SPACE( tnSize ) + laLines[ lnI ] 
    ENDFOR 
    RETURN lcOut


  FUNCTION GetTimeStamp( tnVal ) 
    RETURN TRANSFORM( DATETIME()  ) 

  FUNCTION FormatProperties( lcProp, tAddObj, tnMode )
    * Picture = ..  

    LOCAL tnSize 
    tnSize = 2 
    LOCAL ARRAY laLines[ 1 ]
    LOCAL lnI, lnCnt, lcOut, lnBeg , lcRow, lcVal
    LOCAL lcTxt 
    lcTxt = lcProp 
     
    lnCnt = ALINES( laLines, lcTxt )
    IF lnCnt = 0
       RETURN lcTxt 
    ENDIF
    =ASORT( laLines )  

    lcOut = ""  
    FOR lnI = 1 TO lnCnt 
    
        lcRow = laLines[ lnI ] 
        IF ATC( "=", lcRow ) # 0  
            
            lcRow = ALLTRIM( lcRow )         
            lnBeg = ATC( " = ", lcRow )
            IF lnBeg = 0 
               lnBeg = ATC( "=", lcRow ) 
            ELSE 
               lnBeg = lnBeg + 2   
            ENDIF
            lcVal = SUBSTR( lcRow, lnBeg + 1 )

            #DEFINE PARSE_OBJECT_VAL 
            DO CASE
              CASE EMPTY( lcVal ) 
               lcVal = "[]"                  && empty value 
       
              CASE ATC( ",", lcVal, 2 ) # 0 AND ATC( "COL", lcRow ) # 0 ;
               AND ( VAL( STRTRAN( lcVal, ",", "" )) > 0 ;
                     OR lcVal = "0,0,0" ) 
                     
                   lcVal = "RGB("+lcVal+")"  && RGB(..
       
              CASE ! INLIST( LEFT( lcVal, 1 ), ["], "[", "(" )  ;
               AND ! INLIST( lcVal , ".NULL.", ".F.", ".T.", "{}", "{..}" ) ;
               AND ; 
               (    ! CHRTRAN( lcVal, "[]:\/?!@#$#$%^&*()(ABCDF~;,<>=", "" ) == lcVal  ;  
                 OR ! INLIST( TYPE( lcVal ), 'N', 'L' ) ;
                 OR ATC( "..", lcVal ) # 0 ;
                )                            && if character data 
                                             && {} - for data, E- scientic, +, -  signs 
               IF ATC( ["], lcVal ) # 0 
                 lcVal = "[" + lcVal + "]" 
               ELSE                         
                 lcVal = ["] + lcVal + ["] 
               ENDIF 
                 
            ENDCASE 
            
            lcRow = LEFT( lcRow, lnBeg ) + lcVal
            IF tAddObj    
                lcRow = IIF( lnI # 1, ", ", "  " ) ;
                      + lcRow + IIF( lnI # lnCnt, " ;", "" )  
            ENDIF                       
        ENDIF  
                
        lcOut = lcOut + IIF( lnI > 1, CR_LF, "" )  ;
              + SPACE( tnSize ) + lcRow 
    ENDFOR 
    RETURN lcOut
 
  FUNCTION FormatMethods(lcMethods, tnMode )
    
    LOCAL lcDelimBeg, lcDelimEnd, lcText, lcProc, lnCnt
    LOCAL laNames[ 1 ], laCodes[ 1, 3 ] 

    lcText = lcMethods 
    lcDelimBeg = "PROCEDURE " 
    lcDelimEnd = "ENDPROC" 
    lnCnt = 0 
    
    LOCAL lcName, lnJ, lnI
    
    DO WHILE ATC("PROC", lcText) # 0  
    
       lcProc = STREXTRACT( lcText, lcDelimBeg, lcDelimEnd ) 
       IF EMPTY( lcProc )   
          EXIT 
       ENDIF
       
       *-------- Extract code ----------------------
       lcText = STRTRAN( lcText, lcDelimBeg + lcProc + lcDelimEnd, ""  ) 
       lnCnt = lnCnt + 1 
       DIMENSION laNames[ lnCnt ]
       DIMENSION laCodes[ lnCnt, 3 ]
       lcName = LEFT( lcProc, 80 )  
       lcName = ALLTRIM( STREXTRACT( lcName, "", CR_LF ) ) 
       ASSERT ! EMPTY( lcName )  
       
       IF AT( " ", lcName ) > 0  
          lcName = LEFT( lcName, AT( " ", lcName ) ) 
       ENDIF 
       lcName = UPPER( lcName ) 
       
       *-------------------------------------------------
       lcProc = lcDelimBeg + lcProc 
       lcProc = This.IndentText( lcProc, 2 )  

       lcProc = CR_LF + SUBSTR( lcProc, 3 ) ; 
              + CR_LF + lcDelimEnd + CR_LF 
       
       laNames[ lnCnt ] = lcName 
       laCodes[ lnCnt,  1 ] = lcName 
       laCodes[ lnCnt,  2 ] = lcProc 
       
    ENDDO     
    
    IF lnCnt > 0 
        ASORT( laNames )  
        lcMethods = "" 
        
        FOR lnJ = 1 TO lnCnt 
           lcName = laNames[ lnJ ]
           FOR lnI = 1 TO lnCnt 
            IF lcName == laCodes[ lnI, 1 ]  
                lcMethods    = lcMethods ; 
                             + laCodes[ lnI, 2 ]
                EXIT              
            ENDIF                 
           ENDFOR               
        ENDFOR  
    ENDIF 
    lcMethods = This.IndentText( lcMethods, 2 ) 
    RETURN  lcMethods 
    
  FUNCTION ShellExecute(lcExportToFile) 
  
  FUNCTION MsgBox( eMsg,nDlg,cTitle ) 
    eMsg    =  IIF( EMPTY( eMsg ), "!", eMsg ) 
    nDlg    =  IIF( EMPTY( nDlg ), 0, nDlg ) 
    cTitle  =  IIF( EMPTY( cTitle ), "ViewVcx", cTitle )     
    RETURN MESSAGEBOX(eMsg,nDlg,cTitle) && , nTimeout) 
    
  FUNCTION ExportClass() 
     DO brwExportClass  WITH This, .T., "ViewVcx" 

  FUNCTION SetBusyState(lState) 
     RETURN .T. 

  FUNCTION MsgInit()
     IF FTESTCURS 
        CREATE CURSOR cDebug( Key C(40), Text M, Text2 M, Loc C(50)  ) 
     ENDIF  
     RETURN .T. 

  FUNCTION MsgNow( tcKey , tcText ) 
     IF FTESTCURS 
        REPLACE IN cDebug  Text WITH TRANSFORM( tcText ) 
     ENDIF 
     
  FUNCTION Msg( tcKey , tcText, tcText2 ) 
     IF FTESTCURS 
       INSERT INTO cDebug( Key, Text, Text2, Loc ) ;
           VALUES( TRANSFORM( tcKey ) ;
                 , TRANSFORM( tcText ) ;
                 , TRANSFORM( tcText2 ) ;
                 , PROGRAM( PROGRAM(-1)-1 ) )     
     ENDIF 
     RETURN .T. 
       
ENDDEFINE 

DEFINE CLASS VcxParser AS Custom 
  oBrowser = .NULL. 
  cCode = "" 
  
  cDefineClass = ""
  cInsertDefineCode = ""
  cAppendDefineCode = ""
  
  cInsertCode = ""
  cAppendCode = "" 
  
  DIMENSION aClassLib[ 1 ] 

  FUNCTION Parse 
    RETURN .F. 
  

ENDDEFINE  

FUNCTION brwExportClass( toBrowser, tlShow, tcExportToFile )  

    LOCAL lcExportToFile,lcCode,lcInsertCode,lcAppendCode,lcDefineClass,llHTML
    LOCAL lcClass,lcParentClass,lcBaseClass,lcObjectClass,lcObjectBaseClass,lcParent
    LOCAL lcClassLoc,lcProperties,lcAddObject 
    LOCAL lcInsertDefineCode,lcAppendDefineCode,llSCXMode
    LOCAL lcFileName,lcFileName2, lcFileName3 
    LOCAL lnClassCount,lnListIndex,lcFilter,lcViewCodeFileName
    LOCAL llFileMode,lnClassLibCount,laClassLib,lnRecNo,lcCRLF3,lcCRLF4,lcMemberType
    LOCAL lcMember,lcMember2,lcMemberDesc,lnMemberCount,laMembers,laMemberDesc,lcTimeStamp
    LOCAL lnProtectedCount,laProtected,lnAtPos,lnElement,lcComment,lnLastSelect
    LOCAL lcVarName,lcArrayInfo,lcBorder,lnCount,llHidden,lcMethods,lcMethods2,lcSearchStr
    LOCAL lRetVal

    IF VARTYPE( toBrowser ) # "O"
       RETURN .F. 
    ENDIF    
    lRetVal  =  "" 

    llHTML = .F.
    DO CASE
        CASE TYPE("tcExportToFile")#"C"
            lcExportToFile = ""
        CASE UPPER(ALLTRIM(tcExportToFile)) == "HTML"
            lcExportToFile = ""
            llHTML = .T.
        CASE NOT EMPTY(tcExportToFile)
            lcExportToFile = ALLTRIM(tcExportToFile)
        OTHERWISE
            lcExportToFile = LOWER(PUTFILE(M_SAVE_LOC,"","prg|txt|htm|html"))
            IF EMPTY(lcExportToFile)
                RETVAL = ""
                RETURN RETVAL
            ENDIF
    ENDCASE
    IF NOT EMPTY(lcExportToFile)
        IF NOT ":"$lcExportToFile AND NOT "\\"$lcExportToFile
            lcExportToFile = toBrowser.FULLPATH( lcExportToFile, .T. )
        ENDIF
        IF FILE(lcExportToFile)
            IF tlShow AND toBrowser.MsgBox( lcExportToFile+M_ALREADY_EXISTS_OVER_LOC,35 ) # 6
                RETVAL = ""
                RETURN RETVAL
            ENDIF
        ENDIF
        llHTML = INLIST(LOWER(JUSTEXT(lcExportToFile)),"htm","html")
    ENDIF

    SET MESSAGE TO M_GEN_CLASS_DEF_LOC+[ ...]
  
    lcCRLF3 = REPLICATE(CR_LF,3)
    lcCRLF4 = REPLICATE(CR_LF,4)
    lnLastSelect = SELECT()

    toBrowser.SetBusyState(.T.)

    #IF .F.
        PUBLIC toBrowser AS GenericBrowser OF D:\Vfplib\sys\ViewVcx.prg  
        PUBLIC goParser  AS VcxParser OF D:\Vfplib\sys\ViewVcx.prg   
    #ENDIF     

    goParser.oBrowser = toBrowser 
  
    lcBorder = REPLICATE("*",50)
    lcComment = "*-- "
    lcCode = ""
    lcInsertCode = ""
    lcAppendCode = ""
    lcInsertDefineCode = ""
    lcAppendDefineCode = ""
    lcDefineClass = ""
    lnClassLibCount = 0
    
    DIMENSION laClassLib[1]
    llFileMode = toBrowser.lFileMode
    llSCXMode  = toBrowser.lSCXMode

    lnClassCount = 0 
    IF ! toBrowser.ParseClassLib() 
       RETVAL = ""
       RETURN RETVAL 
    ENDIF 
    LOCAL lcAlias 
    lcAlias    = ALIAS() 
    toBrowser.MsgInit()

    SELECT (lcAlias) 
    
    lcFileName = toBrowser.cFileName
    lcFileName3 = toBrowser.FullPath( lcFileName, .T. )  
    IF EMPTY( lcExportToFile )
       lcExportToFile = LOWER( lcFileName + ".prg"  ) 
    ENDIF 
    LOCATE
    
    #DEFINE DOWHILE 
    
    DO WHILE .T.
        IF toBrowser.lRelease
            SELECT (lnLastSelect)
            RETVAL = ""
            RETURN RETVAL
        ENDIF
        IF lnClassCount>0
            IF EOF()
                EXIT
            ENDIF
            SKIP
        ENDIF
        
        lcParent = LOWER(ALLTRIM(Parent))
        IF lnClassCount <= 0 OR EMPTY(lcParent)
        
            lnClassCount = lnClassCount+1
            IF lnClassCount> toBrowser.nClassCount OR ;
                    (NOT llFileMode AND lnClassCount >= 2)
                EXIT
            ENDIF
            IF llFileMode
                lnListIndex =  lnClassCount
            ELSE
                lnListIndex =  toBrowser.nClassListIndex + 1
            ENDIF
            #DEFINE ERR_CASE 
            
            lcClass = ALLTRIM( toBrowser.aClassList[lnListIndex,1] ) 
            IF lcClass == UPPER( lcClass )
               lcClass = LOWER( lcClass )  
            ENDIF 
            lcFileName2 = ALLTRIM( toBrowser.aClassList[lnListIndex,6] )
            lcFileName2 = PROPER( lcFileName2 )  
    
            IF "."$lcClass OR NOT UPPER( lcFileName ) == UPPER( lcFileName2 ) 
                LOCATE
                LOOP
            ENDIF
            
            GO toBrowser.aClassList[lnListIndex,2]
            lcParent = LOWER(ALLTRIM(Parent))
            lcParentClass = LOWER(ALLTRIM(Class))
            SET MESSAGE TO M_GEN_CLASS_DEF_LOC+[ (]+lcClass+[) ...]
        ELSE
            lcClass = LOWER(ALLTRIM(ObjName))
            lcParentClass = LOWER(ALLTRIM(Class))
            SET MESSAGE TO M_GEN_CLASS_DEF_LOC+[ (]+lcDefineClass+[.]+lcClass+[) ...]
        ENDIF
        
        lcBaseClass = LOWER(ALLTRIM(BaseClass))
        lcClassLoc = IIF(EMPTY(ClassLoc),"" ;
                            , toBrowser.FULLPATH( ALLTRIM(ClassLoc), .T. )  ;
                        )
                        && ,lcFileName ) ) 
        IF llHTML
            lcProperties = brwValidHTMLText(ALLTRIM(Properties))
            lcMethods    = brwValidHTMLText(ALLTRIM(Methods))
        ELSE
            lcProperties = ALLTRIM( Properties )
            lcMethods    = ALLTRIM( Methods )
        ENDIF
        lnMemberCount = 0
        DIMENSION laMembers[1]
        DIMENSION laMemberDesc[1]
        
        _MLINE = 0
        #DEFINE PARSE_MEMBERS 

        toBrowser.Msg( "Obj: "+ ObjName + "/"+ Parent ;
                , "Obj: " + ObjName + " of "+ Parent, " Class "+ Class  )         
        toBrowser.Msg( "Pars_Prop", lcProperties )
        toBrowser.Msg( "Pars_Meth", lcMethods )
        toBrowser.Msg( "Comment", Reserved3 )
        toBrowser.Msg( "Protected", Protected )
        
        LOCAL ARRAY laComment[1000,1] 
        =ALINES( laComment, Reserved3 )
        FOR lnCount = 1 TO ALEN( laComment )        && Comments 
        
            * lcMember = ALLTRIM( MLINE( Reserved3, lnCount, _mline ))
            lcMember = ALLTRIM( laComment[ lnCount ] ) 
                                && MLINE( Reserved3, lnCount ))

            lcArrayInfo = ""
            IF EMPTY( lcMember) ;
               OR LEFT( lcMember,1)  == "^" ;
               OR LEFT( lcMember,1) == "*"
                  LOOP
            ENDIF 

*!*                IF LEFT(lcMember,1) == "*"
*!*                
*!*                    lcMember = ALLTRIM(SUBSTR(lcMember,2))
*!*                    lnAtPos = AT(" ",lcMember)
*!*                    IF lnAtPos = 0
*!*                        lcMemberDesc = ""
*!*                        lcMember = LOWER(lcMember)
*!*                    ELSE
*!*                        lcMemberDesc = ALLTRIM(SUBSTR(lcMember,lnAtPos+1))
*!*                        lcMember = LOWER(ALLTRIM(LEFT(lcMember,lnAtPos-1)))
*!*                    ENDIF
*!*                    lnAtPos = ATC( CR_LF+"PROCEDURE "+ lcMember+CR_LF ;
*!*                                 , CR_LF+lcMethods+CR_LF )
*!*                                 
*!*                    IF NOT EMPTY(lcMethods)
*!*                        lcMethods = lcMethods+CR_LF
*!*                    ENDIF
*!*                    IF lnAtPos>0
*!*                        IF EMPTY(lcMemberDesc)
*!*                            lcMemberDesc = CR_LF
*!*                        ELSE
*!*                            lcMemberDesc = ; 
*!*                                 toBrowser.IndentText( lcComment+lcMemberDesc, 2 )
*!*                        ENDIF
*!*                        lcMethods = LEFT(lcMethods,lnAtPos-1)+ CR_LF ;
*!*                              + MARKER+IIF(llHTML,[<font color = "green">],[]) ;
*!*                              + lcMemberDesc+IIF(llHTML,[</font><font color = "black">],[]) ;
*!*                              +CR_LF  + SUBSTR(lcMethods,lnAtPos)
*!*                        LOOP
*!*                    ENDIF
*!*                    IF NOT EMPTY(lcMethods)
*!*                        lcMethods = lcMethods + CR_LF
*!*                    ENDIF
*!*                    IF NOT EMPTY(lcMemberDesc)
*!*                        lcMethods = lcMethods + MARKER ;
*!*                                  + lcComment + lcMemberDesc 
*!*                                  *WAS: + toBrowser.IndentText(lcComment+lcMemberDesc, 2 )
*!*                    ENDIF
*!*                    IF NOT EMPTY(lcMethods)
*!*                        lcMethods = lcMethods+CR_LF
*!*                    ENDIF
*!*                    lcMethods = lcMethods+"PROCEDURE "+lcMember ;
*!*                                   +CR_LF+"ENDPROC"+ CR_LF
*!*                    LOOP
*!*                    
*!*                ENDIF
*!*                
*!*                IF LEFT(lcMember,1) == "^"
*!*                    lcMember = STRTRAN(STRTRAN(STRTRAN(ALLTRIM(SUBSTR(lcMember,2)) ;
*!*                                      , "(","["),")","]"),",0]","]" )
*!*                    lnAtPos = AT("[",lcMember )
*!*                    IF lnAtPos>0
*!*                        lcArrayInfo = ALLTRIM(SUBSTR(lcMember,lnAtPos))
*!*                        lcMember = ALLTRIM(LEFT( lcMember,lnAtPos-1 ))
*!*                    ENDIF
*!*                    IF EMPTY(lcMember)
*!*                        LOOP
*!*                    ENDIF
*!*                    lnMemberCount = lnMemberCount+1
*!*                    DIMENSION laMembers[lnMemberCount]
*!*                    DIMENSION laMemberDesc[lnMemberCount]
*!*                    laMembers[lnMemberCount] = LOWER(lcMember)+" "
*!*                    lnAtPos = AT(" ",lcArrayInfo)
*!*                    IF lnAtPos = 0
*!*                        laMemberDesc[lnMemberCount] = MARKER+lcArrayInfo
*!*                    ELSE
*!*                        laMemberDesc[lnMemberCount] = ALLTRIM(SUBSTR(lcArrayInfo,lnAtPos+1)) ;
*!*                              + MARKER+ALLTRIM(LEFT(lcArrayInfo,lnAtPos-1))
*!*                    ENDIF
*!*                    LOOP
*!*                    
*!*                ENDIF
            
            lnMemberCount = lnMemberCount+1
            DIMENSION laMembers[lnMemberCount]
            DIMENSION laMemberDesc[lnMemberCount]
            lnAtPos = AT(" ",lcMember)
            IF lnAtPos = 0
                laMembers[lnMemberCount] = LOWER(lcMember)+" "
                laMemberDesc[lnMemberCount] = ""
            ELSE
                laMembers[lnMemberCount]    = LOWER( ALLTRIM(LEFT(lcMember,lnAtPos-1)) )+" "
                laMemberDesc[lnMemberCount] = ALLTRIM( SUBSTR(lcMember,lnAtPos+1) )
            ENDIF
            
        ENDFOR

      *------------------------------------------------------------------ 
        
        LOCAL lnI, lcStr
        lcStr = "" 
        IF TYPE( "laMembers[ 1 ]" ) = 'C' 
            FOR lnI = 1 TO ALEN( laMembers )
               lcStr = lcStr + CR_LF + laMembers[ lnI ] 
            ENDFOR 
        ENDIF     
        toBrowser.Msg( "laMembers", lcStr, Reserved3  )        

      *------------------------------------------------------------------ 
            
        lnProtectedCount = 0
        DIMENSION laProtected[1]
        _MLINE = 0

        #DEFINE PARSE_PROTECT  
        
        FOR lnCount = 1 TO MEMLINE(Protected)
        
            lcMember = LOWER(ALLTRIM( MLINE( Protected,1,_MLINE )))
            IF EMPTY(lcMember)
                LOOP
            ENDIF
            llHidden = ("^"$lcMember)
            lcMember2 = ALLTRIM(STRTRAN(lcMember,"^",""))
            lcMemberType = IIF(PEMSTATUS(lcBaseClass,lcMember2,5) ;
                              , LOWER(PEMSTATUS(lcBaseClass,lcMember2,3)),"")
            IF ASCAN(laMembers,lcMember2+" ") = 0 AND NOT lcMemberType == "property"
                lcMethods2 = CR_LF+lcMethods
                lcSearchStr = CR_LF+"PROCEDURE "+lcMember2+CR_LF
                lnAtPos = ATC(lcSearchStr,lcMethods2)
                IF lnAtPos>0
                    lcMethods = SUBSTR(LEFT(lcMethods2,lnAtPos),3) + TAB2 ;
                          + IIF(llHidden,"HIDDEN ","PROTECTED ") ;
                          + SUBSTR(lcMethods2,lnAtPos+2)
                    lcMethods2 = ""
                    LOOP
                ENDIF
                lcMethods2 = ""
            ENDIF
            lnProtectedCount = lnProtectedCount+1
            DIMENSION laProtected[lnProtectedCount]
            laProtected[lnProtectedCount] = lcMember+" "
        ENDFOR

        IF llFileMode AND llSCXMode AND NOT EMPTY(lcClassLoc) ;
            AND  ASCAN( laClassLib,lcClassLoc ) = 0
            
            lnClassLibCount = lnClassLibCount+1
            DIMENSION laClassLib[lnClassLibCount]
            laClassLib[lnClassLibCount] = lcClassLoc
        ENDIF
        ASSERT !FTEST2
        
        #DEFINE PARSE_PARENT 
        
        DO CASE
            CASE EMPTY(lcParent)
                IF NOT EMPTY(lcDefineClass)
                    IF NOT EMPTY(lcInsertDefineCode)
                        lcInsertDefineCode = lcInsertDefineCode + CR_LF
                    ENDIF
                    lcCode = lcCode + lcInsertDefineCode + lcAppendDefineCode

                    lcCode = lcCode+lcCRLF3 ;
                          + IIF(llHTML,[<font color = "navy">]+CR_LF,[])+"ENDDEFINE"+CR_LF ;
                          + IIF(llHTML,CR_LF+[</font><font color = "green">]+CR_LF,[])+"*"+CR_LF ;
                          + lcComment+ "EndDefine: " +lcDefineClass+CR_LF+lcBorder ;
                          + IIF(llHTML,CR_LF+[</font><font color = "black">]+CR_LF,[]) ;
                                  + CR_LF 
                ENDIF
                lcInsertDefineCode = ""
                lcAppendDefineCode = ""
                IF NOT EMPTY(lcDefineClass)
                    lcCode = lcCode+CR_LF+IIF(llHTML,[<hr>], CR_LF ) + CR_LF 
                ENDIF
                lcDefineClass = lcClass
                IF llHTML
                    lcCode = lcCode+IIF(llHTML,CR_LF+[<font color = "green">]+CR_LF,[])
                ENDIF
                IF llFileMode AND NOT llSCXMode AND EMPTY(lcCode)
                    lnRecNo = RECNO()
                    LOCATE
                    lcCode = lcCode+lcBorder+CR_LF ;
                          + lcComment+ "Class Library:  "+lcFileName3 + CR_LF
                    IF NOT EMPTY(Reserved7)
                        lcCode = lcCode ;
                               + toBrowser.IndentText( lcComment + ALLTRIM(Reserved7) ;
                                                     , 2 ) + CR_LF
                    ENDIF
                    lcCode = lcCode+lcBorder+lcCRLF3
                    GO lnRecNo
                ENDIF
                
                lcCode = lcCode+lcBorder+CR_LF + lcComment ;
                            + PADR( IIF( llSCXMode ;
                                  , PROPER( lcBaseClass)+":", "Class:" ),14) ;
                          + IIF(llHTML,[<font color = "blue">],[]) + lcClass ;
                          + IIF(llHTML,[</font><font color = "green">],[]) ;
                               + " ("+ lcFileName3 + ")"+CR_LF ;
                          + lcComment + "ParentClass:  "
                DO CASE
                    CASE NOT llHTML
                        lcCode = lcCode+lcParentClass
                    CASE lcParentClass == lcBaseClass OR NOT toBrowser.lFileMode ;
                         OR EMPTY(lcClassLoc) ;
                         OR NOT  UPPER( toBrowser.cFileName ) == UPPER( lcClassLoc ) 
                         
                      lcCode = lcCode+IIF(llHTML,[</font><font color = "blue">],[]) ;
                               + lcParentClass
                    OTHERWISE
                        lcCode = lcCode+IIF(llHTML,[<a href = "#]+lcParentClass+[">],[]) ;
                               + lcParentClass + IIF(llHTML,[</a>],[])
                ENDCASE
                lcCode = lcCode+IIF(llHTML,[</font><font color = "green">],[])+IIF(EMPTY(lcClassLoc),""," ("+lcClassLoc+")")+CR_LF ;
                          + lcComment+"BaseClass:    "+IIF(llHTML,[</font><font color = "blue">],[]) ;
                          + lcBaseClass+IIF(llHTML,[</font><font color = "green">    ],[])+CR_LF

                lcTimeStamp = toBrowser.GetTimeStamp(TIMESTAMP)

                *IF NOT EMPTY(lcTimeStamp)
                *    lcCode = lcCode+lcComment+M_TIMESTAMP_LOC+" "+lcTimeStamp+CR_LF
                *ENDIF
                IF NOT EMPTY(OLE2)
                    lcCode = lcCode+lcComment+MLINE(OLE2,1)+CR_LF
                ENDIF
                IF NOT EMPTY(Reserved7)
                    lcCode = lcCode+lcComment+Reserved7+CR_LF
                ENDIF 

                * lcCode = toBrowser.IndentText( lcCode )
                IF llSCXMode
                    lnRecNo = RECNO()
                    LOCATE
                ENDIF
                IF NOT EMPTY( Reserved8 )
                    lcCode = lcCode+ "*"+CR_LF ;
                          + IIF( ATC( [#INCLUDE ], lcCode ) # 0, "*", "" ) ; 
                          + [#INCLUDE ]+CHR(34) ;
                          + toBrowser.FULLPATH( ALLTRIM( MLINE(Reserved8,1)) , .T. ) ; && ,lcFileName )) 
                          + CHR(34)+CR_LF
    
                    toBrowser.Msg( "Prop [after include]", lcCode )
                ENDIF
                IF llSCXMode 
                    GO lnRecNo 
                ENDIF
                lcCode = lcCode+"*"+CR_LF+IIF(llHTML,[<font color = "navy">]+CR_LF ;
                          + [<a name = "]+lcClass+[">]+CR_LF,[]) ;
                          + "DEFINE CLASS "+IIF(llHTML,[</a></font><font color = "blue">],[])+lcClass ;
                          + IIF(llHTML,[</font><font color = "navy">],[])+" AS "
                DO CASE
                    CASE NOT llHTML
                        lcCode = lcCode+lcParentClass
                    CASE lcParentClass == lcBaseClass OR NOT toBrowser.lFileMode ;
                         OR EMPTY(lcClassLoc) ; 
                         OR NOT  UPPER( toBrowser.cFileName ) == UPPER( lcClassLoc ) 
                         
                        lcCode = lcCode+IIF(llHTML,[</font><font color = "blue">],[])+lcParentClass
                    OTHERWISE
                        lcCode = lcCode+IIF(llHTML,[<a href = "#]+lcParentClass+[">],[])+lcParentClass ;
                          + IIF(llHTML,[</a>],[])
                ENDCASE
                IF NOT llSCXMode
                    lnRecNo = RECNO()
                    LOCATE FOR UPPER(ALLTRIM(Platform)) == "COMMENT" ;
                           AND LOWER(ALLTRIM(ObjName)) == LOWER(lcClass)
                    IF NOT EOF() AND UPPER(ALLTRIM(MLINE(Reserved2,1))) == "OLEPUBLIC"
                        lcCode = lcCode+IIF(llHTML,[<font color = "navy">],[])+" OLEPUBLIC"
                    ENDIF
                    GO lnRecNo
                ENDIF
                lcCode = lcCode+CR_LF+IIF(llHTML,[</font><font color = "black">]+CR_LF,[])+CR_LF

                toBrowser.Msg( "Prop [after format ]", lcProperties )

              #DEFINE GOT_PROPERTIES  
              
                IF NOT EMPTY(lcProperties)
                    lcInsertDefineCode = ;
                        IIF( ! EMPTY( lcInsertDefineCode) , lcInsertDefineCode  + CR_LF, "" ) ;
                        + lcProperties 
                ENDIF       

                FOR lnCount = 1 TO lnMemberCount

                    lcMember  = ALLTRIM( laMembers[ lnCount] )
                    llHidden  = ( "^" $ lcMember )
                    lcMember2 = ALLTRIM( STRTRAN( lcMember,"^", "" ))
                    
                    lcMemberDesc = laMemberDesc[ lnCount ]
                    lcMemberDesc = "" 
                    lnAtPos = AT( MARKER, lcMemberDesc )

                    IF lnAtPos = 0
                        lcArrayInfo = ""
                    ELSE
                        lcArrayInfo  = SUBSTR(lcMemberDesc,lnAtPos+1)
                        lcMemberDesc = LEFT(lcMemberDesc,lnAtPos-1)
                    ENDIF

*!*                        IF NOT EMPTY(lcMemberDesc)
*!*                            lnAtPos = ATC( TAB+lcMember2+" = ",lcInsertDefineCode )
*!*                            IF lnAtPos = 0
*!*                                lcInsertDefineCode = lcInsertDefineCode+CR_LF ;
*!*                                  + IIF(llHTML,[<font color = "green">],[]) ;
*!*                                  + toBrowser.IndentText( ; 
*!*                                        toBrowser.IndentText( lcComment + lcMemberDesc, 1 ), 1 ) ;
*!*                                     + IIF(llHTML,[</font><font color = "black">],[] ) + CR_LF
*!*                            ELSE
*!*                                lcInsertDefineCode = LEFT(lcInsertDefineCode,lnAtPos-1) ;
*!*                                  + IIF(llHTML,[<font color = "green">],[]) ;
*!*                                  + toBrowser.IndentText( ;
*!*                                       toBrowser.IndentText( lcComment  + lcMemberDesc, 1  ), 1 ) ;
*!*                                  +IIF(llHTML,[</font><font color = "black">],[])+CR_LF ;
*!*                                  + SUBSTR(lcInsertDefineCode,lnAtPos)
*!*                            ENDIF
*!*                        ENDIF
                    
                    lnElement = ASCAN(laProtected,lcMember+" ")
                    IF lnElement = 0
                        lnElement = ASCAN(laProtected,lcMember+"^ ")
                        IF lnElement>0
                            llHidden = .T.
                        ENDIF
                    ENDIF
                    IF lnElement>0
                        laProtected[lnElement] = ""
                    ENDIF
                    
                    IF ATC( lcMember2 , lcInsertDefineCode ) # 0 
                       LOOP 
                    ENDIF                     
                    
                    IF EMPTY(lcArrayInfo)
                        lnAtPos = ATC( lcMember2+" ",lcInsertDefineCode)
                        
                        IF lnElement>0
                            IF lnAtPos = 0
                                lcInsertDefineCode = lcInsertDefineCode + TAB2 ;
                                  + IIF(llHidden, "HIDDEN ","PROTECTED ") ;
                                  + lcMember2+CR_LF
                                LOOP
                                
                            ELSE
                                * + TAB2 + 
                                * lcInsertDefineCode = LEFT(lcInsertDefineCode,lnAtPos-1) 
                                
                                lcInsertDefineCode = LEFT(lcInsertDefineCode, lnAtPos-1) ;
                                  + TAB2 ; 
                                  + IIF(llHidden, "HIDDEN ","PROTECTED ") ;
                                  + lcMember2+CR_LF ;
                                  + SUBSTR( lcInsertDefineCode,lnAtPos )
                            ENDIF
                        ENDIF
                        IF lnAtPos>0
                            LOOP
                        ENDIF
                    ELSE
                        lcInsertDefineCode = lcInsertDefineCode + TAB2 ;
                                  + IIF(lnElement>0,IIF(llHidden,"HIDDEN ","PROTECTED ") ;
                                  , "DIMENSION ")+lcMember2+lcArrayInfo+CR_LF
                    ENDIF
                    IF EMPTY(lcArrayInfo)
                        lcInsertDefineCode = lcInsertDefineCode ;    && +TAB2 
                                    + lcMember2 + " = .F." + CR_LF
                    ENDIF
                ENDFOR

                IF NOT EMPTY( lcInsertDefineCode  )
                    lcInsertDefineCode = toBrowser.FormatProperties( lcInsertDefineCode, .F. ) ;
                                       + CR_LF 
                ENDIF
                toBrowser.MsgNow( "Prop [after format ]", lcInsertDefineCode  )

                FOR lnCount = 1 TO lnProtectedCount

                    lcMember = ALLTRIM(laProtected[lnCount])
                    IF EMPTY(lcMember)
                        LOOP
                    ENDIF
                    llHidden = ("^"$lcMember)
                    lcMember2 = ALLTRIM(STRTRAN(lcMember,"^",""))
                    lcInsertDefineCode = lcInsertDefineCode + TAB2 ;
                                  + IIF(llHidden,"HIDDEN ","PROTECTED ") ;
                                  + lcMember2+CR_LF
                    laProtected[lnCount] = ""
                ENDFOR 
            
            #DEFINE GOT_METHODS                 
            
                toBrowser.Msg( "Protec meth ", lcMethods)

                IF NOT EMPTY(lcMethods)
                    lcMethods = toBrowser.FormatMethods(lcMethods)
                    lcAppendDefineCode = lcAppendDefineCode ;
                                       + lcMethods
                ENDIF

                toBrowser.MsgNow("Protec meth ", lcAppendDefineCode)
                
            CASE NOT EMPTY(lcClass) AND NOT EMPTY(lcParent)

                lcObjectClass = IIF(LOWER(lcParent) == LOWER(lcDefineClass), "", lcParent + "." ) + lcClass
                IF ATC(lcDefineClass + '.', lcObjectClass) > 0 
                   lcObjectClass = SUBSTR(lcObjectClass, ATC(".", lcObjectClass) + 1)
                ENDIF 
                lcObjectBaseClass = LOWER(ALLTRIM(BaseClass))
                lcAddObject = IIF(llHTML,[<font color = "navy">]+CR_LF,[]) ;
                       + "ADD OBJECT "+IIF(llHTML,[</font><font color = "blue">],[]) ;
                       + lcObjectClass + IIF(llHTML,[</font><font color = "navy">],[]) ;
                       + " AS "
                       
                DO CASE
                    CASE NOT llHTML
                        lcAddObject = lcAddObject + lcParentClass
                    CASE lcParentClass == lcObjectBaseClass OR NOT toBrowser.lFileMode ;
                      OR EMPTY(lcClassLoc) ; 
                      OR NOT  UPPER(toBrowser.cFileName) == UPPER( lcClassLoc) 
                      
                        lcAddObject = lcAddObject+IIF(llHTML,[<font color = "blue">],[])+lcParentClass
                    OTHERWISE
                        lcAddObject = lcAddObject+IIF(llHTML,[<a href = "#]+lcParentClass+[">],[])+lcParentClass ;
                                  + IIF(llHTML,[</a>],[])
                ENDCASE
                
                lcAddObject = lcAddObject + IIF(llHTML,[</font><font color = "navy">],[])
                IF UPPER(ALLTRIM(Reserved8)) == "NOINIT"
                    lcAddObject = lcAddObject+" NOINIT"
                ENDIF
                
                IF EMPTY(lcProperties)
                    lcAddObject = toBrowser.IndentText( lcAddObject, 2 ) ;
                                  + IIF(llHTML,[<font color = "black">],[])
                ELSE
                    lcProperties = toBrowser.FormatProperties( lcProperties, .T. )
                    lcAddObject = lcAddObject + " WITH "+IIF(llHTML,[<font color = "black">],[])+";" 
                    IF ! EMPTY( ClassLoc ) 
                        lcAddObject = lcAddObject + " &"+"& " + ALLTRIM( ClassLoc ) + " " 
                    ENDIF 
                    lcAddObject = lcAddObject + CR_LF+ toBrowser.IndentText( lcProperties, 2 )
                ENDIF
                
                lcAddObject = toBrowser.IndentText(lcAddObject, 2)

                toBrowser.Msg("Parsed AddObj ", lcAddObject)
                toBrowser.Msg("Parsed  Meth", "", lcMethods)
                
                IF NOT EMPTY(lcMethods)
                    ASSERT !FTESTMETH MESSAGE [Method name] + lcClass 

                    lcMethods = toBrowser.FormatMethods(lcMethods)
                    lcMethods = STRTRAN(lcMethods, "PROCEDURE ","PROCEDURE " + lcObjectClass + ".")

                    IF ! EMPTY(lcAppendDefineCode)
                        * ASSERT ! FTEST  
                        
                        lcAppendDefineCode = lcAppendDefineCode + CR_LF
                    ENDIF
                    lcAppendDefineCode = lcAppendDefineCode + lcMethods
                ENDIF
                lcInsertDefineCode = lcInsertDefineCode + CR_LF + lcAddObject + CR_LF

                toBrowser.MsgNow( "Parsed  Meth", lcMethods )
                
        ENDCASE

         toBrowser.Msg( "Now InsertDef", lcInsertDefineCode )
         toBrowser.Msg( "Now AppendDef", lcAppendDefineCode )
        
         toBrowser.Msg( "Now Code", lcCode )

         toBrowser.Msg( "Now InsertCode", lcInsertCode )
         toBrowser.Msg( "Now AppendCode", lcAppendCode )
        
*!*            IF NOT EMPTY(lcMethods)
*!*                DO WHILE LEFT(lcAppendDefineCode,2) == CR_LF
*!*                    lcAppendDefineCode = SUBSTR(lcAppendDefineCode,3)
*!*                ENDDO
*!*                DO WHILE RIGHT(lcAppendDefineCode,2) == CR_LF
*!*                    lcAppendDefineCode = LEFT(lcAppendDefineCode ;
*!*                                             , LEN(lcAppendDefineCode)-2)
*!*                ENDDO
*!*                lcAppendDefineCode = lcAppendDefineCode+lcCRLF3
*!*            ENDIF
        
    ENDDO
    
    SET MESSAGE TO ""

    #DEFINE PARSE_DEFINECLASS 
     
    IF NOT EMPTY(lcDefineClass)
        IF NOT EMPTY(lcInsertDefineCode)
            lcInsertDefineCode = lcInsertDefineCode + CR_LF 
        ENDIF
        lcCode = lcCode + lcInsertDefineCode + lcAppendDefineCode

        lcCode = lcCode+lcCRLF3 ;
                  + IIF(llHTML,[<font color = "navy">]+CR_LF,[])+"ENDDEFINE"+CR_LF ;
                  + IIF(llHTML,CR_LF+[</font><font color = "green">]+CR_LF,[])+"*"+CR_LF ;
                  + lcComment+"EndDefine: "+lcDefineClass+CR_LF+lcBorder ;
                  + IIF(llHTML,CR_LF+[</font><font color = "black">]+CR_LF,[])+CR_LF
    ENDIF    
    IF llFileMode AND llSCXMode AND NOT EMPTY(lcCode)

        FOR lnCount = 1 TO lnClassLibCount
            lcInsertCode = lcInsertCode+"SET CLASSLIB TO "+laClassLib[lnCount] ;
                  + " ADDITIVE"+CR_LF
        ENDFOR
        IF NOT EMPTY(lcInsertCode)
            lcInsertCode = lcInsertCode+CR_LF
        ENDIF
        lcVarName = "o"+lcDefineClass
        lcInsertCode = [PUBLIC ]+lcVarName + CR_LF + lcInsertCode ;
                  + lcVarName+[ = NEWOBJECT("]+lcDefineClass+[")]+CR_LF ;
                  + lcVarName+[.Show]+CR_LF ;
                  + [RETURN]+lcCRLF3
    ENDIF
    
    IF NOT EMPTY(lcInsertCode)
        lcCode = lcInsertCode+lcCode
    ENDIF
    IF NOT EMPTY(lcAppendCode)
        lcCode = lcCode+lcAppendCode
    ENDIF
    lcCode = STRTRAN(lcCode,MARKER,"")
    
    lcCode = "* "+ lcFileName3 ;
             + CR_LF + lcCode 
             
    IF llHTML
        lcCode = [<html>]+CR_LF ;
                  + [<head>]+CR_LF ;
                  + [<title>]+IIF(toBrowser.lFileMode,M_CLASS_LIBRARY_LOC+" "+toBrowser.cClass ;
                                  , M_CLASS_LOC+" ("+toBrowser.cClass+")") ;
                  + [</title>]+CR_LF ;
                  + [</head>]+CR_LF ;
                  + [<body>]+CR_LF+CR_LF ;
                  + [<pre><b>]+CR_LF ;
                  + lcCode+CR_LF ;
                  + [</b></pre>]+CR_LF+CR_LF ;
                  + [</body>]+CR_LF ;
                  + [</html>]+CR_LF
    ENDIF
    
    * lcCode = STRTRAN(STRTRAN(STRTRAN(lcCode,LF+ TAB +CR,""),LF+LF,LF),CR+CR,CR)
*!*        DO WHILE lcCRLF4 $ lcCode
*!*            lcCode = STRTRAN(lcCode,lcCRLF4,lcCRLF3)
*!*        ENDDO
    
    IF NOT EMPTY(lcExportToFile)
        IF WEXIST(JUSTFNAME(lcExportToFile))
            RELEASE WINDOW (JUSTFNAME(lcExportToFile))
        ENDIF
        IF FILE( lcExportToFile )
           LOCAL lcOldCode
           lcOldCode = FILETOSTR( lcExportToFile )
           IF ! lcOldCode == lcCode
              STRTOFILE( lcCode,lcExportToFile )
           ENDIF 
        ELSE 
           STRTOFILE( lcCode,lcExportToFile )
        ENDIF 
    ENDIF

    #DEFINE SHOW_PRGFILE 
    IF tlShow
        IF NOT EMPTY(lcExportToFile)
            IF llHTML
                toBrowser.ShellExecute(lcExportToFile)
            ELSE
                IF LOWER(JUSTEXT(lcExportToFile)) == "prg"
                    MODIFY COMM (lcExportToFile) RANGE 1,1 IN SCREEN NOWAIT
                ELSE
                    MODIFY FILE (lcExportToFile) RANGE 1,1 IN SCREEN NOWAIT
                ENDIF
            ENDIF
        ELSE
            lcViewCodeFileName = LOWER(toBrowser.cViewCodeFileName)
            IF EMPTY(lcViewCodeFileName)
                lcViewCodeFileName = LOWER(toBrowser.cProgramPath+SYS(2015)+".prg")
            ENDIF
            IF WEXIST(JUSTFNAME(lcViewCodeFileName))
                RELEASE WINDOW (JUSTFNAME(lcViewCodeFileName))
            ENDIF
            STRTOFILE(lcCode,lcViewCodeFileName)
            IF LOWER(JUSTEXT(lcViewCodeFileName)) == "prg"
                MODIFY COMM (lcViewCodeFileName) RANGE 1,1 IN SCREEN NOWAIT
            ELSE
                MODIFY FILE (lcViewCodeFileName) RANGE 1,1 IN SCREEN NOWAIT
            ENDIF
        ENDIF
    ENDIF
    
    toBrowser.SetBusyState(.F.)
    SELECT (lnLastSelect)
    SET MESSAGE TO
    RETVAL = lcCode
    RETURN RETVAL

ENDFUNC


FUNCTION brwValidHTMLText( tcText )
RETURN tcText

FUNCTION GetPrg2Curs  

CREATE CURSOR cPrg ( STR C( 220 ) )
APPEND FROM (GETFILE( "Prg" )) DELIMITED WITH CHARACTER ` 


FUNCTION CreaVCX 

CREATE CURSOR VCX ( ; 
   PLATFORM C( 8 ),  UNIQUEID C( 10 ), TIMESTAMP N( 10 ), CLASS M( 4 ),  CLASSLOC M( 4 ) ;
 , BASECLASS M( 4 ), OBJNAME M( 4 ),   PARENT M( 4 ),    PROPERTIES M( 4 ), PROTECTED M( 4 ) ;
 , METHODS M( 4 ),   OBJCODE M( 4 ),   OLE M( 4 ),       OLE2 M( 4 ),       RESERVED1 M( 4 ) ;
 , RESERVED2 M( 4 ), RESERVED3 M( 4 ), RESERVED4 M( 4 ), RESERVED5 M( 4 ),  RESERVED6 M( 4 ) ;
 , RESERVED7 M( 4 ), RESERVED8 M( 4 ), USER M( 4 ) ;
 ) 
 
 
 