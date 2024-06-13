unit FormSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin;

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
    PanelWidthGroup: TGroupBox;
    PrintSettingsGroup: TGroupBox;
    LabelPositionX: TLabel;
    LabelPositionY: TLabel;
    LabelSizeWidth: TLabel;
    LabelSizeHeight: TLabel;
    LabelWidthPanelImg: TLabel;
    LabelWidthPanelText: TLabel;
    LabelSetDefaultPrinter: TLabel;
    LabelWidthLine: TLabel;
    PositionX: TSpinEdit;
    PositionY: TSpinEdit;
    SizeWidth: TSpinEdit;
    SizeHeight: TSpinEdit;
    WidthPanelImg: TSpinEdit;
    WidthPanelText: TSpinEdit;
  private

  public

  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.lfm}

end.

