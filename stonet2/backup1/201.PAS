uses crt,dos,ems,gif,graph,myska,snapshot,vga256;

{$M 16384,0,65535}

const pages=32;xs=5;ys=18;sms='s';name='text';

type map1=0..1;map2=0..5;tr=0..10;pr=0..pages;ar=0..16000;xr=0..320;yr=0..200;dr=-1..1;nr=0..80;

const xc=58;yc=6;prg='.gif';

var p:pr;x,x2,x3,x4,x5,x6,x7:xr;y,y2,y3,y4,y5,y6,y7:yr;d:dr;n:nr;
    r,s:byte;error,handle,total,free,address,pocstr:word;realy:integer;
    sm,rk:char;lines:array [0..319] of byte;data:array [1..16000] of byte;
    {gif}
    fn,fn2:pathstr;gp:gifpicture;ps:rgbpalettesegment;
    {buffer}
    bufferseg:word;buffer:pointer;

function real(realy:integer):ar;

var realf,realh:integer;

begin realf:=0;realh:=0;for realf:=1 to realy do realh:=realh+realf;real:=realh;end;

function seal(realy:integer;y4:yr):ar;var realf,realh:integer;begin seal:=real(y4)-real(y4-realy);end;

procedure page(number:word);begin error:=mappages(handle,number,0);checkerror(error);end;

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

procedure gifshow(t:tr;p:pr;a:ar;x3:xr;y3:yr;x4:xr;y4:yr;x5:xr;y5:yr);

begin
  case t of
  1:begin page(p);move(mem[address:a],data,x4*y4);
      for y6:=0 to y4-1 do for x6:=0 to x4-1 do drawpoint(x6+x5,y6+y5,data[(y6*x4)+x6+1]);
    end;
  2:begin page(p);move(mem[address:0],data,16000);for y6:=0 to y4-1 do for x6:=0 to x4-1 do
      begin
        if ((y6*x4)+x6+1)<=16000 then drawpoint(x6+x5,y6+y5,data[(y6*x4)+x6+1]);
        if ((y6*x4)+x6+1)=16000 then begin page(p+1);move(mem[address:0],data,x4*y4-16000);end;
        if ((y6*x4)+x6+1)>16000 then drawpoint(x6+x5,y6+y5,data[(y6*x4)+x6+1-16000]);
      end;
    end;
  3:begin page(p);move(mem[address:a],data,real(y4));
      for y6:=0 to y4-1 do for x6:=0 to y6 do drawpoint(x6+x5,y6+y5,data[real(y6)+x6+1]);
    end;
  4:begin page(p);move(mem[address:a],data,real(y4));
      for y6:=0 to y4-1 do for x6:=0 to -y6+y4-1 do drawpoint(x6+x5,y6+y5,data[seal(y6,y4)+x6+1]);
    end;
  5:begin page(p);move(mem[address:a],data,real(y4));
      for y6:=0 to y4-1 do for x6:=-y6+y4-1 to y4-1 do drawpoint(x6+x5,y6+y5,data[real(y6)+x6+y6-y4+1+1]);
    end;
  6:begin page(p);move(mem[address:a],data,real(y4));
      for y6:=0 to y4-1 do for x6:=y6 to y4-1 do drawpoint(x6+x5,y6+y5,data[seal(y6,y4)+x6-y6+1]);
    end;
  7:begin page(p);move(mem[address:a],data,x4*y4);
      for y6:=0 to y4-1 do for x6:=0 to x4-1 do putpixel(x6+x5,y6+y5,data[(y6*x4)+x6+1]);
    end;
  end;
end;

procedure textnumerror;begin write(' Chyba #',cmferrstat:3,': ');printcmferrmessage;writeln;halt(cmferrstat);end;

procedure bufline(a,b,c,d:integer);var realy2:integer;begin for realy2:=a to c do drawpoint(realy2,yc+realy,0); end;

procedure initgif(t:tr;p:pr;a:ar;x3:xr;y3:yr;x4:xr;y4:yr;x5:xr;y5:yr);

begin
  if (p>=12) and (p<=pages) then begin n:=n+1;setcolor(p);line(119+n,100,119+n,105);end;
  if n>=80 then n:=0;
  gp.openpicture(fn+prg);if gp.ok then
  begin if gp.gpalettesize>0 then
  begin ps:=gp.gpalette;for x6:=0 to pred(gp.gpalettesize) do with ps[x6] do
  begin r:=r shr 2;g:=g shr 2;b:=b shr 2;end;
  setrgbpalettesegment(0,gp.gpalettesize,ps);end else setgraypalette(ps);while gp.readblockheader do
  begin if gp.lpalettesize>0 then
  begin ps:=gp.lpalette;for x6:=0 to pred(gp.lpalettesize) do with ps[x6] do
  begin r:=r shr 2;g:=g shr 2;b:=b shr 2;end;
  setrgbpalettesegment(0,gp.lpalettesize,p);end;
  for y6:=1 to y3 do gp.readline(lines);
  begin
  case t of
  1:begin for y6:=y3 to y4-1+y3 do
      begin gp.readline(lines);for x6:=x3 to x4-1+x3 do
      begin data[((y6-y3)*x4)+(x6-x3)+1]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
      end;page(p);move(data[1],mem[address:a],x4*y4);
    end;
  2:begin for y6:=y3 to y4-1+y3 do
      begin gp.readline(lines);for x6:=x3 to x4-1+x3 do
        begin
          if (((y6-y3)*x4)+(x6-x3)+1)<=16000 then
          begin data[((y6-y3)*x4)+(x6-x3+1)]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
          if (((y6-y3)*x4)+(x6-x3)+1)=16000 then begin page(p);move(data[1],mem[address:0],16000);end;
          if (((y6-y3)*x4)+(x6-x3)+1)>16000 then
          begin data[((y6-y3)*x4)+(x6-x3)+1-16000]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
        end;
      end;page(p+1);move(data[1],mem[address:0],x4*y4-16000);
    end;
  3:begin for y6:=y3 to y3+y4-1 do
      begin gp.readline(lines);for x6:=x3 to x3+y6-y3 do
      begin data[real(y6-y3)+(x6-x3)+1]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
      end;page(p);move(data[1],mem[address:a],real(y4));
    end;
  4:begin for y6:=y3 to y3+y4-1 do
      begin gp.readline(lines);for x6:=x3 to x3-y6+y3+y4-1 do
      begin data[seal(y6-y3,y4)+(x6-x3)+1]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
      end;page(p);move(data[1],mem[address:a],real(y4));
    end;
  5:begin for y6:=y3 to y3+y4-1 do
      begin gp.readline(lines);for x6:=x3-y6+y3+y4-1 to x3+y4-1 do
      begin data[real(y6-y3)+(x6-x3+y6-y3-y4+1)+1]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
      end;page(p);move(data[1],mem[address:a],real(y4));
    end;
  6:begin for y6:=y3 to y3+y4-1 do
      begin gp.readline(lines);for x6:=x3+y6-y3 to x3+y4-1 do
      begin data[seal(y6-y3,y4)+(x6-x3-y6+y3)+1]:=lines[x6];{drawpoint(x6,y6,lines[x6]);}end;
      end;page(p);move(data[1],mem[address:a],real(y4));
    end;
  end;end;gp.finishblock;end;gp.closepicture;end;
end;

procedure textures(var p:pr);

begin
      n:=0;outtextxy(96,80,'Loading textures');
      line(118,98,201,98);line(201,98,201,107);
      line(201,107,118,107);line(118,107,118,98);
      fn2:='c:\gameska2\textures\'+fn;
      fn:=fn2+'1';
      {zde jedntlive textury}
end;

procedure key;

begin
  if keypressed then
  begin
    x2:=x;y2:=y;rk:=readkey;if rk='-' then p:=p-4;if rk='+' then p:=p+4;
    if p<12 then p:=12; if p>pages-4 then p:=12;{best version}
    if (rk='-') or (rk='+') then begin schovej_mysku;view(y,x,p);putbuffer;ukaz_mysku;end;
    if rk=#0 then
    begin
      rk:=readkey;
      if rk=#71 then case sm of's':sm:='z';'z':sm:='j';'j':sm:='v';'v':sm:='s';end;
      if rk=#72 then case sm of's':y2:=y2-1;'v':x2:=x2+1;'j':y2:=y2+1;'z':x2:=x2-1;end;
      if rk=#73 then case sm of's':sm:='v';'v':sm:='j';'j':sm:='z';'z':sm:='s';end;
      if rk=#75 then case sm of's':x2:=x2-1;'v':y2:=y2-1;'j':x2:=x2+1;'z':y2:=y2+1;end;
      if rk=#77 then case sm of's':x2:=x2+1;'v':y2:=y2+1;'j':x2:=x2-1;'z':y2:=y2-1;end;
      if rk=#80 then case sm of's':y2:=y2+1;'v':x2:=x2-1;'j':y2:=y2-1;'z':x2:=x2+1;end;
    end;
    if x2<1 then x2:=1;if y2<1 then y2:=1;if x2>20 then x2:=20;if y2>20 then y2:=20;
    if mapa1[y2,x2]=0 then begin x:=x2;y:=y2;end;
    if ((rk=#71) or (rk=#72) or (rk=#73) or (rk=#75) or (rk=#77) or (rk=#80)) and (mapa1[y2,x2]=0) then
    begin
      schovej_mysku;view(y,x,p);putbuffer;ukaz_mysku;
    end;
  end;
  if cmfstatusbyte=0 then cmfbegin('c:\gameska2\textures\action');
end;

procedure init_begin;

begin
  x:=xs;y:=ys;sm:=sms;x7:=0;y7:=0;
  {ems}
  if not emsinstalled then emserror('Neni nainstalovan ovladac EMS pameti!');
  error:=getfreepages(total,free);checkerror(error);
  error:=allocatepages(pages,handle);checkerror(error);
  error:=getaddress(address);checkerror(error);
  {buffer}
  getmem(buffer,32000);bufferseg:=seg(buffer^);
  {vga}
  initvga256(vga256modes(0));
  {init textures}
  p:=12;fn:='text';textures(p);clearbuffer;
  p:=16;fn:='kam';textures(p);clearbuffer;
  p:=20;fn:='zbudr';textures(p);clearbuffer;
  {begin of 3ddeska}
  fn:='c:\gameska2\textures\3ddeska';
  {in_to ems}
  initgif(1,1,0,0,0,320,50,0,0);
  initgif(1,2,0,0,50,320,50,0,50);
  initgif(1,3,0,0,100,320,50,0,100);
  initgif(1,4,0,0,150,320,50,0,150);
  {in_to buffer}
  gifshow(1,1,0,0,0,320,50,0,0);
  gifshow(1,2,0,0,50,320,50,0,50);
  gifshow(1,3,0,0,100,320,50,0,100);
  gifshow(1,4,0,0,150,320,50,0,150);
  {begin of buffer2 - ems}
  page(5);move(mem[bufferseg:0],mem[address:0],16000);
  page(6);move(mem[bufferseg:16000],mem[address:0],16000);
  page(7);move(mem[bufferseg:32000],mem[address:0],16000);
  page(8);move(mem[bufferseg:48000],mem[address:0],16000);
  clearbuffer;
  page(5);move(mem[address:0],mem[bufferseg:0],16000);
  page(6);move(mem[address:0],mem[bufferseg:16000],16000);
  page(7);move(mem[address:0],mem[bufferseg:32000],16000);
  page(8);move(mem[address:0],mem[bufferseg:48000],16000);
  putbuffer;
  {end of buffer2 - ems}
  {end of 3ddeska}
  p:=12;view(y,x,p);putbuffer;ukaz_mysku;key;
end;

procedure init_end;

begin
  {vga}
  closegraph;
  {buffer}
  freemem(buffer,32000);
  {ems}
  error:=deallocatepages(handle);checkerror(error);
end;

begin init_begin;repeat key;until rk=#27;init_end;end.