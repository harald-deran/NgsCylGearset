unit InfoFormUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TMyInfoForm }

  TMyInfoForm = class(TForm)
    InfoMemo: TMemo;
  private

  public

  end;

var
  MyInfoForm: TMyInfoForm;

implementation

{$R *.lfm}

end.

