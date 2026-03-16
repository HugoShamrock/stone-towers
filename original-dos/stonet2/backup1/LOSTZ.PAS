program losttest;

uses lostgfx,crt,dos;

type
     par = ^ar;
     ar = array [1..64000] of byte;

var f:file;
    ob : pointer;
    zaloha:par;
    zalohaadr:word;
    qx,qy,xxx,y,pauza,frk:word;
    ch:char;
    smx,smy:boolean;
    r,ani:byte;
    sr:string;

    CELfile:file of byte; {CEL soubor byte}
    bitik:byte;           {pomocna promena pro nacitani byte souboru}

procedure SetFrekv(frequency : word); {pro monitor}
var counter:word;
begin
  if frequency=0 then counter:=0 else
  counter := $1234DD div frequency;
  Port[$43] := $34;
  Port[$40] := counter mod 256;
  Port[$40] := counter div 256;
end;

procedure chb;
begin
 assign(f,'chb1.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chb2.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chb3.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chb4.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);
end;

procedure chf;
begin
 assign(f,'chf11.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chf12.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chf13.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chf14.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);

  delay(pauza);

   assign(f,'chf21.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chf22.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chf23.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chf24.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);
end;

procedure chbf;
begin
 assign(f,'chf11.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chf12.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chf13.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chf14.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);

  delay(pauza);

  chb;
end;

procedure chl;
begin
 assign(f,'chl1.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chl2.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chl3.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chl4.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);
end;

procedure chr;
begin
 assign(f,'chr1.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,0,320,200,ob);
 assign(f,'chr2.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,0,320,200,ob);
 assign(f,'chr3.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,200,320,200,ob);
 assign(f,'chr4.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,200,320,200,ob);
end;


begin
  writeln;writeln;write;
  writeln;textcolor(8);
  writeln('_______________________________________________________________________________');
  writeln;textcolor(15);write('lostGFX v1.1');
  textcolor(8);write(' 640x480x256 graphic engine (c)1998 WIZard Raist');
  writeln;
  writeln('_______________________________________________________________________________');
  writeln;
  textcolor(15);
  writeln('                                STONE TOWERS II');
  textcolor(8);
  writeln('_______________________________________________________________________________');
  writeln;writeln;write;
  write('Pauza:');read(pauza);
  writeln;write;
  write('Freq:');read(frk);
  writeln;writeln;write;

  getmem(zaloha,64000);
  getmem(ob,64000);
  zalohaadr:= seg(zaloha^);
  Init640x480x256;
  setfrekv(frk);
  naspal('ch.col');


   chb;
   qx:=1;qy:=1;{1 = stred}
   ani:=0;

 assign(f,'pan1.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,400,320,80,ob);
 assign(f,'pan2.cel');
  setvirtobr(320);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(320,400,320,80,ob);



repeat

if keypressed then ch:=readkey;

if ch=#0 then
 begin
  ch:=readkey;
  if (ch=#75)and(qx=1)and(qy=1) then
   begin qx:=0;chl;end;
  if (ch=#75)and(qx=2)and(qy=1) then
   begin qx:=1;chb;end;
  if (ch=#77)and(qx=1)and(qy=1) then
   begin qx:=2;chr;end;
   if (ch=#77)and(qx=0)and(qy=1) then
   begin qx:=1;chb;end;
  if (ch=#72)and(qy=1)and(qx=1) then
   begin qy:=0;chf;end;
  if (ch=#72)and(qy=1)and(qx=0) then
   begin qy:=0;qx:=1;chb;delay(pauza);chf;end;
  if (ch=#72)and(qy=1)and(qx=2) then
   begin qy:=0;qx:=1;chb;delay(pauza);chf;end;
  if (ch=#80)and(qy=0)and(qx=1) then
   begin qy:=1;chbf;end;
 end;

  pockej;

{geticor(1,1,50,50,640,zaloha);

ani:=ani+1;
if ani>7 then ani:=1;

str(ani,sr);

assign(f,'cha'+sr+'.cel');
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  puticoNK(0,400,320,80,ob);

PutIcoKr(1,1,50,50,640,zaloha,0);
}
until ch=#27;



InitText;

freemem(zaloha,64000);

 writeln('_______________________________________________________________________________');
  writeln;textcolor(15);write('lostGFX v1.1');
  textcolor(8);write(' 640x480x256 graphic engine (c)1998 WIZard Raist');
  writeln;
  writeln('_______________________________________________________________________________');
  writeln;
  textcolor(15);
  writeln('                                STONE TOWERS II');
  textcolor(8);
  writeln('_______________________________________________________________________________');
  writeln;writeln;
  textcolor(15);
end.