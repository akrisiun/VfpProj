using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Text.Editor;
using Microsoft.VisualStudio.Utilities;
using System.Diagnostics;
using System;

namespace VfpLanguage
{
    //#region Assembly Microsoft.VisualStudio.Text.Logic.dll, v14.0.0.0
    //// D:\webstack\VSIX\OpenCommandLine\packages\Microsoft.VisualStudio.Text.Logic.14.2.25123\lib\net45\Microsoft.VisualStudio.Text.Logic.dll
    //#endregion

    // Install-Package Microsoft.VisualStudio.Text.Logic -Version 12.0.21005
    //    <package id="Microsoft.VisualStudio.Text.Data" version="12.0.21005" targetFramework="net45" />
    //    <package id="Microsoft.VisualStudio.Text.Logic" version="12.0.21005" targetFramework="net45" />

    [Export(typeof(IClassifierProvider))]
    [ContentType(PrgContentTypeDefinition.PrgContentType)]
    [TextViewRole(PredefinedTextViewRoles.Document)]
    public class PrgClassifierProvider : IClassifierProvider
    {
        [Import]
        public IClassificationTypeRegistryService Registry { get; set; }

        public IClassifier GetClassifier(ITextBuffer textBuffer)
        {
            IClassifier obj = null;
            try
            {
                obj = textBuffer.Properties.GetOrCreateSingletonProperty<PrgClassifier>(() => new PrgClassifier(Registry));
            }
            catch (Exception ex) { 
                if (Debugger.IsAttached)
                {
                    Debugger.Log(0, "Error", ex.Message);
                    if (ex.InnerException != null)
                        Debugger.Log(0, "Error", ex.InnerException.Message);
                    Debugger.Break();
                }
            }

            return obj;
        }
    }
}