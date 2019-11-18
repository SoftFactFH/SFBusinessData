unit Ubdscstmr;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils, Ubdscstmrorder;

type
  bdscstmr = class(TSFBusinessData)
    private
      mObjCstmrOrder: bdscstmrorder;
    private
      function getObjCstmrOrder: bdscstmrorder;
    private
      function getbdscstmrid: Integer;
      function getbdscstmrname: String;
      function getbdscstmrfirstname: String;
      function getbdscstmrdateofbirth: TDate;
      function getbdscstmrpostcode: String;
      function getbdscstmrcity: String;
      function getbdscstmrstreet: String;
      function getbdscstmrnotice: String;
      function getbdscstmrimage: TBytes;
      function getbdscstmrimageext: String;
      function getbdscstmrtypeid: Integer;
      procedure setbdscstmrid(pValue: Integer);
      procedure setbdscstmrname(pValue: String);
      procedure setbdscstmrfirstname(pValue: String);
      procedure setbdscstmrdateofbirth(pValue: TDate);
      procedure setbdscstmrpostcode(pValue: String);
      procedure setbdscstmrcity(pValue: String);
      procedure setbdscstmrstreet(pValue: String);
      procedure setbdscstmrnotice(pValue: String);
      procedure setbdscstmrtypeid(pValue: Integer);
      procedure setbdscstmrimage(pValue: TBytes);
      procedure setbdscstmrimageext(pValue: String);
    protected
      procedure AfterDBDeleteRow; override;
      procedure DoAfterOpen; override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      property ObjCstmrOrder: bdscstmrorder read getObjCstmrOrder;
    public
      property bdscstmrid: Integer read getbdscstmrid write setbdscstmrid;
      property bdscstmrname: String read getbdscstmrname write setbdscstmrname;
      property bdscstmrfirstname: String read getbdscstmrfirstname write setbdscstmrfirstname;
      property bdscstmrdateofbirth: TDate read getbdscstmrdateofbirth write setbdscstmrdateofbirth;
      property bdscstmrpostcode: String read getbdscstmrpostcode write setbdscstmrpostcode;
      property bdscstmrcity: String read getbdscstmrcity write setbdscstmrcity;
      property bdscstmrstreet: String read getbdscstmrstreet write setbdscstmrstreet;
      property bdscstmrnotice: String read getbdscstmrnotice write setbdscstmrnotice;
      property bdscstmrtypeid: Integer read getbdscstmrtypeid write setbdscstmrtypeid;
      property bdscstmrimage: TBytes read getbdscstmrimage write setbdscstmrimage;
      property bdscstmrimageext: String read getbdscstmrimageext write setbdscstmrimageext;
  end;

implementation

uses System.DateUtils, SFBusinessDataConnector;

constructor bdscstmr.Create(pOwner: TComponent);
begin
  inherited;

  TableName := 'bdscstmr';
  CatalogName := '';
  SchemaName := '';

  mObjCstmrOrder := nil;
end;

destructor bdscstmr.Destroy;
begin
  inherited;

  if (Assigned(mObjCstmrOrder)) then
    FreeAndNil(mObjCstmrOrder);
end;

procedure bdscstmr.AfterDBDeleteRow;
  var lObjOrderDel: bdscstmrorder;
begin
  inherited;

  // if not using foreign key, you can do this
  // note: on cached updates, related objects are not synced during ApplyUpdates
  lObjOrderDel := bdscstmrorder.Create;
  try
    lObjOrderDel.DeletePositionsByCstmrId(bdscstmrid);
  finally
    FreeAndNil(lObjOrderDel);
  end;

  DeleteDepended('bdscstmrorder', '', '', 'bdscstmrid', 'bdscstmrordercstmrid');
end;

procedure bdscstmr.DoAfterOpen;
  var lFldName: String;
begin
  inherited;

  // if the autoinc for bdscstmrid wasn't automacially detected, add it
  lFldName := FieldNameForDBField('bdscstmrid', True);
  if (lFldName <> '') and (Assigned(FindField(lFldName))) then
  begin
    if not(FieldByName(lFldName) is TAutoIncField) then
    begin
      if (ConnectorUsed.ConnectionDBType = dbtIB) then
        AddAutoValueForField(lFldName).SequenceName := 'GEN_bdscstmrid'
      else
        AddAutoValueForField(lFldName);
    end;
  end;
end;

function bdscstmr.getObjCstmrOrder: bdscstmrorder;
begin
  // get/initialize internal obj with orders, which are related to
  // the current customer
  if (mObjCstmrOrder = nil) then
  begin
    mObjCstmrOrder := bdscstmrorder.Create;
    AddRelation(mObjCstmrOrder, 'bdscstmrid', 'bdscstmrordercstmrid');
  end;

  Result := mObjCstmrOrder;
end;

function bdscstmr.getbdscstmrid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmr.getbdscstmrname: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrname', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrfirstname: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrfirstname', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrdateofbirth: TDate;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrdateofbirth', True);
  if (lFldName <> '') then
    Result := DateOf(FieldByName(lFldName).AsDateTime);
end;

function bdscstmr.getbdscstmrpostcode: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrpostcode', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrcity: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrcity', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrstreet: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrstreet', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrnotice: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrnotice', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrimage: TBytes;
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrimage', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsBytes;
end;

function bdscstmr.getbdscstmrimageext: String;
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrimageext', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

function bdscstmr.getbdscstmrtypeid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrtypeid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

procedure bdscstmr.setbdscstmrid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmr.setbdscstmrname(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrname', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrfirstname(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrfirstname', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrdateofbirth(pValue: TDate);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrdateofbirth', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsDateTime := pValue;
end;

procedure bdscstmr.setbdscstmrpostcode(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrpostcode', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrcity(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrcity', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrstreet(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrstreet', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrnotice(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrnotice', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

procedure bdscstmr.setbdscstmrtypeid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrtypeid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmr.setbdscstmrimage(pValue: TBytes);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrimage', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsBytes := pValue;
end;

procedure bdscstmr.setbdscstmrimageext(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrimageext', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

initialization
begin
  TSFBusinessClassFactory.RegisterClass(bdscstmr, 'bdscstmr');
end;

end.
