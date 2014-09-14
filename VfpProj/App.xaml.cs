﻿using System;
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
using System.Windows.Media.Imaging;

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
        }

        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            Trace.Write(args.Exception.Message);
        }

        void App_Startup(object sender, StartupEventArgs e)
        {
            JumpList jumpList1 = JumpList.GetJumpList(App.Current);

            MainWindow window = new MainWindow();   // NoBorder 
            window.AllowsTransparency = false;
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
