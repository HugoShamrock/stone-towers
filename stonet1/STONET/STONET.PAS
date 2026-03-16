program gameska;

uses  dos,graph,vga256,gif,snapshot,myska,crt;

type paleta=array [1..768] of byte;

const pr='.dat';
      de=375;
      ck1=138;
      ck2=148;
      msec=50;

var p:rgbpalettesegment;
    g:gifpicture;
    fn:pathstr;
    palt:paleta;
    l1,l2,l3,l4:array [1..9,1..9,1..4] of word;
    batoh,batoh2:array [1..6] of word;
    col: array [0..255] of word;
    line2:array [0..2048] of byte;
    c1,c2,c3,c4,c5:string [2];
    x,y,x6,y6,x7,y7,x8,y8,z8,x9,y9,z9,xres,yres:word;
    r,c,m,f,h,f2,g2,h2,kolik,l,ex,cl,dia:word;
    e,li,i:integer;

procedure gifshow(fn:pathstr;x7,y7:word);

begin
  schovej_mysku;
  g.openpicture(fn+pr);
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
              for x6:=0 to pred(xres) do putpixel(x6+x7,y6+y7,line2[x6]);
            end;
          g.finishblock;
        end;
      g.closepicture;
      setviewport(0,0,getmaxx,getmaxy,true);
    end;
    ukaz_mysku;
end;

procedure jas(n:integer;var p:paleta);

var i:integer;

begin
  port[$3c8]:=0;
  for i:= 1 to 768 do port[$3c9]:=p[i]*n div 63;
end;

procedure zjistenipalety(var p:paleta);

var i:integer;

begin
 port[$3c7]:=0;
 for i:= 1 to 768 do p[i]:=port[$3c9];
end;

procedure stmaveni(var p:paleta);

var n:integer;

begin
 for n:= 63 downto 0 do jas(n,p);
 delay(msec);
end;

procedure zesvetleni(var p:paleta);

var n:integer;

begin
 for n:= 0 to 63 do jas(n,p);
 delay(msec);
end;

procedure gameover;

begin
  schovej_mysku;
  for cl:= 255 downto 0 do
  begin
   col[cl]:=cl;
   setrgbpalette(cl,cl,0,0);
  end;
  setrgbpalette(0,20,0,0);
  zjistenipalety(palt);
  stmaveni(palt);
  cleardevice;
  gifshow('50010',0,0);
  zjistenipalety(palt);
  {zesvetleni(palt);}
  jas(63,palt);readkey;
  ex:=2;
end;

procedure clebig;

begin
  setviewport(60,5,259,134,clipon);
  clearviewport;
  setviewport(0,0,319,199,clipon);
end;

procedure clesma;

begin
  setviewport(71,141,248,159,clipon);
  clearviewport;
  setviewport(0,0,319,199,clipon);
end;

procedure clebat;

begin
  for f:=1 to 6 do
  begin
    batoh[f]:=0;
  end;
end;

procedure clemap;

begin
  for f2:=1 to 9 do
  begin
    for g2:=1 to 9 do
    begin
      for h2:=1 to 4 do l1[f2,g2,h2]:=0;
    end;
  end;
 for f2:=1 to 9 do
  begin
    for g2:=1 to 9 do
    begin
      for h2:=1 to 4 do l2[f2,g2,h2]:=0;
    end;
  end;
  for f2:=1 to 9 do
  begin
    for g2:=1 to 9 do
    begin
      for h2:=1 to 4 do l3[f2,g2,h2]:=0;
    end;
  end;
  for f2:=1 to 9 do
  begin
    for g2:=1 to 9 do
    begin
      for h2:=1 to 4 do l4[f2,g2,h2]:=0;
    end;
  end;
end;

procedure initn;

begin
  gifshow('50000',0,0);
  gifshow('51001',2,5);;
  gifshow('52001',2,52);
end;

procedure new;

begin
  str(l,c1);
  str(x8,c2);
  str(y8,c3);
  str(z8,c4);
  if l=1 then str(l1[x8,y8,z8],c5);
  if l=2 then str(l2[x8,y8,z8],c5);
  if l=3 then str(l3[x8,y8,z8],c5);
  if l=4 then str(l4[x8,y8,z8],c5);
  {ohen}
  if (x8=1) and (y8=6) and (z8=3) and (l1[1,6,3]=2) then c5:='1';
  {netopyr}
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=4) then c5:='1';
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=8) then c5:='1';
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=9) then c5:='1';
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=4) then c5:='1';
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=8) then c5:='1';
  {druid}
  if (x8=5) and (y8=7) and (z8=3) and (l1[5,7,3]=2) then c5:='1';
  if (x8=5) and (y8=7) and (z8=3) and (l1[5,7,3]=9) then c5:='1';
  {kasna}
  if (x8=6) and (y8=6) and (z8=2) and (l1[6,6,2]=2) then c5:='1';
  {vlk}
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) then c5:='1';
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=8) then c5:='1';
  gifshow((c1+c2+c3+c4+c5),59,4);
end;

procedure info;

begin
  gifshow('50009',59,4);
  ukaz_mysku;
  repeat
    stisk_mysky(leve_tlacitko,kolik,x,y);
    if kolik>0 then
      begin
        x:=trunc(x/2);
        if (x>219) and (y>115) and (x<241) and (y<130) then ex:=1;
        if (x>192) and (y>115) and (x<214) and (y<130) then ex:=2;
      end;
   until ex>0;
  if ex=1 then new;
end;

procedure listina;

begin
  gifshow('50008',59,4);
  ukaz_mysku;
  repeat
    stisk_mysky(leve_tlacitko,kolik,x,y);
    if kolik>0 then
      begin
        x:=trunc(x/2);
        if (x>219) and (y>115) and (x<241) and (y<130) then ex:=1;
      end;
  until ex>0;
  new;
end;

procedure deska;

begin
  gifshow('16622',59,4);
  ukaz_mysku;
  repeat
    stisk_mysky(leve_tlacitko,kolik,x,y);
    if kolik>0 then
      begin
        x:=trunc(x/2);
        if (x>219) and (y>115) and (x<241) and (y<130) then ex:=1;
      end;
  until ex>0;
  new;
end;

procedure initm;

begin
  gifshow('50004',3,81);
  for f:=1 to m do
  begin
    gifshow('50005',8+7*f-7,83);
  end;
end;

procedure inite;

begin
  gifshow('50004',3,109);
  for f:=1 to e do
  begin
    gifshow('50006',8+7*f-7,111);
  end;
  if (e<1) then gameover;
  if ex=2 then exit;
end;

procedure initb;

begin
  for f:=1 to 6 do
  begin
    x7:=72+29*f-29;
    y7:=166;
    setviewport(x7+1,167,x7+28,192,clipon);
    clearviewport;
    setviewport(0,0,319,199,clipon);
    str(batoh[f],c1);
    gifshow('5300'+c1,x7,y7);
  end;
end;

procedure initb2;

begin
  batoh2:=batoh;
  clebat;
  c:=0;
  for f:=1 to 6 do
  begin
    if batoh2[f]>0 then
    begin
      c:=c+1;
      batoh[c]:=batoh2[f];
    end;
  end;
  h2:=0;
  initb;
end;

procedure init1;

begin
  for f:=1 to 4 do
  begin
    l1[1,5,f]:=1;
    l1[1,6,f]:=1;
    l1[2,5,f]:=1;
    l1[3,5,f]:=1;
    l1[4,1,f]:=1;
    l1[4,2,f]:=1;
    l1[4,3,f]:=1;
    l1[4,4,f]:=1;
    l1[4,5,f]:=1;
    l1[4,6,f]:=1;
    l1[5,6,f]:=1;
    l1[5,7,f]:=1;
    l1[6,4,f]:=1;
    l1[6,5,f]:=1;
    l1[6,6,f]:=1;
  end;
end;


procedure init2;

begin
  for f:=1 to 4 do
  begin
    l2[1,3,f]:=1;
    l2[1,4,f]:=1;
    l2[1,5,f]:=1;
    l2[1,6,f]:=1;
    l2[2,2,f]:=1;
    l2[2,3,f]:=1;
    l2[2,6,f]:=1;
    l2[2,7,f]:=1;
    l2[3,2,f]:=1;
    l2[3,4,f]:=1;
    l2[3,7,f]:=1;
    l2[4,2,f]:=1;
    l2[4,4,f]:=1;
    l2[4,5,f]:=1;
    l2[4,6,f]:=1;
    l2[4,7,f]:=1;
    l2[4,8,f]:=1;
    l2[4,9,f]:=1;
    l2[5,2,f]:=1;
    l2[5,3,f]:=1;
    l2[5,4,f]:=1;
    l2[5,7,f]:=1;
    l2[6,1,f]:=1;
    l2[6,2,f]:=1;
    l2[6,6,f]:=1;
    l2[6,7,f]:=1;
    l2[6,8,f]:=1;
    l2[7,2,f]:=1;
    l2[7,5,f]:=1;
    l2[7,6,f]:=1;
    l2[7,8,f]:=1;
    l2[8,2,f]:=1;
    l2[8,3,f]:=1;
    l2[8,4,f]:=1;
    l2[8,6,f]:=1;
    l2[8,7,f]:=1;
    l2[8,8,f]:=1;
    l2[9,4,f]:=1;
  end;
end;

procedure init3;

begin
  for f:=1 to 4 do
  begin
    l3[1,5,f]:=1;
    l3[1,6,f]:=1;
    l3[1,7,f]:=1;
    l3[2,3,f]:=1;
    l3[2,4,f]:=1;
    l3[2,5,f]:=1;
    l3[2,7,f]:=1;
    l3[3,3,f]:=1;
    l3[3,7,f]:=1;
    l3[4,3,f]:=1;
    l3[4,5,f]:=1;
    l3[4,6,f]:=1;
    l3[4,7,f]:=1;
    l3[5,1,f]:=1;
    l3[5,2,f]:=1;
    l3[5,3,f]:=1;
    l3[5,5,f]:=1;
    l3[5,7,f]:=1;
    l3[6,5,f]:=1;
    l3[6,7,f]:=1;
    l3[6,8,f]:=1;
    l3[7,2,f]:=1;
    l3[7,3,f]:=1;
    l3[7,4,f]:=1;
    l3[7,5,f]:=1;
    l3[8,3,f]:=1;
    l3[8,5,f]:=1;
    l3[8,6,f]:=1;
    l3[8,7,f]:=1;
  end;
end;

procedure init4;

begin
  for f:=1 to 4 do
  begin
    l4[1,5,f]:=1;
    l4[2,1,f]:=1;
    l4[2,2,f]:=1;
    l4[2,3,f]:=1;
    l4[2,5,f]:=1;
    l4[2,6,f]:=1;
    l4[3,1,f]:=1;
    l4[3,3,f]:=1;
    l4[3,5,f]:=1;
    l4[4,1,f]:=1;
    l4[4,5,f]:=1;
    l4[5,1,f]:=1;
    l4[5,2,f]:=1;
    l4[5,3,f]:=1;
    l4[5,4,f]:=1;
    l4[5,5,f]:=1;
  end;
end;

procedure k1;

begin
  setcolor(20);
  line (258+x8*5,140+y8*5,258+x8*5+4,140+y8*5);
  line (258+x8*5,140+y8*5+1,258+x8*5+4,140+y8*5+1);
  line (258+x8*5,140+y8*5+2,258+x8*5+4,140+y8*5+2);
  line (258+x8*5,140+y8*5+3,258+x8*5+4,140+y8*5+3);
  line (258+x8*5,140+y8*5+4,258+x8*5+4,140+y8*5+4);
  setcolor(35);
end;

procedure k2;

begin
  setcolor(40);
  if z8=1 then
  begin
    line (258+x8*5+1,140+y8*5+2,258+x8*5+1,140+y8*5+3);
    line (258+x8*5+2,140+y8*5+1,258+x8*5+2,140+y8*5+2);
    line (258+x8*5+3,140+y8*5+2,258+x8*5+3,140+y8*5+3);
  end;
  if z8=2 then
  begin
    line (258+x8*5+1,140+y8*5+1,258+x8*5+2,140+y8*5+1);
    line (258+x8*5+2,140+y8*5+2,258+x8*5+3,140+y8*5+2);
    line (258+x8*5+1,140+y8*5+3,258+x8*5+2,140+y8*5+3);
  end;
  if z8=3 then
  begin
    line (258+x8*5+1,140+y8*5+1,258+x8*5+1,140+y8*5+2);
    line (258+x8*5+2,140+y8*5+2,258+x8*5+2,140+y8*5+3);
    line (258+x8*5+3,140+y8*5+1,258+x8*5+3,140+y8*5+2);
  end;
  if z8=4 then
  begin
    line (258+x8*5+2,140+y8*5+1,258+x8*5+3,140+y8*5+1);
    line (258+x8*5+1,140+y8*5+2,258+x8*5+2,140+y8*5+2);
    line (258+x8*5+2,140+y8*5+3,258+x8*5+3,140+y8*5+3);
  end;
  setcolor(35);
end;

procedure level1;

begin
  if h2>0 then
  begin
    if batoh[h2]=1 then
    begin
      outtextxy(71,ck1,'Cervene jablicko');
      e:=e+1;
      inite;
      if ex=2 then exit;
      batoh[h2]:=0;
      initb2;
    end;
    if batoh[h2]=2 then
    begin
      outtextxy(71,ck1,'Zlaty peniz');
    end;
    if batoh[h2]=3 then
    begin
      outtextxy(71,ck1,'Nejaka listina');
      if ex=0 then listina;
    end;
    if batoh[h2]=4 then
    begin
      outtextxy(71,ck1,'Mrtvy netopyr');
    end;
    if batoh[h2]=5 then
    begin
      outtextxy(71,ck1,'Stary klic');
    end;
    if batoh[h2]=6 then
    begin
      outtextxy(71,ck1,'Magicky kriz');
    end;
    if batoh[h2]=7 then
    begin
      outtextxy(71,ck1,'Horici pochoden');
    end;
  end;
  {ohen}
  if (x8=1) and (y8=6) and (z8=3) and (x>126) and (y>114) and (x<160) and
  (y<150) and (l1[1,6,3]=1) then
  begin
    l1[1,6,3]:=2;
    outtextxy(71,ck1,'Vzal jsem horici vetev z');
    outtextxy(71,ck2,'ohniste');
    for f:=1 to 6 do
    begin
      if batoh[f]=0 then
      begin
        batoh[f]:=7;
        f:=6;
      end;
    end;
    initb2;
  end;
  {kostra}
  if (x8=1) and (y8=5) and (z8=1) and (x>83) and (y>115) and (x<125) and
  (y<126) then
  begin
    outtextxy(71,ck1,'Mrtvola nejakeho dobrodruha');
  end;
  {kostra}
  if (x8=1) and (y8=5) and (z8=1) and (x>88) and (y>127) and (x<118) and
  (y<135) and (l1[1,5,1]=1) then
  begin
    outtextxy(71,ck1,'Copak to tu je ... , nejaka');
    outtextxy(71,ck2,'listina a zlaty peniz');
    c:=0;
    for f:=1 to 6 do
    begin
      if batoh[f]=0 then c:=c+1;
    end;
    if c>1 then
    for f:=1 to 2 do
    begin
      for h:=1 to 6 do
      begin
        if batoh[h]=0 then
        begin
          batoh[h]:=f+1;
          h:=6;
        end;
      end;
    end;
    initb2;
    l1[1,5,1]:=2;
    new;
  end;
  {netopyr}
  if (x8=2) and (y8=5) and (l1[2,5,2]=1) then
  begin
    l1[3,5,1]:=0;
    l1[3,5,2]:=0;
    l1[3,5,3]:=0;
    l1[3,5,4]:=0;
    l1[2,5,2]:=4;
    if (z8=2) then
    begin
      gifshow('12522',127,48);
      delay(de);
      gifshow('12523',115,47);
      delay(de);
    end;
  end;
  {netopyr}
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=4) and (g2=1) then
  begin
    l1[3,5,1]:=1;
    l1[3,5,2]:=1;
    l1[3,5,3]:=1;
    l1[3,5,4]:=1;
    l1[2,5,2]:=8;
    l1[3,5,4]:=2;
    gifshow('12527',84,34);
    delay(de);
    new;
    g2:=0;
  end;
  {netopyr}
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=8) then
  begin
    gifshow('12528',112,117);
    delay(de);
  end;
  {netopyr}
  if ((x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=8) and (x>112) and (x<227)
  and (y>118) and (y<135)) or ((x8=3) and (y8=5) and (z8=4) and (l1[3,5,4]=2)
  and (x>99) and (x<200) and (y>124) and (y<135)) then
  begin
    l1[2,5,2]:=9;
    l1[3,5,4]:=1;
    new;
    outtextxy(71,ck1,'Mrtvej netopyr');
    for f:=1 to 6 do
    begin
      if batoh[f]=0 then
      begin
        batoh[f]:=4;
        f:=6;
      end;
    end;
    initb2;
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=1) then
  begin
    gifshow('14522',128,23);
    delay(de);
    l1[4,4,3]:=2;
    l1[4,6,1]:=2;
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (x>137) and (y>30) and (x<158) and
  (y<46) and (l1[4,5,2]=1) then
  begin
    outtextxy(71,ck1,'Straka a v zobaku ma stary');
    outtextxy(71,ck2,'klic');
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=1) and (batoh[h2]=2) then
  begin
    gifshow('14523',128,23);
    delay(de);
    l1[4,5,2]:=4;
    batoh[h2]:=0;
    initb2;
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=4) then
  begin
    gifshow('14524',128,23);
    delay(de);
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (x>137) and (y>30) and (x<158) and
  (y<46) and (l1[4,5,2]=4) then
  begin
    outtextxy(71,ck1,'Straka a v zobaku ma zlaty');
    outtextxy(71,ck2,'peniz');
  end;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (x>130) and (y>103) and (x<150) and
  (y<116) and (l1[4,5,2]=4) then
  begin
    gifshow('14525',128,15);
    delay(de);
    outtextxy(71,ck1,'Stary klic');
    for f:=1 to 6 do
    begin
      if batoh[f]=0 then
      begin
        batoh[f]:=5;
        f:=6;
      end;
    end;
    initb2;
    gifshow('14526',104,9);
    delay(de);
    gifshow('14527',80,5);
    delay(de);
    gifshow('14528',60,5);
    delay(de);
    l1[4,4,3]:=1;
    l1[4,6,1]:=1;
    l1[4,5,2]:=8;
    new;
  end;
  {druid}
  if (x8=5) and (y8=7) and (z8=3) and (batoh[h2]=4) and (l1[5,7,3]=1) then
  begin
    batoh[h2]:=0;
    initb2;
    l1[5,7,3]:=2;
  end;
  {druid}
  if (x8=5) and (y8=7) and (z8=3) and (l1[5,7,3]=2) then
  begin
    gifshow('15738',59,4);
    delay(de);
  end;
  {druid}
  if (x8=5) and (y8=7) and (z8=3) and (l1[5,7,3]=2) and (x>60) and (y>5) and
  (x<260) and (y<135) then
  begin
    l1[5,7,3]:=9;
    for f:=1 to 6 do
    begin
      if batoh[f]=0 then
      begin
        batoh[f]:=6;
        f:=6;
      end;
    end;
    initb2;
    new;
    outtextxy(71,ck1,'Magicky kriz');
  end;
  {kasna}
  if (x8=6) and (y8=6) and (z8=2) and (x>124) and (y>114) and (x<151) and
  (y<123) then
  begin
    outtextxy(71,ck1,'Napis na drevene desce');
    if ex=0 then deska;
  end;
  {kasna}
  if (x8=6) and (y8=6) and (z8=2) and (l1[6,6,2]=1) and (x>120) and (y>124)
  and (x<154) and (y<135) then
  begin
    m:=m+1;
    l1[6,6,2]:=2;
    initm;
    outtextxy(71,ck1,'Voda v studance mi zvetsila');
    outtextxy(71,ck2,'mou magickou silu');
  end;
  {skret}
  if (x8=6) and (y8=4) and (z8=1) and (l1[6,4,1]=1) and (x>60) and (y>75) and
  (x<85) and (y<105) then
  begin
    outtextxy(71,ck1,'Kameny');
  end;
  {skret}
  if (x8=6) and (y8=4) and (z8=1) and (l1[6,4,1]=1) and (x>170) and (y>93) and
  (x<183) and (y<107) then
  begin
    gifshow('16412',60,75);
    delay(de);
    e:=e-1;
    inite;
    if ex=2 then exit;
    new;
    g2:=0;
    outtextxy(71,ck1,'To je muj diamat');
  end;
  if (x8=6) and (y8=4) and (z8=1) and (l1[6,4,1]=1) and (g2=1) then
  begin
    gifshow('16412',60,75);
    delay(de);
    e:=e-1;
    inite;
    if ex=2 then exit;
    new;
    g2:=0;
    outtextxy(71,ck1,'Tohle na me nezkousej');
  end;
  {skret}
  if (x8=6) and (y8=4) and (z8=1) and (l1[6,4,1]=1) and (g2=5) and (m=2) then
  begin
    gifshow('16413',60,75);
    delay(de);
    gifshow('16414',60,69);
    delay(de);
    gifshow('16415',60,49);
    delay(de);
    gifshow('16416',60,49);
    delay(de);
    gifshow('16417',60,79);
    delay(de);
    gifshow('16418',59,4);
    delay(de);
    l1[6,4,1]:=8;
    g2:=0;
    outtextxy(71,ck1,'Skret je mrtvy');
  end;
  {skret}
  if (x8=6) and (y8=4) and (z8=1) and (l1[6,4,1]=8) and (x>154) and (y>106) and
  (x<165) and (y<118) then
  begin
    l1[6,4,1]:=9;
    new;
    gifshow('50001',4,139);
    delay(de);
    outtextxy(71,ck1,'Diamat je muj');
    dia:=1;
  end;
  {vlk}
  if (x8=4) and (y8=3) and (l1[4,3,1]=1) then
  begin
    l1[4,2,1]:=0;
    l1[4,2,2]:=0;
    l1[4,2,3]:=0;
    l1[4,2,4]:=0;
    l1[4,3,1]:=6;
    if (z8=1) then
    begin
      gifshow('14312',127,63);
      delay(de);
      gifshow('14313',126,59);
      delay(de);
      gifshow('14314',119,49);
      delay(de);
      gifshow('14315',119,39);
      delay(de);
      li:=2;
    end;
  end;
  {vlk}
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) and (g2=1) then
  begin
    li:=li-1;
    gifshow('14317',119,29);
    delay(de);
    if li=0 then
    begin
      l1[4,2,1]:=1;
      l1[4,2,2]:=1;
      l1[4,2,3]:=1;
      l1[4,2,4]:=1;
      l1[4,3,1]:=8;
      new;
    end;
    g2:=0;
  end;
  {vlk}
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) and (batoh[h2]=6) then
  begin
    batoh[h2]:=0;
    initb2;
    l1[4,2,1]:=1;
    l1[4,2,2]:=1;
    l1[4,2,3]:=1;
    l1[4,2,4]:=1;
    l1[4,3,1]:=8;
    new;
  end;
  {vlk}
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) then
  begin
    gifshow('14315',119,39);
    delay(de);
  end;
  {dvere}
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=1) and (x>60) and (y>5) and
  (x<260) and (y<135) then
  begin
    outtextxy(71,ck1,'Dvere jsou zamcene');
  end;
  {dvere}
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=1) and (batoh[h2]=5) then
  begin
    batoh[h2]:=0;
    initb2;
    l1[4,1,1]:=2;
    new;
  end;
  {dvere}
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=2) and (x>60) and (y>5) and
  (x<260) and (y<135) then
  begin
    outtextxy(71,ck1,'Neni vubec nic videt');
  end;
  {dvere}
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=2) and (batoh[h2]=7) then
  begin
    batoh[h2]:=0;
    initb2;
    l1[4,1,1]:=3;
    new;
  end;
  {dvere}
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=3) and (x>60) and (y>5) and
  (x<260) and (y<135) and (dia=0) then
  begin
    outtextxy(71,ck1,'Sem nemohu, nejdrive musim');
    outtextxy(71,ck2,'ziskat diamant');
  end;
  if (x8=4) and (y8=1) and (z8=1) and (l1[4,1,1]=3) and (x>60) and (y>5) and
  (x<260) and (y<135) and (dia=1) then
  begin
  outtextxy(71,ck1,'Toto je konec');
  readkey;
  ex:=2;
  exit;
  end;
end;

procedure level2;
begin
end;

procedure level3;
begin
end;

procedure level4;
begin
end;

procedure level1a;

begin
  {movie-ohen}
  if (x8=1) and (y8=6) and (z8=3) then
  begin
    gifshow('11632',119,101);
    delay(de);
    gifshow('11633',119,101);
    delay(de);
  end;
  {movie-netopyr}
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=4) then
  begin
    gifshow('12524',84,39);
    delay(de);
    r:=(random(5));
    if r=1 then
    begin
      gifshow('12526',84,39);
      delay(de);
      e:=e-1;
      inite;
      if ex=2 then exit;
    end
    else
    begin
      gifshow('12525',84,39);
      delay(de);
    end;
  end;
  {movie-druid}
  if (x8=5) and (y8=7) and (z8=3) then
  begin
    gifshow('15732',221,5);
    delay(de);
    gifshow('15735',168,73);
    delay(de);
    gifshow('15733',221,5);
    delay(de);
    gifshow('15736',168,73);
    delay(de);
    gifshow('15734',221,5);
    delay(de);
    gifshow('15737',168,73);
    delay(de);
  end;
  {movie-vlk}
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) then
  begin
    delay(de);
    r:=(random(5));
    if (r=1) or (r=2) then
    begin
      gifshow('14316',119,39);
      delay(de);
      e:=e-r;
      inite;
      if ex=2 then exit;
      gifshow('14315',119,39);
      delay(de);
    end
  end;
end;

procedure levels2;

begin
  clesma;
  if g2=1 then outtextxy(71,ck1,'Kouzlo Fire zde nelze pouzit');
  if g2=2 then
  begin
    outtextxy(71,ck1,'Kouzlo Freeze nelze zatim');
    outtextxy(71,ck2,'pouzit, potrebujete vice Many');
  end;
  if g2=3 then
  begin
    outtextxy(71,ck1,'Kouzlo Flash nelze zatim');
    outtextxy(71,ck2,'pouzit, potrebujete vice Many');
  end;
  if g2=4 then
  begin
    outtextxy(71,ck1,'Kouzlo Death nelze pouzit,');
    outtextxy(71,ck2,'neznas zarikadlo smrti');
  end;
  if g2=5 then
  begin
    if m=1 then
    begin
      outtextxy(71,ck1,'Kouzlo Move nelze zatim');
      outtextxy(71,ck2,'pouzit, potrebujete vice Many');
    end;
    if m=2 then outtextxy(71,ck1,'Kouzlo Move zde nelze pouzit');
 end;
end;

procedure levels;

begin
  clesma;
  f2:=0;
  g2:=0;
  h2:=0;
  if (x>266) and (x<314) and (y>4) and (y<20) then info;{info}
  if (x>266) and (x<314) and (y>103) and (y<135) then{kurzor}
  begin
    x9:=x8;
    y9:=y8;
    z9:=z8;
    if (x>266) and (x<282) and (y>103) and (y<119) then
    begin
      z9:=z9-1;
      if z9=0 then z9:=4;
    end;
    if (x>282) and (x<298) and (y>103) and (y<119) then
    begin
      if z9=1 then y9:=y9-1;
      if z9=2 then x9:=x9+1;
      if z9=3 then y9:=y9+1;
      if z9=4 then x9:=x9-1;
    end;
    if (x>298) and (x<314) and (y>103) and (y<119) then
    begin
      z9:=z9+1;
      if z9=5 then z9:=1;
    end;
    if (x>266) and (x<282) and (y>119) and (y<135) then
    begin
      if z9=1 then x9:=x9-1;
      if z9=2 then y9:=y9-1;
      if z9=3 then x9:=x9+1;
      if z9=4 then y9:=y9+1;
     end;
    if (x>282) and (x<298) and (y>119) and (y<135) then
    begin
      if z9=1 then y9:=y9+1;
      if z9=2 then x9:=x9-1;
      if z9=3 then y9:=y9-1;
      if z9=4 then x9:=x9+1;
    end;
    if (x>298) and (x<314) and (y>119) and (y<135) then
    begin
      if z9=1 then x9:=x9+1;
      if z9=2 then y9:=y9+1;
      if z9=3 then x9:=x9-1;
      if z9=4 then y9:=y9-1;
    end;
    if (x9>0) and (x9<10) and (y9>0) and (y9<10) and (z9>0) and (z9<5) then
    begin
      if (l=1) and (l1[x9,y9,z9]>0) then f2:=1;
      if (l=2) and (l2[x9,y9,z9]>0) then f2:=1;
      if (l=3) and (l3[x9,y9,z9]>0) then f2:=1;
      if (l=4) and (l4[x9,y9,z9]>0) then f2:=1;
    end;
    if f2=1 then
    begin
      k1;
      x8:=x9;
      y8:=y9;
      z8:=z9;
      new;
      k1;
      k2;
    end;
  end;
  if (x>269) and (x<311) and (y>29) and (y<92) then{kouzla}
  begin
    if (y>29) and (y<40) then g2:=1;
    if (y>42) and (y<53) then g2:=2;
    if (y>55) and (y<66) then g2:=3;
    if (y>68) and (y<79) then g2:=4;
    if (y>81) and (y<92) then g2:=5;
  end;
  if (x>71) and (x<247) and (y>167) and (y<192) then{zasobnik}
  begin
    if (x>72) and (x<101) then h2:=1;
    if (x>101) and (x<130) then h2:=2;
    if (x>130) and (x<159) then h2:=3;
    if (x>159) and (x<188) then h2:=4;
    if (x>188) and (x<217) then h2:=5;
    if (x>217) and (x<246) then h2:=6;
  end;
  if ((x>59) and (x<260) and (y>4) and (y<135)) or (g2>0) or (h2>0) then
  begin
    if l=1 then level1;
    if l=2 then level2;
    if l=3 then level3;
    if l=4 then level4;
  end;
  if g2>0 then levels2;
  {netopyr}
  if (x8=2) and (y8=5) and (l1[2,5,2]=1) then level1;
  if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=8) then level1;
  {vlk}
  if (x8=4) and (y8=3) and (l1[4,3,1]=1) then level1;
  if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) then level1;
  {straka}
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=4) then level1;
  if (x8=4) and (y8=5) and (z8=2) and (l1[4,5,2]=1) then level1;
  {druid}
  if (x8=5) and (y8=7) and (z8=3) and (l1[5,7,3]=2) then level1;
end;

procedure mys;

begin
  ex:=0;
  ukaz_mysku;
  repeat
    stisk_mysky(leve_tlacitko,kolik,x,y);
    if kolik>0 then
      begin
        schovej_mysku;
        x:=trunc(x/2);
        ex:=0;
        levels;
        ukaz_mysku;
      end;
    stisk_mysky(prave_tlacitko,kolik,x,y);
    if ex<2 then
    begin
      {movie-ohen}
      if (x8=1) and (y8=6) and (z8=3) then level1a;
      {movie-netopyr}
      if (x8=2) and (y8=5) and (z8=2) and (l1[2,5,2]=4) then level1a;
      {movie-vlk}
      if (x8=4) and (y8=3) and (z8=1) and (l1[4,3,1]=6) then level1a;
      {movie-druid}
      if (x8=5) and (y8=7) and (z8=3) then level1a;
    end;
  until ex>1;
end;

procedure game;

begin
  cleardevice;
  clemap;
  init1;
  init2;
  init3;
  init4;
  clebat;
  dia:=0;
  {level1-begin}
  l:=1;
  x8:=1;
  y8:=6;
  z8:=1;
  m:=1;
  e:=4;
  batoh[1]:=1;
  {level1-end}
  initn;
  new;
  k1;
  k2;
  initm;
  inite;
  initb;
  settextstyle(2,0,2);
  setusercharsize(1,1,4,4);
  mys;
end;

procedure outro;

begin
end;

begin
  initvga256(vga256modes(0));
  gifshow('50011',0,0);
  readkey;
  game;
  outro;
  closegraph;
end.