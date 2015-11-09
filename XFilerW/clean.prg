* $Header: /sntxdeve/vfp/VfpLib/Prg/cleanup.prg,v 1.15 2009/01/13 15:05:12 andriusk Exp $
*
* $Log: cleanup.prg,v $
* Revision 1.15  2009/01/13 15:05:12  andriusk
* be Lock fix
*
* Revision 1.14  2007/05/11 08:08:56  andriusk
* wbx cleanup
*
* Revision 1.13  2005/05/06 08:32:31  andriusk
* on cleanup goApp, goSql release
*
* Revision 1.12  2005/02/23 16:36:02  andriusk
* Clean_Base: with release window
*
* Revision 1.11  2005/02/18 07:58:52  andriusk
* Clean baseobj.vcx
*
* Revision 1.10  2004/08/23 15:19:55  andriusk
* Local vars
*
* Revision 1.9  2004/07/02 07:00:23  andriusk
* CleanTmp dir TEMP
*
* Revision 1.8  2004/07/02 06:56:49  andriusk
* CleanTmp dir TEMP
*
* Revision 1.7  2004/05/25 15:23:51  andriusk
* no message
*
* Revision 1.6  2004/05/20 06:45:37  andriusk
* PS feature
*
* Revision 1.5  2004/05/05 06:10:18  andriusk
* 2004.05 state
* 

*Cleanup 
*###################################################################################################
* FUNCTION CleanUP 
*###################################################################################################
 
RELEASE goApp
RELEASE goEnv
RELEASE ALL EXTENDED  

EXTERNAL PROCEDURE Start 
 
=CleanSafe()

IF TYPE([goApp]) # "U"
   RELEASE goApp
ENDIF 
IF TYPE([goSQL]) # "U"
   RELEASE goSQL 
ENDIF 

_SCREEN.LockScreen = .F.
_SCREEN.Visible = .T.

CLEAR ALL                            && CLEAR ALL neuzdaro OPEN DATABASE 
CLOSE DATABASES ALL         

SET SYSMENU TO DEFAULT 

IF VERSION(2) <> 0 AND FILE( "D:\Vfplib\prg\Def_lib.prg" ) 
   *  COMPILE D:\Vfplib\prg\Def_lib.prg
   *  COMPILE D:\Vfplib\prg\Msg_lib.prg
ENDIF

FUNCTION InitSys 

*   MODI COMM d:\Vfplib\sys\setV.prg SAVE 
DO ("d:\Vfplib\sys\setV.prg" )

*###################################################################################################
FUNCTION CleanMenu 
*###################################################################################################

IF TYPE( "_SCREEN.oMnuSetV" ) <> "U"
   _SCREEN.oMnuSetV = .F. 
ENDIF 

SET SYSMENU TO DEFAULT 
SET SYSMENU TO _MFILE, _MEDIT, _MVIEW, _MWINDOW, _MPROG, _MTOOLS 

IF TYPE( "_SCREEN.appsetvname" ) = 'C'  AND FILE( "d:\Vfplib\sys\SetV.prg")
   DO ("d:\Vfplib\sys\SetV.prg") 
ENDIF 
SET SYSMENU SAVE 

FUNCTION CleanObj 

 *=VERSION(2)#0 AND TryEnd() 
 *ON ERROR 
 
 LOCAL lnI, lcName, lnCnt
 SET ASSERTS ON  
 lnCnt = 0 
 FOR lnI = 1 TO 20 

   IF TYPE( "_VFP.Objects( lnI ).Name" ) = 'C'

     lnCnt = lnCnt + 1 
   
     ASSERT .F. MESSAGE "RELEASE _VFP.OBJECTS(" + TRANSFORM( lnI ) + ")" ;
               + " /name="+ _VFP.Objects( lnI ).Name ;
               + "/baseclass= " + _VFP.Objects( lnI ).BaseClass ;
               + "/class= " + _VFP.Objects( lnI ).Class ;
               
      lcName = _VFP.Objects( lnI ).Name 
      RELEASE &lcName
      IF TYPE( "_VFP.Objects( lnI ).Name" ) = 'C' ;
         AND  _VFP.Objects( lnI ).Name = lcName 
         
         IF TYPE(  "_VFP.Objects( lnI ).Visible" ) = 'L' 
            _VFP.Objects( lnI ).Visible = .F. 
         ENDIF 
         IF PEMSTATUS(  _VFP.Objects( lnI ), "RELEASE", 5 ) 
            _VFP.Objects( lnI ).Release()  
         ENDIF    
      ENDIF   
   ENDIF
   *IF TYPE( "_VFP.Objects( lnI ).Name" ) = 'C'
   *   _VFP.Objects( lnI ) = .F. 
   *ENDIF 
   
 ENDFOR 

 IF lnCnt = 0 
    MESSAGEBOX( "Not objects in memory :)" ) 
 ENDIF 
 
*###################################################################################################
FUNCTION CleanSafe
*###################################################################################################

    RELEASE goApp
    RELEASE goEnv
    RELEASE ALL EXTENDED

    SET PROCEDURE TO 
    SET CLASSLIB  TO 
    *SET PATH TO 
    SET ASSERTS ON 
    SYS(3099,70)
    ON ERROR 
    ON SHUTDOWN 

*###################################################################################################
FUNCTION UseE
 RETURN UseEmpty() 

*###################################################################################################
FUNCTION UseEmpty2
 RETURN UseEmpty() 

*###################################################################################################
FUNCTION UseEmpty

LOCAL LnLen , lnI 
LOCAL ARRAY Arr1[200,1] 

lnLen = AUSED( Arr1 )

FOR lnI = 1 TO lnLen 
   lcAlias = Arr1[ lnI, 1 ]
   IF RECCOUNT( lcAlias ) = 0
      USE IN (lcAlias)
   ENDIF
ENDFOR

*###################################################################################################
FUNCTION UseCurs

LOCAL LnLen , lnI 
LOCAL ARRAY Arr1[200,1] 

lnLen = AUSED( Arr1 )

FOR lnI = 1 TO lnLen 
   lcAlias = Arr1[ lnI, 1 ]
   IF ".TMP" $ DBF( lcAlias ) ;
      OR  FULLPATH( SYS( 2023 ) )  $ DBF( lcAlias )
      
      USE IN (lcAlias)
   ENDIF
   
ENDFOR



*###################################################################################################
FUNCTION CleanTmp
* DO CleanTmp IN d:\vfplib\prg\CleanUp.prg   

PUBLIC lcDir
* lcDir = ADDBS( SYS(2023 ) )
lcDir = [C:\Temp\] 

PUBLIC lnLen
PUBLIC ARRAY aFiles[1]


CREATE CURSOR FList ( FName C(50), SizeB I, Date D, Time C(12), Attr C(6 ) ) 

lnLen = ADIR( aFiles, lcDir + "\*.cdx" ) 
APPEND FROM ARRAY aFiles 

lnLen = ADIR( aFiles, lcDir + "\*.idx" ) 
APPEND FROM ARRAY aFiles 

lnLen = ADIR( aFiles, lcDir + "\*.tmp" ) 
APPEND FROM ARRAY aFiles 

lnLen = ADIR( aFiles, lcDir + "\*.Err" ) 
APPEND FROM ARRAY aFiles 

lnLen = ADIR( aFiles, lcDir + "\*.bak" ) 
APPEND FROM ARRAY aFiles 


SELECT FList 
SET FILTER TO Date <= DATE() - 1
COUNT TO lnCnt 

IF lnCnt = 0 
   ? "No old tmp files from "+ lcDir + "     " + CHR(13) 
   RETURN .T.
ENDIF

ON ERROR DO OnErr IN CleanUP 

? "Erasing from "+ lcDir + "     " + CHR(13) 
SCAN 
   lcFName = lcDir + ALLTRIM( FName )
   IF FILE( lcFName )
      ? "Erasing "+ lcFName 
      ERASE (lcFName)
      ?? IIF( ! FILE( lcFName ), " Ok ", " failed " )
   ENDIF
ENDSCAN 

ON ERROR  


*###################################################################################################
FUNCTION OnErr 

RETURN .T. 

*###################################################################################################
FUNCTION GetGOBj 

LOCAL ARRAY a1[1], a2[1] 

ASELOBJ( a1 )
ASELOBJ( a2, 3 )

RELEASE gObj 
PUBLIC gobj

IF TYPE( 'a1[1].Name' ) = 'C' 
   gObj=a1[1]        && current ctrl
ENDIF 
IF TYPE( 'gObj.Name' ) # "C" ;
   AND TYPE( 'a1[2].Name' ) = 'C' 
   gObj=a1[2]        && form/object
ENDIF  
IF TYPE( 'gObj.Name' ) # "C" ;
   AND TYPE( 'a2[1].Name' ) = 'C' 
   gObj=a2[1]        && select code snipset ?? 
ENDIF 

RETURN gObj 


FUNCTION ShowOutput 

_VFP.LanguageOptions = 1 

DEBUG
IF WEXIST( "WATCH" )
  HIDE WINDOW "WATCH" 
ENDIF
IF WEXIST( "CALL STACK" )
  HIDE WINDOW "CALL STACK"
ENDIF
IF WEXIST( "TRACE" )
  HIDE WINDOW "TRACE"
ENDIF
IF WEXIST( "LOCALS" ) 
  HIDE WINDOW "LOCALS"
ENDIF
IF WEXIST( "DEBUG OUTPUT" ) 
  SHOW WINDOW "DEBUG OUTPUT"
ENDIF 
IF WEXIST( "VISUAL FOXPRO DEBUGGER" ) 
   MOVE WINDOW "VISUAL FOXPRO DEBUGGER" TO 30, 50
ENDIF 

ACTIVATE SCREEN 

FUNCTION Path 

  #DEFINE PROJ_PATH    Prg\, Lib\, Bmp\, Frm\, Cls\   
  
  #DEFINE VLIB_PATH    D:\VfpLib
  #DEFINE DEFLIB_PATH  VLIB_PATH\Prg\, VLIB_PATH\Cls\, VLIB_PATH\BMP\ ;
                     , VLIB_PATH\EXT\ ;            && Extensions
                     , VLIB_PATH\SYS\ ;            && system 
                     , Tmp\
  
  SET PATH TO PROJ_PATH, DEFLIB_PATH
  SET PROCEDURE TO Def_lib, Sysprog, Msg_Lib  
  
FUNCTION PS 
 =PathSys() 

FUNCTION C_Base 
 DO Clean_Base && IN CleanUP 
 
FUNCTION Clean_Base 

MODIFY CLASS bc_form OF d:\vfplib\cls\baseobj.vcx      NOWAIT SAVE
MODIFY CLASS bc_grid OF d:\vfplib\cls\baseobj.vcx      NOWAIT SAVE
MODIFY CLASS bc_textbox OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_pageframe OF d:\vfplib\cls\baseobj.vcx NOWAIT SAVE
MODIFY CLASS bc_custom OF d:\vfplib\cls\baseobj.vcx    NOWAIT SAVE

MODIFY CLASS bc_checkbox OF d:\vfplib\cls\baseobj.vcx  NOWAIT SAVE
MODIFY CLASS bc_combobox OF d:\vfplib\cls\baseobj.vcx  NOWAIT SAVE
MODIFY CLASS bc_commandbutton OF d:\vfplib\cls\baseobj.vcx  NOWAIT SAVE
MODIFY CLASS bc_commandgroup OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_optiongroup OF d:\vfplib\cls\baseobj.vcx    NOWAIT SAVE
MODIFY CLASS bc_container OF d:\vfplib\cls\baseobj.vcx NOWAIT SAVE
MODIFY CLASS bc_container OF d:\vfplib\cls\baseobj.vcx NOWAIT SAVE
MODIFY CLASS bc_image OF d:\vfplib\cls\baseobj.vcx     NOWAIT SAVE
MODIFY CLASS bc_label OF d:\vfplib\cls\baseobj.vcx     NOWAIT SAVE
MODIFY CLASS bc_editbox OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_line OF d:\vfplib\cls\baseobj.vcx      NOWAIT SAVE
MODIFY CLASS bc_listbox OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_shape OF d:\vfplib\cls\baseobj.vcx     NOWAIT SAVE
MODIFY CLASS bc_spinner OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_timer OF d:\vfplib\cls\baseobj.vcx     NOWAIT SAVE
MODIFY CLASS bc_toolbar OF d:\vfplib\cls\baseobj.vcx   NOWAIT SAVE
MODIFY CLASS bc_treeview OF d:\vfplib\cls\baseobj.vcx  NOWAIT SAVE

IF FILE([wbx.vcx])
   MODIFY CLASS bc_form OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_container OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_combobox OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_textbox OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_checkbox OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_pageframe OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_commandbutton OF wbx.vcx  NOWAIT SAVE
   MODIFY CLASS bc_toolbar OF wbx.vcx  NOWAIT SAVE

   RELEASE WINDOW [Class Designer - wbx.vcx (bc_form)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_container)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_combobox)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_textbox)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_checkbox)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_pageframe)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_commandbutton)]
   RELEASE WINDOW [Class Designer - wbx.vcx (bc_toolbar)]
ENDIF 
IF FILE([webproducts.vcx])
   MODIFY CLASS stypspec_cnt OF webproducts.vcx NOWAIT SAVE 
   MODIFY CLASS styptrp_cnt OF webproducts.vcx NOWAIT SAVE 

   RELEASE WINDOW [Class Designer - webproducts.vcx (stypspec_cnt)]
   RELEASE WINDOW [Class Designer - webproducts.vcx (styptrp_cnt)]
ENDIF 

RELEASE WINDOW [Class Designer - baseobj.vcx (bc_form)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_grid)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_textbox)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_pageframe)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_custom)]

RELEASE WINDOW [Class Designer - baseobj.vcx (bc_checkbox)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_combobox)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_commandbutton)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_commandgroup)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_optiongroup)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_container)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_container)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_image)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_label)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_editbox)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_line)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_listbox)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_shape)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_spinner)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_timer)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_toolbar)]
RELEASE WINDOW [Class Designer - baseobj.vcx (bc_treeview)]

FUNCTION PathSys 

SET PATH TO PRG\, LIB\, BMP\, FRM\, CLS\   ;
          , D:\VFPLIB\PRG\, D:\VFPLIB\CLS\, D:\VFPLIB\BMP\  ;
          , D:\VFPLIB\EXT\  , TMP\ , D:\VFPLIB\SYS\

          