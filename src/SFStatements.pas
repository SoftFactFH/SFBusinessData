//
//   Title:         SFStatements
//
//   Description:   classes to build sql queries (query builder)
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFStatements;

interface

uses
  System.Generics.Collections, System.Classes, System.SysUtils,
  Xml.XMLIntf, SFStatementsXML, SFStatementType;

const
  SFSTMT_OP_EQUAL = '=';
  SFSTMT_OP_NOTEQUAL = '<>';
  SFSTMT_OP_LESSEQUAL = '<=';
  SFSTMT_OP_GREATEREQUAL = '>=';
  SFSTMT_OP_LESS = '<';
  SFSTMT_OP_GREATER = '>';
  SFSTMT_OP_LIKE = 'LIKE';
  SFSTMT_OP_NOT_LIKE = 'NOT LIKE';
  SFSTMT_OP_IN = 'IN';
  SFSTMT_OP_NOT_IN = 'NOT IN';
  SFSTMT_OP_EXISTS = 'EXISTS';
  SFSTMT_OP_NOT_EXISTS = 'NOT EXISTS';

  SFSTMTATTR_UNDEFINED = '*';

  SFSTMTAGGR_COUNT = 'count';
  SFSTMTAGGR_MIN = 'min';
  SFSTMTAGGR_MAX = 'max';
  SFSTMTAGGR_AVG = 'avg';
  SFSTMTAGGR_SUM = 'sum';

  SFSTMTVAL_NULLDATE = -693594;

type
  // forward declarations
  TSFStmt = class;
  TSFStmtTable = class;
  TSFStmtTableJoin = class;
  TSFStmtAttr = class;
  TSFStmtAttrItem = class;
  TSFStmtCondition = class;
  TSFStmtDBDialectConv = class;

  TSFStmtCls = class of TSFStmt;
  TSFStmtDBDialectConvCls = class of TSFStmtDBDialectConv;

  TSFStmtGenSelectEvent = procedure(pStmt: TSFStmt; pLevel, pSubId, pUnionId: Integer) of object;
  TSFStmtGetDialectConvEvent = function(pDBDialect: TSFStmtDBDialect): TSFStmtDBDialectConvCls of object;

  TSFStmt = class(TComponent)
    private
      mBaseTable: TSFStmtTable;
      mStmtAttrs: TObjectList<TSFStmtAttr>;
      mStmtConditions: TObjectList<TSFStmtCondition>;
      mStmtOrder: TObjectList<TSFStmtAttr>;
      mStmtGroup: TObjectList<TSFStmtAttr>;
      mRestrAttrs: TObjectList<TSFStmtAttr>;
      mSetAttrs: TObjectList<TSFStmtAttr>;
      mInsAttrs: TObjectList<TSFStmtAttr>;
      mRestrConditions: TObjectList<TSFStmtCondition>;
      mClientRestrConditions: TObjectList<TSFStmtCondition>;
      mSetConditions: TObjectList<TSFStmtCondition>;
      mInsConditions: TObjectList<TSFStmtCondition>;
      mGenerateLevel: Integer;
      mGenerateSubId: Integer;
      mGenerateUnionId: Integer;
      mQuoteType: TSFStmtQuoteType;
      mOnBeforeGenSelect: TSFStmtGenSelectEvent;
      mOnAfterGenSelect: TSFStmtGenSelectEvent;
      mOnBeforeGenDelete: TSFStmtGenSelectEvent;
      mOnAfterGenDelete: TSFStmtGenSelectEvent;
      mOnBeforeGenUpdate: TSFStmtGenSelectEvent;
      mOnAfterGenUpdate: TSFStmtGenSelectEvent;
      mOnBeforeGenInsert: TSFStmtGenSelectEvent;
      mOnAfterGenInsert: TSFStmtGenSelectEvent;
      mStmtGenInfos: TSFStmtGenInfos;
      mUseDistinct: Boolean;
      mLikeEscapeChar: String;
      mAutoEscapeLike: Boolean;
      mDfltFrmtSettings: TFormatSettings;
      mUnion: TSFStmt;
      mUnionName: String;
      mDBDialect: TSFStmtDBDialect;
      mOnGetDBDialectCls: TSFStmtGetDialectConvEvent;
    private
      function getTableByAlias(pAlias: String): TSFStmtTable;
      function getAttrByName(pAttrName: String; pTableAlias: String = ''; pAttrAggr: String = ''; pOnlyVisible: Boolean = False): TSFStmtAttr;
      procedure setWhereConditions(var pWhereStr: String; pLst: TObjectList<TSFStmtCondition>; pWithBracket: Boolean; pWithAliases: Boolean = True);
      function hasVisibleAttrs(pLst: TObjectList<TSFStmtAttr>): Boolean;
      function detectDBDialectConvCls: TSFStmtDBDialectConvCls;
      function createRelItems(pRelValsSource, pRelValsDest: Array of Variant;
                              pRelTypesSource, pRelTypesDest: Array of TSFStmtJoinRelItemType): TSFStmtJoinRelItems;
      function createRelItemsFromXmlRelItems(pXmlRelationItems: TSFStmtTableRelationItemsXML): TSFStmtJoinRelItems;
      procedure exportToXml(pXmlDoc: IXmlDocument);
      procedure loadXml(pXmlDoc: IXmlDocument; pEnforceRecreate, pSuspendRefs: Boolean);
      procedure readXmlDefintion(pReader: TReader);
      procedure writeXmlDefintion(pWriter: TWriter);
      function getUnion: TSFStmt;
      function getGenerateNextLevel: Integer;
      function getGenerateNextSubId: Integer;
    protected
      procedure DefineProperties(Filer: TFiler); override;
    public
      constructor Create(pOwner: TComponent); override;
      destructor Destroy; override;
    public
      function SetBaseTable(pTableName, pSchema, pCatalog, pTableAlias: String): TSFStmtTable; overload;
      function SetBaseTable(pStmt: TSFStmt; pTableAlias: String): TSFStmtTable; overload;
      function SetBaseTable(pStmtName, pTableAlias: String): TSFStmtTable; overload;
      procedure ReconfigBaseTable(pTableName, pSchema, pCatalog, pTableAlias: String);
      function AddStmtAttr(pAttrName: String; pOnlyForSearch: Boolean): TSFStmtAttr;
      procedure SetStmtAttr(pAttrName, pAttrAlias, pTableAlias: String; pOnlyForSearch: Boolean); overload;
      procedure SetStmtAttr(pAttrName, pAttrAlias: String; pStmtTable: TSFStmtTable; pOnlyForSearch: Boolean); overload;
      procedure SetStmtAggr(pAggr, pAttrName, pAttrAlias, pTableAlias: String); overload;
      procedure SetStmtAggr(pAggr, pAttrName, pAttrAlias: String; pStmtTable: TSFStmtTable); overload;
      function SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTableAlias: String;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTableAlias: String;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pSourceTableAlias: String; pDestStmt: TSFStmt;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pSourceTableAlias: String; pDestStmt: TSFStmt;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pSourceTable: TSFStmtTable;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pSourceTable: TSFStmtTable;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmt: TSFStmt;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmt: TSFStmt;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmtName: String;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmtName: String;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      procedure ModfiyTableJoinType(pDestTableAlias, pSourceTableAlias: String;
                                    pTypeFrom, pTypeTo: TSFStmtJoinType); overload;
      procedure ModfiyTableJoinType(pDestTable, pSourceTable: TSFStmtTable;
                                    pTypeFrom, pTypeTo: TSFStmtJoinType); overload;
      function TableJoinAliasesForAttr(pSourceTableAlias, pAttr: String): Variant; overload;
      function TableJoinAliasesForAttr(pSourceTable: TSFStmtTable; pAttr: String): Variant; overload;
      function GetRelItemsForJoin(pSourceTable, pDestTable: TSFStmtTable): TSFStmtJoinRelItems; overload;
      function GetRelItemsForJoin(pSourceTableAlias, pDestTableAlias: String): TSFStmtJoinRelItems; overload;
      procedure SetRelItemsForJoin(pSourceTable, pDestTable: TSFStmtTable; pRelItems: TSFStmtJoinRelItems); overload;
      procedure SetRelItemsForJoin(pSourceTableAlias, pDestTableAlias: String; pRelItems: TSFStmtJoinRelItems); overload;
      function GetNextTableNo: Integer;
      procedure AddConditionVal(pTableAlias, pAttrName, pOp: String; pVal: Variant; pRestrict: Boolean = False);
      procedure AddConditionAttr(pSrcTabAlias, pSrcAttrName, pOp, pDestTabAlias, pDestAttrName: String; pRestrict: Boolean = False);
      procedure AddConditionIsNull(pTableAlias, pAttrName: String; pRestrict: Boolean = False);
      procedure AddConditionIsNotNull(pTableAlias, pAttrName: String; pRestrict: Boolean = False);
      procedure AddConditionType(pType: TSFStmtConditionType; pRestrict: Boolean = False);
      procedure AddConditionExists(pDestStmt: TSFStmt; pTableAlias, pDestTableAlias, pOp: String;
                                    pRelItems: TSFStmtJoinRelItems; pRestrict: Boolean = False); overload;
      procedure AddConditionExists(pDestStmt: TSFStmt; pTableAlias, pDestTableAlias, pOp: String;
                                    const pRelValsDest, pRelValsSource: Array of Variant;
                                    const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                                    pRestrict: Boolean = False); overload;
      procedure AddConditionExists(pDestStmtName, pTableAlias, pDestTableAlias, pOp: String;
                                    pRelItems: TSFStmtJoinRelItems; pRestrict: Boolean = False); overload;
      procedure AddConditionExists(pDestStmtName, pTableAlias, pDestTableAlias, pOp: String;
                                    const pRelValsDest, pRelValsSource: Array of Variant;
                                    const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                                    pRestrict: Boolean = False); overload;
      procedure AddOrderAttr(pTableAlias, pAttrName: String; pOrderType: TSFStmtSortType = stmtSortTypeAsc);
      procedure AddGroupAttr(pTableAlias, pAttrName: String);
      procedure AddSetCondition(pAttrName: String; pVal: Variant; pValType: TSFStmtAttrItemValueType);
      procedure AddInsertCondition(pAttrName: String; pVal: Variant; pValType: TSFStmtAttrItemValueType);
      procedure Reset;
      function GetSelectStmt(pLevel: Integer = 0; pSubId: Integer = 0; pUnionId: Integer = 0): String;
      function GetDeleteStmt: String;
      function GetUpdateStmt: String;
      function GetInsertStmt: String;
      function GetNextAutoValueStmt(pRefName: String = ''): String;
      function GetLastAutoValueStmt(pRefName: String = ''): String;
      function GetDBDialectCanSelWithoutTab(var pTableName: String): Boolean;
      function GetDBDialectCanSubInFrom: Boolean;
      function GetDBDialectNeedTableOnSubInFrom: Boolean;
      function GetDBDialectLikeWildcardSingle: String;
      function GetDBDialectLikeWildcardMany: String;
      function GetDBDialectLikeSupportsEscape: Boolean;
      procedure AddBaseRestriction(pTableAlias, pAttrName: String; pVal: Variant; pVisible, pPreventNull: Boolean);
      procedure ClearBaseRestrictions;
      procedure ClearConditions;
      procedure ClearClientRectrictions;
      procedure ClearOrder;
      procedure ClearGroup;
      procedure ClearSetConditions;
      procedure ClearInsConditions;
      function AttrExists(pAttrName, pTableAlias, pAggr: String): Boolean;
      function AttrDisplayName(pAttrName, pTableAlias: String): String;
      function GetTableNameForAttr(var pAttrName: String; pIncludeInvisible: Boolean): String;
      function GetTableAliasForAttr(var pAttrName: String; pIncludeInvisible: Boolean): String;
      function GetTableForAttr(var pAttrName: String; pIncludeInvisible: Boolean): TSFStmtTable;
      function HasConditions: Boolean;
      function GetConvertedValue(pValue: Variant; pExplicitCast: Boolean = False; pEscapeLike: Boolean = False): String;
      function GetTypeForValue(pValue: Variant): TSFStmtValueType;
      function ConvertValueInType(var pValue: Variant; pType: TSFStmtValueType; pHandleArray: Boolean = False): Boolean;
      function ConvertArrayValueToStr(pValue: Variant): String;
      function GetReferencedStmtByNamePath(pNamePath: String): TSFStmt;
      function GetReferencedStmtForParent(pNamePath: String; pParent: TComponent): TSFStmt;
      function GetReferencedStmtNamePath(pComp: TComponent = nil): String;
      function GetQuotedIdentifier(pIdentifier: String): String;
      procedure SetUnion(pStmt: TSFStmt);
      function HasUnion: Boolean;
      function AssignStmt: TSFStmt;
      procedure AssignStmtTo(pDest: TSFStmt);
      function AttrDatabaseNameForAttrName(pTableAlias, pAttrName: String): String; overload;
      function AttrDatabaseNameForAttrName(pAttrName: String; var pTable: TSFStmtTable): String; overload;
      function ListTables: TObjectList<TSFStmtTable>;
      function ListAttributes: TObjectList<TSFStmtAttr>;
      function ListAttributeParams: TStrings;
      function ListConditions: TObjectList<TSFStmtCondition>;
      function ListRestrictions: TObjectList<TSFStmtCondition>;
      function ListOrder: TObjectList<TSFStmtAttr>;
      function ListGroup: TObjectList<TSFStmtAttr>;
      function ConfigStmtTimeValue(pTime: TTime): TDateTime;
      function HasStmtDatePart(pDate: TDateTime): Boolean;
      function HasStmtTimePart(pDate: TDateTime): Boolean;
      function GetStmtDatePart(pDate: TDateTime): TDate;
      function GetStmtTimePart(pDate: TDateTime): TTime;
      function SaveToXmlDoc: IXmlDocument;
      procedure SaveToXmlStr(var pXmlStr: String);
      procedure LoadFromXml(pXmlStr: String; pSuspendRefs: Boolean = True);
      procedure LoadFromXmlDoc(pXmlDoc: IXmlDocument; pSuspendRefs: Boolean = True);
    public
      property BaseTable: TSFStmtTable read mBaseTable;
      property GenerateLevel: Integer read mGenerateLevel;
      property GenerateSubId: Integer read mGenerateSubId;
      property GenerateUnionId: Integer read mGenerateUnionId;
      property QuoteType: TSFStmtQuoteType read mQuoteType write mQuoteType;
      property StmtGenInfos: TSFStmtGenInfos read mStmtGenInfos;
      property OnBeforeGenSelect: TSFStmtGenSelectEvent read mOnBeforeGenSelect write mOnBeforeGenSelect;
      property OnAfterGenSelect: TSFStmtGenSelectEvent read mOnAfterGenSelect write mOnAfterGenSelect;
      property OnBeforeGenDelete: TSFStmtGenSelectEvent read mOnBeforeGenDelete write mOnBeforeGenDelete;
      property OnAfterGenDelete: TSFStmtGenSelectEvent read mOnAfterGenDelete write mOnAfterGenDelete;
      property OnBeforeGenUpdate: TSFStmtGenSelectEvent read mOnBeforeGenUpdate write mOnBeforeGenUpdate;
      property OnAfterGenUpdate: TSFStmtGenSelectEvent read mOnAfterGenUpdate write mOnAfterGenUpdate;
      property OnBeforeGenInsert: TSFStmtGenSelectEvent read mOnBeforeGenInsert write mOnBeforeGenInsert;
      property OnAfterGenInsert: TSFStmtGenSelectEvent read mOnAfterGenInsert write mOnAfterGenInsert;
      property UseDistinct: Boolean read mUseDistinct write mUseDistinct;
      property LikeEscapeChar: String read mLikeEscapeChar write mLikeEscapeChar;
      property AutoEscapeLike: Boolean read mAutoEscapeLike write mAutoEscapeLike;
      property DBDialect: TSFStmtDBDialect read mDBDialect write mDBDialect;
      property Union: TSFStmt read getUnion write SetUnion;
      property OnGetDBDialectCls: TSFStmtGetDialectConvEvent read mOnGetDBDialectCls write mOnGetDBDialectCls;
  end;

  TSFStmtTable = class(TObject)
    private
      mTableName: String;
      mSchema: String;
      mCatalog: String;
      mTableStmt: TSFStmt;
      mTableStmtName: String;
      mTableAlias: String;
      mTableNo: Integer;
      mJoins: TObjectList<TSFStmtTableJoin>;
      mParentStmt: TSFStmt;
    private
      function getTableAlias: String;
      function getTableAliasNested(pLevel, pSubId, pUnionId: Integer): String;
      procedure doCreate(pTableName, pSchema, pCatalog, pTableAlias: String; pTableNo: Integer;
                          pParentStmt, pTableStmt: TSFStmt; pTableStmtName: String);
      function assignRelItems(pRelItems: TSFStmtJoinRelItems): TSFStmtJoinRelItems;
      function getTableIdentifier: String;
      function getTableStmt: TSFStmt;
    public
      constructor Create(pTableName, pSchema, pCatalog, pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt); overload;
      constructor Create(pTableStmt: TSFStmt; pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt); overload;
      constructor Create(pTableStmtName, pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt); overload;
      destructor Destroy; override;
    public
      function SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pTableNo: Integer; pRelItems: TSFStmtJoinRelItems;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias: String; pStmt: TSFStmt; pTableNo: Integer; pRelItems: TSFStmtJoinRelItems;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function SetTableJoin(pTableAlias, pStmtName: String; pTableNo: Integer; pRelItems: TSFStmtJoinRelItems;
                            pType: TSFStmtJoinType): TSFStmtTable; overload;
      function GetJoinTableByAlias(pAlias: String; pSearchType: TSFStmtTableSearchType = stmtTableSearchAll): TSFStmtTable;
      function GetJoinTableAliasesForAttr(pAttr: String): Variant;
      procedure ResetJoins;
      function HasJoins: Boolean;
      function GetMaxTableNo: Integer;
      function GetTableDef(pWithAlias: Boolean = True): String;
      function AssignStmtTable(pDestStmt: TSFStmt): TSFStmtTable;
      procedure AssignStmtTableJoins(pDest: TSFStmtTable);
      function GetJoinType(pDest: TSFStmtTable): TSFStmtJoinType;
      procedure ModifyJoinType(pDest: TSFStmtTable; pTypeFrom, pTypeTo: TSFStmtJoinType);
      function GetRelItemsForJoin(pDest: TSFStmtTable): TSFStmtJoinRelItems;
      procedure SetRelItemsForJoin(pDest: TSFStmtTable; pRelItems: TSFStmtJoinRelItems);
      function QuotedTableIdentifier: String;
      function QuotedTableName: String;
      function QuotedTableSchema: String;
      function QuotedTableCatalog: String;
      procedure ListJoinTables(pLst: TObjectList<TSFStmtTable>; pRecursive: Boolean = True);
      procedure SaveToXmlTable(pXmlTable: TSFStmtTableXML);
      procedure LoadFromXmlTable(pXmlTable: TSFStmtTableXML; pSuspendRefs: Boolean);
    public
      property TableName: String read mTableName;
      property TableStmt: TSFStmt read getTableStmt;
      property TableAlias: String read getTableAlias;
      property TableAliasNested[pLevel, pSubId, pUnionId: Integer]: String read getTableAliasNested;
      property TableNo: Integer read mTableNo;
      property ParentStmt: TSFStmt read mParentStmt;
      property Schema: String read mSchema;
      property Catalog: String read mCatalog;
      property TableIdentifier: String read getTableIdentifier;
  end;

  TSFStmtTableJoin = class(TObject)
    private
      mSourceTable: TSFStmtTable;
      mDestTable: TSFStmtTable;
      mRelItems: TSFStmtJoinRelItems;
      mType: TSFStmtJoinType;
    public
      function GetJoinDef: String;
      procedure SaveToXmlRelation(pXmlRelation: TSFStmtTableRelationXML);
    public
      constructor Create(pSrcTab, pDestTab: TSFStmtTable; pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType); overload;
      destructor Destroy; override;
    public
      property DestTable: TSFStmtTable read mDestTable;
  end;

  TSFStmtAttr = class(TObject)
    private
      mAttrName: String;
      mParentStmt: TSFStmt;
      mSortType: TSFStmtSortType;
      mOnlyForSearch: Boolean;
      mItems: TObjectList<TSFStmtAttrItem>;
    private
      function getDBAttrName: String;
      function getDBAttrTable: TSFStmtTable;
      function getDBAttrAggr: String;
    public
      constructor Create(pParentStmt: TSFStmt; pAttrName: String; pOnlyForSearch: Boolean); overload;
      destructor Destroy; override;
    public
      function GetSelectDef: String;
      function GetAttrDef(pWithSortType: Boolean = False; pWithAliases: Boolean = True;
                          pExplicitCast: Boolean = False; pEscapeLike: Boolean = False): String;
      function HasItems: Boolean;
      function IsSingleItem: Boolean;
      function IsSingleDBFieldItem: Boolean;
      function IsSingleDBFieldUndefined: Boolean;
      procedure AddItem(pType: TSFStmtAttrItemType; pTable: TSFStmtTable; pItemValue: Variant; pAggr: String);
      procedure AddItemDbFld(pTable: TSFStmtTable; pAttrName, pAggr: String);
      procedure AddItemValue(pValue: Variant);
      procedure AddItemValueDateTime(pValue: TDateTime);
      procedure AddItemValueDate(pValue: TDate);
      procedure AddItemValueTime(pValue: TTime);
      procedure AddItemStmt(pStmt: TSFStmt); overload;
      procedure AddItemStmt(pStmtName: String); overload;
      procedure AddItemAggrFunc(pAggrFunc: string);
      procedure AddItemParam(pParamName: String);
      procedure AddItemOperator(pType: TSFStmtAttrItemOperatorType);
      procedure AddItemBracket(pType: TSFStmtAttrItemBracketType);
      procedure AddItemDynamic(pValue: String);
      function AssignStmtAttr(pDestStmt: TSFStmt): TSFStmtAttr;
      procedure SetItemParamNamesToList(pLst: TStrings);
      procedure SaveToXmlAttr(pXmlAttr: TSFStmtAttrXML);
      procedure LoadFromXmlAttr(pXmlAttr: TSFStmtAttrXML; pSuspendRefs: Boolean);
    public
      property ParentStmt: TSFStmt read mParentStmt;
      property AttrName: String read mAttrName;
      property DBAttrName: String read getDBAttrName;
      property DBAttrTable: TSFStmtTable read getDBAttrTable;
      property DBAttrAggr: String read getDBAttrAggr;
      property SortType: TSFStmtSortType read mSortType write mSortType;
      property OnlyForSearch: Boolean read mOnlyForSearch;
      property Items: TObjectList<TSFStmtAttrItem> read mItems;
  end;

  TSFStmtAttrItem = class(TObject)
    private
      mAttr: TSFStmtAttr;
      mType: TSFStmtAttrItemType;
      mTable: TSFStmtTable;
      mItemRef: Variant;
      mAggr: String;
    private
      function getItemRef: Variant;
    public
      constructor Create(pAttr: TSFStmtAttr; pType: TSFStmtAttrItemType; pTable: TSFStmtTable; pItemRef: Variant; pAggr: String); overload;
      destructor Destroy; override;
    public
      function GetAttrItemDef(pWithAlias: Boolean; pExplicitCast, pEscapeLike: Boolean): String;
      procedure SaveToXmlAttrItem(pXmlAttrItem: TSFStmtAttrItemXML);
    public
      property Attr: TSFStmtAttr read mAttr;
      property ItemType: TSFStmtAttrItemType read mType;
      property Table: TSFStmtTable read mTable;
      property ItemRef: Variant read getItemRef;
      property Aggr: String read mAggr;
  end;

  TSFStmtCondition = class(TObject)
    private
      function getAttrCondition(pWithAliases: Boolean): String;
    protected
      mParentStmt: TSFStmt;
      mStmtAttr: TSFStmtAttr;
      mType: TSFStmtConditionType;
      mValue: Variant;
      mOperator: String;
    public
      function GetConditionDef(pWithAliases: Boolean): String; virtual;
      function AssignStmtCondition(pDestStmt: TSFStmt): TSFStmtCondition; virtual;
      procedure SaveToXmlCondition(pXmlCond: TSFStmtCondXML); virtual;
    public
      constructor Create(pParentStmt: TSFStmt; pAttr: TSFStmtAttr; pOp: String; pVal: Variant; pType: TSFStmtConditionType); overload;
    public
      property CondType: TSFStmtConditionType read mType;
      property StmtAttr: TSFStmtAttr read mStmtAttr;
      property CondValue: Variant read mValue;
      property CondOperator: String read mOperator;
  end;

  TSFStmtConditionExists = class(TSFStmtCondition)
    private
      mDestStmt: TSFStmt;
      mDestStmtName: String;
      mSrcTable: TSFStmtTable;
      mDestTable: TSFStmtTable;
      mDestTableName: String;
      mRelItems: TSFStmtJoinRelItems;
    private
      function getDestStmt: TSFStmt;
      function getDestTable: TSFStmtTable;
    public
      function GetConditionDef(pWithAliases: Boolean): String; override;
      function AssignStmtCondition(pDestStmt: TSFStmt): TSFStmtCondition; override;
      procedure SaveToXmlCondition(pXmlCond: TSFStmtCondXML); override;
    public
      constructor Create(pDestStmt: TSFStmt; pSrcTable, pDestTable: TSFStmtTable; pRelItems: TSFStmtJoinRelItems; pOp: String); overload;
      constructor Create(pDestStmtName: String; pSrcTable: TSFStmtTable; pDestTableName: String; pRelItems: TSFStmtJoinRelItems; pOp: String); overload;
      destructor Destroy; override;
    public
      property DestStmt: TSFStmt read getDestStmt;
      property SrcTable: TSFStmtTable read mSrcTable;
      property DestTable: TSFStmtTable read getDestTable;
      property RelItems: TSFStmtJoinRelItems read mRelItems;
  end;

  TSFStmtDBDialectConv = class(TObject)
    private
      mStmt: TSFStmt;
    protected
      function ConvertStringValue(pValue: Variant; pEscapeLike: Boolean): String; virtual;
      function ConvertNumValue(pValue: Variant; pUsedDecSeparator: String): String; virtual;
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; virtual;
      function StringToDoubleQuotedString(pString: String): String;
      function HasDatePart(pDate: TDateTime): Boolean;
      function HasTimePart(pDate: TDateTime): Boolean;
      function GetDatePart(pDate: TDateTime): TDate;
      function GetTimePart(pDate: TDateTime): TTime;
      function DateToFormattedString(pDate: TDateTime; pDayBeforeMonth: Boolean = False;
                                    pDateSep: String = '-'; pTimeSep: String = ':';
                                    pGenMilliSec: Boolean = True; pMilliSecSep: String = '.'): String;
    protected
      property Stmt: TSFStmt read mStmt;
    public
      function ConvertValue(pValue: Variant; pUsedDecSeparator: String; pExplicitCast, pEscapeLike: Boolean): String;
      function ValueTypeForValue(pValue: Variant): TSFStmtValueType;
      function EscapeLike(var pValue: String): String;
      function GetNextAutoValue(pSeqName: String = ''): String; virtual;
      function GetLastAutoValue(pSeqName: String = ''): String; virtual;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; virtual;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; virtual;
      class function GetNeedTableOnSubInFrom: Boolean; virtual;
      class function GetStartQuote: String; virtual;
      class function GetEndQuote: String; virtual;
      class function GetLikeWildcardSingle: String; virtual;
      class function GetLikeWildcardMany: String; virtual;
      class function SupportsLikeEscape: Boolean; virtual;
    public
      constructor Create(pStmt: TSFStmt);
  end;

  TSFStmtDBDialectConvOra = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetDummyTableName: String;
  end;

  TSFStmtDBDialectConvDB2 = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetDummyTableName: String;
  end;

  TSFStmtDBDialectConvIfx = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetDummyTableName: String;
  end;

  TSFStmtDBDialectConvAcc = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetNeedTableOnSubInFrom: Boolean; override;
      class function GetStartQuote: String; override;
      class function GetEndQuote: String; override;
      class function GetLikeWildcardSingle: String; override;
      class function GetLikeWildcardMany: String; override;
      class function SupportsLikeEscape: Boolean; override;
  end;

  TSFStmtDBDialectConvFBIB = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetDummyTableName: String;
  end;

  TSFStmtDBDialectConvSQLite = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
  end;

  TSFStmtDBDialectConvPG = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
  end;

  TSFStmtDBDialectConvMySQL = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      function GetNextAutoValue(pSeqName: String = ''): String; override;
      function GetLastAutoValue(pSeqName: String = ''): String; override;
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetStartQuote: String; override;
      class function GetEndQuote: String; override;
  end;

  TSFStmtDBDialectConvMSSQL = class(TSFStmtDBDialectConv)
    protected
      function ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String; override;
    public
      class function GetCanSelectWithoutTable(var pTableName: String): Boolean; override;
      class function GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean; override;
      class function GetStartQuote: String; override;
      class function GetEndQuote: String; override;
  end;

implementation

uses System.Variants, Data.SqlTimSt, Data.FmtBcd, System.StrUtils, System.DateUtils,
     SFBusinessDataDemoHelp;

// ===========================================================================//
//                                  TSFStmt                                    //
// ===========================================================================//

// constructor
constructor TSFStmt.Create(pOwner: TComponent);
begin
  inherited;

  mBaseTable := nil;
  mStmtAttrs := TObjectList<TSFStmtAttr>.Create(True);
  mStmtConditions := TObjectList<TSFStmtCondition>.Create(True);
  mStmtOrder := TObjectList<TSFStmtAttr>.Create(False);
  mStmtGroup := TObjectList<TSFStmtAttr>.Create(False);

  mRestrAttrs := TObjectList<TSFStmtAttr>.Create(True);
  mRestrConditions := TObjectList<TSFStmtCondition>.Create(True);

  mClientRestrConditions := TObjectList<TSFStmtCondition>.Create(True);

  mSetAttrs := TObjectList<TSFStmtAttr>.Create(True);
  mInsAttrs := TObjectList<TSFStmtAttr>.Create(True);
  mSetConditions  := TObjectList<TSFStmtCondition>.Create(True);
  mInsConditions := TObjectList<TSFStmtCondition>.Create(True);

  mUnion := nil;
  mUnionName := '';

  mGenerateLevel := 0;
  mGenerateSubId := 0;
  mGenerateUnionId := 0;
  mQuoteType := stmtQuoteTypeNone;
  mDBDialect := stmtDBDDflt;
  mOnGetDBDialectCls := nil;

  mOnBeforeGenSelect := nil;
  mOnAfterGenSelect := nil;
  mOnBeforeGenDelete := nil;
  mOnAfterGenDelete := nil;
  mOnBeforeGenUpdate := nil;
  mOnAfterGenUpdate := nil;
  mOnBeforeGenInsert := nil;
  mOnAfterGenInsert := nil;

  mUseDistinct := False;
  mLikeEscapeChar := '';
  mAutoEscapeLike := True;

  mDfltFrmtSettings := TFormatSettings.Create;
end;

// destructor
destructor TSFStmt.Destroy;
begin
  inherited;

  Reset;

  ClearBaseRestrictions;

  FreeAndNil(mStmtOrder);
  FreeAndNil(mStmtGroup);
  FreeAndNil(mStmtAttrs);
  FreeAndNil(mStmtConditions);
  FreeAndNil(mRestrAttrs);
  FreeAndNil(mRestrConditions);
  FreeAndNil(mClientRestrConditions);
  FreeAndNil(mSetAttrs);
  FreeAndNil(mInsAttrs);
  FreeAndNil(mSetConditions);
  FreeAndNil(mInsConditions);

  FreeAndNil(mBaseTable);

  if (Assigned(mUnion)) and (mUnion.Owner = nil) then
    mUnion.Free;
  mUnion := nil;
  mUnionName := '';
end;

// define the main-table of stmt
function TSFStmt.SetBaseTable(pTableName, pSchema, pCatalog, pTableAlias: String): TSFStmtTable;
begin
  Reset;

  if (Assigned(mBaseTable)) then
    FreeAndNil(mBaseTable);

  mBaseTable := TSFStmtTable.Create(pTableName, pSchema, pCatalog, pTableAlias, 1, Self);

  Result := mBaseTable;
end;

function TSFStmt.SetBaseTable(pStmt: TSFStmt; pTableAlias: String): TSFStmtTable;
begin
  Reset;

  if (Assigned(mBaseTable)) then
    FreeAndNil(mBaseTable);

  mBaseTable := TSFStmtTable.Create(pStmt, pTableAlias, 1, Self);

  Result := mBaseTable;
end;

function TSFStmt.SetBaseTable(pStmtName, pTableAlias: String): TSFStmtTable;
begin
  Reset;

  if (Assigned(mBaseTable)) then
    FreeAndNil(mBaseTable);

  mBaseTable := TSFStmtTable.Create(pStmtName, pTableAlias, 1, Self);

  Result := mBaseTable;
end;

procedure TSFStmt.ReconfigBaseTable(pTableName, pSchema, pCatalog, pTableAlias: String);
begin
  if not(Assigned(mBaseTable)) or (mBaseTable.mTableStmt <> nil) or (mBaseTable.mTableStmtName <> '') then
    SetBaseTable(pTableName, pSchema, pCatalog, pTableAlias)
  else
  begin
    mBaseTable.mTableName := pTableName;
    mBaseTable.mSchema := pSchema;
    mBaseTable.mCatalog := pCatalog;
    if (pTableAlias <> '') then
      mBaseTable.mTableAlias := pTableAlias;
  end;
end;

// add a attribute with given name to stmt
function TSFStmt.AddStmtAttr(pAttrName: String; pOnlyForSearch: Boolean): TSFStmtAttr;
begin
  Result := TSFStmtAttr.Create(Self, pAttrName, pOnlyForSearch);
  mStmtAttrs.Add(Result);
end;

// add a select-attribute to stmt
procedure TSFStmt.SetStmtAttr(pAttrName, pAttrAlias, pTableAlias: String; pOnlyForSearch: Boolean);
  var lTable: TSFStmtTable;
begin
  if not(Assigned(mBaseTable)) then
    Exit;

  lTable := nil;
  if (pTableAlias <> '') then
    lTable := getTableByAlias(pTableAlias);

  if (pTableAlias = '') or (Assigned(lTable)) then
    SetStmtAttr(pAttrName, pAttrAlias, lTable, pOnlyForSearch);
end;

// add a select-attribute to stmt
procedure TSFStmt.SetStmtAttr(pAttrName, pAttrAlias: String; pStmtTable: TSFStmtTable; pOnlyForSearch: Boolean);
  var lStmtAttr: TSFStmtAttr;
begin
  if (Trim(pAttrName) = '') or not(Assigned(pStmtTable)) then
    Exit;

  lStmtAttr := AddStmtAttr(pAttrAlias, pOnlyForSearch);
  lStmtAttr.AddItemDbFld(pStmtTable, pAttrName, '');
end;

procedure TSFStmt.SetStmtAggr(pAggr, pAttrName, pAttrAlias, pTableAlias: String);
  var lTable: TSFStmtTable;
begin
  if not(Assigned(mBaseTable)) then
    Exit;

  lTable := nil;
  if (pTableAlias <> '') then
    lTable := getTableByAlias(pTableAlias);

  if (Trim(pTableAlias) = '') or (Assigned(lTable)) then
    SetStmtAggr(pAggr, pAttrName, pAttrAlias, lTable);
end;

procedure TSFStmt.SetStmtAggr(pAggr, pAttrName, pAttrAlias: String; pStmtTable: TSFStmtTable);
  var lStmtAttr: TSFStmtAttr;
begin
  if (Trim(pAttrName) = '') or not(Assigned(pStmtTable)) and (pAttrName <> SFSTMTATTR_UNDEFINED) then
    Exit;

  lStmtAttr := AddStmtAttr(pAttrAlias, False);
  lStmtAttr.AddItemDbFld(pStmtTable, pAttrName, pAggr);
end;

// add a join to stmt
function TSFStmt.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTableAlias: String;
                                pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
  var lSrcTable: TSFStmtTable;
begin
  Result := nil;

  if not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  if (Assigned(lSrcTable)) then
    Result := SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, lSrcTable, pRelItems, pType);
end;

function TSFStmt.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTableAlias: String;
                              const pRelValsDest, pRelValsSource: Array of Variant;
                              const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                              pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTableAlias,
                        createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pType);
end;

// add a join to stmt - destination is another stmt
function TSFStmt.SetTableJoin(pTableAlias, pSourceTableAlias: String; pDestStmt: TSFStmt;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
  var lSrcTable: TSFStmtTable;
begin
  Result := nil;

  if not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  if (Assigned(lSrcTable)) then
    Result := SetTableJoin(pTableAlias, lSrcTable, pDestStmt, pRelItems, pType);
end;

function TSFStmt.SetTableJoin(pTableAlias, pSourceTableAlias: String; pDestStmt: TSFStmt;
                              const pRelValsDest, pRelValsSource: Array of Variant;
                              const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                              pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := SetTableJoin(pTableAlias, pSourceTableAlias, pDestStmt,
                        createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pType);
end;

// add a join to stmt
function TSFStmt.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pSourceTable: TSFStmtTable;
                                pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := nil;

  if not(Assigned(pSourceTable)) or (Trim(pTableName) = '') then
    Exit;

  Result := pSourceTable.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, GetNextTableNo, pRelItems, pType);
end;

function TSFStmt.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pSourceTable: TSFStmtTable;
                              const pRelValsDest, pRelValsSource: Array of Variant;
                              const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                              pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog, pSourceTable,
                        createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pType);
end;

// add a join to stmt - destination is another stmt
function TSFStmt.SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmt: TSFStmt;
                                pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := nil;

  if not(Assigned(pSourceTable)) or not(Assigned(pDestStmt)) then
    Exit;

  Result := pSourceTable.SetTableJoin(pTableAlias, pDestStmt, GetNextTableNo, pRelItems, pType);
end;

function TSFStmt.SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmt: TSFStmt;
                              const pRelValsDest, pRelValsSource: Array of Variant;
                              const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                              pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := SetTableJoin(pTableAlias, pSourceTable, pDestStmt,
                        createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pType);
end;

function TSFStmt.SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmtName: String;
                            pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := nil;

  if not(Assigned(pSourceTable)) or (Trim(pDestStmtName) = '') then
    Exit;

  Result := pSourceTable.SetTableJoin(pTableAlias, Trim(pDestStmtName), GetNextTableNo, pRelItems, pType);
end;

function TSFStmt.SetTableJoin(pTableAlias: String; pSourceTable: TSFStmtTable; pDestStmtName: String;
                            const pRelValsDest, pRelValsSource: Array of Variant;
                            const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                            pType: TSFStmtJoinType): TSFStmtTable;
begin
  Result := SetTableJoin(pTableAlias, pSourceTable, pDestStmtName,
                        createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pType);
end;

// modify type of a join
procedure TSFStmt.ModfiyTableJoinType(pDestTableAlias, pSourceTableAlias: String;
                                    pTypeFrom, pTypeTo: TSFStmtJoinType);
  var lSrcTable, lDestTable: TSFStmtTable;
begin
  if not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  lDestTable := getTableByAlias(pDestTableAlias);
  if (Assigned(lSrcTable)) then
    ModfiyTableJoinType(lDestTable, lSrcTable, pTypeFrom, pTypeTo);
end;

// modify type of a join
procedure TSFStmt.ModfiyTableJoinType(pDestTable, pSourceTable: TSFStmtTable;
                                    pTypeFrom, pTypeTo: TSFStmtJoinType);
begin
  if (Assigned(pSourceTable)) then
    pSourceTable.ModifyJoinType(pDestTable, pTypeFrom, pTypeTo);
end;

// detect joins from a given attribute
function TSFStmt.TableJoinAliasesForAttr(pSourceTableAlias, pAttr: String): Variant;
  var lSrcTable: TSFStmtTable;
begin
  Result := NULL;

  if not(Assigned(mBaseTable)) or (Trim(pSourceTableAlias) = '') then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  if (Assigned(lSrcTable)) then
    Result := TableJoinAliasesForAttr(lSrcTable, pAttr);
end;

// detect joins from a given attribute
function TSFStmt.TableJoinAliasesForAttr(pSourceTable: TSFStmtTable; pAttr: String): Variant;
begin
  Result := NULL;

  if (Assigned(pSourceTable)) then
    Result := pSourceTable.GetJoinTableAliasesForAttr(pAttr);
end;

// detect relitems for a given join
function TSFStmt.GetRelItemsForJoin(pSourceTable, pDestTable: TSFStmtTable): TSFStmtJoinRelItems;
begin
  if (Assigned(pSourceTable)) and (Assigned(pDestTable)) then
    Result := pSourceTable.GetRelItemsForJoin(pDestTable);
end;

// detect relitems for a given join
function TSFStmt.GetRelItemsForJoin(pSourceTableAlias, pDestTableAlias: String): TSFStmtJoinRelItems;
  var lSrcTable, lDestTable: TSFStmtTable;
begin
  if not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  lDestTable := getTableByAlias(pDestTableAlias);
  if (Assigned(lSrcTable)) then
    Result := GetRelItemsForJoin(lSrcTable, lDestTable);
end;

// set relitems for a given join
procedure TSFStmt.SetRelItemsForJoin(pSourceTable, pDestTable: TSFStmtTable; pRelItems: TSFStmtJoinRelItems);
begin
  if (Assigned(pSourceTable)) and (Assigned(pDestTable)) then
    pSourceTable.SetRelItemsForJoin(pDestTable, pRelItems);
end;

// set relitems for a given join
procedure TSFStmt.SetRelItemsForJoin(pSourceTableAlias, pDestTableAlias: String; pRelItems: TSFStmtJoinRelItems);
  var lSrcTable, lDestTable: TSFStmtTable;
begin
  if not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pSourceTableAlias);
  lDestTable := getTableByAlias(pDestTableAlias);
  if (Assigned(lSrcTable)) then
    SetRelItemsForJoin(lSrcTable, lDestTable, pRelItems);
end;

// detect the next table-no
function TSFStmt.GetNextTableNo: Integer;
begin
  Result := 1;

  if (Assigned(mBaseTable)) then
    Result := mBaseTable.GetMaxTableNo + 1;
end;

// add a condition with value (p. e. t1.attr = 1)
procedure TSFStmt.AddConditionVal(pTableAlias, pAttrName, pOp: String; pVal: Variant; pRestrict: Boolean = False);
  var lAttr: TSFStmtAttr;
      lCond: TSFStmtCondition;
begin
  lAttr := getAttrByName(pAttrName, pTableAlias);
  if (Assigned(lAttr)) and not lAttr.IsSingleDBFieldUndefined then
  begin
    lCond := TSFStmtCondition.Create(Self, lAttr, pOp, pVal, stmtCondTypeValue);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

// add a condition with attribute (p. e. t1.attr = t2.attr)
procedure TSFStmt.AddConditionAttr(pSrcTabAlias, pSrcAttrName, pOp, pDestTabAlias, pDestAttrName: String; pRestrict: Boolean = False);
  var lSrcAttr, lDestAttr: TSFStmtAttr;
      lCond: TSFStmtCondition;
begin
  lSrcAttr := getAttrByName(pSrcAttrName, pSrcTabAlias);
  lDestAttr := getAttrByName(pDestAttrName, pDestTabAlias);
  if (Assigned(lSrcAttr)) and not lSrcAttr.IsSingleDBFieldUndefined and (Assigned(lDestAttr)) and not lDestAttr.IsSingleDBFieldUndefined then
  begin
    lCond := TSFStmtCondition.Create(Self, lSrcAttr, pOp, Integer(Pointer(@lDestAttr)^), stmtCondTypeAttribute);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

// add a condition with "is null" (p. e. t1.attr is null)
procedure TSFStmt.AddConditionIsNull(pTableAlias, pAttrName: String; pRestrict: Boolean = False);
  var lAttr: TSFStmtAttr;
      lCond: TSFStmtCondition;
begin
  lAttr := getAttrByName(pAttrName, pTableAlias);
  if (Assigned(lAttr)) and not lAttr.IsSingleDBFieldUndefined then
  begin
    lCond := TSFStmtCondition.Create(Self, lAttr, '', '', stmtCondTypeIsNull);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

// add a condition with "is not null" (p. e. t1.attr is not null)
procedure TSFStmt.AddConditionIsNotNull(pTableAlias, pAttrName: String; pRestrict: Boolean = False);
  var lAttr: TSFStmtAttr;
      lCond: TSFStmtCondition;
begin
  lAttr := getAttrByName(pAttrName, pTableAlias);
  if (Assigned(lAttr)) and not lAttr.IsSingleDBFieldUndefined then
  begin
    lCond := TSFStmtCondition.Create(Self, lAttr, '', '', stmtCondTypeIsNotNull);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

// add a condition-type (p. e. brackets, and, or)
procedure TSFStmt.AddConditionType(pType: TSFStmtConditionType; pRestrict: Boolean = False);
  var lCond: TSFStmtCondition;
begin
  lCond := TSFStmtCondition.Create(Self, nil, '', NULL, pType);
  if (pRestrict) then
    mClientRestrConditions.Add(lCond)
  else
    mStmtConditions.Add(lCond);
end;

procedure TSFStmt.AddConditionExists(pDestStmt: TSFStmt; pTableAlias, pDestTableAlias, pOp: String;
                                      pRelItems: TSFStmtJoinRelItems; pRestrict: Boolean = False);
  var lSrcTable, lDestTable: TSFStmtTable;
      lCond: TSFStmtCondition;
begin
  if not(Assigned(pDestStmt)) or not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pTableAlias);
  lDestTable := pDestStmt.getTableByAlias(pDestTableAlias);

  if (Assigned(lSrcTable)) and (Assigned(lDestTable)) then
  begin
    lCond := TSFStmtConditionExists.Create(pDestStmt, lSrcTable, lDestTable, pRelItems, pOp);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

procedure TSFStmt.AddConditionExists(pDestStmt: TSFStmt; pTableAlias, pDestTableAlias, pOp: String;
                                    const pRelValsDest, pRelValsSource: Array of Variant;
                                    const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                                    pRestrict: Boolean = False);
begin
  AddConditionExists(pDestStmt, pTableAlias, pDestTableAlias, pOp,
                    createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pRestrict);
end;

procedure TSFStmt.AddConditionExists(pDestStmtName, pTableAlias, pDestTableAlias, pOp: String;
                                    pRelItems: TSFStmtJoinRelItems; pRestrict: Boolean = False);
  var lSrcTable: TSFStmtTable;
      lCond: TSFStmtCondition;
begin
  if (Trim(pDestStmtName) = '') or not(Assigned(mBaseTable)) then
    Exit;

  lSrcTable := getTableByAlias(pTableAlias);

  if (Assigned(lSrcTable)) then
  begin
    lCond := TSFStmtConditionExists.Create(Trim(pDestStmtName), lSrcTable, pDestTableAlias, pRelItems, pOp);
    if (pRestrict) then
      mClientRestrConditions.Add(lCond)
    else
      mStmtConditions.Add(lCond);
  end;
end;

procedure TSFStmt.AddConditionExists(pDestStmtName, pTableAlias, pDestTableAlias, pOp: String;
                                    const pRelValsDest, pRelValsSource: Array of Variant;
                                    const pRelTypesDest, pRelTypesSource: Array of TSFStmtJoinRelItemType;
                                    pRestrict: Boolean = False);
begin
  AddConditionExists(pDestStmtName, pTableAlias, pDestTableAlias, pOp,
                    createRelItems(pRelValsSource, pRelValsDest, pRelTypesSource, pRelTypesDest), pRestrict);
end;

// define a attribute as order
procedure TSFStmt.AddOrderAttr(pTableAlias, pAttrName: String; pOrderType: TSFStmtSortType);
  var lAttr: TSFStmtAttr;
begin
  lAttr := getAttrByName(pAttrName, pTableAlias);
  if (Assigned(lAttr)) and not lAttr.IsSingleDBFieldUndefined then
  begin
    lAttr.SortType := pOrderType;
    mStmtOrder.Add(lAttr);
  end;
end;

// define a attribute as group
procedure TSFStmt.AddGroupAttr(pTableAlias, pAttrName: String);
  var lAttr: TSFStmtAttr;
begin
  lAttr := getAttrByName(pAttrName, pTableAlias);
  if (Assigned(lAttr)) and not lAttr.IsSingleDBFieldUndefined then
    mStmtGroup.Add(lAttr);
end;

procedure TSFStmt.AddSetCondition(pAttrName: String; pVal: Variant; pValType: TSFStmtAttrItemValueType);
  var lAttrFld, lAttrVal: TSFStmtAttr;
      lSetCond: TSFStmtCondition;
begin
  if (pAttrName = '') or (pValType = stmtAttrItemTypeParameter) and ((VarIsNull(pVal)) or (VarIsEmpty(pVal))) then
    Exit;

  lAttrFld := TSFStmtAttr.Create(Self, '', False);
  lAttrFld.AddItemDbFld(mBaseTable, pAttrName, '');
  mSetAttrs.Add(lAttrFld);

  lAttrVal := TSFStmtAttr.Create(Self, '', False);
  lAttrVal.AddItem(TSFStmtAttrItemType(pValType), nil, pVal, '');
  mSetAttrs.Add(lAttrVal);

  lSetCond := TSFStmtCondition.Create(Self, lAttrFld, SFSTMT_OP_EQUAL, Integer(Pointer(@lAttrVal)^), stmtCondTypeAttribute);
  mSetConditions.Add(lSetCond);
end;

procedure TSFStmt.AddInsertCondition(pAttrName: String; pVal: Variant; pValType: TSFStmtAttrItemValueType);
  var lAttrFld, lAttrVal: TSFStmtAttr;
      lInsCond: TSFStmtCondition;
begin
  if (pAttrName = '') or (pValType = stmtAttrItemTypeParameter) and ((VarIsNull(pVal)) or (VarIsEmpty(pVal))) then
    Exit;

  lAttrFld := TSFStmtAttr.Create(Self, '', False);
  lAttrFld.AddItemDbFld(mBaseTable, pAttrName, '');
  mInsAttrs.Add(lAttrFld);

  lAttrVal := TSFStmtAttr.Create(Self, '', False);
  lAttrVal.AddItem(TSFStmtAttrItemType(pValType), nil, pVal, '');
  mInsAttrs.Add(lAttrVal);

  lInsCond := TSFStmtCondition.Create(Self, lAttrFld, SFSTMT_OP_EQUAL, Integer(Pointer(@lAttrVal)^), stmtCondTypeAttribute);
  mInsConditions.Add(lInsCond);
end;

// reset stmt
procedure TSFStmt.Reset;
begin
  ClearOrder;
  ClearGroup;

  mStmtAttrs.Clear;

  ClearConditions;

  // on reset clear client-restrictions
  ClearClientRectrictions;

  ClearSetConditions;
  ClearInsConditions;

  if (Assigned(mUnion)) and (mUnion.Owner = nil) then
    mUnion.Free;
  mUnion := nil;
  mUnionName := '';

  if (Assigned(mBaseTable)) and (mBaseTable.HasJoins) then
    mBaseTable.ResetJoins;
end;

// generate the select-stmt
function TSFStmt.GetSelectStmt(pLevel: Integer = 0; pSubId: Integer = 0; pUnionId: Integer = 0): String;
  var lSelAttr, lSelDef, lFromDef, lWhereDef, lGrpDef, lOrderDef: String;
      i, lGenLevelSave, lGenerateSubIdSave, lGenerateUnionIdSave: Integer;
      lUnion: TSFStmt;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  mStmtGenInfos := [];

  Result := '';

  if (Assigned(mOnBeforeGenSelect)) then
    mOnBeforeGenSelect(Self, pLevel, pSubId, pUnionId);

  lGenLevelSave := mGenerateLevel;
  lGenerateSubIdSave := mGenerateSubId;
  lGenerateUnionIdSave := mGenerateUnionId;

  mGenerateLevel := pLevel;
  mGenerateSubId := pSubId;
  mGenerateUnionId := pUnionId;

  lSelDef := '';
  if (hasVisibleAttrs(mStmtAttrs)) then
  begin
    // set restrattrs only to select, if other attrs exists
    for i := 0 to (mRestrAttrs.Count - 1) do
    begin
      lSelAttr := mRestrAttrs[i].GetSelectDef;
      if (lSelAttr = '') then
        Continue;

      if (lSelDef <> '') then
        lSelDef := lSelDef + ', ';

      lSelDef := lSelDef + lSelAttr;
    end;
  end;

  for i := 0 to (mStmtAttrs.Count - 1) do
  begin
    lSelAttr := mStmtAttrs[i].GetSelectDef;
    if (lSelAttr = '') then
      Continue;

    if (lSelDef <> '') then
      lSelDef := lSelDef + ', ';

    lSelDef := lSelDef + lSelAttr;
  end;

  lFromDef := '';
  if (Assigned(mBaseTable)) then
    lFromDef := mBaseTable.GetTableDef;

  lWhereDef := '';
  setWhereConditions(lWhereDef, mRestrConditions, True);
  setWhereConditions(lWhereDef, mClientRestrConditions, True);
  setWhereConditions(lWhereDef, mStmtConditions, (mRestrConditions.Count > 0) or (mClientRestrConditions.Count > 0));

  lGrpDef := '';
  for i := 0 to (mStmtGroup.Count - 1) do
  begin
    if (lGrpDef <> '') then
      lGrpDef := lGrpDef + ', ';

    lGrpDef := lGrpDef + mStmtGroup[i].GetAttrDef;
  end;

  lOrderDef := '';
  if (pLevel = 0) then
  begin
    for i := 0 to (mStmtOrder.Count - 1) do
    begin
      if (lOrderDef <> '') then
        lOrderDef := lOrderDef + ', ';

      lOrderDef := lOrderDef + mStmtOrder[i].GetAttrDef(True);
    end;
  end;

  Result := 'SELECT ';
  mStmtGenInfos := mStmtGenInfos + [stmtGenSelect];

  if (lSelDef <> '') then
  begin
    if (mUseDistinct) then
      Result := Result + ' DISTINCT ';
    Result := Result + lSelDef
  end else
    Result := Result + SFSTMTATTR_UNDEFINED;

  if (lFromDef <> '') then
  begin
    Result := Result + ' FROM ' + lFromDef;
    mStmtGenInfos := mStmtGenInfos + [stmtGenFrom];
  end;

  if (lWhereDef <> '') then
  begin
    Result := Result + ' WHERE ' + lWhereDef;
    mStmtGenInfos := mStmtGenInfos + [stmtGenWhere];
  end;

  if (lGrpDef <> '') then
  begin
    Result := Result + ' GROUP BY ' + lGrpDef;
    mStmtGenInfos := mStmtGenInfos + [stmtGenGroup];
  end;

  if (lOrderDef <> '') then
  begin
    Result := Result + ' ORDER BY ' + lOrderDef;
    mStmtGenInfos := mStmtGenInfos + [stmtGenOrder];
  end;

  lUnion := Union;
  if (Assigned(lUnion)) then
  begin
    lUnion.DBDialect := mDBDialect;
    lUnion.QuoteType := mQuoteType;
    lUnion.AutoEscapeLike := mAutoEscapeLike;

    Result := Result + Chr(13) + Chr(10) + 'UNION' + Chr(13) + Chr(10);
    Result := Result + lUnion.GetSelectStmt(pLevel, pSubId, pUnionId + 1);
  end;

  mGenerateLevel := lGenLevelSave;
  mGenerateSubId := lGenerateSubIdSave;
  mGenerateUnionId := lGenerateUnionIdSave;

  if (Assigned(mOnAfterGenSelect)) then
    mOnAfterGenSelect(Self, pLevel, pSubId, pUnionId);
end;

function TSFStmt.GetDeleteStmt: String;
  var lFromDef, lWhereDef: String;
      lGenLevelSave, lGenerateSubIdSave, lGenerateUnionIdSave: Integer;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  Result := '';

  if not(Assigned(mBaseTable)) or (mBaseTable.HasJoins) or (Assigned(mBaseTable.TableStmt)) then
    Exit;

  if (Assigned(mOnBeforeGenDelete)) then
    mOnBeforeGenDelete(Self, 0, 0, 0);

  lGenLevelSave := mGenerateLevel;
  lGenerateSubIdSave := mGenerateSubId;
  lGenerateUnionIdSave := mGenerateUnionId;

  mGenerateLevel := 0;
  mGenerateSubId := 0;
  mGenerateUnionId := 0;

  lFromDef := mBaseTable.GetTableDef(False);
  if (lFromDef <> '') then
    Result := 'DELETE FROM ' + lFromDef
  else
    Exit;

  lWhereDef := '';
  setWhereConditions(lWhereDef, mRestrConditions, True, False);
  setWhereConditions(lWhereDef, mClientRestrConditions, True, False);
  setWhereConditions(lWhereDef, mStmtConditions, (mRestrConditions.Count > 0) or (mClientRestrConditions.Count > 0), False);

  if (lWhereDef <> '') then
    Result := Result + ' WHERE ' + lWhereDef;

  mGenerateLevel := lGenLevelSave;
  mGenerateSubId := lGenerateSubIdSave;
  mGenerateUnionId := lGenerateUnionIdSave;

  if (Assigned(mOnAfterGenDelete)) then
    mOnAfterGenDelete(Self, 0, 0, 0);
end;

// generate the update-statement
function TSFStmt.GetUpdateStmt: String;
  var lFromDef, lSetDef, lWhereDef: String;
      i, lGenLevelSave, lGenerateSubIdSave, lGenerateUnionIdSave: Integer;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  Result := '';

  if not(Assigned(mBaseTable)) or (mBaseTable.HasJoins) or (Assigned(mBaseTable.TableStmt)) then
    Exit;

  if (Assigned(mOnBeforeGenUpdate)) then
    mOnBeforeGenUpdate(Self, 0, 0, 0);

  lGenLevelSave := mGenerateLevel;
  lGenerateSubIdSave := mGenerateSubId;
  lGenerateUnionIdSave := mGenerateUnionId;

  mGenerateLevel := 0;
  mGenerateSubId := 0;
  mGenerateUnionId := 0;

  lFromDef := mBaseTable.GetTableDef(False);
  if (lFromDef <> '') then
    Result := 'UPDATE ' + lFromDef
  else
    Exit;

  // set conditions
  lSetDef := '';
  for i := 0 to (mSetConditions.Count - 1) do
  begin
    if (lSetDef <> '') then
      lSetDef := lSetDef + ', ';

    lSetDef := lSetDef + mSetConditions[i].GetConditionDef(False);
  end;

  if (lSetDef <> '') then
    Result := Result + ' SET ' + lSetDef;

  lWhereDef := '';
  setWhereConditions(lWhereDef, mRestrConditions, True, False);
  setWhereConditions(lWhereDef, mClientRestrConditions, True, False);
  setWhereConditions(lWhereDef, mStmtConditions, (mRestrConditions.Count > 0) or (mClientRestrConditions.Count > 0), False);

  if (lWhereDef <> '') then
    Result := Result + ' WHERE ' + lWhereDef;

  mGenerateLevel := lGenLevelSave;
  mGenerateSubId := lGenerateSubIdSave;
  mGenerateUnionId := lGenerateUnionIdSave;

  if (Assigned(mOnAfterGenUpdate)) then
    mOnAfterGenUpdate(Self, 0, 0, 0);
end;

// generate the insert-statement
function TSFStmt.GetInsertStmt: String;
  var lFromDef, lAttrDef, lValuesDef: String;
      i: Integer;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  Result := '';

  if not(Assigned(mBaseTable)) or (mBaseTable.HasJoins) or (Assigned(mBaseTable.TableStmt)) then
    Exit;

  if (Assigned(mOnBeforeGenInsert)) then
    mOnBeforeGenInsert(Self, 0, 0, 0);

  lFromDef := mBaseTable.GetTableDef(False);
  if (lFromDef <> '') then
    Result := 'INSERT INTO ' + lFromDef
  else
    Exit;

  // set insert-attributes and -values
  lAttrDef := '';
  lValuesDef := '';
  for i := 0 to (mInsConditions.Count - 1) do
  begin
    if (lAttrDef = '') then
      lAttrDef := '('
    else
      lAttrDef := lAttrDef + ', ';

    lAttrDef := lAttrDef + mInsConditions[i].StmtAttr.GetAttrDef(False, False);

    if (lValuesDef = '') then
      lValuesDef := 'VALUES('
    else
      lValuesDef := lValuesDef + ', ';

    lValuesDef := lValuesDef + TSFStmtAttr(Pointer(Integer(mInsConditions[i].CondValue))).GetAttrDef(False, False);
  end;

  if (lAttrDef <> '') and (lValuesDef <> '') then
  begin
    lAttrDef := lAttrDef + ')';
    lValuesDef := lValuesDef + ')';

    Result := Result + lAttrDef + ' ' + lValuesDef;
  end;

  if (Assigned(mOnAfterGenInsert)) then
    mOnAfterGenInsert(Self, 0, 0, 0);
end;

function TSFStmt.GetNextAutoValueStmt(pRefName: String = ''): String;
  var lConverter: TSFStmtDBDialectConv;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  lConverter := detectDBDialectConvCls.Create(Self);
  try
    Result := lConverter.GetNextAutoValue(pRefName);
  finally
    FreeAndNil(lConverter);
  end;
end;

function TSFStmt.GetLastAutoValueStmt(pRefName: String = ''): String;
  var lConverter: TSFStmtDBDialectConv;
begin
  if not(TSFBDSDemoHelper.ValidateDemo(Self)) then
    SFStmtError(stmtErrStmtDemoExpired, []);

  lConverter := detectDBDialectConvCls.Create(Self);
  try
    Result := lConverter.GetLastAutoValue(pRefName);
  finally
    FreeAndNil(lConverter);
  end;
end;

function TSFStmt.GetDBDialectCanSelWithoutTab(var pTableName: String): Boolean;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := False;
  pTableName := '';

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.GetCanSelectWithoutTable(pTableName);
end;

function TSFStmt.GetDBDialectCanSubInFrom: Boolean;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := False;

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.GetCanSelectInFrom(mDBDialect);
end;

function TSFStmt.GetDBDialectNeedTableOnSubInFrom: Boolean;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := False;

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.GetNeedTableOnSubInFrom;
end;

function TSFStmt.GetDBDialectLikeWildcardSingle: String;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := '';

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.GetLikeWildcardSingle;
end;

function TSFStmt.GetDBDialectLikeWildcardMany: String;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := '';

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.GetLikeWildcardMany;
end;

function TSFStmt.GetDBDialectLikeSupportsEscape: Boolean;
  var lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := False;

  lConvCls := detectDBDialectConvCls;
  if (lConvCls <> nil) then
    Result := lConvCls.SupportsLikeEscape;
end;

// add a base-restriction (for special separated conditions)
procedure TSFStmt.AddBaseRestriction(pTableAlias, pAttrName: String; pVal: Variant; pVisible, pPreventNull: Boolean);
  var lTable: TSFStmtTable;
      lAttr: TSFStmtAttr;
      lCond: TSFStmtCondition;
begin
  if not(Assigned(mBaseTable)) or (pAttrName = '') or (pAttrName = SFSTMTATTR_UNDEFINED) then
    Exit;

  if (pTableAlias <> '') then
    lAttr := getAttrByName(pAttrName, pTableAlias)
  else
    lAttr := getAttrByName(pAttrName, mBaseTable.TableAlias);

  if not(Assigned(lAttr)) then
  begin
    lTable := getTableByAlias(pTableAlias);
    if not(Assigned(lTable)) then
      lTable := mBaseTable;

    lAttr := TSFStmtAttr.Create(Self, '', not(pVisible) or not(hasVisibleAttrs(mStmtAttrs)));
    lAttr.AddItemDbFld(lTable, pAttrName, '');

    mRestrAttrs.Add(lAttr);
  end;

  if (VarIsNull(pVal)) or (VarIsEmpty(pVal)) then
  begin
    lCond := TSFStmtCondition.Create(Self, lAttr, '', NULL, stmtCondTypeIsNull);
    mRestrConditions.Add(lCond);
    if (pPreventNull) then
    begin
      lCond := TSFStmtCondition.Create(Self, lAttr, '', NULL, stmtCondTypeIsNotNull);
      mRestrConditions.Add(lCond);
    end;
  end else
  begin
    lCond := TSFStmtCondition.Create(Self, lAttr, SFSTMT_OP_EQUAL, pVal, stmtCondTypeValue);
    mRestrConditions.Add(lCond);
  end;
end;

// clear restrictions
procedure TSFStmt.ClearBaseRestrictions;
begin
  mRestrConditions.Clear;
  mRestrAttrs.Clear;
end;

// clear all conditions
procedure TSFStmt.ClearConditions;
begin
  mStmtConditions.Clear;
end;

// clear client-restrictions
procedure TSFStmt.ClearClientRectrictions;
begin
  mClientRestrConditions.Clear;
end;

// clear order
procedure TSFStmt.ClearOrder;
begin
  mStmtOrder.Clear;
end;

procedure TSFStmt.ClearGroup;
begin
  mStmtGroup.Clear;
end;

procedure TSFStmt.ClearSetConditions;
begin
  mSetAttrs.Clear;
  mSetConditions.Clear;
end;

procedure TSFStmt.ClearInsConditions;
begin
  mInsAttrs.Clear;
  mInsConditions.Clear;
end;

// check, given attribute exists
function TSFStmt.AttrExists(pAttrName, pTableAlias, pAggr: String): Boolean;
begin
  Result := Assigned(getAttrByName(pAttrName, pTableAlias, pAggr));
end;

function TSFStmt.AttrDisplayName(pAttrName, pTableAlias: String): String;
  var lAttr: TSFStmtAttr;
begin
  Result := '';

  lAttr := getAttrByName(pAttrName, pTableAlias, '');
  if (Assigned(lAttr)) then
  begin
    if (lAttr.AttrName <> '') then
      Result := lAttr.AttrName
    else if (lAttr.IsSingleDBFieldItem) then
      Result := lAttr.DBAttrName;
  end;
end;

function TSFStmt.GetTableNameForAttr(var pAttrName: String; pIncludeInvisible: Boolean): String;
  var lTable: TSFStmtTable;
begin
  Result := '';

  lTable := GetTableForAttr(pAttrName, pIncludeInvisible);
  if (Assigned(lTable)) then
  begin
    if (lTable.TableName <> '') then
      Result := lTable.TableName;
  end;
end;

function TSFStmt.GetTableAliasForAttr(var pAttrName: String; pIncludeInvisible: Boolean): String;
  var lTable: TSFStmtTable;
begin
  Result := '';

  lTable := GetTableForAttr(pAttrName, pIncludeInvisible);
  if (Assigned(lTable)) then
  begin
    if (lTable.TableAlias <> '') then
      Result := lTable.TableAlias
    else if (lTable.TableName <> '') then
      Result := lTable.TableIdentifier;
  end;
end;

function TSFStmt.GetTableForAttr(var pAttrName: String; pIncludeInvisible: Boolean): TSFStmtTable;
  var i, lCntAttr: Integer;
begin
  Result := nil;

  lCntAttr := 0;
  for i := 0 to (mStmtAttrs.Count - 1) do
  begin
    if not(pIncludeInvisible) and (mStmtAttrs[i].OnlyForSearch) then
      Continue;

    inc(lCntAttr);

    if (mStmtAttrs[i].IsSingleDBFieldItem) and (Assigned(mStmtAttrs[i].DBAttrTable))
      and ((mStmtAttrs[i].AttrName <> '') and (AnsiCompareText(mStmtAttrs[i].AttrName, pAttrName) = 0)
      or (AnsiCompareText(mStmtAttrs[i].DBAttrName, pAttrName)= 0)) then
    begin
      Result := mStmtAttrs[i].DBAttrTable;
      pAttrName := mStmtAttrs[i].DBAttrName;
      Exit;
    end;
  end;

  if (lCntAttr = 0) and (Assigned(mBaseTable)) then
    Result := mBaseTable;
end;

// check, stmt has conditions for where-clause
function TSFStmt.HasConditions: Boolean;
begin
  Result := (mRestrConditions.Count > 0) or (mClientRestrConditions.Count > 0) or (mStmtConditions.Count > 0);
end;

// convert given value for statement-string
function TSFStmt.GetConvertedValue(pValue: Variant; pExplicitCast: Boolean = False; pEscapeLike: Boolean = False): String;
  var lConverter: TSFStmtDBDialectConv;
begin
  lConverter := detectDBDialectConvCls.Create(Self);
  try
    Result := lConverter.ConvertValue(pValue, mDfltFrmtSettings.DecimalSeparator, pExplicitCast, mAutoEscapeLike and pEscapeLike);
  finally
    FreeAndNil(lConverter);
  end;
end;

function TSFStmt.GetTypeForValue(pValue: Variant): TSFStmtValueType;
  var lConverter: TSFStmtDBDialectConv;
begin
  lConverter := detectDBDialectConvCls.Create(Self);
  try
    Result := lConverter.ValueTypeForValue(pValue);
  finally
    FreeAndNil(lConverter);
  end;
end;

function TSFStmt.ConvertValueInType(var pValue: Variant; pType: TSFStmtValueType; pHandleArray: Boolean): Boolean;
  var lDummyValFloat: Double;
      lDummyValDate: TDateTime;
      lDummyValInt, i, lPos: Integer;
      lConvVal: String;
      lArraySingleVal: Variant;
      lNewArray: Array of Variant;
begin
  Result := False;

  if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) then
    Exit;

  lConvVal := VarToStr(pValue);
  if (pHandleArray) then
  begin
    i := 1;
    while (i <= Length(lConvVal)) do
    begin
      lPos := Pos(';', lConvVal, i);
      if (lPos = 0) then
        lPos := Length(lConvVal) + 1;

      lArraySingleVal := MidStr(lConvVal, i, lPos - i);

      Result := ConvertValueInType(lArraySingleVal, pType);
      if (Result) then
      begin
        SetLength(lNewArray, Length(lNewArray) + 1);
        lNewArray[High(lNewArray)] := lArraySingleVal;
      end else
        Exit;

      i := lPos + 1;
    end;

    pValue := VarArrayOf(lNewArray);
  end else
  begin
    case pType of
      stmtValTypeNumeric:
        begin
          Result := TryStrToFloat(lConvVal, lDummyValFloat);
          if (Result) then
            pValue := lDummyValFloat;
        end;
      stmtValTypeDate:
        begin
          Result := TryStrToDate(lConvVal, lDummyValDate);
          if (Result) then
            pValue := lDummyValDate;
        end;
      stmtValTypeTime:
        begin
          Result := TryStrToTime(lConvVal, lDummyValDate);
          if (Result) then
            pValue := lDummyValDate;
        end;
      stmtValTypeDateTime:
        begin
          Result := TryStrToDateTime(lConvVal, lDummyValDate);
          if (Result) then
            pValue := lDummyValDate;
        end;
      stmtValTypeBool:
        begin
          Result := (Length(lConvVal) = 1) and TryStrToInt(lConvVal, lDummyValInt) and ((lDummyValInt = 0) or (lDummyValInt = 1));
          if (Result) then
            pValue := lDummyValInt;
        end;
    else
      Result := True;
    end;
  end;
end;

function TSFStmt.ConvertArrayValueToStr(pValue: Variant): String;
  var i: Integer;
begin
  Result := '';

  if not(VarIsArray(pValue)) then
    Exit;

  for i := VarArrayLowBound(pValue, 1) to VarArrayHighBound(pValue, 1) do
  begin
    if (Result <> '') then
      Result := Result + ';';
    Result := Result + pValue[i];
  end;
end;

function TSFStmt.GetReferencedStmtByNamePath(pNamePath: String): TSFStmt;
begin
  Result := GetReferencedStmtForParent(pNamePath, nil);
  if (Result = nil) then
    SFStmtError(stmtErrRefStmtNotFound, [pNamePath]);
end;

function TSFStmt.GetReferencedStmtForParent(pNamePath: String; pParent: TComponent): TSFStmt;
  var lComp: TComponent;
      lPos: Integer;
      lName: String;
begin
  Result := nil;

  if (pNamePath = '') then
    Exit;

  lPos := Pos('.', pNamePath);
  if (lPos > 0) then
  begin
    lName := MidStr(pNamePath, 1, lPos - 1);
    if (pParent <> nil) then
      lComp := pParent.FindComponent(lName)
    else
      lComp := FindGlobalComponent(lName);

    if (lComp <> nil) then
      Result := GetReferencedStmtForParent(MidStr(pNamePath, lPos + 1, Length(pNamePath) - lPos), lComp);
  end else
  begin
    if (pParent <> nil) then
      lComp := pParent.FindComponent(pNamePath)
    else
      lComp := FindGlobalComponent(pNamePath);

    if (lComp <> nil) and (lComp is TSFStmt) then
      Result := TSFStmt(lComp);
  end;
end;

function TSFStmt.GetReferencedStmtNamePath(pComp: TComponent): String;
begin
  Result := '';

  if (pComp = nil) then
    pComp := Self;

  if (pComp.Owner <> nil) then
    Result := GetReferencedStmtNamePath(pComp.Owner);

  if (Result <> '') then
    Result := Result + '.';

  Result := Result + pComp.Name;
end;

function TSFStmt.GetQuotedIdentifier(pIdentifier: String): String;

  function CheckIdentifierIsValid(pIdent: String): Boolean;
    var i: Integer;
        lChr: Char;
        lOrd: Byte;
  begin
    Result := True;
    for i := 1 to Length(pIdent) do
    begin
      lChr := PChar(MidStr(pIdent, i, 1))^;
      lOrd := ord(lChr);
      // big letters (always allowed)
      if (lOrd >= 65) and (lOrd <= 90) then
        Continue
      // small letters (always allowed)
      else if (lOrd >= 97) and (lOrd <= 122) then
        Continue
      // numbers (not allowed on first pos)
      else if (lOrd >= 48) and (lOrd <= 57) and (i > 1) then
        Continue
      // underscore (not allowed on first pos)
      else if (lChr = '_') and (i > 1) then
        Continue
      else
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  var lStartQuote, lEndQuote: String;
      lConvCls: TSFStmtDBDialectConvCls;
begin
  Result := pIdentifier;

  if (Result = '') or (Result = SFSTMTATTR_UNDEFINED) or (mQuoteType = stmtQuoteTypeNone) then
    Exit;

  if (mQuoteType = stmtQuoteTypeAll) or not(CheckIdentifierIsValid(pIdentifier)) then
  begin
    lStartQuote := '"';
    lEndQuote := '"';

    lConvCls := detectDBDialectConvCls;
    if (lConvCls <> nil) then
    begin
      lStartQuote := lConvCls.GetStartQuote;
      lEndQuote := lConvCls.GetEndQuote;
    end;

    if (lStartQuote <> '') and (lEndQuote <> '') then
    begin
      if (LeftStr(pIdentifier, Length(lStartQuote)) <> lStartQuote) or (RightStr(pIdentifier, Length(lEndQuote)) <> lEndQuote) then
        Result := lStartQuote + Result + lEndQuote;
    end;
  end;
end;

// set a union-statment
procedure TSFStmt.SetUnion(pStmt: TSFStmt);
begin
  if (Assigned(mUnion)) and (mUnion <> pStmt) and (mUnion.Owner = nil) then
    FreeAndNil(mUnion);

  mUnion := pStmt;
  mUnionName := '';
end;

function TSFStmt.HasUnion: Boolean;
begin
  Result := Assigned(Union);
end;

function TSFStmt.AssignStmt: TSFStmt;
begin
  Result := TSFStmt.Create(nil);
  AssignStmtTo(Result);
end;

procedure TSFStmt.AssignStmtTo(pDest: TSFStmt);
  var i: Integer;
      lTabSearch, lAttrSearch: String;
begin
  pDest.DBDialect := mDBDialect;
  pDest.UseDistinct := UseDistinct;
  pDest.QuoteType := mQuoteType;
  pDest.AutoEscapeLike := mAutoEscapeLike;
  if (Assigned(mBaseTable)) then
  begin
    if not(Assigned(pDest.mBaseTable)) then
      pDest.mBaseTable := mBaseTable.AssignStmtTable(pDest)
    else
      mBaseTable.AssignStmtTableJoins(pDest.mBaseTable);
  end;

  for i := 0 to (mStmtAttrs.Count - 1) do
    pDest.mStmtAttrs.Add(mStmtAttrs[i].AssignStmtAttr(pDest));

  for i := 0 to (mStmtConditions.Count - 1) do
    pDest.mStmtConditions.Add(mStmtConditions[i].AssignStmtCondition(pDest));

  for i := 0 to (mStmtOrder.Count - 1) do
  begin
    lTabSearch := '';
    lAttrSearch := mStmtOrder[i].AttrName;
    if (mStmtOrder[i].DBAttrTable <> nil) then
    begin
      lAttrSearch := mStmtOrder[i].DBAttrName;
      if (mStmtOrder[i].DBAttrTable.TableAlias <> '') then
        lTabSearch := mStmtOrder[i].DBAttrTable.TableAlias
      else if (mStmtOrder[i].DBAttrTable.TableName <> '') then
        lTabSearch := mStmtOrder[i].DBAttrTable.TableIdentifier;
    end;
    pDest.AddOrderAttr(lTabSearch, lAttrSearch, mStmtOrder[i].SortType);
  end;

  for i := 0 to (mStmtGroup.Count - 1) do
  begin
    lTabSearch := '';
    lAttrSearch := mStmtGroup[i].AttrName;
    if (mStmtGroup[i].DBAttrTable <> nil) then
    begin
      lAttrSearch := mStmtGroup[i].DBAttrName;
      if (mStmtGroup[i].DBAttrTable.TableAlias <> '') then
        lTabSearch := mStmtGroup[i].DBAttrTable.TableAlias
      else if (mStmtGroup[i].DBAttrTable.TableName <> '') then
        lTabSearch := mStmtGroup[i].DBAttrTable.TableIdentifier;
    end;
    pDest.AddGroupAttr(lTabSearch, lAttrSearch);
  end;

  for i := 0 to (mRestrAttrs.Count - 1) do
    pDest.mRestrAttrs.Add(mRestrAttrs[i].AssignStmtAttr(pDest));

  for i := 0 to (mRestrConditions.Count - 1) do
    pDest.mRestrConditions.Add(mRestrConditions[i].AssignStmtCondition(pDest));

  for i := 0 to (mClientRestrConditions.Count - 1) do
    pDest.mClientRestrConditions.Add(mClientRestrConditions[i].AssignStmtCondition(pDest));

  for i := 0 to (mSetAttrs.Count - 1) do
    pDest.mSetAttrs.Add(mSetAttrs[i].AssignStmtAttr(pDest));

  for i := 0 to (mSetConditions.Count - 1) do
    pDest.mSetConditions.Add(mSetConditions[i].AssignStmtCondition(pDest));

  for i := 0 to (mInsAttrs.Count - 1) do
    pDest.mInsAttrs.Add(mInsAttrs[i].AssignStmtAttr(pDest));

  for i := 0 to (mInsConditions.Count - 1) do
    pDest.mInsConditions.Add(mInsConditions[i].AssignStmtCondition(pDest));

  if (HasUnion) then
    pDest.SetUnion(Union.AssignStmt);
end;

function TSFStmt.AttrDatabaseNameForAttrName(pTableAlias, pAttrName: String): String;
  var lTable: TSFStmtTable;
begin
  lTable := getTableByAlias(pTableAlias);
  Result := AttrDatabaseNameForAttrName(pAttrName, lTable);
end;

function TSFStmt.AttrDatabaseNameForAttrName(pAttrName: String; var pTable: TSFStmtTable): String;
  var lAttr: TSFStmtAttr;
      i: Integer;
      lTableAlias: String;
begin
  Result := pAttrName;

  // check is * for all
  if not(hasVisibleAttrs(mStmtAttrs)) then
  begin
    pTable := nil;
    Exit;
  end;

  // search without table (pAttrName = Alias from Attribute)
  lAttr := getAttrByName(pAttrName, '', '', True);
  if (Assigned(lAttr)) and (lAttr.IsSingleDBFieldItem) and not(lAttr.IsSingleDBFieldUndefined)
  and (not(Assigned(pTable)) or (lAttr.DBAttrTable = pTable)) then
  begin
    Result := lAttr.DBAttrName;
    pTable := lAttr.DBAttrTable;
    Exit;
  end;

  lTableAlias := '';
  if (Assigned(pTable)) then
  begin
    if (pTable.TableAlias <> '') then
      lTableAlias := pTable.TableAlias
    else
      lTableAlias := pTable.TableIdentifier;
  end;

  // explicit search attr with table-alias and attrname (dbattrname or alias)
  lAttr := getAttrByName(pAttrName, lTableAlias, '', True);
  if (Assigned(lAttr)) and (lAttr.IsSingleDBFieldItem) and not(lAttr.IsSingleDBFieldUndefined) then
  begin
    Result := lAttr.DBAttrName;
    pTable := lAttr.DBAttrTable;
    Exit;
  end;

  // check is * for table
  lAttr := getAttrByName(SFSTMTATTR_UNDEFINED, lTableAlias, '', True);
  if (Assigned(lAttr)) and (lAttr.IsSingleDBFieldItem) and (lAttr.IsSingleDBFieldUndefined)
  and (Assigned(pTable)) and (lAttr.DBAttrTable = pTable) then
  begin
    // return given attributename
    pTable := nil;
    Exit;
  end;

  // check restrattrs
  if not(Assigned(pTable)) or (pTable = mBaseTable) then
  begin
    for i := 0 to (mRestrAttrs.Count - 1) do
    begin
      if (AnsiCompareText(mRestrAttrs[i].DBAttrName, Trim(pAttrName)) = 0) then
      begin
        Result := mRestrAttrs[i].DBAttrName;
        pTable := mBaseTable;
        Exit;
      end;
    end;
  end;

  Result := '';
  pTable := nil;
end;

function TSFStmt.ListTables: TObjectList<TSFStmtTable>;
begin
  Result := nil;

  if not(Assigned(mBaseTable)) then
    Exit;

  Result := TObjectList<TSFStmtTable>.Create(False);
  Result.Add(mBaseTable);

  mBaseTable.ListJoinTables(Result);
end;

function TSFStmt.ListAttributes: TObjectList<TSFStmtAttr>;
  var i: Integer;
begin
  Result := TObjectList<TSFStmtAttr>.Create(False);
  for i := 0 to (mStmtAttrs.Count - 1) do
    Result.Add(mStmtAttrs[i]);
end;

function TSFStmt.ListAttributeParams: TStrings;
  var i: Integer;
begin
  Result := TStringList.Create;
  for i := 0 to (mStmtAttrs.Count - 1) do
  begin
    if (mStmtAttrs[i].HasItems) then
      mStmtAttrs[i].SetItemParamNamesToList(Result);
  end;
end;

function TSFStmt.ListConditions: TObjectList<TSFStmtCondition>;
  var i: Integer;
begin
  Result := TObjectList<TSFStmtCondition>.Create(False);
  for i := 0 to (mStmtConditions.Count - 1) do
    Result.Add(mStmtConditions[i]);
end;

function TSFStmt.ListRestrictions: TObjectList<TSFStmtCondition>;
  var i: Integer;
begin
  Result := TObjectList<TSFStmtCondition>.Create(False);
  for i := 0 to (mClientRestrConditions.Count - 1) do
    Result.Add(mClientRestrConditions[i]);
end;

function TSFStmt.ListOrder: TObjectList<TSFStmtAttr>;
  var i: Integer;
begin
  Result := TObjectList<TSFStmtAttr>.Create(False);
  for i := 0 to (mStmtOrder.Count - 1) do
    Result.Add(mStmtOrder[i]);
end;

function TSFStmt.ListGroup: TObjectList<TSFStmtAttr>;
  var i: Integer;
begin
  Result := TObjectList<TSFStmtAttr>.Create(False);
  for i := 0 to (mStmtGroup.Count - 1) do
    Result.Add(mStmtGroup[i]);
end;

function TSFStmt.ConfigStmtTimeValue(pTime: TTime): TDateTime;
begin
  Result := SFSTMTVAL_NULLDATE - pTime;
end;

function TSFStmt.HasStmtDatePart(pDate: TDateTime): Boolean;
begin
  Result := (Trunc(pDate) > SFSTMTVAL_NULLDATE);
end;

function TSFStmt.HasStmtTimePart(pDate: TDateTime): Boolean;
begin
  if (pDate < 0) then
    Result := ((pDate - Trunc(pDate)) * -1) < 0
  else
    Result := (pDate - Trunc(pDate)) > 0;
end;

function TSFStmt.GetStmtDatePart(pDate: TDateTime): TDate;
begin
  Result := Trunc(pDate);
end;

function TSFStmt.GetStmtTimePart(pDate: TDateTime): TTime;
begin
  if (pDate < 0) then
    Result := (pDate - Trunc(pDate)) * -1
  else
    Result := pDate - Trunc(pDate);
end;

function TSFStmt.SaveToXmlDoc: IXmlDocument;
begin
  Result := TSFStmtXML.CreateDocument;
  exportToXml(Result);
end;

procedure TSFStmt.SaveToXmlStr(var pXmlStr: String);
  var lXmlDoc: IXmlDocument;
begin
  lXmlDoc := TSFStmtXML.CreateDocument([doNodeAutoIndent]);
  try
    exportToXml(lXmlDoc);
    lXmlDoc.SaveToXML(pXmlStr);
  finally
    lXmlDoc := nil;
  end;
end;

procedure TSFStmt.LoadFromXml(pXmlStr: String; pSuspendRefs: Boolean);
  var lXmlDoc: IXmlDocument;
begin
  lXmlDoc := TSFStmtXML.LoadDocumentFromStr(pXmlStr);
  try
    LoadFromXmlDoc(lXmlDoc, pSuspendRefs);
  finally
    lXmlDoc := nil;
  end;
end;

procedure TSFStmt.LoadFromXmlDoc(pXmlDoc: IXmlDocument; pSuspendRefs: Boolean);
begin
  loadXml(pXmlDoc, True, pSuspendRefs);
end;

procedure TSFStmt.DefineProperties(Filer: TFiler);
begin
  inherited;

  Filer.DefineProperty('XmlDefinition', readXmlDefintion, writeXmlDefintion, True);
end;

// search a table by alias
function TSFStmt.getTableByAlias(pAlias: String): TSFStmtTable;
  var lAlias: String;
      i: TSFStmtTableSearchType;
begin
  Result := nil;

  if not(Assigned(mBaseTable)) then
    Exit;

  lAlias := Trim(pAlias);
  if (lAlias <> '') then
  begin
    for i := Low(TSFStmtTableSingleSearchTypes) to High(TSFStmtTableSingleSearchTypes) do
    begin
      case i of
        stmtTableSearchOnlyAlias:
          begin
            if (mBaseTable.TableAlias <> '') and (AnsiCompareText(mBaseTable.TableAlias, lAlias) = 0) then
              Result := mBaseTable
            else
              Result := mBaseTable.GetJoinTableByAlias(lAlias, i);
          end;
        stmtTableSearchOnlyIdentifier:
          begin
            if (mBaseTable.TableIdentifier <> '') and (AnsiCompareText(mBaseTable.TableIdentifier, lAlias) = 0) then
              Result := mBaseTable
            else
              Result := mBaseTable.GetJoinTableByAlias(lAlias, i);
          end;
        stmtTableSearchOnlyName:
          begin
            if (mBaseTable.TableName <> '') and (AnsiCompareText(mBaseTable.TableName, lAlias) = 0) then
              Result := mBaseTable
            else
              Result := mBaseTable.GetJoinTableByAlias(lAlias, i);
          end;
      end;

      if (Result <> nil) then
        Break;
    end;
  end;
end;

// search a attribute
function TSFStmt.getAttrByName(pAttrName: String; pTableAlias: String = '';
                      pAttrAggr: String = ''; pOnlyVisible: Boolean = False): TSFStmtAttr;
  var lTable: TSFStmtTable;
      i: Integer;
      lAttrName, lAttrAggr: String;
begin
  Result := nil;

  lTable := nil;
  if (pTableAlias <> '') then
    lTable := getTableByAlias(pTableAlias);

  lAttrName := Trim(pAttrName);
  lAttrAggr := Trim(pAttrAggr);

  for i := 0 to (mStmtAttrs.Count - 1) do
  begin
    if (pOnlyVisible) and (mStmtAttrs[i].OnlyForSearch) then
      Continue;

    if (Assigned(lTable)) then
    begin
      if (mStmtAttrs[i].IsSingleDBFieldItem) and (mStmtAttrs[i].DBAttrTable = lTable)
      and ((AnsiCompareText(mStmtAttrs[i].DBAttrName, lAttrName) = 0) or (mStmtAttrs[i].AttrName <> '') and (AnsiCompareText(mStmtAttrs[i].AttrName, lAttrName) = 0))
      and (AnsiCompareText(mStmtAttrs[i].DBAttrAggr, lAttrAggr) = 0) then
        Result := mStmtAttrs[i];
    end
    else if ((mStmtAttrs[i].AttrName <> '') and (AnsiCompareText(mStmtAttrs[i].AttrName, lAttrName) = 0)
    or (mStmtAttrs[i].IsSingleDBFieldItem) and (AnsiCompareText(mStmtAttrs[i].DBAttrName, lAttrName) = 0))
    and (AnsiCompareText(mStmtAttrs[i].DBAttrAggr, lAttrAggr) = 0) then
      Result := mStmtAttrs[i];

    if (Result <> nil) then
      break;
  end;
end;

// set where conditions from list to string
procedure TSFStmt.setWhereConditions(var pWhereStr: String; pLst: TObjectList<TSFStmtCondition>; pWithBracket: Boolean; pWithAliases: Boolean = True);
  var i: Integer;
      lCondLastType: TSFStmtConditionType;
      lCondLastIsExists: Boolean;
begin
  if (pLst.Count > 0) then
  begin
    if (pWhereStr <> '') then
      pWhereStr := pWhereStr + ' AND';

    if (pWithBracket) then
      pWhereStr := pWhereStr + ' (';
  end;

  lCondLastType := stmtCondTypeUndefined;
  lCondLastIsExists := False;
  for i := 0 to (pLst.Count - 1) do
  begin
    if (pWhereStr <> '') then
      pWhereStr := pWhereStr + ' ';

    if (lCondLastType in [stmtCondTypeValue, stmtCondTypeAttribute, stmtCondTypeIsNull, stmtCondTypeIsNotNull, stmtCondTypeClose]) or (lCondLastIsExists) then
    begin
      if (pLst[i].CondType in [stmtCondTypeValue, stmtCondTypeAttribute, stmtCondTypeIsNull, stmtCondTypeIsNotNull, stmtCondTypeOpen]) or (pLst[i] is TSFStmtConditionExists) then
        pWhereStr := pWhereStr + 'AND ';
    end;

    pWhereStr := pWhereStr + pLst[i].GetConditionDef(pWithAliases);

    lCondLastType := pLst[i].CondType;
    lCondLastIsExists := (pLst[i] is TSFStmtConditionExists);
  end;

  if (pWithBracket) and (pLst.Count > 0) then
    pWhereStr := pWhereStr + ')';
end;

// check list has visible (only for search = false) attrs
function TSFStmt.hasVisibleAttrs(pLst: TObjectList<TSFStmtAttr>): Boolean;
  var i: Integer;
begin
  for i := 0 to (pLst.Count - 1) do
  begin
    Result := not(pLst[i].OnlyForSearch);

    if (Result) then
      Exit;
  end;

  Result := False;
end;

function TSFStmt.detectDBDialectConvCls: TSFStmtDBDialectConvCls;
begin
  Result := nil;

  if (Assigned(mOnGetDBDialectCls)) then
    Result := mOnGetDBDialectCls(mDBDialect);

  if (Result <> nil) then
    Exit;

  Result := TSFStmtDBDialectConv;

  case mDBDialect of
    stmtDBDOra: Result := TSFStmtDBDialectConvOra;
    stmtDBDDB2: Result := TSFStmtDBDialectConvDB2;
    stmtDBDIfx: Result := TSFStmtDBDialectConvIfx;
    stmtDBDAcc: Result := TSFStmtDBDialectConvAcc;
    stmtDBIB, stmtDBFB: Result := TSFStmtDBDialectConvFBIB;
    stmtDBDSQLite: Result := TSFStmtDBDialectConvSQLite;
    stmtDBDPG: Result := TSFStmtDBDialectConvPG;
    stmtDBDMySQL: Result := TSFStmtDBDialectConvMySQL;
    stmtDBDMSSQL: Result := TSFStmtDBDialectConvMSSQL;
  end;
end;

function TSFStmt.createRelItems(pRelValsSource, pRelValsDest: Array of Variant;
                                pRelTypesSource, pRelTypesDest: Array of TSFStmtJoinRelItemType): TSFStmtJoinRelItems;
  var i: Integer;
begin
  if (Length(pRelValsSource) <> Length(pRelValsDest)) or (Length(pRelValsSource) <> Length(pRelTypesSource))
  or (Length(pRelTypesSource) <> Length(pRelTypesDest)) then
    Exit;

  SetLength(Result, Length(pRelValsSource));
  for i := Low(pRelValsSource) to High(pRelValsSource) do
  begin
    Result[i].riSrcType := pRelTypesSource[i];
    Result[i].riSrcValue := pRelValsSource[i];
    Result[i].riDestType := pRelTypesDest[i];
    Result[i].riDestValue := pRelValsDest[i];
  end;
end;

function TSFStmt.createRelItemsFromXmlRelItems(pXmlRelationItems: TSFStmtTableRelationItemsXML): TSFStmtJoinRelItems;
  var i: Integer;
      lXmlRelItem: TSFStmtTableRelationItemXML;
begin
  SetLength(Result, pXmlRelationItems.Count);
  for i := 0 to (pXmlRelationItems.Count - 1) do
  begin
    lXmlRelItem := TSFStmtTableRelationItemXML(pXmlRelationItems.Item[i]);

    Result[i].riSrcType := TSFStmtJoinRelItemType(lXmlRelItem.SrcType);
    Result[i].riSrcValue := lXmlRelItem.SrcValue;
    if (lXmlRelItem.SrcValueType >= Integer(Low(TSFStmtValueType))) and (lXmlRelItem.SrcValueType <= Integer(High(TSFStmtValueType))) then
      ConvertValueInType(Result[i].riSrcValue, TSFStmtValueType(lXmlRelItem.SrcValueType));

    Result[i].riDestType := TSFStmtJoinRelItemType(lXmlRelItem.DestType);
    Result[i].riDestValue := lXmlRelItem.DestValue;
    if (lXmlRelItem.DestValueType >= Integer(Low(TSFStmtValueType))) and (lXmlRelItem.DestValueType <= Integer(High(TSFStmtValueType))) then
      ConvertValueInType(Result[i].riDestValue, TSFStmtValueType(lXmlRelItem.DestValueType));
  end;
end;

procedure TSFStmt.exportToXml(pXmlDoc: IXmlDocument);
  var lXmlStmt: TSFStmtXML;
      lXmlAttr: TSFStmtAttrXML;
      lXmlCond: TSFStmtCondXML;
      lXmlOrder: TSFStmtOrderXML;
      lXmlGroup: TSFStmtGroupXML;
      i: Integer;
begin
  if not(pXmlDoc.DocumentElement is TSFStmtXML) then
    Exit;

  lXmlStmt := TSFStmtXML(pXmlDoc.DocumentElement);

  lXmlStmt.UseDistinct := UseDistinct;
  lXmlStmt.QuoteType := Integer(QuoteType);
  lXmlStmt.AutoEscapeLike := AutoEscapeLike;
  lXmlStmt.DBDialect := Integer(DBDialect);
  lXmlStmt.LikeEscapeChar := LikeEscapeChar;
  if (mUnionName <> '') then
    lXmlStmt.Union := mUnionName
  else if (Assigned(mUnion)) then
    lXmlStmt.Union := mUnion.GetReferencedStmtNamePath;

  if (Assigned(BaseTable)) then
    BaseTable.SaveToXmlTable(lXmlStmt.BaseTable);

  for i := 0 to (mStmtAttrs.Count - 1) do
  begin
    lXmlAttr := TSFStmtAttrXML(lXmlStmt.Attrs.AddItem);
    lXmlAttr.AttrIdx := i;
    mStmtAttrs[i].SaveToXmlAttr(lXmlAttr);
  end;

  for i := 0 to (mClientRestrConditions.Count - 1) do
  begin
    lXmlCond := TSFStmtCondXML(lXmlStmt.Conds.AddItem);
    lXmlCond.IsRestriction := True;
    mClientRestrConditions[i].SaveToXmlCondition(lXmlCond);
  end;

  for i := 0 to (mStmtConditions.Count - 1) do
  begin
    lXmlCond := TSFStmtCondXML(lXmlStmt.Conds.AddItem);
    lXmlCond.IsRestriction := False;
    mStmtConditions[i].SaveToXmlCondition(lXmlCond);
  end;

  for i := 0 to (mStmtOrder.Count - 1) do
  begin
    lXmlOrder := TSFStmtOrderXML(lXmlStmt.Orders.AddItem);
    lXmlOrder.AttrIdx := mStmtAttrs.IndexOf(mStmtOrder[i]);
    lXmlOrder.OrderType := Integer(mStmtOrder[i].SortType);
  end;

  for i := 0 to (mStmtGroup.Count - 1) do
  begin
    lXmlGroup := TSFStmtGroupXML(lXmlStmt.Groups.AddItem);
    lXmlGroup.AttrIdx := mStmtAttrs.IndexOf(mStmtGroup[i]);
  end;
end;

procedure TSFStmt.loadXml(pXmlDoc: IXmlDocument; pEnforceRecreate, pSuspendRefs: Boolean);
  var lXmlStmt: TSFStmtXML;
      lXmlStmtAttr: TSFStmtAttrXML;
      lXmlStmtCond: TSFStmtCondXML;
      lXmlStmtOrder: TSFStmtOrderXML;
      lXmlStmtGroup: TSFStmtGroupXML;
      lStmtAttr, lDestAttr: TSFStmtAttr;
      i: Integer;
      lConvValue: Variant;
      lAttrIdxMap: Array of Integer;
begin
  if not(pXmlDoc.DocumentElement is TSFStmtXML) then
    Exit;

  if (pEnforceRecreate) then
  begin
    Reset;
    if (Assigned(mBaseTable)) then
      FreeAndNil(mBaseTable);
  end;

  lXmlStmt := TSFStmtXML(pXmlDoc.DocumentElement);

  UseDistinct := lXmlStmt.UseDistinct;
  AutoEscapeLike := lXmlStmt.AutoEscapeLike;
  LikeEscapeChar := lXmlStmt.LikeEscapeChar;
  if (lXmlStmt.QuoteType >= Integer(Low(TSFStmtQuoteType))) and (lXmlStmt.QuoteType <= Integer(High(TSFStmtQuoteType))) then
    QuoteType := TSFStmtQuoteType(lXmlStmt.QuoteType);
  if (lXmlStmt.DBDialect >= Integer(Low(TSFStmtDBDialect))) and (lXmlStmt.QuoteType <= Integer(High(TSFStmtDBDialect))) then
    DBDialect := TSFStmtDBDialect(lXmlStmt.DBDialect);

  if (lXmlStmt.HasBaseTable) then
  begin
    if not(Assigned(mBaseTable)) then
    begin
      if (lXmlStmt.BaseTable.TableIsStmt) then
      begin
        if (pSuspendRefs) then
          SetBaseTable(GetReferencedStmtByNamePath(lXmlStmt.BaseTable.StmtName), lXmlStmt.BaseTable.TableAlias)
        else
          SetBaseTable(lXmlStmt.BaseTable.StmtName, lXmlStmt.BaseTable.TableAlias);
      end else
        SetBaseTable(lXmlStmt.BaseTable.TableName, lXmlStmt.BaseTable.Schema, lXmlStmt.BaseTable.Catalog, lXmlStmt.BaseTable.TableAlias);
    end;

    if (Assigned(mBaseTable)) then
      mBaseTable.LoadFromXmlTable(lXmlStmt.BaseTable, pSuspendRefs);
  end;

  Finalize(lAttrIdxMap);
  if (lXmlStmt.HasAttrs) then
  begin
    for i := 0 to (lXmlStmt.Attrs.Count - 1) do
    begin
      lXmlStmtAttr := TSFStmtAttrXML(lXmlStmt.Attrs.Item[i]);
      lStmtAttr := AddStmtAttr(lXmlStmtAttr.AttrName, lXmlStmtAttr.OnlyForSearch);
      lStmtAttr.LoadFromXmlAttr(lXmlStmtAttr, pSuspendRefs);

      // map the current attridx
      if (lXmlStmtAttr.AttrIdx >= 0) then
      begin
        if (Length(lAttrIdxMap) < (lXmlStmtAttr.AttrIdx + 1)) then
          SetLength(lAttrIdxMap, lXmlStmtAttr.AttrIdx + 1);
        lAttrIdxMap[lXmlStmtAttr.AttrIdx] := mStmtAttrs.Count - 1;
      end;
    end;
  end;

  if (lXmlStmt.HasConds) then
  begin
    for i := 0 to (lXmlStmt.Conds.Count - 1) do
    begin
      lXmlStmtCond := TSFStmtCondXML(lXmlStmt.Conds.Item[i]);
      if (lXmlStmtCond.CondType < Integer(Low(TSFStmtConditionType))) or (lXmlStmtCond.CondType > Integer(High(TSFStmtConditionType))) then
        Continue;

      case TSFStmtConditionType(lXmlStmtCond.CondType) of
        stmtCondTypeValue:
          begin
            lStmtAttr := nil;
            if (Length(lAttrIdxMap) > 0) and (Low(lAttrIdxMap) <= lXmlStmtCond.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtCond.AttrIdx) then
              lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtCond.AttrIdx]];

            if (lStmtAttr <> nil) then
            begin
              lConvValue := lXmlStmtCond.DestValue;
              if (lXmlStmtCond.DestValueType >= Integer(Low(TSFStmtValueType))) and (lXmlStmtCond.DestValueType <= Integer(High(TSFStmtValueType))) then
                ConvertValueInType(lConvValue, TSFStmtValueType(lXmlStmtCond.DestValueType), lXmlStmtCond.DestValueIsArray);
              if (lXmlStmtCond.IsRestriction) then
                mClientRestrConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, lXmlStmtCond.CondOperator, lConvValue, stmtCondTypeValue))
              else
                mStmtConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, lXmlStmtCond.CondOperator, lConvValue, stmtCondTypeValue));
            end;
          end;
        stmtCondTypeAttribute:
          begin
            lStmtAttr := nil;
            lDestAttr := nil;
            if (Length(lAttrIdxMap) > 0) then
            begin
              if (Low(lAttrIdxMap) <= lXmlStmtCond.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtCond.AttrIdx) then
                lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtCond.AttrIdx]];
              if (Low(lAttrIdxMap) <= lXmlStmtCond.DestAttrIdx) and (High(lAttrIdxMap) >= lXmlStmtCond.DestAttrIdx) then
                lDestAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtCond.DestAttrIdx]];
            end;

            if (lStmtAttr <> nil) and (lDestAttr <> nil) then
            begin
              if (lXmlStmtCond.IsRestriction) then
                mClientRestrConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, lXmlStmtCond.CondOperator, Integer(Pointer(@lDestAttr)^), stmtCondTypeAttribute))
              else
                mStmtConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, lXmlStmtCond.CondOperator, Integer(Pointer(@lDestAttr)^), stmtCondTypeAttribute));
            end;
          end;
        stmtCondTypeIsNull:
          begin
            lStmtAttr := nil;
            if (Length(lAttrIdxMap) > 0) and (Low(lAttrIdxMap) <= lXmlStmtCond.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtCond.AttrIdx) then
              lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtCond.AttrIdx]];

            if (lStmtAttr <> nil) then
            begin
              if (lXmlStmtCond.IsRestriction) then
                mClientRestrConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, '', '', stmtCondTypeIsNull))
              else
                mStmtConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, '', '', stmtCondTypeIsNull));
            end;
          end;
        stmtCondTypeIsNotNull:
          begin
            lStmtAttr := nil;
            if (Length(lAttrIdxMap) > 0) and (Low(lAttrIdxMap) <= lXmlStmtCond.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtCond.AttrIdx) then
              lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtCond.AttrIdx]];

            if (lStmtAttr <> nil) then
            begin
              if (lXmlStmtCond.IsRestriction) then
                mClientRestrConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, '', '', stmtCondTypeIsNotNull))
              else
                mStmtConditions.Add(TSFStmtCondition.Create(Self, lStmtAttr, '', '', stmtCondTypeIsNotNull));
            end;
          end;
        stmtCondTypeUndefined:
          begin
            if (lXmlStmtCond.ExistsTableAliasFrom <> '') and
              (lXmlStmtCond.ExistsDestRefStmtName <> '') and
              (lXmlStmtCond.ExistsDestRefStmtTableAlias <> '') and
              (lXmlStmtCond.HasExistsRelationItems) then
            begin
              if (pSuspendRefs) then
              begin
                AddConditionExists(GetReferencedStmtByNamePath(lXmlStmtCond.ExistsDestRefStmtName),
                                  lXmlStmtCond.ExistsTableAliasFrom, lXmlStmtCond.ExistsDestRefStmtTableAlias,
                                  lXmlStmtCond.CondOperator, createRelItemsFromXmlRelItems(lXmlStmtCond.ExistsRelation),
                                  lXmlStmtCond.IsRestriction);
              end else
              begin
                AddConditionExists(lXmlStmtCond.ExistsDestRefStmtName, lXmlStmtCond.ExistsTableAliasFrom,
                                  lXmlStmtCond.ExistsDestRefStmtTableAlias, lXmlStmtCond.CondOperator,
                                  createRelItemsFromXmlRelItems(lXmlStmtCond.ExistsRelation),
                                  lXmlStmtCond.IsRestriction);
              end;
            end;
          end;
      else
        AddConditionType(TSFStmtConditionType(lXmlStmtCond.CondType), lXmlStmtCond.IsRestriction);
      end;
    end;
  end;

  if (lXmlStmt.HasOrders) then
  begin
    for i := 0 to (lXmlStmt.Orders.Count - 1) do
    begin
      lXmlStmtOrder := TSFStmtOrderXML(lXmlStmt.Orders.Item[i]);
      if (lXmlStmtOrder.OrderType < Integer(Low(TSFStmtSortType))) or (lXmlStmtOrder.OrderType > Integer(High(TSFStmtSortType))) then
        Continue;

      lStmtAttr := nil;
      if (Length(lAttrIdxMap) > 0) and (Low(lAttrIdxMap) <= lXmlStmtOrder.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtOrder.AttrIdx) then
        lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtOrder.AttrIdx]];

      if (lStmtAttr <> nil) then
      begin
        lStmtAttr.SortType := TSFStmtSortType(lXmlStmtOrder.OrderType);
        mStmtOrder.Add(lStmtAttr);
      end;
    end;
  end;

  if (lXmlStmt.HasGroups) then
  begin
    for i := 0 to (lXmlStmt.Groups.Count - 1) do
    begin
      lXmlStmtGroup := TSFStmtGroupXML(lXmlStmt.Groups.Item[i]);

      lStmtAttr := nil;
      if (Length(lAttrIdxMap) > 0) and (Low(lAttrIdxMap) <= lXmlStmtGroup.AttrIdx) and (High(lAttrIdxMap) >= lXmlStmtGroup.AttrIdx) then
        lStmtAttr := mStmtAttrs.Items[lAttrIdxMap[lXmlStmtGroup.AttrIdx]];

      if (lStmtAttr <> nil) then
        mStmtGroup.Add(lStmtAttr);
    end;
  end;

  if (lXmlStmt.Union <> '') then
  begin
    if (pSuspendRefs) then
      SetUnion(GetReferencedStmtByNamePath(lXmlStmt.Union))
    else
      mUnionName := lXmlStmt.Union;
  end else
  begin
    mUnion := nil;
    mUnionName := '';
  end;
end;

procedure TSFStmt.readXmlDefintion(pReader: TReader);
  var lXmlDoc: IXmlDocument;
begin
  lXmlDoc := TSFStmtXML.LoadDocumentFromStr(pReader.ReadString);
  try
    loadXml(lXmlDoc, False, False);
  finally
    lXmlDoc := nil;
  end;
end;

procedure TSFStmt.writeXmlDefintion(pWriter: TWriter);
  var lXmlStr: String;
begin
  SaveToXmlStr(lXmlStr);
  pWriter.WriteString(lXmlStr);
end;

function TSFStmt.getUnion: TSFStmt;
begin
  Result := mUnion;
  if not(Assigned(Result)) and (mUnionName <> '') then
    Result := GetReferencedStmtByNamePath(mUnionName);
end;

function TSFStmt.getGenerateNextSubId: Integer;
begin
  if (mGenerateLevel = 0) then
    inc(mGenerateSubId);

  Result := mGenerateSubId;
end;

function TSFStmt.getGenerateNextLevel: Integer;
begin
  Result := mGenerateLevel + 1;
end;

// ===========================================================================//
//                               TSFStmtTable                                  //
// ===========================================================================//


// constructor
constructor TSFStmtTable.Create(pTableName, pSchema, pCatalog, pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt);
begin
  doCreate(pTableName, pSchema, pCatalog, pTableAlias, pTableNo, pParentStmt, nil, '');
end;

constructor TSFStmtTable.Create(pTableStmt: TSFStmt; pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt);
begin
  doCreate('', '', '', pTableAlias, pTableNo, pParentStmt, pTableStmt, '');
end;

constructor TSFStmtTable.Create(pTableStmtName, pTableAlias: String; pTableNo: Integer; pParentStmt: TSFStmt);
begin
  doCreate('', '', '', pTableAlias, pTableNo, pParentStmt, nil, pTableStmtName);
end;

// destructor
destructor TSFStmtTable.Destroy;
begin
  inherited;

  mJoins.Clear;
  FreeAndNil(mJoins);

  if (Assigned(mTableStmt)) and (mTableStmt.Owner = nil) then
    mTableStmt.Free;
  mTableStmt := nil;
  mTableStmtName := '';
end;

procedure TSFStmtTable.doCreate(pTableName, pSchema, pCatalog, pTableAlias: String;
        pTableNo: Integer; pParentStmt, pTableStmt: TSFStmt; pTableStmtName: String);
begin
  inherited Create;

  mParentStmt := pParentStmt;
  mTableStmt := pTableStmt;
  mTableStmtName := pTableStmtName;
  mTableName := Trim(pTableName);
  mSchema := Trim(pSchema);
  mCatalog := Trim(pCatalog);
  mTableNo := pTableNo;
  mTableAlias := Trim(pTableAlias);
  if (mTableAlias = '') then
    mTableAlias := 't' + IntToStr(mTableNo);

  mJoins := TObjectList<TSFStmtTableJoin>.Create(True);
end;

// add a new join for table
function TSFStmtTable.SetTableJoin(pTableAlias, pTableName, pSchema, pCatalog: String; pTableNo: Integer;
                                    pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
  var lDestTable: TSFStmtTable;
      lTableJoin: TSFStmtTableJoin;
begin
   lDestTable := TSFStmtTable.Create(pTableName, pSchema, pCatalog, pTableAlias, pTableNo, mParentStmt);
   lTableJoin := TSFStmtTableJoin.Create(Self, lDestTable, pRelItems, pType);

   mJoins.Add(lTableJoin);

   Result := lDestTable;
end;

// add a new join for a stmt
function TSFStmtTable.SetTableJoin(pTableAlias: String; pStmt: TSFStmt; pTableNo: Integer;
                                    pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
  var lDestTable: TSFStmtTable;
      lTableJoin: TSFStmtTableJoin;
begin
   lDestTable := TSFStmtTable.Create(pStmt, pTableAlias, pTableNo, mParentStmt);
   lTableJoin := TSFStmtTableJoin.Create(Self, lDestTable, pRelItems, pType);

   mJoins.Add(lTableJoin);

   Result := lDestTable;
end;

function TSFStmtTable.SetTableJoin(pTableAlias, pStmtName: String; pTableNo: Integer;
                                    pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType): TSFStmtTable;
  var lDestTable: TSFStmtTable;
      lTableJoin: TSFStmtTableJoin;
begin
   lDestTable := TSFStmtTable.Create(pStmtName, pTableAlias, pTableNo, mParentStmt);
   lTableJoin := TSFStmtTableJoin.Create(Self, lDestTable, pRelItems, pType);

   mJoins.Add(lTableJoin);

   Result := lDestTable;
end;

// search join by alias-name from dest-table
function TSFStmtTable.GetJoinTableByAlias(pAlias: String; pSearchType: TSFStmtTableSearchType = stmtTableSearchAll): TSFStmtTable;
  var i: Integer;
      lJoin: TSFStmtTableJoin;
      lAlias: String;
begin
  Result := nil;
  lAlias := Trim(pAlias);
  for i := 0 to (mJoins.Count - 1) do
  begin
    lJoin := mJoins[i];
    case pSearchType of
      stmtTableSearchAll:
        begin
          if (AnsiCompareText(lJoin.DestTable.TableAlias, lAlias) = 0) or (lJoin.DestTable.TableName <> '') and
            ((AnsiCompareText(lJoin.DestTable.TableIdentifier, lAlias) = 0) or (AnsiCompareText(lJoin.DestTable.TableName, lAlias) = 0)) then
          begin
            Result := lJoin.DestTable
          end else
            Result := lJoin.DestTable.GetJoinTableByAlias(lAlias, pSearchType);
        end;
      stmtTableSearchOnlyAlias:
        begin
          if (lJoin.DestTable.TableAlias <> '') and (AnsiCompareText(lJoin.DestTable.TableAlias, lAlias) = 0) then
            Result := lJoin.DestTable
          else
            Result := lJoin.DestTable.GetJoinTableByAlias(lAlias, pSearchType);
        end;
      stmtTableSearchOnlyIdentifier:
        begin
          if (lJoin.DestTable.TableIdentifier <> '') and (AnsiCompareText(lJoin.DestTable.TableIdentifier, lAlias) = 0) then
            Result := lJoin.DestTable
          else
            Result := lJoin.DestTable.GetJoinTableByAlias(lAlias, pSearchType);
        end;
      stmtTableSearchOnlyName:
        begin
          if (lJoin.DestTable.TableName <> '') and (AnsiCompareText(lJoin.DestTable.TableName, lAlias) = 0) then
            Result := lJoin.DestTable
          else
            Result := lJoin.DestTable.GetJoinTableByAlias(lAlias, pSearchType);
        end;
    end;

    if (Result <> nil) then
      Break;
  end;
end;

function TSFStmtTable.GetJoinTableAliasesForAttr(pAttr: String): Variant;
  var i, x: Integer;
      lJoin: TSFStmtTableJoin;
      lAttr: String;
      lResult: Array of Variant;
begin
  Result := NULL;

  lAttr := Trim(pAttr);
  for i := 0 to (mJoins.Count - 1) do
  begin
    lJoin := mJoins[i];
    for x := Low(lJoin.mRelItems) to High(lJoin.mRelItems) do
    begin
      if (lJoin.mRelItems[x].riSrcType = stmtJoinRelItemAttr) and (AnsiUpperCase(lJoin.mRelItems[x].riSrcValue) = AnsiUpperCase(lAttr)) then
      begin
        SetLength(lResult, Length(lResult) + 1);
        if (lJoin.DestTable.TableAlias <> '') then
          lResult[Length(lResult) - 1] := lJoin.DestTable.TableAlias
        else
          lResult[Length(lResult) - 1] := lJoin.DestTable.TableIdentifier;
      end;
    end;
  end;

  if (Length(lResult) > 0) then
    Result := lResult;
end;

// reset/clear all joins
procedure TSFStmtTable.ResetJoins;
begin
  mJoins.Clear;
end;

// table has related joins
function TSFStmtTable.HasJoins: Boolean;
begin
  Result := (mJoins.Count > 0);
end;

// detect max. table-no
function TSFStmtTable.GetMaxTableNo: Integer;
  var i, lNextNo: Integer;
begin
  Result := mTableNo;

  for i := 0 to (mJoins.Count - 1) do
  begin
    lNextNo := mJoins[i].DestTable.GetMaxTableNo;
    if (lNextNo > Result) then
      Result := lNextNo;
  end;
end;

// generate table-definition for select
function TSFStmtTable.GetTableDef(pWithAlias: Boolean): String;
  var i: Integer;
begin
  Result := '';

  if (mTableName <> '') then
    Result := QuotedTableIdentifier
  else if (TableStmt <> nil) then
  begin
    TableStmt.DBDialect := mParentStmt.DBDialect;
    TableStmt.QuoteType := mParentStmt.QuoteType;
    TableStmt.AutoEscapeLike := mParentStmt.AutoEscapeLike;
    Result := '(' + TableStmt.GetSelectStmt(mParentStmt.getGenerateNextLevel, mParentStmt.getGenerateNextSubId, mParentStmt.GenerateUnionId) + ')'
  end else
    Exit;

  if (pWithAlias) and (TableAlias <> '') then
    Result := Result + ' ' + mParentStmt.GetQuotedIdentifier(TableAlias);

  for i := 0 to (mJoins.Count - 1) do
  begin
    Result := Result + ' ' + mJoins[i].GetJoinDef;
  end;
end;

function TSFStmtTable.AssignStmtTable(pDestStmt: TSFStmt): TSFStmtTable;
  var lTableStmt: TSFStmt;
begin
  if (TableStmt <> nil) then
  begin
    lTableStmt := TableStmt.AssignStmt;
    Result := TSFStmtTable.Create(lTableStmt, mTableAlias, mTableNo, pDestStmt);
  end else
    Result := TSFStmtTable.Create(mTableName, mSchema, mCatalog, mTableAlias, mTableNo, pDestStmt);

  AssignStmtTableJoins(Result);
end;

procedure TSFStmtTable.AssignStmtTableJoins(pDest: TSFStmtTable);
  var lJoinStmt: TSFStmt;
      lDestJoinTable: TSFStmtTable;
      i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    if (mJoins[i].DestTable.TableStmt <> nil) then
    begin
      lJoinStmt := mJoins[i].DestTable.TableStmt.AssignStmt;
      lDestJoinTable := pDest.SetTableJoin(mJoins[i].DestTable.TableAlias, lJoinStmt, mJoins[i].DestTable.TableNo,
                                          assignRelItems(mJoins[i].mRelItems), mJoins[i].mType);
    end else
    begin
      lDestJoinTable := pDest.SetTableJoin(mJoins[i].DestTable.TableAlias, mJoins[i].DestTable.TableName,
                                          mJoins[i].DestTable.Schema, mJoins[i].DestTable.Catalog, mJoins[i].DestTable.TableNo,
                                          assignRelItems(mJoins[i].mRelItems), mJoins[i].mType);
    end;

    mJoins[i].DestTable.AssignStmtTableJoins(lDestJoinTable);
  end;
end;

function TSFStmtTable.GetJoinType(pDest: TSFStmtTable): TSFStmtJoinType;
  var i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    if (pDest = nil) or (mJoins[i].DestTable = pDest) then
    begin
      Result := mJoins[i].mType;
      Exit;
    end;
  end;

  Result := stmtJoinTypeNone;
end;

procedure TSFStmtTable.ModifyJoinType(pDest: TSFStmtTable; pTypeFrom, pTypeTo: TSFStmtJoinType);
  var i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    if (pDest = nil) or (mJoins[i].DestTable = pDest) then
    begin
      if (mJoins[i].mType = pTypeFrom) and (mJoins[i].mType <> pTypeTo) then
        mJoins[i].mType := pTypeTo;
    end;
  end;
end;

function TSFStmtTable.GetRelItemsForJoin(pDest: TSFStmtTable): TSFStmtJoinRelItems;
  var i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    if (mJoins[i].DestTable = pDest) then
    begin
      Result := mJoins[i].mRelItems;
      Exit;
    end;
  end;
end;

procedure TSFStmtTable.SetRelItemsForJoin(pDest: TSFStmtTable; pRelItems: TSFStmtJoinRelItems);
  var i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    if (mJoins[i].DestTable = pDest) then
    begin
      mJoins[i].mRelItems := pRelItems;
      Exit;
    end;
  end;
end;

function TSFStmtTable.QuotedTableIdentifier: String;
begin
  Result := '';
  if (mTableName <> '') then
  begin
    Result := QuotedTableName;
    if (mSchema <> '') then
      Result := QuotedTableSchema + '.' + Result;
    if (mCatalog <> '') then
      Result := QuotedTableCatalog + '.' + Result;
  end;
end;

function TSFStmtTable.QuotedTableName: String;
begin
  Result := '';
  if (mTableName <> '') then
    Result := mParentStmt.GetQuotedIdentifier(mTableName);
end;

function TSFStmtTable.QuotedTableSchema: String;
begin
  Result := '';
  if (mSchema <> '') then
    Result := mParentStmt.GetQuotedIdentifier(mSchema);
end;

function TSFStmtTable.QuotedTableCatalog: String;
begin
  Result := '';
  if (mCatalog <> '') then
    Result := mParentStmt.GetQuotedIdentifier(mCatalog);
end;

procedure TSFStmtTable.ListJoinTables(pLst: TObjectList<TSFStmtTable>; pRecursive: Boolean = True);
  var i: Integer;
begin
  for i := 0 to (mJoins.Count - 1) do
  begin
    pLst.Add(mJoins[i].DestTable);
    if (pRecursive) then
      mJoins[i].DestTable.ListJoinTables(pLst);
  end;
end;

procedure TSFStmtTable.SaveToXmlTable(pXmlTable: TSFStmtTableXML);
  var i: Integer;
      lXmlRelation: TSFStmtTableRelationXML;
begin
  pXmlTable.TableNo := TableNo;
  pXmlTable.TableAlias := TableAlias;
  if (TableName <> '') then
  begin
    pXmlTable.TableIsStmt := False;
    pXmlTable.TableName := TableName;
    pXmlTable.Schema := Schema;
    pXmlTable.Catalog := Catalog;
  end else
  if (mTableStmtName <> '') or (TableStmt <> nil) then
  begin
    pXmlTable.TableIsStmt := True;
    if (mTableStmtName <> '') then
      pXmlTable.StmtName := mTableStmtName
    else
      pXmlTable.StmtName := TableStmt.GetReferencedStmtNamePath;
  end;

  for i := 0 to (mJoins.Count - 1) do
  begin
    lXmlRelation := TSFStmtTableRelationXML(pXmlTable.Relations.AddItem);
    mJoins[i].SaveToXmlRelation(lXmlRelation);
  end;
end;

procedure TSFStmtTable.LoadFromXmlTable(pXmlTable: TSFStmtTableXML; pSuspendRefs: Boolean);
  var i: Integer;
      lXmlRelation: TSFStmtTableRelationXML;
      lDestJoinTable: TSFStmtTable;
begin
  if (pXmlTable.HasRelations) then
  begin
    for i := 0 to (pXmlTable.Relations.Count - 1) do
    begin
      lXmlRelation := TSFStmtTableRelationXML(pXmlTable.Relations.Item[i]);

      if not(lXmlRelation.HasDestTable) then
        Continue;

      if (lXmlRelation.DestTable.TableIsStmt) then
      begin
        if (pSuspendRefs) then
        begin
          lDestJoinTable := mParentStmt.SetTableJoin(lXmlRelation.DestTable.TableAlias, Self,
                              mParentStmt.GetReferencedStmtByNamePath(lXmlRelation.DestTable.StmtName),
                              mParentStmt.createRelItemsFromXmlRelItems(lXmlRelation.RelationItems),
                              TSFStmtJoinType(lXmlRelation.ParentTableJoinType));
        end else
        begin
          lDestJoinTable := mParentStmt.SetTableJoin(lXmlRelation.DestTable.TableAlias, Self,
                              lXmlRelation.DestTable.StmtName, mParentStmt.createRelItemsFromXmlRelItems(lXmlRelation.RelationItems),
                              TSFStmtJoinType(lXmlRelation.ParentTableJoinType));
        end;
      end else
      begin
        lDestJoinTable := mParentStmt.SetTableJoin(lXmlRelation.DestTable.TableAlias, lXmlRelation.DestTable.TableName,
                              lXmlRelation.DestTable.Schema, lXmlRelation.DestTable.Catalog, Self,
                              mParentStmt.createRelItemsFromXmlRelItems(lXmlRelation.RelationItems),
                              TSFStmtJoinType(lXmlRelation.ParentTableJoinType));
      end;

      lDestJoinTable.LoadFromXmlTable(lXmlRelation.DestTable, pSuspendRefs);
    end;
  end;
end;

function TSFStmtTable.assignRelItems(pRelItems: TSFStmtJoinRelItems): TSFStmtJoinRelItems;
  var i: Integer;
begin
  SetLength(Result, Length(pRelItems));

  for i := Low(pRelItems) to High(pRelItems) do
  begin
    Result[i].riSrcType := pRelItems[i].riSrcType;
    Result[i].riSrcValue := pRelItems[i].riSrcValue;
    Result[i].riDestType := pRelItems[i].riDestType;
    Result[i].riDestValue := pRelItems[i].riDestValue;
  end;
end;

function TSFStmtTable.getTableIdentifier: String;
  var lTableIdent: TSFStmtTableIdent;
begin
  Result := '';
  if (mTableName <> '') then
  begin
    lTableIdent.tiTableName := mTableName;
    lTableIdent.tiSchemaName := mSchema;
    lTableIdent.tiCatalogName := mCatalog;

    Result := lTableIdent.GetTableIdent;
  end;
end;

function TSFStmtTable.getTableStmt: TSFStmt;
begin
  Result := mTableStmt;
  if not(Assigned(Result)) and (mTableStmtName <> '') then
    Result := mParentStmt.GetReferencedStmtByNamePath(mTableStmtName);
end;

function TSFStmtTable.getTableAlias: String;
begin
  if (Assigned(mParentStmt)) and ((mParentStmt.GenerateLevel > 0) or (mParentStmt.GenerateSubId > 0) or (mParentStmt.GenerateUnionId > 0)) then
    Result := TableAliasNested[mParentStmt.GenerateLevel, mParentStmt.GenerateSubId, mParentStmt.GenerateUnionId]
  else
    Result := mTableAlias;
end;

function TSFStmtTable.getTableAliasNested(pLevel, pSubId, pUnionId: Integer): String;
begin
  if (pLevel > 0) or (pSubId > 0) or (pUnionId > 0) then
  begin
    Result := '';
    // the subid on alias is only for subselects (level > 0)
    if (pSubId > 0) and (pLevel > 0) then
      Result := Result + 's' + IntToStr(pSubId);
    if (pLevel > 0) then
      Result := Result + 'n' + IntToStr(pLevel);
    if (pUnionId > 0) then
      Result := Result + 'u' + IntToStr(pUnionId);

    Result := Result + mTableAlias;
  end else
    Result := mTableAlias;
end;

// ===========================================================================//
//                             TSFStmtTableJoin                                //
// ===========================================================================//

// constructor
constructor TSFStmtTableJoin.Create(pSrcTab, pDestTab: TSFStmtTable; pRelItems: TSFStmtJoinRelItems; pType: TSFStmtJoinType);
begin
  inherited Create;

  mSourceTable := pSrcTab;
  mDestTable := pDestTab;
  mRelItems := pRelItems;
  mType := pType;
end;

// destructor
destructor TSFStmtTableJoin.Destroy;
begin
  inherited;

  FreeAndNil(mDestTable);
end;

// generate join-definition for select-stmt
function TSFStmtTableJoin.GetJoinDef: String;
  var i: Integer;
begin
  if (mType = stmtJoinTypeInner) then
    Result := ' INNER JOIN '
  else if (mType = stmtJoinTypeOuter) then
    Result := ' LEFT OUTER JOIN '
  else if (mType =  stmtJoinTypeROuter) then
    Result := ' RIGHT OUTER JOIN '
  else
    Result := ', ';

  if (mType = stmtJoinTypeNone) then
    Result := Result +  mDestTable.GetTableDef
  else
  begin
    if (mDestTable.HasJoins) then
      Result := Result + '(';

    Result := Result + mDestTable.GetTableDef;

    if (mDestTable.HasJoins) then
      Result := Result + ')';

    Result := Result + ' ON ';

    for i := Low(mRelItems) to High(mRelItems) do
    begin
      if (i > Low(mRelItems)) then
        Result := Result + ' AND ';

      if (mRelItems[i].riDestType = stmtJoinRelItemAttr) and (mRelItems[i].riSrcType = stmtJoinRelItemAttr) then
      begin
        Result := Result + mSourceTable.ParentStmt.GetQuotedIdentifier(mSourceTable.TableAlias) + '.' + mSourceTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riSrcValue)) + ' = '
                          + mDestTable.ParentStmt.GetQuotedIdentifier(mDestTable.TableAlias) + '.' + mDestTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riDestValue));
      end else
      if (mRelItems[i].riSrcType = stmtJoinRelItemAttr) then
      begin
        Result := Result + mSourceTable.ParentStmt.GetQuotedIdentifier(mSourceTable.TableAlias) + '.' + mSourceTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riSrcValue)) + ' = '
                          + mDestTable.ParentStmt.GetConvertedValue(mRelItems[i].riDestValue);
      end else
      if (mRelItems[i].riDestType = stmtJoinRelItemAttr) then
      begin
        Result := Result + mDestTable.ParentStmt.GetQuotedIdentifier(mDestTable.TableAlias) + '.' + mDestTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riDestValue)) + ' = '
                          + mSourceTable.ParentStmt.GetConvertedValue(mRelItems[i].riSrcValue);
      end else
      begin
        Result := Result + mSourceTable.ParentStmt.GetConvertedValue(mRelItems[i].riSrcValue) + ' = '
                          + mDestTable.ParentStmt.GetConvertedValue(mRelItems[i].riDestValue);
      end;
    end;
  end;
end;

procedure TSFStmtTableJoin.SaveToXmlRelation(pXmlRelation: TSFStmtTableRelationXML);
  var i: Integer;
      lXmlRelItem: TSFStmtTableRelationItemXML;
begin
  pXmlRelation.ParentTableJoinType := Integer(mType);

  for i := Low(mRelItems) to High(mRelItems) do
  begin
    lXmlRelItem := TSFStmtTableRelationItemXML(pXmlRelation.RelationItems.AddItem);
    lXmlRelItem.SrcType := Integer(mRelItems[i].riSrcType);
    lXmlRelItem.SrcValue := mRelItems[i].riSrcValue;
    if (mRelItems[i].riSrcType = stmtJoinRelItemValue) then
      lXmlRelItem.SrcValueType := Integer(mSourceTable.ParentStmt.GetTypeForValue(mRelItems[i].riSrcValue));
    lXmlRelItem.DestType := Integer(mRelItems[i].riDestType);
    lXmlRelItem.DestValue := mRelItems[i].riDestValue;
    if (mRelItems[i].riDestType = stmtJoinRelItemValue) then
      lXmlRelItem.DestValueType := Integer(mSourceTable.ParentStmt.GetTypeForValue(mRelItems[i].riDestValue));
  end;

  if (mDestTable <> nil) then
    mDestTable.SaveToXmlTable(pXmlRelation.DestTable);
end;

// ===========================================================================//
//                             TSFStmtCondition                                //
// ===========================================================================//

constructor TSFStmtCondition.Create(pParentStmt: TSFStmt; pAttr: TSFStmtAttr; pOp: String; pVal: Variant; pType: TSFStmtConditionType);
begin
  inherited Create;

  mStmtAttr := pAttr;
  mOperator := Trim(pOp);
  mValue := pVal;
  mType := pType;
  mParentStmt := pParentStmt;
end;

// generate condition for stmt
function TSFStmtCondition.GetConditionDef(pWithAliases: Boolean): String;
begin
  Result := '';

  case mType of
    stmtCondTypeAttribute, stmtCondTypeValue,
    stmtCondTypeIsNull, stmtCondTypeIsNotNull: Result := getAttrCondition(pWithAliases);
    stmtCondTypeOpen: Result := '(';
    stmtCondTypeClose: Result := ')';
    stmtCondTypeAnd: Result := 'AND';
    stmtCondTypeOr: Result := 'OR';
  end;
end;

function TSFStmtCondition.AssignStmtCondition(pDestStmt: TSFStmt): TSFStmtCondition;
  var lSrcAttr, lDestAttr: TSFStmtAttr;
      lTabSearch, lAttrSearch: String;
begin
  lTabSearch := '';
  lAttrSearch := mStmtAttr.AttrName;
  if (mStmtAttr.DBAttrTable <> nil) then
  begin
    lAttrSearch := mStmtAttr.DBAttrName;
    if (mStmtAttr.DBAttrTable.TableAlias <> '') then
      lTabSearch := mStmtAttr.DBAttrTable.TableAlias
    else if (mStmtAttr.DBAttrTable.TableName <> '') then
      lTabSearch := mStmtAttr.DBAttrTable.TableIdentifier;
  end;

  lSrcAttr := pDestStmt.getAttrByName(lAttrSearch, lTabSearch);
  if (mType = stmtCondTypeAttribute) then
  begin
    lTabSearch := '';
    lAttrSearch := TSFStmtAttr(Pointer(Integer(mValue))).AttrName;
    if (TSFStmtAttr(Pointer(Integer(mValue))).DBAttrTable <> nil) then
    begin
      lAttrSearch := TSFStmtAttr(Pointer(Integer(mValue))).DBAttrName;
      if (TSFStmtAttr(Pointer(Integer(mValue))).DBAttrTable.TableAlias <> '') then
        lTabSearch := TSFStmtAttr(Pointer(Integer(mValue))).DBAttrTable.TableAlias
      else if (TSFStmtAttr(Pointer(Integer(mValue))).DBAttrTable.TableName <> '') then
        lTabSearch := TSFStmtAttr(Pointer(Integer(mValue))).DBAttrTable.TableIdentifier;
    end;

    lDestAttr := pDestStmt.getAttrByName(lAttrSearch, lTabSearch);

    Result := TSFStmtCondition.Create(pDestStmt, lSrcAttr, mOperator, Integer(Pointer(@lDestAttr)^), stmtCondTypeAttribute);
  end else
    Result := TSFStmtCondition.Create(pDestStmt, lSrcAttr, mOperator, mValue, mType);
end;

procedure TSFStmtCondition.SaveToXmlCondition(pXmlCond: TSFStmtCondXML);
begin
  pXmlCond.CondType := Integer(CondType);
  pXmlCond.CondOperator := CondOperator;

  case CondType of
    stmtCondTypeValue, stmtCondTypeAttribute,
    stmtCondTypeIsNull, stmtCondTypeIsNotNull:
      begin
        pXmlCond.AttrIdx := mParentStmt.mStmtAttrs.IndexOf(StmtAttr);
        if (CondType = stmtCondTypeAttribute) then
          pXmlCond.DestAttrIdx := mParentStmt.mStmtAttrs.IndexOf(TSFStmtAttr(Pointer(Integer(CondValue))))
        else if (CondType = stmtCondTypeValue) then
        begin
          if not(VarIsNull(CondValue)) then
          begin
            if (VarIsArray(CondValue)) then
            begin
              pXmlCond.DestValueIsArray := True;
              pXmlCond.DestValue := mParentStmt.ConvertArrayValueToStr(CondValue);
            end else
              pXmlCond.DestValue := CondValue;

            pXmlCond.DestValueType := Integer(mParentStmt.GetTypeForValue(CondValue));
          end;
        end;
      end;
  end;
end;

// generate condtion with attr
function TSFStmtCondition.getAttrCondition(pWithAliases: Boolean): String;
  var lIsLike: Boolean;
begin
  lIsLike := False;
  if (mOperator <> '') then
  begin
    lIsLike := (UpperCase(mOperator) = SFSTMT_OP_LIKE) or
                (UpperCase(mOperator) = SFSTMT_OP_NOT_LIKE);
  end;

  Result := mStmtAttr.GetAttrDef(False, pWithAliases, False, lIsLike) + ' ';
  if (mOperator <> '') then
    Result := Result + mOperator + ' ';

  if (mType = stmtCondTypeAttribute) then
    Result := Result + TSFStmtAttr(Pointer(Integer(mValue))).GetAttrDef(False, pWithAliases, False, lIsLike)
  else if (mType = stmtCondTypeValue) then
    Result := Result + mParentStmt.GetConvertedValue(mValue, False, lIsLike)
  else if (mType = stmtCondTypeIsNull) then
    Result := Result + ' IS NULL'
  else if (mType = stmtCondTypeIsNotNull) then
    Result := Result + ' IS NOT NULL';

  if not(mParentStmt.AutoEscapeLike) and (lIsLike) and (mParentStmt.LikeEscapeChar <> '') and (mParentStmt.GetDBDialectLikeSupportsEscape) then
    Result := Result + ' ESCAPE ''' + mParentStmt.LikeEscapeChar + '''';
end;

// ===========================================================================//
//                          TSFStmtConditionExists                             //
// ===========================================================================//

constructor TSFStmtConditionExists.Create(pDestStmt: TSFStmt; pSrcTable, pDestTable: TSFStmtTable; pRelItems: TSFStmtJoinRelItems; pOp: String);
begin
  inherited Create;

  mStmtAttr := nil;
  mOperator := Trim(pOp);
  mValue := NULL;
  mType := stmtCondTypeUndefined;

  mDestStmt := pDestStmt;
  mDestStmtName := '';
  mSrcTable := pSrcTable;
  mDestTable := pDestTable;
  mDestTableName := '';
  mRelItems := pRelItems;
end;

constructor TSFStmtConditionExists.Create(pDestStmtName: String; pSrcTable: TSFStmtTable; pDestTableName: String; pRelItems: TSFStmtJoinRelItems; pOp: String);
begin
  inherited Create;

  mStmtAttr := nil;
  mOperator := Trim(pOp);
  mValue := NULL;
  mType := stmtCondTypeUndefined;

  mDestStmt := nil;
  mDestStmtName := pDestStmtName;
  mSrcTable := pSrcTable;
  mDestTable := nil;
  mDestTableName := pDestTableName;
  mRelItems := pRelItems;
end;

destructor TSFStmtConditionExists.Destroy;
begin
  inherited;

  if (Assigned(mDestStmt)) and (mDestStmt.Owner = nil) then
    mDestStmt.Free;

  mDestStmt := nil;
  mDestStmtName := '';
  mDestTable := nil;
  mDestTableName := '';
end;

// generate condition for stmt
function TSFStmtConditionExists.GetConditionDef(pWithAliases: Boolean): String;
  var i, lDestLvl, lSubId, lUnionId: Integer;
begin
  Result := '';
  if not(Assigned(DestStmt)) then
    Exit;

  Result := mOperator + ' (';
  DestStmt.DBDialect := mSrcTable.ParentStmt.DBDialect;
  DestStmt.QuoteType := mSrcTable.ParentStmt.QuoteType;
  DestStmt.AutoEscapeLike := mSrcTable.ParentStmt.AutoEscapeLike;
  lDestLvl := mSrcTable.ParentStmt.getGenerateNextLevel;
  lSubId := mSrcTable.ParentStmt.getGenerateNextSubId;
  lUnionId := mSrcTable.ParentStmt.GenerateUnionId;
  Result := Result + DestStmt.GetSelectStmt(lDestLvl, lSubId, lUnionId);

  if (stmtGenWhere in DestStmt.StmtGenInfos) then
    Result := Result + ' AND '
  else
    Result := Result + ' WHERE ';

  for i := Low(mRelItems) to High(mRelItems) do
  begin
    if (i > Low(mRelItems)) then
      Result := Result + ' AND ';

    if (mRelItems[i].riDestType = stmtJoinRelItemAttr) and (mRelItems[i].riSrcType = stmtJoinRelItemAttr) then
    begin
      Result := Result + DestTable.ParentStmt.GetQuotedIdentifier(DestTable.TableAliasNested[lDestLvl, lSubId, lUnionId]) + '.' + DestTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riDestValue)) + ' = '
                        + mSrcTable.ParentStmt.GetQuotedIdentifier(mSrcTable.TableAlias) + '.' + mSrcTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riSrcValue));
    end else
    if (mRelItems[i].riSrcType = stmtJoinRelItemAttr) then
    begin
      Result := Result + mSrcTable.ParentStmt.GetQuotedIdentifier(mSrcTable.TableAlias) + '.' + mSrcTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riSrcValue)) + ' = '
                        + DestTable.ParentStmt.GetConvertedValue(mRelItems[i].riDestValue);
    end else
    if (mRelItems[i].riDestType = stmtJoinRelItemAttr) then
    begin
      Result := Result + DestTable.ParentStmt.GetQuotedIdentifier(DestTable.TableAliasNested[lDestLvl, lSubId, lUnionId]) + '.' + DestTable.ParentStmt.GetQuotedIdentifier(Trim(mRelItems[i].riDestValue)) + ' = '
                        + mSrcTable.ParentStmt.GetConvertedValue(mRelItems[i].riSrcValue);
    end else
    begin
      Result := Result + mSrcTable.ParentStmt.GetConvertedValue(mRelItems[i].riSrcValue) + ' = '
                        + DestTable.ParentStmt.GetConvertedValue(mRelItems[i].riDestValue);
    end;
  end;

  Result := Result + ')';
end;

function TSFStmtConditionExists.AssignStmtCondition(pDestStmt: TSFStmt): TSFStmtCondition;
  var lDestStmt: TSFStmt;
      lSrcTab, lDestTab: TSFStmtTable;
      lTabSearch: String;
begin
  if (mSrcTable.TableAlias <> '') then
    lTabSearch := mSrcTable.TableAlias
  else
    lTabSearch := mSrcTable.TableIdentifier;

  lSrcTab := pDestStmt.getTableByAlias(lTabSearch);

  lDestStmt := nil;
  lDestTab := nil;
  if (Assigned(DestStmt)) then
  begin
    lDestStmt := DestStmt.AssignStmt;
    if (DestTable.TableAlias <> '') then
      lTabSearch := DestTable.TableAlias
    else
      lTabSearch := DestTable.TableIdentifier;

    lDestTab := lDestStmt.getTableByAlias(lTabSearch);
  end;

  Result := TSFStmtConditionExists.Create(lDestStmt, lSrcTab, lDestTab, mSrcTable.assignRelItems(mRelItems), mOperator);
end;

procedure TSFStmtConditionExists.SaveToXmlCondition(pXmlCond: TSFStmtCondXML);
  var i: Integer;
      lXmlRelItem: TSFStmtTableRelationItemXML;
begin
  inherited;

  pXmlCond.ExistsTableAliasFrom := SrcTable.TableAlias;

  if (mDestStmtName <> '') then
    pXmlCond.ExistsDestRefStmtName := mDestStmtName
  else if (DestStmt <> nil) then
    pXmlCond.ExistsDestRefStmtName := DestStmt.GetReferencedStmtNamePath;

  if (mDestTableName <> '') then
    pXmlCond.ExistsDestRefStmtTableAlias := mDestTableName
  else if (DestTable <> nil) then
    pXmlCond.ExistsDestRefStmtTableAlias := DestTable.TableAlias;

  for i := Low(mRelItems) to High(mRelItems) do
  begin
    lXmlRelItem := TSFStmtTableRelationItemXML(pXmlCond.ExistsRelation.AddItem);
    lXmlRelItem.SrcType := Integer(mRelItems[i].riSrcType);
    lXmlRelItem.SrcValue := mRelItems[i].riSrcValue;
    if (mRelItems[i].riSrcType = stmtJoinRelItemValue) then
      lXmlRelItem.SrcValueType := Integer(mSrcTable.ParentStmt.GetTypeForValue(mRelItems[i].riSrcValue));
    lXmlRelItem.DestType := Integer(mRelItems[i].riDestType);
    lXmlRelItem.DestValue := mRelItems[i].riDestValue;
    if (mRelItems[i].riDestType = stmtJoinRelItemValue) then
      lXmlRelItem.DestValueType := Integer(mSrcTable.ParentStmt.GetTypeForValue(mRelItems[i].riDestValue));
  end;
end;

function TSFStmtConditionExists.getDestStmt: TSFStmt;
begin
  Result := mDestStmt;
  if not(Assigned(Result)) and (mDestStmtName <> '') then
    Result := SrcTable.ParentStmt.GetReferencedStmtByNamePath(mDestStmtName);
end;

function TSFStmtConditionExists.getDestTable: TSFStmtTable;
begin
  Result := mDestTable;
  if not(Assigned(Result)) and (mDestTableName <> '') and (Assigned(DestStmt)) then
    Result := DestStmt.getTableByAlias(mDestTableName);
end;

// ===========================================================================//
//                                TSFStmtAttr                                  //
// ===========================================================================//

constructor TSFStmtAttr.Create(pParentStmt: TSFStmt; pAttrName: String; pOnlyForSearch: Boolean);
begin
  inherited Create;

  mParentStmt := pParentStmt;
  mAttrName := Trim(pAttrName);
  mOnlyForSearch := pOnlyForSearch;
  mSortType := stmtSortTypeAsc;

  mItems := TObjectList<TSFStmtAttrItem>.Create(True);
end;

destructor TSFStmtAttr.Destroy;
begin
  inherited;

  mItems.Clear;
  FreeAndNil(mItems);
end;

// generate attribute for select-stmt (with alias)
function TSFStmtAttr.GetSelectDef: String;
begin
  Result := '';

  if not(mOnlyForSearch) then
  begin
    Result := GetAttrDef(False, True, True);

    if (mAttrName <> '') and not IsSingleDBFieldUndefined then
      Result := Result + ' AS ' + mParentStmt.GetQuotedIdentifier(mAttrName);
  end;
end;

// generate definition for attribute
function TSFStmtAttr.GetAttrDef(pWithSortType: Boolean = False;
                                pWithAliases: Boolean = True;
                                pExplicitCast: Boolean = False;
                                pEscapeLike: Boolean = False): String;
  var i: Integer;
begin
  Result := '';

  for i := 0 to (mItems.Count - 1) do
    Result := Result + mItems[i].GetAttrItemDef(pWithAliases, pExplicitCast, pEscapeLike);

  if (pWithSortType) and (mSortType = stmtSortTypeDesc) then
    Result := Result + ' Desc';
end;

function TSFStmtAttr.HasItems: Boolean;
begin
  Result := (mItems.Count > 0);
end;

function TSFStmtAttr.IsSingleItem: Boolean;
begin
  Result := (mItems.Count = 1);
end;

function TSFStmtAttr.IsSingleDBFieldItem: Boolean;
begin
  Result := IsSingleItem and (mItems[0].ItemType = stmtAttrItemTypeDbField);
end;

function TSFStmtAttr.IsSingleDBFieldUndefined: Boolean;
begin
  Result := (IsSingleDBFieldItem) and (DBAttrName = SFSTMTATTR_UNDEFINED);
end;

procedure TSFStmtAttr.AddItem(pType: TSFStmtAttrItemType; pTable: TSFStmtTable; pItemValue: Variant; pAggr: String);
begin
  mItems.Add(TSFStmtAttrItem.Create(Self, pType, pTable, pItemValue, pAggr));
end;

procedure TSFStmtAttr.AddItemDbFld(pTable: TSFStmtTable; pAttrName, pAggr: String);
begin
  AddItem(stmtAttrItemTypeDbField, pTable, pAttrName, pAggr);
end;

procedure TSFStmtAttr.AddItemValue(pValue: Variant);
begin
  AddItem(stmtAttrItemTypeValue, nil, pValue, '');
end;

procedure TSFStmtAttr.AddItemValueDateTime(pValue: TDateTime);
begin
  AddItemValue(pValue);
end;

procedure TSFStmtAttr.AddItemValueDate(pValue: TDate);
begin
  AddItemValue(pValue);
end;

procedure TSFStmtAttr.AddItemValueTime(pValue: TTime);
  var lValue: TDateTime;
begin
  lValue := mParentStmt.ConfigStmtTimeValue(pValue);
  AddItemValue(lValue);
end;

procedure TSFStmtAttr.AddItemStmt(pStmt: TSFStmt);
begin
  AddItem(stmtAttrItemTypeStmt, nil, Integer(Pointer(@pStmt)^), '');
end;

procedure TSFStmtAttr.AddItemStmt(pStmtName: String);
begin
  AddItem(stmtAttrItemTypeStmt, nil, pStmtName, '');
end;

procedure TSFStmtAttr.AddItemAggrFunc(pAggrFunc: string);
begin
  AddItem(stmtAttrItemTypeAggrFunc, nil, '', pAggrFunc);
end;

procedure TSFStmtAttr.AddItemParam(pParamName: String);
begin
  AddItem(stmtAttrItemTypeParameter, nil, pParamName, '');
end;

procedure TSFStmtAttr.AddItemOperator(pType: TSFStmtAttrItemOperatorType);
begin
  AddItem(TSFStmtAttrItemType(pType), nil, NULL, '');
end;

procedure TSFStmtAttr.AddItemBracket(pType: TSFStmtAttrItemBracketType);
begin
  AddItem(TSFStmtAttrItemType(pType), nil, NULL, '');
end;

procedure TSFStmtAttr.AddItemDynamic(pValue: String);
begin
  AddItem(stmtAttrItemTypeDynamic, nil, pValue, '');
end;

function TSFStmtAttr.AssignStmtAttr(pDestStmt: TSFStmt): TSFStmtAttr;
  var i: Integer;
      lItemTable: TSFStmtTable;
      lItemStmt: TSFStmt;
begin
  Result := TSFStmtAttr.Create(pDestStmt, mAttrName, mOnlyForSearch);
  Result.SortType := mSortType;

  for i := 0 to (mItems.Count - 1) do
  begin
    if (mItems[i].ItemType = stmtAttrItemTypeStmt) then
    begin
      if not(VarIsNull(mItems[i].ItemRef)) then
      begin
        lItemStmt := TSFStmt(Pointer(Integer(mItems[i].ItemRef))).AssignStmt;
        Result.AddItemStmt(lItemStmt);
      end;
    end else
    begin
      lItemTable := nil;
      if (Assigned(mItems[i].Table)) then
      begin
        if (mItems[i].Table.TableAlias <> '') then
          lItemTable := pDestStmt.getTableByAlias(mItems[i].Table.TableAlias);
        if (lItemTable = nil) and (mItems[i].Table.TableName <> '')  then
          lItemTable := pDestStmt.getTableByAlias(mItems[i].Table.TableIdentifier);
      end;

      Result.AddItem(mItems[i].ItemType, lItemTable, mItems[i].ItemRef, mItems[i].Aggr);
    end;
  end;
end;

procedure TSFStmtAttr.SetItemParamNamesToList(pLst: TStrings);
  var i: Integer;
begin
  if not(HasItems) then
    Exit;

  for i := 0 to (mItems.Count - 1) do
  begin
    if (mItems[i].ItemType = stmtAttrItemTypeParameter) then
      pLst.Add(VarToStr(mItems[i].ItemRef));
  end;
end;

procedure TSFStmtAttr.SaveToXmlAttr(pXmlAttr: TSFStmtAttrXML);
  var i: Integer;
begin
  pXmlAttr.AttrName := AttrName;
  pXmlAttr.OnlyForSearch := OnlyForSearch;

  for i := 0 to (mItems.Count - 1) do
    mItems[i].SaveToXmlAttrItem(TSFStmtAttrItemXML(pXmlAttr.AttrItems.AddItem));
end;

procedure TSFStmtAttr.LoadFromXmlAttr(pXmlAttr: TSFStmtAttrXML; pSuspendRefs: Boolean);
  var i: Integer;
      lXmlAttrItem: TSFStmtAttrItemXML;
      lRefValue: Variant;
begin
  if (pXmlAttr.HasAttrItems) then
  begin
    for i := 0 to (pXmlAttr.AttrItems.Count - 1) do
    begin
      lXmlAttrItem := TSFStmtAttrItemXML(pXmlAttr.AttrItems.Item[i]);
      if (lXmlAttrItem.ItemType < Integer(Low(TSFStmtAttrItemType))) or (lXmlAttrItem.ItemType > Integer(High(TSFStmtAttrItemType))) then
        Continue;

      case TSFStmtAttrItemType(lXmlAttrItem.ItemType) of
        stmtAttrItemTypeDbField:
          begin
            AddItemDbFld(mParentStmt.getTableByAlias(lXmlAttrItem.ItemRefTableAlias), lXmlAttrItem.ItemRefTableField, lXmlAttrItem.Aggr);
          end;
        stmtAttrItemTypeStmt:
          begin
            if (pSuspendRefs) then
              AddItemStmt(mParentStmt.GetReferencedStmtByNamePath(lXmlAttrItem.ItemRefStmtName))
            else
              AddItemStmt(lXmlAttrItem.ItemRefStmtName);
          end;
      else
        if (lXmlAttrItem.ItemRefOther <> '') and
          (lXmlAttrItem.ItemRefValueType >= Integer(Low(TSFStmtValueType))) and
          (lXmlAttrItem.ItemRefValueType <= Integer(High(TSFStmtValueType))) then
        begin
          lRefValue := lXmlAttrItem.ItemRefOther;
          mParentStmt.ConvertValueInType(lRefValue, TSFStmtValueType(lXmlAttrItem.ItemRefValueType));
          AddItem(TSFStmtAttrItemType(lXmlAttrItem.ItemType), nil, lRefValue, lXmlAttrItem.Aggr);
        end else
        begin
          if (lXmlAttrItem.ItemRefOther <> '') then
            AddItem(TSFStmtAttrItemType(lXmlAttrItem.ItemType), nil, lXmlAttrItem.ItemRefOther, lXmlAttrItem.Aggr)
          else
            AddItem(TSFStmtAttrItemType(lXmlAttrItem.ItemType), nil, NULL, lXmlAttrItem.Aggr);
        end;
      end;
    end;
  end;
end;

function TSFStmtAttr.getDBAttrName: String;
begin
  Result := '';
  if (IsSingleDBFieldItem) then
    Result := mItems[0].ItemRef;
end;

function TSFStmtAttr.getDBAttrTable: TSFStmtTable;
begin
  Result := nil;
  if (IsSingleDBFieldItem) then
    Result := mItems[0].Table;
end;

function TSFStmtAttr.getDBAttrAggr: String;
begin
  Result := '';
  if (IsSingleDBFieldItem) then
    Result := mItems[0].Aggr;
end;

// ===========================================================================//
//                              TSFStmtAttrItem                               //
// ===========================================================================//

constructor TSFStmtAttrItem.Create(pAttr: TSFStmtAttr; pType: TSFStmtAttrItemType; pTable: TSFStmtTable; pItemRef: Variant; pAggr: String);
begin
  inherited Create;

  mAttr := pAttr;
  mType := pType;
  mTable := pTable;
  mItemRef := pItemRef;
  if (mType = stmtAttrItemTypeDbField) or (mType = stmtAttrItemTypeParameter) then
    mItemRef := Trim(VarToStr(mItemRef));
  mAggr := Trim(pAggr);
end;

destructor TSFStmtAttrItem.Destroy;
begin
  inherited;

  if (mType = stmtAttrItemTypeStmt) and not(VarIsStr(mItemRef)) and (TSFStmt(Pointer(Integer(mItemRef))).Owner = nil) then
    TSFStmt(Pointer(Integer(mItemRef))).Free;

  mItemRef := NULL;
end;

function TSFStmtAttrItem.GetAttrItemDef(pWithAlias: Boolean; pExplicitCast, pEscapeLike: Boolean): String;
  var lStmtRef: TSFStmt;
begin
  Result := '';

  case mType of
    stmtAttrItemTypeDbField:
      begin
        if (Assigned(mTable)) and (pWithAlias) then
        begin
          if (mTable.TableAlias <> '') then
            Result := Result + mTable.ParentStmt.GetQuotedIdentifier(mTable.TableAlias) + '.'
          else if (mTable.TableName <> '') then
            Result := Result + mTable.QuotedTableIdentifier + '.'
        end;

        Result := Result + mTable.ParentStmt.GetQuotedIdentifier(mItemRef);

        if (mAggr <> '') then
          Result := mAggr + '(' + Result + ')';
      end;
    stmtAttrItemTypeOpPlus: Result := ' + ';
    stmtAttrItemTypeOpMinus: Result := ' - ';
    stmtAttrItemTypeOpMultiply: Result := ' * ';
    stmtAttrItemTypeOpDivide: Result := ' / ';
    stmtAttrItemTypeStmt:
      begin
        if not(VarIsNull(ItemRef)) then
        begin
          lStmtRef := TSFStmt(Pointer(Integer(ItemRef)));
        
          lStmtRef.DBDialect := mAttr.ParentStmt.DBDialect;
          lStmtRef.QuoteType := mAttr.ParentStmt.QuoteType;
          lStmtRef.AutoEscapeLike := mAttr.ParentStmt.AutoEscapeLike;

          Result := Chr(13) + Chr(10) + '(' + lStmtRef.GetSelectStmt(mAttr.ParentStmt.getGenerateNextLevel, mAttr.ParentStmt.getGenerateNextSubId, mAttr.ParentStmt.GenerateUnionId) + ')';
        end;
      end;
    stmtAttrItemTypeValue: Result := mAttr.ParentStmt.GetConvertedValue(mItemRef, pExplicitCast, pEscapeLike);
    stmtAttrItemTypeAggrFunc: Result := mAggr;
    stmtAttrItemTypeBracketOpen: Result := '(';
    stmtAttrItemTypeBracketClose: Result := ')';
    stmtAttrItemTypeParameter: Result := ':' + mItemRef;
    stmtAttrItemTypeDynamic: Result := mItemRef;
  end;
end;

procedure TSFStmtAttrItem.SaveToXmlAttrItem(pXmlAttrItem: TSFStmtAttrItemXML);
begin
  pXmlAttrItem.Aggr := Aggr;
  pXmlAttrItem.ItemType := Integer(ItemType);
  case ItemType of
    stmtAttrItemTypeDbField:
      begin
        pXmlAttrItem.ItemRefTableAlias := Table.TableAlias;
        pXmlAttrItem.ItemRefTableField := ItemRef;
      end;
    stmtAttrItemTypeStmt:
      begin
        if (VarIsStr(mItemRef)) then
          pXmlAttrItem.ItemRefStmtName := mItemRef
        else if not(VarIsNull(ItemRef)) then
          pXmlAttrItem.ItemRefStmtName := TSFStmt(Pointer(Integer(ItemRef))).GetReferencedStmtNamePath;
      end;
  else
    if not(VarIsNull(ItemRef)) then
    begin
      pXmlAttrItem.ItemRefOther := ItemRef;
      if (ItemType = stmtAttrItemTypeValue) then
        pXmlAttrItem.ItemRefValueType := Integer(mAttr.ParentStmt.GetTypeForValue(ItemRef));
    end;
  end;
end;

function TSFStmtAttrItem.getItemRef: Variant;
  var lStmtRef: TSFStmt;
begin
  Result := mItemRef;
  if (ItemType = stmtAttrItemTypeStmt) and (VarIsStr(Result)) then
  begin
    lStmtRef := mAttr.ParentStmt.GetReferencedStmtByNamePath(Result);
    if (lStmtRef <> nil) then
      Result := Integer(Pointer(@lStmtRef)^)
    else
      Result := NULL;
  end;
end;

// ===========================================================================//
//                            TSFStmtDBDialectConv                            //
// ===========================================================================//

constructor TSFStmtDBDialectConv.Create(pStmt: TSFStmt);
begin
  inherited Create;

  mStmt := pStmt;
end;

function TSFStmtDBDialectConv.ConvertStringValue(pValue: Variant; pEscapeLike: Boolean): String;
  var lEscChar: String;
begin
  Result := VarToStr(pValue);

  lEscChar := '';
  if (pEscapeLike) then
    lEscChar := EscapeLike(Result);

  Result := StringToDoubleQuotedString(Result);
  Result := AnsiQuotedStr(Result, '''');

  if (lEscChar <> '') then
    Result := Result + ' ESCAPE ''' + lEscChar + '''';
end;

function TSFStmtDBDialectConv.ConvertNumValue(pValue: Variant; pUsedDecSeparator: String): String;
begin
  Result := VarToStr(pValue);
  if (pUsedDecSeparator <> '') and (pUsedDecSeparator <> '.') then
    Result := AnsiReplaceStr(Result, pUsedDecSeparator, '.');
end;

function TSFStmtDBDialectConv.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
begin
  Result := DateToFormattedString(VarToDateTime(pValue));
  Result := AnsiQuotedStr(Result, '''');
end;

function TSFStmtDBDialectConv.StringToDoubleQuotedString(pString: String): String;
  var i, lLen, lPos: Integer;
      lDone: Boolean;
      lSearchStr: String;
begin
  Result := pString;

  // check all quotes (') are doubled inside the string
  lDone := False;
  i := 1;
  while lDone do
  begin
    lLen := Length(Result);
    while (i > 0) and (i <= lLen) do
    begin
      lSearchStr := AnsiMidStr(Result, i, Length(Result) - i + 1);
      lPos := AnsiPos('''', lSearchStr);
      lDone := (lPos <= 0);
      if (lDone) then
        Break;

      if (lPos >= Length(lSearchStr)) then
      begin
        Result := Result + '''';
        lDone := True;
        Break;
      end else
      begin
        if (AnsiMidStr(lSearchStr, lPos + 1, 1) <> '''') then
          Result := AnsiMidStr(Result, 1, i + lPos - 1) + '''' + AnsiMidStr(Result, i + lPos, lLen - i - lPos + 1);

        i := i + lPos + 1;
        Break;
      end;
    end;
  end;
end;

function TSFStmtDBDialectConv.HasDatePart(pDate: TDateTime): Boolean;
begin
  Result := mStmt.HasStmtDatePart(pDate);
end;

function TSFStmtDBDialectConv.HasTimePart(pDate: TDateTime): Boolean;
begin
  Result := mStmt.HasStmtTimePart(pDate);
end;

function TSFStmtDBDialectConv.GetDatePart(pDate: TDateTime): TDate;
begin
  Result := mStmt.GetStmtDatePart(pDate);
end;

function TSFStmtDBDialectConv.GetTimePart(pDate: TDateTime): TTime;
begin
  Result := mStmt.GetStmtTimePart(pDate);
end;

function TSFStmtDBDialectConv.DateToFormattedString(pDate: TDateTime; pDayBeforeMonth: Boolean = False;
            pDateSep: String = '-'; pTimeSep: String = ':'; pGenMilliSec: Boolean = True;
            pMilliSecSep: String = '.'): String;
  var lDateTime: TDateTime;
      lYear, lMonth, lDay, lHour, lMinute, lSecond, lMilliSecond: Word;
      lDatePartStr, lDayStr, lMonthStr: String;
      lHasDate, lHasTime: Boolean;
      lStrLen: Integer;
begin
  Result := '';

  lDateTime := pDate;

  lHasDate := HasDatePart(lDateTime);
  lHasTime := HasTimePart(lDateTime);

  if (lHasDate) then
    DecodeDate(GetDatePart(lDateTime), lYear, lMonth, lDay);
  if (lHasTime) then
    DecodeTime(GetTimePart(lDateTime), lHour, lMinute, lSecond, lMilliSecond);

  if (lHasDate) then
  begin
    lDatePartStr := IntToStr(lYear);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 4) then
      Result := Result + StringOfChar('0', 4 - lStrLen) + lDatePartStr
    else
      Result := Result + lDatePartStr;

    Result := Result + pDateSep;

    lDatePartStr := IntToStr(lMonth);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 2) then
      lMonthStr := StringOfChar('0', 2 - lStrLen) + lDatePartStr
    else
      lMonthStr := lDatePartStr;

    lDatePartStr := IntToStr(lDay);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 2) then
      lDayStr := StringOfChar('0', 2 - lStrLen) + lDatePartStr
    else
      lDayStr := lDatePartStr;

    if (pDayBeforeMonth) then
      Result := Result + lDayStr + pDateSep + lMonthStr
    else
      Result := Result + lMonthStr + pDateSep + lDayStr;
  end;

  if (lHasTime) then
  begin
    if (lHasDate) then
      Result := Result + ' ';

    lDatePartStr := IntToStr(lHour);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 2) then
      Result := StringOfChar('0', 2 - lStrLen) + lDatePartStr
    else
      Result := lDatePartStr;

    Result := Result + pTimeSep;

    lDatePartStr := IntToStr(lMinute);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 2) then
      Result := Result + StringOfChar('0', 2 - lStrLen) + lDatePartStr
    else
      Result := Result + lDatePartStr;

    Result := Result + pTimeSep;

    lDatePartStr := IntToStr(lSecond);
    lStrLen := Length(lDatePartStr);
    if (lStrLen < 2) then
      Result := Result + StringOfChar('0', 2 - lStrLen) + lDatePartStr
    else
      Result := Result + lDatePartStr;

    if (pGenMilliSec) and (lMilliSecond > 0) then
    begin
      Result := Result + pMilliSecSep;

      lDatePartStr := IntToStr(lSecond);
      lStrLen := Length(lDatePartStr);
      if (lStrLen < 2) then
        Result := Result + StringOfChar('0', 2 - lStrLen) + lDatePartStr
      else
        Result := Result + lDatePartStr;
    end;
  end;
end;

function TSFStmtDBDialectConv.ConvertValue(pValue: Variant; pUsedDecSeparator: String; pExplicitCast, pEscapeLike: Boolean): String;
  var i: Integer;
begin
  Result := '';

  if (VarIsType(pValue, [varEmpty, varNull])) then
    Result := 'NULL'
  else if (VarIsArray(pValue)) then
  begin
    for i := 0 to VarArrayHighBound(pValue, 1) do
    begin
      if (Result <> '') then
        Result := Result + ', '
      else
        Result := '(';

      Result := Result + ConvertValue(pValue[i], pUsedDecSeparator, pExplicitCast, pEscapeLike);
    end;

    if (Result <> '') then
      Result := Result + ')';
  end else
  begin
    case ValueTypeForValue(pValue) of
      stmtValTypeNumeric:
        Result := ConvertNumValue(pValue, pUsedDecSeparator);
      stmtValTypeDate,
      stmtValTypeTime,
      stmtValTypeDateTime:
        Result := ConvertDateValue(pValue, pExplicitCast);
      stmtValTypeBool:
        Result := IntToStr(Integer(pValue));
      stmtValTypeString:
        Result := ConvertStringValue(pValue, pEscapeLike)
    else
      Result := VarToStr(pValue);
    end;
  end;
end;

function TSFStmtDBDialectConv.ValueTypeForValue(pValue: Variant): TSFStmtValueType;
  var lHasDate, lHasTime: Boolean;
begin
  Result := stmtValTypeOther;

  if (VarIsArray(pValue)) then
    Result := ValueTypeForValue(pValue[0])
  else if (VarIsType(pValue, [varSingle, varDouble, varCurrency, varFMTBcd])) or (VarIsNumeric(pValue)) then
    Result := stmtValTypeNumeric
  else if (VarIsType(pValue, [varDate, varSQLTimeStamp])) then
  begin
    lHasDate := HasDatePart(pValue);
    lHasTime := HasTimePart(pValue);

    if (lHasDate) and (lHasTime) then
      Result := stmtValTypeDateTime
    else if (lHasDate) then
      Result := stmtValTypeDate
    else if (lHasTime) then
      Result := stmtValTypeTime
  end
  else if (VarIsType(pValue, varBoolean)) then
    Result := stmtValTypeBool
  else if (VarIsStr(pValue)) then
    Result := stmtValTypeString;
end;

function TSFStmtDBDialectConv.EscapeLike(var pValue: String): String;
  const lcEscChars: Array[0..7] of String = ('#', '!', '$', '/', '{', '}', '&', '~');
  var lLikeSearchTxt, lLikeWildcardMany, lLikeWildcardSingle, lLikeWildcard, lEscapeChr: String;
      i, lPos, lPosStart: Integer;
begin
  Result := '';

  if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) or not(VarIsStr(pValue)) then
    Exit;

  lLikeSearchTxt := pValue;
  lLikeWildcardMany := GetLikeWildcardMany;
  lLikeWildcardSingle := GetLikeWildcardSingle;
  lEscapeChr := '';
  if (SupportsLikeEscape) and (lLikeWildcardMany <> '') and ((Pos(lLikeWildcardMany, lLikeSearchTxt) > 0)
    or (lLikeWildcardSingle <> '') and (Pos(lLikeWildcardSingle, lLikeSearchTxt) > 0)) then
  begin
    for i := Low(lcEscChars) to High(lcEscChars) do
    begin
      if (Pos(lcEscChars[i], lLikeSearchTxt) = 0) then
      begin
        lEscapeChr := lcEscChars[i];
        Break;
      end;
    end;

    if (lEscapeChr <> '') then
    begin
      for i := 1 to 2 do
      begin
        lLikeWildcard := '';
        if (i = 1) then
          lLikeWildcard := lLikeWildcardMany
        else if (lLikeWildcardMany <> lLikeWildcardSingle) then
          lLikeWildcard := lLikeWildcardSingle;

        if (lLikeWildcard = '') then
          Continue;

        lPos := 1;
        while (lPos > 0) and (lPos <= Length(lLikeSearchTxt)) do
        begin
          lPosStart := lPos;
          lPos := Pos(lLikeWildcard, lLikeSearchTxt, lPosStart);
          if (lPos > 0) then
          begin
            lLikeSearchTxt := MidStr(lLikeSearchTxt, 1, lPos - 1) + lEscapeChr + MidStr(lLikeSearchTxt, lPos, Length(lLikeSearchTxt) - lPos + 1);
            lPos := lPos + 2;
          end;
        end;
      end;
    end;
  end;

  if (lLikeWildcardMany <> '') then
    lLikeSearchTxt := lLikeWildcardMany + lLikeSearchTxt + lLikeWildcardMany;

  Result := lEscapeChr;
  pValue := lLikeSearchTxt;
end;

function TSFStmtDBDialectConv.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

function TSFStmtDBDialectConv.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Stmt.Reset;

  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('@@IDENTITY');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConv.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := False;
  pTableName := '';
end;

class function TSFStmtDBDialectConv.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := False;
end;

class function TSFStmtDBDialectConv.GetNeedTableOnSubInFrom: Boolean;
  var lTab: String;
begin
  Result := not(GetCanSelectWithoutTable(lTab));
end;

class function TSFStmtDBDialectConv.GetStartQuote: String;
begin
  Result := '"';
end;

class function TSFStmtDBDialectConv.GetEndQuote: String;
begin
  Result := '"';
end;

class function TSFStmtDBDialectConv.GetLikeWildcardSingle: String;
begin
  Result := '_';
end;

class function TSFStmtDBDialectConv.GetLikeWildcardMany: String;
begin
  Result := '%';
end;

class function TSFStmtDBDialectConv.SupportsLikeEscape: Boolean;
begin
  Result := True;
end;

// ===========================================================================//
//                           TSFStmtDBDialectConvOra                          //
// ===========================================================================//

function TSFStmtDBDialectConvOra.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  lDateVal := VarToDateTime(pValue);
  lDateStrVal := DateToFormattedString(lDateVal);
  if (HasTimePart(lDateVal)) and (MilliSecondOf(GetTimePart(lDateVal)) > 0) then
  begin
    if (HasDatePart(lDateVal)) then
      lDateStrVal := 'TO_TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + ', ''YYYY-MM-DD HH24:MI:SS.FF3'')'
    else
      lDateStrVal := 'TO_TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + ', ''HH24:MI:SS.FF3'')'
  end else
  begin
    if (HasDatePart(lDateVal)) then
    begin
      if (HasTimePart(lDateVal)) then
        lDateStrVal := 'TO_DATE(' + AnsiQuotedStr(lDateStrVal, '''') + ', ''YYYY-MM-DD HH24:MI:SS'')'
      else
        lDateStrVal := 'TO_DATE(' + AnsiQuotedStr(lDateStrVal, '''') + ', ''YYYY-MM-DD'')';
    end
    else if (HasTimePart(lDateVal)) then
      lDateStrVal := 'TO_TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + ', ''HH24:MI:SS'')';
  end;

  Result := lDateStrVal;
end;

function TSFStmtDBDialectConvOra.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';

  if (pSeqName = '') then
    Exit;

  Stmt.Reset;

  Stmt.SetBaseTable(GetDummyTableName, '', '', '');
  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic(Stmt.GetQuotedIdentifier(pSeqName) + '.nextval');

  Result := Stmt.GetSelectStmt;
end;

function TSFStmtDBDialectConvOra.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

class function TSFStmtDBDialectConvOra.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := GetDummyTableName;
end;

class function TSFStmtDBDialectConvOra.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvOra.GetDummyTableName: String;
begin
  Result := 'DUAL';
end;

// ===========================================================================//
//                           TSFStmtDBDialectConvDB2                          //
// ===========================================================================//

function TSFStmtDBDialectConvDB2.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  lDateVal := VarToDateTime(pValue);
  lDateStrVal := DateToFormattedString(lDateVal, False, '-', '.');
  if (HasTimePart(lDateVal)) and (MilliSecondOf(GetTimePart(lDateVal)) > 0) then
    lDateStrVal := 'TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + StringOfChar('0', 6) + ')'
  else
  begin
    if (HasDatePart(lDateVal)) then
    begin
      if (HasTimePart(lDateVal)) then
        lDateStrVal := 'TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + ')'
      else
        lDateStrVal := 'DATE(' + AnsiQuotedStr(lDateStrVal, '''') + ')';
    end
    else if (HasTimePart(lDateVal)) then
      lDateStrVal := 'TIME(' + AnsiQuotedStr(lDateStrVal, '''') + ')';
  end;

  Result := lDateStrVal;
end;

function TSFStmtDBDialectConvDB2.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';

  if (pSeqName = '') then
    Exit;

  Stmt.Reset;

  Stmt.SetBaseTable(GetDummyTableName, '', '', '');
  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic(Stmt.GetQuotedIdentifier(pSeqName) + '.NEXTVAL');

  Result := Stmt.GetSelectStmt;
end;

function TSFStmtDBDialectConvDB2.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Stmt.Reset;

  Stmt.SetBaseTable(GetDummyTableName, '', '', '');
  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('IDENTITY_VAL_LOCAL()');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvDB2.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := GetDummyTableName;
end;

class function TSFStmtDBDialectConvDB2.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvDB2.GetDummyTableName: String;
begin
  Result := 'SYSIBM.SYSDUMMY1';
end;

// ===========================================================================//
//                           TSFStmtDBDialectConvIfx                          //
// ===========================================================================//

function TSFStmtDBDialectConvIfx.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  lDateVal := VarToDateTime(pValue);
  lDateStrVal := DateToFormattedString(lDateVal);
  if (HasTimePart(lDateVal)) and (MilliSecondOf(GetTimePart(lDateVal)) > 0) then
  begin
    if (HasDatePart(lDateVal)) then
      lDateStrVal := 'DATETIME(' + lDateStrVal + ') YEAR TO FRACTION'
    else
      lDateStrVal := 'DATETIME(' + lDateStrVal + ') HOUR TO FRACTION';
  end else
  begin
    if (HasDatePart(lDateVal)) then
    begin
      if (HasTimePart(lDateVal)) then
        lDateStrVal := 'DATETIME(' + lDateStrVal + ') YEAR TO SECOND'
      else
        lDateStrVal := 'DATETIME(' + lDateStrVal + ') YEAR TO DAY';
    end
    else if (HasTimePart(lDateVal)) then
      lDateStrVal := 'DATETIME(' + lDateStrVal + ') HOUR TO SECOND';
  end;

  Result := lDateStrVal;
end;

function TSFStmtDBDialectConvIfx.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

function TSFStmtDBDialectConvIfx.GetLastAutoValue(pSeqName: String = ''): String;
  var lStmtSerial, lStmtSerial8, lStmtBigSerial: TSFStmt;
begin
  Stmt.Reset;

  lStmtSerial := TSFStmt.Create(nil);
  lStmtSerial.SetBaseTable(GetDummyTableName, '', '', 't1a');
  with lStmtSerial.AddStmtAttr('num', False) do
    AddItemDynamic('DBINFO(''sqlca.sqlerrd1'')');

  lStmtSerial8 := TSFStmt.Create(nil);
  lStmtSerial8.SetBaseTable(GetDummyTableName, '', '', 't1b');
  with lStmtSerial8.AddStmtAttr('num', False) do
    AddItemDynamic('DBINFO(''serial8'')');

  lStmtBigSerial := TSFStmt.Create(nil);
  lStmtBigSerial.SetBaseTable(GetDummyTableName, '', '', 't1c');
  with lStmtBigSerial.AddStmtAttr('num', False) do
    AddItemDynamic('DBINFO(''bigserial'')');

  lStmtSerial8.SetUnion(lStmtBigSerial);
  lStmtSerial.SetUnion(lStmtSerial8);

  Stmt.SetBaseTable(lStmtSerial, 't1');
  Stmt.SetStmtAggr('Max', 'num', 'LastID', 't1');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvIfx.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := GetDummyTableName;
end;

class function TSFStmtDBDialectConvIfx.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvIfx.GetDummyTableName: String;
begin
  Result := 'sysmaster:sysdual';
end;

// ===========================================================================//
//                           TSFStmtDBDialectConvAcc                          //
// ===========================================================================//

function TSFStmtDBDialectConvAcc.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  lDateVal := VarToDateTime(pValue);
  lDateStrVal := DateToFormattedString(lDateVal);
  Result := 'CDATE(' + AnsiQuotedStr(lDateStrVal, '''') + ')';
end;

class function TSFStmtDBDialectConvAcc.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := '';
end;

class function TSFStmtDBDialectConvAcc.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvAcc.GetNeedTableOnSubInFrom: Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvAcc.GetStartQuote: String;
begin
  Result := '[';
end;

class function TSFStmtDBDialectConvAcc.GetEndQuote: String;
begin
  Result := ']';
end;

class function TSFStmtDBDialectConvAcc.GetLikeWildcardSingle: String;
begin
  // wildcards (single) for Access ANSI89 = ?, ANSI92 = _
  // it seems, all dataacess-components works with ANSI92 (SQL Server compatible)
  // Result := '?';
  Result := inherited GetLikeWildcardSingle;
end;

class function TSFStmtDBDialectConvAcc.GetLikeWildcardMany: String;
begin
  // wildcards (many) for Access ANSI89 = *, ANSI92 = %
  // it seems, all dataacess-components works with ANSI92 (SQL Server compatible)
  // Result := '*';
  Result := inherited GetLikeWildcardMany;
end;

class function TSFStmtDBDialectConvAcc.SupportsLikeEscape: Boolean;
begin
  Result := False;
end;

// ===========================================================================//
//                          TSFStmtDBDialectConvFBIB                          //
// ===========================================================================//

function TSFStmtDBDialectConvFBIB.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  lDateVal := VarToDateTime(pValue);
  lDateStrVal := DateToFormattedString(lDateVal);
  if (HasTimePart(lDateVal)) and (MilliSecondOf(GetTimePart(lDateVal)) > 0) then
    lDateStrVal := lDateStrVal + '0';

  if (pExplicitCast) then
  begin
    if (HasTimePart(lDateVal)) and (HasDatePart(lDateVal)) then
      lDateStrVal := 'CAST(' + AnsiQuotedStr(lDateStrVal, '''') + ' as TIMESTAMP)'
    else
    begin
      if (HasDatePart(lDateVal)) then
        lDateStrVal := 'CAST(' + AnsiQuotedStr(lDateStrVal, '''') + ' as DATE)'
      else if (HasTimePart(lDateVal)) then
        lDateStrVal := 'CAST(' + AnsiQuotedStr(lDateStrVal, '''') + ' as TIME)';
    end;

    Result := lDateStrVal;
  end else
    Result := AnsiQuotedStr(lDateStrVal, '''');
end;

function TSFStmtDBDialectConvFBIB.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';

  if (pSeqName = '') then
    Exit;

  Stmt.Reset;

  Stmt.SetBaseTable(GetDummyTableName, '', '', '');
  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('gen_id(' + Stmt.GetQuotedIdentifier(pSeqName) + ', 1)');

  Result := Stmt.GetSelectStmt;
end;

function TSFStmtDBDialectConvFBIB.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Result := '';

  if (pSeqName = '') then
    Exit;

  Stmt.Reset;

  Stmt.SetBaseTable(GetDummyTableName, '', '', '');
  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('gen_id(' + Stmt.GetQuotedIdentifier(pSeqName) + ', 0)');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvFBIB.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := GetDummyTableName;
end;

class function TSFStmtDBDialectConvFBIB.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := (pDBDialect = stmtDBFB);
end;

class function TSFStmtDBDialectConvFBIB.GetDummyTableName: String;
begin
  Result := 'RDB$DATABASE';
end;

// ===========================================================================//
//                         TSFStmtDBDialectConvSQLite                         //
// ===========================================================================//

function TSFStmtDBDialectConvSQLite.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  if not(pExplicitCast) then
    Result := inherited ConvertDateValue(pValue, pExplicitCast)
  else
  begin
    lDateVal := VarToDateTime(pValue);
    lDateStrVal := DateToFormattedString(lDateVal);
    if (HasTimePart(lDateVal)) and (HasDatePart(lDateVal)) then
      lDateStrVal := 'datetime(' + AnsiQuotedStr(lDateStrVal, '''') + ')'
    else
    begin
      if (HasDatePart(lDateVal)) then
        lDateStrVal := 'date(' + AnsiQuotedStr(lDateStrVal, '''') + ')'
      else if (HasTimePart(lDateVal)) then
        lDateStrVal := 'time(' + AnsiQuotedStr(lDateStrVal, '''') + ')';
    end;

    Result := lDateStrVal;
  end;
end;

function TSFStmtDBDialectConvSQLite.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

function TSFStmtDBDialectConvSQLite.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Result := '';

  // seqname should be tablename
  if (pSeqName = '') then
    Exit;

  Stmt.Reset;

  Stmt.SetBaseTable('sqlite_sequence', '', '', '');
  Stmt.SetStmtAttr('seq', '', 'sqlite_sequence', False);
  Stmt.SetStmtAttr('name', '', 'sqlite_sequence', True);
  Stmt.AddConditionVal('sqlite_sequence', 'name', SFSTMT_OP_EQUAL, pSeqName);

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvSQLite.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := '';
end;

class function TSFStmtDBDialectConvSQLite.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

// ===========================================================================//
//                           TSFStmtDBDialectConvPG                           //
// ===========================================================================//

function TSFStmtDBDialectConvPG.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal, lFormatMask: String;
begin
  if not(pExplicitCast) then
    Result := inherited ConvertDateValue(pValue, pExplicitCast)
  else
  begin
    lDateVal := VarToDateTime(pValue);
    lDateStrVal := DateToFormattedString(lDateVal);
    lFormatMask := '';
    if (HasDatePart(lDateVal)) then
      lFormatMask := 'YYYY-MM-DD';

    if (HasTimePart(lDateVal)) then
    begin
      if (lFormatMask <> '') then
        lFormatMask := lFormatMask + ' ';
      lFormatMask := 'HH24:MM:SS';
      if (MilliSecondOf(GetTimePart(lDateVal)) > 0) then
        lFormatMask := lFormatMask + '.MS';
    end;

    Result := 'to_date(' + AnsiQuotedStr(lDateStrVal, '''') + ', ' + AnsiQuotedStr(lFormatMask, '''') + ')';
  end;
end;

function TSFStmtDBDialectConvPG.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

function TSFStmtDBDialectConvPG.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Stmt.Reset;

  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('LASTVAL()');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvPG.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := '';
end;

class function TSFStmtDBDialectConvPG.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

// ===========================================================================//
//                         TSFStmtDBDialectConvMySQL                          //
// ===========================================================================//

function TSFStmtDBDialectConvMySQL.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  if not(pExplicitCast) then
    Result := inherited ConvertDateValue(pValue, pExplicitCast)
  else
  begin
    lDateVal := VarToDateTime(pValue);
    lDateStrVal := DateToFormattedString(lDateVal);
    if (HasTimePart(lDateVal)) and (HasDatePart(lDateVal)) then
      lDateStrVal := 'TIMESTAMP(' + AnsiQuotedStr(lDateStrVal, '''') + ')'
    else
    begin
      if (HasDatePart(lDateVal)) then
        lDateStrVal := 'DATE(' + AnsiQuotedStr(lDateStrVal, '''') + ')'
      else if (HasTimePart(lDateVal)) then
        lDateStrVal := 'TIME(' + AnsiQuotedStr(lDateStrVal, '''') + ')';
    end;

    Result := lDateStrVal;
  end;
end;

function TSFStmtDBDialectConvMySQL.GetNextAutoValue(pSeqName: String = ''): String;
begin
  Result := '';
end;

function TSFStmtDBDialectConvMySQL.GetLastAutoValue(pSeqName: String = ''): String;
begin
  Stmt.Reset;

  with Stmt.AddStmtAttr('', False) do
    AddItemDynamic('LAST_INSERT_ID()');

  Result := Stmt.GetSelectStmt;
end;

class function TSFStmtDBDialectConvMySQL.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := '';
end;

class function TSFStmtDBDialectConvMySQL.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvMySQL.GetStartQuote: String;
begin
  Result := '`';
end;

class function TSFStmtDBDialectConvMySQL.GetEndQuote: String;
begin
  Result := '`';
end;

// ===========================================================================//
//                         TSFStmtDBDialectConvMSSQL                          //
// ===========================================================================//

function TSFStmtDBDialectConvMSSQL.ConvertDateValue(pValue: Variant; pExplicitCast: Boolean): String;
  var lDateVal: TDateTime;
      lDateStrVal: String;
begin
  if not(pExplicitCast) then
  begin
    Result := DateToFormattedString(pValue, False, '');
    Result := AnsiQuotedStr(Result, '''');
  end else
  begin
    lDateVal := VarToDateTime(pValue);
    lDateStrVal := DateToFormattedString(lDateVal, False, '');
    lDateStrVal := 'CAST(' + AnsiQuotedStr(lDateStrVal, '''') + ' as DATETIME)';
    Result := lDateStrVal;
  end;
end;

class function TSFStmtDBDialectConvMSSQL.GetCanSelectWithoutTable(var pTableName: String): Boolean;
begin
  Result := True;
  pTableName := '';
end;

class function TSFStmtDBDialectConvMSSQL.GetCanSelectInFrom(pDBDialect: TSFStmtDBDialect): Boolean;
begin
  Result := True;
end;

class function TSFStmtDBDialectConvMSSQL.GetStartQuote: String;
begin
  Result := '[';
end;

class function TSFStmtDBDialectConvMSSQL.GetEndQuote: String;
begin
  Result := ']';
end;

end.
