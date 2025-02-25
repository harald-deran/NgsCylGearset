unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  StrUtils, Math,
  Menus, ComCtrls, mystrings, CgwUnit, OilWstUnit, MyMath;

const
  MemoryFileName = 'NgsCgs.mem';
type

  { TCylindricalGearset }

  TCylindricalGearset = class(TForm)
    FVA166CheckBox: TCheckBox;
    MenuItem3: TMenuItem;
    MenuItemSaveMemoFile: TMenuItem;
    MenuItemSTplusPath: TMenuItem;
    MenuItemCfgFile: TMenuItem;
    MenuItemStartSTplus: TMenuItem;
    MenuItemOpenSte: TMenuItem;
    MenuItemStaPath: TMenuItem;
    MenuItemStePath: TMenuItem;
    MenuItemWstPath: TMenuItem;
    MenuItemOpenSta: TMenuItem;
    UnlegOelCheckBox: TCheckBox;
    ISO6336CheckBox: TCheckBox;
    Edit_thetaOil: TLabeledEdit;
    Label3: TLabel;
    Label_i: TLabel;
    Panel2: TPanel;
    WstComboBox1: TComboBox;
    OilComboBox: TComboBox;
    WstComboBox2: TComboBox;
    Edit_a: TLabeledEdit;
    Edit_mn: TLabeledEdit;
    Edit_alphan: TLabeledEdit;
    Edit_bK1: TLabeledEdit;
    Edit_bK2: TEdit;
    Edit_hK2: TEdit;
    Edit_hK1: TLabeledEdit;
    Edit_beta: TLabeledEdit;
    Edit_KA: TLabeledEdit;
    Edit_n1: TLabeledEdit;
    Edit_T1: TLabeledEdit;
    Edit_T1stat: TLabeledEdit;
    Edit_z1: TLabeledEdit;
    Edit_z2: TEdit;
    Edit_b1: TLabeledEdit;
    Edit_b2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    MenuItem2: TMenuItem;
    MenuItemOilFilePath: TMenuItem;
    MenuItemSaveSteFile: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItemClose: TMenuItem;
    MyMemo: TMemo;
    MySaveDialog: TSaveDialog;
    MyScrollBox: TScrollBox;
    MyOpenDialog: TOpenDialog;
    MyPageControl: TPageControl;
    Panel1: TPanel;
    Panel3: TPanel;
    x1x2RadioGroup: TRadioGroup;
    Separator1: TMenuItem;
    TabSheetGearboxData: TTabSheet;
    InfoTabSheet: TTabSheet;
    procedure FloatInput(Sender: TObject; var Key: char);
    procedure IntInput(Sender: TObject; var Key: char);
    procedure MenuItemCfgFileClick(Sender: TObject);
    procedure MenuItemOpenSteClick(Sender: TObject);
    procedure MenuItemOpenStaClick(Sender: TObject);
    procedure MenuItemCloseClick(Sender: TObject);
    procedure MenuItemSaveSteFileClick(Sender: TObject);
    procedure MenuItemOilFilePathClick(Sender: TObject);
    procedure MenuItemSaveMemoFileClick(Sender: TObject);
    procedure MenuItemStaPathClick(Sender: TObject);
    procedure MenuItemStartSTplusClick(Sender: TObject);
    procedure MenuItemStePathClick(Sender: TObject);
    procedure MenuItemSTplusPathClick(Sender: TObject);
    procedure MenuItemWstPathClick(Sender: TObject);
    procedure OilComboBoxChange(Sender: TObject);
    procedure WstComboBox1Change(Sender: TObject);
    procedure WstComboBox2Change(Sender: TObject);
  private
    a: extended; { center distance [mm] }
    a_d: extended; { ref center distance [mm] }
    alpha_wt: extended; { transverse pressure angle at working dia [rad] }
    Ausdruck_FVA166: string; { show results of calculation acc. to FVA 166 ['ja'/'nein'] }
    gw1, gw2: tCgw; { gearwheel 1 & 2 }
    i: extended; { gearwheelset ratio [-] }
    ISO_6336_2006: string; { calculation acc. to FVA 166 ['ja'/'nein'] }
    K_A: extended; { application factor [-] }
    LastSteFile: string;
    MyHomePath: string;
    StePath, StaPath: string;
    n_1: extended; { input speed [rpm] }
    Oeltemperatur: extended; { temperature of oil in operation [°] }
    STplusCfgFile: string;
    STplusOelFile: string;
    STplusPath: string;
    STplusWstFile: string;
    Schmierstoff: string; { name of lubricant from file OEL.DAT }
    T_1, T_1stat: extended; { torque gear wheel [Nm] }
    UnlegiertesOel: string; { oil with or without additives ['ja'/'nein'] }

    x1x2: integer; { STplus number for a calculation of profile shift [1 .. 7] see manual page 24 }
  public
    constructor Create(aOwner: tComponent); override;
    destructor Destroy; override;
    procedure SaveMemories;
    procedure LoadSteFile(aFilename: string);
    procedure CalcData;
    procedure GetInputData;
    procedure ShowResults;   
    procedure CreateSteFile(aSteFileName: string);
    procedure LoadOelListFromFile;
    procedure LoadWstListFromFile;
  end;

var
  CylindricalGearset: TCylindricalGearset;

implementation

{$R *.lfm}

uses
  process;

constructor TCylindricalGearset.Create(aOwner: tComponent);
var
  YesNo: integer;

  procedure ReadMemories(aFilename: string);
  var
    MyInt: integer;
    MySL: tStringList;
  begin
    Left := 0;
    Top := 0;
    Width := 800;
    Height := 678;
    MySL := tStringList.Create;
    MySL.LoadFromFile(aFilename);
    for MyInt := 0 to MySL.Count-1 do
    case ExtractWord(1, MySL[MyInt], [' ']) of
      'MainForm.Left':   Left   := StrToInt(ExtractWord(3, MySL[MyInt], [' ']));
      'MainForm.Top':    Top    := StrToInt(ExtractWord(3, MySL[MyInt], [' ']));
      'MainForm.Width':  Width  := StrToInt(ExtractWord(3, MySL[MyInt], [' ']));
      'MainForm.Height': Height := StrToInt(ExtractWord(3, MySL[MyInt], [' ']));
      'STplusOelFile':   STplusOelFile := ExtractWord(3, MySL[MyInt], [' ']);
      'STplusWstFile':   STplusWstFile := ExtractWord(3, MySL[MyInt], [' ']);
      'StePath':         StePath := ExtractWord(3, MySL[MyInt], [' ']);
      'StaPath':         StaPath := ExtractWord(3, MySL[MyInt], [' ']);
      'LastSteFile':     LastSteFile := ExtractWord(3, MySL[MyInt], [' ']);
      'STplusPath':      STplusPath := ExtractWord(3, MySL[MyInt], [' ']);
      'STplusCfgFile':   STplusCfgFile := ExtractWord(3, MySL[MyInt], [' ']);
    end;
    MySL.Free;
  end;

  procedure SetDefaultMemories;
  begin
    Left := 10;
    Top := 10;
    Width := 1200;
    Height := 1000;
  end;

begin
  inherited Create(aOwner);
  MyHomePath := GetCurrentDir;
  if FileExists(MemoryFilename) then ReadMemories(MemoryFilename) else
  begin
    YesNo := MessageDlg('Memory-Datei nicht gefunden! Datei suchen? {sonst Default}', mtWarning, [mbYes, mbNo], 0);
    if YesNo = mrYes then
    begin
      if MyOpenDialog.execute then ReadMemories(MyOpenDialog.Filename) else SetDefaultMemories;
    end else SetDefaultMemories;
  end;
  LoadOelListFromFile;
  LoadWstListFromFile;
  LoadSteFile(LastSteFile);
  Caption := 'NgsCylGearset: ' + ExtractFilename(LastSteFile);
  gw1 := tCgw.Create;
  gw2 := tCgw.Create;
  GetInputData;
  CalcData;
  ShowResults;
  MyPageControl.ActivePage := TabSheetGearboxData;
end;

destructor TCylindricalGearset.Destroy;
begin
  SaveMemories;
  gw2.free;
  gw1.free;
  inherited Destroy;
end;


procedure tCylindricalGearset.SaveMemories;
var
  MySL: tStringList;
begin
  ChDir(MyHomePath);
  MySL := tStringList.Create;
  with MySL do
  begin
    add('MainForm.Left   = ' + IntToStr(Left));
    add('MainForm.Top    = ' +  IntToStr(Top));
    add('MainForm.Width  = ' +  IntToStr(Width));
    add('MainForm.Height = ' +  IntToStr(Height));
    add('STplusOelFile   = ' + STplusOelFile);
    add('STplusWstFile   = ' + STplusWstFile);
    add('StePath         = ' + StePath);
    add('StaPath         = ' + StaPath);
    add('LastSteFile     = ' + LastSteFile);
    add('STplusPath      = ' + STplusPath);
    add('STplusCfgFile   = ' + STplusCfgFile);
  end;
  MySL.SaveToFile(MemoryFilename);
  MySL.Free;
end;


procedure tCylindricalGearset.LoadSteFile(aFilename: string);
var
  aInt, bInt: integer;
  MySL: tStringList;
  Wst1, Wst2: string;
begin
  MySL := tStringList.Create;
  if FileExists(aFilename) then MySL.LoadFromFile(aFilename);
  for aInt := 0 to MySL.Count-1 do
  case ExtractWord(1, MySL[aInt], [' ']) of
    'Eingriffswinkel':   Edit_alphan.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Schraegungswinkel': Edit_beta.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Achsabstand':       Edit_a.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Normalmodul':       Edit_mn.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Zaehnezahl':        begin
                           Edit_z1.Text := ExtractWord(3, MySL[aInt], [' ']);
                           Edit_z2.Text := ExtractWord(4, MySL[aInt], [' ']);
                         end;
    'Aufteilung_x1x2':   x1x2RadioGroup.ItemIndex := Str2Int(ExtractWord(3, MySL[aInt], [' '])) - 1;
    'Zahnbreite':        begin
                           Edit_b1.Text := ExtractWord(3, MySL[aInt], [' ']);
                           Edit_b2.Text := ExtractWord(4, MySL[aInt], [' ']);
                         end;
    'Fase':              begin
                           Edit_bK1.Text := ExtractWord(3, MySL[aInt], [' ']);
                           Edit_bK2.Text := ExtractWord(4, MySL[aInt], [' ']);
                         end;
    'Kopfkantenbruch':   begin
                           Edit_hK1.Text := ExtractWord(3, MySL[aInt], [' ']);
                           Edit_hK2.Text := ExtractWord(4, MySL[aInt], [' ']);
                         end;

    'Drehmoment':        Edit_T1.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Drehmoment_stat':   Edit_T1stat.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Drehzahl':          Edit_n1.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Schmierstoff':      begin
                           Schmierstoff := ExtractWord(3, MySL[aInt], [' ']);
                           for bInt := 0 to OilComboBox.Items.Count-1 do
                           if OilComboBox.Items[bInt] = Schmierstoff then OilComboBox.ItemIndex := bInt;
                         end;
    'Oeltemperatur':     Edit_thetaOil.Text := ExtractWord(3, MySL[aInt], [' ']);
    'Werkstoff':         begin
                           Wst1 := ExtractWord(3, MySL[aInt], [' ']);
                           Wst2 := ExtractWord(4, MySL[aInt], [' ']);
                           for bInt := 0 to WstComboBox1.Items.Count-1 do
                           if WstComboBox1.Items[bInt] = Wst1 then WstComboBox1.ItemIndex := bInt;
                           for bInt := 0 to WstComboBox2.Items.Count-1 do
                           if WstComboBox2.Items[bInt] = Wst2 then WstComboBox2.ItemIndex := bInt;
                         end;
    'ISO_6336_2006':     if ExtractWord(3, MySL[aInt], [' ']) = 'ja' then ISO6336CheckBox.Checked := true
                         else ISO6336CheckBox.Checked := false;
    'Ausdruck_FVA166':   if ExtractWord(3, MySL[aInt], [' ']) = 'ja' then FVA166CheckBox.Checked := true
                         else FVA166CheckBox.Checked := false;

    'UnlegiertesOel':    if ExtractWord(3, MySL[aInt], [' ']) = 'ja' then UnlegOelCheckBox.Checked := true
                         else UnlegOelCheckBox.Checked := false;
    'Anwendungsfaktor':  Edit_KA.Text := ExtractWord(3, MySL[aInt], [' ']);
  end;
end;

procedure tCylindricalGearset.CalcData;
var
  r_fPmax: extended;
  s_fPK: extended;
  x_r1: extended;
  y_r1: extended;
begin
  i := gw2.z / gw1.z;
  with gw1 do alpha_t := arctan(tan(alpha_n) / cos(gw1.beta));
  with gw2 do alpha_t := arctan(tan(alpha_n) / cos(gw2.beta));
  alpha_wt := InvToAngle(tan(gw1.alpha_t)-gw1.alpha_t + 2 * (gw1.x + gw2.x) * tan(gw1.alpha_n) / (gw1.z + gw2.z));
  a_d := gw1.m_n * (gw1.z + gw2.z) / 2 / cos(gw1.beta);
  with gw1 do
  begin
    m_t := m_n / cos(beta);
    d := m_n * z / cos(beta);
    d_b := d * cos(alpha_t);
    d_a := d + 2 * m_n * (h_aPStar + x);
    d_f := d + 2 * m_n * (x - h_fPStar);
    p_n := m_n * pi;
    p_t := m_t * pi;
    h_aP := h_aPStar * m_n;
    h_fP := h_aPStar * m_n;
    r_fP := r_fPStar * m_n;
    s_fPK := p_t / 2 - 2 * h_fP * tan(alpha_t);
    x_r1 := s_fPK / 2 * (1 - sin(alpha_t));
    y_r1 := s_fPK / 2 * cos(alpha_t);
    r_fPmax := y_r1 + x_r1 * tan(alpha_t);
    if r_fP > r_fPmax then
    begin
      r_fP := r_fPmax;
      r_fPStar := r_fP / m_n;
    end;
    s_t := p_t / 2 + 2 * x * m_n * tan(alpha_t);
    alpha_a :=  arccos(d_b / d_a);
    s_a := d_a * (s_t / d + tan(alpha_t) - alpha_t - Tan(alpha_a) + alpha_a);
  end;
  with gw2 do
  begin
    m_t := m_n / cos(beta);
    d := m_n * z / cos(beta);
    d_b := d * cos(alpha_t);
    d_a := d + 2 * m_n * (h_aPStar + x);
    d_f := d + 2 * m_n * (x - h_fPStar);
    p_n := m_n * pi;
    p_t := m_t * pi;
    h_aP := h_aPStar * m_n;
    h_fP := h_aPStar * m_n;
    r_fP := r_fPStar * m_n;
    s_fPK := p_t / 2 - 2 * h_fP * tan(alpha_t);
    x_r1 := s_fPK / 2 * (1 - sin(alpha_t));
    y_r1 := s_fPK / 2 * cos(alpha_t);
    r_fPmax := y_r1 + x_r1 * tan(alpha_t);
    if r_fP > r_fPmax then
    begin
      r_fP := r_fPmax;
      r_fPStar := r_fP / m_n;
    end;
    s_t := p_t / 2 + 2 * x * m_n * tan(alpha_t);
    alpha_a :=  arccos(d_b / d_a);
    s_a := d_a * (s_t / d + tan(alpha_t) - alpha_t - Tan(alpha_a) + alpha_a);
  end;
end;

procedure TCylindricalGearset.FloatInput(Sender: TObject; var Key: char);
begin
  MyFloatInput(Sender, Key);
end;

procedure TCylindricalGearset.IntInput(Sender: tObject; var Key: char);
begin
  MyIntInput(Sender, Key);
end;

procedure TCylindricalGearset.MenuItemCfgFileClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'STplus-Config-Datei auswählen:';
  if MyOpenDialog.execute then STplusCfgFile := MyOpenDialog.Filename;
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemOpenSteClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'STplus-Eingabedatei öffnen';
  MyOpenDialog.InitialDir := StePath;
  if MyOpenDialog.execute then
  begin
    LoadSteFile(MyOpenDialog.FileName);
    LastSteFile := MyOpenDialog.Filename;
    Caption := 'NgsCylGearset: ' + ExtractFilename(LastSteFile);
  end;
  StePath := ExtractFilePath(MyOpenDialog.Filename);
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemOpenStaClick(Sender: TObject);
var
  BufStr: string;
  MySL: tStringList;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'STplus-Ausgabedatei öffnen';
  MyOpenDialog.InitialDir := StaPath;
  if MyOpenDialog.execute then
  begin
    MySL := tStringList.Create;
    MySL.LoadFromFile(MyOpenDialog.Filename);
    MyMemo.Text := MySL.Text;
    MySL.Free;
    MyPageControl.ActivePage := InfoTabSheet;
  end;
  StaPath := ExtractFilePath(MyOpenDialog.Filename);
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCylindricalGearset.MenuItemSaveSteFileClick(Sender: TObject);
var
  BufStr: string;
begin                            
  BufStr := MySaveDialog.Title;
  MySaveDialog.Title := 'STplus-Eingabedatei speichern';
  MySaveDialog.InitialDir := StePath;
  if MySaveDialog.Execute then
  begin
    if FileExists(MySaveDialog.Filename) then
    begin
      if MessageDlg('Achtung!', 'Datei bereits vorhanden - überschreiben?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        CreateSteFile(MySaveDialog.Filename);
      end;
    end else CreateSteFile(MySaveDialog.Filename);
  end;
  MySaveDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemOilFilePathClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'Öldatei festlegen';
  if MyOpenDialog.Execute then STplusOelFile := MyOpenDialog.FileName;
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemSaveMemoFileClick(Sender: TObject);
begin
  SaveMemories;
end;

procedure TCylindricalGearset.MenuItemStaPathClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'Pfad zur Ausgabedatei festlegen';
  if MyOpenDialog.execute then StaPath := ExtractFilePath(MyOpenDialog.Filename);
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemStartSTplusClick(Sender: TObject);
var
  aStaFile: string; 
  aSteFile: string;
  BufStr: string;
  LinePos: integer;
  MySL: tStringList;   
  STplusProcess: tProcess;
begin
  if LastSteFile = '' then
  begin
    BufStr := MyOpenDialog.Title;
    MyOpenDialog.Title := 'STplus-Eingabedatei öffnen';
    if MyOpenDialog.execute then LastSteFile := MyOpenDialog.Filename;
    MyOpenDialog.Title := BufStr;
  end;
  aSteFile := LastSteFile;

  aStaFile := ExtractFilename(aSteFile);
  Delete(aStaFile, Length(aStaFile), 1);
  aStaFile := aStaFile + 'a';
  aStaFile := StaPath + aStaFile;
  MySL := tStringList.Create;
  MySL.LoadFromFile(STplusCfgFile);
  for LinePos := 0 to MySL.Count-1 do
  case ExtractWord(1, MySL[LinePos], [' ']) of
    'Eingabedatei': MySL[LinePos] := 'Eingabedatei = ' + aSteFile;
    'Ausgabedatei': MySL[LinePos] := 'Ausgabedatei = ' + aStaFile;
  end; 
  MySL.SaveToFile(STplusCfgFile);
  STplusProcess := tProcess.Create(nil);
  ChDir(STplusPath);
  STplusProcess.Executable := STplusPath + '\STplus.exe';
  STplusProcess.Execute;
  STplusProcess.WaitOnExit;
  STplusProcess.Free;
  MySL.Clear;
  MySL.LoadFromFile(aStaFile);
  MyMemo.Text := MySL.Text;
  MySL.Free;
  MyPageControl.ActivePage := InfoTabSheet;
end;

procedure TCylindricalGearset.MenuItemStePathClick(Sender: TObject); 
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'Pfad zur Eingabedatei festlegen';
  if MyOpenDialog.execute then StePath := ExtractFilePath(MyOpenDialog.Filename);
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemSTplusPathClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'Pfad zum STplus-Programm festlegen';
  if MyOpenDialog.execute then STplusPath := ExtractFilePath(MyOpenDialog.Filename);
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.MenuItemWstPathClick(Sender: TObject);
var
  BufStr: string;
begin
  BufStr := MyOpenDialog.Title;
  MyOpenDialog.Title := 'Werkstoffdatei festlegen';
  if MyOpenDialog.Execute then STplusWstFile := MyOpenDialog.FileName;
  MyOpenDialog.Title := BufStr;
end;

procedure TCylindricalGearset.OilComboBoxChange(Sender: TObject);
begin
  Schmierstoff := OilComboBox.Items[OilComboBox.ItemIndex];
end;

procedure TCylindricalGearset.WstComboBox1Change(Sender: TObject);
begin
  gw1.Werkstoff := WstComboBox1.Items[WstComboBox1.ItemIndex];
end;

procedure TCylindricalGearset.WstComboBox2Change(Sender: TObject);
begin
  gw2.Werkstoff := WstComboBox2.Items[WstComboBox2.ItemIndex];
end;

procedure TCylindricalGearset.GetInputData;
begin
  a := Str2Float(Edit_a.Text);
  T_1 := Str2Float(Edit_T1.Text);
  T_1stat := Str2Float(Edit_T1stat.Text);
  n_1 := Str2Float(Edit_n1.Text);
  K_A := Str2Float(Edit_KA.Text);
  x1x2 := x1x2RadioGroup.ItemIndex+1;
  Schmierstoff := OilComboBox.Items[OilComboBox.ItemIndex];
  Oeltemperatur := Str2Float(Edit_thetaOil.Text);
  if ISO6336CheckBox.Checked then ISO_6336_2006 := 'ja' else ISO_6336_2006 := 'nein';
  if UnlegOelCheckBox.Checked then UnlegiertesOel := 'ja' else UnlegiertesOel := 'nein';
  if FVA166CheckBox.Checked then Ausdruck_FVA166 := 'ja' else Ausdruck_FVA166 := 'nein';
  with gw1 do
  begin
    alpha_n := Str2Float(Edit_alphan.Text) / 180 * pi;
    beta := Str2Float(Edit_beta.Text) / 180 * pi; 
    m_n := Str2Float(Edit_mn.Text);
    z := Str2Int(Edit_z1.Text);
    b := Str2Float(Edit_b1.Text);
    b_K := Str2Float(Edit_bK1.Text);
    h_K := Str2Float(Edit_hK1.Text);
    Werkstoff := WstComboBox1.Items[WstComboBox1.ItemIndex];
  end;
  with gw2 do
  begin
    alpha_n := Str2Float(Edit_alphan.Text) / 180 * pi;
    beta := Str2Float(Edit_beta.Text) / 180 * pi;
    m_n := Str2Float(Edit_mn.Text);
    z := Str2Int(Edit_z2.Text);  
    b := Str2Float(Edit_b2.Text);
    b_K := Str2Float(Edit_bK2.Text);
    h_K := Str2Float(Edit_hK2.Text); 
    Werkstoff := WstComboBox2.Items[WstComboBox2.ItemIndex];
  end;
end;

procedure TCylindricalGearset.ShowResults;
begin 
  Label_i.Caption := Float2Str(i, 12, 6);
end;  

procedure TCylindricalGearset.CreateSteFile(aSteFileName: string);
var
  MySL: tStringList;
begin
  GetInputData;
  CalcData;
  MySL := tStringList.Create;
  with MySL do
  begin
    add('');
    add('$ Anfang');
    add('');
    add('');
    add('$ Geometriedaten');
    add('');
    add('Eingriffswinkel = ' + Float2Str(gw1.alpha_n*180/pi, 15, 12)); 
    add('Schraegungswinkel = ' + Float2Str(gw1.beta*180/pi, 15, 12)); 
    add('Normalmodul = ' + Float2Str(gw1.m_n, 11, 6));
    add('Achsabstand = ' + Float2Str(a, 11, 6));
    add('Zaehnezahl = ' + IntToStr(gw1.z) + ' ' + IntToStr(gw2.z));
    x1x2 := x1x2RadioGroup.ItemIndex+1;
    case x1x2 of
      1: add('Aufteilung_x1x2 = 1');
      2: add('Aufteilung_x1x2 = 2');
      3: add('Aufteilung_x1x2 = 3');
      4: add('Aufteilung_x1x2 = 4');
      5: add('Aufteilung_x1x2 = 5');
      6: add('Aufteilung_x1x2 = 6');
      7: add('Aufteilung_x1x2 = 7');
    end;   
    add('Zahnbreite = ' + Float2Str(gw1.b, 11, 6) + ' ' + Float2Str(gw2.b, 11, 6));
    add('Fase = ' + Float2Str(gw1.b_K, 11, 6) + ' ' + Float2Str(gw2.b_K, 11, 6));
    add('Kopfkantenbruch = ' + Float2Str(gw1.h_K, 11, 6) + ' ' + Float2Str(gw2.h_K, 11, 6));
    add('');
    add('');
    add('$ Tragfaehigkeit_allgem');
    add('');
    add('Drehmoment = ' + Float2Str(T_1, 11, 6));
    add('Drehmoment_stat = ' + Float2Str(T_1stat, 11, 6));
    add('Drehzahl = ' + Float2Str(n_1, 11, 6));
    add('Schmierstoff = ' + Schmierstoff);
    add('Oeltemperatur = ' + Float2Str(Oeltemperatur, 6, 2));
    add('Werkstoff = ' + gw1.Werkstoff + ' ' + gw2.Werkstoff);
    add('');
    add('');
    add('$ TR_DIN3990_1987');
    add('');
    add('ISO_6336_2006 = ' + ISO_6336_2006);
    add('Ausdruck_FVA166 = ' + AUSDRUCK_FVA166);
    add('Unlegiertes_Oel = ' + UnlegiertesOel);
    add('Anwendungsfaktor = ' + Float2Str(K_A, 9,4));
    add('');
    add('');
    add('$ Ende');
    add('');
  end;
  MySL.SaveToFile(aSteFilename);
  LastSteFile := aSteFilename;
  MySL.Free;
end;

procedure tCylindricalGearset.LoadOelListFromFile;
var
  aStr: string;
  aOel: tOel;
  BufStr: string;
  MyInt: integer;
  MySL: tStringList;
begin
  if not FileExists(STplusOelFile) then
  begin
    BufStr := MyOpenDialog.Title;
    MyOpenDialog.Title := 'Öldatei öffnen';
    if MessageDlg('Öldatei nicht gefunden! Datei suchen? {sonst Default}', mtWarning, [mbYes, mbNo], 0) = mrYes then
    if MyOpenDialog.execute then STplusOelFile := MyOpenDialog.Filename;
    MyOpenDialog.Title := BufStr;
  end;
  if FileExists(STplusOelFile) then
  begin
    MyInt := 0;
    MySL := tStringList.Create;
    MySL.LoadFromFile(STplusOelFile);
    while MyInt <= MySL.Count-1 do
    begin
      if PosEx('Schmierstoffbezeichnung', MySL[MyInt]) > 0 then
      begin
        aOel := tOel.Create;
        aOel.Name := ExtractWord(3, MySL[MyInt], [' ']);
        MyInt := MyInt + 1;
        while (PosEx('$', UpperCase(MySL[MyInt])) = 0) and (MyInt <= MySL.Count-1) do
        begin
          aStr := ExtractWord(1, MySL[MyInt], [' ']);
          case aStr of
            'Schmierstoffart': aOel.Art := ExtractWord(3, MySL[MyInt], [' ']);
            'NUE40'          : aOel.nue40 := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'NUE100'         : aOel.nue100 := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'RHO15'          : aOel.rho15 := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'FZG_KRAFTSTUFE' : aOel.FZG_Kraftstufe := StrToInt(ExtractWord(3, MySL[MyInt], [' ']));
          end;
          MyInt := MyInt + 1;
        end;
        OilComboBox.AddItem(aOel.Name, aOel);
      end;
      MyInt := MyInt + 1;
    end;
    MySL.Free;
  end;
  if OilComboBox.Items.Count = 0 then
  begin
    aOel := tOel.Create;
    aOel.Name            := 'ISO-VG-220';
    aOel.Art             := 'PAO';
    aOel.nue40           := 220.0;
    aOel.nue100          := 19.0;
    aOel.RHO15           := 0.90;
    aOel.FZG_KRAFTSTUFE  := 12;
    OilComboBox.AddItem(aOel.Name, aOel);
  end;    
  OilComboBox.ItemIndex := 0;
end;

procedure tCylindricalGearset.LoadWstListFromFile;
var
  aStr: string;
  aWst: tWst;
  BufStr: string;
  MyInt: integer;
  MySL: tStringList;
begin
  if not FileExists(STplusWstFile) then
  begin
    BufStr := MyOpenDialog.Title;
    MyOpenDialog.Title := 'Werkstoffdatei öffnen';
    if MessageDlg('Werkstoffdatei nicht gefunden! Datei suchen? {sonst Default}', mtWarning, [mbYes, mbNo], 0) = mrYes then
    if MyOpenDialog.execute then STplusWstFile := MyOpenDialog.Filename;
    MyOpenDialog.Title := BufStr;
  end;
  if FileExists(STplusWstFile) then
  begin
    MyInt := 0;
    MySL := tStringList.Create;
    MySL.LoadFromFile(STplusWstFile);
    while MyInt <= MySL.Count-1 do
    begin
      if PosEx('WERKSTOFFBEZEICHNUNG', UpperCase(MySL[MyInt])) > 0 then
      begin
        aWst := tWst.Create;
        aWst.Name := ExtractWord(3, MySL[MyInt], [' ']);
        MyInt := MyInt + 1;
        while (PosEx('$', UpperCase(MySL[MyInt])) = 0) and (MyInt <= MySL.Count-1) do
        begin
          aStr := ExtractWord(1, MySL[MyInt], [' ']);
          case aStr of
            'Waermebehandlung'     : aWst.HeatTreatment := ExtractWord(3, MySL[MyInt], [' ']);
            'Querkontraktionszahl' : aWst.nue := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'Elastizitaetsmodul'   : aWst.EModul := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'DIN3990/87_Sigma_Hlim': aWst.DIN3990_87_Sigma_Hlim := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'DIN3990/87_Sigma_FE'  : aWst.DIN3990_87_Sigma_FE   := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
            'DIN3990/87_Sigma_Flim': aWst.DIN3990_87_Sigma_Flim := Str2Float(ExtractWord(3, MySL[MyInt], [' ']));
          end;
          MyInt := MyInt + 1;
        end;
        WstComboBox1.AddItem(aWst.Name, aWst);
        WstComboBox2.AddItem(aWst.Name, aWst);
      end;
      MyInt := MyInt + 1;
    end;
    MySL.Free;
  end;
  if WstComboBox1.Items.Count = 0 then
  begin
    aWst := tWst.Create;
    aWst.Name                  := '16MnCr5';
    aWst.HeatTreatment         := 'einsatzgehaertet';
    aWst.nue                   := 0.3;
    aWst.EModul                := 210000.0;
    aWst.DIN3990_87_Sigma_Hlim := 1460.0;
    aWst.DIN3990_87_Sigma_FE   := 860.0;
    aWst.DIN3990_87_Sigma_Flim := 430.0;
    WstComboBox1.AddItem(aWst.Name, aWst);
    WstComboBox2.AddItem(aWst.Name, aWst);
  end;
  WstComboBox1.ItemIndex := 0;
  WstComboBox2.ItemIndex := 0;
end;

end.

