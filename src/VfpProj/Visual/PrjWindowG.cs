#if XAML

using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;


namespace VfpProj {
    
    
    /// <summary>
    /// PrjWindow
    /// </summary>
    public partial class PrjWindow : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
#line 6 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Grid panelPrj;
        
#line default
#line hidden
        
        /// <summary>
        /// col3 Name Field
        /// </summary>
        
#line 12 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.ColumnDefinition col3;
        
#line default
#line hidden
        
        
#line 15 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Forms.Integration.WindowsFormsHost hostPath;
        
#line default
#line hidden
        
        
#line 24 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button buttonProj;
        
#line default
#line hidden
        
        
#line 29 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DockPanel dockProj;
        
#line default
#line hidden
        
        /// <summary>
        /// tree Name Field
        /// </summary>
        
#line 31 "Visual\PrjWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.TreeView tree;
        
#line default
#line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/VfpProj2;component/visual/prjwindow.xaml", System.UriKind.Relative);
            
#line 1 "Visual\PrjWindow.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
#line default
#line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.panelPrj = ((System.Windows.Controls.Grid)(target));
            return;
            case 2:
            this.col3 = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 3:
            this.hostPath = ((System.Windows.Forms.Integration.WindowsFormsHost)(target));
            return;
            case 4:
            this.buttonProj = ((System.Windows.Controls.Button)(target));
            return;
            case 5:
            this.dockProj = ((System.Windows.Controls.DockPanel)(target));
            return;
            case 6:
            this.tree = ((System.Windows.Controls.TreeView)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

#endif