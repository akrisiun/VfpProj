using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using System.Windows.Navigation;
using System.Windows.Shell;
using System.Windows.Forms.Integration;
using VfpEdit;
using System.Threading;

namespace VfpProj
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {

        public static App Instance
        {
            [DebuggerStepThrough]
            get { return Application.Current as App; }
        }

        public App()
        {
            Startup += App_Startup;
            // Application.Current.Th
            // res = Application.LoadComponent(uri) as ResourceDictionary;
        }

        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            Trace.Write(args.Exception.Message);
        }

        void App_Startup(object sender, StartupEventArgs e)
        {
            JumpList jumpList1 = JumpList.GetJumpList(App.Current);

            MainWindow window = new MainWindow();
            window.Show();

            if (FoxCmd.Attach())
                FoxCmd.CreateForm(window);
        }

        public EditWindow ShowEditWindow()
        {
            var winEdit = new EditWindow();
            winEdit.ShowInTaskbar = true;

            /*
            string key = "Editor";
            Uri uri = new Uri("/VfpProj;component/editpanel.xaml", System.UriKind.Relative);

            // Style textStyle = res[key] as Style;
            // DependencyObject obj = new UIElement() { Content = }
            try
            {
                var res = Application.LoadComponent(uri) as ResourceDictionary;
                var textStyle = res[key] as Style;
                winEdit.Content = new ICSharpCode.AvalonEdit.TextEditor() { Style = textStyle };
            }
            catch (Exception ex)
            {
                Trace.Write(ex.Message);
            }
            */
            winEdit.Show();
            return winEdit;
        }
    }
}
