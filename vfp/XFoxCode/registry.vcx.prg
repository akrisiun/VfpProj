* d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx
**************************************************
*-- Class Library:  d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx
**************************************************


**************************************************
*-- Class:        filereg (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- ParentClass:  registry (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- BaseClass:    custom
*
#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\registry.h"
*
DEFINE CLASS filereg AS registry

  Name = "filereg"

  
  PROCEDURE getapplication
    LPARAMETERS cExtnKey,cAppKey,lServer
    
    LOCAL nErrNum,cOptName
    cOptName = ""
    
    * lServer - checking for OLE server.
    IF TYPE("m.lServer") = "L" AND m.lServer
    	THIS.cAppPathKey = OLE_PATH_KEY
    ELSE	
    	THIS.cAppPathKey = APP_PATH_KEY
    ENDIF
    
    * Open extension app key
    m.nErrNum = THIS.OpenKey(m.cExtnKey+THIS.cAppPathKey)
    IF m.nErrNum  # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Get application path
    nErrNum = THIS.GetKeyValue(cOptName,@cAppKey)
    
    * Close application path key
    THIS.CloseKey()
    
    RETURN m.nErrNum
    
  ENDPROC
  
  PROCEDURE getapppath
    * Checks and returns path of application
    * associated with a particular extension (e.g., XLS, DOC). 
    LPARAMETER cExtension,cExtnKey,cAppKey,lServer
    LOCAL nErrNum,cOptName
    cOptName = ""
    
    * Check Extension parameter
    IF TYPE("m.cExtension") # "C" OR LEN(m.cExtension) > 3
    	RETURN ERROR_BADPARM
    ENDIF
    m.cExtension = "."+m.cExtension
    
    * Open extension key
    nErrNum = THIS.OpenKey(m.cExtension)
    IF m.nErrNum  # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Get key value for file extension
    nErrNum = THIS.GetKeyValue(cOptName,@cExtnKey)
    
    * Close extension key
    THIS.CloseKey()
    
    IF m.nErrNum  # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    RETURN THIS.GetApplication(cExtnKey,@cAppKey,lServer)
    
  ENDPROC
  
  PROCEDURE getlatestversion
    LPARAMETER cClass,cExtnKey,cAppKey,lServer
    
    LOCAL nErrNum,cOptName
    cOptName = ""
    
    * Open class key (e.g., Excel.Sheet)
    nErrNum = THIS.OpenKey(m.cClass+CURVER_KEY)
    IF m.nErrNum  # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Get key value for file extension
    nErrNum = THIS.GetKeyValue(cOptName,@cExtnKey)
    
    * Close extension key
    THIS.CloseKey()
    
    IF m.nErrNum  # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    RETURN THIS.GetApplication(cExtnKey,@cAppKey,lServer)
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: filereg
**************************************************



**************************************************
*-- Class:        foxreg (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- ParentClass:  registry (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- BaseClass:    custom
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\registry.h"
*
DEFINE CLASS foxreg AS registry

  Name = "foxreg"

  
  PROCEDURE enumfoxoptions
    LPARAMETER aFoxOpts
    RETURN THIS.EnumOptions(@aFoxOpts,THIS.cVFPOptPath,THIS.nUserKey,.F.)
    
  ENDPROC
  
  PROCEDURE getfoxoption
    LPARAMETER cOptName,cOptVal
    RETURN THIS.GetRegKey(cOptName,@cOptVal,THIS.cVFPOptPath,THIS.nUserKey)
    
  ENDPROC
  
  PROCEDURE setfoxoption
    LPARAMETER cOptName,cOptVal
    RETURN THIS.SetRegKey(cOptName,cOptVal,THIS.cVFPOptPath,THIS.nUserKey)
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: foxreg
**************************************************



**************************************************
*-- Class:        odbcreg (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- ParentClass:  registry (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- BaseClass:    custom
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\registry.h"
*
DEFINE CLASS odbcreg AS registry

  Name = "odbcreg"

  
  PROCEDURE enumodbcdata
    LPARAMETER aDrvrOpts,cDataSource
    LOCAL cSourceKey
    cSourceKey = ODBC_DATA_KEY+cDataSource
    RETURN THIS.EnumOptions(@aDrvrOpts,m.cSourceKey,HKEY_CURRENT_USER,.F.)
    
  ENDPROC
  
  PROCEDURE enumodbcdrvrs
    LPARAMETER aDrvrOpts,cODBCDriver
    LOCAL cSourceKey
    cSourceKey = ODBC_DRVRS_KEY+m.cODBCDriver
    RETURN THIS.EnumOptions(@aDrvrOpts,m.cSourceKey,HKEY_LOCAL_MACHINE,.F.)
    
  ENDPROC
  
  PROCEDURE getodbcdrvrs
    LPARAMETERS aDrvrs,lDataSources
    LOCAL nODBCEnv,nRetVal,dsn,dsndesc,mdsn,mdesc
    
    lDataSources = IIF(TYPE("m.lDataSources")="L",m.lDataSources,.F.)
    
    * Load API functions
    nRetVal = THIS.LoadODBCFuncs()
    IF m.nRetVal # ERROR_SUCCESS
    	RETURN m.nRetVal
    ENDIF
    
    * Get ODBC environment handle
    nODBCEnv=VAL(SYS(3053))
    
    * -- Possible error messages
    * 527 "cannot load odbc library"
    * 528 "odbc entry point missing"
    * 182 "not enough memory"
    
    IF INLIST(nODBCEnv,527,528,182)
    	* Failed
    	RETURN ERROR_ODBCFAIL
    ENDIF
    
    DIMENSION aDrvrs[1,IIF(m.lDataSources,2,1)]
    aDrvrs[1] = ""
    
    DO WHILE .T.
    	dsn=space(100)
    	dsndesc=space(100)
    	mdsn=0
    	mdesc=0
    
    	* Return drivers or data sources
    	IF m.lDataSources
    		nRetVal = SQLDataSources(m.nODBCEnv,SQL_FETCH_NEXT,@dsn,100,@mdsn,@dsndesc,255,@mdesc)
    	ELSE
    		nRetVal = SQLDrivers(m.nODBCEnv,SQL_FETCH_NEXT,@dsn,100,@mdsn,@dsndesc,100,@mdesc)
    	ENDIF
    		
    	DO CASE
    		CASE m.nRetVal = SQL_NO_DATA
    			nRetVal = ERROR_SUCCESS
    			EXIT
    		CASE m.nRetVal # ERROR_SUCCESS AND m.nRetVal # 1 
    			EXIT
    		OTHERWISE
    			IF !EMPTY(aDrvrs[1])
    				IF m.lDataSources
    					DIMENSION aDrvrs[ALEN(aDrvrs,1)+1,2]
    				ELSE
    					DIMENSION aDrvrs[ALEN(aDrvrs,1)+1,1]
    				ENDIF
    			ENDIF
    			dsn = ALLTRIM(m.dsn)
    			aDrvrs[ALEN(aDrvrs,1),1] = LEFT(m.dsn,LEN(m.dsn)-1)
    			IF m.lDataSources
    				dsndesc = ALLTRIM(m.dsndesc)				
    				aDrvrs[ALEN(aDrvrs,1),2] = LEFT(m.dsndesc,LEN(m.dsndesc)-1)			
    			ENDIF
    	ENDCASE
    ENDDO
    RETURN nRetVal
    
  ENDPROC
  
  PROCEDURE loadodbcfuncs
    IF THIS.lLoadedODBCs
    	RETURN ERROR_SUCCESS
    ENDIF
    
    * Check API file containing functions
    
    IF EMPTY(THIS.cODBCDLLFile)
    	RETURN ERROR_NOODBCFILE
    ENDIF
    
    LOCAL henv,fDirection,szDriverDesc,cbDriverDescMax
    LOCAL pcbDriverDesc,szDriverAttributes,cbDrvrAttrMax,pcbDrvrAttr
    LOCAL szDSN,cbDSNMax,pcbDSN,szDescription,cbDescriptionMax,pcbDescription
    
    DECLARE Short SQLDrivers IN (THIS.cODBCDLLFile) ;
    	Integer henv, Integer fDirection, ;
    	String @ szDriverDesc, Integer cbDriverDescMax, Integer pcbDriverDesc, ;
    	String @ szDriverAttributes, Integer cbDrvrAttrMax, Integer pcbDrvrAttr
    
    IF THIS.lhaderror && error loading library
    	RETURN -1
    ENDIF
    
    DECLARE Short SQLDataSources IN (THIS.cODBCDLLFile) ;
    	Integer henv, Integer fDirection, ;
    	String @ szDSN, Integer cbDSNMax, Integer @ pcbDSN, ;
    	String @ szDescription, Integer cbDescriptionMax,Integer pcbDescription
    
    THIS.lLoadedODBCs = .T.
    
    RETURN ERROR_SUCCESS
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: odbcreg
**************************************************



**************************************************
*-- Class:        oldinireg (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- ParentClass:  registry (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- BaseClass:    custom
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\registry.h"
*
DEFINE CLASS oldinireg AS registry

  Name = "oldinireg"

  
  PROCEDURE getinientry
    LPARAMETER cValue,cSection,cEntry,cINIFile
    
    * Get entry from INI file 
    LOCAL cBuffer,nBufSize,nErrNum,nTotParms
    nTotParms = PCOUNT()
    
    * Load API functions
    nErrNum= THIS.LoadINIFuncs()
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Parameter checks here
    IF m.nTotParms < 3
    	m.cEntry = 0
    ENDIF
    
    m.cBuffer=space(2000)
    
    IF EMPTY(m.cINIFile)
    	* WIN.INI file
    	m.nBufSize = GetWinINI(m.cSection,m.cEntry,"",@cBuffer,LEN(m.cBuffer))
    ELSE
    	* Private INI file
    	m.nBufSize = GetPrivateINI(m.cSection,m.cEntry,"",@cBuffer,LEN(m.cBuffer),m.cINIFile)
    ENDIF
    
    IF m.nBufSize = 0 &&could not find entry in INI file
    	RETURN ERROR_NOINIENTRY
    ENDIF
    
    m.cValue=LEFT(m.cBuffer,m.nBufSize)
    
    ** All is well
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE getinisection
    LPARAMETERS aSections,cSection,cINIFile
    LOCAL cINIValue, nTotEntries, i, nLastPos
    cINIValue = ""
    IF TYPE("m.cINIFile") # "C"
    	cINIFile = ""
    ENDIF
    
    IF THIS.GetINIEntry(@cINIValue,cSection,0,m.cINIFile) # ERROR_SUCCESS
    	RETURN ERROR_FAILINI
    ENDIF
    
    nTotEntries=OCCURS(CHR(0),m.cINIValue)
    DIMENSION aSections[m.nTotEntries]
    nLastPos = 1
    FOR i = 1 TO m.nTotEntries
    	nTmpPos = AT(CHR(0),m.cINIValue,m.i)
    	aSections[m.i] = SUBSTR(m.cINIValue,m.nLastPos,m.nTmpPos-m.nLastPos)
    	nLastPos = m.nTmpPos+1
    ENDFOR
    
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE loadinifuncs
    * Loads funtions needed for reading INI files
    IF THIS.lLoadedINIs
    	RETURN ERROR_SUCCESS
    ENDIF
    
    DECLARE integer GetPrivateProfileString IN Win32API ;
    	AS GetPrivateINI string,string,string,string,integer,string
    
    IF THIS.lhaderror && error loading library
    	RETURN -1
    ENDIF
    
    DECLARE integer GetProfileString IN Win32API ;
    	AS GetWinINI string,string,string,string,integer
    
    DECLARE integer WriteProfileString IN Win32API ;
    	AS WriteWinINI string,string,string
    
    DECLARE integer WritePrivateProfileString IN Win32API ;
    	AS WritePrivateINI string,string,string,string
    
    THIS.lLoadedINIs = .T.
    
    * Need error check here
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE writeinientry
    LPARAMETER cValue,cSection,cEntry,cINIFile
    
    * Get entry from INI file 
    LOCAL nErrNum
    
    * Load API functions
    nErrNum = THIS.LoadINIFuncs()
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    IF EMPTY(m.cINIFile)
    	* WIN.INI file
    	nErrNum = WriteWinINI(m.cSection,m.cEntry,m.cValue)
    ELSE
    	* Private INI file
    	nErrNum = WritePrivateINI(m.cSection,m.cEntry,m.cValue,m.cINIFile)
    ENDIF
    		
    ** All is well
    RETURN IIF(m.nErrNum=1,ERROR_SUCCESS,m.nErrNum)
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: oldinireg
**************************************************



**************************************************
*-- Class:        registry (d:\beta\fcmd\vfpproj\xfoxcode\registry.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*
*#INCLUDE "d:\beta\fcmd\vfpproj\xfoxcode\registry.h"
*
DEFINE CLASS registry AS custom

  Name = "registry"
  capppathkey =[]
  cinidllfile =[]
  codbcdllfile =[]
  cregdllfile =[]
  cvfpoptpath =[]
  lcreatekey = .F.
  ldisallowexpanded = .F.
  lhaderror = .F.
  lhasdllloaded = .F.
  lloadeddlls = .F.
  lloadedinis = .F.
  lloadedodbcs = .F.
  ncurrentkey = 0
  ncurrentos = 0
  nuserkey = 0

  
  PROCEDURE closekey
    * Closes a registry key
    =RegCloseKey(THIS.nCurrentKey)
    THIS.nCurrentKey =0 
    
  ENDPROC
  
  PROCEDURE deletekey
    * This routine deletes a Registry Key
    LPARAMETER nUserKey,cKeyPath
    LOCAL nErrNum
    nErrNum = ERROR_SUCCESS
    
    * Delete key
    m.nErrNum = RegDeleteKey(m.nUserKey,m.cKeyPath)
    RETURN m.nErrNum
    
  ENDPROC
  
  PROCEDURE deletekeyvalue
    LPARAMETER cOptName,cKeyPath,nUserKey
    LOCAL cOption,nErrNum
    cOption = cOptName
    nErrNum = ERROR_SUCCESS
    
    * Open key
    m.nErrNum = THIS.OpenKey(m.cKeyPath,m.nUserKey)
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Delete the key value
    m.nErrNum = RegDeleteValue(THIS.nCurrentKey,m.cOption)
    
    * Close key
    THIS.CloseKey()		&& close key
    RETURN m.nErrNum
    
  ENDPROC
  
  PROCEDURE Destroy
    IF !THIS.lHasDllLoaded
    	CLEAR DLLS RegOpenKey
    	CLEAR DLLS RegCreateKey
    	CLEAR DLLS RegDeleteKey
    	CLEAR DLLS RegDeleteValue
    	CLEAR DLLS RegCloseKey
    	CLEAR DLLS RegSetValueEx
    	CLEAR DLLS RegQueryValueEx
    	CLEAR DLLS RegEnumKey
    	CLEAR DLLS RegEnumKeyEx
    	CLEAR DLLS RegEnumValue
    ENDIF
  ENDPROC
  
  PROCEDURE enumkeys
    LPARAMETERS aKeyNames
    LOCAL nKeyEntry,cNewKey,cbuf,nbuflen,cRetTime, nKeySize, nErrCode
    nKeyEntry = 0
    DIMENSION aKeyNames[1]
    DO WHILE .T.
    	nKeySize = 0
    	cNewKey = SPACE(100)
    	nKeySize = LEN(m.cNewKey)
    	cbuf=space(100)
    	nbuflen=len(m.cbuf)
    	cRetTime=space(100)
    
    	m.nErrCode = RegEnumKeyEx(THIS.nCurrentKey,m.nKeyEntry,@cNewKey,@nKeySize,0,@cbuf,@nbuflen,@cRetTime)
    	
    	DO CASE
    	CASE m.nErrCode = ERROR_EOF
    		EXIT
    	CASE m.nErrCode # ERROR_SUCCESS
    		EXIT
    	ENDCASE
    
    	cNewKey = ALLTRIM(m.cNewKey)
    	cNewKey = LEFT(m.cNewKey,LEN(m.cNewKey)-1)
    	IF !EMPTY(aKeyNames[1])
    		DIMENSION aKeyNames[ALEN(aKeyNames)+1]
    	ENDIF
    	aKeyNames[ALEN(aKeyNames)] = m.cNewKey 
    	nKeyEntry = m.nKeyEntry + 1
    ENDDO
    
    IF m.nErrCode = ERROR_EOF AND m.nKeyEntry # 0
    	m.nErrCode = ERROR_SUCCESS
    ENDIF
    RETURN m.nErrCode
    
  ENDPROC
  
  PROCEDURE enumkeyvalues
    * Enumerates through values of a registry key
    LPARAMETER aKeyValues
    
    LOCAL lpszValue,lpcchValue,lpdwReserved
    LOCAL lpdwType,lpbData,lpcbData
    LOCAL nErrCode,nKeyEntry
    
    STORE 0 TO nKeyEntry
    
    IF TYPE("THIS.nCurrentKey")#'N' OR THIS.nCurrentKey = 0
    	RETURN ERROR_BADKEY
    ENDIF
    
    * Sorry, Win32s does not support this one!
    IF THIS.nCurrentOS = OS_W32S
    	RETURN ERROR_BADPLAT
    ENDIF
    
    DO WHILE .T.
    
    	STORE 0 TO lpdwReserved,lpdwType,nErrCode
    	STORE SPACE(256) TO lpbData, lpszValue
    	STORE LEN(lpbData) TO m.lpcchValue
    	STORE LEN(lpszValue) TO m.lpcbData
    
    	nErrCode=RegEnumValue(THIS.nCurrentKey,m.nKeyEntry,@lpszValue,;
    		@lpcchValue,m.lpdwReserved,@lpdwType,@lpbData,@lpcbData)
    	
    	DO CASE
    	CASE m.nErrCode = ERROR_EOF
    		EXIT
    	CASE m.nErrCode # ERROR_SUCCESS
    		EXIT
    	ENDCASE
    
    	nKeyEntry = m.nKeyEntry + 1
    
    	* Set array values
    	DIMENSION aKeyValues[m.nKeyEntry,2]
    	aKeyValues[m.nKeyEntry,1] = LEFT(m.lpszValue,m.lpcchValue)
    	DO CASE
    	CASE lpdwType = REG_SZ
    		aKeyValues[m.nKeyEntry,2] = LEFT(m.lpbData,m.lpcbData-1)
    	CASE lpdwType = REG_EXPAND_SZ AND !THIS.lDisAllowExpanded
    		aKeyValues[m.nKeyEntry,2] = LEFT(m.lpbData,m.lpcbData-1)
    	CASE lpdwType = REG_BINARY
    		* Don't support binary
    		aKeyValues[m.nKeyEntry,2] = REG_BINARY_LOC
    	CASE lpdwType = REG_DWORD
    		* You will need to use ASC() to check values here.
    		aKeyValues[m.nKeyEntry,2] = LEFT(m.lpbData,m.lpcbData-1)
    	OTHERWISE
    		aKeyValues[m.nKeyEntry,2] = REG_UNKNOWN_LOC
    	ENDCASE
    ENDDO
    
    IF m.nErrCode = ERROR_EOF AND m.nKeyEntry#0
    	m.nErrCode = ERROR_SUCCESS
    ENDIF
    RETURN m.nErrCode
    
  ENDPROC
  
  PROCEDURE enumoptions
    * Enumerates through all entries for a key and populates array
    LPARAMETER aRegOpts,cOptPath,nUserKey,lEnumKeys
    LOCAL iPos,cOption,nErrNum
    iPos = 0
    cOption = ""
    nErrNum = ERROR_SUCCESS
    
    IF PCOUNT()<4 OR TYPE("m.lEnumKeys") # "L"
    	lEnumKeys = .F.
    ENDIF
    
    * Open key
    m.nErrNum = THIS.OpenKey(m.cOptPath,m.nUserKey)
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Enumerate through keys
    IF m.lEnumKeys
    	* Enumerate and get key names
    	nErrNum = THIS.EnumKeys(@aRegOpts)
    ELSE
    	* Enumerate and get all key values
    	nErrNum = THIS.EnumKeyValues(@aRegOpts)
    ENDIF
    
    * Close key
    THIS.CloseKey()		&&close key
    RETURN m.nErrNum
    
  ENDPROC
  
  PROCEDURE Error
    LPARAMETERS nError, cMethod, nLine
    THIS.lhaderror = .T.
    =MESSAGEBOX(MESSAGE())
    
  ENDPROC
  
  PROCEDURE getkeyvalue
    * Obtains a value from a registry key
    * Note: this routine only handles Data strings (REG_SZ)
    LPARAMETER cValueName,cKeyValue
    
    LOCAL lpdwReserved,lpdwType,lpbData,lpcbData,nErrCode
    STORE 0 TO lpdwReserved,lpdwType
    STORE SPACE(256) TO lpbData
    STORE LEN(m.lpbData) TO m.lpcbData
    
    DO CASE
    CASE TYPE("THIS.nCurrentKey")#'N' OR THIS.nCurrentKey = 0
    	RETURN ERROR_BADKEY
    CASE TYPE("m.cValueName") #"C"
    	RETURN ERROR_BADPARM
    ENDCASE
    
    m.nErrCode=RegQueryValueEx(THIS.nCurrentKey,m.cValueName,;
    		m.lpdwReserved,@lpdwType,@lpbData,@lpcbData)
    
    * Check for error 
    IF m.nErrCode # ERROR_SUCCESS
    	RETURN m.nErrCode
    ENDIF
    
    * Make sure we have a data string data type
    IF m.lpdwType # REG_SZ AND m.lpdwType # REG_EXPAND_SZ 
    	RETURN ERROR_NONSTR_DATA		
    ENDIF
    
    m.cKeyValue = LEFT(m.lpbData,m.lpcbData-1)
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE getregkey
    * This routine gets a registry key setting
    * ex. THIS.GetRegKey("ResWidth",@cValue,;
    *		"Software\Microsoft\VisualFoxPro\4.0\Options",;
    *		HKEY_CURRENT_USER)
    LPARAMETER cOptName,cOptVal,cKeyPath,nUserKey
    LOCAL iPos,cOption,nErrNum
    iPos = 0
    cOption = ""
    nErrNum = ERROR_SUCCESS
    
    * Open registry key
    m.nErrNum = THIS.OpenKey(m.cKeyPath,m.nUserKey)
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Get the key value
    nErrNum = THIS.GetKeyValue(cOptName,@cOptVal)
    
    * Close registry key 
    THIS.CloseKey()		&&close key
    RETURN m.nErrNum
    
  ENDPROC
  
  PROCEDURE Init
    LOCAL laTmpDLLs,lnDlls
    DIMENSION laTmpDLLs[1]
    THIS.nUserKey = HKEY_CURRENT_USER
    THIS.cVFPOptPath = VFP_OPTIONS_KEY1 + _VFP.VERSION + VFP_OPTIONS_KEY2
    DO CASE
    	CASE _DOS OR _UNIX OR _MAC
    		RETURN .F.
    	CASE ATC("Windows 3",OS(1)) # 0
    		THIS.nCurrentOS = OS_W32S
    	CASE ATC("Windows NT",OS(1)) # 0
    		THIS.nCurrentOS = OS_NT
    		THIS.cRegDLLFile = DLL_ADVAPI_NT
    		THIS.cINIDLLFile = DLL_KERNEL_NT	
    		THIS.cODBCDLLFile = DLL_ODBC_NT
    	CASE VAL(OS(3)) >= 5
    		* Handle W2K, XP
    		THIS.nCurrentOS = OS_NT
    		THIS.cRegDLLFile = DLL_ADVAPI_NT
    		THIS.cINIDLLFile = DLL_KERNEL_NT	
    		THIS.cODBCDLLFile = DLL_ODBC_NT
    	OTHERWISE
    		* Windows 95
    		THIS.nCurrentOS = OS_WIN95
    		THIS.cRegDLLFile = DLL_ADVAPI_WIN95
    		THIS.cINIDLLFile = DLL_KERNEL_WIN95
    		THIS.cODBCDLLFile = DLL_ODBC_WIN95
    ENDCASE
    
    * Check if DLLs already loaded so we don't unload when done.
    lnDlls = ADLLS(laTmpDLLs)
    IF lnDlls > 0
    	IF ASCAN(laTmpDLLs,"RegOpenKey",-1,-1,-1,1)#0
    		THIS.lHasDllLoaded=.T.
    	ENDIF
    ENDIF
    
  ENDPROC
  
  PROCEDURE iskey
    * Checks to see if a key exists
    LPARAMETER cKeyName,nRegKey
    LOCAL nErrNum 
    * Open extension key		
    nErrNum = THIS.OpenKey(m.cKeyName,m.nRegKey)
    IF m.nErrNum  = ERROR_SUCCESS
    	* Close extension key
    	THIS.CloseKey()
    ENDIF
    
    RETURN m.nErrNum = ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE loadregfuncs
    * Loads funtions needed for Registry
    LOCAL nHKey,cSubKey,nResult
    LOCAL hKey,iValue,lpszValue,lpcchValue,lpdwType,lpbData,lpcbData
    LOCAL lpcStr,lpszVal,nLen,lpdwReserved
    LOCAL lpszValueName,dwReserved,fdwType
    LOCAL iSubKey,lpszName,cchName
    
    IF THIS.lLoadedDLLs
    	RETURN ERROR_SUCCESS
    ENDIF
    
    DECLARE Integer RegOpenKey IN Win32API ;
    	Integer nHKey, String @cSubKey, Integer @nResult
    
    IF THIS.lhaderror && error loading library
    	RETURN -1
    ENDIF
    
    DECLARE Integer RegCreateKey IN Win32API ;
    	Integer nHKey, String @cSubKey, Integer @nResult
    
    DECLARE Integer RegDeleteKey IN Win32API ;
    	Integer nHKey, String @cSubKey
    
    DECLARE Integer RegDeleteValue IN Win32API ;
    	Integer nHKey, String cSubKey
    
    DECLARE Integer RegCloseKey IN Win32API ;
    	Integer nHKey
    
    DECLARE Integer RegSetValueEx IN Win32API ;
    	Integer hKey, String lpszValueName, Integer dwReserved,;
    	Integer fdwType, String lpbData, Integer cbData
    
    DECLARE Integer RegQueryValueEx IN Win32API ;
    	Integer nHKey, String lpszValueName, Integer dwReserved,;
    	Integer @lpdwType, String @lpbData, Integer @lpcbData
    
    DECLARE Integer RegEnumKey IN Win32API ;
    	Integer nHKey,Integer iSubKey, String @lpszName, Integer @cchName
    
    DECLARE Integer RegEnumKeyEx IN Win32API ;
    	Integer nHKey,Integer iSubKey, String @lpszName, Integer @cchName,;
    	Integer dwReserved,String @lpszName, Integer @cchName,String @cchName
    
    DECLARE Integer RegEnumValue IN Win32API ;
    	Integer hKey, Integer iValue, String @lpszValue, ;
    	Integer @lpcchValue, Integer lpdwReserved, Integer @lpdwType, ;
    	String @lpbData, Integer @lpcbData
        		
    THIS.lLoadedDLLs = .T.
    
    * Need error check here
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE openkey
    * Opens a registry key
    LPARAMETER cLookUpKey,nRegKey,lCreateKey
    
    LOCAL nSubKey,nErrCode,nPCount,lSaveCreateKey
    nSubKey = 0
    nPCount = PCOUNT()
    
    IF TYPE("m.nRegKey") # "N" OR EMPTY(m.nRegKey)
    	m.nRegKey = HKEY_CLASSES_ROOT
    ENDIF
    
    * Load API functions
    nErrCode = THIS.LoadRegFuncs()
    IF m.nErrCode # ERROR_SUCCESS
    	RETURN m.nErrCode
    ENDIF
    
    lSaveCreateKey = THIS.lCreateKey
    IF m.nPCount>2 AND TYPE("m.lCreateKey") = "L"
    	THIS.lCreateKey = m.lCreateKey
    ENDIF
    
    IF THIS.lCreateKey
    	* Try to open or create registry key
    	nErrCode = RegCreateKey(m.nRegKey,m.cLookUpKey,@nSubKey)
    ELSE
    	* Try to open registry key
    	nErrCode = RegOpenKey(m.nRegKey,m.cLookUpKey,@nSubKey)
    ENDIF
    
    THIS.lCreateKey = m.lSaveCreateKey
    
    IF nErrCode # ERROR_SUCCESS
    	RETURN m.nErrCode
    ENDIF
    
    THIS.nCurrentKey = m.nSubKey
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE setkeyvalue
    * This routine sets a key value
    * Note: this routine only handles data strings (REG_SZ)
    LPARAMETER cValueName,cValue
    LOCAL nValueSize,nErrCode 
    
    DO CASE
    CASE TYPE("THIS.nCurrentKey")#'N' OR THIS.nCurrentKey = 0
    	RETURN ERROR_BADKEY
    CASE TYPE("m.cValueName") #"C" OR TYPE("m.cValue")#"C"
    	RETURN ERROR_BADPARM
    *!*	CASE EMPTY(m.cValueName)
    *!*		RETURN ERROR_BADPARM
    ENDCASE
    
    * Make sure we null terminate this guy
    cValue = m.cValue+CHR(0)
    nValueSize = LEN(m.cValue)
    
    * Set the key value here
    m.nErrCode = RegSetValueEx(THIS.nCurrentKey,m.cValueName,0,;
    	REG_SZ,m.cValue,m.nValueSize)
    
    * Check for error
    IF m.nErrCode # ERROR_SUCCESS
    	RETURN m.nErrCode
    ENDIF
    
    RETURN ERROR_SUCCESS
    
  ENDPROC
  
  PROCEDURE setregkey
    * This routine sets a registry key setting
    * ex. THIS.SetRegKey("ResWidth","640",;
    *		"Software\Microsoft\VisualFoxPro\6.0\Options",;
    *		HKEY_CURRENT_USER)
    LPARAMETER cOptName,cOptVal,cKeyPath,nUserKey,lCreateKey
    LOCAL iPos,cOptKey,cOption,nErrNum
    iPos = 0
    cOption = ""
    nErrNum = ERROR_SUCCESS
    
    * Open registry key
    m.nErrNum = THIS.OpenKey(m.cKeyPath,m.nUserKey,m.lCreateKey)
    IF m.nErrNum # ERROR_SUCCESS
    	RETURN m.nErrNum
    ENDIF
    
    * Set Key value
    nErrNum = THIS.SetKeyValue(m.cOptName,m.cOptVal)
    
    * Close registry key 
    THIS.CloseKey()		&&close key
    RETURN m.nErrNum
    
  ENDPROC


ENDDEFINE
*
*-- EndDefine: registry
**************************************************