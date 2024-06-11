unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  PairSplitter, ExtCtrls, ComCtrls, Spin, FileUtil, Printers, PrintersDlgs, FormPrintPreview;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonPrint: TButton;
    ButtonPrintPreview: TButton;
    ListImg: TComboBox;
    ListText: TComboBox;
    ImgPreview: TImage;
    MainPrintDialog: TPrintDialog;
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
    procedure ButtonPrintClick(Sender: TObject);
    procedure ButtonPrintPreviewClick(Sender: TObject);
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

procedure TMainForm.ButtonPrintClick(Sender: TObject);
var
  sm: Integer;
  ImgRect, TextRect: TRect;
begin
  if MainPrintDialog.Execute then
  begin
    with Printer do
    try
      BeginDoc;
      sm:= Round(PageWidth / 21);

      Canvas.Pen.Color:= clBlack;
      Canvas.Pen.Width:= Round(sm/40);

      Canvas.Rectangle(3*sm, 2*sm, 18*sm, 2*sm + 3*sm);
      Canvas.Rectangle(3*sm, 5*sm, 18*sm, 15*sm);
      Canvas.Rectangle(3*sm, 15*sm, 18*sm, 24*sm);

      Canvas.Rectangle(1*sm, 5*sm, 3*sm, 15*sm);
      Canvas.Rectangle(18*sm, 5*sm, 20*sm, 15*sm);

      ImgRect:=Rect(4*sm, 7*sm, 8*sm, 7*sm + Round(4*sm/ImgPreview.Picture.Width*ImgPreview.Picture.Height));
      Canvas.StretchDraw(ImgRect, ImgPreview.Picture.Bitmap);
      TextRect:=Rect(10*sm, 7*sm, 17*sm, 7*sm + Round(7*sm/TextPreview.Picture.Width*TextPreview.Picture.Height));
      Canvas.StretchDraw(TextRect, TextPreview.Picture.Bitmap);
    finally
      EndDoc;
    end;
  end;
end;

procedure TMainForm.ButtonPrintPreviewClick(Sender: TObject);
begin
  ImgPicture:= ImgPreview.Picture;
  TextPicture:= TextPreview.Picture;

  PrintPreviewForm.ShowModal;
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

