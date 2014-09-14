using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
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

        public static BitmapFrame PrgIco;

        public MainWindow()
        {
            Uri iconUri;
            iconUri = new Uri("pack://application:,,,/PRG.ico", UriKind.RelativeOrAbsolute);
            MainWindow.PrgIco = BitmapFrame.Create(iconUri);

            iconUri = new Uri("pack://application:,,,/PJX.ico", UriKind.RelativeOrAbsolute);
            Icon = BitmapFrame.Create(iconUri);

            form = new CsForm();
            form.Form = this;
            events = new Native.WindowsEvents(this);

            // WindowStyle = System.Windows.WindowStyle.SingleBorderWindow;
            InitializeComponent();
            // WindowStyle = System.Windows.WindowStyle.None;

            var window = this; // NoBorder init
            Native.WpfNoBorder.Init(window, window.titleBar, window.topLeft, window.top, window.topRight,
                   window.right, window.bottomRight, window.bottom, window.bottomLeft, window.left);
            window.cmdClose.Click += (s, evt) => window.Close();
            titleBar.MouseDown += (s, evt) => {
                this.Topmost = !this.Topmost;
            };


            // SizeChanged += MainWindow_SizeChanged;
            ContentRendered += (s, e)
                =>
                {
                    // this.border.Effect = new DropShadowEffect();
                    /*
                    {
                        Color = Color.FromRgb(0, 0, 0),
                        Direction = 270,
                        BlurRadius = 10,
                        ShadowDepth = 2
                    }; */
                    events.AfterRendered();
                };
            Closing += MainWindow_Closing;
        }

        ~MainWindow()
        {
            FoxCmd.Dispose();
        }

        void MainWindow_Closing(object sender, CancelEventArgs e)
        {
            if (!FoxCmd.QueryUnload())
                e.Cancel = true;
        }

    }
}
