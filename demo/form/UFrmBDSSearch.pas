unit UFrmBDSSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.DBCtrls,
  Vcl.Mask, SFBusinessData, SFBusinessDataCustom;

type
  TFrmBDSSearch = class(TForm)
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label10: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    Label8: TLabel;
    DataSource2: TDataSource;
    DataSource1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    DsFrmBDSSearchCache: TSFDataSet;
    DsFrmBDSSearchType: TSFDataSet;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  public
    property BDSDataCstmrCached: TSFDataSet read DsFrmBDSSearchCache;
  end;

var
  FrmBDSSearch: TFrmBDSSearch;

implementation

{$R *.dfm}

procedure TFrmBDSSearch.Button1Click(Sender: TObject);
begin
  if (DsFrmBDSSearchCache.State in [dsInsert, dsEdit]) then
    DsFrmBDSSearchCache.Post;
end;

procedure TFrmBDSSearch.Button2Click(Sender: TObject);
begin
  if (DsFrmBDSSearchCache.State in [dsInsert, dsEdit]) then
    DsFrmBDSSearchCache.Cancel;
end;

procedure TFrmBDSSearch.FormCreate(Sender: TObject);
begin
  DsFrmBDSSearchCache.InitFieldsFromBusinessData('bdscstmr', '', '', True, True, True);
  DsFrmBDSSearchCache.Open;
  DsFrmBDSSearchType.Open;
end;

end.
