unit oilwstunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  contnrs;

type
  tWst = class(tObject)
    Name: string;
    EModul: extended;
    nue: extended;
    HeatTreatment: string;
    DIN3990_87_SIGMA_HLIM: extended;
    DIN3990_87_SIGMA_FE  : extended;
    DIN3990_87_SIGMA_FLIM: extended;
  end;

  tOel = class(tObject)
  public
    Name: string;
    Art: string;
    nue40, nue100: extended;
    rho15: extended;
    FZG_Kraftstufe: integer;
  end;

var
  WstList: tObjectList;
  OelList: tObjectList; 

procedure LoadOelList(var anObjectList: tObjectList);
procedure LoadWstList(var anObjectList: tObjectList);

implementation 

procedure LoadOelList(var anObjectList: tObjectList);
var
  anOel: tOel;
begin
  anOel := tOel.Create;
  anOel.Name           := 'Castrol-BOT-352-B1';
  anOel.Art            := 'Mineraloel';
  anOel.nue40          := 18.0;
  anOel.nue100         := 4.6;
  anOel.rho15          := 0.849;
  anOel.FZG_Kraftstufe := 10;
  anObjectList.Add(anOel);
end;

procedure LoadWstList(var anObjectList: tObjectList);
var
  aWst: tWst;
begin
  aWst := tWst.Create;
  aWst.Name                 := '16MnCr5';
  aWst.EModul               := 210000.0;
  aWst.nue                  := 0.3;
  aWst.HeatTreatment        := 'einsatzgehaertet';
  aWst.DIN3990_87_SIGMA_HLIM:= 1460.0;
  aWst.DIN3990_87_SIGMA_FE  := 860.0;
  aWst.DIN3990_87_SIGMA_FLIM:= 430.0;
  anObjectList.Add(aWst);
end;

end.

