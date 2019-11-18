object FrmBDSDemoOrderPos: TFrmBDSDemoOrderPos
  Left = 0
  Top = 0
  Caption = 'Businessdata Demo - Orderdetails'
  ClientHeight = 294
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 24
    Top = 19
    Width = 50
    Height = 13
    Caption = 'Orderdate'
  end
  object Label3: TLabel
    Left = 25
    Top = 46
    Width = 44
    Height = 13
    Caption = 'Summary'
  end
  object Label11: TLabel
    Left = 24
    Top = 84
    Width = 211
    Height = 26
    Caption = 
      'To Insert/Append: Use button "Add article"'#13#10'To Delete: Press Ct' +
      'rl+Del'
  end
  object DBEdit1: TDBEdit
    Left = 112
    Top = 16
    Width = 121
    Height = 21
    DataField = 'bdscstmrorderdate'
    DataSource = srcOrder
    ReadOnly = True
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 112
    Top = 43
    Width = 121
    Height = 21
    DataField = 'bdscstmrordersum'
    DataSource = srcOrder
    ReadOnly = True
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 116
    Width = 448
    Height = 139
    DataSource = srcOrderPos
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'bdscstmrorderposid'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderposorderid'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderposartdesc'
        Title.Caption = 'Article'
        Width = 122
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderposprice'
        Title.Caption = 'Price'
        Width = 76
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderposquantity'
        Title.Caption = 'Quantity'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bdscstmrorderpossum'
        Title.Caption = 'Summary'
        Width = 83
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 25
    Top = 261
    Width = 447
    Height = 25
    Caption = 'Add article'
    TabOrder = 3
    OnClick = Button1Click
  end
  object srcOrder: TDataSource
    AutoEdit = False
    Left = 296
    Top = 24
  end
  object srcOrderPos: TDataSource
    Left = 368
    Top = 24
  end
end
