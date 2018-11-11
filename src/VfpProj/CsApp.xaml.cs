using System;
using System.Diagnostics;
using System.Windows;

namespace VfpProj
{
    /// <summary>
    /// Interaction logic for CsApp.xaml
    /// </summary>
    public partial class CsApp : Application
    {
        static CsApp() {
            startRef = AppDomain.CurrentDomain.GetData("CsObj") as CsApp;
        } // debugger entry
        static CsApp startRef;

        public static CsApp Instance {
            [DebuggerStepThrough]
            get { return startRef ?? Application.Current as CsApp; }
            set { startRef = value; }
        }

        public MainWindow Window { get; set; }

        public static CsApp Ref()
        {
            return Instance ?? (Instance = new CsApp());
        }

        public static CsApp Restore()
        {
            Instance = AppDomain.CurrentDomain.GetData("CsObj") as CsApp ?? Ref();
            return Instance;
        }

        public static bool StartupMode = false;
        public CsApp()
        {
            startRef = this;
            if (!StartupMode)
                Startup += AppMethods.App_Startup;
        }

#if NET40 || MONO || DOTNET
        [STAThread]
        public static void Main()
        {
            VfpProj.CsApp app = new VfpProj.CsApp();
            app.InitializeComponent();
            app.Run();
        }
#endif

#if !DOTNET

        private bool _contentLoaded;
        public void InitializeComponent()
        {
            if (_contentLoaded) return;
            _contentLoaded = true;
            var resourceLocater = new System.Uri("/VfpProj;component/csapp.xaml", System.UriKind.Relative);

            Application.LoadComponent(this, resourceLocater);
        }
#endif
    }
}
