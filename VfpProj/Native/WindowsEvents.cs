﻿using Microsoft.Win32;
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
    public class WindowsEvents : ISupportInitialize
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
        // public Forms.TextBox txtFile;
        public System.Windows.Controls.TextBox txtFile;

        public WindowsEvents(MainWindow form)
        {
            this.form = form.FormObject;
            edit = null;

            listWI = new Collection<NativeWndInfo>();
            directory = Directory.GetCurrentDirectory();
            dlg = null;
            isBound = false;
        }

        void ISupportInitialize.BeginInit() { }
        void ISupportInitialize.EndInit()
        {
            //   form.tabWI.TabPages.Clear();
            Bind();
        }

        bool isBound;
        void Bind()
        {
            if (isBound)
                return;

            isBound = true;
            //txtFile = Form.hostFile.Child as Forms.TextBox;
            txtFile = Form.txtFile;

            var frm = Form;

            frm.buttonModi.Click += buttonModi_Click;
            frm.buttonModi.MouseDown += buttonModi_MouseClick;
            frm.buttonCD.Click += cmdCD_Click;

            frm.Activated += form1_Enter;
            frm.MouseEnter += form1_MouseEnter;
            frm.MouseLeave += form1_MouseLeave;
            // frm.Deactivate += form1_Leave;

            frm.Topmost = true;
            frm.tabList.SelectionChanged += tabWI_IndexChanged;
            //frm.txtFile.KeyDown += txtFile_KeyDown;
        }

        public void AfterRendered()
        {
            Bind();
            var textFile = Form.txtFile;
            //var textFile = Form.hostFile.Child as Forms.TextBox;
            //textFile.IsAccessible = true;
            //textFile.Visible = true;
            //Form.hostFile.Visibility = Visibility.Visible;

            //NativeAutocomplete.SetFileAutoComplete(textFile);
            textFile.Text = Directory.GetCurrentDirectory() + "\\";
            FormFocus(Form);
        }

        public IntPtr RpcTest()
        {
            IntPtr hWnd = IntPtr.Zero;
            try
            {
                hWnd = (IntPtr)FoxCmd.App.hWnd;
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
            var app = FoxCmd.App;
            IntPtr hWnd = IntPtr.Zero;
            hWnd = RpcTest();

            try
            {
                if (hWnd == IntPtr.Zero)
                {
                    // FoxCmd.App = null;
                    if (FoxCmd.Attach())
                    {
                        app = FoxCmd.App;
                        FoxCmd.ShowForm(form1);
                    }
                    app.Application.Visible = true;
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

        public void AfterFocus(IntPtr? hWnd = null)
        {
            if (hWnd == null)
                hWnd = RpcTest();

            if (!hWnd.HasValue)
                return;
            WindowsTab.FillList(form, hWnd.Value);

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
                dlg = new OpenFileDialog();

            // dlg.SupportMultiDottedExtensions = true;
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
            dlg.Filter = "Vfp files|*.pjx;*.prg|All files|*.*";
            dlg.ShowReadOnly = true;

            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;

            Form.txtFile.Text = dlg.FileName;  // dlg.InitialDirectory + "\\" + dlg.SafeFileNames[0];
            file = Form.txtFile.Text.Trim();
            ext = Path.GetExtension(file).ToLower();

            var app = FoxCmd.App;
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
            // FolderBrowserDialog dlg = new FolderBrowserDialog();
            FileDialog dlg = new Microsoft.Win32.OpenFileDialog();

            directory = Directory.GetCurrentDirectory();
            // dlg.SelectedPath = directory;
            dlg.InitialDirectory = directory;
            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;

            Directory.SetCurrentDirectory(dlg.InitialDirectory);
            directory = Directory.GetCurrentDirectory();

            Form.txtFile.Text = directory;
        }

        #region Focus Events
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

            Trace.Write("form leave");

            // HWND WINAPI GetForegroundWindow(void);  User32.dll 
            if (FoxCmd.hWnd == NativeMethods.GetForegroundWindow())
            {
                FoxCmd.SetApp(null); // = null;
                FoxCmd.SetFormObj(null);
            }
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

                if (File.Exists(cmd) || Directory.Exists(cmd))
                {
                    if (!File.Exists(cmd))
                    {
                        FoxCmd.AppCmd("CD " + cmd);
                        form.Events.directory = FoxCmd.App.DefaultFilePath;
                        Directory.SetCurrentDirectory(form.Events.directory);
                        return;
                    }

                    string ext = Path.GetExtension(cmd).ToLower();
                    if (ext == ".prg")
                        FoxCmd.AppCmd("MODI COMM " + cmd + " NOWAIT");
                    else
                        if (ext == ".pjx")
                            FoxCmd.AppCmd("MODI PROJ " + cmd + " NOWAIT");
                }
                else
                    FoxCmd.AppCmd(cmd);

                try
                {
                    if (form.Events.directory != FoxCmd.App.DefaultFilePath)
                    {
                        if (form.Events.directory != FoxCmd.App.DefaultFilePath)
                            Directory.SetCurrentDirectory(form.Events.directory);
                    }
                }
                catch (Exception) { }

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
            catch (Exception ex)
            { Trace.Write(ex); }

        }

    }

}
