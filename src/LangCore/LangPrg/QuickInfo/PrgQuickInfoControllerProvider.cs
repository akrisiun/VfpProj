using System.Collections.Generic;
using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Editor;
using Microsoft.VisualStudio.Utilities;

namespace VfpLanguage
{
    // Install-Package Microsoft.VisualStudio.Language.Intellisense -Version 12.0.21005
    
//PM> Install-Package Microsoft.VisualStudio.Language.Intellisense -Version 12.0.21005
//Attempting to resolve dependency 'Microsoft.VisualStudio.Text.UI (≥ 12.0.21005)'.
//Attempting to resolve dependency 'Microsoft.VisualStudio.Text.Data (≥ 12.0.21005)'.
//Attempting to resolve dependency 'Microsoft.VisualStudio.CoreUtility (≥ 12.0.21005)'.
//Attempting to resolve dependency 'Microsoft.VisualStudio.Text.Logic (≥ 12.0.21005)'.

    [Export(typeof(IIntellisenseControllerProvider))]
    [Name("Prg QuickInfo Controller")]
    [ContentType(PrgContentTypeDefinition.PrgContentType)]
    internal class PrgQuickInfoControllerProvider : IIntellisenseControllerProvider
    {
        [Import]
        internal IQuickInfoBroker QuickInfoBroker { get; set; }

        public IIntellisenseController TryCreateIntellisenseController(ITextView textView, IList<ITextBuffer> subjectBuffers)
        {
            return new PrgQuickInfoController(textView, subjectBuffers, this);
        }
    }
}
