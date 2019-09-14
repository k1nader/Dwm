unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDwm.NoBorderForm, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    DwmNoBorderForm1: TDwmNoBorderForm;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Panel1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if WindowState = wsMaximized then
  begin
    Button1.Caption := 'Maximized';
    WindowState := wsNormal;
  end
  else
  begin
    Button1.Caption := 'Normal';
    WindowState := wsMaximized;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  WindowState := wsMinimized;
end;

procedure TForm1.Panel1DblClick(Sender: TObject);
begin
  Button1.Click;
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

end.

