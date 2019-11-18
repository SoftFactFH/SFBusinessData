unit UBusinessDataTmpl;

interface

uses SFBusinessData, SFBusinessDataCustom, Data.DB, System.Generics.Collections,
     System.Classes, System.SysUtils;

type
  MyTable = class(TSFBusinessData)
  public
    constructor Create(pOwner: TComponent); override;
  end;

implementation

constructor BusinessDataTmpl.Create(pOwner: TComponent);
begin
  inherited;

  // your tablename
  TableName := 'MyTable';
  // your catalogname (if necessary)
  CatalogName := '';
  // your schemaname (if necessary)
  SchemaName := '';
end;


initialization
begin
  TSFBusinessClassFactory.RegisterClass(MyTable, 'MyTable');
end;

end.
