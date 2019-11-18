unit UFrmBDSDemoOrderPos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Ubdscstmrorder, SFBusinessDataCustom;

type
  TFrmBDSDemoOrderPos = class(TForm)
    DBEdit1: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    srcOrder: TDataSource;
    srcOrderPos: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Label11: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    mInsertByUser: Boolean;
  private
    function objOrderPosCompareRecords(pRecFrom, pRecTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult;
    procedure objOrderPosBeforeInsert(pDataSet: TDataSet);
    procedure setObjbdscstmrOrder(pObj: bdscstmrorder);
  public
    property ObjbdscstmrOrder: bdscstmrorder write setObjbdscstmrOrder;
  end;

var
  FrmBDSDemoOrderPos: TFrmBDSDemoOrderPos;

implementation

uses UFrmBDSDemoArticle, Ubdscstmrorderpos;

{$R *.dfm}


procedure TFrmBDSDemoOrderPos.FormCreate(Sender: TObject);
begin
  mInsertByUser := True;
end;

procedure TFrmBDSDemoOrderPos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TSFCustomBusinessData(srcOrderPos.DataSet).OnCompareRecords := nil;
  TSFCustomBusinessData(srcOrderPos.DataSet).BeforeInsert := nil;
end;

procedure TFrmBDSDemoOrderPos.Button1Click(Sender: TObject);
  var lFrmArt: TFrmBDSDemoArticle;
begin
  // add/call articles
  lFrmArt := TFrmBDSDemoArticle.Create(nil);
  try
    if (lFrmArt.ShowModal = mrOK) and (lFrmArt.CurrentArticleId > 0) then
    begin
      mInsertByUser := False;
      try
        srcOrderPos.DataSet.Append;
        bdscstmrorderpos(srcOrderPos.DataSet).bdscstmrorderposorderid := bdscstmrorder(srcOrder.DataSet).bdscstmrorderid;
        bdscstmrorderpos(srcOrderPos.DataSet).bdscstmrorderposartid := lFrmArt.CurrentArticleId;
        bdscstmrorderpos(srcOrderPos.DataSet).bdscstmrorderposquantity := 1;
        srcOrderPos.DataSet.Post;
      finally
        mInsertByUser := True;
      end;
    end else
    if (lFrmArt.HasChanges) then
      bdscstmrorderpos(srcOrderPos.DataSet).NotifyArticleChanged;
  finally
    FreeAndNil(lFrmArt);
  end;
end;

procedure TFrmBDSDemoOrderPos.DBGrid1TitleClick(Column: TColumn);
  var lOrderIdx: Integer;
begin
  // save the index from clicked colheader and start sorting buffer
  lOrderIdx := Column.Index + 1;
  if (Abs(srcOrderPos.DataSet.Tag) = lOrderIdx) then
  begin
    if (srcOrderPos.DataSet.Tag < 0) then
      srcOrderPos.DataSet.Tag := lOrderIdx
    else
      srcOrderPos.DataSet.Tag := lOrderIdx * -1;
  end else
    srcOrderPos.DataSet.Tag := lOrderIdx;

  TSFCustomBusinessData(srcOrderPos.DataSet).SortBuffer;
end;

procedure TFrmBDSDemoOrderPos.setObjbdscstmrOrder(pObj: bdscstmrorder);
begin
  srcOrder.DataSet := pObj;
  srcOrderPos.DataSet := pObj.ObjOrderPos;
  pObj.ObjOrderPos.OnCompareRecords := objOrderPosCompareRecords;
  pObj.ObjOrderPos.BeforeInsert := objOrderPosBeforeInsert;
end;

procedure TFrmBDSDemoOrderPos.objOrderPosBeforeInsert(pDataSet: TDataSet);
begin
  if (mInsertByUser) then
    Abort;
end;

function TFrmBDSDemoOrderPos.objOrderPosCompareRecords(pRecFrom, pRecTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult;
  var lDesc: Boolean;
      lFldName: String;
begin
  // compare given records (called on sorting buffer)
  lDesc := (srcOrderPos.DataSet.Tag < 0);
  lFldName := DBGrid1.Columns.Items[Abs(srcOrderPos.DataSet.Tag) - 1].FieldName;

  if not(lDesc) then
  begin
    if (pRecFrom.GetFieldValByName(lFldName) > pRecTo.GetFieldValByName(lFldName)) then
      Result := compareResultGreater
    else if (pRecFrom.GetFieldValByName(lFldName) < pRecTo.GetFieldValByName(lFldName)) then
      Result := compareResultLess
    else
      Result := compareResultEqual;
  end else
  begin
    if (pRecFrom.GetFieldValByName(lFldName) > pRecTo.GetFieldValByName(lFldName)) then
      Result := compareResultLess
    else if (pRecFrom.GetFieldValByName(lFldName) < pRecTo.GetFieldValByName(lFldName)) then
      Result := compareResultGreater
    else
      Result := compareResultEqual;
  end;
end;

end.
