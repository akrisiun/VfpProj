using ICSharpCode.AvalonEdit.Utils;
using ICSharpCode.AvalonEdit.Highlighting;
using ICSharpCode.AvalonEdit.Folding;
using ICSharpCode.AvalonEdit.Indentation;
using Microsoft.Win32;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using System.IO;
using System.Text;
using ICSharpCode.AvalonEdit;
using AvalonEdit.Sample;

namespace VfpEdit
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class EditWindow : Window
    {
        string fileName;
        HighlightingManager defManager;
        FoldingManager foldManager;
        XmlFoldingStrategy xmlStrategy;
        
        BraceFoldingStrategy csStrategy;

        //  Button button1;
        //  TextBox text1;
        //  TextEditor editor;

        public EditWindow()
        {
            Loaded += EditWindow_Loaded;
            fileName = string.Empty;
            InitializeComponent();
            PostLoad();
        }

        void PostLoad()
        {
            button1.Click += button1_Click;
            text1.Text = Directory.GetCurrentDirectory();

            xmlStrategy = new XmlFoldingStrategy();
            csStrategy = new BraceFoldingStrategy();
            editor.TextArea.IndentationStrategy = new DefaultIndentationStrategy();
            foldManager = null; // FoldingManager.Install(editor.TextArea);

            defManager = HighlightingManager.Instance;
            editor.SyntaxHighlighting = defManager.GetDefinitionByExtension(".cs");
        }

        protected override void OnContentChanged(object oldContent, object newContent)
        {
            base.OnContentChanged(oldContent, newContent);
        }

        void EditWindow_Loaded(object sender, RoutedEventArgs e)
        {
             //    throw new NotImplementedException();
        }

        void button1_Click(object sender, RoutedEventArgs e)
        {
            string dir = text1.Text.Trim();
            if (Directory.Exists(dir))
                Directory.SetCurrentDirectory(dir);

            OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();

            // Set filter for file extension and default file extension 
            dlg.DefaultExt = ".prg";
            dlg.Filter = "code files|*.prg;*.cs;.x*;*.csproj;*.css;*.js;*.aspx|all files|*.*";
            dlg.InitialDirectory = Directory.GetCurrentDirectory();

            // Display OpenFileDialog by calling ShowDialog method 
            Nullable<bool> result = dlg.ShowDialog();
            if (result != true)
                return;

            fileName = dlg.FileName.Replace(".PRG", ".prg");
            text1.Text = fileName;
            FileInfo f = new FileInfo(fileName);
            if (!f.Exists)
                return;
            Directory.SetCurrentDirectory(Path.GetDirectoryName(fileName));

            if (foldManager != null)
                FoldingManager.Uninstall(foldManager);            

            using(var stream = FileReader.OpenFile(fileName, Encoding.GetEncoding(1257)))
            {
                editor.Text = stream.ReadToEnd();
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
