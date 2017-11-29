using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VfpLanguage;
using System.Diagnostics;
using VfpProj.Wcf;

namespace Vfp15Test
{
    [TestClass]
    public class UnitTestVfpService
    {
        [TestMethod]
        public void Test_Init()
        {
            VfpLanguagePackage package = new VfpLanguagePackage();
            package.DoInit();
        }

        [TestMethod]
        public void Test_ServiceDebug()
        {
            if (!Debugger.IsAttached)
                return;
            // var exe = @"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe";  


            VfpServiceClient client = new VfpServiceClient();

            // Use the 'client' variable to call operations on the service.
            var vfp = client.Load(null);

            var status = client.Eval(null);

            //// Always close the client.
            client.Close();
        }

    }
}
