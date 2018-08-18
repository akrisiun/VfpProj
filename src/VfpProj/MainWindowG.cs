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
using VfpProj.Visual;


namespace VfpProj {
    
    
    /// <summary>
    /// MainWindow
    /// </summary>
    public partial class MainWindow : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
#line 10 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Border border;
        
#line default
#line hidden
        
        /// <summary>
        /// titleBar Name Field
        /// </summary>
        
#line 33 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.TextBlock titleBar;
        
#line default
#line hidden
        
        
#line 38 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button cmdClose;
        
#line default
#line hidden
        
        /// <summary>
        /// cmdPanel Name Field
        /// </summary>
        
#line 41 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public VfpProj.Visual.CmdPanel cmdPanel;
        
#line default
#line hidden
        
        
#line 44 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ContentControl content;
        
#line default
#line hidden
        
        /// <summary>
        /// tabList Name Field
        /// </summary>
        
#line 54 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public VfpProj.Visual.VfpTabs tabList;
        
#line default
#line hidden
        
        /// <summary>
        /// topLeft Name Field
        /// </summary>
        
#line 63 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle topLeft;
        
#line default
#line hidden
        
        /// <summary>
        /// top Name Field
        /// </summary>
        
#line 65 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle top;
        
#line default
#line hidden
        
        /// <summary>
        /// topRight Name Field
        /// </summary>
        
#line 67 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle topRight;
        
#line default
#line hidden
        
        /// <summary>
        /// right Name Field
        /// </summary>
        
#line 69 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle right;
        
#line default
#line hidden
        
        /// <summary>
        /// bottomRight Name Field
        /// </summary>
        
#line 71 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle bottomRight;
        
#line default
#line hidden
        
        /// <summary>
        /// bottom Name Field
        /// </summary>
        
#line 73 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle bottom;
        
#line default
#line hidden
        
        /// <summary>
        /// bottomLeft Name Field
        /// </summary>
        
#line 75 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle bottomLeft;
        
#line default
#line hidden
        
        /// <summary>
        /// left Name Field
        /// </summary>
        
#line 77 "MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Shapes.Rectangle left;
        
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
            System.Uri resourceLocater = new System.Uri("/VfpProj2;component/mainwindow.xaml", System.UriKind.Relative);
            
#line 1 "MainWindow.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
#line default
#line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal System.Delegate _CreateDelegate(System.Type delegateType, string handler) {
            return System.Delegate.CreateDelegate(delegateType, this, handler);
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
            this.border = ((System.Windows.Controls.Border)(target));
            return;
            case 2:
            this.titleBar = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 3:
            this.cmdClose = ((System.Windows.Controls.Button)(target));
            return;
            case 4:
            this.cmdPanel = ((VfpProj.Visual.CmdPanel)(target));
            return;
            case 5:
            this.content = ((System.Windows.Controls.ContentControl)(target));
            return;
            case 6:
            this.tabList = ((VfpProj.Visual.VfpTabs)(target));
            return;
            case 7:
            this.topLeft = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 8:
            this.top = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 9:
            this.topRight = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 10:
            this.right = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 11:
            this.bottomRight = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 12:
            this.bottom = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 13:
            this.bottomLeft = ((System.Windows.Shapes.Rectangle)(target));
            return;
            case 14:
            this.left = ((System.Windows.Shapes.Rectangle)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}


#endif