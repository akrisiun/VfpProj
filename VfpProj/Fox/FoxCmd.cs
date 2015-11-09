using System;
using System.Configuration;
using System.Diagnostics;
using System.Threading;
using System.Windows;
using System.Windows.Forms.Integration;
using VfpInterop;
using VisualFoxpro;

namespace VfpProj
{
    public static class FoxCmd
    {
        public static FoxApplication App { get; set; }
        public static CsForm FormObj { get; set; }

        static string[] initCmd = new[] { 
                    "_SCREEN.WindowState = 2",
                    "HIDE WINDOW Standard",
                    "ACTIVATE WINDOW Command", 
                    "MOVE WINDOW 'Command' TO 4,1",
                    "SIZE WINDOW 'Command' TO 50, 50",
                    "SET",
                    "MOVE WINDOW 'View' TO 40, 210" 
                };

        public static CsObj ocs;

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
            ocs = null;
            hWnd = IntPtr.Zero;
            FormObj = null;
        }

        public static void Dispose()
        {
            hWnd = IntPtr.Zero;
            ocs = null;
            FormObj = null;
            App = null;
        }


        public static void AppCmd(string cmd)
        {
            if (FormObj == null)
                return;
            string dir = string.Empty;
            Trace.WriteLine("cmd:" + cmd);
            string[] cmdList = new string[] { cmd };
            if (cmd.Contains(";"))
                cmdList = cmd.Split(new char[] { ';' });

            dynamic ocs_form = null;
            try
            {
                foreach (string cmdItem in cmdList)
                {
                    FormObj.Text = cmdItem;
                    App.DoCmd(cmdItem);
                }
                dir = App.DefaultFilePath;

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
                VfpProj.App.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }

            // An outgoing call cannot be made as the application is despatching an input-synchronous call.
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))
            if (string.IsNullOrEmpty(dir))
                return;

            FoxCmd.FormObj.Text = dir;
            FoxCmd.FormObj.Events.directory = dir;
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
            catch (Exception ex1)
            {
                // RPC server is not available
                msg = ex1.Message;
                Trace.Write(msg);
            }

            return false;
        }

        public static bool Attach()
        {
            try
            {
                if (App == null)
                    App = new VisualFoxpro.FoxApplication();

                App.AutoYield = false;
                hWnd = (IntPtr)App.hWnd;
                SetHWnd();
            }
            finally
            {
                if (App == null)
                {
                    MessageBox.Show("VisualFoxPro object error");
                }
            }

            return App != null;
        }

        public static void SetHWnd()
        {
            if (hWnd == IntPtr.Zero)
                return;

            // nativeWindow = GetWindowFromHost((int)hWnd);
        }


        public static bool CreateForm(MainWindow form)
        {
            var ocs = new CsObj();
            App.SetVar("ocs", ocs);
            if (FoxCmd.FormObj != null)
            {
                AppCmd("PUBLIC m.ocs as VfpProj.CsObj");
                App.SetVar("ocs", ocs);
            }

            dynamic ocs_form = null;
            ocs_form = App.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
            if (ocs_form != null && ocs_form is CsForm && (ocs_form as CsForm).Visible)
                FoxCmd.FormObj = ocs_form as CsForm;

            if (FoxCmd.FormObj == null
                && form != null && form.form != null)
                FoxCmd.FormObj = form.form;
            else
            {
                FoxCmd.FormObj = new CsForm();
                FoxCmd.FormObj.Form = form;
            }
            if (FoxCmd.FormObj == null)
                return false;
            if (FoxCmd.FormObj.Form == null)
                FoxCmd.FormObj.Form = new MainWindow();

            SetVar();

            if (!App.Visible)
                App.Visible = true;

            // hWnd = nativeWindow.Handle;
            return ShowForm(FoxCmd.FormObj.Form);
        }

        public static void SetVar()
        {
            dynamic ocs_form = null;
            ocs_form = App.Eval("IIF(TYPE(\"_SCREEN.ocs_form.text\") != 'C', 0, _SCREEN.ocs_form)");

            if (ocs_form != null && ocs_form is _Form && FoxCmd.FormObj.Equals(ocs_form))
                return;

            AppCmd("PUBLIC m.ocs_form as VfpProj.Form");

            // non COM visible class 'System.Windows.Window', the QueryInterface call will fail.
            // This is done to prevent 
            // the non COM visible base class from being constrained by the COM versioning rules.

            App.SetVar("ocs_form", FoxCmd.FormObj);
            AppCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
            AppCmd("_SCREEN.Visible = .T.");
        }

        public static bool ShowForm(MainWindow form)
        {
            if (form == null)
            {
                FoxCmd.FormObj = null;
                return false;
            }

            if (!form.IsVisible)
            {
                form.ShowActivated = false;
                form.Show();
            }

            form.ShowInTaskbar = true;
            form.Top = -5;
            form.Left = SystemParameters.PrimaryScreenWidth / 2;
            form.Topmost = true;
            // GetWindowFromHwnd is a method-wrapped version of your code
            //   static private WindowsFormsHost GetWindowFromHost(int hwnd)
            //   WindowsFormsHost nativeWindow = new WindowsFormsHost();
            //     nativeWindow.AssignHandle(handle);

            return true;
        }

        public static bool QueryUnload()
        {
            try
            {
                dynamic isClose = App.Eval("_SCREEN.QueryUnload()");
                if (isClose is Boolean && !isClose)
                    return false;

                // App.Quit();
            }
            catch (Exception ex)
            {
                Trace.Write(ex);
            }

            // App = null;
            return true;
        }
    }
}
