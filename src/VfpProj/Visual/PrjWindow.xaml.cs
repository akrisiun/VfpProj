//using ICSharpCode.AvalonEdit.Utils;
//using ICSharpCode.AvalonEdit.Highlighting;
//using ICSharpCode.AvalonEdit.Folding;
//using ICSharpCode.AvalonEdit.Indentation;
//using ICSharpCode.AvalonEdit;
//using AvalonEdit.Sample;
using System;
using System.Windows;
using System.Windows.Controls;
using Forms = System.Windows.Forms;
using System.IO;
using VfpProj.Native;
using VfpProj;

namespace VfpProj
{
    // xmlns:avalonedit="clr-namespace:ICSharpCode.AvalonEdit;assembly=ICSharpCode.AvalonEdit"

    public partial class PrjWindow : Window
    {
        public string FileName { get; set; }
        public Forms.TextBox txtPath { get; set; }
        internal TreeView treeObj;

        public PrjWindow()
        {
            // Uri iconUri = new Uri("pack://application:,,,/PRG.ICO", UriKind.RelativeOrAbsolute);
            Icon = MainWindow.PrgIco; //  BitmapFrame.Create(iconUri);

            FileName = string.Empty;
            InitializeComponent();
            if (!_contentLoaded)
            {
                _contentLoaded = true;
                System.Uri resourceLocater = new System.Uri(MainWindow.Dll + ";component/visual/prjwindow.xaml", System.UriKind.Relative);
                System.Windows.Application.LoadComponent(this, resourceLocater);
            }

            treeObj = this.tree;
            PostLoad();
        }

        void PostLoad()
        {
            Tree.Bind(this);

            TextDrop.BindPrjEdit(this, txtPath);
        }

        void buttonOpen_Click(object sender, RoutedEventArgs e)
        {
            var w = this;
            string dir = txtPath.Text.Trim();

            var info = new VfpFileInfo();

            if (File.Exists(dir))
            {
                TextRead.ReadVfpInfo(ref info, ref dir, (f) => { 
                
                    }
                );

                FileName = dir;
                return;
            }

            if (Directory.Exists(dir))
                Directory.SetCurrentDirectory(dir);

            string projName = "";
            try
            {
                // projName = info.vfpProj.Name; // ["Name"] as string;
            }
            catch { }
            ProjTree.Load(w, w.tree, info.vfpProj, projName);

        }

    }

}
