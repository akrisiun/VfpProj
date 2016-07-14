* PrjVw.prg : Project View 
*$Id: prjvw.PRG,v 1.10 2007/07/24 11:54:19 andriusk Exp $
*$Log: prjvw.PRG,v $
*Revision 1.10  2007/07/24 11:54:19  andriusk
*Nodes_AddFile, .curItem properties
*
*Revision 1.9  2005/02/18 09:16:56  andriusk
*Hook [SYSPATH\] usage
*
*Revision 1.8  2004/11/03 13:08:54  andriusk
*fix
*
*Revision 1.7  2004/08/30 06:47:32  andriusk
*added PrjVcx
*
*Revision 1.6  2004/08/18 09:58:28  andriusk
*activate, parse (no normal cfg)
*
*Revision 1.5  2004/07/30 06:44:26  andriusk
*CFG object
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
 FUNCTION PrjVw 
*######################################################

#DEFINE THIS_PATH   FULLPATH(CURDIR())
#DEFINE VFPLIB_PATH D:\VfpLib\Sys
#DEFINE SYS_PATH    D:\VfpLib\Sys

  * DO SYS_PATH\PrjVw2
  DO PrjVwOrig

*######################################################
 FUNCTION PrjVwOrig
*######################################################


*#DEFINE L_FORM LBASE_FORM
#DEFINE LDEBUG .F. 

#DEFINE TREE_NODECLICK       1 
#DEFINE TREE_NODECHECK       2
#DEFINE TREE_NODEEDIT        5 
#DEFINE TREE_NODERUN         4
#DEFINE CR   CHR(13)+CHR(10) 
#DEFINE CRLF CHR(13)+CHR(10)   
 
LOCAL ln1
ln1 = 1 
IF TYPE( "goPrj[ 1 ]" ) = "U" 
   PUBLIC ARRAY goPrj[1]
ELSE 
   ln1 = ALEN( goPrj, 1 ) 
   IF TYPE( "goPrj[ ln1 ].Name" ) = 'C' 
      ln1 = ln1 + 1 
   ENDIF 
   DIMENSION goPrj[ ln1 ]
ENDIF 

goPrj[ ln1 ] = NEWOBJECT( "PrjView" ) 

_SCREEN.AddProperty( "oPrj", goPrj )  
WITH goPrj[ ln1 ]
   .Show()   
   IF ln1 > 1 
      .Top = .Top + 10       
      .Left = .Left - 30       
   ENDIF 
ENDWITH 

*######################################################################## 
DEFINE CLASS PrjViewDS AS PrjView 
    DataSession = 2
ENDDEFINE     

*######################################################################## 
DEFINE CLASS PrjView AS L_FORM OF PrjVw.Prg   

  #IF .F.
      LOCAL ThisForm AS PrjView OF PrjVw.Prg 
      LOCAL This AS PrjView OF PrjVw.Prg 
  #ENDIF 

    Top = 5
    Left = 300   
    Height = 250
    Width = 158
    CaptionPref = "prj:"

    Name = "PROGS"
    Visible = .F. 
    DIMENSION aNodeInfo[ 1, 10 ]

    cIniFilename = ("D:\VfpLib\sys\Prj.Ini") 
    isRestoreposition = .T.
    
    Prj_HomeDir = "" 
    DIMENSION Prj_Items[ 1, 1 ]
    DIMENSION Prj_ItemInfo[ 1, 5 ]
    
    #DEFINE NODEVALUES_SECTION  
    
    N_Item = ""
    N_Key  = ""
    N_Children = 0
    N_Text = "" 
    N_ParKey = "" 
    N_ParText = "" 
    N_Line = 0 
    
    N_File = "" 
    N_Ext  = "" 
    
    N_Cmd  = "" 
    N_Prj  = "" 
    N_Alias = "" 
        
    N_Info = ""     
    Cmd_Last = "" 
    
    ADD OBJECT oCfg AS CfgObject  WITH ;
         nLen = 0 ;
       , cAlias = "PrjCfg" , cPrj = 'DEFPRJ' 
    
    *######################################################################## 

    ADD OBJECT pgf1 AS l_pageframe WITH ;
         Top = 1 ;
       , Left = 0 ;
       , Width = 160 ;
       , Height = 250 ;
       , calignment = ("110000") ;
       , Name = "pgf1" ;

    *   , PageCount = 0 ;
    *   , Page1.FontName = "Tahoma" ;
       , Page1.FontSize = 7 ;
       , Page1.Caption = "Project" ;
       , Page1.Name = "Page1"


    ADD OBJECT chkfav AS checkbox WITH ;
        Top = 2 ;
       , Left = 68 ;
       , Height = 17 ;
       , Width = 31 ;
       , FontName = "Tahoma" ;
       , FontSize = 9 ;
       , Caption = "Fav." ;
       , Value = 2 ;
       , Style = 1 ;
       , ToolTipText = "Favorite mark" ;
       , Name = "chkFav"


    ADD OBJECT cmdedit AS commandbutton WITH ;
        Top = 1, Left = 101, Height = 19, Width = 27 ;
       , FontName = "Tahoma", FontSize = 9 ;
       , Caption = "\<Edit", ToolTipText = "Edit [Enter]" ;
       , Name = "cmdEdit"


    ADD OBJECT cmdrun AS commandbutton WITH ;
        Top = 1, Left = 128, Height = 19, Width = 27 ;
       , FontName = "Tahoma", FontSize = 9 ;
       , Caption = "\<Run", Name = "cmdRun"

    ADD OBJECT cmdVCX AS commandbutton WITH ;
        Top = 1, Left = 158, Height = 19, Width = 27 ;
       , FontName = "Tahoma", FontSize = 9 ;
       , Caption = "\<VCX", Name = "cmdVCX", Enabled = .F. 

    ADD OBJECT cmdSRC AS commandbutton WITH ;
        Top = 1, Left = 184, Height = 19, Width = 27 ;
       , FontName = "Tahoma", FontSize = 9 ;
       , Caption = "x\<SRC", Name = "cmdSRC", Enabled = .F. 


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
        
        L_FORM::Activate()

        IF ! EMPTY( This.Prj_HomeDir ) ; 
          AND ! FULLPATH( CURDIR() ) ;
                == FULLPATH( This.Prj_HomeDir ) ;
          AND MESSAGEBOX( "CD "+   This.Prj_HomeDir + " ?", 4 ) = 6
            CD FULLPATH( This.Prj_HomeDir )  
        ENDIF
    
    FUNCTION Init
        
        WITH This 
          .Caption = .CaptionPref 
          L_FORM::Init()

          * IF TYPE( "_VFP.Application.ActiveProject.Files.Count" ) # "N"
          *   WAIT WINDOW NOWAIT "Select project.." 
          *   MODIFY PROJECT ?  NOWAIT NOSHOW 
          * ENDIF  
         IF TYPE( "_VFP.Application.ActiveProject.name" ) = 'C'  
             This.oCfg.cPrj =  ;
                 UPPER( JUSTSTEM(_VFP.Application.ActiveProject.name) ) 
         ELSE          
             This.oCfg.cPrj = 'NEWPROJ'     
         ENDIF 
         This.oCfg.ReadCfg() 
         
         *---------------------------------------------- 
         .AddProperty( 'tree1', NULL )
         .tree1 = .pgf1.Pages( 1 ).tree1
         .pgf1.ActivePage = 1  
         
         .AddProperty( "aItems[1]" )
         .AddProperty( "ItemsCount", 0 ) 
         
         DIMENSION .aItems[1]
         
         .InitNode( "" ) 
         
        ENDWITH
    ENDFUNC 
    
    FUNCTION ReadPos 
       
         LOCAL lcPos 
         lcPos = This.oCfg.ReadValue( "POS", .Caption ) 
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

    FUNCTION Hide() 
       This.SavePos() 
    
    FUNCTION Show() 

       This.ReadPos() 
        
       This.Resize()   
       This.Visible = .T. 
       This.Tree1.SetFocus()
 
    PROCEDURE InitNode
        LPARAMETERS tcKey 

        LOCAL lcKeyPar, lcKey 
        lcKeyPar = tcKey
        lcKey = ""

        WITH This.Tree1
         
         IF ! EMPTY( tcKey )
             IF .Nodes( tcKey ).Children = 1  ;
                AND "EMPTY" $ .Nodes( tcKey ).Child.Key 
                lcKey = .Nodes( tcKey ).Child.Key 
                .Nodes.Remove( lcKey )
                lcKey = ""
             ENDIF   
             IF .Nodes( tcKey ).Children > 0 AND .Nodes( tcKey ).Index > 1 
                RETURN .F.
             ENDIF 
         ENDIF      
         
         LOCAL lcName, lnCnt, lnI  
                     
         DO CASE
          CASE EMPTY( tcKey )
            
               lcKey = "PRJ"
               This.Prj_HomeDir = ""  
               IF TYPE( "_VFP.Application.ActiveProject.Files.Count" ) = "N"
                  lcName = _VFP.Application.ActiveProject.Name
                  This.Prj_HomeDir = ADDBS( ;
                           _VFP.Application.ActiveProject.HomeDir )
               ELSE
                  lcKey = "PRJNO"
                  lcName = "No project" 
                  IF .Nodes.Count > 0
                     RETURN .F.
                  ENDIF
               ENDIF  
               
               This.N_Prj = JUSTSTEM( lcName ) 
               ThisForm.Caption = ThisForm.CaptionPref + This.N_Prj 
               
               .Nodes.Clear()          
               .Nodes.Add( , 4, lcKey, lcName )
               .Nodes( lcKey ).Expanded = .T.
               
               This.InitNode( lcKey ) 
               
               lcKey = "WND"
               .Nodes.Add( , 4, lcKey, "Windows" ) 
               .Nodes( lcKey ).Expanded = .T.
               This.InitNode( lcKey ) 

          CASE LEFT( tcKey , 3 ) = "WND"
               This.FillWindow() 
              
          CASE LEFT( tcKey , 3 ) = "PRJ"
               This.FillProj() 

          CASE LEFT( tcKey , 3 ) = "FIL" 
                
                IF ! This.NodeFile( tcKey ) 
                   RETURN .F.
                ENDIF  
                DO CASE
                   CASE This.N_Ext = "PRG"
                      
                      IF This.N_Children = 0   
                          LOCAL ARRAY laPCodes[1]

                           lnCnt = APROCINFO( laPCodes, This.N_File ) 
                           lnNodeCnt = .Nodes.Count
                           FOR lnI = 1 TO lnCnt
                                 lcKey  = This.N_Key + "PRC"+ TRANSF( lnI ) ;
                                             + "_L"+ TRANSFORM( laPCodes[ lnI, 2 ]  ) 
                                              
                                 lcText = laPCodes[ lnI, 1 ] 
                                 .Nodes.Add( lcKeyPar, 4, lcKey, lcText )
                                 IF lnNodeCnt = .Nodes.Count
                                    EXIT 
                                 ENDIF
                          ENDFOR                                              
                      ENDIF 
                      
                   CASE INLIST( This.N_Ext, "VCX", "SCX" )  

                      IF This.N_Children = 0   
                            LOCAL ARRAY laCls[1]
                            LOCAL lcLib 
                            lcLib = This.N_File
                            
                            lnCnt = AVCXCLASSES( laCls, lcLib )                
                            ASORT( laCls ) 
                            lnNodeCnt = .Nodes.Count
                            FOR lnI = 1 TO lnCnt
                                 lcKey  = This.N_Key + "CLS"+ TRANSF( lnI )
                                 lcText = laCls[ lnI, 1 ] 
                                 .Nodes.Add( lcKeyPar, 4, lcKey, lcText )
                                 IF lnNodeCnt = .Nodes.Count
                                    EXIT 
                                 ENDIF
                           ENDFOR                                              
                     ENDIF 
                     
                ENDCASE
            
          ENDCASE

        ENDWITH 

      *######################################################################## 
      FUNCTION FillWindow( tcKey ) 
        
       
       WITH This.oMenu
          .cPopup = "_MWINDOW"
          ACTIVATE POPUP _MWINDOW NOWAIT       
          .Parse() 

          IF EMPTY( tcKey )       
             tcKey = "WND"  
          ENDIF 
          LOCAL lcParKey 
          lcParKey = tcKey 
           
          LOCAL lnCnt , lnI, lcFile  
          LOCAL ARRAY aFiles[ 1, 3 ] 
          
          lnCnt = 0 
          FOR lnI = 1 TO .nCount   
             lcFile = .aItems[ lnI, 1 ] 
             * ASSERT .aItems[ lnI, 2 ] # -22508 
             
             lcFile = ALLTRIM( lcFile ) 
             IF ATC( " - ", lcFile ) # 0 
                LOOP
             ENDIF 
             IF ATC( " ", lcFile ) <= 3 
                lcFile = SUBSTR( lcFile, ATC( " ", lcFile ) + 1 ) 
             ENDIF 
             IF ! FILE( lcFile ) 
                LOOP
             ENDIF 
             
             lnCnt = lnCnt + 1  
             DIMENSION aFiles[ lnCnt, 3 ] 
             aFiles[ lnCnt, 1 ] = lcFile 
             aFiles[ lnCnt, 2 ] = FULLPATH( lcFile ) 
             aFiles[ lnCnt, 3 ] = JUSTEXT( lcFile )  
             
          ENDFOR
       ENDWITH 
       
       * Last_WOnTop 
       ASSERT ! LDEBUG MESSAGE "Windows "+ TRANSFORM( lnCnt ) 
       
       WITH This.tree1 
        
        LOCAL lnItem 
        lnItem = 0 
        FOR lnI = 1 TO lnCnt         
           lnItem = lnItem + 1 
           lcKey  = "FILW"+ TRANSFORM( lnItem ) 
           lcText = aFiles[ lnI, 1 ] 
           
           IF TYPE( ".Nodes( lcKey ).Key" ) = 'C' 
              .Nodes.Remove( lcKey )  
              IF TYPE( ".Nodes( lcKey ).Key" ) = 'C' 
                 lnItem = lnItem + 1 
                 lnI = lnI - 1 
                 LOOP   
              ENDIF 
           ENDIF 
           .Nodes.Add( lcParKey, 4, lcKey, lcText )
           
        ENDFOR
        .Nodes( tcKey ).Expanded = .T. 
        
       ENDWITH 
       RETURN .T.      
    
               
      *######################################################################## 
      FUNCTION FillProj( tcKey ) 
                
       IF TYPE( "_VFP.Application.ActiveProject.Files.Count" ) # "N"
          RETURN .F.
       ENDIF
       
      WITH This.Tree1 
       
       LOCAL lnCnt, lcParKey  
       
       IF EMPTY( tcKey )       
         tcKey = "PRJ" 
       ENDIF  

       This.Prj_HomeDir = ADDBS( _VFP.Application.ActiveProject.HomeDir ) 
       lnCnt = _VFP.Application.ActiveProject.Files.Count
       lcParKey = tcKey 
       
       IF LDEBUG 
           CREATE CURSOR ProjFiles ( File C(200), Index I, Type C(1) ;
                   , Comment C(150), KeyFile C(20), Text C(50),  Key C(20) )  
       ENDIF 
                                                    
       LOCAL ARRAY aFil[ lnCnt, 5 ]
       LOCAL loFile AS Files 
       LOCAL lcText, lcKeyFile 
       LOCAL lnII, lnI 
       lnI = 0  
       FOR lnII = 1 TO lnCnt 
            IF TYPE( "_VFP.Application.ActiveProject.Files[ lnII ].Name" ) # 'C'
               LOOP
            ENDIF
            loFile = _VFP.Application.ActiveProject.Files[ lnII ]
            lcText = loFile.Name 
            
            IF ATC( JUSTEXT( lcText ), "BMP ICO FLL" ) # 0
               LOOP
            ENDIF  
            lnI = lnI + 1  
            lcKeyFile = UPPER(JUSTFNAME( lcText ))  
            
            aFil[ lnI, 1 ] = lcText          && .File 
            aFil[ lnI, 2 ] = lnI             && .Index
            aFil[ lnI, 3 ] = lcKeyFile 

            IF USED( "ProjFiles" ) 
               INSERT INTO ProjFiles ( File, Index, Type, Comment ) ;
                   VALUES( lcText, lnI, loFile.Type ;
                         , loFile.Description  ) 
            ENDIF 

       ENDFOR             
        
       lnCnt = lnI  
       IF lnI > 0 
           LOCAL ARRAY aFil[ lnI, 5 ]
           ASORT( aFil )
       ENDIF        
       * IF lnCnt > 20 
       
       LOCAL lcExt , lnItems, lcKey
               
       lnItems = MAX( 1, lnCnt )                 
       DIMENSION This.Prj_Items[ lnItems, 1 ]
       DIMENSION This.Prj_ItemInfo[ lnItems, 5 ]
       
       lnItems = 0                                        && ..... 
       FOR lnI = 1 TO lnCnt 
             
            IF TYPE( "aFil[ lnI, 2 ]" ) # "N"
               LOOP 
            ENDIF 
            lnItems = lnItems + 1    
            lcKey  = "FIL"+ TRANSF( aFil[ lnI, 2 ] )      && Index 
            lcText = aFil[ lnI, 1 ]
            lcText = STRTRAN( lcText, This.Prj_HomeDir, "" ) 
            
            lcExt = JUSTEXT( UPPER(lcText)  ) 
            IF ! INLIST( lcExt, "PRG", "SCX", "VCX" )
               LOOP
            ENDIF  
            
            IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
               .Nodes.Remove( lcKey )
               IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
                  ASSERT (.F.) MESSAGE "Not removed node "+ TRANSFORM( lcKey ) 
                  LOOP 
               ENDIF 
            ENDIF   
            .Nodes.Add( lcParKey, 4, lcKey, lcText )
            IF INLIST( lcExt, "VCX", "PRG" )
               IF TYPE( [.Nodes( lcKey+"EMPTY" ).Key] ) = 'C' 
                   .Nodes.Remove( lcKey+"EMPTY" )
               ENDIF     
               .Nodes.Add( lcKey, 4, lcKey+"EMPTY", "..." )
            ENDIF  
            *----------------------------------------------  
       ENDFOR 
  
       lnItems = MAX( 1, lnCnt )                 
       DIMENSION This.Prj_Items[ lnItems, 1 ]
       DIMENSION This.Prj_ItemInfo[ lnItems, 5 ]
     
    ENDWITH 

    *######################################################################## 
    PROCEDURE NodeFile 
        LPARAMETERS tcKey

        IF ! This.NodeInfo( tcKey ) 
           RETURN .F. 
        ENDIF 
        IF INLIST( This.N_Key, "WND", "DIR", "PRJ0" ) 
           RETURN .F.
        ENDIF  
        IF ATC( This.N_Key, "PRJ PRJ0 PRJ1" ) = 0 
           ASSERT ! EMPTY( This.N_PARKEY )  
        ENDIF 
             
        tcKey = This.N_Key 
        IF "CLS" $ This.N_Key  OR "PRC" $ This.N_Key 
           This.N_Item = This.N_Text 
           This.N_Text = This.Tree1.Nodes( tcKey ).Parent.Text 
        ENDIF
        This.N_Line = 0 
        IF ATC( "_L", This.N_Key ) # 0         && Line gavimas 
        
           LOCAL lcInt 
           lcInt = ALLTRIM( SUBSTR( This.N_Key ;    
                          , ATC( "_L", This.N_Key ) + 2   ) ) 
           IF ! EMPTY( lcInt )
              This.N_Line = VAL( lcInt ) 
           ENDIF  
        ENDIF
        
        This.N_File = This.N_Text 
        This.N_Ext = ""  
        STORE .F. To This.cmdVcx.Enabled, This.cmdSrc.Enabled  
        
        IF ! FILE( This.N_File ) 
           MessageBox( "Not found file " + This.N_File )
           This.N_File = "" 
           RETURN .F.
        ENDIF
        *----------------------------------------------- 
        This.N_Ext  = UPPER( JUSTEXT( This.N_File ) )
 
        STORE INLIST( THis.N_Ext, "VCX", "SCX", "PJX" ) ; 
           TO This.cmdVcx.Enabled, This.cmdSrc.Enabled 

        RETURN .T.                 

    *######################################################################## 
    PROCEDURE NodeInfo( tcKey ) 
          
          IF TYPE( [tcKey] ) # "C" ;
             AND TYPE( [This.Tree1.SelectedItem.Key] ) = 'C' 
             tcKey = This.Tree1.SelectedItem.Key 
          ENDIF
          This.N_Key  = tcKey 
          IF EMPTY( This.N_Key ) ;
             OR TYPE( [This.Tree1.Nodes( tcKey ).Key] ) # "C" ;
             OR This.Tree1.Nodes( tcKey ).Key # tcKey 
             This.N_Key = ""
             RETURN .F.
          ENDIF  
            
          This.N_Item = This.Tree1.Nodes( tcKey ).Key
          This.N_Children = This.Tree1.Nodes( tcKey ).Children
          This.N_Text = This.Tree1.Nodes( tcKey ).Text 

          IF ISNULL( This.Tree1.Nodes( tcKey ).Parent )  
             This.N_ParKey = ""
             This.n_ParText = ""
          ELSE    
             This.N_ParKey  = This.Tree1.Nodes( tcKey ).Parent.Key  
             This.N_ParText = This.Tree1.Nodes( tcKey ).Parent.Text 
          ENDIF            
          This.N_File = "" 
          RETURN .T.
    
   *######################################################################## 
    FUNCTION NodeCmd( tcAddi ) 
    
        IF EMPTY( This.N_Cmd )  
           RETURN .F.
        ENDIF 
        
        ACTIVATE SCREEN 
        
        LOCAL lcMacro 
        lcMacro = This.N_Cmd
        This.Cmd_Last = lcMacro 
        
        &lcMacro  
    
    *######################################################################## 
    FUNCTION ValidSrc() 
    
       RETURN INLIST( RIGHT( DBF(), 4 ) ;
               , ".SCX", ".VCX", ".PJX", ".FRX", ".LBX" )  
    
    *######################################################################## 
    FUNCTION UseSrc( tcAddi ) 
      
      IF ! FILE( This.N_File ) 
         RETURN .F.
      ENDIF 
      
        LOCAL lcOld
        lcOld = ALIAS() 

        This.N_Alias = JUSTSTEM( This.N_File ) 
        IF EMPTY( This.N_ALIAS )
           RETURN .F.
        ENDIF 
        IF USED( This.N_Alias  )  
           SELECT (This.N_Alias)
        ENDIF   
        
        IF NOT USED( This.N_Alias ) 
        
           SELECT 0

           LOCAL lcOldErr, lErr
           lcOldErr = ON("ERROR")
           ON ERROR lErr = .T.
           
           USE (This.N_File)  AGAIN  ALIAS (This.N_Alias) 

           ON ERROR &lcOldErr 
           
           IF ! EMPTY( ALIAS() ) 
              This.N_ALIAS = ALIAS() 
           ELSE 
              ERROR "Not used "+ This.N_File + " ALIAS "+ This.N_Alias   
           ENDIF
        ENDIF
      RETURN This.ValidSrc()  

    *######################################################################## 
    FUNCTION Info( lNoShow ) 

        This.NodeFile( This.N_Key )    
        This.N_Info =  This.N_Key ;
                + CR + This.N_Text ;
                + CR + ;
                + CR + "File: " + FULLPATH( This.N_File ) ;
                + CR + "Item: " + This.N_Item ;
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
    PROCEDURE TreeClick
        LPARAMETERS tnEvent, tcKey

        IF EMPTY( tcKey )
           RETURN .F.
        ENDIF
        WITH This.Tree1
          This.NodeInfo( tcKey )  
          ThisForm.chkFav.Value = IIF( .Nodes( tcKey ).Bold, 1, 0 ) 
          
          DEBUGOUT "EVE "+ TRANSFORM( tnEvent ) + " node:" + tcKey       
                 
          DO CASE
           CASE tnEvent = TREE_NODECLICK      && Click Event
            
            IF "FIL" $ tcKey ;
               AND  .Nodes( tcKey ).Children <= 1 ; 
               AND (    ATC( ".VCX", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                     OR ATC( ".PRG", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                   ) ;
               OR ! "FIL" $ tcKey 
                 
                 This.InitNode( tcKey ) 
            ENDIF 
            This.NodeFile( tcKey )

           CASE tnEvent = TREE_NODECHECK   
              
             This.TreeClick( TREE_NODEEDIT, tcKey )    
                            
           CASE tnEvent = TREE_NODEEDIT  && Edit event 

            DO CASE
               CASE tcKey = "WND"
                    RETURN This.FillWindow() 
               CASE tcKey = "PRJ"
                    IF FILE( "D:\vfplib\sys\prjTool.prg" )
                       DO OptionsForm IN ("D:\vfplib\sys\prjTool.prg")
                    ENDIF
            ENDCASE            
            IF ! This.NodeFile( tcKey ) 
                 RETURN .F. 
            ENDIF         
            This.N_Cmd = "" 
            DO CASE
               CASE "CLS" $ tcKey 
                  This.N_Cmd = "MODI CLASS "+ This.N_Item ;
                             + " OF "+ This.N_File ; 
                             + " NOWAIT SAVE"

               CASE "PRC" $ tcKey 
                  This.N_Cmd = "EDITSOURCE( [" ;
                                  + This.N_File + "], " ;
                                  + TRANSFORM( This.N_Line ) ;
                                  + " , ["+ This.N_Item +"] )"  

               CASE This.N_Ext = "PRG"
                  This.N_Cmd = "MODI COMM "+ This.N_File + " NOWAIT SAVE"

               CASE This.N_Ext = "SCX"              
                  This.N_Cmd = "MODI FORM "+ This.N_File + " NOWAIT SAVE"
                 
            ENDCASE
            This.NodeCmd() 

           CASE tnEvent = TREE_NODERUN ;
                AND LEFT( tcKey , 3 ) = "FIL" 
              
            IF ! This.NodeFile( tcKey ) 
                 RETURN .F. 
            ENDIF         
            This.N_Cmd = ""
            DO CASE
               CASE "CLS" $ tcKey 
                  This.N_Cmd = "MODI CLASS "+ This.N_Item + " OF "+ This.N_File

               CASE "PRC" $ tcKey 
                  This.N_Cmd = "DO "+ This.N_Item + " IN " + This.N_File 
                  

               CASE This.N_Ext = "PRG"
                  This.N_Cmd = "DO "+ This.N_File 

               CASE This.N_Ext = "SCX"              
                  This.N_Cmd = "DO FORM "+ This.N_File 
                 
            ENDCASE
            This.NodeCmd() 
             
          ENDCASE
        ENDWITH

    *######################################################################## 
    PROCEDURE RightMenu 
        LPARAMETERS tnMode, tnValue

        tnMode  = IIF( VARTYPE( tnMode ) = 'N',  tnMode, 0 )
        tnValue = IIF( VARTYPE( tnValue ) = 'N', tnValue, 0 )
        WITH This 
         DO CASE 
           CASE tnMode = 0
            
            DEFINE POPUP P_Shortcut SHORTCUT RELATIVE FROM MROW(), MCOL() ;
                         FONT "Tahoma", 9 

            DEFINE BAR 4 OF P_Shortcut PROMPT "Edit" ;
                 FONT "Tahoma", 9 
            DEFINE BAR 5 OF P_Shortcut PROMPT "Run/Exec" ;
                 FONT "Tahoma", 9 
            
            DEFINE BAR 55 OF P_Shortcut AFTER 5 PROMPT "PrjVcx Requery" ;
                 FONT "Tahoma", 9 ;
                 SKIP FOR ! FILE( "D:\vfplib\sys\PcboHook.prg" ) 
                  
            ON SELECTION BAR 55 OF  P_Shortcut  ;
                     DO PrjVcxRequery 
                     
 
            DEFINE BAR 6 OF P_Shortcut PROMPT '\-'

            DEFINE BAR 1 OF P_Shortcut PROMPT 'Refresh' ;
                         FONT "Tahoma", 9 


            ON SELECTION BAR 1 OF P_Shortcut  .RightMenu( 1, 1 )

            ON SELECTION BAR 4 OF P_Shortcut  .RightMenu( 1, TREE_NODEEDIT )
            ON SELECTION BAR 5 OF P_Shortcut  .RightMenu( 1, TREE_NODERUN )

          *------------
            DEFINE BAR 10 OF P_Shortcut PROMPT 'Info'

            DEFINE BAR 11 OF P_Shortcut PROMPT 'InfoList'
            
            
            ON SELECTION BAR 10 OF P_Shortcut  .Info() 
            ON SELECTION BAR 11 OF P_Shortcut  .InfoList() 
            
            ACTIVATE POPUP  P_Shortcut 
            RELEASE  POPUPS P_Shortcut 
            
          CASE tnMode = 1 
          
            lcKey = ""
            IF TYPE( ".Tree1.SelectedItem.Key" ) = 'C'
               lcKey = .Tree1.SelectedItem.Key
            ENDIF 
               
            DO CASE
               CASE tnValue = 1                && Refresh
                    .InitNode( "" ) 
               
               CASE tnValue = TREE_NODEEDIT    && Edit
                    .TreeClick( TREE_NODEEDIT, lcKey ) 

               CASE tnValue = TREE_NODERUN     && Run 
                    .TreeClick( TREE_NODERUN, lcKey ) 
          
            ENDCASE
          
        ENDCASE 
        ENDWITH 

    *######################################################################## 
    FUNCTION pgf1.Init 
       WITH This.Page1
           .AddObject( "tree1", "PrjTree" ) 
           .tree1.Visible = .T.
       ENDWITH  
    ENDFUNC 
           
    *######################################################################## 
    PROCEDURE chkfav.Valid
        LOCAL lSelect, lcKey

        lSelect = ( ThisForm.chkFav.Value = 1 )
        IF TYPE( "ThisForm.Tree1.SelectedItem.Key" ) = 'C' 
          lcKey = ThisForm.Tree1.SelectedItem.Key
          ThisForm.Tree1.Nodes( lcKey ).Bold = lSelect    
        ENDIF

        RETURN .T.

    *######################################################################## 
    PROCEDURE cmdedit.Click

        IF ! TYPE( "ThisForm.tree1.SelectedItem.Key" ) = "C"
           RETURN .F. 
        ENDIF 
        ThisForm.RightMenu( 1,  TREE_NODEEDIT ) 

    *######################################################################## 
    PROCEDURE cmdRun.Click

        IF ! TYPE( "ThisForm.tree1.SelectedItem.Key" ) = "C"
           RETURN .F.
        ENDIF 
        ThisForm.RightMenu( 1, TREE_NODERUN ) 

    *######################################################################## 
    PROCEDURE cmdVCX.Click

        IF ! ThisForm.NodeFile() ;
           OR ! ThisForm.UseSrc() 
           
           RETURN .T.
        ENDIF 
        IF ! FILE( [SYS_PATH\BrowF2.prg] ) 
           This.Enabled = .F.
           RETURN .F. 
        ENDIF 
        DO ( [SYS_PATH\BrowF2] ) WITH ThisForm.N_File 

    *######################################################################## 
    PROCEDURE cmdSRC.Click
    
        LOCAL lMulti
        
        lMulti = .F.                 && Multi files ... 
        * ASSERT .F. 
        IF ! ThisForm.NodeFile() ;
           OR ! ThisForm.UseSrc() 
           
           IF ThisForm.N_Index = 1
              lMulti = .T.
           ELSE   
              RETURN .F.
           ENDIF    
        ENDIF 
        IF ! FILE( [SYS_PATH\ViewVcx.prg] ) 
           This.Enabled = .F.
           RETURN .F. 
        ENDIF 
        
        DO ([SYS_PATH\ViewVcx]) WITH ThisForm.N_File 

    *######################################################################## 
    PROCEDURE cmdSRC.RightClick
        IF ! ThisForm.NodeFile()  
           RETURN .F.
        ENDIF 
        LOCAL lcFileSrc 
        lcFileSrc = ThisForm.N_File + ".prg" 
        IF ! FILE( lcFileSrc ) 
           RETURN .F.
        ENDIF 
        MODI COMM (lcFileSrc) SAVE NOWAIT 

ENDDEFINE
*
*-- EndDefine: progs
**************************************************

*     Name = "l_form"


DEFINE CLASS CfgObject AS Custom 

  CfgFile = ""
  lUsedCfg = .F. 
  cAlias = "PrjCfg" 
  cPrj = 'NEWPROJ' 
  lAuto = .F.
  lChanges = .F.
  
  DIMENSION aCfg[ 1, 5 ]
  nLen = 0 
  
  FUNCTION Init 
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
    
    FOR lnI = 1 TO This.nLen 
      IF This.aCfg[ lnI, 1 ] = cParKey ;
         AND This.aCfg[ lnI, 2 ] = cKey 
           
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

    lFound = .F. 
    * ASSERT SET( "EXACT" ) = 'OFF' 
    
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
  
    IF This.OpenCfg() 
       SELECT PrjCfg 
       BROWSE IN SCREEN NOWAIT SAVE  
    ENDIF 
    
  FUNCTION OpenCfg()    
    This.lUsedCfg  = USED( "PrjCfg" )     
    IF ! This.lUsedCfg 
       IF ! FILE( HOME(1)+"prjcfg.dbf" )
          RETURN .F.
       ENDIF 
       USE (HOME(1)+"prjcfg.dbf") ALIAS PrjCfg IN 0 
    ENDIF 
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
    
    LOCAL ARRAY laCfg[ RECCOUNT( "PrjCfg" ), 5 ] 
    
    SELECT Parkey, Key ;
         , ( Value ), ( Mvalue ), ( ChTime ) ;
     FROM PrjCfg ORDER BY 1, 2 ;
     INTO ARRAY laCfg  
    
    * WHERE Prj = This.cPrj * 
    
    IF _TALLY > 0 
      ASSERT _TALLY == ALEN( laCfg, 1 )  
      
      This.nLen = ALEN( laCfg, 1 ) 
      DIMENSION This.aCfg[ This.nLen, 5 ] 
      =ACOPY( laCfg, This.aCfg )

      This.nLen = ALEN( This.aCfg, 1 ) 
      ASSERT This.nLen == ALEN( laCfg, 1 )  
    ENDIF 
    
    *ACTIVATE SCREEN 
    *DISPLAY MEMORY LIKE This.aCfg 
        
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
    
    USE IN cNewCfg 
    This.CloseCfg()      
  

ENDDEFINE 

*######################################################################## 
DEFINE CLASS L_FORM AS form

    Top = -1
    Left = 0
    Height = 118
    Width = 375
    DoCreate = .T.
    ShowTips = .T.
    Caption = "L_Form"
    FontName = "Tahoma"
    
    KeyPreview = .T.
    *-- BuvAs pried Resize() avyka formos aukdtis
    noldheight = ""
    *-- BuvAs pried Resize() avyka formos plotis
    noldwidth = ""
    cinifilename = ("App.Ini")
    isrestoreposition = .T.
    isignoreerrors = .F.
    Last_WOnTop = ""

    *-- Modalinës formos gra_inama reikdmë
    uretval = .T.
    MinButton = .F. 
    MaxHeight = 1200 
    MaxWidth = 500


    *######################################################################## 
    PROCEDURE restorewindowpos
        LPARAMETERS tcEntry

        LOCAL  lcBuffer, lcOldError,  llError, llError2
        LOCAL  lnTop, lnLeft, lnWidth, lnHeight 
        LOCAL  lnCommaPos,lnCommaPos2,lnCommaPos3 
        LOCAL  lcEntry, lnScrWidth,  lnScrHeight 

        IF NOT This.IsRestorePosition  OR EMPTY( This.cIniFileName )
           RETURN .F.
        ENDIF

        * lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
        lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Name, tcEntry )
        
        *lcBuffer = SPACE(20) + CHR(0)
        lcBuffer   = CHR(0)
        lcBuffer   = This.RestoreProp( "WindowPositions", lcEntry )
        lcOldError = ON('ERROR')

        *-- Read the window position from the INI file
        IF ! EMPTY( lcBuffer ) 
           *-- If an error occurs while parsing the string, 
           *-- just ignore the string and use the form's 
           *-- defaults
           ON ERROR llError = .T.
           lnCommaPos = AT(",", lcBuffer)
           lnCommaPos2 = IIF( AT(",", lcBuffer, 2) # 0, AT(",", lcBuffer, 2), LEN(lcBuffer) )
           lnTop  = VAL(LEFT(lcBuffer, lnCommaPos - 1))
           lnLeft = VAL(SUBSTR(lcBuffer, lnCommaPos + 1,lnCommaPos2-lnCommaPos ))
           
           llError2 = llError
           IF NOT llError2 AND This.BorderStyle = 3                    && jeigu sizeable border
              lnCommaPos3 = AT(",", lcBuffer, 3)
              lnHeight = VAL(SUBSTR(lcBuffer, lnCommaPos2 + 1,lnCommaPos3-lnCommaPos2 ))
              lnWidth =  VAL(SUBSTR(lcBuffer, lnCommaPos3 + 1))
           ENDIF   
           IF NOT llError2
              lnScrWidth  = SYSMETRIC(1)
              lnScrHeight = SYSMETRIC(2)- 48
              IF ( lnScrWidth > MAX( 600, lnWidth ) )   ;
                  AND ( lnLeft + lnWidth  > lnScrWidth )
                  lnLeft = lnScrWidth - lnWidth
              ENDIF
              IF ( lnScrHeight > MAX( 350, lnHeight ) )   ;
                AND ( lnTop + lnHeight > lnScrHeight )
                  lnTop = lnScrHeight - lnHeight 
              ENDIF
              This.Top = lnTop
              This.Left = lnLeft
           ENDIF   
           IF TYPE( "lnWidth" ) = "N" AND lnWidth > 0   ;
                AND TYPE( "lnHeight" ) = "N" AND lnHeight > 0

                 This.Width  = lnWidth
                 This.Height = lnHeight
                 This.Resize()
           ENDIF  
           
           lnWidth = This.Width  
           lnHeight = This.Height 
           ON ERROR &lcOldError
        ENDIF

    *######################################################################## 
    PROCEDURE refreshform
        WITH This
          .LockScreen = .T.
          .Refresh()
          .LockScreen = .F.
        ENDWITH

    *######################################################################## 
    PROCEDURE savewindowpos
        LPARAMETERS tcEntry

        LOCAL lcValue, lcEntry

        IF EMPTY( This.cIniFileName ) 
           RETURN .F.
        ENDIF

        * lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Caption, tcEntry )
        lcEntry = IIF( TYPE( "tcEntry" ) # "C", This.Name, tcEntry )
        lcValue = ALLT(STR(MAX(This.Top, 0))) + ',' ;
                + ALLT(STR(MAX(This.Left, 0))) 
        IF This.BorderStyle = 3          
           lcValue = lcValue + ','  ;
                + ALLT(STR(MAX(This.Height, 0))) + ','  ;
                + ALLT(STR(MAX(This.Width, 0)))
        ENDIF

        This.SaveProp("WindowPositions", lcEntry, lcValue )

    *######################################################################## 
    PROCEDURE onError
        LPARAMETERS nError, cMsg, cMethod, nLine

        oObject = This

        LOCAL llHandledError, lcMessage, cMessage, lnAnswer
        LOCAL laError[ 7 ]    && 7= AERRORARRAY
                      
        LOCAL nI, cPrg
            
            lcMessage = MESSAGE()
            
            =AERROR(laError)

            IF TYPE( "oObject.IsIgnoreErrors" ) = "L" AND oObject.IsIgnoreErrors
               RETURN .T.
            ENDIF

            *-- Loads the laError array with error information ------------------
            ?? CHR(7)
            lcMessage = "Klaida " + IIF( TYPE( "nError" ) = "N",;
                                      ALLT( STR( nError )), '' ) + " : "  + lcMessage
            DO CASE
               CASE nError = 108   && File is used by another user
                 lsMessage = " Duomenys apdorojami kitoje darbo vietoje..."+;
                         CHR(13)+ "("+ lcMessage + ")"
               CASE nError = 39    && Numeric overlow. Data was lost
                 lsMessage = " Numerio reikðmës perpildymas. Duomenys praràsti "+;
                        CHR(13)+"(" + lcMessage + ")"                  
            ENDCASE
            
            lcMessage = lcMessage + CHR(13)  ;
                + " objektas "+IIF( TYPE("oObject.Name")="C", oObject.Name + CHR(13), "'', " )
                    
            IF  TYPE( "cMethod" ) = "C" AND NOT EMPTY( cMethod )
                lcMessage = lcMessage +;        
                        " metodas " + cMethod + IIF( LEN( cMethod ) > 30, CHR(13), "" ) +;
                         IIF( EMPTY( nLine ), "",  " eilute " + ALLT(STR(nLine)) + CHR( 13 ) )
            ENDIF

            IF  RIGHT( SYS( 16, 0 ), 4 ) # ".EXE"           && ne exe'as

                nI = 1
                DO WHILE NOT EMPTY( PROGRAM( nI ) ) 
                   nI = nI + 1
                ENDDO
                nI = nI - 1
                DO WHILE nI > 0 AND INLIST( RIGHT( PROGRAM(nI), 6 ), "TERROR", ".ERROR" )
                   nI = nI - 1
                ENDDO

                cPrg = PROGRAM( nI )
                lcMessage = lcMessage + " funkcija "+;
                             IIF( EMPTY( cPrg ), "-", cPrg +;
                              IIF( LEN( cPrg ) > 15, CHR(13), '' ) )
                cPrg = PROGRAM( nI - 1 )                     
                IF NOT EMPTY( cPrg )
                    lcMessage = lcMessage + "  ( " + cPrg  +;
                                        IIF( LEN( cPrg ) > 15, CHR(13), '' )
                    cPrg = PROGRAM( nI - 2 )                     
                    IF NOT EMPTY( cPrg )
                       lcMessage = lcMessage + "  \ " + cPrg   ;
                                 + IIF( LEN( cPrg ) > 15, CHR(13), '' )
                    ENDIF
                    lcMessage = lcMessage + " ) "
                 ENDIF
               IF nError # 39   ;
                AND nError # 108  
                                 && 108-File is used by another ...
                                 && 39- Numeric overlow. Data was lost
                
                  IF INLIST( UPPER( SUBSTR( cMethod, RAT( ".", cMethod )+1 ) ),;
                             "ACTIVATE", "REFRESH" )
                             
                    RETURN .T.      && jeigu "ACTIVATE" arba "REFRESH" dingstam
                 ELSE
                   * cMacro = "msg( lcMessage )"
                   * &cMacro
                 ENDIF
                ENDIF
             ENDIF             
            
            IF TYPE( "goApp.IsDebugMsg" ) = "L"   ;
                AND goApp.IsDebugMsg                 && jei yra debugerio msg
                 goApp.DebugMsg( lcMessage )
            ENDIF
            
            lnAnswer = MessageBox( lcMessage ;
                               , 16 + 2 + 512 ;
                               , " Klaida "+ALLTRIM( STR( nError ) ) )
                              && MB_ICONSTOP + MB_ABORTRETRYIGNORE+ MB_DEFBUTTON3
            DO CASE
               CASE lnAnswer = 3        &&   IDABORT
                    SUSPEND
               CASE lnAnswer = 4        &&   IDRETRY
                    RETRY
               OTHERWISE
                    RETURN
            ENDCASE
            RETURN llHandledError

    *######################################################################## 
    PROCEDURE saveprop
        LPARAMETERS tcParKey, tcKey, tcValue

        *-- Write the entry to the INI file
        DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
          String cSection, String cKey, String cValue, String cINIFile

        =WritePrivStr( tcParKey, tcKey, tcValue, This.cIniFileName )

    *######################################################################## 
    PROCEDURE restoreprop
        LPARAMETERS lcParKey, lcKey

        DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
             String cSection, String cKey, String cDefault, String @cBuffer ;
           , Integer nBufferSize, String cINIFile

        DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
          String cSection, String cKey, String cValue, String cINIFile

        LOCAL lcBuffer, lnLen

        lcBuffer = SPACE(200)+CHR(0)
        lnLen    =  0
        IF FILE( This.cIniFileName )
           This.cIniFileName = FULLPATH( This.cIniFileName ) 
           lnLen =  GetPrivStr( lcParKey, lcKey, "" ;
                              , @lcBuffer, LEN(lcBuffer), This.cIniFileName ) 
        ENDIF                         
        IF lnLen = 0
           RETURN ""
        ENDIF
        lcBuffer = LEFT( lcBuffer, lnLen )
        RETURN lcBuffer 

    *######################################################################## 
    PROCEDURE SetRect
        LPARAMETERS tObject, tLeft, tTop, tWidth, tHeight

        WITH tObject 
          .Left = tLeft
          .Top  = tTop
          .Width  = tWidth
          .Height = tHeight
        ENDWITH

    *######################################################################## 
    PROCEDURE ObjectAlign
        LPARAMETERS oThis, nDeltaY, nDeltaX              && Koordinaciu pokyciai po formos Resize() ivykio

        LOCAL nHeight, nWidth                            && darbiniai auksciui ir plociui saugoti

        WITH oThis
             IF .Parent.BaseClass = "Page"               && objektas yra PageFrame'o lape (nera properciu Height ir Width)
                nHeight = .Parent.Parent.PageHeight
                nWidth  = .Parent.Parent.PageWidth
             ELSE                                        && objektas yra normaliame objekte
                nHeight = .Parent.Height
                nWidth  = .Parent.Width
             ENDIF
             
             IF LEN(.cAlignment) > 0   ;
                AND SUBSTR(.cAlignment, 1, 1) = "1"    ;
                AND .Height + nDeltaY > 0                    && Resize pagal Y
                .Height = .Height + nDeltaY
             ENDIF
             IF LEN(.cAlignment) > 1   ;
                AND SUBSTR(.cAlignment, 2, 1) = "1"   ;
                AND .Width + nDeltaX > 0                     && Resize pagal X
                .Width = .Width + nDeltaX
             ENDIF
             IF LEN(.cAlignment) > 2   ;
                AND SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
                .Top = .Top + nDeltaY
             ENDIF
             IF LEN(.cAlignment) > 3   ;
                AND SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
                .Left = .Left + nDeltaX
             ENDIF
             
             IF LEN(.cAlignment) > 4   ;
                AND SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
                .Top = INT((nHeight - .Height) / 2)
             ENDIF
             IF LEN(.cAlignment) > 5   ;
                AND SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
                .Left = INT((nWidth - .Width) / 2)
             ENDIF
             
        ENDWITH

    *######################################################################## 
    PROCEDURE Load
        WITH This
              SET ASSERTS ON 
              .uRetVal = .T. 
              .cIniFileName = FULLPATH( This.cIniFileName )       
              DEBUGOUT .cIniFileName

              DO CASE
                CASE LEFT( .cIniFileName, 2 ) = 'W:'
                 .cIniFileName = ADDBS( SYS( 2023) ) ;
                               + JUSTFNAME( .cIniFileName )
                CASE DIRECTORY( [VFPLIB_PATH] )    
                   .cIniFileName = ADDBS( [VFPLIB_PATH] ) ;
                                 + JUSTFNAME( .cIniFileName )
              ENDCASE
              DEBUGOUT .cIniFileName
              
             .nOldHeight = .Height
             .nOldWidth =  .Width
             RETURN .uRetVal 
        ENDWITH 

    *######################################################################## 
    PROCEDURE Resize
        LPARAMETERS  lNotLock 

        LOCAL lI, lJ, lK                                           && darbiniai skaitliukai
        LOCAL nDeltaY, nDeltaX                                     && formos aukscio, plocio pokyciai
        LOCAL lOldLock
        LOCAL oThis

        WITH ThisForm
             lOldLock = .LockScreen
             IF ! lNotLock AND .Visible 
                .LockScreen = .T.
             ENDIF   
             
             nDeltaY = .Height - .nOldHeight                       && formos aukscio pokytis
             nDeltaX = .Width - .nOldWidth                         && formos plocio pokytis
             FOR lI = 1 TO .ControlCount                           && per formos objektus
                 oThis = .Controls(lI)
                 WITH .Controls(lI)
                   IF TYPE(".cAlignment") = "C" ;
                     AND NOT EMPTY(.cAlignment) AND AT( "1", .cAlignment) != 0
                      DO CASE
                        CASE  PEMSTATUS( oThis, 'ObjectAlign', 5 )
                            .ObjectAlign( nDeltaY, nDeltaX )
                        OTHERWISE    
                            ThisForm.ObjectAlign( oThis, nDeltaY, nDeltaX )
                      ENDCASE      
                   ENDIF
                 ENDWITH
                 IF UPPER(.Controls(lI).BaseClass) = "PAGEFRAME"   && PageFrame
                    FOR lJ = 1 TO .Controls(lI).PageCount          && per PageFrame'o puslapius
                        WITH .Controls( lI ).Pages( lJ )

                           FOR lK = 1 TO .ControlCount             && per puslapio objektus
                                 oThis = .Controls(lK)
                                 WITH .Controls(lK)
                                   IF TYPE(".cAlignment") = "C" ;
                                     AND NOT EMPTY(.cAlignment) AND AT( "1", .cAlignment) != 0
                                      DO CASE
                                        CASE  PEMSTATUS( oThis, 'ObjectAlign', 5 )
                                            .ObjectAlign( nDeltaY, nDeltaX )
                                        OTHERWISE    
                                            ThisForm.ObjectAlign( oThis, nDeltaY, nDeltaX )
                                      ENDCASE      
                                   ENDIF
                                 ENDWITH
                             ENDFOR
                        ENDWITH
                    ENDFOR
                 ENDIF
             ENDFOR
             
             .EveResize() 
             
             .nOldHeight = .Height                                 && irasom auksti
             .nOldWidth = .Width                                   && irasom ploti
             IF ! lNotLock AND .Visible 
                .LockScreen = lOldLock 
             ENDIF

        ENDWITH
    ENDPROC

    *######################################################################## 
    FUNCTION Activate 
      This.Last_WOnTop = WONTOP() 
      RETURN .T. 


    *######################################################################## 
    FUNCTION Deactivate 
      ACTIVATE SCREEN 

    *######################################################################## 
    PROCEDURE Destroy
        THis.Deactivate() 
        This.SaveWindowPos()
        RETURN .T.
    ENDPROC

    *######################################################################## 
    PROCEDURE Init
        WITH This
              .RestoreWindowPos()

              .Icon = _SCREEN.Icon
              IF .Left > _SCREEN.ViewPortWidth  - .Width 
                 .Left = _SCREEN.ViewPortWidth  - .Width - 6
              ENDIF
              IF .Top > _SCREEN.ViewPortWidth  - .Height
                 .Top = _SCREEN.ViewPortWidth  - .Height - 6
              ENDIF
              .ExternalInit()
           RETURN .uRetVal 
        ENDWITH

    *######################################################################## 
    PROCEDURE externalinit
    ENDPROC

    PROCEDURE EveShow
    ENDPROC

    PROCEDURE EveResize 
    ENDPROC

ENDDEFINE
*
*-- EndDefine: l_form
**************************************************

*######################################################################## 
DEFINE CLASS l_pageframe AS pageframe
*######################################################################## 

    TabStyle = 1  
    ErasePage = .T.
    
    PageCount = 0 
    ActivePage = 0
    Width = 160
    Height = 79
    Visible = .T. 
    calignment = ("000000")
    Name = "bc_pageframe"
    
    nState = .F.  
    nSaveHeight = 0 
    
    ADD OBJECT Page1 AS Page WITH ;
         Name = "Page1" ; 
       , FontName = "Tahoma" ;
       , FontSize = 7 ;
       , Caption = "Project"  


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
    ENDFUNC     
    
    *######################################################################## 
    *-- Objekto, sukurto klasës pagrindu, idlyginimo metodas.
    PROCEDURE objectalign
        LPARAMETERS nDeltaY, nDeltaX                     && Koordinaciu pokyciai po formos Resize() ivykio

        WITH This
             IF LEN(.cAlignment) > 0   ;
                AND SUBSTR(.cAlignment, 1, 1) = "1"    ;
                AND .Height  + nDeltaY > .Height -.PageHeight
                                                         && Resize pagal Y
                .Height = .Height + nDeltaY
             ENDIF
             IF LEN(.cAlignment) > 1   ;
                AND SUBSTR(.cAlignment, 2, 1) = "1"    ;
                AND .Width + nDeltaX > 2                     && Resize pagal X
                .Width = .Width + nDeltaX
             ENDIF
             IF LEN(.cAlignment) > 2   ;
                AND SUBSTR(.cAlignment, 3, 1) = "1"          && Move pagal Y
                .Top = .Top + nDeltaY
             ENDIF
             IF LEN(.cAlignment) > 3   ;
                AND SUBSTR(.cAlignment, 4, 1) = "1"          && Move pagal X
                .Left = .Left + nDeltaX
             ENDIF
             IF LEN(.cAlignment) > 4   ;
                AND SUBSTR(.cAlignment, 5, 1) = "1"          && Center pagal Y
                .Top = INT((.Parent.Height - .Height) / 2)
             ENDIF
             IF LEN(.cAlignment) > 5   ;
                AND SUBSTR(.cAlignment, 6, 1) = "1"          && Center pagal X
                .Left = INT((.Parent.Width - .Width) / 2)
             ENDIF
        ENDWITH
    ENDPROC


ENDDEFINE
*
*-- EndDefine: l_pageframe
**************************************************


*######################################################################## 
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
    Width = 155
    calignment = ("1100")
    
    Style = 7  
    Scroll = .T. 
    LineStyle = 1 
    CheckBoxes = .F. 
    HideSelection = .F. 
    FullRowSelect = .T. && .F. 
    HotTracking = .T. 
    SingleSel = .F. 
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
        *.Imagelist.ImageWidth  = 24
       
    ENDPROC

    *######################################################################## 
    PROCEDURE Expand
        LPARAMETERS node

        IF TYPE( "node.key" ) = 'C'
           ThisForm.TreeClick( TREE_NODECLICK, node.key )
        ENDIF
        Node.expanded = .T.
    ENDPROC

    *######################################################################## 
    PROCEDURE NodeClick
        LPARAMETERS node

        IF TYPE("node.key") = 'C'
           ThisForm.TreeClick(TREE_NODECLICK, node.key)
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
        LPARAMETERS button, shift, x, y

        This.nClickMode = 1 
        IF button = 2
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

    *######################################################################## 
    PROCEDURE NodeCheck
        LPARAMETERS node

        IF TYPE("node.key") = 'C'
           ThisForm.TreeClick(TREE_NODECHECK, node.key)
        ENDIF
    ENDPROC


ENDDEFINE 
*######################################################################## 


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
FUNCTION PrjFiles 

* DO PrjFiles  IN d:\vfplib\sys\PrjVw.prg 

IF EMPTY( ALIAS() ) OR ! JUSTEXT( DBF() ) == "PJX"  
  IF TYPE( "_VFP.ActiveProject.Name" ) # "C"
     RETURN .F.
  ENDIF
  lcALias = JUSTSTEM( _VFP.ActiveProject.Name  ) 
  lcName = FULLPATH( _VFP.ActiveProject.Name  ) 
  IF ! USED( lcAlias ) 
      USE (lcName) ALIAS (lcAlias) IN 0 AGAIN 
      IF ! USED( lcAlias ) 
         RETURN .F. 
      ENDIF   
  ENDIF 
  SELECT (lcAlias) 
ENDIF 

CD  ( _VFP.ActiveProject.HomeDir) 

LOCAL lcPrj  
lcPrj = ALIAS() 
SET ASSERTS ON 
ASSERT JUSTEXT( DBF() ) == "PJX" 


CREATE CURSOR cPrj ( ID I, File c(80) ;
, name c(20), ext c(3) ;
, type c(1) ;
, subdir c(20 ) ;
, key c(20), chtime T, TimeStamp I ;
, fullfile c(100) )

INDEX ON File   TAG File 
INDEX ON ChTime TAG ChTime

IF TYPE( "lcPrj" ) = 'U'
  lcPrj = ALIAS()  
ENDIF 

INSERT INTO cPrj ( ID, File, Type, Key, TimeStamp ) ;
  SELECT RECNO() ;
     , CHRTRAN( PADR( Name, 80 ) ,CHR(0), "" ) ;
     , Type, Key , TimeStamp  ;
  FROM (lcPrj)  WHERE Type NOT IN ( 'x' , 'i', 'T' ) ;
     

UPDATE cPrj SET FullFile = FULLPATH( File ) ;
   , Ext = JUSTEXT( File ) ;
   , SubDir = JUSTPATH( File ) ; 
 WHERE FILE( ALLTRIM( cPrj.File ) )   

UPDATE cPrj SET ChTime = FDATE( File, 1 )  ; 
     WHERE FILE( File )   
 
 

 
FUNCTION PrjVcxRequery 
  
  PrjFiles() 
  IF ! USED( "cPrj") 
     RETURN .F. 
  ENDIF
  ACTIVATE SCREEN 
  
  SELECT cPrj
  SCAN FOR INLIST(UPPER(cPrj.Ext), "VCX","SCX" ) ;
       AND FILE( ALLTRIM( cPrj.FullFile ) ) 
    
    SELECT 0 
 
    USE ( cPrj.FullFile )  AGAIN SHARED  
    
    IF ! EMPTY( DBF() ) 
        ? DBF() 
        DO D:\Vfplib\SYs\ViewVcx WITH ".NOSHOW" 
    ENDIF 
    
    USE 
  ENDSCAN     
