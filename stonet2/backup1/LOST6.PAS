program losttest;

uses lostgfxx,crt,dos;

{ buff1:array[0..0] of byte;
  uk1:^buff1;

  procedure init;
  begin
    getmem(uk1^,64000*sizeof buff1);
  end;
                                 }
var f:file;
    ob : pointer;
    zaloha:pointer;
    room:pointer; {no joke :o), jsou totiz takovy jiny, nedelaj na polich(array0..64000)}

    obadr,zaladr,romadr:word;

    qx,qy,y,pauza,s0x,bee,ppx,ppy:word;
    ch:char;
    ani:byte;
    sr:string;
    bitik:byte;

procedure loadni(co:string;kamx,kamy:word);
begin
 assign(f,co);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  putico(kamx,kamy,320,200,640,ob);
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
  getico(320,200,320,200,640,zaloha);
end;


begin



  getmem(zaloha,64000);
  getmem(ob,64000);
  getmem(room,64000);

  Init640x480x256;

  naspal('ch.col');

  getfont8x8; { chyba na 95-106,13 (8x8), v bufrech je zpusobena getfontem
                tedy ulozenim bios fontu do wordu,kterej se mi tam sere
                (hodit nekam do pointru, nebo udelat naky pole)}

  {puttrans(x,y:word;s,d:pointer);{x,y moc nepouzivat(kvuli preteceni pres okraje}
                                  {ale umisteni pouzivat az pri konecnem vykresleni}
                                  {bufru na screen}

  qx:=1;qy:=1;{1 = stred}
  ani:=1;pauza:=1;s0x:=0;bee:=10;

  obadr:=seg(ob^);
  zaladr:=seg(zaloha^);
  romadr:=seg(room^);

 chb;
 loadni('pan1.cel',0,400);
 loadni('pan2.cel',320,400);

 getit;



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

 s0x:=s0x+1;


 if (s0x=bee) then
  begin
   ani:=ani+1;
   if ani>7 then ani:=1;

   str(ani,sr);

   assign(f,'cha'+sr+'.cel');
   reset(f,1);
   seek(f,800);
   blockread(f,ob^,64000,y);
   close(f);

   {PutIco(320,200,320,200,640,zaloha);}

{   cls(obadr,0);
   for ppy:=1 to 200 do
    begin
     for ppx:=1 to 320 do
      begin
       bitik:=getpixel(ppx,ppy,zaladr);
       putpixel(ppx,ppy,bitik,obadr);
      end;
    end;

    putico(0,0,320,200,640,ob);}

{   flip(zaladr,romadr);
   puttrans(0,0,ob,room);

   puticoK(320,200,320,200,640,room,0);}

   s0x:=1;
 end;

{cls(obadr,0);
 sr:='realtime rendering : lostGFX v1.3';
 outtext(2,2,3,8,sr,obadr);
 outtext(1,1,4,8,sr,obadr);
 puticoK(0,0,320,200,640,ob,0);}



 pockej;

until ch=#27;

InitText;

freemem(zaloha,64000);
freemem(ob,64000);
freemem(room,64000);

end.