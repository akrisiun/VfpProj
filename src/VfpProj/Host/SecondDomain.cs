using System;
using System.Security.Policy;

namespace VfpProj.Domain.Engine
{
    public class SecondDomain : IDisposable
    {
        public static int Index { get; set; }
        public static SecondDomain Instance { get; private set; }

        static SecondDomain()
        {
            Instance = new SecondDomain();
        }

        public _AppDomain SecondAppDomain { get; protected set; }

        public static SecondDomain Load()
        {
            if (Instance != null)
                Instance.Dispose();

            Instance = new SecondDomain();
            Index++;

            // https://stackoverflow.com/questions/658498/how-to-load-an-assembly-to-appdomain-with-all-references-recursively
            AppDomainSetup info = new AppDomainSetup();
            info.ApplicationBase = System.Environment.CurrentDirectory;
            Evidence adevidence = AppDomain.CurrentDomain.Evidence;

            Instance.SecondAppDomain = AppDomain.CreateDomain($"Domain{Index}", adevidence, info);

            return Instance;
        }

        public static void UnLoad(SecondDomain instance = null)
        {
            Instance = null;

            var domain = instance?.SecondAppDomain as AppDomain;
            if (domain == null)
                return;

            AppDomain.Unload(domain);
            instance.SecondAppDomain = null;
            Instance = null;
        }

        public void Dispose()
        {
            if (SecondAppDomain != null)
                UnLoad(this);
        }
        
    }
}
