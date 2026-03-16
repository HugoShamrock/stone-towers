uses EMS,Crt;
var Error:Word;
    Total,Free:Word;
    Handle:Word;
    Address:Word;
    A,B:longint;

    Data:Array[1..32000] of Byte;
    Fil:File;
    Size,c,d:Word;

procedure Page(Number:Word);
begin
  Error:=MapPages(Handle,Number,0);CheckError(Error); {namapuje stranku}
end;

begin
for c:= 0 to 3200 do
   begin
    data[c]:=c;
   end;
  ClrScr;
  If not EMSInstalled then EMSError('neni nainstalovan ovladac EMS pameti!');{otestuje ovladac EMS pameti}
  Error:=GetFreePages(Total,Free);CheckError(Error);{zjisti volnou/celkovou EMS}
                                                    {vraci hodnotu HANDLE (NEMENIT)!!!}

  A:=Total;B:=Free;
  Writeln('Celkova pamet : ',A*16000);
  Writeln('Volna pamet   : ',B*16000);

  Error:=AllocatePages(4,Handle);CheckError(Error);{alokuje 4 ems stranky (64000)}
  Error:=GetAddress(Address);CheckError(Error);    {vezme adresu EMS (provest pouze 1)
                                                    vraci hodnotu Address(nemenit)!!!!}

  Page(0); {nastavi prvni stranku (Cislo=0)}
  Move(Data[1],Mem[Address:0],16000); {presune do EMS promennou data}


  Page(1); {nastavi druhou stranku (Cislo=1)}
  Move(Data[16000],Mem[Address:0],16000); {presune do EMS promennou data}
  A:=Total;B:=Free;
  Writeln('Celkova pamet : ',A*16000);
  Writeln('Volna pamet   : ',B*16000);
  
  readln;
  asm mov ax,13h;int 10h;end;
  Page(0);
  Move(Mem[Address:0],Mem[$A000:0],16000);
  readln;readln;
  asm mov ax,3h; int 10h; end;
  for c:= 1 to 20 do
   begin
    writeln(data[c]);
   end;
  readln;
  Error:=DeallocatePages(Handle);CheckError(Error); {dealokuje EMS (uvolni)}
end.
