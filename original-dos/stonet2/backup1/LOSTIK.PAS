program losttest;

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

end.