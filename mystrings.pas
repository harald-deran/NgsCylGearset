unit mystrings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LclType,
  Dialogs, StdCtrls, ExtCtrls, StrUtils,
  Clipbrd;

const
  InputFloatChars: set of char = [#3, #22,' ', '_', '-', 'e', ',', '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', #8, #127];
  InputIntChars: set of char = [#3, #22, ' ', '_', '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', #8, #127];
  IntChars: set of char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];


function Str2Float(aStr: string): extended;
function Str2Int(aStr: string): int64;
procedure MyIntInput(Sender: TObject; var Key: char);
procedure MyFloatInput(Sender: tObject; var Key: char);
function Int2Str(aInt: int64; nPlaces: integer): string;
function Float2Str(aFloat: extended; nPlaces, nDecimals: integer): string;

implementation

function Str2Float(aStr: string): extended;
var
  E: integer;
begin
  while PosEx(' ', aStr) <> 0 do Delete(aStr, PosEx(' ', aStr), 1);
  while PosEx('_', aStr) <> 0 do Delete(aStr, PosEx('_', aStr), 1);
  Val(aStr, Result, E);
  if E <> 0 then Result := 0;
end;

function Str2Int(aStr: string): int64;
var
  E: int64;
begin 
  while PosEx(' ', aStr) <> 0 do Delete(aStr, PosEx(' ', aStr), 1);
  while PosEx('_', aStr) <> 0 do Delete(aStr, PosEx('_', aStr), 1);
  Val(aStr, Result, E);
  if E <> 0 then Result := 0;
end;


procedure MyIntInput(Sender: TObject; var Key: char);
begin                 
  if not (Key in IntChars) then { Eine Zahl wird halt immer angenommen! }
  begin
    if not ( Key in InputIntChars ) then Key := #0 else
    if Sender is tLabeledEdit then with Sender as tLabeledEdit do
    begin
      if Key = '-' then if (PosEx('-', Text) <> 0) then Key := #0
      else SelStart := 0;
    end else
    if Sender is tEdit then with Sender as tEdit do
    begin
      if Key = '-' then if (PosEx('-', Text) <> 0) then Key := #0
      else SelStart := 0;
    end;
  end;
end;

procedure MyFloatInput(Sender: TObject; var Key: char);

  procedure HandleTLabeledEdit;
  var
    i: integer;
    buf: string;
  begin
    with Sender as TLabeledEdit do
    begin
      if (Key = 'e') and (PosEx('e', Text) = 0) then SelStart := Length(Text);
      if (Key = 'e') and (PosEx('e', Text) <> 0) then Key := #0;
      if (Key ='.')  and (PosEx('.', Text) <> 0) then Key := #0;
      if Key = '-' then
      begin
        if PosEx('e', Text) > 0 then
        begin
          { Prüfen, ob zwei Minuszeichen vorhanden sind: }
          if (PosEx('-', Text) > 0) and (PosEx('-', Text, PosEx('-', Text) + 1) > 0) then Key := #0 else
          { Ist Cursorposition weder ganz vorn noch hinter dem "e", dann nixda! }
          if (CaretPos.x <> PosEx('e', Text)) and (CaretPos.x <> 0) then Key := #0;
        end else
        if CaretPos.x <> 0 then Key := #0; { Nur wenn das Minus vor der Zahl eingegeben wird! }
      end;
      if Key = #22 then
      begin
        buf := Clipboard.AsText;
        for i := 1 to length(buf) do
        if not (buf[i] in InputFloatChars) then Clipboard.AsText := '';
      end;
    end;
  end;

  procedure HandleTEdit;
  var
    i: integer;
    buf: string;
  begin
    with Sender as TEdit do
    begin                         
      if (Key = 'e') and (PosEx('e', Text) = 0) then SelStart := Length(Text);
      if (Key = 'e') and (PosEx('e', Text) <> 0) then Key := #0;
      if (Key ='.')  and (PosEx('.', Text) <> 0) then Key := #0;
      if Key = '-' then
      begin
        if PosEx('e', Text) > 0 then
        begin
          { Prüfen, ob zwei Minuszeichen vorhanden sind: }
          if (PosEx('-', Text) > 0) and (PosEx('-', Text, PosEx('-', Text) + 1) > 0) then Key := #0 else
          { Ist Cursorposition weder ganz vorn noch hinter dem "e", dann nixda! }
          if (CaretPos.x <> PosEx('e', Text)) and (CaretPos.x <> 0) then Key := #0;
        end else
        if CaretPos.x <> 0 then Key := #0; { Nur wenn das Minus vor der Zahl eingegeben wird! }
      end;
      if Key = #22 then
      begin
        buf := Clipboard.AsText;
        for i := 1 to length(buf) do
        if not (buf[i] in InputFloatChars) then Clipboard.AsText := '';
      end;
    end;
  end;

begin
  if not (Key in IntChars) then { Eine Zahl wird halt immer angenommen! }
  begin
    if Key = ',' then Key := '.';  { Regel Nummer eins: Dezimaltrennzeichen ist IMMER der Punkt - Punkt. }
    if not ( Key in InputFloatChars ) then Key := #0; { Alle nicht zugelassenen Zeichen werden gleich eliminiert. }
    if Sender is tLabeledEdit then HandleTLabeledEdit;
    if Sender is tEdit then HandleTEdit;
  end;
end;
                 
function Int2Str(aInt: int64; nPlaces: integer): string;
begin
  Str(aInt: nPlaces, Result);
end;

function Float2Str(aFloat: extended; nPlaces, nDecimals: integer): string;
begin
  Str(aFloat: nPlaces: nDecimals, Result);
end;

end.

