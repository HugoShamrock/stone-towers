uses crt,dos,ems,gif,graph,myska,snapshot,vga256;
{$M 16384,0,65535}

type xroz=word;
     yroz=word;
     sroz=0..5; {1sever, 2vychod, 3jih, 4zapad}

const pages=800; {12.8mb}

var {main}
    x,xtmp:xroz;
    y,ytmp:yroz;
    s,stmp:sroz;
    p:0..800;
    a:0..16000;
    rk:char;
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


procedure gifshow(fn:pathstr);
var x6,y6:integer;
    line2:array [0..2048] of byte;
begin
  schovej_mysku;
  gp.openpicture(fn);
  if gp.ok then
    begin
      if gp.gpalettesize>0 then
        begin
          ps:=gp.gpalette;
          for x6:=0 to pred(gp.gpalettesize) do
            with ps[x6] do
              begin
                r:=r shr 2;
                g:=g shr 2;
                b:=b shr 2;
              end;
          setrgbpalettesegment(0,gp.gpalettesize,p);
        end               else
        setgraypalette(ps);
      while gp.readblockheader do
        begin
          if gp.lpalettesize>0 then
            begin
              ps:=gp.lpalette;
              for x6:=0 to pred(gp.lpalettesize) do
                with ps[x6] do
                  begin
                    r:=r shr 2;
                    g:=g shr 2;
                    b:=b shr 2;
                  end;
              setrgbpalettesegment(0,gp.lpalettesize,p);
            end;
          {xres:=succ(getmaxx-g.blockheader.x0);
          if xres>g.blockheader.width then xres:=g.blockheader.width;
          yres:=succ(getmaxy-g.blockheader.y0);
          if yres>g.blockheader.height then yres:=G.blockheader.height;
          setviewport(g.blockheader.x0,G.blockheader.y0,getmaxx,Getmaxy,true);}
          for y6:=0 to pred(200) do
            begin
              gp.readline(line2);
              for x6:=0 to pred(320) do putpixel(x6,y6,line2[x6]);
            end;
          gp.finishblock;
        end;
      gp.closepicture;
      setviewport(0,0,getmaxx,getmaxy,true);
    end;
    ukaz_mysku;
end;

{procedure gifshow;
var xgif:0..320;ygif:0..200;i:1..4;
begin
  for i:=1 to 4 do
  begin
    page(p+i-1);move(mem[address:0],data,16000);
    for ygif:=0 to i*50-1 do
    for xgif:=0 to  320-1 do
    drawpoint(xgif,ygif,data[(ygif*320)+xgif+1-((i-1)*16000)]);
  end;
end;}

{procedure initgif;
var xgif:0..320;ygif:0..200;i:1..4;
begin
  gp.openpicture(fn);
  if gp.ok then
  begin
    if gp.gpalettesize>0 then
    begin
      ps:=gp.gpalette;
      for xgif:=0 to pred(gp.gpalettesize) do
      with ps[xgif] do
      begin
        r:=r shr 2;
        g:=g shr 2;
        b:=b shr 2;
      end;
      setrgbpalettesegment(0,gp.gpalettesize,ps);
    end
    else
    setgraypalette(ps);
    while gp.readblockheader do
    begin
      if gp.lpalettesize>0 then
      begin
        ps:=gp.lpalette;
        for xgif:=0 to pred(gp.lpalettesize) do
        with ps[xgif] do
        begin
          r:=r shr 2;
          g:=g shr 2;
          b:=b shr 2;
        end;
        setrgbpalettesegment(0,gp.lpalettesize,p);
      end;
      for ygif:=1 to 200 do gp.readline(lines);
      for i:=1 to 4 do
      begin
        for ygif:=0 to 200-1 do
        begin
          gp.readline(lines);
          for xgif:=0 to 320-1 do
            data[ygif*320+xgif+1-((i-1)*16000)]:=lines[xgif];
          page(p+i-1);
          move(data[1],mem[address:0],16000);
        end;
      end;
    end;
    gp.finishblock;
  end;
  gp.closepicture;
end;}

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

procedure view(x:xroz;y:yroz);
begin

  gifshow('3ddeska.gif');

  {page(5);move(mem[bufferseg:0],mem[address:0],16000);
  page(6);move(mem[bufferseg:16000],mem[address:0],16000);
  page(7);move(mem[bufferseg:32000],mem[address:0],16000);
  page(8);move(mem[bufferseg:48000],mem[address:0],16000);
  clearbuffer;
  page(5);move(mem[address:0],mem[bufferseg:0],16000);
  page(6);move(mem[address:0],mem[bufferseg:16000],16000);
  page(7);move(mem[address:0],mem[bufferseg:32000],16000);
  page(8);move(mem[address:0],mem[bufferseg:48000],16000);
  putbuffer;}
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
  {main;}
  view(1,1);
  readkey;
  done;
end.
