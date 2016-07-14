* PrjViewMain
IF FILE( "D:\Vfplib\sys\PrjVw.fxp" ) ;
   OR FILE( "D:\Vfplib\sys\PrjVw.prg" ) 
   
   DO D:\Vfplib\sys\PrjVw
   
   IF TYPE( [goPrj( ALEN( goPrj, 1 ) ).Name] ) = 'C'
       RETURN .T.
   ENDIF 
ELSE 
   DO PrjVw2            && project ... 
ENDIF 
IF FILE( PROGRAM()  ) 
   RELEASE PROCEDURE PROGRAM()  
ENDIF 
RETURN .T. 

