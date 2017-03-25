using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Shell;
using System.Threading;

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
            // Startup += App_Startup;
            if (!StartupMode)
                Startup += App_StartupLoad2;
        }

        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            var ex = args.Exception;
            if (CsApp.Instance.Window.FormObject != null)
                CsApp.Instance.Window.FormObject.LastError = ex;

            Trace.Write(ex.Message);
        }

        void App_StartupLoad(object sender, StartupEventArgs e)
        {
            Vfp.Startup.Instance.LoadMain(null);
        }

        void App_StartupLoad2(object sender, StartupEventArgs e)
        {
            Vfp.Startup.Instance.LoadMain(null);

            try
            {
                var app = new VisualFoxpro.FoxApplication();
                app.Visible = true;
                FoxCmd.SetApp(app);
                FoxCmd.SetVar();

                var inst = Vfp.Startup.Instance;
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
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        void App_Startup(object sender, StartupEventArgs e)
        {
            JumpList jumpList1 = JumpList.GetJumpList(CsApp.Current);

            MainWindow window = new MainWindow();   // NoBorder 
            window.AllowsTransparency = false;
            window.Load(null);
            window.Show();

            if (FoxCmd.Attach())
                FoxCmd.AssignForm(window);
        }

        public EditWindow ShowEditWindow(string file)
        {
            var winEdit = new EditWindow();
            winEdit.ShowInTaskbar = true;
            if (file.Length > 0)
            {
                winEdit.txtPath.Text = file;
                TextRead.Open(winEdit);
            }

            // Uri iconUri = new Uri("pack://application:,,,/PRG.ico", UriKind.RelativeOrAbsolute);
            // winEdit.Icon = BitmapFrame.Create(iconUri);
            winEdit.Show();
            return winEdit;
        }
    }
}
