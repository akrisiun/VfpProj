using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

namespace VfpProj
{
    public partial class MainWindow
    {
        public CsForm FormObject;
        public Native.WindowsEvents events;
        public bool IsStart;

        public static BitmapFrame PrgIco;
        public static string Dll { get; set; }

        public Button buttonCD { get; set; }
        public Button buttonModi { get; set; }
        public Button buttonDO { get; set; }
        public ComboBox comboCfg { get; set; }
        public TextBox txtFile { get; set; }

        public void InitValues()
        {
            buttonCD = this.cmdPanel.buttonCD;
            buttonCD = this.cmdPanel.buttonModi;
            txtFile = this.cmdPanel.txtFile;
            buttonDO = this.cmdPanel.buttonDO;
            comboCfg = this.cmdPanel.comboCfg;

            var list = new List<string>();
            list.Add("SA");
            list.Add("TS");
            list.Add("LV");
            list.Add("EE");
            comboCfg.ItemsSource = list;
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

            // this.hostFile.Visibility = System.Windows.Visibility.Visible;
            // this.Height = 49;

            SizeChanged += MainWindow_SizeChanged;
            if (!IsStart)
                ContentRendered += MainWindow_ContentRendered;

            Closing += MainWindow_Closing;
        }

        void MainWindow_ContentRendered(object sender, EventArgs e)
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
