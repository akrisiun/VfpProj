using System.ComponentModel.Composition;
using Microsoft.VisualStudio;
using Microsoft.VisualStudio.Editor;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.OLE.Interop;
using Microsoft.VisualStudio.Text.Editor;
using Microsoft.VisualStudio.TextManager.Interop;
using Microsoft.VisualStudio.Utilities;

namespace VfpLanguage
{
    [Export(typeof(IVsTextViewCreationListener))]
    [ContentType(PrgContentTypeDefinition.PrgContentType)]
    [TextViewRole(PredefinedTextViewRoles.Interactive)]
    internal sealed class PrgVsTextViewCreationListener : IVsTextViewCreationListener
    {
        [Import]
        IVsEditorAdaptersFactoryService AdaptersFactory = null;

        [Import]
        ICompletionBroker CompletionBroker = null;

        public void VsTextViewCreated(IVsTextView textViewAdapter)
        {
            IWpfTextView view = AdaptersFactory.GetWpfTextView(textViewAdapter);

            var filter = new PrgCommandFilter(view, CompletionBroker);

            IOleCommandTarget next;
            ErrorHandler.ThrowOnFailure(textViewAdapter.AddCommandFilter(filter, out next));
            filter.Next = next;
        }
    }
}