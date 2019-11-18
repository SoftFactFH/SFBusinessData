//
//   Title:         SFBusinessDataCommon
//
//   Description:   common definitions business datasets
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFBusinessDataCommon;

interface

uses
   System.Generics.Collections, System.Classes, System.SysUtils, SFBusinessDataConst,
   SFStatementType, System.MaskUtils;

type
  TSFBDSMessageProc = procedure(pSender: TObject; pMsgId, pMessageType: Word) of object;

  TSFBDSError = (
    bdsErrNotInsertEdit,
    bdsErrClassExists,
    bdsErrFullRefreshWithUpd,
    bdsErrNoWriteInMode,
    bdsErrMissingConnector,
    bdsErrNoSearchFields,
    bdsErrInvalidAutotype,
    bdsErrCachedUpdWhenEdit,
    bdsErrInvalidConnection,
    bdsErrCommonConnectorExists,
    bdsErrInvalidTransactionType,
    bdsErrConnectionMapExists,
    bdsErrConnectionTypeRequired,
    bdsErrNoTransactionForType,
    bdsErrTableRequired,
    bdsErrNameOnAutoGenParamVal,
    bdsErrBusinessDataDemoExpired
  );

  ESFBDSError = class(Exception);

  TSFBDSMessage = packed record
    MessageId: Word;
    MessageType: Word;
    MsgSender: TObject;
  end;

  TSFBDSQuoteType = TSFStmtQuoteType;
  TSFBDSQuoteTypeDflt = stmtQuoteTypeAuto..stmtQuoteTypeAuto;

  TSFBDSFormatOptions = class(TPersistent)
    private
      mDisplayFmtDateTime: String;
      mDisplayFmtDate: String;
      mDisplayFmtTime: String;
      mDisplayFmtFloat: String;
      mDisplayFmtCurrency: String;
      mEditMaskDateTime: TEditMask;
      mEditMaskDate: TEditMask;
      mEditMaskTime: TEditMask;
      mEditFmtFloat: String;
      mEditFmtCurrency: String;
      mQuoteType: TSFBDSQuoteType;
    public
      procedure Assign(pSource: TPersistent); override;
    published
      property DisplayFmtDateTime: String read mDisplayFmtDateTime write mDisplayFmtDateTime;
      property DisplayFmtDate: String read mDisplayFmtDate write mDisplayFmtDate;
      property DisplayFmtTime: String read mDisplayFmtTime write mDisplayFmtTime;
      property DisplayFmtFloat: String read mDisplayFmtFloat write mDisplayFmtFloat;
      property DisplayFmtCurrency: String read mDisplayFmtCurrency write mDisplayFmtCurrency;
      property EditMaskDateTime: TEditMask read mEditMaskDateTime write mEditMaskDateTime;
      property EditMaskDate: TEditMask read mEditMaskDate write mEditMaskDate;
      property EditMaskTime: TEditMask read mEditMaskTime write mEditMaskTime;
      property EditFmtFloat: String read mEditFmtFloat write mEditFmtFloat;
      property EditFmtCurrency: String read mEditFmtCurrency write mEditFmtCurrency;
      property QuoteType: TSFBDSQuoteType read mQuoteType write mQuoteType;
  end;

const
  // error-strings
  SFBDSErrorMessages: Array[TSFBDSError] of String = (
    SFBDSMSG_NOTININSERTEDIT,
    SFBDSMSG_CLASSEXISTS,
    SFBDSMSG_FULLREFRESHWITHUPD,
    SFBDSMSG_NOWRITEINMODE,
    SFBDSMSG_MISSINGCONNECTOR,
    SFBDSMSG_NOSEARCHFIELDS,
    SFBDSMSG_INVALIDAUTOTYPE,
    SFBDSMSG_CACHEDUPDWHENEDIT,
    SFBDSMSG_INVALIDCONNECTION,
    SFBDSMSG_COMMONCONNECTOR,
    SFBDSMSG_INVALIDTRANSTYPE,
    SFBDSMSG_CONNECTIONMAPEXISTS,
    SFBDSMSG_NOCONNECTIONTYPE,
    SFBDSMSG_NOTRANSACTIONFORTYPE,
    SFBDSMSG_TABLEREQUIRED,
    SFBDSMSG_NAMEONAUTOGENPRMVAL,
    SFBDSMSG_BUSINESSDATADEMOEXPIRED
  );

  // messageids
  SFBDSMSG_CONNECTORMESSAGE         = 1;

  // messagetypes
  SFBDSMSGTYPE_COMMONCONNCHANGED    = 1;
  SFBDSMSGTYPE_CONNTYPECHANGED      = 2;
  SFBDSMSGTYPE_CONNECTIONCHANGED    = 3;

  procedure SFBDSDataError(pMessage: TSFBDSError; const pArgs: array of const);
  // procedure SFBDSSendMsg(pSender, pDest: TObject; pMsgId, pMessageType: Word);

implementation

procedure SFBDSDataError(pMessage: TSFBDSError; const pArgs: array of const);
begin
  raise ESFBDSError.Create(Format(SFBDSErrorMessages[pMessage], pArgs));
end;

{
procedure SFBDSSendMsg(pSender, pDest: TObject; pMsgId, pMessageType: Word);
  var lMsg: TSFBDSMessage;
begin
  lMsg.MessageId := pMsgId;
  lMsg.MessageType := pMessageType;
  lMsg.MsgSender := pSender;

  pSender.Dispatch(lMsg);
end;
}

procedure TSFBDSFormatOptions.Assign(pSource: TPersistent);
begin
  if (pSource is TSFBDSFormatOptions) then
  begin
    DisplayFmtDateTime := TSFBDSFormatOptions(pSource).DisplayFmtDateTime;
    DisplayFmtDate := TSFBDSFormatOptions(pSource).DisplayFmtDate;
    DisplayFmtTime := TSFBDSFormatOptions(pSource).DisplayFmtTime;
    DisplayFmtFloat := TSFBDSFormatOptions(pSource).DisplayFmtFloat;
    DisplayFmtCurrency := TSFBDSFormatOptions(pSource).DisplayFmtCurrency;
    EditMaskDateTime := TSFBDSFormatOptions(pSource).EditMaskDateTime;
    EditMaskDate := TSFBDSFormatOptions(pSource).EditMaskDate;
    EditMaskTime := TSFBDSFormatOptions(pSource).EditMaskTime;
    EditFmtFloat := TSFBDSFormatOptions(pSource).EditFmtFloat;
    EditFmtCurrency := TSFBDSFormatOptions(pSource).EditFmtCurrency;
    QuoteType := TSFBDSFormatOptions(pSource).QuoteType;
  end else
    inherited;
end;

end.
