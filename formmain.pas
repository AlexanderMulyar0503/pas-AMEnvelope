unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Spin, FileUtil, Printers, ExtDlgs,
  PrintersDlgs, FormSettings, IniFiles, FormAbout;

type

  { TMainForm }

  TMainForm = class(TForm)
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
    MainOpenPictureDialog: TOpenPictureDialog;
    MainPrintDialog: TPrintDialog;
    ButtonLeftTopWidth: TButton;
    ButtonPrint: TButton;
    PanelAll: TPanel;
    PanelImg: TPanel;
    ListImg: TComboBox;
    LabelImgMarginTop: TLabel;
    ImgMarginTop: TFloatSpinEdit;
    LabelImgMarginLeft: TLabel;
    ImgMarginLeft: TFloatSpinEdit;
    LabelImgWidth: TLabel;
    ImgWidth: TFloatSpinEdit;
    ImgPreview: TImage;
    ListText: TComboBox;
    LabelTextMarginTop: TLabel;
    TextMarginTop: TFloatSpinEdit;
    LabelTextMarginLeft: TLabel;
    TextMarginLeft: TFloatSpinEdit;
    LabelTextWidth: TLabel;
    TextWidth: TFloatSpinEdit;
    TextPreview: TImage;
    PanelAllSplitter1: TSplitter;
    PanelPrintPreview: TPanel;
    PrintPreview: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ButtonLeftTopWidthClick(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure LeftTopWidthChange(Sender: TObject);
    procedure ListImgChange(Sender: TObject);
    procedure ListTextChange(Sender: TObject);
    procedure MainFormMenuAddImgClick(Sender: TObject);
    procedure MainFormMenuAddTextClick(Sender: TObject);
    procedure MainFormMenuSettingsClick(Sender: TObject);
    procedure MainFormMenuExitClick(Sender: TObject);
    procedure MainFormMenuAboutClick(Sender: TObject);
    procedure PaintPrintPreview;
  private

  public

  end;

var
  MainForm: TMainForm;
  PrintLineWidth: Double;

implementation

{$R *.lfm}

procedure TMainForm.PaintPrintPreview;
var
  sm: Integer;
  ImgRect, TextRect: TRect;
  VleImgMrgTop, VleImgMrgLeft, VleImgWidth: Integer;
  VleTextMrgTop, VleTextMrgLeft, VleTextWidth: Integer;
begin
  PrintPreview.Picture.Clear;
  PrintPreview.Picture.Bitmap.Width:= 2100;
  PrintPreview.Picture.Bitmap.Height:= 2970;

  PrintPreview.Picture.Bitmap.Canvas.Brush.Color:= clWhite;
  PrintPreview.Picture.Bitmap.Canvas.FillRect(0, 0, PrintPreview.Picture.Bitmap.Width, PrintPreview.Picture.Bitmap.Height);

  sm:= Round(PrintPreview.Picture.Bitmap.Width / 21);

  PrintPreview.Picture.Bitmap.Canvas.Pen.Color:= clBlack;
  PrintPreview.Picture.Bitmap.Canvas.Pen.Width:= Round(PrintLineWidth * (sm/5));

  PrintPreview.Picture.Bitmap.Canvas.Rectangle(3*sm, 2*sm, 18*sm, 2*sm + 3*sm);
  PrintPreview.Picture.Bitmap.Canvas.Rectangle(3*sm, 5*sm, 18*sm, 15*sm);
  PrintPreview.Picture.Bitmap.Canvas.Rectangle(3*sm, 15*sm, 18*sm, 24*sm);

  PrintPreview.Picture.Bitmap.Canvas.Rectangle(1*sm, 5*sm, 3*sm, 15*sm);
  PrintPreview.Picture.Bitmap.Canvas.Rectangle(18*sm, 5*sm, 20*sm, 15*sm);

  VleImgMrgTop:= Round((5 + ImgMarginTop.Value) * sm);
  VleImgMrgLeft:= Round((3 + ImgMarginLeft.Value) * sm);
  VleImgWidth:= Round(ImgWidth.Value * sm);

  VleTextMrgTop:= Round((5 + TextMarginTop.Value) * sm);
  VleTextMrgLeft:= Round((3 + TextMarginLeft.Value) * sm);
  VleTextWidth:= Round(TextWidth.Value * sm);

  if not (ImgPreview.Picture.Width = 0) then
  begin
    ImgRect:=Rect(VleImgMrgLeft, VleImgMrgTop, VleImgMrgLeft + VleImgWidth, VleImgMrgTop + Round(VleImgWidth / ImgPreview.Picture.Width * ImgPreview.Picture.Height));
    PrintPreview.Picture.Bitmap.Canvas.StretchDraw(ImgRect, ImgPreview.Picture.Bitmap);
  end;

  if not (TextPreview.Picture.Width = 0) then
  begin
    TextRect:=Rect(VleTextMrgLeft, VleTextMrgTop, VleTextMrgLeft + VleTextWidth, VleTextMrgTop + Round(VleTextWidth / TextPreview.Picture.Width * TextPreview.Picture.Height));
    PrintPreview.Picture.Bitmap.Canvas.StretchDraw(TextRect, TextPreview.Picture.Bitmap);
  end;
end;


{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  ListImgFind, ListTextFind: TStringList;
  FilesList: String;
begin
  MainForm.Left:= IniFile.ReadInteger('Position', 'X', 25);
  MainForm.Top:= IniFile.ReadInteger('Position', 'Y', 25);
  MainForm.Width:= IniFile.ReadInteger('Size', 'Width', 700);
  MainForm.Height:= IniFile.ReadInteger('Size', 'Height', 400);
  Printer.PrinterIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  PrintLineWidth:= IniFile.ReadFloat('Print','LineWidth', 0.5);

  ListImgFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator, '*', true);
  ListImgFind.Sort;
  for FilesList in ListImgFind do ListImg.Items.Add(ExtractFileName(FilesList));
  ListImgFind.Free;

  ListTextFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator, '*', true);
  ListTextFind.Sort;
  for FilesList in ListTextFind do ListText.Items.Add(ExtractFileName(FilesList));
  ListTextFind.Free;

  PaintPrintPreview;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  IniFile.WriteInteger('Position', 'X', MainForm.Left);
  IniFile.WriteInteger('Position', 'Y', MainForm.Top);
  IniFile.WriteInteger('Size', 'Width', MainForm.Width);
  IniFile.WriteInteger('Size', 'Height', MainForm.Height);
end;

procedure TMainForm.ButtonLeftTopWidthClick(Sender: TObject);
begin
  ImgMarginTop.Value:= 2;
  ImgMarginLeft.Value:= 1;
  ImgWidth.Value:= 4;

  TextMarginTop.Value:= 2;
  TextMarginLeft.Value:= 7;
  TextWidth.Value:= 7;
end;

procedure TMainForm.ButtonPrintClick(Sender: TObject);
var
  sm: Integer;
  ImgRect, TextRect: TRect;
  VleImgMrgTop, VleImgMrgLeft, VleImgWidth: Integer;
  VleTextMrgTop, VleTextMrgLeft, VleTextWidth: Integer;
begin
  if MainPrintDialog.Execute then
  begin
    with Printer do
    try
      BeginDoc;
      sm:= Round(PageWidth / 21);

      Canvas.Pen.Color:= clBlack;
      Canvas.Pen.Width:= Round(PrintLineWidth * (sm/10));

      Canvas.Rectangle(3*sm, 2*sm, 18*sm, 2*sm + 3*sm);
      Canvas.Rectangle(3*sm, 5*sm, 18*sm, 15*sm);
      Canvas.Rectangle(3*sm, 15*sm, 18*sm, 24*sm);

      Canvas.Rectangle(1*sm, 5*sm, 3*sm, 15*sm);
      Canvas.Rectangle(18*sm, 5*sm, 20*sm, 15*sm);

      VleImgMrgTop:= Round((5 + ImgMarginTop.Value) * sm);
      VleImgMrgLeft:= Round((3 + ImgMarginLeft.Value) * sm);
      VleImgWidth:= Round(ImgWidth.Value * sm);

      VleTextMrgTop:= Round((5 + TextMarginTop.Value) * sm);
      VleTextMrgLeft:= Round((3 + TextMarginLeft.Value) * sm);
      VleTextWidth:= Round(TextWidth.Value * sm);

      if not (ImgPreview.Picture.Width = 0) then
      begin
        ImgRect:=Rect(VleImgMrgLeft, VleImgMrgTop, VleImgMrgLeft + VleImgWidth, VleImgMrgTop + Round(VleImgWidth / ImgPreview.Picture.Width * ImgPreview.Picture.Height));
        Canvas.StretchDraw(ImgRect, ImgPreview.Picture.Bitmap);
      end;

      if not (TextPreview.Picture.Width = 0) then
      begin
        TextRect:=Rect(VleTextMrgLeft, VleTextMrgTop, VleTextMrgLeft + VleTextWidth, VleTextMrgTop + Round(VleTextWidth / TextPreview.Picture.Width * TextPreview.Picture.Height));
        Canvas.StretchDraw(TextRect, TextPreview.Picture.Bitmap);
      end;
    finally
      EndDoc;
    end;
  end;
end;

procedure TMainForm.LeftTopWidthChange(Sender: TObject);
begin
  PaintPrintPreview;
end;

procedure TMainForm.ListImgChange(Sender: TObject);
begin
  if ListImg.ItemIndex = 0 then ImgPreview.Picture.Clear
  else ImgPreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator + ListImg.Text);

  PaintPrintPreview;
end;

procedure TMainForm.ListTextChange(Sender: TObject);
begin
  if ListText.ItemIndex = 0 then TextPreview.Picture.Clear
  else TextPreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + ListText.Text);

  PaintPrintPreview;
end;

procedure TMainForm.MainFormMenuAddImgClick(Sender: TObject);
var
  ListImgFind: TStringList;
  FilesList: String;
begin
  if MainOpenPictureDialog.Execute then
  begin
    ListImg.Items.Clear;
    ListImg.Items.Add('Нет картинки');
    ListImg.ItemIndex:= 0;

    for FilesList in MainOpenPictureDialog.Files do CopyFile(FilesList, GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator + ExtractFileName(FilesList));

    ListImgFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator, '*', true);
    ListImgFind.Sort;
    for FilesList in ListImgFind do ListImg.Items.Add(ExtractFileName(FilesList));
    ListImgFind.Free;

    ShowMessage('Файлы добавлены');
  end;
end;

procedure TMainForm.MainFormMenuAddTextClick(Sender: TObject);
var
  ListTextFind: TStringList;
  FilesList: String;
begin
  if MainOpenPictureDialog.Execute then
  begin
    ListText.Items.Clear;
    ListText.Items.Add('Нет текста');
    ListText.ItemIndex:= 0;

    for FilesList in MainOpenPictureDialog.Files do CopyFile(FilesList, GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + ExtractFileName(FilesList));

    ListTextFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator, '*', true);
    ListTextFind.Sort;
    for FilesList in ListTextFind do ListText.Items.Add(ExtractFileName(FilesList));
    ListTextFind.Free;

    ShowMessage('Файлы добавлены');
  end;
end;

procedure TMainForm.MainFormMenuSettingsClick(Sender: TObject);
begin
  IniFile.WriteInteger('Position', 'X', MainForm.Left);
  IniFile.WriteInteger('Position', 'Y', MainForm.Top);
  IniFile.WriteInteger('Size', 'Width', MainForm.Width);
  IniFile.WriteInteger('Size', 'Height', MainForm.Height);

  SettingsForm.ShowModal;

  MainForm.Left:= IniFile.ReadInteger('Position', 'X', 25);
  MainForm.Top:= IniFile.ReadInteger('Position', 'Y', 25);
  MainForm.Width:= IniFile.ReadInteger('Size', 'Width', 700);
  MainForm.Height:= IniFile.ReadInteger('Size', 'Height', 400);
  Printer.PrinterIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  PrintLineWidth:= IniFile.ReadFloat('Print', 'LineWidth', 0.5);
end;

procedure TMainForm.MainFormMenuExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.MainFormMenuAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.

