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
        static CsApp() { } // debugger entry

        static CsApp startRef;

        public static CsApp Instance {
            [DebuggerStepThrough]
            get { return startRef ?? Application.Current as CsApp; }
            set { startRef = value; }
        }

        public MainWindow Window { get; set; }

        public static CsApp Ref()
        {
            return Instance ?? new CsApp();
        }

        public static bool StartupMode = false;
        public CsApp()
        {
            startRef = this;
            if (!StartupMode)
                Startup += AppMethods.App_Startup;
        }
    }
}
