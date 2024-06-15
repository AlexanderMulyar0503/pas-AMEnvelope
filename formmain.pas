unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Spin, FileUtil, Printers, ExtDlgs,
  PrintersDlgs, FormPrintPreview, FormSettings, IniFiles, FormAbout;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonPrint: TButton;
    ButtonPrintPreview: TButton;
    ListImg: TComboBox;
    ListText: TComboBox;
    ImgPreview: TImage;
    MainPrintDialog: TPrintDialog;
    MainOpenPictureDialog: TOpenPictureDialog;
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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListImgChange(Sender: TObject);
    procedure ListTextChange(Sender: TObject);
    procedure MainFormMenuAboutClick(Sender: TObject);
    procedure MainFormMenuAddImgClick(Sender: TObject);
    procedure MainFormMenuAddTextClick(Sender: TObject);
    procedure MainFormMenuExitClick(Sender: TObject);
    procedure MainFormMenuSettingsClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  PrintLineWidth: Double;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  ListImgFind, ListTextFind: TStringList;
  FilesList: String;
  IniFile: TIniFile;
begin
  if not DirectoryExists(GetUserDir + DirectorySeparator + '.amenvelope') then
  begin
    CreateDir(GetUserDir + DirectorySeparator + '.amenvelope');
    CreateDir(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img');
    CreateDir(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text');

    IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
    IniFile.WriteInteger('Position', 'X', 25);
    IniFile.WriteInteger('Position', 'Y', 25);
    IniFile.WriteInteger('Size', 'Width', 700);
    IniFile.WriteInteger('Size', 'Height', 400);
    IniFile.WriteInteger('Print', 'DefaultPrinter', 0);
    IniFile.WriteFloat('Print', 'LineWidth', 0.5);
    IniFile.Free;
  end;

  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  MainForm.Left:= IniFile.ReadInteger('Position', 'X', 25);
  MainForm.Top:= IniFile.ReadInteger('Position', 'Y', 25);
  MainForm.Width:= IniFile.ReadInteger('Size', 'Width', 700);
  MainForm.Height:= IniFile.ReadInteger('Size', 'Height', 400);
  Printer.PrinterIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  PrintLineWidth:= IniFile.ReadFloat('Print','LineWidth', 0.5);
  IniFile.Free;

  ListImgFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator, '*', true);

  for FilesList in ListImgFind do ListImg.Items.Add(ExtractFileName(FilesList));

  ListImgFind.Free;

  ListTextFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator, '*', true);

  for FilesList in ListTextFind do ListText.Items.Add(ExtractFileName(FilesList));

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
      Canvas.Pen.Width:= Round(PrintLineWidth * (sm/10));

      Canvas.Rectangle(3*sm, 2*sm, 18*sm, 2*sm + 3*sm);
      Canvas.Rectangle(3*sm, 5*sm, 18*sm, 15*sm);
      Canvas.Rectangle(3*sm, 15*sm, 18*sm, 24*sm);

      Canvas.Rectangle(1*sm, 5*sm, 3*sm, 15*sm);
      Canvas.Rectangle(18*sm, 5*sm, 20*sm, 15*sm);

      if not (ImgPreview.Picture.Width = 0) then
      begin
        ImgRect:=Rect((3 + ImgMarginLeft.Value)*sm, (5+ImgMarginTop.Value)*sm, (9-ImgMarginLeft.Value)*sm, (5+ImgMarginTop.Value)*sm + Round(((6-ImgMarginLeft.Value*2)*sm)/ImgPicture.Width*ImgPicture.Height));
        Canvas.StretchDraw(ImgRect, ImgPreview.Picture.Bitmap);
      end;

      if not (TextPreview.Picture.Width = 0) then
      begin
        TextRect:=Rect((9+TextMarginLeft.Value)*sm, (5+TextMarginTop.Value)*sm, (18-TextMarginLeft.Value)*sm, (5+TextMarginTop.Value)*sm + Round(((9-TextMarginLeft.Value*2)*sm)/TextPicture.Width*TextPicture.Height));
        Canvas.StretchDraw(TextRect, TextPreview.Picture.Bitmap);
      end;
    finally
      EndDoc;
    end;
  end;
end;

procedure TMainForm.ButtonPrintPreviewClick(Sender: TObject);
begin
  ImgPicture:= ImgPreview.Picture;
  TextPicture:= TextPreview.Picture;

  VleImgMarginTop:= ImgMarginTop.Value;
  VleImgMarginLeft:= ImgMarginLeft.Value;
  VleTextMarginTop:= TextMarginTop.Value;
  VleTextMarginLeft:= TextMarginLeft.Value;

  PrintPreviewForm.ShowModal;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  IniFile: TIniFile;
begin
  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  IniFile.WriteInteger('Position', 'X', MainForm.Left);
  IniFile.WriteInteger('Position', 'Y', MainForm.Top);
  IniFile.WriteInteger('Size', 'Width', MainForm.Width);
  IniFile.WriteInteger('Size', 'Height', MainForm.Height);
  IniFile.Free;
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

procedure TMainForm.MainFormMenuAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
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

    for FilesList in ListTextFind do ListText.Items.Add(ExtractFileName(FilesList));

    ListTextFind.Free;

    ShowMessage('Файлы добавлены');
  end;
end;

procedure TMainForm.MainFormMenuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MainFormMenuSettingsClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  CancelPositionX:= MainForm.Left;
  CancelPositionY:= MainForm.Top;
  CancelSizeWidth:= MainForm.Width;
  CancelSizeHeight:= MainForm.Height;

  SettingsForm.PositionX.Value:= MainForm.Left;
  SettingsForm.PositionY.Value:= MainForm.Top;
  SettingsForm.SizeWidth.Value:= MainForm.Width;
  SettingsForm.SizeHeight.Value:= MainForm.Height;

  SettingsForm.ShowModal;

  IniFile:= TIniFile.Create(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'amenvelope.ini');
  MainForm.Left:= IniFile.ReadInteger('Position', 'X', 25);
  MainForm.Top:= IniFile.ReadInteger('Position', 'Y', 25);
  MainForm.Width:= IniFile.ReadInteger('Size', 'Width', 700);
  MainForm.Height:= IniFile.ReadInteger('Size', 'Height', 400);
  Printer.PrinterIndex:= IniFile.ReadInteger('Print', 'DefaultPrinter', 0);
  PrintLineWidth:= IniFile.ReadFloat('Print', 'LineWidth', 0.5);
  IniFile.Free;
end;

end.

