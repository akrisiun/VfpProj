using System;
using System.ServiceModel;
using System.Runtime.Serialization;
using System.ServiceModel.Web;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Collections.Generic;
using System.ServiceModel.Channels;

namespace VfpProj.Wcf
{
    // bindingConfiguration="BasicHttpBinding_IVfpService" contract="VfpProj.Wcf.IVfpService" name="BasicHttpBinding_IVfpService" />
    // VfpProj.Wcf.IVfpService
    // httpcfg set ssl -i 0.0.0.0:8080 -h b2fdd72d153ac0daa462ae26fe0902dfb7cfe670 -n LOCAL_MACHINE -c MY

    #region Interfaces

    [ServiceContract]
    [ServiceKnownType(typeof(VfpService))]
    [ServiceKnownType(typeof(CsObj))]
    [ServiceKnownType(typeof(CsForm))]
    public interface IVfpService
    {
        [OperationContract] IVfpData Load(object obj);
        [OperationContract] IList<KeyValuePair<string, object>> Eval(object obj);

        [OperationContract] IVfpData DoCmd(string cmd, params object[] parm);
        [OperationContract] IVfpData DoCompile(string file);
    }

    [ServiceContract]
    [ServiceKnownType(typeof(VfpIndex))]
    public interface IVfpIndex
    {
        [OperationContract(Action = "*", ReplyAction = "*")]
        Message Index();
    }

    public interface IVfpData
    {
        [DataMember] string Name { get; set; }
        [DataMember] string StatusBar { get; set; }
        [DataMember] string Directory { get; set; }
        [DataMember] int? HWnd { get; set; }
        [DataMember] string ActiveProject { get; set; }

        // non COM object!!
        [DataMember] IList<KeyValuePair<string, object>> VFP { get; set; }
    }

    #endregion

    [Serializable]
    [DataContract]
    public class VfpIndex : IVfpIndex
    {
        // [OperationContract(Action = "*", ReplyAction = "*")]
        public Message Index()
        {
            var context = WebOperationContext.Current;
            context.OutgoingResponse.ContentType = "text/html";
            var to = OperationContext.Current.RequestContext.RequestMessage.Headers.To;

            return new LandingPageMessage();
        }
    }

    [Serializable]
    [DataContract] // no [ServiceContract]
    public class VfpService : IVfpService, IVfpData, IDisposable
    {
        public static VfpService Instance; // { get; set; }
        static VfpService() { Instance = Instance ?? new VfpService(); }

        [DataMember] public string Name { [DebuggerStepThrough] get; set; }
        [DataMember] public string StatusBar { [DebuggerStepThrough] get; set; }
        [DataMember] public string Directory { [DebuggerStepThrough] get; set; }

        [DataMember] public int? HWnd { get; set; }
        [DataMember] public string ActiveProject { [DebuggerStepThrough] get; set; }
        [DataMember] public IList<KeyValuePair<string, object>> VFP { [DebuggerStepThrough] get; set; }

        public VfpService()
        {
            Instance = this;
        }

        public static Exception VfpError { [DebuggerStepThrough] get; set; }

        public IList<KeyValuePair<string, object>> Eval(object obj)
        {
            if (Debugger.IsAttached)
                Debugger.Break();

            var result = new List<KeyValuePair<string, object>>();

            return result;
        }

        public IVfpData DoCmd(string cmd, params object[] parm)
        {
            VfpError = null;
            IVfpData result = null;
            StatusBar = null;
            try
            {
                var app = FoxCmd.App;
                var list = cmd.Split(new char[] { ';' });
                if (list.Length > 0)
                {
                    foreach (string item in list)
                        app.DoCmd(item);
                }
                else
                    app.DoCmd(cmd);

                result = Host.UpdateValues(this, app);
            }
            catch (Exception ex)
            {
                VfpError = ex;
                StatusBar = StatusBar ?? ex.Message;
            }
            return result;
        }

        public IVfpData DoCompile(string file)
        {
            VfpError = null;
            IVfpData result = null;
            try
            {
                var app = FoxCmd.App;

                app.DoCmd("ON ERROR _VFP.StatusBar = MESSAGE()");
                app.DoCmd("COMPILE " + file);

                StatusBar = app.Eval("_VFP.StatusBar");
                result = Host.UpdateValues(this, app);
            }
            catch (Exception ex) { VfpError = ex; }
            return result;
        }

        // no [OperationContract]
        public IVfpData Load(object obj)
        {
            if (Debugger.IsAttached)
                Debugger.Break();

            var context = OperationContext.Current;

            Console.WriteLine("WCF: Load");
            if (obj != null)
                Console.WriteLine(obj.ToString());

            VfpError = null;
            try
            {
                var app = FoxCmd.App;
                if (app != null)
                    Host.UpdateValues(this, app);
            }
            catch (Exception ex) { VfpError = ex; }

            return this as IVfpData;
        }

        public void Bind()
        {
            if (Host.Object != null)
                return;

            Task.Factory.StartNew(() => Host.Create());
        }

        public void Dispose()
        {
            VfpError = null;
            VFP = null;
        }
    }

}

/*
 
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
        <identity><!—this value will be different on your machine –!>                          <userPrincipalName value="PRAVEEN-WIN7\BriskTech"/>             
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
