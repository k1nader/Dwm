unit uDwm.Reg;

interface

uses
  Windows, Classes, DesignIntf;

procedure register;

implementation

uses
  uDwm.NoBorderForm;

procedure register;
begin
  RegisterComponents('Dwm', [TDwmNoBorderForm]);
end;

end.

