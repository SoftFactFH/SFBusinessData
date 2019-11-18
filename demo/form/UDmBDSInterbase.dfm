object DmBDSInterbase: TDmBDSInterbase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 303
  Width = 368
  object IBDatabase1: TIBDatabase
    DatabaseName = 
      '..\..\..\db\BDSDEMO.GD' +
      'B'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    ServerType = 'IBServer'
    Left = 64
    Top = 40
  end
  object IBTransaction1: TIBTransaction
    DefaultAction = TARollback
    AutoStopAction = saCommitRetaining
    Left = 168
    Top = 64
  end
  object SFConnector1: TSFConnector
    ConnectionType = ctInterbase
    Connection = IBDatabase1
    CommonConnector = True
    ConnectionDBType = dbtIB
    FormatOptions.DisplayFmtFloat = '#,##0.00 '#8364
    FormatOptions.EditFmtFloat = '#,##0.00'
    FormatOptions.QuoteType = stmtQuoteTypeAll
    Left = 96
    Top = 184
  end
end
