using System;
using System.Runtime.InteropServices;
using VisualFoxpro;

namespace VfpProj
{

    [Guid("c155b373-563f-433f-8fcf-18fd98100003")]
    [ClassInterface(ClassInterfaceType.AutoDispatch), ProgId("VfpProj.CsObj")]
    [ComVisible(true)]
    public sealed class CsObj : _Events
    {
        public static int cnt = 0;
        public CsObj()
        {
            cnt++;
        }

        public string Name { get { return "VfpProj.CsObj." + cnt.ToString(); } }
        public FoxApplication App { get { return FoxCmd.app as FoxApplication; } }

        public IntPtr hWnd
        {
            get { return FoxCmd.hWnd; }
            set
            {
                FoxCmd.hWnd = value;
            }
        }

        [ComVisible(true)]
        public _Form Form(FoxApplication app)
        {
            FoxCmd.app = app;
            if (FoxCmd.Attach())
                FoxCmd.ShowForm(FoxCmd.form.Form);

            return FoxCmd.form;
        }

    }

}
