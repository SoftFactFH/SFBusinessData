unit Ubdscstmrorderpos;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils, Ubdsarticle;

type
  bdscstmrorderpos = class(TSFBusinessData)
    private
      mObjArticle: bdsarticle;
    private
      function getObjArticle: bdsarticle;
    private
      function getbdscstmrorderposid: Integer;
	    function getbdscstmrorderposorderid: Integer;
	    function getbdscstmrorderposquantity: Integer;
	    function getbdscstmrorderposartid: Integer;
	    function getbdscstmrorderpossum: Double;
	    function getbdscstmrorderposprice: Double;
	    function getbdscstmrorderposartdesc: String;
      procedure setbdscstmrorderposid(pValue: Integer);
	    procedure setbdscstmrorderposorderid(pValue: Integer);
	    procedure setbdscstmrorderposquantity(pValue: Integer);
	    procedure setbdscstmrorderposartid(pValue: Integer);
	    procedure setbdscstmrorderpossum(pValue: Double);
	    procedure setbdscstmrorderposprice(pValue: Double);
	    procedure setbdscstmrorderposartdesc(pValue: String);
    protected
      procedure DoOnCalcFields; override;
      procedure DoAfterPost; override;
      procedure DoAfterDelete; override;
      procedure DoAfterOpen; override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      function CalcAmount: Double;
      procedure NotifyArticleChanged;
    public
      property ObjArticle: bdsarticle read getObjArticle;
    public
      property bdscstmrorderposid: Integer read getbdscstmrorderposid write setbdscstmrorderposid;
	    property bdscstmrorderposorderid: Integer read getbdscstmrorderposorderid write setbdscstmrorderposorderid;
	    property bdscstmrorderposquantity: Integer read getbdscstmrorderposquantity write setbdscstmrorderposquantity;
	    property bdscstmrorderposartid: Integer read getbdscstmrorderposartid write setbdscstmrorderposartid;
	    property bdscstmrorderpossum: Double read getbdscstmrorderpossum write setbdscstmrorderpossum;
	    property bdscstmrorderposprice: Double read getbdscstmrorderposprice write setbdscstmrorderposprice;
	    property bdscstmrorderposartdesc: String read getbdscstmrorderposartdesc write setbdscstmrorderposartdesc;
  end;

implementation

uses Ubdscstmrorder, SFBusinessDataConnector;

constructor bdscstmrorderpos.Create(pOwner: TComponent);
begin
  inherited;

  TableName := 'bdscstmrorderpos';
  CatalogName := '';
  SchemaName := '';

  AddDynCalcField('bdscstmrorderposprice', ftFloat, 0);
  AddDynCalcField('bdscstmrorderpossum', ftFloat, 0);
  AddDynCalcField('bdscstmrorderposartdesc', ftString, 50);
  mObjArticle := nil;
end;

destructor bdscstmrorderpos.Destroy;
begin
  inherited;

  if (Assigned(mObjArticle)) then
    FreeAndNil(mObjArticle);
end;

function bdscstmrorderpos.CalcAmount: Double;
begin
  // calculate the full price for the current position
  Result := 0;

  if (State <> dsCalcFields) and (IsEmpty) or (ObjArticle.IsEmpty) then
    Exit;

  Result := ObjArticle.bdsarticleprice * bdscstmrorderposquantity;
end;

procedure bdscstmrorderpos.NotifyArticleChanged;
begin
  // refresh object, when articles data (description, price) was changed
  CheckBrowseMode;
  FullRefresh;
  if (Assigned(ParentRel)) and (ParentRel.SrcObj is bdscstmrorder) then
  begin
    DisableControls;
    try
      bdscstmrorder(ParentRel.SrcObj).RecalcCalculatedFields;
    finally
      EnableControls;
    end;
  end;
end;

procedure bdscstmrorderpos.DoOnCalcFields;
begin
  inherited;

  // in DoOnCalcFields relations will synced after calcfields
  // => reopen objarticle to take sure, objarticle is synced
  ObjArticle.FullRefresh;

  if not(ObjArticle.IsEmpty) then
  begin
    bdscstmrorderposartdesc := ObjArticle.bdsarticledesc;
    bdscstmrorderposprice := ObjArticle.bdsarticleprice
  end else
  begin
    bdscstmrorderposartdesc := '';
    bdscstmrorderposprice := 0;
  end;

  bdscstmrorderpossum := CalcAmount;
end;

procedure bdscstmrorderpos.DoAfterPost;
begin
  inherited;

  // when is a related/synced obj from a order, notify the order, that
  // there are changes in positions
  if (Assigned(ParentRel)) and (ParentRel.SrcObj is bdscstmrorder) then
  begin
    DisableControls;
    try
      bdscstmrorder(ParentRel.SrcObj).RecalcCalculatedFields;
    finally
      EnableControls;
    end;
  end;
end;

procedure bdscstmrorderpos.DoAfterDelete;
begin
  inherited;

  // when is a related/synced obj from a order, notify the order, that
  // there are changes in positions
  if (Assigned(ParentRel)) and (ParentRel.SrcObj is bdscstmrorder) then
  begin
    DisableControls;
    try
      bdscstmrorder(ParentRel.SrcObj).RecalcCalculatedFields;
    finally
      EnableControls;
    end;
  end;
end;

procedure bdscstmrorderpos.DoAfterOpen;
  var lFldName: String;
begin
  inherited;

  // if the autoinc for bdscstmrorderposid wasn't automacially detected, add it
  lFldName := FieldNameForDBField('bdscstmrorderposid', True);
  if (lFldName <> '') and (Assigned(FindField(lFldName))) then
  begin
    if not(FieldByName(lFldName) is TAutoIncField) then
    begin
      if (ConnectorUsed.ConnectionDBType = dbtIB) then
        AddAutoValueForField(lFldName).SequenceName := 'GEN_bdscstmrorderposid'
      else
        AddAutoValueForField(lFldName);
    end;
  end;
end;

function bdscstmrorderpos.getObjArticle: bdsarticle;
begin
  // get/initialize internal obj with article, which is related to
  // the current orderposition
  if (mObjArticle = nil) then
  begin
    mObjArticle := bdsarticle.Create;
    AddRelation(mObjArticle, 'bdscstmrorderposartid', 'bdsarticleid');
  end;

  Result := mObjArticle;
end;

function bdscstmrorderpos.getbdscstmrorderposid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderposid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorderpos.getbdscstmrorderposorderid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderposorderid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorderpos.getbdscstmrorderposquantity: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderposquantity', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorderpos.getbdscstmrorderposartid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrorderposartid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrorderpos.getbdscstmrorderpossum: Double;
begin
  Result := 0;
  if (Assigned(FindField('bdscstmrorderpossum'))) then
    Result := FieldByName('bdscstmrorderpossum').AsFloat;
end;

function bdscstmrorderpos.getbdscstmrorderposprice: Double;
begin
  Result := 0;
  if (Assigned(FindField('bdscstmrorderposprice'))) then
    Result := FieldByName('bdscstmrorderposprice').AsFloat;
end;

function bdscstmrorderpos.getbdscstmrorderposartdesc: String;
begin
  Result := '';
  if (Assigned(FindField('bdscstmrorderposartdesc'))) then
    Result := FieldByName('bdscstmrorderposartdesc').AsString;
end;

procedure bdscstmrorderpos.setbdscstmrorderposid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderposid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderposorderid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderposorderid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderposquantity(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderposquantity', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderposartid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrorderposartid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderpossum(pValue: Double);
begin
  if (Assigned(FindField('bdscstmrorderpossum'))) and (FieldByName('bdscstmrorderpossum').AsFloat <> pValue) then
    FieldByName('bdscstmrorderpossum').AsFloat := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderposprice(pValue: Double);
begin
  if (Assigned(FindField('bdscstmrorderposprice'))) and (FieldByName('bdscstmrorderposprice').AsFloat <> pValue) then
    FieldByName('bdscstmrorderposprice').AsFloat := pValue;
end;

procedure bdscstmrorderpos.setbdscstmrorderposartdesc(pValue: String);
begin
  if (Assigned(FindField('bdscstmrorderposartdesc'))) and (FieldByName('bdscstmrorderposartdesc').AsString <> pValue) then
    FieldByName('bdscstmrorderposartdesc').AsString := pValue;
end;

initialization
begin
  TSFBusinessClassFactory.RegisterClass(bdscstmrorderpos, 'bdscstmrorderpos');
end;

end.
