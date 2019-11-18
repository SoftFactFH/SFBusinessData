//
//   Title:         SFStatementConst
//
//   Description:   constants for query builder
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFStatementConst;

interface

const
  // TSFStmtValueType
  STMTDEFDESC_VALTYPENUM      = 'Numeric';
  STMTDEFDESC_VALTYPEDATE     = 'Date';
  STMTDEFDESC_VALTYPETIME     = 'Time';
  STMTDEFDESC_VALTYPEDATETIME = 'DateTime';
  STMTDEFDESC_VALTYPEBOOL     = 'Boolean';
  STMTDEFDESC_VALTYPESTRING   = 'String';
  STMTDEFDESC_VALTYPEOTHER    = 'Other';

  // TSFStmtJoinType
  STMTDEFDESC_JOINTYPEINNER   = 'Inner';
  STMTDEFDESC_JOINTYPEOUTER   = 'Outer';
  STMTDEFDESC_JOINTYPEROUTER  = 'Right outer';
  STMTDEFDESC_JOINTYPENONE    = '';

  // TSFStmtJoinRelItemType
  STMTDEFDESC_RELITEMTYPEATTR = 'Attribute';
  STMTDEFDESC_RELITEMTYPEVAL  = 'Value';

  // TSFStmtAttrItemType
  STMTDEFDESC_ATTRITEMTYPEDBFIELD     = 'Databasefield';
  STMTDEFDESC_ATTRITEMTYPEVALUE       = 'Value';
  STMTDEFDESC_ATTRITEMTYPEPARAM       = 'Parameter';
  STMTDEFDESC_ATTRITEMTYPESTMT        = 'Statementreference';
  STMTDEFDESC_ATTRITEMTYPEAGGR        = 'Aggragatefunction';
  STMTDEFDESC_ATTRITEMTYPEOPPLUS      = 'Plusoperator';
  STMTDEFDESC_ATTRITEMTYPEOPMINUS     = 'Minusoperator';
  STMTDEFDESC_ATTRITEMTYPEOPMULITPLY  = 'Multiplyoperator';
  STMTDEFDESC_ATTRITEMTYPEOPDIVIDE    = 'Divideoperator';
  STMTDEFDESC_ATTRITEMTYPEOPEN        = 'Left parenthesis';
  STMTDEFDESC_ATTRITEMTYPECLOSE       = 'Right parenthesis';
  STMTDEFDESC_ATTRITEMTYPEDYN         = 'Free text';

  // TSFStmtConditionType
  STMTDEFDESC_CONDTYPEVALUE     = 'Value';
  STMTDEFDESC_CONDTYPEATTR      = 'Attribute';
  STMTDEFDESC_CONDTYPEOPEN      = 'Left parenthesis';
  STMTDEFDESC_CONDTYPECLOSE     = 'Right parenthesis';
  STMTDEFDESC_CONDTYPEAND       = 'AND';
  STMTDEFDESC_CONDTYPEOR        = 'OR';
  STMTDEFDESC_CONDTYPEISNULL    = 'IS NULL';
  STMTDEFDESC_CONDTYPEISNOTNULL = 'IS NOT NULL';
  STMTDEFDESC_CONDTYPEUNDEFINED = 'Exists/Not Exists';

  // TSFStmtSortType
  STMTDEFDESC_SORTTYPEASC   = 'Ascending';
  STMTDEFDESC_SORTTYPEDESC  = 'Descending';

  // TSFStmtDBDialect
  STMTDEFDESC_DIALECTDFLT   = 'Default';
  STMTDEFDESC_DIALECTORA    = 'Oracle';
  STMTDEFDESC_DIALECTDB2    = 'DB2';
  STMTDEFDESC_DIALECTIFX    = 'Informix';
  STMTDEFDESC_DIALECTACC    = 'MS Access';
  STMTDEFDESC_DIALECTIB     = 'Interbase';
  STMTDEFDESC_DIALECTFB     = 'Firebird';
  STMTDEFDESC_DIALECTSQLITE = 'SQLite';
  STMTDEFDESC_DIALECTPG     = 'Postgress';
  STMTDEFDESC_DIALECTMYSQL  = 'MySQL';
  STMTDEFDESC_DIALECTMSSQL  = 'MS SQL Server';
  STMTDEFDESC_DIALECTADV    = 'Advantage';
  STMTDEFDESC_DIALECTANY    = 'Anywhere';
  STMTDEFDESC_DIALECTDSYB   = 'Sybase';

  // TSFStmtQuoteType
  STMTDEFDESC_QUOTEAUTO = 'Auto';
  STMTDEFDESC_QUOTEALL  = 'All';
  STMTDEFDESC_QUOTENONE = 'None';

  // other resourcestrings
  STMTDESIGN_CONFIG     = 'Config/Define SQL-Query';

  // errors
  SFSTMTERRORMSG_REFSTMTNOTFOUND = 'Referenced Stmt %s not found';
  SFSTMTERRORMSG_STMTDEMOEXPIRED = 'your demo from TSFStmt is expired';

implementation

end.
