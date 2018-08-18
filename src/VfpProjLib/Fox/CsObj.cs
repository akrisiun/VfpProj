using System;
using System.Runtime.InteropServices;
using System.Runtime.Remoting;
using System.ComponentModel;
using System.Diagnostics;
using System.Text;
using VfpProj;

namespace Vfp
{
    public static class StrExt
    {
#if NET40
        public static bool IsNullOrWhiteSpace(this string str)
        {
            return (str == null || str.Length == 0 || str.TrimEnd().Length == 0);
        }
#endif
    }

    internal class CsObj : CsObj20 { }

    [ProgId("VfpProj.CsObj"), Guid("c155b373-563f-433f-8fcf-18fd98100013")]
    [ClassInterface(ClassInterfaceType.AutoDispatch)]
    [ComVisible(true)]
    [Serializable]
    // [DataContract]
    public class CsObj20 : _Events20, IComponent, IDisposable
#if DLL
            , VfpProj.UnsafeNativeMethods.IViewObject
#endif
    {
        static CsObj20() { }
        public static CsObj20 Instance {
            [DebuggerStepThrough] get; private set; }
        public Exception LastError {
            [DebuggerStepThrough] get; set; }

        public bool IsLockForm { get; set; }

        public static int cnt = 0;
        public CsObj20()
        {
            IsLockForm = false;
            Instance = this;
            cnt++;
        }

        public CsObj20 GetInstance() { return this; }

        //[DataMember]
        public _Form20 CmdForm {
            get { return FoxCmd.FormObj as _Form20; }
            set { FoxCmd.SetFormObj(value as _Form20 ?? FoxCmd.FormObj); }
        }

        // [DataMember]
        public string Name { get { return "VfpProj.CsObj." + cnt.ToString(); } set { } }

        
        public IFoxApplication App {
            // [NonSerialized]
            // get { return FoxCmd.App as FoxApplication; }
            get; set;
        }

        //public CsApp CSApp {
        //    // [NonSerialized]
        //    get { return CsApp.Instance; } }

        // [DataMember]
        public IntPtr hWnd {
            get { return FoxCmd.hWnd; }
            set {
                FoxCmd.hWnd = value;
            }
        }

        [ComVisible(true)]
        public _Form20 Form(VfpProj.FoxApplication app)
        {
            FoxCmd.SetApp(app);
            if (FoxCmd.Attach())
            {
                //CsApp.Ref();
                //if (FoxCmd.FormObj.Form != null || CsApp.Instance.Window != null)
                //    FoxCmd.ShowForm(FoxCmd.FormObj.Form ?? CsApp.Instance.Window);
                //else
                //    FoxCmd.NewForm();

                //if (!FoxCmd.FormObj.IsBound())
                //    FoxCmd.FormObj.Form.ReLoad();
            }

            return FoxCmd.FormObj;
        }

        [ComVisible(true)]
        public _Form20 Show(object appObj)
        {
            var form = FoxCmd.FormObj;
            var app = appObj as VfpProj.FoxApplication;

            try
            {
                //if (form == null || form.Form == null || !form.IsBound())
                //    form = Form(app) as CsForm;

                //var wpfForm = form.Form;

                CsObj20.Instance.IsLockForm = true;
                var hWnd = (IntPtr)app.hWnd;
                
                CsObj20.Instance.IsLockForm = false;
            }
            catch (Exception ex) {
                if (form != null) form.LastError = ex;
            }

            return form;
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

        public string SetPtr(object ptr)
        {
            if (ptr as ObjectHandle == null)
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

        //public string SetFoxObj(IFoxObjects ptr)
        //{
        //    return "SetFoxObj =" + (ptr == null ? " null " : ptr.ToString());
        //}


        //public string SetFoxForms(IFoxForms ptr)
        //{
        //    return "SetFoxForms: " + (ptr == null ? " null " : ptr.ToString());
        //}


        //public string SetProjects(IFoxProjects ptr)
        //{
        //    return "SetProjects: " + (ptr == null ? " null " : ptr.ToString());
        //}


#if NET40X
        public string GetXml(string command)
        {
            return command.IsNullOrWhiteSpace() ? string.Empty :
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
#endif

        public string SetProperty(IntPtr ptr, string property)
        {
            return "SetProperty: Ptr =" + (ptr == IntPtr.Zero ? " 0 " : ptr.ToString());
        }

        public void Dispose() { Instance = null; }
        ISite IComponent.Site { get; set; }

#pragma warning disable 0067
        public event EventHandler Disposed;

#if DLL

        public int Draw(int dwDrawAspect, int lindex, IntPtr pvAspect, UnsafeNativeMethods.tagDVTARGETDEVICE ptd, 
            IntPtr hdcTargetDev, IntPtr hdcDraw, UnsafeNativeMethods.COMRECT lprcBounds, 
            UnsafeNativeMethods.COMRECT lprcWBounds, IntPtr pfnContinue, int dwContinue)
        {
            throw new NotImplementedException();
        }

        public int GetColorSet(int dwDrawAspect, int lindex, IntPtr pvAspect, 
            UnsafeNativeMethods.tagDVTARGETDEVICE ptd, IntPtr hicTargetDev, UnsafeNativeMethods.tagLOGPALETTE ppColorSet)
        {
            throw new NotImplementedException();
        }

        public int Freeze(int dwDrawAspect, int lindex, IntPtr pvAspect, IntPtr pdwFreeze)
        {
            throw new NotImplementedException();
        }

        public int Unfreeze(int dwFreeze)
        {
            throw new NotImplementedException();
        }

        public void SetAdvise(int aspects, int advf, System.Runtime.InteropServices.ComTypes.IAdviseSink pAdvSink)
        {
            throw new NotImplementedException();
        }

        public void GetAdvise(int[] paspects, int[] advf, System.Runtime.InteropServices.ComTypes.IAdviseSink[] pAdvSink)
        {
            throw new NotImplementedException();
        }
#endif


    }

}
