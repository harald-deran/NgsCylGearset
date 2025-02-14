unit mymath;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  tBigInt = class(tObject)

  end;

function RingArea(r1, r2: extended): extended;
function EpsilonAlpha(z_1: integer; d_a1, d_b1: extended; z_2: integer; d_a2, d_b2, alpha_wt: extended): extended;
function EpsilonBeta(m_n, b, beta: extended): extended;
function IsPrime(aNumber: Cardinal): Boolean;
function InvToAngle(inv_a: Extended): Extended;
function ggT(i, j: integer): Integer;
function zPLim(zZ, p: integer): integer;

implementation


function RingArea(r1, r2: extended): extended;
begin
  Result := (r1*r1-r2*r2)*pi;
end;

function EpsilonAlpha(z_1: integer; d_a1, d_b1: extended; z_2: integer; d_a2, d_b2, alpha_wt: extended): extended;
var
  eps_1, eps_2: extended;
begin
  eps_1 := z_1 / 2 / pi * (Power(((d_a1 / d_b1) * (d_a1 / d_b1) - 1), 1/2) - tan(alpha_wt));
  eps_2 := z_2 / 2 / pi * (Power(((d_a2 / d_b2) * (d_a2 / d_b2) - 1), 1/2) - tan(alpha_wt));
  Result := eps_1 + eps_2;
end;

function EpsilonBeta(m_n, b, beta: extended): extended;
begin
  Result := b * sin(abs(beta)) / m_n / pi;
end;

function IsPrime(ANumber: Cardinal): Boolean;
var
  Divisor: Integer;
begin
  Result := true;
  if aNumber < 9 then
  begin
    if aNumber = 2 then exit;
    if aNumber = 3 then exit;
    if aNumber = 5 then exit;
    if aNumber = 7 then exit;
  end;
  { Check: is aNumber a just number? }
  Result := (ANumber = 2) or ((ANumber > 1) and (ANumber mod 2 = 0));
  { Then Result must be false! And then exit ... }
  if Result then
  begin
    Result := false;
    Exit;
  end;
  Divisor := 3;
  Result := true;
  while (Divisor < sqrt(ANumber) + 1) do
  begin
    {
    MyMemo.Lines.Add('In while loop: Divisor = ' + IntToStr(Divisor));
    MyMemo.Lines.Add('aNumber mod Divisor = ' + IntToStr(aNumber mod Divisor));
    }
    if (ANumber mod Divisor = 0) then
    begin
      Result := False;
      Exit;
    end;
    Inc(Divisor, 2);
  end;
end;

function InvToAngle(inv_a: Extended): Extended;
var
  a0, a1, a2, d: Extended;
begin

  //with MyInfoForm.InfoMemo.Lines do
  //begin
  //  add('MyMath - InvToAngle');
  //  add('     inv_a = ' + FloatToStrF(inv_a, ffFixed, 15, 10));
  //  add('        a0 = ' + FloatToStrF(a0, ffFixed, 15, 6));
  //  add('         d = ' + FloatToStrF(d, ffFixed, 15, 6));
  //  add('        a1 = ' + FloatToStrF(a1, ffFixed, 15, 6));
  //  add('        a2 = ' + FloatToStrF(a2, ffFixed, 15, 6));
  //end;

  a0 := Power(3*inv_a, 1/3);
  d := -1 * Power(tan(a0) * tan(a0), 0.5) + a0 + inv_a;
  a1 := d/tan(a0)/tan(a0)+a0;
  a2 := (-1*tan(a1)+a1+inv_a)/Power(tan(a1), 2)+a1;

  while ((tan(a2)-a2-inv_a) > 0.0000000000001) do
  begin
    a1 := a2;
    a2 := (-1*tan(a1)+a1+inv_a)/Power(tan(a1), 2)+a1;
  end;
  Result := a2;
end;

function ggT(i, j: integer): Integer;
var
  z: integer;
begin
  while j > 0 do
  begin
    z := j;
    j := i mod j;
    i := z;
  end;
  Result := i;
end;

function zPLim(zZ, p: integer): integer;
var
  q: extended;
begin
  case p of
    3: begin
         Result := trunc((zZ - 4/3 * sqrt(3)) / (2/3 * sqrt(3) - 1));
       end;
    4: begin
         Result := trunc((zZ - 2 * sqrt(2)) / (sqrt(2) - 1));
       end;
    5: begin
         q := sqrt(50 + 10 * sqrt(5));
         Result := trunc((zZ - 2 * q / 5) / (q / 5 - 1));
       end;
    else Result := 0;
  end;
end;

end.

