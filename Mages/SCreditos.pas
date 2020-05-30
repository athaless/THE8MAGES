unit SCreditos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TFormCreditos = class(TForm)
    Image1: TImage;
    Label9: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1Click(Sender: TObject);
    procedure CredTimerTimer(Sender: TObject);
  private
  public
  end;

var
  FormCreditos: TFormCreditos;

implementation


{$R *.DFM}

procedure TFormCreditos.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCreditos.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

procedure TFormCreditos.ListBox1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormCreditos.CredTimerTimer(Sender: TObject);
begin
  Close;
end;

end.
