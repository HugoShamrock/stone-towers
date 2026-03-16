uses crt,dos,ems,gif,graph,myska,snapshot,vga256;
{$M 16384,0,65535}

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
    {initgif,gifshow}
    data:array [1..16000] of byte;
    lines:array [0..319] of byte;
    {gif}
    gp:gifpicture;
    ps:rgbpalettesegment;
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

{procedure drawpoint(xcenter,ycenter:word;color:byte);assembler;
asm
  mov  ax,bufferseg
  mov  es,ax
  mov  al,color
  mov  bx,xcenter
  mov  dx,ycenter
  xchg dh,dl
  mov  di,dx
  shr  di,1
  shr  di,1
  add  di,dx
  add  di,bx
  mov  es:[di],al
end;}

{procedure gifshow(p:pr);
var x6:xr;y6:yr;
    i:integer;
begin
  p:=p*4+1;
  for i:=0 to 3 do
  begin
    page(p+i);move(mem[address:0],data,x4*y4);
    for y6:=0 to y4-1 do
    for x6:=0 to x4-1 do
    drawpoint(x6,y6+(i*y4),data[(y6*x4)+x6+1]);
 end;
end;}

procedure initgif(p:pr;fn:pathstr);
var x6:xr;y6:yr;
    i:integer;
begin
  p:=p*4+1;
  gp.openpicture(fn+'.gif');if gp.ok then
  begin if gp.gpalettesize>0 then
  begin ps:=gp.gpalette;for x6:=0 to pred(gp.gpalettesize) do with ps[x6] do
  begin r:=r shr 2;g:=g shr 2;b:=b shr 2;end;
  setrgbpalettesegment(0,gp.gpalettesize,ps);end else setgraypalette(ps);while gp.readblockheader do
  begin if gp.lpalettesize>0 then
  begin ps:=gp.lpalette;for x6:=0 to pred(gp.lpalettesize) do with ps[x6] do
  begin r:=r shr 2;g:=g shr 2;b:=b shr 2;end;
  setrgbpalettesegment(0,gp.lpalettesize,p);end;
  for i:=0 to 3 do
  begin
    for y6:=(i*y4) to y4-1+(i*y4) do
    begin gp.readline(lines);for x6:=0 to x4-1 do
    begin data[((y6-(i*y4))*x4)+(x6)+1]:=lines[x6];end;
    end;page(p+i);move(data[1],mem[address:0],x4*y4);
  end;
  gp.finishblock;end;gp.closepicture;end;
end;

procedure obuf(p:pr);
var i:integer;
begin
  p:=p*4+1;
  for i:=0 to 3 do
  begin
    page(p+i);
    move(mem[bufferseg:16000*i],mem[address:0],16000);
  end;
end;

procedure ibuf(p:pr);
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
  ibuf(9);
  if (s=2) and (y=0) then
  begin
    if x=1 then ibuf(1);
    if x=2 then ibuf(2);
    if x=3 then ibuf(3);
  end;
  if (x=4) and (y=0) then
  begin
    if s=1 then ibuf(6);
    if s=2 then ibuf(4);
    if s=3 then ibuf(5);
    if s=4 then ibuf(7);
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
  initvga256(vga256modes(11));
  {textures}
  initgif(0,'white');
  initgif(1,'1');
  initgif(2,'2');
  initgif(3,'3');
  initgif(4,'4');
  initgif(5,'p');
  initgif(6,'l');
  initgif(7,'b');
  initgif(8,'3ddeska1');
  initgif(9,'black');
  ibuf(0);putbuffer;
  {obuf(1);clearbuffer;ibuf(1);}
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
  closegraph;
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
