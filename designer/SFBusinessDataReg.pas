//
//   Title:         SFBusinessDataReg
//
//   Description:   editors and registration for business dataset
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//
unit SFBusinessDataReg;

interface

uses System.Classes, System.SysUtils, DesignEditors, DesignIntf;

type

  TBDSClassNameEditor = class(TComponentProperty)
    public
      function GetValue: string; override;
  end;

  TBDSWrapperDataSourceEditor = class(TComponentProperty)
    public
      function GetAttributes: TPropertyAttributes; override;
      procedure Edit; override;
  end;

  TBDSDataRelDestObjEditor = class(TComponentProperty)
    public
      function GetAttributes: TPropertyAttributes; override;
  end;

  TBDSStmtProperty = class(TClassProperty)
    public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
  end;

  TBDSStmtEditor = class(TDefaultEditor)
    protected
      procedure EditProperty(const PropertyEditor: IProperty; var Continue: Boolean); override;
    public
      procedure ExecuteVerb(Index: Integer); override;
      function GetVerb(Index: Integer): string; override;
      function GetVerbCount: Integer; override;
  end;

  procedure Register;

implementation

uses System.TypInfo, SFBusinessData, SFStatements, UFrmSFStatementDefine, Data.DB,
     SFStatementConst, SFBusinessDataCommon, SFBusinessDataConnector;

//============================================================================//
//                          TBDSClassNameEditor                               //
//============================================================================//

function TBDSClassNameEditor.GetValue: string;
begin
  Result := '';
  if (GetOrdValue > 0)  then
    FmtStr(Result, '(%s)', [GetTypeName(GetPropType)]);
end;

//============================================================================//
//                      TBDSWrapperDataSourceEditor                           //
//============================================================================//

function TBDSWrapperDataSourceEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paReadOnly];
end;

procedure TBDSWrapperDataSourceEditor.Edit;
begin
  // nothing to do
end;

//============================================================================//
//                        TBDSDataRelDestObjEditor                            //
//============================================================================//

function TBDSDataRelDestObjEditor.GetAttributes: TPropertyAttributes;
  var lComponent: TComponent;
begin
  Result := inherited GetAttributes;

  lComponent := GetComponentReference;
  if (lComponent <> nil) and (csSubComponent in lComponent.ComponentStyle) then
    Result := Result - [paSubProperties];
end;

//============================================================================//
//                             TBDSStmtProperty                               //
//============================================================================//

procedure TBDSStmtProperty.Edit;
  var lStmt: TSFStmt;
      lFrmDefine: TFrmSFStatementDefine;
begin
  lStmt := TSFStmt(GetOrdValue);
  if not(Assigned(lStmt)) or not(Assigned(lStmt.BaseTable)) then
    SFBDSDataError(bdsErrTableRequired, []);

  lFrmDefine := TFrmSFStatementDefine.Create(nil);
  try
    lFrmDefine.Stmt := lStmt;
    lFrmDefine.CanModfiyBaseTable := False;
    lFrmDefine.ShowModal;
    lStmt.LoadFromXml(lFrmDefine.XmlDefinition, False);
  finally
    lFrmDefine.Free;
  end;

  if (lStmt.Owner is TSFBusinessData) then
    TSFBusinessData(lStmt.Owner).RefreshStmtParamValues;

  Designer.Modified;
end;

function TBDSStmtProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

//============================================================================//
//                              TBDSStmtEditor                                //
//============================================================================//

procedure TBDSStmtEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);
  var lPropName: string;
begin
  lPropName := PropertyEditor.GetName;
  if (CompareText(lPropName, 'STMT') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

function TBDSStmtEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TBDSStmtEditor.GetVerb(Index: Integer): string;
begin
  if (Index = 0) then
    Result := STMTDESIGN_CONFIG
  else
    Result := '';
end;

procedure TBDSStmtEditor.ExecuteVerb(Index: Integer);
begin
  if (Index = 0) then
    Edit;
end;

//============================================================================//
//                              Register Editors                              //
//============================================================================//

procedure Register;
begin
  RegisterComponents('SFFH Data', [TSFConnector, TSFBusinessDataWrap, TSFDataSet, TSFBusinessDataWrapSource]);

  RegisterComponentEditor(TSFBusinessData, TBDSStmtEditor);

  RegisterPropertyEditor(TypeInfo(TSFBusinessData), TSFBusinessDataWrap, 'BusinessDataSet', TBDSClassNameEditor);
  RegisterPropertyEditor(TypeInfo(TSFBusinessDataRelationDesigner), TSFBusinessData, 'ParentRelationDesigner', TBDSClassNameEditor);
  RegisterPropertyEditor(TypeInfo(TDataSet), TSFBusinessDataWrapSource, 'DataSet', TBDSWrapperDataSourceEditor);
  RegisterPropertyEditor(TypeInfo(TSFBusinessData), TSFBusinessDataRelationDesigner, 'DestObj', TBDSDataRelDestObjEditor);
  RegisterPropertyEditor(TypeInfo(TSFStmt), nil, '', TBDSStmtProperty);
end;

end.
