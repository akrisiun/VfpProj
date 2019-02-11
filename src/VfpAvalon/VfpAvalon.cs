using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;

namespace VfpProj
{
    public class VfpAvalon
    {
        static VfpAvalon()
        {
            //iconUri = new Uri("pack://application:,,," + Dll + ";component/prg.ico", UriKind.RelativeOrAbsolute);
            //MainWindow.PrgIco = BitmapFrame.Create(iconUri);
        }

        public static BitmapFrame PrgIco { get;set;}
        public static BitmapFrame Icon { get;set;}

        public static EditWindow ShowEditWindow(string file)
        {
            var winEdit = new EditWindow();
            winEdit.ShowInTaskbar = true;
            if (file.Length > 0) {
                winEdit.txtPath.Text = file;
                TextRead.Open(winEdit, winEdit.editorObj);
            }

            // Uri iconUri = new Uri("pack://application:,,,/PRG.ico", UriKind.RelativeOrAbsolute);
            // winEdit.Icon = BitmapFrame.Create(iconUri);
            winEdit.Show();
            return winEdit;
        }
    }

    internal class FileSystem
    { 
        public static string CurrentDirectory =>  System.IO.Directory.GetCurrentDirectory();
    }

    internal class MainWindow
    { 
        public static string Dll => "VfpAvalon.dll";
    }

    internal class FoxCmd
    {
        public static dynamic App { get; set; }
        // App.ActiveProject;
    }
}
