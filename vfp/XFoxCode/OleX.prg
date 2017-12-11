FUNCTION OleX     

*-- Declare DLL functions
DECLARE INTEGER CoCreateGuid ;
    IN Ole32.DLL ;
    STRING @pGuid
DECLARE INTEGER StringFromGUID2 ;
    IN Ole32.DLL ;
    STRING rguid, STRING @lpsz, INTEGER cchMax

    * oX = createobjectex('{008B6010-1F3D-11D1-B0C8-00A0C9055D74}','MachineName')
*!*        oForm = CREATEOBJECTEX("{c155b373-563f-433f-8fcf-18fd98100002}", "localhost")
*!*        oForm = CREATEOBJECTEX("{c155b373-563f-433f-8fcf-18fd98100002}", "localhost")
*!*        Guid("c155b373-563f-433f-8fcf-18fd98100014")]
*!*    c155b373-563f-433f-8fcf-18fd98100004

RETURN .T.

* DEFINE CLASS MyBooks AS CUSTOM OLEPUBLIC
* IMPLEMENTS Publisher IN "c:\sample4\Publisher.VB\BooksPub.dll"

DEFINE CLASS CSEvents as Custom 
  oleclass = "VfpProj.Events"
ENDDEFINE
  
* a = NEWOBJECT("VfpForm1", "d:\Beta\start.prg")
DEFINE CLASS VfpForm1 AS CUSTOM OLEPUBLIC 
  * [Guid("c155b373-563f-433f-8fcf-18fd98100002")]
  *IMPLEMENTS _Form IN "D:\Beta\VfpProj\Lib\VfpProj.dll"
  IMPLEMENTS _Form IN {c155b373-563f-433f-8fcf-18fd98100002}
  
  *IMPLEMENTS _Form IN {c155b373-563f-433f-8fcf-18fd98100014}#1.0
  * IMPLEMENTS IDict1 IN {04BCEF93-7A77-11D0-9AED-CE3E5F000000}#1.0


ENDDEFINE

DEFINE CLASS VfpForm2 as OLECONTROL
  oleclass = "VfpProj.Form"
ENDDEFINE

* //_Events [Guid("c155b373-563f-433f-8fcf-18fd98100001")]
* //_Form [Guid("c155b373-563f-433f-8fcf-18fd98100002")]
* //_Startup [Guid("c155b373-563f-433f-8fcf-18fd98100002")]
