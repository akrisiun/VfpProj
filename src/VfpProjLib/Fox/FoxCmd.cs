using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using Vfp;
using VfpProj.Com;
using VisualFoxpro;

namespace VfpProj
{
    public static class FoxCmd
    {
        #region Form Attach, Hwnd, AssignForm

        public static bool Attach(bool secondTime = false)
        {
            if (secondTime)
                CsObj20.Instance.IsLockForm = true;

            Exception err = null;
            try
            {
                // dynamic 
                // VisualFoxpro.Application 
                var objApp = App;
                if (App == null) // && !VfpProj.CsApp20.Instance.Window.IsStart)
                {
                    //if (Vfp.Startup.Instance.App != null)
                    //    App = Vfp.Startup.Instance.App as IFoxApplication;
                    var vfpDLL = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "vfp8r.dll");

                    Type objType1 = null;
                    object obj1;

                    if (App == null)
                    {
                        try
                        {
                            // objType1 = Type.GetTypeFromProgID("VisualFoxpro.FoxApplication");
                            objType1 = Type.GetTypeFromCLSID(VfpGUID.FoxAppClass, server: null, throwOnError: false);

                            obj1 = Activator.CreateInstance(objType1);
                            var refObj = obj1 as MarshalByRefObject;
                            App = FoxApplication.Wrap(obj1);
                        }
                        catch (Exception ex)
                        {
                            // Retrieving the COM class factory for component with CLSID {00A19612-D8FC-4A3E-A95F-FEA211444BF7}
                            // COM class factory failed due to the following error: 80040154.
                            err = ex;
                        }
                        if (App == null)
                        {
                            FoxApplication App1 = null; // AppMethods.CreateFoxApp() as VisualFoxpro.Application;
                            if (App1 != null)
                            {
                                try
                                {
                                    App1.Caption = "Loading";
                                    object obj = CsObj20.Instance;
                                    var SetVar1 = App1.GetType().GetMethod("SetVar");

                                    if (SetVar1 != null)
                                        App.SetVar("ocs", obj);
                                    objApp = App1;
                                    App1.Visible = true;
                                }
                                catch (Exception ex)
                                {
                                    // memory corrupt
                                    err = ex.InnerException ?? ex;
                                }
                                App = App1 as FoxApplication;
                                      // as VisualFoxpro.FoxApplication;
                            }
                        }
                    }


                    // Vfp.Startup.Instance.App = App as IFoxApplication;
                    objApp = App;
                    try
                    {
                        object obj = CsObj20.Instance;
                        if (obj != null) {
                            objApp.SetVar("ocs", obj);
                            // setVar?.Invoke(objApp, new object[] { "ocs", obj });
                        }
                    }
                    catch (Exception ex) { err = ex; }
                }
                else
                    secondTime = false;

                objApp = App;
                IntPtr ProcessId = IntPtr.Zero;

                if (objApp != null)
                {
                    try
                    {
                        ProcessId = (IntPtr)objApp.ProcessId;
                        hWnd = (IntPtr)objApp.hWnd;
                        objApp.Visible = true;
                        objApp.SetVar("ocs", CsObj20.Instance);

                        SetHWnd();

                        objApp.AutoYield = true;
                    }
                    catch (Exception ex) { err = ex; }
                }

                if (secondTime)
                {
                    FoxCmd.StartCmd();
                }
            }
            finally
            {
                if (App == null)
                {
                    // MessageBox.Show($"VisualFoxPro object error {err}");
                }
            }

            if (CsObj20.Instance == null)
                new CsObj20();
            if (CsObj20.Instance != null)
                CsObj20.Instance.IsLockForm = false;
            return App != null;
        }

        public static void NewForm()
        {
            //FoxCmd.FormObj.SetForm(new MainWindow());
            _Form20 form = FoxCmd.FormObj; // .Form;

            StartCmd();
            ShowForm(form);
        }

        //[DispId(21)]
        //dynamic DataToClip(ref object lpvarWrkArea = Type.Missing, ref object lpvarNumRows = Type.Missing, ref object lpvarClipFormat = Type.Missing);
        //[DispId(17)]
        //void DoCmd(string bstrCmd);
        //[DispId(18)]
        //dynamic Eval(string bstrExpr);
        //[DispId(23)]
        //void Help(ref object lpvarHelpFile = Type.Missing, ref object lpvarHelpCid = Type.Missing, ref object lpvarHelpString = Type.Missing);
        //[DispId(19)]
        //void Quit();
        //[DispId(20)]
        //dynamic RequestData(ref object lpvarWrkArea = Type.Missing, ref object lpvarNumRows = Type.Missing);
        //[DispId(22)]
        //void SetVar(string bstrVarName, ref object lpvarNumRows);

        #endregion

        #region Ctor, properties

        public static FoxApplication App {
            [DebuggerStepThrough]
            get;
            private set;
        }

        public static bool IsAlive(FoxApplication app)
        {
            if (app == null && App == null)
                return false;
            app = app ?? App;
            IntPtr hWnd = IntPtr.Zero;
            try {
                var appObj = app as IFoxApplication; // as VisualFoxpro.FoxApplication;
                hWnd = (IntPtr)appObj.hWnd; }
            catch (Exception) { App = null; }
            return hWnd != IntPtr.Zero;
        }

        public static _Form20 FormObj { get; private set; }

        public static void SetApp(FoxApplication app)
        {
            App = app;
            if (app == null)
                return;
            //CsApp20.Ref();

            //var form = CsApp.Instance.Window;
            //if (form != null)
            //{
            //    var obj = form.FormObject ?? FormObj;
            //    FoxCmd.SetFormObj(obj);
            //    form.FormObject = obj;
            //}

            //var ocs = new CsObj();
            //try
            //{
            //    var objApp = App;
            //    objApp.DoCmd("PUBLIC m.ocs as VfpProj.CsObj");

            //    ocs = CsObj.Instance;
            //    objApp.SetVar("ocs", ocs);

            //    // result check:
            //    var m_ocs = objApp.Eval("m.ocs");
            //}
            //catch (Exception ex) {
            //    // server threw an exception. (Exception from HRESULT: 0x80010105(RPC_E_SERVERFAULT))
            //    Trace.Write(ex.Message);
            //}
        }


        static string[] initCmd = new[] {
                    "_SCREEN.WindowState = 2",
                    "HIDE WINDOW Standard",
                    "ACTIVATE WINDOW Command",
                    "MOVE WINDOW 'Command' TO 4,1",
                    "SIZE WINDOW 'Command' TO 50, 50",
                    "SET",
                    "MOVE WINDOW 'View' TO 40, 210"
                };

        public static CsObj20 ocs { get { return CsObj.Instance; } }
        public static void SetFormObj(_Form20 obj) { FormObj = obj; }

        public static IntPtr hWnd;
        public static string cfg_startDir;
        public static string cfg_startFxp;

        static FoxCmd()
        {
            var settings = ConfigurationManager.AppSettings;
            cfg_startDir = string.Empty;
            cfg_startFxp = string.Empty;
            foreach (var list in settings.Keys)
            {
                if (list.Equals("startDir"))
                    cfg_startDir = settings.Get("startDir");
                if (list.Equals("startFxp"))
                    cfg_startFxp = settings.Get("startFxp");
            }

            App = null;
            //if (CsObj20.Instance == null)
            //    new CsObj20();
            hWnd = IntPtr.Zero;
            //FormObj = new CsForm();
        }

        public static void Dispose()
        {
            //if (CsObj20.Instance != null)
            //    CsObj20.Instance.Dispose();
            FormObj = null;
            App = null;
        }

        #endregion

        public static void TryDoCmd(string cmd, bool throwEx = true)
        {
            string[] cmdList = new string[] { cmd };
            if (cmd.Contains(";"))
                cmdList = cmd.Split(new char[] { ';' });

            try
            {
                foreach (string cmdItem in cmdList)
                {
                    App.DoCmd(cmdItem);
                }
            }
            catch (Exception ex)
            {
                CsObj20.Instance.LastError = ex;
                //if (throwEx)
                //    AppMethods.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }
        }

        public static object AppEval(string expr)
        {
            object result = null;
            try
            {
                // dynamic 
                var AppObj = App;
                result = AppObj.Eval(expr);
            }
            catch (COMException ex)
            {
                CsObj.Instance.LastError = ex;
            }
            catch (Exception ex)
            {
                CsObj.Instance.LastError = ex;
                // AppMethods.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }
            return result;
        }

        public static void AppCmd(string cmd)
        {
            if (FormObj == null || ocs == null)
                return;
            string dir = string.Empty;
            Trace.WriteLine("cmd:" + cmd);
            string[] cmdList = new string[] { cmd };
            if (cmd.Contains(";"))
                cmdList = cmd.Split(new char[] { ';' });

            // dynamic 
            object ocs_form = null;
            bool isBound = false; // FormObj.IsBound();

            try
            {
                // dynamic 
                var AppObj = App as FoxApplication;
                var oldDir = AppObj.DefaultFilePath;

                foreach (string cmdItem in cmdList)
                {
                    var cmdTrim = cmdItem.Trim(new[] { ' ', '\n', '\r', '\t' });
                    AppObj.DoCmd(cmdTrim);
                }
                dir = AppObj.DefaultFilePath;
                var caption = AppObj.Caption;
                if (oldDir != dir
                    && caption != null
                    && (caption.Trim().Length) != 0 && caption.Substring(1, 1) == ":"
                    && Directory.Exists(caption))
                {
                    App.Caption = dir;
                }

                ocs_form = AppObj.Eval("IIF(TYPE(\"_SCREEN.ocs_form.text\") != 'C', 0, _SCREEN.ocs_form)");
                if (ocs_form == null || (ocs_form as int?) == null)
                {
                    // SetVar:
                    object obj = FoxCmd.FormObj;
                    App.SetVar("ocs_form",  obj);
                    AppCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
                    AppCmd("_SCREEN.Visible = .T.");
                    AppCmd("_SCREEN.ocs_form = m.ocs_form");
                }
            }
            catch (COMException ex)
            {
               CsObj.Instance.LastError = ex;
                // AppMethods.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }
            catch (Exception ex)
            {
                /* System.Runtime.InteropServices.ComTypes.ITypeInfo
                   System.Runtime.InteropServices.ComTypes.ITypeLib
                   at System.Dynamic.ComRuntimeHelpers.CheckThrowException(Int32 hresult, ExcepInfo & excepInfo, UInt32 argErr, String message)
                   at CallSite.Target(Closure, CallSite, ComObject, String)
                   https://github.com/mono/mono/blob/master/mcs/class/dlr/Runtime/Microsoft.Dynamic/ComRuntimeHelpers.cs
                */
                //AppMethods.Application_ThreadException(null, 
                //     new System.Threading.ThreadExceptionEventArgs(ex));
            }

            // An outgoing call cannot be made as the application is despatching an input-synchronous call.
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))
            if (string.IsNullOrEmpty(dir) || !isBound)
                return;

            //if (FoxCmd.FormObj.Events != null)
            //{
            //    if (!isBound)
            //        FoxCmd.FormObj.SetText(dir);
            //    FoxCmd.FormObj.Events.directory = dir;
            //}
        }

        public static bool ShowApp()
        {
            string msg = "";
            try
            {
                if (!App.Visible)
                {
                    App.Visible = true;
                    App.DoCmd("_SCREEN.WindowState = 2");
                    App.DoCmd("_SCREEN.LockScreen = .F.");

                }
                return true;
            }
            catch (Exception ex)
            {
                // RPC server is not available
                msg = ex.Message;
                Trace.Write(msg);
            }

            return false;
        }

        #region HWnd, Assign form success

        public static void SetHWnd()
        {
            if (hWnd == IntPtr.Zero)
                return;

            // nativeWindow = GetWindowFromHost((int)hWnd);
        }

        public static bool AssignForm(bool reload = false)
        {
            if (ocs == null)
                return false;

            // dynamic 
            var objApp = App;
            if (FoxCmd.FormObj != null)
            {
                TryDoCmd("PUBLIC m.ocs as VfpProj.CsObj");
                object obj = ocs;
                objApp.SetVar("ocs", obj);
            }

            // dynamic 
            object ocs_form = null;
            ocs_form = objApp.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
            //if (ocs_form != null && ocs_form is CsForm && (ocs_form as CsForm).Visible)
            //    FoxCmd.FormObj = ocs_form as CsForm;

            //if (FoxCmd.FormObj == null)
            //{
            //    if (form != null && form.FormObject != null)
            //        FoxCmd.FormObj = form.FormObject;
            //    else
            //    {
            //        FoxCmd.SetFormObj(new CsForm());
            //        FoxCmd.FormObj.SetForm(form);
            //    }
            //}

            if (FoxCmd.FormObj == null)
                return false;

            //if (FoxCmd.FormObj.Form == null)
            //{
            //    if (form != null)
            //        FoxCmd.FormObj.SetForm(form);
            //}

            StartCmd();

            objApp = App;
            if (!objApp.Visible)
                objApp.Visible = true;

            if (reload)
            {
                //FoxCmd.FormObj.Form.ReLoad();
            }

            return false; // ShowForm(FoxCmd.FormObj.Form);
        }

        public static void SetVar()
        {
            // dynamic 
            _Form20 ocs_form = null;
            var objApp = App;
            ocs_form = objApp?.Eval("IIF(TYPE(\"_SCREEN.ocs_form.Directory\") != 'C', 0, _SCREEN.ocs_form)")
                     as _Form20;

            if (ocs_form != null && ocs_form is _Form20 && FoxCmd.FormObj.Equals(ocs_form))
                return;

            TryDoCmd("PUBLIC m.ocs as VfpProj.CsObj");
            object obj = CsObj20.Instance;
            try
            {
                objApp.SetVar("ocs", obj);


                // non COM visible class 'System.Windows.Window', the QueryInterface call will fail.
                TryDoCmd("PUBLIC m.ocs_form as VfpProj.Form");
                obj = FoxCmd.FormObj;
                objApp.SetVar("ocs_form", obj); // FoxCmd.FormObj);
                TryDoCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
            }
            catch { }
        }

        public static void StartCmd()
        {
            SetVar();
            AppCmd(@"SET;
                    _SCREEN.Visible = .T.;
                    ACTIVATE WINDOW Command");
        }

        public static bool ShowForm(object form)
        {
            //if (form.Dispatcher.CheckAccess())
            //{
            //    if (!form.IsVisible)
            //    {
            //        form.ShowActivated = false;
            //        form.Show();
            //    }
            //    DefPosition(form);
            //} 
            //FoxCmd.FormObj.SetForm();

            return true;
        }

        #endregion

        public static bool QueryUnload()
        {
            IntPtr hWnd = IntPtr.Zero;
            try
            {
                //dynamic 
                var isClose = App.Eval("_SCREEN.QueryUnload()");
                if (isClose is Boolean && (!(isClose as Boolean?) ?? true))
                    return false;

                hWnd = App.hWnd;
                if (!App.Visible)
                    hWnd = IntPtr.Zero;
                // App.Quit();
            }
            catch (Exception ex)
            {
                Trace.Write(ex);
            }

            if (hWnd != IntPtr.Zero)
                return false;

            SetApp(null);
            SetFormObj(null);
            return true;
        }

        public static void DebugObj(object app)
        {
            var objApp = app as FoxApplication;
            MethodInfo setVar = null;
            PropertyInfo fStatus = null;
            VariantCom variant = VariantCom.Empty;

            if (objApp != null)
            {
                // This operation failed because the QueryInterface call on the COM component 
                // for the  interface with IID '{00A19612-D8FC-4A3E-A95F-FEA211444BF7}' 
                // failed due to the following error: Error loading type library/DLL. 
                // (Exception from HRESULT: 0x80029C4A (TYPE_E_CANTLOADLIBRARY)).
                var m = objApp.GetType().GetMethods();

                var getType = objApp.GetType().GetMethod("GetType");
                setVar = objApp.GetType().GetMethod("SetVar");


                var type2 = objApp.GetType();

                variant = new VariantCom(objApp.MarshalObj);

                var type3 = variant.UnderlyingSystemType; // .GetType();

                var m2 = type2.GetMethods();
                var m3 = type3.GetMethods();
                var f2 = type2.GetProperties();
                var f3 = type3.GetProperties();
                var f4 = variant.Properties;
                var variant2 = new VariantCom(objApp);
                var f5 = variant2.Properties;

                fStatus = type2.GetProperty("Caption");
                fStatus = fStatus ?? variant.Property("Caption");
                //var CreateObjRef = type2.GetMethod("CreateObjRef");
                fStatus?.GetSetMethod().Invoke(objApp, new object[] { "setVar.." });
                var caption = fStatus?.GetGetMethod().Invoke(objApp, null);
                caption = objApp.Caption;
            }
        }

    }

}