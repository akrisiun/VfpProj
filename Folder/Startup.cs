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
using VfpEdit;
using Folder;
using VisualFoxpro;
using Application = System.Windows.Application;
using System.Runtime.InteropServices;

namespace Vfp
{
    public class Startup : IComponent, IDisposable // _Startup
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

        //[ComVisible(true)]
        //public _Startup LoadMain(FoxApplication app)
        //{
        //    Main(app, false);
        //    return this;
        //}

         public FoxApplication App { get; set; }

        protected CsApp appCur;

        [STAThread]
        public void Main(FoxApplication app = null, bool lRun = false)
        {
            this.App = app;
            Folder.MainWindow.Dll = "/Folder";

            appCur = Application.Current as CsApp ?? Folder.CsApp.Instance;
            try
            {
                if (appCur == null)
                    appCur = Folder.CsApp.Ref();

                appCur.ShutdownMode = ShutdownMode.OnExplicitShutdown;
            }
            catch (Exception) { }

            var mainWnd = appCur.Window;

            //bool checkAccess = true;
            if (mainWnd == null)
                mainWnd = new Folder.FolderWindow();
            //else
            //    checkAccess = (mainWnd as DispatcherObject).CheckAccess();

            // calling thread must be STA because many UI components
            //appCur.MainWindow = mainWnd;
            //mainWnd.IsStart = true;

            //if (app != null)
            //{
            //    if (!checkAccess)
            //        mainWnd.Dispatcher.Invoke(new Action(() =>
            //            {
            //                WindowLoad(mainWnd, app, lRun);
            //                mainWnd.Visibility = Visibility.Visible;
            //            }));
            //    else
                  WindowLoad(mainWnd, app, lRun);
            //}
        }

        public void WindowLoad(FolderWindow mainWnd, FoxApplication app, bool lRun = false)
        {
            string dir = Environment.CurrentDirectory;
 
            if (lRun)
                appCur.Run();
        }
    }
} 