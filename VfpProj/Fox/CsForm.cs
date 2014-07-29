using System;
using System.Runtime.InteropServices;

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

        bool _Form.IsDisposed { get { return Form != null; } }

        public VisualFoxpro.FoxApplication App
        {
            get { return FoxCmd.app.Application; }
            set
            {
                FoxCmd.app = value;
                FoxCmd.Attach();
            }
        }

        public string Directory { get; set; }
        public Native.WindowsEvents events { get { return Form.events; } }

        string _Form.Name { get { return "VfpProj.CsForm"; } }
        IntPtr _Form.Handle
        {
            get
            {
                return IntPtr.Zero;    //  this.HandlesScrolling }
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
        int _Form.Width { get { return Convert.ToInt32(Form.Width); } set { Form.Width = value; } }
        int _Form.Height { get { return Convert.ToInt32(Form.Height); } set { Form.Height = value; } }
        int _Form.Left { get { return Convert.ToInt32(Form.Left); } set { Form.Left = value; } }
        int _Form.Top { get { return Convert.ToInt32(Form.Top); } set { Form.Top = value; } }


    }
}
