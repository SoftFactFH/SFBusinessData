object FrmSFStatementDefine: TFrmSFStatementDefine
  Left = 0
  Top = 0
  Caption = 'SQL Generator'
  ClientHeight = 526
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcFrmSFStatementDefineBase: TPageControl
    Left = 0
    Top = 0
    Width = 704
    Height = 526
    ActivePage = tsFrmStatementDefineGeneral
    Align = alClient
    TabOrder = 0
    OnChange = pcFrmSFStatementDefineBaseChange
    object tsFrmStatementDefineGeneral: TTabSheet
      Caption = 'General'
      object lblFrmStatementDefineGeneralDialect: TLabel
        Left = 10
        Top = 99
        Width = 36
        Height = 13
        Caption = 'Dialect:'
      end
      object lblFrmStatementDefineGeneralQuotes: TLabel
        Left = 10
        Top = 126
        Width = 39
        Height = 13
        Caption = 'Quotes:'
      end
      object lblFrmStatementDefineGeneralLikeEscape: TLabel
        Left = 10
        Top = 203
        Width = 79
        Height = 13
        Caption = 'LikeEscapeChar:'
      end
      object lblFrmStatementDefineGeneralNote: TLabel
        Left = 10
        Top = 16
        Width = 507
        Height = 13
        Caption = 
          'Note: Some options here (dialect, quotes), at runtime will be gi' +
          'ven by the referenced businessdata object'
      end
      object lblFrmStatementDefineGeneralUnion: TLabel
        Left = 10
        Top = 246
        Width = 31
        Height = 13
        Caption = 'Union:'
      end
      object cboFrmStatementDefineGeneralDialect: TDBLookupComboBox
        Left = 136
        Top = 96
        Width = 265
        Height = 21
        DataField = 'DBDialect'
        DataSource = srcFrmStatementDefineStmt
        KeyField = 'DId'
        ListField = 'DDesc'
        ListSource = srcFrmStatementDefineLkpDialect
        TabOrder = 1
      end
      object cboFrmStatementDefineGeneralQuotes: TDBLookupComboBox
        Left = 136
        Top = 123
        Width = 265
        Height = 21
        DataField = 'QuoteType'
        DataSource = srcFrmStatementDefineStmt
        KeyField = 'QTId'
        ListField = 'QTDesc'
        ListSource = srcFrmStatementDefineLkpQuotes
        TabOrder = 2
      end
      object txtFrmStatementDefineGeneralLikeEscape: TDBEdit
        Left = 136
        Top = 200
        Width = 33
        Height = 21
        DataField = 'LikeEscapeChar'
        DataSource = srcFrmStatementDefineStmt
        TabOrder = 4
      end
      object chkFrmStatementDefineGeneralAutoEscape: TDBCheckBox
        Left = 10
        Top = 172
        Width = 97
        Height = 17
        Caption = 'Autoescape Like'
        DataField = 'AutoEscapeLike'
        DataSource = srcFrmStatementDefineStmt
        TabOrder = 3
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object lblFrmStatementDefineGeneralDistinct: TDBCheckBox
        Left = 10
        Top = 67
        Width = 97
        Height = 17
        Caption = 'Use Distinct'
        DataField = 'UseDistinct'
        DataSource = srcFrmStatementDefineStmt
        TabOrder = 0
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object cboFrmStatementDefineGeneralUnion: TDBComboBox
        Left = 136
        Top = 243
        Width = 265
        Height = 22
        Style = csOwnerDrawVariable
        AutoComplete = False
        DataField = 'Union'
        DataSource = srcFrmStatementDefineStmt
        TabOrder = 5
      end
    end
    object tsFrmStatementDefineTable: TTabSheet
      Caption = 'Tables'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grpFrmStatementDefineTableStructure: TGroupBox
        Left = 0
        Top = 0
        Width = 696
        Height = 242
        Align = alClient
        Caption = 'Structure'
        TabOrder = 0
        object tvFrmStatementDefineTableStructure: TTreeView
          Left = 2
          Top = 15
          Width = 692
          Height = 225
          Margins.Left = 10
          Margins.Top = 5
          Margins.Right = 10
          Margins.Bottom = 5
          Align = alClient
          Indent = 19
          PopupMenu = pmFrmStatementDefineTableTree
          ReadOnly = True
          TabOrder = 0
          OnChange = tvFrmStatementDefineTableStructureChange
        end
      end
      object grpFrmStatementDefineTableDetail: TGroupBox
        Left = 0
        Top = 242
        Width = 696
        Height = 256
        Align = alBottom
        Caption = 'Details'
        TabOrder = 1
        DesignSize = (
          696
          256)
        object lblFrmStatementDefineTableDetailName: TLabel
          Left = 10
          Top = 46
          Width = 94
          Height = 13
          Caption = 'Name (Table/Stmt):'
        end
        object lblFrmStatementDefineTableDetailSchema: TLabel
          Left = 10
          Top = 73
          Width = 41
          Height = 13
          Caption = 'Schema:'
        end
        object lblFrmStatementDefineTableDetailCatalog: TLabel
          Left = 10
          Top = 100
          Width = 41
          Height = 13
          Caption = 'Catalog:'
        end
        object lblFrmStatementDefineTableDetailJoinType: TLabel
          Left = 10
          Top = 127
          Width = 45
          Height = 13
          Caption = 'Jointype:'
        end
        object grdFrmStatementDefineTableDetailJoinItems: TDBGrid
          Left = 10
          Top = 151
          Width = 676
          Height = 102
          Anchors = [akLeft, akTop, akRight]
          DataSource = srcFrmStatementDefineTableJoinDef
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
          PopupMenu = pmFrmStatementDefineData
          TabOrder = 6
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = grdFrmStatementDefineDataExit
          Columns = <
            item
              Expanded = False
              FieldName = 'SrcTypeDesc'
              Title.Caption = 'Soureitem Type'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SrcValue'
              Title.Caption = 'Sourceitem Value'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SrcValueTypeDesc'
              Title.Caption = 'Sourceitem Valuetype'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestTypeDesc'
              Title.Caption = 'Destitem Type'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestValue'
              Title.Caption = 'Destitem Value'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestValueTypeDesc'
              Title.Caption = 'Destitem Valuetype'
              Width = 110
              Visible = True
            end>
        end
        object txtFrmStatementDefineTableDetailName: TDBEdit
          Left = 152
          Top = 43
          Width = 241
          Height = 21
          DataField = 'TableName'
          DataSource = srcFrmStatementDefineTables
          TabOrder = 2
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
        object txtFrmStatementDefineTableDetailSchema: TDBEdit
          Left = 152
          Top = 70
          Width = 241
          Height = 21
          DataField = 'Schema'
          DataSource = srcFrmStatementDefineTables
          TabOrder = 3
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
        object txtFrmStatementDefineTableDetailCatalog: TDBEdit
          Left = 152
          Top = 97
          Width = 241
          Height = 21
          DataField = 'Catalog'
          DataSource = srcFrmStatementDefineTables
          TabOrder = 4
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
        object cboFrmStatementDefineTableDetailJoinType: TDBLookupComboBox
          Left = 152
          Top = 124
          Width = 241
          Height = 21
          DataField = 'ParentTableJoinType'
          DataSource = srcFrmStatementDefineTables
          KeyField = 'JTId'
          ListField = 'JTDesc'
          ListSource = srcFrmStatementDefineLkpJoinType
          TabOrder = 5
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
        object chkFrmStatementDefineTableDetailIsStmt: TDBCheckBox
          Left = 10
          Top = 20
          Width = 97
          Height = 17
          Caption = 'Is Statement'
          DataField = 'TableIsStmt'
          DataSource = srcFrmStatementDefineTables
          TabOrder = 0
          ValueChecked = '1'
          ValueUnchecked = '0'
          OnClick = chkFrmStatementDefineTableDetailIsStmtClick
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
        object cboFrmStatementDefineTableDetailStmt: TDBComboBox
          Left = 152
          Top = 42
          Width = 241
          Height = 22
          Style = csOwnerDrawVariable
          AutoComplete = False
          DataField = 'StmtName'
          DataSource = srcFrmStatementDefineTables
          TabOrder = 1
          Visible = False
          OnExit = ctrlFrmStatementDefineTableDetailExit
        end
      end
    end
    object tsFrmStatementDefineAttribute: TTabSheet
      Caption = 'Attributes'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdFrmStatementDefineAttributes: TDBGrid
        Left = 0
        Top = 0
        Width = 696
        Height = 298
        Align = alClient
        DataSource = srcFrmStatementDefineAttributes
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
        PopupMenu = pmFrmStatementDefineData
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = grdFrmStatementDefineDataExit
        Columns = <
          item
            Expanded = False
            FieldName = 'AttrName'
            Title.Caption = 'Alias'
            Width = 175
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AttrResultName'
            ReadOnly = True
            Title.Caption = 'Resultname'
            Width = 175
            Visible = True
          end
          item
            Alignment = taCenter
            ButtonStyle = cbsNone
            Expanded = False
            FieldName = 'OnlyForSearch'
            ReadOnly = True
            Title.Caption = 'Only for search'
            Width = 98
            Visible = True
          end>
      end
      object grpFrmStatementDefineAttrDetail: TGroupBox
        Left = 0
        Top = 298
        Width = 696
        Height = 200
        Align = alBottom
        Caption = 'Details'
        TabOrder = 1
        object grdFrmStatementDefineAttrDetail: TDBGrid
          Left = 2
          Top = 15
          Width = 692
          Height = 183
          Align = alClient
          DataSource = srcFrmStatementDefineAttributeItems
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
          PopupMenu = pmFrmStatementDefineData
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = grdFrmStatementDefineDataExit
          Columns = <
            item
              Expanded = False
              FieldName = 'ItemTypeDesc'
              Title.Caption = 'Itemtype'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AggrDesc'
              Title.Caption = 'Aggregate'
              Width = 55
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ItemRefTableNoDesc'
              Title.Caption = 'Table'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ItemRefTableField'
              Title.Caption = 'FieldName'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ItemRefStmtNameDesc'
              Title.Caption = 'Statement'
              Width = 135
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ItemRefOther'
              Title.Caption = 'Value'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ItemRefValueTypeDesc'
              Title.Caption = 'Valuetype'
              Width = 65
              Visible = True
            end>
        end
      end
    end
    object tsFrmStatementDefineCondition: TTabSheet
      Caption = 'Conditions'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblFrmStatementDefineConditionsInfo: TLabel
        Left = 0
        Top = 0
        Width = 696
        Height = 73
        Align = alTop
        AutoSize = False
        Caption = 
          'Note: Restricted conditions'#13#10'- are conditions which won'#39't remove' +
          'd on "ClearConditions"'#13#10'- are conditions which will added on a s' +
          'eparted container (therfore see restrictions separatly)'#13#10'- are s' +
          'trictly separated from regular conditions (you cannot concat wit' +
          'h regular conditions)'#13#10'- are conditions which will always concat' +
          'ed with a AND with the regular conditions (do not add a operator' +
          ' between)'
      end
      object grdFrmStatementDefineConditions: TDBGrid
        Left = 0
        Top = 73
        Width = 696
        Height = 225
        Align = alClient
        DataSource = srcFrmStatementDefineConditions
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
        PopupMenu = pmFrmStatementDefineData
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = grdFrmStatementDefineDataExit
        Columns = <
          item
            Expanded = False
            FieldName = 'CondTypeDesc'
            Title.Caption = 'Type'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AttrTempIdDesc'
            Title.Caption = 'Source/Attribute'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CondOperatorDesc'
            Title.Caption = 'Operator'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DestAttrTempIdDesc'
            Title.Caption = 'Destattribute'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DestValue'
            Title.Caption = 'Destvalue'
            Width = 80
            Visible = True
          end
          item
            Alignment = taCenter
            ButtonStyle = cbsNone
            Expanded = False
            FieldName = 'DestValueIsArray'
            ReadOnly = True
            Title.Caption = 'Destvalue is Array'
            Width = 95
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DestValueTypeDesc'
            Title.Caption = 'Destvaluetype'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ExistsDestRefStmtNameDesc'
            Title.Caption = 'Exists Stmt (Dest)'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ExistsTableAliasFromDesc'
            Title.Caption = 'Exists Sourcetable'
            Width = 95
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ExistsDestRefStmtTableAlias'
            Title.Caption = 'Exists Desttable (Alias)'
            Width = 120
            Visible = True
          end
          item
            Alignment = taCenter
            ButtonStyle = cbsNone
            Expanded = False
            FieldName = 'IsRestriction'
            ReadOnly = True
            Title.Caption = 'Restricted'
            Width = 60
            Visible = True
          end>
      end
      object grpFrmStatementDefineConditionsExists: TGroupBox
        Left = 0
        Top = 298
        Width = 696
        Height = 200
        Align = alBottom
        Caption = 'Exists relation'
        TabOrder = 1
        object grdFrmStatementDefineConditionsExists: TDBGrid
          Left = 2
          Top = 15
          Width = 692
          Height = 183
          Align = alClient
          DataSource = srcFrmStatementDefineConditionExists
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
          PopupMenu = pmFrmStatementDefineData
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = grdFrmStatementDefineDataExit
          Columns = <
            item
              Expanded = False
              FieldName = 'SrcTypeDesc'
              Title.Caption = 'Soureitem Type'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SrcValue'
              Title.Caption = 'Sourceitem Value'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SrcValueTypeDesc'
              Title.Caption = 'Sourceitem Valuetype'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestTypeDesc'
              Title.Caption = 'Destitem Type'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestValue'
              Title.Caption = 'Destitem Value'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DestValueTypeDesc'
              Title.Caption = 'Destitem Valuetype'
              Width = 110
              Visible = True
            end>
        end
      end
    end
    object tsFrmStatementDefineOrder: TTabSheet
      Caption = 'Order'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdFrmStatementDefineOrder: TDBGrid
        Left = 0
        Top = 0
        Width = 696
        Height = 498
        Align = alClient
        DataSource = srcFrmStatementDefineAttributesOrder
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
        PopupMenu = pmFrmStatementDefineData
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = grdFrmStatementDefineDataExit
        Columns = <
          item
            Expanded = False
            FieldName = 'AttrTempIdDesc'
            Title.Caption = 'Attribute'
            Width = 189
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SortTypeDesc'
            Title.Caption = 'Type'
            Width = 136
            Visible = True
          end>
      end
    end
    object tsFrmStatementDefineGroup: TTabSheet
      Caption = 'Group'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdFrmStatementDefineGroup: TDBGrid
        Left = 0
        Top = 0
        Width = 696
        Height = 498
        Align = alClient
        DataSource = srcFrmStatementDefineAttributesGroup
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
        PopupMenu = pmFrmStatementDefineData
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = grdFrmStatementDefineDataExit
        Columns = <
          item
            Expanded = False
            FieldName = 'AttrTempIdDesc'
            Title.Caption = 'Attribute'
            Width = 189
            Visible = True
          end>
      end
    end
    object tsFrmStatementDefineTest: TTabSheet
      Caption = 'Test'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object memFrmStatementDefineTest: TMemo
        Left = 0
        Top = 0
        Width = 696
        Height = 498
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object srcFrmStatementDefineStmt: TDataSource
    AutoEdit = False
    Left = 348
    Top = 65520
  end
  object srcFrmStatementDefineTables: TDataSource
    AutoEdit = False
    Left = 364
    Top = 65520
  end
  object srcFrmStatementDefineTableJoinDef: TDataSource
    AutoEdit = False
    Left = 380
    Top = 65520
  end
  object srcFrmStatementDefineAttributes: TDataSource
    AutoEdit = False
    Left = 396
    Top = 65520
  end
  object srcFrmStatementDefineAttributeItems: TDataSource
    AutoEdit = False
    Left = 412
    Top = 65520
  end
  object srcFrmStatementDefineConditions: TDataSource
    AutoEdit = False
    Left = 428
    Top = 65520
  end
  object srcFrmStatementDefineConditionExists: TDataSource
    AutoEdit = False
    Left = 444
    Top = 65520
  end
  object srcFrmStatementDefineAttributesOrder: TDataSource
    AutoEdit = False
    Left = 460
    Top = 65520
  end
  object srcFrmStatementDefineAttributesGroup: TDataSource
    AutoEdit = False
    Left = 476
    Top = 65520
  end
  object srcFrmStatementDefineLkpDialect: TDataSource
    Left = 484
    Top = 65520
  end
  object srcFrmStatementDefineLkpQuotes: TDataSource
    Left = 492
    Top = 65520
  end
  object srcFrmStatementDefineLkpJoinType: TDataSource
    Left = 516
    Top = 65520
  end
  object pmFrmStatementDefineTableTree: TPopupMenu
    OnPopup = pmFrmStatementDefineTableTreePopup
    Left = 564
    Top = 65520
    object pmFrmStatementDefineTableTreeAdd: TMenuItem
      Caption = 'Add'
      OnClick = pmFrmStatementDefineTableTreeAddClick
    end
    object pmFrmStatementDefineTableTreeDelete: TMenuItem
      Caption = 'Delete'
      OnClick = pmFrmStatementDefineTableTreeDeleteClick
    end
  end
  object pmFrmStatementDefineData: TPopupMenu
    OnPopup = pmFrmStatementDefineDataPopup
    Left = 580
    Top = 65520
    object pmFrmStatementDefineDataAdd: TMenuItem
      Caption = 'Add'
      OnClick = pmFrmStatementDefineDataAddClick
    end
    object pmFrmStatementDefineDataDelete: TMenuItem
      Caption = 'Delete'
      OnClick = pmFrmStatementDefineDataDeleteClick
    end
    object pmFrmStatementDefineDataCancel: TMenuItem
      Caption = 'Cancel'
      OnClick = pmFrmStatementDefineDataCancelClick
    end
    object pmFrmStatementDefineDataPost: TMenuItem
      Caption = 'Post'
      OnClick = pmFrmStatementDefineDataPostClick
    end
    object pmFrmStatementDefineDataUp: TMenuItem
      Caption = 'Up'
      OnClick = pmFrmStatementDefineDataUpClick
    end
    object pmFrmStatementDefineDataDown: TMenuItem
      Caption = 'Down'
      OnClick = pmFrmStatementDefineDataDownClick
    end
  end
end
