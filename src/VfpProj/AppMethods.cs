using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using VfpProj;

namespace VfpProj
{
    public static class AppMethods
    {
        #region Startup

        public static void App_Startup(object sender, StartupEventArgs e)
        {
            App_StartupJumpList(sender, e);
            var window = CsApp.Instance.MainWindow as MainWindow;

            // version 2
            App_StartupLoad2(Startup.Instance, e);
            if (Startup.Instance.App != null 
                && FoxCmd.Attach())
                FoxCmd.AssignForm(window);
        }


        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            var ex = args.Exception;
            ex = ex.InnerException ?? ex;

            if (CsApp.Instance.Window.FormObject != null)
                CsApp.Instance.Window.FormObject.LastError = ex;

            Startup.Instance.LastError = ex;

            Trace.Write(ex.Message);
        }


        public static object CreateFoxApp()
        {
            object app = null;
            try
            {
                app = new VisualFoxpro.FoxApplication();
            }
            catch (InvalidCastException ex)
            {
                Startup.Instance.LastError = ex;
            }
            catch (InvalidComObjectException ex)
            {
                Startup.Instance.LastError = ex;
            }
            catch (COMException ex)
            {
                // "Retrieving the COM class factory for component with CLSID {00A19610-D8FC-4A3E-A95F-FEA211444BF7} " +
                //  Retrieving the COM class factory failed due to the following error: 800702e4 The requested operation requires elevation
                //  dcomcnfg - 32
                Startup.Instance.LastError = ex;
            }

            return app;
        }

        public static void App_StartupJumpList(object sender, StartupEventArgs e)
        {
            // JumpList jumpList1 = JumpList.GetJumpList(CsApp.Current);

            MainWindow window = new MainWindow();   // NoBorder 

            CsApp.Instance.MainWindow = window;

            window.AllowsTransparency = false;
            window.Load(null);
            window.Show();
        }

        static void App_StartupLoad(Startup Instance, StartupEventArgs e)
        {
            Instance.LoadMain(null);
        }

        static void App_StartupLoad2(Startup Instance, StartupEventArgs e)
        {
            Instance.LoadMain(null);

            try
            {
                var app = CreateFoxApp() as VisualFoxpro.FoxApplication;
                if (app != null)
                {
                    // dynamic 
                    VisualFoxpro.FoxApplication appObj = app;
                    appObj.Visible = true;
                    FoxCmd.SetApp(app);
                    FoxCmd.SetVar();

                    var inst = VfpProj.Startup.Instance;
                    inst.ShowThen(app, then: (app1) =>
                    {
                        var screen = app1.Eval("_SCREEN");
                        if (screen != null)
                        {
                            app1.DoCmd("_SCREEN.AddProperty('ocs', m.ocs)");
                            app1.DoCmd("_SCREEN.ocs_form = m.ocs_form");
                        }
                    }
                    );

                }
            }
            catch (Exception ex)
            {
                Startup.Instance.LastError = ex;
                MessageBox.Show(ex.Message);
            }
        }

        #endregion

        //public static EditWindow ShowEditWindow(string file)
        //{
        //    var winEdit = new EditWindow();
        //    winEdit.ShowInTaskbar = true;
        //    if (file.Length > 0)
        //    {
        //        winEdit.txtPath.Text = file;
        //        TextRead.Open(winEdit);
        //    }

        //    // Uri iconUri = new Uri("pack://application:,,,/PRG.ico", UriKind.RelativeOrAbsolute);
        //    // winEdit.Icon = BitmapFrame.Create(iconUri);
        //    winEdit.Show();
        //    return winEdit;
        //}

        public static void App_DoCmd(string cmd)
        {
            var app = Startup.Instance.App;
            FoxCmd.TryDoCmd(cmd, throwEx: false);
        }

        public static object App_DoEval(string expr)
        {
            var app = Startup.Instance.App;
            if (expr == "_VFP")
                return app;

            return app == null || expr.IsNullOrWhiteSpace() ? null 
                 : FoxCmd.AppEval(expr);
        }

        public static void HostBind()
        {
            //var service = VfpWcf.Instance;

            //if (Host.Object != null)
            //    return;

            //Task.Factory.StartNew(() => Host.Create());
        }
    }
}
