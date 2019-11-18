object DmBDSMsAccADO: TDmBDSMsAccADO
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 302
  Width = 386
  object ADOConnection1: TADOConnection
    Attributes = [xaCommitRetaining]
    CommandTimeout = 60
    ConnectionString = 
      'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=..\..\..\' +
      'db\bdsdemo.accdb;Persist Securi' +
      'ty Info=False;'
    LoginPrompt = False
    Provider = 'Microsoft.ACE.OLEDB.12.0'
    Left = 56
    Top = 80
  end
  object SFConnector1: TSFConnector
    ConnectionType = ctADO
    Connection = ADOConnection1
    CommonConnector = True
    ConnectionDBType = dbtMSAcc
    FormatOptions.DisplayFmtFloat = '#,##0.00 '#8364
    FormatOptions.EditFmtFloat = '#,##0.00'
    FormatOptions.QuoteType = stmtQuoteTypeAuto
    Left = 184
    Top = 128
  end
end
