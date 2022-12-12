{$mode fpc}
unit uClient;

{***********************************************************}
{ uClient.pas ; based-pipeline server-side client structure }
{ Author: Felix Eckert                                      }
{***********************************************************}

interface
  uses {$ifdef unix} cthreads, {$endif} SysUtils, Sockets, CTypes, UnixType;

  type 
    TByteBuff = array[0..255] of Byte;

    TClient = record
      { Thread Control }
      should_halt, halted: Boolean;
      
      { Should a Based Time sent. based_time is a Unix-Timestamp }
      send_based: Boolean;
      based_time: UInt32;

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

  function ClientExecute(p: Pointer): PtrInt;
  var
    i: Integer;
    recp: PClient;
    buf: TByteBuff;
    phrase: ShortString;
  begin  
    recp := PClient(p);

    writeln('Started new Client-Thread!');  
    
    { Receive Passphrase to check if ALPHA }

    if (fprecv(recp^.S, @buf, Length(buf), 0) = -1) then
    begin
      writeln(SocketError);
      recp^.halted := True;
      exit(-1);
    end;

    phrase := '';
    for i := 0 to Length(buf)-1 do
      if buf[i] = 0 then break
      else phrase := phrase + Char(buf[i]);

    (* phrase : NOTALPHA = NormalWeiter; phrase : <ALPHAPHRASE> = BranchAlphaEx; *)

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

  function AlphaExecute(p: Pointer): PtrInt;
  begin
    writeln('Alpha is executing');
    AlphaExecute := 0;
  end;
end.
