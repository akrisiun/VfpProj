* $Id: prjvwItem.PRG,v 1.3 2007/07/24 11:53:28 andriusk Exp $
* Prj Vw Items routines 
* $Log: prjvwItem.PRG,v $
* Revision 1.3  2007/07/24 11:53:28  andriusk
* Nodes_AddFile, .curItem properties
*
* Revision 1.2  2007/05/11 08:20:11  andriusk
* scx failu metodai
*
* Revision 1.1  2006/07/05 15:02:04  andriusk
* PW_NodeFile ikelimas, LIBPATH define keitimas, Requery erase FXP
*
*#############################################################

DO PrjVwHook 

#DEFINE LIST_WEBEXT "HTML", "HTM", "CSS", "ASPX", "XSLT"
FUNCTION PW_NodeFile(toForm, tcKey)

    LOCAL lnCnt, lnNodeCnt, lnI    
    LOCAL lcKeyPar, lcKey, lcText 

    lcKeyPar = tcKey 
    IF INLIST(toForm.N_Ext, "PRG", "DDL", "XML", LIST_WEBEXT, "SCX", "VCX") ;
       AND !EMPTY(toForm.N_File) AND !FILE(toForm.N_File) ;
       AND !EMPTY(toForm.N_Dir)

       toForm.N_File = ADDBS(toForm.N_Dir) + JUSTFNAME(toForm.N_File)
       ASSERT FILE(toForm.N_File) 
    ENDIF 

    DO CASE
       CASE INLIST(toForm.N_Ext, "PRG", "DDL", "XML", LIST_WEBEXT) 
          
          IF toForm.N_Children = 0   
              LOCAL ARRAY laPCodes[1]
              RELEASE laPCodes 

               lnCnt = APROCINFO(laPCodes, toForm.N_File) 
               * Column1 – Doc View content / Column2 – line
               * Column3 – type / Column4 – indentation
               lnNodeCnt = .Nodes.Count
               FOR lnI = 1 TO lnCnt
                     lcKey = toForm.N_Key + "_PRC" + TRANSF( lnI ) ;
                                 + "_L"+ TRANSFORM( laPCodes[ lnI, 2 ]) 
                                 
                     lcText = ALLTRIM(laPCodes[ lnI, 1 ]) 
                     IF lcText == [IF .F.] OR lcText == [ENDIF]
                        LOOP         && ignore #IF, #ENDIF 
                     ENDIF 
                     #DEFINE NODEADD_PRG_FUNC 
                     .Nodes.Add(lcKeyPar, 4, lcKey, lcText)
                     IF lnNodeCnt = .Nodes.Count
                        EXIT 
                     ENDIF
              ENDFOR                                              
          ENDIF 
          
       CASE INLIST( toForm.N_Ext, "SCX")

          IF toForm.N_Children = 0 ;
             AND FILE(toForm.N_File + ".prg")   

              LOCAL ARRAY laPCodes[1]
              RELEASE laPCodes 
              LOCAL lcDefine

               lnCnt = APROCINFO(laPCodes, toForm.N_File + ".prg") 
               * Column1 – Doc View content / Column2 – line
               * Column3 – type / Column4 – indentation
               lnNodeCnt = .Nodes.Count
               lcDefine = ""               
               
               FOR lnI = 1 TO lnCnt
                     lcKey = toForm.N_Key + "_PRC" + TRANSF( lnI ) ;
                                 + "_L"+ TRANSFORM( laPCodes[ lnI, 2 ]) 
                                 
                     lcText = ALLTRIM(laPCodes[ lnI, 1 ]) 
                     
                     IF lcText == [IF .F.] OR lcText == [ENDIF]
                        LOOP         && ignore #IF, #ENDIF 
                     ENDIF 
                     IF ATC([ AS ], lcText) > 0 
                        lcDefine  = STREXTRACT(lcText, [], [ AS ])
                     ENDIF                   
                     IF !EMPTY(lcDefine) ;
                        AND LEFT(lcText, LEN(lcDefine) + 1) = lcDefine + [.] 
                        lcText = [METH ] + SUBSTR(lcText, LEN(lcDefine) + 2)
                     ENDIF 

                     #DEFINE NODEADD_PRG_FUNC 
                     .Nodes.Add(lcKeyPar, 4, lcKey, lcText)
                     IF lnNodeCnt = .Nodes.Count
                        EXIT 
                     ENDIF
              ENDFOR                                              
          ENDIF 
          
       CASE INLIST( toForm.N_Ext, "VCX")

          IF toForm.N_Children = 0   
          
                LOCAL ARRAY laCls[1]
                LOCAL lcLib 
                lcLib = toForm.N_File
                
                lnCnt = AVCXCLASSES(laCls, lcLib) 
                ASORT( laCls ) 
                lnNodeCnt = .Nodes.Count
                FOR lnI = 1 TO lnCnt
                     lcKey  = toForm.N_Key + "_CLS"+ TRANSF(lnI)
                     lcText = laCls[ lnI, 1 ] 

                     #DEFINE NODEADD_VCX_CLS 
                     .Nodes.Add(lcKeyPar, 4, lcKey, lcText)
                     IF lnNodeCnt = .Nodes.Count
                        EXIT 
                     ENDIF
               ENDFOR                                              
         ENDIF 
         
    ENDCASE