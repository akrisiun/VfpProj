using System;
using System.Windows;
using System.Windows.Media.Imaging;

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
                Dll = "/VfpProj2";

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
