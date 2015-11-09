using System;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using Vfp;

namespace VfpProj
{
    [Guid("c155b373-563f-433f-8fcf-18fd98100004")]
    [ClassInterface(ClassInterfaceType.AutoDispatch)]
    [ProgId("VfpProj.Form")]
    [ComVisible(true)]
    public class CsForm : _Form
    {
        public MainWindow Form { get; set; }

        public CsForm()
        {
            Form = null;
            Directory = string.Empty;
        }

        public bool IsDisposed { get { return Form != null; } }

        public CsObj Object { get { return FoxCmd.ocs; } }

        public _Startup Instance { get { return Startup.Instance; } }

        public VisualFoxpro.FoxApplication App
        {
            get { return FoxCmd.App.Application; }
            set
            {
                if (value != null)
                    FoxCmd.SetApp(value);
                FoxCmd.Attach();
            }
        }

        public string Directory { get; set; }
        public Native.WindowsEvents Events { get { return Form.events; } }

        string _Form.Name { get { return "VfpProj._Form.CsForm"; } }

        public string Name { get { return "VfpProj.CsForm"; } }

        IntPtr? hWnd = null;
        public IntPtr Handle
        {
            get
            {
                if (hWnd == null)
                {
                    var wih = new WindowInteropHelper(Form);
                    hWnd = wih.Handle;
                }
                return hWnd ?? IntPtr.Zero;
            }
        }
        public bool OnTop
        {
            get
            {
                if (Form != null && Form.Dispatcher.CheckAccess())
                    return Form.Topmost;
                if (Form != null)
                    return Form.Dispatcher.Invoke<bool>(() => { return Form.Topmost; });
                else return false;
            }
            set
            {
                if (Form != null && Form.Dispatcher.CheckAccess())
                    Form.Topmost = value;
                else if (Form != null)
                    Form.Dispatcher.Invoke(() => { Form.Topmost = value; });
            }
        }

        public bool AlwaysOnTop
        {
            get { return OnTop; }
            set { OnTop = value; }
        }

        public string Text
        {
            get
            {
                if (Form != null && Form.Dispatcher.CheckAccess())
                    return Form.Title;
                if (Form != null)
                    return Form.Dispatcher.Invoke<string>(() => { return Form.Title; });
                else return null;
            }
            set
            {
                if (Form != null && Form.Dispatcher.CheckAccess())
                    Form.Title = value;
                else if (Form != null)
                    Form.Dispatcher.Invoke(() => { Form.Title = value; });
            }
        }

        public bool Visible
        {
            get { return (Form == null) ? false : Form.IsVisible; }
            set
            {
                if (Form.IsVisible != value && !value)
                    Form.Hide();
                else if (Form.IsVisible != value && value)
                    Form.Show();
            }

        }

        public int Width
        {
            get
            {
                if (Form == null) return -1;
                if (Form.Dispatcher.CheckAccess())
                    return Convert.ToInt32(Form.Width);
                return Form.Dispatcher.Invoke<int>(() =>
                {
                    return Convert.ToInt32(Form.Width);
                });
            }
            set
            {
                if (Form == null) return;
                if (Form.Dispatcher.CheckAccess())
                    Form.Width = value;
                else
                    Form.Dispatcher.Invoke(() =>
                    {
                        Form.Width = value;
                    });
            }
        }
        public int Height
        {
            get
            {
                if (Form == null) return -1;
                if (Form.Dispatcher.CheckAccess())
                    return Convert.ToInt32(Form.Height);
                return Form.Dispatcher.Invoke<int>(() =>
                {
                    return Convert.ToInt32(Form.Height);
                });
            }
            set
            {
                if (Form == null) return;
                if (Form.Dispatcher.CheckAccess())
                    Form.Height = value;
                else
                    Form.Dispatcher.Invoke(() =>
                    {
                        Form.Height = value;
                    });
            }
        }
        public int Left
        {
            get
            {
                if (Form == null) return -1;
                if (Form.Dispatcher.CheckAccess())
                    return Convert.ToInt32(Form.Left);
                return Form.Dispatcher.Invoke<int>(() =>
                {
                    return Convert.ToInt32(Form.Left);
                });
            }
            set
            {
                if (Form == null) return;
                if (Form.Dispatcher.CheckAccess())
                    Form.Left = value;
                else
                    Form.Dispatcher.Invoke(() =>
                    {
                        Form.Left = value;
                    });
            }
        }
        public int Top
        {
            get
            {
                if (Form == null) return -1;
                if (Form.Dispatcher.CheckAccess())
                    return Convert.ToInt32(Form.Top);
                return Form.Dispatcher.Invoke<int>(() =>
                {
                    return Convert.ToInt32(Form.Top);
                });
            }
            set
            {
                if (Form == null) return;
                if (Form.Dispatcher.CheckAccess())
                    Form.Top = value;
                else
                    Form.Dispatcher.Invoke(() =>
                    {
                        Form.Top = value;
                    });
            }
        }

    }
}
