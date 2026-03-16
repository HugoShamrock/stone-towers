uses crt,dos,ems,gif,graph,myska,snapshot,vga256;
{$M 16384,0,65535}

type xr=0..320;
     yr=0..200;
     sr=0..5; {0nic, 1sever, 2vychod, 3jih, 4zapad, 5nic}

const pages=80; {800=12.8mb}
type  pr=0..pages;

const x4=320;y4=50;

var {main}
    x,xtmp:xr;
    y,ytmp:yr;
    s,stmp:sr;
    rk:char;
    {initgif,gifshow}
    data:array [1..16000] of byte;
    lines:array [0..319] of byte;
    {gif}
    fn:pathstr;
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

procedure drawpoint(xcenter,ycenter:word;color:byte);assembler;
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
end;

procedure gifshow(p:pr);
var x6:xr;y6:yr;
    i:integer;
begin
  for i:=0 to 3 do
  begin
    page(p+i);move(mem[address:0],data,x4*y4);
    for y6:=0 to y4-1 do
    for x6:=0 to x4-1 do
    drawpoint(x6,y6+(i*y4),data[(y6*x4)+x6+1]);
 end;
end;

procedure initgif(p:pr);
var x6:xr;y6:yr;
    i:integer;
begin
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
  for i:=0 to 3 do
  begin
    page(p+i);
    move(mem[bufferseg:16000*i],mem[address:0],16000);
  end;
end;

procedure ibuf(p:pr);
var i:integer;
begin
  for i:=0 to 3 do
  begin
    page(p+i);
    move(mem[address:0],mem[bufferseg:16000*i],16000);
  end;
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
  initvga256(vga256modes(0));
end;

procedure keys72;
begin
  case stmp of
    1:ytmp:=ytmp-1;
    2:xtmp:=xtmp+1;
    3:ytmp:=ytmp+1;
    4:xtmp:=xtmp-1;
  end;
end;

procedure keys75;
begin
  case stmp of
    1:xtmp:=xtmp-1;
    2:ytmp:=ytmp-1;
    3:xtmp:=xtmp+1;
    4:ytmp:=ytmp+1;
  end;
end;

procedure keys77;
begin
  case stmp of
    1:xtmp:=xtmp+1;
    2:ytmp:=ytmp+1;
    3:xtmp:=xtmp-1;
    4:ytmp:=ytmp-1;
  end;
end;

procedure keys80;
begin
  case stmp of
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
end;


procedure view(x:xr;y:yr);
begin
  fn:='3ddeska';
  initgif(1);
  gifshow(1);
  obuf(5);
  clearbuffer;
  ibuf(5);
  putbuffer;
end;

procedure main;
begin
  repeat
    rk:=readkey;
    if (rk=#71) or (rk=#72) or (rk=#73) or
       (rk=#75) or (rk=#77) or (rk=#80) then
    begin
      xtmp:=x;ytmp:=y;stmp:=s;
      case rk of
        #71: s:=s-1;   #72: keys72;   #73: s:=s+1;
        #75: keys75;   #77: keys77;   #80: keys80;
      end;
      test;
      x:=xtmp;y:=ytmp;s:=stmp;
      schovej_mysku;
      view(x,y);
      putbuffer;
      ukaz_mysku;
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
  view(1,1);
  readkey;
  done;
end.
