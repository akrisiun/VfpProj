
using Microsoft.Win32;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using Forms = System.Windows.Forms;
using System.IO;
using System.Text;
using Folder.Native;
using System.Windows.Media.Imaging;
using VfpEdit;

namespace Folder
{
    public partial class FolderWindow : Window
    {
        public string FileName { get; set; }
        public Forms.TextBox txtPath { get; set; }
        internal TreeView treeObj;

        public FolderWindow()
        {
            // Uri iconUri = new Uri("pack://application:,,,/PRG.ICO", UriKind.RelativeOrAbsolute);
            Icon = MainWindow.PrgIco; //  BitmapFrame.Create(iconUri);
            if (MainWindow.Dll == null)
                MainWindow.Dll = "Folder";

            FileName = string.Empty;
            // InitializeComponent();
            if (!_contentLoaded)
            {
                _contentLoaded = true;
                System.Uri resourceLocater = new System.Uri(MainWindow.Dll + ";component/visual/folderwindow.xaml", System.UriKind.Relative);
                System.Windows.Application.LoadComponent(this, resourceLocater);
            }

            treeObj = this.tree;
            PostLoad();
        }

        void PostLoad()
        {
            txtPath = hostPath.Child as System.Windows.Forms.TextBox;
            txtPath.Text = Directory.GetCurrentDirectory();
            txtPath.SetFileAutoComplete();

            // TextDrop.Bind(this);
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

            string projName = info.vfpProj.Name;
            ProjTree.Load(w, w.tree, info.vfpProj, projName);

            if (Directory.Exists(dir))
                Directory.SetCurrentDirectory(dir); 
        }

    }

}
