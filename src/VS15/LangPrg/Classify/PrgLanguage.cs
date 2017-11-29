using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace VfpLanguage
{
    public static class CmdLanguageLink
    {
        public static Regex CommentRegex { get { return CmdLanguage.CommentRegex; } }
    }

    public static class PrgLanguage
    {
        // Comment * //
        //      static Regex _rComment = new Regex("(?<=(^[\\s]+))?(rem|::).+|((?<=([\\s]+))&(rem|::).+)",
        private static Regex _rComment = new Regex("(?<=(^[\\s]+))?(rem|::).+|((?<=([\\s]+))&(" + "rem" //rem
                                                   + "|::).+)", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        private static Regex _rIdentifier = new Regex("(?<=(\\bset([\\s]+)))([\\S]+)(?=([\\s]+)?=)|%([^%\\s]+)%|%~([fdpnxsatz]+\\d)", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        private static Regex _rKeyword = GetKeywordRegex();
        //private static Regex _rLabel = new Regex("^(([\\s]+)?):([^\\s:]+)|(?<=(\\b" + "goto" + "(:|\\s)([\\s]+)?))([^\\s:]+)", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        private static Regex _rOperator = new Regex(@"(&|&&|\|\||([012]?>>?)|<|!|=|^)", RegexOptions.Compiled);
        private static Regex _rParameter = new Regex("(?<=(\\s))(/|-?-)([\\S]+)", RegexOptions.Compiled);
        private static Regex _rString = new Regex("(\"|')([^\\1]+)\\1|(?<=echo([\\s]+)).+", RegexOptions.Compiled);
        private static Dictionary<string, string> _keywords = GetList();

        public static Regex KeywordRegex { get { return _rKeyword; } }
        public static Regex StringRegex { get { return _rString; } }
        public static Regex IdentifierRegex { get { return _rIdentifier; } }
        public static Regex CommentRegex { get { return _rComment; } }
        public static Regex OperatorRegex { get { return _rOperator; } }
        public static Regex ParameterRegex { get { return _rParameter; } }
        //public static Regex LabelRegex { get { return _rLabel; } }

        public static Dictionary<string, string> Keywords {
            get { return _keywords; }
        }

        private static Regex GetKeywordRegex()
        {
            var list = GetList().Keys;
            string keywords = string.Join("|", list);
            return new Regex("(?<=(^|([\\s]+)))@?(" + keywords + ")\\b", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        }

        private static Dictionary<string, string> GetList()
        {
            return new Dictionary<string, string>
            {
                {"DO",        ""},
                {"FUNCTION",  ""},
                {"PROCEDURE", ""},
                {"PROC", ""},
                {"FUNC", ""},
                {"RETURN", "returns value"},
                {"DEFINE",  "" },
                {"ENDDEFINE",  "" },
                {"LPARAMETERS", "" },
                {"LPAR", "" },
                {"CLASS", "" },
                {"ADD", "" },
                {"OBJECT", "" },
                {"RELEASE", "" },
                {"ALL", "" },
                {"EXTENDED", "" },
                {"EXTERNAL", "" },
                {"IF", "" },
                {"ENDIF", "" },
                {"CLEAR", "" },
                {"SET", "" },
                {"SYSMENU", "" },
                {"TO", "" },
                {"DEFAULT", "" },
                {"CLOSE", "" },
                {"DATABASES", "" },
                {"IIF", "" },
                {"TYPE", "" },
                {"VERSION", "" },
                {"SAVE", "" },
                {"ASSERTS", "" },
                {"ON", "" },
                {"OFF", "" },
                {"WHILE",    ""},
                {"ENDWHILE", ""},
                {"FOR", "" },
                {"ENDFOR", "" },
                {"CASE", "" },
                {"WHEN", "" },
                {"SHUTDOWN", "" },
                {"ASSERT", "" },
                {"OTHERWISE", "" },
                {"OTHER", "" },
                {"ENDCASE", "" },
                {"CD", "" },
                {"DIRECTORY", "" },
                {"MODI", "" },
                {"PROJ", "" },
                {"MODIFY", "" },
                {"PROJECT", "" },
                {"WAIT", "" },
                {"WINDOW", "" },
                {"NOWAIT", "" },
                {"LOOP", "" },
                {"CONFIRM", "" },
                {"SAFETY", "" },
                {"COPY", "" },
                {"FILE", "" },
                {"BUILD", "" },
                {"EXE", "" },
                {"CANCEL", "" },

                {".F.", "" },
                {".T.", "" },
                {"MESSAGE", "" },
                {"_VFP", "" },
                {"_SCREEN", "" },
                {"Objects", "" },
                {"PEMSTATUS", "" },
                {"PATH", "" },
                {"ERROR", "" },
                {"LOCAL", "" },
                {"ARRAY", "" },
                {"AUSED", "" },
                {"USE", "" },
                {"PUBLIC", "" },
                {"PRIVATE", "" },
                {"RECCOUNT", "" },
                {"DBF", "" },
                {"IN", "" },
                {"FULLPATH", "" },
                {"CREATE", "" },
                {"CURSOR", "" },
                {"APPEND", "" },
                {"FROM", "" },
                {"ADIR", "" },
                {"SELECT", "" },
                {"COUNT", "" },
                {"WHERE", "" },
                {"GROUP", "" },
                {"BY", "" },
                {"LEFT", "" },
                {"JOIN", "" },
                {"CHR", "" },
                {"ASC", "" },
                {"MESSAGEBOX", "" },
                //{"MessageBox", "" },
            };
        }
    }
}
