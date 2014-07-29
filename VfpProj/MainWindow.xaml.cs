using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using VfpEdit;

namespace VfpProj
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public CsForm form;
        public Native.WindowsEvents events;

        public MainWindow()
        {
            form = new CsForm();
            form.Form = this;
            events = new Native.WindowsEvents(this);

            InitializeComponent();
            SizeChanged += MainWindow_SizeChanged;
            Activated += MainWindow_Activated;
            (events as ISupportInitialize).BeginInit();
        }

        void MainWindow_Activated(object sender, EventArgs e)
        {
            (events as ISupportInitialize).EndInit();
        }

        void MainWindow_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            textFile.Width = Width - buttonCD.Width - buttonModi.Width - 50;
        }

    }
}
