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
using VfpProj;

namespace VfpProj
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            CsApp.Instance.Window = this;
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

            if (!_contentLoaded)
            {
                _contentLoaded = true;
                System.Uri resourceLocater = new System.Uri(Dll + ";component/mainwindow.xaml", System.UriKind.Relative);
                System.Windows.Application.LoadComponent(this, resourceLocater);
            }

            InitValues();
        }

    }
}
