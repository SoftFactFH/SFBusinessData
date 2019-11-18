program BDSDemo;

uses
  Vcl.Forms,
  UFrmBDSDemo in '..\form\UFrmBDSDemo.pas' {FrmBDSDemo},
  UFrmBDSSearch in '..\form\UFrmBDSSearch.pas' {FrmBDSSearch},
  UDmBDSMySQLFd in '..\form\UDmBDSMySQLFd.pas' {DmBDSMySQLFd: TDataModule},
  Ubdsarticle in '..\bdsclass\Ubdsarticle.pas',
  Ubdscstmr in '..\bdsclass\Ubdscstmr.pas',
  Ubdscstmrorder in '..\bdsclass\Ubdscstmrorder.pas',
  Ubdscstmrorderpos in '..\bdsclass\Ubdscstmrorderpos.pas',
  Ubdscstmrtype in '..\bdsclass\Ubdscstmrtype.pas',
  UFrmBDSDemoOrderPos in '..\form\UFrmBDSDemoOrderPos.pas' {FrmBDSDemoOrderPos},
  UFrmBDSDemoArticle in '..\form\UFrmBDSDemoArticle.pas' {FrmBDSDemoArticle},
  UDmBDSIBdbExpress in '..\form\UDmBDSIBdbExpress.pas' {DmBDSIBdbExpress: TDataModule},
  BDSDemoCommon in '..\common\BDSDemoCommon.pas',
  UDmBDSODBCMSSQLFd in '..\form\UDmBDSODBCMSSQLFd.pas' {DmBDSODBCMSSQLFd: TDataModule},
  UFrmBDSDemoSubqueries in '..\form\UFrmBDSDemoSubqueries.pas' {FrmBDSDemoSubqueries},
  UDmBDSMsAccADO in '..\form\UDmBDSMsAccADO.pas' {DmBDSMsAccADO: TDataModule},
  UDmBDSInterbase in '..\form\UDmBDSInterbase.pas' {DmBDSInterbase: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmBDSIBdbExpress, DmBDSIBdbExpress);
  Application.CreateForm(TFrmBDSDemo, FrmBDSDemo);
  Application.Run;
end.
