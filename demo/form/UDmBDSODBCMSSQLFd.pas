unit UDmBDSODBCMSSQLFd;

interface

uses
  // NOTE: FireDac is available since XE4 (min. Enterprise) or XE5 (min. Professional)
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  SFBusinessDataConnector;

type
  TDmBDSODBCMSSQLFd = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    SFConnector1: TSFConnector;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSODBCMSSQLFd: TDmBDSODBCMSSQLFd;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSODBCMSSQLFd.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  FDConnection1.Connected := True;
end;

procedure TDmBDSODBCMSSQLFd.DataModuleDestroy(Sender: TObject);
begin
  FDConnection1.Connected := False;
end;

procedure TDmBDSODBCMSSQLFd.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDateTime := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDateTime := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDateTime);
end;

end.
