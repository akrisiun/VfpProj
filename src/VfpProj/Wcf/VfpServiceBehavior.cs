using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.Xml;

namespace VfpProj.Wcf
{
    public class VfpServiceBehavior
    {
        // Note that the httpGetEnabled is set to true

        public static IVfpService CreateWebService(bool selfHosted)
        {
            var address = "http://localhost:9001/VfpService";
            BasicHttpBinding binding = new BasicHttpBinding();

            //  var binding = new CustomBinding();

            binding.Name = "BasicHttpBinding_IVfpService";
            if (Debugger.IsAttached)
            {
                binding.ReceiveTimeout = TimeSpan.FromSeconds(500);
                binding.OpenTimeout = TimeSpan.FromSeconds(300);
                binding.SendTimeout = TimeSpan.FromSeconds(500);
            }
            else
            {
                binding.ReceiveTimeout = TimeSpan.FromSeconds(5);
                binding.OpenTimeout = TimeSpan.FromSeconds(3);
                binding.SendTimeout = TimeSpan.FromSeconds(5);
            }

            var elems = binding.CreateBindingElements();
            //var elem = new HttpTransportBindingElement();
            //if (binding.Elements.Count == 0)
            //    var enc = new TextMessageEncodingBindingElement() { MessageVersion = MessageVersion.Soap12 }; 
            // content type 'application/soap+xml; charset=utf-8' was not the expected type 'application/xml; charset=utf-8'..

            var channelFactory = new ChannelFactory<IVfpService>(binding, address);

            var proxy = channelFactory.CreateChannel();
            return proxy;
        }

        public static ServiceHost Set(ServiceHost host)
        {
            //foreach (ServiceEndpoint endpoint in host.Description.Endpoints)
            //    SetDataContractSerializerBehavior(endpoint.Contract);
            return host;
        }

        static void SetDataContractSerializerBehavior(ContractDescription contractDescription)
        {
            foreach (OperationDescription operation in contractDescription.Operations)
            {

                operation.Behaviors.Add(new ReferencePreservingDataContractSerializerOperationBehavior(operation));

            }

        }

    }

    // https://blogs.msdn.microsoft.com/sowmy/2006/03/26/preserving-object-reference-in-wcf/#comments
    class ReferencePreservingDataContractSerializerOperationBehavior : DataContractSerializerOperationBehavior
    {

        public ReferencePreservingDataContractSerializerOperationBehavior(OperationDescription operationDescription)
               : base(operationDescription)
        {
            if (Debugger.IsAttached)
                Debugger.Break();
        }

        public override XmlObjectSerializer CreateSerializer(Type type, string name, string ns, IList<Type> knownTypes)
        {
            return CreateDataContractSerializer(type, name, ns, knownTypes);

        }

        private static XmlObjectSerializer CreateDataContractSerializer(
                Type type, string name, string ns, IList<Type> knownTypes)

        {
            return CreateDataContractSerializer(type, name, ns, knownTypes);
        }

        public override XmlObjectSerializer CreateSerializer(Type type, XmlDictionaryString name, XmlDictionaryString ns,
                    IList<Type> knownTypes)
        {
            return new DataContractSerializer(type, name, ns, knownTypes,
                0x7FFF /*maxItemsInObjectGraph*/,
                false/*ignoreExtensionDataObject*/,
                true/*preserveObjectReferences*/,
                null/*dataContractSurrogate*/
                );

        }

    }

}