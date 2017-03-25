using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.IO;
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
        // public static BitmapFrame PrjIco; // TODO

        public static string Dll { get; set; }

        public Button buttonCD { get; set; }
        public Button buttonPrj { get; set; }

        public Button buttonModi { get; set; }
        public Button buttonDO { get; set; }
        public Button buttonWcf { get; set; }

        public ComboBox comboPrj { get; set; }
        public ComboBox comboCfg { get; set; }
        public TextBox txtFile { get; set; }

        public void InitValues()
        {
            buttonCD = this.cmdPanel.buttonCD;
            buttonPrj = this.cmdPanel.buttonPrj;
            buttonModi = this.cmdPanel.buttonModi;
            buttonDO = this.cmdPanel.buttonDO;
            txtFile = this.cmdPanel.txtFile;
            comboCfg = this.cmdPanel.comboCfg;

            buttonWcf = this.cmdPanel.buttonWcf;
            comboPrj = this.cmdPanel.comboPrj;
            comboPrj.Visibility = Visibility.Collapsed; // TODO

            var cfFile = System.AppDomain.CurrentDomain.BaseDirectory + @"cmd.cfg";
            ReadCfg(cfFile);
        }

        public void ReadCfg(string cfFile)
        {
            var cfgCmd = ConfigurationManager.AppSettings["loadcmd"];
            if (!string.IsNullOrWhiteSpace(cfgCmd) && File.Exists(cfgCmd))
                cfFile = Path.GetFullPath(cfgCmd);

            string[] commands = null;
            var list = new List<string>();

            if (File.Exists(cfFile))
            {
                commands = File.ReadAllLines(cfFile);
                if (commands.Length > 0)
                    foreach (string line in commands)
                        list.Add(line);
            }

            if (list.Count == 0)
                list.Add("CLEAR ALL;CANCEL");

            comboCfg.ItemsSource = list;
            comboCfg.SelectionChanged += ComboCfg_SelectionChanged;

            IsRendered = false;
            this.ContentRendered += MainWindow_ContentRendered;

            FoxCmd.DefPosition(this);

            // <add key="formTop" value="0" />
            // <add key="formLeft" value="0" />
            var cfg_formTop = ConfigurationManager.AppSettings["formTop"];
            var int_formTop  = ToInt(cfg_formTop);
            if (int_formTop.HasValue)
                this.SetValue(Window.TopProperty, (double)int_formTop);
            var cfg_formLeft = ConfigurationManager.AppSettings["formLeft"];
            var int_formLeft = ToInt(cfg_formLeft);
            if (int_formLeft.HasValue)
                this.SetValue(Window.LeftProperty, (double)int_formLeft);
        }
        
        static int? ToInt(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return null;
            int intValue = 0;
            if (Int32.TryParse(value, out intValue))
                return intValue;
            return null;
        }

        private void ComboCfg_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (e.AddedItems.Count == 0)
                return;

            txtFile.Text = e.AddedItems[0] as string;
        }

        public void ReLoad()
        {
            if (txtFile == null)
                InitValues();
            if (events == null)
                Load(FoxCmd.App);
        }

        public void Load(VisualFoxpro.FoxApplication app = null)
        {
            FormObject = FormObject ?? new CsForm();
            FoxCmd.SetFormObj(FormObject);
            FoxCmd.FormObj.SetForm(this);

            events = new Native.WindowsEvents(this);

            if (app != null)
                FoxCmd.SetApp(app);
            if (FoxCmd.Attach())
                FoxCmd.AssignForm(this);

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

        public bool IsRendered { get; protected set; }

        void MainWindow_ContentRendered(object sender, EventArgs e)
        {
            IsRendered = true;
            // this.border.Effect = new DropShadowEffect();
            /*
            {
                Color = Color.FromRgb(0, 0, 0),
                Direction = 270,
                BlurRadius = 10,
                ShadowDepth = 2
            }; */
            events.AfterRendered();

            var inst = Vfp.Startup.Instance;
            if (FoxCmd.App != null && inst != null && inst.Then != null)
            {
                inst.Then(FoxCmd.App);
                inst.Then = null;
            }
        }

        private static readonly Thickness MainBorderMaximizedPadding = new Thickness(13);
        private static readonly Thickness MainBorderNormalPadding = new Thickness(5);

        protected override void OnStateChanged(EventArgs e)
        {
            // bdrRoot.Padding = WindowState == WindowState.Maximized ? MainBorderMaximizedPadding : MainBorderNormalPadding;
        }


        ~MainWindow()
        {
            if (this.FormObject != null)
            {
                this.FormObject.SetForm(null);
                this.FormObject = null;
            }
            // FoxCmd.Dispose();
        }

        void MainWindow_Closing(object sender, CancelEventArgs e)
        {
            if (!FoxCmd.QueryUnload())
            {
                if (FoxCmd.App.hWnd > 0)
                {
                    e.Cancel = true;
                    FoxCmd.AppCmd("ON SHUTDOWN; QUIT");
                    return;
                }
            }

            if (CsApp.Current != null)
            {
                FoxCmd.SetApp(null);
                FoxCmd.SetFormObj(null);
                CsApp.Current.Shutdown();
            }
        }


        void MainWindow_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            // txtFile.Width = Width - buttonCD.Width - buttonModi.Width - 50;
        }

    }
}
