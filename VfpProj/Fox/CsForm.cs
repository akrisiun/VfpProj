using System;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interop;
using System.ComponentModel;
using IO = System.IO;
using Vfp;

namespace VfpProj
{
    [Guid("c155b373-563f-433f-8fcf-18fd98100014")]
    [ClassInterface(ClassInterfaceType.AutoDual)] // .AutoDispatch)]
    [ProgId("VfpProj.Form")]
    [ComVisible(true)]
    public class CsForm : _Form, IComponent, IDisposable
    {
        public MainWindow Form { get; private set; }
        public void SetForm(MainWindow form) { Form = form; }
        public bool CheckAccess() { return Form != null && Form.events != null && Form.Dispatcher.CheckAccess(); }
        public bool IsBound() { return Form != null && Form.events != null && Form.events.IsBound; }

        public _Events CsObject { get { return CsObj.Instance; } }
        public _Startup Instance { get { return Startup.Instance; } }
        public Exception LastError { get; set; }

        public void Dispose() { Form = null; }
        ISite IComponent.Site { get; set; }
#pragma warning disable 0067
        public event EventHandler Disposed;

        public VisualFoxpro.FoxApplication App
        {
            get { return FoxCmd.App.Application; }
            set
            {
                if (value != null)
                    FoxCmd.SetApp(value);
                FoxCmd.Attach();

                try
                {
                    if (FoxCmd.App.Application != null)
                    {
                        var app = FoxCmd.App.Application;
                        Directory = app.DefaultFilePath;
                        Caption = Directory;

                        FoxCmd.SetVar();
                    }

                    CsApp.Ref();
                    if (CsApp.Instance.Window == null)
                    {

                    }

                }
                catch (Exception ex) { LastError = ex; }
            }
        }

        public CsForm()
        {
            Form = null;
            Directory = string.Empty;
        }

        public bool IsDisposed { get { return Form == null; } } // || !Form.IsLoaded; } }

        protected string _directory = string.Empty;
        protected string _project = string.Empty;

        public string Directory
        {
            get { return _directory; }
            set
            {
                _directory = value;
                if (!string.IsNullOrWhiteSpace(_directory) && IO.Directory.Exists(_directory))
                    IO.Directory.SetCurrentDirectory(_directory);
            }
        }

        public string Project
        {
            get { return _project; }
        }

        public Native.WindowsEvents Events { get { return Form == null ? null : Form.events; } }

        string _Form.Name { get { return "VfpProj._Form.CsForm"; } }
        public string Name { get { return "VfpProj.CsForm"; } }

        IntPtr? hWnd = null;
        public IntPtr Handle
        {
            get
            {
                if (hWnd == null && Form != null)
                {
                    var wih = new WindowInteropHelper(Form);
                    hWnd = wih.Handle;
                }
                return hWnd ?? IntPtr.Zero;
            }
        }

        public bool AlwaysOnTop
        {
            get { return TopMost; }
            set { TopMost = value; }
        }

        public string Text
        {
            get
            {
                if (!IsDisposed)
                {
                    if (Form.Dispatcher.CheckAccess())
                        return Form.txtFile.GetValue(TextBox.TextProperty) as string;
#if NET45
                    else
                        return Form.Dispatcher.Invoke<string>(new Action(() =>
                            Form.txtFile.GetValue(TextBox.TextProperty) as string));
#endif
                }
                return null;
            }
            set
            {
                if (!IsDisposed)
                    SetValueAsync<string>(Form.txtFile, TextBox.TextProperty, value);
            }
        }

        public void SetText(string value)
        {
            if (!IsDisposed && !string.IsNullOrWhiteSpace(value) && value.Substring(1, 1) == ":")
                SetValueAsync<string>(Form.txtFile, TextBox.TextProperty, value);
        }

        public bool Visible
        {
            get { return (Form == null) ? false : Form.IsVisible; }
            set
            {
                if (Form.IsVisible != value && !value)
                {
                    if (Form.Dispatcher.CheckAccess())
                        Form.Hide();
                    else
                        Form.Dispatcher.Invoke(new Action(() => Form.Hide()));
                }
                else if (Form.IsVisible != value && value)
                {
                    if (Form.Dispatcher.CheckAccess())
                        Form.Show();
                    else
                        Form.Dispatcher.Invoke(new Action(() => Form.Show()));
                }
            }

        }

        #region AsyncValues

        public static T ValueAsync<T>(FrameworkElement el, DependencyProperty dp, T value)
        {
            if (el == null)
                return value;

            if (el.Dispatcher.CheckAccess())
                return (T)Convert.ChangeType(el.GetValue(dp), typeof(T));

#if !NET45
            return default(T);
#else 
            return el.Dispatcher.Invoke<T>(() =>
                   (T)Convert.ChangeType(el.GetValue(dp), typeof(T))
                );
#endif
        }

        public static void SetValueAsync<T>(FrameworkElement el, DependencyProperty dp, T value)
        {
            if (el == null)
                return;

            if (el.Dispatcher.CheckAccess())
                el.SetValue(dp, value);

            else
                el.Dispatcher.Invoke(new Action(() =>
                    el.SetValue(dp, value)
                ));
        }

        #endregion

        #region Form properties

        public Int32 Width
        {
            get { return ValueAsync<Int32>(Form, FrameworkElement.WidthProperty, -1); }
            set { SetValueAsync<Double>(Form, FrameworkElement.WidthProperty, Convert.ToDouble(value)); }
        }

        public string Caption
        {
            get { return ValueAsync<string>(Form, Window.TitleProperty, ""); }
            set { SetValueAsync<string>(Form, Window.TitleProperty, value); }
        }

        public Int32 Height
        {
            get { return ValueAsync<Int32>(Form, FrameworkElement.HeightProperty, -1); }
            set { SetValueAsync<Double>(Form, FrameworkElement.HeightProperty, Convert.ToDouble(value)); }
        }

        public Int32 Left
        {
            get { return ValueAsync<Int32>(Form, Window.LeftProperty, -1); }
            set { SetValueAsync<Double>(Form, Window.LeftProperty, Convert.ToDouble(value)); }
        }

        public Int32 Top
        {
            get { return ValueAsync<Int32>(Form, Window.TopProperty, -1); }
            set { SetValueAsync<Double>(Form, Window.TopProperty, Convert.ToDouble(value)); }
        }

        public bool TopMost
        {
            get { return ValueAsync<bool>(Form, Window.TopmostProperty, false); }
            set { SetValueAsync<bool>(Form, Window.TopmostProperty, value); }
        }

        #endregion
    }
}
