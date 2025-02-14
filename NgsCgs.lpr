program NgsCgs;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, mystrings, CgwUnit, mymath, oilwstunit;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TCylindricalGearset, CylindricalGearset);
  //Application.CreateForm(TMyInfoForm, MyInfoForm);
  Application.Run;
end.

