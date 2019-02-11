
using ICSharpCode.AvalonEdit.Utils;
using ICSharpCode.AvalonEdit.Highlighting;
using ICSharpCode.AvalonEdit.Folding;
using ICSharpCode.AvalonEdit.Indentation;
using Microsoft.Win32;
using System;
using System.Windows;
using System.Windows.Controls;
using Forms = System.Windows.Forms;
using System.IO;
using System.Text;
using AvalonEdit.Sample;
using ICSharpCode.AvalonEdit;
//using ICSharpCode.AvalonEdit;
//using System.Windows.Media.Imaging;

namespace VfpProj
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

        internal TreeView treeObj;
        internal ICSharpCode.AvalonEdit.TextEditor editorObj;

        internal GridLength zeroWidth, projWidth;  

        public EditWindow()
        {
            // Uri iconUri = new Uri("pack://application:,,,/PRG.ICO", UriKind.RelativeOrAbsolute);
            // Icon = MainWindow.PrgIco; //  BitmapFrame.Create(iconUri);

            FileName = string.Empty;

            // InitializeComponent();
            if (!_contentLoaded) {
                _contentLoaded = true;
                System.Uri resourceLocater = new System.Uri(MainWindow.Dll + ";component/visual/editwindow.xaml", System.UriKind.Relative);
                System.Windows.Application.LoadComponent(this, resourceLocater);
            }
            //editorObj
            //this.treeObj = tree;
            PostLoad();
        }

        bool _contentLoaded;

        void PostLoad()
        {
            //buttonOpen.Click += buttonOpen_Click;

            //txtPath = hostPath.Child as System.Windows.Forms.TextBox;
            //txtPath.Text = FileSystem.CurrentDirectory;
            //txtPath.SetFileAutoComplete();

            //xmlStrategy = new XmlFoldingStrategy();
            //csStrategy = new BraceFoldingStrategy();
            //editor.TextArea.IndentationStrategy = new DefaultIndentationStrategy();
            //foldManager = null;

            //defManager = HighlightingManager.Instance;
            //editor.SyntaxHighlighting = defManager.GetDefinitionByExtension(".cs");

            //TextDrop.BindEdit(this);

            //this.buttonProj.Click += buttonProj_Click;

            zeroWidth = new GridLength(0.0);
            projWidth = new GridLength(200.0);
        }

        void buttonProj_Click(object sender, RoutedEventArgs e)
        {
            //if (this.col3.Width.Value >= projWidth.Value)
            //    this.col3.Width = zeroWidth;
            //else
            //    this.col3.Width = projWidth;
        }

        void buttonOpen_Click(object sender, RoutedEventArgs e)
        {
            string dir = txtPath.Text.Trim();
            if (File.Exists(dir))
            {
                FileName = dir;
                TextEditor editor = this.editorObj;
                TextRead.Open(this, editor);
                return;
            }

            if (Directory.Exists(dir))
                Directory.SetCurrentDirectory(dir);

            OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();

            // Set filter for file extension and default file extension 
            dlg.DefaultExt = ".prg";
            dlg.Filter = filter;
            dlg.InitialDirectory = FileSystem.CurrentDirectory;

            // Display OpenFileDialog by calling ShowDialog method 
            Nullable<bool> result = dlg.ShowDialog();
            if (result != true)
                return;

            FileName = dlg.FileName.Replace(".PRG", ".prg");
            txtPath.Text = FileName;
            TextRead.Open(this, null);
        }

    }

}
