uses crt,dos,ems,gif,graph,myska,snapshot,vga256,cmftool;

{$M 16384,0,65535}

const pages=32;
      xs=5;ys=18;sms='s';
      name='zbudr';

type map1=0..1;map2=0..5;
     tr=0..10;pr=0..pages;ar=0..16000;xr=0..320;yr=0..200;dr=-1..1;nr=0..80;

const xc=58;yc=6;
      prc='.cmf';prg='.gif';
      mapa1:array[1..20,1..20] of
      map1=((0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
            (0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),
            (0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0),
            (0,1,0,1,0,1,0,1,1,1,1,1,0,1,1,0,1,0,1,0),
            (0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0),
            (0,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,1,0,1,0),
            (0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1,0),
            (0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
            (0,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0),
            (0,1,0,0,0,1,0,0,0,1,0,0,1,1,1,1,1,1,1,0),
            (0,1,0,0,0,1,1,1,0,1,0,0,1,0,0,0,0,0,1,0),
            (0,1,0,1,1,1,0,1,0,1,1,1,1,0,1,1,1,0,1,0),
            (0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0),
            (0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,1,0,1,0),
            (0,1,1,1,0,1,1,1,0,0,1,0,0,1,0,0,0,0,1,0),
            (0,1,0,0,0,0,0,1,0,1,1,1,0,1,1,1,1,0,1,0),
            (0,1,0,1,0,1,0,1,0,0,1,0,0,0,0,1,0,0,1,0),
            (0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0),
            (0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),
            (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));
      mapa2:array[1..20,1..20] of
      map2=((5,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5),
            (5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5),
            (5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5),
            (5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5));

var p:pr;
    x,x2,x3,x4,x5,x6,x7:xr;
    y,y2,y3,y4,y5,y6,y7:yr;
    d:dr;
    n:nr;
    r,s:byte;
    error,handle,total,free,address,pocstr:word;
    realy:integer;
    sm,rk:char;
    lines:array [0..319] of byte;
    data:array [1..16000] of byte;
    fn:pathstr;gp:gifpicture;ps:rgbpalettesegment;
    {cmf}
    check:boolean;
    size:word;
    skok:longint;
    songname:string;
    songbuffer:cmfdatatyp;
    vfile:cmffiletyp;
    {buffer}
    bufferseg:word;
    buffer:pointer;

function real(realy:integer):ar;

var realf,realh:integer;

begin
  realf:=0;realh:=0;
  for realf:=1 to realy do realh:=realh+realf;
  real:=realh;
end;

function seal(realy:integer;y4:yr):ar;

var realf,realh:integer;

begin
  seal:=real(y4)-real(y4-realy);
end;

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
  check:=cmfgetsongbuffer(songbuffer,songName,skok,size);
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

procedure bufline(a,b,c,d:integer);

var realy2:integer;

begin
  for realy2:=a to c do drawpoint(realy2,yc+realy,0);
end;

procedure view(r,s:integer);

begin
  p:=1;
  {begin of compas}
{  setcolor(0);
  help:=char(219)+char(219)+char(219)+char(219)+char(219)+char(219)+char(219);
  outtextxy(270,10,help);
  setcolor(219);
  if sm='s' then outtextxy(270,10,'S');
  if sm='v' then outtextxy(270,10,'V');
  if sm='j' then outtextxy(270,10,'J');
  if sm='z' then outtextxy(270,10,'Z');
  str(x,help);outtextxy(280,10,help);
  str(y,help);outtextxy(300,10,help);
  {end of compas}
  {sever-jih}
  if sm='s' then d:=1;if sm='j' then d:=-1;if (sm='s') or (sm='j') then
  begin
    if (mapa1[r,s]=0) and (mapa1[r-d,s]=0) and (mapa1[r-2*d,s]=0) then
    begin
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{14}  gifshow(1,p,4800,xc+60,yc+15,80,30,xc+60,yc+15);
{15}  gifshow(1,p,7200,xc+60,yc+45,80,15,xc+60,yc+45);
      for realy:=60 to 69 do bufline(xc+60,yc+realy,xc+60+79,yc+realy);
{43}  gifshow(1,p+1,3600,xc+60,yc+70,80,15,xc+60,yc+70);
{44}  gifshow(1,p+1,4800,xc+60,yc+85,80,30,xc+60,yc+85);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
    end;
    if (mapa1[r,s-d]=0) and (mapa1[r-d,s-d]=0) and (mapa1[r-2*d,s-d]=0) then
    begin
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{03}  gifshow(1,p,225,xc,yc+15,15,30,xc,yc+15);
{04}  gifshow(1,p,675,xc,yc+45,15,15,xc,yc+45);
      for realy:=60 to 69 do bufline(xc,yc+realy,xc+14,yc+realy);
{31}  gifshow(1,p+1,0,xc,yc+70,15,15,xc,yc+70);
{32}  gifshow(1,p+1,225,xc,yc+85,15,30,xc,yc+85);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r,s+d]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-2*d,s+d]=0) then
    begin
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{26}  gifshow(1,p,11325,xc+185,yc+15,15,30,xc+185,yc+15);
{27}  gifshow(1,p,11775,xc+185,yc+45,15,15,xc+185,yc+45);
      for realy:=60 to 69 do bufline(xc+185,yc+realy,xc+185+14,yc+realy);
{54}  gifshow(1,p+1,11100,xc+185,yc+70,15,15,xc+185,yc+70);
{55}  gifshow(1,p+1,11325,xc+185,yc+85,15,30,xc+185,yc+85);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if not ((mapa1[r-d,s-d]=1) and (mapa1[r-d,s]=0)) and not
    ((mapa1[r-d,s-d]=0) and (mapa1[r-2*d,s-d]=1)) and not (mapa1[r-d,s]=1) then
    begin
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{07}  gifshow(3,p,1785,xc+15,yc+15,30,30,xc+15,yc+15);
{08}  gifshow(1,p,2250,xc+15,yc+45,30,15,xc+15,yc+45);
      for realy:=60 to 69 do bufline(xc+15,yc+realy,xc+15+29,yc+realy);
{35}  gifshow(1,p+1,900,xc+15,yc+70,30,15,xc+15,yc+70);
{36}  gifshow(4,p+1,1350,xc+15,yc+85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if not ((mapa1[r-d,s+d]=1) and (mapa1[r-d,s]=0)) and not
    ((mapa1[r-d,s+d]=0) and (mapa1[r-2*d,s+d]=1)) and not (mapa1[r-d,s]=1) then
    begin
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{22}  gifshow(5,p,10185,xc+155,yc+15,30,30,xc+155,yc+15);
{23}  gifshow(1,p,10650,xc+155,yc+45,30,15,xc+155,yc+45);
      for realy:=60 to 69 do bufline(xc+155,yc+realy,xc+155+29,yc+realy);
{50}  gifshow(1,p+1,9300,xc+155,yc+70,30,15,xc+155,yc+70);
{51}  gifshow(6,p+1,9750,xc+155,yc+85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if not ((mapa1[r-2*d,s]=1) and (mapa1[r-d,s]=0)) and not
    ((mapa1[r-2*d,s-d]=1) and (mapa1[r-2*d,s]=0) and (mapa1[r-d,s]=0)) and not (mapa1[r-d,s]=1) then
    begin
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{11}  gifshow(6,p,3375,xc+45+1,yc+45,14,14,xc+45+1,yc+45);
{12}  gifshow(3,p,3480,xc+45,yc+45,15,15,xc+45,yc+45);
      for realy:=60 to 69 do bufline(xc+45,yc+realy,xc+45+14,yc+realy);
{39}  gifshow(4,p+1,2700,xc+45,yc+70,15,15,xc+45,yc+70);
{40}  gifshow(5,p+1,2820,xc+45+1,yc+70+1,14,14,xc+45+1,yc+70+1);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
    end;
    if not ((mapa1[r-2*d,s]=1) and (mapa1[r-d,s]=0)) and not
    ((mapa1[r-2*d,s+d]=1) and (mapa1[r-2*d,s]=0) and (mapa1[r-d,s]=0)) and not (mapa1[r-d,s]=1) then
    begin
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{18}  gifshow(4,p,9075,xc+140,yc+45,14,14,xc+140,yc+45);
{19}  gifshow(5,p,9180,xc+140,yc+45,15,15,xc+140,yc+45);
      for realy:=60 to 69 do bufline(xc+140,yc+realy,xc+140+14,yc+realy);
{46}  gifshow(6,p+1,8400,xc+140,yc+70,15,15,xc+140,yc+70);
{47}  gifshow(3,p+1,8520,xc+140,yc+70+1,14,14,xc+140,yc+70+1);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
    if (mapa1[r,s-d]=1) then
    begin
      {01.67.28.68.34}{sj}{v1l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{67}  gifshow(3,p+3,9600,200,0,15,15,xc,yc);
{28}  gifshow(1,p,12000,200,15,15,100,xc,yc+15);
{68}  gifshow(4,p+3,9720,200,115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r,s+d]=1) then
    begin
      {24.74.58.75.57}{sj}{v1p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{74}  gifshow(5,p+3,11160,305,0,15,15,xc+185,yc);
{58}  gifshow(1,p+1,12000,305,15,15,100,xc+185,yc+15);
{75}  gifshow(6,p+3,11280,305,115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if (mapa1[r,s-d]=0) and (mapa1[r-d,s-d]=1) then
    begin
      {01.02.62.33.34}{sj}{m1l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{62}  gifshow(1,p+3,1000,0,0,15,100,xc,yc+15);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r,s+d]=0) and (mapa1[r-d,s+d]=1) then
    begin
      {24.25.66.56.57}{sj}{m1p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{66}  gifshow(1,p+3,8100,185,0,15,100,xc+185,yc+15);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if mapa1[r-d,s]=1 then
    begin
      {05.09.13.16.20.61.38.42.45.49.53}{sj}{zed1}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{61}  gifshow(2,p+2,0,15,0,170,100,xc+15,yc+15);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r-d,s-d]=1) and (mapa1[r-d,s]=0) then
    begin
      {05.06.69.29.70.37.38}{sj}{v2l}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{69}  gifshow(3,p+3,9840,215,15,30,30,xc+15,yc+15);
{29}  gifshow(1,p,13500,215,45,30,40,xc+15,yc+45);
{70}  gifshow(4,p+3,10305,215,85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if (mapa1[r-d,s+d]=1) and (mapa1[r-d,s]=0) then
    begin
      {20.21.76.59.77.52.53}{sj}{v2p}
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{76}  gifshow(5,p+3,11400,275,15,30,30,xc+155,yc+15);
{59}  gifshow(1,p+1,13500,275,45,30,40,xc+155,yc+45);
{77}  gifshow(6,p+3,11865,275,85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r-d,s]=0) and (mapa1[r-d,s-d]=0) and (mapa1[r-2*d,s-d]=1) then
    begin
      {05.06.07.30.36.37.38}{sj}{m2l}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{07}  gifshow(3,p,1785,xc+15,yc+15,30,30,xc+15,yc+15);
{30}  gifshow(1,p,14700,15,100,30,40,xc+15,yc+45);
{36}  gifshow(4,p+1,1350,xc+15,yc+85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if (mapa1[r-d,s]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-2*d,s+d]=1) then
    begin
      {20.21.22.60.51.52.53}{sj}{m2p}
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{22}  gifshow(5,p,10185,xc+155,yc+15,30,30,xc+155,yc+15);
{60}  gifshow(1,p+1,14700,155,100,30,40,xc+155,yc+45);
{51}  gifshow(6,p+1,9750,xc+155,yc+85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r,s-d]=0) and (mapa1[r-d,s-d]=0) and (mapa1[r-2*d,s-d]=1) then
    begin
      {01.02.03.63.32.33.34}{sj}{m3l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{03}  gifshow(1,p,225,xc,yc+15,15,30,xc,yc+15);
{63}  gifshow(1,p+3,2500,0,100,15,40,xc,yc+45);
{32}  gifshow(1,p+1,225,xc,yc+85,15,30,xc,yc+85);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r,s+d]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-2*d,s+d]=1) then
    begin
      {24.25.26.65.55.56.57}{sj}{m3p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{26}  gifshow(1,p,11325,xc+185,yc+15,15,30,xc+185,yc+15);
{65}  gifshow(1,p+3,7500,185,100,15,40,xc+185,yc+45);
{55}  gifshow(1,p+1,11325,xc+185,yc+85,15,30,xc+185,yc+85);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if (mapa1[r-2*d,s]=1) and (mapa1[r-d,s]=0) then
    begin
      {09.13.16.10.14.17.64.41.44.48.42.45.49}{sj}{zed2}
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{14}  gifshow(1,p,4800,xc+60,yc+15,80,30,xc+60,yc+15);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{64}  gifshow(1,p+3,3100,45,100,110,40,xc+45,yc+45);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{44}  gifshow(1,p+1,4800,xc+60,yc+85,80,30,xc+60,yc+85);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
    if (mapa1[r-2*d,s-d]=1) and (mapa1[r-2*d,s]=0) and (mapa1[r-d,s]=0) then
    begin
      {09.10.11.71.72.73.40.41.42}{sj}{v3l}
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{11}  gifshow(6,p,3375,xc+45+1,yc+45,14,14,xc+45+1,yc+45);
{71}  gifshow(3,p+3,10770,245,45,15,15,xc+45,yc+45);
{72}  gifshow(1,p+3,10890,245,60,15,10,xc+45,yc+60);
{73}  gifshow(4,p+3,11040,245,70,15,15,xc+45,yc+70);
{40}  gifshow(5,p+1,2820,xc+45+1,yc+70+1,14,14,xc+45+1,yc+70+1);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
    end;
    if (mapa1[r-2*d,s+d]=1) and (mapa1[r-2*d,s]=0) and (mapa1[r-d,s]=0) then
    begin
      {16.17.18.78.79.80.47.48.49}{sj}{v3p}
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{18}  gifshow(4,p,9075,xc+140,yc+45,14,14,xc+140,yc+45);
{78}  gifshow(5,p+3,12330,260,45,15,15,xc+140,yc+45);
{79}  gifshow(1,p+3,12600,260,60,15,10,xc+140,yc+60);
{80}  gifshow(6,p+3,12750,260,70,15,15,xc+140,yc+70);
{47}  gifshow(3,p+1,8520,xc+140,yc+70+1,14,14,xc+140,yc+70+1);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
  end;
  {vychod-zapad}
  if sm='v' then d:=1;if sm='z' then d:=-1;if (sm='v') or (sm='z') then
  begin
    if (mapa1[r,s]=0) and (mapa1[r,s+d]=0) and (mapa1[r,s+2*d]=0) then
    begin
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{14}  gifshow(1,p,4800,xc+60,yc+15,80,30,xc+60,yc+15);
{15}  gifshow(1,p,7200,xc+60,yc+45,80,15,xc+60,yc+45);
      for realy:=60 to 69 do bufline(xc+60,yc+realy,xc+60+79,yc+realy);
{43}  gifshow(1,p+1,3600,xc+60,yc+70,80,15,xc+60,yc+70);
{44}  gifshow(1,p+1,4800,xc+60,yc+85,80,30,xc+60,yc+85);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
    end;
    if (mapa1[r-d,s]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-d,s+2*d]=0) then
    begin
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{03}  gifshow(1,p,225,xc,yc+15,15,30,xc,yc+15);
{04}  gifshow(1,p,675,xc,yc+45,15,15,xc,yc+45);
      for realy:=60 to 69 do bufline(xc,yc+realy,xc+14,yc+realy);
{31}  gifshow(1,p+1,0,xc,yc+70,15,15,xc,yc+70);
{32}  gifshow(1,p+1,225,xc,yc+85,15,30,xc,yc+85);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r+d,s]=0) and (mapa1[r+d,s+d]=0) and (mapa1[r+d,s+2*d]=0) then
    begin
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{26}  gifshow(1,p,11325,xc+185,yc+15,15,30,xc+185,yc+15);
{27}  gifshow(1,p,11775,xc+185,yc+45,15,15,xc+185,yc+45);
      for realy:=60 to 69 do bufline(xc+185,yc+realy,xc+185+14,yc+realy);
{54}  gifshow(1,p+1,11100,xc+185,yc+70,15,15,xc+185,yc+70);
{55}  gifshow(1,p+1,11325,xc+185,yc+85,15,30,xc+185,yc+85);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if not ((mapa1[r-d,s+d]=1) and (mapa1[r,s+d]=0)) and not
    ((mapa1[r-d,s+d]=0) and (mapa1[r-d,s+2*d]=1)) and not (mapa1[r,s+d]=1) then
    begin
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{07}  gifshow(3,p,1785,xc+15,yc+15,30,30,xc+15,yc+15);
{08}  gifshow(1,p,2250,xc+15,yc+45,30,15,xc+15,yc+45);
      for realy:=60 to 69 do bufline(xc+15,yc+realy,xc+15+29,yc+realy);
{35}  gifshow(1,p+1,900,xc+15,yc+70,30,15,xc+15,yc+70);
{36}  gifshow(4,p+1,1350,xc+15,yc+85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if not ((mapa1[r+d,s+d]=1) and (mapa1[r,s+d]=0)) and not
    ((mapa1[r+d,s+d]=0) and (mapa1[r+d,s+2*d]=1)) and not (mapa1[r,s+d]=1) then
    begin
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{22}  gifshow(5,p,10185,xc+155,yc+15,30,30,xc+155,yc+15);
{23}  gifshow(1,p,10650,xc+155,yc+45,30,15,xc+155,yc+45);
      for realy:=60 to 69 do bufline(xc+155,yc+realy,xc+155+29,yc+realy);
{50}  gifshow(1,p+1,9300,xc+155,yc+70,30,15,xc+155,yc+70);
{51}  gifshow(6,p+1,9750,xc+155,yc+85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if not ((mapa1[r,s+2*d]=1) and (mapa1[r,s+d]=0)) and not
    ((mapa1[r-d,s+2*d]=1) and (mapa1[r,s+2*d]=0) and (mapa1[r,s+d]=0)) and not (mapa1[r,s+d]=1) then
    begin
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{11}  gifshow(6,p,3375,xc+45+1,yc+45,14,14,xc+45+1,yc+45);
{12}  gifshow(3,p,3480,xc+45,yc+45,15,15,xc+45,yc+45);
      for realy:=60 to 69 do bufline(xc+45,yc+realy,xc+45+14,yc+realy);
{39}  gifshow(4,p+1,2700,xc+45,yc+70,15,15,xc+45,yc+70);
{40}  gifshow(5,p+1,2820,xc+45+1,yc+70+1,14,14,xc+45+1,yc+70+1);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
    end;
    if not ((mapa1[r,s+2*d]=1) and (mapa1[r,s+d]=0)) and not
    ((mapa1[r+d,s+2*d]=1) and (mapa1[r,s+2*d]=0) and (mapa1[r,s+d]=0)) and not (mapa1[r,s+d]=1) then
    begin
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{18}  gifshow(4,p,9075,xc+140,yc+45,14,14,xc+140,yc+45);
{19}  gifshow(5,p,9180,xc+140,yc+45,15,15,xc+140,yc+45);
      for realy:=60 to 69 do bufline(xc+140,yc+realy,xc+140+14,yc+realy);
{46}  gifshow(6,p+1,8400,xc+140,yc+70,15,15,xc+140,yc+70);
{47}  gifshow(3,p+1,8520,xc+140,yc+70+1,14,14,xc+140,yc+70+1);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
    if (mapa1[r-d,s]=1) then
    begin
      {01.67.28.68.34}{vz}{v1l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{67}  gifshow(3,p+3,9600,200,0,15,15,xc,yc);
{28}  gifshow(1,p,12000,200,15,15,100,xc,yc+15);
{68}  gifshow(4,p+3,9720,200,115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r+d,s]=1) then
    begin
      {24.74.58.75.57}{vz}{v1p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{74}  gifshow(5,p+3,11160,305,0,15,15,xc+185,yc);
{58}  gifshow(1,p+1,12000,305,15,15,100,xc+185,yc+15);
{75}  gifshow(6,p+3,11280,305,115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if (mapa1[r-d,s]=0) and (mapa1[r-d,s+d]=1) then
    begin
      {01.02.62.33.34}{vz}{m1l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{62}  gifshow(1,p+3,1000,0,0,15,100,xc,yc+15);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r+d,s]=0) and (mapa1[r+d,s+d]=1) then
    begin
      {24.25.66.56.57}{vz}{m1p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{66}  gifshow(1,p+3,8100,185,0,15,100,xc+185,yc+15);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if mapa1[r,s+d]=1 then
    begin
      {05.09.13.16.20.61.38.42.45.49.53}{vz}{zed1}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{61}  gifshow(2,p+2,0,15,0,170,100,xc+15,yc+15);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r-d,s+d]=1) and (mapa1[r,s+d]=0) then
    begin
      {05.06.69.29.70.37.38}{vz}{v2l}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{69}  gifshow(3,p+3,9840,215,15,30,30,xc+15,yc+15);
{29}  gifshow(1,p,13500,215,45,30,40,xc+15,yc+45);
{70}  gifshow(4,p+3,10305,215,85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if (mapa1[r+d,s+d]=1) and (mapa1[r,s+d]=0) then
    begin
      {20.21.76.59.77.52.53}{vz}{v2p}
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{76}  gifshow(5,p+3,11400,275,15,30,30,xc+155,yc+15);
{59}  gifshow(1,p+1,13500,275,45,30,40,xc+155,yc+45);
{77}  gifshow(6,p+3,11865,275,85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r,s+d]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-d,s+2*d]=1) then
    begin{*}
      {05.06.07.30.36.37.38}{vz}{m2l}
{05}  gifshow(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  gifshow(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{07}  gifshow(3,p,1785,xc+15,yc+15,30,30,xc+15,yc+15);
{30}  gifshow(1,p,14700,15,100,30,40,xc+15,yc+45);
{36}  gifshow(4,p+1,1350,xc+15,yc+85,30,30,xc+15,yc+85);
{37}  gifshow(5,p+1,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  gifshow(1,p+1,2250,xc+15,yc+115,30,15,xc+15,yc+115);
    end;
    if (mapa1[r,s+d]=0) and (mapa1[r+d,s+d]=0) and (mapa1[r+d,s+2*d]=1) then
    begin{*}
      {20.21.22.60.51.52.53}{vz}{m2p}
{20}  gifshow(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  gifshow(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{22}  gifshow(5,p,10185,xc+155,yc+15,30,30,xc+155,yc+15);
{60}  gifshow(1,p+1,14700,155,100,30,40,xc+155,yc+45);
{51}  gifshow(6,p+1,9750,xc+155,yc+85,30,30,xc+155,yc+85);
{52}  gifshow(3,p+1,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  gifshow(1,p+1,10650,xc+155,yc+115,30,15,xc+155,yc+115);
    end;
    if (mapa1[r-d,s]=0) and (mapa1[r-d,s+d]=0) and (mapa1[r-d,s+2*d]=1) then
    begin
      {01.02.03.63.32.33.34}{vz}{m3l}
{01}  gifshow(6,p,0,xc+1,yc,14,14,xc+1,yc);
{02}  gifshow(3,p,105,xc,yc,15,15,xc,yc);
{03}  gifshow(1,p,225,xc,yc+15,15,30,xc,yc+15);
{63}  gifshow(1,p+3,2500,0,100,15,40,xc,yc+45);
{32}  gifshow(1,p+1,225,xc,yc+85,15,30,xc,yc+85);
{33}  gifshow(4,p+1,675,xc,yc+115,15,15,xc,yc+115);
{34}  gifshow(5,p+1,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
    end;
    if (mapa1[r+d,s]=0) and (mapa1[r+d,s+d]=0) and (mapa1[r+d,s+2*d]=1) then
    begin
      {24.25.26.65.55.56.57}{vz}{m3p}
{24}  gifshow(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  gifshow(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{26}  gifshow(1,p,11325,xc+185,yc+15,15,30,xc+185,yc+15);
{65}  gifshow(1,p+3,7500,185,100,15,40,xc+185,yc+45);
{55}  gifshow(1,p+1,11325,xc+185,yc+85,15,30,xc+185,yc+85);
{56}  gifshow(6,p+1,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  gifshow(3,p+1,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
    end;
    if (mapa1[r,s+2*d]=1) and (mapa1[r,s+d]=0) then
    begin
      {09.13.16.10.14.17.64.41.44.48.42.45.49}{vz}{zed2}
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{13}  gifshow(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{14}  gifshow(1,p,4800,xc+60,yc+15,80,30,xc+60,yc+15);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{64}  gifshow(1,p+3,3100,45,100,110,40,xc+45,yc+45);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{44}  gifshow(1,p+1,4800,xc+60,yc+85,80,30,xc+60,yc+85);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
{45}  gifshow(1,p+1,7200,xc+60,yc+115,80,15,xc+60,yc+115);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
    if (mapa1[r-d,s+2*d]=1) and (mapa1[r,s+2*d]=0) and (mapa1[r,s+d]=0) then
    begin
      {09.10.11.71.72.73.40.41.42}{vz}{v3l}
{09}  gifshow(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{10}  gifshow(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{11}  gifshow(6,p,3375,xc+45+1,yc+45,14,14,xc+45+1,yc+45);
{71}  gifshow(3,p+3,10770,245,45,15,15,xc+45,yc+45);
{72}  gifshow(1,p+3,10890,245,60,15,10,xc+45,yc+60);
{73}  gifshow(4,p+3,11040,245,70,15,15,xc+45,yc+70);
{40}  gifshow(5,p+1,2820,xc+45+1,yc+70+1,14,14,xc+45+1,yc+70+1);
{41}  gifshow(1,p+1,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{42}  gifshow(1,p+1,3375,xc+45,yc+115,15,15,xc+45,yc+115);
    end;
    if (mapa1[r+d,s+2*d]=1) and (mapa1[r,s+2*d]=0) and (mapa1[r,s+d]=0) then
    begin
      {16.17.18.78.79.80.47.48.49}{vz}{v3p}
{16}  gifshow(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{17}  gifshow(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{18}  gifshow(4,p,9075,xc+140,yc+45,14,14,xc+140,yc+45);
{78}  gifshow(5,p+3,12330,260,45,15,15,xc+140,yc+45);
{79}  gifshow(1,p+3,12600,260,60,15,10,xc+140,yc+60);
{80}  gifshow(6,p+3,12750,260,70,15,15,xc+140,yc+70);
{47}  gifshow(3,p+1,8520,xc+140,yc+70+1,14,14,xc+140,yc+70+1);
{48}  gifshow(1,p+1,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{49}  gifshow(1,p+1,9075,xc+140,yc+115,15,15,xc+140,yc+115);
    end;
  end;
end;

procedure initgif(t:tr;p:pr;a:ar;x3:xr;y3:yr;x4:xr;y4:yr;x5:xr;y5:yr);

begin
  if p<10 then line(120+n,100,120+n,105);n:=n+1;
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
  end;
  end;
  gp.finishblock;
  end;
  gp.closepicture;
  end;
end;

procedure textures(var p:pr);

begin
      n:=0;outtextxy(96,80,'Loading textures');
      line(118,98,201,98);line(201,98,201,107);
      line(201,107,118,107);line(118,107,118,98);
      fn:='c:\gameska2\textures\'+name+'1';
{01}  initgif(6,p,0,xc+1,yc,14,14,xc+1,yc);{}
{02}  initgif(3,p,105,xc,yc,15,15,xc,yc);
{03}  initgif(1,p,225,xc,yc+15,15,30,xc,yc+15);
{04}  initgif(1,p,675,xc,yc+45,15,15,xc,yc+45);
{05}  initgif(1,p,900,xc+15,yc,30,15,xc+15,yc);
{06}  initgif(6,p,1350,xc+15+1,yc+15,29,29,xc+15+1,yc+15);
{07}  initgif(3,p,1785,xc+15,yc+15,30,30,xc+15,yc+15);
{08}  initgif(1,p,2250,xc+15,yc+45,30,15,xc+15,yc+45);
{09}  initgif(1,p,2700,xc+45,yc,15,15,xc+45,yc);
{10}  initgif(1,p,2925,xc+45,yc+15,15,30,xc+45,yc+15);
{11}  initgif(6,p,3375,xc+45+1,yc+45,14,14,xc+45+1,yc+45);
{12}  initgif(3,p,3480,xc+45,yc+45,15,15,xc+45,yc+45);
{13}  initgif(1,p,3600,xc+60,yc,80,15,xc+60,yc);
{14}  initgif(1,p,4800,xc+60,yc+15,80,30,xc+60,yc+15);
{15}  initgif(1,p,7200,xc+60,yc+45,80,15,xc+60,yc+45);
{16}  initgif(1,p,8400,xc+140,yc,15,15,xc+140,yc);
{17}  initgif(1,p,8625,xc+140,yc+15,15,30,xc+140,yc+15);
{18}  initgif(4,p,9075,xc+140,yc+45,14,14,xc+140,yc+45);
{19}  initgif(5,p,9180,xc+140,yc+45,15,15,xc+140,yc+45);
{20}  initgif(1,p,9300,xc+155,yc,30,15,xc+155,yc);
{21}  initgif(4,p,9750,xc+155,yc+15,29,29,xc+155,yc+15);
{22}  initgif(5,p,10185,xc+155,yc+15,30,30,xc+155,yc+15);
{23}  initgif(1,p,10650,xc+155,yc+45,30,15,xc+155,yc+45);
{24}  initgif(4,p,11100,xc+185,yc,14,14,xc+185,yc);
{25}  initgif(5,p,11205,xc+185,yc,15,15,xc+185,yc);
{26}  initgif(1,p,11325,xc+185,yc+15,15,30,xc+185,yc+15);
{27}  initgif(1,p,11775,xc+185,yc+45,15,15,xc+185,yc+45);
      fn:='c:\gameska2\textures\'+name+'3';
{28}  initgif(1,p,12000,200,15,15,100,xc,yc+15);
{29}  initgif(1,p,13500,215,45,30,40,xc+15,yc+45);
{30}  initgif(1,p,14700,15,100,30,40,xc+15,yc+45);
      p:=p+1;
      fn:='c:\gameska2\textures\'+name+'1';
{31}  initgif(1,p,0,xc,yc+70,15,15,xc,yc+70);
{32}  initgif(1,p,225,xc,yc+85,15,30,xc,yc+85);
{33}  initgif(4,p,675,xc,yc+115,15,15,xc,yc+115);
{34}  initgif(5,p,795,xc+1,yc+115+1,14,14,xc+1,yc+115+1);
{35}  initgif(1,p,900,xc+15,yc+70,30,15,xc+15,yc+70);
{36}  initgif(4,p,1350,xc+15,yc+85,30,30,xc+15,yc+85);
{37}  initgif(5,p,1815,xc+15+1,yc+85+1,29,29,xc+15+1,yc+85+1);
{38}  initgif(1,p,2250,xc+15,yc+115,30,15,xc+15,yc+115);
{39}  initgif(4,p,2700,xc+45,yc+70,15,15,xc+45,yc+70);
{40}  initgif(5,p,2820,xc+45+1,yc+70+1,14,14,xc+45+1,yc+70+1);
{41}  initgif(1,p,2925,xc+45,yc+85,15,30,xc+45,yc+85);
{42}  initgif(1,p,3375,xc+45,yc+115,15,15,xc+45,yc+115);
{43}  initgif(1,p,3600,xc+60,yc+70,80,15,xc+60,yc+70);
{44}  initgif(1,p,4800,xc+60,yc+85,80,30,xc+60,yc+85);
{45}  initgif(1,p,7200,xc+60,yc+115,80,15,xc+60,yc+115);
{46}  initgif(6,p,8400,xc+140,yc+70,15,15,xc+140,yc+70);
{47}  initgif(3,p,8520,xc+140,yc+70+1,14,14,xc+140,yc+70+1);
{48}  initgif(1,p,8625,xc+140,yc+85,15,30,xc+140,yc+85);
{49}  initgif(1,p,9075,xc+140,yc+115,15,15,xc+140,yc+115);
{50}  initgif(1,p,9300,xc+155,yc+70,30,15,xc+155,yc+70);
{51}  initgif(6,p,9750,xc+155,yc+85,30,30,xc+155,yc+85);
{52}  initgif(3,p,10215,xc+155,yc+85+1,29,29,xc+155,yc+85+1);
{53}  initgif(1,p,10650,xc+155,yc+115,30,15,xc+155,yc+115);
{54}  initgif(1,p,11100,xc+185,yc+70,15,15,xc+185,yc+70);
{55}  initgif(1,p,11325,xc+185,yc+85,15,30,xc+185,yc+85);
{56}  initgif(6,p,11775,xc+185,yc+115,15,15,xc+185,yc+115);
{57}  initgif(3,p,11895,xc+185,yc+115+1,14,14,xc+185,yc+115+1);
      fn:='c:\gameska2\textures\'+name+'3';
{58}  initgif(1,p,12000,305,15,15,100,xc+185,yc+15);
{59}  initgif(1,p,13500,275,45,30,40,xc+155,yc+45);
{60}  initgif(1,p,14700,155,100,30,40,xc+155,yc+45);
      p:=p+1;
{61}  initgif(2,p,0,15,0,170,100,xc+15,yc+15);
      p:=p+1;
{62}  initgif(1,p,1000,0,0,15,100,xc,yc+15);
{63}  initgif(1,p,2500,0,100,15,40,xc,yc+45);
{64}  initgif(1,p,3100,45,100,110,40,xc+45,yc+45);
{65}  initgif(1,p,7500,185,100,15,40,xc+185,yc+45);
{66}  initgif(1,p,8100,185,0,15,100,xc+185,yc+15);
{67}  initgif(3,p,9600,200,0,15,15,xc,yc);
{68}  initgif(4,p,9720,200,115,15,15,xc,yc+115);
{69}  initgif(3,p,9840,215,15,30,30,xc+15,yc+15);
{70}  initgif(4,p,10305,215,85,30,30,xc+15,yc+85);
{71}  initgif(3,p,10770,245,45,15,15,xc+45,yc+45);
{72}  initgif(1,p,10890,245,60,15,10,xc+45,yc+60);
{73}  initgif(4,p,11040,245,70,15,15,xc+45,yc+70);
{74}  initgif(5,p,11160,305,0,15,15,xc+185,yc);
{75}  initgif(6,p,11280,305,115,15,15,xc+185,yc+115);
{76}  initgif(5,p,11400,275,15,30,30,xc+155,yc+15);
{77}  initgif(6,p,11865,275,85,30,30,xc+155,yc+85);
{78}  initgif(5,p,12330,260,45,15,15,xc+140,yc+45);
{79}  initgif(1,p,12600,260,60,15,10,xc+140,yc+60);
{80}  initgif(6,p,12750,260,70,15,15,xc+140,yc+70);
end;

procedure key;

begin
  if keypressed then
  begin
    x2:=x;y2:=y;rk:=readkey;if rk=#0 then
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
      schovej_mysku;view(y,x);putbuffer;ukaz_mysku;
    end;
  end;
  if cmfstatusbyte=0 then cmfbegin('c:\gameska2\textures\action');
end;

procedure init_begin;

begin
  x:=xs;y:=ys;sm:=sms;x7:=0;y7:=0;p:=1;
  {ems}
  if not emsinstalled then emserror('Neni nainstalovan ovladac EMS pameti!');
  error:=getfreepages(total,free);checkerror(error);
  error:=allocatepages(pages,handle);checkerror(error);
  error:=getaddress(address);checkerror(error);
  {buffer}
  getmem(buffer,32000);
  bufferseg:=seg(buffer^);
  {vga}
  initvga256(vga256modes(0));
  {cmf}
  if not (cmfdriverinstalled) then textnumerror;
  cmfbegin('c:\gameska2\textures\action');
  {init textures}
  textures(p);clearbuffer;
  {begin of 3ddeska}
  fn:='c:\gameska2\textures\3ddeska';
  {in_to ems}
  initgif(1,11,0,0,0,320,50,0,0);
  initgif(1,12,0,0,50,320,50,0,50);
  initgif(1,13,0,0,100,320,50,0,100);
  initgif(1,14,0,0,150,320,50,0,150);
  {in_to buffer}
  gifshow(1,11,0,0,0,320,50,0,0);
  gifshow(1,12,0,0,50,320,50,0,50);
  gifshow(1,13,0,0,100,320,50,0,100);
  gifshow(1,14,0,0,150,320,50,0,150);
  {begin of buffer2 - ems}
  page(15);
  move(mem[bufferseg:0],mem[address:0],16000);
  page(16);
  move(mem[bufferseg:16000],mem[address:0],16000);
  page(17);
  move(mem[bufferseg:32000],mem[address:0],16000);
  page(18);
  move(mem[bufferseg:48000],mem[address:0],16000);
  clearbuffer;
  page(15);
  move(mem[address:0],mem[bufferseg:0],16000);
  page(16);
  move(mem[address:0],mem[bufferseg:16000],16000);
  page(17);
  move(mem[address:0],mem[bufferseg:32000],16000);
  page(18);
  move(mem[address:0],mem[bufferseg:48000],16000);
  putbuffer;
  {end of buffer2 - ems}
  {end of 3ddeska}
  view(y,x);putbuffer;ukaz_mysku;key;
end;

procedure init_end;

begin
  {cmf}
  if cmfstatusbyte<>0 then cmfend;
  {vga}
  closegraph;
  {buffer}
  freemem(buffer,32000);
  {ems}
  error:=deallocatepages(handle);checkerror(error);
end;

begin
  init_begin;
  repeat
    key;
  until rk=#27;
  init_end;
end.