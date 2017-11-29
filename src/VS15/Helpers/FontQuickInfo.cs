﻿using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.Language.Intellisense;
using Microsoft.VisualStudio.Language.StandardClassification;
// Install-Package Microsoft.VisualStudio.Language.StandardClassification -Version 12.0.21005
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;

namespace VfpLanguage
{
    internal class FontQuickInfo : IQuickInfoSource
    {
        private CmdQuickInfoSourceProvider _provider1;
        private PrgQuickInfoSourceProvider _provider2;

        private readonly ITextBuffer _buffer;
        private IClassifierAggregatorService _classifierService;
        private bool _isDisposed;

        public FontQuickInfo(IQuickInfoSourceProvider provider, ITextBuffer subjectBuffer, IClassifierAggregatorService classifierService)
        {
            _provider1 = provider as CmdQuickInfoSourceProvider;
            _provider2 = provider as PrgQuickInfoSourceProvider;

            _buffer = subjectBuffer;
            _classifierService = classifierService;
        }

        public void AugmentQuickInfoSession(IQuickInfoSession session, IList<object> qiContent,
            out ITrackingSpan applicableToSpan)
        {
            applicableToSpan = null;

            if (session == null || qiContent == null)
                return;

            // Map the trigger point down to our buffer.
            SnapshotPoint? point = session.GetTriggerPoint(_buffer.CurrentSnapshot);
            if (!point.HasValue)
                return;

            var snapshot = _buffer.CurrentSnapshot;
            var classifier = _classifierService.GetClassifier(_buffer);

            var doc = new SnapshotSpan(snapshot, 0, snapshot.Length);
            var line = point.Value.GetContainingLine();
            var idents = classifier.GetClassificationSpans(line.Extent);

            bool handled = HandleVariables(qiContent, ref applicableToSpan, idents, point);

            if (handled)
                return;

            HandleKeywords(qiContent, ref applicableToSpan, idents, point);
        }

        private bool HandleVariables(IList<object> qiContent, ref ITrackingSpan applicableToSpan, 
            IList<ClassificationSpan> spans, SnapshotPoint? point)
        {
            ClassificationSpan span;
            string text = GetText(spans, point, PredefinedClassificationTypeNames.SymbolDefinition, out span);

            if (string.IsNullOrWhiteSpace(text))
                return false;

            string value = Environment.GetEnvironmentVariable(text.Trim('%'));

            if (string.IsNullOrEmpty(value))
                return false;

            string displayText = value;

            if (value.Equals("path", StringComparison.OrdinalIgnoreCase))
                displayText = string.Join(Environment.NewLine, value.Split(';'));

            applicableToSpan = _buffer.CurrentSnapshot.CreateTrackingSpan(span.Span, SpanTrackingMode.EdgeNegative);
            qiContent.Add(displayText);

            string expanded = Environment.ExpandEnvironmentVariables(value);

            if (expanded != value)
                qiContent.Add(expanded);

            return true;
        }

        private bool HandleKeywords(IList<object> qiContent, ref ITrackingSpan applicableToSpan,
            IList<ClassificationSpan> spans, SnapshotPoint? point)
        {
            ClassificationSpan span;
            string text = GetText(spans, point, PredefinedClassificationTypeNames.Keyword, out span);

            if (string.IsNullOrWhiteSpace(text))
                return false;

            if (!CmdLanguage.Keywords.ContainsKey(text.ToLowerInvariant()))
                return false;

            applicableToSpan = _buffer.CurrentSnapshot.CreateTrackingSpan(span.Span, SpanTrackingMode.EdgeNegative);
            qiContent.Add(CmdLanguage.Keywords[text.ToLowerInvariant()]);

            return true;
        }

        private string GetText(IList<ClassificationSpan> spans, SnapshotPoint? point, 
            string classification, out ClassificationSpan span)
        {
            var idents = spans.Where(g => g.ClassificationType.IsOfType(classification));
            span = idents.FirstOrDefault(i => i.Span.Contains(point.Value));

            if (span == null)
                return null;

            return span.Span.GetText().Trim();
        }

        public void Dispose()
        {
            if (!_isDisposed)
            {
                GC.SuppressFinalize(this);
                _isDisposed = true;
            }
        }
    }
}
