{$mode fpc}
unit uClient;

{***********************************************************}
{ uClient.pas ; based-pipeline server-side client structure }
{ Author: Felix Eckert                                      }
{***********************************************************}

interface
  uses {$ifdef unix} cthreads, {$endif} SysUtils, Sockets, CTypes, UnixType,
        Types, uShared;

  type 
    TClient = record
      { Thread Control }
      should_halt, halted: Boolean;
      
      { Should a Based Time sent. based_time is a Unix-Timestamp }
      (*send_based: Boolean;
      based_time: UInt32;*)

      { Socket, Address and Length }
      S: Longint;
      sAddr: PSockAddr;
      sLen: PSockLen;
    end;

    PClient = ^TClient;

    TClientDynArray = array of TClient;

  procedure CreateClient(const CS: Longint; const sAddr: PSockAddr; const sLen: PSockLen);
  procedure StopClients;
  function ClientExecute(p: Pointer): PtrInt;
  function AlphaExecute(p: Pointer): PtrInt;

  var
    ALPHA_THREAD: PClient;
    THREADS: TClientDynArray;

implementation
  { ALL IMPLEMENTATIONS ARE NOT TESTED AND UNFINISHED! }  

  procedure CreateClient(const CS: Longint; const sAddr: PSockAddr; const sLen: PSockLen);
  begin
    SetLength(THREADS, Length(THREADS)+1);
    THREADS[High(THREADS)].should_halt := False;
    THREADS[High(THREADS)].halted      := False;
    THREADS[High(THREADS)].S           := CS;
    THREADS[High(THREADS)].sAddr       := sAddr;
    THREADS[High(THREADS)].sLen        := sLen;
  
    BeginThread(@ClientExecute, @(THREADS[High(THREADS)]));
  end;

  procedure StopClients;
  var
    i: Integer;
  begin
    for i := 0 to Length(THREADS)-1 do
      THREADS[i].should_halt := True;
  end;

  procedure Broadcast(const ASender: PSockAddr; const AMsg: String);
  var
    i: Integer;
  begin
    for i := 0 to Length(THREADS)-1 do
      if THREADS[i].sAddr <> ASender then
        fpSend(THREADS[i].S, @AMsg, Length(AMsg), 0);
  end;

  function ClientExecute(p: Pointer): PtrInt;
  var
    i: Integer;
    recp: PClient;
    buf: TByteDynArray;
    recvstr: ShortString;
  begin  
    recp := PClient(p);

    writeln('Started new Client-Thread!');  
    
    { Receive Passphrase to check if ALPHA }

    SetLength(buf, 512);
    if (fprecv(recp^.S, @buf, Length(buf), 0) = -1) then
    begin
      writeln(SocketError);
      recp^.halted := True;
      exit(-1);
    end;

    recvstr := ShortString(BytesToStr(buf));

    (* Exec as alpha if passphrase *)
    if (recvstr = passphrase) and (ALPHA_THREAD = nil) then
      exit(AlphaExecute(p)); 

    {******************************}

    while not recp^.should_halt do
    begin
      while not recp^.send_based do begin end;
      recp^.send_based := False;
      writeln('Send Based');
    end;

    recp^.halted := True;
    ClientExecute := 0;
  end;

  (* Muss in tandem mit Discord-Bot getestet werden, ist besser so *)
  function AlphaExecute(p: Pointer): PtrInt;
  var
    recp: PClient;
    buf: TByteDynArray;
    recvstr: ShortString;
  begin
    recp := PClient(p);
    writeln(Format('Info: Thread $%p is executing as Alpha', [p]));
    
    SetLength(buf, 512);
    while not recp^.should_halt do
    begin
      if (fprecv(recp^.S, @buf, Length(buf), 0) = -1) then
      begin
        writeln('Info: Alpha Client lost connection');
        recp^.halted := True;
        break;
      end;
      
      recvstr := ShortString(BytesToStr(buf));
      if (recvstr[1] = 'b') then
        Broadcast(recp^.sAddr, Copy(recvstr, 2, Length(recvstr)));
    end;

    ALPHA_THREAD := nil;
    AlphaExecute := 0;
  end;

initialization
  ALPHA_THREAD := nil;
end.
