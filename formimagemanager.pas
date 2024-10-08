unit FormImageManager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  ExtCtrls, ExtDlgs, FileUtil, LCLType;

type

  { TImageManagerForm }

  TImageManagerForm = class(TForm)
    PanelFiles: TPanel;
    RbtnImages: TRadioButton;
    RbtnTexts: TRadioButton;
    FileList: TCheckListBox;
    ButtonAdd: TButton;
    ButtonDelete: TButton;
    FileName: TEdit;
    ButtonRename: TButton;
    ImagePreview: TImage;
    Splitter1: TSplitter;
    PanelTextImg: TPanel;
    YourText: TMemo;
    ButtonFont: TButton;
    ImageTextPreview: TImage;
    TextFileName: TEdit;
    ButtonSaveText: TButton;
    ManagerFontDialog: TFontDialog;
    ManagerOpenPictureDialog: TOpenPictureDialog;
    procedure FormShow(Sender: TObject);
    procedure RbtnImagesTextsChange(Sender: TObject);
    procedure FileListClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonRenameClick(Sender: TObject);
    procedure YourTextChange(Sender: TObject);
    procedure ButtonFontClick(Sender: TObject);
    procedure ButtonSaveTextClick(Sender: TObject);
    procedure FindFiles;
    procedure PaintYourText;
  private

  public

  end;

  procedure AddFiles(ImgType: Byte);

var
  ImageManagerForm: TImageManagerForm;

implementation

{$R *.lfm}

{ TImageManagerForm }

procedure TImageManagerForm.FormShow(Sender: TObject);
begin
  RbtnImages.Checked:= True;
  FindFiles;
end;

procedure TImageManagerForm.RbtnImagesTextsChange(Sender: TObject);
begin
  FindFiles;
end;

procedure TImageManagerForm.FileListClick(Sender: TObject);
begin
  if (RbtnImages.Checked) and (FileList.ItemIndex > -1) then
    ImagePreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator + FileList.Items[FileList.ItemIndex])
  else if (RbtnTexts.Checked) and (FileList.ItemIndex > -1) then
    ImagePreview.Picture.LoadFromFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + FileList.Items[FileList.ItemIndex]);

  if FileList.ItemIndex > -1 then
    FileName.Text:= FileList.Items[FileList.ItemIndex];
end;

procedure TImageManagerForm.ButtonAddClick(Sender: TObject);
begin
  if ManagerOpenPictureDialog.Execute then
  begin
    if RbtnImages.Checked then
      AddFiles(0)
    else
      AddFiles(1);
  end;

  FindFiles;
end;

procedure TImageManagerForm.ButtonDeleteClick(Sender: TObject);
var
  i, FileListCount: Integer;
begin
  if Application.MessageBox('Вы действительно хотите удалить выбранные изображения?', 'Удаление', MB_ICONWARNING + MB_YESNO) = IDYES then
  begin
    i:= 0;
    FileListCount:= FileList.Items.Count;

    while i < FileListCount do
    begin
      if RbtnImages.Checked then
      begin
        if FileList.Checked[i] then
          DeleteFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator + FileList.Items[i]);

        FileListCount:= FileList.Items.Count;
      end
      else begin
        if FileList.Checked[i] then
          DeleteFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + FileList.Items[i]);

        FileListCount:= FileList.Items.Count;
      end;

      i:= i + 1;
    end;
  end;

  FindFiles;
end;

procedure TImageManagerForm.ButtonRenameClick(Sender: TObject);
var
  ChCount, i: Integer;
  RootPath: String;
begin
  ChCount:= 0;
  for i:= 0 to FileList.Items.Count - 1 do
  begin
    if FileList.Checked[i] then ChCount:= ChCount + 1;
  end;

  if RbtnImages.Checked then
    RootPath:= GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator
  else
    RootPath:= GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator;

  if (ChCount = 1) and not (FileName.Text = '') then
  begin
    for i:= 0 to FileList.Items.Count - 1 do
    begin
      if FileList.Checked[i] then
        RenameFile(RootPath + FileList.Items[i], RootPath + FileName.Text);

      Break;
    end;
  end
  else
    ShowMessage('Переименование не выполнено');

  FindFiles;
end;

procedure TImageManagerForm.YourTextChange(Sender: TObject);
begin
  PaintYourText;
end;

procedure TImageManagerForm.ButtonFontClick(Sender: TObject);
begin
  if ManagerFontDialog.Execute then
  begin
    ImageTextPreview.Picture.Bitmap.Canvas.Font.Name:= ManagerFontDialog.Font.Name;
    ImageTextPreview.Picture.Bitmap.Canvas.Font.Size:= ManagerFontDialog.Font.Size;
    ImageTextPreview.Picture.Bitmap.Canvas.Font.Bold:= ManagerFontDialog.Font.Bold;
    ImageTextPreview.Picture.Bitmap.Canvas.Font.Italic:= ManagerFontDialog.Font.Italic;
  end;

  PaintYourText;
end;

procedure TImageManagerForm.ButtonSaveTextClick(Sender: TObject);
begin
  if not (TextFileName.Text = '') then
    ImageTextPreview.Picture.PNG.SaveToFile(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator + TextFileName.Text + '.png')
  else
    ShowMessage('Не указано имя файла');

  FindFiles;
end;

procedure TImageManagerForm.FindFiles;
var
  FilesListFind: TStringList;
  FilesList: String;
begin
  FileList.Items.Clear;

  if RbtnImages.Checked then
    FilesListFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator, '*', true)
  else
    FilesListFind:= FindAllFiles(GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator, '*', true);

  FilesListFind.Sort;
  for FilesList in FilesListFind do FileList.Items.Add(ExtractFileName(FilesList));
  FilesListFind.Free;
end;

procedure TImageManagerForm.PaintYourText;
var
  MaxWidth, MaxHeight, MarginTop, i: Integer;
begin
  MaxWidth:= 0;
  MaxHeight:= 0;
  MarginTop:= 0;

  for i:= 0 to YourText.Lines.Count - 1 do
  begin
    if ImageTextPreview.Picture.Bitmap.Canvas.TextWidth(YourText.Lines[i]) > MaxWidth then
      MaxWidth:= ImageTextPreview.Picture.Bitmap.Canvas.TextWidth(YourText.Lines[i]);

    MaxHeight:= MaxHeight + ImageTextPreview.Picture.Bitmap.Canvas.TextHeight('I');
  end;

  ImageTextPreview.Picture.Clear;
  ImageTextPreview.Picture.Bitmap.Width:= MaxWidth;
  ImageTextPreview.Picture.Bitmap.Height:= MaxHeight;
  ImageTextPreview.Picture.Bitmap.Canvas.FillRect(0, 0, MaxWidth, MaxHeight);

  for i:= 0 to YourText.Lines.Count - 1 do
  begin
    ImageTextPreview.Picture.Bitmap.Canvas.TextOut(0, MarginTop, YourText.Lines[i]);
    MarginTop:= MarginTop + ImageTextPreview.Picture.Bitmap.Canvas.TextHeight('I');
  end;
end;


procedure AddFiles(ImgType: Byte);
var
  FilesList, FilesPath: String;
begin
  if ImgType = 0 then
    FilesPath:= GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'img' + DirectorySeparator
  else
    FilesPath:= GetUserDir + DirectorySeparator + '.amenvelope' + DirectorySeparator + 'text' + DirectorySeparator;

  for FilesList in ImageManagerForm.ManagerOpenPictureDialog.Files do
    CopyFile(FilesList, FilesPath + ExtractFileName(FilesList));
end;

end.

