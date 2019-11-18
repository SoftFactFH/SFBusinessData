object DmBDSMySQLFd: TDmBDSMySQLFd
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 387
  Width = 477
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'Server=localhost'
      'Database=bdsdemo'
      'User_Name='
      'Password=')
    FormatOptions.AssignedValues = [fvFmtDisplayDate]
    LoginPrompt = False
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction2
    Left = 40
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Program Files\MySQL\MySQL Server 5.5\lib\libmysql32.dll'
    Left = 144
    Top = 16
  end
  object SFConnector1: TSFConnector
    ConnectionType = ctFireDac
    Connection = FDConnection1
    CommonConnector = True
    ConnectionDBType = dbtMySQL
    FormatOptions.DisplayFmtFloat = '#,##0.00 '#8364
    FormatOptions.EditFmtFloat = '#,##0.00'
    FormatOptions.QuoteType = stmtQuoteTypeAuto
    Left = 144
    Top = 104
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 341
    Top = 24
  end
  object FDTransaction2: TFDTransaction
    Connection = FDConnection1
    Left = 261
    Top = 24
  end
end
