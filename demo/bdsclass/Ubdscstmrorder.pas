unit Ubdscstmrorder;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils, Ubdscstmrorderpos, SFStatements;

type
  bdscstmrorder = class(TSFBusinessData)
    private
      mObjOrderPos: bdscstmrorderpos;
    private
      function getObjOrderPos: bdscstmrorderpos;
    private
      function getbdscstmrorderid: Integer;
	    function getbdscstmrordercstmrid: Integer;
	    function getbdscstmrorderdate: TDate;
	    function getbdscstmrordersum: Double;
      procedure setbdscstmrorderid(pValue: Integer);
	    procedure setbdscstmrordercstmrid(pValue: Integer);
	    procedure setbdscstmrorderdate(pValue: TDate);
	    procedure setbdscstmrordersum(pValue: Double);
    protected
      procedure DoOnCalcFields; override;
      procedure AfterDBDeleteRow; override;
      procedure DoAfterOpen; override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      function CalcOrderSum: Double;
      procedure DeletePositionsByCstmrId(pCstmrId: Integer);
    public
      property ObjOrderPos: bdscstmrorderpos read getObjOrderPos;
    public
      property bdscstmrorderid: Integer read getbdscstmrorderid write setbdscstmrorderid;
	    property bdscstmrordercstmrid: Integer read getbdscstmrordercstmrid write setbdscstmrordercstmrid;
	    property bdscstmrorderdate: TDate read getbdscstmrorderdate write setbdscstmrorderdate;
	    property bdscstmrordersum: Double read getbdscstmrordersum write setbdscstmrordersum;
  end;

implementation

uses System.DateUtils, System.Variants, SFBusinessDataConnector, SFStatementType;

constructor bdscstmrorder.Create(pOwner: TComponent);
begin
  inherited;

  TableName := 'bdscstmrorder';
  CatalogName := '';
  SchemaName := '';

  AddDynCalcField('bdscstmrordersum', ftFloat, 0);
  mObjOrderPos := nil;
end;

destructor bdscstmrorder.Destroy;
begin
  inherited;

  if (Assigned(mObjOrderPos)) then
    FreeAndNil(mObjOrderPos);
end;

function bdscstmrorder.CalcOrderSum: Double;
  var lBookmark: TBookmark;
begin
  // calc sum of all positions from current order
  Result := 0;
  if (ObjOrderPos.IsEmpty) then
    Exit;

  lBookmark := ObjOrderPos.Bookmark;
  try
    ObjOrderPos.First;
    while not(ObjOrderPos.Eof) do
    begin
      Result := Result + ObjOrderPos.bdscstmrorderpossum;
      ObjOrderPos.Next;
    end;
  finally
    ObjOrderPos.Bookmark := lBookmark;
  end;
end;

procedure bdscstmrorder.DeletePositionsByCstmrId(pCstmrId: Integer);
  var lOrderPos: bdscstmrorderpos;
      lStmt: TSFStmt;
      // === Start Test ===  lStmtTestExists: TSFStmt;  === End Test === //
begin
  // delete all orderpositions for the given customerid
  lOrderPos := bdscstmrorderpos.Create;
  try

    // create subselect
    // note: when stmt is added as subselect and hasn't owner,
    // parent-stmt will destroy it automatically
    lStmt := TSFStmt.Create(nil);
    lStmt.SetBaseTable(TableName, '', '', '');
    lStmt.SetStmtAttr('bdscstmrorderid', '', lStmt.BaseTable, False);
    lStmt.SetStmtAttr('bdscstmrordercstmrid', '', lStmt.BaseTable, True);
    lStmt.AddConditionVal(lStmt.BaseTable.TableAlias, 'bdscstmrordercstmrid', SFSTMT_OP_EQUAL, pCstmrId);

    lOrderPos.Stmt.SetStmtAttr('bdscstmrorderposorderid', '', lOrderPos.Stmt.BaseTable, True);
    with lOrderPos.Stmt.AddStmtAttr('selorders', True) do
      AddItemStmt(lStmt);

    lOrderPos.Stmt.AddConditionAttr('', 'bdscstmrorderposorderid', SFSTMT_OP_IN, '', 'selorders');

{
    // === Start Test === //

    lStmtTestExists := TSFStmt.Create(nil);
    lStmtTestExists.SetBaseTable('bdscstmr', '', '', '');
    lStmtTestExists.SetStmtAttr('bdscstmrid', '', lStmtTestExists.BaseTable, False);
    lStmtTestExists.AddConditionVal(lStmtTestExists.BaseTable.TableAlias, 'bdscstmrid', SFSTMT_OP_EQUAL, pCstmrId);

    lStmt.AddConditionExists(lStmtTestExists, lStmt.BaseTable.TableAlias, lStmtTestExists.BaseTable.TableAlias,
            SFSTMT_OP_NOT_EXISTS, ['bdscstmrid'], ['bdscstmrordercstmrid'],
            [stmtJoinRelItemAttr], [stmtJoinRelItemAttr]);

    // === End Test === //
}

    lOrderPos.DeleteByStmtConditions(NULL, False);
  finally
    FreeAndNil(lOrderPos);
  end;
end;

procedure bdscstmrorder.DoOnCalcFields;
begin
  inherited;

  // in DoOnCalcFields relations will synced after calcfields
  // => reopen orderpos to take sure orderpos is synced
  ObjOrderPos.FullRefresh;

  bdscstmrordersum := CalcOrderSum;
end;

procedure bdscstmrorder.AfterDBDeleteRow;
begin
  inherited;

  // if not using foreign key, you can do this
  // note: on cached updates, related objects are not synced during ApplyUpdates
  DeleteDepended('bdscstmrorderpos', '', '', 'bdscstmrorderid', 'bdscstmrorderposorderid');
end;

procedure bdscstmrorder.DoAfterOpen;
  var lFldName: String;
begin
  inherited;

  // if the autoinc for bdscstmrorderid wasn't automacially detected, add it
  lFldName := FieldNameForDBField('bdscstmrorderid', True);
  if (lFldName <> '') and (Assigned(FindField(lFldName))) then
  begin
    if not(FieldByName(lFldName) is TAutoIncField) then
    begin
      if (ConnectorUsed.ConnectionDBType = dbtIB) then
        AddAutoValueForField(lFldName).SequenceName := 'GEN_bdscstmrorderid'
      else
        AddAutoValueForField(lFldName);
    end;
  end;
end;

function bdscstmrorder.getObjOrderPos: bdscstmrorderpos;
begin
  // get/initialize internal obj with orderpositions, which are related to
  // the current order
  if (mObjOrderPos = nil) then
  begin
    mObjOrderPos := bdscstmrorderpos.Create;
    AddRelation(mObjOrderPos, 'bdscstmrorderid', 'bdscstmrorderposorderid');
  end;

  Result := mObjOrderPos;
end;

function bdscstmrorder.getbdscstmrorderid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorder.getbdscstmrordercstmrid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrordercstmrid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorder.getbdscstmrorderdate: TDate;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderdate', True);
  if (lFldName <> '') then
    Result := DateOf(FieldByName(lFldName).AsDateTime);
end;

function bdscstmrorder.getbdscstmrordersum: Double;
begin
  Result := 0;
  if (Assigned(FindField('bdscstmrordersum'))) then
    Result := FieldByName('bdscstmrordersum').AsFloat;
end;

procedure bdscstmrorder.setbdscstmrorderid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorder.setbdscstmrordercstmrid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrordercstmrid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorder.setbdscstmrorderdate(pValue: TDate);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderdate', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsDateTime := pValue;
end;

procedure bdscstmrorder.setbdscstmrordersum(pValue: Double);
begin
  if (Assigned(FindField('bdscstmrordersum'))) and (FieldByName('bdscstmrordersum').AsFloat <> pValue) then
    FieldByName('bdscstmrordersum').AsFloat := pValue;
end;


initialization
begin
  TSFBusinessClassFactory.RegisterClass(bdscstmrorder, 'bdscstmrorder');
end;

end.
