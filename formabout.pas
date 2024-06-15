unit FormAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    ProgramIcon: TImage;
    ProgramName: TLabel;
    ProgramDescription: TLabel;
    ProgramCopyright: TLabel;
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

end.

