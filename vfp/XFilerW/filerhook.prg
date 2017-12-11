* filerhook.prg
*
*Revision 1.2  2006/05/10 06:33:20  andriusk
*recompile, v3 class
*##############################################################################
LPARAMETERS tcExtra1, tcExtra2

#INCLUDE setv.h 
#DEFINE ROOTDIR "d:\webstack\vsix\vfpproj\vfp\xfilerw\"

DO ShowForm WITH tcExtra1, tcExtra2

FUNCTION ShowForm(tcExtra1, tcExtra2) 

PUBLIC gcHookPrg as string

gcHookPrg = ROOTDIR + "filerhook.prg"
SET PROCEDURE TO (gcHookPrg) ADDITIVE 
SET CLASSLIB  TO (ROOTDIR + "lib.vcx")

* MODIFY CLASS frmparameters OF lib.vcx
ASSERT FILE("FilerW.scx")

PUBLIC filerw  as Form

DO FORM (ROOTDIR + "filerw.scx") Name filerw NOSHOW

filerw.HookSet = gcHookPrg
filerw.Show()

FUNCTION GetMessage(tcMsgText, tnDlgType, tcTitle) 

* MESSAGEBOX(cMsgTExt, nDlgType, cTitle, nTimeOut)
=MESSAGEBOX(tcMsgText, tnDlgType, tcTitle)

FUNCTION Brow(tcExtra) 


FUNCTION FSet_Init(toFormSet)
WITH toFormSet
    .cOldDir = FULLPATH( CURDIR() )
    
    .FilerW.Caption = "FilerW"    
    .cCurDir = FULLPATH( CURDIR() )
    .isEdit = .F.
    .cExt = "*.prg;*.vcx;*.scx"

    IF NOT USED( "TmpFil" )
      RETURN .F.
    ENDIF

    ON KEY LABEL Alt+F10 SUSPEND
    
    SELECT TmpFil
    SET ORDER TO TAG By_Ext
    .FilerW.chbExt.Value = 1
    .FilerW.chbName.Value = 0
    
    .GridProperties()
    .FilerW.grdFiles.GridSetUp(toFormSet)

    .GetDir( .F., .F. )
        
ENDWITH
RETURN .T.

FUNCTION FSet_Load(toFormSet)

IF TYPE( "_SCREEN.oFilerW.Name" ) = "C"
   _SCREEN.oFilerW = .NULL.
ENDIF
_SCREEN.AddProperty("oFilerW", toFormSet)

SET CENTURY ON
SET DELETED ON
SET SAFETY OFF
SET TALK OFF
SET DATE TO ANSI

toFormSet.cIniDir = "D:\Prg\"
IF NOT FILE( (toFormSet.cIniDir +"Lib.vcx" )  )
   cLib = FULLPATH( LOCFILE( "Lib.vcx", "vcx" ) )
   toFormSet.cIniDir = LEFT( cLib, RAT("\", cLib ) )
ENDIF
IF NOT FILE( (toFormSet.cIniDir +"Lib.vcx" )  )
   WAIT WINDOW "Error: not found Lib.vcx file"
   NODEFAULT
   RETURN .F.
ENDIF

SET CLASSLIB TO (toFormSet.cIniDir +"Lib")
toFormSet.CreateTmp("TmpFil")
RETURN .T. 


* DO FSET_Edit 
FUNCTION FSET_Edit(toFormSet AS FormSet)

WITH toFormSet 

 DO CASE
   CASE TmpFil->nType = 10
    
     DO CASE
       CASE ALLT(LOWER(TmpFil->F_Ext)) = ".dbf"
          
          SELECT 0 
          USE (ALLT(TmpFil->F_Name))  SHARED NOUPDATE 
          
          DO d:\prg\brow 

       CASE ALLT(LOWER(TmpFil->F_Ext)) = ".scx"

          *EDITSOURCE(cFileName, nLineNo[, cClassName, cProcName)]
          IF NOT EMPTY( TmpFil->F_Method )
              KEYBOARD "{Ctrl+F2}MODI FORM " ;
                  + ALLT(TmpFil->F_Name) + " METH "+ ALLT(TmpFil->F_Method ) ;
                  + " {ENTER}"
          ELSE
              KEYBOARD "{Ctrl+F2}MODI FORM " ;
                  + ALLT(TmpFil->F_Name) + "{ENTER}"
          ENDIF
          
       CASE ALLT(LOWER(TmpFil->F_Ext)) = ".vcx"

          KEYBOARD "{Ctrl+F2}MODI CLASS ? OF " ;
                  + ALLT(TmpFil->F_Name) + "{ENTER}"

      **CASE NOT .IsEdit    &&  TmpFil->nLine > 0 AND NOT IsEdit
       OTHERWISE
       
          CLEAR TYPEAHEAD
          SET SYSMENU TO DEFAULT
          **ON KEY LABEL F10 ACTIVATE MENU _MSYSMENU 
          ACTIVATE SCREEN
          IF TmpFil->nLine > 0
             **SET MESSAGE TO "   "+ALLT(TmpFil->F_Name) ;
                  + **      " Found line:"+ALLT(STR( TmpFil->nLine)) 
             **WAIT WINDOW NOWAIT   "Go Line: "+ALLT(STR( TmpFil->nLine)) 
             cOldFilerCaption = toFormSet.FilerW.Caption
             toFormSet.FilerW.Caption = toFormSet.FilerW.Caption + "  " ;
                  + "   "+ALLT(TmpFil->F_Name) ;
                  + " Found line:"+ALLT(STR( TmpFil->nLine)) 
          ENDIF                   
          
          ACTIVATE WINDOW Command
                      
          ** KEYBOARD  ;
                IIF( TmpFil->nLine > 0, "{Ctrl+F2}*" ;
                  + ALLT(STR( TmpFil->nLine))+ "  "+ ALLT(TmpFil->F_Name)  ;
                  + "{ENTER}","" ) ;
                  + "{Ctrl+F2}MODI COMM "  ;
                  + (ALLT( TmpFil->F_Name ) + TmpFil->F_Ext ) ;
                  + "{ENTER}" ;
                  + IIF( TmpFil->nLine > 0,;
                "{Alt+E}N", ;
                "" )

          IF TmpFil->nLine = 0
              KEYBOARD "{Ctrl+F2}MODI COMM "  ;
                  + (ALLT( TmpFil->F_Name ) + TmpFil->F_Ext) ;
                  + "{ENTER}"
          ELSE 
              *EDITSOURCE(cFileName, nLineNo)
              KEYBOARD "{Ctrl+F2}EDITSOURCE(" ;
                  + "[" + ALLTRIM(TmpFil->F_Name) + ALLTRIM(TmpFil->F_Ext) + "]" ; 
                  + [, ] + ALLT(STR( TmpFil->nLine)) ; 
                  + "){ENTER}"
          ENDIF                   
          .isEdit = .T.
    ENDCASE
   
  CASE INLIST( TmpFil->nType, 3, 5 )
  
    .GetDir( .F., .T.,  ALLT(TmpFil->F_Name) )  
    
 ENDCASE
 toFormSet.FilerW.grdFiles.SetFocus()

ENDWITH
RETURN


FUNCTION FSet_BrowF(toFormSet, toButton)

* MESSAGEBOX([TODO D:\Prg\BrowF]) 


FUNCTION FSet_ClassView(toFormSet, cFile)

**WAIT WINDOW "TODO classview( "+ cFile +" )" 
MESSAGEBOX([TODO BrowF ] + cFile) 
* DO (toFormSet.cIniDir + "browF" ) WITH (cFile)

* thisformset.FindMode()
* -> .FindFiles()