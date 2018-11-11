using System;
using System.Windows;

namespace VfpProj
{
    /// <summary>
    /// Interaction logic for NoBorder.xaml
    /// </summary>
    public partial class NoBorder : Window, System.Windows.Markup.IComponentConnector
    {
        public NoBorder()
        {
            InitializeComponent();

            Native.WpfNoBorder.Init(this, titleBar,
                topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left);
            cmdClose.Click += (s, e) => Close();
        }

#if MONO  // #if !DOTNET
        internal System.Windows.Controls.DockPanel titleBar;
            internal System.Windows.Controls.Button cmdClose;
            internal System.Windows.Controls.ContentControl content;
            internal System.Windows.Shapes.Rectangle topLeft;
            internal System.Windows.Shapes.Rectangle top;
            internal System.Windows.Shapes.Rectangle topRight;
            internal System.Windows.Shapes.Rectangle right;
            internal System.Windows.Shapes.Rectangle bottomRight;
            internal System.Windows.Shapes.Rectangle bottom;
            internal System.Windows.Shapes.Rectangle bottomLeft;
            internal System.Windows.Shapes.Rectangle left;

            private bool _contentLoaded;
            public void InitializeComponent()
            {
                if (_contentLoaded) return;
                _contentLoaded = true;

                System.Uri resourceLocater = new System.Uri("/VfpProj;component/native/noborder.xaml", System.UriKind.Relative);

                System.Windows.Application.LoadComponent(this, resourceLocater);
            }

            void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target)
            {
                switch (connectionId)
                {
                    case 1:
                        this.titleBar = ((System.Windows.Controls.DockPanel)(target));
                        return;
                    case 2:
                        this.cmdClose = ((System.Windows.Controls.Button)(target));
                        return;
                    case 3:
                        this.content = ((System.Windows.Controls.ContentControl)(target));
                        return;
                    case 4:
                        this.topLeft = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 5:
                        this.top = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 6:
                        this.topRight = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 7:
                        this.right = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 8:
                        this.bottomRight = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 9:
                        this.bottom = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 10:
                        this.bottomLeft = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                    case 11:
                        this.left = ((System.Windows.Shapes.Rectangle)(target));
                        return;
                }
                this._contentLoaded = true;
            }
#endif
    }

}