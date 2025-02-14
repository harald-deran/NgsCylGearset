unit CgsUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, CgwUnit,
  math, mymath;

type
  tCgs = class(tObject)
 public
    a: extended; { center distance [ mm ] }
    a_d: extended; { ref center distance [ mm ] }
    alpha_wt: extended;
    i: extended; { gearwheelset ratio [ - ] }
    gw_1, gw_2: tCgw; { gearwheel 1 & 2 }
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  MyStrings;

constructor tCgs.Create;
begin
  inherited Create;
end;

destructor tCgs.Destroy;
begin
  gw_2.free;
  gw_1.free;
  inherited Destroy;
end;



end.

