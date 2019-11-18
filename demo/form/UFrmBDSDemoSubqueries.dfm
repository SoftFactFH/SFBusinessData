object FrmBDSDemoSubqueries: TFrmBDSDemoSubqueries
  Left = 0
  Top = 0
  Caption = 'Subqueries Demo'
  ClientHeight = 490
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object memBDSDemoSubqueries: TMemo
    Left = 8
    Top = 39
    Width = 580
    Height = 228
    Lines.Strings = (
      '')
    ReadOnly = True
    TabOrder = 0
    WantTabs = True
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 312
    Width = 580
    Height = 170
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 8
    Top = 281
    Width = 580
    Height = 25
    Caption = 
      'Execute query (not supported in interbase, because interbase doe' +
      'sn'#39't support subselect in from-clause)'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 8
    Width = 580
    Height = 25
    Caption = 'Show query'
    TabOrder = 3
    OnClick = Button2Click
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = SFDataSet1
    Left = 88
    Top = 360
  end
  object SFDataSet1: TSFDataSet
    TableName = 'bdscstmr'
    Left = 144
    Top = 360
    Name = 'SFDataSet1'
    CachedUpdates = False
    FormatOptions.QuoteType = stmtQuoteTypeAuto
    ParentRelationDesigner.PassKeys = False
    PassKeysOnCachedUpdates = False
    RefreshMode = refreshModeRow
    UpdateMode = upWhereKeyOnly
    Stmt.XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmr</TableName>'#13#10'    <Schema></Schema>'#13#10 +
      '    <Catalog></Catalog>'#13#10'  </TABLE>'#13#10'</STATEMENTDEFINITION>'#13#10
    StmtParamValues = <>
  end
  object stmtOrderSum: TSFStmt
    Left = 240
    Top = 104
    XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmrorderpos</TableName>'#13#10'    <Schema></S' +
      'chema>'#13#10'    <Catalog></Catalog>'#13#10'    <TABLERELATIONS>'#13#10'      <TA' +
      'BLERELATION>'#13#10'        <JoinType>0</JoinType>'#13#10'        <RELATIONI' +
      'TEMS>'#13#10'          <RELATIONITEM>'#13#10'            <SrcType>0</SrcType' +
      '>'#13#10'            <SrcValue>bdscstmrorderposartid</SrcValue>'#13#10'     ' +
      '       <DestType>0</DestType>'#13#10'            <DestValue>bdsarticle' +
      'id</DestValue>'#13#10'          </RELATIONITEM>'#13#10'        </RELATIONITE' +
      'MS>'#13#10'        <TABLE>'#13#10'          <TableNo>2</TableNo>'#13#10'          ' +
      '<TableAlias>t2</TableAlias>'#13#10'          <TableIsStmt>false</Table' +
      'IsStmt>'#13#10'          <TableName>bdsarticle</TableName>'#13#10'          ' +
      '<Schema></Schema>'#13#10'          <Catalog></Catalog>'#13#10'        </TABL' +
      'E>'#13#10'      </TABLERELATION>'#13#10'    </TABLERELATIONS>'#13#10'  </TABLE>'#13#10' ' +
      ' <ATTRIBUTES>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'    ' +
      '  <AttrName></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSear' +
      'ch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          ' +
      '<Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <Item' +
      'RefTableAlias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableFie' +
      'ld>bdscstmrorderposorderid</ItemRefTableField>'#13#10'        </ATTRIB' +
      'UTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIB' +
      'UTE>'#13#10'      <AttrIdx>1</AttrIdx>'#13#10'      <AttrName>bdsordersum</A' +
      'ttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATT' +
      'RIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr>sum</Aggr' +
      '>'#13#10'          <ItemType>4</ItemType>'#13#10'        </ATTRIBUTEITEM>'#13#10' ' +
      '       <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <Item' +
      'Type>9</ItemType>'#13#10'        </ATTRIBUTEITEM>'#13#10'        <ATTRIBUTEI' +
      'TEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13 +
      #10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'          ' +
      '<ItemRefTableField>bdscstmrorderposquantity</ItemRefTableField>'#13 +
      #10'        </ATTRIBUTEITEM>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <A' +
      'ggr></Aggr>'#13#10'          <ItemType>7</ItemType>'#13#10'        </ATTRIBU' +
      'TEITEM>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'     ' +
      '     <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t2</It' +
      'emRefTableAlias>'#13#10'          <ItemRefTableField>bdsarticleprice</' +
      'ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'        <ATTRIBUTE' +
      'ITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>10</ItemType' +
      '>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTR' +
      'IBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <GROUPS>'#13#10'    <GROUP>'#13#10'      <AttrIdx' +
      '>0</AttrIdx>'#13#10'    </GROUP>'#13#10'  </GROUPS>'#13#10'</STATEMENTDEFINITION>'#13 +
      #10
  end
  object stmtCstmrSum: TSFStmt
    Left = 160
    Top = 104
    XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmr</TableName>'#13#10'    <Schema></Schema>'#13#10 +
      '    <Catalog></Catalog>'#13#10'    <TABLERELATIONS>'#13#10'      <TABLERELAT' +
      'ION>'#13#10'        <JoinType>0</JoinType>'#13#10'        <RELATIONITEMS>'#13#10' ' +
      '         <RELATIONITEM>'#13#10'            <SrcType>0</SrcType>'#13#10'     ' +
      '       <SrcValue>bdscstmrid</SrcValue>'#13#10'            <DestType>0<' +
      '/DestType>'#13#10'            <DestValue>bdscstmrordercstmrid</DestVal' +
      'ue>'#13#10'          </RELATIONITEM>'#13#10'        </RELATIONITEMS>'#13#10'      ' +
      '  <TABLE>'#13#10'          <TableNo>2</TableNo>'#13#10'          <TableAlias' +
      '>t2</TableAlias>'#13#10'          <TableIsStmt>false</TableIsStmt>'#13#10'  ' +
      '        <TableName>bdscstmrorder</TableName>'#13#10'          <Schema>' +
      '</Schema>'#13#10'          <Catalog></Catalog>'#13#10'          <TABLERELATI' +
      'ONS>'#13#10'            <TABLERELATION>'#13#10'              <JoinType>0</Jo' +
      'inType>'#13#10'              <RELATIONITEMS>'#13#10'                <RELATIO' +
      'NITEM>'#13#10'                  <SrcType>0</SrcType>'#13#10'                ' +
      '  <SrcValue>bdscstmrorderid</SrcValue>'#13#10'                  <DestT' +
      'ype>0</DestType>'#13#10'                  <DestValue>bdscstmrorderposo' +
      'rderid</DestValue>'#13#10'                </RELATIONITEM>'#13#10'           ' +
      '   </RELATIONITEMS>'#13#10'              <TABLE>'#13#10'                <Tab' +
      'leNo>3</TableNo>'#13#10'                <TableAlias>t3</TableAlias>'#13#10' ' +
      '               <TableIsStmt>true</TableIsStmt>'#13#10'                ' +
      '<StmtName>FrmBDSDemoSubqueries.stmtOrderSum</StmtName>'#13#10'        ' +
      '      </TABLE>'#13#10'            </TABLERELATION>'#13#10'          </TABLER' +
      'ELATIONS>'#13#10'        </TABLE>'#13#10'      </TABLERELATION>'#13#10'    </TABLE' +
      'RELATIONS>'#13#10'  </TABLE>'#13#10'  <ATTRIBUTES>'#13#10'    <ATTRIBUTE>'#13#10'      <' +
      'AttrIdx>0</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyFor' +
      'Search>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <A' +
      'TTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</I' +
      'temType>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10' ' +
      '         <ItemRefTableField>bdscstmrid</ItemRefTableField>'#13#10'    ' +
      '    </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13 +
      #10'    <ATTRIBUTE>'#13#10'      <AttrIdx>1</AttrIdx>'#13#10'      <AttrName>bd' +
      'scstmrsum</AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>' +
      #13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Ag' +
      'gr>sum</Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <Item' +
      'RefTableAlias>t3</ItemRefTableAlias>'#13#10'          <ItemRefTableFie' +
      'ld>bdsordersum</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'  ' +
      '    </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <GRO' +
      'UPS>'#13#10'    <GROUP>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'    </GROUP>'#13#10'  <' +
      '/GROUPS>'#13#10'</STATEMENTDEFINITION>'#13#10
  end
  object stmtExistsType: TSFStmt
    Left = 336
    Top = 104
    XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmrtype</TableName>'#13#10'    <Schema></Schem' +
      'a>'#13#10'    <Catalog></Catalog>'#13#10'  </TABLE>'#13#10'  <ATTRIBUTES>'#13#10'    <AT' +
      'TRIBUTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'      <AttrName></AttrName' +
      '>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEI' +
      'TEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'       ' +
      '   <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1</Item' +
      'RefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrtypeid</Ite' +
      'mRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEM' +
      'S>'#13#10'    </ATTRIBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <CONDITIONS>'#13#10'    <COND' +
      'ITION>'#13#10'      <IsRestriction>false</IsRestriction>'#13#10'      <CondT' +
      'ype>0</CondType>'#13#10'      <CondOperator>=</CondOperator>'#13#10'      <A' +
      'ttrIdx>0</AttrIdx>'#13#10'      <DestValue>2</DestValue>'#13#10'      <DestV' +
      'alueType>0</DestValueType>'#13#10'    </CONDITION>'#13#10'  </CONDITIONS>'#13#10'<' +
      '/STATEMENTDEFINITION>'#13#10
  end
  object stmtUnionNoCstmr: TSFStmt
    Left = 304
    Top = 48
    XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmr</TableName>'#13#10'    <Schema></Schema>'#13#10 +
      '    <Catalog></Catalog>'#13#10'  </TABLE>'#13#10'  <ATTRIBUTES>'#13#10'    <ATTRIB' +
      'UTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10' ' +
      '     <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS' +
      '>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <' +
      'ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1</ItemRefT' +
      'ableAlias>'#13#10'          <ItemRefTableField>bdscstmrid</ItemRefTabl' +
      'eField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    ' +
      '</ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>1</AttrIdx>'#13#10'     ' +
      ' <AttrName></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearc' +
      'h>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <' +
      'Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemR' +
      'efTableAlias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableFiel' +
      'd>bdscstmrname</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'  ' +
      '    </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      ' +
      '<AttrIdx>2</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyFo' +
      'rSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <' +
      'ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</' +
      'ItemType>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10 +
      '          <ItemRefTableField>bdscstmrfirstname</ItemRefTableFiel' +
      'd>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATT' +
      'RIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>3</AttrIdx>'#13#10'      <Att' +
      'rName></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10' ' +
      '     <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr>' +
      '</Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTab' +
      'leAlias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bds' +
      'cstmrdateofbirth</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10 +
      '      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'    ' +
      '  <AttrIdx>4</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <Only' +
      'ForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'       ' +
      ' <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0' +
      '</ItemType>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>' +
      #13#10'          <ItemRefTableField>bdscstmrpostcode</ItemRefTableFie' +
      'ld>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </AT' +
      'TRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>5</AttrIdx>'#13#10'      <At' +
      'trName></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10 +
      '      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr' +
      '></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTa' +
      'bleAlias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bd' +
      'scstmrcity</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      ' +
      '</ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <Att' +
      'rIdx>6</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSea' +
      'rch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTR' +
      'IBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</Item' +
      'Type>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'    ' +
      '      <ItemRefTableField>bdscstmrstreet</ItemRefTableField>'#13#10'   ' +
      '     </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>' +
      #13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>7</AttrIdx>'#13#10'      <AttrName>b' +
      'dscstmrstate</AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSear' +
      'ch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          ' +
      '<Aggr></Aggr>'#13#10'          <ItemType>1</ItemType>'#13#10'          <Item' +
      'RefOther>is no customer</ItemRefOther>'#13#10'          <ItemRefValueT' +
      'ype>5</ItemRefValueType>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTR' +
      'IBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>8' +
      '</AttrIdx>'#13#10'      <AttrName>bdscstmrsum</AttrName>'#13#10'      <OnlyF' +
      'orSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        ' +
      '<ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>1<' +
      '/ItemType>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10' ' +
      '   </ATTRIBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <CONDITIONS>'#13#10'    <CONDITION' +
      '>'#13#10'      <IsRestriction>false</IsRestriction>'#13#10'      <CondType>8' +
      '</CondType>'#13#10'      <CondOperator>NOT EXISTS</CondOperator>'#13#10'    ' +
      '  <ExistsTableAliasFrom>t1</ExistsTableAliasFrom>'#13#10'      <Exists' +
      'DestRefStmtName>FrmBDSDemoSubqueries.stmtExistsType</ExistsDestR' +
      'efStmtName>'#13#10'      <ExistsDestRefStmtTableAlias>t1</ExistsDestRe' +
      'fStmtTableAlias>'#13#10'      <RELATIONITEMS>'#13#10'        <RELATIONITEM>'#13 +
      #10'          <SrcType>0</SrcType>'#13#10'          <SrcValue>bdscstmrtyp' +
      'eid</SrcValue>'#13#10'          <DestType>0</DestType>'#13#10'          <Des' +
      'tValue>bdscstmrtypeid</DestValue>'#13#10'        </RELATIONITEM>'#13#10'    ' +
      '  </RELATIONITEMS>'#13#10'    </CONDITION>'#13#10'  </CONDITIONS>'#13#10'</STATEME' +
      'NTDEFINITION>'#13#10
  end
  object stmtCstmrMain: TSFStmt
    Left = 200
    Top = 48
    XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <Union>FrmBDSDemoSubqueries.stmtUnionN' +
      'oCstmr</Union>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'    <TableA' +
      'lias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStmt>'#13#10'    ' +
      '<TableName>bdscstmr</TableName>'#13#10'    <Schema></Schema>'#13#10'    <Cat' +
      'alog></Catalog>'#13#10'    <TABLERELATIONS>'#13#10'      <TABLERELATION>'#13#10'  ' +
      '      <JoinType>1</JoinType>'#13#10'        <RELATIONITEMS>'#13#10'         ' +
      ' <RELATIONITEM>'#13#10'            <SrcType>0</SrcType>'#13#10'            <' +
      'SrcValue>bdscstmrid</SrcValue>'#13#10'            <DestType>0</DestTyp' +
      'e>'#13#10'            <DestValue>bdscstmrid</DestValue>'#13#10'          </R' +
      'ELATIONITEM>'#13#10'        </RELATIONITEMS>'#13#10'        <TABLE>'#13#10'       ' +
      '   <TableNo>2</TableNo>'#13#10'          <TableAlias>t2</TableAlias>'#13#10 +
      '          <TableIsStmt>true</TableIsStmt>'#13#10'          <StmtName>F' +
      'rmBDSDemoSubqueries.stmtCstmrSum</StmtName>'#13#10'        </TABLE>'#13#10' ' +
      '     </TABLERELATION>'#13#10'    </TABLERELATIONS>'#13#10'  </TABLE>'#13#10'  <ATT' +
      'RIBUTES>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'      <At' +
      'trName></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10 +
      '      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr' +
      '></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTa' +
      'bleAlias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bd' +
      'scstmrid</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </' +
      'ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrI' +
      'dx>1</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearc' +
      'h>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIB' +
      'UTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemTy' +
      'pe>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'      ' +
      '    <ItemRefTableField>bdscstmrname</ItemRefTableField>'#13#10'       ' +
      ' </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'  ' +
      '  <ATTRIBUTE>'#13#10'      <AttrIdx>2</AttrIdx>'#13#10'      <AttrName></Att' +
      'rName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRI' +
      'BUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'  ' +
      '        <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1<' +
      '/ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrfirstn' +
      'ame</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRI' +
      'BUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>3<' +
      '/AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearch>fal' +
      'se</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEIT' +
      'EM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10 +
      '          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'          <' +
      'ItemRefTableField>bdscstmrdateofbirth</ItemRefTableField>'#13#10'     ' +
      '   </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10 +
      '    <ATTRIBUTE>'#13#10'      <AttrIdx>4</AttrIdx>'#13#10'      <AttrName></A' +
      'ttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATT' +
      'RIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10 +
      '          <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t' +
      '1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrpost' +
      'code</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTR' +
      'IBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>5' +
      '</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearch>fa' +
      'lse</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEI' +
      'TEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13 +
      #10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'          ' +
      '<ItemRefTableField>bdscstmrcity</ItemRefTableField>'#13#10'        </A' +
      'TTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <A' +
      'TTRIBUTE>'#13#10'      <AttrIdx>6</AttrIdx>'#13#10'      <AttrName></AttrNam' +
      'e>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTE' +
      'ITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'      ' +
      '    <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1</Ite' +
      'mRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrstreet</It' +
      'emRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITE' +
      'MS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>7</AttrId' +
      'x>'#13#10'      <AttrName>bdscstmrstate</AttrName>'#13#10'      <OnlyForSear' +
      'ch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRI' +
      'BUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>1</ItemT' +
      'ype>'#13#10'          <ItemRefOther>is a customer</ItemRefOther>'#13#10'    ' +
      '      <ItemRefValueType>5</ItemRefValueType>'#13#10'        </ATTRIBUT' +
      'EITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUT' +
      'E>'#13#10'      <AttrIdx>8</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'   ' +
      '   <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13 +
      #10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <It' +
      'emType>0</ItemType>'#13#10'          <ItemRefTableAlias>t2</ItemRefTab' +
      'leAlias>'#13#10'          <ItemRefTableField>bdscstmrsum</ItemRefTable' +
      'Field>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    <' +
      '/ATTRIBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <CONDITIONS>'#13#10'    <CONDITION>'#13#10' ' +
      '     <IsRestriction>false</IsRestriction>'#13#10'      <CondType>8</Co' +
      'ndType>'#13#10'      <CondOperator>EXISTS</CondOperator>'#13#10'      <Exist' +
      'sTableAliasFrom>t1</ExistsTableAliasFrom>'#13#10'      <ExistsDestRefS' +
      'tmtName>FrmBDSDemoSubqueries.stmtExistsType</ExistsDestRefStmtNa' +
      'me>'#13#10'      <ExistsDestRefStmtTableAlias>t1</ExistsDestRefStmtTab' +
      'leAlias>'#13#10'      <RELATIONITEMS>'#13#10'        <RELATIONITEM>'#13#10'       ' +
      '   <SrcType>0</SrcType>'#13#10'          <SrcValue>bdscstmrtypeid</Src' +
      'Value>'#13#10'          <DestType>0</DestType>'#13#10'          <DestValue>b' +
      'dscstmrtypeid</DestValue>'#13#10'        </RELATIONITEM>'#13#10'      </RELA' +
      'TIONITEMS>'#13#10'    </CONDITION>'#13#10'  </CONDITIONS>'#13#10'</STATEMENTDEFINI' +
      'TION>'#13#10
  end
end
