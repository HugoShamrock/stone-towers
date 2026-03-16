uses dos,graph,vga256,gif,snapshot,myska,crt,cmftool;

{$M 16384,0,65535}
{$L MOD-obj.OBJ}
{$F+}

procedure modvolume (v1,v2,v3,v4:integer); external ;
procedure moddevice (var device:integer); external ;
procedure modsetup (var status:integer;device,mixspeed,pro,loop:integer;var str:string); external ;
procedure modstop; external ;
procedure modinit; external;

{$F-}

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

var {gif}
    p:rgbpalettesegment;
    g:gifpicture;
    fn:pathstr;
    palt:paleta;
    line2:array [0..2048] of byte;
    {cmf}
    check:boolean;
    songname:string;
    songbuffer:cmfdatatyp;
    size:word;
    skok:longint;
    vfile:cmffiletyp;
    {mod}
    dev,mix,stat,pro,loop:integer;
    md:string;
    ch:char;
    {my}
    x,y,x2,y2,x6,y6,x7,y7,dx,dy,xres,yres,d:integer;
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
          if yres>g.blockheader.height then yres:=g.blockheader.height;
          setviewport(g.blockheader.x0,g.blockheader.y0,getmaxx,getmaxy,true);
          for y6:=0 to pred(yres) do
            begin
              g.readline(line2);
              if fn='podlaha' then for x6:=0 to pred(xres) do putpixel(x6+x7,y6+y7,line2[x6]) else
              for x6:=0 to pred(xres) do if line2[x6]<>0 then putpixel(x6+x7,y6+y7,line2[x6]);
            end;
          g.finishblock;
        end;
      g.closepicture;
      setviewport(0,0,getmaxx,getmaxy,true);
    end;
end;

procedure textnumerror;

begin
  write(' Chyba #',cmferrstat:3,': ');
  printcmferrmessage;
  writeln;
  halt(cmferrstat);
end;

procedure cmfbegin(songname:string);

begin
  if not (cmfdriverinstalled) then textnumerror;
  songname:=songname+prc;
  check:=cmfgetsongbuffer(songbuffer,songname,skok,size);
  if not(check) then textnumerror;
  cmfsettransposeofs(0);
  check:=cmfplaysong(songbuffer);
  if not(check) then textnumerror;
end;

procedure cmfend;

begin
  check:=cmfstopsong;
  if not(check) then textnumerror;
  check:=cmfresetdriver;
  if not(check) then textnumerror;
  check:=cmffreesongbuffer(songbuffer);
  if not(check) then textnumerror;
end;

procedure modul(md:string);

begin
  if (dev=255) then halt(1);
  md:=md+prm;
  mix:=10000;
  pro:=0;
  loop:=4;
  modvolume(255,255,255,255);
  modsetup(stat,dev,mix,pro,loop,md);
end;

procedure obr(r,s:integer);

begin
  schovej_mysku;
  if sm='s' then d:=1;
  if sm='j' then d:=-1;
  gifshow('podlaha',65,36);
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
  ukaz_mysku;
end;

begin
  x:=10;
  y:=20;
  sm:='s';
  modinit;
  moddevice(dev);
  initvga256(vga256modes(0));
  if not (cmfdriverinstalled) then textnumerror;
  cmfbegin('action');
  modul('popcorn');
  ukaz_mysku;
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
      x:=x2;
      y:=y2;
    end;
    if (rk=#71) or (rk=#72) or (rk=#73) or (rk=#75) or (rk=#77) or (rk=#80) then obr(y,x);
    if cmfstatusbyte=0 then cmfend;
  until rk=#27;
  if  cmfstatusbyte<>0 then cmfend;
  modstop;
  closegraph;
end.