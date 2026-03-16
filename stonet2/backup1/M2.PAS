program m;

uses svga,crt,dos;

const sk1=0;  sk2=512; sk3=1024; sk4=1536; sk5=2048; sk6=2560; sk7=3072;
      sk8=3564; sk9=4096; sk10=4608; sk11=5102; sk12=5632; sk13=6144;
      sk14=6656; sk15=7168; sk16=7680; sk17=8192; sk18=8704; sk19=9216;

var
    deska1:array[0..20,0..19] of byte;
    deska2:array[0..20,0..19] of byte;
    deska3:array[0..20,0..19] of byte;
    deska4:array[0..20,0..19] of byte;
    deska5:array[0..20,0..19] of byte;
    deska6:array[0..20,0..19] of byte;
    deska7:array[0..20,0..19] of byte;
    deska8:array[0..20,0..19] of byte;
    deska9:array[0..20,0..19] of byte; {u vojaku zbytecny nejaky pole dyt}
    deska10:array[0..20,0..19] of byte;{je muzu obratit v prg}
    deska11:array[0..20,0..19] of byte;
    deska12:array[0..20,0..19] of byte;
    i,j,v,z,q,sped,x,y:word;
    smer,mne:byte;
    ran:integer;

procedure AAPal(Jmeno:String;Skok:LongInt);
var A : File;
    C : Array[1..768] of Byte;
    R : Registers;
begin
  Assign(A,Jmeno);
  {$I-}Reset(A,1);{$I+}
  If IOResult>0 then begin ExitGraphics;;WriteLn(' Soubor ',Jmeno,' nenalezen !');Halt(1);end;
  Seek(A,Skok);
  BlockRead(A,C,768);
  Close(A);
  begin with R do begin ah := $10;al := $12;bx := 0;cx := 256;dx := ofs(C);es := seg(C);end;
  intr($10, R);end;
end;

procedure LoadGOB(Name:String;skok:longint;kam:byte);
var Fila:File;
begin
  Assign(Fila,Name);
  Reset(Fila,1);
  seek(fila,skok);

  if kam=1 then blockread(fila,deska1,sizeof(deska1));
  if kam=2 then blockread(fila,deska2,sizeof(deska2));
  if kam=3 then blockread(fila,deska3,sizeof(deska3));
  if kam=4 then blockread(fila,deska4,sizeof(deska4));
  if kam=5 then blockread(fila,deska5,sizeof(deska5));
  if kam=6 then blockread(fila,deska6,sizeof(deska6));
  if kam=7 then blockread(fila,deska7,sizeof(deska7));
  if kam=8 then blockread(fila,deska8,sizeof(deska8));
  if kam=9 then blockread(fila,deska9,sizeof(deska9));
  if kam=10 then blockread(fila,deska10,sizeof(deska10));
  if kam=11 then blockread(fila,deska11,sizeof(deska11));
  if kam=12 then blockread(fila,deska12,sizeof(deska12));
  Close(Fila);
end;

procedure smaz(x,y:word;co:byte);
begin
for i:=0 to 19 do
 begin
  for j:=0 to 20 do
   begin
    if co=1 then plot(j+x,i+y,0);
    if co=2 then plot(j+x,i+y,0);
    if co=3 then plot(j+x,i+y,0);
    if co=4 then plot(j+x,i+y,0);
    if co=5 then plot(j+x,i+y,0);
    if co=6 then plot(j+x,i+y,0);
    if co=7 then plot(j+x,i+y,0);
    if co=8 then plot(j+x,i+y,0);
    if co=9 then plot(j+x,i+y,0);
    if co=10 then plot(j+x,i+y,0);
    if co=11 then plot(j+x,i+y,0);
    if co=12 then plot(j+x,i+y,0);
   end;
 end;
end;

procedure smazrev(x,y:word;co:byte);
var r:word;
begin
for i:=0 to 19 do
 begin
  r:=0;
  for j:=20 downto 0 do
   begin
    if co=1 then plot(r+x,i+y,0);
    if co=2 then plot(r+x,i+y,0);
    if co=3 then plot(r+x,i+y,0);
    if co=4 then plot(r+x,i+y,0);
    if co=5 then plot(r+x,i+y,0);
    if co=6 then plot(r+x,i+y,0);
    if co=7 then plot(r+x,i+y,0);
    if co=8 then plot(r+x,i+y,0);
    if co=9 then plot(r+x,i+y,0);
    if co=10 then plot(r+x,i+y,0);
    if co=11 then plot(r+x,i+y,0);
    if co=12 then plot(r+x,i+y,0);
    r:=r+1;
   end;
 end;
end;


procedure pis(x,y:word;co:byte);
begin
for i:=0 to 19 do
 begin
  for j:=0 to 20 do
   begin
    if co=1 then plot(j+x,i+y,deska1[j,i]);
    if co=2 then plot(j+x,i+y,deska2[j,i]);
    if co=3 then plot(j+x,i+y,deska3[j,i]);
    if co=4 then plot(j+x,i+y,deska4[j,i]);
    if co=5 then plot(j+x,i+y,deska5[j,i]);
    if co=6 then plot(j+x,i+y,deska6[j,i]);
    if co=7 then plot(j+x,i+y,deska7[j,i]);
    if co=8 then plot(j+x,i+y,deska8[j,i]);
    if co=9 then plot(j+x,i+y,deska9[j,i]);
    if co=10 then plot(j+x,i+y,deska10[j,i]);
    if co=11 then plot(j+x,i+y,deska11[j,i]);
    if co=12 then plot(j+x,i+y,deska12[j,i]);
   end;
 end;
end;

procedure pisrev(x,y:word;co:byte);
var r:word;
begin
for i:=0 to 19 do
 begin
  r:=0;
  for j:=20 downto 0 do
   begin
    if co=1 then plot(r+x,i+y,deska1[j,i]);
    if co=2 then plot(r+x,i+y,deska2[j,i]);
    if co=3 then plot(r+x,i+y,deska3[j,i]);
    if co=4 then plot(r+x,i+y,deska4[j,i]);
    if co=5 then plot(r+x,i+y,deska5[j,i]);
    if co=6 then plot(r+x,i+y,deska6[j,i]);
    if co=7 then plot(r+x,i+y,deska7[j,i]);
    if co=8 then plot(r+x,i+y,deska8[j,i]);
    if co=9 then plot(r+x,i+y,deska9[j,i]);
    if co=10 then plot(r+x,i+y,deska10[j,i]);
    if co=11 then plot(r+x,i+y,deska11[j,i]);
    if co=12 then plot(r+x,i+y,deska12[j,i]);
    r:=r+1;
   end;
 end;
end;

procedure smazba(x1,y1,x2,y2:word);
var tx,ty:word;
begin
for ty:=y1 to y2 do
 begin
  for tx:=x1 to x2 do
   begin
    plot(tx,ty,0);
   end;
 end;
end;


BEGIN
loadgob('chuze.lib',sk1,1);write('.');
loadgob('chuze.lib',sk2,2);write('.');
loadgob('chuze.lib',sk3,3);write('.');
loadgob('chuze.lib',sk4,4);write('.');
loadgob('chuze.lib',sk5,5);write('.');
loadgob('chuze.lib',sk6,6);write('.');
loadgob('chuze.lib',sk7,7);write('.');
loadgob('chuze.lib',sk8,8);write('.');
loadgob('chuze.lib',sk9,9);write('.');
loadgob('chuze.lib',sk10,10);write('.');
loadgob('chuze.lib',sk11,11);write('.');
loadgob('chuze.lib',sk12,12);write('.');
writeln;write('Rychlost:');readln(sped);
if sped<5 then sped:=5 ;
if sped>500 then sped:=500;
SetMode( SVGA6440 );
    LoadPalette( 'boot.pal' );


aapal('ch1.cel',32);
randomize;
v:=0;smer:=1;x:=160;y:=100;q:=0;
repeat
 q:=q+1;
 if (y+v)<10 then smer:=2; if (y+v)>180 then smer:=1;
 if (x+v)<10 then smer:=4; if (x+v)>300 then smer:=3;
 if q=5 then q:=1;
 ran:=random(50);
 if ran=25 then smer:=(random(3))+2;
 if smer=1 then
  begin
   v:=v-2;
   if q=1 then pis(x,y+v,4);
   if q=2 then pis(x,y+v,5);
   if q=3 then pis(x,y+v,4);
   if q=4 then pis(x,y+v,6);
  end;
 if smer=2 then
  begin
   v:=v+2;
   if q=1 then pis(x,y+v,1);
   if q=2 then pis(x,y+v,2);
   if q=3 then pis(x,y+v,1);
   if q=4 then pis(x,y+v,3);
  end;
 if smer=3 then
  begin
   v:=v-2;
   if q=1 then pis(x+v,y,10);
   if q=2 then pis(x+v,y+2,11);
   if q=3 then pis(x+v,y,10);
   if q=4 then pis(x+v,y,12);
  end;
 if smer=4 then
  begin
   v:=v+2;
   if q=1 then pis(x+v,y,7);
   if q=2 then pis(x+v,y,8);
   if q=3 then pis(x+v,y,7);
   if q=4 then pis(x+v,y,8);
  end;
  for mne:= 1 to 12 do
   begin
    pis(10+(mne*15),10,mne);
    pis(10+(mne*15),30,mne);
    pis(10+(mne*15),50,mne);
    pis(10+(mne*15),70,mne);
   end;
  delay(sped);
  smazba(x+v,y,x+v+20,y+20);smazba(x,y+v,x+20,y+v+20);
until keypressed;

ExitGraphics;
END.

