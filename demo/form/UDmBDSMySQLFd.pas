unit UDmBDSMySQLFd;

interface

uses
  // NOTE: FireDac is available since XE4 (min. Enterprise) or XE5 (min. Professional)
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait,
  SFBusinessDataConnector, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDmBDSMySQLFd = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    SFConnector1: TSFConnector;
    FDTransaction1: TFDTransaction;
    FDTransaction2: TFDTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSMySQLFd: TDmBDSMySQLFd;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSMySQLFd.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  FDConnection1.Connected := True;
end;

procedure TDmBDSMySQLFd.DataModuleDestroy(Sender: TObject);
begin
  FDConnection1.Connected := False;
end;

procedure TDmBDSMySQLFd.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDate := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDate := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDate);
end;

end.
