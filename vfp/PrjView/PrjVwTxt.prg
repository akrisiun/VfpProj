* $Header$
* Project texts...
* $Log$
*#######################################################################################


IF Fill_PrjTxt()
   =Fill_Prg()
   =Fill_VCX()
ENDIF 

*#######################################################################################
FUNCTION GetTimeStamp(tnTimeStamp) 

LOCAL lcTimeStamp,lnYear,lnMonth,lnDay,lnHour,lnMinutes,lnSeconds,lcTime,lnHour
LOCAL laDir[1]

IF EMPTY(tnTimeStamp)
   RETURN ""
ENDIF
lcTimeStamp=IntToBin(tnTimeStamp)

lnYear=BinToInt(SUBSTR(lcTimeStamp,1,7))+1980
lnMonth=BinToInt(SUBSTR(lcTimeStamp,8,4))
lnDay=BinToInt(SUBSTR(lcTimeStamp,12,5))
lnHour=BinToInt(SUBSTR(lcTimeStamp,17,5))
lnMinutes=BinToInt(SUBSTR(lcTimeStamp,22,6))
lnSeconds=BinToInt(SUBSTR(lcTimeStamp,28,4))
*--     YYYY   YYYM   MMMD DDDD HHHH  HMMM   MMMS   SSSS
RETURN TTOC(EVALUATE("{^"+STR(lnYear,4)+"-"+STR(lnMonth,4)+"-"+STR(lnDay,4)+" " ;
       + STR(lnHour,4)+":"+STR(lnMinutes,4)+":"+STR(lnSeconds,4)+"}"))


*#######################################################################################
FUNCTION IntToBin(tnInteger)

LOCAL lnInteger,lcBinary,lnDivisor,lnCount

IF EMPTY(tnInteger)
    RETURN "0"
ENDIF
lnInteger=INT(tnInteger)
lcBinary=""
FOR lnCount = 31 TO 0 STEP -1
    lnDivisor=2^lnCount
    IF lnDivisor>lnInteger
        lcBinary=lcBinary+"0"
        LOOP
    ENDIF
    lcBinary=lcBinary+IIF((lnInteger/lnDivisor)>0,"1","0")
    lnInteger=INT(lnInteger-lnDivisor)
ENDFOR
RETURN lcBinary


*#######################################################################################
FUNCTION BinToInt(tcBinary)

LOCAL lcInteger,lnInteger,lnCount,lnStrLen

IF EMPTY(tcBinary)
    RETURN "0"
ENDIF
lnStrLen=LEN(tcBinary)
lnInteger=0
FOR lnCount = 0 TO (lnStrLen-1)
    IF SUBSTR(tcBinary,lnStrLen-lnCount,1)=="1"
        lnInteger=lnInteger+2^lnCount
    ENDIF
ENDFOR
RETURN INT(lnInteger)

*#######################################################################################
FUNCTION Fill_PrjTxt()

  IF !USED([cPrj])
     RETURN .F.
  ENDIF 
  
  CREATE CURSOR cPrjTxt (ID int, Stem Char(20), SubDir C(40), Key C(60), Ext C(4) ;
          , FullFile C(80), ChTime T, TimeStamp Int ;
          , ObjName C(40), Parent c(40), BaseClass C(30), Class C(40) ;
          , Properties M, Methods M, Prc M, Str M, Active int)
  
  INSERT INTO cPrjTxt (Stem, SubDir, Key, Ext, FullFile, ChTime, TimeStamp) ;
    SELECT Stem, SubDir, Key, ext, FullFile, ChTime, TimeStamp ;
       FROM cPrj WHERE !Exclude
  
  UPDATE cPrj  set ID = RECNO()
  * br([!FILE(ALLTRIM(fullfile))], [cPrjTxt])

  RETURN .T.


*#######################################################################################
FUNCTION Fill_PRG
* DO Fill_PRG IN PrjVwTxt
*#######################################################################################

  SELECT cPrjTxt
  SCAN FOR INLIST(UPPER(Ext), 'TXT', 'PRG', 'HTML', 'XML') ;
      AND FILE(ALLTRIM(FullFile))
        
       lcFile = ALLTRIM(FullFile)
       ? lcFile
       
       REPLACE Active WITh 2 

       REPLACE Active WITh 1, Methods WITH FILETOSTR(lcFile)

 ENDSCAN 
               


*#######################################################################################
FUNCTION Fill_VCX  
* DO Fill_VCX IN PrjVwTxt
*#######################################################################################

  ACTIVATE Screen 
  
  LOCAL lcFile, lnRec 
  
  * DELETE FROM cPrjTxt WHERE UPPER(Ext) NOT IN ('VCX','SCX') OR !FILE(ALLTRIM(FullFile))

  SELECT cPrjTxt
  
  SCAN FOR Active = 0 AND INLIST(UPPER(Ext), 'VCX','SCX')
    
    lnRec = RECNO()
    REPLACE Active WITh 2
    
    lcFile = ALLTRIM(FullFile)
    
    IF USED([Vcx])
       USE IN Vcx
    ENDIF
    SELECT 0
    
    ? lcFile
    USE (lcFile) ALIAS Vcx again shared
    IF !USED([vcx])
       SELECT cPrjTxt
       LOOP
    ENDIF 

    IF TYPE([Vcx.ObjName]) # "M" OR TYPE([Vcx.TimeStamp]) # "N"
       USE IN Vcx
       SELECT cPrjTxt
       LOOP
    ENDIF 

    * Properties M, Methods M, Prc M, Str M, Active int)
    
    INSERT INTO cPrjTxt (ObjName, Parent, BaseClass, Class ;
          , Key, Properties, Methods, TimeStamp, Ext, FullFile, Active) ;
    SELECT LEFT(ObjName, 20) as ObjName , LEFT(Parent, 40) as Parent ;
          , LEFT(BaseClass, 30) AS BaseClass,  LEFT(Class, 40) AS Class ;
          , SPACE(20) as Key, Properties, Methods, TimeStamp ;
          , [OBJ] AS Ext, cPrjTxt.FullFile as FullFile, 3 AS Active ;
        FROM Vcx WHERE Reserved2 = "1" OR !EMPTY(Class)
        
    SELECT cPrjTxt
    GO RECORD lnRec
    
    REPLACE Active WITh 1

  ENDSCAN 
  
  =Update_PrjTxt()
  
  RETURN .T.
  * br(, [cPrjTxt])

*#######################################################################################
FUNCTION Update_PrjTxt()
* DO Update_PrjTxt IN PrjVwTxt


  UPDATE cPrjTxt  set Key = ALLTRIM(ObjName) + " OF " + JUSTFNAME(FullFile) ;
                    , ChTime = CTOT(GetTimeStamp(TimeStamp)) ;
      WHERE Active = 3
  
  UPDATE cPrjTxt  set ID = RECNO()

  RETURN .T.

  SELECT Key, ObjName, Parent, fullFile, count(*) ;
      from cPrjTxt ;
      group by key, ObjName, Parent, FullFile having count(*)>1  
      
  set FILTER to atc('act_', parent+ class) > 0       
  * Br(,'cPrjtxt')
  
*#######################################################################################
* DO Fill_PrjTxt IN PrjVwTxt
* DO Fill_VCX IN PrjVwTxt

