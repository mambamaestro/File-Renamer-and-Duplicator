unit u_about_us;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,  HtmlView, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, lclintf, Buttons, ssockets, sslsockets,  fphttpclient,
  fpopenssl, openssl;

type

  { TFAboutUs }

  TFAboutUs = class(TForm)
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    BitBtn3: TBitBtn;
    HtmlViewer1: THtmlViewer;
    Image1: TImage;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SSLClientCertSetup(Sender: TObject; const UseSSL: Boolean;
  out AHandler: TSocketHandler);
  private

  public
    procedure loadHtmlViewer(html: string);
    procedure refreshAbout;
  end;

var
  FAboutUs: TFAboutUs;

implementation

{$R *.lfm}

{ TFAboutUs }

procedure TFAboutUs.BitBtn1Click(Sender: TObject);
begin
  OpenURL('https://m.me/ali.programmer.aplikasi');
end;

procedure TFAboutUs.BitBtn2Click(Sender: TObject);
begin
  OpenURL('https://wa.me/6285706634394');
end;

procedure TFAboutUs.BitBtn3Click(Sender: TObject);
begin

  refreshAbout;
  //Self.Close;
end;

procedure TFAboutUs.SSLClientCertSetup(Sender: TObject; const UseSSL: Boolean;
  out AHandler: TSocketHandler);
begin
  //AHandler := nil;
  //  if UseSSL and (FClientCertificate <> '') then
  //  begin
  //    // Only set up client certificate if needed.
  //    // If not, let normal fphttpclient flow create
  //    // required socket handler
  //    AHandler := TSSLSocketHandler.Create;
  //    // Example: use your own client certificate when communicating with the server:
  //    (AHandler as TSSLSocketHandler).Certificate.FileName := FClientCertificate;
  //  end;
end;

procedure TFAboutUs.loadHtmlViewer(html: string);
begin
  HtmlViewer1.LoadFromString(
    html
  );
end;

procedure TFAboutUs.refreshAbout;
var
  html: string;
begin

  try
    html:= TFPHttpClient.SimpleGet('https://altaifa.com/about.html');

  except
    on E:Exception do begin
        html:=
              '<html> ' +
                  '<body> ' +
                   Label1.Caption +
                  '</body> ' +
                  '</html> ';
      //ShowMessage(e.Message)
    end;


  end;




  loadHtmlViewer(html);

end;

end.

