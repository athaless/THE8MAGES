unit SHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Buttons, ComCtrls, AthCircBut;

type
  TFormHelp = class(TForm)
    ScrollBox1: TScrollBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label31: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Label28: TLabel;
    Label32: TLabel;
    Label21: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    Label29: TLabel;
    Image1: TImage;
    Label37: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    PanelTop: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label22: TLabel;
    PanelBotton: TPanel;
    Shape3: TShape;
    Label42: TLabel;
    Label45: TLabel;
    Label48: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    AthCircButton10: TAthCircButton;
    AthCircButton2: TAthCircButton;
    AthCircButton1: TAthCircButton;
    AthCircButton4: TAthCircButton;
    AthCircButton12: TAthCircButton;
    AthCircButton13: TAthCircButton;
    Label43: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo2: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHelp: TFormHelp;

implementation

{$R *.DFM}

procedure TFormHelp.FormResize(Sender: TObject);
begin
if FormHelp.Width<>683 then FormHelp.Width:=683;
end;





















end.
