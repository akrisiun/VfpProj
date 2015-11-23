using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Windows;
using System.Windows.Forms.Integration;
using VfpInterop;
using VisualFoxpro;

namespace VfpProj
{
    public static class FoxCmd
    {
        public static FoxApplication App { get; private set; }
        public static bool IsAlive(this FoxApplication app)
        {
            if (app == null && App == null)
                return false;
            app = app ?? App;
            IntPtr hWnd = IntPtr.Zero;
            try { hWnd = (IntPtr)app.hWnd; }
            catch (Exception) { App = null; }
            return hWnd != IntPtr.Zero;
        }

        public static CsForm FormObj { get; private set; }
        public static void SetApp(FoxApplication app)
        {
            App = app;
            if (app == null)
                return;
            CsApp.Ref();

            var form = CsApp.Instance.Window;
            if (form != null)
            {
                var obj = form.FormObject ?? FormObj;
                FoxCmd.SetFormObj(obj);
                form.FormObject = obj;
            }

            var ocs = new CsObj();
            App.DoCmd("PUBLIC m.ocs as VfpProj.CsObj");
            App.SetVar("ocs", CsObj.Instance);
        }

        public static void SetFormObj(CsForm obj) { FormObj = obj; }

        static string[] initCmd = new[] {
                    "_SCREEN.WindowState = 2",
                    "HIDE WINDOW Standard",
                    "ACTIVATE WINDOW Command",
                    "MOVE WINDOW 'Command' TO 4,1",
                    "SIZE WINDOW 'Command' TO 50, 50",
                    "SET",
                    "MOVE WINDOW 'View' TO 40, 210"
                };

        public static CsObj ocs { get { return CsObj.Instance; } }

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
            if (CsObj.Instance == null)
                new CsObj();
            hWnd = IntPtr.Zero;
            FormObj = new CsForm();
        }

        public static void Dispose()
        {
            if (CsObj.Instance != null)
                CsObj.Instance.Dispose();
            FormObj = null;
            App = null;
        }

        public static void TryDoCmd(string cmd)
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
                VfpProj.CsApp.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }
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

            dynamic ocs_form = null;
            bool isBound = FormObj.IsBound();
            try
            {
                var oldDir = App.DefaultFilePath;
                foreach (string cmdItem in cmdList)
                {
                    var cmdTrim = cmdItem.Trim(new[] { ' ', '\n', '\r', '\t' });
                    if (isBound)
                        FormObj.SetText(cmdTrim);
                    App.DoCmd(cmdTrim);
                }
                dir = App.DefaultFilePath;
                var caption = App.Caption;
                if (oldDir != dir 
                    && !string.IsNullOrWhiteSpace(caption) && caption.Substring(1, 1) == ":"
                    && Directory.Exists(caption))
                    App.Caption = dir;

                ocs_form = App.Eval("IIF(TYPE(\"_SCREEN.ocs_form.text\") != 'C', 0, _SCREEN.ocs_form)");
                if (ocs_form == null || (ocs_form as int?) == null)
                {
                    // SetVar();
                    App.SetVar("ocs_form", FoxCmd.FormObj);
                    AppCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
                    AppCmd("_SCREEN.Visible = .T.");
                    AppCmd("_SCREEN.ocs_form = m.ocs_form");
                }
            }
            catch (Exception ex)
            {
                VfpProj.CsApp.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }

            // An outgoing call cannot be made as the application is despatching an input-synchronous call.
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))
            if (string.IsNullOrEmpty(dir) || !isBound)
                return;

            if (FoxCmd.FormObj.Events != null)
            {
                FoxCmd.FormObj.SetText(dir);
                FoxCmd.FormObj.Events.directory = dir;
            }
        }

        public static bool ShowApp()
        {
            string msg = "";
            try
            {
                // dynamic x = app.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
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

        public static bool Attach(bool secondTime = false)
        {
            if (secondTime)
                CsObj.Instance.IsLockForm = true;

            try
            {
                if (App == null && !VfpProj.CsApp.Instance.Window.IsStart)
                {
                    if (Vfp.Startup.Instance.App != null)
                        App = Vfp.Startup.Instance.App;

                    if (App == null)
                        App = new VisualFoxpro.FoxApplication();

                    Vfp.Startup.Instance.App = App;
                    App.SetVar("ocs", CsObj.Instance);
                }
                else
                    secondTime = false;

                if (App != null)
                {
                    App.AutoYield = true;
                    hWnd = (IntPtr)App.hWnd;
                    SetHWnd();
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
                    MessageBox.Show("VisualFoxPro object error");
                }
            }

            CsObj.Instance.IsLockForm = false;
            return App != null;
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

        public static void SetHWnd()
        {
            if (hWnd == IntPtr.Zero)
                return;

            // nativeWindow = GetWindowFromHost((int)hWnd);
        }

        public static bool AssignForm(MainWindow form, bool reload = false)
        {
            if (ocs == null)
                return false;
            if (FoxCmd.FormObj != null)
            {
                TryDoCmd("PUBLIC m.ocs as VfpProj.CsObj");
                App.SetVar("ocs", ocs);
            }

            dynamic ocs_form = null;
            ocs_form = App.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
            if (ocs_form != null && ocs_form is CsForm && (ocs_form as CsForm).Visible)
                FoxCmd.FormObj = ocs_form as CsForm;

            if (FoxCmd.FormObj == null)
            {
                if (form != null && form.FormObject != null)
                    FoxCmd.FormObj = form.FormObject;
                else
                {
                    FoxCmd.SetFormObj(new CsForm());
                    FoxCmd.FormObj.SetForm(form);
                }
            }

            if (FoxCmd.FormObj == null)
                return false;

            if (FoxCmd.FormObj.Form == null)
            {
                if (form != null)
                    FoxCmd.FormObj.SetForm(form);
            }

            StartCmd();

            if (!App.Visible)
                App.Visible = true;

            if (reload)
            {
                //FoxCmd.FormObj.Form.ReLoad();
            }

            return ShowForm(FoxCmd.FormObj.Form);
        }

        public static void NewForm()
        {
            FoxCmd.FormObj.SetForm(new MainWindow());
            var form = FoxCmd.FormObj.Form;

            StartCmd();
            ShowForm(form);
        }

        public static void SetVar()
        {
            dynamic ocs_form = null;
            ocs_form = App.Eval("IIF(TYPE(\"_SCREEN.ocs_form.Directory\") != 'C', 0, _SCREEN.ocs_form)");

            if (ocs_form != null && ocs_form is _Form && FoxCmd.FormObj.Equals(ocs_form))
                return;

            TryDoCmd("PUBLIC m.ocs as VfpProj.CsObj");
            App.SetVar("ocs", CsObj.Instance);

            // non COM visible class 'System.Windows.Window', the QueryInterface call will fail.
            TryDoCmd("PUBLIC m.ocs_form as VfpProj.Form");
            App.SetVar("ocs_form", FoxCmd.FormObj);
            TryDoCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
        }

        public static void StartCmd()
        {
            SetVar();
            AppCmd(@"SET;
                    _SCREEN.Visible = .T.;
                    ACTIVATE WINDOW Command");
        }

        public static bool ShowForm(MainWindow form)
        {
            if (form == null)
            {
                FoxCmd.FormObj = null;
                return false;
            }

            if (form.Dispatcher.CheckAccess())
            {
                if (!form.IsVisible)
                {
                    form.ShowActivated = false;
                    form.Show();
                }
                DefPosition(form);
            }

            // GetWindowFromHwnd is a method-wrapped version of your code
            //   static private WindowsFormsHost GetWindowFromHost(int hwnd)
            //   WindowsFormsHost nativeWindow = new WindowsFormsHost();
            //     nativeWindow.AssignHandle(handle);

            FoxCmd.FormObj.SetForm(form);

            return true;
        }

        public static void DefPosition(MainWindow form)
        {
            var isSet = form.GetValue(Window.TopProperty);
            if (!Double.NaN.Equals(isSet))
                return;

            form.SetValue(Window.ShowInTaskbarProperty, true);
            // form.SetValue(Window.TopProperty, -5);
            form.SetValue(Window.LeftProperty, SystemParameters.PrimaryScreenWidth / 2);
            form.SetValue(Window.TopmostProperty, true);
        }

        public static void DefPositionLoad(MainWindow form)
        {
            var isSet = form.GetValue(Window.TopProperty);
            if (Double.NaN.Equals(isSet))
                form.Top = -5;
        }

        public static bool QueryUnload()
        {
            int hWnd = 0;
            try
            {
                dynamic isClose = App.Eval("_SCREEN.QueryUnload()");
                if (isClose is Boolean && !isClose)
                    return false;

                hWnd = App.hWnd;
                if (!App.Visible)
                    hWnd = 0;
                // App.Quit();
            }
            catch (Exception ex)
            {
                Trace.Write(ex);
            }

            if (hWnd != 0)
                return false;

            SetApp(null);
            SetFormObj(null);
            return true;
        }
    }
}
