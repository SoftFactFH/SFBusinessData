unit UDmBDSIBdbExpress;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr,
  Data.DBXInterBase, SFBusinessDataConnector;

type
  TDmBDSIBdbExpress = class(TDataModule)
    SQLConnection1: TSQLConnection;
    SFConnector1: TSFConnector;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSIBdbExpress: TDmBDSIBdbExpress;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSIBdbExpress.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  SQLConnection1.Connected := True;
end;

procedure TDmBDSIBdbExpress.DataModuleDestroy(Sender: TObject);
begin
  SQLConnection1.Connected := False;
end;

procedure TDmBDSIBdbExpress.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDate := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDate := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDate);
end;

end.
