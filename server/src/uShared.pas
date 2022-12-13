{$mode fpc}
unit uShared;

{********************************************************}
{ uShared.pas ; Shared Globals and procs for bugattiserv }
{ Author: Felix Eckert                                   }
{********************************************************}

interface
  uses Types;

  var
    passphrase: ShortString;

  function BytesToStr(const ABuf: TByteDynArray): String;
implementation
  function BytesToStr(const ABuf: TByteDynArray): String;
  var
    out: String;
    i: Integer;
  begin
    out := '';
    for i := 0 to Length(ABuf)-1 do
      if ABuf[i] = 0 then exit(out)
      else out := out + Char(ABuf[i]);
  end;
end.
