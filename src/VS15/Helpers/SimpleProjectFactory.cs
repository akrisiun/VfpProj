using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.Internal.VisualStudio.PlatformUI;
using Microsoft.VisualStudio.Shell;
using System.Runtime.InteropServices;


using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Language.StandardClassification;
// Install-Package Microsoft.VisualStudio.Language.StandardClassification -Version 12.0.21005
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;

namespace VfpLanguage
{
    // ## https://msdn.microsoft.com/en-us/library/hh966591.aspx
    // https://github.com/Microsoft/visualstudio-docs/blob/master/docs/extensibility/extending-the-solution-explorer-filter.md
    // https://github.com/Microsoft/visualstudio-docs/blob/master/docs/extensibility/creating-a-basic-project-system-part-1.md

    //SimpleProjectPackageGuids.cs in the code editor.
    //Create GUIDs for your project factory(on the Tools menu, click Create GUID), 
    // use the one in the following example.Add the GUIDs to the SimpleProjectPackageGuids class. 
    // The GUIDs must be in both GUID form and string form.The resulting code should resemble the following example.

    static class SimpleProjectPackageGuids
    {
        public const string guidSimpleProjectPkgString =
            "96bf4c26-d94e-43bf-a56a-f8500b52bfad";
        public const string guidSimpleProjectCmdSetString =
            "72c23e1d-f389-410a-b5f1-c938303f1391";
        public const string guidSimpleProjectFactoryString =
            "471EC4BB-E47E-4229-A789-D1F5F83B52D4";

        public static readonly Guid guidSimpleProjectCmdSet =
            new Guid(guidSimpleProjectCmdSetString);
        public static readonly Guid guidSimpleProjectFactory =
            new Guid(guidSimpleProjectFactoryString);
    }


    //Add a Guid attribute to the SimpleProjectFactory class. The value of the attribute is the new project factory GUID.

    [Guid(SimpleProjectPackageGuids.guidSimpleProjectFactoryString)]
    class SimpleProjectFactory
    {

    }

    //     Now you can register your project template.
    //To register the project template     In SimpleProjectPackage.cs, 
    //    add a xref:Microsoft.VisualStudio.Shell.ProvideProjectFactoryAttribute attribute to the SimpleProjectPackage class, 

    //    Severity Code    Description Project File Line    Suppression State
    //Error CS0012  The type 'RegistrationAttribute' is defined in an assembly that is not referenced.You must add a reference to
    //    assembly 'Microsoft.VisualStudio.Shell.Framework, Version=15.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.	
    //    VfpLanguage15 D:\webstack\VSIX\VfpLanguage\src\Helpers\SimpleProjectFactory.cs    57	Active


    [ProvideProjectFactory(typeof(SimpleProjectFactory), "Simple Project",
          "VFP Project Files (*.pjx);*.pjx", "pjx", "pjx",
          @"Templates\Projects\pjxProject",
          LanguageVsTemplate = "pjxProject")]
    [Guid(SimpleProjectPackageGuids.guidSimpleProjectPkgString)]
    public sealed class SimpleProjectPackage : Package
    {

    }


}