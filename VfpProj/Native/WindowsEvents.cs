using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows;
using Forms = System.Windows.Forms;
using VfpEdit;
using VfpInterop;
using VfpProj;

namespace VfpProj.Native
{
    [ToolboxItem(true)]
    public class WindowsEvents
    {
        CsForm form;
        public MainWindow Form
        {
            [DebuggerStepThrough]
            get { return form.Form; }
        }
        public OpenFileDialog dlg;
        public string directory;
        public string file;
        public string ext;
        public Collection<NativeWndInfo> listWI;

        public EditWindow edit;
        public Forms.TextBox txtFile;

        public WindowsEvents(MainWindow form)
        {
            this.form = form.form;
            edit = null;

            listWI = new Collection<NativeWndInfo>();
            directory = Directory.GetCurrentDirectory();
            dlg = null;
            isBound = false;
        }

        bool isBound;
        void Bind()
        {
            if (isBound)
                return;

            isBound = true;
            txtFile = Form.hostFile.Child as Forms.TextBox;

            var frm = Form;

            frm.buttonModi.Click += buttonModi_Click;
            frm.buttonModi.MouseDown += buttonModi_MouseClick;
            frm.buttonCD.Click += cmdCD_Click;

            frm.Activated += form1_Enter;
            frm.MouseEnter += form1_MouseEnter;
            // frm.MouseLeave += form1_MouseLeave;
            frm.Deactivated += form1_Leave;

            frm.Topmost = true;
            frm.tabList.SelectionChanged += tabWI_IndexChanged;
            frm.txtFile.KeyDown += txtFile_KeyDown;
        }

        public void AfterRendered()
        {
            Bind();
            var textFile = Form.hostFile.Child as Forms.TextBox;
            textFile.IsAccessible = true;
            Form.hostFile.Visibility = Visibility.Visible;

            NativeAutocomplete.SetFileAutoComplete(textFile);
            textFile.Text = Directory.GetCurrentDirectory() + "\\";
            FormFocus(Form);
        }

        public IntPtr RpcTest()
        {
            IntPtr hWnd = IntPtr.Zero;
            try
            {
                hWnd = (IntPtr)FoxCmd.app.hWnd;
            }
            catch (Exception ex)
            {
                Trace.Write(ex);
            }
            return hWnd;
        }

        void FormFocus(MainWindow form1)
        {
            string dir = form1.events.directory;
            var app = FoxCmd.app;
            IntPtr hWnd = IntPtr.Zero;
            hWnd = RpcTest();

            try
            {
                if (hWnd == IntPtr.Zero)
                {
                    FoxCmd.app = null;
                    if (FoxCmd.Attach())
                    {
                        app = FoxCmd.app;
                        FoxCmd.CreateForm(form1);
                    }
                    Debug.Assert(app.Application.Visible);
                }
                if (app != null && app.DefaultFilePath != dir)
                    Directory.SetCurrentDirectory(app.DefaultFilePath);
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.Message);
            }

            form1.events.directory = Directory.GetCurrentDirectory();
            Trace.Write("form Focus");
            AfterFocus(hWnd);
        }

        public void AfterFocus(IntPtr hWnd)
        {
            if (hWnd == IntPtr.Zero)
                return;

            WindowsTab.FillList(form, hWnd);

            if (FoxCmd.cfg_startDir.Length > 0 && !Directory.GetCurrentDirectory().Contains(FoxCmd.cfg_startDir))
            {
                Directory.SetCurrentDirectory(FoxCmd.cfg_startDir);
                FoxCmd.AppCmd("CD " + FoxCmd.cfg_startDir);
            }
        }

        void buttonModi_Click(object sender, RoutedEventArgs e)
        {
            cmdModi_Click(sender, e);
        }

        void buttonModi_MouseClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (e.RightButton == System.Windows.Input.MouseButtonState.Pressed)
                edit = (Application.Current as App).ShowEditWindow(Form.txtFile.Text);
        }

        void cmdModi_Click(object sender, EventArgs e)
        {
            if (dlg == null)
            {
                dlg = new OpenFileDialog();
                dlg.Filter = "Vfp files|*.pjx;*.prg|All files|*.*";
                dlg.ShowReadOnly = true;
                // winForms: dlg.SupportMultiDottedExtensions = true;
            }

            directory = Directory.GetCurrentDirectory();
            this.file = Form.txtFile.Text;
            string path = Path.GetDirectoryName(this.file);
            if (!directory.StartsWith(path))
            {
                try
                {
                    Directory.SetCurrentDirectory(path);
                }
                catch (Exception) { }
                directory = Directory.GetCurrentDirectory();
            }
            dlg.InitialDirectory = directory;

            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;

            Form.txtFile.Text = dlg.FileName;  // dlg.InitialDirectory + "\\" + dlg.SafeFileNames[0];
            file = Form.txtFile.Text.Trim();
            ext = Path.GetExtension(file).ToLower();

            var app = FoxCmd.app;
            if (app == null) return;

            try
            {
                if (ext == ".prg")
                    app.DoCmd("modi comm " + file + " nowait");
                if (ext == ".pjx")
                {
                    path = Path.GetDirectoryName(file);
                    app.DoCmd("modi proj " + file + " nowait");
                    app.DoCmd("cd " + path);
                    if (FoxCmd.cfg_startFxp.Length > 0 && File.Exists(FoxCmd.cfg_startFxp))
                        app.DoCmd("DO " + FoxCmd.cfg_startFxp);
                }

            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.Message);
            }

        }

        void cmdCD_Click(object sender, EventArgs e)
        {
            Forms.FolderBrowserDialog dlg = new Forms.FolderBrowserDialog();

            directory = Directory.GetCurrentDirectory();
            dlg.SelectedPath = directory;
            Forms.DialogResult res = dlg.ShowDialog();
            if (res != Forms.DialogResult.OK)
                return;

            Directory.SetCurrentDirectory(dlg.SelectedPath);
            directory = Directory.GetCurrentDirectory();

            Form.txtFile.Text = directory;
        }

        #region Focus Events
        // void form1_MouseLeave(object sender, EventArgs e)
            // Trace.Write("mouse Leave");

        void form1_MouseEnter(object sender, EventArgs e)
        {
            // Trace.Write("mouse Enter");
            var hWnd = RpcTest();
            AfterFocus(hWnd);
        }

        void form1_Leave(object sender, EventArgs e)
        {
            var form1 = sender as MainWindow;
            string dir = form1.events.directory;
            var app = FoxCmd.app;
            if (app == null)
                return;

            // {"An outgoing call cannot be made since the application is dispatching an input-synchronous call. 
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL))"}
            try
            {
                if (app.DefaultFilePath.ToLower() != dir.ToLower())
                {
                    app.Caption = dir;
                    app.DefaultFilePath = dir;
                }
                FoxCmd.hWnd = (IntPtr)app.hWnd;
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.Message);
            }

            // Trace.Write("form leave");
            // HWND WINAPI GetForegroundWindow(void);  User32.dll 
            // if (FoxCmd.hWnd == NativeMethods.GetForegroundWindow())
                // FoxCmd.app = null;
        }

        void form1_Enter(object sender, EventArgs e)
        {
            var form1 = sender as MainWindow;
            FormFocus(form1);
        }

        #endregion

        void txtFile_KeyDown(object sender, Forms.KeyEventArgs e)
        {
            var textFile = sender as Forms.TextBox;
            var formCS = form.Form;
            if (e.KeyCode == Forms.Keys.Enter)
            {
                string cmd = textFile.Text.Trim();
                FoxCmd.TextFileCmd(cmd);

                var hWnd = (IntPtr)form.App.hWnd;
                WindowsTab.FillList(form, hWnd);
            }
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
            if (!NativeMethods.IsWindowVisible(hWnd))
            {
                formCS.tabList.Items.RemoveAt(index);
                return;
            }

            try
            {
                NativeMethods.BringWindowToTop(hWnd);
                NativeMethods.SetFocus(hWnd);

                string cmd = wi.text;
                if (wi.text.StartsWith("Project"))
                    cmd = "ACTIVATE WINDOW Project";
                else
                    cmd = "ACTIVATE WINDOW '" + cmd + "'";

                if (cmd.Length > 0)
                    FoxCmd.AppCmd(cmd);
            }
            catch (Exception ex)
            { Trace.Write(ex); }

        }

    }

}
