object FrmBDSDemoArticle: TFrmBDSDemoArticle
  Left = 0
  Top = 0
  Caption = 'Businessdata Demo - Articles'
  ClientHeight = 343
  ClientWidth = 523
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
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 344
    Height = 26
    Caption = 
      'To Insert/Append: Type data and change row (new row = arrow down' +
      ')'#13#10'To Delete: Press Ctrl+Del'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 40
    Width = 507
    Height = 249
    DataSource = SFBusinessDataWrapSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'bdsarticleid'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'bdsarticledesc'
        Title.Caption = 'Description'
        Width = 168
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bdsarticleprice'
        Title.Caption = 'Price'
        Width = 100
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 304
    Width = 250
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 265
    Top = 304
    Width = 250
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SFBusinessDataWrap1: TSFBusinessDataWrap
    BusinessClassName = 'bdsarticle'
    BusinessDataSet.Name = 'TSFBusinessData'
    BusinessDataSet.CachedUpdates = False
    BusinessDataSet.FormatOptions.QuoteType = stmtQuoteTypeAuto
    BusinessDataSet.ParentRelationDesigner.PassKeys = False
    BusinessDataSet.PassKeysOnCachedUpdates = False
    BusinessDataSet.RefreshMode = refreshModeRow
    BusinessDataSet.UpdateMode = upWhereKeyOnly
    BusinessDataSet.Stmt.XmlDefinition = 
      '<?xml version="1.0"?>'#13#10'<STATEMENTDEFINITION>'#13#10'  <UseDistinct>fal' +
      'se</UseDistinct>'#13#10'  <QuoteType>0</QuoteType>'#13#10'  <AutoEscapeLike>' +
      'true</AutoEscapeLike>'#13#10'  <DBDialect>0</DBDialect>'#13#10'  <LikeEscape' +
      'Char></LikeEscapeChar>'#13#10'  <TABLE>'#13#10'    <TableNo>1</TableNo>'#13#10'   ' +
      ' <TableAlias>t1</TableAlias>'#13#10'    <TableIsStmt>false</TableIsStm' +
      't>'#13#10'    <TableName>bdsarticle</TableName>'#13#10'    <Schema></Schema>' +
      #13#10'    <Catalog></Catalog>'#13#10'  </TABLE>'#13#10'</STATEMENTDEFINITION>'#13#10
    BusinessDataSet.StmtParamValues = <>
    BusinessDataSet.AfterPost = SFBusinessDataWrap1TSFBusinessDataAfterPost
    Left = 256
    Top = 40
  end
  object SFBusinessDataWrapSource1: TSFBusinessDataWrapSource
    BusinessDataWrapper = SFBusinessDataWrap1
    Left = 336
    Top = 48
  end
end
