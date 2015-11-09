*$Id: filerw.prg,v 1.2 2006/05/10 06:33:20 andriusk Exp $
* FileW caller 
*$Log: filerw.prg,v $
*Revision 1.2  2006/05/10 06:33:20  andriusk
*recompile, v3 class
*
*##############################################################################
LPARAMETERS tcExtra1, tcExtra2

DO ShowForm WITH tcExtra1, tcExtra2 IN FilerHook 

* COPY FILE filerw.app to \vfplib\filerw.app