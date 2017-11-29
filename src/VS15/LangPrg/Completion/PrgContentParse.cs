
using System;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
// using Microsoft.VisualStudio.Text.Operations;
using System.IO;
using System.Xml.Linq;
using System.Collections.Generic;

namespace VfpLanguage
{
    public class PrgContentParse : IDisposable
    {
        public ITextBuffer Buffer { get; set; }
        public IClassifier Classifier { get; set; }
        private bool _disposed = false;

        public XElement Files { get; set; }

        public PrgContentParse(string xmlFile)
        {
            _disposed = false;
            if (!string.IsNullOrWhiteSpace(xmlFile)
                && File.Exists(xmlFile))
                Files = XElement.Load(xmlFile);
        }

        public IEnumerable<string> ExtractPrg()
        {
            yield break;
        }

        public void Dispose()
        {
            _disposed = true;
        }
    }

}

// #if WCF

namespace VfpProj.Wcf
{
    using System.ServiceModel;
    using System.Runtime.Serialization;
    using System.Threading.Tasks;

    // C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.ServiceModel.dll
    // C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.Runtime.Serialization.dll
    // httpcfg set ssl -i 0.0.0.0:9001 -h b2fdd72d153ac0daa462ae26fe0902dfb7cfe670 -n LOCAL_MACHINE -c MY

    [ServiceContract]
    [ServiceKnownType(typeof(VfpService2))]
    public interface IVfpService2
    {
        [OperationContract]
        IVfpData Load(object obj);
    }

    public interface IVfpData
    {
        [DataMember]
        string Name { get; set; }
        [DataMember]
        string Directory { get; set; }

        [DataMember]
        string ActiveProject { get; set; }
        [DataMember]
        int? HWnd { get; set; }

        // no COM objects, just Serializables
        [DataMember]
        object VFP { get; set; }
    }

    // VfpProj.Wcf.VfpService
    [Serializable]
    public class VfpService2 : IVfpService2 // , IVfpService
    {
        IVfpData IVfpService2.Load(object obj)
        {
            return null;
        }

        object Load(object obj)
        {
            return null;
        }

        Task<object> LoadAsync(object obj) { return null; }
    }


    /*
       <system.serviceModel>
        <bindings>
          <basicHttpBinding>
            <binding name="BasicHttpBinding_IVfpService" />
          </basicHttpBinding>
        </bindings>
        <client>
          <endpoint address="http://localhost:9001/VfpService" binding="basicHttpBinding"
            bindingConfiguration="BasicHttpBinding_IVfpService" contract="VfpServiceRef.IVfpService"
            name="BasicHttpBinding_IVfpService" />
        </client> 
        <behaviors>
          <serviceBehaviors>
            <behavior name="MyServiceTypeBehaviors" >
              <serviceMetadata httpGetEnabled="true" />
            </behavior>
          </serviceBehaviors>
        </behaviors>
      </system.serviceModel>
    </configuration>
    */
}

// #endif