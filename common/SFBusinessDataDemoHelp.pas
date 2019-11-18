//
//   Title:         SFBusinessDataDemoHelp
//
//   Description:   helper class for manage demoversions
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFBusinessDataDemoHelp;

interface

uses System.Classes;

type
  TSFBDSDemoHelper = class(TObject)
  public
    class function IsDemo: Boolean;
    class function IsDemoExpired(pComponent: TComponent = nil): Boolean;
    class function ValidateDemo(pComponent: TComponent = nil): Boolean;
  end;

implementation

class function TSFBDSDemoHelper.IsDemo: Boolean;
begin
  Result := False;
end;

class function TSFBDSDemoHelper.IsDemoExpired(pComponent: TComponent = nil): Boolean;
begin
  Result := False;
end;

class function TSFBDSDemoHelper.ValidateDemo(pComponent: TComponent = nil): Boolean;
begin
  Result := True;

  if (IsDemo) then
    Result := not IsDemoExpired(pComponent);
end;

end.
