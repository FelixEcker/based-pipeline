unit MyError;

{ Custom error reporting routines }

interface

procedure Say(msg : String);
procedure SockError(msg : String);
procedure SockSay(msg : String);
procedure GenError(msg : String);

implementation

uses sockets, errors;

procedure Say(msg : String);
begin
   Writeln(stderr, msg);
end;

procedure SockError(msg : String);
begin
   Writeln(stderr, msg, strerror(SocketError));
   Halt(1);
end;

procedure SockSay(msg : String);
begin
   Writeln(stderr, msg, strerror(SocketError));
end;

procedure GenError(msg : String);
begin
   Say(msg);
   Halt(1);
end;

end.
