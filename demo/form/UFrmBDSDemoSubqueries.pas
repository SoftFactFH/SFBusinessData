unit UFrmBDSDemoSubqueries;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SFStatements, Data.DB,
  SFBusinessDataCustom, SFBusinessData, Vcl.Grids, Vcl.DBGrids;

type
  TFrmBDSDemoSubqueries = class(TForm)
    memBDSDemoSubqueries: TMemo;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    SFDataSet1: TSFDataSet;
    stmtOrderSum: TSFStmt;
    stmtCstmrSum: TSFStmt;
    stmtExistsType: TSFStmt;
    stmtUnionNoCstmr: TSFStmt;
    stmtCstmrMain: TSFStmt;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmBDSDemoSubqueries: TFrmBDSDemoSubqueries;

implementation

uses System.UITypes;

{$R *.dfm}

procedure TFrmBDSDemoSubqueries.Button1Click(Sender: TObject);
begin
  if (SFDataSet1.GetCanSubSelectInFrom) then
  begin
    if (SFDataSet1.Active) then
      SFDataSet1.Close;

    SFDataSet1.Stmt.Reset;
    stmtCstmrMain.AssignStmtTo(SFDataSet1.Stmt);
    SFDataSet1.Open;
  end else
    MessageDlg('the used database doesn''t support subselects in from-clause', mtError, [mbOk], 0);
end;

procedure TFrmBDSDemoSubqueries.Button2Click(Sender: TObject);
begin
  memBDSDemoSubqueries.Text := stmtCstmrMain.GetSelectStmt;
end;

end.
