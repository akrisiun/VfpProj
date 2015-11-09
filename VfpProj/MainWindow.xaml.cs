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
        public CsForm FormObject;
        public Native.WindowsEvents events;
        public bool IsStart;

        public static BitmapFrame PrgIco;

        public static string Dll { get; set; }

        public MainWindow()
        {
            App.Instance.Window = this;
            IsStart = false;

            if (Dll == null)
                Dll = "/VfpProj";

            Uri iconUri;
            try
            {
                iconUri = new Uri("pack://application:,,," + Dll + ";component/PRG.ico", UriKind.RelativeOrAbsolute);
                MainWindow.PrgIco = BitmapFrame.Create(iconUri);

                // Resources/
                iconUri = iconUri = new Uri("pack://application:,,," + Dll + ";component/PJX.ico", UriKind.RelativeOrAbsolute);
                Icon = BitmapFrame.Create(iconUri);
            }
            catch (Exception) { }

            if (_contentLoaded)
            {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri(Dll + ";component/mainwindow.xaml", System.UriKind.Relative);
            System.Windows.Application.LoadComponent(this, resourceLocater);

            // WindowStyle = System.Windows.WindowStyle.None;
        }

        public void Load(VisualFoxpro.FoxApplication app = null)
        {
            FormObject = new CsForm();
            FormObject.Form = this;
            FoxCmd.SetFormObj(FormObject);

            events = new Native.WindowsEvents(this);

            if (app != null)
                FoxCmd.SetApp(app);
            if (FoxCmd.Attach())
                FoxCmd.CreateForm(this);

            var window = this; // NoBorder init
            Native.WpfNoBorder.Init(window, window.titleBar, window.topLeft, window.top, window.topRight,
                   window.right, window.bottomRight, window.bottom, window.bottomLeft, window.left);
            window.cmdClose.Click += (s, evt) => window.Close();

            this.hostFile.Visibility = System.Windows.Visibility.Visible;
            // this.Height = 49;

            SizeChanged += MainWindow_SizeChanged;

            if (!this.IsStart)
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


        private static readonly Thickness MainBorderMaximizedPadding = new Thickness(13);
        private static readonly Thickness MainBorderNormalPadding = new Thickness(5);

        protected override void OnStateChanged(EventArgs e)
        {

            // bdrRoot.Padding = WindowState == WindowState.Maximized ? MainBorderMaximizedPadding : MainBorderNormalPadding;
        }


        ~MainWindow()
        {
            FoxCmd.Dispose();
        }

        void MainWindow_Closing(object sender, CancelEventArgs e)
        {
            if (!FoxCmd.QueryUnload())
                e.Cancel = true;

            App.Current.Shutdown();
        }


        void MainWindow_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            // txtFile.Width = Width - buttonCD.Width - buttonModi.Width - 50;
        }

    }
}
