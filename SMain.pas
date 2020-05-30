unit SMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons, AthCircBut,Mmsystem;

type
  TPtrPontoInt = ^TPontoInt;
  TPontoInt = record
                x,y:integer;
              end;

  TSentido = (NORTE,NORDESTE,LESTE,SUDESTE,SUL,SUDOESTE,OESTE,NOROESTE);

  TControl = record
               PosTela  : TPontoInt;
               PtrImage : TImage;
               Sentido  : TSentido;
             end;

  TChess = record
              PosTela  : TPontoInt;
              Ocupado  : Boolean;
              Bloqueado: Boolean;
              Ocupante : TImage;
           end;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    Mage02: TImage;
    Mage07: TImage;
    Mage08: TImage;
    Mage06: TImage;
    Mage03: TImage;
    Mage05: TImage;
    Mage04: TImage;
    Mage01: TImage;
    TreeView: TTreeView;
    ImageListSentidos: TImageList;
    ImageMap: TImage;
    MainMenu1: TMainMenu;
    Visualizar1: TMenuItem;
    Arquivo1: TMenuItem;
    MenuTabuleiro: TMenuItem;
    MenuAnimacao: TMenuItem;
    MenuHelp: TMenuItem;
    MenuOQue: TMenuItem;
    MenuCreditos: TMenuItem;
    MenuNovaBusca: TMenuItem;
    N1: TMenuItem;
    MenuBuscaHeuristica: TMenuItem;
    MenuBuscaExaustiva: TMenuItem;
    MenuFecharPrograma: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MenuCorDesocupado: TMenuItem;
    MenuCorOcupado: TMenuItem;
    MenuBloqueado: TMenuItem;
    ColorDialog: TColorDialog;
    ImageListTree: TImageList;
    MenuMostraResultado: TMenuItem;
    N4: TMenuItem;
    MenuGerarArvore: TMenuItem;
    Panel3: TPanel;
    AthCircButton1: TAthCircButton;
    AthCircButton2: TAthCircButton;
    AthCircButton3: TAthCircButton;
    AthCircButton4: TAthCircButton;
    AthCircButton12: TAthCircButton;
    AthCircButton13: TAthCircButton;
    MenuBuscaVertical: TMenuItem;
    N5: TMenuItem;
    MenuBuscaHorizontal: TMenuItem;
    MenuImagemdeFundo: TMenuItem;
    procedure Breshan(inic,fim:TPontoInt; Mage:TImage);
    procedure FormShow(Sender: TObject);
     function TestaDir(inic,fim:TPontoInt):TSentido;
    procedure ChangeMage(ind:TSentido; AuxImage:TCanvas);
    procedure ImageMapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Mage06MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuTabuleiroClick(Sender: TObject);
    procedure ShowTabuleiro;
    procedure MenuFecharProgramaClick(Sender: TObject);
    procedure InicializaTabuleiro;
    procedure BloqueiaCaminhos(ax,ay:Integer);
    procedure VerificaPosInTab(x,y:integer);
    procedure MenuAnimacaoClick(Sender: TObject);
    procedure MenuNovaBuscaClick(Sender: TObject);
    procedure MenuCorDesocupadoClick(Sender: TObject);
    procedure MenuCorOcupadoClick(Sender: TObject);
    procedure MenuBloqueadoClick(Sender: TObject);
    procedure MenuOQueClick(Sender: TObject);
    procedure MenuCreditosClick(Sender: TObject);
    procedure MenuGerarArvoreClick(Sender: TObject);
    procedure MenuBuscaExaustivaClick(Sender: TObject);
    procedure MenuBuscaHeuristicaClick(Sender: TObject);
    procedure MontaArvore;
    procedure MontaArvoreHeuristica;
    procedure MontaArvoreExaustiva;
    procedure TreeViewDeletion(Sender: TObject; Node: TTreeNode);
    procedure MenuMostraResultadoClick(Sender: TObject);
    procedure PosicionaMagos;
    procedure MenuBuscaVerticalClick(Sender: TObject);
    procedure MenuBuscaHorizontalClick(Sender: TObject);
    procedure MenuImagemdeFundoClick(Sender: TObject);
  private
    UltSel        : Integer;
    VetMages      : array[1..8]of TControl;
    Tabuleiro     : array[1..8,1..8] of TChess;
    CorOCUPADO    : TColor;
    CorBLOQUEADO  : TColor;
    CorDESOCUPADO : TColor;
  public

  end;

var
  FormMain: TFormMain;

implementation

uses SInicio, SHelp, SCreditos;

{$R *.DFM}

function PontoInt(x,y:integer):TPontoInt;
begin
 PontoInt.x:=x; PontoInt.y:=y;
end;

function DIVIDE(A,B:real):real;
begin
 if b<>0 then Divide:=(A/B) else  Divide:=0;
end;

function QuaseIgual(a,b,intervalo:real):boolean;
var aux:real;
begin
 QuaseIgual:=False;
 aux := abs(a-b);
 if ( aux < intervalo ) then  QuaseIgual:=True;
end;

procedure TFormMain.FormShow(Sender: TObject);
var i:integer;
begin
  FormInicio.ShowModal;

  CorOCUPADO    := clBlue;
  CorBLOQUEADO  := clRed;
  CorDESOCUPADO := clYellow;
  ImageMap.Picture.SaveToFile('Buffer.bmp');

  UltSel:=-1;
  VetMages[1].PtrImage:=Mage01;  VetMages[5].PtrImage:=Mage05;
  VetMages[2].PtrImage:=Mage02;  VetMages[6].PtrImage:=Mage06;
  VetMages[3].PtrImage:=Mage03;  VetMages[7].PtrImage:=Mage07;
  VetMages[4].PtrImage:=Mage04;  VetMages[8].PtrImage:=Mage08;
  for i:=1 to 8 do
     begin
       VetMages[i].PosTela.x:=VetMages[i].PtrImage.Left + (VetMages[i].PtrImage.Width  div 2);
       VetMages[i].PosTela.y:=VetMages[i].PtrImage.Top  + (VetMages[i].PtrImage.Height div 2);
       VetMages[i].Sentido:=LESTE;
     end;
  InicializaTabuleiro;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.InicializaTabuleiro;
var i,j:integer;
begin
  for i:=1 to 8 do
    for j:=1 to 8 do
      begin
      Tabuleiro[i,j].PosTela  :=PontoInt(34+(54*i),10+(50*j));
      Tabuleiro[i,j].Ocupado  :=False;
      Tabuleiro[i,j].Bloqueado:=False;
      end;
  Mage01.Left:=1; Mage01.Top:=33;   Mage02.Left:=1; Mage02.Top:=83;
  Mage03.Left:=1; Mage03.Top:=133;  Mage04.Left:=1; Mage04.Top:=183;
  Mage05.Left:=1; Mage05.Top:=233;  Mage06.Left:=1; Mage06.Top:=283;
  Mage07.Left:=1; Mage07.Top:=333;  Mage08.Left:=1; Mage08.Top:=383;

  VetMages[1].PtrImage:=Mage01;  VetMages[5].PtrImage:=Mage05;
  VetMages[2].PtrImage:=Mage02;  VetMages[6].PtrImage:=Mage06;
  VetMages[3].PtrImage:=Mage03;  VetMages[7].PtrImage:=Mage07;
  VetMages[4].PtrImage:=Mage04;  VetMages[8].PtrImage:=Mage08;
  for i:=1 to 8 do
     begin
       VetMages[i].PosTela.x:=VetMages[i].PtrImage.Left + (VetMages[i].PtrImage.Width  div 2);
       VetMages[i].PosTela.y:=VetMages[i].PtrImage.Top  + (VetMages[i].PtrImage.Height div 2);
       VetMages[i].Sentido:=LESTE;
     end;
end;

procedure TFormMain.VerificaPosInTab(x,y:integer);
var a,b:integer;
begin
  for a:=1 to 8 do
    for b:=1 to 8 do
       if (
            ((x>Tabuleiro[a,b].PosTela.x-20) and (x<Tabuleiro[a,b].PosTela.x+20))and
            ((y>Tabuleiro[a,b].PosTela.y-20) and (y<Tabuleiro[a,b].PosTela.y+20))
           )then
         begin
           Tabuleiro[a,b].Ocupado:=True;
           Exit;
         end;
end;

procedure TFormMain.ImageMapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var auxpchar:Pchar; auxstr:string;
begin
 if (button=mbleft)and(UltSel<>-1) then
  begin
    getmem(auxpchar,300);
    auxstr:='AsYouWhi.wav';
    StrPCopy(auxpchar, auxstr);
    try SndPlaySound(auxpchar,snd_async); except end;
    freemem(auxpchar,300);

    { Troca  mago conforme a direcao que ele seguira }
    ChangeMage(TestaDir(VetMages[UltSel].PosTela,PontoInt(x,y)),
               VetMages[UltSel].PtrImage.Canvas);
    { Efetua o caminhamento propriaente dito }
    Breshan(VetMages[UltSel].PosTela,PontoInt(x,y),VetMages[UltSel].PtrImage);
    { Muda de posição para ficar virado para o usuário }
    ChangeMage(SUL,VetMages[UltSel].PtrImage.Canvas);
    { Efetua o update da posição do mago }
    VetMages[UltSel].PosTela:=PontoInt(x,y);
    { Verifica a posição que o mago ficou no tabuleiro e efetua as devidas marcações }
    VerificaPosInTab(x,y);
    { Marca as casas bloqueadas }
    BloqueiaCaminhos(x,y);

    if MenuTabuleiro.Checked then ShowTabuleiro;
  end;
end;

procedure TFormMain.BloqueiaCaminhos(ax,ay:integer);
var a,b,j,i:integer;
begin
  for a:=1 to 8 do
    for b:=1 to 8 do
       if (
            ((ax>Tabuleiro[a,b].PosTela.x-20) and (ax<Tabuleiro[a,b].PosTela.x+20))and
            ((ay>Tabuleiro[a,b].PosTela.y-20) and (ay<Tabuleiro[a,b].PosTela.y+20))
           )then
         begin
           { Leste - Oeste}
           for i:=1 to 8 do Tabuleiro[i,b].Bloqueado:=True;
           { Norte - Sul}
           for j:=1 to 8 do Tabuleiro[a,j].Bloqueado:=True;
           i:=a;  j:=b;
           { Sudeste }
           while (i<8)and (j<8) do
            begin if (i<8) then inc(i); if (j<8) then inc(j); Tabuleiro[i,j].Bloqueado:=True; end;
           i:=a;  j:=b;
           { Noroeste }
           while (i>1)and (j>1) do
            begin if (i>1) then dec(i); if (j>1) then dec(j); Tabuleiro[i,j].Bloqueado:=True; end;
           i:=a;  j:=b;
           { Nordeste }
           while (i>1)and (j<8) do
            begin if (i>1) then dec(i); if (j<8) then inc(j); Tabuleiro[i,j].Bloqueado:=True; end;
           i:=a;  j:=b;
           { Sudoeste }
           while (i<8)and (j>1) do
            begin if (i<8) then inc(i); if (j>1) then dec(j); Tabuleiro[i,j].Bloqueado:=True; end;
           Break;
         end;
end;

procedure TFormMain.ShowTabuleiro;
var i,j:integer;
begin
  ImageMap.Canvas.Brush.style:=bsClear;
  ImageMap.Canvas.Pen.Width:=3;
  for i:=1 to 8 do
    for j:=1 to 8 do
      begin
      if Tabuleiro[i,j].Ocupado then ImageMap.Canvas.Pen.Color:=CorOCUPADO
      else if Tabuleiro[i,j].Bloqueado then ImageMap.Canvas.Pen.Color:=CorBLOQUEADO
                                       else ImageMap.Canvas.Pen.Color:=CorDESOCUPADO;
      ImageMap.Canvas.Ellipse(Tabuleiro[i,j].PosTela.X-28,Tabuleiro[i,j].PosTela.Y-26,
                              Tabuleiro[i,j].PosTela.X+28,Tabuleiro[i,j].PosTela.Y+25);
      end;
  ImageMap.Canvas.Pen.Width:=1;
  ImageMap.Canvas.Brush.style:=bsSolid;
  ImageMap.Canvas.Pen.Color:=clBlack;
//  PaintView.Canvas.CopyRect(PaintView.Canvas.ClipRect,PaintView.Canvas,ImageMap.Canvas.ClipRect);
end;

procedure TFormMain.Breshan(inic,fim:TPontoInt;Mage:TImage);
var x1,y1, x2,y2, x,y, deltaX, deltaY,stepX, stepY : real;
    smw,smh : integer;
begin
 x1:=inic.x; y1:=inic.y; x2:=fim.x; y2:=fim.y;
 stepX:=1;  stepY:=1; deltaX:=abs(x2-x1);   deltaY:=abs(y2-y1);
 if (deltaY > deltaX) then
  begin
   if (y1>y2) then stepY:=-1 else stepY := 1;
   if (x1>x2) then stepX:=-Divide(deltaX,deltaY) else stepX:=Divide(deltaX,deltaY);
   end;
 if (deltaX > deltaY) then
  begin
   if (x1>x2) then stepX:=-1 else stepX := 1;
   if (y1>y2) then stepY:=-Divide(deltaY,deltaX) else stepY:=Divide(deltaY,deltaX);
   end;
 x:=x1;  y:=y1;
 smw:=(Mage.Width  div 2);
 smh:=(Mage.Height div 2);
 while not ( QuaseIgual(x,x2,3) and QuaseIgual(y,y2,3) ) do
   begin
     x:=x+stepX;
     y:=y+stepY;
     if MenuAnimacao.Checked then
      begin
       Mage.Left :=round(x)-smw;
       Mage.Top  :=round(y)-smh;
       Mage.Refresh;
      end;
   end;
 x:=x2;
 y:=y2; { Finalizaçao do algoritmo }
 Mage.Left :=round(x)-(Mage.Width  div 2);
 Mage.Top  :=round(y)-(Mage.Height div 2);
end;

function TFormMain.TestaDir(inic,fim:TPontoInt):TSentido;
const TOL = 10; {Valor de tolerancia para manter o sentido }
begin
 if inic.x<(fim.x-TOL) then
   begin
     if (inic.y>(fim.y-TOL))and
        (inic.y<(fim.y+TOL)) then TestaDir:=LESTE
                            else if inic.y>fim.y then TestaDir:=NORDESTE
                                                 else TestaDir:=SUDESTE; end
  else
    if inic.x>(fim.x+TOL) then
      begin
        if (inic.y>(fim.y-TOL))and
           (inic.y<(fim.y+TOL)) then TestaDir:=OESTE
                               else if inic.y>fim.y then TestaDir:=NOROESTE
                                                    else TestaDir:=SUDOESTE; end
    else {inic.x=fim.x}
      if inic.y>fim.y then TestaDir:=NORTE  else TestaDir:=SUL;
end;

procedure TFormMain.ChangeMage(ind:TSentido; AuxImage:TCanvas);
var AuxBMP:TBitMap;
begin
  AuxBMP:=TBitMap.Create;
  AUXBMP.WIDTH :=ImageListSentidos.WIDTH;
  AuxBMP.HEIGHT:=ImageListSentidos.HEIGHT;
  ImageListSentidos.GetBitmap(Ord(ind),AuxBMP);
  AuxImage.CopyRect(AuxImage.ClipRect,AuxBMP.Canvas,AuxBMP.Canvas.Cliprect);
  AuxBMP.Free;
end;

procedure TFormMain.Mage06MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var auxpchar:Pchar; auxstr:string;
begin
 { Seleciona um mago para o posisionamento com o mouse }
 if button=mbright then
  begin
   getmem(auxpchar,300);
   auxstr:='YesMyLord.wav';
   StrPCopy(auxpchar, auxstr);
   try SndPlaySound(auxpchar,snd_async); except end;
   freemem(auxpchar,300);
   {
   TImage(Sender).Canvas.Brush.Style:=bsClear;
   TImage(Sender).Canvas.Pen.Color:=clWhite;
   TImage(Sender).Canvas.Ellipse(1,1,TImage(Sender).Width-3,TImage(Sender).Height-3);
   TImage(Sender).Canvas.Pen.Color:=clBlack;
   TImage(Sender).Canvas.Brush.Style:=bsSolid;
   }
   UltSel:=TImage(Sender).Tag;
  end;
end;

procedure TFormMain.MenuImagemdeFundoClick(Sender: TObject);
begin
  MenuImagemdeFundo.Checked:=not MenuImagemdeFundo.Checked;
  if (fileexists('Buffer.bmp') and MenuImagemdeFundo.Checked)
     then ImageMap.Picture.LoadFromFile('Buffer.bmp')
     else ImageMap.Picture:=nil;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuTabuleiroClick(Sender: TObject);
begin
  MenuTabuleiro.Checked:=not MenuTabuleiro.Checked;
  if (fileexists('Buffer.bmp') and MenuImagemdeFundo.Checked)
     then ImageMap.Picture.LoadFromFile('Buffer.bmp')
     else ImageMap.Picture:=nil;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuAnimacaoClick(Sender: TObject);
begin
  MenuAnimacao.Checked:=not MenuAnimacao.Checked;
end;

procedure TFormMain.MenuFecharProgramaClick(Sender: TObject);
begin
  TreeView.FullCollapse;  { Otimiza a deleção dos nodos. }
  TreeView.Items.Clear;   { Limpa a arvore. }

  Close;
end;

procedure TFormMain.MenuNovaBuscaClick(Sender: TObject);
begin
  TreeView.FullCollapse;  { Otimiza a deleção dos nodos. }
  TreeView.Items.Clear;   { Limpa a arvore. }

  InicializaTabuleiro;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuCorDesocupadoClick(Sender: TObject);
begin
  if ColorDialog.Execute then CorDESOCUPADO := ColorDialog.Color;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuCorOcupadoClick(Sender: TObject);
begin
  if ColorDialog.Execute then CorOCUPADO := ColorDialog.Color;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuBloqueadoClick(Sender: TObject);
begin
  if ColorDialog.Execute then CorBLOQUEADO := ColorDialog.Color;
  if MenuTabuleiro.Checked then ShowTabuleiro;
end;

procedure TFormMain.MenuBuscaExaustivaClick(Sender: TObject);
begin
  MenuBuscaHeuristica.Checked:=False;
  MenuBuscaExaustiva.Checked:=not MenuBuscaExaustiva.Checked;
end;

procedure TFormMain.MenuBuscaHeuristicaClick(Sender: TObject);
begin
  MenuBuscaExaustiva.Checked:=False;
  MenuBuscaHeuristica.Checked:=not MenuBuscaHeuristica.Checked;
end;

procedure TFormMain.MenuBuscaVerticalClick(Sender: TObject);
begin
  MenuBuscaHorizontal.Checked:=False;
  MenuBuscaVertical.Checked:=not MenuBuscaVertical.Checked;
end;

procedure TFormMain.MenuBuscaHorizontalClick(Sender: TObject);
begin
  MenuBuscaVertical.Checked:=False;
  MenuBuscaHorizontal.Checked:=not MenuBuscaHorizontal.Checked;
end;


procedure TFormMain.MenuOQueClick(Sender: TObject);
begin
 FormHelp.ShowModal;
end;

procedure TFormMain.MenuCreditosClick(Sender: TObject);
begin
 FormCreditos.ShowModal;
end;

procedure TFormMain.TreeViewDeletion(Sender: TObject; Node: TTreeNode);
var PosMageTab: TPtrPontoInt;
begin
  if Node.Data <> nil then
     begin
       PosMageTab := Node.Data;
       Node.Data  := nil;
       Dispose(PosMageTab);
     end;
end;

procedure TFormMain.MenuGerarArvoreClick(Sender: TObject);
begin
 if MessageDLG('Confirma a geração da árvore de estados segundo o tipo '+chr(13)+
               'de busca configurado no menu visualizar ?',
               mtConfirmation,[mbYes,mbNo],0)= mrYes then
               begin MenuNovaBuscaClick(Sender); MontaArvore; end;
end;

procedure TFormMain.MontaArvore;
begin
 if MenuBuscaHeuristica.Checked then MontaArvoreHeuristica
                                else MontaArvoreExaustiva;
end;

procedure TFormMain.MontaArvoreHeuristica;
var Raiz,Nodo: TTreeNode; PtrPos: TPtrPontoInt;
    auxa,auxb,a,b,i,j,ContMages:integer;
begin
  screen.Cursor:=crHourGlass;
  TreeView.FullCollapse;  { Otimiza a deleção dos nodos. }
  TreeView.Items.Clear;   { Limpa a arvore. }

  for a:=1 to 8 do
    for b:=1 to 8 do
      begin
       if MenuBuscaVertical.Checked then begin auxa:=a; auxb:=b; end
                                    else begin auxa:=b; auxb:=a; end;
       VerificaPosInTab(Tabuleiro[auxa,auxb].postela.x,Tabuleiro[auxa,auxb].postela.y);
       BloqueiaCaminhos(Tabuleiro[auxa,auxb].postela.x,Tabuleiro[auxa,auxb].postela.y);
       if MenuTabuleiro.Checked then ShowTabuleiro;
       ContMages:=1;
       Raiz := TreeView.Items.Add(nil, 'ESTADOS possíveis apartir de => '+inttostr(auxa)+','+inttostr(auxb) ); { Cria nodo raiz da arvore. }
       Raiz.ImageIndex    := 0;
       Raiz.SelectedIndex := 0;
       for i:=1 to 8 do
         for j:=1 to 8 do
         begin
           if not tabuleiro[i,j].Bloqueado then
           begin
             inc(ContMages);
             VerificaPosInTab(Tabuleiro[i,j].postela.x,Tabuleiro[i,j].postela.y);
             BloqueiaCaminhos(Tabuleiro[i,j].postela.x,Tabuleiro[i,j].postela.y);
             Nodo := TreeView.Items.AddChild(Raiz, inttostr(i)+','+inttostr(j));
             new(PtrPos);
             PtrPos^.x := i;
             PtrPos^.y := j;
             Nodo.Data          := PtrPos;
             Nodo.ImageIndex    := 1;
             Nodo.SelectedIndex := 2;
             if ContMages=8 then
              begin
               Raiz.text:='SOLUÇÃO apartir de => '+inttostr(auxa)+','+inttostr(auxb);
               Raiz.ImageIndex := 3;
               Raiz.SelectedIndex := 3;
               Raiz.Expand(False);
               nodo.Expand(True);
               if MenuTabuleiro.Checked then ShowTabuleiro;
               screen.Cursor:=crdefault;
               MessageDLG('Utilize o botão MOSTRA RESULTADO para visualizar as soluções.',mtInformation,[mbOk],0);
               exit;
              end
           end;
         end;
       if MenuTabuleiro.Checked then begin ShowTabuleiro; ImageMap.refresh; end;
       InicializaTabuleiro;
      end;
  screen.Cursor:=crdefault;
end;

procedure TFormMain.MontaArvoreExaustiva;
var Raiz,Nodo: TTreeNode; PtrPos: TPtrPontoInt; auxa,auxb,a,b,i,j,ContMages:integer;
begin
  screen.Cursor:=crHourGlass;
  TreeView.FullCollapse;  { Otimiza a deleção dos nodos. }
  TreeView.Items.Clear;   { Limpa a arvore. }

  for a:=1 to 8 do
    for b:=1 to 8 do
      begin
        if MenuBuscaVertical.Checked then begin auxa:=a; auxb:=b; end
                                     else begin auxa:=b; auxb:=a; end;
        { Verifica a posição que o mago ficaria no tabuleiro e efetua as devidas marcações }
        VerificaPosInTab(Tabuleiro[auxa,auxb].postela.x,Tabuleiro[auxa,auxb].postela.y);
        { Marca as casas bloqueadas }
        BloqueiaCaminhos(Tabuleiro[a,b].postela.x,Tabuleiro[auxa,auxb].postela.y);
        if MenuTabuleiro.Checked then ShowTabuleiro;
        ContMages:=1;
        Raiz := TreeView.Items.Add(nil, 'ESTADOS possíveis apartir de => '+inttostr(auxa)+','+inttostr(auxb) ); { Cria nodo raiz da arvore. }
        Raiz.ImageIndex    := 0;  Raiz.SelectedIndex := 0;
        for i:=1 to 8 do
          for j:=1 to 8 do
          begin
            if not tabuleiro[i,j].Bloqueado then
            begin
              inc(ContMages);
              { Verifica a posição que o mago ficaria no tabuleiro e efetua as devidas marcações }
              VerificaPosInTab(Tabuleiro[i,j].postela.x,Tabuleiro[i,j].postela.y);
              { Marca as casas bloqueadas }
              BloqueiaCaminhos(Tabuleiro[i,j].postela.x,Tabuleiro[i,j].postela.y);
              Nodo := TreeView.Items.AddChild(Raiz, inttostr(i)+','+inttostr(j));
              new(PtrPos);
              PtrPos^.x := i;
              PtrPos^.y := j;
              Nodo.Data          := PtrPos;
              Nodo.ImageIndex    := 1;
              Nodo.SelectedIndex := 2;
              if ContMages=8 then
                begin
                 Raiz.text:='SOLUÇÃO apartir de => '+inttostr(auxa)+','+inttostr(auxb);
                 Raiz.ImageIndex    := 3;
                 Raiz.SelectedIndex := 3;
                 Raiz.Expand(False);
                end
            end;
          end;
         if MenuTabuleiro.Checked then begin ShowTabuleiro; ImageMap.refresh; end;
         InicializaTabuleiro;
      end;
  InicializaTabuleiro;
  if MenuTabuleiro.Checked then ShowTabuleiro;

  MessageDLG('Utilize o botão MOSTRA RESULTADO para visualizar as soluções.',mtInformation,[mbOk],0);
  screen.Cursor:=crdefault;
end;

procedure TFormMain.MenuMostraResultadoClick(Sender: TObject);
begin
 {- busca a soluçoes
  - seta o tabuleiro
  - loco entre as solucoes
     PosicionaMagos;
     messageDlG('Esta foi a primeira solução enciontrada pela busca Exaustiva.'+chr(13)+
                ' Aperte Ok para continuar',mtInformation,[mbOk],0);
      }
 PosicionaMagos;
end;

procedure TFormMain.PosicionaMagos;
var a,b:integer;
begin
  screen.cursor:=crHourGlass;
  ultSel:=1;
  for a:=1 to 8 do
    for b:=1 to 8 do
      if Tabuleiro[a,b].Ocupado then
       begin
        { Troca  mago conforme a direcao que ele seguira }
        ChangeMage(TestaDir(VetMages[UltSel].PosTela,Tabuleiro[a,b].PosTela)
                   ,VetMages[UltSel].PtrImage.Canvas);
        { Efetua o caminhamento propriaente dito }
        Breshan(VetMages[UltSel].PosTela,Tabuleiro[a,b].PosTela,VetMages[UltSel].PtrImage);
        { Muda de posição para ficar virado para o usuário }
        ChangeMage(SUL,VetMages[UltSel].PtrImage.Canvas);
        { Efetua o update da posição do mago }
        VetMages[UltSel].PosTela:=Tabuleiro[a,b].PosTela;
        inc(ultsel);
      end;
  screen.cursor:=crDefault;
end;

end.
