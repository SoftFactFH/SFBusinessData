unit BDSDemoCommon;

interface
  uses System.SysUtils, System.Classes, System.StrUtils;

  function GetLocalDateFormat: String;
  function GetDateEditMaskByFrmt(pFrmt: String): String;

implementation

function GetLocalDateFormat: String;
  var lFrmtSettings: TFormatSettings;
begin
  lFrmtSettings := TFormatSettings.Create;
  Result := lFrmtSettings.ShortDateFormat;
end;

function GetDateEditMaskByFrmt(pFrmt: String): String;
  var i: Integer;
      lChr: String;
      lFirstD, lFirstM: Boolean;
begin
  Result := '';

  if (pFrmt <> '') then
  begin
    Result := '!';
    lFirstD := True;
    lFirstM := True;
    for i := 1 to (Length(pFrmt)) do
    begin
      lChr := MidStr(pFrmt, i, 1);
      if (lChr = 'd') or (lChr = 'D') then
      begin
        if (lFirstD) then
          Result := Result + '9'
        else
          Result := Result + '0';
        lFirstD := False;
      end
      else if (lChr = 'm') or (lChr = 'M') then
      begin
        if (lFirstM) then
          Result := Result + '9'
        else
          Result := Result + '0';
        lFirstM := False;
      end
      else if (lChr = 'y') or (lChr = 'Y') then
        Result := Result + '0'
      else
        Result := Result + lChr;
    end;

    Result := Result + ';1; ';
  end;
end;

end.
