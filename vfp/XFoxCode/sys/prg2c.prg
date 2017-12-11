* AMEMINFO 
* $Id: prg2c.prg,v 1.3 2005/02/18 09:15:29 andriusk Exp $
* $Log: prg2c.prg,v $
* Revision 1.3  2005/02/18 09:15:29  andriusk
* _VFP.SetVar todo
*
* Revision 1.2  2004/05/20 06:28:40  andriusk
* added
* 

#DEFINE LIBPATH D:\Vfplib\sys

* AMEMINFO 
IF ! INLIST( ALIAS() , "CPRG", "AINF" , 'CLN' ) 
   DO GetCode IN D:\vfplib\sys\ClipFunc 
   * DO ALn  WITH  lcCodeFile 
ENDIF 

IF EMPTY( ALIAS() ) 
   RETURN .F.
ENDIF 
IF TAGCOUNT() = 0 AND TYPE( "Ln" ) # "U" 
   INDEX ON BINTOC( Ln ) + BINTOC( RECNO() ) TAG Ln
ENDIF 

IF TYPE( "gBr_ainf" ) = 'U'
   PUBLIC gBr_ainf 
ENDIF 

BROW SAVE  NOWAIT   NAME gBr_ainf 
 
gBr_Ainf.GridLines = 0 
gBr_Ainf.RecordMark = .F.
IF ! FILE( [[LIBPATH\Dbo.prg] ) 
   RETURN .T.
ENDIF 

WITH gBr_Ainf.Columns( 1 )
   .RemoveObject( .Objects( 2 ).Name )  
ENDWITH  
WITH gBr_Ainf.Columns( 1 )
   .Sparse = .F. 
   .NewObject( "Text1", [PrgColText], [LIBPATH\Dbo.prg] )  
   * CLASS: PrgColText AS TextBox  IN Dbo.prg && program code column text

   .Objects( 2 ).Visible = .T. 
   .Width = 700 
ENDWITH 

FUNCTION ALn ( lcCodeFile )

CREATE CURSOR cLn ( Str c(180), Ln i )

PUBLIC ARRAY aLn[1] 
LOCAL a1 
a1= FILETOSTR( lcCodeFile )

ALINES( aln, a1 )

FOR lni= 1 TO ALEN( aln ) 
  INSERT INTO cln ( str, Ln ) ;
   VALUES ( aln[lni], lni ) 
ENDFOR 
REPLACE ALL ;
 STR WITH STRTRAN( str, CHR(9), SPACE(4) )

FUNCTION AInfo ()  
 
SELECT * from cln ;
 WHERE ;
 (    Ln in  (select line-1 FROM cprg ) ;
  OR Ln in (select line FROM cprg ) ;
  OR Ln in  (select line+1 FROM cprg ) ;
  OR Ln in  (select line+2 FROM cprg ) ;
  ) ;
 AND  !INLIST( STREXTRACT(str,""," ");
         , "LOCAL", "IF", "DO" ) ;
 ORDER BY Ln ;  
  INTO CURSOR ainf  READWRITE 
  
   RETURN .F. 

FUNCTION IntoClip 

PRIVATE lcStr, lcCur, lcVar 
lcStr = "" 
lcCur = ""
GO TOP 
for lni= 1 TO RECCOUNT() 
  IF ! EMPTY( lcCur ) OR ! EMPTY( str ) 

      ASSERT ! EMPTY( lcCur ) OR ! EMPTY( ALLTRIM( str ) ) 

      lcCur = RTRIM( str ) 
      lcCur = STRTRAN( lcCur, CHR(160), " " ) 
      lcCur = STRTRAN( lcCur, CHR(9), SPACE(4) ) 
      lcCur = CHRTRAN( lcCur, CHR(10)+CHR(13)+CHR(0), "" ) 

      lcVar = STREXTRACT( " "+ ALLTRIM( str ), " ", " " )
      IF ! lcVar == "LOCAL"  ;
         AND ! lcVar == "PRIVATE" ;
         AND ! lcVar == "IF" ;
         AND ! lcVar == "DO" ; 
         AND ! lcVar == "CASE" 
         
         lcStr = lcStr + CHR(13) + lcCur 
      ENDIF    
  ENDIF       
  IF ! EOF()
    SKIP 1 
  ENDIF
ENDFOR 
* ? lcStr 
_CLIPTEXT = lcStr 

