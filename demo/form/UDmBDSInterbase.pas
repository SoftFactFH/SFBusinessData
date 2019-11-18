unit UDmBDSInterbase;

interface

uses
  System.SysUtils, System.Classes, Data.DB, SFBusinessDataConnector,
  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF CompilerVersion < 27.0}
      IBDatabase
    {$ELSE}
      IBX.IBDatabase
    {$ENDIF}
  {$ELSE}
    IBX.IBDatabase
  {$ENDIF}
  ;

type
  TDmBDSInterbase = class(TDataModule)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    SFConnector1: TSFConnector;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure initFormats;
  public
    { Public-Deklarationen }
  end;

var
  DmBDSInterbase: TDmBDSInterbase;

implementation

uses BDSDemoCommon;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmBDSInterbase.DataModuleCreate(Sender: TObject);
begin
  initFormats;
  IBDatabase1.Connected := True;
end;

procedure TDmBDSInterbase.DataModuleDestroy(Sender: TObject);
begin
  IBDatabase1.Connected := False;
end;

procedure TDmBDSInterbase.initFormats;
begin
  SFConnector1.FormatOptions.DisplayFmtDate := GetLocalDateFormat;
  SFConnector1.FormatOptions.EditMaskDate := GetDateEditMaskByFrmt(SFConnector1.FormatOptions.DisplayFmtDate);
end;

end.
