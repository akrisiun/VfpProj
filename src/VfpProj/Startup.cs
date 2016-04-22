using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Shell;
using System.Windows.Threading;
using System.ComponentModel;
using VfpProj;
using VisualFoxpro;
using Application = System.Windows.Application;
using System.Runtime.InteropServices;

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
        }

        ISite IComponent.Site { get; set; }
#pragma warning disable 0067
        public event EventHandler Disposed;

        public static Startup Instance { get; protected set; }

        public static Startup Load() { return Instance; }

        [ComVisible(true)]
        public _Startup LoadMain(FoxApplication app)
        {
            Main(app, false);
            return this;
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

        public FoxApplication App { get; set; }

        protected CsApp appCur;

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

                // mainWnd.events.AfterRendered();
                app.DoCmd("CANCEL");
            }
            catch (Exception) { }

            if (lRun)
                appCur.Run();
        }
    }
}

/*
namespace VfpProj
{

    public class App : Application
    {
        static App() { } // debugger entry

        static App startRef;
        public static App Instance
        {
            [DebuggerStepThrough]
            get
            { return startRef ?? Application.Current as App; }
            set { startRef = value; }
        }

        [STAThread]
        public static void Main()
        {
            VfpProj.App app = new VfpProj.App();
            // app.InitializeComponent();

            //<JumpList.JumpList x:Uid="jumpList">
            //    <JumpList ShowRecentCategory="True" 
            //              ShowFrequentCategory="True">

            app.Startup += app.App_Startup;
            app.Run();
        }

        public static App Ref()
        {
            return Instance ?? new App();
        }

        public App()
        {
            startRef = this;
        }

        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            Trace.Write(args.Exception.Message);
        }

        void App_Startup(object sender, StartupEventArgs e)
        {
            // JumpList jumpList1 = JumpList.GetJumpList(App.Current);

            MainWindow window = new MainWindow();   // NoBorder 
            window.AllowsTransparency = false;
            window.Load(null);

            window.Show();

            if (FoxCmd.Attach())
                FoxCmd.CreateForm(window);
        }

        public EditWindow ShowEditWindow(string file)
        {
            var winEdit = new EditWindow();
            winEdit.ShowInTaskbar = true;
            if (file.Length > 0)
            {
                winEdit.txtPath.Text = file;
                winEdit.OpenFile();
            }

            // Uri iconUri = new Uri("pack://application:,,,/PRG.ico", UriKind.RelativeOrAbsolute);
            // winEdit.Icon = BitmapFrame.Create(iconUri);
            winEdit.Show();
            return winEdit;
        }


    }
}

*/
