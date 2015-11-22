* Test_ActiveX

PUBLIC f as Form 

f = CREATEOBJECT("Form")

* [ProgId("ADendrite.OurActiveX"), Guid("121C3E0E-DC6E-45dc-952B-A6617F0FAA32")]
* ole1 = NEWOBJECT("olecontrol", "ADendrite.OurActiveX") && , "{121C3E0E-DC6E-45dc-952B-A6617F0FAA32}")
m.f.AddObject("ole1", "olecontrol", "ADendrite.OurActiveX") && , "{121C3E0E-DC6E-45dc-952B-A6617F0FAA32}")
m.f.ole1.Visible = .T. 

m.f.Show()





