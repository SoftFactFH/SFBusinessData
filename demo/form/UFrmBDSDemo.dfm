object FrmBDSDemo: TFrmBDSDemo
  Left = 0
  Top = 0
  Caption = 'Businessdata Demo - Main'
  ClientHeight = 648
  ClientWidth = 832
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 40
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 24
    Top = 67
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label3: TLabel
    Left = 25
    Top = 94
    Width = 47
    Height = 13
    Caption = 'Firstname'
  end
  object Label4: TLabel
    Left = 24
    Top = 121
    Width = 61
    Height = 13
    Caption = 'Date of birth'
  end
  object Label5: TLabel
    Left = 25
    Top = 148
    Width = 30
    Height = 13
    Caption = 'Street'
  end
  object Label6: TLabel
    Left = 24
    Top = 175
    Width = 44
    Height = 13
    Caption = 'Postcode'
  end
  object Label7: TLabel
    Left = 25
    Top = 202
    Width = 19
    Height = 13
    Caption = 'City'
  end
  object Label8: TLabel
    Left = 256
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Notice'
  end
  object Label9: TLabel
    Left = 25
    Top = 259
    Width = 79
    Height = 13
    Caption = 'Type (from Join)'
  end
  object Label10: TLabel
    Left = 25
    Top = 229
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label11: TLabel
    Left = 25
    Top = 352
    Width = 344
    Height = 26
    Caption = 
      'To Insert/Append: Type data and change row (new row = arrow down' +
      ')'#13#10'To Delete: Press Ctrl+Del'
  end
  object Label12: TLabel
    Left = 631
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Image'
  end
  object Label13: TLabel
    Left = 631
    Top = 59
    Width = 173
    Height = 218
    Alignment = taCenter
    AutoSize = False
    Caption = 'click to add image'
    Color = clWhite
    ParentColor = False
    Transparent = False
    Layout = tlCenter
    StyleElements = [seFont]
  end
  object Image1: TImage
    Left = 631
    Top = 59
    Width = 173
    Height = 218
    Cursor = crHandPoint
    Hint = 'click to add image'
    Center = True
    ParentShowHint = False
    Proportional = True
    ShowHint = True
    OnClick = Image1Click
  end
  object DBEdit1: TDBEdit
    Left = 112
    Top = 37
    Width = 121
    Height = 21
    DataField = 'bdscstmrid'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 112
    Top = 64
    Width = 121
    Height = 21
    DataField = 'Name'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 112
    Top = 91
    Width = 121
    Height = 21
    DataField = 'Firstname'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 2
  end
  object DBEdit4: TDBEdit
    Left = 112
    Top = 118
    Width = 121
    Height = 21
    DataField = 'bdscstmrdateofbirth'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 3
  end
  object DBEdit5: TDBEdit
    Left = 112
    Top = 145
    Width = 121
    Height = 21
    DataField = 'bdscstmrstreet'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 4
  end
  object DBEdit6: TDBEdit
    Left = 112
    Top = 172
    Width = 121
    Height = 21
    DataField = 'bdscstmrpostcode'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 5
  end
  object DBEdit7: TDBEdit
    Left = 112
    Top = 199
    Width = 121
    Height = 21
    DataField = 'bdscstmrcity'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 6
  end
  object DBEdit8: TDBEdit
    Left = 111
    Top = 256
    Width = 121
    Height = 21
    DataField = 'TypeDescJoin'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 8
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 112
    Top = 226
    Width = 121
    Height = 21
    DataField = 'bdscstmrtypeid'
    DataSource = srcFrmBDSDemoCstmr
    KeyField = 'bdscstmrtypeid'
    ListField = 'bdscstmrtypedesc'
    ListSource = srcFrmBDSDemoTypeLkp
    TabOrder = 7
  end
  object DBMemo1: TDBMemo
    Left = 256
    Top = 59
    Width = 369
    Height = 218
    DataField = 'bdscstmrnotice'
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 9
  end
  object DBGrid1: TDBGrid
    Left = 25
    Top = 384
    Width = 779
    Height = 188
    DataSource = srcFrmBDSDemoOrder
    TabOrder = 12
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'bdscstmrorderid'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'bdscstmrordercstmrid'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderdate'
        Title.Caption = 'Orderdate'
        Width = 142
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bdscstmrordersum'
        Title.Caption = 'Summary'
        Width = 111
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 24
    Top = 283
    Width = 780
    Height = 25
    DataSource = srcFrmBDSDemoCstmr
    TabOrder = 10
  end
  object Button1: TButton
    Left = 24
    Top = 585
    Width = 786
    Height = 25
    Caption = 'Orderdetails'
    TabOrder = 13
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 24
    Top = 314
    Width = 780
    Height = 25
    Caption = 'Search'
    TabOrder = 11
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 24
    Top = 616
    Width = 786
    Height = 25
    Caption = 'Show subquery demo'
    TabOrder = 14
    OnClick = Button2Click
  end
  object srcFrmBDSDemoTypeLkp: TDataSource
    AutoEdit = False
    DataSet = DsFrmBDSDemoTypeLkp
    Left = 400
  end
  object DsWFrmBDSDemoCstmr: TSFBusinessDataWrap
    BusinessClassName = 'bdscstmr'
    BusinessDataSet.Name = 'TSFBusinessData'
    BusinessDataSet.CachedUpdates = False
    BusinessDataSet.FormatOptions.QuoteType = stmtQuoteTypeAuto
    BusinessDataSet.ParentRelationDesigner.SrcAttrs = 'bdscstmrorderid'
    BusinessDataSet.ParentRelationDesigner.DestAttrs = 'bdscstmrorderid'
    BusinessDataSet.ParentRelationDesigner.PassKeys = False
    BusinessDataSet.PassKeysOnCachedUpdates = True
    BusinessDataSet.RefreshMode = refreshModeRow
    BusinessDataSet.UpdateMode = upWhereKeyOnly
    BusinessDataSet.Stmt.XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>0</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>8</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmr</TableName>'#13#10'    <Schema></Schema>'#13#10 +
      '    <Catalog></Catalog>'#13#10'    <TABLERELATIONS>'#13#10'      <TABLERELAT' +
      'ION>'#13#10'        <JoinType>1</JoinType>'#13#10'        <RELATIONITEMS>'#13#10' ' +
      '         <RELATIONITEM>'#13#10'            <SrcType>0</SrcType>'#13#10'     ' +
      '       <SrcValue>bdscstmrtypeid</SrcValue>'#13#10'            <DestTyp' +
      'e>0</DestType>'#13#10'            <DestValue>bdscstmrtypeid</DestValue' +
      '>'#13#10'          </RELATIONITEM>'#13#10'        </RELATIONITEMS>'#13#10'        ' +
      '<TABLE>'#13#10'          <TableNo>2</TableNo>'#13#10'          <TableAlias>t' +
      '2</TableAlias>'#13#10'          <TableIsStmt>false</TableIsStmt>'#13#10'    ' +
      '      <TableName>bdscstmrtype</TableName>'#13#10'          <Schema></S' +
      'chema>'#13#10'          <Catalog></Catalog>'#13#10'        </TABLE>'#13#10'      <' +
      '/TABLERELATION>'#13#10'    </TABLERELATIONS>'#13#10'  </TABLE>'#13#10'  <ATTRIBUTE' +
      'S>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'      <AttrName' +
      '></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      ' +
      '<ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Agg' +
      'r>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTableAli' +
      'as>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmr' +
      'id</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIB' +
      'UTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>1</' +
      'AttrIdx>'#13#10'      <AttrName>Name</AttrName>'#13#10'      <OnlyForSearch>' +
      'false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUT' +
      'EITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType' +
      '>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'        ' +
      '  <ItemRefTableField>bdscstmrname</ItemRefTableField>'#13#10'        <' +
      '/ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    ' +
      '<ATTRIBUTE>'#13#10'      <AttrIdx>2</AttrIdx>'#13#10'      <AttrName>Firstna' +
      'me</AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'     ' +
      ' <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Ag' +
      'gr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTableAl' +
      'ias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstm' +
      'rfirstname</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      ' +
      '</ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <Att' +
      'rIdx>3</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSea' +
      'rch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTR' +
      'IBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</Item' +
      'Type>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'    ' +
      '      <ItemRefTableField>bdscstmrdateofbirth</ItemRefTableField>' +
      #13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRI' +
      'BUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>4</AttrIdx>'#13#10'      <AttrN' +
      'ame></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'   ' +
      '   <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></' +
      'Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTable' +
      'Alias>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscs' +
      'tmrpostcode</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'     ' +
      ' </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <At' +
      'trIdx>5</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSe' +
      'arch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATT' +
      'RIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</Ite' +
      'mType>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'   ' +
      '       <ItemRefTableField>bdscstmrcity</ItemRefTableField>'#13#10'    ' +
      '    </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13 +
      #10'    <ATTRIBUTE>'#13#10'      <AttrIdx>6</AttrIdx>'#13#10'      <AttrName></' +
      'AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <AT' +
      'TRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13 +
      #10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>' +
      't1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrstr' +
      'eet</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRI' +
      'BUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>7<' +
      '/AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearch>fal' +
      'se</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEIT' +
      'EM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType>'#13#10 +
      '          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'          <' +
      'ItemRefTableField>bdscstmrtypeid</ItemRefTableField>'#13#10'        </' +
      'ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <' +
      'ATTRIBUTE>'#13#10'      <AttrIdx>8</AttrIdx>'#13#10'      <AttrName></AttrNa' +
      'me>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      <ATTRIBUT' +
      'EITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'     ' +
      '     <ItemType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1</It' +
      'emRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmrnotice</I' +
      'temRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEIT' +
      'EMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>9</AttrI' +
      'dx>'#13#10'      <AttrName>TypeDescJoin</AttrName>'#13#10'      <OnlyForSear' +
      'ch>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRI' +
      'BUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemT' +
      'ype>'#13#10'          <ItemRefTableAlias>t2</ItemRefTableAlias>'#13#10'     ' +
      '     <ItemRefTableField>bdscstmrtypedesc</ItemRefTableField>'#13#10'  ' +
      '      </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE' +
      '>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>10</AttrIdx>'#13#10'      <AttrName' +
      '></AttrName>'#13#10'      <OnlyForSearch>false</OnlyForSearch>'#13#10'      ' +
      '<ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></Agg' +
      'r>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTableAli' +
      'as>t1</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscstmr' +
      'image</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATT' +
      'RIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>' +
      '11</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearch>' +
      'false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUT' +
      'EITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemType' +
      '>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'        ' +
      '  <ItemRefTableField>bdscstmrimageext</ItemRefTableField>'#13#10'     ' +
      '   </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10 +
      '  </ATTRIBUTES>'#13#10'  <ORDERS>'#13#10'    <ORDER>'#13#10'      <AttrIdx>1</Attr' +
      'Idx>'#13#10'      <OrderType>0</OrderType>'#13#10'    </ORDER>'#13#10'    <ORDER>'#13 +
      #10'      <AttrIdx>2</AttrIdx>'#13#10'      <OrderType>0</OrderType>'#13#10'   ' +
      ' </ORDER>'#13#10'  </ORDERS>'#13#10'</STATEMENTDEFINITION>'#13#10
    BusinessDataSet.StmtParamValues = <>
    BusinessDataSet.OnFieldChange = DsWFrmBDSDemoCstmrTSFBusinessDataFieldChange
    BusinessDataSet.OnRecordChange = DsWFrmBDSDemoCstmrTSFBusinessDataRecordChange
    BusinessDataSet.AfterCancel = DsWFrmBDSDemoCstmrTSFBusinessDataAfterCancel
    BusinessDataSet.AfterClose = DsWFrmBDSDemoCstmrTSFBusinessDataRecordChange
    BusinessDataSet.AfterInsert = DsWFrmBDSDemoCstmrTSFBusinessDataAfterInsert
    BusinessDataSet.AfterPost = DsWFrmBDSDemoCstmrTSFBusinessDataAfterPost
    Left = 288
  end
  object DsFrmBDSDemoTypeLkp: TSFDataSet
    TableName = 'bdscstmrtype'
    Left = 424
    Name = 'DsFrmBDSDemoTypeLkp'
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
      't>'#13#10'    <TableName>bdscstmrtype</TableName>'#13#10'    <Schema></Schem' +
      'a>'#13#10'    <Catalog></Catalog>'#13#10'  </TABLE>'#13#10'</STATEMENTDEFINITION>'#13 +
      #10
    StmtParamValues = <
      item
        Name = 'PrmId'
        Value = Null
      end>
  end
  object srcFrmBDSDemoCstmr: TSFBusinessDataWrapSource
    BusinessDataWrapper = DsWFrmBDSDemoCstmr
    Left = 264
  end
  object DsWFrmBDSDemoOrder: TSFBusinessDataWrap
    BusinessClassName = 'bdscstmrorder'
    BusinessDataSet.Name = 'TSFBusinessData'
    BusinessDataSet.CachedUpdates = False
    BusinessDataSet.FormatOptions.QuoteType = stmtQuoteTypeAuto
    BusinessDataSet.ParentRelationDesigner.DestWrapper = DsWFrmBDSDemoCstmr
    BusinessDataSet.ParentRelationDesigner.SrcAttrs = 'bdscstmrordercstmrid'
    BusinessDataSet.ParentRelationDesigner.DestAttrs = 'bdscstmrid'
    BusinessDataSet.ParentRelationDesigner.PassKeys = True
    BusinessDataSet.PassKeysOnCachedUpdates = False
    BusinessDataSet.RefreshMode = refreshModeRow
    BusinessDataSet.UpdateMode = upWhereKeyOnly
    BusinessDataSet.Stmt.XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>2</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdscstmrorder</TableName>'#13#10'    <Schema></Sche' +
      'ma>'#13#10'    <Catalog></Catalog>'#13#10'    <TABLERELATIONS>'#13#10'      <TABLE' +
      'RELATION>'#13#10'        <JoinType>0</JoinType>'#13#10'        <RELATIONITEM' +
      'S>'#13#10'          <RELATIONITEM>'#13#10'            <SrcType>0</SrcType>'#13#10 +
      '            <SrcValue>bdscstmrordercstmrid</SrcValue>'#13#10'         ' +
      '   <DestType>0</DestType>'#13#10'            <DestValue>bdscstmrid</De' +
      'stValue>'#13#10'          </RELATIONITEM>'#13#10'        </RELATIONITEMS>'#13#10' ' +
      '       <TABLE>'#13#10'          <TableNo>2</TableNo>'#13#10'          <Table' +
      'Alias>t2</TableAlias>'#13#10'          <TableIsStmt>false</TableIsStmt' +
      '>'#13#10'          <TableName>bdscstmr</TableName>'#13#10'          <Schema>' +
      '</Schema>'#13#10'          <Catalog></Catalog>'#13#10'        </TABLE>'#13#10'    ' +
      '  </TABLERELATION>'#13#10'    </TABLERELATIONS>'#13#10'  </TABLE>'#13#10'  <ATTRIB' +
      'UTES>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrIdx>0</AttrIdx>'#13#10'      <AttrN' +
      'ame></AttrName>'#13#10'      <OnlyForSearch>true</OnlyForSearch>'#13#10'    ' +
      '  <ATTRIBUTEITEMS>'#13#10'        <ATTRIBUTEITEM>'#13#10'          <Aggr></A' +
      'ggr>'#13#10'          <ItemType>0</ItemType>'#13#10'          <ItemRefTableA' +
      'lias>t2</ItemRefTableAlias>'#13#10'          <ItemRefTableField>bdscst' +
      'mrtypeid</ItemRefTableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </' +
      'ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUTE>'#13#10'      <AttrI' +
      'dx>1</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'      <OnlyForSearc' +
      'h>false</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10'        <ATTRIB' +
      'UTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <ItemType>0</ItemTy' +
      'pe>'#13#10'          <ItemRefTableAlias>t1</ItemRefTableAlias>'#13#10'      ' +
      '    <ItemRefTableField>*</ItemRefTableField>'#13#10'        </ATTRIBUT' +
      'EITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10'    </ATTRIBUTE>'#13#10'    <ATTRIBUT' +
      'E>'#13#10'      <AttrIdx>2</AttrIdx>'#13#10'      <AttrName></AttrName>'#13#10'   ' +
      '   <OnlyForSearch>true</OnlyForSearch>'#13#10'      <ATTRIBUTEITEMS>'#13#10 +
      '        <ATTRIBUTEITEM>'#13#10'          <Aggr></Aggr>'#13#10'          <Ite' +
      'mType>0</ItemType>'#13#10'          <ItemRefTableAlias>t1</ItemRefTabl' +
      'eAlias>'#13#10'          <ItemRefTableField>bdscstmrorderdate</ItemRef' +
      'TableField>'#13#10'        </ATTRIBUTEITEM>'#13#10'      </ATTRIBUTEITEMS>'#13#10 +
      '    </ATTRIBUTE>'#13#10'  </ATTRIBUTES>'#13#10'  <CONDITIONS>'#13#10'    <CONDITIO' +
      'N>'#13#10'      <IsRestriction>true</IsRestriction>'#13#10'      <CondType>0' +
      '</CondType>'#13#10'      <CondOperator>=</CondOperator>'#13#10'      <AttrId' +
      'x>0</AttrIdx>'#13#10'      <DestValue>2</DestValue>'#13#10'      <DestValueT' +
      'ype>0</DestValueType>'#13#10'    </CONDITION>'#13#10'  </CONDITIONS>'#13#10'  <ORD' +
      'ERS>'#13#10'    <ORDER>'#13#10'      <AttrIdx>2</AttrIdx>'#13#10'      <OrderType>' +
      '1</OrderType>'#13#10'    </ORDER>'#13#10'  </ORDERS>'#13#10'</STATEMENTDEFINITION>' +
      #13#10
    BusinessDataSet.StmtParamValues = <>
    BusinessDataSet.OnCompareRecords = DsWFrmBDSDemoOrderTSFBusinessDataCompareRecords
    BusinessDataSet.AfterInsert = DsWFrmBDSDemoOrderTSFBusinessDataAfterInsert
    BusinessDataSet.BeforeInsert = DsWFrmBDSDemoOrderTSFBusinessDataBeforeInsert
    Left = 328
    Top = 424
  end
  object srcFrmBDSDemoOrder: TSFBusinessDataWrapSource
    BusinessDataWrapper = DsWFrmBDSDemoOrder
    Left = 360
    Top = 424
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All|*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.ico;*.emf;*.wm' +
      'f'
    Left = 584
    Top = 8
  end
end
