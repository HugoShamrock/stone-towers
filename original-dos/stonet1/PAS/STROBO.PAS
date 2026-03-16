program Pokus;
uses EMS,Crt,Sandra;
var Error      : Word;
    Total,Free : Word;
    Address    : Word;
    A,B        : longint;
    Handle     : Word;
    Fil        : File;
    Key        : Charac;
procedure Page(Number:Word);
begin
  Error:=MapPages(Handle,Number,0);CheckError(Error); {namapuje stranku}
end;
begin
  ClrScr;
  If not EMSInstalled then EMSError('neni nainstalovan ovladac EMS pameti!');{otestuje ovladac EMS pameti}
  Error:=GetFreePages(Total,Free);CheckError(Error);{zjisti volnou/celkovou EMS}
                                                    {vraci hodnotu HANDLE (NEMENIT)!!!}

  A:=Total;B:=Free;
  Writeln('Celkova pamet : ',A*16000);
  Writeln('Volna pamet   : ',B*16000);
  Error:=AllocatePages(20,Handle);CheckError(Error);{alokuje 4 ems stranky (320000)}
  Error:=GetAddress(Address);CheckError(Error);    {vezme adresu EMS (provest pouze 1)
                                                    vraci hodnotu Address(nemenit)!!!!}
  Assign(Fil,'STROBO1.GRA');
  Reset(Fil,1);
  Page(0);Seek(Fil,0);BlockRead(Fil,Mem[Address:0],16000);
  Page(1);Seek(Fil,16000);BlockRead(Fil,Mem[Address:0],16000);
  Page(2);Seek(Fil,32000);BlockRead(Fil,Mem[Address:0],16000);
  Page(3);Seek(Fil,48000);BlockRead(Fil,Mem[Address:0],16000);
  Close(Fil);

  Assign(Fil,'STROBO2.GRA');
  Reset(Fil,1);
  Page(4);Seek(Fil,0);BlockRead(Fil,Mem[Address:0],16000);
  Page(5);Seek(Fil,16000);BlockRead(Fil,Mem[Address:0],16000);
  Page(6);Seek(Fil,32000);BlockRead(Fil,Mem[Address:0],16000);
  Page(7);Seek(Fil,48000);BlockRead(Fil,Mem[Address:0],16000);
  Close(Fil);

  Assign(Fil,'STROBO3.GRA');
  Reset(Fil,1);
  Page(8);Seek(Fil,0);BlockRead(Fil,Mem[Address:0],16000);
  Page(9);Seek(Fil,16000);BlockRead(Fil,Mem[Address:0],16000);
  Page(10);Seek(Fil,32000);BlockRead(Fil,Mem[Address:0],16000);
  Page(11);Seek(Fil,48000);BlockRead(Fil,Mem[Address:0],16000);
  Close(Fil);

  Assign(Fil,'STROBO4.GRA');
  Reset(Fil,1);
  Page(12);Seek(Fil,0);BlockRead(Fil,Mem[Address:0],16000);
  Page(13);Seek(Fil,16000);BlockRead(Fil,Mem[Address:0],16000);
  Page(14);Seek(Fil,32000);BlockRead(Fil,Mem[Address:0],16000);
  Page(15);Seek(Fil,48000);BlockRead(Fil,Mem[Address:0],16000);
  Close(Fil);

  Assign(Fil,'HOSPODA.GIF');
  Reset(Fil,1);
  Page(16);Seek(Fil,0);BlockRead(Fil,Mem[Address:0],16000);
  {Page(17);Seek(Fil,16000);BlockRead(Fil,Mem[Address:0],16000);
  Page(18);Seek(Fil,32000);BlockRead(Fil,Mem[Address:0],16000);
  Page(19);Seek(Fil,48000);BlockRead(Fil,Mem[Address:0],16000);}
  Close(Fil);
  asm mov ax,13h;int 10h;end;
  AAPalette('Strobo.col',0);

  Repeat;
    Key:=InKey;
    If Key='1' then
      begin
        Page(0);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        Page(1);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(2);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(3);
        Move(Mem[Address:0],Mem[$A000:48000],16000);
      end;
    If Key='2' then
      begin
        Page(4);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        Page(5);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(6);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(7);
        Move(Mem[Address:0],Mem[$A000:48000],16000);
      end;
    If Key='3' then
      begin
        Page(8);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        Page(9);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(10);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(11);
        Move(Mem[Address:0],Mem[$A000:48000],16000);
      end;
    If Key='4' then
      begin
        Page(12);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        Page(13);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(14);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(15);
        Move(Mem[Address:0],Mem[$A000:48000],16000);
      end;
    If Key='5' then
      begin
        Page(16);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        {Page(17);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(18);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(19);
        Move(Mem[Address:0],Mem[$A000:48000],16000);}
      end;
        Delay(55);
        Page(0);
        Move(Mem[Address:0],Mem[$A000:0],16000);
        Page(1);
        Move(Mem[Address:0000],Mem[$A000:16000],16000);
        Page(2);
        Move(Mem[Address:0],Mem[$A000:32000],16000);
        Page(3);
        Move(Mem[Address:0],Mem[$A000:48000],16000);
  Until Key=#27;

  asm mov ax,3h; int 10h; end;
  Error:=DeallocatePages(Handle);CheckError(Error); {dealokuje EMS (uvolni)}
end.