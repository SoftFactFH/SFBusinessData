unit Ubdscstmrtype;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils;

type
  bdscstmrtype = class(TSFBusinessData)
    private
      function getbdscstmrtypeid: Integer;
	    function getbdscstmrtypedesc: String;
      procedure setbdscstmrtypeid(pValue: Integer);
	    procedure setbdscstmrtypedesc(pValue: String);
    public
      constructor Create(pOwner: TComponent); override;
    public
      property bdscstmrtypeid: Integer read getbdscstmrtypeid write setbdscstmrtypeid;
	    property bdscstmrtypedesc: String read getbdscstmrtypedesc write setbdscstmrtypedesc;
  end;

implementation

constructor bdscstmrtype.Create(pOwner: TComponent);
begin
  inherited;

  TableName := 'bdscstmrtype';
  CatalogName := '';
  SchemaName := '';
end;

function bdscstmrtype.getbdscstmrtypeid: Integer;
  var lFldName: String;
begin
  Result := 0;

  lFldName := FieldNameForDBField('bdscstmrtypeid', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsInteger;
end;

function bdscstmrtype.getbdscstmrtypedesc: String;
  var lFldName: String;
begin
  Result := '';

  lFldName := FieldNameForDBField('bdscstmrtypedesc', True);
  if (lFldName <> '') then
    Result := FieldByName(lFldName).AsString;
end;

procedure bdscstmrtype.setbdscstmrtypeid(pValue: Integer);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrtypeid', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsInteger := pValue;
end;

procedure bdscstmrtype.setbdscstmrtypedesc(pValue: String);
  var lFldName: String;
begin
  lFldName := FieldNameForDBField('bdscstmrtypedesc', True);
  if (lFldName <> '') then
    FieldByName(lFldName).AsString := pValue;
end;

initialization
begin
  TSFBusinessClassFactory.RegisterClass(bdscstmrtype, 'bdscstmrtype');
end;

end.
