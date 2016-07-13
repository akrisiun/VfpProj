#ifndef _VFP2CMACROS_H__
#define _VFP2CMACROS_H__

// defines for easier access to VFP parameters (1 based)
// by value
#define p1 (parm->p[0].val)
#define p2 (parm->p[1].val)
#define p3 (parm->p[2].val)
#define p4 (parm->p[3].val)
#define p5 (parm->p[4].val)
#define p6 (parm->p[5].val)
#define p7 (parm->p[6].val)
#define p8 (parm->p[7].val)
#define p9 (parm->p[8].val)
#define p10 (parm->p[9].val)
#define p11 (parm->p[10].val)
#define p12 (parm->p[11].val)
#define p13 (parm->p[12].val)
#define p14 (parm->p[13].val)
#define p15 (parm->p[14].val)
#define p16 (parm->p[15].val)
#define p17 (parm->p[16].val)
#define p18 (parm->p[17].val)
#define p19 (parm->p[18].val)
#define p20 (parm->p[19].val)
#define p21 (parm->p[20].val)
#define p22 (parm->p[21].val)
#define p23 (parm->p[22].val)
#define p24 (parm->p[23].val)
#define p25 (parm->p[24].val)
#define p26 (parm->p[25].val)

// by reference
#define r1 (parm->p[0].loc)
#define r2 (parm->p[1].loc)
#define r3 (parm->p[2].loc)
#define r4 (parm->p[3].loc)
#define r5 (parm->p[4].loc)
#define r6 (parm->p[5].loc)
#define r7 (parm->p[6].loc)
#define r8 (parm->p[7].loc)
#define r9 (parm->p[8].loc)
#define r10 (parm->p[9].loc)
#define r11 (parm->p[10].loc)
#define r12 (parm->p[11].loc)
#define r13 (parm->p[12].loc)
#define r14 (parm->p[13].loc)
#define r15 (parm->p[14].loc)
#define r16 (parm->p[15].loc)
#define r17 (parm->p[16].loc)
#define r18 (parm->p[17].loc)
#define r19 (parm->p[18].loc)
#define r20 (parm->p[19].loc)
#define r21 (parm->p[20].loc)
#define r22 (parm->p[21].loc)
#define r23 (parm->p[22].loc)
#define r24 (parm->p[23].loc)
#define r25 (parm->p[24].loc)
#define r26 (parm->p[25].loc)

// count of parameters passed
#define PCOUNT() (parm->pCount)

// defines for easier declaration of typed Value's
#define LOGICAL(sValue)					Value sValue = {'L','\0',0,0}
#define SHORT(sValue) 					Value sValue = {'I','\0',6,0}
#define INTEGER(sValue) 				Value sValue = {'I','\0',11,0}
#define UINTEGER(sValue)				Value sValue = {'N','\0',10,0}
#define DOUBLE(sValue) 					Value sValue = {'N','\0',20,16}
#define FLOAT(sValue) 					Value sValue = {'N','\0',20,7}
#define NUMERIC(sValue,nWidth,nLength)	Value sValue = {'N','\0',nWidth,nLength}
#define INT64DOUBLE(sValue)				Value sValue = {'N','\0',20,0}
#define CURRENCY(sValue)				Value sValue = {'Y','\0',0,0,0,0,0,0}
#define STRING(sValue) 					Value sValue = {'C','\0',0,0,0,0,0,0}
#define STRINGN(sValue,nLength) 		Value sValue = {'C','\0',0,nLength,0,0,0,0}
#define DATE(sValue)					Value sValue = {'D'}
#define DATETIME(sValue)				Value sValue = {'T'}
#define VALUE(sValue) 					Value sValue = {'0'}

// defines for easier 'typeing' an already existing "Value"
#define SET_LOGICAL(sValue)		sValue.ev_type = 'L'; sValue.ev_length = 0
#define SET_SHORT(sValue) 		sValue.ev_type = 'I'; sValue.ev_width = 6
#define SET_INTEGER(sValue)		sValue.ev_type = 'I'; sValue.ev_width = 11
#define SET_UINTEGER(sValue)		sValue.ev_type = 'N'; sValue.ev_width = 10; sValue.ev_length = 0
#define SET_DOUBLE(sValue)		sValue.ev_type = 'N'; sValue.ev_width = 20; sValue.ev_length = 16
#define SET_FLOAT(sValue)		sValue.ev_type = 'N'; sValue.ev_width = 20; sValue.ev_length = 7
#define SET_NUMERIC(sValue,nWidth,nLength) sValue.ev_type = 'N'; sValue.ev_width = nWidth; sValue.ev_length = nLength
#define SET_INT64DOUBLE(sValue) sValue.ev_type = 'N'; sValue.ev_width = 20; sValue.ev_length = 0
#define SET_CURRENCY(sValue) sValue.ev_type = 'Y'; sValue.ev_currency.QuadPart = 0
#define SET_STRING(sValue)		sValue.ev_type = 'C'; sValue.ev_length = 0; sValue.ev_handle = 0
#define SET_DATE(sValue)			sValue.ev_type = 'D'
#define SET_DATETIME(sValue)		sValue.ev_type = 'T'
#define SET_NULL(sValue)			sValue.ev_type = '0'

// defines for easier type checking of Value's
#define IS_DATE(sValue) (sValue.ev_type == 'D')
#define IS_DATETIME(sValue) (sValue.ev_type == 'T')
#define IS_LOGICAL(sValue) (sValue.ev_type == 'L')
#define IS_INTEGER(sValue) (sValue.ev_type == 'I')
#define IS_NUMERIC(sValue) (sValue.ev_type == 'N')
#define IS_STRING(sValue) (sValue.ev_type == 'C')
#define IS_OBJECT(sValue) (sValue.ev_type == 'O')
#define IS_NULL(sValue)	(sValue.ev_type == '0')
#define IS_CURRENCY(sValue) (sValue.ev_type == 'Y')
#define IS_REFERENCE(sValue) (sValue.l_type == 'R')
#define IS_MEMOREF(sValue) (sValue.l_type == 'R' && sValue.l_where != -1)
#define IS_VARIABLEREF(sLocator) (sLocator.l_where == -1)

// is value a string and length > 0
#define VALID_STRING(sValue) (sValue.ev_type == 'C' && sValue.ev_length)
#define VALID_STRING_EX(nParm) (PCOUNT() >= nParm && parm->p[nParm-1].val.ev_length)

// defines for easier loading and replacing variables passed by reference or 
// identified with FindFoxVar/FindFoxField
#define STORE(sLocator,sValue)	_Store(&sLocator,&sValue)
#define STOREEX(sLocator,sValue) StoreEx(&sLocator,&sValue)
#define LOAD(sLocator,sValue)	_Load(&sLocator,&sValue)

#define EVALUATE(sValue,pCommand) _Evaluate(&sValue,pCommand)
#define EXECUTE(pCommand)	_Execute(pCommand) // just for completeness ..

// defines for returning values back to VFP
#define RET_INTEGER(sSomeVar) _RetInt((long)sSomeVar,11)
#define RET_UINTEGER(sSomeVar) _RetFloat((double)(unsigned long)sSomeVar,11,0)
#define RET_DOUBLE(sSomeVar) _RetFloat((double)sSomeVar,20,16)
#define RET_FLOAT(sSomeVar) _RetFloat((double)sSomeVar,20,7)
#define RET_INT64(sSomeVar) _RetFloat((double)sSomeVar,20,0) // may truncate the value !!
#define RET_CURRENCY(sSomeVar) _RetCurrency(sSomeVar,21)
#define RET_LOGICAL(sSomeVar) _RetLogical((int)sSomeVar)
#define RET_VALUE(sValue) _RetVal(&sValue)
// to return the rowcount of an array
#define RET_AROWS(sLocator) _RetInt(sLocator.l_sub1,5)
// to return a pointer variable that may be bigger than MAX_INT
#define RET_POINTER(sSomePointer) (int)sSomePointer >= 0 ? _RetInt((long)sSomePointer,11) : _RetFloat((double)(unsigned long)sSomePointer,11,0)

// defines for easier memory handle usage in combination with a Value structure
#ifndef __cplusplus
#define HANDTOPTR(sValue)			_HandToPtr(sValue.ev_handle)
#else
#define HANDTOPTR(sValue)			(char*)_HandToPtr(sValue.ev_handle)
#endif

#define ALLOCHAND(sValue,nBytes)	(sValue.ev_handle = _AllocHand(##nBytes))
#define FREEHAND(sValue)			_FreeHand(sValue.ev_handle)
#define VALIDHAND(sValue)			(sValue.ev_handle)
#define LOCKHAND(sValue)			_HLock(sValue.ev_handle)
#define UNLOCKHAND(sValue)			_HUnLock(sValue.ev_handle)
#define GETHANDSIZE(sValue)			_GetHandSize(sValue.ev_handle)
#define SETHANDSIZE(sValue,nLength)	_SetHandSize(sValue.ev_handle,##nLength)
#define EXPANDHAND(sValue,nBytes)	_SetHandSize(sValue.ev_handle,sValue.ev_length+nBytes)
#define NULLTERMINATE(sValue)		_SetHandSize(sValue.ev_handle,sValue.ev_length+1)

// array handling macros
// initializes a Locator for an array to zero and the supplied subscripts 
#define RESETARRAY(sLocator,nSubscripts)	sLocator.l_subs = ##nSubscripts > 1 ? 2 : 1; \
									sLocator.l_sub1 = 0; \
									sLocator.l_sub2 = 0

#define AROW(sLocator) sLocator.l_sub1 // access row subscript of Locator
#define ADIM(sLocator) sLocator.l_sub2 // access dimension subscript of Locator

#define ALEN(sLocator,nAttribute) _ALen(sLocator.l_NTI,nAttribute) // like ALEN function in VFP
#define AELEMENTS(sLocator)	_ALen(sLocator.l_NTI,AL_ELEMENTS)
#define AROWS(sLocator)		_ALen(sLocator.l_NTI,AL_SUBSCRIPT1)
#define ADIMS(sLocator)		_ALen(sLocator.l_NTI,AL_SUBSCRIPT2)
#define VALID_ADIM(nDims,nPassed) ((nPassed <= nDims) || (nPassed == 1 && nDims == 0))

// object manipulation macros
#define ADDOBJECTPROPERTY(sObject,pName,sValue) _SetObjectProperty(&sObject,pName,&sValue,TRUE)

// VFP like macros for easier table handling
#define APPENDRECORDS(nRecords) DBAppendRecords(-1,nRecords)
#define APPENDRECORDSW(nWorkarea,nRecords) DBAppendRecords(nWorkarea,nRecords)
#define APPENDBLANK() _DBAppend(-1,0)
#define APPENDBLANKW(nWorkarea) _DBAppend(nWorkarea,0)
#define APPENDCARRY() _DBAppend(-1,1)
#define APPENDCARRYW(nWorkarea) _DBAppend(nWorkarea,1)
#define APPEND() _DBAppend(-1,-1)
#define APPENDW(nWorkarea) _DBAppend(nWorkarea,-1)
#define GOTOP() _DBRewind()
#define GOTOPW(nWorkarea) _DBRewind(nWorkarea)
#define GOBOTTOM() _DBUnwind(-1)
#define GOBOTTOMW(nWorkarea) _DBUnwind(nWorkarea)
#define SKIP(nRecords) _DBSkip(-1,nRecords)
#define SKIPW(nWorkarea,nRecords) _DBSkip(nWorkarea,nRecords)
#define RECNO() _DBRecNo(-1)
#define RECNOW(nWorkarea) _DBRecNo(nWorkarea)
#define RECCOUNT() _DBRecCount(-1)
#define RECCOUNTW(nWorkarea) _DBRecCount(nWorkarea)
#define GO(nRecord) _DBRead(-1,nRecord)
#define GOW(nWorkarea,nRecord) _DBRead(nWorkarea,nRecord)
#define RLOCK() _DBLock(-1,DBL_RECORD)
#define RLOCKW(nWorkarea) _DBLock(nWorkarea,DBL_RECORD)
#define FLOCK() _DBLock(-1,DBL_FILE) 
#define FLOCKW(nWorkarea) _DBLock(nWorkarea,DBL_FILE)
#define UNLOCK() _DBUnLock(-1)
#define UNLOCKW(nWorkarea) _DBUnLock(nWorkarea)

#define REPLACE(sLocator,sValue) _DBReplace(&sLocator,&sValue)
#define SEEK(sValue) _DBSeek(&sValue)

// VFP like macros for testing table status
#define BOF() (_DBStatus(-1) & DB_BOF)
#define BOFW(nWorkarea) (_DBStatus(nWorkarea) & DB_BOF)
//#define EOF() (_DBStatus(-1) & DB_EOF) //conflicts with EOF define from stdio.h
#define EOFW(nWorkarea) (_DBStatus(nWorkarea) & DB_EOF)
#define RLOCKED() (_DBStatus(-1) & DB_RLOCKED)
#define RLOCKEDW(nWorkarea) (_DBStatus(nWorkarea) & DB_RLOCKED)
#define FLOCKED() (_DBStatus(-1) & DB_FLOCKED)
#define FLOCKEDW(nWorkarea) (_DBStatus(nWorkarea) & DB_FLOCKED)
#define EXCLUSIVE() (_DBStatus(-1) & DB_EXCLUSIVE)
#define EXCLUSIVEW(nWorkarea) (_DBStatus(nWorkarea) & DB_EXCLUSIVE)
#define READONLY() (_DBStatus(-1) & DB_READONLY)
#define READONLYW(nWorkarea) (_DBStatus(nWorkarea) & DB_READONLY)

#define DBSTATUS() _DBStatus(-1)
#define DBSTATUSW(nWorkarea) _DBStatus(nWorkarea)

#define WORKAREA(sLocator) sLocator.l_where

// some window defines (gives us HWND of the screen or topmost window respectivly)
#define WMAINHWND() _WhToHwnd(_WMainWindow())
#define WTOPHWND()	_WhToHwnd(_WOnTop())
#define WHWNDBYTITLE(lcWindow) _WhToHwnd(_WFindTitle(lcWindow))

// misc helper macros
// mulitply 2 integers (a 64 Bit Integer) to a double 
#define INTS2DOUBLE(nLowInt,nHighInt) (((double)nHighInt) * 4294967296.0 + nLowInt)
#define INTS2INT64(nLowInt,nHighInt) (((__int64)nHighInt) * 4294967296 + nLowInt)

// some defines for file functions
#define FSIZE(hChan)	_FSeek(hChan,0,FS_FROMEOF);

// some VFP internal error numbers
#define E_INSUFMEMORY		182
#define E_TYPECONFLICT		532
#define E_FIELDNOTFOUND		806
#define E_ARRAYNOTFOUND		176
#define E_VARIABLENOTFOUND	170
#define E_INVALIDPARAMS		901
#define E_NOENTRYPOINT		754
#define E_INVALIDSUBSCRIPT	224
#define E_NOTANARRAY		176
#define E_LOCKFAILED		503
#define E_CUSTOMERROR		7777
#define E_APIERROR			12345678

#endif // _VFP2CMACROS_H__