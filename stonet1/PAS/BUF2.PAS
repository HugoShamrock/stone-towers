uses dos,graph,vga256,gif,snapshot,myska,crt,ems;

type paleta=array [1..768] of byte;

type bunka=0..1;

type radka=array [0..319] of byte;

const prg='.gif';
      prc='.cmf';
      prm='.mod';
      VGA = $a000;
      a:array[1..20,1..20] of
      bunka=((0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0),
             (0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0),
             (0,0,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0));

var p:rgbpalettesegment;
    g:gifpicture;
    fn:pathstr;
    palt:paleta;
    line2:array [0..2048] of byte;
    x,y,x2,y2,x6,y6,x7,y7,x8,y8,dx,dy,xres,yres,d,p2,p3,poc:integer;{x8,y8-kompas}
    sm,rk:char;
    {ems}
    error,total,free,handle,address,pomdata,strana,pocstr:word;
    b,c:longint;
    data:array [1..16000] of byte;
    lines:array [0..319] of byte;
    radky:array [0..49] of radka;
    f1,f2:integer;
    Buffer      : pointer;                  {oprava}
    BufferSeg   : word;                     {oprava}

{ems}

procedure Page(Number:Word);

begin
  Error:=MapPages(Handle,Number,0);CheckError(Error);
end;

procedure checking;

begin
  If not EMSInstalled then EMSError('neni nainstalovan ovladac EMS pameti!');
  Error:=GetFreePages(Total,Free);CheckError(Error);
  b:=Total;c:=Free;
  Writeln('Celkova pamet : ',b*16000);
  Writeln('Volna pamet   : ',c*16000);
end;

procedure alokujems;

begin
  Error:=AllocatePages(50,Handle);CheckError(Error);
  Error:=GetAddress(Address);CheckError(Error);
end;

procedure dealokujems;

begin
  Error:=DeallocatePages(Handle);CheckError(Error);
end;

{end-ems}

Procedure pixel (X,Y : Integer; Col : Byte);
BEGIN
  Mem [VGA:X+(Y*320)]:=Col;
END;

Procedure ClearBuffer; assembler;           {oprava}
Asm
  mov ax,BufferSeg
  mov es,ax
  xor di,di
  xor ax,ax
  mov cx,32000
  rep stosw
End;
{ Put in A000h the buffer where we are painting pixels.}
{ þ In RASANTE HOLE all of this is XMode, QUICK!       }
Procedure PutBuffer; assembler;             {oprava}
Asm
  push ds
  mov ax,0A000h
  mov es,ax
  mov ax,BufferSeg
  mov ds,ax
  xor si,si
  xor di,di
  mov cx,32000
  rep movsw
  pop ds
End;

Procedure DrawPoint(XCenter,YCenter:word;Color:byte);
Var
  X,Y:word;
Begin
  X:={160+}XCenter{+X};
  Y:={100+}YCenter{+Y};
  if (X<320) and (Y<200) then
    Asm
      mov  ax,BufferSeg
      mov  es,ax
      mov  al,Color
      mov  bx,X
      mov  dx,Y
      xchg dh,dl
      mov  di,dx
      shr  di,1
      shr  di,1
      add  di,dx
      add  di,bx
      mov  es:[di],al
    End;
End;

{Repeat     {hlavni repea
{ Wait for vertical retrace.
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    }

procedure initgif(fn:pathstr;p2:integer);

begin
  line(11+poc,11,11+poc,19);
  poc:=poc+1;
  g.openpicture('c:\gameska2\gif\'+fn+prg);
  if g.ok then
    begin
      if g.gpalettesize>0 then
        begin
          p:=g.gpalette;
          for x6:=0 to pred(g.gpalettesize) do
            with p[x6] do
              begin
                r:=r shr 2;
                g:=g shr 2;
                b:=b shr 2;
              end;
          setrgbpalettesegment(0,g.gpalettesize,p);
        end               else
        setgraypalette(p);
      while g.readblockheader do
        begin
          if g.lpalettesize>0 then
            begin
              p:=g.lpalette;
              for x6:=0 to pred(g.lpalettesize) do
                with p[x6] do
                  begin
                    r:=r shr 2;
                    g:=g shr 2;
                    b:=b shr 2;
                  end;
              setrgbpalettesegment(0,g.lpalettesize,p);
            end;
          xres:=succ(getmaxx-g.blockheader.x0);
          if xres>g.blockheader.width then xres:=g.blockheader.width;
          yres:=succ(getmaxy-g.blockheader.y0);
          if yres>g.blockheader.height then yres:=g.blockheader.height;
          setviewport(g.blockheader.x0,g.blockheader.y0,getmaxx,getmaxy,true);
          pomdata:=0;strana:=0;
          for y6:=0 to 149 do
          begin
            if y6>pred(yres) then for p3:=0 to 319 do lines[p3]:=0;
            g.readline(lines);
            for x6:=0 to 319 do
            begin
              pomdata:=pomdata+1;
              if (strana=0) and (pomdata=16000) then
              begin
                page(p2+0);move(data[1],mem[address:0],16000);
                pomdata:=0;
                strana:=1;
              end;
              if (strana=1) and (pomdata=16000) then
              begin
                page(p2+1);move(data[1],mem[address:0],16000);
                pomdata:=0;
                strana:=2;
              end;
              if (strana=2) and (pomdata=16000) then
              begin
                page(p2+2);move(data[1],mem[address:0],16000);
                pomdata:=0;
                exit;
              end;
              data[pomdata]:=lines[x6];
{              putpixel(x6,y6,lines[x6]);}
            end;
          end;
          g.finishblock;
        end;
      g.closepicture;
      setviewport(0,0,getmaxx,getmaxy,true);
    end;
end;

procedure gifshow(p2,x7,y7:integer);

begin
  page(p2+0);Move(Mem[Address:0],radky,16000);
  for f1:=0 to 49 do
   begin
    for f2:=0 to 319 do
     begin
      if radky[f1,f2]<>0 then drawpoint(f2+x7,f1+y7,radky[f1,f2]);
     end;
    end;
  page(p2+1);Move(Mem[Address:0],radky,16000);
  for f1:=50 to 99 do
   begin
    for f2:=0 to 319 do
     begin
      if radky[f1-50,f2]<>0 then drawpoint(f2+x7,f1+y7,radky[f1-50,f2]);
     end;
    end;
  page(p2+2);Move(Mem[Address:0],radky,16000);
  for f1:=100 to 149 do
   begin
    for f2:=0 to 319 do
     begin
      if radky[f1-100,f2]<>0 then drawpoint(f2+x7,f1+y7,radky[f1-100,f2]);
     end;
    end;
end;

{delete}

procedure initkompas;

begin
  for x8:=1 to 20 do
  for y8:=1 to 20 do
  if a[y8,x8]=0 then
  begin
    setcolor(20);
    line (158+x8*3,130+y8*3,158+x8*3+2,130+y8*3);
    line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
    line (158+x8*3,130+y8*3+2,158+x8*3+2,130+y8*3+2);
  end;
end;

procedure kompas;

begin
  x8:=x;
  y8:=y;
  setcolor(50);
  if sm='s' then
  begin
    line (158+x8*3+1,130+y8*3,158+x8*3+2-1,130+y8*3);
    line (158+x8*3+1,130+y8*3+1,158+x8*3+2-1,130+y8*3+1);
    line (158+x8*3,130+y8*3+2,158+x8*3+2,130+y8*3+2);
  end;
  if sm='j' then
  begin
    line (158+x8*3,130+y8*3,158+x8*3+2,130+y8*3);
    line (158+x8*3+1,130+y8*3+1,158+x8*3+2-1,130+y8*3+1);
    line (158+x8*3+1,130+y8*3+2,158+x8*3+2-1,130+y8*3+2);
  end;
  if sm='v' then
  begin
    line (158+x8*3,130+y8*3,158+x8*3+2-2,130+y8*3);
    line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
    line (158+x8*3,130+y8*3+2,158+x8*3+2-2,130+y8*3+2);
  end;
  if sm='z' then
  begin
    line (158+x8*3+2,130+y8*3,158+x8*3+2,130+y8*3);
    line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
    line (158+x8*3+2,130+y8*3+2,158+x8*3+2,130+y8*3+2);
  end;
end;

{end}

procedure text;

begin
  initgif('podlaha',0);
  initgif('zed1',3);
  initgif('zed2',6);
  initgif('v1l',9);
  initgif('v1p',12);
  initgif('v2l',15);
  initgif('v2p',18);
  initgif('v3l',21);
  initgif('v3p',24);
  initgif('m1l',27);
  initgif('m1p',30);
  initgif('m2l',33);
  initgif('m2p',36);
  initgif('m3l',39);
  initgif('m3p',42);
end;

procedure obr(r,s:integer);

begin
{  kompas;}
  gifshow(0,65,36);
  if sm='s' then d:=1;
  if sm='j' then d:=-1;
  if (sm='s') or (sm='j') then
  begin
    if (a[r,s-d]=1) then gifshow(9,65,36);
    if (a[r,s+d]=1) then gifshow(12,250,36);
    if (a[r,s-d]=0) and (a[r-d,s-d]=1) then gifshow(27,65,51);
    if (a[r,s+d]=0) and (a[r-d,s+d]=1) then gifshow(30,250,51);
    if a[r-d,s]=1 then gifshow(3,80,51);
    if (a[r-d,s-d]=1) and (a[r-d,s]=0) then gifshow(15,80,51);
    if (a[r-d,s+d]=1) and (a[r-d,s]=0) then gifshow(18,220,51);
    if (a[r,s-d]=0) and (a[r-d,s-d]=0) and (a[r-2*d,s-d]=1) then gifshow(39,65,81);
    if (a[r,s+d]=0) and (a[r-d,s+d]=0) and (a[r-2*d,s+d]=1) then gifshow(42,250,81);
    if (a[r-d,s-d]=0) and (a[r-2*d,s-d]=1) and (a[r-d,s]=0) then gifshow(33,80,81);
    if (a[r-d,s+d]=0) and (a[r-2*d,s+d]=1) and (a[r-d,s]=0) then gifshow(36,220,81);
    if (a[r-2*d,s]=1) and (a[r-d,s]=0) then gifshow(6,110,81);
    if (a[r-2*d,s-d]=1) and (a[r-2*d,s]=0) and (a[r-d,s]=0) then gifshow(21,110,81);
    if (a[r-2*d,s+d]=1) and (a[r-2*d,s]=0) and (a[r-d,s]=0) then gifshow(24,205,81);
  end;
{  if sm='z' then d:=1;
  if sm='v' then d:=-1;
  if (sm='z') or (sm='v') then
  begin
    if (a[r+d,s]=1) then gifshow('v1l',65,36);
    if (a[r-d,s]=1) then gifshow('v1p',250,36);
    if (a[r+d,s]=0) and (a[r+d,s-d]=1) then gifshow('m1l',65,51);
    if (a[r-d,s]=0) and (a[r-d,s-d]=1) then gifshow('m1p',250,51);
    if a[r,s-d]=1 then gifshow('zed1',80,51);
    if (a[r+d,s-d]=1) and (a[r,s-d]=0) then gifshow('v2l',80,51);
    if (a[r-d,s-d]=1) and (a[r,s-d]=0) then gifshow('v2p',220,51);
    if (a[r+d,s]=0) and (a[r+d,s-d]=0) and (a[r+d,s-2*d]=1) then gifshow('m3l',65,81);
    if (a[r-d,s]=0) and (a[r-d,s-d]=0) and (a[r-d,s-2*d]=1) then gifshow('m3p',250,81);
    if (a[r+d,s-d]=0) and (a[r+d,s-2*d]=1) and (a[r,s-d]=0) then gifshow('m2l',80,81);
    if (a[r-d,s-d]=0) and (a[r-d,s-2*d]=1) and (a[r,s-d]=0) then gifshow('m2p',220,81);
    if (a[r,s-2*d]=1) and (a[r,s-d]=0) then gifshow('zed2',110,81);
    if (a[r+d,s-2*d]=1) and (a[r,s-2*d]=0) and (a[r,s-d]=0) then gifshow('v3l',110,81);
    if (a[r-d,s-2*d]=1) and (a[r,s-2*d]=0) and (a[r,s-d]=0) then gifshow('v3p',205,81);
  end;}
end;

procedure key;

begin
  x2:=x;
  y2:=y;
  rk:=readkey;
  if rk=#0 then
  begin
    rk:=readkey;
    if rk=#72 then
    case sm of
      's':y2:=y2-1;
      'v':x2:=x2+1;
      'j':y2:=y2+1;
      'z':x2:=x2-1;
    end;
    if rk=#77 then
    case sm of
      's':x2:=x2+1;
      'v':y2:=y2+1;
      'j':x2:=x2-1;
      'z':y2:=y2-1;
    end;
    if rk=#80 then
    case sm of
      's':y2:=y2+1;
      'v':x2:=x2-1;
      'j':y2:=y2-1;
      'z':x2:=x2+1;
    end;
    if rk=#75 then
    case sm of
      's':x2:=x2-1;
      'v':y2:=y2-1;
      'j':x2:=x2+1;
      'z':y2:=y2+1;
    end;
    if rk=#73 then
    case sm of
      's':sm:='v';
      'v':sm:='j';
      'j':sm:='z';
      'z':sm:='s';
    end;
    if rk=#71 then
    case sm of
      's':sm:='z';
      'z':sm:='j';
      'j':sm:='v';
      'v':sm:='s';
    end;
  end;
  if x2<1 then x2:=1;
  if y2<1 then y2:=1;
  if x2>20 then x2:=20;
  if y2>20 then y2:=20;
  if a[y2,x2]=0 then
  begin
    {delete}
{    setcolor(20);
    line (158+x8*3,130+y8*3,158+x8*3+2,130+y8*3);
    line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
    line (158+x8*3,130+y8*3+2,158+x8*3+2,130+y8*3+2);
    {end}
    x:=x2;
    y:=y2;
  end;
  if (rk=#71) or (rk=#72) or (rk=#73) or (rk=#75) or (rk=#77) or (rk=#80) then obr(y,x);
end;

procedure initb;

begin
  {pozice}
  x:=10;
  y:=15;
  sm:='s';
  poc:=0;
  checking;
  readkey;
  alokujems;
  initvga256(vga256modes(0));
  setcolor(blue);
  line(10,10,26,10);
  line(10,20,26,20);
  line(10,10,10,20);
  line(26,10,26,20);
  setcolor(green);
  text;
{  initkompas;}
end;

procedure inite;

begin
  closegraph;
  dealokujems;
end;

begin
  initb;
  GetMem(Buffer,64000);
  BufferSeg:=seg(Buffer^);
  ClearBuffer;
  repeat
    key;
    putbuffer;
    clearbuffer;
  until rk=#27;
  inite;
end.

