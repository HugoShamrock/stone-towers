uses dos,graph,vga256,gif,snapshot,myska,crt;

type paleta=array [1..768] of byte;

type bunka=0..1;

const prg='.gif';
      prc='.cmf';
      prm='.mod';
      a:array[1..20,1..20] of
      bunka=((0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0),
             (0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0),
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
    x,y,x2,y2,x6,y6,x7,y7,x8,y8,dx,dy,xres,yres,d:integer;
    sm,rk:char;

procedure gifshow(fn:pathstr;x7,y7:word);

begin
  g.openpicture(fn+prg);
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
          if yres>g.blockheader.height then yres:=G.blockheader.height;
          setviewport(g.blockheader.x0,G.blockheader.y0,getmaxx,Getmaxy,true);
          for y6:=0 to pred(yres) do
            begin
              g.readline(line2);
              if fn='podlaha' then for x6:=0 to pred(xres) do putpixel(x6+x7,y6+y7-35,line2[x6]) else
              for x6:=0 to pred(xres) do if line2[x6]<>0 then putpixel(x6+x7,y6+y7-35,line2[x6]);
            end;
          g.finishblock;
        end;
      g.closepicture;
      setviewport(0,0,getmaxx,getmaxy,true);
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

procedure obr(r,s:integer);

begin
  kompas;
  gifshow('podlaha',65,36);
  if sm='s' then d:=1;
  if sm='j' then d:=-1;
  if (sm='s') or (sm='j') then
  begin
    if (a[r,s-d]=1) then gifshow('v1l',65,36);
    if (a[r,s+d]=1) then gifshow('v1p',250,36);
    if (a[r,s-d]=0) and (a[r-d,s-d]=1) then gifshow('m1l',65,51);
    if (a[r,s+d]=0) and (a[r-d,s+d]=1) then gifshow('m1p',250,51);
    if a[r-d,s]=1 then gifshow('zed1',80,51);
    if (a[r-d,s-d]=1) and (a[r-d,s]=0) then gifshow('v2l',80,51);
    if (a[r-d,s+d]=1) and (a[r-d,s]=0) then gifshow('v2p',220,51);
    if (a[r,s-d]=0) and (a[r-d,s-d]=0) and (a[r-2*d,s-d]=1) then gifshow('m3l',65,81);
    if (a[r,s+d]=0) and (a[r-d,s+d]=0) and (a[r-2*d,s+d]=1) then gifshow('m3p',250,81);
    if (a[r-d,s-d]=0) and (a[r-2*d,s-d]=1) and (a[r-d,s]=0) then gifshow('m2l',80,81);
    if (a[r-d,s+d]=0) and (a[r-2*d,s+d]=1) and (a[r-d,s]=0) then gifshow('m2p',220,81);
    if (a[r-2*d,s]=1) and (a[r-d,s]=0) then gifshow('zed2',110,81);
    if (a[r-2*d,s-d]=1) and (a[r-2*d,s]=0) and (a[r-d,s]=0) then gifshow('v3l',110,81);
    if (a[r-2*d,s+d]=1) and (a[r-2*d,s]=0) and (a[r-d,s]=0) then gifshow('v3p',205,81);
  end;
  if sm='z' then d:=1;
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
  end;
end;

begin
  x:=10;
  y:=20;
  sm:='s';
  initvga256(vga256modes(0));
  for x8:=1 to 20 do
  for y8:=1 to 20 do
  if a[y8,x8]=0 then
  begin
    setcolor(20);
    line (158+x8*3,130+y8*3,158+x8*3+2,130+y8*3);
    line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
    line (158+x8*3,130+y8*3+2,158+x8*3+2,130+y8*3+2);
  end;
  obr(y,x);
  repeat
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
      setcolor(20);
      line (158+x8*3,130+y8*3,158+x8*3+2,130+y8*3);
      line (158+x8*3,130+y8*3+1,158+x8*3+2,130+y8*3+1);
      line (158+x8*3,130+y8*3+2,158+x8*3+2,130+y8*3+2);
      x:=x2;
      y:=y2;
    end;
    if (rk=#71) or (rk=#72) or (rk=#73) or (rk=#75) or (rk=#77) or (rk=#80) then obr(y,x);
  until rk=#27;
  closegraph;
end.