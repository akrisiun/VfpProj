using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Threading;
using System.ComponentModel;
using VfpProj;
using VisualFoxpro;
using Application = System.Windows.Application;
using System.Runtime.InteropServices;
using System.Security;
using System.IO;
using System.Reflection;
//using VfpProj.Wcf;
//using Newtonsoft.Json;

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
#if WCF            
            if (Host.Object != null)
            {
                Host.Object.Close();
                Host.Object = null;
            }
#endif
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

        public Exception LastError { get; set; }

        public FoxApplication App {
            [DebuggerStepThrough]
            get;
            set;
        }

        // [JsonIgnore]
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
            VfpProj.MainWindow.Dll = "/VfpProj2";

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

                app.DoCmd("CANCEL");
            }
            catch (Exception ex)
            {
                Instance.LastError = ex;
            }

            if (lRun)
                appCur.Run();
        }


        [STAThread]
        public static void Main()
        {
            VfpProj.CsApp app = new VfpProj.CsApp();
            // app.InitializeComponent();
            app.Run(new MainWindow());
        }

        public static string BaseDirectory { get => AppDomain.CurrentDomain.BaseDirectory; }
        public static Assembly AsmOle { get; private set; }

        public static FoxApplication CreateApp(MainWindow form)
        {
            var inst = Vfp.Startup.Instance;
            VfpProj.CsApp.Instance.Window.IsStart = false;

            Instance.LastError = null;
            try
            {
                var ThreadId = SafeLibraryHandle.Win32.GetCurrentThreadId();
                Console.Write($"ThreadId=0x{ThreadId.ToString("X8")}  ");

                string dll = Path.Combine(BaseDirectory, "vfp8r.dll");
                Console.Write(dll);
                var Vfp8R = SafeLibraryHandle.Win32.LoadLibrary(dll);

                Console.WriteLine($" Vfp8R.handle={Vfp8R}");

                //dll = Path.Combine(BaseDirectory, "VfpOleLib.dll");
                //Console.Write(dll);
                //if (File.Exists(dll))
                //    AsmOle = Assembly.LoadFrom(dll);
                //Console.WriteLine($" Ole OK");

                dll = Path.Combine(BaseDirectory, "Interop.VisualFoxpro.dll");
                Console.Write(dll);
                AsmOle = Assembly.LoadFrom(dll);
                Console.WriteLine($" Interop.VisualFoxpro={AsmOle}");

            }
            catch (Exception ex)
            {
                Instance.LastError = ex;
                Console.WriteLine($"{ex.InnerException ?? ex}");
                // return App;
            }

            FoxCmd.Attach(secondTime: true);

            if (FoxCmd.App == null)
                return null;
            
            var app = FoxCmd.App;

            form.Load(app);
            inst.Show(app);

            return FoxCmd.App;
        }
    }


    [DebuggerDisplay("{Handle.ToString(\"X8\")}h")]
    public struct SafeLibraryHandle : IDisposable
    {
        internal class Win32
        {
            const string KERNEL32 = "kernel32.dll";

            [DllImport(KERNEL32, ExactSpelling = false, SetLastError = true)] // , CharSet = CharSet.Unicode)]
            //[ResourceExposure(ResourceScope.Machine)]
            [SuppressUnmanagedCodeSecurity]
            [SecurityCritical]
            internal static extern SafeLibraryHandle LoadLibrary(String libPath);

            [DllImport(KERNEL32, ExactSpelling = true, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            internal static extern IntPtr GetCurrentThreadId();

            [System.Security.SecurityCritical]
            [DllImport(KERNEL32, CallingConvention = CallingConvention.Winapi, SetLastError = true)]
            internal extern static IntPtr GetProcAddress(SafeLibraryHandle hModule, string entryPoint);

            [System.Security.SecurityCritical]
            [DllImport(KERNEL32, CallingConvention = CallingConvention.Winapi, SetLastError = true)]
            internal extern static IntPtr GetProcAddress(IntPtr hModule, string entryPoint);

            [DllImport(KERNEL32, ExactSpelling = true)]
            [SuppressUnmanagedCodeSecurity]
            [SecurityCritical]
            internal static extern bool FreeLibrary(IntPtr moduleHandle);
        }

        public IntPtr Handle { get; set; }

        public bool IsEmpty { get => Handle == IntPtr.Zero; }

        internal SafeLibraryHandle(IntPtr handle)
        {
            Handle = handle;
        }

        public unsafe bool HasFunction(string functionName)
        {
            IntPtr ret = Win32.GetProcAddress(this, functionName);
            return (ret != IntPtr.Zero);
        }

        public void Dispose()
        {
            if (!IsEmpty)
                Win32.FreeLibrary(Handle);
            Handle = IntPtr.Zero;
        }
    }

}