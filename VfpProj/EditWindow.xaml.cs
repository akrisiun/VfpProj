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
        string fileName;
        HighlightingManager defManager;
        FoldingManager foldManager;
        XmlFoldingStrategy xmlStrategy;
        
        BraceFoldingStrategy csStrategy;
        public Forms.TextBox txtPath;

        public EditWindow()
        {
            // Uri iconUri = new Uri("pack://application:,,,/PRG.ICO", UriKind.RelativeOrAbsolute);
            Icon = MainWindow.PrgIco; //  BitmapFrame.Create(iconUri);

            fileName = string.Empty;
            InitializeComponent();
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
            foldManager = null; // FoldingManager.Install(editor.TextArea);

            defManager = HighlightingManager.Instance;
            editor.SyntaxHighlighting = defManager.GetDefinitionByExtension(".cs");
        }

        void buttonOpen_Click(object sender, RoutedEventArgs e)
        {
            string dir = txtPath.Text.Trim();
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

            fileName = dlg.FileName.Replace(".PRG", ".prg");
            txtPath.Text = fileName;
            OpenFile();

        }

        public void OpenFile()
        {
            string fileName = txtPath.Text;
            FileInfo f = new FileInfo(fileName);
            if (!f.Exists)
                return;
            Title = Path.GetFileName(fileName) + " " + Path.GetDirectoryName(fileName);

            Directory.SetCurrentDirectory(Path.GetDirectoryName(fileName));

            if (foldManager != null)
                FoldingManager.Uninstall(foldManager);

            try
            {
                using (var stream = FileReader.OpenFile(fileName, Encoding.GetEncoding(1257)))
                {
                    editor.Text = stream.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("File " + fileName + " error\n" + ex);
            }

            string ext = Path.GetExtension(fileName);
            editor.SyntaxHighlighting = defManager.GetDefinitionByExtension(ext);
            var doc = editor.Document;
            var area = editor.TextArea;
            foldManager = FoldingManager.Install(area);

            if (ext.Contains(".x") || ext.Contains(".a") || ext.Contains(".csproj"))
                xmlStrategy.UpdateFoldings(foldManager, doc);
            else
                csStrategy.UpdateFoldings(foldManager, doc);

            // int firstError = -1;
            // foldManager.UpdateFoldings(this.foldStrategy.CreateNewFoldings(doc, out firstError), firstError);
        }
    }

}
