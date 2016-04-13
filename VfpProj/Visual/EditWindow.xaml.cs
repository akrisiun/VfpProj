using ICSharpCode.AvalonEdit.Utils;
using ICSharpCode.AvalonEdit.Highlighting;
using ICSharpCode.AvalonEdit.Folding;
using ICSharpCode.AvalonEdit.Indentation;
using Microsoft.Win32;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using Forms = System.Windows.Forms;
using System.IO;
using System.Text;
using ICSharpCode.AvalonEdit;
using AvalonEdit.Sample;
using VfpProj.Native;
using System.Windows.Media.Imaging;
using VfpProj;

namespace VfpEdit
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class EditWindow : Window
    {
        const string filter = "code files|*.prg;*.cs;.x*;*.csproj;*.css;*.js;*.aspx|all files|*.*";
        public string FileName { get; set; }
        public Forms.TextBox txtPath { get; set; }

        internal HighlightingManager defManager;
        internal FoldingManager foldManager;
        internal XmlFoldingStrategy xmlStrategy;
        internal BraceFoldingStrategy csStrategy;

        public EditWindow()
        {
            // Uri iconUri = new Uri("pack://application:,,,/PRG.ICO", UriKind.RelativeOrAbsolute);
            Icon = MainWindow.PrgIco; //  BitmapFrame.Create(iconUri);

            FileName = string.Empty;

            // InitializeComponent();
            if (!_contentLoaded)
            {
                _contentLoaded = true;
                System.Uri resourceLocater = new System.Uri(MainWindow.Dll + ";component/visual/editwindow.xaml", System.UriKind.Relative);
                System.Windows.Application.LoadComponent(this, resourceLocater);
            }
            PostLoad();
        }

        void PostLoad()
        {
            buttonOpen.Click += buttonOpen_Click;

            txtPath = hostPath.Child as System.Windows.Forms.TextBox;
            txtPath.Text = Directory.GetCurrentDirectory();
            txtPath.SetFileAutoComplete();

            xmlStrategy = new XmlFoldingStrategy();
            csStrategy = new BraceFoldingStrategy();
            editor.TextArea.IndentationStrategy = new DefaultIndentationStrategy();
            foldManager = null;

            defManager = HighlightingManager.Instance;
            editor.SyntaxHighlighting = defManager.GetDefinitionByExtension(".cs");

            TextDrop.Bind(this);

            this.buttonProj.Click += buttonProj_Click;
        }

        void buttonProj_Click(object sender, RoutedEventArgs e)
        {
            this.col3.Width = new GridLength(200.0);
        }

        void buttonOpen_Click(object sender, RoutedEventArgs e)
        {
            string dir = txtPath.Text.Trim();
            if (File.Exists(dir))
            {
                FileName = dir;
                TextRead.Open(this);
                return;
            }

            if (Directory.Exists(dir))
                Directory.SetCurrentDirectory(dir);

            OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();

            // Set filter for file extension and default file extension 
            dlg.DefaultExt = ".prg";
            dlg.Filter = filter;
            dlg.InitialDirectory = Directory.GetCurrentDirectory();

            // Display OpenFileDialog by calling ShowDialog method 
            Nullable<bool> result = dlg.ShowDialog();
            if (result != true)
                return;

            FileName = dlg.FileName.Replace(".PRG", ".prg");
            txtPath.Text = FileName;
            TextRead.Open(this);
        }

    }

}
