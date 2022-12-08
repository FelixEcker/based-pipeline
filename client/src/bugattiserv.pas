{$mode fpc}
program bugattiserv;

uses Sockets;

type 
  TClient = record
    FromName: String;
    Buffer: String[255];
    Sin, Sout: Text;
  end;

  TClientDynArray: array of TClientDynArray;

  PClient = ^TClient;

var
  FClients : TClientDynArray;
  FromName : string;
  Buffer   : string[255];
  S        : Longint;
  Sin,Sout : Text;
  SAddr    : TInetSockAddr;

procedure perror(const S:string);
begin
  writeln (S,SocketError);
  halt(100);
end;

function AcceptClient(const ASocket: Longint): PClient;
var
  ix: Integer;
begin
  ix := Length(FClients);
  SetLength(FClients, ix+1);
  Accept(FClients[ix].S, FClients[ix].FromName, FClients[ix].Sin, FClients[ix].Sout);
end;

begin
  S:=fpSocket (AF_INET,SOCK_STREAM,0);
  if SocketError<>0 then
   Perror ('Server : Socket : ');
  SAddr.sin_family:=AF_INET;
  { port 50000 in network order }
  SAddr.sin_port:=htons(5000);
  SAddr.sin_addr.s_addr:=0;
  if fpBind(S,@SAddr,sizeof(saddr))=-1 then
   PError ('Server : Bind : ');
  if fpListen (S,1)=-1 then
   PError ('Server : Listen : ');
  Writeln('Waiting for Connect from Client, run now sock_cli in an other tty');
  if Accept(S,FromName,Sin,Sout) then
   PError ('Server : Accept : '+fromname);
  Reset(Sin);
  ReWrite(Sout);
  Writeln(Sout,'Message From Server');
  Flush(SOut);
  while not eof(sin) do
   begin
     Readln(Sin,Buffer);
     Writeln('Server : read : ',buffer);
   end;
end.
