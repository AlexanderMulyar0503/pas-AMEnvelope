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
    FormPositionGroup: TGroupBox;
    FormSizeGroup: TGroupBox;
    PrintSettingsGroup: TGroupBox;
    LabelPositionX: TLabel;
    LabelPositionY: TLabel;
    LabelSizeWidth: TLabel;
    LabelSizeHeight: TLabel;
    LabelSetDefaultPrinter: TLabel;
    LabelWidthLine: TLabel;
    PositionX: TSpinEdit;
    PositionY: TSpinEdit;
    SizeWidth: TSpinEdit;
    SizeHeight: TSpinEdit;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonDefaultClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  SettingsForm: TSettingsForm;

  CancelPositionX, CancelPositionY: Integer;
  CancelSizeWidth, CancelSizeHeight: Integer;

implementation

{$R *.lfm}

{ TSettingsForm }

procedure TSettingsForm.FormShow(Sender: TObject);
var
  IniFile: TIniFile;
begin
  SetDefaultPrinter.Items:= Printer.Printers;

  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  SetDefaultPrinter.ItemIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  WidthLine.Value:= IniFile.ReadFloat('Print', 'LineWidth', 0.5);
  IniFile.Free;
end;

procedure TSettingsForm.ButtonDefaultClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  IniFile.WriteInteger('Position', 'X', 25);
  IniFile.WriteInteger('Position', 'Y', 25);
  IniFile.WriteInteger('Size', 'Width', 700);
  IniFile.WriteInteger('Size', 'Height', 400);
  IniFile.WriteInteger('Print', 'DefaultPrinter', 0);
  IniFile.WriteFloat('Print', 'LineWidth', 0.5);
  IniFile.Free;
  Close;
end;

procedure TSettingsForm.ButtonCancelClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  IniFile.WriteInteger('Position', 'X', CancelPositionX);
  IniFile.WriteInteger('Position', 'Y', CancelPositionY);
  IniFile.WriteInteger('Size', 'Width', CancelSizeWidth);
  IniFile.WriteInteger('Size', 'Height', CancelSizeHeight);
  IniFile.Free;
  Close;
end;

procedure TSettingsForm.ButtonOKClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  IniFile.WriteInteger('Position', 'X', PositionX.Value);
  IniFile.WriteInteger('Position', 'Y', PositionY.Value);
  IniFile.WriteInteger('Size', 'Width', SizeWidth.Value);
  IniFile.WriteInteger('Size', 'Height', SizeHeight.Value);
  IniFile.WriteInteger('Print', 'DefaultPrinter', SetDefaultPrinter.ItemIndex);
  IniFile.WriteFloat('Print', 'LineWidth', WidthLine.Value);
  IniFile.Free;
  Close;
end;

end.

