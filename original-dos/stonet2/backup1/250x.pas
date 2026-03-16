uses crt,dos,ems,lostgfxx;

const pages=80; {800=12.8mb}
      x4=320;
      y4=50;

type  xr=0..x4;
      yr=0..y4*4;
      sr=0..5; {0nic, 1sever, 2vychod, 3jih, 4zapad, 5nic}
      pr=0..pages;

var {main}
    x,xtmp:xr;
    y,ytmp:yr;
    s:sr;
    rk:char;
    {ems}
    address,error,free,handle,total:word;
    {buffer}
    buffer:pointer;
    bufferseg:word;

procedure page(number:word);
begin
  error:=mappages(handle,number,0);
  checkerror(error);
end;

procedure clearbuffer;assembler;
asm
  mov ax,bufferseg
  mov es,ax
  xor di,di
  xor ax,1
  mov cx,32000
  rep stosw
end;

procedure putbuffer;assembler;
asm
  push ds
  mov ax,40960 {A000h -> 40960}{+20}
  mov es,ax
  mov ax,bufferseg
  mov ds,ax
  xor si,si
  xor di,di
  mov cx,32000
  rep movsw
  pop ds
end;

procedure inpage(p:pr);
var i:integer;
begin
  p:=p*4+1;
  for i:=0 to 3 do
  begin
    page(p+i);
    move(mem[bufferseg:16000*i],mem[address:0],16000);
  end;
end;

procedure inbufr(p:pr);
var i:integer;
begin
  p:=p*4+1;
  for i:=0 to 3 do
  begin
    page(p+i);
    move(mem[address:0],mem[bufferseg:16000*i],16000);
  end;
end;

procedure keys72;
begin
  case s of
    1:ytmp:=ytmp-1;
    2:xtmp:=xtmp+1;
    3:ytmp:=ytmp+1;
    4:xtmp:=xtmp-1;
  end;
end;

procedure keys75;
begin
  case s of
    1:xtmp:=xtmp-1;
    2:ytmp:=ytmp-1;
    3:xtmp:=xtmp+1;
    4:ytmp:=ytmp+1;
  end;
end;

procedure keys77;
begin
  case s of
    1:xtmp:=xtmp+1;
    2:ytmp:=ytmp+1;
    3:xtmp:=xtmp-1;
    4:ytmp:=ytmp-1;
  end;
end;

procedure keys80;
begin
  case s of
    1:ytmp:=ytmp+1;
    2:xtmp:=xtmp-1;
    3:ytmp:=ytmp-1;
    4:xtmp:=xtmp+1;
  end;
end;

procedure test;
begin
  if s=0 then s:=4;
  if s=5 then s:=1;
  x:=xtmp;
  y:=ytmp;
end;

procedure view;
begin
  inbufr(9);
  if (s=2) and (y=0) then
  begin
    if x=1 then inbufr(1);
    if x=2 then inbufr(2);
    if x=3 then inbufr(3);
  end;
  if (x=4) and (y=0) then
  begin
    if s=1 then inbufr(6);
    if s=2 then inbufr(4);
    if s=3 then inbufr(5);
    if s=4 then inbufr(7);
  end;
  putbuffer;
end;

procedure init;
begin
  {ems}
  if not emsinstalled then emserror('Neni nainstalovan ovladac EMS pameti!');
  error:=getfreepages(total,free);checkerror(error);
  error:=allocatepages(pages,handle);checkerror(error);
  error:=getaddress(address);checkerror(error);
  {buffer}
  getmem(buffer,32000);bufferseg:=seg(buffer^);
  {vga}
  Init640x480x256;
  {textures}
  x:=0;
  y:=0;
  s:=2;
end;

procedure main;
begin
  repeat
    rk:=readkey;
    if (rk=#71) or (rk=#72) or (rk=#73) or
       (rk=#75) or (rk=#77) or (rk=#80) then
    begin
      xtmp:=x;
      ytmp:=y;
      case rk of
        #71: s:=s-1;   #72: keys72;   #73: s:=s+1;
        #75: keys75;   #77: keys77;   #80: keys80;
      end;
      test;
      {schovej_mysku;}
      view;
      {ukaz_mysku;}
    end;
  until rk=#27;
end;

procedure done;
begin
  {vga}
  InitText;
  {buffer}
  freemem(buffer,32000);
  {ems}
  error:=deallocatepages(handle);checkerror(error);
end;

begin
  init;
  main;
  done;
end.

{program losttest;

uses lostgfx,crt,dos;

{type
     par = ^ar;
     ar = array [1..64000] of byte;}

var f:file;
    ob : pointer;
    zaloha:pointer;

    qx,qy,xxx,y,pauza,frk:word;
    ch:char;
    smx,smy:boolean;
    r,ani:byte;
    sr:string;




procedure SetFrekv(frequency : word); {pro monitor}
var counter:word;
begin
  if frequency=0 then counter:=0 else
  counter := $1234DD div frequency;
  Port[$43] := $34;
  Port[$40] := counter mod 256;
  Port[$40] := counter div 256;
end;

procedure loadni(co:string;kamx,kamy:word);
begin
 assign(f,co);

  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoKr(kamx,kamy,320,200,640,ob,255);
  delay(pauza);
end;

procedure chb;
begin
 loadni('chb1.cel',0,0);
 loadni('chb2.cel',320,0);
 loadni('chb3.cel',0,200);
 loadni('chb4.cel',320,200);
end;

procedure chf;
begin
 loadni('chf11.cel',0,0);
 loadni('chf12.cel',320,0);
 loadni('chf13.cel',0,200);
 loadni('chf14.cel',320,200);

  delay(pauza);

 loadni('chf21.cel',0,0);
 loadni('chf22.cel',320,0);
 loadni('chf23.cel',0,200);
 loadni('chf24.cel',320,200);
end;

procedure chbf;
begin
 loadni('chf11.cel',0,0);
 loadni('chf12.cel',320,0);
 loadni('chf13.cel',0,200);
 loadni('chf14.cel',320,200);

  delay(pauza);

  chb;
end;

procedure chl;
begin
 loadni('chl1.cel',0,0);
 loadni('chl2.cel',320,0);
 loadni('chl3.cel',0,200);
 loadni('chl4.cel',320,200);
end;

procedure chr;
begin
 loadni('chr1.cel',0,0);
 loadni('chr2.cel',320,0);
 loadni('chr3.cel',0,200);
 loadni('chr4.cel',320,200);
end;

procedure getit;
begin

  geticor(1,1,50,50,640,zaloha);
end;

begin

  pauza:=1;

  getmem(zaloha,64000);
  getmem(ob,64000);
  Init640x480x256;
  naspal('ch.col');

  {setvirtobr(640);}

   chb;
   qx:=1;qy:=1;{1 = stred}
   ani:=0;

 loadni('pan1.cel',0,400);
 loadni('pan2.cel',320,400);

repeat

if keypressed then ch:=readkey;

if ch=#0 then
 begin
  ch:=readkey;
  if (ch=#75)and(qx=1)and(qy=1) then
   begin qx:=0;chl;getit;end;
  if (ch=#75)and(qx=2)and(qy=1) then
   begin qx:=1;chb;getit;end;
  if (ch=#77)and(qx=1)and(qy=1) then
   begin qx:=2;chr;getit;end;
   if (ch=#77)and(qx=0)and(qy=1) then
   begin qx:=1;chb;getit;end;
  if (ch=#72)and(qy=1)and(qx=1) then
   begin qy:=0;chf;getit;end;
  if (ch=#72)and(qy=1)and(qx=0) then
   begin qy:=0;qx:=1;chb;delay(pauza);chf;getit;end;
  if (ch=#72)and(qy=1)and(qx=2) then
   begin qy:=0;qx:=1;chb;delay(pauza);chf;getit;end;
  if (ch=#80)and(qy=0)and(qx=1) then
   begin qy:=1;chbf;getit;end;

 end;

ani:=ani+1;
if ani>7 then ani:=1;

str(ani,sr);

 assign(f,'cha'+sr+'.cel');
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);

  PutIcoKr(400,260,50,50,640,zaloha,0);
  puticoKr(400,260,320,200,640,ob,0);

    pockej;

until ch=#27;



InitText;

freemem(zaloha,64000);
freemem(ob,64000);

end.}