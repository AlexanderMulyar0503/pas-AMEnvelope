unit FormSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, IniFiles, Printers;

type

  { TSettingsForm }

  TSettingsForm = class(TForm)
    ButtonDefault: TButton;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    SetDefaultPrinter: TComboBox;
    WidthLine: TFloatSpinEdit;
    PrintSettingsGroup: TGroupBox;
    LabelSetDefaultPrinter: TLabel;
    LabelWidthLine: TLabel;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonDefaultClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  SettingsForm: TSettingsForm;
  IniFile: TIniFile;


implementation

{$R *.lfm}

{ TSettingsForm }

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  SetDefaultPrinter.Items:= Printer.Printers;

  SetDefaultPrinter.ItemIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  WidthLine.Value:= IniFile.ReadFloat('Print', 'LineWidth', 0.5);
end;

procedure TSettingsForm.ButtonDefaultClick(Sender: TObject);
begin
  IniFile.WriteInteger('Position', 'X', 25);
  IniFile.WriteInteger('Position', 'Y', 25);
  IniFile.WriteInteger('Size', 'Width', 800);
  IniFile.WriteInteger('Size', 'Height', 640);
  IniFile.WriteInteger('Print', 'DefaultPrinter', 0);
  IniFile.WriteFloat('Print', 'LineWidth', 0.5);
  SettingsForm.Close;
end;

procedure TSettingsForm.ButtonCancelClick(Sender: TObject);
begin
  SettingsForm.Close;
end;

procedure TSettingsForm.ButtonOKClick(Sender: TObject);
begin
  IniFile.WriteInteger('Print', 'DefaultPrinter', SetDefaultPrinter.ItemIndex);
  IniFile.WriteFloat('Print', 'LineWidth', WidthLine.Value);
  SettingsForm.Close;
end;


initialization

if not DirectoryExists(GetUserDir + DirectorySeparator + '.amenvelope') then
begin
  CreateDir(GetUserDir + DirectorySeparator + '.amenvelope');
end;

if not DirectoryExists(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img') then
  CreateDir(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img');

if not DirectoryExists(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text') then
  CreateDir(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text');

if not FileExists(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini') then
begin
  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  IniFile.WriteInteger('Position', 'X', 25);
  IniFile.WriteInteger('Position', 'Y', 25);
  IniFile.WriteInteger('Size', 'Width', 800);
  IniFile.WriteInteger('Size', 'Height', 640);
  IniFile.WriteInteger('Print', 'DefaultPrinter', 0);
  IniFile.WriteFloat('Print', 'LineWidth', 0.5);
  IniFile.Free;
end;

IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');


finalization

IniFile.Free;


end.

