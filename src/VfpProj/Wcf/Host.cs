using System;
using System.ServiceModel;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.ServiceModel.Description;

namespace VfpProj.Wcf
{
    public static class Host
    {
        public static IVfpData UpdateValues(IVfpData obj, VisualFoxpro.FoxApplication app)
        {
            obj.StatusBar = app.StatusBar;
            obj.Directory = app.DefaultFilePath;
            obj.HWnd = app.hWnd;
            obj.Name = app.Name;
            obj.ActiveProject = null;
            try { obj.ActiveProject = app.ActiveProject == null ? "" : app.ActiveProject.Name; }
            catch { }

            return obj;
        }

        public static ICommunicationObject Object { get; set; }

        static bool ValidateCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        public static void Create()
        {
            ServiceHost svcHost = null;
            System.Net.ServicePointManager.ServerCertificateValidationCallback += new
                RemoteCertificateValidationCallback(ValidateCertificate);

            try
            {
                var serviceUri = new Uri("http://localhost:9001/VfpService");
                svcHost = new ServiceHost(typeof(VfpService), serviceUri);

                svcHost = LandingPageMessage.FixHost(svcHost);

                Object = svcHost;
                svcHost.Open();
                Console.WriteLine("\n" + serviceUri.ToString());

                var serviceUri2 = new Uri("http://localhost:9001/VfpIndex");
                var host2 = new ServiceHost(typeof(VfpIndex), serviceUri2);
                host2 = LandingPageMessage.FixHost(host2);
                host2.Open();

                Console.WriteLine("\n" + serviceUri2.ToString());
            }
            catch (Exception eX)
            {
                svcHost = null;
                // HTTP could not register URL http://+:9001/VfpService/. 
                // Your process does not have access rights to this namespace (see http://go.microsoft.com/fwlink/?LinkId=70353 for details).
                // netsh http add urlacl url=http://+:9001/VfpService/
                // netsh http add urlacl url=http://+:9001/VfpService/ user=DOMAIN\user  
                // The ChannelDispatcher at 'http://localhost:9001/VfpService' with contract(s) '"IVfpService"' is unable to open its IChannelListener.
                // The ChannelDispatcher at is unable to open its IChannelListener.
                System.Windows.Forms.MessageBox.Show("Service can not be started \n\nError Message [" + eX.Message + "]");
                Object = null;
            }
        }
    }
}

/*
 * 
      <endpoint
          address=""
          binding="customBinding" bindingConfiguration="BasicHttpBinding_IVfpService"
          contract="VfpProj.Wcf.IVfpService" />
        <host>
          <baseAddresses>
            <add baseAddress="http://localhost:9001/VfpService" />
          </baseAddresses>
        </host>

 
<system.serviceModel>             
    <bindings>             
      <basicHttpBinding>             
        <binding name="BasicHttpBinding_IMyMathService"/>             
      </basicHttpBinding>             
    </bindings>             
    <client>             
      <endpoint address="http://localhost:9001/MyMathService&quot; binding="basicHttpBinding" 
                bindingConfiguration="BasicHttpBinding_IMyMathService" contract="VfpProj.Wcf.IMyMathService" name="BasicHttpBinding_IMyMathService"/>             

    <endpoint address="net.tcp://localhost:9002/MyMathService" binding="netTcpBinding" 
        bindingConfiguration="NetTcpBinding_IMyMathService" contract="VfpProj.Wcf.IMyMathService" name="NetTcpBinding_IMyMathService">             
        <identity><!—this value will be different on your machine –!>              
            <userPrincipalName value="PRAVEEN-WIN7\BriskTech"/>             
        </identity>             
      </endpoint>             
    </client>             
</system.serviceModel>

<netTcpBinding>             
<binding name="NetTcpBinding_IMyMathService"/>             
</netTcpBinding>             

    Uri serviceUri = new Uri("https://" + Dns.GetHostEntry("localhost").HostName + ":8080/TestService");
TestService s = new TestService();
ServiceHost h = new ServiceHost(s, serviceUri);


  BasicHttpBinding binding = new BasicHttpBinding(BasicHttpSecurityMode.Transport);
  h.AddServiceEndpoint(typeof(IService), binding, serviceUri);

  ServiceMetadataBehavior mex = h.Description.Behaviors.Find<ServiceMetadataBehavior>();

if (mex == null)
{
    mex = new ServiceMetadataBehavior();
    //mex.HttpGetEnabled = true;
    mex.HttpsGetEnabled = true;
    h.Description.Behaviors.Add(mex);
}

//set the service cert...
h.Credentials.ServiceCertificate.SetCertificate(
    StoreLocation.LocalMachine,
      StoreName.My,
      X509FindType.FindBySerialNumber,
      "6B8F3E0E000000000040");

h.AddServiceEndpoint(typeof(IMetadataExchange), binding, "MEX");

h.Open();
Console.WriteLine("Service Hosted");
Console.ReadLine();
h.Close();

 */
