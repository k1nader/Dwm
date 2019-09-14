unit uDwm.NoBorderForm;

interface

uses
  Windows, Classes, Messages, SysUtils, Forms, UxTheme, Dwmapi;

type
  TDwmAero = class(TObject)
  public
    class function IsAeroEnabled: Boolean;
    class procedure SetShadow(Handle: THandle);
    class procedure SetFramesSize(Handle: Cardinal; Left, Top, Width, Height: Integer; var FrameSize: Integer);
  end;

  TDwmNoBorderForm = class(TComponent)
  private
    FParent: TForm;
    FOldWndProc: TWndMethod;
    FAeroEnabled: Boolean;
  protected
    procedure WndProc(var Msg: TMessage); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

class function TDwmAero.IsAeroEnabled: Boolean;

  function GetOSVersionInfo(var Info: TOSVersionInfoEx): Boolean;
  begin
    FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
    Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
    Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
    if (not Result) then
      Info.dwOSVersionInfoSize := 0;
  end;

var
  OSVersionInfoEx: TOSVersionInfoEx;
  Enabled: BOOL;
begin
  Result := False;

  if GetOSVersionInfo(OSVersionInfoEx) then
  begin
    if OSVersionInfoEx.dwMajorVersion >= 6 then
    begin
      DwmIsCompositionEnabled(Enabled);
      Result := Enabled;
    end;
  end;
end;

class procedure TDwmAero.SetShadow(Handle: THandle);
const
  dwAttribute = 2;
  cbAttribute = 4;
var
  pvAttribute: Integer;
  pMarInset: TMargins;
begin
  pvAttribute := 2;
  DwmSetWindowAttribute(Handle, dwAttribute, @pvAttribute, cbAttribute);
  pMarInset.cxLeftWidth := 1;
  pMarInset.cxRightWidth := 1;
  pMarInset.cyTopHeight := 1;
  pMarInset.cyBottomHeight := 1;
  DwmExtendFrameIntoClientArea(Handle, pMarInset);
end;

class procedure TDwmAero.SetFramesSize(Handle: Cardinal; Left, Top, Width, Height: Integer; var FrameSize: Integer);
var
  R: TRect;
begin
  SetRectEmpty(R);
  AdjustWindowRectEx(R, GetWindowLong(Handle, GWL_STYLE), False, GetWindowLong(Handle, GWL_EXSTYLE));
  FrameSize := R.Right;
  SetWindowPos(Handle, 0, Left, Top, Width, Height, SWP_FRAMECHANGED);
end;

constructor TDwmNoBorderForm.Create(AOwner: TComponent);
begin
  inherited;
  Assert(AOwner.InheritsFrom(TForm));
  FParent := TForm(AOwner);
  FOldWndProc := FParent.WindowProc;
  FParent.WindowProc := WndProc;
  FAeroEnabled := TDwmAero.IsAeroEnabled;
end;

destructor TDwmNoBorderForm.Destroy;
begin
  inherited;
  FParent.WindowProc := FOldWndProc;
end;

procedure TDwmNoBorderForm.WndProc(var Msg: TMessage);
var
  BorderSpace: Integer;
  WMNCCalcSize: TWMNCCalcSize;
begin
  if csDesigning in ComponentState then
  begin
    if Assigned(FOldWndProc) then
      FOldWndProc(Msg);
  end
  else
  begin
    if Msg.Msg = WM_NCCALCSIZE then
    begin
      Msg.Result := 0;

      if FParent.WindowState = wsMaximized then
      begin
        WMNCCalcSize := TWMNCCalcSize(Msg);
        BorderSpace := GetSystemMetrics(SM_CYFRAME) + GetSystemMetrics(SM_CXPADDEDBORDER);
        Inc(WMNCCalcSize.CalcSize_Params.rgrc[0].Top, BorderSpace);
        Inc(WMNCCalcSize.CalcSize_Params.rgrc[0].Left, BorderSpace);
        Dec(WMNCCalcSize.CalcSize_Params.rgrc[0].Right, BorderSpace);
        Dec(WMNCCalcSize.CalcSize_Params.rgrc[0].Bottom, BorderSpace);
      end;
    end
    else if Msg.Msg = WM_PAINT then
    begin
      if Assigned(FOldWndProc) then
        FOldWndProc(Msg);

      if FAeroEnabled then
      begin
        TDwmAero.SetShadow(FParent.Handle);
      end;
    end
    else
    begin
      if Assigned(FOldWndProc) then
        FOldWndProc(Msg);
    end;
  end;
end;

end.
