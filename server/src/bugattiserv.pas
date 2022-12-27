{$mode fpc}
program bugattiserv;

{**********************************************************************}
{ bugattiserv.pas ; The Official Server-Program for the based-pipeline }
{ Author: Felix Eckert                                                 }
{**********************************************************************}

uses uClient, Sockets, SysUtils, CTypes, UnixType, uShared;

{
  buggatiserv - server startup & connection acception
  uClient - Client Record and Thread
}

const
  SERVER_PORT = 1337;

{
  S       - Socket Handle
  SAddr   - Socket Address
  tmpS... - Temporary Client data for accepting
}
var
  S, tmpS    : Longint;
  SAddr      : TInetSockAddr;
  tmpSAddr   : PSockAddr;
  tmpSLen    : PSockLen;

begin
  if ParamCount() = 0 then
  begin
    writeln('Provide ALPHA-Passphrase as 1st argument!');
    halt;
  end;
  passphrase := ParamStr(1);

  S :=fpSocket(AF_INET,SOCK_STREAM, 0);
  if SocketError <> 0 then
    perror('Server : Socket : ');
  
  SAddr.sin_family:=AF_INET;

  SAddr.sin_port := htons(SERVER_PORT);
  SAddr.sin_addr.s_addr := 0;
  
  if fpBind(S, @SAddr, sizeof(sAddr)) = -1 then
    perror('Server : Bind : ');
  
  if fpListen(S, 1) = -1 then
    perror('Server : Listen : ');
 
  writeln('Info: Server Ready');
  while True do
  begin
    tmpS := fpAccept(S, @tmpSAddr, @tmpSLen);

    writeln('Info: Accepeted Connection');
    CreateClient(tmpS, tmpSAddr, tmpSLen);
  end;
end.
