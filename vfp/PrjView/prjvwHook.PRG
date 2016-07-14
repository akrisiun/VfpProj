* $Id: prjvwHook.PRG,v 1.9 2007/10/09 11:44:46 andriusk Exp $
* prjvwHook

*$Log: prjvwHook.PRG,v $
*Revision 1.9  2007/10/09 11:44:46  andriusk
*Nerasto failo N_File pataisymas (is .N_Dir)
*
*Revision 1.8  2007/07/24 11:53:28  andriusk
*Nodes_AddFile, .curItem properties
*
*Revision 1.7  2007/05/11 08:20:10  andriusk
*scx failu metodai
*
*Revision 1.6  2006/07/05 15:02:04  andriusk
*PW_NodeFile ikelimas, LIBPATH define keitimas, Requery erase FXP
*
*Revision 1.5  2006/03/15 14:15:33  andriusk
*Geri pakeitimai 2006-03
*
*Revision 1.6  2006/02/14 18:00:23  AndriusK
*Found2
*
*Revision 1.4  2005/03/09 12:37:16  andriusk
*proj XML generate fix
*
*Revision 1.3  2005/02/18 09:29:34  andriusk
*Project subdirs / XML generate
*
*Revision 1.2  2004/11/29 12:35:10  andriusk
*main hook funcs
*
*Revision 1.1  2004/11/26 16:08:08  andriusk
*NotActPM manual delete Active=10->11
*

#DEFINE APP_VERSION .F.
#IF NOT APP_VERSION 
    #DEFINE LIBPATH D:\VfpLib\Sys
    #DEFINE THISFILE LIBPATH\PrjVwHook.prg 
#ELSE 
    #DEFINE LIBPATH
    #DEFINE THISFILE PrjVwHook.prg 
#ENDIF
#DEFINE TEST_NODE .F.

#DEFINE USE_DATAEXP .F.
#DEFINE LDEBUG_MODE .F. 
#DEFINE LCURS  .F. 
#DEFINE TEST_FIL .F. 

#DEFINE TREE_NODECLICK       1 
#DEFINE TREE_NODECHECK       2
#DEFINE TREE_NODEEDIT        5 
#DEFINE TREE_NODERUN         4
#DEFINE CR   CHR(13)+CHR(10) 
#DEFINE CRLF CHR(13)+CHR(10)   


*--- PRJ_ITEMINFO index'es 
#DEFINE PI_SORT    1
#DEFINE PI_FILE    2
#DEFINE PI_KEY     3
#DEFINE PI_STEM    4
#DEFINE PI_EXT     5
* #DEFINE PI_SUBDIR  6
#DEFINE PI_DIR  6
#DEFINE PI_TIME    7
#DEFINE PI_FSIZE   8
#DEFINE PI_SRCTYPE 9             && SRCTYPE = T-text, D-dbf, B-binary, V-vcx/scx  
#DEFINE PI_EXCLUDE 10

SET PATH TO LIB\, BMP\, PRG\  ;
     , D:\VFPLIB\PRG\, D:\VFPLIB\CLS\, D:\VFPLIB\BMP\, D:\VFPLIB\EXT\, D:\VFPLIB\EBR\, TMP\ ;
     , D:\VFPLIB\SYS\, D:\VFPLIB\SYS\FData\ 
DO PrjVw2     

*##############################################################################
FUNCTION FillProj (toForm AS PrjView OF PrjVw2.Prg, tcKey)
* DO FillProj WITH _screen.oPrj, "PRJ" IN PrjVwHook.prg 
*##############################################################################

   WITH toForm.Tree1 

       LOCAL lByCPRJ

       toForm.uRetVal = .F.
       lByCPRJ = .F.
       IF TYPE("_VFP.Application.ActiveProject.Files.Count") # "N"
          IF ! USED( "cPrj" )  
             DO PrjCurs     && IN THISFILE=D:\Vfplib\sys\PrjVwHook.prg 
          ENDIF 
          IF ! USED( "cPrj" )  OR RECCOUNT( "cPrj" ) = 0 
               RETURN .F.
          ENDIF
          IF TYPE( "cPrj.Name" ) = 'C' 
             UPDATE cPrj SET Name = File 
          ENDIF  
          lByCPRJ = .T.
       ENDIF
       LOCAL lnCnt, lcParKey, lnSele  
       
       IF EMPTY( tcKey )       
          tcKey = "PRJ" 
       ENDIF  
       IF TYPE(".Nodes(tcKey).Key") # "C" 
          IF .Nodes.Count > 0 AND .Nodes(1).Key = [PRJNO] 
            tcKey = [PRJ0]
            .Nodes(1).Key = tcKey 
          ENDIF    
          IF TYPE(".Nodes(tcKey).Key") # "C" 
             RETURN .F.
          ENDIF 
       ENDIF
       lnSele = SELECT() 

       toForm.Prj_HomeDir = ADDBS( _VFP.Application.ActiveProject.HomeDir ) 
       lcParKey = tcKey 
       
       .Nodes( tcKey ).Text = _VFP.Application.ActiveProject.Name 

       * Masyvas
       LOCAL ARRAY aFil[ 1, 5 ]
       LOCAL lnCnt 

       aFil[ 1, 1 ] = .F.
       =ArrayFil(toForm, @aFil, "", lByCPRJ)
       lnCnt = IIF(TYPE("aFil[1, 1]") #'C', 0, ALEN(aFil, 1)) 

       LOCAL lcExt, lnItems, lcKey  
               
       lnItems = MAX(1, lnCnt) 
       #DEFINE DIM_PRJITEMS             
       DIMENSION toForm.Prj_Items[ lnItems, 1 ]
       DIMENSION toForm.Prj_ItemInfo[ lnItems, 10 ]
       
       LOCAL lcSubDir, lnDirsCnt, lcCurDir, lcRootKey
       LOCAL lcText, lnI
       
       lcCurDir = "" 
       lcRootKey = lcParKey 
       lnDirsCnt = 0 
       lnItems = 0                                        && ..... 
       
       FOR lnI = 1 TO lnCnt 
             
            IF TYPE( "aFil[ lnI, 2 ]" ) # "N"
               LOOP 
            ENDIF 
            lnItems = lnItems + 1    
            lcText = aFil[ lnI, 1 ]
            lcExt = JUSTEXT( UPPER(lcText)  ) 
            IF ! INLIST(lcExt, "PRG", "SCX", "VCX", "DDL", "TXT", "XML")
               LOOP
            ENDIF  
            
            lcSubDir = JUSTPATH( lcText ) 
            IF ! lcSubDir == lcCurDir 
                lnDirsCnt = lnDirsCnt + 1
                lcKey = "DIR"+ TRANSFORM( lnDirsCnt  ) && Index 
                IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
                   .Nodes.Remove( lcKey )
                   IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
                      LOOP 
                   ENDIF 
                ENDIF    
                #DEFINE NODEADD_SUBDIR
                .Nodes.Add( lcRootKey, 4, lcKey, lcSubDir )
                IF ! TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
                   EXIT 
                ENDIF  
                lcParKey = lcKey 
                lcCurDir = lcSubDir  
            ENDIF 

            lcKey  = "FIL" + TRANSF(lnItems)               && Index 
            
            =Nodes_AddFile(toForm, lcParKey, lcKey, @aFil, lnI)

       ENDFOR 
       
       SELECT (lnSele)          && restore current data alias 
  
       lnItems = MAX( 1, ALEN(toForm.Prj_Items, 1)) 
       DIMENSION toForm.Prj_Items[ lnItems, 1 ]
       DIMENSION toForm.Prj_ItemInfo[ lnItems, 10 ]
     
    ENDWITH 

       
*#######################################################################################
FUNCTION FillProjDir(toForm AS PrjView OF PrjVw2.Prg, lcDirKey) 

*#######################################################################################

    WITH toForm.Tree1 

        LOCAL ARRAY aFil[1, 5]
        LOCAL lnItems, lcText, lcExt
        LOCAL lnCnt, lnI, lcKey, lcParKey
        LOCAL lcSubText
         
        aFil[1, 1] = .F.
        lcSubText = ""                    && init var 
        lcSubText = .Nodes(lcDirKey).Text 
        IF LEFT(lcSubText, 2) == ".\"
           lcSubText = SUBSTR(lcSubText, 3)
        ENDIF 
        ASSERT !EMPTY(lcSubText) 
        
        =ArrayFil(toForm, @aFil, lcSubText, USED([cPRJ]))

        lcParKey = lcDirKey
        lnItems = MAX( 1, ALEN(toForm.Prj_Items, 1)) 
        lnCnt = IIF(TYPE("aFil[1, 1]") #'C', 0, ALEN(aFil, 1)) 

        FOR lnI = 1 TO lnCnt

            IF TYPE( "aFil[ lnI, 2 ]" ) # "N"
               LOOP 
            ENDIF 

            lcText = aFil[ lnI, 1 ]
            lcExt = JUSTEXT( UPPER(lcText)  ) 
            IF ! INLIST(lcExt, "PRG", "SCX", "VCX", "DDL", "TXT", "XML")
               LOOP
            ENDIF  

            lnItems = lnItems + 1    
            DIMENSION toForm.Prj_Items[ lnItems, 1 ]
            DIMENSION toForm.Prj_ItemInfo[ lnItems, 10 ]
        
            lcKey  = "FIL" + TRANSF(lnItems)                 && Index 
            
            =Nodes_AddFile(toForm, lcParKey, lcKey, @aFil, lnI)

       ENDFOR     

       lnItems = MAX( 1, ALEN(toForm.Prj_Items, 1)) 
       DIMENSION toForm.Prj_Items[ lnItems, 1 ]
       DIMENSION toForm.Prj_ItemInfo[ lnItems, 10 ]
    
    ENDWITH 

*#######################################################################################
FUNCTION ArrayFil(toForm, aFil AS Array, tcSubDir, lByCPRJ)   && Project array Fill 
*#######################################################################################
       
       IF LDEBUG_MODE OR LCURS 
           CREATE CURSOR ProjFiles (FName C(20), Ext C(7), Index I, Type C(1) ;
                   , SubDir C(20) ;
                   , ChTime T, FSize I, Exclude L ;
                   , File C(200) ;
                   , User M ;     && in Pjx.User file 
                   , Comment C(150), KeyFile C(20), Text C(50) ;
                   , Key C(20), Stem C(20))  
       ENDIF 

       LOCAL lnCnt

       IF lByCPRJ 
          lnCnt = RECCOUNT("cPrj") 
          SELECT cPrj
          SET ORDER TO 
          GO TOP           
       ELSE 
          lnCnt = _VFP.Application.ActiveProject.Files.Count  
       ENDIF 

       LOCAL ARRAY aFil[ lnCnt, 5 ]
                                                    
       LOCAL loFile AS Files 
       LOCAL lcText, lcKeyFile, lcDir 
       LOCAL lnII, lnI
       LOCAL lcType, lcDescript, lTime, lExclude 

       lnI = 0  

       FOR lnII = 1 TO lnCnt 
            
            DO CASE 
              CASE ! lByCPRJ
                    IF TYPE( "_VFP.Application.ActiveProject.Files[ lnII ].Name" ) # 'C'
                       LOOP
                    ENDIF
                    loFile = _VFP.Application.ActiveProject.Files[ lnII ]
                    lcText = loFile.Name         && full path lowercase 
                    lcDir  = JUSTPATH(FULLPATH(lcText)) 

                    lcType = loFile.Type
                    lExclude = loFile.Exclude
                    lcDescript = loFile.Description
                    IF FILE( lcText )          && failo nera jei blogas projektas/path nesudetas
                       lTime  = FDATE( lcText, 1 ) 
                    ENDIF 
                    IF ATC(FULLPATH(tcSubDir), lcDir) = 0 ;
                       OR (ALLTRIM(tcSubDir) == "." ;
                           AND !FULLPATH(_VFP.ActiveProject.HomeDir) == lcDir)
                       LOOP
                    ENDIF        
                    
              CASE TYPE("cPrj.File") = "C" 
              
                    loFile = .NULL.
                    lcText = ALLTRIM(cPrj.File)
                    lcDir  = JUSTPATH(FULLPATH(lcText)) 
                    
                    ** LEFT(lcText, LEN(tcSubDir) + 1) <> tcSubDir + "\" 
                    IF !EMPTY(tcSubDir) AND !ALLTRIM(tcSubDir) == "." ;
                          AND ATC(":", tcSubDir) = 0 ;
                          AND ATC(ADDBS(FULLPATH(tcSubDir)), FULLPATH(lcText)) = 0 ;
                       OR (ALLTRIM(tcSubDir) == "." AND ATC("\", lcText) > 0) ;
                       OR (ATC(":", tcSubDir) > 0 AND ATC(tcSubDir, FULLPATH(lcText)) = 0)
                       
                       * msg('skip ' + lcText + ' of ' + tcSubDir + ' full=' + FULLPATH(lcText)) 
                       SKIP 1 IN cPrj 
                       LOOP                    && Filter subdir 
                    ENDIF 
                    
                    ASSERT FILE(lcText) MESSAGE "Prj no file " + lcText  
                    IF ! FILE(lcText) 
                       lcText = ALLTRIM( cPrj.FullFile )
                       IF ! FILE( lcText ) 
                          LOOP
                       ENDIF                 
                    ENDIF 
                    lcType = cprj.Type
                    IF TYPE( [cPrj.Descript] ) = 'C' 
                        lcDescript = cPrj.Descript
                    ELSE 
                        lcDescript = ""
                    ENDIF 
                    lExclude = cPrj.Exclude 
                    
                    lTime  = FDATE( lcText, 1 ) 
                    
                    SKIP 1 IN cPrj 
              OTHERWISE
                 LOOP
            ENDCASE         
            IF ATC( JUSTEXT( lcText ), "BMP ICO FLL APP MEM MSK" ) # 0
               LOOP
            ENDIF  

            lnI = lnI + 1  
            lcKeyFile = UPPER(JUSTFNAME( lcText ))  

            IF ATC( toForm.Prj_HomeDir, lcText )  # 0 
               lcText = STRTRAN( lcText, toForm.Prj_HomeDir, "" ) 
               IF ! EMPTY(JUSTPATH(lcText))
                  lcText = ".\"+ lcText         && + "\"
               ENDIF    
            ENDIF 
            IF EMPTY( JUSTPATH( lcText ) )
               lcText = "!:.\"+ lcText 
            ENDIF 
            
            aFil[ lnI, 1 ] = lcText          && .File 
            aFil[ lnI, 2 ] = lnI             && .Index
            aFil[ lnI, 3 ] = lcKeyFile 
            aFil[ lnI, 4 ] = lExclude

            IF USED( "ProjFiles" )  AND FILE( lcText ) 
               INSERT INTO ProjFiles (File, Index, Type, ChTime, Comment) ;
                   VALUES(lcText, lnI, lcType, lTime , lcDescript) 

               REPLACE IN ProjFiles ;
                   FName  WITH JUSTFNAME( lcText ) ;
                   Ext    WITH JUSTEXT( lcText ) ;
                   SubDir WITH  JUSTPATH( lcText ) 
                   
            ENDIF 

       ENDFOR             
        
       lnCnt = lnI  
       IF lnI > 0 
           DIMENSION aFil[ lnI, 5 ]
           =ASORT( aFil )
           FOR lnI = 1 TO lnCnt
               aFil[ lnI, 1 ] = STRTRAN( aFil[ lnI, 1 ], "!:", "" ) 
           ENDFOR 
       ENDIF        
       * TODO: IF lnCnt > 20     && big array ... 
       RETURN .T.

*#######################################################################################
FUNCTION Nodes_AddFile(toForm AS PrjView OF PrjVw2.Prg ;
                      , lcParKey, lcKey, aFil AS Array, lnI AS Integer)
*#######################################################################################

    WITH toForm.Tree1 

            LOCAL lcText, lnItems, lcExt 
            LOCAL lcFile, lTime, lExclude
            
            lnItems = IIF(TYPE("toForm.Prj_Items[ 1, 1 ]") # "C" ;
                         , 1, ALEN(toForm.Prj_Items, 1)) 
            
            lcText = aFil[ lnI, 1 ]
            lcFile = ALLTRIM(lcText)
            lcText = JUSTFNAME(lcText) 
            lcExt = JUSTEXT( UPPER(lcText)  ) 
            lExclude = aFil[ lnI, 4 ]
            
            IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
               .Nodes.Remove( lcKey )
               IF TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
                  ASSERT (.F.) MESSAGE "Not removed node "+ TRANSFORM( lcKey ) 
                  LOOP 
               ENDIF 
            ENDIF   
            ASSERT TYPE( [.Nodes( lcParKey ).Key] ) = 'C' 

            #DEFINE NODEADD_FIL
            .Nodes.Add( lcParKey, 4, lcKey, lcText )
            IF ! TYPE( [.Nodes( lcKey ).Key] ) = 'C' 
               EXIT 
            ENDIF 
            lcFile = ALLTRIM(lcFile)
            
            lTime = {. : } 
            IF FILE(lcFile)
               * ASSERT UPPER(lcFile) == UPPER(FULLPATH(lcFile)) 
               lTime = FDATE( lcFile, 1 ) 
            ENDIF 
            
            toForm.Prj_Items[ lnItems, 1 ]    = lcKey
            toForm.Prj_ItemInfo[ lnItems, PI_FILE ] = lcFile
            toForm.Prj_ItemInfo[ lnItems, PI_KEY ]  = lcKey
            toForm.Prj_ItemInfo[ lnItems, PI_STEM ] = lcText
            toForm.Prj_ItemInfo[ lnItems, PI_EXT ]  = JUSTEXT(lcFile)
            toForm.Prj_ItemInfo[ lnItems, PI_DIR ] =  JUSTPATH(FULLPATH(lcFile))
                                                      && JUSTPATH(lcFile)
            toForm.Prj_ItemInfo[ lnItems, PI_TIME ]  = lTime
            toForm.Prj_ItemInfo[ lnItems, PI_FSIZE ] = 0

            toForm.Prj_ItemInfo[ lnItems, PI_SORT ] = FULLPATH(lcFile) 
            toForm.Prj_ItemInfo[ lnItems, PI_EXCLUDE ] = lExclude

            IF lExclude AND TYPE([.Nodes(lcKey).ForeColor]) = 'N' 
               .Nodes(lcKey).ForeColor = 0x707070
            ENDIF 
            
            IF INLIST(lcExt, "VCX", "PRG", "SCX")
               IF TYPE([.Nodes(lcKey+"EMPTY" ).Key]) = 'C' 
                   .Nodes.Remove(lcKey+"EMPTY")
               ENDIF     
               .Nodes.Add(lcKey, 4, lcKey+"EMPTY", "...")
            ENDIF  

   ENDWITH 
               

*#######################################################################################
FUNCTION NodeInfo(toForm, tcKey)
*#######################################################################################
     
          IF TYPE( [tcKey] ) # "C" ;
             AND TYPE([toForm.Tree1.SelectedItem.Key] ) = 'C' 
             tcKey = toForm.Tree1.SelectedItem.Key 
          ENDIF
          toForm.N_Key  = tcKey 
          IF EMPTY( toForm.N_Key ) ;
             OR TYPE( [toForm.Tree1.Nodes( tcKey ).Key] ) # "C" ;
             OR toForm.Tree1.Nodes( tcKey ).Key # tcKey 
             toForm.N_Key = ""
             RETURN .F.
          ENDIF  
          
          #DEFINE NODEINFO_ITEM   

          toForm.N_Item = ""        
          toForm.N_Children = toForm.Tree1.Nodes( tcKey ).Children
          
          toForm.N_Stem = toForm.Tree1.Nodes( tcKey ).Text 
           
          IF "_CLS" $ toForm.N_Key  OR "_PRC" $ toForm.N_Key 
              toForm.N_Item = toForm.N_Text 
              toForm.N_Text = toForm.Tree1.Nodes( tcKey ).Parent.Text 
          ENDIF
          toForm.N_Line = 0 
          IF ATC( "_L", toForm.N_Key ) # 0         && Line gavimas 
        
               LOCAL lcInt 
               lcInt = ALLTRIM( SUBSTR( toForm.N_Key ;    
                              , ATC( "_L", toForm.N_Key ) + 2   ) ) 
               IF ! EMPTY( lcInt )
                  toForm.N_Line = VAL( lcInt ) 
               ENDIF  
           ENDIF
           
          ASSERT ! TEST_FIL OR ! "FIL" $ toForm.N_Key  
          
          DO CASE
           CASE INLIST( LEFT( toForm.N_Key, 3 ), "FIL")
          
              toForm.N_Idx = VAL( STREXTRACT( toForm.N_Key + "_" , "FIL", "_")) 
              DO CASE
                CASE toForm.N_Idx # 0 ;
                 AND TYPE("toForm.Prj_ItemInfo[toForm.N_Idx, PI_STEM]") = 'C'
                                                    && FIL* from prj 
                                                    
                 toForm.N_Text = toForm.Prj_ItemInfo[toForm.N_Idx, PI_STEM] 
                 toForm.N_File = toForm.Prj_ItemInfo[toForm.N_Idx, PI_FILE] 
                 toForm.N_Dir  = toForm.Prj_ItemInfo[toForm.N_Idx, PI_DIR] 
                 toForm.N_Exclude = toForm.Prj_ItemInfo[toForm.N_Idx, PI_EXCLUDE] 
                 toForm.N_Info = toForm.N_File 
                 
                CASE  ! "_" $ toForm.N_Key          && FILW* atvejis
                    toForm.N_Text = toForm.N_Stem      
                    IF FILE(toForm.N_Stem) 
                       toForm.N_Text = toForm.N_Stem
                       toForm.N_File = toForm.N_Stem
                       toForm.N_Dir = JUSTPATH(FULLPATH(toForm.N_Stem))
                    ELSE
                       ASSERT !TEST_NODE MESSAGE "No file N_Stem"
                       toForm.N_Dir = ALLTRIM(toForm.Tree1.Nodes(toForm.N_Key).Parent.Text)
                       * IF LEFT(toForm.N_Dir, 1) == "."
                       toForm.N_Dir = FULLPATH(toForm.N_Dir) 
                           
                       toForm.N_File = ADDBS(toForm.N_Dir) + toForm.N_Stem
                    ENDIF   
                
                OTHERWISE 
                    toForm.N_File = toForm.N_Text   
              ENDCASE 
              
              IF !EMPTY(toForm.N_File) AND ATC(".", toForm.N_File) > 0 ;
                 AND RIGHT(ALLTRIM(toForm.N_File), 2) == " *"
                 
                 * assert .F. message [cur file ] + toForm.n_File 
                 toForm.N_File = SUBSTR(toForm.N_File, 1, LEN(toForm.N_File) - 2)
                 toForm.N_Stem = JUSTFNAME(toForm.N_File)
                 IF !FILE(toForm.N_File) 
                    toForm.N_File = IIF(FILE(FULLPATH(toForm.N_Stem)) ;
                                       , FULLPATH(toForm.N_Stem), toForm.N_Stem)
                 ENDIF 
              ENDIF    
              
              IF toForm.N_Idx > 0 AND !EMPTY(toForm.N_Text) ; 
                 AND !TYPE("toForm.Prj_ItemInfo[toForm.N_Idx, PI_STEM]") = 'C'
                                                    && FIL* from prj 
                                                    
                 toForm.Prj_ItemInfo[toForm.N_Idx, PI_STEM] = toForm.N_Text
                 toForm.Prj_ItemInfo[toForm.N_Idx, PI_FILE] = toForm.N_File
                 toForm.Prj_ItemInfo[toForm.N_Idx, PI_DIR] = toForm.N_Dir
              ENDIF 

           OTHERWISE 
              ASSERT INLIST( LEFT( toForm.N_Key, 3 ) ;
                           , "DIR", "PRJ", "WND", "DSE", "DAL", "FWI") 
              toForm.N_Text = toForm.N_Stem         && DIR* atvejis
              toForm.N_File = ""
          ENDCASE
          
          IF TYPE( "toForm.N_Text" ) # "C"
             toForm.N_Text = toForm.N_Stem 
             RETURN .F.
          ENDIF   
          
          IF ISNULL( toForm.Tree1.Nodes( tcKey ).Parent )  
             toForm.N_ParKey = ""
             toForm.N_ParText = ""
          ELSE    
             toForm.N_ParKey  = toForm.Tree1.Nodes( tcKey ).Parent.Key  
             toForm.N_ParText = toForm.Tree1.Nodes( tcKey ).Parent.Text 
          ENDIF            
          IF ! EMPTY( toForm.N_FILE ) 
             IF !FILE(toForm.N_FILE) AND ATC("\", toForm.N_File) = 0 
                toForm.N_FILE = FULLPATH(ADDBS(toForm.N_Dir) + toForm.N_File)
                ASSERT FILE(toForm.N_FILE)  
             ENDIF 

             toForm.N_Ext = JUSTEXT(toForm.N_FILE) 
          ENDIF 
          toForm.uRetVal = .T. 
          RETURN .T.


*######################################################################## 
FUNCTION NodeCmd(toFormPar AS Form, tcAddi) 
    
    PRIVATE toForm AS PrjVw ON PrjVw.prg 
    toForm = toFormPar

    ASSERT !TEST_NODE
    IF EMPTY(toForm.N_Cmd) 
       RETURN .F.
    ENDIF 
    IF "This." $ toForm.N_Cmd 
       toForm.N_Cmd = STRTRAN(STRTRAN(toForm.N_Cmd, "THIS.", "This.") ;
                             , "This.", "toForm.")
    ENDIF 
    ACTIVATE SCREEN 
    
    LOCAL lcMacro, lcRet
    lcMacro = toForm.N_Cmd
    IF ATC([ IN ], lcMacro) > 0 
       lcMacro = STRTRAN(lcMacro, [ IN .\], [ IN ])
       IF toForm.N_Ext = [PRG]
          lcMacro = STRTRAN(lcMacro, [.prg], [.fxp]) 
          COMPILE (toForm.N_File) 
       ENDIF
    ENDIF 
    
    toForm.Cmd_Last = lcMacro 
    
    IF ATC( CHR(13), lcMacro ) = 0  
        &lcMacro   
    ELSE     
        EXECSCRIPT( lcMacro ) 
    ENDIF 
    lcRet = _TALLY 
    RETURN lcRet 

FUNCTION Reinit(toForm AS PrjView2 OF PrjVw2.Prg)

  WITH toForm
       .oCfg.SaveCfg() 
       
       .Show() 
       .InitNode("") 
       
  ENDWITH 

*##############################################################################
FUNCTION Form_Show (toForm AS PrjViewForm OF PrjVw2.Prg)

       toForm.ReadPos() 
       toForm.Resize()   
       toForm.Visible = .T. 
       toForm.cmdFind.Enabled = .T. 
       
       toForm.Tree1.SetFocus()
       
       IF USE_DATAEXP 
           LOCAL loDExp AS L_CntDataExp OF PrjVw2.prg 
           loDExp = toForm.oDataExplorer 

           ASSERT APP_VERSION OR FILE([DataExpEngine.prg]) 
           IF APP_VERSION OR FILE([DataExpEngine.prg]) 
              * SET PATH TO BMP\, PRG\, LIB\, FRM\  ;
                 , D:\VFPLIB\PRG\, D:\VFPLIB\CLS\, D:\VFPLIB\BMP, D:\VFPLIB\EXT\, D:\VFPLIB\EBR\, TMP\ ;
                 , D:\VFPLIB\SYS\, D:\VFPLIB\SYS\FData\
              * loDExp.lDebug = .T. 
              loDExp.OnShow()
              loDExp.oTree.SetFocus() 
           ENDIF 
       ENDIF 
       
       RETURN toForm.uRetVal 

FUNCTION ActivatePage(toForm AS PrjViewForm OF PrjVw2.Prg) 

   * toForm.pgF1.ActivePage 


FUNCTION InitNode(toForm AS PrjViewForm OF PrjVw2.Prg, tcKey)

        LOCAL lcKeyPar, lcKey 
        lcKeyPar = tcKey
        lcKey = ""

        WITH toForm.Tree1
         
         IF ! EMPTY(tcKey)
            IF .Nodes(tcKey).Children = 1  ;
               AND "EMPTY" $ .Nodes(tcKey).Child.Key 

                ASSERT !TEST_NODE MESSAGE [Node ] + tcKey + [ Name=] + .Nodes(tcKey).Text 
                lcKey = .Nodes(tcKey).Child.Key 
                .Nodes.Remove(lcKey)
                lcKey = ""
            ENDIF   
            IF .Nodes(tcKey).Children > 0 AND .Nodes(tcKey).Index > 1 
               RETURN .F.
            ENDIF 
         ENDIF 
         
         LOCAL lcName 
                     
         DO CASE
          CASE EMPTY(tcKey)
            
               lcKey = "PRJ"
               toForm.Prj_HomeDir = ""  
               IF TYPE( "_VFP.Application.ActiveProject.Name" ) = "C"
                  lcName = _VFP.Application.ActiveProject.Name
                  toForm.Prj_HomeDir = ADDBS(_VFP.Application.ActiveProject.HomeDir)
               ELSE
                  lcKey = "PRJNO"
                  lcName = "No project" 
                  IF .Nodes.Count > 0
                     RETURN .F.
                  ENDIF
               ENDIF  
               
               toForm.N_Prj = JUSTSTEM( lcName ) 
               toForm.Caption = toForm.CaptionPref + toForm.N_Prj 
               
               .Nodes.Clear()          
               #DEFINE NODEADD_PRJROOT
               .Nodes.Add( , 4, lcKey, lcName )
               .Nodes( lcKey ).Expanded = .T.
               
               toForm.InitNode(lcKey) 
               
               lcKey = "WND"
               .Nodes.Add( , 4, lcKey, "Windows" ) 
               .Nodes( lcKey ).Expanded = .T.
               toForm.InitNode(lcKey) 

               lcKey = "DSET1"
               .Nodes.Add( , 4, lcKey, "Datasession " ;
                         + TRANSFORM( SET( "DATASESSION" ))  ) 
               .Nodes( lcKey ).Expanded = .T.
               toForm.InitNode( lcKey ) 

          
          CASE LEFT( tcKey , 3 ) = "WND"
               toForm.FillWindow() 
              
          CASE LEFT( tcKey , 3 ) = "DIR"
               * ?? TODO
               =FillProjDir(toForm, tcKey) 

          CASE LEFT( tcKey , 3 ) = "PRJ"
               **toForm.FillProj() 
               =FillProj(toForm, tcKey) 

          CASE LEFT( tcKey , 3 ) = "DSET"
               * toForm.FillDSet() 

          CASE LEFT( tcKey , 3 ) = "FIL" 
               
               IF ! NodeFile(toForm, tcKey) 
                  ASSERT !TEST_NODE MESSAGE [failed nodefile(] + tcKey 
                  RETURN .F.
               ENDIF  

               #IF APP_VERSION 
                  DO PW_NodeFile WITH toForm, tcKey IN PrjvwItem 
               #ELSE   
                  ASSERT FILE([LIBPATH\PrjvwItem.prg]) 
                  IF FILE([LIBPATH\PrjvwItem.prg]) 
                     DO PW_NodeFile WITH toForm, tcKey IN ([LIBPATH\PrjvwItem]) 
                  ENDIF 
               #ENDIF    
            
          ENDCASE

        ENDWITH 


*##############################################################################
FUNCTION FillWindow(toForm AS PrjView OF PrjVw2.Prg, tcKey) 

    IF !FILE([PrjVwWind.prg])
       RETURN .F.
    ENDIF 

    LOCAL loWindow  AS TWindow OF PrjVwWind.prg 
    LOCAL loList AS Collection
     
    loWindow = NEWOBJECT("Twindow", [PrjVwWind.prg], .NULL., 0) 
    loList = loWindow.GetFrameChilds([W])

    LOCAL lcParKey 

    IF EMPTY(tcKey) 
         tcKey = "WND"  
    ENDIF 
    lcParKey = tcKey 

    * Last_WOnTop 
    ASSERT ! LDEBUG_MODE MESSAGE "Windows "+ TRANSFORM(loList.Count) 
    WITH toForm.tree1 

        LOCAL lnI, lcFile, lcKey, lcText
        LOCAL loItem AS TWindow OF PrjVwWind.prg 
        LOCAL lnItem 
        LOCAL loChild, lcKey1 
        
        lnItem = 0 

        FOR EACH loItem IN loList 
           
           IF TYPE([loItem.WinTitle]) # "C" ;
              OR loItem.WinType = "WVFP" ; 
              OR INLIST(loItem.WinTitle, [Trace], [Call Stack]) 
              LOOP
           ENDIF 
           
           lcFile = ALLTRIM(loItem.WinTitle) 
           lcFile = STRTRAN( lcFile, "[Read Only]", "" )
            
           lnItem = lnItem + 1 
           IF loItem.WinType = "WMODI"
              lcKey  = "FILW" + TRANSFORM(lnItem) 
              lcText = IIF(ATC('.TMP', lcFile) > 0, lcFile, JUSTFNAME(lcFile)) 

           ELSE
              lcKey  = "FWIN" + TRANSFORM(lnItem) 
              
              * TODO check  _SCREEN.Forms NAMES ... 
              lcText = lcFile 
           ENDIF    
           
           IF TYPE( ".Nodes( lcKey ).Key" ) = 'C' 
              .Nodes.Remove( lcKey )  
              IF TYPE( ".Nodes( lcKey ).Key" ) = 'C' 
                 lnItem = lnItem + 1 
                 lnI = lnI - 1 
                 LOOP   
              ENDIF 
           ENDIF 
           IF .Nodes(lcParKey).Children > 0 
              loChild = .Nodes(lcParKey).Child 
              DO WHILE !ISNULL(loChild)
                 lcKey1 = loChild.Key 
                 loChild = .Nodes(lcKey1).Next 
                 IF lcText == .Nodes(lcKey1).Text 
                    .Nodes.Remove(lcKey1)
                 ENDIF 
              ENDDO    
           ENDIF 
           
           #DEFINE NODEADD_WND_FIL 
           .Nodes.Add(lcParKey, 4, lcKey, lcText)
               
        ENDFOR
        .Nodes(tcKey).Expanded = .T. 

      ENDWITH 
      toForm.uRetVal = .T. 
      RETURN toForm.uRetVal  
      

FUNCTION FillWindowPopup(toForm AS PrjView OF PrjVw2.Prg, tcKey) 
        
      WITH toForm.oMenu

          .cPopup = "_MWINDOW"
          ACTIVATE POPUP _MWINDOW NOWAIT       
          .Parse() 

          IF EMPTY(tcKey) 
             tcKey = "WND"  
          ENDIF 
          LOCAL lcParKey 
          lcParKey = tcKey 
           
          LOCAL lcKey, lcText
          LOCAL lnCnt , lnI, lcFile  
          LOCAL ARRAY aFiles[ 1, 3 ] 
          
          lnCnt = 0 
          FOR lnI = 1 TO .nCount   
             lcFile = .aItems[ lnI, 1 ] 
             
             * ASSERT .aItems[ lnI, 2 ] # -22508 
             
             lcFile = STRTRAN( lcFile, "[Read Only]", "" )
             lcFile = ALLTRIM( lcFile ) 
             IF ATC( " - ", lcFile ) # 0 
                LOOP
             ENDIF 
             IF ATC( " ", lcFile ) <= 3 
                lcFile = SUBSTR( lcFile, ATC( " ", lcFile ) + 1 ) 
             ENDIF 
             IF ! FILE( lcFile ) ;
                OR INLIST( JUSTEXT( lcFile ), "PRG", "TXT", "XML", "H" ) 
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
       ASSERT ! LDEBUG_MODE MESSAGE "Windows "+ TRANSFORM(lnCnt) 
       
       WITH toForm.tree1 
        
        LOCAL lnItem 
        lnItem = 0 
        FOR lnI = 1 TO lnCnt         
           lnItem = lnItem + 1 
           lcKey  = "FILW" + TRANSFORM(lnItem) 
           lcText = aFiles[ lnI, 1 ] 
           
           IF TYPE(".Nodes( lcKey ).Key") = 'C' 
              .Nodes.Remove(lcKey)  
              IF TYPE(".Nodes( lcKey ).Key") = 'C' 
                 lnItem = lnItem + 1 
                 lnI = lnI - 1 
                 LOOP   
              ENDIF 
           ENDIF 
           #DEFINE NODEADD_WND_FIL 
           .Nodes.Add(lcParKey, 4, lcKey, lcText)
           
        ENDFOR
        .Nodes( tcKey ).Expanded = .T. 
   ENDWITH 
   toForm.uRetVal = .T. 
   RETURN .T.      

*##############################################################################
FUNCTION NodeFile(toForm AS PrjViewForm OF PrjVw2.Prg, tcKey )
*##############################################################################

    IF ! NodeInfo(toForm, tcKey) 
       RETURN .F. 
    ENDIF 
    IF INLIST(toForm.N_Key, "DIR") 
       toForm.info1.Value = PROPER(ADDBS(FULLPATH(toForm.N_Stem))) 
       toForm.info1.ToolTipText = toForm.N_Stem 
       RETURN .F.
    ENDIF  
    IF INLIST(toForm.N_Key, "WND", "DIR", "PRJ0 PRJNO DSET") 
       toForm.info1.Value = toForm.N_Stem 
       toForm.info1.ToolTipText = ADDBS(toForm.n_DIR) + toForm.N_Stem 
       RETURN .F.
    ENDIF  
    IF ATC( toForm.N_Key, "PRJ PRJ0 PRJ1 PRJNO DSET" ) = 0 
       ASSERT ! EMPTY(toForm.N_PARKEY)  
    ENDIF 
    IF EMPTY(toForm.N_File)
       RETURN .F.
    ENDIF 
    
    ASSERT TYPE( "toForm.N_File" ) = 'C'
         
    tcKey = toForm.N_Key 

    toForm.info1.Value = ;
        IIF( ! toForm.N_Stem = toForm.N_Text, toForm.N_Stem ;
              + IIF( "PRC" $ toForm.N_Key, " IN " ;
                , IIF( "CLS" $ toForm.N_Key, " OF " ;
                                , " - "  )) ;
              , "" ) + toForm.N_Text  
    toForm.info1.ToolTipText = ADDBS(toForm.n_DIR) + toForm.N_Stem 
    
    STORE .F. To toForm.cmdVcx.Enabled, toForm.cmdSrc.Enabled  
            
    IF ! FILE(toForm.N_File) 
       ASSERT EMPTY(toForm.N_File) MESSAGE "No found file [" + toForm.N_File +"] " ;
                                         + " curDir=" + CURDIR()
       IF INLIST(toForm.N_Ext, "PRG", "DDL", "XML", "SCX", "VCX") ;
          AND !EMPTY(toForm.N_File) AND !FILE(toForm.N_File) ;
          AND !EMPTY(toForm.N_Dir)

          toForm.N_File = ADDBS(toForm.N_Dir) + JUSTFNAME(toForm.N_File)
       ENDIF           
       ASSERT FILE(toForm.N_File) 
       * toForm.N_File = "" 
       RETURN .F.
    ENDIF
    *----------------------------------------------- 
    IF EMPTY( toForm.N_Stem ) 
       toForm.N_Stem  = UPPER( JUSTSTEM( toForm.N_File ) )
    ENDIF 
    toForm.N_Ext = UPPER( JUSTEXT( toForm.N_File ) )
 
    STORE INLIST( toForm.N_Ext, "VCX", "SCX", "PJX" ) ; 
       TO toForm.cmdVcx.Enabled, toForm.cmdSrc.Enabled 

    toForm.uRetVal = .T. 
    RETURN .T.                 


FUNCTION UseSrc(toForm, tcAddi) 

  IF ! FILE( toForm.N_File ) 
     RETURN .F.
  ENDIF 
  
    LOCAL lcOld
    lcOld = ALIAS() 

    toForm.N_Alias = JUSTSTEM( toForm.N_File ) 
    IF EMPTY( toForm.N_ALIAS )
       RETURN .F.
    ENDIF 
    IF USED( toForm.N_Alias  )  
       SELECT (toForm.N_Alias)
    ENDIF   
    
    IF NOT USED( toForm.N_Alias ) 
    
       SELECT 0

       TRY
         USE (toForm.N_File)  AGAIN  ALIAS (toForm.N_Alias) 
       CATCH
       ENDTRY 
       
       IF ! EMPTY( ALIAS() ) 
          toForm.N_ALIAS = ALIAS() 
       ELSE 
          ERROR "Not used "+ toForm.N_File + " ALIAS "+ toForm.N_Alias   
       ENDIF
    ENDIF
  RETURN toForm.ValidSrc()  


FUNCTION RightMenu(toForm AS PrjViewForm OF PrjVw2.Prg ;
                  , tnMode, tnValue ) 

tnMode  = IIF( VARTYPE( tnMode ) = 'N',  tnMode, 0 )
tnValue = IIF( VARTYPE( tnValue ) = 'N', tnValue, 0 )

LOCAL lcHomeDir, lcKey 
lcHomeDir = FULLPATH(CURDIR()) 
IF TYPE([_VFP.ActiveProject.HomeDir]) = 'C' 
   lcHomeDir = _VFP.ActiveProject.HomeDir 
ENDIF 
WITH toForm 
 LOCAL lcLib
 lcLib = [LIBPATH\]

 DO CASE 
   CASE tnMode = 0
    
    DEFINE POPUP P_Shortcut SHORTCUT RELATIVE FROM MROW(), MCOL() ;
                 FONT "Tahoma", 9 

    DEFINE BAR 4 OF P_Shortcut PROMPT "Edit" ;
         SKIP FOR ! FILE(lcLib + [PrjVwHook.prg]) ;
         FONT "Tahoma", 9 

    DEFINE BAR 5 OF P_Shortcut PROMPT "Run/Exec" ;
         FONT "Tahoma", 9 

    DEFINE BAR 55 OF P_Shortcut AFTER 5 PROMPT "PrjVcx Requery" ;
         FONT "Tahoma", 9 ;
         SKIP FOR ! FILE(lcLib + [PrjVwHook.prg]) 

    DEFINE BAR 56 OF P_Shortcut AFTER 5 PROMPT "PrjXML get" ;
         FONT "Tahoma", 9 ;
         SKIP FOR ! FILE(lcLib + [PrjVwHook.prg]) 
   
   DEFINE BAR 57 OF P_Shortcut AFTER 5 PROMPT "CD " + lcHomeDir ;
         FONT "Tahoma", 9 
          
    ON SELECTION BAR 55 OF  P_Shortcut  ;
             DO PrjRequery IN (lcLib + [PrjVwHook.prg]) 

    ON SELECTION BAR 56 OF  P_Shortcut  ;
             DO PrjXmlRequery IN (lcLib + [PrjVwHook.prg]) 

    lcHomeDir = [CD ]+ lcHomeDir
    ON SELECTION BAR 57 OF  P_Shortcut  ;
             &lcHomeDir 
    DEFINE BAR 6 OF P_Shortcut PROMPT '\-'

    DEFINE BAR 1 OF P_Shortcut PROMPT 'Refresh' ;
                 FONT "Tahoma", 9 

    ON SELECTION BAR 1 OF P_Shortcut  .RightMenu( 1, 1)

    ON SELECTION BAR 4 OF  P_Shortcut .RightMenu( 1, TREE_NODEEDIT)
    
    ON SELECTION BAR 5 OF P_Shortcut  .RightMenu( 1, TREE_NODERUN)

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
            
            DO Reinit WITH toForm 

       CASE tnValue = TREE_NODEEDIT    && Edit

            * TREE_NODEEDIT
            * DO PrjEdit IN (lcLib + [PrjVwHook.prg]) 
            .TreeClick( TREE_NODEEDIT, lcKey) 

       CASE tnValue = TREE_NODERUN     && Run 
            .TreeClick( TREE_NODERUN, lcKey) 
  
    ENDCASE
  
 ENDCASE 
 .uRetval = .T.
ENDWITH 

*##############################################################################
FUNCTION TreeClick(toForm, tnEvent, tcKey) 
        
    IF EMPTY(tcKey)
       RETURN .F.
    ENDIF
    DEBUGOUT "EVE " + TRANSFORM(tnEvent) + " node:" + TRANSFORM(tcKey) 
    WITH toForm.Tree1
    
      LOCAL loChild, lcKey1 
        
      IF .Nodes(tcKey).Children > 0 AND .Nodes(tcKey).Index > 1 
         IF !.Nodes(tcKey).Expanded 
            loChild = .Nodes(tcKey).Child 
            DO WHILE !ISNULL(loChild)
               lcKey1 = loChild.Key 
               loChild = .Nodes(lcKey1).Next 
               .Nodes.Remove(lcKey1)
            ENDDO    
            .Nodes.Add(tcKey , 4, tcKey + "EMPTY", "..." )            
            .Nodes(tcKey).Expanded = .F. 

            ASSERT !TEST_NODE
            =NodeFile(toForm, tcKey) 
            IF INLIST(tnEvent, TREE_NODECLICK, TREE_NODECHECK)
               RETURN .T. 
            ENDIF 
         ENDIF 

      ELSE
          ASSERT !TEST_NODE
          * toForm.NodeInfo(tcKey)  
          =NodeInfo(toForm, tcKey) 
      ENDIF 
      
      toForm.chkFav.Value = IIF( .Nodes( tcKey ).Bold, 1, 0 ) 
      
      DO CASE
       CASE tnEvent = TREE_NODECLICK      && Click Event
        
            IF "FIL" $ tcKey ;
               AND  .Nodes( tcKey ).Children <= 1 ; 
               AND (    ATC( ".VCX", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                     OR ATC( ".SCX", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                     OR ATC( ".PRG", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                     OR ATC( ".DDL", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                     OR ATC( ".XML", UPPER( .Nodes( tcKey ).Text ) ) > 0 ;
                   ) ;
               OR ! "FIL" $ tcKey 
                 
                * toForm.InitNode(tcKey) 
                =InitNode(toForm, tcKey)
            
            ELSE 
                =NodeFile(toForm, tcKey)
            ENDIF         

       CASE tnEvent = TREE_NODECHECK   
          
            toForm.TreeClick(TREE_NODEEDIT, tcKey) 
                        
       CASE tnEvent = TREE_NODEEDIT  && Edit event 

        DO CASE
           CASE tcKey = "WND"

               RETURN toForm.FillWindow() 

           CASE tcKey = "FWIN"
               
               ASSERT !TEST_NODE MESSAGE [FWindow Item=] + toForm.N_Stem 
               TRY 
                  DO CASE
                    CASE toForm.N_Stem == [Data Session] 
                       SET  
                    CASE LEFT(toForm.N_Stem, LEN('Document View')) == 'Document View'               
                       ACTIVATE WINDOW 'Document View'               
                    OTHERWISE 
                       ACTIVATE WINDOW (toForm.N_Stem)
                  ENDCASE 
               CATCH
               ENDTRY 

               
           CASE tcKey = "PRJ"
               * IF TYPE( "_VFP.ActiveProject.Name" ) = 'C' ;
               *    AND FILE( [LIBPATH\prjTool.prg] )
               *    
               *    DO OptionsForm IN ( [LIBPATH\prjTool.prg] )
               * ENDIF

               DO PrjEdit && IN THISFILE  
               
        ENDCASE        
            
        IF ! toForm.NodeFile( tcKey ) 
             RETURN .F. 
        ENDIF         
        toForm.N_Cmd = "" 

        DO CASE
           CASE "CLS" $ tcKey AND !EMPTY(toForm.N_File) 
           
              ASSERT ATC([METH ], toForm.N_Stem) = 0  
              
              toForm.N_Cmd = "MODI CLASS "+ toForm.N_Stem ;
                         + " OF "+ toForm.N_File ; 
                         + " NOWAIT SAVE"

           CASE toForm.N_Ext = "SCX" AND !EMPTY(toForm.N_File) 

              IF ATC([METH ], toForm.N_Stem) > 0
                  toForm.N_Cmd = "MODI FORM "+ toForm.N_File ;
                               + " " + toForm.N_Stem + " NOWAIT SAVE"
              ELSE 
                  toForm.N_Cmd = "MODI FORM "+ toForm.N_File + " NOWAIT SAVE"
              ENDIF                 

           CASE "PRC" $ tcKey AND !EMPTY(toForm.N_File) 
              toForm.N_Cmd = "EDITSOURCE( [" ;
                              + toForm.N_File + "], " ;
                              + TRANSFORM( toForm.N_Line ) ;
                              + " , ["+ toForm.N_Stem +"] )"  

           CASE INLIST(toForm.N_Ext, "PRG", "DDL", "XML") AND !EMPTY(toForm.N_File) 
              toForm.N_Cmd = "MODI COMM "+ toForm.N_File + " NOWAIT SAVE"

             
        ENDCASE
        toForm.NodeCmd() 

       CASE tnEvent = TREE_NODERUN ;
            AND LEFT( tcKey , 3 ) = "FIL" 
          
        IF ! toForm.NodeFile( tcKey ) 
             RETURN .F. 
        ENDIF         
        toForm.N_Cmd = ""
        DO CASE 
           CASE "CLS" $ tcKey 
              toForm.N_Cmd = "MODI CLASS "+ toForm.N_Stem + " OF "+ toForm.N_File

           CASE "PRC" $ tcKey 
              toForm.N_Cmd = "DO "+ toForm.N_Stem + " IN " + toForm.N_File 
              

           CASE toForm.N_Ext = "PRG"
              toForm.N_Cmd = "DO "+ toForm.N_File 

           CASE toForm.N_Ext = "SCX"              
              toForm.N_Cmd = "DO FORM "+ toForm.N_File 
             
        ENDCASE
        toForm.NodeCmd() 
         
      ENDCASE
    ENDWITH

*######################################################################## 
FUNCTION EditMenu ( toForm, tnMode, tnValue )

        IF ! toForm.NodeFile()  
           RETURN .F.
        ENDIF 
        LOCAL lcFileSrc 
        lcFileSrc = toForm.N_File    &&  + ".prg" 
        ASSERT FILE(lcFileSrc) 
        IF ! FILE(lcFileSrc) 
           RETURN .F.
        ENDIF 
        MODI COMM (lcFileSrc) SAVE NOWAIT 

*######################################################################## 
FUNCTION CHK_Valid( toButton, toForm )
*######################################################################## 
    LOCAL lSelect, lcKey

    lSelect = ( toForm.chkFav.Value = 1 )
    IF TYPE( "toForm.Tree1.SelectedItem.Key" ) = 'C' 
      lcKey = toForm.Tree1.SelectedItem.Key
      toForm.Tree1.Nodes( lcKey ).Bold = lSelect    
    ENDIF


*######################################################################## 
FUNCTION Edit_Click( toButton, toForm )

        IF ! TYPE( "toForm.tree1.SelectedItem.Key" ) = "C"
           RETURN .F. 
        ENDIF 
        toForm.RightMenu( 1,  TREE_NODEEDIT ) 

*######################################################################## 
FUNCTION Run_Click( toButton, toForm )

        IF ! TYPE( "toForm.tree1.SelectedItem.Key" ) = "C"
           RETURN .F.
        ENDIF 
        DO TreeClick WITH toForm, TREE_NODERUN, toForm.tree1.SelectedItem.Key

        IF TYPE( [toForm] ) = 'O'
           RETURN toForm.uRetVal 
        ENDIF 

*######################################################################## 
FUNCTION Find_Click( toButton, toForm )

  ASSERT FILE([LIBPATH\FilerW.prg] )
  IF ! FILE([LIBPATH\FilerW.prg] ) 
     toButton.Enabled = .F. 
     RETURN .F.
  ENDIF 
  DO ([LIBPATH\FilerW.prg]) 

*######################################################################## 
FUNCTION VCX_Click( toButton, toForm )

    IF ! toForm.NodeFile() ;
       OR ! toForm.UseSrc() 

       RETURN .F.
    ENDIF 
    IF ! FILE([LIBPATH\BrowF2.prg]) 
       to.Enabled = .F.
       RETURN .F. 
    ENDIF 
    DO ([LIBPATH\BrowF2]) WITH toForm.N_File 

*######################################################################## 
FUNCTION SRC_Click( toButton, toForm )

    LOCAL lMulti
    
    lMulti = .F.                 && Multi files ... 
    IF ! toForm.NodeFile() ;
       OR ! toForm.UseSrc() 
       
       IF toForm.N_Idx = 1
          lMulti = .T.
       ELSE   
          RETURN .F.
       ENDIF    
    ENDIF   
    IF ! FILE([LIBPATH\ViewVcx.prg] ) 
       toButton.Enabled = .F.
       RETURN .F. 
    ENDIF 
    
    DO ([LIBPATH\ViewVcx]) WITH toForm.N_File 
    
    IF USED( "cPrj" ) AND toForm.N_Idx = 1
       DO GetPrjXML 
    ENDIF 


FUNCTION PrjCurs
* DO PrjCurs IN D:\Vfplib\sys\PrjVwHook.prg 

IF EMPTY( ALIAS() ) OR ! JUSTEXT( DBF() ) == "PJX"  
  IF TYPE("_VFP.ActiveProject.Name") # "C"
     WAIT WINDOW NOWAIT [No project ....]  
     RETURN .F.
  ENDIF
  LOCAL lcAlias, lcName 
  lcAlias = JUSTSTEM( _VFP.ActiveProject.Name  ) 
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
 , ext c(3), stem c(20) ; 
 , type c(1) ;
 , subdir c(20 ) ;
 , key c(20), Exclude L, chtime T, TimeStamp I ;
 , fullfile c(100) )

INDEX ON File   TAG File 
INDEX ON ChTime TAG ChTime

IF TYPE("lcPrj") = 'U'
  lcPrj = ALIAS()  
ENDIF 
IF ! TYPE(lcPrj+ [.Name]) = 'M' OR ! TYPE(lcPrj+ [.TimeStamp]) = 'N' 
   ERROR [bad proj file ] + DBF(lcPrj) 
   RETURN .F.
ENDIF 

INSERT INTO cPrj ( ID, File, Type, Key, Stem, TimeStamp, Exclude) ;
  SELECT RECNO() ;
     , CHRTRAN( PADR( Name, 80 ) ,CHR(0), "" ) ;
     , Type, "", PADR(PROPER(Key),20) AS Stem, TimeStamp, Exclude ;
  FROM (lcPrj) WHERE Type NOT IN ( 'x' , 'i', 'T' )
     
UPDATE cPrj SET FullFile = FULLPATH( File ) ;
   , ID = RECNO() ; 
   , Ext = JUSTEXT( File ) ;
   , SubDir = JUSTPATH( File ) ; 
   , Key = File ;
   , ChTime = FDATE( ALLTRIM( File ), 1 )  ; 
 WHERE FILE(ALLTRIM( cPrj.File )) 
RETURN .T. 

*##############################################################################
FUNCTION PrjXmlRequery 

  ACTIVATE SCREEN 

  IF EMPTY( ALIAS() ) OR ! JUSTEXT( DBF() ) == "PJX"  
     IF TYPE("_VFP.ActiveProject.Name") # "C"
        WAIT WINDOW NOWAIT [Select project ...]
        MODI PROJECT ? SAVE 
        IF TYPE("_VFP.ActiveProject.Name") # "C"
           RETURN .F.
        ENDIF 
     ENDIF   
  ENDIF 
  PrjCurs()  
  IF ! USED("cPrj") 
     RETURN .F. 
  ENDIF

  DO UpdatePrjXML 
  
  DO GetPrjXML 
  RETURN .T. 


*##############################################################################
FUNCTION PrjRequery 
  * DO PrjRequery IN D:\vfplib\sys\PrjVwHook 

  ACTIVATE SCREEN 
  
  PrjCurs() 
  IF ! USED("cPrj") 
     RETURN .F. 
  ENDIF
  SELECT cPrj
  GO 1 
  
  IF FILE( [LIBPATH\GetList.prg] ) 
   
      PUBLIC goPrjUp AS GetLMultiDlg OF D:\VfpLib\Sys\GetList.prg 
      LOCAL arr1[1,4]
      arr1[1,1] = ALLTRIM( cprj.FullFile )

      goPrjUp =NEWOBJECT( [GetLMultiObj], [LIBPATH\GetList.prg], [] ;
                        , @arr1 ) 
  ENDIF 
  IF TYPE( [goPrjUp.gc1] ) = 'O'                    
      WITH goPrjUp 
           .gc1.Command1.Caption = '\<Modify'
           .gc1.Command2.Caption = '\<Close'
           .Caption='Updating scx/vcx'
           LOCAL lStr 
           lStr = "" 
           TEXT TO lStr NOSHOW 
               IF ! EMPTY( toForm.uReturnVal ) 
                  =ModiFiles(toForm.uReturnVal)
               ENDIF 
           ENDTEXT  
           .cButCmd = lStr
           .Show()  
      ENDWITH 
  ENDIF   

  DO UpdatePrjXML 
  
  DO GetPrjXML 
  RETURN .T. 

*##############################################################################
FUNCTION UpdatePrjXML   
  
  ACTIVATE SCREEN 
  
  ASSERT APP_VERSION OR FILE([LIBPATH\ViewVcx.prg])
  IF !APP_VERSION AND !FILE([LIBPATH\ViewVcx.prg])
     ERROR "!FILE " + [LIBPATH\ViewVcx.prg]  
     RETURN .F.
  ENDIF 
  
  #DEFINE OUTLINE ? 
  
  SELECT cPrj
  GO TOP 

  SCAN FOR INLIST(UPPER(cPrj.Ext), "VCX","SCX") ;
       AND FILE(ALLTRIM(cPrj.FullFile)) 
    
    SELECT 0 
 
    USE ( cPrj.FullFile )  AGAIN SHARED  
    
    IF ! EMPTY( DBF() ) AND FILE([LIBPATH\ViewVcx.prg]) 
    
        IF TYPE( [goPrjUp.lst1] ) = 'O'                    
           goPrjUp.lst1.AddItem( DBF() ) 
        ELSE 
           OUTLINE DBF() 
        ENDIF 
        
        DO ([LIBPATH\ViewVcx]) WITH ".NOSHOW" 
    ENDIF 
    
    USE 
  ENDSCAN     

  SCAN FOR INLIST(UPPER(cPrj.Ext), "PRG", "DDL", "XML") ;
       AND (FILE(FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP")) ;
            OR FILE(FORCEEXT(ALLTRIM(cPrj.FullFile), "BAK"))) 
     
     IF FILE(FORCEEXT(ALLTRIM(cPrj.FullFile), "BAK")) 
        ERASE FORCEEXT(ALLTRIM(cPrj.FullFile), "BAK") 
     ENDIF 
     IF FILE(FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP")) 
         TRY
           ERASE FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP") 
         CATCH
           * ok 
         ENDTRY  

         IF FILE(FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP")) 
             TRY
               COMPILE ALLTRIM(cPrj.FullFile) 
               ERASE FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP") 
             CATCH
               * ignore error   
               OUTLINE [Failed compile/erase ] + FORCEEXT(ALLTRIM(cPrj.FullFile), "FXP") 
             ENDTRY  
         ENDIF              
     ENDIF 
  ENDSCAN 

  RETURN .T.   
  
*##############################################################################
FUNCTION PrjEdit 
  * DO PrjEdit IN D:\vfplib\sys\PrjVwHook 
  
  IF ! FILE( [LIBPATH\GetList.prg] ) 
     RETURN .F.
  ENDIF 
  ACTIVATE SCREEN 
  PrjCurs() 
  IF ! USED("cPrj") 
     RETURN .F. 
  ENDIF
  
  PUBLIC goPrjUp AS GetLMultiDlg OF D:\VfpLib\Sys\GetList.prg 

  SELECT cPrj
  GO RECORD 1 
 
  LOCAL arr1[1,4]

  arr1[1,1] = ALLTRIM( cprj.FullFile )

  goPrjUp =NEWOBJECT( [GetLMultiObj], [LIBPATH\GetList.prg], [] ;
                    , @arr1 ) 
  IF TYPE( [goPrjUp.gc1] ) # 'O'                    
     RETURN .F.
  ENDIF 
  WITH goPrjUp 
       .gc1.Command1.Caption = '\<Modify'
       .Caption='Project ' + JUSTSTEM( cPrj.File ) 
       TEXT TO .cButCmd NOSHOW 
           IF ! EMPTY( toForm.uReturnVal ) 
              =ModiFiles( toForm.uReturnVal )
           ENDIF 
       ENDTEXT
       .Left = _SCREEN.Width - 300 
       .Top = 300 
       .Height = 400     
       .Resize() 
        
       .Show()  
  ENDWITH 
  
  ACTIVATE SCREEN 
  
  SELECT cPrj
  INDEX ON ChTime TAG ChTime 
  SET ORDER TO CHTIME DESCENDING 
  GO 1 

  LOCAL lcHome , lcFile 
  lcHome = JUSTPATH( cPrj.File ) 
  
  lcFile = ALLTRIM( cPrj.FullFile )   
  IF FILE( FORCEEXT( lcFile, "XML" ) )   
     lcFile = STRTRAN( FORCEEXT( lcFile, "XML" ), lcHome, "." ) 
     goPrjUp.lst1.AddItem( lcFile )   
  ENDIF 

  _SCREEN.LockScreen= .T. 

  GO TOP 
  SCAN FOR INLIST(UPPER(cPrj.Ext), "VCX","SCX", "PRG", "H" ) ;
       AND FILE( ALLTRIM( cPrj.FullFile ) )  
      
      lcFile = ALLTRIM( cPrj.FullFile )   
      lcFile = STRTRAN( lcFile, lcHome, "." ) 
      goPrjUp.lst1.AddItem( lcFile )

  ENDSCAN     
  _SCREEN.LockScreen= .F.   
  
  IF goPrjUp.lst1.ListCount > 0 
     goPrjUp.lst1.ListItemID = 2 
     goPrjUp.lst1.SetFocus() 
  ENDIF 
  RETURN .T. 
  
    
FUNCTION GetPrjXML 

IF ! USED( "cPrj" ) 
   RETURN .F.
ENDIF 
SET DATE TO ANSI 
SET CENTURY ON 
SET MARK TO [.]
SET POINT TO [.]
SET SEPARATOR TO [ ]
SET DECIMALS TO 2

SELECT cPrj
LOCATE FOR TYPE='H'
IF ! FOUND()
   ERROR [No cPrj.Type='H']
   RETURN .F.
ENDIF 
CREATE CURSOR PrjHead( HomeDir C(50), Name C(20) ;
      , version C(10), exe C(50) ;
      , exeversion c(10) ;
      , SizeKb N(10,3) ;
      , time C(20), xml M ) 

INSERT INTO PrjHead  (HomeDir , Name) ;
    VALUES( JUSTPATH( ALLTRIM( CPrj.File )) ;
          , JUSTSTEM( ALLTRIM( CPrj.File )) ;
          )

* SET PROCEDURE TO d:\Vfplib\sys\PrjVwHook ADDITIVE 

ASSERT TYPE( "_vfp.activeproject.Name" ) = 'C'

IF TYPE( "_vfp.activeproject.Name" ) = 'C'
   ASSERT ATC( _vfp.activeproject.Name, CPrj.File ) # 0 

   REPLACE IN PrjHead ;
       Time    WITH TTOC( _vfp.activeproject.BuildDateTime ) ;
       Version WITH _VFP.Activeproject.VersionNumber ;
       Exe WITH ADDBS(ALLTRIM( HomeDir )) ;
              + DEFAULTEXT( IIF( EMPTY( _vfp.activeproject.VersionProduct ) ;
                   , ALLTRIM(Name) ;
                   , ALLTRIM( _vfp.activeproject.VersionProduct ) ) ;
                 ,"EXE" ) 
                 
   IF FILE( ALLTRIM( PrjHead.Exe ))
       REPLACE IN PrjHead SizeKb ;
           WITH FileSize( ALLTRIM( PrjHead.Exe ) ) / 1000 
   ENDIF               
ENDIF 

SELECT IIF( type="H", "0";
          , IIF( LEFT(file,4)='..\.', "2" ;
          , "1" )) as PType ;
     , Type, Ext ;
     , PADR(Stem,20) as Name, File, 0000.000 AS SizeKb ;
 FROM CPRJ ORDER BY Ptype, File, Key ;
 INTO CURS PrjItem READWRITE 
 * Stem (=Name)  (not Key) 

UPDATE PrjHead SET exeVersion = FileVersion( ALLTRIM( PrjHead.Exe )) ;
  WHERE FILE(ALLTRIM(PrjHead.Exe)) 

UPDATE PrjItem SET SizeKb = FileSize( ALLTRIM( File ) ) / 1000 ;
 WHERE FILE(ALLTRIM(File)) 

ASSERT FILE("D:\Vfplib\Prg\UseF_Lite.prg") 
IF ! FILE("D:\Vfplib\Prg\UseF_Lite.prg")  
    RETURN .F. 
ENDIF 
SET PROCEDURE TO D:\Vfplib\Prg\UseF_Lite ADDITIVE 

SELECT PrjHead  
REPLACE IN PrjHead  XML WITH ""
LOCAL lcStr , lcStr2  
lcStr = GetXml("PrjHead", 'NOCLIP') 
GO TOP 
REPLACE IN PrjHead  XML WITH lcStr 

SELECT PrjItem 
lcStr2 = GetXml("PrjItem", 'NOCLIP') 

lcStr = lcStr + lcStr2 
lcStr = STRTRAN( lcStr ;
    , CHR(13) + CHR(10) + "</VFPData>"+ CHR(13) + CHR(10) ;
    + [<?xml version = "1.0" encoding="Windows-1257" standalone="yes"?>] ;
    + CHR(13) + CHR(10) + "<VFPData>", "" ) 

lcStr = STRTRAN( lcStr ;
            , "<VFPData>" ;
            , "<VFPData>" ;
            + CHR(13)+CHR(10) + SPACE(2) + "<Project>" ;
            )
            
lcStr = STRTRAN( lcStr ;
            , "</VFPData>" ;
            , SPACE(2) + "</Project>" ;
            + CHR(13)+CHR(10) + "</VFPData>" ;
            )

lcStr = STRTRAN( lcStr ;
            , "</ptype>" + CHR(13) + CHR(10) + "        " + "<type>" ;
            , "</ptype><type>" )
lcStr = STRTRAN( lcStr ;
            , "</type>"   + CHR(13) + CHR(10) + "        " + "<ext>" ;
            , "</type><ext>" )
     
lcStr = STRTRAN( lcStr, CHR(9), SPACE(4) )     
lcStr = STRTRAN( lcStr, CHR(9), SPACE(4) ) 

SELECT PrjHead  
REPLACE IN PrjHead  XML WITH lcStr

IF ! FILE( ALLTRIM( PrjHead.Name )+ ".xml" ) 
   =STRTOFILE( PrjHead.XML ;
            , ALLTRIM( PrjHead.Name )+ ".xml" ) 
   * _CLIPTEXT = PrjHead.XML 
ELSE 
   * _CLIPTEXT = FILETOSTR( ALLTRIM( PrjHead.Name )+ ".xml" ) 
   =STRTOFILE( PrjHead.XML ;
            , ALLTRIM( PrjHead.Name )+ ".xml") 
ENDIF 
IF FILE( ALLTRIM( PrjHead.Name )+ ".xml" )     && PrjHead.Stem 
   MODI COMM (ALLTRIM( PrjHead.Name )+ ".xml")  SAVE NOWAIT 
ENDIF                            
RETURN .T. 

*######################################################################################
FUNCTION FileVersion(tcFileName) 
*######################################################################################

 *TEST: DEBUGOUT "FileVersion " + TRANSFORM( tcFileName ) 
 ASSERT ALLTRIM(tcFileName)  = tcFileName 
 IF ! FILE(tcFileName) 
    RETURN "<no file>"
 ENDIF 
 LOCAL ARRAY aFL[11]
 LOCAL lcVersion 

 * Product version from array 
 =AGETFILEVERSION(aFL, tcFileName)
 lcVersion = aFL[ 11 ]
 IF TYPE([lcVersion]) = 'L'
    lcVersion = ""
 ENDIF 
 lcVersion = TRANSF(lcVersion)
 RETURN  lcVersion 

*######################################################################################
FUNCTION FileSize( tcFileName ) 
*######################################################################################

 *TEST: DEBUGOUT "FileSize " + TRANSFORM( tcFileName ) 
 IF ! FILE( tcFileName ) 
    RETURN 0 
 ENDIF 
 LOCAL laInfo[1,10] 
 LOCAL lnCnt , lnSize 
  
 laInfo[1, 1] = ""
 lnSize = 0 
 lnCnt = ADIR(laInfo, tcFileName  )
 IF lnCnt = 1 AND TYPE( "laInfo[ 1, 2 ]" ) = 'N'
    lnSize = laInfo[ 1, 2 ] 
 ENDIF 
 RETURN lnSize 
    

*######################################################################## 
FUNCTION SRC_RClick( toButton, toForm )

    IF ! toForm.NodeFile()  
       RETURN .F.
    ENDIF 
    LOCAL lcFileSrc 
    lcFileSrc = toForm.N_File + ".prg" 
    IF ! FILE( lcFileSrc ) 
       RETURN .F.
    ENDIF 
    MODI COMM (lcFileSrc) SAVE NOWAIT 


*######################################################################## 
DEFINE CLASS LL_FORM AS form

    Top = -1
    Left = 0
    Height = 118
    Width = 375
    DoCreate = .T.
    ShowTips = .T.
    Caption = "L_Form"
    FontName = "Tahoma"
    
    Visible = .T. 
    KeyPreview = .T.
    noldHeight = 0
    noldWidth = 0
    cinifilename = ("App.Ini")
    isrestoreposition = .T.
    isignoreerrors = .F.
    Last_WOnTop = ""

    uRetVal = .T.
    MinButton = .F. 
    MaxHeight = 1200 
    MaxWidth = 500

    *######################################################################## 
    PROCEDURE RefreshForm
        WITH This
          .LockScreen = .T.
          .Refresh()
          .LockScreen = .F.
        ENDWITH


    *######################################################################## 
    PROCEDURE onError
        LPARAMETERS nError, cMsg, cMethod, nLine

        LOCAL oObject AS Object 
        oObject = This

        LOCAL llHandledError, lcMessage, lnAnswer
        LOCAL laError[ 7 ]    && 7= AERRORARRAY
                      
        LOCAL nI, cPrg
            
            llHandledError = .T. 
            lcMessage = MESSAGE()
            
            =AERROR(laError)

            IF TYPE( "oObject.IsIgnoreErrors" ) = "L" AND oObject.IsIgnoreErrors
               RETURN .T.
            ENDIF

            *-- Loads the laError array with error information ------------------
            ?? CHR(7)
            lcMessage = "Error " + IIF( TYPE( "nError" ) = "N" ;
                                    , ALLT( STR( nError )), '' ) ;
                                    + " : "  + lcMessage
            
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
                lcMessage = lcMessage + " function "+;
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
                             
                    RETURN .T.      && if "ACTIVATE" of "REFRESH" then out 
                 ENDIF
                ENDIF
             ENDIF             
            
            IF TYPE( "goApp.IsDebugMsg" ) = "L"   ;
                AND goApp.IsDebugMsg                 && if debug msg 
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
    PROCEDURE RestoreProp
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
                CASE DIRECTORY( [VFPLIB_PATH\] )    
                   .cIniFileName = ADDBS( [VFPLIB_PATH\] ) ;
                                 + JUSTFNAME( .cIniFileName )
              ENDCASE
              DEBUGOUT .cIniFileName
              
             .nOldHeight = .Height
             .nOldWidth =  .Width
             RETURN .uRetVal 
        ENDWITH 


    *######################################################################## 
    FUNCTION Activate 
      This.Last_WOnTop = WONTOP() 
      RETURN .T. 


    *######################################################################## 
    FUNCTION Deactivate 
      ACTIVATE SCREEN 
      RETURN .T. 

    *######################################################################## 
    PROCEDURE Destroy
        This.Deactivate() 

    *######################################################################## 
    PROCEDURE Init
        WITH This
              * .RestoreWindowPos()

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
    PROCEDURE Externalinit

    PROCEDURE EveShow

    PROCEDURE EveResize 

ENDDEFINE
**************************************************

*######################################################################## 
DEFINE CLASS PrjVwFrame2 AS L_EmptyFrame OF LCtrLib.prg 
*######################################################################## 

    TabStyle = 1  
    ErasePage = .T.
    
    PageCount = 0 
    ActivePage = 0
    Width = 160
    Height = 79
    Visible = .T. 
    
    uRetVal = .T.
    calignment = "0000"
    
    nState = .F.  
    nSaveHeight = 0 
    
    ADD OBJECT Page1 AS PrjPage WITH ;
        Name = 'Page1' ;
        , Caption = "Prj" 

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
    

ENDDEFINE
*-- EndDefine: LL_pageframe
**************************************************

  * src=http://blogs.msdn.com/calvin_hsia/archive/2005/01/21/358339.aspx#DecodeTimeStamp 
  * see http://msdn.microsoft.com/library/en-us/sysinfo/base/filetimetodosdatetime.asp 
  FUNCTION DecodeTimeStamp(nTimestamp as Number) as Datetime 
      
  LOCAL nDate, nTime, nYear, nMonth, nDay, nHr, nMin, nSec 
  nDate=BITRSHIFT(nTimestamp,16)
  nTime=BITAND(nTimestamp,2^16-1)

  nYear=BITAND(BITRSHIFT(nDate,9),2^8-1)+1980
  nMonth=BITAND(BITRSHIFT(nDate,5),2^4-1)
  nDay=BITAND(nDate,2^5-1)

  nHr=BITAND(BITRSHIFT(nTime,11),2^5-1)
  nMin=BITAND(BITRSHIFT(nTime,5),2^6-1)
  nSec=BITAND(nTime,2^5-1)

  RETURN DATETIME(nYear,nMonth,nDay,nHr,nMin,nSec)

#DEFINE EOF1 
