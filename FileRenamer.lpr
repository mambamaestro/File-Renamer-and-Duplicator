program FileRenamer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FrameViewer09, u_main, u_about_us
  { you can add units after this };

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Title:='Aly File Renamer';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAboutUs, FAboutUs);
  Application.Run;
end.

