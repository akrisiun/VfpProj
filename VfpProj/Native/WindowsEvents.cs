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
using System.Windows.Forms;
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

        public WindowsEvents(MainWindow form)
        {
            this.form = form.form;
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

            var frm = Form;

            frm.buttonModi.Click += buttonModi_Click;
            // frm.buttonModi.Click += cmdModi_Click;
            frm.buttonCD.Click += cmdCD_Click;

            frm.Activated += form1_Enter;
            // frm.Deactivate += form1_Leave;
            frm.MouseEnter += form1_MouseEnter;
            frm.MouseLeave += form1_MouseLeave;

            // frm.tabWI.SelectedIndexChanged += tabWI_IndexChanged;
            // frm.textFile.KeyDown += textFile_KeyDown;
        }

        public void AfterFocus(IntPtr handle)
        {
            WindowsTab.FillList(form);

            var textFile = Form.textFile;
            // NativeAutocomplete.SetFileAutoComplete(textFile);

            if (textFile.Text.Length == 0)
                textFile.Text = Directory.GetCurrentDirectory() + "\\";

            if (FoxCmd.cfg_startDir.Length > 0 && !Directory.GetCurrentDirectory().Contains(FoxCmd.cfg_startDir))
            {
                Directory.SetCurrentDirectory(FoxCmd.cfg_startDir);
                FoxCmd.AppCmd("CD " + FoxCmd.cfg_startDir);
            }
        }

        /*
        void textFile_KeyDown(object sender, KeyEventArgs e)
        {
            var form = (sender as TextBox).Parent as Form1;
            if (e.KeyCode == Keys.Enter)
            {
                string cmd = form.textFile.Text.Trim();
                if (File.Exists(cmd) || Directory.Exists(cmd))
                {
                    if (!File.Exists(cmd))
                    {
                        FoxCmd.AppCmd("CD " + cmd);
                        form.events.directory = FoxCmd.app.DefaultFilePath;
                        Directory.SetCurrentDirectory(form.events.directory);
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
                    if (form.events.directory != FoxCmd.app.DefaultFilePath)
                    {
                        if (form.events.directory != FoxCmd.app.DefaultFilePath)
                            Directory.SetCurrentDirectory(form.events.directory);
                    }
                }
                catch (Exception) { }

            }
        }

        void tabWI_IndexChanged(object sender, EventArgs e)
        {
            int index = form.tabWI.SelectedIndex;
            if (index < 0)
                return;
            NativeWndInfo wi = listWI[index];
            IntPtr hWnd = listWI[index].ptr;

            bool focused = form.ContainsFocus;
            if (!focused || hWnd == IntPtr.Zero)
                return;

            if (!NativeMethods.IsWindowVisible(hWnd))
            {
                form.tabWI.TabPages.RemoveAt(index);
                return;
            }

            NativeMethods.BringWindowToTop(hWnd);
            NativeMethods.SetFocus(hWnd);

            string cmd = string.Empty;
            if (wi.text.StartsWith("Project"))
                cmd = "ACTIVATE WINDOW Project";
            else
                if (!wi.text.ToLower().Contains("data session"))
                    cmd = "ACTIVATE WINDOW \"" + wi.text + "\"";
            if (cmd.Length > 0)
                FoxCmd.AppCmd(cmd);

        }
        */

        void buttonModi_Click(object sender, RoutedEventArgs e)
        {
            // buttonModi.Click += buttonModi_Click;
            edit = (Application.Current as App).ShowEditWindow();
        }


        void cmdModi_Click(object sender, EventArgs e)
        {
            if (dlg == null)
                dlg = new OpenFileDialog();

            // dlg.SupportMultiDottedExtensions = true;
            directory = Directory.GetCurrentDirectory();
            dlg.InitialDirectory = directory;
            dlg.Filter = "Vfp files|*.pjx;*.prg|All files|*.*";
            dlg.ShowReadOnly = true;

            bool? res = dlg.ShowDialog();
            if (!res ?? true)
                return;

            Form.textFile.Text = dlg.FileName;  // dlg.InitialDirectory + "\\" + dlg.SafeFileNames[0];
            file = Form.textFile.Text.Trim();
            ext = Path.GetExtension(file).ToLower();

            var app = FoxCmd.app;
            if (app == null) return;

            try
            {
                if (ext == ".prg")
                    app.DoCmd("modi comm " + file + " nowait");
                if (ext == ".pjx")
                {
                    string path = Path.GetDirectoryName(file);
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

            Form.textFile.Text = directory;
        }

        static void form1_MouseLeave(object sender, EventArgs e)
        {
            Trace.Write("mouse Leave");
        }

        static void form1_MouseEnter(object sender, EventArgs e)
        {
            Trace.Write("mouse Enter");

            //Form1 form = sender as Form1;
            // WindowsTab.FillList(form);
        }

        static void form1_Leave(object sender, EventArgs e)
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

            Trace.Write("form leave");

            // HWND WINAPI GetForegroundWindow(void);  User32.dll 
            if (FoxCmd.hWnd == NativeMethods.GetForegroundWindow())
            {
                FoxCmd.app = null;
            }
        }

        static void form1_Enter(object sender, EventArgs e)
        {
            var form1 = sender as MainWindow;
            string dir = form1.events.directory;

            var app = FoxCmd.app;
            IntPtr hWnd = IntPtr.Zero;

            try
            {
                hWnd = (IntPtr)app.hWnd;
            }
            catch (Exception) { }

            if (hWnd == IntPtr.Zero)
            {
                FoxCmd.app = null;
                if (FoxCmd.Attach())
                {
                    app = FoxCmd.app;
                    FoxCmd.ShowForm(form1);
                }
            }

            // Retrieving the COM class factory for component with CLSID {00A19610-D8FC-4A3E-A95F-FEA211444BF7}
            // failed due to the following error: 8001010d 
            // An outgoing call cannot be made as the application is despatching an input-synchronous call.
            // (Exception from HRESULT: 0x8001010D (RPC_E_CANTCALLOUT_ININPUTSYNCCALL)).

            try
            {
                if (app != null && app.DefaultFilePath != dir)
                    Directory.SetCurrentDirectory(app.DefaultFilePath);
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.Message);
            }

            form1.events.directory = Directory.GetCurrentDirectory();
            Trace.Write("form Focus");
        }


    }

}
