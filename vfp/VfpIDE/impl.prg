* Impl


public o as Session 
o = NEWOBJECT("myclass", "impl.prg")



* / ADedrite.OurActiveX
* "68BD4E0D-D7BC-4cf6-BEB7-CAB950161E79")]
* c:\bin\ActiveXTest.dll"
* ADendrite.OurActiveX

DEFINE CLASS myclass AS session
IMPLEMENTS ControlEvents IN "ADendrite.OurActiveX"

a = .NULL.

FUNCTION Bind 

  public a
  a  = NEWOBJECT("ADendrite.OurActiveX")
  this.a = a;
  
  =EVENTHANDLER(a, this)  


FUNCTION ControlEvents_OnClose(lcUrl as string)

MESSAGEBOX("SVFP onClose" + TRANSFORM(lcUrl)) 

FUNCTION ControlEvents_OnFinish(lcUrl as string)

MESSAGEBOX("SVFP OnFinish" + TRANSFORM(lcUrl)) 

ENDDEFINE