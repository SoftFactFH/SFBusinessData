//
//   Title:         SFStatementReg
//
//   Description:   editors and registration for query builder
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFStatementReg;

interface

uses System.Classes, System.SysUtils, DesignEditors, DesignIntf;

type

  TStmtEditor = class(TComponentEditor)
    public
      procedure ExecuteVerb(Index: Integer); override;
      function GetVerb(Index: Integer): string; override;
      function GetVerbCount: Integer; override;
  end;

  procedure Register;

implementation

uses System.TypInfo, SFStatements, UFrmSFStatementDefine, SFStatementConst;

//============================================================================//
//                                TStmtEditor                                 //
//============================================================================//

function TStmtEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TStmtEditor.GetVerb(Index: Integer): string;
begin
  if (Index = 0) then
    Result := STMTDESIGN_CONFIG
  else
    Result := '';
end;

procedure TStmtEditor.ExecuteVerb(Index: Integer);
  var lStmt: TSFStmt;
      lFrmDefine: TFrmSFStatementDefine;
begin
  if (Index = 0) then
  begin
    lStmt := TSFStmt(GetComponent);
    lFrmDefine := TFrmSFStatementDefine.Create(nil);
    try
      lFrmDefine.Stmt := lStmt;
      lFrmDefine.CanModfiyBaseTable := True;
      lFrmDefine.ShowModal;
      lStmt.LoadFromXml(lFrmDefine.XmlDefinition, False);
    finally
      lFrmDefine.Free;
    end;

    Designer.Modified;
  end;
end;

//============================================================================//
//                              Register Editors                              //
//============================================================================//

procedure Register;
begin
  RegisterComponents('SFFH Data', [TSFStmt]);
  RegisterComponentEditor(TSFStmt, TStmtEditor);
end;

end.
