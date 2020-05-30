program TheMages;

uses
  Forms,
  SMain in 'SMain.pas' {FormMain},
  SInicio in 'SInicio.pas' {FormInicio},
  SHelp in 'SHelp.pas' {FormHelp},
  SCreditos in 'SCreditos.pas' {FormCreditos};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TheMages';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormInicio, FormInicio);
  Application.CreateForm(TFormHelp, FormHelp);
  Application.CreateForm(TFormCreditos, FormCreditos);
  Application.Run;
end.
