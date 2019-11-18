object DmBDSMsAccFd: TDmBDSMsAccFd
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 281
  Width = 350
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=..\..\..\db\b' +
        'dsdemo.accdb'
      'StringFormat=ANSI'
      'DriverID=MSAcc')
    FormatOptions.AssignedValues = [fvFmtDisplayDate]
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object SFConnector1: TSFConnector
    ConnectionType = ctFireDac
    Connection = FDConnection1
    CommonConnector = True
    ConnectionDBType = dbtMSAcc
    FormatOptions.DisplayFmtFloat = '#,##0.00 '#8364
    FormatOptions.EditFmtFloat = '#,##0.00'
    FormatOptions.QuoteType = stmtQuoteTypeAuto
    Left = 144
    Top = 88
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 248
    Top = 48
  end
end
