#include "SqlOpenRowset.h"


SqlOpenRowset::SqlOpenRowset()
{
}

SqlOpenRowset::~SqlOpenRowset()
{
}


HRESULT SqlOpenRowset::OpenRowset()
{
	HRESULT hr = 0x0;
	return hr;
}

/*
	IDBInitialize *pIDBInitialize = NULL;
	IDBCreateSession *pIDBCreateSession = NULL;
	IDBProperties *pIDBProperties = NULL;

	// Create the data source object.
	// __inline _Check_return_ HRESULT CoCreateInstance(

	hr = CoCreateInstance(CLSID_SQLNCLI10, NULL,
		CLSCTX_INPROC_SERVER,
		IID_IDBInitialize,
		(void**)&pIDBInitialize);

	hr = pIDBInitialize->QueryInterface(IID_IDBProperties, (void**)&pIDBProperties);

	// Set the MARS property.
	DBPROP rgPropMARS;

	// The following is necessary since MARS is off by default.
	rgPropMARS.dwPropertyID = SSPROP_INIT_MARSCONNECTION;
	rgPropMARS.dwOptions = DBPROPOPTIONS_REQUIRED;
	rgPropMARS.dwStatus = DBPROPSTATUS_OK;
	rgPropMARS.colid = DB_NULLID;
	V_VT(&(rgPropMARS.vValue)) = VT_BOOL;
	V_BOOL(&(rgPropMARS.vValue)) = VARIANT_TRUE;

	// Create the structure containing the properties.
	DBPROPSET PropSet;
	PropSet.rgProperties = &rgPropMARS;
	PropSet.cProperties = 1;
	PropSet.guidPropertySet = DBPROPSET_SQLSERVERDBINIT;

	// Get an IDBProperties pointer and set the initialization properties.
	pIDBProperties->SetProperties(1, &PropSet);
	pIDBProperties->Release();

	// Initialize the data source object.
	hr = pIDBInitialize->Initialize();

	//Create a session object from a data source object.
	IOpenRowset * pIOpenRowset = NULL;
	hr = IDBInitialize->QueryInterface(IID_IDBCreateSession, (void**)&pIDBCreateSession));

	hr = pIDBCreateSession->CreateSession(
		NULL,             // pUnkOuter
		IID_IOpenRowset,  // riid
		&pIOpenRowset));  // ppSession

	// Create a rowset with a firehose mode cursor.
	IRowset *pIRowset = NULL;
	DBPROP rgRowsetProperties[2];

	// To get a firehose mode cursor request a 
	// forward only read only rowset.
	rgRowsetProperties[0].dwPropertyID = DBPROP_IRowsetLocate;
	rgRowsetProperties[0].dwOptions = DBPROPOPTIONS_REQUIRED;
	rgRowsetProperties[0].dwStatus = DBPROPSTATUS_OK;
	rgRowsetProperties[0].colid = DB_NULLID;
	VariantInit(&(rgRowsetProperties[0].vValue));
	rgRowsetProperties[0].vValue.vt = VARIANT_BOOL;
	rgRowsetProperties[0].vValue.boolVal = VARIANT_FALSE;

	rgRowsetProperties[1].dwPropertyID = DBPROP_IRowsetChange;
	rgRowsetProperties[1].dwOptions = DBPROPOPTIONS_REQUIRED;
	rgRowsetProperties[1].dwStatus = DBPROPSTATUS_OK;
	rgRowsetProperties[1].colid = DB_NULLID;
	VariantInit(&(rgRowsetProperties[1].vValue));
	rgRowsetProperties[1].vValue.vt = VARIANT_BOOL;
	rgRowsetProperties[1].vValue.boolVal = VARIANT_FALSE;

	DBPROPSET rgRowsetPropSet[1];
	rgRowsetPropSet[0].rgProperties = rgRowsetProperties
		rgRowsetPropSet[0].cProperties = 2
		rgRowsetPropSet[0].guidPropertySet = DBPROPSET_ROWSET;

	hr = pIOpenRowset->OpenRowset(NULL,
		&TableID,
		NULL,
		IID_IRowset,
		1,
		rgRowsetPropSet
		(IUnknown**)&pIRowset);

}

*/