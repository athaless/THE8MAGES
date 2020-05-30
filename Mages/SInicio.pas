unit SInicio;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TFormInicio = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Bevel1: TBevel;
    Label6: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInicio: TFormInicio;

implementation

{$R *.DFM}

procedure TFormInicio.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 Close;
end;


end.
