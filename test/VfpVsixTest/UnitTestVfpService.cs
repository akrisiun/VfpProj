using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using Xunit.Sdk;
using System.Linq;
// using System.ServiceModel;

namespace Vfp15Test
{
#if VSIX
    using VfpLanguage;
using VfpProj.Wcf;

    [TestClass]
    public class UnitTestVfpLang
    {
        [TestMethod]
        public void Test_Init()
        {
            VfpLanguagePackage package = new VfpLanguagePackage();
            package.DoInit();
        }
    }

#endif

    [TestClass]
    public class UnitTestVfpService
    {

        // var exe = @"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe";  

        static string baseAddress = "http://localhost:9001/VfpService";
        static string baseAddressJson = "http://localhost:9001/Vfp/";

        [TestMethod]
        public void Test_ServiceDebug()
        {
            if (!Debugger.IsAttached)
                return;

            var client = new Vfp15Test.VfpService.VfpServiceClient();
            client.Endpoint.Address = new System.ServiceModel.EndpointAddress(baseAddress);
            var f = client.Endpoint.EndpointBehaviors.First();
            var vfp = client.Load(null);

            var obj = client.WcfChannel;
            var dir = client.Eval("_VFP.DefaultFilePath");
            var err = dir.Length >= 2 ? dir[1].Value : null;

            Console.WriteLine($"_VFP.DefaultFilePath= {dir}");

            var status = client.Eval("_VFP.StatusBar");
            Console.WriteLine($"_VFP.StatusBar=\"{status}\";");

            //// Always close the client.
            client.Close();
            Debugger.Break();
        }

        [TestMethod]
        public void Test_ServiceJson()
        {
            var uri = baseAddressJson;

            //  http://localhost:9001/Vfp/Load
        }

        [TestMethod]
        public void Test_ServiceJsonEval()
        {
            var uri = baseAddressJson;
            // http://localhost:9001/Vfp/Eval/?_VFP.StatusBar
        }
    }
}

