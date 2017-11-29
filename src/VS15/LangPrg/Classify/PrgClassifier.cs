using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.VisualStudio.Language.StandardClassification;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;

namespace VfpLanguage
{
    public class PrgClassifier : IClassifier
    {
        public Dictionary<Regex, IClassificationType> _map;
        private IClassificationType _comment, _identifier;

        public PrgClassifier(IClassificationTypeRegistryService registry)
        {
            _comment = registry.GetClassificationType(PredefinedClassificationTypeNames.Comment);
            _identifier = registry.GetClassificationType(PredefinedClassificationTypeNames.SymbolDefinition);

            _map = new Dictionary<Regex, IClassificationType>
            {
                {PrgLanguage.StringRegex, registry.GetClassificationType(PredefinedClassificationTypeNames.String)},
                {PrgLanguage.KeywordRegex, registry.GetClassificationType(PredefinedClassificationTypeNames.Keyword)},
                // {PrgLanguage.LabelRegex, registry.GetClassificationType(PredefinedClassificationTypeNames.SymbolReference)},
                {PrgLanguage.OperatorRegex, registry.GetClassificationType(PredefinedClassificationTypeNames.Operator)},
                {PrgLanguage.ParameterRegex, registry.GetClassificationType(PredefinedClassificationTypeNames.ExcludedCode)},
            };
        }

        public IList<ClassificationSpan> GetClassificationSpans(SnapshotSpan span)
        {
            IList<ClassificationSpan> list = new List<ClassificationSpan>();
            string text = span.GetText();

            // Comments
            Match commentMatch = PrgLanguage.CommentRegex.Match(text);
            if (commentMatch.Success)
            {
                var result = new SnapshotSpan(span.Snapshot, span.Start + commentMatch.Index, commentMatch.Length);
                list.Add(new ClassificationSpan(result, _comment));

                if (commentMatch.Index == 0)
                    return list;
            }

            // Strings, keywords, operators and parameters
            foreach (Regex regex in _map.Keys)
            {
                var classifier = _map[regex];
                var matches = regex.Matches(text);

                foreach (Match match in matches)
                {
                    var hitSpan = new Span(span.Start + match.Index, match.Length);

                    if (!list.Any(s => s.Span.IntersectsWith(hitSpan)))
                    {
                        var result = new SnapshotSpan(span.Snapshot, hitSpan);
                        list.Add(new ClassificationSpan(result, classifier));
                    }
                }
            }

            // Identifier
            foreach (Match match in PrgLanguage.IdentifierRegex.Matches(text))
            {
                var result = new SnapshotSpan(span.Snapshot, span.Start + match.Index, match.Length);
                list.Add(new ClassificationSpan(result, _identifier));
            }

            return list;
        }

        public event EventHandler<ClassificationChangedEventArgs> ClassificationChanged
        {
            add { }
            remove { }
        }
    }
}