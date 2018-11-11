using Newtonsoft.Json;
using System.Dynamic;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.Text;
using System.Xml;

namespace VfpProj.Wcf
{
    //https://cgeers.wordpress.com/2011/09/04/replacing-the-you-have-created-a-service-message/
    // <binding name = "landingPage" >
    //  < textMessageEncoding messageVersion="None"/>
    //  <httpTransport/>
    //</binding>

    public class LandingPageMessage : Message
    {
        public static ServiceHost FixHost(ServiceHost host)
        {
            host.Description.Behaviors.Remove<ServiceDebugBehavior>();

            /*
            ServiceMetadataBehavior mex = host.Description.Behaviors.Find<ServiceMetadataBehavior>();
            if (mex == null)
            {
                mex = new ServiceMetadataBehavior();
                mex.HttpGetEnabled = true;
                mex.HttpsGetEnabled = false;
                mex.MetadataExporter.PolicyVersion = PolicyVersion.Policy15;

                host.Description.Behaviors.Add(mex);
            }
            //  mex.HttpGetEnabled = true;
            host = VfpServiceBehavior.Set(host);
            */

            return host;
        }

        private readonly MessageHeaders _headers;
        private readonly MessageProperties _properties;

        public LandingPageMessage() : base()
        {
            this._headers = new MessageHeaders(MessageVersion.None);
            this._properties = new MessageProperties();
        }


        public override MessageHeaders Headers {
            get { return this._headers; }
        }

        public override MessageProperties Properties {
            get { return this._properties; }
        }

        public override MessageVersion Version {
            get { return this._headers.MessageVersion; }
        }

        public ExpandoObject Data { get; set; }

        protected override void OnWriteBodyContents(XmlDictionaryWriter writer)
        {
            writer.WriteStartElement("html");
            writer.WriteStartElement("head");
            writer.WriteStartElement("body");

            if (Data == null) {
                writer.WriteRaw("<h3>VfpService</h3>");
                writer.WriteStartElement("span");
                writer.WriteString("WCF service is running.");
                writer.WriteEndElement();
            }

            if (Data != null) {
                var json = JsonConvert.SerializeObject(Data,
                    new JsonSerializerSettings { MaxDepth = 5 });

                var html = json; // !
                writer.WriteStartElement("span");
                //  writer.WriteString("Data:");
                writer.WriteRaw("<br/>");

                writer.WriteStartElement("pre");
                writer.WriteStartElement("code");
                writer.WriteRaw("<br/>");

                var xmlEn = new StringBuilder();
                xmlEn.Append(html); // System.Net.WebUtility.HtmlEncode(html);
                xmlEn.Replace("}", "}\n");
                xmlEn.Replace("[", "\n[");
                xmlEn.Replace("\",", "\",\n");
                json = xmlEn.ToString();

                writer.WriteRaw(xmlEn.ToString());

                writer.WriteRaw("<br/>");
                writer.WriteEndElement();
                writer.WriteEndElement();

                writer.WriteEndElement();
            }

            writer.WriteEndElement();
            writer.WriteEndElement();
            writer.WriteEndElement();
        }
    }
}


/*
 * 
 * <endpoint address="" 
            binding="customBinding" 
            bindingConfiguration="landingPage" 
            contract="WcfServiceLibrary.ILandingPage"/>
  <host>
    <baseAddresses>
      <add baseAddress="http://localhost:8732/Service"/>
    </baseAddresses>
  </host>
</service>
As you can see the new endpoint uses a custom binding, which is declared as follows:

<bindings>
  <customBinding>
    <binding name="landingPage">
      <textMessageEncoding messageVersion="None"/>
      <httpTransport/>
    </binding>
  </customBinding>
</bindings>

*/
