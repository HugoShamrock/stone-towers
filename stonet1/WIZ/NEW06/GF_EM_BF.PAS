{ \/ tohle je jeste nejaka prapuvodni verze davani GIFu do EMSky}
program GIF_TO_EMS;
{WIZ}

uses  Dos,crt,
 Graph, VGA256, GIF, Snapshot,ems,myskame;{misto myskame de dat normalni myska}

type radka=array [0..319] of byte;

{ \/ muj kurzor mysi,muze se i nacist GIFem do tohdle pole,nebo ho 
  \/  udelat CELem s ukazatelem}
const mysak:array[1..16,1..16] of word=
            ((1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (1,11,11,1,0,0,0,0,0,0,0,0,0,0,0,0),
             (1,11,1,11,1,0,0,0,0,0,0,0,0,0,0,0),
             (0,1,11,1,11,1,0,0,0,0,0,0,0,0,0,0),
             (0,0,1,11,1,11,1,0,0,0,0,0,0,0,0,0),
             (0,0,0,1,11,1,11,1,0,0,0,0,8,0,0,0),
             (0,0,0,0,1,11,1,11,1,0,0,8,8,0,0,0),
             (0,0,0,0,0,1,11,1,11,1,8,8,0,0,0,0),
             (0,0,0,0,0,0,1,11,1,8,8,0,0,0,0,0),
             (0,0,0,0,0,0,0,1,8,8,6,0,0,0,0,0),
             (0,0,0,0,0,0,0,8,8,6,6,6,0,0,0,0),
             (0,0,0,0,0,0,8,8,0,0,6,6,6,0,0,0),
             (0,0,0,0,0,8,8,0,0,0,0,6,6,6,8,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,6,8,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));

var   G : GIFPicture;
      karta:integer;
      FN : PathStr;
      xres, yres ,fr,frx,fry,frxx: word;
      P : RGBPaletteSegment;
      x, y,xmsk,ymsk,frcmx,frcmy: word;
      {xmsk,ymsk:integer;}
      Lines : array [ 0 .. 320 ] of byte;
      radek:array [0 .. 319] of integer;
      Error:Word;
      Total,Free:Word;
      Handle:Word;
      Address:Word;
      A,B:longint;
      pomdata,strana,pocstr:word;
      data: Array [1..16000] of byte;
      radky:array [0..49] of radka;
      ch:char;
      { \/ bafr}
      Buffer      : pointer;
      BufferSeg   : word;
      tlc1,tlc2,tlc3:boolean;

procedure Page(Number:Word);
begin
  Error:=MapPages(Handle,Number,0);CheckError(Error); {namapuje stranku}
end;

procedure checking;{vypis a kontrola volne pameti}
begin
  If not EMSInstalled then EMSError('neni nainstalovan ovladac EMS pameti!');{otestuje ovladac EMS pameti}
  Error:=GetFreePages(Total,Free);CheckError(Error); {jen jednou}
  A:=Total;B:=Free;
  Writeln('Celkova pamet : ',A*16000);
  Writeln('Volna pamet   : ',B*16000);
end;

procedure alokujems;
begin
  Error:=AllocatePages(8,Handle);CheckError(Error);{alokuje 4 ems stranky (64000)}
  Error:=GetAddress(Address);CheckError(Error); {jen jednou}
end;

Procedure ClearBuffer; assembler;
Asm
  mov ax,BufferSeg
  mov es,ax
  xor di,di
  xor ax,ax
  mov cx,32000
  rep stosw
End;

Procedure PutBuffer; assembler;
Asm
  push ds
  mov ax,0A000h
  mov es,ax
  mov ax,BufferSeg
  mov ds,ax
  xor si,si
  xor di,di
  mov cx,32000
  rep movsw
  pop ds
End;

Procedure DrawPoint(XCenter,YCenter:word;Color:byte);
Var
  X,Y:word;
Begin
  X:=XCenter;
  Y:=YCenter;
  if (X<320) and (Y<200) then
    Asm
      mov  ax,BufferSeg
      mov  es,ax
      mov  al,Color
      mov  bx,X
      mov  dx,Y
      xchg dh,dl
      mov  di,dx
      shr  di,1
      shr  di,1
      add  di,dx
      add  di,bx
      mov  es:[di],al
    End;
End;

procedure piszems;{vypise obsah stranek z EMS}
begin
repeat
schovej_mysku;
setcolor(1);
outtextxy(0,180,'Vypis rovnou z ems');
page(2);
Move(Mem[Address:0],mem[$a000:0],16000);
outtextxy(0,180,'Vypis rovnou z ems');
outtextxy(0,0,'ENTER');
outtextxy(0,12,'ESC');
page(3);
Move(Mem[Address:0],Mem[$a000:16000],16000);
outtextxy(0,180,'Vypis rovnou z ems');
page(4);
Move(Mem[Address:0],Mem[$a000:32000],16000);
outtextxy(0,180,'Vypis rovnou z ems');
page(5);
Move(Mem[Address:0],Mem[$a000:48000],16000);
ukaz_mysku;
outtextxy(0,0,'ENTER');
outtextxy(0,12,'ESC');
outtextxy(0,180,'Vypis rovnou z ems');
until keypressed;
cleardevice;
frxx:=1;
repeat
page(2);move(mem[address:0],radky,16000);
for fry:=0 to 49 do
 begin
  for frx:=0 to 319 do
   begin
    if radky[fry,frx]<>0 then drawpoint(frx,fry,radky[fry,frx]);
   end;
 end;

page(3);move(mem[address:0],radky,16000);
for fry:=50 to 99 do
 begin
  for frx:=0 to 319 do
   begin
    if radky[fry-50,frx]<>0 then drawpoint(frx,fry,radky[fry-50,frx]);
   end;
 end;

page(4);move(mem[address:0],radky,16000);
for fry:=100 to 149 do
 begin
  for frx:=0 to 319 do
   begin
    if radky[fry-100,frx]<>0 then drawpoint(frx,fry,radky[fry-100,frx]);
   end;
 end;

page(5);move(mem[address:0],radky,16000);
for fry:=150 to 199 do
 begin
  for frx:=0 to 319 do
   begin
    if radky[fry-150,frx]<>0 then drawpoint(frx,fry,radky[fry-150,frx]);
   end;
 end;
 schovej_mysku;
 { vsechno nacte(nalepi) do bafru a zobrazi ho}
 putbuffer;
 clearbuffer;
 { pak ukaze mys}
 ukaz_mysku;
if keypressed then
 begin
  ch:=readkey;
   if ch=#9 then
    begin
    schovej_mysku;
    {vypnu normalni mysi kurzor}
    cleardevice;
    frxx:=1;
     repeat
           page(2);move(mem[address:0],radky,16000);
           for fry:=0 to 49 do
           begin
           for frx:=0 to 319 do
           begin
           if radky[fry,frx]<>0 then drawpoint(frx,fry,radky[fry,frx]);
           end;
           end;

                 page(3);move(mem[address:0],radky,16000);
                 for fry:=50 to 99 do
                 begin
                 for frx:=0 to 319 do
                 begin
                 if radky[fry-50,frx]<>0 then drawpoint(frx,fry,radky[fry-50,frx]);
                 end;
                 end;

                    page(4);move(mem[address:0],radky,16000);
                    for fry:=100 to 149 do
                    begin
                    for frx:=0 to 319 do
                    begin
                    if radky[fry-100,frx]<>0 then drawpoint(frx,fry,radky[fry-100,frx]);
                    end;
                    end;

                      page(5);move(mem[address:0],radky,16000);
                      for fry:=150 to 199 do
                      begin
                      for frx:=0 to 319 do
                      begin
                      if radky[fry-150,frx]<>0 then drawpoint(frx,fry,radky[fry-150,frx]);
                      end;
                      end;
                { /\ vsechno nalepim do bafru}

                pozice_mysky(xmsk,ymsk,tlc1,tlc2,tlc3);
                xmsk:=trunc(xmsk/2);
                {dosadim svoji mys}
                for frcmy:=1 to 16 do
                 begin
                  for frcmx:=1 to 16 do
                   begin
                    if mysak[frcmy,frcmx]<>0 then drawpoint(frcmx+xmsk,frcmy+ymsk,mysak[frcmy,frcmx]);
                   end;
                 end;
                {dam i ji do bafru a zobrazim ho}
                putbuffer;
                clearbuffer;
                {ukaz_mysku; }
                setcolor(1);
                outtextxy(0,0,'ENTER');
                outtextxy(0,180,'Vypis z bufru s moji mysi');
         if keypressed then
         begin
         ch:=readkey;
         end;
     until ch=#13;
     ukaz_mysku;
    end;
 end;
 setcolor(1);
 outtextxy(0,0,'TAB');
 outtextxy(0,12,'ESC');
 outtextxy(0,180,'Vypis z bufru s myskou');
until ch=#27;
cleardevice;
setcolor(1);
outtextxy(0,0,'ENTER');
setcolor(15);
outtextxy(0,150,'Vypis z ems nepripada v uvahu,vypis z ');
outtextxy(0,160,'bafru s myskou je dobry, vypis s moji');
outtextxy(0,170,'myskou je nejlepsi jen se asi nehodi');
outtextxy(0,180,'pro prilis rychle pohyby.    WIZ Raist');
end;



procedure dealokujems;
begin
Error:=DeallocatePages(Handle);CheckError(Error); {dealokuje EMS (uvolni)}
end;

procedure strana0;
begin
Page(2); {nastavi nulovou stranku (Cislo=0)}
Move(Data[1],Mem[Address:0],16000); {presune do EMS promennou data}
end;     {^odkud}
procedure strana1;
begin
Page(3);
Move(Data[1],Mem[Address:0],16000);
end;
procedure strana2;
begin
Page(4);
Move(Data[1],Mem[Address:0],16000);
end;
procedure strana3;
begin
Page(5);
Move(Data[1],Mem[Address:0],16000);
end;

procedure gifshowtoems(fn:pathstr);
begin
  G.OpenPicture(FN);
  if G.Ok then
    begin
      InitVGA256(VGA256Modes(0));
      ukaz_mysku;
      if G.GPaletteSize>0 then
        begin
          P := G.GPalette;
          for x := 0 to pred(G.GPaletteSize) do
            with P[x] do
              begin
                R := R shr 2;
                G := G shr 2;
                B := B shr 2;
              end;
          SetRGBPaletteSegment(0,G.GPaletteSize,P);
        end               else
        SetGrayPalette(P);
      while G.ReadBlockHeader do
        begin
          if G.LPaletteSize>0 then
            begin
              P := G.LPalette;
              for x := 0 to pred(G.LPaletteSize) do
                with P[x] do
                  begin
                    R := R shr 2;
                    G := G shr 2;
                    B := B shr 2;
                  end;
              SetRGBPaletteSegment(0,G.LPaletteSize,P);
            end;
          xres := succ(GetMaxx-G.BlockHeader.x0);
          if xres>G.BlockHeader.Width then xres := G.BlockHeader.Width;
          yres := succ(GetMaxy-G.BlockHeader.y0);
          if yres>G.BlockHeader.Height then yres := G.BlockHeader.Height;
          pomdata:=0;strana:=0;
          for y := 0 to pred(yres) do
            begin
              G.ReadLine(Lines);
              for x := 0 to pred(xres) do
               begin
                pomdata:=pomdata+1;

                if (strana=0) and (pomdata=16000) then
                 begin
                  strana0;
                  pomdata:=0;
                  strana:=1;
                 end;
                if (strana=1) and (pomdata=16000) then
                 begin
                  strana1;
                  pomdata:=0;
                  strana:=2;
                 end;
                if (strana=2) and (pomdata=16000) then
                 begin
                  strana2;
                  pomdata:=0;
                  strana:=3;
                 end;
                if (strana=3) and (pomdata=16000) then
                 begin
                  strana3;
                  pomdata:=0;
                  exit;
                 end;
                data[pomdata]:=lines[x];
                {PutPixel(x,y,Lines[x]);}
               end;
            end;
          G.FinishBlock;
        end;
      G.ClosePicture;
      SetViewPort(0,0,GetMaxx,GetMaxy,true);
    end;
   end;


BEGIN
karta:=1;
GetMem(Buffer,64000);
  BufferSeg:=seg(Buffer^);
  clearbuffer;
checking;
alokujems;
gifshowtoems('agmtit.gif');

piszems;
readln;
schovej_mysku;
dealokujems;
END.