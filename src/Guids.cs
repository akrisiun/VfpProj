using System;

namespace VfpLanguage
{
    static class GuidList
    {
        public const string guidVfpLanguagePkgString = Vsix.Id;
        // "f4ab1e64-5555-4f06-bad9-bf414f4b3cc5";
        public const string guidVfpLanguageCmdSetString = "59c8a2ef-5555-4f2d-93ee-ca16174989dd";

        public static readonly Guid guidVfpLanguageCmdSet = new Guid(guidVfpLanguageCmdSetString);

        //public const string guidLanguageCmdSetString = "59c8a2ef-5555-4f2d-93ee-ca16174989cc";
        //public static readonly Guid guidLanguageCmdSet = new Guid(guidVfpLanguageCmdSetString);
                            // guidLanguageCmdSet
    }

    static class PkgCmdIDList
    {
        public const uint cmdidVfpLanguage = 0x101;
        public const uint cmdidOpenCmd = 0x201;
        public const uint cmdidOpenPowershell = 0x300;
        public const uint cmdidOpenOptions = 0x401;

        //public const uint cmdExecuteVfp = 0x501;
        public const uint cmdExecuteConEmu = 0x502;
        
        // <Button guid = "guidVfpLanguageCmdSet" id="cmdExecuteVfp" priority="0x0501" type="Button">
        // <Button guid = "guidVfpLanguageCmdSet" id="cmdExecuteCmd" priority="0x0502" type="Button">
    }
}