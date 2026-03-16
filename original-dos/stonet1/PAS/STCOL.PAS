{WIZ}
unit stcol;

INTERFACE
var shine:word;
    gwx1,gwy1,gwx2,gwy2:word;

Procedure Pal(Col,R,G,B : Byte);
Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Procedure LoadPal (FileName : string);
Procedure Get_back;
Procedure Make_gwin(light,ram:byte);
Procedure Put_back;

IMPLEMENTATION
uses graph,vga256;

var rc,gc,bc,color:byte;
    frx,fry,size,maxshine:word;
    p:pointer;

Procedure Pal(Col,R,G,B : Byte);
Begin
   asm
      mov    dx,3c8h
      mov    al,[col]
      out    dx,al
      inc    dx
      mov    al,[r]
      out    dx,al
      mov    al,[g]
      out    dx,al
      mov    al,[b]
      out    dx,al
   end;
End;

Procedure GetPal(Col : Byte; Var R,G,B : Byte);
Var
   rr,gg,bb : Byte;
Begin
   asm
      mov    dx,3c7h
      mov    al,col
      out    dx,al

      add    dx,2

      in     al,dx
      mov    [rr],al
      in     al,dx
      mov    [gg],al
      in     al,dx
      mov    [bb],al
   end;
   r := rr;
   g := gg;
   b := bb;
end;


procedure LoadPal (FileName : string);
type DACType = array [0..255] of record
                                R, G, B : byte;
                              end;
var DAC : DACType;
    Fil : file of DACType;
    I : integer;
BEGIN
  assign (Fil, FileName);
  reset (Fil);
  read (Fil, DAC);
  close (Fil);
  for I := 0 to 255 do Pal(I,Dac[I].R,Dac[I].G,Dac[I].B);
end;

procedure get_back;
begin
size:=imagesize(gwx1,gwy1,gwx2,gwy2);
getmem(p,size);
getimage(gwx1,gwy1,gwx2,gwy2,p^);
end;

procedure put_back;
begin
freemem(p,size);
putimage(gwx1,gwy1,p^,0);
end;

procedure make_gwin(light,ram:byte);
begin
maxshine:=0;
if light>200 then light:=200;
for fry:=gwy1 to gwy2 do
 begin
  for frx:=gwx1 to gwx2 do
   begin
    color:=getpixel(frx,fry);
    if color<>0 then
     begin
      getpal(color,rc,gc,bc);
      shine:=trunc((rc+gc+bc)/3)+light;

      if (shine>=1) and (shine<=7) then putpixel(frx,fry,160);
      if (shine>=8) and (shine<=15) then putpixel(frx,fry,162);
      if (shine>=16) and (shine<=23) then putpixel(frx,fry,164);
      if (shine>=24) and (shine<=31) then putpixel(frx,fry,166);
      if (shine>=32) and (shine<=39) then putpixel(frx,fry,168);
      if (shine>=40) and (shine<=47) then putpixel(frx,fry,170);
      if (shine>=48) and (shine<=55) then putpixel(frx,fry,172);
      if (shine>=56) and (shine<=63) then putpixel(frx,fry,174);
      if (shine>=64) and (shine<=71) then putpixel(frx,fry,176);
      if (shine>=72) and (shine<=79) then putpixel(frx,fry,178);
      if (shine>=80) and (shine<=87) then putpixel(frx,fry,180);
      if (shine>=88) and (shine<=95) then putpixel(frx,fry,182);
      if (shine>=96) and (shine<=103) then putpixel(frx,fry,184);
      if (shine>=104) and (shine<=111) then putpixel(frx,fry,186);
      if (shine>=112) and (shine<=119) then putpixel(frx,fry,188);
      if (shine>=120) and (shine<=127) then putpixel(frx,fry,190);
      if (shine>=128) and (shine<=135) then putpixel(frx,fry,192);
      if (shine>=136) and (shine<=143) then putpixel(frx,fry,194);
      if (shine>=144) and (shine<=151) then putpixel(frx,fry,196);
      if (shine>=152) and (shine<=159) then putpixel(frx,fry,198);
      if (shine>=160) and (shine<=167) then putpixel(frx,fry,200);
      if (shine>=168) and (shine<=175) then putpixel(frx,fry,202);
      if (shine>=176) and (shine<=183) then putpixel(frx,fry,204);
      if (shine>=184) and (shine<=191) then putpixel(frx,fry,206);
      if (shine>=192) and (shine<=199) then putpixel(frx,fry,208);
      if (shine>=200) and (shine<=207) then putpixel(frx,fry,210);
      if (shine>=208) and (shine<=215) then putpixel(frx,fry,212);
      if (shine>=216) and (shine<=223) then putpixel(frx,fry,214);
      if (shine>=224) and (shine<=231) then putpixel(frx,fry,216);
      if (shine>=232) and (shine<=239) then putpixel(frx,fry,218);
      if (shine>=240) and (shine<=247) then putpixel(frx,fry,220);
      if (shine>=248) and (shine<=255) then putpixel(frx,fry,222);
      if shine>256 then putpixel(frx,fry,223);
      if shine>maxshine then maxshine:=shine+1;
     end;
   end;
 end;
if ram=1 then
 begin
  setcolor(maxshine-1);
  rectangle(gwx1,gwy1,gwx2,gwy2);
 end;
end;

BEGIN
END.