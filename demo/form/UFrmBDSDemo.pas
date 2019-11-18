unit UFrmBDSDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, SFBusinessDataCustom, SFStatements, SFBusinessData,
  Vcl.ExtDlgs, Vcl.DBCtrls;

type
  TFrmBDSDemo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    Label9: TLabel;
    DBEdit8: TDBEdit;
    Label10: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    srcFrmBDSDemoTypeLkp: TDataSource;
    DBMemo1: TDBMemo;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    Button3: TButton;
    DsWFrmBDSDemoCstmr: TSFBusinessDataWrap;
    DsFrmBDSDemoTypeLkp: TSFDataSet;
    srcFrmBDSDemoCstmr: TSFBusinessDataWrapSource;
    DsWFrmBDSDemoOrder: TSFBusinessDataWrap;
    srcFrmBDSDemoOrder: TSFBusinessDataWrapSource;
    Label11: TLabel;
    Label12: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    Image1: TImage;
    Label13: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DsWFrmBDSDemoOrderTSFBusinessDataAfterInsert(DataSet: TDataSet);
    procedure DBGrid1TitleClick(Column: TColumn);
    function DsWFrmBDSDemoOrderTSFBusinessDataCompareRecords(CompareRecordFrom,
      CompareRecordTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult;
    procedure DsWFrmBDSDemoCstmrTSFBusinessDataAfterInsert(DataSet: TDataSet);
    procedure DsWFrmBDSDemoCstmrTSFBusinessDataAfterCancel(DataSet: TDataSet);
    procedure DsWFrmBDSDemoCstmrTSFBusinessDataAfterPost(DataSet: TDataSet);
    procedure DsWFrmBDSDemoCstmrTSFBusinessDataFieldChange(Sender: TObject;
      Field: TField);
    procedure DsWFrmBDSDemoOrderTSFBusinessDataBeforeInsert(DataSet: TDataSet);
    procedure DsWFrmBDSDemoCstmrTSFBusinessDataRecordChange(DataSet: TDataSet);
    procedure Image1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure loadImageFromData;
    function graphicClsByExt(pExt: String): TGraphicClass;
  end;

var
  FrmBDSDemo: TFrmBDSDemo;

implementation

uses SFStatementType, UFrmBDSSearch, System.StrUtils, Ubdscstmr, Ubdscstmrorder,
     UFrmBDSDemoOrderPos, System.UITypes, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,
     Vcl.Imaging.jpeg, UFrmBDSDemoSubqueries;

{$R *.dfm}

procedure TFrmBDSDemo.FormCreate(Sender: TObject);
begin
  DsWFrmBDSDemoCstmr.BusinessDataSet.Open;
  // note: order will opened from cstmr (because it's a relation)
  DsFrmBDSDemoTypeLkp.Open;
end;

procedure TFrmBDSDemo.Image1Click(Sender: TObject);
begin
  if (OpenPictureDialog1.Execute) then
  begin
    if not(DsWFrmBDSDemoCstmr.BusinessDataSet.State in [dsInsert, dsEdit]) then
    begin
      if (DsWFrmBDSDemoCstmr.BusinessDataSet.IsEmpty) then
        DsWFrmBDSDemoCstmr.BusinessDataSet.Insert
      else
        DsWFrmBDSDemoCstmr.BusinessDataSet.Edit;
    end;

    TBlobField(DsWFrmBDSDemoCstmr.BusinessDataSet.FieldByName('bdscstmrimage')).LoadFromFile(OpenPictureDialog1.FileName);
    bdscstmr(DsWFrmBDSDemoCstmr.BusinessDataSet).bdscstmrimageext := ExtractFileExt(OpenPictureDialog1.FileName);
    loadImageFromData;
  end;
end;

procedure TFrmBDSDemo.Button1Click(Sender: TObject);
  var lFrmOrderPos: TFrmBDSDemoOrderPos;
begin
  DsWFrmBDSDemoCstmr.BusinessDataSet.CheckBrowseMode;
  DsWFrmBDSDemoOrder.BusinessDataSet.CheckBrowseMode;

  if not(DsWFrmBDSDemoOrder.BusinessDataSet.IsEmpty) and (DsWFrmBDSDemoOrder.BusinessDataSet.RecNo >= 1) then
  begin
    lFrmOrderPos := TFrmBDSDemoOrderPos.Create(nil);
    try
      lFrmOrderPos.ObjbdscstmrOrder := bdscstmrorder(DsWFrmBDSDemoOrder.BusinessDataSet);
      lFrmOrderPos.ShowModal;
    finally
      FreeAndNil(lFrmOrderPos);
    end;
  end;
end;

procedure TFrmBDSDemo.Button2Click(Sender: TObject);
  var lFrmSubQuery: TFrmBDSDemoSubqueries;
begin
  DsWFrmBDSDemoCstmr.BusinessDataSet.CheckBrowseMode;
  DsWFrmBDSDemoOrder.BusinessDataSet.CheckBrowseMode;

  lFrmSubQuery := TFrmBDSDemoSubqueries.Create(nil);
  try
    lFrmSubQuery.ShowModal;
  finally
    FreeAndNil(lFrmSubQuery);
  end;
end;

procedure TFrmBDSDemo.Button3Click(Sender: TObject);
  var lFrmSearch: TFrmBDSSearch;
      i: Integer;
      lTabAlias, lTab, lTabS, lTabC, lTabAttr: String;
      lSearchFldVal: TField;
      lBDS: TSFBusinessData;
begin
  // set search-conditions from modal form to cstmr-obj and execute
  lBDS := DsWFrmBDSDemoCstmr.BusinessDataSet;
  lBDS.CheckBrowseMode;

  lFrmSearch := TFrmBDSSearch.Create(nil);
  try
    if (lFrmSearch.ShowModal = mrOK) then
    begin
      lBDS.Stmt.ClearConditions;
      if not(lFrmSearch.BDSDataCstmrCached.IsEmpty) then
      begin
        for i := 0 to (lBDS.Fields.Count - 1) do
        begin
          if (lBDS.Fields[i].FieldKind <> fkData) then
            Continue;

          if (lBDS.DatabaseNameForFieldName(lBDS.Fields[i].FieldName, lTabAlias, lTab, lTabS, lTabC, lTabAttr)) and
            (UpperCase(lTab) = 'BDSCSTMR') then
          begin
            lSearchFldVal := lFrmSearch.BDSDataCstmrCached.FindField(lTabAttr);
            if (Assigned(lSearchFldVal)) and not(lSearchFldVal.IsNull) and (lSearchFldVal.AsString <> '') then
            begin
              if not(lBDS.Stmt.AttrExists(lTabAttr, 'bdscstmr', '')) then
                lBDS.Stmt.SetStmtAttr(lTabAttr, '', 'bdscstmr', True);

              if not(lBDS.Fields[i].IsBlob) then
                lBDS.Stmt.AddConditionVal('bdscstmr', lTabAttr, SFSTMT_OP_EQUAL, lSearchFldVal.Value)
              else
                lBDS.Stmt.AddConditionVal('bdscstmr', lTabAttr, SFSTMT_OP_LIKE, lSearchFldVal.Value);
            end;
          end;
        end;
      end;

      lBDS.Close;
      lBDS.Open;
    end;
  finally
    FreeAndNil(lFrmSearch);
  end;
end;

procedure TFrmBDSDemo.DBGrid1TitleClick(Column: TColumn);
  var lOrderIdx: Integer;
begin
  // save clicked column-index and start sorting buffer
  lOrderIdx := Column.Index + 1;
  if (Abs(DsWFrmBDSDemoOrder.BusinessDataSet.Tag) = lOrderIdx) then
  begin
    if (DsWFrmBDSDemoOrder.BusinessDataSet.Tag < 0)  then
      DsWFrmBDSDemoOrder.BusinessDataSet.Tag := lOrderIdx
    else
      DsWFrmBDSDemoOrder.BusinessDataSet.Tag := lOrderIdx * -1;
  end else
    DsWFrmBDSDemoOrder.BusinessDataSet.Tag := lOrderIdx;

  DsWFrmBDSDemoOrder.BusinessDataSet.SortBuffer;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoCstmrTSFBusinessDataAfterInsert(
  DataSet: TDataSet);
begin
  // use cached update on orders to take sure, no orders will be created
  // without existing customer
  // -> otherwise use transactions
  // -> disable sync because on post/cancel related datasets will be synced
  //    before fire afterpost/aftercancel
  // -> see also passkeys (on relation)
  DsWFrmBDSDemoOrder.BusinessDataSet.CachedUpdates := True;
  DsWFrmBDSDemoCstmr.BusinessDataSet.SetDisableSyncRel(DsWFrmBDSDemoOrder.BusinessDataSet, True);
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoCstmrTSFBusinessDataAfterCancel(
  DataSet: TDataSet);
begin
  // see DsWFrmBDSDemoCstmrTSFBusinessDataAfterInsert
  if (DsWFrmBDSDemoOrder.BusinessDataSet.CachedUpdates) then
  begin
    DsWFrmBDSDemoOrder.BusinessDataSet.CancelUpdates;
    DsWFrmBDSDemoOrder.BusinessDataSet.CachedUpdates := False;
    DsWFrmBDSDemoCstmr.BusinessDataSet.ExplicitSyncRel(DsWFrmBDSDemoOrder.BusinessDataSet);
    DsWFrmBDSDemoCstmr.BusinessDataSet.SetDisableSyncRel(DsWFrmBDSDemoOrder.BusinessDataSet, False);
  end;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoCstmrTSFBusinessDataAfterPost(
  DataSet: TDataSet);
begin
  // see DsWFrmBDSDemoCstmrTSFBusinessDataAfterInsert
  if (DsWFrmBDSDemoOrder.BusinessDataSet.CachedUpdates) then
  begin
    DsWFrmBDSDemoOrder.BusinessDataSet.ApplyUpdates;
    DsWFrmBDSDemoOrder.BusinessDataSet.CachedUpdates := False;
    DsWFrmBDSDemoCstmr.BusinessDataSet.ExplicitSyncRel(DsWFrmBDSDemoOrder.BusinessDataSet);
    DsWFrmBDSDemoCstmr.BusinessDataSet.SetDisableSyncRel(DsWFrmBDSDemoOrder.BusinessDataSet, False);
  end;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoCstmrTSFBusinessDataFieldChange(
  Sender: TObject; Field: TField);
begin
  if (Field.FieldName = 'bdscstmrtypeid') and (Field.AsInteger = 1) then
  begin
    if not(DsWFrmBDSDemoOrder.BusinessDataSet.IsEmpty) then
    begin
      if (MessageDlg('Suppliers cannot have orders. Do you want change Type and delete all orders?', mtConfirmation, [mbNo, mbYes], 0) = mrYes) then
      begin
        // suppliers cannot own some orders -> delete
        if (DsWFrmBDSDemoOrder.BusinessDataSet.State in [dsEdit, dsInsert]) then
          DsWFrmBDSDemoOrder.BusinessDataSet.Cancel;

        DsWFrmBDSDemoOrder.BusinessDataSet.First;
        while not(DsWFrmBDSDemoOrder.BusinessDataSet.Eof) do
          DsWFrmBDSDemoOrder.BusinessDataSet.Delete;
      end else
        Field.Value := Field.OldValue;
    end;
  end;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoCstmrTSFBusinessDataRecordChange(
  DataSet: TDataSet);
begin
  loadImageFromData;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoOrderTSFBusinessDataAfterInsert(
  DataSet: TDataSet);
begin
  // when insert a order, set the customerid
  bdscstmrorder(DsWFrmBDSDemoOrder.BusinessDataSet).bdscstmrordercstmrid :=
    bdscstmr(DsWFrmBDSDemoCstmr.BusinessDataSet).bdscstmrid;
end;

procedure TFrmBDSDemo.DsWFrmBDSDemoOrderTSFBusinessDataBeforeInsert(
  DataSet: TDataSet);
begin
  // - when no customer exists or customer is a supplier, fire a error
  if not(DsWFrmBDSDemoCstmr.BusinessDataSet.Active) or (DsWFrmBDSDemoCstmr.BusinessDataSet.IsEmpty)
  or (bdscstmr(DsWFrmBDSDemoCstmr.BusinessDataSet).bdscstmrtypeid <> 2) then
  begin
    raise Exception.Create('Cannot create a order without customer');
  end;
end;

function TFrmBDSDemo.DsWFrmBDSDemoOrderTSFBusinessDataCompareRecords(CompareRecordFrom,
                CompareRecordTo: TSFBDSCompareRecord): TSFBDSRecordCompareResult;
  var lDesc: Boolean;
      lFldName: String;
begin
  // compare given records (called by sorting buffer)
  lDesc := (DsWFrmBDSDemoOrder.BusinessDataSet.Tag < 0);
  lFldName := DBGrid1.Columns.Items[Abs(DsWFrmBDSDemoOrder.BusinessDataSet.Tag) - 1].FieldName;

  if not(lDesc) then
  begin
    if (CompareRecordFrom.GetFieldValByName(lFldName) > CompareRecordTo.GetFieldValByName(lFldName)) then
      Result := compareResultGreater
    else if (CompareRecordFrom.GetFieldValByName(lFldName) < CompareRecordTo.GetFieldValByName(lFldName)) then
      Result := compareResultLess
    else
      Result := compareResultEqual;
  end else
  begin
    if (CompareRecordFrom.GetFieldValByName(lFldName) > CompareRecordTo.GetFieldValByName(lFldName)) then
      Result := compareResultLess
    else if (CompareRecordFrom.GetFieldValByName(lFldName) < CompareRecordTo.GetFieldValByName(lFldName)) then
      Result := compareResultGreater
    else
      Result := compareResultEqual;
  end;
end;

procedure TFrmBDSDemo.loadImageFromData;
  var lGraphCls: TGraphicClass;
      lGraph: TGraphic;
      lImgStream: TMemoryStream;
begin
  Image1.Picture.Assign(nil);

  if ((DsWFrmBDSDemoCstmr.BusinessDataSet.State in [dsEdit, dsInsert])
    or not(DsWFrmBDSDemoCstmr.BusinessDataSet.IsEmpty))
    and (TBlobField(DsWFrmBDSDemoCstmr.BusinessDataSet.FieldByName('bdscstmrimage')).BlobSize > 0) then
  begin
    lGraphCls := graphicClsByExt(bdscstmr(DsWFrmBDSDemoCstmr.BusinessDataSet).bdscstmrimageext);
    lGraph := lGraphCls.Create;
    lImgStream := TMemoryStream.Create;
    try
      TBlobField(DsWFrmBDSDemoCstmr.BusinessDataSet.FieldByName('bdscstmrimage')).SaveToStream(lImgStream);
      lImgStream.Position := 0;
      lGraph.LoadFromStream(lImgStream);
      Image1.Picture.Graphic := lGraph;
    finally
      FreeAndNil(lImgStream);
      FreeAndNil(lGraph);
    end;

    Label13.Visible := False;
  end else
    Label13.Visible := True;
end;

function TFrmBDSDemo.graphicClsByExt(pExt: String): TGraphicClass;
begin
  Result := TBitmap;

  if (CompareText('.wmf', pExt) = 0) then
    Result := TMetafile
  else if (CompareText('.emf', pExt) = 0) then
    Result := TMetafile
  else if (CompareText('.ico', pExt) = 0) then
    Result := TIcon
  else if (CompareText('.tiff', pExt) = 0) then
    Result := TWICImage
  else if (CompareText('.tif', pExt) = 0) then
    Result := TWICImage
  else if (CompareText('.png', pExt) = 0) then
    Result := TPngImage
  else if (CompareText('.gif', pExt) = 0) then
    Result := TGifImage
  else if (CompareText('.jpeg', pExt) = 0) then
    Result := TJPEGImage
  else if (CompareText('.jpg', pExt) = 0) then
    Result := TJPEGImage;
end;

end.
