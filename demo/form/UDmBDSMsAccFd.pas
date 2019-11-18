unit UDmBDSMsAccFd;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, SFBusinessDataConnector, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc;

type
  TDmBDSMsAccFd = class(TDataModule)
    FDConnection1: TFDConnection;
    SFConnector1: TSFConnector;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSMsAccFd: TDmBDSMsAccFd;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSMsAccFd.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  FDConnection1.Connected := True;
end;

procedure TDmBDSMsAccFd.DataModuleDestroy(Sender: TObject);
begin
  FDConnection1.Connected := False;
end;

procedure TDmBDSMsAccFd.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDateTime := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDateTime := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDateTime);
end;

end.
