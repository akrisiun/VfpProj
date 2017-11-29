using System;
using System.Runtime.InteropServices;
using Microsoft.VisualStudio;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.OLE.Interop;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Editor;
using System.Collections.Generic;

namespace VfpLanguage
{
    public class VsGuidsList
    {
        public IList<Guid> List { get; set; }
        public IList<string> ListNames { get; set; }

        public static VsGuidsList Instance { get; set; }

        public static string GetName(Guid name)
        {
            string result = "<>";
            var instance = Instance;
            foreach (var guid in instance.List)
            {
                if (name == guid)
                {
                    var idx = instance.List.IndexOf(guid);
                    if (instance.ListNames.Count >= idx + 1)
                        result = instance.ListNames[idx];
                }
            }

            return result;
        }


        public VsGuidsList()
        {
            Instance = this;
            List = new List<Guid>();
            ListNames = new List<string>();

            List.Add(VSConstants.AssemblyReferenceProvider_Guid);
            ListNames.Add("AssemblyReferenceProvider_Guid");

            List.Add(VSConstants.BuildOrder);
            ListNames.Add("BuildOrder");

            List.Add(VSConstants.BuildOutput);
            ListNames.Add("BuildOutput");

            List.Add(VSConstants.BuildOutput);
            ListNames.Add("BuildOutput");

            List.Add(VSConstants.CLSID_ComPlusOnlyDebugEngine);
            ListNames.Add("CLSID_ComPlusOnlyDebugEngine");
            List.Add(VSConstants.CLSID_HtmDocData);
            ListNames.Add("CLSID_HtmDocData");
            List.Add(VSConstants.CLSID_HtmedPackage);
            ListNames.Add("CLSID_HtmedPackage");
            List.Add(VSConstants.CLSID_HtmlLanguageService);
            ListNames.Add("CLSID_HtmlLanguageService");
            List.Add(VSConstants.CLSID_MiscellaneousFilesProject);
            ListNames.Add("CLSID_MiscellaneousFilesProject");
            List.Add(VSConstants.CLSID_SolutionItemsProject);
            ListNames.Add("CLSID_SolutionItemsProject");
            List.Add(VSConstants.CLSID_VsCfgProviderEventsHelper);
            ListNames.Add("CLSID_VsCfgProviderEventsHelper");
            List.Add(VSConstants.CLSID_VsDocOutlinePackage);
            ListNames.Add("CLSID_VsDocOutlinePackage");
            List.Add(VSConstants.CLSID_VsEnvironmentPackage);
            ListNames.Add("CLSID_VsEnvironmentPackage");
            List.Add(VSConstants.CLSID_VsTaskList);
            ListNames.Add("CLSID_VsTaskList");
            List.Add(VSConstants.CLSID_VsTaskListPackage);
            ListNames.Add("CLSID_VsTaskListPackage");
            List.Add(VSConstants.CLSID_VsUIHierarchyWindow);
            ListNames.Add("CLSID_VsUIHierarchyWindow");
            List.Add(VSConstants.ComReferenceProvider_Guid);
            ListNames.Add("ComReferenceProvider_Guid");
            List.Add(VSConstants.ConnectedServiceInstanceReferenceProvider_Guid);
            ListNames.Add("ConnectedServiceInstanceReferenceProvider_Guid");
            List.Add(VSConstants.DebugOutput);
            ListNames.Add("DebugOutput");
            List.Add(VSConstants.FileReferenceProvider_Guid);
            ListNames.Add("FileReferenceProvider_Guid");
            //     The GUID of the COM Plus library.
            List.Add(VSConstants.guidCOMPLUSLibrary);
            ListNames.Add("guidCOMPLUSLibrary");
            //     Identifies commands fired as a result of a WM_APPCOMMAND message received by
            //     the main window.
            List.Add(VSConstants.GUID_AppCommand);
            ListNames.Add("GUID_AppCommand");
            //     The Browse File page.
            List.Add(VSConstants.GUID_BrowseFilePage);
            ListNames.Add("GUID_BrowseFilePage");
            List.Add(VSConstants.GUID_BuildOutputWindowPane);
            ListNames.Add("GUID_BuildOutputWindowPane");
            List.Add(VSConstants.GUID_COMClassicPage);
            ListNames.Add("GUID_COMClassicPage");
            List.Add(VSConstants.GUID_COMPlusPage);
            ListNames.Add("GUID_COMPlusPage");
            List.Add(VSConstants.GUID_DefaultEditor);
            ListNames.Add("GUID_DefaultEditor");
            List.Add(VSConstants.GUID_ExternalEditor);
            ListNames.Add("GUID_ExternalEditor");
            List.Add(VSConstants.GUID_HTMEDAllowExistingDocData);
            ListNames.Add("GUID_HTMEDAllowExistingDocData");
            List.Add(VSConstants.GUID_HtmlEditorFactory);
            ListNames.Add("GUID_HtmlEditorFactory");
            List.Add(VSConstants.GUID_ItemType_PhysicalFile);
            ListNames.Add("GUID_ItemType_PhysicalFile");
            List.Add(VSConstants.GUID_ItemType_PhysicalFolder);
            ListNames.Add("GUID_ItemType_PhysicalFolder");
#if !VS12
            List.Add(VSConstants.GUID_ItemType_SharedProjectReference);
            ListNames.Add("GUID_ItemType_SharedProjectReference");
#endif
            List.Add(VSConstants.GUID_ItemType_SubProject);
            ListNames.Add("GUID_ItemType_SubProject");
            List.Add(VSConstants.GUID_ItemType_VirtualFolder);
            ListNames.Add("GUID_ItemType_VirtualFolder");
            List.Add(VSConstants.GUID_OutWindowDebugPane);
            ListNames.Add("GUID_OutWindowDebugPane");
            List.Add(VSConstants.GUID_OutWindowGeneralPane);
            ListNames.Add("GUID_OutWindowGeneralPane");
            List.Add(VSConstants.GUID_ProjectDesignerEditor);
            ListNames.Add("GUID_ProjectDesignerEditor");
            List.Add(VSConstants.GUID_SolutionPage);
            ListNames.Add("GUID_SolutionPage");
            List.Add(VSConstants.GUID_TextEditorFactory);
            ListNames.Add("GUID_TextEditorFactory");
            //     String resource ID for Visual Studio pseudo-folder.
            List.Add(VSConstants.GUID_VsNewProjectPseudoFolder);
            ListNames.Add("GUID_VsNewProjectPseudoFolder");
            //     This GUID identifies the standard set of commands known by Visual Studio 97 (version

            List.Add(VSConstants.GUID_VSStandardCommandSet97);
            ListNames.Add("GUID_VSStandardCommandSet97");
            List.Add(VSConstants.GUID_VsTaskListViewAll);
            ListNames.Add("GUID_VsTaskListViewAll");
            List.Add(VSConstants.GUID_VsTaskListViewCheckedTasks);
            ListNames.Add("GUID_VsTaskListViewCheckedTasks");
            List.Add(VSConstants.GUID_VsTaskListViewCommentTasks);
            ListNames.Add("GUID_VsTaskListViewCommentTasks");
            List.Add(VSConstants.GUID_VsTaskListViewCompilerTasks);
            ListNames.Add("GUID_VsTaskListViewCompilerTasks");
            List.Add(VSConstants.GUID_VsTaskListViewCurrentFileTasks);
            ListNames.Add("GUID_VsTaskListViewCurrentFileTasks");
            List.Add(VSConstants.GUID_VsTaskListViewHTMLTasks);
            ListNames.Add("GUID_VsTaskListViewHTMLTasks");
            List.Add(VSConstants.GUID_VsTaskListViewShortcutTasks);
            ListNames.Add("GUID_VsTaskListViewShortcutTasks");
            List.Add(VSConstants.GUID_VsTaskListViewUncheckedTasks);
            ListNames.Add("GUID_VsTaskListViewUncheckedTasks");
            List.Add(VSConstants.GUID_VsTaskListViewUserTasks);
            ListNames.Add("GUID_VsTaskListViewUserTasks");
            List.Add(VSConstants.GUID_VsUIHierarchyWindowCmds);
            ListNames.Add("GUID_VsUIHierarchyWindowCmds");
            List.Add(VSConstants.GUID_VS_DEPTYPE_BUILD_PROJECT);
            ListNames.Add("GUID_VS_DEPTYPE_BUILD_PROJECT");
            //     Instructs the selection container not to change the value.
            // public static readonly IntPtr HIERARCHY_DONTCHANGE);
            //     Instructs the selection container to set the value to null.
            // public static readonly IntPtr HIERARCHY_DONTPROPAGATE);
            //     GUID of the IUnknown COM interface.

            List.Add(VSConstants.IID_IUnknown);
            ListNames.Add("IID_IUnknown");
            List.Add(VSConstants.LOGVIEWID_Any);
            ListNames.Add("LOGVIEWID_Any");
            List.Add(VSConstants.LOGVIEWID_Code);
            ListNames.Add("LOGVIEWID_Code");
            List.Add(VSConstants.LOGVIEWID_Debugging);
            ListNames.Add("LOGVIEWID_Debugging");
            List.Add(VSConstants.LOGVIEWID_Designer);
            ListNames.Add("LOGVIEWID_Designer");
            List.Add(VSConstants.LOGVIEWID_Primary);
            ListNames.Add("LOGVIEWID_Primary");
            List.Add(VSConstants.LOGVIEWID_TextView);
            ListNames.Add("LOGVIEWID_TextView");
            List.Add(VSConstants.LOGVIEWID_UserChooseView);
            ListNames.Add("LOGVIEWID_UserChooseView");

            List.Add(VSConstants.PlatformReferenceProvider_Guid);
            ListNames.Add("PlatformReferenceProvider_Guid");
            List.Add(VSConstants.ProjectReferenceProvider_Guid);
            ListNames.Add("ProjectReferenceProvider_Guid");
            //     Instructs the selection container not to change the value.
            // public static readonly IntPtr SELCONTAINER_DONTCHANGE);
            //     Instructs the selection container to set the value to null.
            // public static readonly IntPtr SELCONTAINER_DONTPROPAGATE);
            //ListNames.Add(only IntPtr SELCONTAINER_DONTPROPAGATE");
#if !VS12            
            List.Add(VSConstants.SharedProjectReferenceProvider_Guid);
            ListNames.Add("SharedProjectReferenceProvider_Guid");
#endif
            //     The name of the Visual Studio service that implements Microsoft.VisualStudio.OLE.Interop.IOleCommandTarget.
            List.Add(VSConstants.SID_SUIHostCommandDispatcher);
            ListNames.Add("SID_SUIHostCommandDispatcher");

            //     Returns an IID_IVsOutputWindowPane interface of the General output pane in the
            //     Visual Studio environment.
            List.Add(VSConstants.SID_SVsGeneralOutputWindowPane);
            ListNames.Add("SID_SVsGeneralOutputWindowPane");

            //     A Visual Studio toolbox service.
            List.Add(VSConstants.SID_SVsToolboxActiveXDataProvider);
            ListNames.Add("SID_SVsToolboxActiveXDataProvider");
            List.Add(VSConstants.UICONTEXT_CodeWindow);
            ListNames.Add("UICONTEXT_CodeWindow");
            List.Add(VSConstants.UICONTEXT_Debugging);
            ListNames.Add("UICONTEXT_Debugging");
            List.Add(VSConstants.UICONTEXT_DesignMode);
            ListNames.Add("UICONTEXT_DesignMode");
            List.Add(VSConstants.UICONTEXT_Dragging);
            ListNames.Add("UICONTEXT_Dragging");
            List.Add(VSConstants.UICONTEXT_EmptySolution);
            ListNames.Add("UICONTEXT_EmptySolution");
            List.Add(VSConstants.UICONTEXT_FullScreenMode);
            ListNames.Add("UICONTEXT_FullScreenMode");
            List.Add(VSConstants.UICONTEXT_NoSolution);
            ListNames.Add("UICONTEXT_NoSolution");
            List.Add(VSConstants.UICONTEXT_SolutionBuilding);
            ListNames.Add("UICONTEXT_SolutionBuilding");
            List.Add(VSConstants.UICONTEXT_SolutionExists);
            ListNames.Add("UICONTEXT_SolutionExists");
            List.Add(VSConstants.UICONTEXT_SolutionHasAppContainerProject);
            ListNames.Add("UICONTEXT_SolutionHasAppContainerProject");
            List.Add(VSConstants.UICONTEXT_SolutionHasMultipleProjects);
            ListNames.Add("UICONTEXT_SolutionHasMultipleProjects");
            List.Add(VSConstants.UICONTEXT_SolutionHasSingleProject);
            ListNames.Add("UICONTEXT_SolutionHasSingleProject");
            List.Add(VSConstants.VsStd11);
            ListNames.Add("VsStd11");
            List.Add(VSConstants.VsStd12);
            ListNames.Add("VsStd12");

#if !VS12            
            List.Add(VSConstants.VsStd14);
            ListNames.Add("VsStd14");
#endif
            List.Add(VSConstants.VsStd2010);
            ListNames.Add("VsStd2010");
            List.Add(VSConstants.VSStd2K);
            ListNames.Add("VSStd2K");

        }
    }

}