unit rat;

interface

uses dos;

const seta:array[0..15,0..7] of word=(
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,130,130,130,130,999,999),
 (999,130, 14, 37, 37, 14,130,999),
 (999,130, 37, 37, 37, 14,130,999),
 (130, 14,130, 37, 37,130, 14,130),
 (130, 37,130, 37, 37,130, 14,130),
 (130, 37, 37, 37, 37, 37, 14,130),
 (130, 37, 37, 37, 37, 37, 14,130),
 (130, 37,130, 37, 37,130, 14,130),
 (130, 14, 37,130,130, 14, 14,130),
 (999,130, 37, 37, 14, 14,130,999),
 (999,130, 14, 14, 14, 14,130,999),
 (999,999,130,130,130,130,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999)
 );

var buf:array[0..255] of byte;
    mode,co,n,m,xmax,ymax,mxmax:word;
    sos,ooo:word;
    bank:byte;
    oldbank:word;
    mx,my,mb,omx,omy:word;
    mask:array[0..15,0..7] of byte;  { mask of mouse pointer }
    oldseg,oldofs,oldmask:word;
    newseg,newofs,newmask:word;

 procedure SetPixel(X, Y : Word; C : word);  { VESA putpixel }
 function GetPixel(X, Y : Word):byte;
{ procedure newmouse(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP : word);}
 procedure initmysak;
 procedure hidemouse;
 procedure showmouse;
 Procedure SetPosition(Xpos,Ypos : integer);

implementation

procedure SetPixel(X, Y : Word; C : word);  { VESA putpixel }
var b,z1,z2,z3,q,w:longint;
    bnk:word;

begin
 if c<256 then
  begin       { if color <256 change, else dont put the pixel }
   z1:=y;z2:=xmax;            { swaping x,y to longint vars }
   q:=z1*z2+x;                { calculating offset }
   z3:=memw[sos:ooo+6];
   z3:=z3*1024;
   if z3=0 then z3:=1;
   b:=q div z3;
   bnk:=b*bank;                 { calculating effective Bank # }
   if oldbank<>b then
    begin
     asm
      mov ax,$4f05
      mov bx,0
      mov dx,bnk
      int $10
     end;   { Change to Bank # }
     oldbank:=b;
    end;
   if ((x<xmax) and (y<ymax)) then mem[$a000:q]:=c; {screen dimmensions}
 end;
end;

function GetPixel(X, Y : Word):byte;
var z1,z2,q,w:longint;
    b:word;
begin
 z1:=y;z2:=xmax;
 q:=z1*z2+x;
 b:=q div 65536;
 b:=b*bank;
 if oldbank<>b then
  begin
   asm
    mov ax,$4f05
    mov bx,0
    mov dx,b
    int $10
   end;
   oldbank:=b;
  end;
 getpixel:=mem[$a000:q];
end;

procedure newmouse(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP : word);interrupt;
var hx,hy,hb,ev:word;
    hn,hm:integer;
begin
 ev:=ax;
 hx:=cx div 4;
 hy:=dx;
 hb:=bx;
 mb:=hb;
 if ((hx<>mx) or (hy<>my)) then
  begin
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     setpixel(mx+hm,my+hn,mask[hn,hm]);
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     mask[hn,hm]:=getpixel(hx+hm,hy+hn);
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     setpixel(hx+hm,hy+hn,seta[hn,hm]);
   mx:=hx;
   my:=hy;
  end;
 inline ($8B/ $E5/ $5D/ $07/ $1F/ $5F/ $5E/ $5A/ $59/$5B/ $58/ $CB);
end;

Procedure SetPosition(Xpos,Ypos : integer);
var Regs : registers;
Begin
     Regs.AX := $04;
     Regs.CX := Xpos;
     Regs.DX := Ypos;
     Intr($33,Regs);
End;


procedure hidemouse;
var hn,hm:integer;
begin
 omx:=mx;omy:=my;
 asm
  mov ax,0
  int $33
  mov ax,1
  int $33
  mov ax,2
  int $33
 end;
 for hn:=0 to 15 do
    for hm:=0 to 7 do
     setpixel(mx+hm,my+hn,mask[hn,hm]);
end;

procedure showmouse;
begin
 asm
  mov ax,0
  int $33    { mouse ? }
  mov ax,1
  int $33    { Show Mouse }
  mov ax,7
  mov cx,0
  mov dx,mxmax
  int $33
  mov ax,8
  mov cx,0
  mov dx,ymax  { Set YMAX for mouse windows }
  int $33
  mov ax,20
  mov cx,newmask
  mov es,newseg
  mov dx,newofs
  int $33      { Active USER Mouse Routine }
  mov ax,$000f
  mov cx,4
  mov dx,4
  int $33
 end;
setposition(omx,omy);
end;


procedure initmysak;
begin

 mx:=0;
 my:=0;
 mode:=$101; { nas Vesa mode }
 sos:=seg(buf);
 ooo:=ofs(buf[0]); { pointing VESA information Buffer }
 oldbank:=0;

  asm
  mov ax,$4f01
  mov cx,mode
  mov es,sos
  mov di,ooo
  int $10
 end; { Get VESA info }

if memw[sos:ooo+4]=0 then memw[sos:ooo+4]:=1;
 bank:=memw[sos:ooo+6] div memw[sos:ooo+4];
 { Granularity }

 xmax:={639}memw[sos:ooo+$12];
 ymax:={479}memw[sos:ooo+$14];
 if xmax=0 then begin xmax:=320;ymax:=200;bank:=0;end;
 { Get Screen Size }

  { pick up (0,0) mask }
 for n:=0 to 15 do
  for m:=0 to 7 do
   mask[n,m]:=getpixel(m,n);

 newseg:=seg(newmouse);
 newofs:=ofs(newmouse); { pointing to new mouse routine }
 newmask:=1;

 mxmax:=xmax*4;



end;

BEGIN
END.