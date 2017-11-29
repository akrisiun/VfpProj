﻿using System.Collections.Generic;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Editor;

namespace VfpLanguage
{
    internal class PrgQuickInfoController : IIntellisenseController
    {
//#if VS14
        private ITextView _textView;
        private IList<ITextBuffer> _subjectBuffers;
        private PrgQuickInfoControllerProvider _provider;
        private IQuickInfoSession _session;

        public PrgQuickInfoController() : this(null, null, null)
        {
        }

        
        internal PrgQuickInfoController(ITextView  textView
                , IList<ITextBuffer> subjectBuffers, PrgQuickInfoControllerProvider provider)
        {
            _textView = textView as ITextView;
            _textView.MouseHover += this.OnTextViewMouseHover;
            _subjectBuffers = subjectBuffers;
            _provider = provider;
        }

        private void OnTextViewMouseHover(object sender, MouseHoverEventArgs e)
        {
#if true // VS14
            //find the mouse position by mapping down to the subject buffer
            SnapshotPoint? point = _textView.BufferGraph.MapDownToFirstMatch
                 (new SnapshotPoint(_textView.TextSnapshot, e.Position),
                PointTrackingMode.Positive,
                snapshot => _subjectBuffers.Contains(snapshot.TextBuffer),
                PositionAffinity.Predecessor);

            if (point != null)
            {
                ITrackingPoint triggerPoint = point.Value.Snapshot.CreateTrackingPoint(point.Value.Position,
                PointTrackingMode.Positive);

                if (!_provider.QuickInfoBroker.IsQuickInfoActive(_textView))
                {
                    _session = _provider.QuickInfoBroker.TriggerQuickInfo(_textView, triggerPoint, true);
                }
            }
#endif

        }

        public void Detach(ITextView textView)
        {
            if (_textView == textView)
            {
                _textView.MouseHover -= this.OnTextViewMouseHover;
                _textView = null;
            }
        }

        public void ConnectSubjectBuffer(ITextBuffer subjectBuffer)
        {
        }

        public void DisconnectSubjectBuffer(ITextBuffer subjectBuffer)
        {
        }
    }
}
