unit UFrmBDSDemoArticle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, SFBusinessData;

type
  TFrmBDSDemoArticle = class(TForm)
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    SFBusinessDataWrap1: TSFBusinessDataWrap;
    SFBusinessDataWrapSource1: TSFBusinessDataWrapSource;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SFBusinessDataWrap1TSFBusinessDataAfterPost(DataSet: TDataSet);
  private
    mHasChanges: Boolean;
  private
    function getCurrentArticleId: Integer;
  public
    property CurrentArticleId: Integer read getCurrentArticleId;
    property HasChanges: Boolean read mHasChanges;
  end;

var
  FrmBDSDemoArticle: TFrmBDSDemoArticle;

implementation

uses Ubdsarticle;

{$R *.dfm}

procedure TFrmBDSDemoArticle.FormCreate(Sender: TObject);
begin
  mHasChanges := False;
  SFBusinessDataWrap1.BusinessDataSet.Open;
end;

function TFrmBDSDemoArticle.getCurrentArticleId: Integer;
begin
  // return the selected articleid
  Result := 0;

  if not(SFBusinessDataWrap1.BusinessDataSet.IsEmpty) and (SFBusinessDataWrap1.BusinessDataSet.RecNo >= 1) then
    Result := bdsarticle(SFBusinessDataWrap1.BusinessDataSet).bdsarticleid;
end;

procedure TFrmBDSDemoArticle.SFBusinessDataWrap1TSFBusinessDataAfterPost(
  DataSet: TDataSet);
begin
  mHasChanges := True;
end;

end.
