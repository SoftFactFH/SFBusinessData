//
//   Title:         SFBusinessData
//
//   Description:   form to manage queries for the query builder with delphi designer
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit UFrmSFStatementDefine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, System.Generics.Collections,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask, Data.DB, SFBusinessData, SFStatements, SFStatementsXML,
  Xml.XMLIntf, Vcl.Menus, SFStatementType;

type
  TFrmSFStatementDefine = class(TForm)
    pcFrmSFStatementDefineBase: TPageControl;
    tsFrmStatementDefineGeneral: TTabSheet;
    tsFrmStatementDefineTable: TTabSheet;
    tsFrmStatementDefineAttribute: TTabSheet;
    tsFrmStatementDefineCondition: TTabSheet;
    tsFrmStatementDefineOrder: TTabSheet;
    tsFrmStatementDefineGroup: TTabSheet;
    grpFrmStatementDefineTableStructure: TGroupBox;
    grpFrmStatementDefineTableDetail: TGroupBox;
    tvFrmStatementDefineTableStructure: TTreeView;
    lblFrmStatementDefineTableDetailName: TLabel;
    lblFrmStatementDefineTableDetailSchema: TLabel;
    lblFrmStatementDefineTableDetailCatalog: TLabel;
    lblFrmStatementDefineTableDetailJoinType: TLabel;
    grdFrmStatementDefineTableDetailJoinItems: TDBGrid;
    txtFrmStatementDefineTableDetailName: TDBEdit;
    txtFrmStatementDefineTableDetailSchema: TDBEdit;
    txtFrmStatementDefineTableDetailCatalog: TDBEdit;
    cboFrmStatementDefineTableDetailJoinType: TDBLookupComboBox;
    lblFrmStatementDefineGeneralDialect: TLabel;
    lblFrmStatementDefineGeneralQuotes: TLabel;
    lblFrmStatementDefineGeneralLikeEscape: TLabel;
    cboFrmStatementDefineGeneralDialect: TDBLookupComboBox;
    cboFrmStatementDefineGeneralQuotes: TDBLookupComboBox;
    txtFrmStatementDefineGeneralLikeEscape: TDBEdit;
    chkFrmStatementDefineGeneralAutoEscape: TDBCheckBox;
    lblFrmStatementDefineGeneralDistinct: TDBCheckBox;
    lblFrmStatementDefineGeneralNote: TLabel;
    grdFrmStatementDefineAttributes: TDBGrid;
    grpFrmStatementDefineAttrDetail: TGroupBox;
    grdFrmStatementDefineAttrDetail: TDBGrid;
    tsFrmStatementDefineTest: TTabSheet;
    grdFrmStatementDefineConditions: TDBGrid;
    grpFrmStatementDefineConditionsExists: TGroupBox;
    grdFrmStatementDefineConditionsExists: TDBGrid;
    grdFrmStatementDefineOrder: TDBGrid;
    grdFrmStatementDefineGroup: TDBGrid;
    lblFrmStatementDefineGeneralUnion: TLabel;
    memFrmStatementDefineTest: TMemo;
    srcFrmStatementDefineStmt: TDataSource;
    srcFrmStatementDefineTables: TDataSource;
    srcFrmStatementDefineTableJoinDef: TDataSource;
    srcFrmStatementDefineAttributes: TDataSource;
    srcFrmStatementDefineAttributeItems: TDataSource;
    srcFrmStatementDefineConditions: TDataSource;
    srcFrmStatementDefineConditionExists: TDataSource;
    srcFrmStatementDefineAttributesOrder: TDataSource;
    srcFrmStatementDefineAttributesGroup: TDataSource;
    chkFrmStatementDefineTableDetailIsStmt: TDBCheckBox;
    srcFrmStatementDefineLkpDialect: TDataSource;
    srcFrmStatementDefineLkpQuotes: TDataSource;
    srcFrmStatementDefineLkpJoinType: TDataSource;
    pmFrmStatementDefineTableTree: TPopupMenu;
    pmFrmStatementDefineTableTreeAdd: TMenuItem;
    pmFrmStatementDefineTableTreeDelete: TMenuItem;
    pmFrmStatementDefineData: TPopupMenu;
    pmFrmStatementDefineDataAdd: TMenuItem;
    pmFrmStatementDefineDataDelete: TMenuItem;
    pmFrmStatementDefineDataCancel: TMenuItem;
    pmFrmStatementDefineDataPost: TMenuItem;
    pmFrmStatementDefineDataUp: TMenuItem;
    pmFrmStatementDefineDataDown: TMenuItem;
    cboFrmStatementDefineGeneralUnion: TDBComboBox;
    cboFrmStatementDefineTableDetailStmt: TDBComboBox;
    lblFrmStatementDefineConditionsInfo: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvFrmStatementDefineTableStructureChange(Sender: TObject;
      Node: TTreeNode);
    procedure pmFrmStatementDefineTableTreePopup(Sender: TObject);
    procedure pmFrmStatementDefineTableTreeAddClick(Sender: TObject);
    procedure pmFrmStatementDefineTableTreeDeleteClick(Sender: TObject);
    procedure grdFrmStatementDefineDataExit(Sender: TObject);
    procedure pmFrmStatementDefineDataPopup(Sender: TObject);
    procedure pmFrmStatementDefineDataAddClick(Sender: TObject);
    procedure pmFrmStatementDefineDataDeleteClick(Sender: TObject);
    procedure pmFrmStatementDefineDataCancelClick(Sender: TObject);
    procedure pmFrmStatementDefineDataPostClick(Sender: TObject);
    procedure pmFrmStatementDefineDataUpClick(Sender: TObject);
    procedure pmFrmStatementDefineDataDownClick(Sender: TObject);
    procedure pcFrmSFStatementDefineBaseChange(Sender: TObject);
    procedure chkFrmStatementDefineTableDetailIsStmtClick(Sender: TObject);
    procedure ctrlFrmStatementDefineTableDetailExit(Sender: TObject);
  private
    mStmt: TSFStmt;
    mStmtRefLst: TStrings;
    mTableLkpFieldsNotify: TList;
    mAttrLkpFieldsNotify: TList;
    mStmtLkpFieldsNotify: TList;
    mLastTableNo: Integer;
    mLastAttrId: Integer;
    mLastCondId: Integer;
    mCanModifyBaseTable: Boolean;
    mObjStmt: TSFBusinessData;
    mObjStmtTable: TSFBusinessData;
    mObjStmtTableRel: TSFBusinessData;
    mObjStmtAttr: TSFBusinessData;
    mObjStmtAttrItem: TSFBusinessData;
    mObjStmtCond: TSFBusinessData;
    mObjStmtCondExists: TSFBusinessData;
    mObjStmtOrder: TSFBusinessData;
    mObjStmtGroup: TSFBusinessData;
    // lookups
    mObjQuoteTypeLkp: TSFBusinessData;
    mObjDialectLkp: TSFBusinessData;
    mObjStmtRefLkpCached: TSFBusinessData;
    mObjJoinTypeLkp: TSFBusinessData;
    mObjRelItemTypeLkp: TSFBusinessData;
    mObjValueDataTypeLkp: TSFBusinessData;
    mObjAttrItemTypeLkp: TSFBusinessData;
    mObjAggregateLkp: TSFBusinessData;
    mObjCondTypeLkp: TSFBusinessData;
    mObjCondOpLkp: TSFBusinessData;
    mObjOrderTypeLkp: TSFBusinessData;
    mObjAttributesLkp: TSFBusinessData;
    mObjTablesLkp: TSFBusinessData;
  private
    // setter/getter for properties
    procedure setStmt(pStmt: TSFStmt);
    procedure setStmtRefLst(pLst: TStrings);
    procedure setCanModifyBaseTable(pCanModify: Boolean);
    // setter/getter for internal dataobjects
    function getObjStmt: TSFBusinessData;
    function getObjStmtTable: TSFBusinessData;
    function getObjStmtTableRel: TSFBusinessData;
    function getObjStmtAttr: TSFBusinessData;
    function getObjStmtAttrItem: TSFBusinessData;
    function getObjStmtCond: TSFBusinessData;
    function getObjStmtCondExists: TSFBusinessData;
    function getObjStmtOrder: TSFBusinessData;
    function getObjStmtGroup: TSFBusinessData;
    // setter/getter for lookupobjects
    function getObjQuoteTypeLkp: TSFBusinessData;
    function getObjDialectLkp: TSFBusinessData;
    function getObjStmtRefLkpCached: TSFBusinessData;
    function getObjJoinTypeLkp: TSFBusinessData;
    function getObjRelItemTypeLkp: TSFBusinessData;
    function getObjValueDataTypeLkp: TSFBusinessData;
    function getObjAttrItemTypeLkp: TSFBusinessData;
    function getObjAggregateLkp: TSFBusinessData;
    function getObjCondTypeLkp: TSFBusinessData;
    function getObjCondOpLkp: TSFBusinessData;
    function getObjOrderTypeLkp: TSFBusinessData;
    function getObjAttributesLkp: TSFBusinessData;
    function getObjTablesLkp: TSFBusinessData;
  private
    // private functions
    procedure reOpenDataObjects;
    procedure reOpenDataObject(pObj: TSFBusinessData);
    procedure loadObjects(pXmlStmt: TSFStmtXML);
    procedure loadTableXML(pTable: TSFStmtTableXML; pParentRelation: TSFStmtTableRelationXML = nil;
                            pParentTableNo: Integer = 0);
    procedure loadAttributesXML(pAttrs: TSFStmtAttrsXML);
    procedure loadConditionsXML(pConds: TSFStmtCondsXML);
    procedure loadOrderAndGroupXML(pOrder: TSFStmtOrdersXML; pGroup: TSFStmtGroupsXML);
    function tableNoByAlias(pAlias: String): Integer;
    function tableAliasByNo(pTableNo: Integer): String;
    function detectAttrDesc: String;
    procedure clearTableTreeView;
    procedure loadTableTreeView(pParentNode: TTreeNode = nil; pParentNo: Integer = 0);
    function generateTableTreeDesc: String;
    function searchMaxTableNo: Integer;
    function searchMaxAttrId: Integer;
    function searchMaxCondId: Integer;
    function checkValueTypeForVal(pVal: String; pValType: Integer; pIsArray: Boolean): Boolean;
    function listGlobalStmtNames: TStringList;
    procedure listComponentStmtNames(pComponent: TComponent; pLst: TStringList; pNamePath: String);
    procedure configStmtRefLkpObj(pLkpObj: TSFBusinessData; pNotifyLkpFlds: Boolean);
    procedure syncTablesLkp(pRefreshCurrent: Boolean = False);
    procedure syncAttributesLkp(pRefreshCurrent: Boolean = False);
    procedure createLkpField(pObj: TSFBusinessData; pFieldName: String; pFldType: TFieldType;
                                pLkpDs: TDataSet; pKeyFlds, pLkpKeyFlds, pLkpRsltFld: String;
                                pCached: Boolean; pSize, pPrecision: Integer);
    procedure adjustAutoEditSources;
    procedure checkDataGridsReadOnly;
    procedure checkDataGridReadOnly(pGrd: TDBGrid);
    procedure createGridInplace(pGrd: TDBGrid; pFieldName: String; pParent: TWinControl);
    procedure fillCboStmtNames(pCbo: TDBComboBox);
    procedure checkControlsForTable;
    procedure validateConditions;
    procedure handlePostError;
    procedure deleteTableByTreeNode(pTreeNode: TTreeNode);
    function exportToXmlDoc: IXmlDocument;
    function exportToXmlStr: String;
    procedure exportTablesXML(pXmlStmt: TSFStmtXML);
    procedure exportTableXML(pXmlTable: TSFStmtTableXML; pXmlRelation: TSFStmtTableRelationXML);
    procedure exportAttrsXML(pXmlStmt: TSFStmtXML);
    procedure exportCondsXML(pXmlStmt: TSFStmtXML);
    procedure exportOrdersAndGroupsXML(pXmlStmt: TSFStmtXML);
    // event handler
    procedure objStmtTableAfterScroll(pDataSet: TDataSet);
    procedure objStmtTableBeforeDelete(pDataSet: TDataSet);
    procedure objStmtTableAfterPost(pDataSet: TDataSet);
    procedure objStmtTableFieldChanged(pSender: TObject; pField: TField);
    procedure objStmtTableRelFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
    procedure objStmtTableRelFieldChanged(pSender: TObject; pField: TField);
    procedure objStmtTableRelRecChanged(pDataSet: TDataSet);
    procedure objStmtTableRelAfterInsert(pDataSet: TDataSet);
    procedure objStmtTableRelBeforePost(pDataSet: TDataSet);
    procedure objStmtAttrAfterScroll(pDataSet: TDataSet);
    procedure objStmtAttrBeforeDelete(pDataSet: TDataSet);
    procedure objStmtAttrAfterInsert(pDataSet: TDataSet);
    procedure objStmtAttrBeforePost(pDataSet: TDataSet);
    procedure objStmtAttrAfterPost(pDataSet: TDataSet);
    procedure objStmtAttrItemFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
    procedure objStmtAttrItemFieldChanged(pSender: TObject; pField: TField);
    procedure objStmtAttrItemRecChanged(pDataSet: TDataSet);
    procedure objStmtAttrItemAfterInsert(pDataSet: TDataSet);
    procedure objStmtAttrItemBeforePost(pDataSet: TDataSet);
    procedure objStmtAttrItemAfterPost(pDataSet: TDataSet);
    procedure objStmtCondAfterScroll(pDataSet: TDataSet);
    procedure objStmtCondBeforeDelete(pDataSet: TDataSet);
    procedure objStmtCondFieldChanged(pSender: TObject; pField: TField);
    procedure objStmtCondRecChanged(pDataSet: TDataSet);
    procedure objStmtCondAfterInsert(pDataSet: TDataSet);
    procedure objStmtCondBeforePost(pDataSet: TDataSet);
    procedure objStmtCondExistsFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
    procedure objStmtCondExistsFieldChanged(pSender: TObject; pField: TField);
    procedure objStmtCondExistsRecChanged(pDataSet: TDataSet);
    procedure objStmtCondExistsAfterInsert(pDataSet: TDataSet);
    procedure objStmtCondExistsBeforePost(pDataSet: TDataSet);
    procedure objStmtOrderAfterInsert(pDataSet: TDataSet);
    procedure objStmtOrderBeforePost(pDataSet: TDataSet);
  private
    property objStmt: TSFBusinessData read getObjStmt;
    property objStmtTable: TSFBusinessData read getObjStmtTable;
    property objStmtTableRel: TSFBusinessData read getObjStmtTableRel;
    property objStmtAttr: TSFBusinessData read getObjStmtAttr;
    property objStmtAttrItem: TSFBusinessData read getObjStmtAttrItem;
    property objStmtCond: TSFBusinessData read getObjStmtCond;
    property objStmtCondExists: TSFBusinessData read getObjStmtCondExists;
    property objStmtOrder: TSFBusinessData read getObjStmtOrder;
    property objStmtGroup: TSFBusinessData read getObjStmtGroup;
    property objQuoteTypeLkp: TSFBusinessData read getObjQuoteTypeLkp;
    property objDialectLkp: TSFBusinessData read getObjDialectLkp;
    property objStmtRefLkpCached: TSFBusinessData read getObjStmtRefLkpCached;
    property objJoinTypeLkp: TSFBusinessData read getObjJoinTypeLkp;
    property objRelItemTypeLkp: TSFBusinessData read getObjRelItemTypeLkp;
    property objValueDataTypeLkp: TSFBusinessData read getObjValueDataTypeLkp;
    property objAttrItemTypeLkp: TSFBusinessData read getObjAttrItemTypeLkp;
    property objAggregateLkp: TSFBusinessData read getObjAggregateLkp;
    property objCondTypeLkp: TSFBusinessData read getObjCondTypeLkp;
    property objCondOpLkp: TSFBusinessData read getObjCondOpLkp;
    property objOrderTypeLkp: TSFBusinessData read getObjOrderTypeLkp;
    property objAttributesLkp: TSFBusinessData read getObjAttributesLkp;
    property objTablesLkp: TSFBusinessData read getObjTablesLkp;
  public
    property Stmt: TSFStmt read mStmt write setStmt;
    property StmtRefLst: TStrings read mStmtRefLst write setStmtRefLst;
    property CanModfiyBaseTable: Boolean read mCanModifyBaseTable write setCanModifyBaseTable;
    property XmlDefinition: String read exportToXmlStr;
  end;

  TFrmSFStatementDefInplaceChk = class(TDBCheckBox)
  private
    mDBGrid: TDBGrid;
    mColumnIdx: Integer;
    mGrdDrawColCellSave: TDrawColumnCellEvent;
  private
    procedure setDBGrid(pVal: TDBGrid);
    procedure setColumnIdx(pVal: Integer);
  private
    procedure grdDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
                                  Column: TColumn; State: TGridDrawState);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoExit; override;
  public
    constructor Create(pOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DBGrid: TDBGrid read mDBGrid write setDBGrid;
    property ColIdx: Integer read mColumnIdx write setColumnIdx;
  end;

var
  FrmSFStatementDefine: TFrmSFStatementDefine;

implementation

{$R *.dfm}

procedure TFrmSFStatementDefine.FormCreate(Sender: TObject);
begin
  mObjStmt := nil;
  mObjStmtTable := nil;
  mObjStmtTableRel := nil;
  mObjStmtAttr := nil;
  mObjStmtAttrItem := nil;
  mObjStmtCond := nil;
  mObjStmtCondExists := nil;
  mObjStmtOrder := nil;
  mObjStmtGroup := nil;

  mObjQuoteTypeLkp := nil;
  mObjDialectLkp := nil;
  mObjStmtRefLkpCached := nil;
  mObjJoinTypeLkp := nil;
  mObjRelItemTypeLkp := nil;
  mObjValueDataTypeLkp := nil;
  mObjAttrItemTypeLkp := nil;
  mObjAggregateLkp := nil;
  mObjCondTypeLkp := nil;
  mObjCondOpLkp := nil;
  mObjOrderTypeLkp := nil;
  mObjAttributesLkp := nil;
  mObjTablesLkp := nil;

  mStmt := nil;
  mStmtRefLst := nil;

  mTableLkpFieldsNotify := TList.Create;
  mAttrLkpFieldsNotify := TList.Create;
  mStmtLkpFieldsNotify := TList.Create;

  mLastTableNo := 0;
  mLastAttrId := 0;
  mLastCondId := 0;

  mCanModifyBaseTable := True;

  srcFrmStatementDefineLkpDialect.DataSet := objDialectLkp;
  srcFrmStatementDefineLkpQuotes.DataSet := objQuoteTypeLkp;
  srcFrmStatementDefineLkpJoinType.DataSet := objJoinTypeLkp;

  fillCboStmtNames(cboFrmStatementDefineGeneralUnion);
  fillCboStmtNames(cboFrmStatementDefineTableDetailStmt);

  srcFrmStatementDefineStmt.DataSet := objStmt;
  srcFrmStatementDefineTables.DataSet := objStmtTable;
  srcFrmStatementDefineTableJoinDef.DataSet := objStmtTableRel;
  srcFrmStatementDefineAttributes.DataSet := objStmtAttr;
  srcFrmStatementDefineAttributeItems.DataSet := objStmtAttrItem;
  srcFrmStatementDefineConditions.DataSet := objStmtCond;
  srcFrmStatementDefineConditionExists.DataSet := objStmtCondExists;
  srcFrmStatementDefineAttributesOrder.DataSet := objStmtOrder;
  srcFrmStatementDefineAttributesGroup.DataSet := objStmtGroup;

  createGridInplace(grdFrmStatementDefineAttributes, 'OnlyForSearch', tsFrmStatementDefineAttribute);
  createGridInplace(grdFrmStatementDefineConditions, 'DestValueIsArray', tsFrmStatementDefineCondition);
  createGridInplace(grdFrmStatementDefineConditions, 'IsRestriction', tsFrmStatementDefineCondition);
end;

procedure TFrmSFStatementDefine.FormDestroy(Sender: TObject);
begin
  mTableLkpFieldsNotify.Clear;
  FreeAndNil(mTableLkpFieldsNotify);

  mAttrLkpFieldsNotify.Clear;
  FreeAndNil(mAttrLkpFieldsNotify);

  mStmtLkpFieldsNotify.Clear;
  FreeAndNil(mStmtLkpFieldsNotify);

  if (Assigned(mObjStmt)) then
    FreeAndNil(mObjStmt);
  if (Assigned(mObjStmtTable)) then
    FreeAndNil(mObjStmtTable);
  if (Assigned(mObjStmtTableRel)) then
    FreeAndNil(mObjStmtTableRel);
  if (Assigned(mObjStmtAttr)) then
    FreeAndNil(mObjStmtAttr);
  if (Assigned(mObjStmtAttrItem)) then
    FreeAndNil(mObjStmtAttrItem);
  if (Assigned(mObjStmtCond)) then
    FreeAndNil(mObjStmtCond);
  if (Assigned(mObjStmtCondExists)) then
    FreeAndNil(mObjStmtCondExists);
  if (Assigned(mObjStmtOrder)) then
    FreeAndNil(mObjStmtOrder);
  if (Assigned(mObjStmtGroup)) then
    FreeAndNil(mObjStmtGroup);
  if (Assigned(mObjQuoteTypeLkp)) then
    FreeAndNil(mObjQuoteTypeLkp);
  if (Assigned(mObjDialectLkp)) then
    FreeAndNil(mObjDialectLkp);
  if (Assigned(mObjStmtRefLkpCached)) then
    FreeAndNil(mObjStmtRefLkpCached);
  if (Assigned(mObjJoinTypeLkp)) then
    FreeAndNil(mObjJoinTypeLkp);
  if (Assigned(mObjRelItemTypeLkp)) then
    FreeAndNil(mObjRelItemTypeLkp);
  if (Assigned(mObjValueDataTypeLkp)) then
    FreeAndNil(mObjValueDataTypeLkp);
  if (Assigned(mObjAttrItemTypeLkp)) then
    FreeAndNil(mObjAttrItemTypeLkp);
  if (Assigned(mObjAggregateLkp)) then
    FreeAndNil(mObjAggregateLkp);
  if (Assigned(mObjCondTypeLkp)) then
    FreeAndNil(mObjCondTypeLkp);
  if (Assigned(mObjCondOpLkp)) then
    FreeAndNil(mObjCondOpLkp);
  if (Assigned(mObjOrderTypeLkp)) then
    FreeAndNil(mObjOrderTypeLkp);
  if (Assigned(mObjAttributesLkp)) then
    FreeAndNil(mObjAttributesLkp);
  if (Assigned(mObjTablesLkp)) then
    FreeAndNil(mObjTablesLkp);
end;

procedure TFrmSFStatementDefine.tvFrmStatementDefineTableStructureChange(
  Sender: TObject; Node: TTreeNode);
begin
  if (Node <> nil) and not(objStmtTable.IsEmpty) then
    objStmtTable.Locate('TableNo', Integer(Node.Data), []);
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineTableTreePopup(
  Sender: TObject);
begin
  // check buttons can be enabled
  pmFrmStatementDefineTableTreeAdd.Enabled := (tvFrmStatementDefineTableStructure.Items.Count = 0) and (mCanModifyBaseTable) or (tvFrmStatementDefineTableStructure.Selected <> nil);
  pmFrmStatementDefineTableTreeDelete.Enabled := (tvFrmStatementDefineTableStructure.Items.Count > 0) or (tvFrmStatementDefineTableStructure.Selected <> nil);
  if (pmFrmStatementDefineTableTreeDelete.Enabled) and (tvFrmStatementDefineTableStructure.Selected.IsFirstNode) then
    pmFrmStatementDefineTableTreeDelete.Enabled := mCanModifyBaseTable;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineTableTreeAddClick(
  Sender: TObject);
  var lNewTableNo, lParentTableNo: Integer;
      lNewNode: TTreeNode;
begin
  // add a new table
  lNewTableNo := mLastTableNo + 1;
  lParentTableNo := 0;
  if (tvFrmStatementDefineTableStructure.Selected <> nil) then
    lParentTableNo := Integer(tvFrmStatementDefineTableStructure.Selected.Data);

  objStmtTable.DisableControls;
  try
    objStmtTable.Append;
    objStmtTable.FieldByName('TableNo').AsInteger := lNewTableNo;
    objStmtTable.FieldByName('TableAlias').AsString := 't' + IntToStr(lNewTableNo);
    objStmtTable.FieldByName('StmtName').AsString := '';
    objStmtTable.FieldByName('TableIsStmt').AsInteger := 0;
    objStmtTable.FieldByName('TableName').AsString := '';
    objStmtTable.FieldByName('Schema').AsString := '';
    objStmtTable.FieldByName('Catalog').AsString := '';
    objStmtTable.FieldByName('ParentTableNo').AsInteger := lParentTableNo;
    objStmtTable.FieldByName('ParentTableJoinType').AsInteger := Integer(stmtJoinTypeNone);
    if (lParentTableNo > 0) then
      objStmtTable.FieldByName('ParentTableJoinType').AsInteger := Integer(stmtJoinTypeInner);
    objStmtTable.Post;
    syncTablesLkp(True);
  finally
    objStmtTable.EnableControls;
  end;

  if (tvFrmStatementDefineTableStructure.Selected <> nil) then
    lNewNode := tvFrmStatementDefineTableStructure.Items.AddChild(tvFrmStatementDefineTableStructure.Selected, generateTableTreeDesc)
  else
    lNewNode := tvFrmStatementDefineTableStructure.Items.Add(nil, generateTableTreeDesc);

  mLastTableNo := lNewTableNo;
  lNewNode.Data := Pointer(lNewTableNo);
  lNewNode.Selected := True;
end;


procedure TFrmSFStatementDefine.pmFrmStatementDefineTableTreeDeleteClick(
  Sender: TObject);
  var lNextSelNode: TTreeNode;
begin
  // delete table
  if (tvFrmStatementDefineTableStructure.Selected = nil) then
    Exit;

  objStmtTable.DisableControls;
  try
    deleteTableByTreeNode(tvFrmStatementDefineTableStructure.Selected);
    adjustAutoEditSources;
  finally
    objStmtTable.EnableControls;
  end;

  lNextSelNode := tvFrmStatementDefineTableStructure.Selected.getPrevSibling;
  if (lNextSelNode = nil) then
    lNextSelNode := tvFrmStatementDefineTableStructure.Selected.getNextSibling;

  tvFrmStatementDefineTableStructure.Selected.Delete;
  if (lNextSelNode <> nil) then
    lNextSelNode.Selected := True;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataPopup(Sender: TObject);
  var lCurrData: TSFBusinessData;
begin
  pmFrmStatementDefineDataAdd.Enabled := False;
  pmFrmStatementDefineDataDelete.Enabled := False;
  pmFrmStatementDefineDataCancel.Enabled := False;
  pmFrmStatementDefineDataPost.Enabled := False;
  pmFrmStatementDefineDataUp.Enabled := False;
  pmFrmStatementDefineDataDown.Enabled := False;

  if (pmFrmStatementDefineData.PopupComponent is TDBGrid) and
    (TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource <> nil) and
    (TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet <> nil) and
    (TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet is TSFBusinessData) then
  begin
    lCurrData := TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet);
    pmFrmStatementDefineDataAdd.Enabled := TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.AutoEdit
                                            and (lCurrData.State = dsBrowse);
    pmFrmStatementDefineDataDelete.Enabled := pmFrmStatementDefineDataAdd.Enabled and (lCurrData.RecNo > 0);
    pmFrmStatementDefineDataCancel.Enabled := (lCurrData.State in [dsEdit, dsInsert]);
    pmFrmStatementDefineDataPost.Enabled := pmFrmStatementDefineDataCancel.Enabled;
    pmFrmStatementDefineDataUp.Enabled := pmFrmStatementDefineDataDelete.Enabled and (lCurrData.RecNo > 1);
    pmFrmStatementDefineDataDown.Enabled := pmFrmStatementDefineDataDelete.Enabled and (lCurrData.RecNo < lCurrData.RecordCount);
  end;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataAddClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).Append;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataDeleteClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).Delete;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataCancelClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).Cancel;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataPostClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).Post;
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataUpClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).ExchangeRecordPositions(
    TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet.RecNo,
    TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet.RecNo - 1);
end;

procedure TFrmSFStatementDefine.pmFrmStatementDefineDataDownClick(
  Sender: TObject);
begin
  TSFBusinessData(TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet).ExchangeRecordPositions(
    TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet.RecNo,
    TDBGrid(pmFrmStatementDefineData.PopupComponent).DataSource.DataSet.RecNo + 1);
end;

procedure TFrmSFStatementDefine.grdFrmStatementDefineDataExit(
  Sender: TObject);
begin
  if (Sender is TDBGrid) and
    (TDBGrid(Sender).DataSource <> nil) and
    (TDBGrid(Sender).DataSource.DataSet <> nil) and
    (TDBGrid(Sender).DataSource.DataSet is TDataSet) then
  begin
    TDBGrid(Sender).DataSource.DataSet.CheckBrowseMode;
  end;
end;

procedure TFrmSFStatementDefine.pcFrmSFStatementDefineBaseChange(Sender: TObject);
  var lStmtTemp: TSFStmt;
      lXmlDoc: IXMLDocument;
begin
  if (pcFrmSFStatementDefineBase.ActivePage = tsFrmStatementDefineTest) then
  begin
    lStmtTemp := TSFStmt.Create(nil);
    try
      lXmlDoc := exportToXmlDoc;
      try
        lStmtTemp.LoadFromXmlDoc(lXmlDoc);
        memFrmStatementDefineTest.Text := lStmtTemp.GetSelectStmt;
      finally
        lXmlDoc := nil;
      end;
    finally
      FreeAndNil(lStmtTemp);
    end;
  end;
end;

procedure TFrmSFStatementDefine.chkFrmStatementDefineTableDetailIsStmtClick(
  Sender: TObject);
begin
  cboFrmStatementDefineTableDetailStmt.Visible := chkFrmStatementDefineTableDetailIsStmt.Checked;
  txtFrmStatementDefineTableDetailName.Visible := not(cboFrmStatementDefineTableDetailStmt.Visible);
end;

procedure TFrmSFStatementDefine.ctrlFrmStatementDefineTableDetailExit(
  Sender: TObject);
begin
  objStmtTable.CheckBrowseMode;
end;

//============================================================================//
//                        private event handler                               //
//============================================================================//

procedure TFrmSFStatementDefine.objStmtTableAfterScroll(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtTable) then
  begin
    if not(objStmtTable.SyncDisabled) then
    begin
      if (objStmtTableRel.Filtered) then
        objStmtTableRel.Refilter
      else
        objStmtTableRel.Filtered := True;
    end;

    if not(objStmtTable.ControlsDisabled) then
    begin
      checkControlsForTable;

      adjustAutoEditSources;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableBeforeDelete(pDataSet: TDataSet);
  var lDelAttr: Boolean;
      lCondNeedValidate: Boolean;
begin
  if (pDataSet = objStmtTable) then
  begin
    // delete related joins
    if not(objStmtTableRel.IsEmpty) then
    begin
      objStmtTableRel.DisableControls;
      try
        objStmtTableRel.First;
        while not(objStmtTableRel.Eof) do
        begin
          if (objStmtTable.FieldByName('TableNo').AsInteger = objStmtTableRel.FieldByName('TableNoTo').AsInteger) and
            (objStmtTable.FieldByName('ParentTableNo').AsInteger = objStmtTableRel.FieldByName('TableNoFrom').AsInteger) then
          begin
            objStmtTableRel.Delete;
          end else
            objStmtTableRel.Next;
        end;
        if not(objStmtTableRel.IsEmpty) then
          objStmtTableRel.First;
      finally
        objStmtTableRel.EnableControls;
      end;
    end;

    // delete related attributes
    if not(objStmtAttr.IsEmpty) then
    begin
      objStmtAttr.DisableControls;
      objStmtAttrItem.DisableControls;
      try
        objStmtAttr.First;
        while not(objStmtAttr.Eof) do
        begin
          lDelAttr := False;
          if not(objStmtAttrItem.IsEmpty) then
          begin
            objStmtAttrItem.First;
            while not(objStmtAttrItem.Eof) do
            begin
              if (objStmtAttrItem.FieldByName('AttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger) then
              begin
                if (objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger > 0) and
                  (objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger = objStmtTable.FieldByName('TableNo').AsInteger) then
                begin
                  lDelAttr := True;
                  Break;
                end;
              end;
              objStmtAttrItem.Next;
            end;
          end;

          if (lDelAttr) then
            objStmtAttr.Delete
          else
            objStmtAttr.Next;
        end;
        if not(objStmtAttr.IsEmpty) then
          objStmtAttr.First;
      finally
        objStmtAttr.EnableControls;
        objStmtAttrItem.EnableControls;
      end;
    end;

    // delete related exists-conditions
    if not(objStmtCond.IsEmpty) then
    begin
      objStmtCond.DisableControls;
      objStmtCondExists.DisableControls;
      try
        lCondNeedValidate := False;
        objStmtCond.First;
        while not(objStmtCond.Eof) do
        begin
          if (objStmtTable.FieldByName('TableNo').AsInteger = objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger) then
          begin
            lCondNeedValidate := True;
            objStmtCond.Delete;
          end else
            objStmtCond.Next;
        end;
        if (lCondNeedValidate) then
          validateConditions;
        if not(objStmtCond.IsEmpty) then
          objStmtCond.First;
      finally
        objStmtCond.EnableControls;
        objStmtCondExists.EnableControls;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableAfterPost(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtTable) and not(objStmtTable.ControlsDisabled) then
    syncTablesLkp(True);
end;

procedure TFrmSFStatementDefine.objStmtTableFieldChanged(pSender: TObject; pField: TField);
begin
  if (pSender = objStmtTable) and (objStmtTable.State in [dsInsert, dsEdit]) and
    not(objStmtTable.ControlsDisabled) and (pField <> nil) then
  begin
    if (pField.FieldName = 'TableIsStmt') then
    begin
      if (Boolean(objStmtTable.FieldByName('TableIsStmt').AsInteger)) then
      begin
        objStmtTable.FieldByName('TableName').AsString := '';
        objStmtTable.FieldByName('Schema').AsString := '';
        objStmtTable.FieldByName('Catalog').AsString := '';
      end else
        objStmtTable.FieldByName('StmtName').AsString := '';
    end
    else if (pField.FieldName = 'TableAlias') or (pField.FieldName = 'TableName') or
            (pField.FieldName = 'StmtName') then
    begin
      if (tvFrmStatementDefineTableStructure.Selected <> nil) and
        (Integer(tvFrmStatementDefineTableStructure.Selected.Data) = objStmtTable.FieldByName('TableNo').AsInteger) and
        (generateTableTreeDesc <> tvFrmStatementDefineTableStructure.Selected.Text) then
      begin
        tvFrmStatementDefineTableStructure.Selected.Text := generateTableTreeDesc;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableRelFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
begin
  pAccept := True;
  if (pDataSet = objStmtTableRel) then
  begin
    pAccept := (objStmtTable.FieldByName('TableNo').AsInteger = objStmtTableRel.FieldByName('TableNoTo').AsInteger);
    pAccept := pAccept and (objStmtTable.FieldByName('ParentTableNo').AsInteger = objStmtTableRel.FieldByName('TableNoFrom').AsInteger);
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableRelFieldChanged(pSender: TObject; pField: TField);
begin
  if (pSender = objStmtTableRel) and (objStmtTableRel.State in [dsInsert, dsEdit]) and
    not(objStmtTableRel.ControlsDisabled) and (pField <> nil) then
  begin
    if (pField.FieldName = 'SrcType') then
    begin
      if (TSFStmtJoinRelItemType(pField.AsInteger) = stmtJoinRelItemAttr) then
      begin
        objStmtTableRel.FieldByName('SrcValueType').AsInteger := -1;
        objStmtTableRel.FieldByName('SrcValueType').ReadOnly := True;
      end else
        objStmtTableRel.FieldByName('SrcValueType').ReadOnly := False;
    end else
    if (pField.FieldName = 'DestType') then
    begin
      if (TSFStmtJoinRelItemType(pField.AsInteger) = stmtJoinRelItemAttr) then
      begin
        objStmtTableRel.FieldByName('DestValueType').AsInteger := -1;
        objStmtTableRel.FieldByName('DestValueType').ReadOnly := True;
      end else
        objStmtTableRel.FieldByName('DestValueType').ReadOnly := False;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableRelRecChanged(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtTableRel) and not(objStmtTableRel.State in [dsEdit, dsInsert]) then
  begin
    if (objStmtTableRel.IsEmpty) then
    begin
      objStmtTableRel.FieldByName('SrcValueType').ReadOnly := True;
      objStmtTableRel.FieldByName('DestValueType').ReadOnly := True;
    end else
    begin
      objStmtTableRel.FieldByName('SrcValueType').ReadOnly := (TSFStmtJoinRelItemType(objStmtTableRel.FieldByName('SrcType')) = stmtJoinRelItemAttr);
      objStmtTableRel.FieldByName('DestValueType').ReadOnly := (TSFStmtJoinRelItemType(objStmtTableRel.FieldByName('DestType')) = stmtJoinRelItemAttr);
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableRelAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtTableRel) and not(objStmtTableRel.ControlsDisabled) then
  begin
    objStmtTableRel.FieldByName('TableNoTo').AsInteger := objStmtTable.FieldByName('TableNo').AsInteger;
    objStmtTableRel.FieldByName('TableNoFrom').AsInteger := objStmtTable.FieldByName('ParentTableNo').AsInteger;
    objStmtTableRel.FieldByName('SrcType').AsInteger := Integer(stmtJoinRelItemAttr);
    objStmtTableRel.FieldByName('DestType').AsInteger := Integer(stmtJoinRelItemAttr);
  end;
end;

procedure TFrmSFStatementDefine.objStmtTableRelBeforePost(pDataSet: TDataSet);
  var lError: Boolean;
begin
  if (pDataSet = objStmtTableRel) and not(objStmtTableRel.ControlsDisabled) then
  begin
    lError := (objStmtTableRel.FieldByName('SrcType').AsInteger < 0) or (objStmtTableRel.FieldByName('DestType').AsInteger < 0);
    lError := lError or (objStmtTableRel.FieldByName('SrcType').AsInteger < Integer(Low(TSFStmtJoinRelItemType)))
              or (objStmtTableRel.FieldByName('SrcType').AsInteger > Integer(High(TSFStmtJoinRelItemType)));
    lError := lError or (objStmtTableRel.FieldByName('DestType').AsInteger < Integer(Low(TSFStmtJoinRelItemType)))
              or (objStmtTableRel.FieldByName('DestType').AsInteger > Integer(High(TSFStmtJoinRelItemType)));
    lError := lError or (objStmtTableRel.FieldByName('SrcValue').AsString = '') or (objStmtTableRel.FieldByName('DestValue').AsString = '');

    if (lError) then
      handlePostError;

    if (TSFStmtJoinRelItemType(objStmtTableRel.FieldByName('SrcType').AsInteger) = stmtJoinRelItemValue) then
    begin
      if (objStmtTableRel.FieldByName('SrcValueType').AsInteger < 0) or
        (objStmtTableRel.FieldByName('SrcValueType').AsInteger < Integer(Low(TSFStmtValueType))) or
        (objStmtTableRel.FieldByName('SrcValueType').AsInteger > Integer(High(TSFStmtValueType))) then
      begin
        handlePostError;
      end;
      if not(checkValueTypeForVal(objStmtTableRel.FieldByName('SrcValue').AsString, objStmtTableRel.FieldByName('SrcValueType').AsInteger, False)) then
        handlePostError;

      if (objStmtTableRel.FieldByName('DestValueType').AsInteger < 0) or
        (objStmtTableRel.FieldByName('DestValueType').AsInteger < Integer(Low(TSFStmtValueType))) or
        (objStmtTableRel.FieldByName('DestValueType').AsInteger > Integer(High(TSFStmtValueType))) then
      begin
        handlePostError;
      end;
      if not(checkValueTypeForVal(objStmtTableRel.FieldByName('DestValue').AsString, objStmtTableRel.FieldByName('DestValueType').AsInteger, False)) then
        handlePostError;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrAfterScroll(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttr) then
  begin
    if not(objStmtAttr.SyncDisabled) then
    begin
      if (objStmtAttrItem.Filtered) then
        objStmtAttrItem.Refilter
      else
        objStmtAttrItem.Filtered := True;
    end;

    if not(objStmtAttr.ControlsDisabled) then
      adjustAutoEditSources;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrBeforeDelete(pDataSet: TDataSet);
  var lDelCond, lNeedCondCheck: Boolean;
begin
  if (pDataSet = objStmtAttr) then
  begin
    // delete related items
    if not(objStmtAttrItem.IsEmpty) then
    begin
      objStmtAttrItem.DisableControls;
      try
        objStmtAttrItem.First;
        while not(objStmtAttrItem.Eof) do
        begin
          if (objStmtAttrItem.FieldByName('AttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger) then
            objStmtAttrItem.Delete
          else
            objStmtAttrItem.Next;
        end;
        if not(objStmtAttrItem.IsEmpty) then
          objStmtAttrItem.First;
      finally
        objStmtAttrItem.EnableControls;
      end;
    end;

    // delete related order
    if not(objStmtOrder.IsEmpty) then
    begin
      objStmtOrder.DisableControls;
      try
        objStmtOrder.First;
        while not(objStmtOrder.Eof) do
        begin
          if (objStmtOrder.FieldByName('AttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger) then
            objStmtOrder.Delete
          else
            objStmtOrder.Next;
        end;
        if not(objStmtOrder.IsEmpty) then
          objStmtOrder.First;
      finally
        objStmtOrder.EnableControls;
      end;
    end;

    // delete related group
    if not(objStmtGroup.IsEmpty) then
    begin
      objStmtGroup.DisableControls;
      try
        objStmtGroup.First;
        while not(objStmtGroup.Eof) do
        begin
          if (objStmtGroup.FieldByName('AttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger) then
            objStmtGroup.Delete
          else
            objStmtGroup.Next;
        end;
        if not(objStmtGroup.IsEmpty) then
          objStmtGroup.First;
      finally
        objStmtGroup.EnableControls;
      end;
    end;

    // delete related conditions
    if not(objStmtCond.IsEmpty) then
    begin
      objStmtCond.DisableControls;
      objStmtCondExists.DisableControls;
      try
        lNeedCondCheck := False;
        objStmtCond.First;
        while not(objStmtCond.Eof) do
        begin
          lDelCond := False;
          case TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) of
            stmtCondTypeValue, stmtCondTypeAttribute,
            stmtCondTypeIsNull, stmtCondTypeIsNotNull:
              begin
                lDelCond := (objStmtCond.FieldByName('AttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger);
                if not(lDelCond) and (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeAttribute) then
                  lDelCond := (objStmtCond.FieldByName('DestAttrTempId').AsInteger = objStmtAttr.FieldByName('TempId').AsInteger);
              end;
          end;
          lNeedCondCheck := lNeedCondCheck or lDelCond;
          if (lDelCond) then
            objStmtCond.Delete
          else
            objStmtCond.Next;
        end;
        if (lNeedCondCheck) then
          validateConditions;
        if not(objStmtCond.IsEmpty) then
          objStmtCond.First;
      finally
        objStmtCond.EnableControls;
        objStmtCondExists.EnableControls;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttr) and not(objStmtAttr.ControlsDisabled) then
  begin
    inc(mLastAttrId);
    objStmtAttr.FieldByName('TempId').AsInteger := mLastAttrId;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrBeforePost(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttr) and not(objStmtAttr.ControlsDisabled) then
  begin
    objStmtAttr.FieldByName('AttrResultName').AsString := detectAttrDesc;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrAfterPost(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttr) and not(objStmtAttr.ControlsDisabled) then
    syncAttributesLkp(True);
end;

procedure TFrmSFStatementDefine.objStmtAttrItemFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
begin
  pAccept := True;
  if (pDataSet = objStmtAttrItem) then
    pAccept := (objStmtAttr.FieldByName('TempId').AsInteger = objStmtAttrItem.FieldByName('AttrTempId').AsInteger);
end;

procedure TFrmSFStatementDefine.objStmtAttrItemFieldChanged(pSender: TObject; pField: TField);
begin
  // disable/enable columns when type was changed
  if (pSender = objStmtAttrItem) and (objStmtAttrItem.State in [dsInsert, dsEdit]) and
    not(objStmtAttrItem.ControlsDisabled) and (pField <> nil) then
  begin
    if (pField.FieldName = 'ItemType') then
    begin
      case TSFStmtAttrItemType(pField.AsInteger) of
        stmtAttrItemTypeDbField:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;

            objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefOther').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger := -1;
          end;
        stmtAttrItemTypeValue:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := False;

            objStmtAttrItem.FieldByName('Aggr').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := -1;
            objStmtAttrItem.FieldByName('ItemRefTableField').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := '';
          end;
        stmtAttrItemTypeStmt:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;

            objStmtAttrItem.FieldByName('Aggr').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := -1;
            objStmtAttrItem.FieldByName('ItemRefTableField').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefOther').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger := -1;
          end;
        stmtAttrItemTypeParameter, stmtAttrItemTypeDynamic:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;

            objStmtAttrItem.FieldByName('Aggr').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := -1;
            objStmtAttrItem.FieldByName('ItemRefTableField').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger := -1;
          end;
        stmtAttrItemTypeAggrFunc:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;

            objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := -1;
            objStmtAttrItem.FieldByName('ItemRefTableField').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefOther').AsString := '';
            objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger := -1;
          end;
      else
        objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;

        objStmtAttrItem.FieldByName('Aggr').AsString := '';
        objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := -1;
        objStmtAttrItem.FieldByName('ItemRefTableField').AsString := '';
        objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := '';
        objStmtAttrItem.FieldByName('ItemRefOther').AsString := '';
        objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger := -1;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrItemRecChanged(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttrItem) and not(objStmtAttrItem.State in [dsEdit, dsInsert]) then
  begin
    if (objStmtAttrItem.IsEmpty) then
    begin
      objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
      objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
      objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
      objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
      objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
      objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
    end else
    begin
      case TSFStmtAttrItemType(objStmtAttrItem.FieldByName('ItemType').AsInteger) of
        stmtAttrItemTypeDbField:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
          end;
        stmtAttrItemTypeValue:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := False;
          end;
        stmtAttrItemTypeStmt:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
          end;
        stmtAttrItemTypeParameter, stmtAttrItemTypeDynamic:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
          end;
        stmtAttrItemTypeAggrFunc:
          begin
            objStmtAttrItem.FieldByName('Aggr').ReadOnly := False;
            objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
            objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
          end;
      else
        objStmtAttrItem.FieldByName('Aggr').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefTableNo').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefTableField').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefStmtName').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefOther').ReadOnly := True;
        objStmtAttrItem.FieldByName('ItemRefValueType').ReadOnly := True;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrItemAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttrItem) and not(objStmtAttrItem.ControlsDisabled) then
  begin
    objStmtAttrItem.FieldByName('AttrTempId').AsInteger := objStmtAttr.FieldByName('TempId').AsInteger;
    objStmtAttrItem.FieldByName('ItemType').AsInteger := Integer(stmtAttrItemTypeDbField);
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrItemBeforePost(pDataSet: TDataSet);
  var lError: Boolean;
begin
  if (pDataSet = objStmtAttrItem) and not(objStmtAttrItem.ControlsDisabled) then
  begin
    if (objStmtAttrItem.FieldByName('ItemType').AsInteger < 0) or
        (objStmtAttrItem.FieldByName('ItemType').AsInteger < Integer(Low(TSFStmtAttrItemType))) or
        (objStmtAttrItem.FieldByName('ItemType').AsInteger > Integer(High(TSFStmtAttrItemType))) then
    begin
      handlePostError;
    end;

    lError := False;
    case TSFStmtAttrItemType(objStmtAttrItem.FieldByName('ItemType').AsInteger) of
      stmtAttrItemTypeDbField:
        begin
          lError := (objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger <= 0);
          lError := lError or (objStmtAttrItem.FieldByName('ItemRefTableField').AsString = '');
        end;
      stmtAttrItemTypeValue:
        begin
          if (objStmtAttrItem.FieldByName('ItemRefOther').AsString <> '') then
          begin
            lError := lError or (objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger < 0);
            lError := lError or (objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger < Integer(Low(TSFStmtValueType)))
                      or (objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger > Integer(High(TSFStmtValueType)));

            if not(lError) then
              lError := not(checkValueTypeForVal(objStmtAttrItem.FieldByName('ItemRefOther').AsString, objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger, False));
          end else
            lError := (objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger >= 0)
        end;
      stmtAttrItemTypeStmt:
        begin
          lError := (objStmtAttrItem.FieldByName('ItemRefStmtName').AsString = '');
        end;
      stmtAttrItemTypeParameter, stmtAttrItemTypeDynamic:
        begin
          lError := (objStmtAttrItem.FieldByName('ItemRefOther').AsString = '');
        end;
    end;

    if (lError) then
      handlePostError;
  end;
end;

procedure TFrmSFStatementDefine.objStmtAttrItemAfterPost(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtAttrItem) and not(objStmtAttrItem.ControlsDisabled) then
  begin
    if (objStmtAttr.FieldByName('AttrName').AsString = '') then
    begin
      // refresh AttrResultName from objStmtAttr - see objStmtAttrBeforePost
      objStmtAttr.DisableSync;
      try
        objStmtAttr.Edit;
        objStmtAttr.Post;
      finally
        objStmtAttr.EnableSync;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondAfterScroll(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCond) then
  begin
    if not(objStmtCond.SyncDisabled) then
    begin
      if (objStmtCondExists.Filtered) then
        objStmtCondExists.Refilter
      else
        objStmtCondExists.Filtered := True;
    end;

    if not (objStmtCond.ControlsDisabled) then
      adjustAutoEditSources;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondBeforeDelete(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCond) then
  begin
    // delete related exists-conditions
    objStmtCondExists.DisableControls;
    try
      if not(objStmtCondExists.IsEmpty) then
      begin
        objStmtCondExists.First;
        while not(objStmtCondExists.Eof) do
        begin
          if (objStmtCond.FieldByName('TempId').AsInteger = objStmtCondExists.FieldByName('TempId').AsInteger) then
            objStmtCondExists.Delete
          else
            objStmtCondExists.Next;
        end;
      end;
      if not(objStmtCondExists.IsEmpty) then
        objStmtCondExists.First;
    finally
      objStmtCondExists.EnableControls;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondFieldChanged(pSender: TObject; pField: TField);
begin
  // disable/enable columns when type was changed
  if (pSender = objStmtCond) and (objStmtCond.State in [dsInsert, dsEdit]) and
    not(objStmtCond.ControlsDisabled) and (pField <> nil) then
  begin
    if (pField.FieldName = 'CondType') then
    begin
      case TSFStmtConditionType(pField.AsInteger) of
        stmtCondTypeValue:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := False;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
            objStmtCond.FieldByName('DestValue').ReadOnly := False;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := False;
            objStmtCond.FieldByName('DestValueType').ReadOnly := False;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;

            objStmtCond.FieldByName('DestAttrTempId').AsInteger := -1;
            objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := -1;
            objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := '';
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := '';
          end;
        stmtCondTypeAttribute:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := False;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('DestValue').ReadOnly := True;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
            objStmtCond.FieldByName('DestValueType').ReadOnly := True;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;

            objStmtCond.FieldByName('DestValue').AsString := '';
            objStmtCond.FieldByName('DestValueIsArray').AsInteger := -1;
            objStmtCond.FieldByName('DestValueType').AsInteger := -1;
            objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := -1;
            objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := '';
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := '';
          end;
        stmtCondTypeIsNull, stmtCondTypeIsNotNull:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := True;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
            objStmtCond.FieldByName('DestValue').ReadOnly := True;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
            objStmtCond.FieldByName('DestValueType').ReadOnly := True;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;

            objStmtCond.FieldByName('CondOperator').AsString := '';
            objStmtCond.FieldByName('DestAttrTempId').AsInteger := -1;
            objStmtCond.FieldByName('DestValue').AsString := '';
            objStmtCond.FieldByName('DestValueIsArray').AsInteger := -1;
            objStmtCond.FieldByName('DestValueType').AsInteger := -1;
            objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := -1;
            objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := '';
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := '';
          end;
      else
        objStmtCond.FieldByName('AttrTempId').ReadOnly := True;
        objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
        objStmtCond.FieldByName('DestValue').ReadOnly := True;
        objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
        objStmtCond.FieldByName('DestValueType').ReadOnly := True;

        objStmtCond.FieldByName('AttrTempId').AsInteger := -1;
        objStmtCond.FieldByName('DestAttrTempId').AsInteger := -1;
        objStmtCond.FieldByName('DestValue').AsString := '';
        objStmtCond.FieldByName('DestValueIsArray').AsInteger := -1;
        objStmtCond.FieldByName('DestValueType').AsInteger := -1;

        if (TSFStmtConditionType(pField.AsInteger) = stmtCondTypeUndefined) then
        begin
          objStmtCond.FieldByName('CondOperator').ReadOnly := False;
          if ((objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) or
            (objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS)) then
          begin
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := False;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := False;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := False;
          end else
          begin
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;

            objStmtCond.FieldByName('CondOperator').AsString := '';
            objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := -1;
            objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := '';
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := '';
          end;
        end else
        begin
          objStmtCond.FieldByName('CondOperator').ReadOnly := True;
          objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
          objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
          objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;

          objStmtCond.FieldByName('CondOperator').AsString := '';
          objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := -1;
          objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := '';
          objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := '';
        end;
      end;

      if (objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly) then
      begin
        objStmtCondExists.DisableControls;
        try
          // delete related exists-conditions
          if not(objStmtCondExists.IsEmpty) then
          begin
            objStmtCondExists.First;
            while not(objStmtCondExists.Eof) do
            begin
              if (objStmtCond.FieldByName('TempId').AsInteger = objStmtCondExists.FieldByName('TempId').AsInteger) then
                objStmtCondExists.Delete
              else
                objStmtCondExists.Next;
            end;
          end;
          if not(objStmtCondExists.IsEmpty) then
            objStmtCondExists.First;
        finally
          objStmtCondExists.EnableControls;
        end;

        if ((objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) or
          (objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS)) then
        begin
          objStmtCond.FieldByName('CondOperator').AsString := '';
        end;
      end;

      adjustAutoEditSources;
    end else
    if (pField.FieldName = 'CondOperator') then
    begin
      if (pField.AsString <> '') then
      begin
        if (pField.AsString <> SFSTMT_OP_EXISTS) and (pField.AsString <> SFSTMT_OP_NOT_EXISTS) then
        begin
          if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeUndefined) then
            objStmtCond.FieldByName('CondType').AsInteger := Integer(stmtCondTypeValue);
        end else
          objStmtCond.FieldByName('CondType').AsInteger := Integer(stmtCondTypeUndefined);
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondRecChanged(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCond) and not(objStmtCond.State in [dsEdit, dsInsert]) then
  begin
    if (objStmtCond.IsEmpty) then
    begin
      objStmtCond.FieldByName('AttrTempId').ReadOnly := True;
      objStmtCond.FieldByName('CondOperator').ReadOnly := True;
      objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
      objStmtCond.FieldByName('DestValue').ReadOnly := True;
      objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
      objStmtCond.FieldByName('DestValueType').ReadOnly := True;
      objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
      objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
      objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
    end else
    begin
      case TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) of
        stmtCondTypeValue:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := False;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
            objStmtCond.FieldByName('DestValue').ReadOnly := False;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := False;
            objStmtCond.FieldByName('DestValueType').ReadOnly := False;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
          end;
        stmtCondTypeAttribute:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := False;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('DestValue').ReadOnly := True;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
            objStmtCond.FieldByName('DestValueType').ReadOnly := True;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
          end;
        stmtCondTypeIsNull, stmtCondTypeIsNotNull:
          begin
            objStmtCond.FieldByName('AttrTempId').ReadOnly := False;
            objStmtCond.FieldByName('CondOperator').ReadOnly := True;
            objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
            objStmtCond.FieldByName('DestValue').ReadOnly := True;
            objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
            objStmtCond.FieldByName('DestValueType').ReadOnly := True;
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
          end;
      else
        objStmtCond.FieldByName('AttrTempId').ReadOnly := True;
        objStmtCond.FieldByName('DestAttrTempId').ReadOnly := True;
        objStmtCond.FieldByName('DestValue').ReadOnly := True;
        objStmtCond.FieldByName('DestValueIsArray').ReadOnly := True;
        objStmtCond.FieldByName('DestValueType').ReadOnly := True;

        if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeUndefined) then
        begin
          objStmtCond.FieldByName('CondOperator').ReadOnly := False;
          if ((objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) or
            (objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS)) then
          begin
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := False;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := False;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := False;
          end else
          begin
            objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
            objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
          end;
        end else
        begin
          objStmtCond.FieldByName('CondOperator').ReadOnly := True;
          objStmtCond.FieldByName('ExistsTableAliasFrom').ReadOnly := True;
          objStmtCond.FieldByName('ExistsDestRefStmtName').ReadOnly := True;
          objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').ReadOnly := True;
        end;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCond) and not(objStmtCond.ControlsDisabled) then
  begin
    inc(mLastCondId);
    objStmtCond.FieldByName('TempId').AsInteger := mLastCondId;
    objStmtCond.FieldByName('CondType').AsInteger := Integer(stmtCondTypeValue);
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondBeforePost(pDataSet: TDataSet);
  var lError: Boolean;
begin
  if (pDataSet = objStmtCond) and not(objStmtCond.ControlsDisabled) then
  begin
    if (objStmtCond.FieldByName('CondType').AsInteger < 0) or
        (objStmtCond.FieldByName('CondType').AsInteger < Integer(Low(TSFStmtConditionType))) or
        (objStmtCond.FieldByName('CondType').AsInteger > Integer(High(TSFStmtConditionType)))then
    begin
      handlePostError;
    end;

    lError := False;
    case TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) of
      stmtCondTypeValue:
        begin
          lError := (objStmtCond.FieldByName('AttrTempId').AsInteger <= 0);
          lError := lError or (objStmtCond.FieldByName('CondOperator').AsString = '');
          lError := lError or (objStmtCond.FieldByName('DestValue').AsString = '');
          lError := lError or (objStmtCond.FieldByName('DestValueType').AsInteger < 0)
                    or (objStmtCond.FieldByName('DestValueType').AsInteger < Integer(Low(TSFStmtValueType)))
                    or (objStmtCond.FieldByName('DestValueType').AsInteger > Integer(High(TSFStmtValueType)));
          if not(lError) then
            lError := ((objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) or
                      (objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS));

          if not(lError) then
          begin
            if (Boolean(objStmtCond.FieldByName('DestValueIsArray').AsInteger)) then
            begin
              lError := not(checkValueTypeForVal(objStmtCond.FieldByName('DestValue').AsString, objStmtCond.FieldByName('DestValueType').AsInteger, True));
            end else
              lError := not(checkValueTypeForVal(objStmtCond.FieldByName('DestValue').AsString, objStmtCond.FieldByName('DestValueType').AsInteger, False));
          end;
        end;
      stmtCondTypeAttribute:
        begin
          lError := (objStmtCond.FieldByName('AttrTempId').AsInteger <= 0);
          lError := lError or (objStmtCond.FieldByName('CondOperator').AsString = '');
          lError := lError or (objStmtCond.FieldByName('DestAttrTempId').AsInteger <= 0);
        end;
      stmtCondTypeIsNull, stmtCondTypeIsNotNull:
        begin
          lError := (objStmtCond.FieldByName('AttrTempId').AsInteger <= 0);
        end;
      stmtCondTypeUndefined:
        begin
          lError := (objStmtCond.FieldByName('CondOperator').AsString = '');
          lError := lError or (objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger <= 0);
          lError := lError or (objStmtCond.FieldByName('ExistsDestRefStmtName').AsString = '');
          lError := lError or (objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString = '');
          if not(lError) then
            lError := not(objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) and
                      not(objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS);
        end;
    end;

    if (lError) then
      handlePostError;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondExistsFilterRecord(pDataSet: TDataSet; var pAccept: Boolean);
begin
  pAccept := True;
  if (pDataSet = objStmtCondExists) then
    pAccept := (objStmtCond.FieldByName('TempId').AsInteger = objStmtCondExists.FieldByName('TempId').AsInteger);
end;

procedure TFrmSFStatementDefine.objStmtCondExistsFieldChanged(pSender: TObject; pField: TField);
begin
  if (pSender = objStmtCondExists) and (objStmtCondExists.State in [dsInsert, dsEdit]) and
    not(objStmtCondExists.ControlsDisabled) and (pField <> nil) then
  begin
    if (pField.FieldName = 'SrcType') then
    begin
      if (TSFStmtJoinRelItemType(pField.AsInteger) = stmtJoinRelItemAttr) then
      begin
        objStmtCondExists.FieldByName('SrcValueType').AsInteger := -1;
        objStmtCondExists.FieldByName('SrcValueType').ReadOnly := True;
      end else
        objStmtCondExists.FieldByName('SrcValueType').ReadOnly := False;
    end else
    if (pField.FieldName = 'DestType') then
    begin
      if (TSFStmtJoinRelItemType(pField.AsInteger) = stmtJoinRelItemAttr) then
      begin
        objStmtCondExists.FieldByName('DestValueType').AsInteger := -1;
        objStmtCondExists.FieldByName('DestValueType').ReadOnly := True;
      end else
        objStmtCondExists.FieldByName('DestValueType').ReadOnly := False;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondExistsRecChanged(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCondExists) and not(objStmtCondExists.State in [dsEdit, dsInsert]) then
  begin
    if (objStmtCondExists.IsEmpty) then
    begin
      objStmtCondExists.FieldByName('SrcValueType').ReadOnly := True;
      objStmtCondExists.FieldByName('DestValueType').ReadOnly := True;
    end else
    begin
      objStmtCondExists.FieldByName('SrcValueType').ReadOnly := (TSFStmtJoinRelItemType(objStmtCondExists.FieldByName('SrcType')) = stmtJoinRelItemAttr);
      objStmtCondExists.FieldByName('DestValueType').ReadOnly := (TSFStmtJoinRelItemType(objStmtCondExists.FieldByName('DestType')) = stmtJoinRelItemAttr);
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondExistsAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtCondExists) and not(objStmtCondExists.ControlsDisabled) then
  begin
    objStmtCondExists.FieldByName('TempId').AsInteger := objStmtCond.FieldByName('TempId').AsInteger;
    objStmtCondExists.FieldByName('SrcType').AsInteger := Integer(stmtJoinRelItemAttr);
    objStmtCondExists.FieldByName('DestType').AsInteger := Integer(stmtJoinRelItemAttr);
  end;
end;

procedure TFrmSFStatementDefine.objStmtCondExistsBeforePost(pDataSet: TDataSet);
  var lError: Boolean;
begin
  if (pDataSet = objStmtCondExists) and not(objStmtCondExists.ControlsDisabled) then
  begin
    lError := (objStmtCondExists.FieldByName('SrcType').AsInteger < 0) or (objStmtCondExists.FieldByName('DestType').AsInteger < 0);
    lError := lError or (objStmtCondExists.FieldByName('SrcType').AsInteger < Integer(Low(TSFStmtJoinRelItemType)))
              or (objStmtCondExists.FieldByName('SrcType').AsInteger > Integer(High(TSFStmtJoinRelItemType)));
    lError := lError or (objStmtCondExists.FieldByName('SrcValue').AsString = '') or (objStmtCondExists.FieldByName('DestValue').AsString = '');

    if (lError) then
      handlePostError;

    if (TSFStmtJoinRelItemType(objStmtCondExists.FieldByName('SrcType').AsInteger) = stmtJoinRelItemValue) then
    begin
      if (objStmtCondExists.FieldByName('SrcValueType').AsInteger < 0) or
          (objStmtCondExists.FieldByName('SrcValueType').AsInteger < Integer(Low(TSFStmtValueType))) or
          (objStmtCondExists.FieldByName('SrcValueType').AsInteger > Integer(High(TSFStmtValueType))) then
      begin
        handlePostError;
      end;
      if not(checkValueTypeForVal(objStmtCondExists.FieldByName('SrcValue').AsString, objStmtCondExists.FieldByName('SrcValueType').AsInteger, False)) then
        handlePostError;

      if (objStmtCondExists.FieldByName('DestValueType').AsInteger < 0) or
          (objStmtCondExists.FieldByName('DestValueType').AsInteger < Integer(Low(TSFStmtValueType))) or
          (objStmtCondExists.FieldByName('DestValueType').AsInteger > Integer(High(TSFStmtValueType))) then
      begin
        handlePostError;
      end;
      if not(checkValueTypeForVal(objStmtCondExists.FieldByName('DestValue').AsString, objStmtCondExists.FieldByName('DestValueType').AsInteger, False)) then
        handlePostError;
    end;
  end;
end;

procedure TFrmSFStatementDefine.objStmtOrderAfterInsert(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtOrder) and not(objStmtOrder.ControlsDisabled) then
    objStmtOrder.FieldByName('SortType').AsInteger := Integer(stmtSortTypeAsc);
end;

procedure TFrmSFStatementDefine.objStmtOrderBeforePost(pDataSet: TDataSet);
begin
  if (pDataSet = objStmtOrder) and not(objStmtOrder.ControlsDisabled) then
  begin
    if (objStmtOrder.FieldByName('AttrTempId').AsInteger <= 0) or
      (objStmtOrder.FieldByName('SortType').AsInteger < 0) or
      (objStmtOrder.FieldByName('SortType').AsInteger < Integer(Low(TSFStmtSortType))) or
      (objStmtOrder.FieldByName('SortType').AsInteger > Integer(High(TSFStmtSortType))) then
    begin
      handlePostError;
    end;
  end;
end;

//============================================================================//
//                          private functions                                 //
//============================================================================//

procedure TFrmSFStatementDefine.reOpenDataObjects;
begin
  reOpenDataObject(mObjStmt);
  reOpenDataObject(mObjStmtTable);
  reOpenDataObject(mObjStmtTableRel);
  reOpenDataObject(mObjStmtAttr);
  reOpenDataObject(mObjStmtAttrItem);
  reOpenDataObject(mObjStmtCond);
  reOpenDataObject(mObjStmtCondExists);
  reOpenDataObject(mObjStmtOrder);
  reOpenDataObject(mObjStmtGroup);
  reOpenDataObject(mObjTablesLkp);
  reOpenDataObject(mObjAttributesLkp);

  adjustAutoEditSources;
  mLastTableNo := 0;
  mLastAttrId := 0;
  mLastCondId := 0;
end;

procedure TFrmSFStatementDefine.reOpenDataObject(pObj: TSFBusinessData);
begin
  if (Assigned(pObj)) then
  begin
    if (pObj.Active) then
      pObj.Close;

    pObj.Open;
  end;
end;

procedure TFrmSFStatementDefine.loadObjects(pXmlStmt: TSFStmtXML);
begin
  objStmt.Append;
  objStmt.FieldByName('UseDistinct').AsInteger := Integer(pXmlStmt.UseDistinct);
  objStmt.FieldByName('QuoteType').AsInteger := pXmlStmt.QuoteType;
  objStmt.FieldByName('AutoEscapeLike').AsInteger := Integer(pXmlStmt.AutoEscapeLike);
  objStmt.FieldByName('DBDialect').AsInteger := pXmlStmt.DBDialect;
  objStmt.FieldByName('LikeEscapeChar').AsString := pXmlStmt.LikeEscapeChar;
  objStmt.FieldByName('Union').AsString := pXmlStmt.Union;
  objStmt.Post;

  if (pXmlStmt.HasBaseTable) then
  begin
    objStmtTable.DisableControls;
    objStmtTable.DisableSync;
    try
      // load tables if exists
      if (pXmlStmt.HasBaseTable) then
        loadTableXML(pXmlStmt.BaseTable);
    finally
      objStmtTable.EnableControls;
      objStmtTable.EnableSync;
    end;

    objStmtTable.First;
    // sync lookup-tables
    syncTablesLkp;
  end;

  // load attributes if exists
  if (pXmlStmt.HasAttrs) then
    loadAttributesXML(pXmlStmt.Attrs);

  // sync lookup-attributes
  syncAttributesLkp;

  // load conditions if exists
  if (pXmlStmt.HasConds) then
    loadConditionsXML(pXmlStmt.Conds);

  // load orders and groups if exists
  if (pXmlStmt.HasOrders) or (pXmlStmt.HasGroups) then
  begin
    if (pXmlStmt.HasOrders) and (pXmlStmt.HasGroups) then
      loadOrderAndGroupXML(pXmlStmt.Orders, pXmlStmt.Groups)
    else if (pXmlStmt.HasOrders) then
      loadOrderAndGroupXML(pXmlStmt.Orders, nil)
    else
      loadOrderAndGroupXML(nil, pXmlStmt.Groups)
  end;

  adjustAutoEditSources;

  mLastTableNo := searchMaxTableNo;
  mLastAttrId := searchMaxAttrId;
  mLastCondId := searchMaxCondId;

  objStmtTableRelRecChanged(objStmtTableRel);
  objStmtAttrItemRecChanged(objStmtAttrItem);
  objStmtCondRecChanged(objStmtCond);
  objStmtCondExistsRecChanged(objStmtCondExists);
end;

procedure TFrmSFStatementDefine.loadTableXML(pTable: TSFStmtTableXML;
    pParentRelation: TSFStmtTableRelationXML; pParentTableNo: Integer);
  var i: Integer;
      lParentRelItemXml: TSFStmtTableRelationItemXML;
      lRelationXml: TSFStmtTableRelationXML;
begin
  objStmtTable.Append;
  objStmtTable.FieldByName('TableNo').AsInteger := pTable.TableNo;
  objStmtTable.FieldByName('TableAlias').AsString := pTable.TableAlias;

  // set tablename or stmtname
  objStmtTable.FieldByName('StmtName').AsString := pTable.StmtName;
  objStmtTable.FieldByName('TableIsStmt').AsInteger := Integer(pTable.TableIsStmt);
  objStmtTable.FieldByName('TableName').AsString := pTable.TableName;
  objStmtTable.FieldByName('Schema').AsString := pTable.Schema;
  objStmtTable.FieldByName('Catalog').AsString := pTable.Catalog;
  // set tablejoininfo
  objStmtTable.FieldByName('ParentTableJoinType').AsInteger := -1;
  objStmtTable.FieldByName('ParentTableNo').AsInteger := pParentTableNo;
  if (pParentRelation <> nil) then
    objStmtTable.FieldByName('ParentTableJoinType').AsInteger := pParentRelation.ParentTableJoinType;
  objStmtTable.Post;

  if (pParentRelation <> nil) and (pParentRelation.HasRelationItems) then
  begin
    for i := 0 to (pParentRelation.RelationItems.Count - 1) do
    begin
      lParentRelItemXml := TSFStmtTableRelationItemXML(pParentRelation.RelationItems.Item[i]);

      objStmtTableRel.Append;
      objStmtTableRel.FieldByName('TableNoFrom').AsInteger := pParentTableNo;
      objStmtTableRel.FieldByName('TableNoTo').AsInteger := pTable.TableNo;
      objStmtTableRel.FieldByName('SrcType').AsInteger := lParentRelItemXml.SrcType;
      objStmtTableRel.FieldByName('SrcValue').AsString := lParentRelItemXml.SrcValue;
      objStmtTableRel.FieldByName('SrcValueType').Value := lParentRelItemXml.SrcValueType;
      objStmtTableRel.FieldByName('DestType').AsInteger := lParentRelItemXml.DestType;
      objStmtTableRel.FieldByName('DestValue').AsString := lParentRelItemXml.DestValue;
      objStmtTableRel.FieldByName('DestValueType').Value := lParentRelItemXml.DestValueType;
      objStmtTableRel.Post;
    end;
  end;

  if (pTable.HasRelations) then
  begin
    for i := 0 to (pTable.Relations.Count - 1) do
    begin
      lRelationXml := TSFStmtTableRelationXML(pTable.Relations.Item[i]);
      if not(lRelationXml.HasDestTable) then
        Continue;

      loadTableXML(lRelationXml.DestTable, lRelationXml, pTable.TableNo);
    end;
  end;
end;

procedure TFrmSFStatementDefine.loadAttributesXML(pAttrs: TSFStmtAttrsXML);
  var i, x: Integer;
      lAttrXML: TSFStmtAttrXML;
      lAttrItemXML: TSFStmtAttrItemXML;
      lAttrDesc: String;
begin
  objStmtAttr.DisableControls;
  objStmtAttr.DisableSync;
  objStmtAttrItem.DisableControls;
  try
    for i := 0 to (pAttrs.Count - 1) do
    begin
      lAttrXML := TSFStmtAttrXML(pAttrs.Item[i]);

      objStmtAttr.Append;
      objStmtAttr.FieldByName('TempId').AsInteger := lAttrXML.AttrIdx + 1;
      objStmtAttr.FieldByName('AttrName').AsString := lAttrXML.AttrName;
      objStmtAttr.FieldByName('AttrResultName').AsString := '';
      objStmtAttr.FieldByName('OnlyForSearch').AsInteger := Integer(lAttrXML.OnlyForSearch);
      objStmtAttr.Post;

      if (lAttrXML.HasAttrItems) then
      begin
        for x := 0 to (lAttrXML.AttrItems.Count - 1) do
        begin
          lAttrItemXML := TSFStmtAttrItemXML(lAttrXML.AttrItems.Item[x]);

          objStmtAttrItem.Append;
          objStmtAttrItem.FieldByName('AttrTempId').AsInteger := lAttrXML.AttrIdx + 1;
          objStmtAttrItem.FieldByName('Aggr').AsString := lAttrItemXML.Aggr;
          objStmtAttrItem.FieldByName('ItemType').AsInteger := lAttrItemXML.ItemType;
          objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger := tableNoByAlias(lAttrItemXML.ItemRefTableAlias);
          objStmtAttrItem.FieldByName('ItemRefTableField').AsString := lAttrItemXML.ItemRefTableField;
          objStmtAttrItem.FieldByName('ItemRefStmtName').AsString := lAttrItemXML.ItemRefStmtName;
          objStmtAttrItem.FieldByName('ItemRefOther').AsString := lAttrItemXML.ItemRefOther;
          objStmtAttrItem.FieldByName('ItemRefValueType').Value := lAttrItemXML.ItemRefValueType;
          objStmtAttrItem.Post;
        end;
      end;

      lAttrDesc := detectAttrDesc;
      if (lAttrDesc <> '') then
      begin
        objStmtAttr.Edit;
        objStmtAttr.FieldByName('AttrResultName').AsString := lAttrDesc;
        objStmtAttr.Post;
      end;
    end;
  finally
    objStmtAttr.EnableControls;
    objStmtAttr.EnableSync;
    objStmtAttrItem.EnableControls;
  end;

  objStmtAttr.First;
end;

procedure TFrmSFStatementDefine.loadConditionsXML(pConds: TSFStmtCondsXML);
  var i, x, lLastTempId: Integer;
      lCondXML: TSFStmtCondXML;
      lExistsRelItem: TSFStmtTableRelationItemXML;
begin
  objStmtCond.DisableControls;
  objStmtCond.DisableSync;
  objStmtCondExists.DisableControls;
  try
    lLastTempId := 0;
    if not(objStmtCond.IsEmpty) then
    begin
      objStmtCond.Last;
      lLastTempId := objStmtCond.FieldByName('TempId').AsInteger;
    end;

    for i := 0 to (pConds.Count - 1) do
    begin
      lCondXML := TSFStmtCondXML(pConds.Item[i]);

      inc(lLastTempId);
      objStmtCond.Append;
      objStmtCond.FieldByName('TempId').AsInteger := lLastTempId;
      objStmtCond.FieldByName('CondType').AsInteger := lCondXML.CondType;
      objStmtCond.FieldByName('CondOperator').AsString := lCondXML.CondOperator;
      objStmtCond.FieldByName('AttrTempId').AsInteger := lCondXML.AttrIdx + 1;
      objStmtCond.FieldByName('DestAttrTempId').AsInteger := lCondXML.DestAttrIdx + 1;
      objStmtCond.FieldByName('DestValue').AsString := lCondXML.DestValue;
      objStmtCond.FieldByName('DestValueType').AsInteger := lCondXML.DestValueType;
      objStmtCond.FieldByName('DestValueIsArray').AsInteger := Integer(lCondXML.DestValueIsArray);
      objStmtCond.FieldByName('IsRestriction').AsInteger := Integer(lCondXML.IsRestriction);
      objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger := tableNoByAlias(lCondXML.ExistsTableAliasFrom);
      objStmtCond.FieldByName('ExistsDestRefStmtName').AsString := lCondXML.ExistsDestRefStmtName;
      objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString := lCondXML.ExistsDestRefStmtTableAlias;
      objStmtCond.Post;

      if (lCondXml.HasExistsRelationItems) then
      begin
        for x := 0 to (lCondXml.ExistsRelation.Count - 1) do
        begin
          lExistsRelItem := TSFStmtTableRelationItemXML(lCondXml.ExistsRelation.Item[x]);

          objStmtCondExists.Append;
          objStmtCondExists.FieldByName('TempId').AsInteger := lLastTempId;
          objStmtCondExists.FieldByName('SrcType').AsInteger := lExistsRelItem.SrcType;
          objStmtCondExists.FieldByName('SrcValue').AsString := lExistsRelItem.SrcValue;
          objStmtCondExists.FieldByName('SrcValueType').Value := lExistsRelItem.SrcValueType;
          objStmtCondExists.FieldByName('DestType').AsInteger := lExistsRelItem.DestType;
          objStmtCondExists.FieldByName('DestValue').AsString := lExistsRelItem.DestValue;
          objStmtCondExists.FieldByName('DestValueType').Value := lExistsRelItem.DestValueType;
          objStmtCondExists.Post;
        end;
      end;
    end;
  finally
    objStmtCond.EnableControls;
    objStmtCond.EnableSync;
    objStmtCondExists.EnableControls;
  end;

  objStmtCond.First;
end;

procedure TFrmSFStatementDefine.loadOrderAndGroupXML(pOrder: TSFStmtOrdersXML; pGroup: TSFStmtGroupsXML);
  var i: Integer;
      lOrderXML: TSFStmtOrderXML;
      lGroupXML: TSFStmtGroupXML;
begin
  if (pOrder <> nil) then
  begin
    objStmtOrder.DisableControls;
    try
      for i := 0 to (pOrder.Count - 1) do
      begin
        lOrderXML := TSFStmtOrderXML(pOrder.Item[i]);

        objStmtOrder.Append;
        objStmtOrder.FieldByName('AttrTempId').AsInteger := lOrderXML.AttrIdx + 1;
        objStmtOrder.FieldByName('SortType').AsInteger := lOrderXML.OrderType;
        objStmtOrder.Post;
      end;

      objStmtOrder.First;
    finally
      objStmtOrder.EnableControls;
    end;
  end;

  if (pGroup <> nil) then
  begin
    // group-attributes
    objStmtGroup.DisableControls;
    try
      for i := 0 to (pGroup.Count - 1) do
      begin
        lGroupXML := TSFStmtGroupXML(pGroup.Item[i]);

        objStmtGroup.Append;
        objStmtGroup.FieldByName('AttrTempId').AsInteger := lGroupXML.AttrIdx + 1;
        objStmtGroup.Post;
      end;

      objStmtGroup.First;
    finally
      objStmtGroup.EnableControls;
    end;
  end;
end;

function TFrmSFStatementDefine.tableNoByAlias(pAlias: String): Integer;
  var lBookmark: TBookmark;
begin
  Result := 0;

  if (objStmtTable.IsEmpty) then
    Exit;

  lBookmark := objStmtTable.Bookmark;
  objStmtTable.DisableControls;
  objStmtTable.DisableSync;
  try
    objStmtTable.First;
    while not(objStmtTable.Eof) do
    begin
      if (objStmtTable.FieldByName('TableAlias').AsString = pAlias) then
      begin
        Result := objStmtTable.FieldByName('TableNo').AsInteger;
        Break;
      end;

      objStmtTable.Next;
    end;
  finally
    objStmtTable.Bookmark := lBookmark;
    objStmtTable.EnableControls;
    objStmtTable.EnableSync;
  end;
end;

function TFrmSFStatementDefine.tableAliasByNo(pTableNo: Integer): String;
  var lBookmark: TBookmark;
begin
  Result := '';

  if (objStmtTable.IsEmpty) then
    Exit;

  lBookmark := objStmtTable.Bookmark;
  objStmtTable.DisableControls;
  objStmtTable.DisableSync;
  try
    objStmtTable.First;
    while not(objStmtTable.Eof) do
    begin
      if (objStmtTable.FieldByName('TableNo').AsInteger = pTableNo) then
      begin
        Result := objStmtTable.FieldByName('TableAlias').AsString;
        Break;
      end;

      objStmtTable.Next;
    end;
  finally
    objStmtTable.Bookmark := lBookmark;
    objStmtTable.EnableControls;
    objStmtTable.EnableSync;
  end;
end;


function TFrmSFStatementDefine.detectAttrDesc: String;
  var lBookmark: TBookmark;
      lIsSingle, lItemTypeValid: Boolean;
      lLastItemDesc: String;
      lItmCnt, lItemType: Integer;
begin
  Result := '';

  if (objStmtAttr.FieldByName('AttrName').AsString <> '') then
    Result := objStmtAttr.FieldByName('AttrName').AsString
  else if not(objStmtAttrItem.IsEmpty) then
  begin
    lLastItemDesc := '';
    lItmCnt := 0;

    objStmtAttrItem.DisableControls;
    lBookmark := objStmtAttrItem.Bookmark;
    try
      objStmtAttrItem.First;
      while not(objStmtAttrItem.Eof) do
      begin
        if (objStmtAttrItem.FieldByName('AttrTempId').AsInteger <> objStmtAttr.FieldByName('TempId').AsInteger) then
        begin
          objStmtAttrItem.Next;
          Continue;
        end;

        lLastItemDesc := '';
        lItemType := objStmtAttrItem.FieldByName('ItemType').AsInteger;
        lItemTypeValid := (lItemType >= Integer(Low(TSFStmtAttrItemType))) and
                          (lItemType <= Integer(High(TSFStmtAttrItemType)));

        if (lItemTypeValid) and (TSFStmtAttrItemType(lItemType) = stmtAttrItemTypeDbField) then
        begin
          if (objStmtAttrItem.FieldByName('ItemRefTableField').AsString = SFSTMTATTR_UNDEFINED) then
          begin
            if (objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger > 0) then
              lLastItemDesc := tableAliasByNo(objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger) + '.' + objStmtAttrItem.FieldByName('ItemRefTableField').AsString
            else
              lLastItemDesc := objStmtAttrItem.FieldByName('ItemRefTableField').AsString;
          end
          else if (objStmtAttrItem.FieldByName('ItemRefTableField').AsString <> '') then
          begin
            if (objStmtAttrItem.FieldByName('Aggr').AsString <> '') then
              lLastItemDesc := objStmtAttrItem.FieldByName('Aggr').AsString + '(' + objStmtAttrItem.FieldByName('ItemRefTableField').AsString + ')'
            else
              lLastItemDesc := objStmtAttrItem.FieldByName('ItemRefTableField').AsString;
          end;
        end else
          lLastItemDesc := objStmtAttrItem.FieldByName('ItemRefOther').AsString;

        inc(lItmCnt);
        objStmtAttrItem.Next;
      end;
    finally
      objStmtAttrItem.Bookmark := lBookmark;
      objStmtAttrItem.EnableControls;
    end;

    lIsSingle := (lItmCnt = 1);
    // description is the value-reference from a single item
    if (lIsSingle) and (lLastItemDesc <> '') then
      Result := lLastItemDesc;
  end;
end;

procedure TFrmSFStatementDefine.clearTableTreeView;
begin
  tvFrmStatementDefineTableStructure.Items.Clear;
end;

procedure TFrmSFStatementDefine.loadTableTreeView(pParentNode: TTreeNode; pParentNo: Integer);
  var lNode: TTreeNode;
      lBookmark: TBookmark;
begin
  if (objStmtTable.IsEmpty) then
    Exit;

  objStmtTable.First;
  while not(objStmtTable.Eof) do
  begin
    if (objStmtTable.FieldByName('ParentTableNo').AsInteger = pParentNo) then
    begin
      if (pParentNode = nil) then
        lNode := tvFrmStatementDefineTableStructure.Items.Add(nil, generateTableTreeDesc)
      else
        lNode := tvFrmStatementDefineTableStructure.Items.AddChild(pParentNode, generateTableTreeDesc);

      lNode.Data := Pointer(objStmtTable.FieldByName('TableNo').AsInteger);

      lBookmark := objStmtTable.Bookmark;
      try
        loadTableTreeView(lNode, objStmtTable.FieldByName('TableNo').AsInteger);
      finally
        objStmtTable.Bookmark := lBookmark;
      end;
    end;

    objStmtTable.Next;
  end;
end;

function TFrmSFStatementDefine.generateTableTreeDesc: String;
begin
  Result := objStmtTable.FieldByName('TableAlias').AsString;
  if (Boolean(objStmtTable.FieldByName('TableIsStmt').AsInteger)) then
    Result := Result + ' (' + objStmtTable.FieldByName('StmtName').AsString + ')'
  else
    Result := Result + ' (' + objStmtTable.FieldByName('TableName').AsString + ')';
end;

function TFrmSFStatementDefine.searchMaxTableNo: Integer;
  var lBookmark: TBookmark;
begin
  Result := 0;

  if (objStmtTable.IsEmpty) then
    Exit;

  lBookmark := objStmtTable.Bookmark;
  objStmtTable.DisableControls;
  objStmtTable.DisableSync;
  try
    objStmtTable.First;
    while not(objStmtTable.Eof) do
    begin
      if (objStmtTable.FieldByName('TableNo').AsInteger > Result) then
        Result := objStmtTable.FieldByName('TableNo').AsInteger;

      objStmtTable.Next;
    end;
  finally
    objStmtTable.Bookmark := lBookmark;
    objStmtTable.EnableControls;
    objStmtTable.EnableSync;
  end;
end;

function TFrmSFStatementDefine.searchMaxAttrId: Integer;
  var lBookmark: TBookmark;
begin
  Result := 0;

  if (objStmtAttr.IsEmpty) then
    Exit;

  lBookmark := objStmtAttr.Bookmark;
  objStmtAttr.DisableControls;
  objStmtAttr.DisableSync;
  try
    objStmtAttr.First;
    while not(objStmtAttr.Eof) do
    begin
      if (objStmtAttr.FieldByName('TempId').AsInteger > Result) then
        Result := objStmtAttr.FieldByName('TempId').AsInteger;

      objStmtAttr.Next;
    end;
  finally
    objStmtAttr.Bookmark := lBookmark;
    objStmtAttr.EnableControls;
    objStmtAttr.EnableSync;
  end;
end;

function TFrmSFStatementDefine.searchMaxCondId: Integer;
  var lBookmark: TBookmark;
begin
  Result := 0;

  if (objStmtCond.IsEmpty) then
    Exit;

  lBookmark := objStmtCond.Bookmark;
  objStmtCond.DisableControls;
  objStmtCond.DisableSync;
  try
    objStmtCond.First;
    while not(objStmtCond.Eof) do
    begin
      if (objStmtCond.FieldByName('TempId').AsInteger > Result) then
        Result := objStmtCond.FieldByName('TempId').AsInteger;

      objStmtCond.Next;
    end;
  finally
    objStmtCond.Bookmark := lBookmark;
    objStmtCond.EnableControls;
    objStmtCond.EnableSync;
  end;
end;

function TFrmSFStatementDefine.checkValueTypeForVal(pVal: String; pValType: Integer; pIsArray: Boolean): Boolean;
  var lVal: Variant;
begin
  Result := False;
  if (Assigned(mStmt)) and
    (pValType >= Integer(Low(TSFStmtValueType))) and
    (pValType <= Integer(High(TSFStmtValueType)))then
  begin
    lVal := pVal;
    Result := mStmt.ConvertValueInType(lVal, TSFStmtValueType(pValType), pIsArray);
  end;
end;

function TFrmSFStatementDefine.listGlobalStmtNames: TStringList;
  var i: Integer;
begin
  Result := TStringList.Create;

  for i := 0 to (Screen.FormCount - 1) do
  begin
    Screen.Forms[i];
    if not(csInline in TComponent(Screen.Forms[i]).ComponentState) then
      listComponentStmtNames(Screen.Forms[i], Result, Screen.Forms[i].Name);
  end;

  for i := 0 to Screen.DataModuleCount - 1 do
    listComponentStmtNames(Screen.DataModules[i], Result, Screen.DataModules[i].Name);
end;

procedure TFrmSFStatementDefine.listComponentStmtNames(pComponent: TComponent; pLst: TStringList; pNamePath: String);
  var i: Integer;
      lStmtName: String;
begin
  for i := 0 to (pComponent.ComponentCount - 1) do
  begin
    if (pComponent.Components[i] is TSFStmt) and (not(Assigned(mStmt)) or (mStmt <> pComponent.Components[i])) then
    begin
      lStmtName := pComponent.Components[i].ClassName;
      if (pComponent.Components[i].Name <> '') then
        lStmtName := pComponent.Components[i].Name;

      if (pNamePath <> '') then
        pLst.Add(pNamePath + '.' + lStmtName)
      else
        pLst.Add(lStmtName);
    end else
    if (pComponent.Components[i] is TSFBusinessData) or (pComponent.Components[i] is TSFBusinessDataWrap) then
    begin
      if (pNamePath <> '') then
        listComponentStmtNames(pComponent.Components[i], pLst, pNamePath + '.' + pComponent.Components[i].Name)
      else
        listComponentStmtNames(pComponent.Components[i], pLst, pComponent.Components[i].Name);
    end;
  end;
end;

procedure TFrmSFStatementDefine.configStmtRefLkpObj(pLkpObj: TSFBusinessData; pNotifyLkpFlds: Boolean);
  var lStmtRefLst: TStrings;
      lFreeLst: Boolean;
      i: Integer;
begin
  if (pLkpObj.Active) then
    pLkpObj.Close;

  pLkpObj.Fields.Clear;
  pLkpObj.AddField('StmtName', ftString, 255);
  pLkpObj.Open;

  lFreeLst := False;
  if (mStmtRefLst <> nil) then
    lStmtRefLst := mStmtRefLst
  else
  begin
    lStmtRefLst := listGlobalStmtNames;
    lFreeLst := True;
  end;

  for i := 0 to (lStmtRefLst.Count - 1) do
  begin
    pLkpObj.Append;
    pLkpObj.FieldByName('StmtName').AsString := lStmtRefLst[i];
    pLkpObj.Post;
  end;

  if (lFreeLst) then
    FreeAndNil(lStmtRefLst);

  if (pNotifyLkpFlds) then
  begin
    for i := 0 to (mStmtLkpFieldsNotify.Count - 1) do
      TField(mStmtLkpFieldsNotify[i]).RefreshLookupList;
  end;
end;

procedure TFrmSFStatementDefine.syncTablesLkp(pRefreshCurrent: Boolean);

  procedure confirmTableValues;
  begin
    objTablesLkp.FieldByName('TableNo').AsInteger := objStmtTable.FieldByName('TableNo').AsInteger;
    objTablesLkp.FieldByName('TableAlias').AsString := generateTableTreeDesc;;
  end;

  var lBookmark: TBookmark;
      i: Integer;
begin
  if (pRefreshCurrent) then
  begin
    if (objTablesLkp.Locate('TableNo', objStmtTable.FieldByName('TableNo').AsInteger, [])) then
    begin
      objTablesLkp.Edit;
      confirmTableValues;
      objTablesLkp.Post;
    end else
    begin
      objTablesLkp.Append;
      confirmTableValues;
      objTablesLkp.Post;
    end;
  end else
  begin
    reOpenDataObject(objTablesLkp);

    if (objStmtTable.IsEmpty) then
      Exit;

    lBookmark := objStmtTable.Bookmark;
    objStmtTable.DisableControls;
    objStmtTable.DisableSync;
    try
      objStmtTable.First;
      while not(objStmtTable.Eof) do
      begin
        objTablesLkp.Append;
        confirmTableValues;
        objTablesLkp.Post;

        objStmtTable.Next;
      end;
    finally
      objStmtTable.Bookmark := lBookmark;
      objStmtTable.EnableControls;
      objStmtTable.EnableSync;
    end;
  end;

  for i := 0 to (mTableLkpFieldsNotify.Count - 1) do
    TField(mTableLkpFieldsNotify[i]).RefreshLookupList;
end;

procedure TFrmSFStatementDefine.syncAttributesLkp(pRefreshCurrent: Boolean);

  procedure confirmAttributeValues;
  begin
    objAttributesLkp.FieldByName('AttrTempId').AsInteger := objStmtAttr.FieldByName('TempId').AsInteger;
    objAttributesLkp.FieldByName('AttrDesc').AsString := objStmtAttr.FieldByName('AttrResultName').AsString;
  end;

  var lBookmark: TBookmark;
      i: Integer;
begin
  if (pRefreshCurrent) then
  begin
    if (objAttributesLkp.Locate('AttrTempId', objStmtAttr.FieldByName('TempId').AsInteger, [])) then
    begin
      objAttributesLkp.Edit;
      confirmAttributeValues;
      objAttributesLkp.Post;
    end else
    begin
      objAttributesLkp.Append;
      confirmAttributeValues;
      objAttributesLkp.Post;
    end;
  end else
  begin
    reOpenDataObject(objAttributesLkp);

    if (objStmtAttr.IsEmpty) then
      Exit;

    lBookmark := objStmtAttr.Bookmark;
    objStmtAttr.DisableControls;
    objStmtAttr.DisableSync;
    try
      objStmtAttr.First;
      while not(objStmtAttr.Eof) do
      begin
        objAttributesLkp.Append;
        confirmAttributeValues;
        objAttributesLkp.Post;

        objStmtAttr.Next;
      end;
    finally
      objStmtAttr.Bookmark := lBookmark;
      objStmtAttr.EnableControls;
      objStmtAttr.EnableSync;
    end;
  end;

  for i := 0 to (mAttrLkpFieldsNotify.Count - 1) do
    TField(mAttrLkpFieldsNotify[i]).RefreshLookupList;
end;

procedure TFrmSFStatementDefine.createLkpField(pObj: TSFBusinessData; pFieldName: String;
        pFldType: TFieldType; pLkpDs: TDataSet; pKeyFlds, pLkpKeyFlds, pLkpRsltFld: String;
        pCached: Boolean; pSize, pPrecision: Integer);
  var lField: TField;
begin
  lField := pObj.AddField(pFieldName, pFldType, pSize, pPrecision);
  lField.FieldKind := fkLookup;
  lField.LookupDataSet := pLkpDs;
  lField.KeyFields := pKeyFlds;
  lField.LookupKeyFields := pLkpKeyFlds;
  lField.LookupResultField := pLkpRsltFld;
  lField.LookupCache := pCached;
end;

procedure TFrmSFStatementDefine.adjustAutoEditSources;
begin
  srcFrmStatementDefineStmt.AutoEdit := not(objStmt.IsEmpty);
  srcFrmStatementDefineTables.AutoEdit := not(objStmtTable.IsEmpty);
  srcFrmStatementDefineTableJoinDef.AutoEdit := srcFrmStatementDefineTables.AutoEdit and (objStmtTable.FieldByName('ParentTableNo').AsInteger > 0);
  srcFrmStatementDefineAttributes.AutoEdit := srcFrmStatementDefineTables.AutoEdit;
  srcFrmStatementDefineAttributeItems.AutoEdit := srcFrmStatementDefineAttributes.AutoEdit and not(objStmtAttr.IsEmpty);
  srcFrmStatementDefineConditions.AutoEdit := srcFrmStatementDefineTables.AutoEdit;
  srcFrmStatementDefineConditionExists.AutoEdit := srcFrmStatementDefineConditions.AutoEdit and not(objStmtCond.IsEmpty) and ((objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_EXISTS) or (objStmtCond.FieldByName('CondOperator').AsString = SFSTMT_OP_NOT_EXISTS));
  srcFrmStatementDefineAttributesOrder.AutoEdit := srcFrmStatementDefineTables.AutoEdit and not(objStmtAttr.IsEmpty);
  srcFrmStatementDefineAttributesGroup.AutoEdit := srcFrmStatementDefineAttributesOrder.AutoEdit;

  checkDataGridsReadOnly;
end;

procedure TFrmSFStatementDefine.checkDataGridsReadOnly;
begin
  checkDataGridReadOnly(grdFrmStatementDefineTableDetailJoinItems);
  checkDataGridReadOnly(grdFrmStatementDefineAttributes);
  checkDataGridReadOnly(grdFrmStatementDefineAttrDetail);
  checkDataGridReadOnly(grdFrmStatementDefineConditions);
  checkDataGridReadOnly(grdFrmStatementDefineConditionsExists);
  checkDataGridReadOnly(grdFrmStatementDefineOrder);
  checkDataGridReadOnly(grdFrmStatementDefineGroup);
end;

procedure TFrmSFStatementDefine.checkDataGridReadOnly(pGrd: TDBGrid);
begin
  pGrd.ReadOnly := not pGrd.DataSource.AutoEdit;
  if not(pGrd.ReadOnly) then
  begin
    pGrd.Options := pGrd.Options + [dgEditing];
  end else
    pGrd.Options := pGrd.Options - [dgEditing];
end;

procedure TFrmSFStatementDefine.createGridInplace(pGrd: TDBGrid; pFieldName: String; pParent: TWinControl);
  var lInplaceChk: TFrmSFStatementDefInplaceChk;
      i, lColIdx: Integer;
begin
  lColIdx := -1;
  for i := 0 to (pGrd.Columns.Count - 1) do
  begin
    if (pGrd.Columns.Items[i].FieldName = pFieldName) then
    begin
      lColIdx :=  i;
      Break;
    end;
  end;

  if (lColIdx >= 0) then
  begin
    lInplaceChk := TFrmSFStatementDefInplaceChk.Create(Self);
    lInplaceChk.SetParent(pParent);
    lInplaceChk.ValueChecked := '1';
    lInplaceChk.ValueUnchecked := '0';
    lInplaceChk.DataSource := pGrd.DataSource;
    lInplaceChk.DataField := pFieldName;
    lInplaceChk.DBGrid := pGrd;
    lInplaceChk.ColIdx := lColIdx;
  end;
end;

procedure TFrmSFStatementDefine.fillCboStmtNames(pCbo: TDBComboBox);
  var lTempDS: TSFBusinessData;
begin
  pCbo.Items.Clear;

  lTempDS := TSFBusinessData.Create;
  try
    configStmtRefLkpObj(lTempDS, False);

    if not(lTempDS.IsEmpty) then
    begin
      lTempDS.First;
      while not(lTempDS.Eof) do
      begin
        pCbo.Items.Add(lTempDS.FieldByName('StmtName').AsString);
        lTempDS.Next
      end;
    end;
  finally
    FreeAndNil(lTempDS);
  end;
end;

procedure TFrmSFStatementDefine.checkControlsForTable;
  var lIsBaseTable: Boolean;
begin
  if not(objStmtTable.IsEmpty) then
  begin
    cboFrmStatementDefineTableDetailStmt.Visible := Boolean(objStmtTable.FieldByName('TableIsStmt').AsInteger);
    txtFrmStatementDefineTableDetailName.Visible := not(cboFrmStatementDefineTableDetailStmt.Visible);

    lIsBaseTable := (objStmtTable.FieldByName('ParentTableNo').AsInteger <= 0);

    cboFrmStatementDefineTableDetailJoinType.ReadOnly := lIsBaseTable;
    chkFrmStatementDefineTableDetailIsStmt.ReadOnly := lIsBaseTable and not(mCanModifyBaseTable);
    cboFrmStatementDefineTableDetailStmt.ReadOnly := chkFrmStatementDefineTableDetailIsStmt.ReadOnly;
    txtFrmStatementDefineTableDetailName.ReadOnly := chkFrmStatementDefineTableDetailIsStmt.ReadOnly;
  end;
end;

procedure TFrmSFStatementDefine.validateConditions;
  var lLastType: TSFStmtConditionType;
      lDelCurrent: Boolean;
      lCntOpen, lCntClose: Integer;
begin
  objStmtCond.DisableControls;
  try
    if not(objStmtCond.IsEmpty) then
    begin
      // 1. validate previous type for each condition
      lLastType := stmtCondTypeAnd;

      objStmtCond.First;
      while not(objStmtCond.Eof) do
      begin
        lDelCurrent := False;
        case TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) of
          stmtCondTypeAnd, stmtCondTypeOr, stmtCondTypeClose:
            begin
              lDelCurrent := (lLastType in [stmtCondTypeAnd, stmtCondTypeOr, stmtCondTypeOpen]);
            end;
        end;

        if (lDelCurrent) then
        begin
          objStmtCond.Delete;
          Continue;
        end;

        lLastType := TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger);
        objStmtCond.Next;
      end;
    end;

    if not(objStmtCond.IsEmpty) then
    begin
      // 2. validate last condition
      objStmtCond.Last;
      if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) in [stmtCondTypeAnd, stmtCondTypeOr, stmtCondTypeOpen]) then
        objStmtCond.Delete;
    end;

    if not(objStmtCond.IsEmpty) then
    begin
      // 3. check brackets
      lCntOpen := 0;
      lCntClose := 0;
      objStmtCond.First;
      while not(objStmtCond.Eof) do
      begin
        if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeOpen) then
          inc(lCntOpen)
        else if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeClose) then
          inc(lCntClose);

        objStmtCond.Next;
      end;

      if (lCntOpen <> lCntClose) then
      begin
        if (lCntOpen > lCntClose) then
        begin
          objStmtCond.First;
          while not(objStmtCond.Eof) do
          begin
            if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeOpen) then
            begin
              objStmtCond.Delete;
              dec(lCntOpen);
            end else
              objStmtCond.Next;

            if (lCntOpen = lCntClose) then
              Break;
          end;
        end else
        begin
          objStmtCond.Last;
          while not(objStmtCond.Bof) do
          begin
            if (TSFStmtConditionType(objStmtCond.FieldByName('CondType').AsInteger) = stmtCondTypeClose) then
            begin
              objStmtCond.Delete;
              dec(lCntClose);
            end else
              objStmtCond.Prior;

            if (lCntOpen = lCntClose) then
              Break;
          end;
        end;
      end;
    end;

    if not(objStmtCond.IsEmpty) then
      objStmtCond.First;
  finally
    objStmtCond.EnableControls;
  end;
end;

procedure TFrmSFStatementDefine.handlePostError;
begin
  raise Exception.Create('There is an logic error in your definition');
end;

procedure TFrmSFStatementDefine.deleteTableByTreeNode(pTreeNode: TTreeNode);
  var i, lDelTableNo: Integer;
begin
  if (pTreeNode.HasChildren) then
  begin
    for i := 0 to (pTreeNode.Count - 1) do
      deleteTableByTreeNode(pTreeNode.Item[i]);
  end;

  lDelTableNo := Integer(pTreeNode.Data);
  if (lDelTableNo <= 0) then
    Exit;

  if (objStmtTable.FieldByName('TableNo').AsInteger <> lDelTableNo) then
    objStmtTable.Locate('TableNo', lDelTableNo, []);

  if (objStmtTable.FieldByName('TableNo').AsInteger = lDelTableNo) then
    objStmtTable.Delete;
end;

function TFrmSFStatementDefine.exportToXmlDoc: IXmlDocument;
  var lStmtXML: TSFStmtXML;
begin
  Result := TSFStmtXML.CreateDocument;

  if (objStmt.IsEmpty) then
    Exit;

  objStmt.CheckBrowseMode;

  lStmtXML := TSFStmtXML(Result.DocumentElement);
  lStmtXML.UseDistinct := Boolean(objStmt.FieldByName('UseDistinct').AsInteger);
  lStmtXML.QuoteType := objStmt.FieldByName('QuoteType').AsInteger;
  lStmtXML.AutoEscapeLike := Boolean(objStmt.FieldByName('AutoEscapeLike').AsInteger);
  lStmtXML.DBDialect := objStmt.FieldByName('DBDialect').AsInteger;
  lStmtXML.LikeEscapeChar := objStmt.FieldByName('LikeEscapeChar').AsString;
  lStmtXML.Union := objStmt.FieldByName('Union').AsString;

  exportTablesXML(lStmtXML);
  exportAttrsXML(lStmtXML);
  exportCondsXML(lStmtXML);
  exportOrdersAndGroupsXML(lStmtXML);
end;

function TFrmSFStatementDefine.exportToXmlStr: String;
  var lStmtTemp: TSFStmt;
      lXmlDoc: IXmlDocument;
begin
  lStmtTemp := TSFStmt.Create(nil);
  try
    lXmlDoc := exportToXmlDoc;
    try
      lStmtTemp.LoadFromXmlDoc(lXmlDoc, False);
      lStmtTemp.SaveToXmlStr(Result);
    finally
      lXmlDoc := nil;
    end;
  finally
    FreeAndNil(lStmtTemp);
  end;
end;

procedure TFrmSFStatementDefine.exportTablesXML(pXmlStmt: TSFStmtXML);
  var lBookmark: TBookmark;
      lCurrParentId, lMaxTableNo, i: Integer;
      lCurrTable: TSFStmtTableXML;
      lCurrRelation: TSFStmtTableRelationXML;
      lXmlTables: Array of TSFStmtTableXML;
begin
  if (objStmtTable.IsEmpty) then
    Exit;

  lBookmark := objStmtTable.Bookmark;
  objStmtTable.DisableControls;
  try
    lCurrParentId := 0;
    lMaxTableNo := searchMaxTableNo;
    SetLength(lXmlTables, lMaxTableNo + 1);
    for i := Low(lXmlTables) to High(lXmlTables) do
      lXmlTables[i] := nil;

    while (lCurrParentId <= lMaxTableNo) do
    begin
      lCurrTable := lXmlTables[lCurrParentId];

      objStmtTable.First;
      while not(objStmtTable.Eof) do
      begin
        if (objStmtTable.FieldByName('ParentTableNo').AsInteger = lCurrParentId) then
        begin
          if (lCurrTable <> nil) then
          begin
            lCurrRelation := TSFStmtTableRelationXML(lCurrTable.Relations.AddItem);
            lXmlTables[objStmtTable.FieldByName('TableNo').AsInteger] := lCurrRelation.DestTable;
            exportTableXML(lCurrRelation.DestTable, lCurrRelation);
          end else
          begin
            lXmlTables[objStmtTable.FieldByName('TableNo').AsInteger] := pXmlStmt.BaseTable;
            exportTableXML(pXmlStmt.BaseTable, nil);
          end;
        end;

        objStmtTable.Next;
      end;

      inc(lCurrParentId);
    end;
  finally
    objStmtTable.Bookmark := lBookmark;
    objStmtTable.EnableControls;
  end;
end;

procedure TFrmSFStatementDefine.exportTableXML(pXmlTable: TSFStmtTableXML; pXmlRelation: TSFStmtTableRelationXML);
  var lBookmark: TBookmark;
      lRelItemXML: TSFStmtTableRelationItemXML;
begin
  pXmlTable.TableNo := objStmtTable.FieldByName('TableNo').AsInteger;
  pXmlTable.TableAlias := objStmtTable.FieldByName('TableAlias').AsString;
  pXmlTable.StmtName := objStmtTable.FieldByName('StmtName').AsString;
  pXmlTable.TableIsStmt := Boolean(objStmtTable.FieldByName('TableIsStmt').AsInteger);
  pXmlTable.TableName := objStmtTable.FieldByName('TableName').AsString;
  pXmlTable.Schema := objStmtTable.FieldByName('Schema').AsString;
  pXmlTable.Catalog := objStmtTable.FieldByName('Catalog').AsString;

  if (pXmlRelation <> nil) then
  begin
    pXmlRelation.ParentTableJoinType := objStmtTable.FieldByName('ParentTableJoinType').AsInteger;

    if not(objStmtTableRel.IsEmpty) then
    begin
      lBookmark := objStmtTableRel.Bookmark;
      objStmtTableRel.DisableControls;
      try
        objStmtTableRel.First;
        while not(objStmtTableRel.Eof) do
        begin
          lRelItemXML := TSFStmtTableRelationItemXML(pXmlRelation.RelationItems.AddItem);

          lRelItemXML.SrcType := objStmtTableRel.FieldByName('SrcType').AsInteger;
          lRelItemXML.SrcValue := objStmtTableRel.FieldByName('SrcValue').AsString;
          lRelItemXML.SrcValueType := objStmtTableRel.FieldByName('SrcValueType').AsInteger;
          lRelItemXML.DestType := objStmtTableRel.FieldByName('DestType').AsInteger;
          lRelItemXML.DestValue := objStmtTableRel.FieldByName('DestValue').AsString;
          lRelItemXML.DestValueType := objStmtTableRel.FieldByName('DestValueType').AsInteger;

          objStmtTableRel.Next;
        end;
      finally
        objStmtTableRel.Bookmark := lBookmark;
        objStmtTableRel.EnableControls;
      end;
    end;
  end;
end;

procedure TFrmSFStatementDefine.exportAttrsXML(pXmlStmt: TSFStmtXML);
  var lBookmark, lBookmarkItm: TBookmark;
      lAttrXML: TSFStmtAttrXML;
      lAttrItemXML: TSFStmtAttrItemXML;
begin
  if (objStmtAttr.IsEmpty) then
    Exit;

  lBookmark := objStmtAttr.Bookmark;
  objStmtAttr.DisableControls;
  try
    objStmtAttr.First;
    while not(objStmtAttr.Eof) do
    begin
      lAttrXML := TSFStmtAttrXML(pXmlStmt.Attrs.AddItem);
      lAttrXML.AttrIdx := objStmtAttr.FieldByName('TempId').AsInteger - 1;
      lAttrXML.AttrName := objStmtAttr.FieldByName('AttrName').AsString;
      lAttrXML.OnlyForSearch := Boolean(objStmtAttr.FieldByName('OnlyForSearch').AsInteger);

      if not(objStmtAttrItem.IsEmpty) then
      begin
        lBookmarkItm := objStmtAttrItem.Bookmark;
        objStmtAttrItem.DisableControls;
        try
          objStmtAttrItem.First;
          while not(objStmtAttrItem.Eof) do
          begin
            lAttrItemXML := TSFStmtAttrItemXML(lAttrXML.AttrItems.AddItem);
            lAttrItemXML.Aggr := objStmtAttrItem.FieldByName('Aggr').AsString;
            lAttrItemXML.ItemType := objStmtAttrItem.FieldByName('ItemType').AsInteger;
            lAttrItemXML.ItemRefTableAlias := tableAliasByNo(objStmtAttrItem.FieldByName('ItemRefTableNo').AsInteger);
            lAttrItemXML.ItemRefTableField := objStmtAttrItem.FieldByName('ItemRefTableField').AsString;
            lAttrItemXML.ItemRefStmtName := objStmtAttrItem.FieldByName('ItemRefStmtName').AsString;
            lAttrItemXML.ItemRefOther := objStmtAttrItem.FieldByName('ItemRefOther').AsString;
            lAttrItemXML.ItemRefValueType := objStmtAttrItem.FieldByName('ItemRefValueType').AsInteger;

            objStmtAttrItem.Next;
          end;
        finally
          objStmtAttrItem.Bookmark := lBookmarkItm;
          objStmtAttrItem.EnableControls;
        end;
      end;
      objStmtAttr.Next;
    end;
  finally
    objStmtAttr.Bookmark := lBookmark;
    objStmtAttr.EnableControls;
  end;
end;

procedure TFrmSFStatementDefine.exportCondsXML(pXmlStmt: TSFStmtXML);
  var lBookmark, lBookmarkExists: TBookmark;
      lCondXML: TSFStmtCondXML;
      lRelItemXML: TSFStmtTableRelationItemXML;
begin
  if (objStmtCond.IsEmpty) then
    Exit;

  lBookmark := objStmtCond.Bookmark;
  objStmtCond.DisableControls;
  try
    objStmtCond.First;
    while not(objStmtCond.Eof) do
    begin
      lCondXML := TSFStmtCondXML(pXmlStmt.Conds.AddItem);
      lCondXML.CondType := objStmtCond.FieldByName('CondType').AsInteger;
      lCondXML.CondOperator := objStmtCond.FieldByName('CondOperator').AsString;
      if (objStmtCond.FieldByName('AttrTempId').AsInteger > 0) then
        lCondXML.AttrIdx := objStmtCond.FieldByName('AttrTempId').AsInteger - 1;
      if (objStmtCond.FieldByName('DestAttrTempId').AsInteger > 0) then
        lCondXML.DestAttrIdx := objStmtCond.FieldByName('DestAttrTempId').AsInteger - 1;
      lCondXML.DestValue := objStmtCond.FieldByName('DestValue').AsString;
      if (objStmtCond.FieldByName('DestValueIsArray').AsInteger > 0) then
        lCondXML.DestValueIsArray := True;
      lCondXML.DestValueType := objStmtCond.FieldByName('DestValueType').AsInteger;
      if (objStmtCond.FieldByName('IsRestriction').AsInteger > 0) then
        lCondXML.IsRestriction := True;
      lCondXML.ExistsTableAliasFrom := tableAliasByNo(objStmtCond.FieldByName('ExistsTableAliasFrom').AsInteger);
      lCondXML.ExistsDestRefStmtName := objStmtCond.FieldByName('ExistsDestRefStmtName').AsString;
      lCondXML.ExistsDestRefStmtTableAlias := objStmtCond.FieldByName('ExistsDestRefStmtTableAlias').AsString;

      if not(objStmtCondExists.IsEmpty) then
      begin
        lBookmarkExists := objStmtCondExists.Bookmark;
        objStmtCondExists.DisableControls;
        try
          objStmtCondExists.First;
          while not(objStmtCondExists.Eof) do
          begin
            lRelItemXML := TSFStmtTableRelationItemXML(lCondXML.ExistsRelation.AddItem);
            lRelItemXML.SrcType := objStmtCondExists.FieldByName('SrcType').AsInteger;
            lRelItemXML.SrcValue := objStmtCondExists.FieldByName('SrcValue').AsString;
            lRelItemXML.SrcValueType := objStmtCondExists.FieldByName('SrcValueType').AsInteger;
            lRelItemXML.DestType := objStmtCondExists.FieldByName('DestType').AsInteger;
            lRelItemXML.DestValue := objStmtCondExists.FieldByName('DestValue').AsString;
            lRelItemXML.DestValueType := objStmtCondExists.FieldByName('DestValueType').AsInteger;

            objStmtCondExists.Next;
          end;
        finally
          objStmtCondExists.Bookmark := lBookmarkExists;
          objStmtCondExists.EnableControls;
        end;
      end;

      objStmtCond.Next;
    end;
  finally
    objStmtCond.Bookmark := lBookmark;
    objStmtCond.EnableControls;
  end;
end;

procedure TFrmSFStatementDefine.exportOrdersAndGroupsXML(pXmlStmt: TSFStmtXML);
  var lBookmark: TBookmark;
      lOrderXML: TSFStmtOrderXML;
      lGroupXML: TSFStmtGroupXML;
begin
  if not(objStmtOrder.IsEmpty) then
  begin
    lBookmark := objStmtOrder.Bookmark;
    objStmtOrder.DisableControls;
    try
      objStmtOrder.First;
      while not(objStmtOrder.Eof) do
      begin
        lOrderXML := TSFStmtOrderXML(pXmlStmt.Orders.AddItem);
        lOrderXML.AttrIdx := objStmtOrder.FieldByName('AttrTempId').AsInteger - 1;
        lOrderXML.OrderType := objStmtOrder.FieldByName('SortType').AsInteger;

        objStmtOrder.Next;
      end;
    finally
      objStmtOrder.Bookmark := lBookmark;
      objStmtOrder.EnableControls;
    end;
  end;

  if not(objStmtGroup.IsEmpty) then
  begin
    lBookmark := objStmtGroup.Bookmark;
    objStmtGroup.DisableControls;
    try
      objStmtGroup.First;
      while not(objStmtGroup.Eof) do
      begin
        lGroupXML := TSFStmtGroupXML(pXmlStmt.Groups.AddItem);
        lGroupXML.AttrIdx := objStmtGroup.FieldByName('AttrTempId').AsInteger - 1;

        objStmtGroup.Next;
      end;
    finally
      objStmtGroup.Bookmark := lBookmark;
      objStmtGroup.EnableControls;
    end;
  end;
end;

//============================================================================//
//                setter/getter for internal dataobjects                      //
//============================================================================//

function TFrmSFStatementDefine.getObjStmt: TSFBusinessData;
begin
  if not(Assigned(mObjStmt)) then
  begin
    mObjStmt := TSFBusinessData.Create;
    mObjStmt.AddField('UseDistinct', ftInteger, 0);
    mObjStmt.AddField('QuoteType', ftInteger, 0);
    mObjStmt.AddField('AutoEscapeLike', ftInteger, 0);
    mObjStmt.AddField('DBDialect', ftInteger, 0);
    mObjStmt.AddField('LikeEscapeChar', ftString, 1);
    mObjStmt.AddField('Union', ftString, 255);

    mObjStmt.Open;
  end;

  Result := mObjStmt;
end;

function TFrmSFStatementDefine.getObjStmtTable: TSFBusinessData;
begin
  if not(Assigned(mObjStmtTable)) then
  begin
    mObjStmtTable := TSFBusinessData.Create;

    mObjStmtTable.AddField('TableNo', ftInteger, 0, 0, True);
    mObjStmtTable.AddField('TableAlias', ftString, 4, 0, True);
    mObjStmtTable.AddField('StmtName', ftString, 255);
    mObjStmtTable.AddField('TableIsStmt', ftInteger, 0);
    mObjStmtTable.AddField('TableName', ftString, 255);
    mObjStmtTable.AddField('Schema', ftString, 255);
    mObjStmtTable.AddField('Catalog', ftString, 255);
    mObjStmtTable.AddField('ParentTableNo', ftInteger, 0);
    mObjStmtTable.AddField('ParentTableJoinType', ftInteger, 0);

    mObjStmtTable.Open;

    mObjStmtTable.AfterScroll := objStmtTableAfterScroll;
    mObjStmtTable.BeforeDelete := objStmtTableBeforeDelete;
    mObjStmtTable.OnFieldChange := objStmtTableFieldChanged;
    mObjStmtTable.AfterPost := objStmtTableAfterPost;
  end;

  Result := mObjStmtTable;
end;

function TFrmSFStatementDefine.getObjStmtTableRel: TSFBusinessData;
begin
  if not(Assigned(mObjStmtTableRel)) then
  begin
    mObjStmtTableRel := TSFBusinessData.Create;

    mObjStmtTableRel.AddField('TableNoFrom', ftInteger, 0, 0, True);
    mObjStmtTableRel.AddField('TableNoTo', ftInteger, 0, 0, True);
    mObjStmtTableRel.AddField('SrcType', ftInteger, 0);
    mObjStmtTableRel.AddField('SrcValue', ftString, 255);
    mObjStmtTableRel.AddField('SrcValueType', ftInteger, 0);
    mObjStmtTableRel.AddField('DestType', ftInteger, 0);
    mObjStmtTableRel.AddField('DestValue', ftString, 255);
    mObjStmtTableRel.AddField('DestValueType', ftInteger, 0);

    createLkpField(mObjStmtTableRel, 'SrcTypeDesc', ftString, objRelItemTypeLkp,
                  'SrcType', 'RITId', 'RITDesc', True, 20, 0);
    createLkpField(mObjStmtTableRel, 'SrcValueTypeDesc', ftString, objValueDataTypeLkp,
                  'SrcValueType', 'VDTId', 'VDTDesc', True, 20, 0);
    createLkpField(mObjStmtTableRel, 'DestTypeDesc', ftString, objRelItemTypeLkp,
                  'DestType', 'RITId', 'RITDesc', True, 20, 0);
    createLkpField(mObjStmtTableRel, 'DestValueTypeDesc', ftString, objValueDataTypeLkp,
                  'DestValueType', 'VDTId', 'VDTDesc', True, 20, 0);

    mObjStmtTableRel.Open;

    mObjStmtTableRel.OnFilterRecord := objStmtTableRelFilterRecord;
    mObjStmtTableRel.OnFieldChange := objStmtTableRelFieldChanged;
    mObjStmtTableRel.OnRecordChange := objStmtTableRelRecChanged;
    mObjStmtTableRel.AfterInsert := objStmtTableRelAfterInsert;
    mObjStmtTableRel.BeforePost := objStmtTableRelBeforePost;
  end;

  Result := mObjStmtTableRel;
end;

function TFrmSFStatementDefine.getObjStmtAttr: TSFBusinessData;
begin
  if not(Assigned(mObjStmtAttr)) then
  begin
    mObjStmtAttr := TSFBusinessData.Create;
    mObjStmtAttr.AddField('TempId', ftInteger, 0);
    mObjStmtAttr.AddField('AttrName', ftString, 255);
    mObjStmtAttr.AddField('AttrResultName', ftString, 255);
    mObjStmtAttr.AddField('OnlyForSearch', ftInteger, 0);

    mObjStmtAttr.Open;

    mObjStmtAttr.AfterScroll := objStmtAttrAfterScroll;
    mObjStmtAttr.BeforeDelete := objStmtAttrBeforeDelete;
    mObjStmtAttr.AfterInsert := objStmtAttrAfterInsert;
    mObjStmtAttr.BeforePost := objStmtAttrBeforePost;
    mObjStmtAttr.AfterPost := objStmtAttrAfterPost;
  end;

  Result := mObjStmtAttr;
end;

function TFrmSFStatementDefine.getObjStmtAttrItem: TSFBusinessData;
begin
  if not(Assigned(mObjStmtAttrItem)) then
  begin
    mObjStmtAttrItem := TSFBusinessData.Create;
    mObjStmtAttrItem.AddField('AttrTempId', ftInteger, 0);
    mObjStmtAttrItem.AddField('Aggr', ftString, 30);
    mObjStmtAttrItem.AddField('ItemType', ftInteger, 0);
    mObjStmtAttrItem.AddField('ItemRefTableNo', ftInteger, 0);
    mObjStmtAttrItem.AddField('ItemRefTableField', ftString, 255);
    mObjStmtAttrItem.AddField('ItemRefStmtName', ftString, 255);
    mObjStmtAttrItem.AddField('ItemRefOther', ftString, 255);
    mObjStmtAttrItem.AddField('ItemRefValueType', ftInteger, 0);

    createLkpField(mObjStmtAttrItem, 'AggrDesc', ftString, objAggregateLkp,
                  'Aggr', 'AggrDesc', 'AggrDesc', True, 10, 0);
    createLkpField(mObjStmtAttrItem, 'ItemTypeDesc', ftString, objAttrItemTypeLkp,
                  'ItemType', 'AITId', 'AITDesc', True, 20, 0);
    createLkpField(mObjStmtAttrItem, 'ItemRefTableNoDesc', ftString, objTablesLkp,
                  'ItemRefTableNo', 'TableNo', 'TableAlias', True, 255, 0);
    createLkpField(mObjStmtAttrItem, 'ItemRefStmtNameDesc', ftString, objStmtRefLkpCached,
                  'ItemRefStmtName', 'StmtName', 'StmtName', True, 255, 0);
    createLkpField(mObjStmtAttrItem, 'ItemRefValueTypeDesc', ftString, objValueDataTypeLkp,
                  'ItemRefValueType', 'VDTId', 'VDTDesc', True, 20, 0);

    mTableLkpFieldsNotify.Add(mObjStmtAttrItem.FieldByName('ItemRefTableNoDesc'));
    mStmtLkpFieldsNotify.Add(mObjStmtAttrItem.FieldByName('ItemRefStmtNameDesc'));

    mObjStmtAttrItem.Open;

    mObjStmtAttrItem.OnFilterRecord := objStmtAttrItemFilterRecord;
    mObjStmtAttrItem.OnFieldChange := objStmtAttrItemFieldChanged;
    mObjStmtAttrItem.OnRecordChange := objStmtAttrItemRecChanged;
    mObjStmtAttrItem.AfterInsert := objStmtAttrItemAfterInsert;
    mObjStmtAttrItem.BeforePost := objStmtAttrItemBeforePost;
    mObjStmtAttrItem.AfterPost := objStmtAttrItemAfterPost;
  end;

  Result := mObjStmtAttrItem;
end;

function TFrmSFStatementDefine.getObjStmtCond: TSFBusinessData;
begin
  if not(Assigned(mObjStmtCond)) then
  begin
    mObjStmtCond := TSFBusinessData.Create;
    mObjStmtCond.AddField('TempId', ftInteger, 0);
    mObjStmtCond.AddField('CondType', ftInteger, 0);
    mObjStmtCond.AddField('CondOperator', ftString, 10);
    mObjStmtCond.AddField('AttrTempId', ftInteger, 0);
    mObjStmtCond.AddField('DestAttrTempId', ftInteger, 0);
    mObjStmtCond.AddField('DestValue', ftString, 255);
    mObjStmtCond.AddField('DestValueType', ftInteger, 0);
    mObjStmtCond.AddField('DestValueIsArray', ftInteger, 0);
    mObjStmtCond.AddField('IsRestriction', ftInteger, 0);
    mObjStmtCond.AddField('ExistsTableAliasFrom', ftInteger, 0);
    mObjStmtCond.AddField('ExistsDestRefStmtName', ftString, 255);
    mObjStmtCond.AddField('ExistsDestRefStmtTableAlias', ftString, 4);

    createLkpField(mObjStmtCond, 'CondTypeDesc', ftString, objCondTypeLkp,
                  'CondType', 'CTId', 'CTDesc', True, 20, 0);
    createLkpField(mObjStmtCond, 'CondOperatorDesc', ftString, objCondOpLkp,
                  'CondOperator', 'OPDesc', 'OPDesc', True, 15, 0);
    createLkpField(mObjStmtCond, 'AttrTempIdDesc', ftString, objAttributesLkp,
                  'AttrTempId', 'AttrTempId', 'AttrDesc', True, 255, 0);
    createLkpField(mObjStmtCond, 'DestAttrTempIdDesc', ftString, objAttributesLkp,
                  'DestAttrTempId', 'AttrTempId', 'AttrDesc', True, 255, 0);
    createLkpField(mObjStmtCond, 'DestValueTypeDesc', ftString, objValueDataTypeLkp,
                  'DestValueType', 'VDTId', 'VDTDesc', True, 20, 0);
    createLkpField(mObjStmtCond, 'ExistsDestRefStmtNameDesc', ftString, objStmtRefLkpCached,
                  'ExistsDestRefStmtName', 'StmtName', 'StmtName', True, 255, 0);
    createLkpField(mObjStmtCond, 'ExistsTableAliasFromDesc', ftString, objTablesLkp,
                  'ExistsTableAliasFrom', 'TableNo', 'TableAlias', True, 255, 0);

    mAttrLkpFieldsNotify.Add(mObjStmtCond.FieldByName('AttrTempIdDesc'));
    mAttrLkpFieldsNotify.Add(mObjStmtCond.FieldByName('DestAttrTempIdDesc'));
    mTableLkpFieldsNotify.Add(mObjStmtCond.FieldByName('ExistsTableAliasFromDesc'));
    mStmtLkpFieldsNotify.Add(mObjStmtCond.FieldByName('ExistsDestRefStmtNameDesc'));

    mObjStmtCond.Open;

    mObjStmtCond.AfterScroll := objStmtCondAfterScroll;
    mObjStmtCond.BeforeDelete := objStmtCondBeforeDelete;
    mObjStmtCond.OnFieldChange := objStmtCondFieldChanged;
    mObjStmtCond.OnRecordChange := objStmtCondRecChanged;
    mObjStmtCond.AfterInsert := objStmtCondAfterInsert;
    mObjStmtCond.BeforePost := objStmtCondBeforePost;
  end;

  Result := mObjStmtCond;
end;

function TFrmSFStatementDefine.getObjStmtCondExists: TSFBusinessData;
begin
  if not(Assigned(mObjStmtCondExists)) then
  begin
    mObjStmtCondExists := TSFBusinessData.Create;
    mObjStmtCondExists.AddField('TempId', ftInteger, 0);
    mObjStmtCondExists.AddField('SrcType', ftInteger, 0);
    mObjStmtCondExists.AddField('SrcValue', ftString, 255);
    mObjStmtCondExists.AddField('SrcValueType', ftInteger, 0);
    mObjStmtCondExists.AddField('DestType', ftInteger, 0);
    mObjStmtCondExists.AddField('DestValue', ftString, 255);
    mObjStmtCondExists.AddField('DestValueType', ftInteger, 0);

    createLkpField(mObjStmtCondExists, 'SrcTypeDesc', ftString, objRelItemTypeLkp,
                  'SrcType', 'RITId', 'RITDesc', True, 20, 0);
    createLkpField(mObjStmtCondExists, 'SrcValueTypeDesc', ftString, objValueDataTypeLkp,
                  'SrcValueType', 'VDTId', 'VDTDesc', True, 20, 0);
    createLkpField(mObjStmtCondExists, 'DestTypeDesc', ftString, objRelItemTypeLkp,
                  'DestType', 'RITId', 'RITDesc', True, 20, 0);
    createLkpField(mObjStmtCondExists, 'DestValueTypeDesc', ftString, objValueDataTypeLkp,
                  'DestValueType', 'VDTId', 'VDTDesc', True, 20, 0);

    mObjStmtCondExists.Open;

    mObjStmtCondExists.OnFilterRecord := objStmtCondExistsFilterRecord;
    mObjStmtCondExists.OnFieldChange := objStmtCondExistsFieldChanged;
    mObjStmtCondExists.OnRecordChange := objStmtCondExistsRecChanged;
    mObjStmtCondExists.AfterInsert := objStmtCondExistsAfterInsert;
    mObjStmtCondExists.BeforePost := objStmtCondExistsBeforePost;
  end;

  Result := mObjStmtCondExists;
end;

function TFrmSFStatementDefine.getObjStmtOrder: TSFBusinessData;
begin
  if not(Assigned(mObjStmtOrder)) then
  begin
    mObjStmtOrder := TSFBusinessData.Create;
    mObjStmtOrder.AddField('AttrTempId', ftInteger, 0);
    mObjStmtOrder.AddField('SortType', ftInteger, 0);

    createLkpField(mObjStmtOrder, 'AttrTempIdDesc', ftString, objAttributesLkp,
                  'AttrTempId', 'AttrTempId', 'AttrDesc', True, 255, 0);
    createLkpField(mObjStmtOrder, 'SortTypeDesc', ftString, objOrderTypeLkp,
                  'SortType', 'OTId', 'OTDesc', True, 20, 0);

    mAttrLkpFieldsNotify.Add(mObjStmtOrder.FieldByName('AttrTempIdDesc'));

    mObjStmtOrder.Open;

    mObjStmtOrder.AfterInsert := objStmtOrderAfterInsert;
    mObjStmtOrder.BeforePost := objStmtOrderBeforePost;
  end;

  Result := mObjStmtOrder;
end;

function TFrmSFStatementDefine.getObjStmtGroup: TSFBusinessData;
begin
  if not(Assigned(mObjStmtGroup)) then
  begin
    mObjStmtGroup := TSFBusinessData.Create;
    mObjStmtGroup.AddField('AttrTempId', ftInteger, 0);

    createLkpField(mObjStmtGroup, 'AttrTempIdDesc', ftString, objAttributesLkp,
                  'AttrTempId', 'AttrTempId', 'AttrDesc', True, 255, 0);

    mAttrLkpFieldsNotify.Add(mObjStmtGroup.FieldByName('AttrTempIdDesc'));

    mObjStmtGroup.Open;
  end;

  Result := mObjStmtGroup;
end;

//============================================================================//
//                    setter/getter for lookupobjects                         //
//============================================================================//

function TFrmSFStatementDefine.getObjQuoteTypeLkp: TSFBusinessData;
  var i: TSFStmtQuoteType;
begin
  if not(Assigned(mObjQuoteTypeLkp)) then
  begin
    mObjQuoteTypeLkp := TSFBusinessData.Create;
    mObjQuoteTypeLkp.AddField('QTId', ftInteger, 0);
    mObjQuoteTypeLkp.AddField('QTDesc', ftString, 20);
    mObjQuoteTypeLkp.Open;

    for i := Low(TSFStmtQuoteType) to High(TSFStmtQuoteType) do
    begin
      mObjQuoteTypeLkp.Append;
      mObjQuoteTypeLkp.FieldByName('QTId').AsInteger := Integer(i);
      mObjQuoteTypeLkp.FieldByName('QTDesc').AsString := STMTDEFDESC_QUOTES[i];
      mObjQuoteTypeLkp.Post;
    end;
  end;

  Result := mObjQuoteTypeLkp;
end;

function TFrmSFStatementDefine.getObjDialectLkp: TSFBusinessData;
  var i: TSFStmtDBDialect;
begin
  if not(Assigned(mObjDialectLkp)) then
  begin
    mObjDialectLkp := TSFBusinessData.Create;
    mObjDialectLkp.AddField('DId', ftInteger, 0);
    mObjDialectLkp.AddField('DDesc', ftString, 20);
    mObjDialectLkp.Open;

    for i := Low(TSFStmtDBDialect) to High(TSFStmtDBDialect) do
    begin
      mObjDialectLkp.Append;
      mObjDialectLkp.FieldByName('DId').AsInteger := Integer(i);
      mObjDialectLkp.FieldByName('DDesc').AsString := STMTDEFDESC_DIALECTS[i];
      mObjDialectLkp.Post;
    end;
  end;

  Result := mObjDialectLkp;
end;

function TFrmSFStatementDefine.getObjStmtRefLkpCached: TSFBusinessData;
begin
  if not(Assigned(mObjStmtRefLkpCached)) then
  begin
    mObjStmtRefLkpCached := TSFBusinessData.Create;
    configStmtRefLkpObj(mObjStmtRefLkpCached, True);
  end;

  Result := mObjStmtRefLkpCached;
end;

function TFrmSFStatementDefine.getObjJoinTypeLkp: TSFBusinessData;
  var i: TSFStmtJoinType;
begin
  if not(Assigned(mObjJoinTypeLkp)) then
  begin
    mObjJoinTypeLkp := TSFBusinessData.Create;
    mObjJoinTypeLkp.AddField('JTId', ftInteger, 0);
    mObjJoinTypeLkp.AddField('JTDesc', ftString, 20);
    mObjJoinTypeLkp.Open;

    for i := Low(TSFStmtJoinType) to High(TSFStmtJoinType) do
    begin
      mObjJoinTypeLkp.Append;
      mObjJoinTypeLkp.FieldByName('JTId').AsInteger := Integer(i);
      mObjJoinTypeLkp.FieldByName('JTDesc').AsString := STMTDEFDESC_JOINTYPES[i];
      mObjJoinTypeLkp.Post;
    end;
  end;

  Result := mObjJoinTypeLkp;
end;

function TFrmSFStatementDefine.getObjRelItemTypeLkp: TSFBusinessData;
  var i: TSFStmtJoinRelItemType;
begin
  if not(Assigned(mObjRelItemTypeLkp)) then
  begin
    mObjRelItemTypeLkp := TSFBusinessData.Create;
    mObjRelItemTypeLkp.AddField('RITId', ftInteger, 0);
    mObjRelItemTypeLkp.AddField('RITDesc', ftString, 20);
    mObjRelItemTypeLkp.Open;

    for i := Low(TSFStmtJoinRelItemType) to High(TSFStmtJoinRelItemType) do
    begin
      mObjRelItemTypeLkp.Append;
      mObjRelItemTypeLkp.FieldByName('RITId').AsInteger := Integer(i);
      mObjRelItemTypeLkp.FieldByName('RITDesc').AsString := STMTDEFDESC_RELITEMTYPES[i];
      mObjRelItemTypeLkp.Post;
    end;
  end;

  Result := mObjRelItemTypeLkp;
end;

function TFrmSFStatementDefine.getObjValueDataTypeLkp: TSFBusinessData;
  var i: TSFStmtValueType;
begin
  if not(Assigned(mObjValueDataTypeLkp)) then
  begin
    mObjValueDataTypeLkp := TSFBusinessData.Create;
    mObjValueDataTypeLkp.AddField('VDTId', ftInteger, 0);
    mObjValueDataTypeLkp.AddField('VDTDesc', ftString, 20);
    mObjValueDataTypeLkp.Open;

    for i := Low(TSFStmtValueType) to High(TSFStmtValueType) do
    begin
      mObjValueDataTypeLkp.Append;
      mObjValueDataTypeLkp.FieldByName('VDTId').AsInteger := Integer(i);
      mObjValueDataTypeLkp.FieldByName('VDTDesc').AsString := STMTDEFDESC_VALTYPES[i];
      mObjValueDataTypeLkp.Post;
    end;
  end;

  Result := mObjValueDataTypeLkp;
end;

function TFrmSFStatementDefine.getObjAttrItemTypeLkp: TSFBusinessData;
  var i: TSFStmtAttrItemType;
begin
  if not(Assigned(mObjAttrItemTypeLkp)) then
  begin
    mObjAttrItemTypeLkp := TSFBusinessData.Create;
    mObjAttrItemTypeLkp.AddField('AITId', ftInteger, 0);
    mObjAttrItemTypeLkp.AddField('AITDesc', ftString, 20);
    mObjAttrItemTypeLkp.Open;

    for i := Low(TSFStmtAttrItemType) to High(TSFStmtAttrItemType) do
    begin
      mObjAttrItemTypeLkp.Append;
      mObjAttrItemTypeLkp.FieldByName('AITId').AsInteger := Integer(i);
      mObjAttrItemTypeLkp.FieldByName('AITDesc').AsString := STMTDEFDESC_ATTRITEMTYPES[i];
      mObjAttrItemTypeLkp.Post;
    end;
  end;

  Result := mObjAttrItemTypeLkp;
end;

function TFrmSFStatementDefine.getObjAggregateLkp: TSFBusinessData;
begin
  if not(Assigned(mObjAggregateLkp)) then
  begin
    mObjAggregateLkp := TSFBusinessData.Create;
    mObjAggregateLkp.AddField('AggrDesc', ftString, 10);
    mObjAggregateLkp.Open;

    mObjAggregateLkp.Append;
    mObjAggregateLkp.FieldByName('AggrDesc').AsString := SFSTMTAGGR_COUNT;
    mObjAggregateLkp.Post;

    mObjAggregateLkp.Append;
    mObjAggregateLkp.FieldByName('AggrDesc').AsString := SFSTMTAGGR_MIN;
    mObjAggregateLkp.Post;

    mObjAggregateLkp.Append;
    mObjAggregateLkp.FieldByName('AggrDesc').AsString := SFSTMTAGGR_MAX;
    mObjAggregateLkp.Post;

    mObjAggregateLkp.Append;
    mObjAggregateLkp.FieldByName('AggrDesc').AsString := SFSTMTAGGR_AVG;
    mObjAggregateLkp.Post;

    mObjAggregateLkp.Append;
    mObjAggregateLkp.FieldByName('AggrDesc').AsString := SFSTMTAGGR_SUM;
    mObjAggregateLkp.Post;
  end;

  Result := mObjAggregateLkp;
end;

function TFrmSFStatementDefine.getObjCondTypeLkp: TSFBusinessData;
  var i: TSFStmtConditionType;
begin
  if not(Assigned(mObjCondTypeLkp)) then
  begin
    mObjCondTypeLkp := TSFBusinessData.Create;
    mObjCondTypeLkp.AddField('CTId', ftInteger, 0);
    mObjCondTypeLkp.AddField('CTDesc', ftString, 20);
    mObjCondTypeLkp.Open;

    for i := Low(TSFStmtConditionType) to High(TSFStmtConditionType) do
    begin
      mObjCondTypeLkp.Append;
      mObjCondTypeLkp.FieldByName('CTId').AsInteger := Integer(i);
      mObjCondTypeLkp.FieldByName('CTDesc').AsString := STMTDEFDESC_CONDTYPES[i];
      mObjCondTypeLkp.Post;
    end;
  end;

  Result := mObjCondTypeLkp;
end;

function TFrmSFStatementDefine.getObjCondOpLkp: TSFBusinessData;
begin
  if not(Assigned(mObjCondOpLkp)) then
  begin
    mObjCondOpLkp := TSFBusinessData.Create;
    mObjCondOpLkp.AddField('OpDesc', ftString, 15);
    mObjCondOpLkp.Open;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_EQUAL;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_NOTEQUAL;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_LESSEQUAL;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_GREATEREQUAL;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_LESS;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_GREATER;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_LIKE;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_NOT_LIKE;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_IN;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_NOT_IN;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_EXISTS;
    mObjCondOpLkp.Post;

    mObjCondOpLkp.Append;
    mObjCondOpLkp.FieldByName('OpDesc').AsString := SFSTMT_OP_NOT_EXISTS;
    mObjCondOpLkp.Post;
  end;

  Result := mObjCondOpLkp;
end;

function TFrmSFStatementDefine.getObjOrderTypeLkp: TSFBusinessData;
  var i: TSFStmtSortType;
begin
  if not(Assigned(mObjOrderTypeLkp)) then
  begin
    mObjOrderTypeLkp := TSFBusinessData.Create;
    mObjOrderTypeLkp.AddField('OTId', ftInteger, 0);
    mObjOrderTypeLkp.AddField('OTDesc', ftString, 20);
    mObjOrderTypeLkp.Open;

    for i := Low(TSFStmtSortType) to High(TSFStmtSortType) do
    begin
      mObjOrderTypeLkp.Append;
      mObjOrderTypeLkp.FieldByName('OTId').AsInteger := Integer(i);
      mObjOrderTypeLkp.FieldByName('OTDesc').AsString := STMTDEFDESC_SORTTYPES[i];
      mObjOrderTypeLkp.Post;
    end;
  end;

  Result := mObjOrderTypeLkp;
end;

function TFrmSFStatementDefine.getObjAttributesLkp: TSFBusinessData;
begin
  if not(Assigned(mObjAttributesLkp)) then
  begin
    mObjAttributesLkp := TSFBusinessData.Create;
    mObjAttributesLkp.AddField('AttrTempId', ftInteger, 0);
    mObjAttributesLkp.AddField('AttrDesc', ftString, 255);
    mObjAttributesLkp.Open;
  end;

  Result := mObjAttributesLkp;
end;

function TFrmSFStatementDefine.getObjTablesLkp: TSFBusinessData;
begin
  if not(Assigned(mObjTablesLkp)) then
  begin
    mObjTablesLkp := TSFBusinessData.Create;
    mObjTablesLkp.AddField('TableNo', ftInteger, 0);
    mObjTablesLkp.AddField('TableAlias', ftString, 255);
    mObjTablesLkp.Open;
  end;

  Result := mObjTablesLkp;
end;

//============================================================================//
//                    setter/getter for properties                            //
//============================================================================//

procedure TFrmSFStatementDefine.setStmt(pStmt: TSFStmt);
  var lStmtXML: IXMLDocument;
begin
  if (pStmt <> mStmt) then
  begin
    mStmt := pStmt;
    reOpenDataObjects;
    clearTableTreeView;

    fillCboStmtNames(cboFrmStatementDefineGeneralUnion);
    fillCboStmtNames(cboFrmStatementDefineTableDetailStmt);
    if (Assigned(mObjStmtRefLkpCached)) then
      configStmtRefLkpObj(mObjStmtRefLkpCached, True);

    if (mStmt <> nil) then
    begin
      lStmtXML := mStmt.SaveToXmlDoc;
      try
        if (lStmtXML.DocumentElement is TSFStmtXML) then
          loadObjects(TSFStmtXML(lStmtXML.DocumentElement));
      finally
        lStmtXML := nil;
      end;

      objStmtTable.DisableControls;
      objStmtTable.DisableSync;
      try
        loadTableTreeView;
      finally
        objStmtTable.EnableControls;
        objStmtTable.EnableSync;
      end;
      if (tvFrmStatementDefineTableStructure.Items.Count > 0) then
        tvFrmStatementDefineTableStructure.Items[0].Selected := True;
    end;
  end;
end;

procedure TFrmSFStatementDefine.setStmtRefLst(pLst: TStrings);
begin
  if (pLst <> mStmtRefLst) then
  begin
    mStmtRefLst := pLst;

    fillCboStmtNames(cboFrmStatementDefineGeneralUnion);
    fillCboStmtNames(cboFrmStatementDefineTableDetailStmt);
    if (Assigned(mObjStmtRefLkpCached)) then
      configStmtRefLkpObj(mObjStmtRefLkpCached, True);
  end;
end;

procedure TFrmSFStatementDefine.setCanModifyBaseTable(pCanModify: Boolean);
begin
  if (pCanModify <> mCanModifyBaseTable) then
  begin
    mCanModifyBaseTable := pCanModify;

    checkControlsForTable;
  end;
end;

//============================================================================//
//                      TFrmSFStatementDefInplaceChk                          //
//============================================================================//

constructor TFrmSFStatementDefInplaceChk.Create(pOwner: TComponent);
begin
  inherited;

  mDBGrid := nil;
  mColumnIdx := -1;
  mGrdDrawColCellSave := nil;
end;

destructor TFrmSFStatementDefInplaceChk.Destroy;
begin
  inherited;

  if (Assigned(mDBGrid)) then
  begin
    mDBGrid.OnDrawColumnCell := mGrdDrawColCellSave;
    mDBGrid := nil;
  end;
end;

procedure TFrmSFStatementDefInplaceChk.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (Assigned(mDBGrid)) and (AComponent = mDBGrid) then
    mDBGrid := nil;
end;

procedure TFrmSFStatementDefInplaceChk.DoExit;
begin
  inherited;

  if (Assigned(mDBGrid)) then
  begin
    Visible := False;
    if not(mDBGrid.Focused) and (Assigned(mDBGrid.OnExit)) then
      mDBGrid.OnExit(mDBGrid);
  end;
end;

procedure TFrmSFStatementDefInplaceChk.grdDrawColumnCell(Sender: TObject;
    const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  const
    LC_CHECKSIZE = 15;
  var
    lInplaceRect, lCellRect: TRect;
    lGrdExitSave: TNotifyEvent;
    lHandled: Boolean;
begin
  inherited;

  if not(Assigned(mDBGrid)) then
    Exit;

  lHandled := False;
  if (Assigned(mGrdDrawColCellSave)) then
  begin
    mGrdDrawColCellSave(Sender, Rect, DataCol, Column, State);
    lHandled := True;
  end;

  if (Assigned(DataSource)) and (DataSource = mDBGrid.DataSource)
    and (Assigned(DataSource.DataSet)) and (DataCol = mColumnIdx) then
  begin
    if (mDBGrid.Focused) and (gdSelected in State) and
      ((DataSource.AutoEdit) or (DataSource.DataSet.State in [dsEdit, dsInsert])) then
    begin
      lInplaceRect := Rect;
      lInplaceRect.Left := mDBGrid.Left + lInplaceRect.Left;
      lInplaceRect.Top := mDBGrid.Top + lInplaceRect.Top;
      lInplaceRect.Right := mDBGrid.Left + lInplaceRect.Right;
      lInplaceRect.Bottom := mDBGrid.Top + lInplaceRect.Bottom;

      Width := LC_CHECKSIZE;
      Height := LC_CHECKSIZE;
      Left := lInplaceRect.Left + ((lInplaceRect.Right - lInplaceRect.Left - LC_CHECKSIZE) div 2) + 2;
      Top := lInplaceRect.Top + ((lInplaceRect.Bottom - lInplaceRect.Top - LC_CHECKSIZE) div 2) + 2;
      Checked := (DataSource.DataSet.FieldByName(Column.FieldName).AsString = ValueChecked);
      Visible := True;
      BringToFront;

      lGrdExitSave := mDBGrid.OnExit;
      mDBGrid.OnExit := nil;
      try
        SetFocus;
      finally
        mDBGrid.OnExit := lGrdExitSave;
      end;
    end else
    begin
      lCellRect := Rect;
      lCellRect.Top := lCellRect.Top + ((lCellRect.Bottom - lCellRect.Top - LC_CHECKSIZE) div 2);
      lCellRect.Bottom := lCellRect.Top + LC_CHECKSIZE;
      lCellRect.Left := lCellRect.Left + ((lCellRect.Right - lCellRect.Left - LC_CHECKSIZE) div 2);
      lCellRect.Right := lCellRect.Left + LC_CHECKSIZE;
      if (DataSource.DataSet.FieldByName(Column.FieldName).AsString = ValueChecked) then
        DrawFrameControl(mDBGrid.Canvas.Handle, lCellRect, DFC_BUTTON, DFCS_CHECKED)
      else
        DrawFrameControl(mDBGrid.Canvas.Handle, lCellRect, DFC_BUTTON, DFCS_BUTTONCHECK);
    end;
    if (mDBGrid.SelectedIndex = mColumnIdx) and (dgEditing in mDBGrid.Options) then
      mDBGrid.Options := mDBGrid.Options - [dgEditing];
  end else
  if not(lHandled) then
  begin
    mDBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    if not(mDBGrid.Columns.Items[mDBGrid.SelectedIndex].ReadOnly) and
      ((mColumnIdx < 0 ) or (mDBGrid.SelectedIndex < 0) or (mDBGrid.SelectedIndex <> mColumnIdx)) and
      (Assigned(DataSource)) and (DataSource.AutoEdit) and not(dgEditing in mDBGrid.Options) then
    begin
      mDBGrid.Options := mDBGrid.Options + [dgEditing];
    end;
  end;
end;

procedure TFrmSFStatementDefInplaceChk.setDBGrid(pVal: TDBGrid);
begin
  if (pVal <> mDBGrid) then
  begin
    if (Assigned(mDBGrid)) then
    begin
      mDBGrid.OnDrawColumnCell := mGrdDrawColCellSave;
      mDBGrid.RemoveFreeNotification(Self);
    end;

    mDBGrid := pVal;
    mGrdDrawColCellSave := mDBGrid.OnDrawColumnCell;
    mDBGrid.OnDrawColumnCell := grdDrawColumnCell;
    mDBGrid.FreeNotification(Self);

    Visible := False;

    if (mColumnIdx > -1) then
      mDBGrid.Invalidate;
  end;
end;

procedure TFrmSFStatementDefInplaceChk.setColumnIdx(pVal: Integer);
begin
  if (pVal <> mColumnIdx) then
  begin
    mColumnIdx := pVal;

    Visible := False;

    if (Assigned(mDBGrid)) then
      mDBGrid.Invalidate;
  end;
end;

end.
