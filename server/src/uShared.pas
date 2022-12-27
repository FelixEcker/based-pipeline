{$mode fpc}
unit uShared;

{********************************************************}
{ uShared.pas ; Shared Globals and procs for bugattiserv }
{ Author: Felix Eckert                                   }
{********************************************************}

interface
  uses SysUtils, Sockets, Types;

  type
    TBuffer = array[0..512] of Byte;

  var
    passphrase: ShortString;

  procedure perror(const S: String);
  function BytesToStr(var ABuf: TBuffer): String;
implementation
  procedure perror(const S: String);
  begin
    writeln (S,SocketError);
    halt(100);
  end;
  
  function BytesToStr(var ABuf: TBuffer): String;
  var
    out: String;
    i: Integer;
  begin
    out := '';

    for i := 0 to Length(ABuf)-1 do
      if ABuf[i] = 0 then exit(out)
      else out := out + Char(ABuf[i]);

    BytesToStr := out;
  end;
end.
