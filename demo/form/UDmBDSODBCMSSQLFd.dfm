object DmBDSODBCMSSQLFd: TDmBDSODBCMSSQLFd
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 366
  Width = 445
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=bdsdemo'
      'User_Name=sa'
      'Password='
      'DataSource='
      'DriverID=ODBC')
    FormatOptions.AssignedValues = [fvFmtDisplayDate]
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 128
    Top = 144
  end
  object SFConnector1: TSFConnector
    ConnectionType = ctFireDac
    Connection = FDConnection1
    CommonConnector = True
    ConnectionDBType = dbtMSSQL
    FormatOptions.DisplayFmtFloat = '#,##0.00 '#8364
    FormatOptions.EditFmtFloat = '#,##0.00'
    FormatOptions.QuoteType = stmtQuoteTypeAuto
    Left = 200
    Top = 72
  end
end
