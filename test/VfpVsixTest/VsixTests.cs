using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

namespace Vfp15Test
{
//    using VfpLanguage;
    [TestClass]
    public class VsixTests
    {
        //[TestMethod]
        //public void Test_Init()
        //{
        //    VfpLanguagePackage package = new VfpLanguagePackage();
        //    package.DoInit();
        //}

        [TestMethod]
        public void Test_Debug()
        {
            if (!Debugger.IsAttached)
                return;

            var exe = @"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe";
            var StartInfo = new ProcessStartInfo
            {
                UseShellExecute = false,
                FileName = exe,
                Arguments = "/rootsuffix Exp"
            };
            var process = new Process { StartInfo = StartInfo };
            // /rootsuffix Exp
            Exception error = null;

            try
            {

                var ok = process.Start();
            }
            catch (Exception ex) { error = ex; }

            Assert.IsTrue(error == null);

            process.WaitForExit();
        }


    }
}
