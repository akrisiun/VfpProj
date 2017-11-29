using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Utilities;

namespace VfpLanguage
{
    class PrgContentTypeDefinition
    {
        public const string VfpContentType = "vfp program";
        public const string PrgContentType = VfpContentType;
        //public const string CmdContentType = PrgContentTypeDefinition.CmdContentType;

        [Export(typeof(ContentTypeDefinition))]
        [Name(VfpContentType)]
        [BaseDefinition("text")]
        public ContentTypeDefinition ICmdContentType { get; set; }

        [Export(typeof(FileExtensionToContentTypeDefinition))]
        [ContentType(VfpContentType)]
        [FileExtension(".prg")]
        public FileExtensionToContentTypeDefinition PrgFileExtension { get; set; }

        [Export(typeof(FileExtensionToContentTypeDefinition))]
        [ContentType(VfpContentType)]
        [FileExtension(".h")]
        public FileExtensionToContentTypeDefinition HFileExtension { get; set; }

    }
}
