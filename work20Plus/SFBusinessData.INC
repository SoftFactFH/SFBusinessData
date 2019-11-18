//
//   Title:         SFBusinessData.INC
//
//   Description:   set conditions for compiler
//
//   Created by:    Frank Huber
//
//   Copyright:     Frank Huber - The SoftwareFactory -
//                  Alberweilerstr. 1
//                  D-88433 Schemmerhofen
//
//                  http://www.thesoftwarefactory.de
//

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion < 27.0}
    {$DEFINE VERSMALLER_XE6}
  {$IFEND}
  {$IF CompilerVersion < 29.0}
    {$DEFINE VERSMALLER_XE8}
  {$IFEND}
{$ENDIF}
