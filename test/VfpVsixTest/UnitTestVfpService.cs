using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VfpLanguage;
using System.Diagnostics;
using VfpProj.Wcf;
using Xunit.Sdk;

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

        // var exe = @"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe";  

        static string baseAddress = "http://localhost:9001/VfpService";
        static string baseAddressJson = "http://localhost:9001/Vfp/";

        [TestMethod]
        public void Test_ServiceDebug()
        {
            if (!Debugger.IsAttached)
                return;

            var client = new Vfp15Test.VfpService.VfpServiceClient();
            //  VfpServiceClient client = new VfpServiceClient();
            client.Endpoint.Address = new System.ServiceModel.EndpointAddress(baseAddress);

            //  binding = "basicHttpBinding" : Content Type application/xml; charset=utf-8 was not supported by 
            // Use the 'client' variable to call operations on the service.
            var vfp = client.Load(null);

            var status = client.Eval("_VFP.StatusBar");

            //// Always close the client.
            client.Close();
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
