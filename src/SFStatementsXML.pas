//
//   Title:         SFStatementsXML;
//
//   Description:   xml classes to reference a query builder
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFStatementsXML;

interface

uses Xml.XMLDoc, Xml.XMLIntf, Xml.Xmldom, System.Classes, System.Variants;

type
  TSFStmtXML = class;
  TSFStmtTableXML = class;
  TSFStmtTableRelationsXML = class;
  TSFStmtTableRelationXML = class;
  TSFStmtTableRelationItemsXML = class;
  TSFStmtTableRelationItemXML = class;
  TSFStmtAttrsXML = class;
  TSFStmtAttrXML = class;
  TSFStmtAttrItemsXML = class;
  TSFStmtAttrItemXML = class;
  TSFStmtCondsXML = class;
  TSFStmtCondXML = class;
  TSFStmtOrdersXML = class;
  TSFStmtOrderXML = class;
  TSFStmtGroupsXML = class;
  TSFStmtGroupXML = class;

  TSFStmtXMLNode = class(TXMLNode)
    protected
      function GetChildNodeByTag(pTag: String): IXmlNode;
      function GetChildValByTag(pTag: String): Variant;
      procedure SetChildValByTag(pTag: String; pVal: Variant);
    public
      class function GetTagName: String; virtual; abstract;
  end;

  TSFStmtXMLNodeList = class(TSFStmtXMLNode)
    private
      function getItem(pIdx: Integer): TSFStmtXMLNode;
    public
      function AddItem: TSFStmtXMLNode; virtual; abstract;
      function Count: Integer;
    public
      property Item[pIdx: Integer]: TSFStmtXMLNode read getItem;
  end;

  TSFStmtXML = class(TSFStmtXMLNode)
    private
      mBaseTable: TSFStmtTableXML;
      mAttrs: TSFStmtAttrsXML;
      mConds: TSFStmtCondsXML;
      mOrders: TSFStmtOrdersXML;
      mGroups: TSFStmtGroupsXML;
    private
      function getBaseTable: TSFStmtTableXML;
      function getAttrs: TSFStmtAttrsXML;
      function getConds: TSFStmtCondsXML;
      function getOrders: TSFStmtOrdersXML;
      function getGroups: TSFStmtGroupsXML;
      procedure notifyBaseTable(pBaseTable: TSFStmtTableXML);
      procedure notifyAttrs(pAttrs: TSFStmtAttrsXML);
      procedure notifyConds(pConds: TSFStmtCondsXML);
      procedure notifyOrders(pOrders: TSFStmtOrdersXML);
      procedure notifyGroups(pGroups: TSFStmtGroupsXML);
      function getUseDistinct: Boolean;
      function getQuoteType: Integer;
      function getAutoEscapeLike: Boolean;
      function getDBDialect: Integer;
      function getLikeEscapeChar: String;
      function getUnion: String;
      procedure setUseDistinct(pVal: Boolean);
      procedure setQuoteType(pVal: Integer);
      procedure setAutoEscapeLike(pVal: Boolean);
      procedure setDBDialect(pVal: Integer);
      procedure setLikeEscapeChar(pVal: String);
      procedure setUnion(pVal: String);
    public
      procedure AfterConstruction; override;
      function HasBaseTable: Boolean;
      function HasAttrs: Boolean;
      function HasConds: Boolean;
      function HasOrders: Boolean;
      function HasGroups: Boolean;
    public
      class function GetTagName: String; override;
      class function CreateDocument(pOptions: TXMLDocOptions = []): IXMLDocument;
      class function LoadDocumentFromStr(pXmlStr: String): IXMLDocument;
    public
      property UseDistinct: Boolean read getUseDistinct write setUseDistinct;
      property QuoteType: Integer read getQuoteType write setQuoteType;
      property AutoEscapeLike: Boolean read getAutoEscapeLike write setAutoEscapeLike;
      property DBDialect: Integer read getDBDialect write setDBDialect;
      property LikeEscapeChar: String read getLikeEscapeChar write setLikeEscapeChar;
      property Union: String read getUnion write setUnion;
      property BaseTable: TSFStmtTableXML read getBaseTable;
      property Attrs: TSFStmtAttrsXML read getAttrs;
      property Conds: TSFStmtCondsXML read getConds;
      property Orders: TSFStmtOrdersXML read getOrders;
      property Groups: TSFStmtGroupsXML read getGroups;
  end;

  TSFStmtTableXML = class(TSFStmtXMLNode)
    private
      mRelations: TSFStmtTableRelationsXML;
    private
      function getTableNo: Integer;
      function getTableAlias: String;
      function getStmtName: String;
      function getTableIsStmt: Boolean;
      function getTableName: String;
      function getSchema: String;
      function getCatalog: String;
      procedure setTableNo(pVal: Integer);
      procedure setTableAlias(pVal: String);
      procedure setStmtName(pVal: String);
      procedure setTableIsStmt(pVal: Boolean);
      procedure setTableName(pVal: String);
      procedure setSchema(pVal: String);
      procedure setCatalog(pVal: String);
      function getRelations: TSFStmtTableRelationsXML;
      procedure notifyRelations(pRelations: TSFStmtTableRelationsXML);
    public
      procedure AfterConstruction; override;
      function HasRelations: Boolean;
    public
      class function GetTagName: String; override;
    public
      property TableNo: Integer read getTableNo write setTableNo;
      property TableAlias: String read getTableAlias write setTableAlias;
      property StmtName: String read getStmtName write setStmtName;
      property TableIsStmt: Boolean read getTableIsStmt write setTableIsStmt;
      property TableName: String read getTableName write setTableName;
      property Schema: String read getSchema write setSchema;
      property Catalog: String read getCatalog write setCatalog;
      property Relations: TSFStmtTableRelationsXML read getRelations;
  end;

  TSFStmtTableRelationsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtTableRelationXML = class(TSFStmtXMLNode)
    private
      mDestTable: TSFStmtTableXML;
      mRelationItems: TSFStmtTableRelationItemsXML;
    private
      function getParentTableJoinType: Integer;
      procedure setParentTableJoinType(pVal: Integer);
      function getRelationItems: TSFStmtTableRelationItemsXML;
      procedure notifyRelationItems(pRelItems: TSFStmtTableRelationItemsXML);
      function getDestTable: TSFStmtTableXML;
      procedure notifyDestTable(pDestTable: TSFStmtTableXML);
    public
      procedure AfterConstruction; override;
      function HasRelationItems: Boolean;
      function HasDestTable: Boolean;
    public
      class function GetTagName: String; override;
    public
      property ParentTableJoinType: Integer read getParentTableJoinType write setParentTableJoinType;
      property DestTable: TSFStmtTableXML read getDestTable;
      property RelationItems: TSFStmtTableRelationItemsXML read getRelationItems;
  end;

  TSFStmtTableRelationItemsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtTableRelationItemXML = class(TSFStmtXMLNode)
    private
      function getSrcType: Integer;
      function getSrcValue: String;
      function getSrcValueType: Integer;
      function getDestType: Integer;
      function getDestValue: String;
      function getDestValueType: Integer;
      procedure setSrcType(pVal: Integer);
      procedure setSrcValue(pVal: String);
      procedure setSrcValueType(pVal: Integer);
      procedure setDestType(pVal: Integer);
      procedure setDestValue(pVal: String);
      procedure setDestValueType(pVal: Integer);
    public
      class function GetTagName: String; override;
    public
      property SrcType: Integer read getSrcType write setSrcType;
      property SrcValue: String read getSrcValue write setSrcValue;
      property SrcValueType: Integer read getSrcValueType write setSrcValueType;
      property DestType: Integer read getDestType write setDestType;
      property DestValue: String read getDestValue write setDestValue;
      property DestValueType: Integer read getDestValueType write setDestValueType;
  end;

  TSFStmtAttrsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtAttrXML = class(TSFStmtXMLNode)
    private
      mAttrItems: TSFStmtAttrItemsXML;
    private
      function getAttrIdx: Integer;
      function getAttrName: String;
      function getOnlyForSearch: Boolean;
      function getAttrItems: TSFStmtAttrItemsXML;
      procedure setAttrIdx(pVal: Integer);
      procedure setAttrName(pVal: String);
      procedure setOnlyForSearch(pVal: Boolean);
      procedure notifyAttrItems(pAttrItems: TSFStmtAttrItemsXML);
    public
      procedure AfterConstruction; override;
      function HasAttrItems: Boolean;
    public
      class function GetTagName: String; override;
    public
      property AttrIdx: Integer read getAttrIdx write setAttrIdx;
      property AttrName: String read getAttrName write setAttrName;
      property OnlyForSearch: Boolean read getOnlyForSearch write setOnlyForSearch;
      property AttrItems: TSFStmtAttrItemsXML read getAttrItems;
  end;

  TSFStmtAttrItemsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtAttrItemXML = class(TSFStmtXMLNode)
    private
      function getAggr: String;
      function getItemType: Integer;
      function getItemRefTableAlias: String;
      function getItemRefTableField: String;
      function getItemRefStmtName: String;
      function getItemRefOther: String;
      function getItemRefValueType: Integer;
      procedure setAggr(pVal: String);
      procedure setItemType(pVal: Integer);
      procedure setItemRefTableAlias(pVal: String);
      procedure setItemRefTableField(pVal: String);
      procedure setItemRefStmtName(pVal: String);
      procedure setItemRefOther(pVal: String);
      procedure setItemRefValueType(pVal: Integer);
    public
      class function GetTagName: String; override;
    public
      property Aggr: String read getAggr write setAggr;
      property ItemType: Integer read getItemType write setItemType;
      property ItemRefTableAlias: String read getItemRefTableAlias write setItemRefTableAlias;
      property ItemRefTableField: String read getItemRefTableField write setItemRefTableField;
      property ItemRefStmtName: String read getItemRefStmtName write setItemRefStmtName;
      property ItemRefOther: String read getItemRefOther write setItemRefOther;
      property ItemRefValueType: Integer read getItemRefValueType write setItemRefValueType;
  end;

  TSFStmtCondsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtCondXML = class(TSFStmtXMLNode)
    private
      mExistsRelation: TSFStmtTableRelationItemsXML;
    private
      function getCondType: Integer;
      function getCondOperator: String;
      function getAttrIdx: Integer;
      function getDestAttrIdx: Integer;
      function getDestValue: String;
      function getDestValueIsArray: Boolean;
      function getDestValueType: Integer;
      function getIsRestriction: Boolean;
      function getExistsTableAliasFrom: String;
      function getExistsDestRefStmtName: String;
      function getExistsDestRefStmtTableAlias: String;
      function getExistsRelation: TSFStmtTableRelationItemsXML;
      procedure setCondType(pVal: Integer);
      procedure setCondOperator(pVal: String);
      procedure setAttrIdx(pVal: Integer);
      procedure setDestAttrIdx(pVal: Integer);
      procedure setDestValue(pVal: String);
      procedure setDestValueIsArray(pVal: Boolean);
      procedure setDestValueType(pVal: Integer);
      procedure setIsRestriction(pVal: Boolean);
      procedure setExistsTableAliasFrom(pVal: String);
      procedure setExistsDestRefStmtName(pVal: String);
      procedure setExistsDestRefStmtTableAlias(pVal: String);
      procedure notifyExistsRelation(pExistsRel: TSFStmtTableRelationItemsXML);
    public
      procedure AfterConstruction; override;
      function HasExistsRelationItems: Boolean;
    public
      class function GetTagName: String; override;
    public
      property CondType: Integer read getCondType write setCondType;
      property CondOperator: String read getCondOperator write setCondOperator;
      property AttrIdx: Integer read getAttrIdx write setAttrIdx;
      property DestAttrIdx: Integer read getDestAttrIdx write setDestAttrIdx;
      property DestValue: String read getDestValue write setDestValue;
      property DestValueIsArray: Boolean read getDestValueIsArray write setDestValueIsArray;
      property DestValueType: Integer read getDestValueType write setDestValueType;
      property IsRestriction: Boolean read getIsRestriction write setIsRestriction;
      property ExistsTableAliasFrom: String read getExistsTableAliasFrom write setExistsTableAliasFrom;
      property ExistsDestRefStmtName: String read getExistsDestRefStmtName write setExistsDestRefStmtName;
      property ExistsDestRefStmtTableAlias: String read getExistsDestRefStmtTableAlias write setExistsDestRefStmtTableAlias;
      property ExistsRelation: TSFStmtTableRelationItemsXML read getExistsRelation;
  end;

  TSFStmtOrdersXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtOrderXML = class(TSFStmtXMLNode)
    private
      function getAttrIdx: Integer;
      function getOrderType: Integer;
      procedure setAttrIdx(pVal: Integer);
      procedure setOrderType(pVal: Integer);
    public
      class function GetTagName: String; override;
    public
      property AttrIdx: Integer read getAttrIdx write setAttrIdx;
      property OrderType: Integer read getOrderType write setOrderType;
  end;

  TSFStmtGroupsXML = class(TSFStmtXMLNodeList)
    public
      procedure AfterConstruction; override;
    public
      class function GetTagName: String; override;
      function AddItem: TSFStmtXMLNode; override;
  end;

  TSFStmtGroupXML = class(TSFStmtXMLNode)
    private
      function getAttrIdx: Integer;
      procedure setAttrIdx(pVal: Integer);
    public
      class function GetTagName: String; override;
    public
      property AttrIdx: Integer read getAttrIdx write setAttrIdx;
  end;

implementation

uses System.SysUtils;

//============================================================================//
//                            TSFStmtXMLNode                                  //
//============================================================================//

function TSFStmtXMLNode.GetChildNodeByTag(pTag: String): IXmlNode;
  var i: Integer;
begin
  if (Assigned(ChildNodes)) then
  begin
    for i := 0 to (ChildNodes.Count - 1) do
    begin
      Result := ChildNodes.Nodes[i];
      if (AnsiCompareText(Result.NodeName, pTag) = 0) then
        Exit;
    end;
  end;

  Result := nil;
end;

function TSFStmtXMLNode.GetChildValByTag(pTag: String): Variant;
  var lNode: IXmlNode;
begin
  Result := NULL;

  lNode := GetChildNodeByTag(pTag);
  if (Assigned(lNode)) and not(VarIsNull(lNode.NodeValue)) then
    Result := lNode.NodeValue;
end;

procedure TSFStmtXMLNode.SetChildValByTag(pTag: String; pVal: Variant);
  var lNode: IXmlNode;
begin
  lNode := GetChildNodeByTag(pTag);
  if not(Assigned(lNode)) then
    lNode := AddChild(pTag);

  lNode.NodeValue := pVal;
end;

//============================================================================//
//                          TSFStmtXMLNodeList                                //
//============================================================================//

function TSFStmtXMLNodeList.getItem(pIdx: Integer): TSFStmtXMLNode;
begin
  Result := nil;

  if (pIdx >= 0) and (Count > pIdx) then
    Result := TSFStmtXMLNode(ChildNodes[pIdx]);
end;

function TSFStmtXMLNodeList.Count: Integer;
begin
  Result := ChildNodes.Count;
end;

//============================================================================//
//                              TSFStmtXML                                    //
//============================================================================//

const
  STMT_TAGNAME = 'STATEMENTDEFINITION';
  STMTPROP_USEDISTINCT = 'UseDistinct';
  STMTPROP_QUOTETYPE = 'QuoteType';
  STMTPROP_AUTOESCAPELIKE = 'AutoEscapeLike';
  STMTPROP_LIKEESCAPECHAR = 'LikeEscapeChar';
  STMTPROP_DBDIALECT = 'DBDialect';
  STMTPROP_UNION = 'Union';

procedure TSFStmtXML.AfterConstruction;
begin
  inherited;

  mBaseTable := nil;
  mAttrs := nil;
  mConds := nil;
  mOrders := nil;
  mGroups := nil;

  RegisterChildNode(TSFStmtTableXML.GetTagName, TSFStmtTableXML);
  RegisterChildNode(TSFStmtAttrsXML.GetTagName, TSFStmtAttrsXML);
  RegisterChildNode(TSFStmtCondsXML.GetTagName, TSFStmtCondsXML);
  RegisterChildNode(TSFStmtOrdersXML.GetTagName, TSFStmtOrdersXML);
  RegisterChildNode(TSFStmtGroupsXML.GetTagName, TSFStmtGroupsXML);

  // init childnodes
  ChildNodes;
end;

class function TSFStmtXML.GetTagName: String;
begin
  Result := STMT_TAGNAME;
end;

class function TSFStmtXML.CreateDocument(pOptions: TXMLDocOptions = []): IXMLDocument;
begin
  Result := NewXMLDocument;
  Result.Options := Result.Options + pOptions;
  Result.Encoding := 'UTF-8';
  Result.Version := '1.0';

  Result.GetDocBinding(TSFStmtXML.GetTagName, TSFStmtXML);
end;

class function TSFStmtXML.LoadDocumentFromStr(pXmlStr: String): IXMLDocument;
begin
  Result := LoadXMLData(pXmlStr);
  Result.GetDocBinding(TSFStmtXML.GetTagName, TSFStmtXML);
end;

function TSFStmtXML.HasBaseTable: Boolean;
begin
  Result := Assigned(mBaseTable);
end;

function TSFStmtXML.HasAttrs: Boolean;
begin
  Result := Assigned(mAttrs);
end;

function TSFStmtXML.HasConds: Boolean;
begin
  Result := Assigned(mConds);
end;

function TSFStmtXML.HasOrders: Boolean;
begin
  Result := Assigned(mOrders);
end;

function TSFStmtXML.HasGroups: Boolean;
begin
  Result := Assigned(mGroups);
end;

function TSFStmtXML.getBaseTable: TSFStmtTableXML;
begin
  if not(Assigned(mBaseTable)) then
    mBaseTable := TSFStmtTableXML(AddChild(TSFStmtTableXML.GetTagName));

  Result := mBaseTable;
end;

function TSFStmtXML.getAttrs: TSFStmtAttrsXML;
begin
  if not(Assigned(mAttrs)) then
    mAttrs := TSFStmtAttrsXML(AddChild(TSFStmtAttrsXML.GetTagName));

  Result := mAttrs;
end;

function TSFStmtXML.getConds: TSFStmtCondsXML;
begin
  if not(Assigned(mConds)) then
    mConds := TSFStmtCondsXML(AddChild(TSFStmtCondsXML.GetTagName));

  Result := mConds;
end;

function TSFStmtXML.getOrders: TSFStmtOrdersXML;
begin
  if not(Assigned(mOrders)) then
    mOrders := TSFStmtOrdersXML(AddChild(TSFStmtOrdersXML.GetTagName));

  Result := mOrders;
end;

function TSFStmtXML.getGroups: TSFStmtGroupsXML;
begin
  if not(Assigned(mGroups)) then
    mGroups := TSFStmtGroupsXML(AddChild(TSFStmtGroupsXML.GetTagName));

  Result := mGroups;
end;

procedure TSFStmtXML.notifyBaseTable(pBaseTable: TSFStmtTableXML);
begin
  mBaseTable := pBaseTable;
end;

procedure TSFStmtXML.notifyAttrs(pAttrs: TSFStmtAttrsXML);
begin
  mAttrs := pAttrs;
end;

procedure TSFStmtXML.notifyConds(pConds: TSFStmtCondsXML);
begin
  mConds := pConds;
end;

procedure TSFStmtXML.notifyOrders(pOrders: TSFStmtOrdersXML);
begin
  mOrders := pOrders;
end;

procedure TSFStmtXML.notifyGroups(pGroups: TSFStmtGroupsXML);
begin
  mGroups := pGroups;
end;

function TSFStmtXML.getUseDistinct: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTPROP_USEDISTINCT);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtXML.getQuoteType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTPROP_QUOTETYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtXML.getAutoEscapeLike: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTPROP_AUTOESCAPELIKE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtXML.getDBDialect: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTPROP_DBDIALECT);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtXML.getLikeEscapeChar: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTPROP_LIKEESCAPECHAR);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtXML.getUnion: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTPROP_UNION);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtXML.setUseDistinct(pVal: Boolean);
begin
  SetChildValByTag(STMTPROP_USEDISTINCT, pVal);
end;

procedure TSFStmtXML.setQuoteType(pVal: Integer);
begin
  SetChildValByTag(STMTPROP_QUOTETYPE, pVal);
end;

procedure TSFStmtXML.setAutoEscapeLike(pVal: Boolean);
begin
  SetChildValByTag(STMTPROP_AUTOESCAPELIKE, pVal);
end;

procedure TSFStmtXML.setDBDialect(pVal: Integer);
begin
  SetChildValByTag(STMTPROP_DBDIALECT, pVal);
end;

procedure TSFStmtXML.setLikeEscapeChar(pVal: String);
begin
  SetChildValByTag(STMTPROP_LIKEESCAPECHAR, pVal);
end;

procedure TSFStmtXML.setUnion(pVal: String);
begin
  SetChildValByTag(STMTPROP_UNION, pVal);
end;

//============================================================================//
//                           TSFStmtTableXML                                  //
//============================================================================//

const
  STMTTABLE_TAGNAME = 'TABLE';
  STMTTABLEPROP_NO = 'TableNo';
  STMTTABLEPROP_ALIAS = 'TableAlias';
  STMTTABLEPROP_STMTNAME = 'StmtName';
  STMTTABLEPROP_ISSTMT = 'TableIsStmt';
  STMTTABLEPROP_DBNAME = 'TableName';
  STMTTABLEPROP_DBSCHEMA = 'Schema';
  STMTTABLEPROP_DBCATALOG = 'Catalog';

procedure TSFStmtTableXML.AfterConstruction;
begin
  inherited;

  mRelations := nil;

  RegisterChildNode(TSFStmtTableRelationsXML.GetTagName, TSFStmtTableRelationsXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) then
  begin
    if (ParentNode is  TSFStmtXML) then
      TSFStmtXML(ParentNode).notifyBaseTable(Self)
    else if (ParentNode is TSFStmtTableRelationXML) then
      TSFStmtTableRelationXML(ParentNode).notifyDestTable(Self);
  end;
end;

function TSFStmtTableXML.HasRelations: Boolean;
begin
  Result := Assigned(mRelations);
end;

class function TSFStmtTableXML.GetTagName: String;
begin
  Result := STMTTABLE_TAGNAME;
end;

function TSFStmtTableXML.getTableNo: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLEPROP_NO);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getTableAlias: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLEPROP_ALIAS);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getStmtName: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLEPROP_STMTNAME);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getTableIsStmt: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTTABLEPROP_ISSTMT);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getTableName: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLEPROP_DBNAME);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getSchema: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLEPROP_DBSCHEMA);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableXML.getCatalog: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLEPROP_DBCATALOG);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtTableXML.setTableNo(pVal: Integer);
begin
  SetChildValByTag(STMTTABLEPROP_NO, pVal);
end;

procedure TSFStmtTableXML.setTableAlias(pVal: String);
begin
  SetChildValByTag(STMTTABLEPROP_ALIAS, pVal);
end;

procedure TSFStmtTableXML.setStmtName(pVal: String);
begin
  SetChildValByTag(STMTTABLEPROP_STMTNAME, pVal);
end;

procedure TSFStmtTableXML.setTableIsStmt(pVal: Boolean);
begin
  SetChildValByTag(STMTTABLEPROP_ISSTMT, pVal);
end;

procedure TSFStmtTableXML.setTableName(pVal: String);
begin
  SetChildValByTag(STMTTABLEPROP_DBNAME, pVal);
end;

procedure TSFStmtTableXML.setSchema(pVal: String);
begin
  SetChildValByTag(STMTTABLEPROP_DBSCHEMA, pVal);
end;

procedure TSFStmtTableXML.setCatalog(pVal: String);
begin
  SetChildValByTag(STMTTABLEPROP_DBCATALOG, pVal);
end;

function TSFStmtTableXML.getRelations: TSFStmtTableRelationsXML;
begin
  if not(Assigned(mRelations)) then
    mRelations := TSFStmtTableRelationsXML(AddChild(TSFStmtTableRelationsXML.GetTagName));

  Result := mRelations;
end;

procedure TSFStmtTableXML.notifyRelations(pRelations: TSFStmtTableRelationsXML);
begin
  mRelations := pRelations;
end;

//============================================================================//
//                       TSFStmtTableRelationsXML                             //
//============================================================================//

const
  STMTTABLERELATIONS_TAGNAME = 'TABLERELATIONS';

procedure TSFStmtTableRelationsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtTableRelationXML.GetTagName, TSFStmtTableRelationXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) then
  begin
    if (ParentNode is  TSFStmtTableXML) then
      TSFStmtTableXML(ParentNode).notifyRelations(Self);
  end;
end;

class function TSFStmtTableRelationsXML.GetTagName: String;
begin
  Result := STMTTABLERELATIONS_TAGNAME;
end;

function TSFStmtTableRelationsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtTableRelationXML(AddChild(TSFStmtTableRelationXML.GetTagName));
end;

//============================================================================//
//                       TSFStmtTableRelationXML                              //
//============================================================================//

const
  STMTTABLEREL_TAGNAME = 'TABLERELATION';
  STMTTABLERELPROP_JOINTYPE = 'JoinType';

procedure TSFStmtTableRelationXML.AfterConstruction;
begin
  inherited;

  mDestTable := nil;
  mRelationItems := nil;

  RegisterChildNode(TSFStmtTableRelationItemsXML.GetTagName, TSFStmtTableRelationItemsXML);
  RegisterChildNode(TSFStmtTableXML.GetTagName, TSFStmtTableXML);

  // init childnodes
  ChildNodes;
end;

function TSFStmtTableRelationXML.HasRelationItems: Boolean;
begin
  Result := Assigned(mRelationItems);
end;

function TSFStmtTableRelationXML.HasDestTable: Boolean;
begin
  Result := Assigned(mDestTable);
end;

class function TSFStmtTableRelationXML.GetTagName: String;
begin
  Result := STMTTABLEREL_TAGNAME;
end;

function TSFStmtTableRelationXML.getParentTableJoinType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLERELPROP_JOINTYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtTableRelationXML.setParentTableJoinType(pVal: Integer);
begin
  SetChildValByTag(STMTTABLERELPROP_JOINTYPE, pVal);
end;

function TSFStmtTableRelationXML.getRelationItems: TSFStmtTableRelationItemsXML;
begin
  if not(Assigned(mRelationItems)) then
    mRelationItems := TSFStmtTableRelationItemsXML(AddChild(TSFStmtTableRelationItemsXML.GetTagName));

  Result := mRelationItems;
end;

procedure TSFStmtTableRelationXML.notifyRelationItems(pRelItems: TSFStmtTableRelationItemsXML);
begin
  mRelationItems := pRelItems;
end;

function TSFStmtTableRelationXML.getDestTable: TSFStmtTableXML;
begin
  if not(Assigned(mDestTable)) then
    mDestTable := TSFStmtTableXML(AddChild(TSFStmtTableXML.GetTagName));

  Result := mDestTable;
end;

procedure TSFStmtTableRelationXML.notifyDestTable(pDestTable: TSFStmtTableXML);
begin
  mDestTable := pDestTable;
end;

//============================================================================//
//                     TSFStmtTableRelationItemsXML                           //
//============================================================================//

const
  STMTTABLERELITEMS_TAGNAME = 'RELATIONITEMS';

procedure TSFStmtTableRelationItemsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtTableRelationItemXML.GetTagName, TSFStmtTableRelationItemXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) then
  begin
    if (ParentNode is  TSFStmtTableRelationXML) then
      TSFStmtTableRelationXML(ParentNode).notifyRelationItems(Self)
    else if (ParentNode is TSFStmtCondXML) then
      TSFStmtCondXML(ParentNode).notifyExistsRelation(Self);
  end;
end;

class function TSFStmtTableRelationItemsXML.GetTagName: String;
begin
  Result := STMTTABLERELITEMS_TAGNAME;
end;

function TSFStmtTableRelationItemsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtTableRelationItemXML(AddChild(TSFStmtTableRelationItemXML.GetTagName));
end;

//============================================================================//
//                      TSFStmtTableRelationItemXML                           //
//============================================================================//

const
  STMTTABLERELITEM_TAGNAME = 'RELATIONITEM';
  STMTTABLERELITEMPROP_SRCTYPE = 'SrcType';
  STMTTABLERELITEMPROP_SRCVALUE = 'SrcValue';
  STMTTABLERELITEMPROP_SRCVALUETYPE = 'SrcValueType';
  STMTTABLERELITEMPROP_DESTTYPE = 'DestType';
  STMTTABLERELITEMPROP_DESTVALUE = 'DestValue';
  STMTTABLERELITEMPROP_DESTVALUETYPE = 'DestValueType';

class function TSFStmtTableRelationItemXML.GetTagName: String;
begin
  Result := STMTTABLERELITEM_TAGNAME;
end;

function TSFStmtTableRelationItemXML.getSrcType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_SRCTYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableRelationItemXML.getSrcValue: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_SRCVALUE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableRelationItemXML.getSrcValueType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_SRCVALUETYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableRelationItemXML.getDestType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_DESTTYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableRelationItemXML.getDestValue: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_DESTVALUE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtTableRelationItemXML.getDestValueType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTTABLERELITEMPROP_DESTVALUETYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtTableRelationItemXML.setSrcType(pVal: Integer);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_SRCTYPE, pVal);
end;

procedure TSFStmtTableRelationItemXML.setSrcValue(pVal: String);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_SRCVALUE, pVal);
end;

procedure TSFStmtTableRelationItemXML.setSrcValueType(pVal: Integer);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_SRCVALUETYPE, pVal);
end;

procedure TSFStmtTableRelationItemXML.setDestType(pVal: Integer);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_DESTTYPE, pVal);
end;

procedure TSFStmtTableRelationItemXML.setDestValue(pVal: String);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_DESTVALUE, pVal);
end;

procedure TSFStmtTableRelationItemXML.setDestValueType(pVal: Integer);
begin
  SetChildValByTag(STMTTABLERELITEMPROP_DESTVALUETYPE, pVal);
end;

//============================================================================//
//                            TSFStmtAttrsXML                                 //
//============================================================================//

const
  STMTATTRS_TAGNAME = 'ATTRIBUTES';

procedure TSFStmtAttrsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtAttrXML.GetTagName, TSFStmtAttrXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) then
  begin
    if (ParentNode is  TSFStmtXML) then
      TSFStmtXML(ParentNode).notifyAttrs(Self);
  end;
end;

class function TSFStmtAttrsXML.GetTagName: String;
begin
  Result := STMTATTRS_TAGNAME;
end;

function TSFStmtAttrsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtAttrXML(AddChild(TSFStmtAttrXML.GetTagName));
end;

//============================================================================//
//                            TSFStmtAttrXML                                  //
//============================================================================//

const
  STMTATTR_TAGNAME = 'ATTRIBUTE';
  STMTATTRPROP_ATTRIDX = 'AttrIdx';
  STMTATTRPROP_ATTRNAME = 'AttrName';
  STMTATTRPROP_ONLYSEARCH = 'OnlyForSearch';


procedure TSFStmtAttrXML.AfterConstruction;
begin
  inherited;

  mAttrItems := nil;

  RegisterChildNode(TSFStmtAttrItemsXML.GetTagName, TSFStmtAttrItemsXML);

  // init childnodes
  ChildNodes;
end;

function TSFStmtAttrXML.HasAttrItems: Boolean;
begin
  Result := Assigned(mAttrItems);
end;

class function TSFStmtAttrXML.GetTagName: String;
begin
  Result := STMTATTR_TAGNAME;
end;

function TSFStmtAttrXML.getAttrIdx: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTATTRPROP_ATTRIDX);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrXML.getAttrName: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRPROP_ATTRNAME);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrXML.getOnlyForSearch: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTATTRPROP_ONLYSEARCH);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrXML.getAttrItems: TSFStmtAttrItemsXML;
begin
  if not(Assigned(mAttrItems)) then
    mAttrItems := TSFStmtAttrItemsXML(AddChild(TSFStmtAttrItemsXML.GetTagName));

  Result := mAttrItems;
end;

procedure TSFStmtAttrXML.setAttrIdx(pVal: Integer);
begin
  SetChildValByTag(STMTATTRPROP_ATTRIDX, pVal);
end;

procedure TSFStmtAttrXML.setAttrName(pVal: String);
begin
  SetChildValByTag(STMTATTRPROP_ATTRNAME, pVal);
end;

procedure TSFStmtAttrXML.setOnlyForSearch(pVal: Boolean);
begin
  SetChildValByTag(STMTATTRPROP_ONLYSEARCH, pVal);
end;

procedure TSFStmtAttrXML.notifyAttrItems(pAttrItems: TSFStmtAttrItemsXML);
begin
  mAttrItems := pAttrItems;
end;

//============================================================================//
//                          TSFStmtAttrItemsXML                               //
//============================================================================//

const
  STMTATTRITEMS_TAGNAME = 'ATTRIBUTEITEMS';


procedure TSFStmtAttrItemsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtAttrItemXML.GetTagName, TSFStmtAttrItemXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) and (ParentNode is TSFStmtAttrXML) then
    TSFStmtAttrXML(ParentNode).notifyAttrItems(Self);
end;

class function TSFStmtAttrItemsXML.GetTagName: String;
begin
  Result := STMTATTRITEMS_TAGNAME;
end;

function TSFStmtAttrItemsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtAttrItemXML(AddChild(TSFStmtAttrItemXML.GetTagName));
end;

//============================================================================//
//                          TSFStmtAttrItemXML                                //
//============================================================================//

const
  STMTATTRITEM_TAGNAME = 'ATTRIBUTEITEM';
  STMTATTRITEMPROP_AGGR = 'Aggr';
  STMTATTRITEMPROP_TYPE = 'ItemType';
  STMTATTRITEMPROP_TABLE = 'ItemRefTableAlias';
  STMTATTRITEMPROP_FIELD = 'ItemRefTableField';
  STMTATTRITEMPROP_STMT = 'ItemRefStmtName';
  STMTATTRITEMPROP_OTHER = 'ItemRefOther';
  STMTATTRITEMPROP_VALUETYPE = 'ItemRefValueType';


class function TSFStmtAttrItemXML.GetTagName: String;
begin
  Result := STMTATTRITEM_TAGNAME;
end;

function TSFStmtAttrItemXML.getAggr: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRITEMPROP_AGGR);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTATTRITEMPROP_TYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemRefTableAlias: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRITEMPROP_TABLE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemRefTableField: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRITEMPROP_FIELD);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemRefStmtName: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRITEMPROP_STMT);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemRefOther: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTATTRITEMPROP_OTHER);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtAttrItemXML.getItemRefValueType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTATTRITEMPROP_VALUETYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtAttrItemXML.setAggr(pVal: String);
begin
  SetChildValByTag(STMTATTRITEMPROP_AGGR, pVal);
end;

procedure TSFStmtAttrItemXML.setItemType(pVal: Integer);
begin
  SetChildValByTag(STMTATTRITEMPROP_TYPE, pVal);
end;

procedure TSFStmtAttrItemXML.setItemRefTableAlias(pVal: String);
begin
  SetChildValByTag(STMTATTRITEMPROP_TABLE, pVal);
end;

procedure TSFStmtAttrItemXML.setItemRefTableField(pVal: String);
begin
  SetChildValByTag(STMTATTRITEMPROP_FIELD, pVal);
end;

procedure TSFStmtAttrItemXML.setItemRefStmtName(pVal: String);
begin
  SetChildValByTag(STMTATTRITEMPROP_STMT, pVal);
end;

procedure TSFStmtAttrItemXML.setItemRefOther(pVal: String);
begin
  SetChildValByTag(STMTATTRITEMPROP_OTHER, pVal);
end;

procedure TSFStmtAttrItemXML.setItemRefValueType(pVal: Integer);
begin
  SetChildValByTag(STMTATTRITEMPROP_VALUETYPE, pVal);
end;

//============================================================================//
//                            TSFStmtCondsXML                                 //
//============================================================================//

const
  STMTCONDITIONS_TAGNAME = 'CONDITIONS';

procedure TSFStmtCondsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtCondXML.GetTagName, TSFStmtCondXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) and (ParentNode is TSFStmtXML) then
    TSFStmtXML(ParentNode).notifyConds(Self);
end;

class function TSFStmtCondsXML.GetTagName: String;
begin
  Result := STMTCONDITIONS_TAGNAME;
end;

function TSFStmtCondsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtCondXML(AddChild(TSFStmtCondXML.GetTagName));
end;

//============================================================================//
//                            TSFStmtCondXML                                  //
//============================================================================//

const
  STMTCONDITION_TAGNAME = 'CONDITION';
  STMTCONDITIONPROP_TYPE = 'CondType';
  STMTCONDITIONPROP_OP = 'CondOperator';
  STMTCONDITIONPROP_ATTRIDX = 'AttrIdx';
  STMTCONDITIONPROP_DESTATTRIDX = 'DestAttrIdx';
  STMTCONDITIONPROP_DESTVAL = 'DestValue';
  STMTCONDITIONPROP_DESTVALARRAY = 'DestValueIsArray';
  STMTCONDITIONPROP_DESTVALTYPE = 'DestValueType';
  STMTCONDITIONPROP_RESTRICTION = 'IsRestriction';
  STMTCONDITIONPROP_EXISTSFROM = 'ExistsTableAliasFrom';
  STMTCONDITIONPROP_EXISTSDESTSTMT = 'ExistsDestRefStmtName';
  STMTCONDITIONPROP_EXISTSDESTTABLE = 'ExistsDestRefStmtTableAlias';

procedure TSFStmtCondXML.AfterConstruction;
begin
  inherited;

  mExistsRelation := nil;

  RegisterChildNode(TSFStmtTableRelationItemsXML.GetTagName, TSFStmtTableRelationItemsXML);

  // init childnodes
  ChildNodes;
end;

function TSFStmtCondXML.HasExistsRelationItems: Boolean;
begin
  Result := Assigned(mExistsRelation);
end;

class function TSFStmtCondXML.GetTagName: String;
begin
  Result := STMTCONDITION_TAGNAME;
end;

function TSFStmtCondXML.getCondType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_TYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getCondOperator: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTCONDITIONPROP_OP);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getAttrIdx: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_ATTRIDX);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getDestAttrIdx: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_DESTATTRIDX);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getDestValue: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTCONDITIONPROP_DESTVAL);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getDestValueIsArray: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_DESTVALARRAY);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getDestValueType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_DESTVALTYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getIsRestriction: Boolean;
  var lRslt: Variant;
begin
  Result := False;

  lRslt := GetChildValByTag(STMTCONDITIONPROP_RESTRICTION);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getExistsTableAliasFrom: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTCONDITIONPROP_EXISTSFROM);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getExistsDestRefStmtName: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTCONDITIONPROP_EXISTSDESTSTMT);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getExistsDestRefStmtTableAlias: String;
  var lRslt: Variant;
begin
  Result := '';

  lRslt := GetChildValByTag(STMTCONDITIONPROP_EXISTSDESTTABLE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtCondXML.getExistsRelation: TSFStmtTableRelationItemsXML;
begin
  if not(Assigned(mExistsRelation)) then
    mExistsRelation := TSFStmtTableRelationItemsXML(AddChild(TSFStmtTableRelationItemsXML.GetTagName));

  Result := mExistsRelation;
end;

procedure TSFStmtCondXML.setCondType(pVal: Integer);
begin
  SetChildValByTag(STMTCONDITIONPROP_TYPE, pVal);
end;

procedure TSFStmtCondXML.setCondOperator(pVal: String);
begin
  SetChildValByTag(STMTCONDITIONPROP_OP, pVal);
end;

procedure TSFStmtCondXML.setAttrIdx(pVal: Integer);
begin
  SetChildValByTag(STMTCONDITIONPROP_ATTRIDX, pVal);
end;

procedure TSFStmtCondXML.setDestAttrIdx(pVal: Integer);
begin
  SetChildValByTag(STMTCONDITIONPROP_DESTATTRIDX, pVal);
end;

procedure TSFStmtCondXML.setDestValue(pVal: String);
begin
  SetChildValByTag(STMTCONDITIONPROP_DESTVAL, pVal);
end;

procedure TSFStmtCondXML.setDestValueIsArray(pVal: Boolean);
begin
  SetChildValByTag(STMTCONDITIONPROP_DESTVALARRAY, pVal);
end;

procedure TSFStmtCondXML.setDestValueType(pVal: Integer);
begin
  SetChildValByTag(STMTCONDITIONPROP_DESTVALTYPE, pVal);
end;

procedure TSFStmtCondXML.setIsRestriction(pVal: Boolean);
begin
  SetChildValByTag(STMTCONDITIONPROP_RESTRICTION, pVal);
end;

procedure TSFStmtCondXML.setExistsTableAliasFrom(pVal: String);
begin
  SetChildValByTag(STMTCONDITIONPROP_EXISTSFROM, pVal);
end;

procedure TSFStmtCondXML.setExistsDestRefStmtName(pVal: String);
begin
  SetChildValByTag(STMTCONDITIONPROP_EXISTSDESTSTMT, pVal);
end;

procedure TSFStmtCondXML.setExistsDestRefStmtTableAlias(pVal: String);
begin
  SetChildValByTag(STMTCONDITIONPROP_EXISTSDESTTABLE, pVal);
end;

procedure TSFStmtCondXML.notifyExistsRelation(pExistsRel: TSFStmtTableRelationItemsXML);
begin
  mExistsRelation := pExistsRel;
end;

//============================================================================//
//                            TSFStmtOrdersXML                                //
//============================================================================//

const
  STMTORDERS_TAGNAME = 'ORDERS';

procedure TSFStmtOrdersXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtOrderXML.GetTagName, TSFStmtOrderXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) and (ParentNode is TSFStmtXML) then
    TSFStmtXML(ParentNode).notifyOrders(Self);
end;

class function TSFStmtOrdersXML.GetTagName: String;
begin
  Result := STMTORDERS_TAGNAME;
end;

function TSFStmtOrdersXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtOrderXML(AddChild(TSFStmtOrderXML.GetTagName));
end;

//============================================================================//
//                            TSFStmtOrderXML                                 //
//============================================================================//

const
  STMTORDER_TAGNAME = 'ORDER';
  STMTORDERPROP_ATTRIDX = 'AttrIdx';
  STMTORDERPROP_TYPE = 'OrderType';


class function TSFStmtOrderXML.GetTagName: String;
begin
  Result := STMTORDER_TAGNAME;
end;

function TSFStmtOrderXML.getAttrIdx: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTORDERPROP_ATTRIDX);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

function TSFStmtOrderXML.getOrderType: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTORDERPROP_TYPE);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtOrderXML.setAttrIdx(pVal: Integer);
begin
  SetChildValByTag(STMTORDERPROP_ATTRIDX, pVal);
end;

procedure TSFStmtOrderXML.setOrderType(pVal: Integer);
begin
  SetChildValByTag(STMTORDERPROP_TYPE, pVal);
end;

//============================================================================//
//                            TSFStmtGroupsXML                                //
//============================================================================//

const
  STMTGROUPS_TAGNAME = 'GROUPS';

procedure TSFStmtGroupsXML.AfterConstruction;
begin
  inherited;

  RegisterChildNode(TSFStmtGroupXML.GetTagName, TSFStmtGroupXML);

  // init childnodes
  ChildNodes;

  if (Assigned(ParentNode)) and (ParentNode is TSFStmtXML) then
    TSFStmtXML(ParentNode).notifyGroups(Self);
end;

class function TSFStmtGroupsXML.GetTagName: String;
begin
  Result := STMTGROUPS_TAGNAME;
end;

function TSFStmtGroupsXML.AddItem: TSFStmtXMLNode;
begin
  Result := TSFStmtGroupXML(AddChild(TSFStmtGroupXML.GetTagName));
end;

//============================================================================//
//                            TSFStmtGroupXML                                 //
//============================================================================//

const
  STMTGROUP_TAGNAME = 'GROUP';
  STMTGROUPPROP_ATTRIDX = 'AttrIdx';


class function TSFStmtGroupXML.GetTagName: String;
begin
  Result := STMTGROUP_TAGNAME;
end;

function TSFStmtGroupXML.getAttrIdx: Integer;
  var lRslt: Variant;
begin
  Result := -1;

  lRslt := GetChildValByTag(STMTGROUPPROP_ATTRIDX);
  if not(VarIsNull(lRslt)) then
    Result := lRslt;
end;

procedure TSFStmtGroupXML.setAttrIdx(pVal: Integer);
begin
  SetChildValByTag(STMTGROUPPROP_ATTRIDX, pVal);
end;

end.
