using System;
using System.ComponentModel.Design;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio.Shell;
using Microsoft.VisualStudio.Shell.Interop;

namespace VfpLanguage
{
    public static class ContextMenuTexts
    {
        // <data name="110" xml:space="preserve">     <value>Open Command Line</value>
        // <data name="112" xml:space="preserve">
        //  <value>Opens a command line at the root of the project. Support for all consoles such as CMD, PowerShell, Bash etc. Provides syntax highlighting, Intellisense and execution of .cmd and .bat files.</value>

        public const string _110 = "#210";
        public const string _112 = "#212";
    }

    [PackageRegistration(UseManagedResourcesOnly = true)]
    [InstalledProductRegistration(ContextMenuTexts._110, ContextMenuTexts._112, Vsix.Version, IconResourceID = 400)]
    [ProvideMenuResource("Menus.ctmenu", 1)]
    [ProvideAutoLoad(UIContextGuids80.SolutionExists)]
    [ProvideOptionPage(typeof(Options), "Environment", "Command VFP", 101, 104, true, new[] { "cmd", "powershell", "bash" }, ProvidesLocalizedCategoryName = false)]
    [Guid(GuidList.guidVfpLanguagePkgString)]
    public sealed class VfpLanguagePackage : Package
    {
        private static DTE2 _dte;
        public Package Instance;

        protected override void Initialize()
        {
            base.Initialize();

            _dte = GetService(typeof(DTE)) as DTE2;
            Telemetry.Initialize(_dte, Vsix.Version, "d6836c4a-0c01-4114-98fe-d4f34b9b9b50");

            OleMenuCommandService mcs = GetService(typeof(IMenuCommandService)) as OleMenuCommandService;

            CommandID cmdCustom = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdidVfpLanguage);
            OleMenuCommand customItem = new OleMenuCommand(OpenCustom, cmdCustom);
            customItem.BeforeQueryStatus += BeforeQueryStatus;
            mcs.AddCommand(customItem);

            CommandID cmdCmd = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdidOpenCmd);
            MenuCommand cmdItem = new MenuCommand(OpenCmd, cmdCmd);
            mcs.AddCommand(cmdItem);

            CommandID cmdPowershell = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdidOpenPowershell);
            MenuCommand powershellItem = new MenuCommand(OpenPowershell, cmdPowershell);
            mcs.AddCommand(powershellItem);

            CommandID cmdOptions = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdidOpenOptions);
            MenuCommand optionsItem = new MenuCommand((s, e) => { ShowOptionPage(typeof(Options)); }, cmdOptions);
            mcs.AddCommand(optionsItem);


            //Debug.Write("
            Telemetry.TrackEvent("package add ExecuteFileVfp");

            // Exec VFP
            //CommandID cmdVfp = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdExecuteVfp);
            //OleMenuCommand exeItem = new OleMenuCommand(ExecuteFileVfp, cmdVfp);
            //exeItem.BeforeQueryStatus += BeforeExeQuery;
            //mcs.AddCommand(exeItem);

            // Exec CMD
            try
            {
                CommandID cmdCmdExe = new CommandID(GuidList.guidVfpLanguageCmdSet, (int)PkgCmdIDList.cmdExecuteConEmu);
                OleMenuCommand cmdItemConEmu = new OleMenuCommand(ExecuteConEmu, cmdCmdExe);
                cmdItemConEmu.BeforeQueryStatus += BeforeExeQuery;
                mcs.AddCommand(cmdItemConEmu);
            }
            catch (Exception ex)
            {
                //[Guid("338FB9A0-BAE5-11D2-8AD1-00C04F79E479")]
                //public interface Debugger  EnvDTE.Debugger
                if (System.Diagnostics.Debugger.IsAttached)
                    Debug.Write(String.Format("error {0}", ex.Message));
            }

            //            514 ERROR LegacySitePackage failed for package[VfpLanguagePackage]Source: 'System.Design' Description: There is already a 
            //                command handler for the menu command '59c8a2ef-5555-4f2d-93ee-ca16174989dd : 1281'
            //                    .System.ArgumentException: There is already a command handler for the menu 
            //                        command '59c8a2ef-5555-4f2d-93ee-ca16174989dd : 1281'.at 
            //                        System.ComponentModel.Design.MenuCommandService.AddCommand(MenuCommand command) at VfpLanguage.VfpLanguagePackage.Initialize() in 
            //                        D:\webstack\VSIX\VfpLanguage\src\VfpLanguagePackage.cs:line 71 
            //                        at Microsoft.VisualStudio.Shell.Package.Microsoft.VisualStudio.Shell.Interop.IVsPackage.SetSite(IServiceProvider sp)
            //                        { F4AB1E64 - 5555 - 4F06 - BAD9 - BF414F4B3CCC}
            //            80070057 - E_INVALIDARG VisualStudio 2016 / 12 / 11 18:00:58.630
            //515 ERROR SetSite failed for package[VfpLanguagePackage](null) { F4AB1E64 - 5555 - 4F06 - BAD9 - BF414F4B3CCC}
            //            80070057 - E_INVALIDARG VisualStudio 2016 / 12 / 11 18:00:58.657
            //516 ERROR End package load[VfpLanguagePackage]

            //Debug.Write(
            Telemetry.TrackEvent("package Success");
        }

        void BeforeExeQuery(object sender, EventArgs e)
        {
            OleMenuCommand button = (OleMenuCommand)sender;
            button.Enabled = button.Visible = false;
            var item = VsHelpers.GetProjectItem(_dte);

            if (item == null || item.FileCount == 0)
            {
                button.Enabled = button.Visible = false;
                return;
            }

            string path = item.FileNames[1];

            if (!VsHelpers.IsValidFileName(path))
                return;

            string[] allowed = { ".PRG", ".H", ".PRG" };
            string ext = Path.GetExtension(path).ToUpperInvariant();
            bool isEnabled = allowed.Contains(ext) && File.Exists(path);

            button.Enabled = button.Visible = isEnabled;
        }

        //private void ExecuteFileVfp(object sender, EventArgs e)
        //{
        //    var item = VsHelpers.GetProjectItem(_dte);
        //    string path = item.FileNames[1];
        //    string folder = Path.GetDirectoryName(path);

        //    Telemetry.TrackEvent("Open with VFP8 file");
        //    StartProcess(folder, "vfp8.exe", "\"" + Path.GetFileName(path) + "\"");
        //}

        private void ExecuteConEmu(object sender, EventArgs e)
        {
            var item = VsHelpers.GetProjectItem(_dte);
            string path = item.FileNames[1];
            string folder = Path.GetDirectoryName(path);

            Telemetry.TrackEvent("Open ConEmu");
            StartProcess(folder, @"d:\Tools\ConEmu.exe", "\"" + Path.GetFileName(path) + "\"");
        }


        private void BeforeQueryStatus(object sender, EventArgs e)
        {
            OleMenuCommand button = (OleMenuCommand)sender;
            Options options = GetDialogPage(typeof(Options)) as Options;

            button.Text = options.FriendlyName;
        }

        private void OpenCustom(object sender, EventArgs e)
        {
            Options options = GetDialogPage(typeof(Options)) as Options;
            string folder = VsHelpers.GetFolderPath(options, _dte);
            string arguments = (options.Arguments ?? string.Empty).Replace("%folder%", folder);

            Telemetry.TrackEvent("Open custom");
            StartProcess(folder, options.Command, arguments);
        }

        private void OpenCmd(object sender, EventArgs e)
        {
            string installDir = VsHelpers.GetInstallDirectory(this);
            string devPromptFile = Path.Combine(installDir, @"..\Tools\VsDevCmd.bat");

            Telemetry.TrackEvent("Open cmd");
            SetupProcess("cmd.exe", "/k \"" + devPromptFile + "\"");
        }

        private void OpenPowershell(object sender, EventArgs e)
        {
            Telemetry.TrackEvent("Open PowerShell");
            SetupProcess("powershell.exe", "-ExecutionPolicy Bypass -NoExit");
        }

        private void SetupProcess(string command, string arguments)
        {
            Options options = GetDialogPage(typeof(Options)) as Options;
            string folder = VsHelpers.GetFolderPath(options, _dte);

            StartProcess(folder, command, arguments);
        }

        private static void StartProcess(string workingDirectory, string command, string arguments)
        {
            try
            {
                command = Environment.ExpandEnvironmentVariables(command ?? string.Empty);
                arguments = Environment.ExpandEnvironmentVariables(arguments ?? string.Empty);

                ProcessStartInfo start = new ProcessStartInfo(command, arguments);
                start.WorkingDirectory = workingDirectory;
                start.LoadUserProfile = true;

                ModifyPathVariable(start);

                using (System.Diagnostics.Process.Start(start))
                {
                    // Makes sure the process handle is disposed
                }
            }
            catch (Exception ex)
            {
                Telemetry.TrackException(ex);
            }
        }

        private static void ModifyPathVariable(ProcessStartInfo start)
        {
            string path = ".\\node_modules\\.bin" + ";" + start.EnvironmentVariables["PATH"];

            string toolsDir = Environment.GetEnvironmentVariable("VS140COMNTOOLS");

            if (Directory.Exists(toolsDir))
            {
                string parent = Directory.GetParent(toolsDir).Parent.FullName;
                path += ";" + Path.Combine(parent, @"IDE\Extensions\Microsoft\Web Tools\External");
            }

            start.UseShellExecute = false;
            start.EnvironmentVariables["PATH"] = path;
        }
    }
}


//<package id = "Microsoft.VisualStudio.Language.Intellisense" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Language.StandardClassification" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.OLE.Interop" version="7.10.6070" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Framework" version="14.0" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Immutable.10.0" version="10.0.30319" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Immutable.12.0" version="12.0.21003" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Immutable.14.0" version="14.3.25407" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Interop" version="7.10.6071" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Interop.10.0" version="10.0.30319" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Interop.12.0" version="12.0.30110" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Interop.8.0" version="8.0.50727" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Shell.Interop.9.0" version="9.0.30729" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Text.Data" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Text.Logic" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Text.UI" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Text.UI.Wpf" version="12.0.21005" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.TextManager.Interop" version="7.10.6070" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.TextManager.Interop.8.0" version="8.0.50727" targetFramework="net45" />

// <!--<package id = "Microsoft.VisualStudio.Threading" version="15.0.20-pre" targetFramework="net45" />--> 
// <!--<package id = "Microsoft.VisualStudio.CoreUtility" version="15.0.25901-RC" targetFramework="net45" />-->
// <!--<package id = "Microsoft.VisualStudio.Shell.14.0" version="15.0.25414-Preview5" targetFramework="net45" />-->
// <!--<package id = "Microsoft.VisualStudio.Utilities" version="14.0" targetFramework="net45" />
// <package id = "Microsoft.VisualStudio.Validation" version="15.0.11-pre" targetFramework="net45" />-->

// Install-Package Microsoft.VisualStudio.Shell.14.0 -Version 14.3.25407 