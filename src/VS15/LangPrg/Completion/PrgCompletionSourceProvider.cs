using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Text.Operations;
using Microsoft.VisualStudio.Utilities;

namespace VfpLanguage
{
    [Export(typeof(ICompletionSourceProvider))]
    [ContentType(PrgContentTypeDefinition.PrgContentType)]
    [Name("PrgCompletion")]
    class PrgCompletionSourceProvider : ICompletionSourceProvider
    {
        [Import]
        internal IClassifierAggregatorService AggregatorService = null;

        [Import]
        internal IGlyphService GlyphService = null;

        [Import]
        public ITextStructureNavigatorSelectorService TextStructureNavigatorSelector = null;

        public ICompletionSource TryCreateCompletionSource(ITextBuffer textBuffer) // , char? triggerChar = null
        {
            ITextStructureNavigator textStructureNavigator = TextStructureNavigatorSelector.GetTextStructureNavigator(textBuffer);

            return new PrgCompletionSource(textBuffer, AggregatorService, GlyphService, textStructureNavigator);
        }
    }
}