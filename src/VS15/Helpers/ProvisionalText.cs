﻿using System;
using System.ComponentModel.Composition;
using System.Linq;
using System.Windows;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Threading;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Editor;
using Microsoft.VisualStudio.Text.Projection;
using Microsoft.VisualStudio.Utilities;

namespace VfpLanguage
{

#if true // VS14
    [Export(typeof(IWpfTextViewCreationListener))]
    [ContentType(CmdContentTypeDefinition.CmdContentType)]
    [TextViewRole(PredefinedTextViewRoles.Document)]
    internal sealed class HtmlProvisionalTextHighlightFactory : IWpfTextViewCreationListener
    {
        public const string Name = "HtmlProvisionalTextHighlight";

        [Export(typeof(AdornmentLayerDefinition))]
        [Name(Name)]
        [Order(Before = PredefinedAdornmentLayers.Outlining)]
        [TextViewRole(PredefinedTextViewRoles.Document)]
        public AdornmentLayerDefinition EditorAdornmentLayer { get; set; }

        public void TextViewCreated(IWpfTextView textView)
        {
        }
    }

#endif

    public class ProvisionalText
    {
        public static bool IgnoreChange { get; set; }

        public event EventHandler<EventArgs> OnClose;
        public char ProvisionalChar { get; private set; }
        public ITrackingSpan TrackingSpan { get; private set; }

#if true
        private ITextView _textView;
        private readonly IAdornmentLayer _layer;
#endif
        private Path _highlightAdornment;
        private readonly Brush _highlightBrush;
        private bool _overtype = false;
        private bool _delete = false;
        private bool _projectionsChanged = false;
        private bool _adornmentRemoved = false;
        private IProjectionBuffer _projectionBuffer;

        public ProvisionalText(object // ITextView 
                textView, Span textSpan)
        {
            IgnoreChange = false;

#if true // VS14
            _textView = textView as ITextView;

            var wpfTextView = (IWpfTextView)_textView;
            _layer = wpfTextView.GetAdornmentLayer(HtmlProvisionalTextHighlightFactory.Name);

            var textBuffer = _textView.TextBuffer;
            var snapshot = textBuffer.CurrentSnapshot;
            var provisionalCharSpan = new Span(textSpan.End - 1, 1);

            TrackingSpan = snapshot.CreateTrackingSpan(textSpan, SpanTrackingMode.EdgeExclusive);
            _textView.Caret.PositionChanged += OnCaretPositionChanged;

            textBuffer.Changed += OnTextBufferChanged;
            textBuffer.PostChanged += OnPostChanged;

            var projectionBuffer = _textView.TextBuffer as IProjectionBuffer;
            if (projectionBuffer != null)
            {
                projectionBuffer.SourceSpansChanged += OnSourceSpansChanged;
            }
#endif

            Color highlightColor = SystemColors.HighlightColor;
            Color baseColor = Color.FromArgb(96, highlightColor.R, highlightColor.G, highlightColor.B);
            _highlightBrush = new SolidColorBrush(baseColor);

#if true // VS14
            ProvisionalChar = snapshot.GetText(provisionalCharSpan)[0];
            HighlightSpan(provisionalCharSpan.Start);
#endif
        }

        public Span CurrentSpan
        {
            get
            {
                return TrackingSpan.GetSpan(_textView.TextBuffer.CurrentSnapshot);
            }
        }

        private void EndTracking()
        {
#if true // VS14
            if (_textView != null)
            {
                ClearHighlight();

                if (_projectionBuffer != null)
                {
                    _projectionBuffer.SourceSpansChanged -= OnSourceSpansChanged;
                    _projectionBuffer = null;
                }

                if (_projectionsChanged || _adornmentRemoved)
                {
                    _projectionsChanged = false;
                    _adornmentRemoved = false;
                }

                _textView.TextBuffer.Changed -= OnTextBufferChanged;
                _textView.TextBuffer.PostChanged -= OnPostChanged;

                _textView.Caret.PositionChanged -= OnCaretPositionChanged;
                _textView = null;

                if (OnClose != null)
                    OnClose(this, EventArgs.Empty);
            }
#endif
        }

        public bool IsPositionInSpan(int position)
        {
            if (_textView != null)
            {
                if (CurrentSpan.Contains(position) && position > CurrentSpan.Start)
                    return true;
            }

            return false;
        }

        private void OnSourceSpansChanged(object sender, ProjectionSourceSpansChangedEventArgs e)
        {
            _projectionsChanged = true;
            Dispatcher.CurrentDispatcher.BeginInvoke(new Action(ResoreHighlight));
        }

        void OnCaretPositionChanged(object sender, CaretPositionChangedEventArgs e)
        {
            // If caret moves outside of the text tracking span, consider text final
            var position = _textView.Caret.Position.BufferPosition;

            if (!CurrentSpan.Contains(position) || position == CurrentSpan.Start)
            {
                EndTracking();
            }
        }

        void OnPostChanged(object sender, EventArgs e)
        {
            if (_textView != null && !IgnoreChange && !_projectionsChanged)
            {
                if (_overtype || _delete)
                {
                    _textView.TextBuffer.Replace(new Span(CurrentSpan.End - 1, 1), String.Empty);
                    EndTracking();
                }
                else
                {
                    HighlightSpan(CurrentSpan.End - 1);
                }
            }
        }

        void OnTextBufferChanged(object sender, TextContentChangedEventArgs e)
        {
            // Zero changes typically means secondary buffer regeneration
            if (e.Changes.Count == 0)
            {
                _projectionsChanged = true;
                Dispatcher.CurrentDispatcher.BeginInvoke(new Action(ResoreHighlight));
            }

            if (_textView != null && !IgnoreChange && !_projectionsChanged)
            {
                // If there is a change outside text span or change over provisional
                // text, we are done here: commit provisional text and disconnect.

                if (CurrentSpan.Length > 0 && e.Changes.Count == 1)
                {
                    var change = e.Changes[0];

                    if (CurrentSpan.Contains(change.OldSpan))
                    {
                        // Check provisional text overtype
                        if (change.OldLength == 0 && change.NewLength == 1 && change.OldPosition == CurrentSpan.End - 2)
                        {
                            char ch = _textView.TextBuffer.CurrentSnapshot.GetText(change.NewPosition, 1)[0];

                            if (ch == ProvisionalChar)
                                _overtype = true;
                        }
                        else if (change.NewLength > 0 && change.NewText.Last() == ProvisionalChar)//(change.NewLength == 0 && change.OldLength > 0 && change.OldPosition == CurrentSpan.Start)
                        {
                            // Deleting open quote or brace should also delete provisional character
                            _delete = true;
                        }

                        return;
                    }
                }

                EndTracking();
            }
        }

        private void ResoreHighlight()
        {
            if (_textView != null && (_projectionsChanged || _adornmentRemoved))
            {
                HighlightSpan(CurrentSpan.End - 1);
            }

            _projectionsChanged = false;
            _adornmentRemoved = false;
        }

        void HighlightSpan(int bufferPosition)
        {
            ClearHighlight();

#if true // VS14
            var wpfTextView = (IWpfTextView)_textView;
            var snapshotSpan = new SnapshotSpan(wpfTextView.TextBuffer.CurrentSnapshot, new Span(bufferPosition, 1));

            Geometry highlightGeometry = wpfTextView.TextViewLines.GetTextMarkerGeometry(snapshotSpan);
            if (highlightGeometry != null)
            {
                _highlightAdornment = new Path();
                _highlightAdornment.Data = highlightGeometry;
                _highlightAdornment.Fill = _highlightBrush;
            }

            if (_highlightAdornment != null)
            {
                _layer.AddAdornment(
                    AdornmentPositioningBehavior.TextRelative, snapshotSpan,
                    this, _highlightAdornment, new AdornmentRemovedCallback(OnAdornmentRemoved));
            }
#endif
        }

        private bool _removing = false;

        private void OnAdornmentRemoved(object tag, UIElement element)
        {
            if (_removing)
                return;

            _adornmentRemoved = true;
            Dispatcher.CurrentDispatcher.BeginInvoke(new Action(ResoreHighlight));
        }

        private void ClearHighlight()
        {
            if (_highlightAdornment != null)
            {
                _removing = true;

#if true // VS14
                _layer.RemoveAdornment(_highlightAdornment);
#endif
                _highlightAdornment = null;

                _removing = false;
            }
        }
    }

}
