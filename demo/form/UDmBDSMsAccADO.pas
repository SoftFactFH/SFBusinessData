unit UDmBDSMsAccADO;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,
  SFBusinessDataConnector;

type
  TDmBDSMsAccADO = class(TDataModule)
    ADOConnection1: TADOConnection;
    SFConnector1: TSFConnector;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSMsAccADO: TDmBDSMsAccADO;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSMsAccADO.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  ADOConnection1.Connected := True;
end;

procedure TDmBDSMsAccADO.DataModuleDestroy(Sender: TObject);
begin
  ADOConnection1.Connected := False;
end;

procedure TDmBDSMsAccADO.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDateTime := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDateTime := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDateTime);
end;

end.
