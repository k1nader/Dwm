unit uDwm.NoBorderForm;

interface

uses
  Windows, Classes, Messages, SysUtils, Forms, UxTheme, Dwmapi;

type
  TDwmAero = class(TObject)
  public
    class function OSMajorVersion: Cardinal;
    class function IsAeroEnabled: Boolean;
    class procedure SetShadow(Handle: THandle);
    class procedure SetFramesSize(Handle: Cardinal; Left, Top, Width, Height: Integer; var FrameSize: Integer);
  end;

  TDwmNoBorderForm = class(TComponent)
  private
    FParent: TForm;
    FOldWndProc: TWndMethod;
    FOSMajorVersion: Cardinal;
    FAeroEnabled: Boolean;
    FEnabledShadow: Boolean;
    FEnabledNoBorder: Boolean;
  protected
    procedure WndProc(var Msg: TMessage); virtual;
    procedure SetEnabledShadow(const Value: Boolean);
    procedure SetEnabledNoBorder(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property EnabledShadow: Boolean read FEnabledShadow write SetEnabledShadow default True;
    property EnabledNoBorder: Boolean read FEnabledNoBorder write SetEnabledNoBorder default True;
  end;

implementation

class function TDwmAero.OSMajorVersion: Cardinal;
begin
  Result := Win32MajorVersion;
end;

class function TDwmAero.IsAeroEnabled: Boolean;
begin
  Result := DwmCompositionEnabled;
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
  FOSMajorVersion := TDwmAero.OSMajorVersion;
  FAeroEnabled := TDwmAero.IsAeroEnabled;
  FEnabledShadow := True;
  FEnabledNoBorder := True;

  SetEnabledShadow(FEnabledShadow);
  SetEnabledNoBorder(FEnabledNoBorder);
end;

destructor TDwmNoBorderForm.Destroy;
begin
  inherited;
  FParent.WindowProc := FOldWndProc;
end;

procedure TDwmNoBorderForm.SetEnabledShadow(const Value: Boolean);
begin
  if FEnabledShadow <> Value then
  begin
    FEnabledShadow := Value;
  end;

  if FEnabledShadow and (FOSMajorVersion < 6) then
  begin
    SetClassLong(FParent.Handle, GCL_STYLE, GetClassLong(FParent.Handle, GCL_STYLE) or CS_DROPSHADOW);
  end;

end;

procedure TDwmNoBorderForm.SetEnabledNoBorder(const Value: Boolean);
begin
  if FEnabledNoBorder <> Value then
  begin
    FEnabledNoBorder := Value;
  end;

  if FEnabledNoBorder and (FOSMajorVersion < 6) then
  begin
    FParent.BorderStyle := bsNone;
  end;
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
      if FOSMajorVersion >= 6 then
      begin
        if FEnabledNoBorder then
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
        else
        begin
          if Assigned(FOldWndProc) then
            FOldWndProc(Msg);
        end;
      end
      else
      begin
        if Assigned(FOldWndProc) then
          FOldWndProc(Msg);
      end;
    end
    else if Msg.Msg = WM_PAINT then
    begin
      if Assigned(FOldWndProc) then
        FOldWndProc(Msg);

      if FEnabledShadow and FAeroEnabled then
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

