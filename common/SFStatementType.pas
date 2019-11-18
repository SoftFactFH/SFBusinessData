//
//   Title:         SFStatementType
//
//   Description:   types for query builder
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFStatementType;

interface

uses SFStatementConst, System.SysUtils;

type
  TSFStmtJoinType =
    (stmtJoinTypeInner,
      stmtJoinTypeOuter,
      stmtJoinTypeROuter,
      stmtJoinTypeNone);

  TSFStmtJoinRelItemType =
    (stmtJoinRelItemAttr,
      stmtJoinRelItemValue);

  TSFStmtJoinRelItem = record
    riSrcType: TSFStmtJoinRelItemType;
    riSrcValue: Variant;
    riDestType: TSFStmtJoinRelItemType;
    riDestValue: Variant;
  end;

  TSFStmtJoinRelItems = Array of TSFStmtJoinRelItem;

  TSFStmtAttrItemType =
    (stmtAttrItemTypeDbField,
      stmtAttrItemTypeValue,
      stmtAttrItemTypeParameter,
      stmtAttrItemTypeStmt,
      stmtAttrItemTypeAggrFunc,
      stmtAttrItemTypeOpPlus,
      stmtAttrItemTypeOpMinus,
      stmtAttrItemTypeOpMultiply,
      stmtAttrItemTypeOpDivide,
      stmtAttrItemTypeBracketOpen,
      stmtAttrItemTypeBracketClose,
      stmtAttrItemTypeDynamic);

  TSFStmtAttrItemOperatorType = stmtAttrItemTypeOpPlus..stmtAttrItemTypeOpDivide;
  TSFStmtAttrItemBracketType = stmtAttrItemTypeBracketOpen..stmtAttrItemTypeBracketClose;
  TSFStmtAttrItemValueType = stmtAttrItemTypeValue..stmtAttrItemTypeParameter;

  TSFStmtConditionType =
    (stmtCondTypeValue,
      stmtCondTypeAttribute,
      stmtCondTypeOpen,
      stmtCondTypeClose,
      stmtCondTypeAnd,
      stmtCondTypeOr,
      stmtCondTypeIsNull,
      stmtCondTypeIsNotNull,
      stmtCondTypeUndefined);

  TSFStmtValueType = (
    stmtValTypeNumeric,
    stmtValTypeDate,
    stmtValTypeTime,
    stmtValTypeDateTime,
    stmtValTypeBool,
    stmtValTypeString,
    stmtValTypeOther
  );

  TSFStmtSortType =
    (stmtSortTypeAsc,
      stmtSortTypeDesc);

  TSFStmtGenInfo =
    (stmtGenSelect,
      stmtGenFrom,
      stmtGenWhere,
      stmtGenGroup,
      stmtGenOrder);

  TSFStmtGenInfos = set of TSFStmtGenInfo;

  TSFStmtDBDialect =
    (stmtDBDDflt,
      stmtDBDOra,
      stmtDBDDB2,
      stmtDBDIfx,
      stmtDBDAcc,
      stmtDBIB,
      stmtDBFB,
      stmtDBDSQLite,
      stmtDBDPG,
      stmtDBDMySQL,
      stmtDBDMSSQL,
      stmtDBDAdvantage,
      stmtDBDAnywhere,
      stmtDBDSybase);

  TSFStmtTableSearchType =
    (stmtTableSearchAll,
      stmtTableSearchOnlyAlias,
      stmtTableSearchOnlyIdentifier,
      stmtTableSearchOnlyName);

  TSFStmtTableSingleSearchTypes = stmtTableSearchOnlyAlias..stmtTableSearchOnlyName;

  TSFStmtQuoteType = (
    stmtQuoteTypeAuto,
    stmtQuoteTypeAll,
    stmtQuoteTypeNone
  );

  TSFStmtTableIdent = record
    public
      tiTableName: String;
      tiSchemaName: String;
      tiCatalogName: String;
    public
      function GetTableIdent: String;
  end;

  TSFStmtError = (
    stmtErrRefStmtNotFound,
    stmtErrStmtDemoExpired
  );

  ESFStmtError = class(Exception);

  procedure SFStmtError(pMessage: TSFStmtError; const pArgs: array of const);
const
  STMTDEFDESC_VALTYPES: array[TSFStmtValueType] of String =
    (
      STMTDEFDESC_VALTYPENUM,
      STMTDEFDESC_VALTYPEDATE,
      STMTDEFDESC_VALTYPETIME,
      STMTDEFDESC_VALTYPEDATETIME,
      STMTDEFDESC_VALTYPEBOOL,
      STMTDEFDESC_VALTYPESTRING,
      STMTDEFDESC_VALTYPEOTHER
    );

  STMTDEFDESC_JOINTYPES: array[TSFStmtJoinType] of String =
    (
      STMTDEFDESC_JOINTYPEINNER,
      STMTDEFDESC_JOINTYPEOUTER,
      STMTDEFDESC_JOINTYPEROUTER,
      STMTDEFDESC_JOINTYPENONE
    );

  STMTDEFDESC_RELITEMTYPES: array[TSFStmtJoinRelItemType] of String =
    (
      STMTDEFDESC_RELITEMTYPEATTR,
      STMTDEFDESC_RELITEMTYPEVAL
    );

  STMTDEFDESC_ATTRITEMTYPES: array[TSFStmtAttrItemType] of String =
    (
      STMTDEFDESC_ATTRITEMTYPEDBFIELD,
      STMTDEFDESC_ATTRITEMTYPEVALUE,
      STMTDEFDESC_ATTRITEMTYPEPARAM,
      STMTDEFDESC_ATTRITEMTYPESTMT,
      STMTDEFDESC_ATTRITEMTYPEAGGR,
      STMTDEFDESC_ATTRITEMTYPEOPPLUS,
      STMTDEFDESC_ATTRITEMTYPEOPMINUS,
      STMTDEFDESC_ATTRITEMTYPEOPMULITPLY,
      STMTDEFDESC_ATTRITEMTYPEOPDIVIDE,
      STMTDEFDESC_ATTRITEMTYPEOPEN,
      STMTDEFDESC_ATTRITEMTYPECLOSE,
      STMTDEFDESC_ATTRITEMTYPEDYN
    );

  STMTDEFDESC_CONDTYPES: array[TSFStmtConditionType] of String =
    (
      STMTDEFDESC_CONDTYPEVALUE,
      STMTDEFDESC_CONDTYPEATTR,
      STMTDEFDESC_CONDTYPEOPEN,
      STMTDEFDESC_CONDTYPECLOSE,
      STMTDEFDESC_CONDTYPEAND,
      STMTDEFDESC_CONDTYPEOR,
      STMTDEFDESC_CONDTYPEISNULL,
      STMTDEFDESC_CONDTYPEISNOTNULL,
      STMTDEFDESC_CONDTYPEUNDEFINED
    );

  STMTDEFDESC_SORTTYPES: array[TSFStmtSortType] of String =
    (
      STMTDEFDESC_SORTTYPEASC,
      STMTDEFDESC_SORTTYPEDESC
    );

  STMTDEFDESC_DIALECTS: array[TSFStmtDBDialect] of String =
    (
      STMTDEFDESC_DIALECTDFLT,
      STMTDEFDESC_DIALECTORA,
      STMTDEFDESC_DIALECTDB2,
      STMTDEFDESC_DIALECTIFX,
      STMTDEFDESC_DIALECTACC,
      STMTDEFDESC_DIALECTIB,
      STMTDEFDESC_DIALECTFB,
      STMTDEFDESC_DIALECTSQLITE,
      STMTDEFDESC_DIALECTPG,
      STMTDEFDESC_DIALECTMYSQL,
      STMTDEFDESC_DIALECTMSSQL,
      STMTDEFDESC_DIALECTADV,
      STMTDEFDESC_DIALECTANY,
      STMTDEFDESC_DIALECTDSYB
    );

  STMTDEFDESC_QUOTES: array[TSFStmtQuoteType] of String =
    (
      STMTDEFDESC_QUOTEAUTO,
      STMTDEFDESC_QUOTEALL,
      STMTDEFDESC_QUOTENONE
    );

  // error-strings
  STMTERROR_MESSAGES: Array[TSFStmtError] of String = (
    SFSTMTERRORMSG_REFSTMTNOTFOUND,
    SFSTMTERRORMSG_STMTDEMOEXPIRED
  );

implementation

function TSFStmtTableIdent.GetTableIdent: String;
begin
  Result := tiTableName;
  if (tiSchemaName <> '') and (Result <> '') then
    Result := tiSchemaName + '.' + Result;
  if (tiCatalogName <> '') and (Result <> '') then
    Result := tiCatalogName + '.' + Result;
end;

procedure SFStmtError(pMessage: TSFStmtError; const pArgs: array of const);
begin
  raise ESFStmtError.Create(Format(STMTERROR_MESSAGES[pMessage], pArgs));
end;

end.
