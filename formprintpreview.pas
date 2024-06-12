unit FormPrintPreview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TPrintPreviewForm }

  TPrintPreviewForm = class(TForm)
    PrintPreviewImg: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  PrintPreviewForm: TPrintPreviewForm;

  ImgPicture, TextPicture: TPicture;
  ImgPictureRect, TextPictureRect: TRect;

  VleImgMarginTop, VleImgMarginLeft: Integer;
  VleTextMarginTop, VleTextMarginLeft: Integer;

implementation

{$R *.lfm}

{ TPrintPreviewForm }

procedure TPrintPreviewForm.FormCreate(Sender: TObject);
begin
end;

procedure TPrintPreviewForm.FormShow(Sender: TObject);
var
  sm: Integer;
begin
  PrintPreviewImg.Picture.Bitmap.Width:= 2100;
  PrintPreviewImg.Picture.Bitmap.Height:= 2970;

  PrintPreviewImg.Picture.Bitmap.Canvas.Brush.Color:= clWhite;
  PrintPreviewImg.Picture.Bitmap.Canvas.FillRect(0, 0, PrintPreviewImg.Picture.Bitmap.Width, PrintPreviewImg.Picture.Bitmap.Height);

  sm:= Round(PrintPreviewImg.Picture.Bitmap.Width / 21);

  PrintPreviewImg.Picture.Bitmap.Canvas.Pen.Width:= Round(sm/20);

  PrintPreviewImg.Picture.Bitmap.Canvas.Rectangle(3*sm, 2*sm, 18*sm, 2*sm + 3*sm);
  PrintPreviewImg.Picture.Bitmap.Canvas.Rectangle(3*sm, 5*sm, 18*sm, 15*sm);
  PrintPreviewImg.Picture.Bitmap.Canvas.Rectangle(3*sm, 15*sm, 18*sm, 24*sm);

  PrintPreviewImg.Picture.Bitmap.Canvas.Rectangle(1*sm, 5*sm, 3*sm, 15*sm);
  PrintPreviewImg.Picture.Bitmap.Canvas.Rectangle(18*sm, 5*sm, 20*sm, 15*sm);

  if not (ImgPicture.Width = 0) then
  begin
    ImgPictureRect:=Rect((3 + VleImgMarginLeft)*sm, (5+VleImgMarginTop)*sm, (9-VleImgMarginLeft)*sm, (5+VleImgMarginTop)*sm + Round(((6-VleImgMarginLeft*2)*sm)/ImgPicture.Width*ImgPicture.Height));
    PrintPreviewImg.Picture.Bitmap.Canvas.StretchDraw(ImgPictureRect, ImgPicture.Bitmap);
  end;

  if not (TextPicture.Width = 0) then
  begin
    TextPictureRect:=Rect((9+VleTextMarginLeft)*sm, (5+VleTextMarginTop)*sm, (18-VleTextMarginLeft)*sm, (5+VleTextMarginTop)*sm + Round(((9-VleTextMarginLeft*2)*sm)/TextPicture.Width*TextPicture.Height));
    PrintPreviewImg.Picture.Bitmap.Canvas.StretchDraw(TextPictureRect, TextPicture.Bitmap);
  end;
end;

end.

