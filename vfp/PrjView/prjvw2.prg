* PrjVw.prg : Project View 
*$Id: prjvw2.prg,v 1.7 2006/03/15 14:15:33 andriusk Exp $
*$Log: prjvw2.prg,v $
*Revision 1.7  2006/03/15 14:15:33  andriusk
*Geri pakeitimai 2006-03
*
*Revision 1.8  2006/02/14 18:00:23  AndriusK
*Found2
*
*Revision 1.7  2006/01/30 17:08:43  AndriusK
*Home V6
*
*Revision 1.6  2005/02/23 16:56:25  andriusk
*Old PrjVw
*
*Revision 1.5  2004/11/29 12:31:41  andriusk
*.HookPrg use, classes from LCtrLib.prg
*
*Revision 1.4  2004/11/17 16:57:53  andriusk
*.Prj_HomeDir property, DIMENSION aFil[ lnI, 5 ] sort
*
*Revision 1.3  2004/08/27 08:38:20  andriusk
*Item,Stem fixes
*
*Revision 1.2  2004/08/24 06:20:27  andriusk
*PrjVw alia 1 (no working info)
*
*Revision 1.4  2004/07/02 07:13:16  andriusk
*Hot tracking tree added
*
*Revision 1.3  2004/05/28 15:51:26  andriusk
*Windows list,  InfoList()
*Revision 1.2  2004/05/27 14:11:39  andriusk
*PRJVW + window
*Revision 1.1  2004/05/21 15:52:07  andriusk
*BrowPric
*
*######################################################
 FUNCTION PrjVw2 
*######################################################
 
#DEFINE APP_VERSION .F.    
* #DEFINE APP_VERSION TYPE([_screen.AppSetVName]) = 'C' 

#DEFINE USE_FDATA .T.
*#DEFINE LDEBUG_MODE .F. 
#DEFINE LCURS  .T. 
#DEFINE TEST_FIL .F. 

*------------------------------------------------------ 
#IF APP_VERSION 
   #DEFINE LIB_PATH
#ELSE
   #DEFINE LIB_PATH D:\Vfplib\Sys\
#ENDIF 

#IF NOT APP_VERSION  
    #DEFINE SYS_PATH D:\VfpLib\Sys\
    #DEFINE THISFILE D:\VfpLib\Sys\PrjVw2.prg 
#ELSE
    #DEFINE SYS_PATH
    #DEFINE THISFILE PrjVw2.prg
#ENDIF 

#DEFINE TREE_NODECLICK       1 
#DEFINE TREE_NODECHECK       2
#DEFINE TREE_NODEEDIT        5 
#DEFINE TREE_NODERUN         4
#DEFINE CR   CHR(13)+CHR(10) 
#DEFINE CRLF CHR(13)+CHR(10)   
 
EXTERNAL PROCEDURE PrjVwHook.prg 
IF !APP_VERSION AND FILE([UseF.prg]) 
   * Test FData dir ... 
   SET PATH TO BMP\, PRG\, LIB\, CLS\, ;
         , D:\VFPLIB\PRG\, D:\VFPLIB\CLS\, D:\VFPLIB\BMP  , D:\VFPLIB\EXT\, D:\VFPLIB\EBR\, TMP\ ;
         , D:\VFPLIB\SYS\, D:\VFPLIB\SYS\FData\
ENDIF 
 
LOCAL ln1
ln1 = 1 
IF TYPE( "goPrj.Name" ) # "C" 
   PUBLIC goPrj AS PrjHook OF PrjVw2.prg 
   goPrj = NEWOBJECT( "PrjHook" ) 
   IF VARTYPE( goPrj ) # "O" 
      RELEASE goPrj  
      RETURN .F.
   ENDIF 
ENDIF  
_SCREEN.AddProperty( "oPrj", .NULL. )  
WITH goPrj 
   IF .AddForm() 
      .Show()   
   ENDIF 
ENDWITH 

*######################################################################## 
DEFINE CLASS PrjViewDS AS PrjView 
    DataSession = 2
ENDDEFINE     

*######################################################################## 
DEFINE CLASS PrjHook AS Custom 

    Name = "PrjHook" 
    
    DIMENSION aItems[ 1 ]
    ItemCount= 0 
    PrjCnt = 0 
    oLast = .NULL.
    oForm = .NULL.
    curItem = ""
    curItemFull = ""
    curItemType = ""
    
    cLastState = ""
    XML = ""
    
   
   FUNCTION Init
     RETURN .T.

   FUNCTION Destroy 
     RETURN .T.
       
   FUNCTION AddForm() 
    WITH This 
    
      LOCAL loForm AS PrjViewForm OF PrjVw2.prg 
      SET PROCEDURE TO ([SYS_PATH] + [LCtrLib.prg]) ADDITIVE 
      
      .oLast = .NULL.
      loForm = NEWOBJECT([PrjViewForm], [SYS_PATH] + [LCtrLib.prg]) 
      IF TYPE([loForm.Name]) # 'C' 
         RETURN .F.                    && Failed form 
      ENDIF 
      .PrjCnt = .PrjCnt + 1
      
      .oLast = loForm 
      .oForm = loForm
      .oLast.oHook = This 
      _SCREEN.oPrj = goPrj.oLast 
    
      .ItemCount = .ItemCount +  1
      DIMENSION .aItems[ .ItemCount ] 
      .aItems[ .ItemCount ] = .oLast 
    ENDWITH    

   FUNCTION DelForm( toForm AS Form ) 
      WITH This
         .PrjCnt = .PrjCnt - 1
         IF  .PrjCnt < 1
             _SCREEN.oPrj = .NULL.
             RELEASE goPrj 
         ENDIF 
      ENDWITH 
      
   FUNCTION Show 
     IF TYPE([This.oLast.Name]) # "C"
        RETURN .F.
     ENDIF 
     RETURN This.oLast.Show() 

   FUNCTION QueryUnload
     IF TYPE([This.oLast.Name]) # "C"
        RETURN .F.
     ENDIF 
     RETURN This.oLast.QueryUnload() 

   FUNCTION Hide
     IF TYPE([This.oLast.Name]) # "C"
        RETURN .F.
     ENDIF 
     RETURN This.oLast.Hide() 
          
ENDDEFINE 

*######################################################################## 
DEFINE CLASS PrjViewForm AS L_FORM OF LCtrLib.Prg   

  #IF .F.
      LOCAL ThisForm AS PrjViewForm OF PrjVw2.Prg 
      LOCAL This     AS PrjViewForm OF PrjVw2.Prg 
  #ENDIF 

    Top = 5
    Left = 300   
    Height = 250
    Width = 158
    oHook = .NULL.
    CaptionPref = "prj:"
    cAlignment = "1100" 

    Name = "PROGS"
    Visible = .F. 
    DIMENSION aNodeInfo[ 1, 10 ]

    cIniFilename = [SYS_PATH] + [Prj.Ini]
    isRestoreposition = .T.
    
    Hookprg = [SYS_PATH] + [PrjVwHook.prg]
    
    Prj_HomeDir = "" 
    DIMENSION Prj_Items[ 1, 1 ]
    DIMENSION Prj_ItemInfo[ 1, 10 ]
 
    #DEFINE NODEVALUES_SECTION  
    
    N_Item = ""
    N_Key  = ""
    N_Children = 0
    N_Text = "" 
    N_ParKey = "" 
    N_ParText = "" 
    N_Line = 0 
    N_Idx = 0
    N_Stem = "" 
    N_SrcType = "" 
    
    N_File = "" 
    N_Ext  = "" 
    N_Dir  = ""
    N_Exclude = .F.
    
    N_Cmd  = "" 
    N_Prj  = "" 
    N_Alias = "" 
        
    N_Info = ""     
    Cmd_Last = "" 
    CfgPathNow = ""
    CfgPathOld = ""
    CfgDSIDOld = 1
    
    ADD OBJECT ObjCfg AS CfgObject  WITH ;
         nLen = 0 ;
       , cAlias = "PrjCfg" , cPrj = 'DEFPRJ' 

    lDebug = .F.
    lInitForm = .T.
    oDataExplorer = .NULL.        && cDataExplorer object (container) 
    *######################################################################## 

ADD OBJECT pgf1 AS PrjVwFrame WITH ;
     Top = 1 ;
   , Left = 0 ;
   , Width = 160 ;
   , Height = 250 ;
   , calignment = "1100"  

ADD OBJECT chkfav AS L_checkbox WITH ;
   Name = "chkFav";
   , Top = 2, Left = 68 ;
   , Height = 17 , Width = 31 ;
   , FontName = "Tahoma" ;
   , FontSize = 9 ;
   , Caption = "Fav." ;
   , Value = 2 , Style = 1, AutoSize = .F. ;
   , ToolTipText = "Favorite mark" 

ADD OBJECT cmdedit AS L_commandbutton WITH ;
   Name = "cmdEdit", Top = 1, Left = 101, Height = 19, Width = 27 ;
   , FontName = "Tahoma", FontSize = 9 ;
   , Caption = "\<Edit", ToolTipText = "Edit [Enter]" 
   
ADD OBJECT cmdrun AS L_commandbutton WITH ;
   Name = "cmdRun", Top = 1, Left = 128, Height = 19, Width = 27 ;
   , FontName = "Tahoma", FontSize = 9 ;
   , Caption = "\<Run"

ADD OBJECT cmdVCX AS L_commandbutton WITH ;
    Name = "cmdVCX", Top = 1, Left = 158, Height = 19, Width = 27 ;
   , FontName = "Tahoma", FontSize = 9 ;
   , Caption = "\<VCX", Enabled = .F. 

ADD OBJECT cmdSRC AS L_commandbutton WITH ;
   Name = "cmdSRC", Top = 1, Left = 184, Height = 19, Width = 27 ;
   , FontName = "Tahoma", FontSize = 9 ;
   , Caption = "x\<SRC", Enabled = .F. 

ADD OBJECT cmdFind AS L_commandbutton WITH ;
   Name = "cmdFind", Top = 1, Left = 211, Height = 19, Width = 27 ;
   , FontName = "Tahoma", FontSize = 9 ;
   , Caption = "\<Find", Enabled = .F. 

ADD OBJECT cboSort AS L_cbobutton WITH ;
   Name = "cboSort", Top = 0, Left = 240 ;
   , Height=21, Width = 18, Enabled = .F.  

ADD OBJECT oMenu AS MenuItems  

*--------------------------------------------- 
FUNCTION QueryUnload

    IF ! L_FORM::QueryUnload()
        RETURN .F.
    ENDIF
    This.Hide() 
    RETURN .T. 

FUNCTION Load 
    SET DATASESSION TO 1 
    L_FORM::Load()

FUNCTION Activate 
    
    IF TYPE([_SCREEN.oPrj.oForm.Name]) # "C" 
       _SCREEN.oPrj = This.oHook
       _SCREEN.oPrj.oForm = This
    ENDIF    
    This.CfgPathOld = SET([PATH])             && old path ... 
    This.CfgDSIDOld = _SCREEN.DataSessionId   && old DSID 
    IF ! EMPTY(This.Prj_HomeDir) ; 
      AND ! FULLPATH(CURDIR())  == FULLPATH( This.Prj_HomeDir ) ;
      AND MESSAGEBOX( "CD "+   This.Prj_HomeDir + " ?", 4 ) = 6

        CD FULLPATH(This.Prj_HomeDir)  
    ENDIF
    
    L_FORM::Activate()


FUNCTION Init
    
    WITH This 
      .oCfg = .ObjCfg 
      .Caption = .CaptionPref 
      L_FORM::Init()

     IF TYPE( "_VFP.Application.ActiveProject.name" ) = 'C'  
         This.oCfg.cPrj =  ;
             UPPER( JUSTSTEM(_VFP.Application.ActiveProject.name) ) 
     ELSE          
         This.oCfg.cPrj = 'NEWPROJ'     
     ENDIF 
     This.oCfg.ReadCfg() 
     
     *---------------------------------------------- 
     .AddProperty( 'tree1', NULL )
     .AddProperty( 'info1', NULL )
     .tree1 = .pgf1.Pages( 1 ).tree1

     IF TYPE( ".pgf1.Pages( 1 ).txtInfo" ) = 'O'
       .info1 = .pgf1.Pages( 1 ).txtInfo
     ENDIF    
     .pgf1.ActivePage = 1  
     
     .AddProperty( "aItems[1]" )
     .AddProperty( "ItemsCount", 0 ) 
     
     DIMENSION .aItems[1]

     .lInitForm = .F.
     RETURN .uRetVal 
    ENDWITH

FUNCTION ReadPrj
     This.InitNode( "" ) 
     RETURN This.uRetVal 

FUNCTION ReadPos 
   
     LOCAL lcPos 
     lcPos = This.oCfg.ReadValue( "POS", This.Caption ) 
     lcPos = STREXTRACT( lcPos, "<EXECSCRIPT>", "</EXECSCRIPT" ) 
     IF ! EMPTY( lcPos ) 
        =EXECSCRIPT( lcPos, This ) 
     ENDIF

FUNCTION SavePos 
   
   WITH This  

    LOCAL lcPos
    lcPos = "<EXECSCRIPT>" + CRLF ;
        + [LPARAMETERS tObject ] + CRLF ;
        + [WITH tObject ] + CRLF ;
        + [ .Top =   ] + TRANSFORM( .Top ) + CRLF ;
        + [ .Left =  ] + TRANSFORM( .Left ) + CRLF ;
        + [ .Width = ] + TRANSFORM( .Width ) + CRLF ;
        + [ .Height = ] + TRANSFORM( .Height ) + CRLF ;
        + [ENDWITH ]   + CRLF ;
        + [</EXECSCRIPT> ] 

    This.oCfg.SaveValue( "POS", .Caption ;
                , "<INMEMO=1/><POS=[ , , , ]/>" ;
                , lcPos ) 
   
   ENDWITH  

FUNCTION Release 
   IF TYPE( [This.oHook.Name] ) = 'C'
      This.oHook.DelForm( This ) 
      This.oHook = .NULL.
   ENDIF 

FUNCTION Hide() 
   This.SavePos() 
   This.Release() 

FUNCTION Show() 

  This.ReadPrj() 
  ASSERT !This.lDebug
  DO Form_Show WITH This IN (This.HookPrg)
  RETURN This.uRetVal 
      
PROCEDURE InitNode( tcKey )
  This.uRetVal = .F. 
  DO InitNode WITH This, tcKey IN (This.HookPrg)
  RETURN This.uRetVal 
  
  *######################################################################## 
  FUNCTION FillWindow( tcKey ) 
    
  DO FillWindow WITH This, tcKey IN (This.HookPrg) 
  RETURN This.uRetVal 

           
  *######################################################################## 
  FUNCTION FillProj( tcKey ) 
   
   This.uRetVal = .F.
   DO FillProj WITH This, tcKey IN (This.HookPrg)
   RETURN This.uRetVal 


*######################################################################## 
FUNCTION NodeFile( tcKey )

  DO NodeFile WITH This, tcKey IN (This.HookPrg) 
  RETURN This.uRetVal 

*######################################################################## 
FUNCTION NodeInfo( tcKey ) 
      
 This.uRetVal = .F.      
 DO NodeInfo WITH This, tcKey IN (This.HookPrg)
 RETURN This.uRetVal 


*######################################################################## 
FUNCTION NodeCmd( tcAddi ) 
   
  DO NodeCmd WITH This, tcAddi IN (This.HookPrg) 
  RETURN This.uRetVal         

*######################################################################## 
FUNCTION ValidSrc() 

   RETURN INLIST( RIGHT( DBF(), 4 ) ;
           , ".SCX", ".VCX", ".PJX", ".FRX", ".LBX" )  

*######################################################################## 
FUNCTION UseSrc( tcAddi ) 
  
  DO UseSrc WITH This, tcAddi  IN (This.HookPrg) 
  RETURN This.uRetVal 
  

*######################################################################## 
FUNCTION Info( lNoShow ) 

    This.NodeFile( This.N_Key )    
    This.N_Info =  This.N_Key ;
            + CR + This.N_Text ;
            + CR + ;
            + CR + "File: " + FULLPATH( This.N_File ) ;
            + CR + "Item: " + This.N_Stem ;
            + CR + "Line: " + TRANSFORM( This.N_Line ) ;
            + CR + "Children: " + TRANSFORM( This.N_Children ) ;
            + CR + ;
            + CR + "Parent: " + This.N_ParText ;
            + CR + "ParKey: " + TRANSFORM( This.N_ParKey )  
    
   RETURN This.ShowInfo( lNoShow ) 

*######################################################################## 
FUNCTION InfoList( lNoShow ) 

    This.NodeFile( This.N_Key )    
    
    This.N_Info =  This.N_Key ;
            + CR + This.N_Text ;
            + CR + ;
            + CR + "File: " + FULLPATH( This.N_File ) ;
            + CR + "Children: " + TRANSFORM( This.N_Children ) ;
            + CR 
    
    LOCAL lcKey 
    LOCAL loNode  AS Object 
    
    lcKey = This.N_Key 
    FOR lnI = 1 TO This.N_Children               
       IF lnI = 1 
          lcKey = This.tree1.Nodes( lcKey ).Child.Key      
       ELSE    
          lcKey = This.tree1.Nodes( lcKey ).Next.Key 
       ENDIF 
       loNode = This.tree1.Nodes( lcKey ) 

       This.N_info = This.N_info + ;
           CR + loNode.Text 
       
   ENDFOR 
   
   RETURN This.ShowInfo( lNoShow ) 
   
*######################################################################## 
FUNCTION ShowInfo( lNoShow ) 
    IF ! EMPTY( lNoShow ) 
       RETURN .T.
    ENDIF 

    MESSAGEBOX( This.N_Info ) 
    RETURN .T.            
       
*######################################################################## 
PROCEDURE TreeClick( tnEvent, tcKey )
  
  DO TreeClick WITH This, tnEvent, tcKey IN (This.HookPrg) 
  RETURN This.uRetVal 


*######################################################################## 
PROCEDURE RightMenu ( tnMode, tnValue ) 

   DO RightMenu WITH This, tnMode, tnValue IN (This.HookPrg) 
   RETURN This.uRetVal 

*######################################################################## 
PROCEDURE chkFav.Valid

  DO CHK_Valid WITH This, ThisForm IN (ThisForm.HookPrg) 
  
 RETURN This.uRetVal 

*######################################################################## 
PROCEDURE cmdEdit.Click
  DO Edit_Click WITH This, ThisForm IN (ThisForm.HookPrg) 
   
*######################################################################## 
PROCEDURE cmdRun.Click
  DO Run_Click WITH This, ThisForm IN (ThisForm.HookPrg) 
  
*######################################################################## 
PROCEDURE cmdFind.Click
  DO Find_Click WITH This, ThisForm IN (ThisForm.HookPrg) 
  
*######################################################################## 
PROCEDURE cmdVCX.Click
  DO VCX_Click WITH This, ThisForm IN (ThisForm.HookPrg) 

*######################################################################## 
PROCEDURE cmdSRC.Click
  DO SRC_Click WITH This, ThisForm IN (ThisForm.HookPrg) 

*######################################################################## 
PROCEDURE cmdSRC.RightClick
  DO SRC_RClick WITH This, ThisForm IN (ThisForm.HookPrg) 

ENDDEFINE
*
*-- EndDefine: progs
**************************************************

DEFINE CLASS CfgObject AS Custom 
  #IF .F.
      LOCAL This AS CfgObject OF PrjVw2.prg 
  #ENDIF

  CfgFile = ""
  lUsedCfg = .F. 
  cAlias = "PrjCfg" 
  cPrj = 'NEWPROJ' 
  lAuto = .F.
  lChanges = .F.
  uRetVal = .T.
  
  DIMENSION aCfg[ 1, 5 ]
  nLen = 0 
  
  HomeDir = ""
  nSele = 0 
  
  FUNCTION Init 
    
    This.HomeDir = ADDBS( JUSTPATH( _BUILDER ))
    IF EMPTY( This.HomeDir ) 
       This.HomeDir = HOME(1) 
    ENDIF 
    This.nSele = SELECT() 
    IF This.lAuto 
       This.ReadCfg() 
    ENDIF 

  FUNCTION Destroy
    IF This.lChanges 
       This.SaveCfg() 
    ENDIF

  FUNCTION ReadValue( cParKey, cKey )   
  
    LOCAL lnI 
    LOCAL lcValue 
    
    ASSERT  cParKey == ALLTRIM( cParKey ) 
    ASSERT  cKey == ALLTRIM( cKey ) 
    
    FOR lnI = 1 TO This.nLen 
      IF cParKey == This.aCfg[ lnI, 1 ] ;
         AND cKey  == This.aCfg[ lnI, 2 ] 
           
           lcValue = ALLTRIM( This.aCfg[ lnI, 3 ] ) 
           IF ATC( "<INMEMO=1/>", lcValue ) # 0 
              lcValue = lcValue + TRANSFORM( This.aCfg[ lnI, 4 ] ) 
           ENDIF
           RETURN lcValue 
      ENDIF 
    ENDFOR    
    RETURN " " 

  FUNCTION SaveValue( cParKey, cKey, cValue, cMValue )   
    
    LOCAL lnI , lFound 
    
    lnI = 0 
    lFound = .F. 
    FOR lnI = 1 TO This.nLen 
      IF This.aCfg[ lnI, 1 ] = cParKey ;
         AND This.aCfg[ lnI, 2 ] = cKey 
           
           lFound = .T.
           EXIT
      ENDIF 
    ENDFOR    

    IF ! lFound 
        This.nLen = This.nLen + 1 
        DIMENSION This.aCfg[ This.nLen, 5 ] 
    ENDIF
    
    This.aCfg[ lnI, 1 ] = cParKey 
    This.aCfg[ lnI, 2 ] = cKey 
           
    This.aCfg[ lnI, 3 ] = cValue  
    This.aCfg[ lnI, 4 ] = IIF( PARAMETERS() = 3, "", cMValue ) 
    This.aCfg[ lnI, 5 ] = DATETIME() 
    
    This.lChanges  = .T.
    RETURN .T. 
    
  
  FUNCTION BrowCfg() 
  
    This.nSele = SELECT() 
    IF This.OpenCfg() 
       SELECT PrjCfg 
       BROWSE IN SCREEN NOWAIT SAVE  
    ENDIF 
    SELECT (This.nSele)
    RETURN .T.  
    
  FUNCTION OpenCfg()    

    This.nSele = SELECT() 
    This.lUsedCfg  = USED( "PrjCfg" )     
    IF ! This.lUsedCfg 
       IF ! FILE( This.HomeDir + "prjcfg.dbf" )
          IF MESSAGEBOX( "Create ["+ This.HomeDir + "prjcfg.dbf" ;
                               + "] ?", 4 )= 6 
             SELECT 0 
             CREATE TABLE ( This.HomeDir + "prjcfg.dbf" ) ;
                 (  ParKey C(20), Key C(20) ;
                  , Value C(200), MValue M, ChTime T ) 
             USE                     
          ENDIF
       ENDIF 
       IF  FILE( This.HomeDir + "prjcfg.dbf" )
           USE ( This.HomeDir + "prjcfg.dbf") ALIAS PrjCfg IN 0 
       ENDIF 
    ENDIF 

    SELECT (This.nSele)             && restore state
    RETURN USED( "PrjCFG") 

  FUNCTION CloseCfg()      
    IF ! This.lUsedCfg 
       USE IN PrjCfg  
    ENDIF 
  
  FUNCTION ReadCfg 
    
    This.nLen = 0 
    DIMENSION This.aCfg[ 1, 5 ]
    IF ! This.OpenCfg()    
       RETURN .F.
    ENDIF 

    LOCAL ARRAY laCfg[ MAX( 1, RECCOUNT( "PrjCfg" ) ), 5 ] 

    SELECT ( Parkey ), ( Key ) ;
         , ( Value ), ( MValue ), ( ChTime ) ;
     FROM PrjCfg ORDER BY 1, 2 ;
     INTO ARRAY laCfg  
    
    IF _TALLY > 0 
      ASSERT _TALLY == ALEN( laCfg, 1 )  
      
      This.nLen = ALEN( laCfg, 1 ) 
      LOCAL lnI, lnJ 
      FOR lnI = 1 TO This.nLen
         FOR lnJ = 1 TO 4 
            laCfg[ lnI, lnJ ] = ALLTRIM( laCfg[ lnI, lnJ ] )
         ENDFOR 
      ENDFOR 
      DIMENSION This.aCfg[ This.nLen, 5 ] 
      =ACOPY( laCfg, This.aCfg )

      ASSERT This.aCfg[ 1, 1 ] == ALLTRIM( This.aCfg[ 1, 1 ] )
      ASSERT This.nLen == ALEN( laCfg, 1 )  
    ENDIF 
    This.CloseCfg()      
  
  FUNCTION SaveCfg 

    IF This.nLen = 0 OR ! This.OpenCfg()    
       RETURN .F.
    ENDIF 
    
    CREATE CURSOR cNewCfg ( ;
        ParKey C(20), Key C(20), Value C(100), MValue M ) 
    INDEX ON Parkey + key TAG seek CANDIDATE
    
    INSERT INTO cNewCfg FROM ARRAY This.aCfg         
    
    SELECT PrjCfg 
    REPLACE FOR SEEK( parkey + key, "cNewCfg" ) ;
        Value  WITH cnewcfg.Value ;
      , mvalue WITH cnewcfg.mvalue ;
      , chtime WITH DATETIME()
    
    INSERT INTO PrjCfg ( ParKey, Key, Value, MValue, ChTime ) ; 
      SELECT ParKey, Key, Value, MValue, DATETIME() ;
        FROM cNewCfg WHERE ParKey + Key NOT IN ;
            (SELECT ParKey + Key FROM PrjCfg ) 
    
    USE IN cNewCfg 
    This.CloseCfg()      
  

ENDDEFINE 


*######################################################################## 
DEFINE CLASS PrjPage AS L_Page OF LCtrLib.prg

  #IF .F.
      LOCAL This AS PrjPage OF PrjVw.prg  
  #ENDIF 
  FontName = "Tahoma"  
  FontSize = 7 
  Caption = "Project"  
  uRetVal = .T. 
  cAlignment = "1100" 
  
  ADD OBJECT Tree1 AS PrjTree WITH ;
        Top = 20 , Height = 200, Width = 300 ;
      , cAlignment = "1100" 
    
   ADD OBJECT txtInfo AS L_TextBox WITH ;
        Top = -1, Height = 21, Width = 300 ;
      , FontName = 'Tahoma', FontSize = 8 ;
      , cAlignment = "0100" 
    
    
    FUNCTION Init 

       ThisForm.SetRect( This.tree1 ;
               , 0, 20, This.Parent.PageWidth ;
               , This.Parent.PageHeight - 20 ) 
               
       This.txtInfo.Width = This.Parent.PageWidth  - 20                                          
       This.txtInfo.AddProperty( "cAlignment", "0100" ) 
       This.tree1.Visible = .T. 
       RETURN .T. 
            
ENDDEFINE 

*######################################################################## 
DEFINE CLASS DataPage AS L_Page OF LCtrLib.prg

  #IF .F.
      LOCAL This AS DataPage OF PrjVw2.prg  
  #ENDIF 
  FontName = "Tahoma"  
  FontSize = 7 
  Caption = "Vfp/Sql Data"  
  uRetVal = .T. 
  cAlignment = "1100" 
  
  ADD OBJECT ec AS L_CntDataExp WITH ;        && Container 
      Name = "ec", Tag = "ecDataExp" ; 
      , Top = -1, Height = 21, Width = 300 ;
      , FontName = 'Tahoma', FontSize = 8 ;
      , cAlignment = "1100" 
    
  FUNCTION Init 

   ThisForm.SetRect(This.ec  ;
           , 0, 0, This.Parent.PageWidth ;
           , This.Parent.PageHeight) 
   RETURN .T. 
            
ENDDEFINE 

*############################################################################### 
#DEFINE PARCLASS cDataExplorer
DEFINE CLASS L_CntDataExp AS cDataExplorer of d:\vfplib\sys\fdata\dataexp.vcx 
  #IF .F.
     LOCAL loDExp AS L_CntDataExp OF PrjVw2.prg 
     LOCAL This AS cDataExplorer of d:\vfplib\sys\fdata\dataexp.vcx  
     LOCAL ThisForm AS PrjViewForm OF PrjVw2.Prg 
  #ENDIF 

  lDebug = .F. 
  uRetVal = .T. 
  Visible = .F.
  
  FUNCTION Init 
    ThisForm.oDataExplorer = This 
    
    ASSERT !This.lDebug MESSAGE PROGRAM() 
    This.uRetVal = cDataExplorer::Init()
    * This.AdjustSize()
    RETURN This.uRetVal

  FUNCTION OnShow() 
 
    ASSERT !This.lDebug MESSAGE PROGRAM() 
    IF APP_VERSION OR FILE([DataExpEngine.prg]) 
        cDataExplorer::OnShow()
        This.Visible = .T. 
        This.AdjustSize()
    ENDIF         
    RETURN This.uRetVal 

  FUNCTION Resize() 
    
    IF !This.Visible 
       RETURN .F.
    ENDIF  
    ASSERT !This.lDebug MESSAGE PROGRAM() 
    cDataExplorer::Resize()
    This.AdjustSize()
    RETURN This.uRetVal 

  FUNCTION Destroy()
    *IF APP_VERSION OR FILE([FoxResource.prg]) 
    IF TYPE([This.oRootnode.Name]) = 'C'
       ASSERT APP_VERSION OR FILE([FoxResource.prg]) 
       cDataExplorer::Destroy()
    ENDIF 

  FUNCTION ActivateCnt   
    PUBLIC _oDataExplorer
    _oDataExplorer = THISFORM

  FUNCTION AdjustSize 
  
    LOCAL loPageFrame AS PageFrame
    loPageFrame = This.Parent.Parent 
    WITH This    && THIS.oDataExplorer
        .Width =  loPageFrame.PageWidth 
        .Height = loPageFrame.PageHeight
        .ResizeForm(.T.)
        .Refresh()
    ENDWITH 
   
ENDDEFINE   
  

*############################################################################### 
DEFINE CLASS PrjTree AS OleControl 

   #IF .F.
     LOCAL This AS PrjTree OF PrjVw.prg  
   #ENDIF 

    Name = "PrjTree"
    OleClass = "MsComCtlLib.TreeCtrl.2"  
    
    Visible = .T.
    Top = 1
    Left = 0
    Height = 225
    Width  = 155
    calignment = "1100"
    
    Style = 7  
    Scroll = .T. 
    LineStyle = 1 
    CheckBoxes = .F. 
    HideSelection = .F. 
    FullRowSelect = .T. && .F. 
    HotTracking = .T. 
    SingleSel = .T.     && .F. 
    Sorted = .F.  
    LabelEdit = 1 
    LineStyle = 0  
    
    OleDragMode = 1
    OleDropMode = 0     && accepts no ole in 
    PathSeparator = "\" 
    
    nClickMode = 0  

    *######################################################################## 
    PROCEDURE Init
    
        This.Visible = .T. 
        This.Object.Font = "Tahoma" 
        This.Object.Font.Size = 9

        This.Object.Indentation = 10.0        && butina nustatyti reiksme 
        This.Object.LabelEdit = 0 
        This.Object.HotTracking = .T. 
        This.Object.FullRowSelect = .F. 
        This.Object.SingleSel = .F. 
        This.Object.HideSelection = .F. 
        * This.Object.Checkboxes = .T. 
        *.Imagelist.ImageWidth  = 24
       
    ENDPROC

    *######################################################################## 
    PROCEDURE Expand
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECLICK, node.key )
        ENDIF
        Node.Expanded = .T.
    ENDPROC

    *######################################################################## 
    PROCEDURE NodeClick
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick(TREE_NODECLICK, node.key)
        ENDIF
    ENDPROC

    *######################################################################## 
    PROCEDURE NodeCheck
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECHECK, node.key )
        ENDIF
    ENDPROC

    *######################################################################## 
    PROCEDURE Click

        IF TYPE("This.SelectedItem.key" ) = 'C'
           ThisForm.TreeClick(TREE_NODECLICK, This.SelectedItem.key)
        ENDIF
    ENDPROC

    *######################################################################## 
    PROCEDURE KeyDown
        LPARAMETERS keycode, shift

        This.nClickMode = 2 
    ENDPROC


    PROCEDURE KeyUp
        LPARAMETERS keycode, shift

        This.nClickMode = 0 
    ENDPROC


    *######################################################################## 
    PROCEDURE MouseDown
        LPARAMETERS Button, Shift, x, y

        This.nClickMode = 1 
        IF Button = 2
           ThisForm.RightMenu()
        ENDIF
    ENDPROC

    *######################################################################## 
    PROCEDURE MouseUp
        LPARAMETERS button, shift, x, y

        This.nClickMode = 0 
    ENDPROC

    *######################################################################## 
    PROCEDURE DblClick
        IF TYPE( "This.SelectedItem.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECHECK, This.SelectedItem.key )
        ENDIF
    ENDPROC

ENDDEFINE 
*######################################################################## 

*######################################################################## 
DEFINE CLASS MenuItems AS Custom 
   
   cPopup = "_MWINDOW" 
   DIMENSION aItems[ 2, 1 ]
   nCount = 0 

   DIMENSION aFiles[ 1 ] 
   
   FUNCTION Init 
   
   FUNCTION Parse 
     
     IF EMPTY( This.cPopup ) OR EMPTY( GETPAD( This.cPopup, 1 )  )
        RETURN .F. 
     ENDIF 
     This.nCount = CNTBAR( This.cPopup )
     IF This.nCount = 0 
        DIMENSION This.aItems[ 2, 1 ]
        RETURN .F.
     ENDIF 
     DIMENSION This.aItems[ This.nCount, 3 ] 
     LOCAL lnI 
     
     FOR lnI = 1 TO CNTBAR( This.cPopup ) 
         This.aItems[ lnI, 2 ] ;
             = GETBAR( This.cPopup, lnI )
         This.aItems[ lnI, 1 ] ;
             = PRMBAR( This.cPopup, GETBAR( This.cPopup, lnI ) )
     ENDFOR 
     RETURN .T. 
  
ENDDEFINE 
*######################################################################## 



*######################################################################## 
DEFINE CLASS PrjVwFrame AS L_EmptyFrame OF LCtrLib.prg 
*######################################################################## 

    TabStyle = 1  
    ErasePage = .T.
    
    PageCount = 0 
    ActivePage = 0
    Width = 160
    Height = 79
    Visible = .T. 
    
    uRetVal = .T.
    calignment = "1100"
    
    nState = .F.  
    nSaveHeight = 0  
    
    ADD OBJECT Page1 AS PrjPage WITH ;
        Caption = "Prj" 

  #IF USE_FDATA
      ADD OBJECT Page2 AS DataPage WITH ;
          Caption = "Data" 
  #ENDIF
  
    *######################################################################## 
    FUNCTION Init 
       This.uRetVal = L_EmptyFrame::Init() 
       ASSERT TYPE( "This.Page1.tree1.Name" ) = 'C'
       RETURN This.uRetVal 

    *######################################################################## 
    FUNCTION Page1.RightClick 
    
      WITH This.Parent
       
       .nState = ! .nState 

       IF .nState         && Is minimize 
          IF  ThisForm.Height > 20  
             .nSaveHeight = ThisForm.Height 
          ENDIF    
          ThisForm.Height = 20  
       ELSE
          IF ThisForm.Height = 20  
             ThisForm.Height = .nSaveHeight 
          ENDIF    
       ENDIF 
       
     ENDWITH 

ENDDEFINE

*######################################################################## 
 FUNCTION MenuTests 

? PRMBAR( "_MSYSMENU", _MSM_FILE )
? CNTBAR( "_MSYSMENU"  )

? PRMBAR( "_MSYSMENU", _MSM_WINDO )

? getbar( "_MSYSMENU",9  )

? PRMBAR( "_MSYSMENU",getbar( "_MSYSMENU",9  ))

* WIndow  - _MWINDOW , -24569 


? PRMBAR( "_MWINDOW", getbar( "_MWINDOW", 1 ) )

* -22507 
*---------------------------------------------------- 
LOCAL lnI 
? CNTBAR( "_MWINDOW" ) 
FOR lnI = 1 TO CNTBAR( "_MWINDOW" ) 

   ?  lnI, GETBAR( "_MWINDOW", lnI )
   ?? " ", GETPAD( "_MWINDOW", lnI )   
   ?? " ", PRMBAR( "_MWINDOW", GETBAR( "_MWINDOW", lnI ) )

ENDFOR  

