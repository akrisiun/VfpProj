using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VfpProj;

namespace Vfp15Test
{
    using Wcf = VfpProj.Wcf;

    [TestClass]
    public class VfpCmdTests
    {
        [TestInitialize]
        public void Test_Init()
        {
            // VfpLanguagePackage package = new VfpLanguagePackage();
            Service = new Wcf.VfpServiceTest();
            Wcf.VfpWcf.Instance = Service;
        }

        public Wcf.VfpServiceTest Service;
 

        [TestMethod]
        public void Test_VfpLoad()
        {
            var res = Service.Load(null);
        }

        [TestMethod]
        public void Test_VfpJsonEval()
        {
            var res = Service.Eval(null);

        }

    }
}
