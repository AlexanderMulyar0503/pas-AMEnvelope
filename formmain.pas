unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  PairSplitter, ExtCtrls, ComCtrls, Spin, FileUtil;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonPrint: TButton;
    ButtonPrintPreview: TButton;
    ListImg: TComboBox;
    ListText: TComboBox;
    ImgPreview: TImage;
    TextPreview: TImage;
    LabelImgMarginTop: TLabel;
    LabelImgMarginLeft: TLabel;
    LabelTextMarginTop: TLabel;
    LabelTextMarginLeft: TLabel;
    MainFormMenu: TMainMenu;
    MainFormMenuFile: TMenuItem;
    MainFormMenuAddImg: TMenuItem;
    MainFormMenuAddText: TMenuItem;
    MainFormMenuSep1: TMenuItem;
    MainFormMenuSettings: TMenuItem;
    MainFormMenuSep2: TMenuItem;
    MainFormMenuExit: TMenuItem;
    MainFormMenuHelp: TMenuItem;
    MainFormMenuAbout: TMenuItem;
    PanelAll: TPanel;
    PanelImg: TPanel;
    PanelText: TPanel;
    ImgMarginTop: TSpinEdit;
    ImgMarginLeft: TSpinEdit;
    TextMarginTop: TSpinEdit;
    TextMarginLeft: TSpinEdit;
    PanelAllSplitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure ListImgChange(Sender: TObject);
    procedure ListTextChange(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
  ListImgFind, ListTextFind: TStringList;
begin
  ListImgFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator, '*.png', true);
  for i:= 0 to ListImgFind.Count - 1 do
  begin
    ListImg.Items.Add(ExtractFileName(ListImgFind[i]));
  end;
  ListImgFind.Free;

  ListTextFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator, '*.png', true);
  for i:= 0 to ListTextFind.Count - 1 do
  begin
    ListText.Items.Add(ExtractFileName(ListTextFind[i]));
  end;
  ListTextFind.Free;
end;

procedure TMainForm.ListImgChange(Sender: TObject);
begin
  if ListImg.ItemIndex = 0 then ImgPreview.Picture.Clear
  else ImgPreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator + ListImg.Text);
end;

procedure TMainForm.ListTextChange(Sender: TObject);
begin
  if ListText.ItemIndex = 0 then TextPreview.Picture.Clear
  else TextPreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + ListText.Text);
end;

end.

