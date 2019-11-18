//
//   Title:         SFBusinessData
//
//   Description:   baseclass for specific business-datasets
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFBusinessData;

interface

uses SFBusinessDataCustom, Data.DB, System.Generics.Collections, System.Classes,
     System.SysUtils, SFStatements;

type
  TSFBusinessData = class;
  TSFBusinessDataRelation = class;
  TSFBusinessDataRelationDesigner = class;
  TSFBusinessDataWrap = class;

  TSFBusinessDataChanged = procedure(pOldDS, pNewDS: TSFBusinessData) of object;

  TSFBusinessData = class(TSFCustomBusinessData)
    private
      mRelations: TObjectList<TSFBusinessDataRelation>;
      mParentRel: TSFBusinessDataRelation;
      mSyncDisabledCnt: Integer;
      mOnFieldChange: TDataChangeEvent;
      mOnRecordChange: TDataSetNotifyEvent;
      mReOpening: Boolean;
      mPassKeysOnCachedUpdates: Boolean;
      mOnBeforeSyncRelObj: TDataSetNotifyEvent;
      mOnAfterSyncRelObj: TDataSetNotifyEvent;
      mOnBeforePassKeyToObj: TDataSetNotifyEvent;
      mOnAfterPassKeyToObj: TDataSetNotifyEvent;
      mParentRelationDesigner: TSFBusinessDataRelationDesigner;
    private
      function relNeedSync(pRel: TSFBusinessDataRelation): Boolean;
      function relValsAreDifferent(pRel: TSFBusinessDataRelation): Boolean;
      procedure setRelValsToDestObj(pRel: TSFBusinessDataRelation);
      procedure syncRelation(pRel: TSFBusinessDataRelation);
      function getObjRelation(pObj: TSFBusinessData): TSFBusinessDataRelation;
      procedure stmtOnBeforeGenSelect(pStmt: TSFStmt; pLevel, pSubId, pUnionId: Integer);
      procedure stmtOnAfterGenSelect(pStmt: TSFStmt; pLevel, pSubId, pUnionId: Integer);
      procedure configRelationToOpen(pRel: TSFBusinessDataRelation);
      procedure splitAttrTableIdent(pIdentifier: String; var pTableIdent, pAttr: String);
    protected
      procedure DataEvent(Event: TDataEvent;  Info: NativeInt); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetActive(Value: Boolean); override;
      procedure InternalPost; override;
      procedure DefineProperties(Filer: TFiler); override;
      procedure DoAfterOpen; override;
      procedure DoAfterClose; override;
      procedure FieldChanged(pField: TField); virtual;
      procedure RecordChanged; virtual;
    public
      procedure AddRelation(pDestObj: TSFBusinessData; pSourceAttrs, pDestAttrs: Variant; pPassKeys: Boolean = False); overload;
      procedure AddRelation(pDestObj: TSFBusinessData; pSourceAttrs, pDestAttrs: String; pPassKeys: Boolean = False); overload;
      procedure RemoveRelation(pDestObj: TSFBusinessData);
      procedure RefreshRelations;
      procedure DisableSync;
      procedure EnableSync;
      function SyncDisabled: Boolean;
      procedure SetDisableSyncRel(pObj: TSFBusinessData; pDisabled: Boolean);
      procedure ExplicitSyncRel(pObj: TSFBusinessData);
      procedure SetPassKeysRel(pObj: TSFBusinessData; pPassKeys: Boolean);
      function HasPassKeysRel: Boolean;
      procedure DeleteByStmtConditions(pParamValues: Variant; pWithRefresh: Boolean);
      procedure DeleteDepended(pTableName, pCatalog, pSchema, pSrcAttr, pDestAttr: String); overload;
      procedure DeleteDepended(pTableName, pCatalog, pSchema, pDestAttr: String; pSrcVal: Variant); overload;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      property ParentRel: TSFBusinessDataRelation read mParentRel;
    published
      // note: because the dataset (as subcomponent) can be related to other components,
      // don't store any properties as default - see also defineproperties
      [Stored(False)]
      property Active stored False;
      [Stored(False)]
      property Filtered stored False;
      [Stored(False)]
      property CachedUpdates stored False;
      [Stored(False)]
      property AutoCalcFields stored False;
      [Stored(False)]
      [Default (False)]
      property ObjectView stored False;
      [Stored(False)]
      property Connector stored False;
      [Stored(False)]
      property FormatOptions stored False;
      [Stored(False)]
      property ParentRelationDesigner: TSFBusinessDataRelationDesigner read mParentRelationDesigner stored False;
      [Stored(False)]
      property PassKeysOnCachedUpdates: Boolean read mPassKeysOnCachedUpdates write mPassKeysOnCachedUpdates stored False;
      [Stored(False)]
      property RefreshMode stored False;
      [Stored(False)]
      property Transaction stored False;
      [Stored(False)]
      property UpdateMode stored False;
      [Stored(False)]
      property UpdateTransaction stored False;
      [Stored(False)]
      property Stmt stored False;
      [Stored(False)]
      property StmtParamValues stored False;
      [Stored(False)]
      property OnFieldChange: TDataChangeEvent read mOnFieldChange write mOnFieldChange stored False;
      [Stored(False)]
      property OnRecordChange: TDataSetNotifyEvent read mOnRecordChange write mOnRecordChange stored False;
      [Stored(False)]
      property OnBeforeSyncRelObj: TDataSetNotifyEvent read mOnBeforeSyncRelObj write mOnBeforeSyncRelObj stored False;
      [Stored(False)]
      property OnAfterSyncRelObj: TDataSetNotifyEvent read mOnAfterSyncRelObj write mOnAfterSyncRelObj stored False;
      [Stored(False)]
      property OnBeforePassKeyToObj: TDataSetNotifyEvent read mOnBeforePassKeyToObj write mOnBeforePassKeyToObj stored False;
      [Stored(False)]
      property OnAfterPassKeyToObj: TDataSetNotifyEvent read mOnAfterPassKeyToObj write mOnAfterPassKeyToObj stored False;
      [Stored(False)]
      property OnSetParams stored False;
      [Stored(False)]
      property OnCompareRecords stored False;
      [Stored(False)]
      property OnBeforeDBEditRow stored False;
      [Stored(False)]
      property OnAfterDBEditRow stored False;
      [Stored(False)]
      property OnBeforeDBInsertRow stored False;
      [Stored(False)]
      property OnAfterDBInsertRow stored False;
      [Stored(False)]
      property OnBeforeDBDeleteRow stored False;
      [Stored(False)]
      property OnAfterDBDeleteRow stored False;
      [Stored(False)]
      property OnBeforeRefreshRow stored False;
      [Stored(False)]
      property OnAfterRefreshRow stored False;
      [Stored(False)]
      property OnBeforeRefreshFull stored False;
      [Stored(False)]
      property OnAfterRefreshFull stored False;
      [Stored(False)]
      property AfterCancel stored False;
      [Stored(False)]
      property AfterClose stored False;
      [Stored(False)]
      property AfterDelete stored False;
      [Stored(False)]
      property AfterEdit stored False;
      [Stored(False)]
      property AfterInsert stored False;
      [Stored(False)]
      property AfterOpen stored False;
      [Stored(False)]
      property AfterPost stored False;
      [Stored(False)]
      property AfterRefresh stored False;
      [Stored(False)]
      property AfterScroll stored False;
      [Stored(False)]
      property BeforeCancel stored False;
      [Stored(False)]
      property BeforeClose stored False;
      [Stored(False)]
      property BeforeDelete stored False;
      [Stored(False)]
      property BeforeEdit stored False;
      [Stored(False)]
      property BeforeInsert stored False;
      [Stored(False)]
      property BeforeOpen stored False;
      [Stored(False)]
      property BeforePost stored False;
      [Stored(False)]
      property BeforeRefresh stored False;
      [Stored(False)]
      property BeforeScroll stored False;
      [Stored(False)]
      property OnCalcFields stored False;
      [Stored(False)]
      property OnDeleteError stored False;
      [Stored(False)]
      property OnEditError stored False;
      [Stored(False)]
      property OnNewRecord stored False;
      [Stored(False)]
      property OnPostError stored False;
      [Stored(False)]
      property OnFilterRecord stored False;
  end;

  TSFDataSet = class(TSFBusinessData)
    published
      property TableName;
      property CatalogName;
      property SchemaName;
  end;

  TSFBusinessDataRelation = class(TObject)
    private
      mSrcObj: TSFBusinessData;
      mDestObj: TSFBusinessData;
      mSrcAttrs: Variant;
      mDestAttrs: Variant;
      mSrcFieldNames: Variant;
      mDestFieldNames: Variant;
      mSrcDBIdent: Variant;
      mDestDBIdent: Variant;
      mSyncDisabled: Boolean;
      mPassKeys: Boolean;
    public
      property SrcObj: TSFBusinessData read mSrcObj write mSrcObj;
      property DestObj: TSFBusinessData read mDestObj write mDestObj;
      property SrcAttrs: Variant read mSrcAttrs write mSrcAttrs;
      property DestAttrs: Variant read mDestAttrs write mDestAttrs;
      property SrcFieldNames: Variant read mSrcFieldNames write mSrcFieldNames;
      property DestFieldNames: Variant read mDestFieldNames write mDestFieldNames;
      property SrcDBIdent: Variant read mSrcDBIdent write mSrcDBIdent;
      property DestDBIdent: Variant read mDestDBIdent write mDestDBIdent;
      property SyncDisabled: Boolean read mSyncDisabled write mSyncDisabled;
      property PassKeys: Boolean read mPassKeys write mPassKeys;
  end;

  TSFBusinessDataRelationDesigner = class(TComponent)
    private
      mSrcObj: TSFBusinessData;
      mDestObj: TSFBusinessData;
      mDestWrapper: TSFBusinessDataWrap;
      mSrcAttrs: String;
      mDestAttrs: String;
      mPassKeys: Boolean;
    private
      procedure setDestWrapper(pDestWrapper: TSFBusinessDataWrap);
      function getDestObj: TSFBusinessData;
      procedure setDestObj(pDestObj: TSFBusinessData);
      procedure setSrcAttrs(pSrcAttrs: String);
      procedure setDestAttrs(pDestAttrs: String);
      procedure setPassKeys(pPassKeys: Boolean);
      procedure notifyDSRelationChanged(pOldDS, pNewDS: TSFBusinessData);
    protected
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      property SrcObj: TSFBusinessData read mSrcObj;
    published
      property DestWrapper: TSFBusinessDataWrap read mDestWrapper write setDestWrapper;
      property DestObj: TSFBusinessData read getDestObj write setDestObj;
      property SrcAttrs: String read mSrcAttrs write setSrcAttrs;
      property DestAttrs: String read mDestAttrs write setDestAttrs;
      property PassKeys: Boolean read mPassKeys write setPassKeys;
  end;

  TSFBusinessDataWrap = class(TComponent)
    private
      mBusinessClassName: String;
      mBusinessDataSet: TSFBusinessData;
      mDataSetNotifications: Array of TSFBusinessDataChanged;
    private
      procedure setBusinessClassName(pClassName: String);
      procedure sendDataSetNofications(pOldDS, pNewDS: TSFBusinessData);
      function getDataSetNotification(pProc: TSFBusinessDataChanged): Integer;
    protected
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      procedure AddDataSetNotification(pProc: TSFBusinessDataChanged);
      procedure RemoveDataSetNotification(pProc: TSFBusinessDataChanged);
    published
      property BusinessClassName: String read mBusinessClassName write setBusinessClassName;
      property BusinessDataSet: TSFBusinessData read mBusinessDataSet;
  end;

  TSFBusinessDataWrapSource = class(TDataSource)
    private
      mWrapper: TSFBusinessDataWrap;
    private
      procedure setWrapper(pWrapper: TSFBusinessDataWrap);
      procedure setDataSet(pDataSet: TDataSet);
      function getDataSet: TDataSet;
      procedure notifyWrapperBDSChanged(pOldDS, pNewDS: TSFBusinessData);
    protected
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    published
      property BusinessDataWrapper: TSFBusinessDataWrap read mWrapper write setWrapper;
      [Stored(False)]
      property DataSet: TDataSet read getDataSet stored False;
  end;

implementation

uses System.Variants, SFBusinessDataCommon, SFBusinessDataConnector, System.TypInfo,
     SFStatementType, System.StrUtils;

// ===========================================================================//
//                              TSFBusinessData                               //
// ===========================================================================//

constructor TSFBusinessData.Create(pOwner: TComponent);
begin
  inherited;

  Stmt.OnBeforeGenSelect := stmtOnBeforeGenSelect;
  Stmt.OnAfterGenSelect := stmtOnAfterGenSelect;

  mRelations := TObjectList<TSFBusinessDataRelation>.Create(True);
  mParentRel := nil;
  mSyncDisabledCnt := 0;
  mReOpening := False;

  mPassKeysOnCachedUpdates := False;

  mOnFieldChange := nil;
  mOnRecordChange := nil;
  mOnBeforeSyncRelObj := nil;
  mOnBeforePassKeyToObj := nil;
  mOnAfterSyncRelObj := nil;
  mOnAfterPassKeyToObj := nil;

  mParentRelationDesigner := TSFBusinessDataRelationDesigner.Create(Self);
  mParentRelationDesigner.SetSubComponent(True);
  mParentRelationDesigner.mSrcObj := Self;
end;

destructor TSFBusinessData.Destroy;
  var i: Integer;
begin
  inherited;

  for i := 0 to (mRelations.Count - 1) do
    mRelations[i].DestObj.mParentRel := nil;

  mRelations.Clear;
  FreeAndNil(mRelations);
end;

// override DataEvent
procedure TSFBusinessData.DataEvent(Event: TDataEvent;  Info: NativeInt);
begin
  inherited;

  case Event of
    deFieldChange:
      FieldChanged(TField(Info));
    deDataSetChange, deDataSetScroll:
      begin
        RefreshRelations;
        RecordChanged;
      end;
  end;
end;

// override Notification
procedure TSFBusinessData.Notification(AComponent: TComponent; Operation: TOperation);
  var lRel: TSFBusinessDataRelation;
begin
  inherited;

  if not(csDestroying in ComponentState) and (csFreeNotification in ComponentState) then
  begin
    if (Operation = opRemove) and (AComponent is TSFBusinessData) then
    begin
      lRel := getObjRelation(TSFBusinessData(AComponent));
      if (Assigned(lRel)) then
        mRelations.Remove(lRel);
    end;
  end;
end;

procedure TSFBusinessData.SetActive(Value: Boolean);
begin
  if (Value) then
  begin
    mReOpening := True;
    try
      inherited;
    finally
      mReOpening := False;
    end;

    if (Active) and not(IsEmpty) then
      RecordChanged;
  end else
    inherited;
end;

procedure TSFBusinessData.InternalPost;
  var i: Integer;
      lBookmark: TBookmark;
begin
  inherited;

  if (CachedUpdates) or (mPassKeysOnCachedUpdates) then
  begin
    for i := 0 to (mRelations.Count - 1) do
    begin
      if not(mRelations[i].PassKeys) then
        Continue;

      if (Assigned(mOnBeforePassKeyToObj)) then
        mOnBeforePassKeyToObj(mRelations[i].DestObj);

      if (mRelations[i].DestObj.State in [dsEdit, dsInsert]) then
        mRelations[i].DestObj.Post;

      mRelations[i].DestObj.DisableControls;
      lBookmark := mRelations[i].DestObj.Bookmark;
      try
        mRelations[i].DestObj.First;
        while not(mRelations[i].DestObj.Eof) do
        begin
          if (relValsAreDifferent(mRelations[i])) then
          begin
            mRelations[i].DestObj.Edit;
            setRelValsToDestObj(mRelations[i]);
            mRelations[i].DestObj.Post;
          end;

          mRelations[i].DestObj.Next;
        end;
      finally
        if (mRelations[i].DestObj.BookmarkValid(lBookmark)) then
          mRelations[i].DestObj.Bookmark := lBookmark;

        mRelations[i].DestObj.EnableControls;
      end;

      if (Assigned(mOnAfterPassKeyToObj)) then
        mOnAfterPassKeyToObj(mRelations[i].DestObj);
    end;
  end;
end;

type TWriterFriend = class(TWriter);

procedure TSFBusinessData.DefineProperties(Filer: TFiler);
  var lStoreDfltProps: Boolean;
      i, lCount: Integer;
      lPropInfo: PPropInfo;
      lPropList: PPropList;
begin
  inherited;

  if (Filer is TWriter) then
  begin
    lStoreDfltProps := not(csSubComponent in ComponentStyle);
    lStoreDfltProps := lStoreDfltProps or (Owner <> nil) and (Owner is TSFBusinessDataWrap) and (csWriting in Owner.ComponentState);

    if (lStoreDfltProps) then
    begin
      lCount := GetTypeData(Self.ClassInfo)^.PropCount;
      if (lCount > 0) then
      begin
        GetMem(lPropList, lCount * SizeOf(Pointer));
        try
          GetPropInfos(Self.ClassInfo, lPropList);
          for i := 0 to (lCount - 1) do
          begin
            lPropInfo := lPropList^[i];
            if (lPropInfo = nil)then
              Break;
            if not(IsStoredProp(Self, lPropInfo)) then
              TWriterFriend(Filer).WriteProperty(Self, lPropInfo);
          end;
        finally
          FreeMem(lPropList, lCount * SizeOf(Pointer));
        end;
      end;
    end;
  end;
end;

procedure TSFBusinessData.DoAfterOpen;
begin
  inherited;

  RefreshRelations;
end;

procedure TSFBusinessData.DoAfterClose;
  var i: Integer;
begin
  inherited;

  for i := 0 to (mRelations.Count - 1) do
  begin
    if (Assigned(mRelations[i].DestObj)) and (mRelations[i].DestObj.Active) then
      mRelations[i].DestObj.Close;
  end;
end;

procedure TSFBusinessData.FieldChanged(pField: TField);
begin
  if (Assigned(mOnFieldChange)) then
    mOnFieldChange(Self, pField);
end;

procedure TSFBusinessData.RecordChanged;
begin
  if (Assigned(mOnRecordChange)) then
    mOnRecordChange(Self);
end;

procedure TSFBusinessData.AddRelation(pDestObj: TSFBusinessData; pSourceAttrs, pDestAttrs: Variant; pPassKeys: Boolean = False);
  var lExcept: Boolean;
      lRel: TSFBusinessDataRelation;
begin
  lExcept := (VarIsArray(pDestAttrs) and not(VarIsArray(pSourceAttrs))) or (VarIsArray(pSourceAttrs) and not(VarIsArray(pDestAttrs)));
  lExcept := lExcept or (VarIsArray(pDestAttrs) and VarIsArray(pSourceAttrs) and (VarArrayHighBound(pDestAttrs, 1) <> VarArrayHighBound(pSourceAttrs, 1)));

  if (lExcept) then
    Exit;

  pDestObj.FreeNotification(Self);

  lRel := TSFBusinessDataRelation.Create;
  lRel.SrcObj := Self;
  lRel.DestObj := pDestObj;
  lRel.SrcAttrs := pSourceAttrs;
  lRel.DestAttrs := pDestAttrs;
  lRel.SyncDisabled := False;
  lRel.PassKeys := pPassKeys;
  lRel.SrcFieldNames := NULL;
  lRel.DestFieldNames := NULL;
  lRel.SrcDBIdent := NULL;
  lRel.DestDBIdent := NULL;

  pDestObj.mParentRel := lRel;
  mRelations.Add(lRel);

  if not(State = dsInactive) and not(SyncDisabled) then
    syncRelation(lRel);
end;

procedure TSFBusinessData.AddRelation(pDestObj: TSFBusinessData; pSourceAttrs, pDestAttrs: String; pPassKeys: Boolean = False);
  var lSourceFlds, lDestFlds: Array of Variant;
      i: Integer;
begin
  if (pSourceAttrs = '') or (pDestAttrs = '') then
    Exit;

  i := 1;
  while (i <= Length(pSourceAttrs)) do
  begin
    SetLength(lSourceFlds, Length(lSourceFlds) + 1);
    lSourceFlds[High(lSourceFlds)] := ExtractFieldName(pSourceAttrs, i);
  end;

  i := 1;
  while (i <= Length(pDestAttrs)) do
  begin
    SetLength(lDestFlds, Length(lDestFlds) + 1);
    lDestFlds[High(lDestFlds)] := ExtractFieldName(pDestAttrs, i);
  end;

  AddRelation(pDestObj, VarArrayOf(lSourceFlds), VarArrayOf(lDestFlds), pPassKeys);
end;

procedure TSFBusinessData.RemoveRelation(pDestObj: TSFBusinessData);
  var lRel: TSFBusinessDataRelation;
begin
  lRel := getObjRelation(pDestObj);
  if (Assigned(lRel)) then
    mRelations.Remove(lRel);
end;

procedure TSFBusinessData.RefreshRelations;
  var i: Integer;
begin
  if (SyncDisabled) then
    Exit;

  for i := 0 to (mRelations.Count - 1) do
  begin
    if not(mRelations[i].SyncDisabled) and (relNeedSync(mRelations[i])) then
      syncRelation(mRelations[i]);
  end;
end;

procedure TSFBusinessData.DisableSync;
begin
  Inc(mSyncDisabledCnt);
end;

procedure TSFBusinessData.EnableSync;
begin
  if (mSyncDisabledCnt > 0) then
    Dec(mSyncDisabledCnt);
end;

function TSFBusinessData.SyncDisabled: Boolean;
begin
  Result := (mSyncDisabledCnt > 0);
end;

procedure TSFBusinessData.SetDisableSyncRel(pObj: TSFBusinessData; pDisabled: Boolean);
  var lRel: TSFBusinessDataRelation;
begin
  lRel := getObjRelation(pObj);
  if (Assigned(lRel)) then
    lRel.SyncDisabled := pDisabled;
end;

procedure TSFBusinessData.ExplicitSyncRel(pObj: TSFBusinessData);
  var lRel: TSFBusinessDataRelation;
begin
  lRel := getObjRelation(pObj);
  if (Assigned(lRel)) and (relNeedSync(lRel)) then
    syncRelation(lRel);
end;

procedure TSFBusinessData.SetPassKeysRel(pObj: TSFBusinessData; pPassKeys: Boolean);
  var lRel: TSFBusinessDataRelation;
begin
  lRel := getObjRelation(pObj);
  if (Assigned(lRel)) then
    lRel.PassKeys := pPassKeys;
end;

function TSFBusinessData.HasPassKeysRel: Boolean;
  var i: Integer;
begin
  for i := 0 to (mRelations.Count - 1) do
  begin
    Result := mRelations[i].PassKeys;
    if (Result) then
      Exit;
  end;

  Result := False;
end;

procedure TSFBusinessData.DeleteByStmtConditions(pParamValues: Variant; pWithRefresh: Boolean);
  var lQueryDel: TDataSet;
      lParams: TCollection;
      i: Integer;
begin
  if not(Assigned(ConnectorUsed)) then
    SFBDSDataError(bdsErrMissingConnector, []);

  lQueryDel := ConnectorUsed.GetNewQuery(UpdateTransaction, atModify);
  try
    Stmt.QuoteType := QueryQuoteType;
    Stmt.DBDialect := MappedStmtDBDialect;
    lParams := ConnectorUsed.SetSQLToQuery(Stmt.GetDeleteStmt, lQueryDel);
    if (lParams <> nil) then
    begin
      for i := 0 to (lParams.Count - 1) do
        ConnectorUsed.SetQueryParamValue(lParams.Items[i], pParamValues[i]);
    end;
    SetQueryParams(exPrmsTypeDelete, lParams);
    ConnectorUsed.QueryExecSQL(lQueryDel);
  finally
    FreeAndNil(lQueryDel);
  end;

  if (pWithRefresh) then
    FullRefresh;
end;

procedure TSFBusinessData.DeleteDepended(pTableName, pCatalog, pSchema, pSrcAttr, pDestAttr: String);
begin
  if not(Active) or (IsEmpty) or not(Assigned(FindField(pSrcAttr))) then
    Exit;

  DeleteDepended(pTableName, pCatalog, pSchema, pDestAttr, FieldByName(pSrcAttr).Value);
end;

procedure TSFBusinessData.DeleteDepended(pTableName, pCatalog, pSchema, pDestAttr: String; pSrcVal: Variant);
  var lObjDepended: TSFBusinessData;
begin
  if (VarIsNull(pSrcVal)) or (VarIsClear(pSrcVal)) then
    Exit;

  lObjDepended := TSFBusinessData.Create(pTableName, pCatalog, pSchema);
  try
    lObjDepended.Stmt.SetStmtAttr(pDestAttr, '', lObjDepended.Stmt.BaseTable, True);
    lObjDepended.Stmt.AddConditionVal(lObjDepended.Stmt.BaseTable.TableAlias, pDestAttr, SFSTMT_OP_EQUAL, pSrcVal);

    lObjDepended.DeleteByStmtConditions(NULL, False);
  finally
    FreeAndNil(lObjDepended);
  end;
end;

function TSFBusinessData.relNeedSync(pRel: TSFBusinessDataRelation): Boolean;
begin
  Result := False;

  if (pRel.DestObj.State in [dsInsert, dsEdit, dsCalcFields]) or (pRel.DestObj.UpdatesPending) or (State = dsInactive) then
    Exit;

  if (IsEmpty) and (pRel.DestObj.IsEmpty) and (pRel.DestObj.State <> dsInactive) then
    Exit;

  Result := (pRel.DestObj.IsEmpty <> IsEmpty) or (pRel.DestObj.State = dsInactive);

  if (Result) then
    Exit;

  Result := mReOpening or relValsAreDifferent(pRel);
end;

function TSFBusinessData.relValsAreDifferent(pRel: TSFBusinessDataRelation): Boolean;
  var i: Integer;
      lSrcFld, lDestFld: TField;
begin
  Result := True;

  if (VarIsArray(pRel.SrcAttrs)) then
  begin
    for i := 0 to VarArrayHighBound(pRel.SrcAttrs, 1) do
    begin
      lSrcFld := FindField(pRel.SrcFieldNames[i]);
      lDestFld := pRel.DestObj.FindField(pRel.DestFieldNames[i]);

      if (Assigned(lSrcFld)) and (Assigned(lDestFld)) then
        Result := (lSrcFld.AsString <> lDestFld.AsString);

      if (Result) then
        break;
    end;
  end else
  begin
    lSrcFld := FindField(pRel.SrcFieldNames);
    lDestFld := pRel.DestObj.FindField(pRel.DestFieldNames);

    if (Assigned(lSrcFld)) and (Assigned(lDestFld)) then
      Result := (lSrcFld.AsString <> lDestFld.AsString);
  end;
end;

procedure TSFBusinessData.setRelValsToDestObj(pRel: TSFBusinessDataRelation);
  var i: Integer;
      lSrcFld, lDestFld: TField;
begin
  if not(Assigned(pRel)) or not(Assigned(pRel.DestObj)) or not(pRel.DestObj.State in [dsInsert, dsEdit]) then
    Exit;

  if (VarIsArray(pRel.SrcAttrs)) then
  begin
    for i := 0 to VarArrayHighBound(pRel.SrcAttrs, 1) do
    begin
      lSrcFld := FindField(pRel.SrcFieldNames[i]);
      lDestFld := pRel.DestObj.FindField(pRel.DestFieldNames[i]);

      if (Assigned(lSrcFld)) and (Assigned(lDestFld)) then
        lDestFld.AsString := lSrcFld.AsString;
    end;
  end else
  begin
    lSrcFld := FindField(pRel.SrcFieldNames);
    lDestFld := pRel.DestObj.FindField(pRel.DestFieldNames);

    if (Assigned(lSrcFld)) and (Assigned(lDestFld)) then
      lDestFld.AsString := lSrcFld.AsString;
  end;
end;

procedure TSFBusinessData.syncRelation(pRel: TSFBusinessDataRelation);
begin
  if (Assigned(mOnBeforeSyncRelObj)) then
    mOnBeforeSyncRelObj(pRel.DestObj);

  if not(pRel.DestObj.State in [dsInsert, dsEdit, dsCalcFields]) or (State <> dsInactive) then
  begin
    if (pRel.DestObj.Active) then
      pRel.DestObj.Close;

    pRel.DestObj.Open;

    if (Assigned(mOnAfterSyncRelObj)) then
      mOnAfterSyncRelObj(pRel.DestObj);
  end;
end;

function TSFBusinessData.getObjRelation(pObj: TSFBusinessData): TSFBusinessDataRelation;
  var i: Integer;
begin
  for i := 0 to (mRelations.Count - 1) do
  begin
    Result := mRelations[i];
    if (Result.DestObj = pObj) then
      Exit;
  end;

  Result := nil;
end;

procedure TSFBusinessData.stmtOnBeforeGenSelect(pStmt: TSFStmt; pLevel, pSubId, pUnionId: Integer);
  var i: Integer;
      lSrcFld: TField;
      lAttr, lTab: String;
begin
  if (pStmt <> Stmt) then
    Exit;

  if (Assigned(mParentRel)) and (mParentRel.SrcObj.State <> dsInactive) then
  begin
    configRelationToOpen(mParentRel);

    // set parent conditions
    if (VarIsArray(mParentRel.SrcAttrs)) then
    begin
      for i := 0 to VarArrayHighBound(mParentRel.SrcAttrs, 1) do
      begin
        if (VarIsNull(mParentRel.SrcFieldNames[i])) then
          Continue;

        lSrcFld := mParentRel.SrcObj.FindField(mParentRel.SrcFieldNames[i]);
        if (Assigned(lSrcFld)) then
        begin
          if (VarIsNull(mParentRel.DestDBIdent[i])) then
          begin
            lTab := '';
            lAttr := mParentRel.DestAttrs[i];
          end else
            splitAttrTableIdent(mParentRel.DestDBIdent[i], lTab, lAttr);

          Stmt.AddBaseRestriction(lTab, lAttr, lSrcFld.Value, VarIsNull(mParentRel.DestDBIdent[i]), True);
        end;
      end;
    end else
    if not(VarIsNull(mParentRel.SrcFieldNames)) then
    begin
      lSrcFld := mParentRel.SrcObj.FindField(mParentRel.SrcFieldNames);
      if (Assigned(lSrcFld)) then
      begin
        if (VarIsNull(mParentRel.DestDBIdent)) then
        begin
          lTab := '';
          lAttr := mParentRel.DestAttrs;
        end else
          splitAttrTableIdent(mParentRel.DestDBIdent, lTab, lAttr);

        Stmt.AddBaseRestriction(lTab, lAttr, lSrcFld.Value, VarIsNull(mParentRel.DestDBIdent), True);
      end;
    end;
  end;
end;

procedure TSFBusinessData.stmtOnAfterGenSelect(pStmt: TSFStmt; pLevel, pSubId, pUnionId: Integer);
begin
  if (pStmt <> Stmt) then
    Exit;

  Stmt.ClearBaseRestrictions;
end;

procedure TSFBusinessData.configRelationToOpen(pRel: TSFBusinessDataRelation);
  var i: Integer;
      lSelectName, lTabAlias, lTabName, lTabCat, lTabSchema, lTabAttr: String;
      lFieldNames, lDBNames: Array of Variant;
begin
  if (VarIsArray(pRel.SrcAttrs)) then
  begin
    Finalize(lFieldNames);
    Finalize(lDBNames);
    for i := VarArrayLowBound(pRel.SrcAttrs, 1) to VarArrayHighBound(pRel.SrcAttrs, 1) do
    begin
      SetLength(lFieldNames, Length(lFieldNames) + 1);
      SetLength(lDBNames, Length(lDBNames) + 1);

      lSelectName := pRel.SrcObj.SelectNameForIdentifier(pRel.SrcAttrs[i], lTabAlias, lTabName, lTabSchema, lTabCat, lTabAttr);
      if (lSelectName <> '') then
      begin
        lFieldNames[High(lFieldNames)] := lSelectName;
        lDBNames[High(lDBNames)] := lTabAlias + '.' + lTabAttr;
      end else
      begin
        lFieldNames[High(lFieldNames)] := pRel.SrcAttrs[i];
        lDBNames[High(lDBNames)] := NULL;
      end;
    end;

    pRel.SrcFieldNames := VarArrayOf(lFieldNames);
    pRel.SrcDBIdent := VarArrayOf(lDBNames);
  end else
  begin
    lSelectName := pRel.SrcObj.SelectNameForIdentifier(pRel.SrcAttrs, lTabAlias, lTabName, lTabSchema, lTabCat, lTabAttr);
    if (lSelectName <> '') then
    begin
      pRel.SrcFieldNames := lSelectName;
      pRel.SrcDBIdent := lTabAlias + '.' + lTabAttr;
    end else
    begin
      pRel.SrcFieldNames := pRel.SrcAttrs;
      pRel.SrcDBIdent := NULL;
    end;
  end;

  if (VarIsArray(pRel.DestAttrs)) then
  begin
    Finalize(lFieldNames);
    Finalize(lDBNames);
    for i := VarArrayLowBound(pRel.DestAttrs, 1) to VarArrayHighBound(pRel.DestAttrs, 1) do
    begin
      SetLength(lFieldNames, Length(lFieldNames) + 1);
      SetLength(lDBNames, Length(lDBNames) + 1);

      lSelectName := pRel.DestObj.SelectNameForIdentifier(pRel.DestAttrs[i], lTabAlias, lTabName, lTabSchema, lTabCat, lTabAttr);
      if (lSelectName <> '') then
      begin
        lFieldNames[High(lFieldNames)] := lSelectName;
        lDBNames[High(lDBNames)] := lTabAlias + '.' + lTabAttr;
      end else
      begin
        lFieldNames[High(lFieldNames)] := pRel.DestAttrs[i];
        lDBNames[High(lDBNames)] := NULL;
      end;
    end;

    pRel.DestFieldNames := VarArrayOf(lFieldNames);
    pRel.DestDBIdent := VarArrayOf(lDBNames);
  end else
  begin
    lSelectName := pRel.DestObj.SelectNameForIdentifier(pRel.DestAttrs, lTabAlias, lTabName, lTabSchema, lTabCat, lTabAttr);
    if (lSelectName <> '') then
    begin
      pRel.DestFieldNames := lSelectName;
      pRel.DestDBIdent := lTabAlias + '.' + lTabAttr;
    end else
    begin
      pRel.DestFieldNames := pRel.DestAttrs;
      pRel.DestDBIdent := NULL;
    end;
  end;
end;

procedure TSFBusinessData.splitAttrTableIdent(pIdentifier: String; var pTableIdent, pAttr: String);
  var i: Integer;
      lChr: String;
      lAttrReady: Boolean;
begin
  pTableIdent := '';
  pAttr := '';

  if (pIdentifier = '') then
    Exit;

  lAttrReady := False;
  for i := Length(pIdentifier) downto 1 do
  begin
    lChr := MidStr(pIdentifier, i, 1);
    if (lChr = '.') then
    begin
      if not(lAttrReady) then
        lAttrReady := True
      else
        pTableIdent := lChr + pTableIdent;
    end else
    begin
      if not(lAttrReady) then
        pAttr := lChr + pAttr
      else
        pTableIdent := lChr + pTableIdent;
    end;
  end;
end;

// ===========================================================================//
//                      TSFBusinessDataRelationDesigner                       //
// ===========================================================================//

constructor TSFBusinessDataRelationDesigner.Create(pOwner: TComponent);
begin
  inherited;

  mSrcObj := nil;
  if (pOwner is TSFBusinessData) then
    mSrcObj := TSFBusinessData(pOwner);

  mDestObj := nil;
  mDestWrapper := nil;
  mSrcAttrs := '';
  mDestAttrs := '';
  mPassKeys := False;
end;

destructor TSFBusinessDataRelationDesigner.Destroy;
begin
  DestWrapper := nil;
  DestObj := nil;

  inherited;
end;

procedure TSFBusinessDataRelationDesigner.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent <> nil) then
  begin
    if (AComponent = mDestObj) then
      notifyDSRelationChanged(mDestObj, nil)
    else if (AComponent = mDestWrapper) then
      DestWrapper := nil;
  end;
end;

procedure TSFBusinessDataRelationDesigner.setDestWrapper(pDestWrapper: TSFBusinessDataWrap);
begin
  if (pDestWrapper <> mDestWrapper) and (not(csSubComponent in mSrcObj.ComponentStyle) or (pDestWrapper <> mSrcObj.Owner)) then
  begin
    if (mDestWrapper <> nil) then
    begin
      mDestWrapper.RemoveDataSetNotification(notifyDSRelationChanged);
      if not(csDestroying in mDestWrapper.ComponentState) then
        mDestWrapper.RemoveFreeNotification(Self);
      notifyDSRelationChanged(mDestObj, nil);
    end;

    mDestWrapper := pDestWrapper;
    if (mDestWrapper <> nil) then
    begin
      mDestWrapper.AddDataSetNotification(notifyDSRelationChanged);
      mDestWrapper.FreeNotification(Self);
      notifyDSRelationChanged(mDestObj, mDestWrapper.BusinessDataSet);
    end;
  end;
end;

procedure TSFBusinessDataRelationDesigner.setDestObj(pDestObj: TSFBusinessData);
begin
  if (pDestObj <> mDestObj) and (pDestObj <> mSrcObj) then
  begin
    if (pDestObj <> nil) then
      DestWrapper := nil;
    notifyDSRelationChanged(mDestObj, pDestObj);
  end;
end;

function TSFBusinessDataRelationDesigner.getDestObj: TSFBusinessData;
begin
  Result := mDestObj;
end;

procedure TSFBusinessDataRelationDesigner.setSrcAttrs(pSrcAttrs: String);
begin
  if (AnsiUpperCase(pSrcAttrs) <> AnsiUpperCase(mSrcAttrs)) then
  begin
    mSrcAttrs := pSrcAttrs;
    notifyDSRelationChanged(mDestObj, mDestObj);
  end;
end;

procedure TSFBusinessDataRelationDesigner.setDestAttrs(pDestAttrs: String);
begin
  if (AnsiUpperCase(pDestAttrs) <> AnsiUpperCase(mDestAttrs)) then
  begin
    mDestAttrs := pDestAttrs;
    notifyDSRelationChanged(mDestObj, mDestObj);
  end;
end;

procedure TSFBusinessDataRelationDesigner.setPassKeys(pPassKeys: Boolean);
begin
  if (pPassKeys <> mPassKeys) then
  begin
    mPassKeys := pPassKeys;
    notifyDSRelationChanged(mDestObj, mDestObj);
  end;
end;

procedure TSFBusinessDataRelationDesigner.notifyDSRelationChanged(pOldDS, pNewDS: TSFBusinessData);
begin
  if (pOldDS <> nil) then
  begin
    pOldDS.RemoveRelation(mSrcObj);
    if not(csDestroying in pOldDs.ComponentState) then
      pOldDS.RemoveFreeNotification(Self);
  end;

  mDestObj := pNewDS;
  if (mDestObj <> nil) then
  begin
    if (mSrcAttrs <> '') and (mDestAttrs <> '') then
      mDestObj.AddRelation(mSrcObj, mDestAttrs, mSrcAttrs, mPassKeys);

    mDestObj.FreeNotification(Self);
  end;
end;


// ===========================================================================//
//                            TSFBusinessDataWrap                             //
// ===========================================================================//

constructor TSFBusinessDataWrap.Create(pOwner: TComponent);
begin
  inherited;

  mBusinessClassName := '';
  mBusinessDataSet := nil;
  Finalize(mDataSetNotifications);
end;

destructor TSFBusinessDataWrap.Destroy;
begin
  Finalize(mDataSetNotifications);

  inherited;
end;

procedure TSFBusinessDataWrap.AddDataSetNotification(pProc: TSFBusinessDataChanged);
begin
  if (getDataSetNotification(pProc) < 0) then
  begin
    SetLength(mDataSetNotifications, Length(mDataSetNotifications) + 1);
    mDataSetNotifications[High(mDataSetNotifications)] := pProc;
  end;
end;

procedure TSFBusinessDataWrap.RemoveDataSetNotification(pProc: TSFBusinessDataChanged);
  var i, lIdx: Integer;
begin
  lIdx := getDataSetNotification(pProc);
  if (lIdx >= 0) then
  begin
    for i := lIdx to (High(mDataSetNotifications) - 1) do
      mDataSetNotifications[i] := mDataSetNotifications[i + 1];

    SetLength(mDataSetNotifications, Length(mDataSetNotifications) - 1);
  end;
end;

procedure TSFBusinessDataWrap.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) then
  begin
    if (AComponent <> nil) and (AComponent = mBusinessDataSet) then
    begin
      sendDataSetNofications(mBusinessDataSet, nil);
      mBusinessDataSet := nil;
    end;
  end;
end;

procedure TSFBusinessDataWrap.setBusinessClassName(pClassName: String);
  var lOldDs: TSFBusinessData;
begin
  if (UpperCase(pClassName) <> UpperCase(mBusinessClassName)) then
  begin
    mBusinessClassName := pClassName;

    lOldDs := mBusinessDataSet;
    mBusinessDataSet := TSFBusinessData(TSFBusinessClassFactory.GetBusinessDataObj(mBusinessClassName, '', '', TSFBusinessData, Self));
    mBusinessDataSet.SetSubComponent(True);
    mBusinessDataSet.FreeNotification(Self);

    sendDataSetNofications(lOldDs, mBusinessDataSet);

    if (Assigned(lOldDs)) then
    begin
      lOldDs.RemoveFreeNotification(Self);
      FreeAndNil(lOldDs);
    end;

    mBusinessDataSet.Name := GetTypeName(TypeInfo(TSFBusinessData));
  end;
end;

procedure TSFBusinessDataWrap.sendDataSetNofications(pOldDS, pNewDS: TSFBusinessData);
  var i: Integer;
      lFunc: TSFBusinessDataChanged;
begin
  for i := Low(mDataSetNotifications) to High(mDataSetNotifications) do
  begin
    lFunc := mDataSetNotifications[i];
    if (Assigned(lFunc)) then
      lFunc(pOldDS, pNewDS);
  end;
end;

function TSFBusinessDataWrap.getDataSetNotification(pProc: TSFBusinessDataChanged): Integer;
  var i: Integer;
begin
  for i := Low(mDataSetNotifications) to High(mDataSetNotifications) do
  begin
    if (@mDataSetNotifications[i] = @pProc) then
    begin
      Result := i;
      Exit;
    end;
  end;

  Result := -1;
end;

// ===========================================================================//
//                         TSFBusinessDataWrapSource                          //
// ===========================================================================//

constructor TSFBusinessDataWrapSource.Create(pOwner: TComponent);
begin
  inherited;

  mWrapper := nil;
  setDataSet(nil);
end;

destructor TSFBusinessDataWrapSource.Destroy;
begin
  BusinessDataWrapper := nil;

  inherited;
end;

procedure TSFBusinessDataWrapSource.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent <> nil) then
  begin
    if (AComponent = mWrapper) then
      BusinessDataWrapper := nil;
  end;
end;

procedure TSFBusinessDataWrapSource.setWrapper(pWrapper: TSFBusinessDataWrap);
begin
  if (mWrapper <> pWrapper) then
  begin
    if (mWrapper <> nil) and not(csDestroying in mWrapper.ComponentState) then
    begin
      mWrapper.RemoveDataSetNotification(notifyWrapperBDSChanged);
      mWrapper.RemoveFreeNotification(Self);
      setDataSet(nil);
    end;

    mWrapper := pWrapper;
    if (mWrapper <> nil) and not(csDestroying in mWrapper.ComponentState) then
    begin
      mWrapper.AddDataSetNotification(notifyWrapperBDSChanged);
      mWrapper.FreeNotification(Self);
      notifyWrapperBDSChanged(nil, mWrapper.BusinessDataSet);
    end;
  end;
end;

procedure TSFBusinessDataWrapSource.setDataSet(pDataSet: TDataSet);
begin
  inherited DataSet := pDataSet;
end;

function TSFBusinessDataWrapSource.getDataSet: TDataSet;
begin
  Result := inherited DataSet;
end;

procedure TSFBusinessDataWrapSource.notifyWrapperBDSChanged(pOldDS, pNewDS: TSFBusinessData);
begin
  setDataSet(pNewDS);
end;


end.
