using Microsoft.Win32;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Threading;
using VfpInterop;
using Forms = System.Windows.Forms;

namespace VfpProj.Native
{
    [ToolboxItem(true)]
    public class WindowsEvents : ISupportInitialize
    {
        CsForm form;
        public MainWindow Form {
            [DebuggerStepThrough]
            get { return form.Form; }
        }

        public PrjWindow FormPrj {
            [DebuggerStepThrough]
            get;
            protected set;
        }

        public OpenFileDialog dlg;
        public string directory;
        public string file;
        public string ext;
        public Collection<NativeWndInfo> listWI;

#if NET45
        public EditWindow edit;
#endif
        public System.Windows.Controls.TextBox txtFile;

        #region Init, Bind

        public WindowsEvents(MainWindow _form)
        {
            form = _form.FormObject as CsForm;
#if NET45
            edit = null;
#endif
            FormPrj = null;

            listWI = new Collection<NativeWndInfo>();
            directory = FileSystem.CurrentDirectory;
            dlg = null;
            IsBound = false;
        }

        void ISupportInitialize.BeginInit() { }
        void ISupportInitialize.EndInit()
        {
            Bind();
        }

        public bool IsBound;
        void Bind()
        {
            var frm = Form;
            if (IsBound || frm == null || !frm.IsLoaded)
                return;

            IsBound = true;
            //txtFile = Form.hostFile.Child as Forms.TextBox;
            txtFile = Form.txtFile;

            frm.buttonModi.Click += buttonModi_Click;
            frm.buttonModi.MouseDown += buttonModi_MouseClick;
            frm.buttonCD.Click += cmdCD_Click;
            frm.buttonPrj.Click += cmdPrj_Click;

            frm.Activated += form1_Enter;
            frm.MouseEnter += form1_MouseEnter;
            frm.MouseLeave += form1_MouseLeave;

            frm.Topmost = true;
            frm.tabList.SelectionChanged += tabWI_IndexChanged;

            frm.AllowDrop = true;
            frm.txtFile.AllowDrop = true;
            frm.DragOver += form_DragOver;
            frm.Drop += form_Drop;
            frm.txtFile.DragOver += form_DragOver;
            frm.txtFile.Drop += form_Drop;


#if NOWPF_TEXTBOX
            //frm.txtFile.KeyDown += txtFile_KeyDown;
#else
            frm.txtFile.KeyDown += txtFile_KeyDown;
#endif
            frm.buttonDO.Click += (s, e) => DoCmd(form.Text);

            frm.buttonWcf.Click += (s, e) => Wcf.VfpWcf.Bind();
            var sets = System.Configuration.ConfigurationManager.AppSettings;
            var baseAddress = sets.Get("baseAddress");
            if (!string.IsNullOrWhiteSpace(baseAddress)) {
                Wcf.VfpWcf.Bind();
                if (Wcf.Host.Object != null)
                    frm.buttonWcf.Visibility = Visibility.Hidden;
            }
        }



#endregion

#region Render, Focus

        public void AfterRendered()
        {
            Bind();
            var textFile = Form.txtFile;

            //NativeAutocomplete.SetFileAutoComplete(textFile);
            textFile.Text = FileSystem.CurrentDirectory + "\\";

            if (!CsObj.Instance.IsLockForm) {
                FoxCmd.DefPositionLoad(Form);
                FormFocus(Form);
            }
        }

        public IntPtr RpcTest()
        {
            IntPtr hWnd = IntPtr.Zero;
            try {
                hWnd = (IntPtr)FoxCmd.App.hWnd;
            }
            catch (Exception ex) {
                Trace.Write(ex);
            }
            return hWnd;
        }

        void FormFocus(MainWindow form1)
        {
            string dir = form1.events.directory;
            if (CsObj.Instance == null
                || CsObj.Instance.IsLockForm)
                return;

            var app = FoxCmd.App;
            IntPtr hWnd = IntPtr.Zero;
            hWnd = RpcTest();

            try {
                //if (hWnd == IntPtr.Zero)
                //{
                //    // FoxCmd.App = null;
                //    if (FoxCmd.Attach(true))
                //    {
                //        app = FoxCmd.App;
                //        FoxCmd.ShowForm(form1);
                //    }
                //    app.Application.Visible = true;
                //}
                if (app != null && app.DefaultFilePath != dir) {
                    dir = app.DefaultFilePath;
                    Trace.WriteLine("Focus set dir=" + dir);
                    Directory.SetCurrentDirectory(dir);

                }
            }
            catch (Exception ex) {
                Trace.WriteLine(ex.Message);
            }

            dir = FileSystem.CurrentDirectory;
            form1.events.directory = dir;
            if (form1.FormObject != null) {
                form1.FormObject.Directory = dir;
                form1.FormObject.Caption = form1.FormObject.Directory;
            }

            Trace.Write("form Focus");
            form1.txtFile.GotFocus += (s, e) => AfterFocus(hWnd);

            if (form.CheckAccess())
                form1.txtFile.Focus();
        }

        public void AfterFocus(IntPtr? hWnd = null)
        {
            if (hWnd == null)
                hWnd = RpcTest();
            if (!hWnd.HasValue)
                return;

            if (!FoxCmd.App.IsAlive())
                return;
            FoxCmd.SetVar();
            WindowsTab.FillList(form, hWnd.Value);
        }

        public void StartDir()
        {
            if (FoxCmd.cfg_startDir.Length > 0 && !FileSystem.CurrentDirectory.Contains(FoxCmd.cfg_startDir)) {
                Directory.SetCurrentDirectory(FoxCmd.cfg_startDir);
                FoxCmd.AppCmd("CD " + FoxCmd.cfg_startDir);
            }
        }

#endregion

#region Button clicks

        void buttonModi_Click(object sender, RoutedEventArgs e)
        {
            cmdModi_Click(sender, e);
        }

        void buttonModi_MouseClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (e.RightButton == System.Windows.Input.MouseButtonState.Pressed) {
                e.Handled = true;
#if NET45
                edit = AppMethods.ShowEditWindow(Form.txtFile.Text);
                if (edit == null)
                    return;

                edit.Left = form.Left;
                if (form.Top < 200)
                    edit.Top = 80 + form.Top;
#endif
            }
        }

        void cmdModi_Click(object sender, EventArgs e)
        {
            if (dlg == null)
                dlg = new OpenFileDialog();

            //  dlg.SupportMultiDottedExtensions = true;

            directory = FileSystem.CurrentDirectory;
            this.file = Form.txtFile.Text;
            string path = Path.GetFullPath(this.file);
            if (path != null && !directory.StartsWith(path)) {
                try {
                    FileSystem.CurrentDirectory = path;
                }
                catch (Exception) { }
                directory = FileSystem.CurrentDirectory;
            }

            dlg.InitialDirectory = directory;
            dlg.Filter = "Vfp files|*.pjx;*.prg|All files|*.*";
            dlg.ShowReadOnly = true;

            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;

            Form.txtFile.Text = dlg.FileName;  // dlg.InitialDirectory + "\\" + dlg.SafeFileNames[0];
            file = Form.txtFile.Text.Trim();
            ext = Path.GetExtension(file).ToLower();

            var app = FoxCmd.App;
            if (app == null)
                return;

            try {
                if (ext == ".prg") {
                    app.DoCmd("modi comm " + file + " nowait");
                } else if (ext == ".pjx") {
                    path = Path.GetDirectoryName(file);
                    app.DoCmd("modi proj " + file + " nowait");
                    app.DoCmd("cd " + path);
                    if (FoxCmd.cfg_startFxp.Length > 0 && File.Exists(FoxCmd.cfg_startFxp))
                        app.DoCmd("DO " + FoxCmd.cfg_startFxp);
                }

            }
            catch (Exception ex) {
                Trace.WriteLine(ex.Message);
            }

        }

        void cmdCD_Click(object sender, EventArgs e)
        {
            try {
                directory = FoxCmd.App.DefaultFilePath;
            }
            catch (Exception) {
                directory = FileSystem.CurrentDirectory;
            }

#if WPF_DLG
            // FileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.InitialDirectory = directory;
            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;
            Directory.SetCurrentDirectory(dlg.InitialDirectory);
#else
            var dlg = new System.Windows.Forms.FolderBrowserDialog();
            dlg.SelectedPath = directory;
            var res = dlg.ShowDialog();
            if (res != Forms.DialogResult.OK)
                return;

            FileSystem.CurrentDirectory = dlg.SelectedPath;
#endif
            directory = FileSystem.CurrentDirectory;
            try {
                FoxCmd.App.DefaultFilePath = directory;
                FoxCmd.App.DefaultFilePath = FoxCmd.App.DefaultFilePath;
            }
            catch (Exception) { }

            var txt = Form.txtFile.Text;
            if (string.IsNullOrWhiteSpace(txt) || txt[1] == ':')
                Form.txtFile.Text = directory;
        }

        void cmdPrj_Click(object sender, EventArgs e)
        {
            if (FormPrj == null || !FormPrj.IsLoaded) {

                if (CsObj.Instance?.App == null) {
                    return;
                }

                var newPath = txtFile.Text ?? "";

                var taskWcf = Task.Factory.StartNew(() => WcfLoad(this, newPath));
                var taskProj = Task.Factory.StartNew(() => Proj(this));


                TaskWaitAny(new TimeSpan(0, 0, 2),  // 2 sec.
                        taskProj, taskWcf);

                // Causes the calling thread to yield execution to another thread that is ready
                // to run on the current processor. The operating system selects the thread to yield to.
                // true if the operating system switched execution to another thread
                var yield = Thread.Yield();
                if (!yield) {
                    FormPrj?.Show();
                }
            }
        }

        public static void TaskWaitAny(TimeSpan timeout, params Task[] tasks)
            => Task.WaitAny(tasks, timeout);

        public static void WcfLoad(WindowsEvents evt, string newPath)
        {
            var FormPrj = evt.FormPrj;
            var txtFile = evt.txtFile;
            Dispatcher dispatcher = evt.txtFile.Dispatcher;
            bool threadAccess = false;

            if (FormPrj == null || !FormPrj.IsLoaded) {
                string path = "";
                try {
                    threadAccess = dispatcher.CheckAccess();
                    path = CsObj.Instance.App.Eval("_VFP.DefaultFilePath") as string ?? "";

                    var dir = path;
                    if (newPath.Length > 4 && newPath[1] == ':') {
                        dir = File.Exists(newPath) ? Path.GetDirectoryName(newPath) 
                            : Path.GetDirectoryName(newPath + Path.DirectorySeparatorChar.ToString());
                    }
                    if (Directory.Exists(dir)) {
                        CsObj.Instance.App.DoCmd($"_VFP.DefaultFilePath = '{dir}'");
                        path = CsObj.Instance.App.Eval("_VFP.DefaultFilePath") as string;
                    }

                }
                catch (Exception ex) { CsObj.Instance.LastError = ex; }

                if (VfpProj.Wcf.Host.Object != null) {
                    // OperationContext ctx = null;
                    try {
                        var service = VfpProj.Wcf.VfpServiceBehavior.CreateWebService(true);
                        if (service != null) {
                            // var htmlMsg = service.Index();
                            service.Load(null);
                            service.Load(CsObj.Instance);
                        }

                    }
                    catch (Exception ex) {
                        var msg = ex.Message;
                        if (ex.InnerException != null)
                            msg += ex.InnerException.Message;
                        MessageBox.Show(msg);
                        //StatusDescriptionStrings
                        //  internal const string HttpContentTypeMismatch = 
                        // "Cannot process the message because the content type '{0}' was not the expected type '{1}'.";
                    }

                }
            }
        }

        public static void Proj(WindowsEvents evt)
        {
            var FormPrj = evt.FormPrj;
            var txtFile = evt.txtFile;

            FormPrj = null; // clear
            Dispatcher dispatcher = evt.txtFile.Dispatcher;
            bool threadAccess = dispatcher.CheckAccess();

            var act = new Action(() => {

                var mainWind = Application.Current.MainWindow;
                var txtDir = evt.Form.txtFile.Text;
                if (txtDir.Length > 0 && Directory.Exists(txtDir))
                    FileSystem.CurrentDirectory = txtDir;

                FormPrj = new PrjWindow();
                FormPrj.Left = mainWind.Left + mainWind.Width - FormPrj.Width;
                if (mainWind.Top < 200)
                    FormPrj.Top = mainWind.Top + mainWind.Height + 20;

                FormPrj.ShowInTaskbar = false;
                FormPrj.Topmost = true;
                Tree.LoadFolder(FormPrj, FormPrj.txtPath.Text);

            });
            if (threadAccess) {
                act();
            } else {
                // Operations are processed before other asynchronous
                dispatcher.BeginInvoke(DispatcherPriority.Send, act);
            }

        }

#endregion

#region Focus Events

        public void form_Drop(object sender, DragEventArgs e)
        {
            var data = e.Data as IDataObject;
            if (data == null) {
                return;
            }
            if (data.GetDataPresent(typeof(string))) {
                var file = data.GetData(typeof(string)) as string;
                txtFile.Text = file ?? txtFile.Text;
            }
        }

        public void form_DragOver(object sender, DragEventArgs e)
        {
            // e.AllowedEffects = DragDropEffects.Copy;
            e.Effects = DragDropEffects.Copy;
        }


        static void form1_MouseLeave(object sender, EventArgs e)
        {
            Trace.Write("mouse Leave");
        }

        static void form1_MouseEnter(object sender, EventArgs e)
        {
            Trace.Write("mouse Enter");
            // Form1 form = sender as Form1;
            // WindowsTab.FillList(form);
        }

        void form1_Leave(object sender, EventArgs e)
        {
            var form1 = sender as MainWindow;
            string dir = form1.events.directory;
            var app = FoxCmd.App;
            if (app == null)
                return;

            // {"An outgoing call cannot be made since the application is dispatching an input-synchronous call. 
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))"}
            try {
                if (app.DefaultFilePath.ToLower() != dir.ToLower()) {
                    app.Caption = dir;
                    app.DefaultFilePath = dir;
                }
                FoxCmd.hWnd = (IntPtr)app.hWnd;
            }
            catch (Exception ex) {
                Trace.WriteLine(ex.Message);
            }

            Trace.Write("form leave");

            // HWND WINAPI GetForegroundWindow(void);  User32.dll 
            //if (FoxCmd.hWnd == NativeMethods.GetForegroundWindow())
            //{
            //    FoxCmd.SetApp(null); // = null;
            //    FoxCmd.SetFormObj(null);
            //}
        }

        void form1_Enter(object sender, EventArgs e)
        {
            var form1 = sender as MainWindow;
            FormFocus(form1);
        }

#endregion

#region KeyDown
#if NOWPF_TEXTBOX
        void txtFile_KeyDown(object sender, Forms.KeyEventArgs e)
        {
            var textFile = sender as Forms.TextBox;
            var formCS = form.Form;
            if (e.KeyCode == Forms.Keys.Enter)
            {
#else
        void txtFile_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
#endif
            var textFile = sender as TextBox;
            if (e.Key == Key.Enter) {
                string cmd = textFile.Text.Trim();
                DoCmd(cmd);
            }
        }

#endregion

        public void DoCmd(string cmd)
        {
            string dir = form.Directory;
            var formCS = form.Form;

            if (!FoxCmd.App.IsAlive()) {
                CsApp.Instance.Window.IsStart = false;
                Vfp.Startup.Instance.App = null;
                FoxCmd.Attach(true);
                if (FoxCmd.App == null)
                    return;

                FoxCmd.App.Visible = true;
                FoxCmd.App.DefaultFilePath = dir;
            }

            if (File.Exists(cmd) || Directory.Exists(cmd)) {
                if (!File.Exists(cmd)) {
                    FoxCmd.AppCmd("CD " + cmd);
                    dir = FoxCmd.App.DefaultFilePath;
                    try {
                        Directory.SetCurrentDirectory(dir);
                    }
                    catch (Exception ex) {
                        form.LastError = ex;
                        dir = FileSystem.CurrentDirectory;
                    }

                    form.Events.directory = dir;
                    form.Directory = dir;
                    form.Caption = dir;
                    return;
                }

                string ext = Path.GetExtension(cmd).ToLower();
                if (ext == ".prg")
                    FoxCmd.AppCmd("MODI COMM " + cmd + " NOWAIT");
                else
                    if (ext == ".pjx")
                    FoxCmd.AppCmd("MODI PROJ " + cmd + " NOWAIT");
            } else {
                bool isEval = false;
                string evalStr = "";
                // ? _VFP.StatusBar;
                if (cmd[0] == '?') {
                    evalStr = cmd.Substring(1).TrimStart();
                    isEval = true;
                }

                dynamic result = null;
                if (isEval)
                    result = FoxCmd.AppEval(evalStr);
                else
                    FoxCmd.AppCmd(cmd);
            }

            IntPtr? hWnd = null;
            try {
                dir = FoxCmd.App.DefaultFilePath;
                if (form.Events.directory != dir) {
                    Directory.SetCurrentDirectory(dir);
                }
                form.Directory = dir;
                form.Caption = dir;
                hWnd = (IntPtr?)(form.App as VisualFoxpro.FoxApplication)?.hWnd;
            }
            catch (Exception ex) {
                form.LastError = ex;
                Trace.WriteLine(ex.Message);
            }

            if (hWnd.HasValue)
                WindowsTab.FillList(form, hWnd ?? IntPtr.Zero);
        }

        void tabWI_IndexChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            var formCS = form.Form;
            int index = formCS.tabList.SelectedIndex;

            if (index < 0 || !formCS.tabList.IsEnabled || listWI.Count < index + 1)
                return;
            var item = formCS.tabList.Items[index] as System.Windows.Controls.TabItem;
            if (item == null)
                return;
            NativeWndInfo wi = item.Tag as NativeWndInfo;
            IntPtr hWnd = wi.ptr;
            if (hWnd == IntPtr.Zero)
                return;
            if (!NativeMethods.IsWindowVisible(hWnd)) {
                formCS.tabList.Items.RemoveAt(index);
                return;
            }

            try {
                NativeMethods.BringWindowToTop(hWnd);
                NativeMethods.SetFocus(hWnd);

                string cmd = string.Empty;
                if (wi.text.StartsWith("Project"))
                    cmd = "ACTIVATE WINDOW Project";
                else
                    if (wi.text.StartsWith("Properties"))
                    cmd = "ACTIVATE WINDOW Properties";
                else
                        if (!wi.text.ToLower().Contains("data session"))
                    cmd = "ACTIVATE WINDOW \"" + wi.text + "\"";
                if (cmd.Length > 0)
                    FoxCmd.AppCmd(cmd);
            }
            catch (Exception ex) { Trace.Write(ex); }

        }

    }

}
