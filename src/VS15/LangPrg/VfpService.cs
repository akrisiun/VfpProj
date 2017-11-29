
namespace VfpProj.Wcf
{
    using System.Runtime.Serialization;
    using System;

    [System.CodeDom.Compiler.GeneratedCode("System.Runtime.Serialization", "4.0.0.0")]
    [DataContract(Name = "VfpService", Namespace = "http://schemas.datacontract.org/2004/07/VfpProj.Wcf")]
    [System.SerializableAttribute]
    [System.Runtime.Serialization.KnownType(typeof(CsObj))]
    [KnownType(typeof(CsForm))]
    [KnownType(typeof(System.IntPtr))]
    [KnownType(typeof(System.Exception))]
    public partial class VfpService : object, IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged
    {

        [System.NonSerializedAttribute]
        private ExtensionDataObject extensionDataField;

        [OptionalFieldAttribute]
        private string ActiveProjectField;

        [OptionalFieldAttribute]
        private string DirectoryField;

        [OptionalFieldAttribute]
        private System.Nullable<int> HWndField;

        [OptionalField]
        private string NameField;

        [OptionalField]
        private object VFPField;

        [global::System.ComponentModel.Browsable(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }

        [DataMember]
        public string ActiveProject {
            get {
                return this.ActiveProjectField;
            }
            set {
                if ((object.ReferenceEquals(this.ActiveProjectField, value) != true))
                {
                    this.ActiveProjectField = value;
                    this.RaisePropertyChanged("ActiveProject");
                }
            }
        }

        [DataMember]
        public string Directory {
            get {
                return this.DirectoryField;
            }
            set {
                if ((object.ReferenceEquals(this.DirectoryField, value) != true))
                {
                    this.DirectoryField = value;
                    this.RaisePropertyChanged("Directory");
                }
            }
        }

        [DataMember]
        public System.Nullable<int> HWnd {
            get {
                return this.HWndField;
            }
            set {
                if ((this.HWndField.Equals(value) != true))
                {
                    this.HWndField = value;
                    this.RaisePropertyChanged("HWnd");
                }
            }
        }

        [DataMember]
        public string Name {
            get {
                return this.NameField;
            }
            set {
                if ((object.ReferenceEquals(this.NameField, value) != true))
                {
                    this.NameField = value;
                    this.RaisePropertyChanged("Name");
                }
            }
        }

        [DataMember]
        public object VFP {
            get {
                return this.VFPField;
            }
            set {
                if ((object.ReferenceEquals(this.VFPField, value) != true))
                {
                    this.VFPField = value;
                    this.RaisePropertyChanged("VFP");
                }
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    [System.Diagnostics.DebuggerStepThrough]
    [System.CodeDom.Compiler.GeneratedCode("System.Runtime.Serialization", "4.0.0.0")]
    [DataContract(Name = "CsObj", Namespace = "http://schemas.datacontract.org/2004/07/VfpProj")]
    [System.Serializable]
    [KnownType(typeof(VfpService))]
    [KnownType(typeof(CsForm))]
    [KnownType(typeof(System.IntPtr))]
    [KnownType(typeof(System.Exception))]
    public partial class CsObj : object, IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged
    {

        [System.NonSerialized]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;

        [OptionalField]
        private object CmdFormField;

        [OptionalField]
        private string NameField;

        [OptionalField]
        private System.IntPtr hWndField;

        [global::System.ComponentModel.Browsable(false)]
        public ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }

        [DataMember]
        public object CmdForm {
            get {
                return this.CmdFormField;
            }
            set {
                if ((object.ReferenceEquals(this.CmdFormField, value) != true))
                {
                    this.CmdFormField = value;
                    this.RaisePropertyChanged("CmdForm");
                }
            }
        }

        [DataMember]
        public string Name {
            get {
                return this.NameField;
            }
            set {
                if ((object.ReferenceEquals(this.NameField, value) != true))
                {
                    this.NameField = value;
                    this.RaisePropertyChanged("Name");
                }
            }
        }

        [DataMember]
        public System.IntPtr hWnd {
            get {
                return this.hWndField;
            }
            set {
                if ((this.hWndField.Equals(value) != true))
                {
                    this.hWndField = value;
                    this.RaisePropertyChanged("hWnd");
                }
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    [System.Diagnostics.DebuggerStepThrough]
    [System.CodeDom.Compiler.GeneratedCode("System.Runtime.Serialization", "4.0.0.0")]
    [DataContract(Name = "CsForm", Namespace = "http://schemas.datacontract.org/2004/07/VfpProj")]
    [System.Serializable]
    public partial class CsForm : object, IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged
    {

        [System.NonSerialized]
        private ExtensionDataObject extensionDataField;

        [OptionalField]
        private System.Exception LastErrorField;

        [global::System.ComponentModel.Browsable(false)]
        public ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }

        [DataMember]
        public System.Exception LastError {
            get {
                return this.LastErrorField;
            }
            set {
                if ((object.ReferenceEquals(this.LastErrorField, value) != true))
                {
                    this.LastErrorField = value;
                    this.RaisePropertyChanged("LastError");
                }
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IVfpServiceChannel : VfpLanguage.VfpServiceRef.IVfpService, System.ServiceModel.IClientChannel
    {
    }


    [System.ServiceModel.ServiceContractAttribute(ConfigurationName = "VfpServiceRef.IVfpService")]
    public interface IVfpService
    {

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/Load", ReplyAction = "http://tempuri.org/IVfpService/LoadResponse")]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.IntPtr))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Exception))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.VfpService))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>[]))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsObj))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsForm))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(object[]))]
        object Load(object obj);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/Load", ReplyAction = "http://tempuri.org/IVfpService/LoadResponse")]
        System.Threading.Tasks.Task<object> LoadAsync(object obj);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/Eval", ReplyAction = "http://tempuri.org/IVfpService/EvalResponse")]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.IntPtr))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Exception))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.VfpService))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>[]))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsObj))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsForm))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(object[]))]
        System.Collections.Generic.KeyValuePair<string, object>[] Eval(object obj);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/Eval", ReplyAction = "http://tempuri.org/IVfpService/EvalResponse")]
        System.Threading.Tasks.Task<System.Collections.Generic.KeyValuePair<string, object>[]> EvalAsync(object obj);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/DoCmd", ReplyAction = "http://tempuri.org/IVfpService/DoCmdResponse")]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.IntPtr))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Exception))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.VfpService))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>[]))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsObj))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsForm))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(object[]))]
        object DoCmd(string cmd, object[] parm);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/DoCmd", ReplyAction = "http://tempuri.org/IVfpService/DoCmdResponse")]
        System.Threading.Tasks.Task<object> DoCmdAsync(string cmd, object[] parm);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/DoCompile", ReplyAction = "http://tempuri.org/IVfpService/DoCompileResponse")]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.IntPtr))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Exception))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.VfpService))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>[]))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(System.Collections.Generic.KeyValuePair<string, object>))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsObj))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(VfpLanguage.VfpServiceRef.CsForm))]
        [System.ServiceModel.ServiceKnownTypeAttribute(typeof(object[]))]
        object DoCompile(string file);

        [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IVfpService/DoCompile", ReplyAction = "http://tempuri.org/IVfpService/DoCompileResponse")]
        System.Threading.Tasks.Task<object> DoCompileAsync(string file);
    }

    

    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class VfpServiceClient : System.ServiceModel.ClientBase<VfpLanguage.VfpServiceRef.IVfpService>, VfpLanguage.VfpServiceRef.IVfpService
    {

        public VfpServiceClient()
        {
        }

        public VfpServiceClient(string endpointConfigurationName) :
                base(endpointConfigurationName)
        {
        }

        public VfpServiceClient(string endpointConfigurationName, string remoteAddress) :
                base(endpointConfigurationName, remoteAddress)
        {
        }

        public VfpServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) :
                base(endpointConfigurationName, remoteAddress)
        {
        }

        public VfpServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) :
                base(binding, remoteAddress)
        {
        }

        public object Load(object obj)
        {
            return base.Channel.Load(obj);
        }

        public System.Threading.Tasks.Task<object> LoadAsync(object obj)
        {
            return base.Channel.LoadAsync(obj);
        }

        public System.Collections.Generic.KeyValuePair<string, object>[] Eval(object obj)
        {
            return base.Channel.Eval(obj);
        }

        public System.Threading.Tasks.Task<System.Collections.Generic.KeyValuePair<string, object>[]> EvalAsync(object obj)
        {
            return base.Channel.EvalAsync(obj);
        }

        public object DoCmd(string cmd, object[] parm)
        {
            return base.Channel.DoCmd(cmd, parm);
        }

        public System.Threading.Tasks.Task<object> DoCmdAsync(string cmd, object[] parm)
        {
            return base.Channel.DoCmdAsync(cmd, parm);
        }

        public object DoCompile(string file)
        {
            return base.Channel.DoCompile(file);
        }

        public System.Threading.Tasks.Task<object> DoCompileAsync(string file)
        {
            return base.Channel.DoCompileAsync(file);
        }
    }
}

