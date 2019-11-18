//
//   Title:         SFBusinessDataCustom
//
//   Description:   custom business-dataset (base)
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//

unit SFBusinessDataCustom;

interface

{$I SFBusinessData.INC}

uses
  Data.DB, System.Generics.Collections, System.Classes, System.SysUtils,
  SFBusinessDataConnector, SFStatements, SFBusinessDataCommon, SFStatementType;

type
  TSFCustomBusinessData = class;
  TSFBDSCompareRecord = class;
  TSFBDSAutoValueGenerator = class;

  TSFBusinessClass = class of TSFCustomBusinessData;
  TSFBDSAutoValueGeneratorCls = class of TSFBDSAutoValueGenerator;

  TSFBDSRecordUpdateState = (
      usUnmodified,
      usInserted,
      usModified,
      usDeleted
    );

  TSFBDSRecordRefType = (
      rtNone,
      rtData,
      rtCache
    );

  TSFBDSRecordCompareResult = (
      compareResultLess,
      compareResultEqual,
      compareResultGreater,
      compareResultUndefined
    );

  TSFBDSRefreshMode = (
      refreshModeRow,
      refreshModeFull
    );

  TSFBDSAutoValueOption = (
      avoExecute,
      avoNeedSequence,
      avoNeedTable,
      avoExecWhenAuto,
      avoPreventWhenAuto,
      avoExecWhenExplicitByDBMS,
      avoPreventWhenExplicitByDBMS
    );

  TSFBDSAutoValueOptions = set of TSFBDSAutoValueOption;

  TSFBDSAutoValueGetMode = (
      avGMAfterInsert,
      avGMBeforePost,
      avGMAfterPost
    );

  TSFBDSFieldData = record
    fdDataOfs: Integer;
    fdDataSize: Integer;
    fdDataIsBlob: Boolean;
    fdDataIsNull: Boolean;
  end;
  PSFBDSFieldData = ^TSFBDSFieldData;

  TSFBDSRecordData = record
    rdBookmarkFlag: TBookmarkFlag;
    rdFieldCount: SmallInt;
    rdRecordNumber: LongInt;
    rdUpdateState: TSFBDSRecordUpdateState;
    rdFields: array[1..1] of TSFBDSFieldData;
  end;
  PSFBDSRecordData = ^TSFBDSRecordData;

  TSFBDSBlobDataArray = array[0..0] of TMemoryStream;
  PSFBDSBlobDataArray = ^TSFBDSBlobDataArray;

  TSFBDSRecordInfo = record
    riRef: LongInt;
    riRefSaved: LongInt;
    riRefDataUpd: LongInt;
    riRefDataOrg: LongInt;
    riRecType: TSFBDSRecordRefType;
    riUpdateState: TSFBDSRecordUpdateState;
    riCachedUpdateState: TSFBDSRecordUpdateState;
    riFiltered: Boolean;
  end;
  TSFBDSRecordInfos = array of TSFBDSRecordInfo;

  TSFBDSFieldInfoMap = record
    fimFieldName: String;
    fimDBFieldName: String;
    fimIsBaseField: Boolean;
    fimIsKeyField: Boolean;
  end;
  TSFBDSFieldInfoMaps = array of TSFBDSFieldInfoMap;

  TSFBDSExecParamsType =
    (exPrmsTypeSelect,
      exPrmsTypeDelete);

  TSFBDSSetParamsEvt = procedure(pType: TSFBDSExecParamsType; pParams: TCollection) of object;
  TSFBSDRecordCompareEvent = function(CompareRecordFrom, CompareRecordTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult of object;
  TSFBDSGetAutoValueCls = function(pFieldName: String; pAutoDetected: Boolean): TSFBDSAutoValueGeneratorCls;

  TSFBDSBlobStream = class(TStream)
  protected
    mField: TField;
    mStream: TMemoryStream;
    mModified: Boolean;
  public
    constructor Create(pField: TField; pStream: TMemoryStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SetSize(NewSize: Longint); override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  TSFBDSCompareRecord = class(TObject)
    private
      mRecord: TRecBuf;
      mDataSet: TSFCustomBusinessData;
    public
      constructor Create(pDataSet: TSFCustomBusinessData; pRecord: TRecBuf);
    public
      function GetFieldValByName(pFieldName: String): Variant;
      function GetFieldValByIdx(pFieldIdx: Integer): Variant;
      function GetBlobFieldValByName(pFieldName: String): TArray<Byte>;
      function GetBlobFieldValByIdx(pFieldIdx: Integer): TArray<Byte>;
  end;

  TSFBusinessClassItem = class(TObject)
    private
      mName: String;
      mClass: TSFBusinessClass;
    public
      constructor Create(pName: String; pClass: TSFBusinessClass);
  end;

  TSFBusinessClassFactory = class(TObject)
    private
      class var cClasses: TObjectList<TSFBusinessClassItem>;
    public
      class procedure RegisterClass(pCls: TSFBusinessClass; pName: String);
      class function GetClassByName(pName: String): TSFBusinessClass;
      class function GetBusinessDataObj(pName: String; pCatalog: String = ''; pSchema: String = '';
                      pAltClass: TSFBusinessClass = nil; pOwner: TComponent = nil): TSFCustomBusinessData;
  end;

  TSFBDSAutoValueGenerator = class(TObject)
    private
      mSequenceName: String;
      mDataSet: TSFCustomBusinessData;
      mFieldName: String;
      mAutoDetected: Boolean;
      mExplicitInsertByDBMS: Boolean;
      mOptions: Array[TSFBDSAutoValueGetMode] of TSFBDSAutoValueOptions;
    private
      function getOptions(pMode: TSFBDSAutoValueGetMode): TSFBDSAutoValueOptions;
      procedure setOptions(pMode: TSFBDSAutoValueGetMode; pOptions: TSFBDSAutoValueOptions);
    protected
      function GetGeneratorValue(pMode: TSFBDSAutoValueGetMode): Variant; virtual;
    public
      constructor Create;
    public
      property SequenceName: String read mSequenceName write mSequenceName;
      property DataSet: TSFCustomBusinessData read mDataSet;
      property FieldName: String read mFieldName;
      property AutoDetected: Boolean read mAutoDetected;
      property ExplicitInsertByDBMS: Boolean read mExplicitInsertByDBMS write mExplicitInsertByDBMS;
      property Options[pMode: TSFBDSAutoValueGetMode]: TSFBDSAutoValueOptions read getOptions write setOptions;
  end;

  TSFBDSStmtParamItem = class(TCollectionItem)
    private
      mValue: Variant;
      mName: String;
      mAutoGenerated: Boolean;
    private
      procedure setName(pName: String);
    public
      constructor Create(Collection: TCollection); override;
    published
      property Name: String read mName write setName;
      property Value: Variant read mValue write mValue;
  end;

  TSFCustomBusinessData = class(TDataSet)
    private
      mConnector: TSFConnector;
      mRecordSize: Integer;
      mRecordBlobsOffset: Integer;
      mRecordFldDataOffset: Integer;
      mRecordCalcFldOffset: Integer;
      mBlobs: TObjectList<TMemoryStream>;
      mSelect: TDataSet;
      mTableName: String;
      mCatalogName: String;
      mSchemaName: String;
      mCurrentRecIdx: Integer;
      mRecordInfos: TSFBDSRecordInfos;
      mRecMapList: Array of Integer;
      mRecCache: Array of TRecBuf;
      mRecSaved: Array of TRecBuf;
      mCurrEditBuffer: TRecBuf;
      mFilterBuffer: TRecBuf;
      mTempBuffer: TRecBuf;
      mDeletedCount: Integer;
      mAddedCount: Integer;
      mRecAddedCount: Integer;
      mFilteredCount: Integer;
      mDataFullLoaded: Boolean;
      mSelectConfigured: Boolean;
      mStmt: TSFStmt;
      mStmtParamValues: TCollection;
      mActiveStmt: TSFStmt;
      mUpdateMode: TUpdateMode;
      mOnSetParams: TSFBDSSetParamsEvt;
      mOnCompareRecords: TSFBSDRecordCompareEvent;
      mCachedUpdates: Boolean;
      mUpdatesPending: Boolean;
      mRefreshMode: TSFBDSRefreshMode;
      mAutoValuesLst: TObjectList<TSFBDSAutoValueGenerator>;
      mOnGetAutoValCls: TSFBDSGetAutoValueCls;
      mCurrInsertIdx: Integer;
      mTransaction: TComponent;
      mUpdateTransaction: TComponent;
      mFieldMaps: TSFBDSFieldInfoMaps;
      mFormatOptions: TSFBDSFormatOptions;
      mDynCalcFields: TObjectList<TField>;
      mDynLkpFields: TObjectList<TField>;
      mOnBeforeDBEditRow: TDataSetNotifyEvent;
      mOnAfterDBEditRow: TDataSetNotifyEvent;
      mOnBeforeDBInsertRow: TDataSetNotifyEvent;
      mOnAfterDBInsertRow: TDataSetNotifyEvent;
      mOnBeforeDBDeleteRow: TDataSetNotifyEvent;
      mOnAfterDBDeleteRow: TDataSetNotifyEvent;
      mOnBeforeRefreshRow: TDataSetNotifyEvent;
      mOnAfterRefreshRow: TDataSetNotifyEvent;
      mOnBeforeRefreshFull: TDataSetNotifyEvent;
      mOnAfterRefreshFull: TDataSetNotifyEvent;
    private
      procedure setConnector(pConnector: TSFConnector);
      function getConnectorUsed: TSFConnector;
      function getSelectQuery: TDataSet;
      procedure enforceSelectClosed;
      function hasActiveSelectQuery: Boolean;
      procedure configSelect(pDoOpen: Boolean);
      function detectCurrentBuffer: TRecBuf;
      function getLastDataRecNoInRecInfos: Integer;
      procedure loadRecordInfosFromData(pLimit: Integer);
      function getDataRecordCount: Integer;
      function getMaxRecInfoCount: Integer;
      function getPriorVisibleRecInfo(pStart: Integer; pCheckFiltered: Boolean): Integer;
      function getNextVisibleRecInfo(pStart: Integer; pCheckFiltered: Boolean): Integer;
      function isVisibleRecInfo(pRecInfo: TSFBDSRecordInfo; pCheckFiltered: Boolean): Boolean;
      function countInvisibleRecInfos(pFrom, pTo: Integer; pCheckFiltered: Boolean): Integer;
      procedure loadCurrentSelectRowToBuffer(pQuery: TDataSet; pBuffer: TRecBuf;
                  pRecNo: LongInt; pCopyBlobs: Boolean = False);
      procedure setTableName(pTableName: String);
      procedure setCatalogName(pCatalogName: String);
      procedure setSchemaName(pSchemaName: String);
      function getDBTableIdentifier: String;
      procedure clearCachedRecords(var pRecList: Array of TRecBuf);
      function addToSavedRecords(pBuffer: TRecBuf): Integer;
      function mapIdByRecIdx(pRecIdx: Integer): Integer;
      procedure editMappedRecIdx(pFrom, pTo: Integer);
      procedure insertCurrRecord(pRecIdx: Integer; pBuffer: TRecBuf);
      procedure editCurrRecord(pBuffer: TRecBuf);
      function executeEdit: Boolean;
      function executeDelete: Boolean;
      function executeInsert: Boolean;
      procedure refreshRow(pBuffer: TRecBuf; pRecIdx: Integer);
      procedure refreshBufferedRow(pBuffer: TRecBuf; pRecIdx: Integer);
      function moveRecInfoPositions(pFrom: Integer): Boolean;
      procedure resetRecBlobBuffers(pRecord: TRecBuf);
      procedure copyRecBuffer(pSource, pDest: TRecBuf);
      procedure copyRecBufferBlobs(pSource, pDest: TRecBuf; pKeepExisting: Boolean);
      procedure connectorChanged;
      procedure doSortBuffer(pMin, pMax: LongInt);
      procedure excangeRecInfos(pInfo, pWith: LongInt);
      function doLocate(pFields: String; pValues: Variant; pOptions: TLocateOptions; pStart: Integer): Integer;
      procedure bindBaseFields;
      function hasMappedBaseFields: Boolean;
      procedure bindAutoValues;
      procedure detectAndSetAutoValueOptions(pAutoVal: TSFBDSAutoValueGenerator);
      procedure removeDetectedAutoValues;
      procedure generateAutoValues(pMode: TSFBDSAutoValueGetMode);
      function getVarTypeForDataType(pDataType: TFieldType): TVarType;
      function getDfltValueForDataType(pDataType: TFieldType): Variant;
      function allocateNewRecordBuffer: TRecBuf;
      procedure freeAllocatedBuffer(var pBuffer: TRecBuf);
      procedure doCancelUpdatesSingle(pRecInfoIdx: Integer);
      function recIdxByRecNo(pRecNo: Integer): Integer;
      function recNoForRecIdx(pRecIdx: Integer): Integer;
      procedure checkFieldFormats(pField, pSourceField: TField);
      function createDynCalcField(pFieldName: String; pFieldCls: TFieldClass; pFldType: TFieldType;
                                  pSize, pPrecision: Integer; pOwner: TComponent = nil): TField;
      function createDynLkpField(pFieldName: String; pFieldCls: TFieldClass; pFldType: TFieldType;
                                pLkpDs: TDataSet; pKeyFlds, pLkpKeyFlds, pLkpRsltFld: String;
                                pCached: Boolean; pSize, pPrecision: Integer; pOwner: TComponent = nil): TField;
      procedure createDynCalcFields;
      procedure createDynLkpFields;
      function getDatabaseNameForFieldName(pFieldName: String; pStmt: TSFStmt; var pTableAlias, pTableName,
                                          pTableSchema, pTableCatalog, pAttrName: String): Boolean;
      procedure doOnConnectorMessage(pSender: TObject; pMsgId, pMessageType: Word);
      procedure doOnSelectClosed(pDataSet: TDataSet);
      procedure setCachedUpdates(pVal: Boolean);
      procedure setTransaction(pVal: TComponent);
      procedure setUpdateTransaction(pVal: TComponent);
      procedure setFormatOptions(pFrmtOptions: TSFBDSFormatOptions);
      function getIsPureCached: Boolean;
      function getQueryQuoteType: TSFBDSQuoteType;
      function getActiveStmt: TSFStmt;
      function getStmtParamValues: TCollection;
      procedure setStmtParamValues(pLst: TCollection);
      function getStmtParamValue(pName: String; pLst: TCollection): TSFBDSStmtParamItem;
    private
      property selectQuery: TDataSet read getSelectQuery;
      property isPureCached: Boolean read getIsPureCached;
      property activeStmt: TSFStmt read getActiveStmt;
    protected
    {$IFDEF NEXTGEN}
      function AllocRecBuf: TRecBuf; override;
      procedure FreeRecBuf(var Buffer: TRecBuf); override;
    {$ELSE}
      function AllocRecordBuffer: TRecordBuffer; override;
      procedure FreeRecordBuffer(var Buffer: TRecordBuffer); override;
    {$ENDIF NEXTGEN}
      procedure InternalAddRecord(Buffer: TRecBuf; Append: Boolean); override;
      procedure GetBookmarkData(Buffer: TRecBuf; Data: TBookmark); override;
      function GetBookmarkFlag(Buffer: TRecBuf): TBookmarkFlag; override;
      procedure InternalInitFieldDefs; override;
      procedure CreateFields; override;
      procedure InternalOpen; override;
      procedure DoAfterOpen; override;
      function IsCursorOpen: Boolean; override;
      procedure InternalClose; override;
      procedure InternalHandleException; override;
      procedure InitRecord(Buffer: TRecBuf); override;
      procedure InternalInitRecord(Buffer: TRecBuf); override;
      procedure SetBookmarkFlag(Buffer: TRecBuf; Value: TBookmarkFlag); override;
      procedure SetFieldData(Field: TField; Buffer: TValueBuffer); override;
      procedure ClearCalcFields(Buffer: NativeInt); override;
      procedure InternalDelete; override;
      procedure InternalFirst; override;
      procedure InternalLast; override;
      procedure InternalInsert; override;
      procedure DoAfterInsert; override;
      procedure InternalPost; override;
      procedure InternalCancel; override;
      procedure InternalEdit; override;
      procedure InternalRefresh; override;
      procedure InternalSetToRecord(Buffer: TRecBuf); override;
      procedure SetBookmarkData(Buffer: TRecBuf; Data: TBookmark); override;
      function GetRecordSize: Word; override;
      function GetRecordCount: Integer; override;
      function GetRecord(Buffer: TRecBuf; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
      function InternalGetRecord(Buffer: TRecBuf; GetMode: TGetMode; DoCheck, CheckFiltered: Boolean; var pRecIdx: Integer): TGetResult;
      function GetRecNo: Integer; override;
      procedure SetRecNo(Value: Integer); override;
      procedure InternalGotoBookmark(Bookmark: TBookmark); override;
      function GetCanModify: Boolean; override;
      function GetKeyFields: String; virtual;
      function GetBaseTableFields: TStringList; overload; virtual;
      function GetBaseTableFields(pTableName, pSchemaName, pCatalogName: String): TStringList; overload;
      function GetBaseTableFields(pStmtTable: TSFStmtTable): TStringList; overload;
      function GetNameInBaseFieldsList(pName: String; pList: TStringList): Boolean;
      procedure NotifyCurrentRecModified;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      function GetAutoValueCls(pFieldName: String; pAutoDetected: Boolean): TSFBDSAutoValueGeneratorCls; virtual;
      function GetAutoValueOptionsForDBType(pDBType: TSFConnectionDBType; pMode: TSFBDSAutoValueGetMode): TSFBDSAutoValueOptions; virtual;
      procedure BeforeDBEditRow; virtual;
      procedure AfterDBEditRow; virtual;
      procedure BeforeDBInsertRow; virtual;
      procedure AfterDBInsertRow; virtual;
      procedure BeforeDBDeleteRow; virtual;
      procedure AfterDBDeleteRow; virtual;
      procedure BeforeRefreshRow; virtual;
      procedure AfterRefreshRow; virtual;
      procedure BeforeRefreshFull; virtual;
      procedure AfterRefreshFull; virtual;
      procedure FilterRecord(var pAccept: Boolean); virtual;
      function CompareRecords(CompareRecordFrom, CompareRecordTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult; virtual;
      procedure SetQueryParams(pType: TSFBDSExecParamsType; pParams: TCollection); virtual;
      function MappedStmtDBDialect: TSFStmtDBDialect;
    protected
      property TableName: String read mTableName write setTableName;
      property CatalogName: String read mCatalogName write setCatalogName;
      property SchemaName: String read mSchemaName write setSchemaName;
      property QueryQuoteType: TSFBDSQuoteType read getQueryQuoteType;
    public
      function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
      function GetCurrentRecord(Buffer: TRecBuf): Boolean; override;
      function Locate(const KeyFields: string; const KeyValues: Variant;
                      Options: TLocateOptions): Boolean; override;
      function LocateNext(const KeyFields: string; const KeyValues: Variant;
                      Options: TLocateOptions): Boolean;
      function Lookup(const KeyFields: string; const KeyValues: Variant;
                      const ResultFields: string): Variant; override;
      procedure Prepare;
      function BookmarkValid(Bookmark: TBookmark): Boolean; override;
      function GetFieldData(Field : TField; var Buffer: TValueBuffer) : Boolean; override;
      procedure SetFiltered(Value: Boolean); override;
      procedure SortBuffer;
      procedure ApplyUpdates;
      procedure CancelUpdates;
      procedure FullRefresh;
      procedure Refilter;
      function AddAutoValueForField(pFieldName: String; pAutoValueClass: TSFBDSAutoValueGeneratorCls = nil): TSFBDSAutoValueGenerator;
      function GetAutoValueForField(pFieldName: String): TSFBDSAutoValueGenerator;
      function AddField(pFieldName: String; pDataType: TFieldType; pSize: Integer; pPrecision: Integer = 0;
                        pRequired: Boolean = False; pReadOnly: Boolean = False): TField;
      procedure InitFieldsFromBusinessData(pTabObjName: String; pCatalog: String = ''; pSchema: String = '';
                                            pPreventAutoValues: Boolean = False; pPreventReadOnly: Boolean = False;
                                            pPreventRequired: Boolean = False); overload;
      procedure InitFieldsFromBusinessData(pObj: TSFCustomBusinessData; pPreventAutoValues: Boolean = False;
                                            pPreventReadOnly: Boolean = False; pPreventRequired: Boolean = False); overload;
      procedure AllBaseFieldsToStmt(pOnlySearch: Boolean = False);
      procedure AddDynCalcField(pFieldName: String; pDataType: TFieldType; pSize: Integer; pPrecision: Integer = 0);
      procedure AddDynLkpField(pFieldName: String; pDataType: TFieldType; pLkpDs: TDataSet; pKeyFlds, pLkpKeyFlds,
                              pLkpRsltFld: String; pCached: Boolean; pSize: Integer; pPrecision: Integer = 0);
      function HasDynCalcField(pFieldName: String): Boolean;
      function HasDynLkpField(pFieldName: String): Boolean;
      procedure RecalcCalculatedFields;
      function DatabaseNameForFieldName(pFieldName: String; var pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName: String): Boolean;
      function SelectNameForIdentifier(pIdentifier: String; var pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName: String): String;
      function FieldNameForDBField(pDBFieldName: String; pOnlyBaseFields: Boolean): String;
      function GetLikeWildcardSingle: String;
      function GetLikeWildcardMany: String;
      function GetSupportsLikeEscape: Boolean;
      procedure ExchangeRecordPositions(pFrom, pTo: Integer);
      procedure RefreshStmtParamValues;
      function GetCanSelectWithoutTable(var pDummyTable: String): Boolean;
      function GetCanSubSelectInFrom: Boolean;
      function GetNeedTableOnSubSelectInFrom: Boolean;
    public
      constructor Create(pOwner: TComponent); overload; override;
      constructor Create; reintroduce; overload; virtual;
      constructor Create(pTableName, pCatalogName, pSchemaName: String; pOwner: TComponent = nil); reintroduce; overload;
      destructor Destroy; override;
    public
      property Connector: TSFConnector read mConnector write setConnector;
      property ConnectorUsed: TSFConnector read getConnectorUsed;
      property DBTableIdentifier: String read getDBTableIdentifier;
      property UpdateMode: TUpdateMode read mUpdateMode write mUpdateMode;
      property OnSetParams: TSFBDSSetParamsEvt read mOnSetParams write mOnSetParams;
      property OnCompareRecords: TSFBSDRecordCompareEvent read mOnCompareRecords write mOnCompareRecords;
      property CachedUpdates: Boolean read mCachedUpdates write setCachedUpdates;
      property UpdatesPending: Boolean read mUpdatesPending;
      property RefreshMode: TSFBDSRefreshMode read mRefreshMode write mRefreshMode;
      property OnGetAutoValCls: TSFBDSGetAutoValueCls read mOnGetAutoValCls write mOnGetAutoValCls;
      property Stmt: TSFStmt read mStmt;
      property StmtParamValues: TCollection read getStmtParamValues write setStmtParamValues;
      property Transaction: TComponent read mTransaction write setTransaction;
      property FormatOptions: TSFBDSFormatOptions read mFormatOptions write setFormatOptions;
      property UpdateTransaction: TComponent read mUpdateTransaction write setUpdateTransaction;
      property OnBeforeDBEditRow: TDataSetNotifyEvent read mOnBeforeDBEditRow write mOnBeforeDBEditRow;
      property OnAfterDBEditRow: TDataSetNotifyEvent read mOnAfterDBEditRow write mOnAfterDBEditRow;
      property OnBeforeDBInsertRow: TDataSetNotifyEvent read mOnBeforeDBInsertRow write mOnBeforeDBInsertRow;
      property OnAfterDBInsertRow: TDataSetNotifyEvent read mOnAfterDBInsertRow write mOnAfterDBInsertRow;
      property OnBeforeDBDeleteRow: TDataSetNotifyEvent read mOnBeforeDBDeleteRow write mOnBeforeDBDeleteRow;
      property OnAfterDBDeleteRow: TDataSetNotifyEvent read mOnAfterDBDeleteRow write mOnAfterDBDeleteRow;
      property OnBeforeRefreshRow: TDataSetNotifyEvent read mOnBeforeRefreshRow write mOnBeforeRefreshRow;
      property OnAfterRefreshRow: TDataSetNotifyEvent read mOnBeforeRefreshRow write mOnBeforeRefreshRow;
      property OnBeforeRefreshFull: TDataSetNotifyEvent read mOnBeforeRefreshFull write mOnBeforeRefreshFull;
      property OnAfterRefreshFull: TDataSetNotifyEvent read mOnAfterRefreshFull write mOnAfterRefreshFull;
  end;

implementation

uses System.StrUtils, System.Variants, System.TypInfo, SFBusinessDataConst, System.Math,
     Data.SqlTimSt, Data.FmtBcd{$IFNDEF NEXTGEN}, System.AnsiStrings{$ENDIF !NEXTGEN}, SFBusinessDataDemoHelp;

// ===========================================================================//
//                              TSFBDSBlobStream                              //
// ===========================================================================//

constructor TSFBDSBlobStream.Create(pField: TField; pStream: TMemoryStream);
begin
  mField := pField;
  mStream := pStream;
  mModified := False;
  mStream.Seek(Longint(0), soFromBeginning);
end;

destructor TSFBDSBlobStream.Destroy;
begin
  if (mModified) then
  begin
    mModified := false;

    if not (TBlobField(mField).Modified) then
      TBlobField(mField).Modified := True;

    TSFCustomBusinessData(mField.DataSet).NotifyCurrentRecModified;
    TSFCustomBusinessData(mField.DataSet).DataEvent(deFieldChange, NativeInt(mField));
  end;

  inherited;
end;

function TSFBDSBlobStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := mStream.Read(Buffer, Count);
end;

function TSFBDSBlobStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := mStream.Seek(Offset, Origin);
end;

procedure TSFBDSBlobStream.SetSize(NewSize: Longint);
begin
  mStream.SetSize(NewSize);
end;

function TSFBDSBlobStream.Write(const Buffer; Count: Longint): Longint;
begin
  mModified := True;
  if not(mField.DataSet.State in [dsEdit, dsInsert]) then
    SFBDSDataError(bdsErrNotInsertEdit, []);

  Result := 0;
  if (Count > 0) then
    Result := mStream.Write(Buffer, Count);
end;


// ===========================================================================//
//                            TSFBusinessClassItem                            //
// ===========================================================================//

constructor TSFBusinessClassItem.Create(pName: string; pClass: TSFBusinessClass);
begin
  inherited Create;

  mName := pName;
  mClass := pClass;
end;

// ===========================================================================//
//                           TSFBusinessClassFactory                          //
// ===========================================================================//

class procedure TSFBusinessClassFactory.RegisterClass(pCls: TSFBusinessClass; pName: String);
  var lNewItem: TSFBusinessClassItem;
begin
  if (GetClassByName(pName) = nil) then
  begin
    if not(Assigned(cClasses)) then
      cClasses := TObjectList<TSFBusinessClassItem>.Create;

    lNewItem := TSFBusinessClassItem.Create(pName, pCls);
    cClasses.Add(lNewItem);
  end else
    SFBDSDataError(bdsErrClassExists, [pName]);
end;

class function TSFBusinessClassFactory.GetClassByName(pName: String): TSFBusinessClass;
  var i: Integer;
begin
  Result := nil;

  if not(Assigned(cClasses)) then
    Exit;

  for i := 0 to (cClasses.Count - 1) do
  begin
    if (UpperCase(cClasses[i].mName) = UpperCase(pName)) then
    begin
      Result := cClasses[i].mClass;
      Exit;
    end;
  end;
end;

class function TSFBusinessClassFactory.GetBusinessDataObj(pName: String; pCatalog: String = '';
    pSchema: String = ''; pAltClass: TSFBusinessClass = nil; pOwner: TComponent = nil): TSFCustomBusinessData;
  var lCls: TSFBusinessClass;
begin
  lCls := GetClassByName(pName);
  if (lCls <> nil) then
    Result := lCls.Create(pOwner)
  else if (pAltClass <> nil) then
    Result := pAltClass.Create(pName, pCatalog, pSchema, pOwner)
  else
    Result := TSFCustomBusinessData.Create(pName, pCatalog, pSchema, pOwner);
end;

// ===========================================================================//
//                            TSFCustomBusinessData                           //
// ===========================================================================//

constructor TSFCustomBusinessData.Create(pOwner: TComponent);
begin
  inherited;

  mSelect := nil;
  mRecordSize := 0;
  mRecordBlobsOffset := 0;
  mRecordFldDataOffset := 0;
  mRecordCalcFldOffset := 0;
  mCurrentRecIdx := -1;
  Finalize(mRecordInfos);
  Finalize(mRecCache);
  Finalize(mRecSaved);
  Finalize(mRecMapList);
  Finalize(mFieldMaps);

  mCurrEditBuffer := 0;
  mFilterBuffer := 0;
  mTempBuffer := 0;
  mDeletedCount := 0;
  mAddedCount := 0;
  mRecAddedCount := 0;
  mFilteredCount := 0;

  mDataFullLoaded := False;
  mSelectConfigured := False;
  mBlobs := TObjectList<TMemoryStream>.Create;
  mStmt := TSFStmt.Create(Self);
  mStmt.SetSubComponent(True);
  mStmt.Name := GetTypeName(TypeInfo(TSFStmt));

  mStmtParamValues := TCollection.Create(TSFBDSStmtParamItem);

  mActiveStmt := nil;
  mUpdateMode := upWhereKeyOnly;
  mOnSetParams := nil;
  mOnCompareRecords := nil;
  mCachedUpdates := False;
  mUpdatesPending := False;
  mRefreshMode := refreshModeRow;
  mAutoValuesLst := TObjectList<TSFBDSAutoValueGenerator>.Create;
  mOnGetAutoValCls := nil;
  mCurrInsertIdx := 0;
  BookmarkSize := Sizeof(LongInt);
  mFormatOptions := TSFBDSFormatOptions.Create;
  mFormatOptions.QuoteType := Low(TSFBDSQuoteTypeDflt);
  mDynCalcFields := TObjectList<TField>.Create(True);
  mDynLkpFields := TObjectList<TField>.Create(True);

  mConnector := nil;
  TSFConnector.AddCommonConnectedProc(doOnConnectorMessage);

  mOnBeforeDBEditRow := nil;
  mOnAfterDBEditRow := nil;
  mOnBeforeDBInsertRow := nil;
  mOnAfterDBInsertRow := nil;
  mOnBeforeDBDeleteRow := nil;
  mOnAfterDBDeleteRow := nil;
  mOnBeforeRefreshRow := nil;
  mOnAfterRefreshRow := nil;
  mOnBeforeRefreshFull := nil;
  mOnAfterRefreshFull := nil;
end;

constructor TSFCustomBusinessData.Create;
begin
  Create(nil);
end;

constructor TSFCustomBusinessData.Create(pTableName, pCatalogName, pSchemaName: String; pOwner: TComponent = nil);
begin
  Create(pOwner);

  TableName := pTableName;
  CatalogName := pCatalogName;
  SchemaName := pSchemaName;
end;

destructor TSFCustomBusinessData.Destroy;
begin
  inherited;

  mBlobs.Clear;
  FreeAndNil(mBlobs);

  mDynCalcFields.Clear;
  FreeAndNil(mDynCalcFields);

  mDynLkpFields.Clear;
  FreeAndNil(mDynLkpFields);

  if (Assigned(mActiveStmt)) then
    FreeAndNil(mActiveStmt);

  Finalize(mRecordInfos);
  Finalize(mRecMapList);
  Finalize(mFieldMaps);

  clearCachedRecords(mRecCache);
  Finalize(mRecCache);

  clearCachedRecords(mRecSaved);
  Finalize(mRecSaved);

  if (mCurrEditBuffer <> 0) then
    freeAllocatedBuffer(mCurrEditBuffer);

  if (Assigned(mSelect)) then
    FreeAndNil(mSelect);

  mStmtParamValues.Clear;
  mStmtParamValues.Free;

  mAutoValuesLst.Clear;
  FreeAndNil(mAutoValuesLst);

  FreeAndNil(mFormatOptions);
end;

{$IFDEF NEXTGEN}

function TSFCustomBusinessData.AllocRecBuf: TRecBuf;
begin
  GetMem(Pointer(Result), mRecordSize);
  FillChar(Pointer(Result)^, mRecordSize, 0);
  InternalInitRecord(Result);
end;

procedure TSFCustomBusinessData.FreeRecBuf(var Buffer: TRecBuf);
begin
  if (Buffer <> 0) then
  begin
    resetRecBlobBuffers(Buffer);
    ReallocMem(Pointer(Buffer), 0);
  end;
end;

{$ELSE}

function TSFCustomBusinessData.AllocRecordBuffer: TRecordBuffer;
begin
  GetMem(Result, mRecordSize);
  FillChar(Result^, mRecordSize, 0);
  InternalInitRecord(TRecBuf(Result));
end;

procedure TSFCustomBusinessData.FreeRecordBuffer(var Buffer: TRecordBuffer);
begin
  if (Assigned(Buffer)) then
  begin
    resetRecBlobBuffers(TRecBuf(Buffer));
    ReallocMem(Buffer, 0);
  end;
end;

{$ENDIF NEXTGEN}

function TSFCustomBusinessData.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
  var lBlobDataArray, lBlobDataArrayCached: PSFBDSBlobDataArray;
      lDataStream: TMemoryStream;
      lCurrBuff: TRecBuf;
      lRecord: PSFBDSRecordData;
      lRecNo: Integer;
begin
  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff = 0) then
  begin
    lDataStream := TMemoryStream.Create;
    mBlobs.Add(lDataStream);
    Result := TSFBDSBlobStream.Create(Field, lDataStream);
  end else
  begin
    lBlobDataArray := PSFBDSBlobDataArray(PByte(lCurrBuff) + mRecordBlobsOffset);
    if (lBlobDataArray^[Field.Offset] <> nil) and (mBlobs.IndexOf(lBlobDataArray^[Field.Offset]) >= 0) then
      lDataStream := lBlobDataArray^[Field.Offset]
    else
    begin
      lRecord := PSFBDSRecordData(lCurrBuff);
      lRecNo := lRecord^.rdRecordNumber;
      if (lRecord^.rdUpdateState <> usInserted) and (Length(mRecMapList) > 0) and (lRecNo >= Low(mRecMapList)) and (lRecNo <= High(mRecMapList)) then
      begin
        if (mRecordInfos[mRecMapList[lRecNo]].riRecType = rtData) then
        begin
          lDataStream := TMemoryStream.Create;
          mBlobs.Add(lDataStream);

          selectQuery.RecNo := mRecordInfos[mRecMapList[lRecNo]].riRef;
          if (Assigned(selectQuery.Fields.FieldByNumber(Field.FieldNo))) then
            TBlobField(selectQuery.Fields.FieldByNumber(Field.FieldNo)).SaveToStream(lDataStream);
        end else
        if (mRecordInfos[mRecMapList[lRecNo]].riRecType = rtCache) then
        begin
          lDataStream := TMemoryStream.Create;
          mBlobs.Add(lDataStream);

          lBlobDataArrayCached := PSFBDSBlobDataArray(PByte(mRecCache[mRecordInfos[mRecMapList[lRecNo]].riRef]) + mRecordBlobsOffset);
          if (lBlobDataArrayCached^[Field.Offset] <> nil) and (mBlobs.IndexOf(lBlobDataArrayCached^[Field.Offset]) >= 0) then
            TMemoryStream(lBlobDataArrayCached^[Field.Offset]).SaveToStream(lDataStream);
        end else
        begin
          lDataStream := TMemoryStream.Create;
          mBlobs.Add(lDataStream);
        end;
      end else
      begin
        lDataStream := TMemoryStream.Create;
        mBlobs.Add(lDataStream);
      end;

      lBlobDataArray^[Field.Offset] := lDataStream;
    end;

    Result := TSFBDSBlobStream.Create(Field, lDataStream);
  end;

  if (Assigned(Result)) and (Mode = bmWrite) then
    TSFBDSBlobStream(Result).SetSize(0);
end;

function TSFCustomBusinessData.GetCurrentRecord(Buffer: TRecBuf): Boolean;
begin
  if not(IsEmpty) and (GetBookmarkFlag(ActiveBuffer) = bfCurrent) then
  begin
    UpdateCursorPos;
    copyRecBuffer(ActiveBuffer, Buffer);
    Result := True;
  end else
    Result := False;
end;

function TSFCustomBusinessData.Locate(const KeyFields: string; const KeyValues: Variant;
                                      Options: TLocateOptions): Boolean;
  var lLocatedRecIdx: Integer;
begin
  Result := False;

  DoBeforeScroll;
  lLocatedRecIdx := doLocate(KeyFields, KeyValues, Options, 0);
  if (lLocatedRecIdx >= 0) then
  begin
    Result := True;
    mCurrentRecIdx := lLocatedRecIdx;
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

function TSFCustomBusinessData.LocateNext(const KeyFields: string; const KeyValues: Variant;
                                          Options: TLocateOptions): Boolean;
  var lLocatedRecIdx: Integer;
begin
  Result := False;

  DoBeforeScroll;
  lLocatedRecIdx := doLocate(KeyFields, KeyValues, Options, mCurrentRecIdx + 1);
  if (lLocatedRecIdx >= 0) then
  begin
    Result := True;
    mCurrentRecIdx := lLocatedRecIdx;
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

function TSFCustomBusinessData.Lookup(const KeyFields: string; const KeyValues: Variant;
                                      const ResultFields: string): Variant;
  var lLocatedRecIdx: Integer;
begin
  Result := NULL;

  DoBeforeScroll;
  lLocatedRecIdx := doLocate(KeyFields, KeyValues, [], 0);
  if (lLocatedRecIdx >= 0) then
  begin
    mCurrentRecIdx := lLocatedRecIdx;
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
    if (ResultFields <> '') then
      Result := FieldValues[ResultFields];
  end;
end;

procedure TSFCustomBusinessData.Prepare;
begin
  if not(isPureCached) then
  begin
    if not(mSelectConfigured) then
      configSelect(False);
    if (selectQuery.FieldDefs.Count <> FieldDefs.Count) then
      InternalInitFieldDefs;
  end else
    InternalInitFieldDefs;
end;

function TSFCustomBusinessData.BookmarkValid(Bookmark: TBookmark): Boolean;
  var lRecNo: Integer;
begin
  Result := False;

  if not(Assigned(Bookmark)) then
    Exit;

  Move(Bookmark[0], lRecNo, SizeOf(lRecNo));
  Result := (lRecNo >= Low(mRecMapList)) and (lRecNo <= High(mRecMapList));
  Result := Result and isVisibleRecInfo(mRecordInfos[mRecMapList[lRecNo]], Filtered);
end;

function TSFCustomBusinessData.GetFieldData(Field : TField; var Buffer: TValueBuffer) : Boolean;
  var lCurrBuff: TRecBuf;
begin
  // set data from current recordbuffer to given fieldbuffer
  Result := False;
  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff <> 0) then
  begin
    if (Field.FieldNo < 0) then
    begin
      if (Field.FieldKind = fkAggregate) then
        Exit;

      // fkCalculated, fkLookup
      Result := Boolean(PByte(lCurrBuff)[mRecordCalcFldOffset + Field.Offset]);
      if (Result) and (Buffer <> nil) then
        Move(PByte(lCurrBuff)[mRecordCalcFldOffset + Field.Offset + 1], PByte(Buffer)[0], Field.DataSize);
    end else
    begin
      Result := not PSFBDSRecordData(lCurrBuff)^.rdFields[Field.FieldNo].fdDataIsNull;
      if (Result) and (Buffer <> nil) then
        Move(PByte(lCurrBuff)[PSFBDSRecordData(lCurrBuff)^.rdFields[Field.FieldNo].fdDataOfs], PByte(Buffer)[0], Field.DataSize);
    end;
  end;
end;

procedure TSFCustomBusinessData.SetFiltered(Value: Boolean);
begin
  if (Active) then
  begin
    CheckBrowseMode;
    if (Filtered <> Value) then
    begin
      inherited SetFiltered(Value);

      mFilteredCount := 0;
      if (Filtered) then
        Refilter
      else
        First;
    end;
  end else
    inherited SetFiltered(Value);
end;

procedure TSFCustomBusinessData.SortBuffer;
begin
  if (Active) then
  begin
    CheckBrowseMode;

    loadRecordInfosFromData(getMaxRecInfoCount);
    doSortBuffer(0, Length(mRecordInfos) - 1);
    First;
  end;
end;

procedure TSFCustomBusinessData.ApplyUpdates;
  var i: Integer;
      lRecBufOrg, lTempBuffSave, lEditBuffSave: TRecBuf;
      lDataRefOrg: LongInt;
      lFreeRecBufOrg, lNeedCancel: Boolean;
      lBookmark: TBookmark;
begin
  if not(mCachedUpdates) then
    Exit;
  if (State in [dsEdit, dsInsert]) then
    Post;

  lBookmark := Bookmark;
  for i := Low(mRecordInfos) to High(mRecordInfos) do
  begin
    lNeedCancel := False;
    case mRecordInfos[i].riCachedUpdateState of
      usDeleted, usModified:
        begin
          lRecBufOrg := 0;
          lDataRefOrg := -1;
          if (mRecordInfos[i].riRefSaved >= 0) and (mRecordInfos[i].riRefSaved >= Low(mRecSaved)) and (mRecordInfos[i].riRefSaved <= High(mRecSaved)) then
            lRecBufOrg := mRecSaved[mRecordInfos[i].riRefSaved]
          else if (mRecordInfos[i].riRefDataUpd >= 0) then
            lDataRefOrg := mRecordInfos[i].riRefDataUpd
          else if (mRecordInfos[i].riRecType = rtCache) and (mRecordInfos[i].riRef >= Low(mRecCache)) and (mRecordInfos[i].riRef <= High(mRecCache)) then
            lRecBufOrg := mRecCache[mRecordInfos[i].riRef]
          else
            lDataRefOrg := mRecordInfos[i].riRef;

          lFreeRecBufOrg := False;
          if (lDataRefOrg >= 0) then
          begin
            lRecBufOrg := allocateNewRecordBuffer;

            selectQuery.RecNo := lDataRefOrg;
            loadCurrentSelectRowToBuffer(selectQuery, lRecBufOrg, i);
            lFreeRecBufOrg := True;
          end;

          if (lRecBufOrg > 0) then
          begin
            if (mRecordInfos[i].riCachedUpdateState = usDeleted) then
            begin
              lTempBuffSave := mTempBuffer;
              mTempBuffer := lRecBufOrg;
              try
                if (isPureCached) or (executeDelete) then
                begin
                  mRecordInfos[i].riUpdateState := usDeleted;
                  PSFBDSRecordData(lRecBufOrg)^.rdUpdateState := usDeleted;
                end else
                  lNeedCancel := True;
              finally
                mTempBuffer := lTempBuffSave;
              end;
            end else
            if not(isPureCached) and (mRecordInfos[i].riRecType = rtCache) and
              (mRecordInfos[i].riRef >= Low(mRecCache)) and (mRecordInfos[i].riRef <= High(mRecCache)) then
            begin
              lTempBuffSave := mTempBuffer;
              lEditBuffSave := mCurrEditBuffer;
              mCurrEditBuffer := lRecBufOrg;
              mTempBuffer := allocateNewRecordBuffer;
              copyRecBuffer(mRecCache[mRecordInfos[i].riRef], mTempBuffer);
              try
                if (executeEdit) then
                begin
                  refreshRow(mRecCache[mRecordInfos[i].riRef], i);

                  if (PSFBDSRecordData(mRecCache[mRecordInfos[i].riRef])^.rdRecordNumber < 0) then
                    PSFBDSRecordData(mRecCache[mRecordInfos[i].riRef])^.rdRecordNumber := mapIdByRecIdx(i);
                end else
                  lNeedCancel := True;
              finally
                mCurrEditBuffer := lEditBuffSave;
                freeAllocatedBuffer(mTempBuffer);
                mTempBuffer := lTempBuffSave;
              end;
            end;

            if (lFreeRecBufOrg) then
              freeAllocatedBuffer(lRecBufOrg);
          end;
        end;
      usInserted:
        begin
          if not(isPureCached) and (mRecordInfos[i].riRecType = rtCache) and
            (mRecordInfos[i].riRef >= Low(mRecCache)) and (mRecordInfos[i].riRef <= High(mRecCache)) then
          begin
            lTempBuffSave := mTempBuffer;
            mTempBuffer := allocateNewRecordBuffer;
            copyRecBuffer(mRecCache[mRecordInfos[i].riRef], mTempBuffer);
            try
              if (executeInsert) then
              begin
                refreshRow(mRecCache[mRecordInfos[i].riRef], i);
                if (PSFBDSRecordData(mRecCache[mRecordInfos[i].riRef])^.rdRecordNumber < 0) then
                  PSFBDSRecordData(mRecCache[mRecordInfos[i].riRef])^.rdRecordNumber := mapIdByRecIdx(i);
              end else
                lNeedCancel := True;
            finally
              freeAllocatedBuffer(mTempBuffer);
              mTempBuffer := lTempBuffSave;
            end;
          end;
        end;
    end;

    if (lNeedCancel) then
      doCancelUpdatesSingle(i)
    else
    begin
      mRecordInfos[i].riCachedUpdateState := usUnmodified;
      mRecordInfos[i].riRefSaved := -1;
      mRecordInfos[i].riRefDataUpd := -1;
    end;
  end;

  clearCachedRecords(mRecSaved);
  Finalize(mRecSaved);

  mUpdatesPending := False;
  if not(isPureCached) then
    mCurrInsertIdx := 0;
  if (BookmarkValid(lBookmark)) then
    Bookmark := lBookmark
  else
    First;
end;

procedure TSFCustomBusinessData.CancelUpdates;
  var i: Integer;
      lBookmark: TBookmark;
begin
  if not(mCachedUpdates) then
    Exit;
  if (State in [dsEdit, dsInsert]) then
    Cancel;

  lBookmark := Bookmark;
  for i := Low(mRecordInfos) to High(mRecordInfos) do
    doCancelUpdatesSingle(i);

  clearCachedRecords(mRecSaved);
  Finalize(mRecSaved);

  mUpdatesPending := False;
  if not(isPureCached) then
    mCurrInsertIdx := 0;
  if (BookmarkValid(lBookmark)) then
    Bookmark := lBookmark
  else
    First;
end;

procedure TSFCustomBusinessData.FullRefresh;
  var lSearchFields: String;
      i: Integer;
      lField: TField;
      lSearchValues: Array of Variant;
begin
  if (isPureCached) then
    Exit;

  if not(Active) then
  begin
    if (State = dsInactive) then
      Open;

    Exit;
  end;

  CheckBrowseMode;

  if (mCachedUpdates) and (mUpdatesPending) then
    SFBDSDataError(bdsErrFullRefreshWithUpd, []);

  BeforeRefreshFull;

  lSearchFields := '';
  Finalize(lSearchValues);
  for i := Low(mFieldMaps) to High(mFieldMaps) do
  begin
    if not(mFieldMaps[i].fimIsKeyField) then
      Continue;
    lField := FindField(mFieldMaps[i].fimFieldName);
    if (Assigned(lField)) then
    begin
      if (lSearchFields <> '') then
        lSearchFields := lSearchFields + ';';
      lSearchFields := lSearchFields + lField.FieldName;

      SetLength(lSearchValues, Length(lSearchValues) + 1);
      lSearchValues[Length(lSearchValues) - 1] := lField.Value;
    end;
  end;

  Close;
  Open;
  if (lSearchFields <> '') and (Length(lSearchValues) > 0) then
    Locate(lSearchFields, VarArrayOf(lSearchValues), [loCaseInsensitive]);

  AfterRefreshFull;
end;

procedure TSFCustomBusinessData.Refilter;
  var lStart, lMax: Integer;
      lTmpBuf: TRecBuf;
      lAccept: Boolean;
      lSaveState: TDataSetState;
begin
  if not(Filtered) or not(Active) then
    Exit;

  CheckBrowseMode;

  mFilteredCount := 0;
  loadRecordInfosFromData(getMaxRecInfoCount);

  lStart := Low(mRecordInfos) - 1;
  lMax := High(mRecordInfos);

  while (lStart < lMax) do
  begin
    lTmpBuf := allocateNewRecordBuffer;
    try
      if (InternalGetRecord(lTmpBuf, gmNext, False, False, lStart) <> grOk) then
        Break;

      lSaveState := SetTempState(dsFilter);
      mFilterBuffer := lTmpBuf;
      try
        lAccept := True;
        FilterRecord(lAccept);
        if not(lAccept) then
        begin
          mRecordInfos[lStart].riFiltered := True;
          inc(mFilteredCount);
        end else
          mRecordInfos[lStart].riFiltered := False;
      finally
        RestoreState(lSaveState);
        mFilterBuffer := 0;
      end;
    finally
      freeAllocatedBuffer(lTmpBuf);
    end;
  end;

  First;
end;

function TSFCustomBusinessData.AddAutoValueForField(pFieldName: String; pAutoValueClass: TSFBDSAutoValueGeneratorCls): TSFBDSAutoValueGenerator;
begin
  Result := GetAutoValueForField(pFieldName);
  if (Result <> nil) then
    Exit;

  if (pAutoValueClass <> nil) then
    Result := pAutoValueClass.Create
  else
    Result := GetAutoValueCls(pFieldName, False).Create;

  Result.mDataSet := Self;
  Result.mFieldName := pFieldName;

  detectAndSetAutoValueOptions(Result);

  mAutoValuesLst.Add(Result);
end;

function TSFCustomBusinessData.GetAutoValueForField(pFieldName: String): TSFBDSAutoValueGenerator;
  var i: Integer;
begin
  for i := 0 to (mAutoValuesLst.Count - 1) do
  begin
     Result := mAutoValuesLst[i];
     if (AnsiCompareText(Result.FieldName, pFieldName) = 0) then
      Exit;
  end;

  Result := nil;
end;

function TSFCustomBusinessData.AddField(pFieldName: String; pDataType: TFieldType; pSize: Integer;
                pPrecision: Integer = 0; pRequired: Boolean = False; pReadOnly: Boolean = False): TField;
  var lFldCls: TFieldClass;
begin
  Result := nil;

  if (Active) or (Trim(pFieldName) = '') or (pDataType = ftUnknown) then
    Exit;

  lFldCls := GetFieldClass(pDataType);
  if (lFldCls <> nil) then
  begin
    Result := lFldCls.Create(Self);
    Result.Size := pSize;
    Result.FieldName := pFieldName;
    Result.Required := pRequired;
    Result.ReadOnly := pReadOnly;
    Result.SetFieldType(pDataType);
    if (Result is TBCDField) then
      TBCDField(Result).Precision := pPrecision
    else if (Result is TFMTBCDField) then
      TFMTBCDField(Result).Precision := pPrecision;
    Result.DataSet := Self;

    checkFieldFormats(Result, nil);
  end;
end;

procedure TSFCustomBusinessData.InitFieldsFromBusinessData(pTabObjName: String; pCatalog, pSchema: String;
                                        pPreventAutoValues, pPreventReadOnly, pPreventRequired: Boolean);
  var lObj: TSFCustomBusinessData;
begin
  if (Active) or (Trim(pTabObjName) = '') then
    Exit;

  lObj := TSFBusinessClassFactory.GetBusinessDataObj(pTabObjName, pCatalog, pSchema);
  try
    if (Assigned(lObj)) then
    begin
      lObj.Connector := Connector;
      lObj.FormatOptions.QuoteType := FormatOptions.QuoteType;
      lObj.Transaction := Transaction;
      lObj.UpdateTransaction := UpdateTransaction;

      InitFieldsFromBusinessData(lObj, pPreventAutoValues, pPreventReadOnly, pPreventRequired);
    end;
  finally
    if (Assigned(lObj)) then
      FreeAndNil(lObj);
  end;
end;

procedure TSFCustomBusinessData.InitFieldsFromBusinessData(pObj: TSFCustomBusinessData;
                      pPreventAutoValues, pPreventReadOnly, pPreventRequired: Boolean);
  var i: Integer;
      lDataType: TFieldType;
begin
  if (Active) or not(Assigned(pObj)) then
    Exit;

  if not(pObj.Active) then
    pObj.FieldDefs.Update;

  for i := 0 to (pObj.FieldDefs.Count - 1) do
  begin
    lDataType := pObj.FieldDefs[i].DataType;
    if (pPreventAutoValues) and (lDataType = ftAutoInc) then
      lDataType := ftInteger;

    AddField(pObj.FieldDefs[i].Name, lDataType, pObj.FieldDefs[i].Size, pObj.FieldDefs[i].Precision,
              (TFieldAttribute(faRequired) in pObj.FieldDefs[i].Attributes) and not pPreventRequired,
              (TFieldAttribute(faReadOnly) in pObj.FieldDefs[i].Attributes) and not pPreventReadOnly);
  end;
end;

procedure TSFCustomBusinessData.AllBaseFieldsToStmt(pOnlySearch: Boolean = False);
  var lBaseTblFlds: TStringList;
      i: Integer;
begin
  if (Active) or (Trim(mTableName) = '') or not(Assigned(mStmt.BaseTable)) then
    Exit;

  lBaseTblFlds := GetBaseTableFields;
  try
    if not(Assigned(lBaseTblFlds)) then
      Exit;

    for i := 0 to (lBaseTblFlds.Count - 1) do
    begin
      if not(mStmt.AttrExists(lBaseTblFlds[i], mStmt.BaseTable.TableAlias, '')) then
        mStmt.SetStmtAttr(lBaseTblFlds[i], '', mStmt.BaseTable, pOnlySearch);
    end;
  finally
    if (Assigned(lBaseTblFlds)) then
      FreeAndNil(lBaseTblFlds);
  end;
end;

procedure TSFCustomBusinessData.AddDynCalcField(pFieldName: String; pDataType: TFieldType;
                                                pSize: Integer; pPrecision: Integer = 0);
  var lField: TField;
begin
  if (Active) or (Trim(pFieldName) = '') or (pDataType = ftUnknown) then
    Exit;

  lField := createDynCalcField(pFieldName, GetFieldClass(pDataType), pDataType, pSize, pPrecision);
  if (lField <> nil) then
    mDynCalcFields.Add(lField);
end;

procedure TSFCustomBusinessData.AddDynLkpField(pFieldName: String; pDataType: TFieldType; pLkpDs: TDataSet;
                              pKeyFlds, pLkpKeyFlds, pLkpRsltFld: String; pCached: Boolean;
                              pSize: Integer; pPrecision: Integer = 0);
  var lField: TField;
begin
  if (Active) or (Trim(pFieldName) = '') or (pDataType = ftUnknown) then
    Exit;

  lField := createDynLkpField(pFieldName, GetFieldClass(pDataType), pDataType,
                              pLkpDs, pKeyFlds, pLkpKeyFlds, pLkpRsltFld,
                              pCached, pSize, pPrecision);

  if (lField <> nil) then
    mDynLkpFields.Add(lField);
end;

function TSFCustomBusinessData.HasDynCalcField(pFieldName: String): Boolean;
  var i: Integer;
begin
  for i := 0 to (mDynCalcFields.Count - 1) do
  begin
    Result := (AnsiCompareText(mDynCalcFields[i].FieldName, pFieldName) = 0);
    if (Result) then
      Exit;
  end;

  Result := False;
end;

function TSFCustomBusinessData.HasDynLkpField(pFieldName: String): Boolean;
  var i: Integer;
begin
  for i := 0 to (mDynLkpFields.Count - 1) do
  begin
    Result := (AnsiCompareText(mDynLkpFields[i].FieldName, pFieldName) = 0);
    if (Result) then
      Exit;
  end;

  Result := False;
end;

procedure TSFCustomBusinessData.RecalcCalculatedFields;
  var lCurrBuff: TRecBuf;
begin
  if not(Active) then
    Exit;

  if not(State in [dsInsert, dsEdit]) then
  begin
    lCurrBuff := detectCurrentBuffer;
    InternalSetToRecord(lCurrBuff);
    Resync([rmExact]);
  end else
    GetCalcFields(ActiveBuffer);
end;

function TSFCustomBusinessData.DatabaseNameForFieldName(pFieldName: String; var pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName: String): Boolean;
  var lField: TField;
begin
  Result := False;

  pTableAlias := '';
  pTableName := '';
  pTableSchema := '';
  pTableCatalog := '';
  pAttrName := '';

  if (pFieldName = '') or not(Assigned(activeStmt.BaseTable)) then
    Exit;

  lField := FindField(pFieldName);
  if not(Assigned(lField)) or (lField.FieldNo < 0) then
    Exit;

  Result := getDatabaseNameForFieldName(lField.FieldName, activeStmt, pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName);
end;

function TSFCustomBusinessData.SelectNameForIdentifier(pIdentifier: String; var pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName: String): String;
begin
  Result := '';

  pTableAlias := '';
  pTableName := '';
  pTableSchema := '';
  pTableCatalog := '';
  pAttrName := '';

  if (pIdentifier = '') or not(Assigned(activeStmt.BaseTable)) then
    Exit;

  if (getDatabaseNameForFieldName(pIdentifier, activeStmt, pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName)) then
  begin
    Result := activeStmt.AttrDisplayName(pAttrName, pTableAlias);
    if (Result = '') then
      Result := pAttrName;
  end;
end;

function TSFCustomBusinessData.FieldNameForDBField(pDBFieldName: String; pOnlyBaseFields: Boolean): String;
  var i: Integer;
begin
  Result := '';

  if (Length(mFieldMaps) = 0) then
    Exit;

  for i := Low(mFieldMaps) to High(mFieldMaps) do
  begin
    if (pOnlyBaseFields) and not(mFieldMaps[i].fimIsBaseField) then
      Continue;

    if (AnsiCompareText(mFieldMaps[i].fimDBFieldName, pDBFieldName) = 0) then
    begin
      Result := mFieldMaps[i].fimFieldName;
      Exit;
    end;
  end;
end;

function TSFCustomBusinessData.GetLikeWildcardSingle: String;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  Result := '';
  if not(isPureCached) then
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectLikeWildcardSingle;
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetLikeWildcardMany: String;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  Result := '';
  if not(isPureCached) then
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectLikeWildcardMany;
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetSupportsLikeEscape: Boolean;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  Result := False;
  if not(isPureCached) then
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectLikeSupportsEscape;
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

procedure TSFCustomBusinessData.ExchangeRecordPositions(pFrom, pTo: Integer);
  var lRecIdxFrom, lRecIdxTo: Integer;
begin
  if (Active) then
  begin
    CheckBrowseMode;

    lRecIdxFrom := recIdxByRecNo(pFrom);
    lRecIdxTo := recIdxByRecNo(pTo);

    if (lRecIdxFrom >= Low(mRecordInfos)) and (lRecIdxFrom <= High(mRecordInfos))
    and (lRecIdxTo >= Low(mRecordInfos)) and (lRecIdxTo <= High(mRecordInfos)) then
    begin
      excangeRecInfos(lRecIdxFrom, lRecIdxTo);
      mCurrentRecIdx := lRecIdxTo;
      Resync([rmCenter]);
      DoAfterScroll;
    end;
  end;
end;

procedure TSFCustomBusinessData.RefreshStmtParamValues;
begin
  StmtParamValues;
end;

function TSFCustomBusinessData.GetCanSelectWithoutTable(var pDummyTable: String): Boolean;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  if (isPureCached) then
    Result := False
  else
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectCanSelWithoutTab(pDummyTable);
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetCanSubSelectInFrom: Boolean;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  if (isPureCached) then
    Result := False
  else
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectCanSubInFrom;
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetNeedTableOnSubSelectInFrom: Boolean;
  var lDBDialectSave: TSFStmtDBDialect;
begin
  if (isPureCached) then
    Result := False
  else
  begin
    lDBDialectSave := mStmt.DBDialect;
    try
      mStmt.DBDialect := MappedStmtDBDialect;
      Result := mStmt.GetDBDialectNeedTableOnSubInFrom;
    finally
      mStmt.DBDialect := lDBDialectSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetRecord(Buffer: TRecBuf; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
  var lAccept: Boolean;
      lSaveState: TDataSetState;
begin
  Result := grOK;
  if (Filtered) then
  begin
    lAccept := False;
    while not(lAccept) do
    begin
      Result := InternalGetRecord(Buffer, GetMode, DoCheck, Filtered, mCurrentRecIdx);
      if (Result <> grOK) then
        Break;

      lSaveState := SetTempState(dsFilter);
      mFilterBuffer := Buffer;
      try
        lAccept := True;
        FilterRecord(lAccept);
        if not(lAccept) then
        begin
          if (GetMode = gmCurrent) then
            GetMode := gmPrior;

          if not(mRecordInfos[mCurrentRecIdx].riFiltered) then
          begin
            mRecordInfos[mCurrentRecIdx].riFiltered := True;
            inc(mFilteredCount);
          end;
        end;
      finally
        RestoreState(lSaveState);
        mFilterBuffer := 0;
      end;
    end;
  end else
    Result := InternalGetRecord(Buffer, GetMode, DoCheck, Filtered, mCurrentRecIdx);
end;

function TSFCustomBusinessData.InternalGetRecord(Buffer: TRecBuf; GetMode: TGetMode; DoCheck, CheckFiltered: Boolean; var pRecIdx: Integer): TGetResult;
  var lRecCacheIdx: Integer;
begin
  // load record to given buffer
  Result := grError;

  case GetMode of
    gmCurrent:
      begin
        if (pRecIdx < 0) then
          Result := grBOF
        else if (pRecIdx >= getMaxRecInfoCount) then
          Result := grEOF
        else
        begin
          pRecIdx := getNextVisibleRecInfo(pRecIdx, CheckFiltered);
          if (pRecIdx < getMaxRecInfoCount) then
            Result := grOK
          else
            Result := grEOF;
        end;
      end;
    gmNext:
      begin
        if (pRecIdx >= (getMaxRecInfoCount - 1)) then
          Result := grEOF
        else
        begin
          inc(pRecIdx);
          pRecIdx := getNextVisibleRecInfo(pRecIdx, CheckFiltered);
          if (pRecIdx < getMaxRecInfoCount) then
            Result := grOK
          else
            Result := grEOF;
        end;
      end;
    gmPrior:
      begin
        if (pRecIdx <= 0) then
          Result := grBOF
        else
        begin
          dec(pRecIdx);
          pRecIdx := getPriorVisibleRecInfo(pRecIdx, CheckFiltered);
          if (pRecIdx >= 0) then
            Result := grOK
          else
            Result := grBOF;
        end;
      end;
  end;

  if (Result = grOK) then
  begin
    loadRecordInfosFromData(pRecIdx + 1);
    if (mRecordInfos[pRecIdx].riRecType = rtData) then
    begin
      selectQuery.RecNo := mRecordInfos[pRecIdx].riRef;
      loadCurrentSelectRowToBuffer(selectQuery, Buffer, pRecIdx);
    end else
    if (mRecordInfos[pRecIdx].riRecType = rtCache) then
    begin
      InternalInitRecord(Buffer);
      lRecCacheIdx := mRecordInfos[pRecIdx].riRef;
      if (lRecCacheIdx >= Low(mRecCache)) and (lRecCacheIdx <= High(mRecCache)) then
      begin
        copyRecBuffer(mRecCache[lRecCacheIdx], Buffer);
        PSFBDSRecordData(Buffer)^.rdRecordNumber := mapIdByRecIdx(pRecIdx);
      end;
    end else
      InternalInitRecord(Buffer);

    PSFBDSRecordData(Buffer)^.rdBookmarkFlag := bfCurrent;
    GetCalcFields(Buffer);
  end else
  if (Result = grBOF) then
  begin
    InternalInitRecord(Buffer);
    PSFBDSRecordData(Buffer)^.rdBookmarkFlag := bfBOF;
  end else
  begin
    InternalInitRecord(Buffer);
    PSFBDSRecordData(Buffer)^.rdBookmarkFlag := bfEOF;
  end;
end;

procedure TSFCustomBusinessData.SetFieldData(Field: TField; Buffer: TValueBuffer);
  var lCurrBuff: TRecBuf;
begin
  // set data from given fieldbuffer to current recordbuffer
  if not(State in dsWriteModes) then
    SFBDSDataError(bdsErrNoWriteInMode, []);

  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff <> 0) then
  begin
    if (Field.FieldNo < 0) then
    begin
      if (Field.FieldKind = fkAggregate) then
        Exit;

      // fkCalculated, fkLookup
      Boolean(PByte(lCurrBuff)[mRecordCalcFldOffset + Field.Offset]) := Buffer <> nil;
      if (Boolean(PByte(lCurrBuff)[mRecordCalcFldOffset + Field.Offset])) then
        Move(PByte(Buffer)[0], PByte(lCurrBuff)[mRecordCalcFldOffset + Field.Offset + 1], Field.DataSize);
    end else
    begin
      Field.Validate(Buffer);
      if (Buffer = nil) then
        PSFBDSRecordData(lCurrBuff)^.rdFields[Field.FieldNo].fdDataIsNull := True
      else
      begin
        PSFBDSRecordData(lCurrBuff)^.rdFields[Field.FieldNo].fdDataIsNull := False;
        Move(PByte(Buffer)[0], PByte(lCurrBuff)[PSFBDSRecordData(lCurrBuff)^.rdFields[Field.FieldNo].fdDataOfs], Field.DataSize);
      end;

      if (State = dsInsert) then
        PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usInserted
      else
        PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usModified;

      SetModified(True);
    end;

    if not(State in [dsCalcFields, dsInternalCalc, dsFilter, dsNewValue]) then
      DataEvent(deFieldChange, IntPtr(Field));
  end;
end;

procedure TSFCustomBusinessData.ClearCalcFields(Buffer: NativeInt);
begin
  FillChar(PByte(Buffer)[mRecordCalcFldOffset], CalcFieldsSize, 0);
end;

function TSFCustomBusinessData.GetRecordSize: Word;
begin
  Result := mRecordSize;
end;

function TSFCustomBusinessData.GetRecordCount: Integer;
begin
  Result := getDataRecordCount + mAddedCount - mDeletedCount - mFilteredCount;
end;

function TSFCustomBusinessData.GetRecNo: Integer;
  var lCurrBuff: TRecBuf;
      lRecMapIdx: Integer;
begin
  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff = 0) then
    Result := 0
  else
  begin
    lRecMapIdx := PSFBDSRecordData(lCurrBuff)^.rdRecordNumber;
    if (lRecMapIdx >= Low(mRecMapList)) and (lRecMapIdx <= High(mRecMapList)) then
      Result := mRecMapList[lRecMapIdx]
    else
      Result := 0;

    if (Result >= 0) then
      Result := recNoForRecIdx(Result);
    if (Result < 0) then
      Result := 0;
  end;
end;

procedure TSFCustomBusinessData.SetRecNo(Value: Integer);
  var lRecIdx: Integer;
begin
  CheckBrowseMode;

  if (Value <> RecNo) then
  begin
    lRecIdx := recIdxByRecNo(Value);

    if (lRecIdx >= 0) then
    begin
      DoBeforeScroll;
      mCurrentRecIdx := lRecIdx;
      Resync([rmCenter]);
      DoAfterScroll;
    end;
  end;
end;

procedure TSFCustomBusinessData.InternalInitFieldDefs;
  var i: Integer;
      lFieldDef: TFieldDef;
begin
  FieldDefs.Clear;

  if not(isPureCached) then
  begin
    if not(mSelectConfigured) then
      configSelect(False);

    FieldDefs.BeginUpdate;
    try
      for i := 0 to (selectQuery.FieldDefs.Count - 1) do
      begin
        lFieldDef := FieldDefs.AddFieldDef;
        lFieldDef.Name := selectQuery.FieldDefs[i].Name;
        lFieldDef.DisplayName := selectQuery.FieldDefs[i].DisplayName;
        lFieldDef.FieldNo := selectQuery.FieldDefs[i].FieldNo;
        lFieldDef.DataType := selectQuery.FieldDefs[i].DataType;
        lFieldDef.Size := selectQuery.FieldDefs[i].Size;
        lFieldDef.Precision := selectQuery.FieldDefs[i].Precision;
        lFieldDef.Required := selectQuery.FieldDefs[i].Required;
        lFieldDef.InternalCalcField := selectQuery.FieldDefs[i].InternalCalcField;
        lFieldDef.Attributes := selectQuery.FieldDefs[i].Attributes;
      end;
    finally
      FieldDefs.EndUpdate;
    end;
  end else
  begin
    if (Fields.Count > 0) then
      InitFieldDefsFromFields;
  end;
end;

procedure TSFCustomBusinessData.CreateFields;
  var i: Integer;
      lSelQryFld: TField;
begin
  inherited;

  {$IFDEF VERSMALLER_XE6}
  createDynCalcFields;
  createDynLkpFields;
  {$ELSE}
  if (FieldOptions.AutoCreateMode <> acExclusive) or not(lcPersistent in Fields.LifeCycles) then
  begin
    createDynCalcFields;
    createDynLkpFields;
  end;
  {$ENDIF VERSMALLER_XE6}

  for i := 0 to (Fields.Count - 1) do
  begin
    lSelQryFld := nil;
    if not(isPureCached) then
      lSelQryFld := selectQuery.FindField(Fields[i].FieldName);

    checkFieldFormats(Fields[i], lSelQryFld);
  end;
end;

procedure TSFCustomBusinessData.InternalOpen;
  var i, lDataSize: Integer;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFBDSDataError(bdsErrBusinessDataDemoExpired, []);

  if (Assigned(mActiveStmt)) then
    FreeAndNil(mActiveStmt);

  configSelect(True);

  InternalInitFieldDefs;

  {$IFDEF VERSMALLER_XE6}
  if (DefaultFields) then
    CreateFields;
  {$ELSE}
  CreateFields;
  {$ENDIF VERSMALLER_XE6}

  BindFields(True);

  Finalize(mFieldMaps);
  bindBaseFields;

  bindAutoValues;

  // calc recordsize

  // 1. Size of recordinfos (first fieldinfo is included -> subtract)
  mRecordSize :=  SizeOf(TSFBDSRecordData) - SizeOf(TSFBDSFieldData);

  // 2. DataSize and Size for Fieldinfo for each field (Fieldvalues)
  lDataSize := 0;
  for i := 0 to (Fields.Count - 1) do
  begin
    // calculated fields without Fieldinfos
    if (Fields[i].FieldNo < 0) then
      Continue;

    // set space for fieldinfos
    mRecordSize := mRecordSize + SizeOf(TSFBDSFieldData);

    // Datasize for blobs will be calculated later
    if (Fields[i].IsBlob) then
      Continue;

    // set space for data
    lDataSize := lDataSize + Fields[i].DataSize;
  end;
  mRecordFldDataOffset := mRecordSize;
  mRecordSize := mRecordSize + lDataSize;

  // 3. calculated fields
  mRecordCalcFldOffset := mRecordSize;
  mRecordSize := mRecordSize + CalcFieldsSize;

  // 4. blob fields (save an instance from the blob-stream to the record)
  mRecordBlobsOffset := mRecordSize;
  mRecordSize := mRecordSize + BlobFieldCount * SizeOf(TMemoryStream);

  mCurrentRecIdx := -1;
  Finalize(mRecordInfos);
  Finalize(mRecMapList);

  clearCachedRecords(mRecCache);
  Finalize(mRecCache);

  clearCachedRecords(mRecSaved);
  Finalize(mRecSaved);

  mUpdatesPending := False;
  mBlobs.Clear;
  mDeletedCount := 0;
  mAddedCount := 0;
  mRecAddedCount := 0;
  mFilteredCount := 0;
  mDataFullLoaded := False;
  mCurrInsertIdx := 0;
end;

procedure TSFCustomBusinessData.DoAfterOpen;
begin
  inherited;

  if (Filtered) then
    Refilter;
end;

procedure TSFCustomBusinessData.InternalSetToRecord(Buffer: TRecBuf);
  var lMapIdx: Integer;
begin
  lMapIdx := PSFBDSRecordData(Buffer)^.rdRecordNumber;
  if (lMapIdx >= Low(mRecMapList)) and (lMapIdx <= High(mRecMapList)) then
    mCurrentRecIdx := mRecMapList[lMapIdx]
  else
    mCurrentRecIdx := -1;
end;

function TSFCustomBusinessData.IsCursorOpen: Boolean;
begin
  Result := not(isPureCached) and (hasActiveSelectQuery) or (isPureCached) and (mRecordSize > 0);
end;

procedure TSFCustomBusinessData.InternalClose;
begin
  mRecordSize := 0;
  mRecordBlobsOffset := 0;
  mRecordFldDataOffset := 0;
  mRecordCalcFldOffset := 0;
  mCurrentRecIdx := -1;
  Finalize(mRecordInfos);
  Finalize(mRecMapList);
  Finalize(mFieldMaps);

  clearCachedRecords(mRecCache);
  Finalize(mRecCache);

  clearCachedRecords(mRecSaved);
  Finalize(mRecSaved);

  mDeletedCount := 0;
  mAddedCount := 0;
  mRecAddedCount := 0;
  mFilteredCount := 0;

  mDataFullLoaded := False;
  mSelectConfigured := False;
  mUpdatesPending := False;
  mCurrInsertIdx := 0;

  mBlobs.Clear;
  if (mCurrEditBuffer <> 0) then
    freeAllocatedBuffer(mCurrEditBuffer);

  mFilterBuffer := 0;
  mTempBuffer := 0;

  removeDetectedAutoValues;

  enforceSelectClosed;

  if (Assigned(mActiveStmt)) then
    FreeAndNil(mActiveStmt);

  if not(csDestroying in ComponentState) then
  begin
    BindFields(False);

    {$IFDEF VERSMALLER_XE6}
    if (DefaultFields) then
      DestroyFields;
    {$ELSE}
    DestroyFields;
    {$ENDIF VERSMALLER_XE6}
  end;
end;

function TSFCustomBusinessData.GetCanModify: Boolean;
  var i: Integer;
begin
  Result := (mTableName <> '') and (mUpdateMode <> upWhereKeyOnly);
  if not(Result) and (mTableName <> '') and (mUpdateMode = upWhereKeyOnly) and (Length(mFieldMaps) > 0) then
  begin
    for i := Low(mFieldMaps) to High(mFieldMaps) do
    begin
      Result := mFieldMaps[i].fimIsKeyField;
      if (Result) then
        Exit;
    end;
  end;

  if not(Result) then
    Result := isPureCached;
end;

function TSFCustomBusinessData.GetKeyFields: String;
  var lDBDialectSave: TSFStmtDBDialect;
      lQuoteTypeSave: TSFStmtQuoteType;
begin
  Result := '';

  if (Assigned(ConnectorUsed)) and (mTableName <> '') then
  begin
    if (Assigned(activeStmt.BaseTable)) then
    begin
      // activeStmt.DBDialect := MappedStmtDBDialect;
      // activeStmt.QuoteType := QueryQuoteType;
      lDBDialectSave := activeStmt.DBDialect;
      lQuoteTypeSave := activeStmt.QuoteType;
      try
        activeStmt.DBDialect := stmtDBDDflt;
        activeStmt.QuoteType := stmtQuoteTypeNone;
        Result := ConnectorUsed.GetKeyFields(activeStmt.BaseTable.QuotedTableName, activeStmt.BaseTable.QuotedTableCatalog, activeStmt.BaseTable.QuotedTableSchema);
      finally
        activeStmt.DBDialect := lDBDialectSave;
        activeStmt.QuoteType := lQuoteTypeSave;
      end;
    end else
      Result := ConnectorUsed.GetKeyFields(mTableName, mCatalogName, mSchemaName);
  end;
end;

function TSFCustomBusinessData.GetBaseTableFields: TStringList;
begin
  if (Assigned(activeStmt.BaseTable)) then
    Result := GetBaseTableFields(activeStmt.BaseTable)
  else
    Result := GetBaseTableFields(mTableName, mSchemaName, mCatalogName);
end;

function TSFCustomBusinessData.GetBaseTableFields(pTableName, pSchemaName, pCatalogName: String): TStringList;
begin
  Result := nil;

  if (Assigned(ConnectorUsed)) and (pTableName <> '') then
    Result := ConnectorUsed.GetFieldNames(pTableName, pCatalogName, pSchemaName);
end;

function TSFCustomBusinessData.GetBaseTableFields(pStmtTable: TSFStmtTable): TStringList;
  var lDBDialectSave: TSFStmtDBDialect;
      lQuoteTypeSave: TSFStmtQuoteType;
begin
  Result := nil;

  if (Assigned(ConnectorUsed)) and (Assigned(pStmtTable)) then
  begin
    // pStmtTable.ParentStmt.DBDialect := MappedStmtDBDialect;
    // pStmtTable.ParentStmt.QuoteType := QueryQuoteType;
    lDBDialectSave := pStmtTable.ParentStmt.DBDialect;
    lQuoteTypeSave := pStmtTable.ParentStmt.QuoteType;
    try
      pStmtTable.ParentStmt.DBDialect := stmtDBDDflt;
      pStmtTable.ParentStmt.QuoteType := stmtQuoteTypeNone;
      Result := ConnectorUsed.GetFieldNames(pStmtTable.QuotedTableName, pStmtTable.QuotedTableCatalog, pStmtTable.QuotedTableSchema);
    finally
      pStmtTable.ParentStmt.DBDialect := lDBDialectSave;
      pStmtTable.ParentStmt.QuoteType := lQuoteTypeSave;
    end;
  end;
end;

function TSFCustomBusinessData.GetNameInBaseFieldsList(pName: String; pList: TStringList): Boolean;
  var lDBDialectSave: TSFStmtDBDialect;
      lQuoteTypeSave: TSFStmtQuoteType;
      lNameSearch: String;
begin
  Result := False;
  if not(Assigned(pList)) or (pList.Count = 0) or (pName = '') then
    Exit;

  // first search fieldname directly
  Result := (pList.IndexOf(pName) >= 0);
  if (Result) then
    Exit;

  // then search fieldname quoted with quotes from dbDialect
  lDBDialectSave := mStmt.DBDialect;
  lQuoteTypeSave := mStmt.QuoteType;
  try
    mStmt.DBDialect := MappedStmtDBDialect;
    mStmt.QuoteType := QueryQuoteType;
    Result := (pList.IndexOf(mStmt.GetQuotedIdentifier(pName)) >= 0);
  finally
    mStmt.DBDialect := lDBDialectSave;
    mStmt.QuoteType := lQuoteTypeSave;
  end;
  if (Result) then
    Exit;

  // then search fieldname quoted with default quotes
  lNameSearch := '''' + pName + '''';
  Result := (pList.IndexOf(lNameSearch) >= 0);
  if (Result) then
    Exit;

  lNameSearch := '"' + pName + '"';
  Result := (pList.IndexOf(lNameSearch) >= 0);
end;

procedure TSFCustomBusinessData.NotifyCurrentRecModified;
  var lCurrBuff: TRecBuf;
begin
  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff <> 0) then
  begin
    if (State = dsInsert) then
      PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usInserted
    else
      PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usModified;
  end;
end;

procedure TSFCustomBusinessData.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent <> nil) then
  begin
    if (AComponent = mConnector) then
      Connector := nil
    else if (AComponent = mTransaction) then
      mTransaction := nil
    else if (AComponent = mUpdateTransaction) then
      mUpdateTransaction := nil;
  end;
end;

function TSFCustomBusinessData.GetAutoValueCls(pFieldName: String; pAutoDetected: Boolean): TSFBDSAutoValueGeneratorCls;
begin
  Result := nil;

  if (Assigned(mOnGetAutoValCls)) then
    Result := mOnGetAutoValCls(pFieldName, pAutoDetected);

  if (Result = nil) then
    Result := TSFBDSAutoValueGenerator;
end;

function TSFCustomBusinessData.GetAutoValueOptionsForDBType(pDBType: TSFConnectionDBType; pMode: TSFBDSAutoValueGetMode): TSFBDSAutoValueOptions;
begin
  Result := [];

  case pDBType of
    dbtDB2:
      begin
        if (pMode = avGMBeforePost) then
          Result := [avoExecute, avoNeedSequence, avoPreventWhenAuto, avoPreventWhenExplicitByDBMS]
        else if (pMode = avGMAfterPost) then
          Result := [avoExecute, avoExecWhenAuto, avoExecWhenExplicitByDBMS];
      end;
    dbtFB, dbtIB:
      begin
        if (pMode = avGMBeforePost) then
          Result := [avoExecute, avoNeedSequence, avoPreventWhenAuto, avoPreventWhenExplicitByDBMS]
        else if (pMode = avGMAfterPost) then
          Result := [avoExecute, avoNeedSequence, avoExecWhenAuto, avoExecWhenExplicitByDBMS];
      end;
    dbtOra:
      begin
        if (pMode = avGMBeforePost) then
          Result := [avoExecute, avoNeedSequence];
      end;
    dbtSQLLite:
      begin
        if (pMode = avGMAfterPost) then
          Result := [avoExecute, avoNeedTable];
      end;
    else
    begin
      if (pMode = avGMAfterPost) then
        Result := [avoExecute];
    end;
  end;
end;

procedure TSFCustomBusinessData.BeforeDBEditRow;
begin
  if (Assigned(mOnBeforeDBEditRow)) then
    mOnBeforeDBEditRow(Self);
end;

procedure TSFCustomBusinessData.AfterDBEditRow;
begin
  if (Assigned(mOnAfterDBEditRow)) then
    mOnAfterDBEditRow(Self);
end;

procedure TSFCustomBusinessData.BeforeDBInsertRow;
begin
  if (Assigned(mOnBeforeDBInsertRow)) then
    mOnBeforeDBInsertRow(Self);
end;

procedure TSFCustomBusinessData.AfterDBInsertRow;
begin
  if (Assigned(mOnAfterDBInsertRow)) then
    mOnAfterDBInsertRow(Self);
end;

procedure TSFCustomBusinessData.BeforeDBDeleteRow;
begin
  if (Assigned(mOnBeforeDBDeleteRow)) then
    mOnBeforeDBDeleteRow(Self);
end;

procedure TSFCustomBusinessData.AfterDBDeleteRow;
begin
  if (Assigned(mOnAfterDBDeleteRow)) then
    mOnAfterDBDeleteRow(Self);
end;

procedure TSFCustomBusinessData.BeforeRefreshRow;
begin
  if (Assigned(mOnBeforeRefreshRow)) then
    mOnBeforeRefreshRow(Self);
end;

procedure TSFCustomBusinessData.AfterRefreshRow;
begin
  if (Assigned(mOnAfterRefreshRow)) then
    mOnAfterRefreshRow(Self);
end;

procedure TSFCustomBusinessData.BeforeRefreshFull;
begin
  if (Assigned(mOnBeforeRefreshFull)) then
    mOnBeforeRefreshFull(Self);
end;

procedure TSFCustomBusinessData.AfterRefreshFull;
begin
  if (Assigned(mOnAfterRefreshRow)) then
    mOnAfterRefreshFull(Self);
end;

procedure TSFCustomBusinessData.FilterRecord(var pAccept: Boolean);
begin
  if (Assigned(OnFilterRecord)) then
    OnFilterRecord(Self, pAccept);
end;

function TSFCustomBusinessData.CompareRecords(CompareRecordFrom, CompareRecordTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult;
begin
  Result := compareResultUndefined;

  if (Assigned(mOnCompareRecords)) then
    Result := mOnCompareRecords(CompareRecordFrom, CompareRecordTo);
end;

procedure TSFCustomBusinessData.SetQueryParams(pType: TSFBDSExecParamsType; pParams: TCollection);
  var i: Integer;
      lQryParamName: String;
      lValueItem: TSFBDSStmtParamItem;
      lParamValuesLst: TCollection;
begin
  if (Assigned(ConnectorUsed)) and (pType = exPrmsTypeSelect) and (Assigned(pParams)) then
  begin
    lParamValuesLst := StmtParamValues;
    for i := 0 to (pParams.Count - 1) do
    begin
      lQryParamName := ConnectorUsed.GetQueryParamName(pParams.Items[i]);
      lValueItem := getStmtParamValue(lQryParamName, lParamValuesLst);
      if (lValueItem <> nil) then
        ConnectorUsed.SetQueryParamValue(pParams.Items[i], lValueItem.Value);
    end;
  end;

  if (Assigned(pParams)) and (pParams.Count > 0) and (Assigned(mOnSetParams)) then
    mOnSetParams(exPrmsTypeSelect, pParams);
end;

function TSFCustomBusinessData.MappedStmtDBDialect: TSFStmtDBDialect;
begin
  Result := stmtDBDDflt;

  if not(Assigned(ConnectorUsed)) then
    Exit;

  case ConnectorUsed.ConnectionDBType of
    dbtDB2: Result := stmtDBDDB2;
    dbtFB: Result := stmtDBFB;
    dbtIB: Result := stmtDBIB;
    dbtMSSQL: Result := stmtDBDMSSQL;
    dbtMySQL: Result := stmtDBDMySQL;
    dbtOra: Result := stmtDBDOra;
    dbtSQLLite: Result := stmtDBDSQLite;
    dbtPG: Result := stmtDBDPG;
    dbtMSAcc: Result := stmtDBDAcc;
    dbtAdvantage: Result := stmtDBDAdvantage;
    dbtInformix: Result := stmtDBDIfx;
    dbtAnywhere: Result := stmtDBDAnywhere;
    dbtSybase: Result := stmtDBDSybase;
  end;
end;

procedure TSFCustomBusinessData.GetBookmarkData(Buffer: TRecBuf; Data: TBookmark);
begin
  if not(IsEmpty) then
    Move(PSFBDSRecordData(Buffer)^.rdRecordNumber, Data[0], BookmarkSize);
end;

function TSFCustomBusinessData.GetBookmarkFlag(Buffer: TRecBuf): TBookmarkFlag;
begin
  Result := PSFBDSRecordData(Buffer)^.rdBookmarkFlag;
end;

procedure TSFCustomBusinessData.SetBookmarkFlag(Buffer: TRecBuf; Value: TBookmarkFlag);
begin
  PSFBDSRecordData(Buffer)^.rdBookmarkFlag := Value;
end;

procedure TSFCustomBusinessData.SetBookmarkData(Buffer: TRecBuf; Data: TBookmark);
begin
  PSFBDSRecordData(Buffer)^.rdRecordNumber := PInteger(Data)^;
end;

procedure TSFCustomBusinessData.InternalAddRecord(Buffer: TRecBuf; Append: Boolean);
begin
  if (Append) then
    mCurrentRecIdx := getMaxRecInfoCount;

  dec(mCurrInsertIdx);
  generateAutoValues(avGMAfterInsert);

  insertCurrRecord(mCurrentRecIdx, Buffer);
  InternalSetToRecord(Buffer);
end;

procedure TSFCustomBusinessData.InternalHandleException;
begin
  // nothing to do
end;

procedure TSFCustomBusinessData.InitRecord(Buffer: TRecBuf);
begin
  inherited;

  InternalInitRecord(Buffer);
  PSFBDSRecordData(Buffer)^.rdUpdateState := usInserted;
  PSFBDSRecordData(Buffer)^.rdBookmarkFlag := bfInserted;
end;

procedure TSFCustomBusinessData.InternalInitRecord(Buffer: TRecBuf);
  var i, lDataStart, lFieldNo, lFldCnt: Integer;
      lRecord: PSFBDSRecordData;
begin
  // reset blobs
  resetRecBlobBuffers(Buffer);

  // initialize record
  lRecord := PSFBDSRecordData(Buffer);
  lRecord^.rdBookmarkFlag := bfCurrent;
  lRecord^.rdRecordNumber := -1;
  lRecord^.rdUpdateState := usUnmodified;

  lDataStart := mRecordFldDataOffset;
  lFldCnt := 0;
  for i := 0 to (Fields.Count - 1) do
  begin
    lFieldNo := Fields[i].FieldNo;
    if (lFieldNo < 0) then
      Continue;

    // exclude calculated fields from Fieldcount
    inc(lFldCnt);

    // initialize fieldinfos
    lRecord^.rdFields[lFieldNo].fdDataOfs := 0;
    lRecord^.rdFields[lFieldNo].fdDataSize := 0;
    lRecord^.rdFields[lFieldNo].fdDataIsBlob := False;
    lRecord^.rdFields[lFieldNo].fdDataIsNull := True;

    if (Fields[i].IsBlob) then
    begin
      lRecord^.rdFields[lFieldNo].fdDataIsBlob := True;
      Continue;
    end;

    // set fieldinfos
    lRecord^.rdFields[lFieldNo].fdDataOfs := lDataStart;
    lRecord^.rdFields[lFieldNo].fdDataSize := Fields[i].DataSize;

    lDataStart := lDataStart + lRecord^.rdFields[lFieldNo].fdDataSize;
  end;

  lRecord^.rdFieldCount := lFldCnt;
end;

procedure TSFCustomBusinessData.InternalDelete;
  var lCurrBuff: TRecBuf;
begin
  lCurrBuff := detectCurrentBuffer;
  if not(mCachedUpdates) and (isVisibleRecInfo(mRecordInfos[mCurrentRecIdx], Filtered)) then
  begin
    if (isPureCached) or (executeDelete) then
    begin
      PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usDeleted;
      mRecordInfos[mCurrentRecIdx].riUpdateState := usDeleted;
      if (mRecordInfos[mCurrentRecIdx].riRecType = rtCache) and (mRecordInfos[mCurrentRecIdx].riRef >= Low(mRecCache)) and (mRecordInfos[mCurrentRecIdx].riRef <= High(mRecCache)) then
        PSFBDSRecordData(mRecCache[mRecordInfos[mCurrentRecIdx].riRef])^.rdUpdateState := usDeleted;

      inc(mDeletedCount);
    end;
  end else
  if (mCachedUpdates) and (isVisibleRecInfo(mRecordInfos[mCurrentRecIdx], Filtered)) then
  begin
    if (mRecordInfos[mCurrentRecIdx].riCachedUpdateState = usInserted) then
    begin
      mRecordInfos[mCurrentRecIdx].riUpdateState := usDeleted;
      mRecordInfos[mCurrentRecIdx].riCachedUpdateState := usUnmodified;
    end else
      mRecordInfos[mCurrentRecIdx].riCachedUpdateState := usDeleted;

    mUpdatesPending := True;
    PSFBDSRecordData(lCurrBuff)^.rdUpdateState := usDeleted;
    if (mRecordInfos[mCurrentRecIdx].riRecType = rtCache) and (mRecordInfos[mCurrentRecIdx].riRef >= Low(mRecCache)) and (mRecordInfos[mCurrentRecIdx].riRef <= High(mRecCache)) then
      PSFBDSRecordData(mRecCache[mRecordInfos[mCurrentRecIdx].riRef])^.rdUpdateState := usDeleted;

    inc(mDeletedCount);
  end;
end;

procedure TSFCustomBusinessData.InternalFirst;
begin
  mCurrentRecIdx := -1;
end;

procedure TSFCustomBusinessData.InternalLast;
  var lRecCnt: Integer;
begin
  lRecCnt := getMaxRecInfoCount;
  if (lRecCnt <= 0) then
    mCurrentRecIdx := -1
  else
    mCurrentRecIdx := lRecCnt;
end;

procedure TSFCustomBusinessData.InternalInsert;
begin
  CursorPosChanged;
end;

procedure TSFCustomBusinessData.DoAfterInsert;
begin
  inherited;

  dec(mCurrInsertIdx);
  generateAutoValues(avGMAfterInsert);
end;

procedure TSFCustomBusinessData.InternalPost;
  var lCurrBuff: TRecBuf;
begin
  inherited;

  lCurrBuff := detectCurrentBuffer;
  if (State = dsInsert) then
  begin
    // append or insert can detected by bookmarkflag (on append = bfEOF)
    if (GetBookmarkFlag(lCurrBuff) = bfEOF) then
      mCurrentRecIdx := getMaxRecInfoCount;

    if (mCurrentRecIdx < 0) then
      mCurrentRecIdx := 0;

    insertCurrRecord(mCurrentRecIdx, lCurrBuff);
    InternalSetToRecord(lCurrBuff);
  end else
  if (State = dsEdit) then
  begin
    editCurrRecord(lCurrBuff);
    if (mCurrEditBuffer <> 0) then
      freeAllocatedBuffer(mCurrEditBuffer);
  end;
end;

procedure TSFCustomBusinessData.InternalCancel;
begin
  inherited;

  if (State = dsEdit) and (mCurrEditBuffer <> 0) then
  begin
    resetRecBlobBuffers(ActiveBuffer);
    copyRecBuffer(mCurrEditBuffer, ActiveBuffer);

    freeAllocatedBuffer(mCurrEditBuffer);
  end else
  begin
    InternalInitRecord(ActiveBuffer);
    if not(CachedUpdates) and not(isPureCached) then
      mCurrInsertIdx := 0
    else
      inc(mCurrInsertIdx);
  end;
end;

procedure TSFCustomBusinessData.InternalEdit;
begin
  inherited;

  if (mCurrEditBuffer <> 0) then
    freeAllocatedBuffer(mCurrEditBuffer);

  mCurrEditBuffer := allocateNewRecordBuffer;
  copyRecBuffer(ActiveBuffer, mCurrEditBuffer);
end;

procedure TSFCustomBusinessData.InternalRefresh;
  var lNewBuf: TRecBuf;
      lBuffIsNew: Boolean;
begin
  inherited;

  if (isPureCached) then
    Exit;

  if (mRefreshMode = refreshModeRow) and (mCurrentRecIdx >= Low(mRecordInfos)) and (mCurrentRecIdx <= High(mRecordInfos)) then
  begin
    lBuffIsNew := False;
    if (mRecordInfos[mCurrentRecIdx].riRecType = rtCache) and (mRecordInfos[mCurrentRecIdx].riRef >= Low(mRecCache)) and (mRecordInfos[mCurrentRecIdx].riRef <= High(mRecCache)) then
      lNewBuf := mRecCache[mRecordInfos[mCurrentRecIdx].riRef]
    else
    begin
      lNewBuf := allocateNewRecordBuffer;
      lBuffIsNew := True;
    end;

    if not(mCachedUpdates) or (mRecordInfos[mCurrentRecIdx].riCachedUpdateState = usUnmodified) then
      refreshRow(lNewBuf, mCurrentRecIdx)
    else
      refreshBufferedRow(lNewBuf, mCurrentRecIdx);

    if (PSFBDSRecordData(lNewBuf)^.rdRecordNumber < 0) then
      PSFBDSRecordData(lNewBuf)^.rdRecordNumber := mapIdByRecIdx(mCurrentRecIdx);
    resetRecBlobBuffers(ActiveBuffer);
    copyRecBuffer(lNewBuf, ActiveBuffer);

    // add to cached list
    if (lBuffIsNew) then
    begin
      SetLength(mRecCache, Length(mRecCache) + 1);
      mRecCache[High(mRecCache)] := lNewBuf;

      mRecordInfos[mCurrentRecIdx].riRef := High(mRecCache);
      mRecordInfos[mCurrentRecIdx].riRecType := rtCache;
    end;
  end else
    FullRefresh;
end;

procedure TSFCustomBusinessData.InternalGotoBookmark(Bookmark: TBookmark);
  var lRecNo: Integer;
begin
  Move(Bookmark[0], lRecNo, SizeOf(lRecNo));
  if (lRecNo >= Low(mRecMapList)) and (lRecNo <= High(mRecMapList))  then
    mCurrentRecIdx := mRecMapList[lRecNo]
  else
    mCurrentRecIdx := -1;
end;

procedure TSFCustomBusinessData.configSelect(pDoOpen: Boolean);
  var lParams: TCollection;
begin
  if (isPureCached) then
    Exit;

  enforceSelectClosed;

  if (Assigned(ConnectorUsed)) then
  begin
    mStmt.QuoteType := QueryQuoteType;
    mStmt.DBDialect := MappedStmtDBDialect;
    lParams := ConnectorUsed.SetSQLToQuery(mStmt.GetSelectStmt, selectQuery);

    if (pDoOpen) then
    begin
      // call event to fill params
      SetQueryParams(exPrmsTypeSelect, lParams);

      selectQuery.Open;
    end else
      selectQuery.FieldDefs.Update;

    mSelectConfigured := True;

    // save current stmt (p. e. for refresh, stmt itself can be changed)
    if (Assigned(mActiveStmt)) then
      FreeAndNil(mActiveStmt);

    mActiveStmt := mStmt.AssignStmt;
  end;
end;

procedure TSFCustomBusinessData.setConnector(pConnector: TSFConnector);
begin
  if (pConnector <> mConnector) then
  begin
    if (mConnector <> nil) then
    begin
      mConnector.RemoveFreeNotification(Self);
      mConnector.RemoveConnectorMsgNotification(doOnConnectorMessage);
    end;

    mConnector := pConnector;
    if (mConnector <> nil) then
    begin
      mConnector.FreeNotification(Self);
      mConnector.AddConnectorMsgNotification(doOnConnectorMessage);
    end;

    connectorChanged;
  end;

  if (mConnector = nil) then
    TSFConnector.AddCommonConnectedProc(doOnConnectorMessage)
  else
    TSFConnector.RemoveCommonConnectedProc(doOnConnectorMessage);
end;

function TSFCustomBusinessData.getConnectorUsed: TSFConnector;
begin
  Result := mConnector;

  if (Result = nil) and (TSFConnector.GetCommonConnector <> nil) then
    Result := TSFConnector.GetCommonConnector;
end;

function TSFCustomBusinessData.getSelectQuery: TDataSet;
begin
  if not(Assigned(mSelect)) and not(isPureCached) then
  begin
    if not(Assigned(ConnectorUsed)) then
      SFBDSDataError(bdsErrMissingConnector, []);

    mSelect := ConnectorUsed.GetNewQuery(mTransaction, atSelect, False);
    mSelect.AfterClose := doOnSelectClosed;
  end;

  Result := mSelect;
end;

procedure TSFCustomBusinessData.enforceSelectClosed;
begin
  if (hasActiveSelectQuery) then
  begin
    mSelect.Close;
    FreeAndNil(mSelect);
  end;
end;

function TSFCustomBusinessData.hasActiveSelectQuery: Boolean;
begin
  Result := Assigned(mSelect) and (mSelect.Active);
end;

function TSFCustomBusinessData.detectCurrentBuffer: TRecBuf;
begin
  Result := 0;

  // todo - check when dsFilter and other states
  if (State = dsCalcFields) then
    Result := CalcBuffer
  else if (State = dsOldValue) then
  begin
    if (mCurrEditBuffer <> 0) then
    begin
      if (mTempBuffer > 0) and (PSFBDSRecordData(mCurrEditBuffer)^.rdRecordNumber = PSFBDSRecordData(mTempBuffer)^.rdRecordNumber) then
        Result := mCurrEditBuffer
      else if (PSFBDSRecordData(mCurrEditBuffer)^.rdRecordNumber = PSFBDSRecordData(ActiveBuffer)^.rdRecordNumber) then
        Result := mCurrEditBuffer
      else
        Result := ActiveBuffer;
    end else
      Result := ActiveBuffer;
  end
  else if (State = dsFilter) then
    Result := mFilterBuffer
  else if (State <> dsBrowse) or not(IsEmpty) then
  begin
    if (mTempBuffer > 0) then
      Result := mTempBuffer
    else
      Result := ActiveBuffer;
  end;
end;

function TSFCustomBusinessData.getLastDataRecNoInRecInfos: Integer;
  var i: Integer;
begin
  Result := -1;
  for i := 0 to (Length(mRecordInfos) - 1) do
  begin
    if (mRecordInfos[i].riRefDataOrg > Result) then
      Result := mRecordInfos[i].riRefDataOrg;
  end;
end;

procedure TSFCustomBusinessData.loadRecordInfosFromData(pLimit: Integer);
  var lLastRecNo, lCurrLen: Integer;
begin
  if (isPureCached) or (Length(mRecordInfos) >= pLimit) then
    Exit;

  lLastRecNo := getLastDataRecNoInRecInfos;
  if (lLastRecNo <= 0) then
    selectQuery.First
  else if (lLastRecNo < getDataRecordCount) then
    selectQuery.RecNo := lLastRecNo + 1
  else
    Exit;

  while not(selectQuery.EOF) do
  begin
    lCurrLen := Length(mRecordInfos);
    if (lCurrLen >= pLimit) then
      Break;

    SetLength(mRecordInfos, lCurrLen + 1);
    mRecordInfos[lCurrLen].riRecType := rtData;
    mRecordInfos[lCurrLen].riRef := selectQuery.RecNo;
    mRecordInfos[lCurrLen].riRefDataOrg := mRecordInfos[lCurrLen].riRef;
    mRecordInfos[lCurrLen].riRefSaved := -1;
    mRecordInfos[lCurrLen].riRefDataUpd := -1;
    mRecordInfos[lCurrLen].riUpdateState := usUnmodified;
    mRecordInfos[lCurrLen].riCachedUpdateState := usUnmodified;
    mRecordInfos[lCurrLen].riFiltered := False;

    SetLength(mRecMapList, Length(mRecMapList) + 1);
    mRecMapList[High(mRecMapList)] := lCurrLen;

    selectQuery.Next;
  end;
end;

function TSFCustomBusinessData.getDataRecordCount: Integer;
begin
  Result := 0;
  if not(isPureCached) and (hasActiveSelectQuery) then
  begin
    if not(mDataFullLoaded) then
    begin
      if not(selectQuery.IsEmpty) then
        selectQuery.Last;

      mDataFullLoaded := True;
    end;

    if not(selectQuery.IsEmpty) then
      Result := selectQuery.RecordCount;
  end;
end;

function TSFCustomBusinessData.getMaxRecInfoCount: Integer;
begin
  // note: deleted rows will stand in SelectQuery
  Result := getDataRecordCount + mRecAddedCount;
end;

function TSFCustomBusinessData.getPriorVisibleRecInfo(pStart: Integer; pCheckFiltered: Boolean): Integer;
  var i: Integer;
begin
  Result := -1;

  if (pStart >= getMaxRecInfoCount) then
    pStart := getMaxRecInfoCount - 1;
  if (pStart >= Length(mRecordInfos)) then
    loadRecordInfosFromData(pStart + 1);

  for i := pStart downto 0 do
  begin
    if (isVisibleRecInfo(mRecordInfos[i], pCheckFiltered)) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TSFCustomBusinessData.getNextVisibleRecInfo(pStart: Integer; pCheckFiltered: Boolean): Integer;
  var i, lMaxInfoCnt: Integer;
begin
  Result := getMaxRecInfoCount;

  if (pStart < 0) then
    pStart := 0;

  lMaxInfoCnt := Result;
  for i := pStart to (lMaxInfoCnt - 1) do
  begin
    if (i >= Length(mRecordInfos)) then
      loadRecordInfosFromData(i + 1);

    if (isVisibleRecInfo(mRecordInfos[i], pCheckFiltered)) then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TSFCustomBusinessData.countInvisibleRecInfos(pFrom, pTo: Integer; pCheckFiltered: Boolean): Integer;
  var i, lMax: Integer;
begin
  Result := 0;

  lMax := getMaxRecInfoCount - 1;
  if (pFrom < 0) then
    pFrom := 0;
  if (pFrom > lMax) then
    pFrom := lMax;
  if (pTo < 0) then
    pTo := 0;
  if (pTo > lMax) then
    pTo := lMax;

  for i := pFrom to pTo do
  begin
    if (i < 0) then
      Continue;

    if (i >= Length(mRecordInfos)) then
      loadRecordInfosFromData(i + 1);

    if not(isVisibleRecInfo(mRecordInfos[i], pCheckFiltered)) then
      inc(Result);
  end;
end;

function TSFCustomBusinessData.isVisibleRecInfo(pRecInfo: TSFBDSRecordInfo; pCheckFiltered: Boolean): Boolean;
begin
  Result := (pRecInfo.riUpdateState <> usDeleted) and (not mCachedUpdates or (pRecInfo.riCachedUpdateState <> usDeleted));
  if (Result) and (pCheckFiltered) then
    Result := not(pRecInfo.riFiltered);
end;

procedure TSFCustomBusinessData.loadCurrentSelectRowToBuffer(pQuery: TDataSet;
          pBuffer: TRecBuf; pRecNo: LongInt; pCopyBlobs: Boolean);
  var lRecord: PSFBDSRecordData;
      lFldData, lFldConv: TValueBuffer;
      i, lFieldNo, lLen: Integer;
      lDataStream: TMemoryStream;
      lBlobDataArray: PSFBDSBlobDataArray;
      lOwnField: TField;
      lTSQLTsOConv: TSQLTimeStampOffset;
      lTSQLTsConv: TSQLTimeStamp;
      lDateTimeConv: TDateTime;
      lNeedConv: Boolean;
      lCurrBcdConv: Currency;
      lBcdConv: TBcd;
      lStrConv: String;
      lDoubleConv: Double;
      lSingleConv: Single;
      lExtendedConv: Extended;
      {$IFDEF NEXTGEN}lMrsh: TMarshaller;{$ELSE}lStrAnsiConv: AnsiString;{$ENDIF NEXTGEN}
begin
  // read Data into buffer
  InternalInitRecord(pBuffer);
  lRecord := PSFBDSRecordData(pBuffer);
  lRecord^.rdRecordNumber := mapIdByRecIdx(pRecNo);

  for i := 0 to (pQuery.Fields.Count - 1) do
  begin
    lOwnField := FindField(pQuery.Fields[i].FieldName);
    if not(Assigned(lOwnField)) then
      Continue;
    lFieldNo := lOwnField.FieldNo;
    if (lRecord^.rdFields[lFieldNo].fdDataIsBlob) then
    begin
      if (pCopyBlobs) and (pQuery.Fields[i].IsBlob) and not(pQuery.Fields[i].IsNull) then
      begin
        lDataStream := TMemoryStream.Create;
        mBlobs.Add(lDataStream);
        TBlobField(pQuery.Fields[i]).SaveToStream(lDataStream);

        lBlobDataArray := PSFBDSBlobDataArray(PByte(pBuffer) + mRecordBlobsOffset);
        lBlobDataArray^[lOwnField.Offset] := lDataStream;
      end;

      Continue;
    end;

    if (pQuery.Fields[i].IsNull) then
    begin
      lRecord^.rdFields[lFieldNo].fdDataIsNull := True;
      Continue;
    end;

    lRecord^.rdFields[lFieldNo].fdDataIsNull := False;
    if (pQuery.Fields[i] is TDateTimeField) and (lOwnField is TSQLTimestampField) then
    begin
      SetLength(lFldData, lRecord^.rdFields[lFieldNo].fdDataSize);
      if (lOwnField is TSQLTimeStampOffsetField) then
      begin
        lTSQLTsOConv := DateTimeToSQLTimeStampOffset(pQuery.Fields[i].AsDateTime);
        lFldData := BytesOf(@lTSQLTsOConv, SizeOf(TSQLTimeStampOffset));
      end else
      begin
        lTSQLTsConv := DateTimeToSQLTimeStamp(pQuery.Fields[i].AsDateTime);
        lFldData := BytesOf(@lTSQLTsConv, SizeOf(TSQLTimeStamp));
      end;
      lNeedConv := True;
    end else
    if (pQuery.Fields[i] is TSQLTimestampField) and (lOwnField is TDateTimeField) then
    begin
      if (lOwnField is TSQLTimeStampOffsetField) then
        lDateTimeConv := SQLTimeStampOffsetToDateTime(pQuery.Fields[i].AsSQLTimeStampOffset)
      else
        lDateTimeConv := SQLTimeStampToDateTime(pQuery.Fields[i].AsSQLTimeStamp);

      lFldData := BytesOf(@lDateTimeConv, SizeOf(TDateTime));
      lNeedConv := True;
    end else
    begin
      if (pQuery.Fields[i].ClassType <> lOwnField.ClassType) and ((pQuery.Fields[i] is TDateTimeField)
        or (pQuery.Fields[i] is TBinaryField) or (pQuery.Fields[i] is TWideStringField)
        or (pQuery.Fields[i] is TBCDField) or (pQuery.Fields[i] is TFMTBCDField)
        or (pQuery.Fields[i] is TFloatField) or (pQuery.Fields[i] is TSingleField)
        or (pQuery.Fields[i] is TExtendedField)) then
      begin
        if (pQuery.Fields[i] is TWideStringField) then
        begin
          lStrConv := pQuery.Fields[i].AsString;
          {$IFDEF NEXTGEN}
            lLen := Max(Integer(Length(TMarshal.AsAnsi(lStrConv)) + 1), pQuery.Fields[i].DataSize);
            lLen := Max(lLen, lRecord^.rdFields[lFieldNo].fdDataSize);
            SetLength(lFldData, lLen);
            TMarshal.Copy(lMrsh.AsAnsi(lStrConv), lFldData, 0, lLen - 1);
            lFldData[lLen - 1] := 0;
          {$ELSE}
            lStrAnsiConv := AnsiString(lStrConv);
            lLen := Max(Integer(System.AnsiStrings.StrLen(PAnsiChar(lStrAnsiConv)) + 1), pQuery.Fields[i].DataSize);
            lLen := Max(lLen, lRecord^.rdFields[lFieldNo].fdDataSize);
            SetLength(lFldData, lLen);
            System.AnsiStrings.StrLCopy(PAnsiChar(@lFldData[0]), PAnsiChar(lStrAnsiConv), lLen - 1);
          {$ENDIF NEXTGEN}
        end else
        if (pQuery.Fields[i] is TNumericField) then
        begin
          if (lOwnField is TExtendedField) then
          begin
            lExtendedConv := pQuery.Fields[i].AsVariant;
            lFldData := BytesOf(@lExtendedConv, lRecord^.rdFields[lFieldNo].fdDataSize);
          end else
          if (lOwnField is TSingleField) then
          begin
            lSingleConv := pQuery.Fields[i].AsVariant;
            lFldData := BytesOf(@lSingleConv, lRecord^.rdFields[lFieldNo].fdDataSize);
          end else
          if (lOwnField is TBCDField) or (lOwnField is TFmtBCDField) then
          begin
            lCurrBcdConv := pQuery.Fields[i].AsVariant;
            lFldData := BytesOf(@lCurrBcdConv, lRecord^.rdFields[lFieldNo].fdDataSize);
          end else
          begin
            lDoubleConv := pQuery.Fields[i].AsVariant;
            lFldData := BytesOf(@lDoubleConv, lRecord^.rdFields[lFieldNo].fdDataSize);
          end;
        end else
        begin
          SetLength(lFldData, Max(lRecord^.rdFields[lFieldNo].fdDataSize, pQuery.Fields[i].DataSize));
          pQuery.Fields[i].GetData(lFldData, False);
        end;
      end else
      begin
        SetLength(lFldData, Max(lRecord^.rdFields[lFieldNo].fdDataSize, pQuery.Fields[i].DataSize));
        pQuery.Fields[i].GetData(lFldData);
      end;

      lNeedConv := (pQuery.Fields[i].ClassType <> lOwnField.ClassType)
                  and ((lOwnField is TDateTimeField) or (lOwnField is TBinaryField)
                  or (lOwnField is TWideStringField) or (lOwnField is TBCDField)
                  or (lOwnField is TFMTBCDField));
    end;

    try
      if (lNeedConv) then
      begin
        if (pQuery.Fields[i].ClassType <> lOwnField.ClassType) and (lOwnField is TWideStringField) then
        begin
          {$IFDEF NEXTGEN}
            lStrConv := TMarshal.ReadStringAsAnsi(TPtrWrapper.Create(lFldData));
          {$ELSE}
            SetString(lStrConv, PAnsiChar(@lFldData[0]), System.AnsiStrings.StrLen(PAnsiChar(@lFldData[0])));
          {$ENDIF NEXTGEN}
          lFldData := TEncoding.Unicode.GetBytes(lStrConv);
          SetLength(lFldData, Length(lFldData) + SizeOf(Char));
          lFldData[Length(lFldData) - 2] := 0;
          lFldData[Length(lFldData) - 1] := 0;
        end else
        if (pQuery.Fields[i].ClassType <> lOwnField.ClassType) and (lOwnField is TFMTBCDField) then
        begin
          {$IFDEF VERSMALLER_XE8}
            CurrToBcd(TBitConverter.ToCurrency(lFldData), lBcdConv, MaxBcdPrecision, MaxBcdScale);
          {$ELSE}
            CurrToBcd(TDBBitConverter.UnsafeInto<System.Currency>(lFldData), lBcdConv, MaxBcdPrecision, MaxBcdScale);
          {$ENDIF VERSMALLER_XE8}
          lFldData := BytesOf(@lBcdConv, SizeOf(TBcd));
        end;
        SetLength(lFldConv, Max(dsMaxStringSize - 1, lRecord^.rdFields[lFieldNo].fdDataSize));
        DataConvert(lOwnField, lFldData, lFldConv, True);
        Move(PByte(lFldConv)[0], PByte(pBuffer)[lRecord^.rdFields[lFieldNo].fdDataOfs], lRecord^.rdFields[lFieldNo].fdDataSize);
      end else
        Move(PByte(lFldData)[0], PByte(pBuffer)[lRecord^.rdFields[lFieldNo].fdDataOfs], lRecord^.rdFields[lFieldNo].fdDataSize);
    finally
      Finalize(lFldConv);
      Finalize(lFldData);
    end;
  end;
end;

procedure TSFCustomBusinessData.setTableName(pTableName: String);
  var lOldIdent: String;
begin
  lOldIdent := DBTableIdentifier;
  mTableName := pTableName;
  if (UpperCase(lOldIdent) <> UpperCase(DBTableIdentifier)) then
    mStmt.SetBaseTable(mTableName, mSchemaName, mCatalogName, '');
end;

procedure TSFCustomBusinessData.setCatalogName(pCatalogName: String);
  var lOldIdent: String;
begin
  lOldIdent := DBTableIdentifier;
  mCatalogName := pCatalogName;
  if (UpperCase(lOldIdent) <> UpperCase(DBTableIdentifier)) then
    mStmt.ReconfigBaseTable(mTableName, mSchemaName, mCatalogName, '');
end;

procedure TSFCustomBusinessData.setSchemaName(pSchemaName: String);
  var lOldIdent: String;
begin
  lOldIdent := DBTableIdentifier;
  mSchemaName := pSchemaName;
  if (UpperCase(lOldIdent) <> UpperCase(DBTableIdentifier)) then
    mStmt.ReconfigBaseTable(mTableName, mSchemaName, mCatalogName, '');
end;

function TSFCustomBusinessData.getDBTableIdentifier: String;
  var lTblIdent: TSFStmtTableIdent;
begin
  lTblIdent.tiTableName := mTableName;
  lTblIdent.tiSchemaName := mSchemaName;
  lTblIdent.tiCatalogName := mCatalogName;

  Result := lTblIdent.GetTableIdent;
end;

procedure TSFCustomBusinessData.clearCachedRecords(var pRecList: Array of TRecBuf);
  var i: Integer;
begin
  for i := Low(pRecList) to High(pRecList) do
    freeAllocatedBuffer(pRecList[i]);
end;

function TSFCustomBusinessData.addToSavedRecords(pBuffer: TRecBuf): Integer;
begin
  Result := Length(mRecSaved);
  SetLength(mRecSaved, Result + 1);
  mRecSaved[Result] := pBuffer;
end;

function TSFCustomBusinessData.mapIdByRecIdx(pRecIdx: Integer): Integer;
  var i: Integer;
begin
  for i := Low(mRecMapList) to High(mRecMapList) do
  begin
    if (mRecMapList[i] = pRecIdx) then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

procedure TSFCustomBusinessData.editMappedRecIdx(pFrom, pTo: Integer);
  var i: Integer;
begin
  for i := Low(mRecMapList) to High(mRecMapList) do
  begin
    if (mRecMapList[i] = pFrom) then
    begin
      mRecMapList[i] := pTo;
      Exit;
    end;
  end;
end;

procedure TSFCustomBusinessData.insertCurrRecord(pRecIdx: Integer; pBuffer: TRecBuf);
  var lNewBuf: TRecBuf;
      lInserted: Boolean;
begin
  loadRecordInfosFromData(pRecIdx + 1);
  if (moveRecInfoPositions(pRecIdx)) then
  begin
    PSFBDSRecordData(pBuffer)^.rdUpdateState := usInserted;

    lInserted := True;
    if not(isPureCached) and not(mCachedUpdates) then
    begin
      lInserted := executeInsert;

      mCurrInsertIdx := 0;
    end;

    lNewBuf := allocateNewRecordBuffer;

    if not(isPureCached) and not(mCachedUpdates) then
    begin
      if (lInserted) then
        refreshRow(lNewBuf, pRecIdx);
    end
    else if (mCachedUpdates) then
    begin
      // map and adjust joined fields to buffer
      if not(isPureCached) then
        refreshBufferedRow(lNewBuf, pRecIdx)
      else
        copyRecBuffer(pBuffer, lNewBuf);

      mUpdatesPending := True;
    end else
      copyRecBuffer(pBuffer, lNewBuf);

    PSFBDSRecordData(lNewBuf)^.rdRecordNumber := mapIdByRecIdx(pRecIdx);
    resetRecBlobBuffers(pBuffer);
    copyRecBuffer(lNewBuf, pBuffer);
    SetModified(False);

    // add to cached list
    SetLength(mRecCache, Length(mRecCache) + 1);
    mRecCache[High(mRecCache)] := lNewBuf;
    if (lInserted) then
    begin
      inc(mAddedCount);
      mRecordInfos[pRecIdx].riUpdateState := usUnmodified;
    end else
    begin
      mRecordInfos[pRecIdx].riUpdateState := usDeleted;
      PSFBDSRecordData(lNewBuf)^.rdUpdateState := usDeleted;
      PSFBDSRecordData(pBuffer)^.rdUpdateState := usDeleted;
    end;
    if not(mCachedUpdates) then
      mRecordInfos[pRecIdx].riCachedUpdateState := usUnmodified
    else
      mRecordInfos[pRecIdx].riCachedUpdateState := usInserted;
    mRecordInfos[pRecIdx].riRef := High(mRecCache);
    mRecordInfos[pRecIdx].riRecType := rtCache;
  end;
end;

procedure TSFCustomBusinessData.editCurrRecord(pBuffer: TRecBuf);
  var lNewBuf: TRecBuf;
      lUpdated: Boolean;
begin
  if (isVisibleRecInfo(mRecordInfos[mCurrentRecIdx], Filtered)) and (mCurrentRecIdx >= Low(mRecordInfos)) and (mCurrentRecIdx <= High(mRecordInfos)) then
  begin
    PSFBDSRecordData(pBuffer)^.rdUpdateState := usModified;

    lUpdated := True;
    if not(isPureCached) and not(mCachedUpdates) then
      lUpdated := executeEdit;

    lNewBuf := allocateNewRecordBuffer;

    if not(isPureCached) and not(mCachedUpdates) then
    begin
      if (lUpdated) or (mCurrEditBuffer = 0) then
        refreshRow(lNewBuf, mCurrentRecIdx)
      else
        copyRecBuffer(mCurrEditBuffer, lNewBuf);
    end
    else if (mCachedUpdates) then
    begin
      // map and adjust joined fields to buffer
      if not(isPureCached) then
        refreshBufferedRow(lNewBuf, mCurrentRecIdx)
      else
        copyRecBuffer(ActiveBuffer, lNewBuf);

      mUpdatesPending := True;
    end else
      copyRecBuffer(ActiveBuffer, lNewBuf);

    PSFBDSRecordData(lNewBuf)^.rdRecordNumber := mapIdByRecIdx(mCurrentRecIdx);
    resetRecBlobBuffers(pBuffer);
    copyRecBuffer(lNewBuf, pBuffer);
    SetModified(False);

    if (mRecordInfos[mCurrentRecIdx].riRecType = rtCache) and (mRecordInfos[mCurrentRecIdx].riRef >= Low(mRecCache)) and (mRecordInfos[mCurrentRecIdx].riRef <= High(mRecCache)) then
    begin
      if not(mCachedUpdates) or (mRecordInfos[mCurrentRecIdx].riCachedUpdateState <> usUnmodified) then
        freeAllocatedBuffer(mRecCache[mRecordInfos[mCurrentRecIdx].riRef])
      else
        mRecordInfos[mCurrentRecIdx].riRefSaved := addToSavedRecords(mRecCache[mRecordInfos[mCurrentRecIdx].riRef]);

      mRecCache[mRecordInfos[mCurrentRecIdx].riRef] := lNewBuf;
    end else
    begin
      // add to cached list
      SetLength(mRecCache, Length(mRecCache) + 1);
      mRecCache[High(mRecCache)] := lNewBuf;

      if (mCachedUpdates) then
        mRecordInfos[mCurrentRecIdx].riRefDataUpd := mRecordInfos[mCurrentRecIdx].riRef;
      mRecordInfos[mCurrentRecIdx].riRef := High(mRecCache);
    end;

    mRecordInfos[mCurrentRecIdx].riUpdateState := usUnmodified;
    if not(mCachedUpdates) then
      mRecordInfos[mCurrentRecIdx].riCachedUpdateState := usUnmodified
    else if (mRecordInfos[mCurrentRecIdx].riCachedUpdateState <> usInserted) then
      mRecordInfos[mCurrentRecIdx].riCachedUpdateState := usModified;
    mRecordInfos[mCurrentRecIdx].riRecType := rtCache;
  end;
end;

function TSFCustomBusinessData.executeEdit: Boolean;
  const lcUpdFldPre = 'UpdPrm_';
  var lStmtEdit: TSFStmt;
      i: Integer;
      lPrmFldName, lQryParamName: String;
      lQueryEdit: TDataSet;
      lHasKeys: Boolean;
      lParams: TCollection;
      lFld: TField;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  lQueryEdit := ConnectorUsed.GetNewQuery(mUpdateTransaction, atModify);
  lStmtEdit := TSFStmt.Create(nil);
  try
    BeforeDBEditRow;

    Result := ConnectorUsed.CanDBInsertion(lQueryEdit);
    if not(Result) then
      Exit;

    lStmtEdit.SetBaseTable(mTableName, mSchemaName, mCatalogName, '');
    lHasKeys := False;
    for i := 0 to (Fields.Count - 1) do
    begin
      if (Fields[i].FieldKind <> fkData) then
        Continue;
      if not(mFieldMaps[i].fimIsBaseField) then
        Continue;

      if not(Fields[i].IsBlob) and ((mUpdateMode <> upWhereKeyOnly) or (mFieldMaps[i].fimIsKeyField)) then
      begin
        lHasKeys := True;
        lStmtEdit.SetStmtAttr(mFieldMaps[i].fimDBFieldName, '', lStmtEdit.BaseTable, True);
        if (VarIsNull(Fields[i].OldValue)) or (VarIsEmpty(Fields[i].OldValue)) then
          lStmtEdit.AddConditionIsNull(lStmtEdit.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName)
        else
        begin
          lPrmFldName := ':' + Fields[i].FieldName;
          with lStmtEdit.AddStmtAttr(lPrmFldName, True) do
            AddItemParam(Fields[i].FieldName);

          lStmtEdit.AddConditionAttr(lStmtEdit.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName, SFSTMT_OP_EQUAL, '', lPrmFldName);
        end;
      end;
      // autoincremented fields cannot updated (p. e. in MSSQL)
      if not(Fields[i] is TAutoIncField) then
        lStmtEdit.AddSetCondition(mFieldMaps[i].fimDBFieldName, lcUpdFldPre + Fields[i].FieldName, stmtAttrItemTypeParameter);
    end;

    if not(lHasKeys) then
      SFBDSDataError(bdsErrNoSearchFields, []);

    lStmtEdit.QuoteType := QueryQuoteType;
    lStmtEdit.DBDialect := MappedStmtDBDialect;
    lParams := ConnectorUsed.SetSQLToQuery(lStmtEdit.GetUpdateStmt, lQueryEdit);
    for i := 0 to (lParams.Count - 1) do
    begin
      lQryParamName := ConnectorUsed.GetQueryParamName(lParams.Items[i]);
      if (AnsiStartsStr(UpperCase(lcUpdFldPre), UpperCase(lQryParamName))) then
      begin
        lFld := FieldByName(RightStr(lQryParamName, Length(lQryParamName) - Length(lcUpdFldPre)));
        if (lFld.IsBlob) then
          ConnectorUsed.SetQueryParamValue(lParams.Items[i], lFld.Value, TBlobField(lFld).BlobType)
        else
          ConnectorUsed.SetQueryParamValue(lParams.Items[i], lFld.Value, lFld.DataType)
      end else
      begin
        lFld := FieldByName(lQryParamName);
        if (lFld.IsBlob) then
          ConnectorUsed.SetQueryParamValue(lParams.Items[i], lFld.OldValue, TBlobField(lFld).BlobType)
        else
          ConnectorUsed.SetQueryParamValue(lParams.Items[i], lFld.OldValue, lFld.DataType);
      end;
    end;

    ConnectorUsed.QueryExecSQL(lQueryEdit);
    AfterDBEditRow;
  finally
    FreeAndNil(lStmtEdit);
    FreeAndNil(lQueryEdit);
  end;
end;

function TSFCustomBusinessData.executeDelete: Boolean;
  var lStmtDel: TSFStmt;
      i: Integer;
      lPrmFldName: String;
      lQueryDel: TDataSet;
      lHasKeys: Boolean;
      lParams: TCollection;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  lQueryDel := ConnectorUsed.GetNewQuery(mUpdateTransaction, atModify);
  lStmtDel := TSFStmt.Create(nil);
  try
    BeforeDBDeleteRow;

    Result := ConnectorUsed.CanDBInsertion(lQueryDel);
    if not(Result) then
      Exit;

    lStmtDel.SetBaseTable(mTableName, mSchemaName, mCatalogName, '');
    lHasKeys := False;
    for i := 0 to (Fields.Count - 1) do
    begin
      if (Fields[i].IsBlob) or (Fields[i].FieldKind <> fkData) then
        Continue;
      if not(mFieldMaps[i].fimIsBaseField) then
        Continue;

      if (mUpdateMode <> upWhereKeyOnly) or (mFieldMaps[i].fimIsKeyField) then
      begin
        lHasKeys := True;
        lStmtDel.SetStmtAttr(mFieldMaps[i].fimDBFieldName, '', lStmtDel.BaseTable, True);
        if (Fields[i].IsNull) then
          lStmtDel.AddConditionIsNull(lStmtDel.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName)
        else
        begin
          lPrmFldName := ':' + Fields[i].FieldName;
          with lStmtDel.AddStmtAttr(lPrmFldName, True) do
            AddItemParam(Fields[i].FieldName);

          lStmtDel.AddConditionAttr(lStmtDel.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName, SFSTMT_OP_EQUAL, '', lPrmFldName);
        end;
      end;
    end;

    if not(lHasKeys) then
      SFBDSDataError(bdsErrNoSearchFields, []);

    lStmtDel.QuoteType := QueryQuoteType;
    lStmtDel.DBDialect := MappedStmtDBDialect;
    lParams := ConnectorUsed.SetSQLToQuery(lStmtDel.GetDeleteStmt, lQueryDel);
    for i := 0 to (lParams.Count - 1) do
      ConnectorUsed.SetQueryParamValue(lParams.Items[i], FieldByName(ConnectorUsed.GetQueryParamName(lParams.Items[i])).Value);

    ConnectorUsed.QueryExecSQL(lQueryDel);

    AfterDBDeleteRow;
  finally
    FreeAndNil(lStmtDel);
    FreeAndNil(lQueryDel);
  end;
end;

function TSFCustomBusinessData.executeInsert: Boolean;
  var lStmtIns: TSFStmt;
      lQueryIns: TDataSet;
      i: Integer;
      lParams: TCollection;
      lPrmFldName: String;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  lQueryIns := ConnectorUsed.GetNewQuery(mUpdateTransaction, atModify);
  lStmtIns := TSFStmt.Create(nil);
  try
    BeforeDBInsertRow;

    Result := ConnectorUsed.CanDBInsertion(lQueryIns);
    if not(Result) then
      Exit;

    generateAutoValues(avGMBeforePost);

    lStmtIns.SetBaseTable(mTableName, mSchemaName, mCatalogName, '');
    for i := 0 to (Fields.Count - 1) do
    begin
      if (Fields[i].FieldKind <> fkData) then
        Continue;
      if not(mFieldMaps[i].fimIsBaseField) then
        Continue;
      if (Fields[i].IsNull) or (Fields[i].AsString = '') then
        Continue;

      lStmtIns.AddInsertCondition(mFieldMaps[i].fimDBFieldName, Fields[i].FieldName, stmtAttrItemTypeParameter);
    end;

    lStmtIns.QuoteType := QueryQuoteType;
    lStmtIns.DBDialect := MappedStmtDBDialect;
    lParams := ConnectorUsed.SetSQLToQuery(lStmtIns.GetInsertStmt, lQueryIns);
    for i := 0 to (lParams.Count - 1) do
    begin
      lPrmFldName := ConnectorUsed.GetQueryParamName(lParams.Items[i]);
      if (FieldByName(lPrmFldName) is TBlobField) then
        ConnectorUsed.SetQueryParamValue(lParams.Items[i], FieldByName(lPrmFldName).Value, TBlobField(FieldByName(lPrmFldName)).BlobType)
      else
        ConnectorUsed.SetQueryParamValue(lParams.Items[i], FieldByName(lPrmFldName).Value, FieldByName(lPrmFldName).DataType);
    end;
    ConnectorUsed.QueryExecSQL(lQueryIns);

    generateAutoValues(avGMAfterPost);

    AfterDBInsertRow;
  finally
    FreeAndNil(lStmtIns);
    FreeAndNil(lQueryIns);
  end;
end;

procedure TSFCustomBusinessData.refreshRow(pBuffer: TRecBuf; pRecIdx: Integer);
  var lStmtRefresh: TSFStmt;
      i: Integer;
      lPrmFldName: String;
      lQueryRefresh: TDataSet;
      lHasKeys: Boolean;
      lParams: TCollection;
      lTempBuf: TRecBuf;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  InternalInitRecord(pBuffer);

  lQueryRefresh := ConnectorUsed.GetNewQuery(mTransaction, atSelect);
  lStmtRefresh := activeStmt.AssignStmt;
  try
    lStmtRefresh.ClearBaseRestrictions;
    lStmtRefresh.ClearConditions;
    lStmtRefresh.ClearClientRectrictions;
    lStmtRefresh.ClearSetConditions;
    lStmtRefresh.ClearInsConditions;
    if (lStmtRefresh.HasUnion) then
      lStmtRefresh.SetUnion(nil);

    lHasKeys := False;
    for i := 0 to (Fields.Count - 1) do
    begin
      if (Fields[i].IsBlob) or (Fields[i].FieldKind <> fkData) then
        Continue;
      if not(mFieldMaps[i].fimIsBaseField) then
        Continue;

      if (mUpdateMode <> upWhereKeyOnly) or (mFieldMaps[i].fimIsKeyField) then
      begin
        lHasKeys := True;
        if (Fields[i].IsNull) then
          lStmtRefresh.AddConditionIsNull(lStmtRefresh.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName)
        else
        begin
          lPrmFldName := ':' + Fields[i].FieldName;
          if not(lStmtRefresh.AttrExists(mFieldMaps[i].fimDBFieldName, lStmtRefresh.BaseTable.TableAlias, '')) then
            lStmtRefresh.SetStmtAttr(mFieldMaps[i].fimDBFieldName, '', lStmtRefresh.BaseTable, True);
          if not(lStmtRefresh.AttrExists(lPrmFldName, '', '')) then
          begin
            with lStmtRefresh.AddStmtAttr(lPrmFldName, True) do
              AddItemParam(Fields[i].FieldName);
          end;

          lStmtRefresh.AddConditionAttr(lStmtRefresh.BaseTable.TableAlias, mFieldMaps[i].fimDBFieldName, SFSTMT_OP_EQUAL, '', lPrmFldName);
        end;
      end;
    end;

    if not(lHasKeys) then
      SFBDSDataError(bdsErrNoSearchFields, []);

    // change inner joins to outer joins
    lStmtRefresh.ModfiyTableJoinType(nil, lStmtRefresh.BaseTable, stmtJoinTypeInner, stmtJoinTypeOuter);

    BeforeRefreshRow;

    lStmtRefresh.DBDialect := MappedStmtDBDialect;
    lStmtRefresh.QuoteType := QueryQuoteType;
    lParams := ConnectorUsed.SetSQLToQuery(lStmtRefresh.GetSelectStmt, lQueryRefresh);
    for i := 0 to (lParams.Count - 1) do
      ConnectorUsed.SetQueryParamValue(lParams.Items[i], FieldByName(ConnectorUsed.GetQueryParamName(lParams.Items[i])).Value);

    lQueryRefresh.Open;
    if not(lQueryRefresh.IsEmpty) then
      loadCurrentSelectRowToBuffer(lQueryRefresh, pBuffer, pRecIdx, True)
    else if (detectCurrentBuffer <> 0) then
      copyRecBuffer(detectCurrentBuffer, pBuffer);

    lTempBuf := mTempBuffer;
    mTempBuffer := pBuffer;
    try
      AfterRefreshRow;
    finally
      mTempBuffer := lTempBuf;
    end;
  finally
    FreeAndNil(lStmtRefresh);
    FreeAndNil(lQueryRefresh);
  end;
end;

procedure TSFCustomBusinessData.refreshBufferedRow(pBuffer: TRecBuf; pRecIdx: Integer);
  var lStmtRefresh, lStmtCachedRow: TSFStmt;
      i, x, y: Integer;
      lDummyTab: String;
      lQueryRefresh: TDataSet;
      lSourceField: TField;
      lCurrBuff, lTempBuf: TRecBuf;
      lNullFields, lNullFieldNames: Array of String;
      lRelationsNullFld: Variant;
      lRelationItems: TSFStmtJoinRelItems;
      lQueryExit: Boolean;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  InternalInitRecord(pBuffer);
  lCurrBuff := detectCurrentBuffer;

  lQueryExit := not(Assigned(activeStmt.BaseTable)) or not(activeStmt.BaseTable.HasJoins);
  lQueryExit := lQueryExit or not(GetCanSelectWithoutTable(lDummyTab)) or not(GetCanSubSelectInFrom);
  lQueryExit := lQueryExit or (lDummyTab = '') and GetNeedTableOnSubSelectInFrom;
  if (lQueryExit) then
  begin
    copyRecBuffer(lCurrBuff, pBuffer);
    Exit;
  end;

  lQueryRefresh := ConnectorUsed.GetNewQuery(mTransaction, atSelect);
  lStmtRefresh := TSFStmt.Create(nil);
  try
    if not(hasMappedBaseFields) then
    begin
      copyRecBuffer(lCurrBuff, pBuffer);
      Exit;
    end;

    lStmtCachedRow := TSFStmt.Create(nil);
    if (lDummyTab <> '') then
      lStmtCachedRow.SetBaseTable(lDummyTab, '', '', '');

    Finalize(lNullFields);
    for i := Low(mFieldMaps) to High(mFieldMaps) do
    begin
      if not(mFieldMaps[i].fimIsBaseField) then
        Continue;
      lSourceField := FindField(mFieldMaps[i].fimFieldName);
      if not(Assigned(lSourceField)) then
        Continue;

      if (lSourceField.IsBlob) or (lSourceField.FieldKind <> fkData) or (lSourceField.IsNull) then
      begin
        // set default-values for null-fields, otherwise datatypes can't be located
        with lStmtCachedRow.AddStmtAttr(mFieldMaps[i].fimDBFieldName, False) do
        begin
          if (lSourceField.IsBlob) then
            AddItemValue(getDfltValueForDataType(ftString))
          else
            AddItemValue(getDfltValueForDataType(lSourceField.DataType));
        end;

        SetLength(lNullFields, Length(lNullFields) + 1);
        lNullFields[Length(lNullFields) - 1] := mFieldMaps[i].fimDBFieldName;

        SetLength(lNullFieldNames, Length(lNullFieldNames) + 1);
        lNullFieldNames[Length(lNullFieldNames) - 1] := mFieldMaps[i].fimFieldName;
      end else
      begin
        with lStmtCachedRow.AddStmtAttr(mFieldMaps[i].fimDBFieldName, False) do
          AddItemValue(lSourceField.Value);
      end;
    end;
    lStmtRefresh.SetBaseTable(lStmtCachedRow, activeStmt.BaseTable.TableAlias);
    activeStmt.AssignStmtTo(lStmtRefresh);

    lStmtRefresh.ClearBaseRestrictions;
    lStmtRefresh.ClearConditions;
    lStmtRefresh.ClearClientRectrictions;
    lStmtRefresh.ClearSetConditions;
    lStmtRefresh.ClearInsConditions;
    if (lStmtRefresh.HasUnion) then
      lStmtRefresh.SetUnion(nil);

    // change inner joins to outer joins
    lStmtRefresh.ModfiyTableJoinType(nil, lStmtRefresh.BaseTable, stmtJoinTypeInner, stmtJoinTypeOuter);

    // check null-fields for joins
    for i := Low(lNullFields) to High(lNullFields) do
    begin
      lRelationsNullFld := lStmtRefresh.TableJoinAliasesForAttr(lStmtRefresh.BaseTable, lNullFields[i]);
      if (VarIsArray(lRelationsNullFld)) then
      begin
        for x := VarArrayLowBound(lRelationsNullFld, 1) to VarArrayHighBound(lRelationsNullFld, 1) do
        begin
          lRelationItems := lStmtRefresh.GetRelItemsForJoin(lStmtRefresh.BaseTable.TableAlias, lRelationsNullFld[x]);
          if (Length(lRelationItems) > 0) then
          begin
            for y := Low(lRelationItems) to High(lRelationItems) do
            begin
              if (lRelationItems[y].riSrcType = stmtJoinRelItemAttr) and (AnsiCompareText(lRelationItems[y].riSrcValue, lNullFields[i]) = 0) then
              begin
                lRelationItems[y].riSrcType := stmtJoinRelItemValue;
                lRelationItems[y].riSrcValue := NULL;
              end;
            end;
            lStmtRefresh.SetRelItemsForJoin(lStmtRefresh.BaseTable.TableAlias, lRelationsNullFld[x], lRelationItems);
          end;
        end;
      end;
    end;

    BeforeRefreshRow;
    lStmtRefresh.DBDialect := MappedStmtDBDialect;
    lStmtRefresh.QuoteType := QueryQuoteType;
    ConnectorUsed.SetSQLToQuery(lStmtRefresh.GetSelectStmt, lQueryRefresh);
    lQueryRefresh.Open;
    if not(lQueryRefresh.IsEmpty) then
    begin
      loadCurrentSelectRowToBuffer(lQueryRefresh, pBuffer, pRecIdx, True);
      // reset null-fields on buffer
      for i := Low(lNullFieldNames) to High(lNullFieldNames) do
      begin
        lSourceField := FindField(lNullFieldNames[i]);
        if (Assigned(lSourceField)) then
          PSFBDSRecordData(pBuffer)^.rdFields[lSourceField.FieldNo].fdDataIsNull := True;
      end;
      // copy own blobs from current buffer
      copyRecBufferBlobs(lCurrBuff, pBuffer, True);
    end else
      copyRecBuffer(lCurrBuff, pBuffer);

    lTempBuf := mTempBuffer;
    mTempBuffer := pBuffer;
    try
      AfterRefreshRow;
    finally
      mTempBuffer := lTempBuf;
    end;
  finally
    FreeAndNil(lStmtRefresh);
    FreeAndNil(lQueryRefresh);
  end;
end;

function TSFCustomBusinessData.moveRecInfoPositions(pFrom: Integer): Boolean;
  var lCurrLen, i: Integer;
begin
  Result := False;

  if (pFrom < 0) then
    pFrom := 0;

  lCurrLen := Length(mRecordInfos);
  // only one new recinfo can be added on end
  if (pFrom > lCurrLen) then
    Exit;

  SetLength(mRecordInfos, lCurrLen + 1);
  inc(mRecAddedCount);
  for i := (lCurrLen - 1) downto pFrom do
  begin
    mRecordInfos[i + 1].riRef := mRecordInfos[i].riRef;
    mRecordInfos[i + 1].riRefSaved := mRecordInfos[i].riRefSaved;
    mRecordInfos[i + 1].riRefDataUpd := mRecordInfos[i].riRefDataUpd;
    mRecordInfos[i + 1].riRefDataOrg := mRecordInfos[i].riRefDataOrg;
    mRecordInfos[i + 1].riRecType := mRecordInfos[i].riRecType;
    mRecordInfos[i + 1].riUpdateState := mRecordInfos[i].riUpdateState;
    mRecordInfos[i + 1].riCachedUpdateState := mRecordInfos[i].riCachedUpdateState;
    mRecordInfos[i + 1].riFiltered := mRecordInfos[i].riFiltered;

    editMappedRecIdx(i, i + 1);
  end;

  mRecordInfos[pFrom].riRef := -1;
  mRecordInfos[pFrom].riRefSaved := -1;
  mRecordInfos[pFrom].riRefDataUpd := -1;
  mRecordInfos[pFrom].riRefDataOrg := -1;
  mRecordInfos[pFrom].riRecType := rtNone;
  mRecordInfos[pFrom].riUpdateState := usUnmodified;
  mRecordInfos[pFrom].riCachedUpdateState := usUnmodified;
  mRecordInfos[pFrom].riFiltered := False;

  SetLength(mRecMapList, Length(mRecMapList) + 1);
  mRecMapList[High(mRecMapList)] := pFrom;

  Result := True;
end;

procedure TSFCustomBusinessData.resetRecBlobBuffers(pRecord: TRecBuf);
  var i: Integer;
      lBlobDataArray: PSFBDSBlobDataArray;
      lRecord: PSFBDSRecordData;
begin
  if (BlobFieldCount <= 0) then
    Exit;

  lRecord := PSFBDSRecordData(pRecord);
  lBlobDataArray := PSFBDSBlobDataArray(PByte(lRecord) + mRecordBlobsOffset);
  for i := 0 to (Fields.Count - 1) do
  begin
    if not(Fields[i].IsBlob) then
      Continue;

    if (lBlobDataArray^[Fields[i].Offset] <> nil) and (mBlobs.IndexOf(lBlobDataArray^[Fields[i].Offset]) >= 0) then
      mBlobs.Remove(TMemoryStream(lBlobDataArray^[Fields[i].Offset]));

    lBlobDataArray^[Fields[i].Offset] := nil;
  end;
end;

procedure TSFCustomBusinessData.copyRecBuffer(pSource, pDest: TRecBuf);
begin
  Move(PByte(pSource)[0], PByte(pDest)[0], mRecordSize);

  copyRecBufferBlobs(pSource, pDest, False);
end;

procedure TSFCustomBusinessData.copyRecBufferBlobs(pSource, pDest: TRecBuf; pKeepExisting: Boolean);
  var i: Integer;
      lSourceBlobData, lDestBlobData: PSFBDSBlobDataArray;
      lSourceRec, lDestRec: PSFBDSRecordData;
      lSourceBlobStream, lDestBlobStream: TMemoryStream;
begin
  if (BlobFieldCount <= 0) then
    Exit;

  lSourceRec := PSFBDSRecordData(pSource);
  lDestRec := PSFBDSRecordData(pDest);

  lSourceBlobData := PSFBDSBlobDataArray(PByte(lSourceRec) + mRecordBlobsOffset);
  lDestBlobData := PSFBDSBlobDataArray(PByte(lDestRec) + mRecordBlobsOffset);
  for i := 0 to (Fields.Count - 1) do
  begin
    if not(Fields[i].IsBlob) then
      Continue;

    lDestBlobStream := nil;
    if (pKeepExisting) and (lDestBlobData^[Fields[i].Offset] <> nil) and (mBlobs.IndexOf(lDestBlobData^[Fields[i].Offset]) >= 0) then
      lDestBlobStream := lDestBlobData^[Fields[i].Offset]
    else
      lDestBlobData^[Fields[i].Offset] := nil;

    lSourceBlobStream := nil;
    if (lSourceBlobData^[Fields[i].Offset] <> nil) and (mBlobs.IndexOf(lSourceBlobData^[Fields[i].Offset]) >= 0) then
      lSourceBlobStream := lSourceBlobData^[Fields[i].Offset];

    if (lSourceBlobStream <> nil) and (lDestBlobStream = nil) then
    begin
      lDestBlobStream := TMemoryStream.Create;
      lSourceBlobStream.SaveToStream(lDestBlobStream);
      mBlobs.Add(lDestBlobStream);
      lDestBlobData^[Fields[i].Offset] := lDestBlobStream;
      lDestRec^.rdFields[Fields[i].FieldNo].fdDataIsNull := (lDestBlobStream.Size = 0);
    end;
  end;
end;

procedure TSFCustomBusinessData.connectorChanged;
begin
  if (Active) then
    Close;

  if (Assigned(mSelect)) then
    FreeAndNil(mSelect);
end;

procedure TSFCustomBusinessData.doSortBuffer(pMin, pMax: LongInt);
  var lMin, lMinSave, lMax, lPiv: Integer;
      lRecMin, lRecMax, lRecPiv: TRecBuf;
      lCompareRecFrom, lCompareRecTo: TSFBDSCompareRecord;
begin
  if (pMin > pMax) then
    Exit;

  lPiv := pMax + 1;
  lRecPiv := allocateNewRecordBuffer;
  if (InternalGetRecord(lRecPiv, gmPrior, False, Filtered, lPiv) <> grOk) then
  begin
    freeAllocatedBuffer(lRecPiv);

    Exit;
  end;

  lMin := pMin;
  lMax := lPiv - 1;
  if (lMin > lMax) then
  begin
    freeAllocatedBuffer(lRecPiv);

    Exit;
  end;

  lRecMin := 0;
  lRecMax := 0;
  while (lMin <= lMax) do
  begin
    repeat
      if (lRecMin > 0) then
        freeAllocatedBuffer(lRecMin);
      lRecMin := allocateNewRecordBuffer;

      if (InternalGetRecord(lRecMin, gmCurrent, False, Filtered, lMin) = grOk) then
      begin
        lCompareRecFrom := TSFBDSCompareRecord.Create(Self, lRecMin);
        lCompareRecTo := TSFBDSCompareRecord.Create(Self, lRecPiv);
        try
          case CompareRecords(lCompareRecFrom, lCompareRecTo) of
            compareResultUndefined:
              begin
                freeAllocatedBuffer(lRecMin);
                lMin := pMax;
              end;
            compareResultLess: inc(lMin);
          else
            Break;
          end;
        finally
          FreeAndNil(lCompareRecFrom);
          FreeAndNil(lCompareRecTo);
        end;
      end else
      begin
        freeAllocatedBuffer(lRecMin);
        lMin := pMax;
      end;
    until (lMin >= lPiv);

    repeat
      if (lRecMax > 0) then
        freeAllocatedBuffer(lRecMax);
      lRecMax := allocateNewRecordBuffer;

      lMax := lMax + 1;
      if (InternalGetRecord(lRecMax, gmPrior, False, Filtered, lMax) = grOk) then
      begin
        lCompareRecFrom := TSFBDSCompareRecord.Create(Self, lRecMax);
        lCompareRecTo := TSFBDSCompareRecord.Create(Self, lRecPiv);
        try
          case CompareRecords(lCompareRecFrom, lCompareRecTo) of
            compareResultUndefined:
              begin
                freeAllocatedBuffer(lRecMax);
                lMax := pMin;
              end;
            compareResultEqual, compareResultGreater: dec(lMax);
          else
            Break;
          end;
        finally
          FreeAndNil(lCompareRecFrom);
          FreeAndNil(lCompareRecTo);
        end;
      end else
      begin
        freeAllocatedBuffer(lRecMax);
        lMax := pMin;
      end;
    until (pMin >= lMax);

    if (lMin < lMax) then
      excangeRecInfos(lMin, lMax);
  end;

  if (lMin < lPiv) then
  begin
    if (lRecMin > 0) then
      freeAllocatedBuffer(lRecMin);
    lRecMin := allocateNewRecordBuffer;

    lMinSave := lMin;
    try
      if (InternalGetRecord(lRecMin, gmCurrent, False, Filtered, lMin) = grOk) and (lMin = lMinSave) then
      begin
        lCompareRecFrom := TSFBDSCompareRecord.Create(Self, lRecMin);
        lCompareRecTo := TSFBDSCompareRecord.Create(Self, lRecPiv);
        try
          if (CompareRecords(lCompareRecFrom, lCompareRecTo) = compareResultGreater) then
            excangeRecInfos(lMin, lPiv);
        finally
          FreeAndNil(lCompareRecFrom);
          FreeAndNil(lCompareRecTo);
        end;
      end;
    finally
      lMin := lMinSave;
    end;
  end;

  if (lRecMin > 0) then
    freeAllocatedBuffer(lRecMin);
  if (lRecMax > 0) then
    freeAllocatedBuffer(lRecMax);
  if (lRecPiv > 0) then
    freeAllocatedBuffer(lRecPiv);

  doSortBuffer(pMin, lMin - 1);
  doSortBuffer(lMin + 1, pMax);
end;

procedure TSFCustomBusinessData.excangeRecInfos(pInfo, pWith: LongInt);
  var lRecInfoCache: TSFBDSRecordInfo;
begin
  lRecInfoCache.riRef := mRecordInfos[pInfo].riRef;
  lRecInfoCache.riRefSaved := mRecordInfos[pInfo].riRefSaved;
  lRecInfoCache.riRefDataUpd := mRecordInfos[pInfo].riRefDataUpd;
  lRecInfoCache.riRefDataOrg := mRecordInfos[pInfo].riRefDataOrg;
  lRecInfoCache.riRecType := mRecordInfos[pInfo].riRecType;
  lRecInfoCache.riUpdateState := mRecordInfos[pInfo].riUpdateState;
  lRecInfoCache.riCachedUpdateState := mRecordInfos[pInfo].riCachedUpdateState;
  lRecInfoCache.riFiltered := mRecordInfos[pInfo].riFiltered;

  mRecordInfos[pInfo].riRef := mRecordInfos[pWith].riRef;
  mRecordInfos[pInfo].riRefSaved := mRecordInfos[pWith].riRefSaved;
  mRecordInfos[pInfo].riRefDataUpd := mRecordInfos[pWith].riRefDataUpd;
  mRecordInfos[pInfo].riRefDataOrg := mRecordInfos[pWith].riRefDataOrg;
  mRecordInfos[pInfo].riRecType := mRecordInfos[pWith].riRecType;
  mRecordInfos[pInfo].riUpdateState := mRecordInfos[pWith].riUpdateState;
  mRecordInfos[pInfo].riCachedUpdateState := mRecordInfos[pWith].riCachedUpdateState;
  mRecordInfos[pInfo].riFiltered := mRecordInfos[pWith].riFiltered;

  mRecordInfos[pWith].riRef := lRecInfoCache.riRef;
  mRecordInfos[pWith].riRefSaved := lRecInfoCache.riRefSaved;
  mRecordInfos[pWith].riRefDataUpd := lRecInfoCache.riRefDataUpd;
  mRecordInfos[pWith].riRefDataOrg := lRecInfoCache.riRefDataOrg;
  mRecordInfos[pWith].riRecType := lRecInfoCache.riRecType;
  mRecordInfos[pWith].riUpdateState := lRecInfoCache.riUpdateState;
  mRecordInfos[pWith].riCachedUpdateState := lRecInfoCache.riCachedUpdateState;
  mRecordInfos[pWith].riFiltered := lRecInfoCache.riFiltered;

  editMappedRecIdx(pWith, -1);
  editMappedRecIdx(pInfo, pWith);
  editMappedRecIdx(-1, pInfo);
end;

function TSFCustomBusinessData.doLocate(pFields: String; pValues: Variant; pOptions: TLocateOptions; pStart: Integer): Integer;
  var lFields: TList<TField>;
      lSearchVals: Array of Variant;
      i, x: Integer;
      lRslt: Boolean;
      lFieldVal: Variant;
      lTempBuffSave: TRecBuf;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  CursorPosChanged;

  Result := -1;

  lFields := TList<TField>.Create;
  try
    lRslt := False;
    GetFieldList(lFields, pFields);
    if (lFields.Count = 1) then
      lRslt := not(VarIsArray(pValues)) or (VarArrayHighBound(pValues, 1) = 0)
    else if (lFields.Count > 1) then
      lRslt := (VarIsArray(pValues)) and (VarArrayHighBound(pValues, 1) = (lFields.Count - 1));

    if not(lRslt) then
      Exit;

    SetLength(lSearchVals, lFields.Count);
    if (VarIsArray(pValues)) then
    begin
      for i := Low(lSearchVals) to High(lSearchVals) do
        lSearchVals[i] := pValues[i];
    end else
      lSearchVals[0] := pValues;

    lRslt := False;
    i := pStart;
    while (i < getMaxRecInfoCount) do
    begin
      lTempBuffSave := mTempBuffer;
      mTempBuffer := allocateNewRecordBuffer;
      try
        if (InternalGetRecord(mTempBuffer, gmCurrent, False, Filtered, i) = grOk) then
        begin
          lRslt := False;
          for x := 0 to (lFields.Count - 1) do
          begin
            if (VarIsNull(lFieldVal)) then
              lRslt := VarIsNull(lSearchVals[x])
            else if not(VarIsNull(lSearchVals[x])) then
            begin
              if (VarIsStr(lFieldVal)) and (VarIsStr(lSearchVals[x])) then
              begin
                if (loPartialKey in pOptions) then
                begin
                  if (loCaseInsensitive in pOptions) then
                    lRslt := (LeftStr(AnsiUpperCase(lFieldVal), Length(lSearchVals[x])) = AnsiUpperCase(lSearchVals[x]))
                  else
                    lRslt := (LeftStr(lFieldVal, Length(lSearchVals[x])) = lSearchVals[x]);
                end else
                begin
                  if (loCaseInsensitive in pOptions) then
                    lRslt := (AnsiUpperCase(lFieldVal) = AnsiUpperCase(lSearchVals[x]))
                  else
                    lRslt := lFieldVal = lSearchVals[x];
                end;
              end else
              begin
                lFieldVal := lFields[x].Value;
                try
                  lFieldVal := VarAsType(lFieldVal, VarType(lSearchVals[x]));
                except
                  on E: EVariantError do
                    Exit;
                end;

                lRslt := (lFieldVal = lSearchVals[x]);
              end;
            end;

            if not(lRslt) then
              Break;
          end;
        end;
      finally
        freeAllocatedBuffer(mTempBuffer);
        mTempBuffer := lTempBuffSave;
      end;

      if (lRslt) then
      begin
        Result := i;
        Exit;
      end;

      inc(i);
    end;
  finally
    FreeAndNil(lFields);
  end;
end;

procedure TSFCustomBusinessData.bindAutoValues;
  var i: Integer;
      lNewAutoVal: TSFBDSAutoValueGenerator;
      lBaseFld: TField;
begin
  for i := 0 to (Fields.Count - 1) do
  begin
    if (GetAutoValueForField(Fields[i].FieldName) <> nil) then
      Continue;

    if (Fields[i] is TAutoIncField) then
    begin
      lNewAutoVal := GetAutoValueCls(Fields[i].FieldName, True).Create;
      lNewAutoVal.mDataSet := Self;
      lNewAutoVal.mFieldName := Fields[i].FieldName;
      lNewAutoVal.mAutoDetected := True;

      if not(isPureCached) then
      begin
        // check has sequence/generator
        lBaseFld := selectQuery.FindField(Fields[i].FieldName);
        if (Assigned(lBaseFld)) and (Assigned(ConnectorUsed)) then
          lNewAutoVal.mSequenceName := ConnectorUsed.SequenceNameForField(lBaseFld);
      end;

      detectAndSetAutoValueOptions(lNewAutoVal);

      mAutoValuesLst.Add(lNewAutoVal);
    end;
  end;
end;

procedure TSFCustomBusinessData.bindBaseFields;
  var lBaseTblFlds, lKeyFldsLst: TStringList;
      lKeyFields: String;
      i: Integer;
begin
  lBaseTblFlds := GetBaseTableFields;
  lKeyFldsLst := TStringList.Create;
  try
    lKeyFields := GetKeyFields;
    if (lKeyFields <> '') then
    begin
      i := 1;
      while (i <= Length(lKeyFields)) do
        lKeyFldsLst.Add(ExtractFieldName(lKeyFields, i));
    end;
    lKeyFldsLst.CaseSensitive := False;

    if (Assigned(lBaseTblFlds)) then
      lBaseTblFlds.CaseSensitive := False;

    SetLength(mFieldMaps, Fields.Count);
    for i := 0 to (Fields.Count - 1) do
    begin
      mFieldMaps[i].fimFieldName := Fields[i].FieldName;
      mFieldMaps[i].fimIsBaseField := False;
      mFieldMaps[i].fimIsKeyField := False;
      if (Fields[i].FieldKind = fkData) and (Assigned(activeStmt.BaseTable)) then
      begin
        mFieldMaps[i].fimDBFieldName := activeStmt.AttrDatabaseNameForAttrName(activeStmt.BaseTable.TableAlias, Fields[i].FieldName);
        if (mFieldMaps[i].fimDBFieldName <> '') then
        begin
          if (Assigned(lBaseTblFlds)) then
            mFieldMaps[i].fimIsBaseField := GetNameInBaseFieldsList(mFieldMaps[i].fimDBFieldName, lBaseTblFlds);
          mFieldMaps[i].fimIsKeyField := GetNameInBaseFieldsList(mFieldMaps[i].fimDBFieldName, lKeyFldsLst);
        end;
      end;
    end;
  finally
    if (Assigned(lBaseTblFlds)) then
      FreeAndNil(lBaseTblFlds);
    FreeAndNil(lKeyFldsLst);
  end;
end;

function TSFCustomBusinessData.hasMappedBaseFields: Boolean;
  var i: Integer;
begin
  for i := Low(mFieldMaps) to High(mFieldMaps) do
  begin
    Result := mFieldMaps[i].fimIsBaseField;
    if (Result) then
      Exit;
  end;

  Result := False;
end;

procedure TSFCustomBusinessData.detectAndSetAutoValueOptions(pAutoVal: TSFBDSAutoValueGenerator);
  var i: TSFBDSAutoValueGetMode;
begin
  if not(Assigned(ConnectorUsed)) then
    Exit;

  for i := Low(TSFBDSAutoValueGetMode) to High(TSFBDSAutoValueGetMode) do
    pAutoVal.Options[i] := GetAutoValueOptionsForDBType(ConnectorUsed.ConnectionDBType, i);
end;

procedure TSFCustomBusinessData.removeDetectedAutoValues;
  var i: Integer;
begin
  i := 0;
  while (i < mAutoValuesLst.Count) do
  begin
    if (mAutoValuesLst[i].AutoDetected) then
      mAutoValuesLst.Remove(mAutoValuesLst[i])
    else
      inc(i);
  end;
end;

procedure TSFCustomBusinessData.generateAutoValues(pMode: TSFBDSAutoValueGetMode);
  var i: Integer;
      lAutoValue: TSFBDSAutoValueGenerator;
      lGenValue, lValue: Variant;
      lCurrBuff: TRecBuf;
      lValueBuffer: TValueBuffer;
      lNullAllowed, lBoolVal: Boolean;
      lCurrStrVal, lStrVal: String;
      lCurrIntVal, lIntVal: Integer;
      lDateVal: TDateTime;
      lLongWordVal: LongWord;
      lSingleVal: Single;
      lDoubleVal: Double;
      lCurrencyVal: Currency;
      lVarType: TVarType;
begin
  lCurrBuff := detectCurrentBuffer;
  if (lCurrBuff = 0) then
    Exit;

  for i := 0 to (Fields.Count - 1) do
  begin
    // check Field has a autovalue
    lAutoValue := GetAutoValueForField(Fields[i].FieldName);
    if not(Assigned(lAutoValue)) then
      Continue;

    // check value was manually setted
    lCurrStrVal := '';
    if not(Fields[i].IsNull) then
      lCurrStrVal := Fields[i].AsString;

    if (lCurrStrVal <> '') and (TryStrToInt(lCurrStrVal, lCurrIntVal)) then
    begin
      if (lCurrIntVal >= 0) then
        Continue;
    end
    else if (lCurrStrVal <> '') then
      Continue;

    // define default value
    lValue := NULL;
    lNullAllowed := False;
    lVarType := getVarTypeForDataType(Fields[i].DataType);
    case pMode of
      avGMAfterInsert:
        begin
          if (lVarType in [varSmallint, varInteger, varShortInt, varByte, varLongWord, varOleStr, varSingle, varDouble, varCurrency]) then
            lValue := mCurrInsertIdx;
        end;
      avGMBeforePost: lNullAllowed := True;
    end;

    lGenValue := lAutoValue.GetGeneratorValue(pMode);
    if not(VarIsNull(lGenValue)) and not(VarIsEmpty(lGenValue)) then
      lValue := lGenValue;

    if not(lNullAllowed) and (VarIsNull(lValue)) or (VarIsEmpty(lValue)) then
      Continue;

    if (VarIsNull(lValue)) or (VarIsEmpty(lValue)) then
      PSFBDSRecordData(lCurrBuff)^.rdFields[Fields[i].FieldNo].fdDataIsNull := True
    else
    begin
      if (lVarType = varError) then
        SFBDSDataError(bdsErrInvalidAutotype, []);

      try
        lValue := VarAsType(lValue, lVarType);
      except
        on E: EVariantError do
          SFBDSDataError(bdsErrInvalidAutotype, []);
      end;

      if (State in [dsInsert, dsEdit]) then
        Fields[i].Value := lValue
      else
      begin
        if (VarIsType(lValue, [varSmallint, varInteger, varShortInt, varByte])) then
        begin
          lIntVal := lValue;
          lValueBuffer := BytesOf(@lIntVal, Fields[i].DataSize);
        end
        else if (VarIsType(lValue, varLongWord)) then
        begin
          lLongWordVal := lValue;
          lValueBuffer := BytesOf(@lLongWordVal, Fields[i].DataSize);
        end
        else if (VarIsType(lValue, varOleStr)) then
        begin
          lStrVal := lValue;
          lValueBuffer := BytesOf(@lStrVal, Fields[i].DataSize)
        end
        else if (VarIsType(lValue, varDate)) then
        begin
          lDateVal := lValue;
          lValueBuffer := BytesOf(@lDateVal, Fields[i].DataSize)
        end
        else if (VarIsType(lValue, varBoolean)) then
        begin
          lBoolVal := lValue;
          lValueBuffer := BytesOf(@lBoolVal, Fields[i].DataSize);
        end
        else if (VarIsType(lValue, varSingle)) then
        begin
          lSingleVal := lValue;
          lValueBuffer := BytesOf(@lSingleVal, Fields[i].DataSize);
        end
        else if (VarIsType(lValue, varDouble)) then
        begin
          lDoubleVal := lValue;
          lValueBuffer := BytesOf(@lDoubleVal, Fields[i].DataSize);
        end
        else if (VarIsType(lValue, varCurrency)) then
        begin
          lCurrencyVal := lValue;
          lValueBuffer := BytesOf(@lCurrencyVal, Fields[i].DataSize);
        end else
          lValueBuffer := BytesOf(@lValue, Fields[i].DataSize);

        Move(PByte(lValueBuffer)[0], PByte(lCurrBuff)[PSFBDSRecordData(lCurrBuff)^.rdFields[Fields[i].FieldNo].fdDataOfs], Fields[i].DataSize);
        PSFBDSRecordData(lCurrBuff)^.rdFields[Fields[i].FieldNo].fdDataIsNull := False;
      end;
    end;
  end;
end;

function TSFCustomBusinessData.getVarTypeForDataType(pDataType: TFieldType): TVarType;
  const lcVarTypeMap: array[TFieldType] of Integer = (
            varError, varOleStr, varSmallint, // 0..2
            varInteger, varSmallint, varBoolean, varDouble, varCurrency, varCurrency, // 3..8
            varDate, varDate, varDate, varOleStr, varOleStr, varInteger, varOleStr, // 9..15
            varOleStr, varOleStr, varOleStr, varOleStr, varOleStr, varOleStr, varError, // 16..22
            varOleStr, varOleStr, varError, varError, varError, varError, varError, // 23..29
            varOleStr, varOleStr, varVariant, varUnknown, varDispatch, varOleStr, varOleStr, varOleStr, // 30..37
            varOleStr, varOleStr, varOleStr, varOleStr, // 38..41
            varLongWord, varShortInt, varByte, varDouble, varError, varError, varError, //42..48
            varOleStr, varError, varSingle); // 49..51
begin
  Result := lcVarTypeMap[pDataType];
end;

function TSFCustomBusinessData.getDfltValueForDataType(pDataType: TFieldType): Variant;
  var lVarType: TVarType;
      lIntVal: Integer;
      lLongWordVal: LongWord;
      lStrVal: String;
      lDateVal: TDateTime;
      lSingleVal: Single;
      lDoubleVal: Double;
      lCurrencyVal: Currency;
begin
  Result := NULL;

  lVarType := getVarTypeForDataType(pDataType);
  if (lVarType in [varSmallint, varInteger, varShortInt, varByte]) then
  begin
    lIntVal := 0;
    Result := lIntVal;
  end
  else if (lVarType = varLongWord) then
  begin
    lLongWordVal := 0;
    Result := lLongWordVal;
  end
  else if (lVarType = varOleStr) then
  begin
    lStrVal := '';
    Result := lStrVal;
  end
  else if (lVarType = varDate) then
  begin
    lDateVal := EncodeDate(1, 1, 1);
    Result := lDateVal;
  end
  else if (lVarType = varBoolean) then
  begin
    Result := False;
  end
  else if (lVarType = varSingle) then
  begin
    lSingleVal := 0.00;
    Result := lSingleVal;
  end
  else if (lVarType = varDouble) then
  begin
    lDoubleVal := 0.00;
    Result := lDoubleVal;
  end
  else if (lVarType = varCurrency) then
  begin
    lCurrencyVal := 0.00;
    Result := lCurrencyVal;
  end;
end;

function TSFCustomBusinessData.allocateNewRecordBuffer: TRecBuf;
begin
  {$IFDEF NEXTGEN}
    Result := AllocRecBuf;
  {$ELSE}
    Result := TRecBuf(AllocRecordBuffer);
  {$ENDIF NEXTGEN}
end;

procedure TSFCustomBusinessData.freeAllocatedBuffer(var pBuffer: TRecBuf);
begin
  {$IFDEF NEXTGEN}
    FreeRecBuf(pBuffer);
  {$ELSE}
    FreeRecordBuffer(TRecordBuffer(pBuffer));
  {$ENDIF NEXTGEN}
end;

procedure TSFCustomBusinessData.doCancelUpdatesSingle(pRecInfoIdx: Integer);
begin
  if (pRecInfoIdx >= Low(mRecordInfos)) and (pRecInfoIdx <= High(mRecordInfos)) then
  begin
    case mRecordInfos[pRecInfoIdx].riCachedUpdateState of
      usDeleted, usModified:
        begin
          if (mRecordInfos[pRecInfoIdx].riRefSaved >= 0) and (mRecordInfos[pRecInfoIdx].riRefSaved >= Low(mRecSaved)) and (mRecordInfos[pRecInfoIdx].riRefSaved <= High(mRecSaved)) then
          begin
            if (mRecordInfos[pRecInfoIdx].riRef >= Low(mRecCache)) and (mRecordInfos[pRecInfoIdx].riRef <= High(mRecCache)) then
            begin
              InternalInitRecord(mRecCache[mRecordInfos[pRecInfoIdx].riRef]);
              copyRecBuffer(mRecSaved[mRecordInfos[pRecInfoIdx].riRefSaved], mRecCache[mRecordInfos[pRecInfoIdx].riRef]);
            end;
          end else
          if (mRecordInfos[pRecInfoIdx].riRefDataUpd >= 0) then
          begin
            if (mRecordInfos[pRecInfoIdx].riRef >= Low(mRecCache)) and (mRecordInfos[pRecInfoIdx].riRef <= High(mRecCache)) then
              PSFBDSRecordData(mRecCache[mRecordInfos[pRecInfoIdx].riRef])^.rdUpdateState := usDeleted;

            mRecordInfos[pRecInfoIdx].riRef := mRecordInfos[pRecInfoIdx].riRefDataUpd;
            mRecordInfos[pRecInfoIdx].riRecType := rtData;
          end;

          if (mRecordInfos[pRecInfoIdx].riRecType = rtCache) and (mRecordInfos[pRecInfoIdx].riRef >= Low(mRecCache)) and (mRecordInfos[pRecInfoIdx].riRef <= High(mRecCache)) then
            PSFBDSRecordData(mRecCache[mRecordInfos[pRecInfoIdx].riRef])^.rdUpdateState := usUnmodified;

          if (mRecordInfos[pRecInfoIdx].riCachedUpdateState = usDeleted) then
            dec(mDeletedCount);
        end;
      usInserted:
        begin
          mRecordInfos[pRecInfoIdx].riUpdateState := usDeleted;
          if (mRecordInfos[pRecInfoIdx].riRef >= Low(mRecCache)) and (mRecordInfos[pRecInfoIdx].riRef <= High(mRecCache)) then
            PSFBDSRecordData(mRecCache[mRecordInfos[pRecInfoIdx].riRef])^.rdUpdateState := usDeleted;

          dec(mAddedCount);
        end;
    end;

    mRecordInfos[pRecInfoIdx].riCachedUpdateState := usUnmodified;
    mRecordInfos[pRecInfoIdx].riRefSaved := -1;
    mRecordInfos[pRecInfoIdx].riRefDataUpd := -1;
  end;
end;

function TSFCustomBusinessData.recIdxByRecNo(pRecNo: Integer): Integer;
  var lFoundCnt, lNextIdx, lMax: Integer;
begin
  if (pRecNo < 1) then
    pRecNo := 1
  else if (pRecNo > RecordCount) then
    pRecNo := RecordCount;

  Result := 0;
  lFoundCnt := 0;
  lMax := getMaxRecInfoCount;
  while (Result < lMax) do
  begin
    lNextIdx := getNextVisibleRecInfo(Result, Filtered);
    if (lNextIdx < lMax) then
      inc(lFoundCnt)
    else
      Break;

    if (lFoundCnt >= pRecNo) then
      Exit;

    Result := lNextIdx + 1;
  end;

  Result := -1;
end;

function TSFCustomBusinessData.recNoForRecIdx(pRecIdx: Integer): Integer;
begin
  Result := 0;
  if (pRecIdx >= 0) then
    Result := pRecIdx - countInvisibleRecInfos(0, pRecIdx, Filtered) + 1;
end;

procedure TSFCustomBusinessData.checkFieldFormats(pField, pSourceField: TField);
begin
  if not(Assigned(pField)) then
    Exit;

  if (pField is TTimeField) then
  begin
    if (Trim(mFormatOptions.DisplayFmtTime) <> '') then
      TTimeField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtTime)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtDateTime) <> '') then
      TTimeField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtTime)
    else if (Assigned(pSourceField)) and (pSourceField is TTimeField) then
      TTimeField(pField).DisplayFormat := TTimeField(pSourceField).DisplayFormat;

    if (mFormatOptions.EditMaskTime <> '') then
      TTimeField(pField).EditMask := mFormatOptions.EditMaskTime
    else if (Assigned(ConnectorUsed)) and (ConnectorUsed.FormatOptions.EditMaskTime <> '') then
      TTimeField(pField).EditMask := ConnectorUsed.FormatOptions.EditMaskTime
    else if (Assigned(pSourceField)) and (pSourceField is TTimeField) then
      TTimeField(pField).EditMask := TTimeField(pSourceField).EditMask;
  end
  else if (pField is TDateField) then
  begin
    if (Trim(mFormatOptions.DisplayFmtDate) <> '') then
      TDateField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtDate)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtDate) <> '') then
      TDateField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtDate)
    else if (Assigned(pSourceField)) and (pSourceField is TDateField) then
      TDateField(pField).DisplayFormat := TDateField(pSourceField).DisplayFormat;

    if (mFormatOptions.EditMaskDate <> '') then
      TDateField(pField).EditMask := mFormatOptions.EditMaskDate
    else if (Assigned(ConnectorUsed)) and (ConnectorUsed.FormatOptions.EditMaskDate <> '') then
      TDateField(pField).EditMask := ConnectorUsed.FormatOptions.EditMaskDate
    else if (Assigned(pSourceField)) and (pSourceField is TDateField) then
      TDateField(pField).EditMask := TDateField(pSourceField).EditMask;
  end
  else if (pField is TDateTimeField) then
  begin
    if (Trim(mFormatOptions.DisplayFmtDateTime) <> '') then
      TDateTimeField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtDateTime)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtDateTime) <> '') then
      TDateTimeField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtDateTime)
    else if (Assigned(pSourceField)) and (pSourceField is TDateTimeField) then
      TDateTimeField(pField).DisplayFormat := TDateTimeField(pSourceField).DisplayFormat;

    if (mFormatOptions.EditMaskDateTime <> '') then
      TDateTimeField(pField).EditMask := mFormatOptions.EditMaskDateTime
    else if (Assigned(ConnectorUsed)) and (ConnectorUsed.FormatOptions.EditMaskDateTime <> '') then
      TDateTimeField(pField).EditMask := ConnectorUsed.FormatOptions.EditMaskDateTime
    else if (Assigned(pSourceField)) and (pSourceField is TDateTimeField) then
      TDateTimeField(pField).EditMask := TDateTimeField(pSourceField).EditMask;
  end
  else if (pField is TSQLTimeStampField)  then
  begin
    if (Trim(mFormatOptions.DisplayFmtDateTime) <> '') then
      TSQLTimeStampField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtDateTime)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtDateTime) <> '') then
      TSQLTimeStampField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtDateTime)
    else if (Assigned(pSourceField)) and (pSourceField is TSQLTimeStampField) then
      TSQLTimeStampField(pField).DisplayFormat := TSQLTimeStampField(pSourceField).DisplayFormat;

    if (mFormatOptions.EditMaskDateTime <> '') then
      TSQLTimeStampField(pField).EditMask := mFormatOptions.EditMaskDateTime
    else if (Assigned(ConnectorUsed)) and (ConnectorUsed.FormatOptions.EditMaskDateTime <> '') then
      TSQLTimeStampField(pField).EditMask := ConnectorUsed.FormatOptions.EditMaskDateTime
    else if (Assigned(pSourceField)) and (pSourceField is TSQLTimeStampField) then
      TSQLTimeStampField(pField).EditMask := TSQLTimeStampField(pSourceField).EditMask;
  end
  else if (pField is TFloatField) or (pField is TSingleField)
      or (pField is TExtendedField) or (pField is TBCDField)
      or (pField is TFMTBCDField) then
  begin
    if (Trim(mFormatOptions.DisplayFmtFloat) <> '') then
      TNumericField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtFloat)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtFloat) <> '') then
      TNumericField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtFloat)
    else if (Assigned(pSourceField)) and (pSourceField is TNumericField) then
      TNumericField(pField).DisplayFormat := TNumericField(pSourceField).DisplayFormat;

    if (Trim(mFormatOptions.EditFmtFloat) <> '') then
      TNumericField(pField).EditFormat := Trim(mFormatOptions.EditFmtFloat)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.EditFmtFloat) <> '') then
      TNumericField(pField).EditFormat := Trim(ConnectorUsed.FormatOptions.EditFmtFloat)
    else if (Assigned(pSourceField)) and (pSourceField is TNumericField) then
      TNumericField(pField).EditFormat := TNumericField(pSourceField).EditFormat;
  end
  else if (pField is TCurrencyField)  then
  begin
    if (Trim(mFormatOptions.DisplayFmtCurrency) <> '') then
      TNumericField(pField).DisplayFormat := Trim(mFormatOptions.DisplayFmtCurrency)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.DisplayFmtCurrency) <> '') then
      TNumericField(pField).DisplayFormat := Trim(ConnectorUsed.FormatOptions.DisplayFmtCurrency)
    else if (Assigned(pSourceField)) and (pSourceField is TNumericField) then
      TNumericField(pField).DisplayFormat := TNumericField(pSourceField).DisplayFormat;

    if (Trim(mFormatOptions.EditFmtCurrency) <> '') then
      TNumericField(pField).EditFormat := Trim(mFormatOptions.EditFmtCurrency)
    else if (Assigned(ConnectorUsed)) and (Trim(ConnectorUsed.FormatOptions.EditFmtCurrency) <> '') then
      TNumericField(pField).EditFormat := Trim(ConnectorUsed.FormatOptions.EditFmtCurrency)
    else if (Assigned(pSourceField)) and (pSourceField is TNumericField) then
      TNumericField(pField).EditFormat := TNumericField(pSourceField).EditFormat;
  end;
end;

function TSFCustomBusinessData.createDynCalcField(pFieldName: String; pFieldCls: TFieldClass; pFldType: TFieldType;
                                                  pSize, pPrecision: Integer; pOwner: TComponent = nil): TField;
begin
  Result := nil;
  if (pFieldCls <> nil) then
  begin
    Result := pFieldCls.Create(pOwner);
    Result.FieldName := pFieldName;
    // Result.FieldKind := fkInternalCalc;
    Result.FieldKind := fkCalculated;
    Result.Size := pSize;
    Result.SetFieldType(pFldType);
    if (Result is TBCDField) then
      TBCDField(Result).Precision := pPrecision
    else if (Result is TFMTBCDField) then
      TFMTBCDField(Result).Precision := pPrecision;
  end;
end;

function TSFCustomBusinessData.createDynLkpField(pFieldName: String; pFieldCls: TFieldClass; pFldType: TFieldType;
                                                pLkpDs: TDataSet; pKeyFlds, pLkpKeyFlds, pLkpRsltFld: String; pCached: Boolean;
                                                pSize, pPrecision: Integer; pOwner: TComponent = nil): TField;
begin
  Result := nil;
  if (pFieldCls <> nil) then
  begin
    Result := pFieldCls.Create(pOwner);
    Result.FieldName := pFieldName;
    Result.FieldKind := fkLookup;
    Result.Size := pSize;
    Result.SetFieldType(pFldType);
    if (Result is TBCDField) then
      TBCDField(Result).Precision := pPrecision
    else if (Result is TFMTBCDField) then
      TFMTBCDField(Result).Precision := pPrecision;
    Result.LookupDataSet := pLkpDs;
    Result.KeyFields := pKeyFlds;
    Result.LookupKeyFields := pLkpKeyFlds;
    Result.LookupResultField := pLkpRsltFld;
    Result.LookupCache := pCached;
  end;
end;

procedure TSFCustomBusinessData.createDynCalcFields;
  var i: Integer;
      lField: TField;
begin
  for i := 0 to (mDynCalcFields.Count - 1) do
  begin
    if (mDynCalcFields[i] is TBCDField) then
      lField := createDynCalcField(mDynCalcFields[i].FieldName, TFieldClass(mDynCalcFields[i].ClassType),
                                  mDynCalcFields[i].DataType, mDynCalcFields[i].Size,
                                  TBCDField(mDynCalcFields[i]).Precision, Self)
    else if (mDynCalcFields[i] is TFMTBCDField) then
      lField := createDynCalcField(mDynCalcFields[i].FieldName, TFieldClass(mDynCalcFields[i].ClassType),
                                  mDynCalcFields[i].DataType, mDynCalcFields[i].Size,
                                  TFMTBCDField(mDynCalcFields[i]).Precision, Self)
    else
      lField := createDynCalcField(mDynCalcFields[i].FieldName, TFieldClass(mDynCalcFields[i].ClassType),
                                  mDynCalcFields[i].DataType, mDynCalcFields[i].Size,
                                  0, Self);

    if (lField <> nil) then
      lField.DataSet := Self;
  end;
end;

procedure TSFCustomBusinessData.createDynLkpFields;
  var i: Integer;
      lField: TField;
begin
  for i := 0 to (mDynLkpFields.Count - 1) do
  begin
    if (mDynCalcFields[i] is TBCDField) then
      lField := createDynLkpField(mDynLkpFields[i].FieldName, TFieldClass(mDynLkpFields[i].ClassType),
                                  mDynLkpFields[i].DataType, mDynLkpFields[i].LookupDataSet,
                                  mDynLkpFields[i].KeyFields, mDynLkpFields[i].LookupKeyFields,
                                  mDynLkpFields[i].LookupResultField, mDynLkpFields[i].LookupCache,
                                  mDynLkpFields[i].Size, TBCDField(mDynLkpFields[i]).Precision, Self)
    else if (mDynCalcFields[i] is TFMTBCDField) then
      lField := createDynLkpField(mDynLkpFields[i].FieldName, TFieldClass(mDynLkpFields[i].ClassType),
                                  mDynLkpFields[i].DataType, mDynLkpFields[i].LookupDataSet,
                                  mDynLkpFields[i].KeyFields, mDynLkpFields[i].LookupKeyFields,
                                  mDynLkpFields[i].LookupResultField, mDynLkpFields[i].LookupCache,
                                  mDynLkpFields[i].Size, TFMTBCDField(mDynLkpFields[i]).Precision, Self)
    else
      lField := createDynLkpField(mDynLkpFields[i].FieldName, TFieldClass(mDynLkpFields[i].ClassType),
                                  mDynLkpFields[i].DataType, mDynLkpFields[i].LookupDataSet,
                                  mDynLkpFields[i].KeyFields, mDynLkpFields[i].LookupKeyFields,
                                  mDynLkpFields[i].LookupResultField, mDynLkpFields[i].LookupCache,
                                  mDynLkpFields[i].Size, 0, Self);

    if (lField <> nil) then
      lField.DataSet := Self;
  end;
end;

function TSFCustomBusinessData.getDatabaseNameForFieldName(pFieldName: String; pStmt: TSFStmt; var pTableAlias,
                                          pTableName, pTableSchema, pTableCatalog, pAttrName: String): Boolean;
  var lStmtTable: TSFStmtTable;
      lTables: TObjectList<TSFStmtTable>;
      lTableFields: TStringList;
      lAttrName: String;
      i: Integer;
begin
  Result := False;
  pTableAlias := '';
  pTableName := '';
  pTableSchema := '';
  pTableCatalog := '';
  pAttrName := '';

  if (pFieldName = '') or not(Assigned(pStmt)) then
    Exit;

  lTables := pStmt.ListTables;
  try
    if (lTables <> nil) then
    begin
      for i := 0 to (lTables.Count - 1) do
      begin
        lStmtTable := lTables[i];
        lAttrName := pStmt.AttrDatabaseNameForAttrName(pFieldName, lStmtTable);
        if (lAttrName <> '') then
        begin
          // when AttrName is setted means this, that...
          if (lStmtTable <> nil) then
          begin
            // ... 1. FieldName was unique identified to a table
            if (lStmtTable.TableIdentifier <> '') then
            begin
              Result := True;
              pTableAlias := lStmtTable.TableAlias;
              pTableName := lStmtTable.TableName;
              pTableSchema := lStmtTable.Schema;
              pTableCatalog := lStmtTable.Catalog;
              pAttrName := lAttrName;
            end
            else if (lStmtTable.TableStmt <> nil) then
              Result := getDatabaseNameForFieldName(lAttrName, lStmtTable.TableStmt, pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName);

            Exit;
          end else
          begin
            // ... 2. Stmt is "Select *" => all fields from all tables are included (check attrname is part of table)
            // ... 3. Given Table is "Select table.*" => all fields from table are included (check attrname is part of table)
            if (lTables[i].TableIdentifier <> '') then
            begin
              // stmttable is a regular db-table
              lTableFields := GetBaseTableFields(lTables[i]);
              try
                if (Assigned(lTableFields)) then
                  lTableFields.CaseSensitive := False;

                if (Assigned(lTableFields)) and (GetNameInBaseFieldsList(lAttrName, lTableFields)) then
                begin
                  Result := True;
                  pTableAlias := lTables[i].TableAlias;
                  pTableName := lTables[i].TableName;
                  pTableSchema := lTables[i].Schema;
                  pTableCatalog := lTables[i].Catalog;
                  pAttrName := lAttrName;

                  Exit;
                end;
              finally
                if (Assigned(lTableFields)) then
                  FreeAndNil(lTableFields);
              end;
            end
            else if (lTables[i].TableStmt <> nil) then
            begin
              // stmttable is a stmt
              Result := getDatabaseNameForFieldName(lAttrName, lTables[i].TableStmt, pTableAlias, pTableName, pTableSchema, pTableCatalog, pAttrName);
              if (Result) then
                Exit;
            end;
          end;
        end;
      end;
    end;
  finally
    if (lTables <> nil) then
      FreeAndNil(lTables);
  end;
end;

procedure TSFCustomBusinessData.doOnConnectorMessage(pSender: TObject; pMsgId, pMessageType: Word);
begin
  case pMessageType of
    SFBDSMSGTYPE_COMMONCONNCHANGED:
      begin
        if (pSender = ConnectorUsed) then
          connectorChanged;
      end;
    SFBDSMSGTYPE_CONNTYPECHANGED:
      begin
        // check transactions
        if (pSender = ConnectorUsed) then
        begin
          if (mTransaction <> nil) and not(ConnectorUsed.CheckTransaction(mTransaction, True)) then
          begin
            if (Assigned(mSelect)) and (ConnectorUsed.HasDataSetTransaction(mSelect, mTransaction)) then
              connectorChanged;

            mTransaction := nil;
          end;

          if (mUpdateTransaction <> nil) and not(ConnectorUsed.CheckTransaction(mUpdateTransaction, True)) then
            mUpdateTransaction := nil;
        end;
      end;
    SFBDSMSGTYPE_CONNECTIONCHANGED:
      begin
        if (pSender = ConnectorUsed) then
          connectorChanged;
      end;
  end;
end;

procedure TSFCustomBusinessData.doOnSelectClosed(pDataSet: TDataSet);
begin
  if (Assigned(mSelect)) and (pDataSet = mSelect) and (Active) then
    Close;
end;

procedure TSFCustomBusinessData.setCachedUpdates(pVal: Boolean);
begin
  if (pVal <> mCachedUpdates) then
  begin
    if (pVal) then
    begin
      if (State in [dsInsert, dsEdit]) then
        SFBDSDataError(bdsErrCachedUpdWhenEdit, []);
    end else
    begin
      if (mUpdatesPending) then
        CancelUpdates;
    end;

    mCachedUpdates := pVal;
  end;
end;

procedure TSFCustomBusinessData.setTransaction(pVal: TComponent);
begin
  if (pVal <> mTransaction) then
  begin
    if (Assigned(pVal)) then
    begin
      if not(Assigned(ConnectorUsed)) then
        SFBDSDataError(bdsErrMissingConnector, []);

      ConnectorUsed.CheckTransaction(pVal);
    end;

    if (Assigned(mTransaction)) then
      mTransaction.RemoveFreeNotification(Self);

    if (Assigned(pVal)) then
      pVal.FreeNotification(Self);

    mTransaction := pVal;
  end;
end;

procedure TSFCustomBusinessData.setUpdateTransaction(pVal: TComponent);
begin
  if (pVal <> mUpdateTransaction) then
  begin
    if (Assigned(pVal)) then
    begin
      if not(Assigned(ConnectorUsed)) then
        SFBDSDataError(bdsErrMissingConnector, []);

      ConnectorUsed.CheckTransaction(pVal);
    end;

    if (Assigned(mUpdateTransaction)) then
      mUpdateTransaction.RemoveFreeNotification(Self);

    if (Assigned(pVal)) then
      pVal.FreeNotification(Self);

    mUpdateTransaction := pVal;
  end;
end;

procedure TSFCustomBusinessData.setFormatOptions(pFrmtOptions: TSFBDSFormatOptions);
begin
  mFormatOptions.Assign(pFrmtOptions);
end;

function TSFCustomBusinessData.getIsPureCached: Boolean;
begin
  Result := (Trim(DBTableIdentifier) = '');
end;

function TSFCustomBusinessData.getQueryQuoteType: TSFBDSQuoteType;
begin
  Result := Low(TSFBDSQuoteTypeDflt);
  if (mFormatOptions.QuoteType <> Result) then
    Result := mFormatOptions.QuoteType
  else if (Assigned(ConnectorUsed)) and (ConnectorUsed.FormatOptions.QuoteType <> Result) then
    Result := ConnectorUsed.FormatOptions.QuoteType;
end;

function TSFCustomBusinessData.getActiveStmt: TSFStmt;
begin
  Result := mActiveStmt;
  if (Result = nil) then
    Result := mStmt;
end;

function TSFCustomBusinessData.getStmtParamValues: TCollection;
  var lParamsLst: TStrings;
      i: Integer;
      lValueItem: TSFBDSStmtParamItem;
begin
  lParamsLst := mStmt.ListAttributeParams;
  if (lParamsLst is TStringList) then
    TStringList(lParamsLst).CaseSensitive := False;

  mStmtParamValues.BeginUpdate;
  try
    for i := 0 to (lParamsLst.Count - 1) do
    begin
      lValueItem := getStmtParamValue(lParamsLst[i], mStmtParamValues);
      if (lValueItem  = nil) then
      begin
        lValueItem := TSFBDSStmtParamItem(mStmtParamValues.Add);
        lValueItem.mName := lParamsLst[i];
        lValueItem.Value := NULL;
      end;
      lValueItem.mAutoGenerated := True;
    end;

    i := 0;
    while (i < mStmtParamValues.Count) do
    begin
      lValueItem := TSFBDSStmtParamItem(mStmtParamValues.Items[i]);
      if (lValueItem.mAutoGenerated) and (lParamsLst.IndexOf(lValueItem.Name) < 0) then
        lValueItem.Collection := nil
      else
        inc(i);
    end;
  finally
    FreeAndNil(lParamsLst);
    mStmtParamValues.EndUpdate;
  end;

  Result := mStmtParamValues;
end;

procedure TSFCustomBusinessData.setStmtParamValues(pLst: TCollection);
  var lStmtParams: TCollection;
      i: Integer;
      lParamItem: TSFBDSStmtParamItem;
begin
  lStmtParams := StmtParamValues;
  for i := 0 to (pLst.Count - 1) do
  begin
    if (pLst.Items[i] is TSFBDSStmtParamItem) then
    begin
      lParamItem := getStmtParamValue(TSFBDSStmtParamItem(pLst.Items[i]).Name, lStmtParams);
      if (lParamItem = nil) then
      begin
        lParamItem := TSFBDSStmtParamItem(lStmtParams.Add);
        lParamItem.mName := TSFBDSStmtParamItem(pLst.Items[i]).Name;
      end;

      lParamItem.Value := TSFBDSStmtParamItem(pLst.Items[i]).Value;
    end;
  end;
end;

function TSFCustomBusinessData.getStmtParamValue(pName: String; pLst: TCollection): TSFBDSStmtParamItem;
  var i: Integer;
begin
  for i := 0 to (pLst.Count - 1) do
  begin
    Result := TSFBDSStmtParamItem(pLst.Items[i]);
    if (AnsiCompareText(Result.Name, pName) = 0) then
      Exit;
  end;

  Result := nil;
end;

// ===========================================================================//
//                              TSFBDSCompareRecord                           //
// ===========================================================================//

constructor TSFBDSCompareRecord.Create(pDataSet: TSFCustomBusinessData; pRecord: TRecBuf);
begin
  inherited Create;

  mRecord := pRecord;
  mDataSet := pDataSet;
end;

function TSFBDSCompareRecord.GetFieldValByName(pFieldName: String): Variant;
  var lTmpBufSave: TRecBuf;
begin
  lTmpBufSave := mDataSet.mTempBuffer;
  mDataSet.mTempBuffer := mRecord;
  try
    Result := mDataSet.FieldByName(pFieldName).Value;
  finally
    mDataSet.mTempBuffer := lTmpBufSave;
  end;
end;

function TSFBDSCompareRecord.GetFieldValByIdx(pFieldIdx: Integer): Variant;
  var lTmpBufSave: TRecBuf;
begin
  lTmpBufSave := mDataSet.mTempBuffer;
  mDataSet.mTempBuffer := mRecord;
  try
    Result := mDataSet.Fields[pFieldIdx].Value;
  finally
    mDataSet.mTempBuffer := lTmpBufSave;
  end;
end;

function TSFBDSCompareRecord.GetBlobFieldValByName(pFieldName: String): TArray<Byte>;
  var lTmpBufSave: TRecBuf;
begin
  lTmpBufSave := mDataSet.mTempBuffer;
  mDataSet.mTempBuffer := mRecord;
  try
    Result := TBlobField(mDataSet.FieldByName(pFieldName)).Value;
  finally
    mDataSet.mTempBuffer := lTmpBufSave;
  end;
end;

function TSFBDSCompareRecord.GetBlobFieldValByIdx(pFieldIdx: Integer): TArray<Byte>;
  var lTmpBufSave: TRecBuf;
begin
  lTmpBufSave := mDataSet.mTempBuffer;
  mDataSet.mTempBuffer := mRecord;
  try
    Result := TBlobField(mDataSet.Fields[pFieldIdx]).Value;
  finally
    mDataSet.mTempBuffer := lTmpBufSave;
  end;
end;

// ===========================================================================//
//                           TSFBDSAutoValueGenerator                         //
// ===========================================================================//

constructor TSFBDSAutoValueGenerator.Create;
begin
  inherited Create;

  mSequenceName := '';
  mDataSet := nil;
  mFieldName := '';
  mAutoDetected := False;
  mExplicitInsertByDBMS := False;
end;

function TSFBDSAutoValueGenerator.GetGeneratorValue(pMode: TSFBDSAutoValueGetMode): Variant;
  var lStmt: TSFStmt;
      lDataSet: TDataSet;
      lStmtStr: String;
begin
  Result := NULL;

  if not(Assigned(mDataSet)) or not(Assigned(mDataSet.ConnectorUsed)) then
    Exit;

  if not(avoExecute in mOptions[pMode]) then
    Exit;
  if (avoNeedSequence in mOptions[pMode]) and (mSequenceName = '') then
    Exit;
  if (avoNeedTable in mOptions[pMode]) and (mDataSet.TableName = '') then
    Exit;
  if (avoPreventWhenAuto in mOptions[pMode]) and (mAutoDetected) then
    Exit;
  if (avoPreventWhenExplicitByDBMS in mOptions[pMode]) and (mExplicitInsertByDBMS) then
    Exit;
  if (avoExecWhenAuto in mOptions[pMode]) and not(mAutoDetected) and (not(avoExecWhenExplicitByDBMS in mOptions[pMode]) or not(mExplicitInsertByDBMS)) then
    Exit;
  if (avoExecWhenExplicitByDBMS in mOptions[pMode]) and not(mExplicitInsertByDBMS) and (not(avoExecWhenAuto in mOptions[pMode]) or not(mAutoDetected)) then
    Exit;

  if (pMode = avGMBeforePost) then
  begin
    // gen stmt to detect next inserted id, execute and return
    lStmt := TSFStmt.Create(nil);
    lDataSet := mDataSet.ConnectorUsed.GetNewQuery(mDataSet.Transaction, atSelect);
    try
      lStmt.DBDialect := mDataSet.MappedStmtDBDialect;
      lStmt.QuoteType := mDataSet.QueryQuoteType;
      if (avoNeedSequence in mOptions[pMode]) then
        lStmtStr := lStmt.GetNextAutoValueStmt(mSequenceName)
      else if (avoNeedTable in mOptions[pMode]) then
        lStmtStr := lStmt.GetNextAutoValueStmt(mDataSet.TableName)
      else
        lStmtStr := lStmt.GetNextAutoValueStmt;

      mDataSet.ConnectorUsed.SetSQLToQuery(lStmtStr, lDataSet);
      lDataSet.Open;
      if not(lDataSet.IsEmpty) then
        Result := lDataSet.Fields[0].Value;
    finally
      FreeAndNil(lDataSet);
      FreeAndNil(lStmt);
    end;
  end else
  if (pMode = avGMAfterPost) and (Assigned(mDataSet)) and (Assigned(mDataSet.ConnectorUsed)) then
  begin
    // gen stmt to detect last inserted id, execute and return
    lStmt := TSFStmt.Create(nil);
    lDataSet := mDataSet.ConnectorUsed.GetNewQuery(mDataSet.Transaction, atSelect);
    try
      lStmt.DBDialect := mDataSet.MappedStmtDBDialect;
      lStmt.QuoteType := mDataSet.QueryQuoteType;
      if (avoNeedSequence in mOptions[pMode]) then
        lStmtStr := lStmt.GetLastAutoValueStmt(mSequenceName)
      else if (avoNeedTable in mOptions[pMode]) then
        lStmtStr := lStmt.GetLastAutoValueStmt(mDataSet.TableName)
      else
        lStmtStr := lStmt.GetLastAutoValueStmt;

      mDataSet.ConnectorUsed.SetSQLToQuery(lStmtStr, lDataSet);
      lDataSet.Open;
      if not(lDataSet.IsEmpty) then
        Result := lDataSet.Fields[0].Value;
    finally
      FreeAndNil(lDataSet);
      FreeAndNil(lStmt);
    end;
  end;
end;

function TSFBDSAutoValueGenerator.getOptions(pMode: TSFBDSAutoValueGetMode): TSFBDSAutoValueOptions;
begin
  Result := mOptions[pMode];
end;

procedure TSFBDSAutoValueGenerator.setOptions(pMode: TSFBDSAutoValueGetMode; pOptions: TSFBDSAutoValueOptions);
begin
  mOptions[pMode] := pOptions;
end;

// ===========================================================================//
//                              TSFBDSStmtParamItem                           //
// ===========================================================================//

constructor TSFBDSStmtParamItem.Create(Collection: TCollection);
begin
  inherited;

  mValue := NULL;
  mName := '';
  mAutoGenerated := False;
end;

procedure TSFBDSStmtParamItem.setName(pName: String);
begin
  if (pName <> mName) then
  begin
    if (mAutoGenerated) then
      SFBDSDataError(bdsErrNameOnAutoGenParamVal, [])
    else
      mName := pName;
  end;
end;

initialization
begin
  TSFBusinessClassFactory.cClasses := TObjectList<TSFBusinessClassItem>.Create;
end;

finalization
begin
  TSFBusinessClassFactory.cClasses.Clear;
  TSFBusinessClassFactory.cClasses.Free;
end;

end.
