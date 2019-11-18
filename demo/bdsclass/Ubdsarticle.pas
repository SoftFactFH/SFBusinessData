unit Ubdsarticle;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils;

type
  bdsarticle = class(TSFBusinessData)
    private
      mObjOrderPos: TSFDataSet;
    private
      function getObjOrderPos: TSFDataSet;
    private
      function getbdsarticleid: Integer;
      function getbdsarticledesc: String;
      function getbdsarticleprice: Double;
      procedure setbdsarticleid(pValue: Integer);
      procedure setbdsarticledesc(pValue: String);
      procedure setbdsarticleprice(pValue: Double);
    protected
      procedure DoBeforeDelete; override;
      procedure DoAfterOpen; override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      property ObjOrderPos: TSFDataSet read getObjOrderPos;
    public
      property bdsarticleid: Integer read getbdsarticleid write setbdsarticleid;
      property bdsarticledesc: String read getbdsarticledesc write setbdsarticledesc;
      property bdsarticleprice: Double read getbdsarticleprice write setbdsarticleprice;
  end;

implementation

uses SFBusinessDataConnector;

constructor bdsarticle.Create(pOwner: TComponent);
begin
  inherited;

  TableName := 'bdsarticle';
  CatalogName := '';
  SchemaName := '';

  mObjOrderPos := nil;
end;

destructor bdsarticle.Destroy;
begin
  inherited;

  if (Assigned(mObjOrderPos)) then
    FreeAndNil(mObjOrderPos);
end;

procedure bdsarticle.DoAfterOpen;
  var lFldName: String;
begin
  inherited;

  // if the autoinc for bdsarticleid wasn't automacially detected, add it
  lFldName := FieldNameForDBField('bdsarticleid', True);
  if (lFldName <> '') and (Assigned(FindField(lFldName))) then
  begin
    if not(FieldByName(lFldName) is TAutoIncField) then
    begin
      if (ConnectorUsed.ConnectionDBType = dbtIB) then
        AddAutoValueForField(lFldName).SequenceName := 'GEN_bdsarticleid'
      else
        AddAutoValueForField(lFldName);
    end;
  end;
end;

procedure bdsarticle.DoBeforeDelete;
begin
  inherited;

  if not(ObjOrderPos.IsEmpty) then
    raise Exception.Create('Cannot delete article with existing orderpositions');
end;

function bdsarticle.getObjOrderPos: TSFDataSet;
begin
  // get/initialize internal obj with orderpositions, which are related to
  // the current article
  if (mObjOrderPos = nil) then
  begin
    mObjOrderPos := TSFDataSet.Create('bdscstmrorderpos', '', '');
    AddRelation(mObjOrderPos, 'bdsarticleid', 'bdscstmrorderposartid');
  end;

  Result := mObjOrderPos;
end;

function bdsarticle.getbdsarticleid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdsarticleid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdsarticle.getbdsarticledesc: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdsarticledesc', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdsarticle.getbdsarticleprice: Double;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdsarticleprice', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsFloat;
end;

procedure bdsarticle.setbdsarticleid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdsarticleid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdsarticle.setbdsarticledesc(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdsarticledesc', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdsarticle.setbdsarticleprice(pValue: Double);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdsarticleprice', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsFloat := pValue;
end;


initialization
begin
  TSFBusinessClassFactory.RegisterClass(bdsarticle, 'bdsarticle');
end;

end.
