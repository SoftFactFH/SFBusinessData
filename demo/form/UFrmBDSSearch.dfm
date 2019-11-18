object FrmBDSSearch: TFrmBDSSearch
  Left = 0
  Top = 0
  Caption = 'Businessdata Demo - Search'
  ClientHeight = 326
  ClientWidth = 690
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
  object Label10: TLabel
    Left = 25
    Top = 231
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label8: TLabel
    Left = 259
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Notice'
  end
  object DBEdit1: TDBEdit
    Left = 112
    Top = 37
    Width = 121
    Height = 21
    DataField = 'bdscstmrid'
    DataSource = DataSource1
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 112
    Top = 64
    Width = 121
    Height = 21
    DataField = 'bdscstmrname'
    DataSource = DataSource1
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 112
    Top = 91
    Width = 121
    Height = 21
    DataField = 'bdscstmrfirstname'
    DataSource = DataSource1
    TabOrder = 2
  end
  object DBEdit4: TDBEdit
    Left = 112
    Top = 118
    Width = 121
    Height = 21
    DataField = 'bdscstmrdateofbirth'
    DataSource = DataSource1
    TabOrder = 3
  end
  object DBEdit5: TDBEdit
    Left = 112
    Top = 145
    Width = 121
    Height = 21
    DataField = 'bdscstmrstreet'
    DataSource = DataSource1
    TabOrder = 4
  end
  object DBEdit6: TDBEdit
    Left = 112
    Top = 172
    Width = 121
    Height = 21
    DataField = 'bdscstmrpostcode'
    DataSource = DataSource1
    TabOrder = 5
  end
  object DBEdit7: TDBEdit
    Left = 112
    Top = 199
    Width = 121
    Height = 21
    DataField = 'bdscstmrcity'
    DataSource = DataSource1
    TabOrder = 6
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 112
    Top = 226
    Width = 121
    Height = 21
    DataField = 'bdscstmrtypeid'
    DataSource = DataSource1
    KeyField = 'bdscstmrtypeid'
    ListField = 'bdscstmrtypedesc'
    ListSource = DataSource2
    TabOrder = 7
  end
  object DBMemo1: TDBMemo
    Left = 259
    Top = 64
    Width = 414
    Height = 183
    DataField = 'bdscstmrnotice'
    DataSource = DataSource1
    TabOrder = 8
  end
  object Button1: TButton
    Left = 24
    Top = 280
    Width = 310
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 363
    Top = 280
    Width = 310
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 10
    OnClick = Button2Click
  end
  object DataSource2: TDataSource
    AutoEdit = False
    DataSet = DsFrmBDSSearchType
    Left = 96
    Top = 65528
  end
  object DataSource1: TDataSource
    DataSet = DsFrmBDSSearchCache
    Left = 64
    Top = 65528
  end
  object DsFrmBDSSearchCache: TSFDataSet
    Left = 312
    Name = 'DsFrmBDSSearchCache'
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
      'Char></LikeEscapeChar>'#13#10'</STATEMENTDEFINITION>'#13#10
    StmtParamValues = <>
  end
  object DsFrmBDSSearchType: TSFDataSet
    TableName = 'bdscstmrtype'
    Left = 376
    Top = 8
    Name = 'DsFrmBDSSearchType'
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
    StmtParamValues = <>
  end
end
