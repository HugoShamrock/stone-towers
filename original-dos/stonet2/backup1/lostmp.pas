uses lostgfxx,crt,dos;

var f:file;

    obadr,zaladr,romadr:word;

    qx,qy,y,pauza,s0x,bee,ppx,ppy:word;
    ch:char;
    ani:byte;
    sr:string;
    bitik:byte;

    sra,srb:word;

procedure loadni(co:string;kamx,kamy:word);
begin
 assign(f,co);
  reset(f,1);
  seek(f,800);
    blockread(f,ob^,64000,y);
  close(f);
  putico(kamx,kamy,640,100,640,ob);
  delay(pauza);
end;




procedure naspalCEL(jm:string);
var f : file;
    kolik  : integer;
    paleta:array[0..767] of byte;
    segm:word;
    ofsm:word;

begin
  assign(f,jm);
  reset(f,1);
  seek(f,32);
  blockread(f,paleta,768,kolik);
  segm:=seg(paleta);
  ofsm:=ofs(paleta);
  asm
    mov ax,1012h
    mov bx,0h
    mov cx,100h
    mov es, segm
    mov dx, ofsm
    int 10h
  end;
  close(f);
end;


procedure getit;
begin
  {assign(f,'malej.cel');
   reset(f,1);
   seek(f,800);
   blockread(f,zaloha^,64000);
   close(f);
   {flip(zaladr,romadr);}
  getico(0,0,640,100,640,zaloha);
end;




begin



  naspalCEL('ut1.cel');

  ani:=1;pauza:=1;s0x:=0;bee:=2;

  obadr:=seg(ob^);
  zaladr:=seg(zaloha^);
  romadr:=seg(room^);

 chb;


 getit;

 putico(0,100,640,100,640,zaloha);



repeat

if keypressed then ch:=readkey;

{if ch=#0 then
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
}

{ s0x:=s0x+1;


 if (s0x=bee) then
  begin}
   ani:=ani+1;
   if ani>7 then ani:=1;

   str(ani,sr);

   assign(f,'cha'+sr+'.cel');
   reset(f,1);
   seek(f,800);
   blockread(f,ob^,64000,y);
   close(f);


 {  PutIco(0,0,640,100,640,zaloha);}

   flip(zaladr,romadr);
   puttrans(0,0,ob,room);

   putico(0,100,640,100,640,room);

{   for ppy:=1 to 200 do
    begin
     for ppx:=1 to 320 do
      begin
       bitik:=getpixel(ppx,ppy,$a000);
       putpixel(320+ppx,0+ppy,bitik,$a000);
      end;
    end;}

{   s0x:=1;
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