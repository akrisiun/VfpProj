using System;
using System.Runtime.InteropServices;
using System.Runtime.Remoting;
using System.ComponentModel;
using System.Text;
using System.Xml.Linq;
using VisualFoxpro;

namespace VfpProj
{

    [Guid("c155b373-563f-433f-8fcf-18fd98100013")]
    [ClassInterface(ClassInterfaceType.AutoDispatch), ProgId("VfpProj.CsObj")]
    [ComVisible(true)]
    public sealed class CsObj : _Events, IComponent, IDisposable
    {
        public static int cnt = 0;
        public CsObj()
        {
            cnt++;
        }

        public void Dispose() {}
        ISite IComponent.Site { get; set; }
#pragma warning disable 0067
        public event EventHandler Disposed;

        public _Form CmdForm { get { return FoxCmd.FormObj as _Form; } }

        public string Name { get { return "VfpProj.CsObj." + cnt.ToString(); } }
        public FoxApplication App { get { return FoxCmd.App as FoxApplication; } }

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
            FoxCmd.SetApp(app);
            if (FoxCmd.Attach())
                FoxCmd.ShowForm(FoxCmd.FormObj.Form);

            return FoxCmd.FormObj;
        }

        public string DoCmd(string cmd)
        {
            return "DoCmd " + (cmd ?? "");
        }

        public string Eval(string expr)
        {
            return "Eval " + (expr ?? "");
        }

        // Marshal.GetHINSTANCE
        // int Marshal.GetLastWin32Error()
        //[DllImportAttribute("user32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        //public static extern int MessageBox(IntPtr hwnd, String text, String caption, uint type);
        // Type GetTypeFromCLSID(Guid clsid
        // net451
        // public static IntPtr OffsetOf<T>(string fieldName

        // public static string PtrToStringAuto(IntPtr ptr

        public IntPtr EvalPtr(string expr)
        {
            var build = new StringBuilder("EvalPtr " + (expr ?? ""));
            IntPtr refStr = Marshal.StringToBSTR(build.ToString());

            return refStr;
        }

        public string SetPtr(dynamic ptr)
        {
            if (ptr == null)
                return "SetPtr null";

            ObjectHandle handle = ptr as ObjectHandle;
            if (handle == null)
                return "setPtr ObjectHandel == null";
            var nowrap = handle.Unwrap();
            var type = nowrap.GetType();
            return type.ToString();
        }

        //Type unknown = ((ObjectHandle)tmp).Unwrap().GetType();
        //By the way, this is a little confusing because if you call Activator.CreateInstance on a type in your current assembly...
        //Activator.CreateInstance(typeof(Foo))

        //DECLARE @ID uniqueidentifier
        //  SET @ID = NEWID()

        public string SetIntPtr(IntPtr ptr)
        {
            return "Ptr =" + (ptr == IntPtr.Zero ? " 0 " : ptr.ToString());
        }

        public string SetFoxObj(IFoxObjects ptr)
        {
            return "SetFoxObj =" + (ptr == null ? " null " : ptr.ToString());
        }


        public string SetFoxForms(IFoxForms ptr)
        {
            return "SetFoxForms: " + (ptr == null ? " null " : ptr.ToString());
        }


        public string SetProjects(IFoxProjects ptr)
        {
            return "SetProjects: " + (ptr == null ? " null " : ptr.ToString());
        }


        public string GetXml(string command)
        {
            return string.IsNullOrWhiteSpace(command) ? string.Empty :
                   XElement.Parse(command).ToString();
        }

        public XElement LoadXml(string command)
        {
            string cmd = "LoadXml: " + (command ?? "");
            if (command == null || !command.Contains("<"))
                return null;

            XElement elem = XElement.Parse(command);
            return elem;
        }


        public string SetProperty(IntPtr ptr, string property)
        {
            return "SetProperty: Ptr =" + (ptr == IntPtr.Zero ? " 0 " : ptr.ToString());
        }

    }

}
