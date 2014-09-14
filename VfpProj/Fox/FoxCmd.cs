using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Windows;
using System.Windows.Forms.Integration;
using VisualFoxpro;

namespace VfpProj
{
    public static class FoxCmd
    {
        static string[] initCmd = new[] { 
                    "_SCREEN.WindowState = 2",
                    "HIDE WINDOW Standard",
                    "ACTIVATE WINDOW Command", 
                    "MOVE WINDOW 'Command' TO 4,1",
                    "SIZE WINDOW 'Command' TO 50, 50",
                    "SET",
                    "MOVE WINDOW 'View' TO 40, 210" 
                };

        public static FoxApplication app;
        public static CsObj ocs;
        public static CsForm form;
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

            app = null;
            ocs = null;
            hWnd = IntPtr.Zero;
            form = null;
        }

        public static void Dispose()
        {
            hWnd = IntPtr.Zero;
            ocs = null;
            form = null;
            app = null;
        }


        public static void AppCmd(string cmd)
        {
            string dir = string.Empty;
            Trace.WriteLine("cmd:" + cmd);
            string[] cmdList = new string[] { cmd };
            if (cmd.Contains(";"))
                cmdList = cmd.Split(new char[] { ';' });

            try
            {
                foreach (string cmdItem in cmdList)
                {
                    form.Text = cmdItem;
                    app.DoCmd(cmdItem);
                }
                dir = app.DefaultFilePath;
            }
            catch (Exception ex)
            {
                App.Application_ThreadException(null, new ThreadExceptionEventArgs(ex));
            }

            // An outgoing call cannot be made as the application is despatching an input-synchronous call.
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))
            if (string.IsNullOrEmpty(dir))
                return;

            FoxCmd.form.Text = dir;
            FoxCmd.form.Events.directory = dir;
        }

        public static bool ShowApp()
        {
            string msg = "";
            try
            {
                // dynamic x = app.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
                if (!app.Visible)
                {
                    app.Visible = true;
                    app.DoCmd("_SCREEN.WindowState = 2");
                    app.DoCmd("_SCREEN.LockScreen = .F.");

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
                if (app == null)
                    app = new VisualFoxpro.FoxApplication();

                app.AutoYield = false;
                hWnd = (IntPtr)app.hWnd;
                SetHWnd();
            }
            finally
            {
                if (app == null)
                {
                    MessageBox.Show("VisualFoxPro object error");
                }
            }

            return app != null;
        }

        public static void SetHWnd()
        {
            if (hWnd == IntPtr.Zero)
                return;

            // nativeWindow = GetWindowFromHost((int)hWnd);
        }


        public static bool CreateForm(MainWindow form)
        {
            AppCmd("PUBLIC m.ocs as VfpProj.CsObj");

            var ocs = new CsObj();
            app.SetVar("ocs", ocs);

            dynamic ocs_form = null;
            ocs_form = app.Eval("IIF(TYPE(\"_SCREEN.ocs_form\") = 'U', 0, _SCREEN.ocs_form)");
            if (ocs_form != null && ocs_form is CsForm && (ocs_form as CsForm).Visible)
                FoxCmd.form = ocs_form as CsForm;

            if (FoxCmd.form == null
                && form != null && form.form != null)
                FoxCmd.form = form.form;
            else
            {
                FoxCmd.form = new CsForm();
                FoxCmd.form.Form = form;
            }
            if (FoxCmd.form == null)
                return false;
            if (FoxCmd.form.Form == null)
                FoxCmd.form.Form = new MainWindow();

            SetVar();

            if (!app.Visible)
            {
                app.Visible = true;
                foreach(string cmd in initCmd)
                    AppCmd(cmd);
            }

            // hWnd = nativeWindow.Handle;
            return ShowForm(FoxCmd.form.Form);
        }

        public static void SetVar()
        {
            dynamic ocs_form = null;
            ocs_form = app.Eval("IIF(TYPE(\"_SCREEN.ocs_form.text\") != 'C', 0, _SCREEN.ocs_form)");

            if (ocs_form != null && ocs_form is _Form && FoxCmd.form.Equals(ocs_form))
                return;

            AppCmd("PUBLIC m.ocs_form as VfpProj.Form");

            // non COM visible class 'System.Windows.Window', the QueryInterface call will fail.
            // This is done to prevent 
            // the non COM visible base class from being constrained by the COM versioning rules.

            app.SetVar("ocs_form", FoxCmd.form);
            AppCmd("_SCREEN.AddProperty(\"ocs_form\", .null.)");
            AppCmd("_SCREEN.ocs_form = m.ocs_form");
        }

        public static bool ShowForm(MainWindow form)
        {
            if (form == null)
            {
                FoxCmd.form = null;
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
                dynamic isClose = app.Eval("_SCREEN.QueryUnload()");
                if (isClose is Boolean && !isClose)
                    return false;

                app.Quit();
            }
            catch (Exception ex)
            {
                Trace.Write(ex);
            }

            app = null;
            return true;
        }


        public static void TextFileCmd(string cmd)
        {

            if (File.Exists(cmd) || Directory.Exists(cmd))
            {
                if (!File.Exists(cmd))
                {
                    FoxCmd.AppCmd("CD " + cmd);
                    form.Events.directory = FoxCmd.app.DefaultFilePath;
                    Directory.SetCurrentDirectory(form.Events.directory);
                    return;
                }

                string ext = Path.GetExtension(cmd).ToLower();
                if (ext == ".prg")
                    FoxCmd.AppCmd("MODI COMM " + cmd + " NOWAIT");
                else
                    if (ext == ".pjx")
                        FoxCmd.AppCmd("MODI PROJ " + cmd + " NOWAIT");
            }
            else
                FoxCmd.AppCmd(cmd);

            try
            {
                if (form.Events.directory != FoxCmd.app.DefaultFilePath)
                {
                    if (form.Events.directory != FoxCmd.app.DefaultFilePath)
                        Directory.SetCurrentDirectory(form.Events.directory);
                }
            }
            catch (Exception) { }
        }

    }
}
