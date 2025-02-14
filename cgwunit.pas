unit CgwUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  tCgw = class(tObject)
  public
    Abmass_Tol_Reihe: string;
    alpha_a: extended; { pressure angle at tip dia [ rad ] }
    alpha_n: extended; { normal pressure angle [ rad ] }
    alpha_t: extended; { transverse pressure angle [ rad ] }

    alpha_tprP0: extended; { [rad] Protuberanzwinkel am Bezugsprofil des Werkzeugs }

    b: extended; { tooth width [ mm ] }
    b_K: extended; { chamfer at toothends [ mm ] }
    b_sbStar: extended; { relative web width = factor web divided by tooth width (b_s / b) [ - ] }
    beta: extended; { helix angle [ rad ] }
    cStarMin: extended; { factor of min. gap tip to root [-] }
    DIN_Q: integer; { STplus: Verzahnungsqualität nach DIN 3961 }
    d: extended; { pitch dia [ mm ] }
    d_b: extended; { base dia [ mm ] }
    d_a: extended; { tip dia [ mm ] }
    d_f: extended; { root dia [ mm ] }
    h_aP, h_fP, r_fP: extended; { ref-profile dims [ mm ] }
    h_aPStar, h_fPStar, r_fPStar: extended; { ref. profile factors }

    h_aP0Star, h_aP1Star: extended; { [-] Zahnkopfhöhenfaktor am Bezugsprofil des Werkzeugs 0=Vorverz. 1=Fertigverz. }
    h_fP0Star, h_fP1Star: extended; { [-] Zahnfußhöhenfaktor am Bezugsprofil des Werkzeugs }
    h_FfP0Star, h_FfP1Star: extended; { [-] Zahnfußformhöhenfaktor am Bezugsprofil des Werkzeugs }
    h_prP0Star: extended; { Protuberanzhöhenfaktor / protuberance high factor }

    h_K: extended; { chamfer at tip dia [ mm ] }
    ISO_Q: integer; { STplus: Verzahnungsqualität nach ISO }
    m_n, m_t: extended; { normal and transverse module [ mm ] }
    p_n, p_t: extended; { normal and transverse pitch [ mm ] }

    
    pr_tP0Star: extended; { [-] Protubenranzdickenfaktor / factor of thickness of protuberance }

    q0: extended; { Bearbeitungszugabe [ mm ] }
    R_aF, R_aH: extended; { Arithmetic mean roughness of tooth root (R_aF) and flank (R_aH) [ µm ] }
    R_zF, R_zH: extended; { roughness depth of tooth root (R_zF) and flank (R_zH) [ µm ] }

    r_aP0Star, r_aP1Star: extended; { [-] Kopfrundungsfaktor am Bezugsprofil des Werkzeugs }

    s_a, s_t: extended; { tooth thickness at tip, pitch dia [ mm ] }
    Wkz0, Wkz1: string; { Werkzeug 1 und 2 / tool no. 1 and 2 }     
    Werkstoff: string;  { name of material from file WST.DAT }
    s_anStar: extended; { factor of min. tooth tip thickness [ - ] }
    x: extended; { profile shift factor [ - ] }
    Y_X: extended; { Größenfaktor Fuß [-] }
    Z_X: extended; { Größenfaktor Flanke [-] }
    z: integer; { no. of teeth [ - ] }
  end;

implementation

uses
  math;

end.

