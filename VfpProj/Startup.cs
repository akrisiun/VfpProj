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
using VfpEdit;
using VfpProj;
using VisualFoxpro;
using Application = System.Windows.Application;

namespace Vfp
{
    public class Startup : _Startup
    {
        static Startup()
        {
            Instance = new Startup();
        }

        public static Startup Instance { get; protected set; }

        public static Startup Load() { return Instance; }

        public _Startup LoadMain(FoxApplication app) { Main(app, false); return this; }

        public FoxApplication App { get; set; }

        protected App appCur;

        [STAThread]
        public void Main(FoxApplication app = null, bool lRun = false)
        {
            this.App = app;

            // System.AppDomain.CurrentDomain.ApplicationIdentity.
            VfpProj.MainWindow.Dll = "/VfpProj";

            appCur = Application.Current as App ?? VfpProj.App.Instance;
            try
            {
                if (appCur == null)
                    appCur = VfpProj.App.Ref();

                appCur.ShutdownMode = ShutdownMode.OnExplicitShutdown;
            }
            catch (Exception) { }

            var mainWnd = appCur.Window;
            bool checkAccess = true;
            if (mainWnd == null)
                mainWnd = new VfpProj.MainWindow();
            else
                checkAccess = (mainWnd as DispatcherObject).CheckAccess();

            appCur.MainWindow = mainWnd;
            // calling thread must be STA because many UI components

            mainWnd.IsStart = true;

            if (!checkAccess)
                mainWnd.Dispatcher.Invoke(new Action(() =>
                    {
                        WindowLoad(mainWnd, app, lRun);
                        mainWnd.Visibility = Visibility.Visible;
                    }));
            else
                WindowLoad(mainWnd, app, lRun);
        }

        public void WindowLoad(VfpProj.MainWindow mainWnd, FoxApplication app, bool lRun = false)
        {

            //if (FoxCmd.Attach())
            //    FoxCmd.CreateForm(window);
            try
            {
                mainWnd.Load(app);
                // mainWnd.Show();

                app.DoCmd("DOEVENTS FORCE");
                
                mainWnd.events.AfterRendered();

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