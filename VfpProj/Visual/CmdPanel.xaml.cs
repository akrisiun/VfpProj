using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace VfpProj.Visual
{
    /// <summary>
    /// Interaction logic for CmdPanel.xaml
    /// </summary>
    public partial class CmdPanel : UserControl
    {
        public CmdPanel()
        {
            InitializeComponent();

            // {"'The invocation of the constructor on type 'System.Windows.Controls.TextBox' 
            // that matches the specified binding constraints threw an exception.' Line number '39' and line position '14'."}
        }

        public override void BeginInit()
        {
            // const uint InitPending = 0x00010000;
            WriteInternalFlag(InternalFlags.InitPending, false);

            base.BeginInit();
        }

        public override void EndInit()
        {
            base.EndInit();
        }
    }
}
