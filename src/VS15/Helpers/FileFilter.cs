using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.Internal.VisualStudio.PlatformUI;
using Microsoft.VisualStudio.Shell;

using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Language.StandardClassification;
// Install-Package Microsoft.VisualStudio.Language.StandardClassification -Version 12.0.21005
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using System.Globalization;
using System.Diagnostics;

namespace VfpLanguage
{
    // ## https://msdn.microsoft.com/en-us/library/hh966591.aspx
    // https://github.com/Microsoft/visualstudio-docs/blob/master/docs/extensibility/extending-the-solution-explorer-filter.md

    public static class FileFilterPackageGuids
    {
        public const string guidFileFilterPackageCmdSetString = ""; // TODO
            // (uint) 
        public const uint FileFilterId = 0;

    }

    //Assembly Microsoft.VisualStudio.Shell.Framework, Version=15.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
    // c:\Users\Andrius\.nuget\packages\Microsoft.VisualStudio.Shell.Framework.15.0.25901-RC\lib\net45\Microsoft.VisualStudio.Shell.Framework.dll
    // Install-Package Microsoft.VisualStudio.Shell.Framework -Pre
    // Install-Package Microsoft.VisualStudio.Shell.14.0 -Pre

    // Implements ISolutionTreeFilterProvider. The SolutionTreeFilterProvider attribute declares it as a MEF component  
    
  //        <!--<package id = "Microsoft.VisualStudio.CoreUtility" version="15.0.25901-RC" targetFramework="net45" />-->
  //<!--<package id = "Microsoft.VisualStudio.Shell.14.0" version="15.0.25414-Preview5" targetFramework="net45" />-->
  //<!--<package id = "Microsoft.VisualStudio.Utilities" version="14.0" targetFramework="net45" />
  //<package id = "Microsoft.VisualStudio.Validation" version="15.0.11-pre" targetFramework="net45" />-->

        
    //[SolutionTreeFilterProvider(
    //    FileFilterPackageGuids.guidFileFilterPackageCmdSetString, (uint)(FileFilterPackageGuids.FileFilterId))
    //]
    public sealed class FileNameFilterProvider : HierarchyTreeFilterProvider
    {
        //SVsServiceProvider svcProvider;
        //IVsHierarchyItemCollectionProvider hierarchyCollectionProvider;

        // Constructor required for MEF composition  
        [ImportingConstructor]
        public FileNameFilterProvider() // SVsServiceProvider serviceProvider, IVsHierarchyItemCollectionProvider hierarchyCollectionProvider)
        {
            //this.svcProvider = serviceProvider;
            //this.hierarchyCollectionProvider = hierarchyCollectionProvider;
        }

        // Returns an instance of Create filter class.  
        protected override HierarchyTreeFilter CreateFilter()
        {
            return null; // new FileNameFilter(this.svcProvider, this.hierarchyCollectionProvider, FileNamePattern);
        }

        // Regex pattern for CSharp factory classes  
        private const string FileNamePattern = @"\w*factory\w*(.cs$)";

        // Implementation of file filtering  
        //private sealed class FileNameFilter : HierarchyTreeFilter
        //{
        //    private readonly Regex regexp;
        //    private readonly IServiceProvider svcProvider;
        //    private readonly IVsHierarchyItemCollectionProvider hierarchyCollectionProvider;

        //    public FileNameFilter(
        //        IServiceProvider serviceProvider,
        //        IVsHierarchyItemCollectionProvider hierarchyCollectionProvider,
        //        string fileNamePattern)
        //    {
        //        this.svcProvider = serviceProvider;
        //        this.hierarchyCollectionProvider = hierarchyCollectionProvider;
        //        this.regexp = new Regex(fileNamePattern, RegexOptions.IgnoreCase);
        //    }

        //    // Gets the items to be included from this filter provider.   
        //    // rootItems is a collection that contains the root of your solution  
        //    // Returns a collection of items to be included as part of the filter  
        //    protected override async Task<IReadOnlyObservableSet> GetIncludedItemsAsync(IEnumerable<IVsHierarchyItem> rootItems)
        //    {
        //        IVsHierarchyItem root = HierarchyUtilities.FindCommonAncestor(rootItems);
        //        IReadOnlyObservableSet<IVsHierarchyItem> sourceItems;
        //        sourceItems = await hierarchyCollectionProvider.GetDescendantsAsync(
        //                            root.HierarchyIdentity.NestedHierarchy,
        //                            CancellationToken);

        //        IFilteredHierarchyItemSet includedItems = await hierarchyCollectionProvider.GetFilteredHierarchyItemsAsync(
        //            sourceItems,
        //            ShouldIncludeInFilter,
        //            CancellationToken);
        //        return includedItems;
        //    }

        //    // Returns true if filters hierarchy item name for given filter; otherwise, false</returns>  
        //    private bool ShouldIncludeInFilter(IVsHierarchyItem hierarchyItem)
        //    {
        //        if (hierarchyItem == null)
        //        {
        //            return false;
        //        }
        //        return this.regexp.IsMatch(hierarchyItem.Text);
        //    }


        //    // In FileFilter.cs, remove the command placement and handling code from the FileFilter constructor.The result should look like this:
        //    private void DoFileFilter(Package package)
        //    {
        //        if (package == null)
        //        {
        //            throw new ArgumentNullException("package");
        //        }

        //        //this.package = package;
        //    }


        //    // In FileFilterPackage, cs, replace the code in the Initialize() method with the following:
        //    // protected override void Initialize()
        //    private // override 
        //            void Initialize()
        //    {
        //        Debug.WriteLine(string.Format(CultureInfo.CurrentCulture, "Entering Initialize() of: {0}", this.ToString()));
        //        //base.Initialize();
        //    }
        //}
    }
    
}