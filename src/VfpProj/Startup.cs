using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Threading;
using System.ComponentModel;
using VfpProj;
using VisualFoxpro;
using Application = System.Windows.Application;
using System.Runtime.InteropServices;
using VfpProj.Wcf;

namespace Vfp
{
    public class Startup : _Startup, IComponent, IDisposable
    {
        static Startup()
        {
            if (CsApp.Instance == null)
                CsApp.StartupMode = true;
            Instance = new Startup();
        }

        public void Dispose()
        {
            appCur = null;
            App = null;
            if (Host.Object != null)
            {
                Host.Object.Close();
                Host.Object = null;
            }
        }

        ISite IComponent.Site { get; set; }
#pragma warning disable 0067
        public event EventHandler Disposed;

        public static Startup Instance {
            [DebuggerStepThrough]
            get;
            protected set;
        }

        public static Startup Load() { return Instance; }

        [ComVisible(true)]
        public _Startup LoadMain(FoxApplication app)
        {
            Main(app, false);
            return this;
        }

        public _Form ShowThen(FoxApplication app, Action<FoxApplication> then)
        {
            var form = Show(app);
            if (then != null)
                this.Then = then;

            return form;
        }

        [ComVisible(true)]
        public _Form Show(FoxApplication app)
        {
            CsForm csForm = null;
            Exception err = null;
            MainWindow form = null;
            try
            {
                CsApp.Ref();
                form = CsApp.Instance.Window ?? new MainWindow();

                FoxCmd.SetApp(app);
                if (app != null)
                {
                    FoxCmd.SetVar();

                    csForm = form.FormObject ?? new CsForm();

                    if (csForm.CheckAccess())
                        form.events.AfterRendered();
                    else if (form.events == null)
                        form.Dispatcher.Invoke(new Action(() => form.ReLoad()));
                    else
                        form.Dispatcher.Invoke(new Action(() => form.events.AfterRendered()));
                }
            }
            catch (Exception ex)
            {
                err = ex;
                if (form != null)
                    form.Show();
            }

            return csForm;
        }

        public FoxApplication App {
            [DebuggerStepThrough]
            get;
            set;
        }

        protected CsApp appCur;
        public Action<FoxApplication> Then {
            [DebuggerStepThrough]
            get;
            set;
        }

        [STAThread]
        public void Main(FoxApplication app = null, bool lRun = false)
        {
            this.App = app;
            VfpProj.MainWindow.Dll = "/VfpProj";

            appCur = Application.Current as CsApp ?? VfpProj.CsApp.Instance;
            try
            {
                if (appCur == null)
                    appCur = VfpProj.CsApp.Ref();

                appCur.ShutdownMode = ShutdownMode.OnExplicitShutdown;
            }
            catch (Exception) { }

            var mainWnd = appCur.Window;
            bool checkAccess = true;
            if (mainWnd == null)
                mainWnd = new VfpProj.MainWindow();
            else
                checkAccess = (mainWnd as DispatcherObject).CheckAccess();

            // calling thread must be STA because many UI components
            appCur.MainWindow = mainWnd;
            mainWnd.IsStart = true;

            if (app != null)
            {
                if (!checkAccess)
                    mainWnd.Dispatcher.Invoke(new Action(() =>
                        {
                            WindowLoad(mainWnd, app, lRun);
                            mainWnd.Visibility = Visibility.Visible;
                        }));
                else
                    WindowLoad(mainWnd, app, lRun);
            }
        }

        public void WindowLoad(VfpProj.MainWindow mainWnd, FoxApplication app, bool lRun = false)
        {
            string dir = FileSystem.CurrentDirectory;

            try
            {
                mainWnd.Load(app);

                app.DoCmd("DOEVENTS FORCE");

                dir = app.DefaultFilePath;
                mainWnd.FormObject.Directory = dir;

                if (this.Then != null)
                    this.Then(app);

                // mainWnd.events.AfterRendered();
                app.DoCmd("CANCEL");
            }
            catch (Exception) { }

            if (lRun)
                appCur.Run();
        }
    }
}