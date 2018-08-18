﻿#if XAML

using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
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


namespace VfpProj.Visual {
    
    
    /// <summary>
    /// CmdPanel
    /// </summary>
    public partial class CmdPanel : System.Windows.Controls.UserControl, System.Windows.Markup.IComponentConnector {
        
        
#line 17 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ColumnDefinition cboCmd;
        
#line default
#line hidden
        
        
#line 18 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ColumnDefinition colCD;
        
#line default
#line hidden
        
        
#line 19 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ColumnDefinition colCbo;
        
#line default
#line hidden
        
        
#line 20 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ColumnDefinition colPjx;
        
#line default
#line hidden
        
        
#line 21 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ColumnDefinition colWcf;
        
#line default
#line hidden
        
        
#line 25 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button buttonModi;
        
#line default
#line hidden
        
        /// <summary>
        /// buttonDO Name Field
        /// </summary>
        
#line 31 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.Button buttonDO;
        
#line default
#line hidden
        
        
#line 37 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.StackPanel hostFile;
        
#line default
#line hidden
        
        
#line 41 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtFile;
        
#line default
#line hidden
        
        /// <summary>
        /// comboCfg Name Field
        /// </summary>
        
#line 52 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.ComboBox comboCfg;
        
#line default
#line hidden
        
        /// <summary>
        /// buttonCD Name Field
        /// </summary>
        
#line 57 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.Button buttonCD;
        
#line default
#line hidden
        
        /// <summary>
        /// comboPrj Name Field
        /// </summary>
        
#line 63 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.ComboBox comboPrj;
        
#line default
#line hidden
        
        /// <summary>
        /// buttonPrj Name Field
        /// </summary>
        
#line 67 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.Button buttonPrj;
        
#line default
#line hidden
        
        /// <summary>
        /// buttonWcf Name Field
        /// </summary>
        
#line 73 "Visual\CmdPanel.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        public System.Windows.Controls.Button buttonWcf;
        
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
            System.Uri resourceLocater = new System.Uri("/VfpProj2;component/visual/cmdpanel.xaml", System.UriKind.Relative);
            
#line 1 "Visual\CmdPanel.xaml"
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
            this.cboCmd = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 2:
            this.colCD = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 3:
            this.colCbo = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 4:
            this.colPjx = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 5:
            this.colWcf = ((System.Windows.Controls.ColumnDefinition)(target));
            return;
            case 6:
            this.buttonModi = ((System.Windows.Controls.Button)(target));
            return;
            case 7:
            this.buttonDO = ((System.Windows.Controls.Button)(target));
            return;
            case 8:
            this.hostFile = ((System.Windows.Controls.StackPanel)(target));
            return;
            case 9:
            this.txtFile = ((System.Windows.Controls.TextBox)(target));
            return;
            case 10:
            this.comboCfg = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 11:
            this.buttonCD = ((System.Windows.Controls.Button)(target));
            return;
            case 12:
            this.comboPrj = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 13:
            this.buttonPrj = ((System.Windows.Controls.Button)(target));
            return;
            case 14:
            this.buttonWcf = ((System.Windows.Controls.Button)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

#endif