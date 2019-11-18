//
//   Title:         SFBusinessDataConnector
//
//   Description:   connectors (data access) for specific business-datasets
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFBusinessDataConnector;

interface

{$I SFBusinessData.INC}
{$I SFBusinessDataConnectivity.INC}

uses
  Data.DB, System.Generics.Collections, System.Classes, System.SysUtils, SFBusinessDataCommon,
  {$IFDEF HASFIREDAC}
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DAPt, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Comp.UI, FireDAC.UI.Intf, FireDAC.Stan.Intf,
  FireDac.Stan.Param, FireDAC.Stan.Option,
  {$ENDIF HASFIREDAC}
  {$IFDEF HASIBX}
  {$IFDEF VERSMALLER_XE6}
  IBDatabase, IBQuery, IBTable,
  {$ELSE}
  IBX.IBDatabase, IBX.IBQuery, IBX.IBTable,
  {$ENDIF VERSMALLER_XE6}
  {$ENDIF HASIBX}
  Data.SqlExpr, Datasnap.DBClient, Datasnap.Provider
  {$IFDEF MSWINDOWS}, Data.Win.ADODB{$ENDIF MSWINDOWS};

type
  TSFConnectionType =
    ( {$IFDEF HASFIREDAC}
        ctFireDac,
      {$ENDIF HASFIREDAC}
      ctDBExpress
      {$IFDEF HASIBX}
        , ctInterbase
      {$ENDIF HASIBX}
      {$IFDEF MSWINDOWS}
        , ctADO
      {$ENDIF MSWINDOWS}
    );

  TSFConnectionDBType =
    (dbtDB2,
      dbtFB,
      dbtIB,
      dbtMSSQL,
      dbtMySQL,
      dbtOra,
      dbtSQLLite,
      dbtPG,
      dbtMSAcc,
      dbtAdvantage,
      dbtInformix,
      dbtAnywhere,
      dbtSybase,
      dbtUnknown);

  TSFQueryActionType =
    (
      atSelect,
      atModify
    );


  TSFConnectorDSCreatedEvt = procedure(pDataSet: TDataSet; pActionType: TSFQueryActionType) of object;

  TSFConnectionMap = class;

  TSFConnectionMapCls = class of TSFConnectionMap;
  TSFCustomConnectionCls = class of TCustomConnection;

  TSFConnectionMapItm = class(TObject)
    private
      mType: TSFConnectionType;
      mCls: TSFConnectionMapCls;
    public
      constructor Create(pType: TSFConnectionType; pCls: TSFConnectionMapCls);
  end;

  TSFConnector = class(TComponent)
    private
      mConnectionType: TSFConnectionType;
      mConnection: TCustomConnection;
      mCommonConnector: Boolean;
      mDBType: TSFConnectionDBType;
      mFormatOptions: TSFBDSFormatOptions;
      mConnectorMsgProcs: Array of TSFBDSMessageProc;
      mOnDataSetCreated: TSFConnectorDSCreatedEvt;
      class var cConnectionMap: TObjectList<TSFConnectionMapItm>;
      class var cCommonConnector: TSFConnector;
      class var cCommonConnectedProcs: Array of TSFBDSMessageProc;
    private
      procedure setConnectionType(pType: TSFConnectionType);
      procedure setConnection(pConn: TCustomConnection);
      procedure setCommonConnector(pCommon: Boolean);
      function getDBType: TSFConnectionDBType;
      procedure setFormatOptions(pFrmtOptions: TSFBDSFormatOptions);
    private
      procedure notifyConnectorMsgProcs(pComp: TComponent; pMsgType: Word);
      class procedure addConnectionMap(pType: TSFConnectionType; pCls: TSFConnectionMapCls);
      class function getConnectionMapByType(pType: TSFConnectionType): TSFConnectionMapCls;
      class procedure notifyCommonConnectedProcs(pComp: TComponent; pMsgType: Word);
      class function getConnectorMsgProc(var pArray: Array of TSFBDSMessageProc; pProc: TSFBDSMessageProc): Integer;
      class procedure moveConnectorMsgProc(var pArray: Array of TSFBDSMessageProc; pFrom: Integer);
    public
      function GetNewQuery(pTransaction: TComponent; pActionType: TSFQueryActionType; pCanUniDir: Boolean = True): TDataSet;
      function GetNewTable(pTransaction: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
      function GetKeyFields(pTableName, pCatalog, pSchema: String): String;
      function GetFieldNames(pTableName, pCatalog, pSchema: String): TStringList;
      function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
      function QueryExecSQL(pDataSet: TDataSet): LongInt;
      procedure SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType = ftUnknown);
      function GetQueryParamName(pParam: TCollectionItem): String;
      function SequenceNameForField(pField: TField): String;
      function GetConnectionDBType: TSFConnectionDBType;
      function CheckTransaction(pTransaction: TComponent; pSilent: Boolean = False): Boolean;
      function HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean;
      procedure StartTransactionForDataSet(pDataSet: TDataSet);
      procedure CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean);
      function ActiveTransactionForDataSet(pDataSet: TDataSet): Boolean;
      function CanDBInsertion(pDataSet: TDataSet): Boolean;
      procedure AddConnectorMsgNotification(pProc: TSFBDSMessageProc);
      procedure RemoveConnectorMsgNotification(pProc: TSFBDSMessageProc);
      class function GetCommonConnector: TSFConnector;
      class procedure AddCommonConnectedProc(pProc: TSFBDSMessageProc);
      class procedure RemoveCommonConnectedProc(pProc: TSFBDSMessageProc);
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ConnectionType: TSFConnectionType read mConnectionType write setConnectionType;
      property Connection: TCustomConnection read mConnection write setConnection;
      property CommonConnector: Boolean read mCommonConnector write setCommonConnector;
      property ConnectionDBType: TSFConnectionDBType read getDBType write mDBType;
      property FormatOptions: TSFBDSFormatOptions read mFormatOptions write setFormatOptions;
      property OnDataSetCreated: TSFConnectorDSCreatedEvt read mOnDataSetCreated write mOnDataSetCreated;
  end;

  TSFConnectionMap = class(TObject)
    protected
      class function GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs; virtual;
      class procedure InitDataSetForIndexDefs(pDataSet: TDataSet); virtual;
    public
      class function GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet; virtual; abstract;
      class function GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet; virtual; abstract;
      class function GetKeyFields(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): String; virtual;
      class function GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList; virtual;
      class function GetRequiredConnectionClass: TSFCustomConnectionCls; virtual;
      class function GetRequiredTransactionClass: TComponentClass; virtual;
      class function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection; virtual; abstract;
      class function QueryExecSQL(pDataSet: TDataSet): LongInt; virtual; abstract;
      class procedure SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType); virtual;
      class function GetQueryParamName(pParam: TCollectionItem): String; virtual;
      class function GetSequenceNameForField(pField: TField): String; virtual;
      class function GetDBType(pConnection: TCustomConnection): TSFConnectionDBType; virtual;
      class function HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean; virtual;
      class procedure StartTransactionForDataSet(pDataSet: TDataSet); virtual;
      class procedure CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean); virtual;
      class function DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean; virtual;
      class function CanDBInsertion(pDataSet: TDataSet): Boolean; virtual;
  end;

  {$IFDEF HASFIREDAC}
  TSFConnectionMapFD = class(TSFConnectionMap)
    protected
      class function GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs; override;
    public
      class function GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet; override;
      class function GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet; override;
      class function GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList; override;
      class function GetRequiredConnectionClass: TSFCustomConnectionCls; override;
      class function GetRequiredTransactionClass: TComponentClass; override;
      class function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection; override;
      class function QueryExecSQL(pDataSet: TDataSet): LongInt; override;
      class procedure SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType); override;
      class function GetQueryParamName(pParam: TCollectionItem): String; override;
      class function GetDBType(pConnection: TCustomConnection): TSFConnectionDBType; override;
      class function GetSequenceNameForField(pField: TField): String; override;
      class function HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean; override;
      class procedure StartTransactionForDataSet(pDataSet: TDataSet); override;
      class procedure CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean); override;
      class function DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean; override;
      class function CanDBInsertion(pDataSet: TDataSet): Boolean; override;
  end;
  {$ENDIF HASFIREDAC}

  TSFConnectionMapSQL = class(TSFConnectionMap)
    private
      class function getProviderDataSet(pDataSet: TDataSet): TDataSet;
    protected
      class function GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs; override;
      class procedure InitDataSetForIndexDefs(pDataSet: TDataSet); override;
    public
      class function GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet; override;
      class function GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet; override;
      class function GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList; override;
      class function GetRequiredConnectionClass: TSFCustomConnectionCls; override;
      class function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection; override;
      class function QueryExecSQL(pDataSet: TDataSet): LongInt; override;
      class function GetDBType(pConnection: TCustomConnection): TSFConnectionDBType; override;
  end;

  {$IFDEF HASIBX}
  TSFConnectionMapIB = class(TSFConnectionMap)
    protected
      class function GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs; override;
    public
      class function GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet; override;
      class function GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet; override;
      class function GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList; override;
      class function GetRequiredConnectionClass: TSFCustomConnectionCls; override;
      class function GetRequiredTransactionClass: TComponentClass; override;
      class function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection; override;
      class function QueryExecSQL(pDataSet: TDataSet): LongInt; override;
      class function GetDBType(pConnection: TCustomConnection): TSFConnectionDBType; override;
      class function HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean; override;
      class procedure StartTransactionForDataSet(pDataSet: TDataSet); override;
      class procedure CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean); override;
      class function DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean; override;
      class function CanDBInsertion(pDataSet: TDataSet): Boolean; override;
  end;
  {$ENDIF HASIBX}

  {$IFDEF MSWINDOWS}
  TSFConnectionMapADO = class(TSFConnectionMap)
    protected
      class function GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs; override;
    public
      class function GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet; override;
      class function GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet; override;
      class function GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList; override;
      class function GetRequiredConnectionClass: TSFCustomConnectionCls; override;
      class function SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection; override;
      class function QueryExecSQL(pDataSet: TDataSet): LongInt; override;
      class procedure SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType); override;
      class function GetQueryParamName(pParam: TCollectionItem): String; override;
  end;
  {$ENDIF MSWINDOWS}

implementation

uses System.StrUtils{$IFDEF HASIBX}{$IFDEF VERSMALLER_XE6}, IBCustomDataSet{$ELSE}, IBX.IBCustomDataSet{$ENDIF VERSMALLER_XE6}{$ENDIF HASIBX}, System.Variants;

// ===========================================================================//
//                            TSFConnectionMapItm                             //
// ===========================================================================//

constructor TSFConnectionMapItm.Create(pType: TSFConnectionType; pCls: TSFConnectionMapCls);
begin
  inherited Create;

  mType := pType;
  mCls := pCls;
end;

// ===========================================================================//
//                                TSFConnector                                //
// ===========================================================================//

constructor TSFConnector.Create(pOwner: TComponent);
begin
  inherited;

  mConnectionType := ctDBExpress;
  mConnection := nil;
  mCommonConnector := false;
  mDBType := dbtUnknown;
  Finalize(mConnectorMsgProcs);
  mFormatOptions := TSFBDSFormatOptions.Create;
  mFormatOptions.QuoteType := Low(TSFBDSQuoteTypeDflt);
  mOnDataSetCreated := nil;
end;

destructor TSFConnector.Destroy;
begin
  if (cCommonConnector = Self) then
  begin
    notifyCommonConnectedProcs(Self, SFBDSMSGTYPE_COMMONCONNCHANGED);
    cCommonConnector := nil;
  end;

  Finalize(mConnectorMsgProcs);

  FreeAndNil(mFormatOptions);

  inherited;
end;

function TSFConnector.GetNewQuery(pTransaction: TComponent; pActionType: TSFQueryActionType; pCanUniDir: Boolean = True): TDataSet;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := nil;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetNewQuery(mConnection, pTransaction, pActionType, pCanUniDir);

  if (Result <> nil) and (Assigned(mOnDataSetCreated)) then
    mOnDataSetCreated(Result, pActionType);
end;

function TSFConnector.GetNewTable(pTransaction: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := nil;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetNewTable(mConnection, pTransaction, pActionType, pTableName, pCatalog, pSchema);

  if (Result <> nil) and (Assigned(mOnDataSetCreated)) then
    mOnDataSetCreated(Result, pActionType);
end;

function TSFConnector.GetKeyFields(pTableName, pCatalog, pSchema: String): String;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := '';

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetKeyFields(mConnection, pTableName, pCatalog, pSchema);
end;

function TSFConnector.GetFieldNames(pTableName, pCatalog, pSchema: String): TStringList;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := nil;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetFieldNames(mConnection, pTableName, pCatalog, pSchema);
end;

function TSFConnector.SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := nil;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.SetSQLToQuery(pSQL, pDataSet);
end;

function TSFConnector.QueryExecSQL(pDataSet: TDataSet): LongInt;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := 0;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.QueryExecSQL(pDataSet);
end;

procedure TSFConnector.SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType);
  var lMapCls: TSFConnectionMapCls;
begin
  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    lMapCls.SetQueryParamValue(pParam, pValue, pDataType);
end;

function TSFConnector.GetQueryParamName(pParam: TCollectionItem): String;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := '';

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetQueryParamName(pParam);
end;

function TSFConnector.SequenceNameForField(pField: TField): String;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := '';

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetSequenceNameForField(pField);
end;

function TSFConnector.GetConnectionDBType: TSFConnectionDBType;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := dbtUnknown;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.GetDBType(mConnection);
end;

function TSFConnector.CheckTransaction(pTransaction: TComponent; pSilent: Boolean): Boolean;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := True;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls = nil) then
  begin
    Result := False;
    if not(pSilent) then
      SFBDSDataError(bdsErrConnectionTypeRequired, [])
  end
  else if (lMapCls.GetRequiredTransactionClass = nil) then
  begin
    Result := False;
    if not(pSilent) then
      SFBDSDataError(bdsErrNoTransactionForType, [])
  end
  else if not(pTransaction is lMapCls.GetRequiredTransactionClass) then
  begin
    Result := False;
    if not(pSilent) then
      SFBDSDataError(bdsErrInvalidTransactionType, []);
  end;
end;

function TSFConnector.HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := False;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) and (pTransaction <> nil) then
    Result := lMapCls.HasDataSetTransaction(pDataSet, pTransaction);
end;

procedure TSFConnector.StartTransactionForDataSet(pDataSet: TDataSet);
  var lMapCls: TSFConnectionMapCls;
begin
  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    lMapCls.StartTransactionForDataSet(pDataSet);
end;

procedure TSFConnector.CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean);
  var lMapCls: TSFConnectionMapCls;
begin
  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    lMapCls.CommitTransactionForDataSet(pDataSet, pRetain);
end;

function TSFConnector.ActiveTransactionForDataSet(pDataSet: TDataSet): Boolean;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := False;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.DataSetHasActiveTransaction(pDataSet);
end;

function TSFConnector.CanDBInsertion(pDataSet: TDataSet): Boolean;
  var lMapCls: TSFConnectionMapCls;
begin
  Result := False;

  lMapCls := getConnectionMapByType(mConnectionType);
  if (lMapCls <> nil) then
    Result := lMapCls.CanDBInsertion(pDataSet);
end;

procedure TSFConnector.AddConnectorMsgNotification(pProc: TSFBDSMessageProc);
begin
  if (getConnectorMsgProc(mConnectorMsgProcs, pProc) < 0) then
  begin
    SetLength(mConnectorMsgProcs, Length(mConnectorMsgProcs) + 1);
    mConnectorMsgProcs[High(mConnectorMsgProcs)] := pProc;
  end;
end;

procedure TSFConnector.RemoveConnectorMsgNotification(pProc: TSFBDSMessageProc);
  var lIdx: Integer;
begin
  lIdx := getConnectorMsgProc(mConnectorMsgProcs, pProc);
  if (lIdx >= 0) then
  begin
    moveConnectorMsgProc(mConnectorMsgProcs, lIdx);
    SetLength(mConnectorMsgProcs, Length(mConnectorMsgProcs) - 1);
  end;
end;

class function TSFConnector.GetCommonConnector: TSFConnector;
begin
  Result := cCommonConnector;
end;

class procedure TSFConnector.AddCommonConnectedProc(pProc: TSFBDSMessageProc);
begin
  if (getConnectorMsgProc(cCommonConnectedProcs, pProc) < 0) then
  begin
    SetLength(cCommonConnectedProcs, Length(cCommonConnectedProcs) + 1);
    cCommonConnectedProcs[High(cCommonConnectedProcs)] := pProc;
  end;
end;

class procedure TSFConnector.RemoveCommonConnectedProc(pProc: TSFBDSMessageProc);
  var lIdx: Integer;
begin
  lIdx := getConnectorMsgProc(cCommonConnectedProcs, pProc);
  if (lIdx >= 0) then
  begin
    moveConnectorMsgProc(cCommonConnectedProcs, lIdx);
    SetLength(cCommonConnectedProcs, Length(cCommonConnectedProcs) - 1);
  end;
end;

procedure TSFConnector.setConnectionType(pType: TSFConnectionType);
  var lMapCls: TSFConnectionMapCls;
begin
  if (mConnectionType <> pType) then
  begin
    mConnectionType := pType;

    if (Assigned(cCommonConnector)) and (cCommonConnector = Self) then
      notifyCommonConnectedProcs(Self, SFBDSMSGTYPE_CONNTYPECHANGED);

    notifyConnectorMsgProcs(Self, SFBDSMSGTYPE_CONNTYPECHANGED);
  end;

  lMapCls := getConnectionMapByType(pType);
  if (lMapCls = nil) or (lMapCls.GetRequiredConnectionClass = nil) or ((Assigned(mConnection)) and not(mConnection is lMapCls.GetRequiredConnectionClass)) then
    Connection := nil
end;

procedure TSFConnector.setConnection(pConn: TCustomConnection);
  var lMapCls: TSFConnectionMapCls;
      lConnectionDBType: TSFConnectionDBType;
begin
  lMapCls := getConnectionMapByType(mConnectionType);
  if (pConn = nil) or (lMapCls = nil) or (lMapCls.GetRequiredConnectionClass = nil) then
    pConn := nil
  else if not(pConn is lMapCls.GetRequiredConnectionClass) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (pConn <> mConnection) then
  begin
    mConnection := pConn;

    if (Assigned(cCommonConnector)) and (cCommonConnector = Self) then
      notifyCommonConnectedProcs(Self, SFBDSMSGTYPE_CONNECTIONCHANGED);

    notifyConnectorMsgProcs(Self, SFBDSMSGTYPE_CONNECTIONCHANGED);
  end;

  if (Assigned(mConnection)) then
  begin
    lConnectionDBType := GetConnectionDBType;
    if (lConnectionDBType <> dbtUnknown) and (lConnectionDBType <> mDBType) then
      mDBType := lConnectionDBType;
  end;
end;

procedure TSFConnector.setCommonConnector(pCommon: Boolean);
begin
  if (pCommon) then
  begin
    if (cCommonConnector = nil) then
    begin
      mCommonConnector := pCommon;
      cCommonConnector := Self;
      notifyCommonConnectedProcs(Self, SFBDSMSGTYPE_COMMONCONNCHANGED);
    end else
    if (cCommonConnector <> Self) then
      SFBDSDataError(bdsErrCommonConnectorExists, []);
  end else
  begin
    mCommonConnector := pCommon;
    if (cCommonConnector <> nil) and (cCommonConnector = Self) then
    begin
      notifyCommonConnectedProcs(Self, SFBDSMSGTYPE_COMMONCONNCHANGED);
      cCommonConnector := nil;
    end;
  end;
end;

function TSFConnector.getDBType: TSFConnectionDBType;
begin
  Result := mDBType;
  if (Result = dbtUnknown) then
    Result := GetConnectionDBType;

  if (Result <> mDBType) then
    mDBType := Result;
end;

procedure TSFConnector.setFormatOptions(pFrmtOptions: TSFBDSFormatOptions);
begin
  mFormatOptions.Assign(pFrmtOptions);
end;

procedure TSFConnector.notifyConnectorMsgProcs(pComp: TComponent; pMsgType: Word);
  var i: Integer;
begin
  for i := Low(mConnectorMsgProcs) to High(mConnectorMsgProcs) do
    mConnectorMsgProcs[i](pComp, SFBDSMSG_CONNECTORMESSAGE, pMsgType);

  {
  for i := 0 to (mConnectorMsgComp.Count - 1) do
    SFBDSSendMsg(pComp, mConnectorMsgComp[i], SFBDSMSG_CONNECTORMESSAGE, pMsgType);
  }
end;

class procedure TSFConnector.addConnectionMap(pType: TSFConnectionType; pCls: TSFConnectionMapCls);
  var lNewItem: TSFConnectionMapItm;
begin
  if (getConnectionMapByType(pType) = nil) then
  begin
    if not(Assigned(cConnectionMap)) then
      cConnectionMap := TObjectList<TSFConnectionMapItm>.Create;

    lNewItem := TSFConnectionMapItm.Create(pType, pCls);
    cConnectionMap.Add(lNewItem);
  end else
    SFBDSDataError(bdsErrConnectionMapExists, []);
end;

class function TSFConnector.getConnectionMapByType(pType: TSFConnectionType): TSFConnectionMapCls;
  var i: Integer;
begin
  Result := nil;

  if not(Assigned(cConnectionMap)) then
    Exit;

  for i := 0 to (cConnectionMap.Count - 1) do
  begin
    if (cConnectionMap[i].mType = pType) then
    begin
      Result := cConnectionMap[i].mCls;
      Exit;
    end;
  end;
end;

class procedure TSFConnector.notifyCommonConnectedProcs(pComp: TComponent; pMsgType: Word);
  var i: Integer;
begin
  for i := Low(cCommonConnectedProcs) to High(cCommonConnectedProcs) do
    cCommonConnectedProcs[i](pComp, SFBDSMSG_CONNECTORMESSAGE, pMsgType);

  {
  for i := 0 to (cCommonConnectedComps.Count - 1) do
    SFBDSSendMsg(pComp, cCommonConnectedComps[i], SFBDSMSG_CONNECTORMESSAGE, pMsgType);
  }
end;

class function TSFConnector.getConnectorMsgProc(var pArray: Array of TSFBDSMessageProc; pProc: TSFBDSMessageProc): Integer;
  var i: Integer;
begin
  for i := Low(pArray) to High(pArray) do
  begin
    if (@pArray[i] = @pProc) then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

class procedure TSFConnector.moveConnectorMsgProc(var pArray: Array of TSFBDSMessageProc; pFrom: Integer);
  var i: Integer;
begin
  if (pFrom >= 0) and (pFrom < High(pArray)) then
  begin
    for i := pFrom to (High(pArray) - 1) do
      pArray[i] := pArray[i + 1];
  end;
end;

// ===========================================================================//
//                              TSFConnectionMap                              //
// ===========================================================================//

class function TSFConnectionMap.GetKeyFields(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): String;
  var lTable: TDataSet;
      lIndexDefs: TIndexDefs;
      i: Integer;
begin
  Result := '';

  lTable := GetNewTable(pConnection, nil, atSelect, pTableName, pCatalog, pSchema);
  try
    if (Assigned(lTable)) then
    begin
      InitDataSetForIndexDefs(lTable);
      lIndexDefs := GetIndexDefsForDataSet(lTable);
      if (lIndexDefs <> nil) then
      begin
        if not(lIndexDefs.Updated) then
          lIndexDefs.Update;

        for i := 0 to (lIndexDefs.Count - 1) do
        begin
          if not(ixPrimary in lIndexDefs[i].Options) and not (ixUnique in lIndexDefs[i].Options) then
            Continue;

          if (Result <> '') then
            Result := Result + ';';

          Result := lIndexDefs[i].Fields;
        end;
      end;
    end;
  finally
    if (Assigned(lTable)) then
      FreeAndNil(lTable);
  end;
end;

class function TSFConnectionMap.GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList;
begin
  Result := nil;
end;

class function TSFConnectionMap.GetRequiredConnectionClass: TSFCustomConnectionCls;
begin
  Result := nil;
end;

class function TSFConnectionMap.GetRequiredTransactionClass: TComponentClass;
begin
  Result := nil;
end;

class procedure TSFConnectionMap.SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType);
begin
  if (pParam is TParam) then
  begin
    if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) or (pDataType <> ftUnknown) then
      TParam(pParam).DataType := pDataType;

    TParam(pParam).Value := pValue;
  end;
end;

class function TSFConnectionMap.GetQueryParamName(pParam: TCollectionItem): String;
begin
  Result := '';

  if (pParam is TParam) then
    Result := TParam(pParam).Name;
end;

class function TSFConnectionMap.GetSequenceNameForField(pField: TField): String;
begin
  Result := '';
end;

class function TSFConnectionMap.GetDBType(pConnection: TCustomConnection): TSFConnectionDBType;
begin
  Result := dbtUnknown;
end;

class function TSFConnectionMap.HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean;
begin
  Result := False;
end;

class procedure TSFConnectionMap.StartTransactionForDataSet(pDataSet: TDataSet);
begin
  // nothing to do
end;

class procedure TSFConnectionMap.CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean);
begin
  // nothing to do
end;

class function TSFConnectionMap.DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean;
begin
  Result := False;
end;

class function TSFConnectionMap.CanDBInsertion(pDataSet: TDataSet): Boolean;
begin
  Result := True;
end;

class function TSFConnectionMap.GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs;
begin
  Result := (pDataSet as IProviderSupportNG).PSGetIndexDefs([ixPrimary..ixNonMaintained]);
end;

class procedure TSFConnectionMap.InitDataSetForIndexDefs(pDataSet: TDataSet);
begin
  // nothing to do
end;

{$IFDEF HASFIREDAC}
// ===========================================================================//
//                             TSFConnectionMapFD                             //
// ===========================================================================//

class function TSFConnectionMapFD.GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TFDConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (Assigned(pTransAct)) and not(pTransAct is TFdTransaction) then
    SFBDSDataError(bdsErrInvalidTransactionType, []);

  Result := TFDQuery.Create(nil);
  TFDQuery(Result).Connection := TFDConnection(pConnection);
  if (Assigned(pTransAct)) then
    TFDQuery(Result).Transaction := TFdTransaction(pTransAct)
  else if (Assigned(TFDConnection(pConnection).UpdateTransaction)) and (pActionType = atModify) then
    TFDQuery(Result).Transaction := TFDConnection(pConnection).UpdateTransaction;
end;

class function TSFConnectionMapFD.GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TFDConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (Assigned(pTransAct)) and not(pTransAct is TFdTransaction) then
    SFBDSDataError(bdsErrInvalidTransactionType, []);

  Result := TFDTable.Create(nil);
  TFDTable(Result).Connection := TFDConnection(pConnection);
  if (Assigned(pTransAct)) then
    TFDTable(Result).Transaction := TFdTransaction(pTransAct);

  TFDTable(Result).TableName := pTableName;
  TFDTable(Result).CatalogName := pCatalog;
  TFDTable(Result).SchemaName := pSchema;
end;

class function TSFConnectionMapFD.GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList;
begin
  if not(Assigned(pConnection)) or not(pConnection is TFdConnection) then
    Result := inherited GetFieldNames(pConnection, pTableName, pCatalog, pSchema)
  else
  begin
    Result := TStringList.Create;
    TFdConnection(pConnection).GetFieldNames(pCatalog, pSchema, pTableName, '', Result);
  end;
end;

class function TSFConnectionMapFD.GetRequiredConnectionClass: TSFCustomConnectionCls;
begin
  Result := TFdConnection;
end;

class function TSFConnectionMapFD.GetRequiredTransactionClass: TComponentClass;
begin
  Result := TFdTransaction;
end;

class function TSFConnectionMapFD.SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
begin
  Result := nil;
  if (pDataSet is TFDQuery) then
  begin
    TFDQuery(pDataSet).SQL.Clear;
    TFDQuery(pDataSet).SQL.Add(pSQL);
    Result := TFDQuery(pDataSet).Params;
  end;
end;

class function TSFConnectionMapFD.QueryExecSQL(pDataSet: TDataSet): LongInt;
begin
  Result := 0;
  if (pDataSet is TFDQuery) then
    TFDQuery(pDataSet).ExecSQL;
end;

class procedure TSFConnectionMapFD.SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType);
begin
  if (pParam is TFDParam) then
  begin
    if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) or (pDataType <> ftUnknown) then
      TFDParam(pParam).DataType := pDataType;

    TFDParam(pParam).Value := pValue;
  end;
end;

class function TSFConnectionMapFD.GetQueryParamName(pParam: TCollectionItem): String;
begin
  Result := '';

  if (pParam is TFDParam) then
    Result := TFDParam(pParam).Name;
end;

class function TSFConnectionMapFD.GetDBType(pConnection: TCustomConnection): TSFConnectionDBType;
  var lDriver, lDriverDef: String;
      lConnStrings: TStrings;
      i: Integer;
begin
  Result := inherited GetDBType(pConnection);
  if (Assigned(pConnection)) and (pConnection is TFDConnection) then
  begin
    lConnStrings := nil;
    lDriver := '';

    if (TFDConnection(pConnection).Params.Count > 0) then
      lConnStrings := TFDConnection(pConnection).Params
    else if (TFDConnection(pConnection).ConnectionDefName <> '') and (FDManager.ConnectionDefs.FindConnectionDef(TFDConnection(pConnection).ConnectionDefName) <> nil) then
      lConnStrings := FDManager.ConnectionDefs.ConnectionDefByName(TFDConnection(pConnection).ConnectionDefName).Params;

    if (lConnStrings <> nil) then
    begin
      lDriverDef := 'DRIVERID=';
      for i := 0 to (lConnStrings.Count - 1) do
      begin
        if (UpperCase(LeftStr(lConnStrings[i], Length(lDriverDef))) = lDriverDef) then
        begin
          lDriver := UpperCase(RightStr(lConnStrings[i], Length(lConnStrings[i]) - Length(lDriverDef)));
          Break;
        end;
      end;
    end;

    if (lDriver = 'DB2') then
      Result := dbtDB2
    else if (lDriver = 'FB') then
      Result := dbtFB
    else if (lDriver = 'IB') then
      Result := dbtIB
    else if (lDriver = 'MSSQL') then
      Result := dbtMSSQL
    else if (lDriver = 'MYSQL') then
      Result := dbtMySQL
    else if (lDriver = 'ORA') then
      Result := dbtOra
    else if (lDriver = 'SQLLITE') then
      Result := dbtSQLLite
    else if (lDriver = 'PG') then
      Result := dbtPG
    else if (lDriver = 'MSACC') then
      Result := dbtMSAcc
    else if (lDriver = 'ADS') then
      Result := dbtAdvantage
    else if (lDriver = 'ASA') then
      Result := dbtAnywhere;
  end;
end;

class function TSFConnectionMapFD.GetSequenceNameForField(pField: TField): String;
begin
  Result := inherited GetSequenceNameForField(pField);
  if (pField is TFDAutoIncField) then
    Result := TFDAutoIncField(pField).GeneratorName;
end;

class function TSFConnectionMapFD.HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean;
begin
  Result := False;

  if (pDataSet is TFdQuery) and (pTransaction <> nil) then
    Result := Assigned(TFdQuery(pDataSet).Transaction) and (TFdQuery(pDataSet).Transaction = pTransaction)
  else if (pDataSet is TFdTable) and (pTransaction <> nil) then
    Result := Assigned(TFdTable(pDataSet).Transaction) and (TFdTable(pDataSet).Transaction = pTransaction);
end;

class procedure TSFConnectionMapFD.StartTransactionForDataSet(pDataSet: TDataSet);
begin
  if (pDataSet is TFdQuery) and (Assigned(TFdQuery(pDataSet).Transaction)) and not(TFdQuery(pDataSet).Transaction.Active) then
    TFdQuery(pDataSet).Transaction.StartTransaction
  else if (pDataSet is TFdTable) and (Assigned(TFdTable(pDataSet).Transaction)) and not(TFdTable(pDataSet).Transaction.Active) then
    TFdTable(pDataSet).Transaction.StartTransaction;
end;

class procedure TSFConnectionMapFD.CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean);
  var lTransaction: TFdCustomTransaction;
begin
  lTransaction := nil;
  if (pDataSet is TFdQuery) and (Assigned(TFdQuery(pDataSet).Transaction)) and (TFdQuery(pDataSet).Transaction.Active) then
    lTransaction := TFdQuery(pDataSet).Transaction
  else if (pDataSet is TFdTable) and (Assigned(TFdTable(pDataSet).Transaction)) and (TFdTable(pDataSet).Transaction.Active) then
    lTransaction := TFdTable(pDataSet).Transaction;

  if (lTransaction <> nil) then
  begin
    if (pRetain) then
      lTransaction.CommitRetaining
    else
      lTransaction.Commit;
  end;
end;

class function TSFConnectionMapFD.DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean;
  var lTransaction: TFdCustomTransaction;
      lConnection: TFdCustomConnection;
begin
  Result := False;

  if not(Assigned(pDataSet)) or not(pDataSet is TFdQuery) and not(pDataSet is TFdTable) then
    Exit;

  if (pDataSet is TFdQuery) then
  begin
    lTransaction := TFDQuery(pDataSet).Transaction;
    lConnection := TFdQuery(pDataSet).Connection;
  end else
  begin
    lTransaction := TFdTable(pDataSet).Transaction;
    lConnection := TFdTable(pDataSet).Connection;
  end;

  if (lTransaction = nil) and (lConnection <> nil) then
    lTransaction := lConnection.Transaction;

  if (lTransaction <> nil) then
    Result := lTransaction.Active;
end;

class function TSFConnectionMapFD.CanDBInsertion(pDataSet: TDataSet): Boolean;
  var lTransaction: TFdCustomTransaction;
begin
  Result := False;

  if not(Assigned(pDataSet)) or not(pDataSet is TFdQuery) and not(pDataSet is TFdTable) then
    Exit;

  lTransaction := nil;
  if (pDataSet is TFdQuery) and (Assigned(TFdQuery(pDataSet).Transaction)) then
    lTransaction := TFdQuery(pDataSet).Transaction
  else if (pDataSet is TFdTable) and (Assigned(TFdTable(pDataSet).Transaction)) then
    lTransaction := TFdTable(pDataSet).Transaction;

  if (lTransaction <> nil) then
  begin
    if (lTransaction.Active) then
      Result := True
    else if (lTransaction.Options.AutoStart) then
      Result := lTransaction.Options.AutoCommit or (lTransaction.Options.DisconnectAction = xdCommit)
    else
      Result := False;
  end else
    Result := True;
end;

class function TSFConnectionMapFD.GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs;
begin
  if not(pDataSet is TFDDataSet) then
    Result := inherited GetIndexDefsForDataSet(pDataSet)
  else
    Result := TFDDataSet(pDataSet).IndexDefs;
end;

{$ENDIF HASFIREDAC}

// ===========================================================================//
//                            TSFConnectionMapSQL                             //
// ===========================================================================//

class function TSFConnectionMapSQL.GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet;
  var lObjRslt: TSQLQuery;
      lObjRsltProvider: TDataSetProvider;
begin
  if not(Assigned(pConnection)) or not(pConnection is TSQLConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (pCanUni) then
  begin
    Result := TSQLQuery.Create(nil);
    TSQLQuery(Result).SQLConnection := TSQLConnection(pConnection);
  end else
  begin
    Result := TClientDataSet.Create(nil);
    lObjRsltProvider := TDataSetProvider.Create(Result);

    lObjRslt := TSQLQuery.Create(lObjRsltProvider);
    lObjRslt.SQLConnection := TSQLConnection(pConnection);

    lObjRsltProvider.DataSet := lObjRslt;
    TClientDataSet(Result).SetProvider(lObjRsltProvider);
  end;
end;

class function TSFConnectionMapSQL.GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TSQLConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  Result := TSQLTable.Create(nil);
  TSQLTable(Result).SQLConnection := TSQLConnection(pConnection);
  TSQLTable(Result).TableName := pTableName;
  TSQLTable(Result).SchemaName := pSchema;
end;

class function TSFConnectionMapSQL.GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList;
begin
  if not(Assigned(pConnection)) or not(pConnection is TSQLConnection) then
    Result := inherited GetFieldNames(pConnection, pTableName, pCatalog, pSchema)
  else
  begin
    Result := TStringList.Create;
    if (pSchema <> '') then
      TSQLConnection(pConnection).GetFieldNames(pTableName, pSchema, Result)
    else
      TSQLConnection(pConnection).GetFieldNames(pTableName, Result);
  end;
end;

class function TSFConnectionMapSQL.GetRequiredConnectionClass: TSFCustomConnectionCls;
begin
  Result := TSQLConnection;
end;

class function TSFConnectionMapSQL.SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
  var lDS: TDataSet;
begin
  Result := nil;

  lDS := getProviderDataSet(pDataSet);
  if (lDS is TSQLQuery) then
  begin
    TSQLQuery(lDS).SQL.Clear;
    TSQLQuery(lDS).SQL.Add(pSQL);
    Result := TSQLQuery(lDS).Params;
  end;
end;

class function TSFConnectionMapSQL.QueryExecSQL(pDataSet: TDataSet): LongInt;
  var lDS: TDataSet;
begin
  Result := 0;

  lDS := getProviderDataSet(pDataSet);
  if (lDS is TSQLQuery) then
    Result := TSQLQuery(lDS).ExecSQL;
end;

class function TSFConnectionMapSQL.GetDBType(pConnection: TCustomConnection): TSFConnectionDBType;
  var lDriver: String;
begin
  Result := inherited GetDBType(pConnection);
  if (Assigned(pConnection)) and (pConnection is TSQLConnection) and (TSQLConnection(pConnection).DriverName <> '') then
  begin
    lDriver := UpperCase(TSQLConnection(pConnection).DriverName);
    if (lDriver = 'DB2') then
      Result := dbtDB2
    else if (lDriver = 'FIREBIRD') then
      Result := dbtFB
    else if (lDriver = 'INTERBASE') then
      Result := dbtIB
    else if (lDriver = 'MSSQL') then
      Result := dbtMSSQL
    else if (lDriver = 'MYSQL') then
      Result := dbtMySQL
    else if (lDriver = 'ORACLE') then
      Result := dbtOra;
  end;
end;

class function TSFConnectionMapSQL.GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs;
  var lDS: TDataSet;
begin
  lDS := getProviderDataSet(pDataSet);
  if not(lDS is TCustomSQLDataSet) then
    Result := inherited GetIndexDefsForDataSet(pDataSet)
  else
    Result := TCustomSQLDataSet(lDS).IndexDefs;
end;

class procedure TSFConnectionMapSQL.InitDataSetForIndexDefs(pDataSet: TDataSet);
  var lDS: TDataSet;
begin
  lDS := getProviderDataSet(pDataSet);
  if not(lDS is TCustomSQLDataSet) then
    inherited
  else
  begin
    if (lDS.Fields.Count = 0) then
      TCustomSQLDataSet(lDS).FieldDefs.Update;
  end;
end;

class function TSFConnectionMapSQL.getProviderDataSet(pDataSet: TDataSet): TDataSet;
  var i: Integer;
begin
  if (pDataSet <> nil) then
  begin
    if (pDataSet is TClientDataSet) then
    begin
      Result := nil;
      for i := 0 to (pDataSet.ComponentCount - 1) do
      begin
        if (pDataSet.Components[i] is TDataSetProvider) then
          Result := TDataSetProvider(pDataSet.Components[i]).DataSet;

        if (Result <> nil) then
          Exit;
      end;
    end;
  end;

  Result := pDataSet;
end;

{$IFDEF HASIBX}

// ===========================================================================//
//                             TSFConnectionMapIB                             //
// ===========================================================================//

class function TSFConnectionMapIB.GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TIBDataBase) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (Assigned(pTransAct)) and not(pTransAct is TIBTransaction) then
    SFBDSDataError(bdsErrInvalidTransactionType, []);

  Result := TIBQuery.Create(nil);
  TIBQuery(Result).Database := TIBDataBase(pConnection);
  if (pTransAct <> nil) then
    TIBQuery(Result).Transaction := TIBTransaction(pTransAct);
end;

class function TSFConnectionMapIB.GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TIBDataBase) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  if (Assigned(pTransAct)) and not(pTransAct is TIBTransaction) then
    SFBDSDataError(bdsErrInvalidTransactionType, []);

  Result := TIBTable.Create(nil);
  TIBTable(Result).Database := TIBDataBase(pConnection);
  if (pTransAct <> nil) then
    TIBTable(Result).Transaction := TIBTransaction(pTransAct);
  TIBTable(Result).TableName := pTableName;
end;

class function TSFConnectionMapIB.GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList;
begin
  if not(Assigned(pConnection)) or not(pConnection is TIBDataBase) then
    Result := inherited GetFieldNames(pConnection, pTableName, pCatalog, pSchema)
  else
  begin
    Result := TStringList.Create;
    TIBDataBase(pConnection).GetFieldNames(pTableName, Result);
  end;
end;

class function TSFConnectionMapIB.GetRequiredConnectionClass: TSFCustomConnectionCls;
begin
  Result := TIBDataBase;
end;

class function TSFConnectionMapIB.GetRequiredTransactionClass: TComponentClass;
begin
  Result := TIBTransaction;
end;

class function TSFConnectionMapIB.SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
begin
  Result := nil;

  if (pDataSet is TIBQuery) then
  begin
    TIBQuery(pDataSet).SQL.Clear;
    TIBQuery(pDataSet).SQL.Add(pSQL);
    Result := TIBQuery(pDataSet).Params;
  end;
end;

class function TSFConnectionMapIB.QueryExecSQL(pDataSet: TDataSet): LongInt;
begin
  Result := 0;

  if (pDataSet is TIBQuery) then
    TIBQuery(pDataSet).ExecSQL;
end;

class function TSFConnectionMapIB.GetDBType(pConnection: TCustomConnection): TSFConnectionDBType;
begin
  Result := dbtIB;
end;

class function TSFConnectionMapIB.HasDataSetTransaction(pDataSet: TDataSet; pTransaction: TComponent): Boolean;
begin
  Result := False;

  if (pDataSet is TIBCustomDataSet) and (pTransaction <> nil) then
    Result := Assigned(TIBCustomDataSet(pDataSet).Transaction) and (TIBCustomDataSet(pDataSet).Transaction = pTransaction);
end;

class procedure TSFConnectionMapIB.StartTransactionForDataSet(pDataSet: TDataSet);
begin
  if (pDataSet is TIBCustomDataSet) and (Assigned(TIBCustomDataSet(pDataSet).Transaction)) and not(TIBCustomDataSet(pDataSet).Transaction.InTransaction) then
    TIBCustomDataSet(pDataSet).Transaction.StartTransaction;
end;

class procedure TSFConnectionMapIB.CommitTransactionForDataSet(pDataSet: TDataSet; pRetain: Boolean);
  var lTransaction: TIBTransaction;
begin
  lTransaction := nil;
  if (pDataSet is TIBCustomDataSet) and (Assigned(TIBCustomDataSet(pDataSet).Transaction)) and (TIBCustomDataSet(pDataSet).Transaction.InTransaction) then
    lTransaction := TIBCustomDataSet(pDataSet).Transaction;

  if (lTransaction <> nil) then
  begin
    if (pRetain) then
      lTransaction.CommitRetaining
    else
      lTransaction.Commit;
  end;
end;

class function TSFConnectionMapIB.DataSetHasActiveTransaction(pDataSet: TDataSet): Boolean;
begin
  Result := False;

  if not(Assigned(pDataSet)) or not(pDataSet is TIBCustomDataSet) then
    Exit;

  if (Assigned(TIBCustomDataSet(pDataSet).Transaction)) then
    Result := TIBCustomDataSet(pDataSet).Transaction.InTransaction;
end;

class function TSFConnectionMapIB.CanDBInsertion(pDataSet: TDataSet): Boolean;
  var lTransaction: TIBTransaction;
begin
  Result := False;

  if not(Assigned(pDataSet)) or not(pDataSet is TIBCustomDataSet) then
    Exit;

  lTransaction := TIBCustomDataSet(pDataSet).Transaction;
  if not(Assigned(lTransaction)) and (Assigned(TIBCustomDataSet(pDataSet).Database))
    and (Assigned(TIBCustomDataSet(pDataSet).Database.DefaultTransaction)) then
  begin
    lTransaction := TIBCustomDataSet(pDataSet).Database.DefaultTransaction;
  end;

  if (Assigned(lTransaction)) then
  begin
    if (lTransaction.InTransaction) then
      Result := True
    else
    begin
      case lTransaction.AutoStopAction of
        saCommit, saCommitRetaining: Result := True;
        saRollback, saRollbackRetaining: Result := False;
        else
          Result := True;
      end;
    end;
  end else
    Result := False;
end;

class function TSFConnectionMapIB.GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs;
begin
  if not(pDataSet is TIBTable) then
    Result := inherited GetIndexDefsForDataSet(pDataSet)
  else
    Result := TIBTable(pDataSet).IndexDefs;
end;

{$ENDIF HASIBX}

{$IFDEF MSWINDOWS}

// ===========================================================================//
//                            TSFConnectionMapADO                             //
// ===========================================================================//

class function TSFConnectionMapADO.GetNewQuery(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pCanUni: Boolean): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TADOConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  Result := TADOQuery.Create(nil);
  TADOQuery(Result).Connection := TADOConnection(pConnection);
end;

class function TSFConnectionMapADO.GetNewTable(pConnection: TCustomConnection; pTransAct: TComponent; pActionType: TSFQueryActionType; pTableName, pCatalog, pSchema: String): TDataSet;
begin
  if not(Assigned(pConnection)) or not(pConnection is TADOConnection) then
    SFBDSDataError(bdsErrInvalidConnection, []);

  Result := TADOTable.Create(nil);
  TADOTable(Result).Connection := TADOConnection(pConnection);
  TADOTable(Result).TableName := pTableName;
end;

class function TSFConnectionMapADO.GetFieldNames(pConnection: TCustomConnection; pTableName, pCatalog, pSchema: String): TStringList;
begin
  if not(Assigned(pConnection)) or not(pConnection is TADOConnection) then
    Result := inherited GetFieldNames(pConnection, pTableName, pCatalog, pSchema)
  else
  begin
    Result := TStringList.Create;
    TADOConnection(pConnection).GetFieldNames(pTableName, Result);
  end;
end;

class function TSFConnectionMapADO.GetRequiredConnectionClass: TSFCustomConnectionCls;
begin
  Result := TADOConnection;
end;

class function TSFConnectionMapADO.SetSQLToQuery(pSQL: String; pDataSet: TDataSet): TCollection;
begin
  Result := nil;

  if (pDataSet is TADOQuery) then
  begin
    TADOQuery(pDataSet).SQL.Clear;
    TADOQuery(pDataSet).SQL.Add(pSQL);
    Result := TADOQuery(pDataSet).Parameters;
  end;
end;

class function TSFConnectionMapADO.QueryExecSQL(pDataSet: TDataSet): LongInt;
begin
  Result := 0;

  if (pDataSet is TADOQuery) then
    Result := TADOQuery(pDataSet).ExecSQL;
end;

class function TSFConnectionMapADO.GetIndexDefsForDataSet(pDataSet: TDataSet): TIndexDefs;
begin
  if not(pDataSet is TADOTable) then
    Result := inherited GetIndexDefsForDataSet(pDataSet)
  else
    Result := TADOTable(pDataSet).IndexDefs;
end;

class procedure TSFConnectionMapADO.SetQueryParamValue(pParam: TCollectionItem; pValue: Variant; pDataType: TFieldType);
begin
  if (pParam is TParameter) then
  begin
    if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) or (pDataType <> ftUnknown) then
      TParameter(pParam).DataType := pDataType;

    TParameter(pParam).Value := pValue;
  end;
end;

class function TSFConnectionMapADO.GetQueryParamName(pParam: TCollectionItem): String;
begin
  Result := '';

  if (pParam is TParameter) then
    Result := TParameter(pParam).Name;
end;

{$ENDIF MSWINDOWS}


initialization
begin
  TSFConnector.cCommonConnector := nil;
  TSFConnector.cConnectionMap := TObjectList<TSFConnectionMapItm>.Create;
  {$IFDEF HASFIREDAC}
  TSFConnector.addConnectionMap(ctFireDac, TSFConnectionMapFD);
  {$ENDIF HASFIREDAC}
  TSFConnector.addConnectionMap(ctDBExpress, TSFConnectionMapSQL);
  {$IFDEF HASIBX}
  TSFConnector.addConnectionMap(ctInterbase, TSFConnectionMapIB);
  {$ENDIF HASIBX}
  {$IFDEF MSWINDOWS}
    TSFConnector.addConnectionMap(ctADO, TSFConnectionMapADO);
  {$ENDIF MSWINDOWS}

  Finalize(TSFConnector.cCommonConnectedProcs);
end;

finalization
begin
  TSFConnector.cConnectionMap.Clear;
  TSFConnector.cConnectionMap.Free;

  Finalize(TSFConnector.cCommonConnectedProcs);
end;

end.
