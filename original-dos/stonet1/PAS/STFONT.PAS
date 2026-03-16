unit stfont;

interface

uses graph,vga256;

var fcol,fx,fy:word;

procedure pis(fx,fy,fcol:word;veta:string);


implementation

var   delka,gdelka:word;
      veta,retez:string;
      xv,px,py:word;
      cykl:integer;

procedure vypisretezec(fx,fy,fcol:word;retezec:string);
begin
px:=fx+xv;
py:=fy;

setcolor(fcol);
if (retezec='A') then
   begin
    line(px,py+2,px,py+6);line(px+1,py+1,px+2,py);
    line(px+3,py+1,px+3,py+1);
    line(px+4,py+2,px+4,py+6);line(px+1,py+3,px+3,py+3);
   end;
if (retezec='B') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+2,py);
    line(px+1,py+3,px+3,py+3);line(px+3,py+1,px+3,py+2);
    line(px+1,py+6,px+3,py+6);line(px+4,py+4,px+4,py+5);
   end;
if (retezec='C') then
   begin
    line(px+1,py,px+4,py);line(px,py+1,px,py+5);
    line(px+1,py+6,px+4,py+6);
   end;
if (retezec='D') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+2,py);line(px+3,py+1,px+3,py+1);
    line(px+4,py+2,px+4,py+4);line(px+3,py+5,px+3,py+5);
    line(px+1,py+6,px+2,py+6);
   end;
if (retezec='E') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+4,py);line(px+1,py+3,px+2,py+3);
    line(px+1,py+6,px+4,py+6);
   end;
if (retezec='F') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+4,py);line(px+1,py+3,px+2,py+3);
   end;
if (retezec='G') then
   begin
    line(px,py+1,px,py+5);line(px+1,py,px+4,py);line(px+1,py+6,px+3,py+6);
    line(px+4,py+5,px+4,py+3);line(px+3,py+3,px+3,py+3);
   end;
if (retezec='H') then
   begin
    line(px,py,px,py+6);line(px+1,py+3,px+3,py+3);line(px+4,py,px+4,py+6);
   end;
if (retezec='I') then
   begin
    line(px+1,py,px+3,py);line(px+2,py+1,px+2,py+5);
    line(px+1,py+6,px+3,py+6);
   end;
if (retezec='J') then
   begin
    line(px,py,px+4,py);line(px+4,py+1,px+4,py+5);line(px+1,py+6,px+3,py+6);
    line(px,py+4,px,py+5);
   end;
if (retezec='K') then
   begin
    line(px,py,px,py+6);line(px+1,py+3,px+4,py);line(px+1,py+3,px+4,py+6);
   end;
if (retezec='L') then
   begin
    line(px,py,px,py+6);line(px+1,py+6,px+4,py+6);
   end;
if (retezec='M') then
   begin
    line(px,py,px,py+6);line(px+1,py+1,px+2,py+2);line(px+3,py+1,px+3,py+1);
    line(px+4,py,px+4,py+6);
   end;
if (retezec='N') then
   begin
    line(px,py,px,py+6);line(px+1,py+1,px+3,py+3);line(px+4,py,px+4,py+6);
   end;
if (retezec='O') then
   begin
    line(px,py+1,px,py+5);line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+5);
    line(px+1,py+6,px+3,py+6);
   end;
if (retezec='P') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+2);
    line(px+1,py+3,px+3,py+3);
   end;
if (retezec='Q') then
   begin
    line(px,py+1,px,py+5);line(px+1,py,px+2,py);line(px+3,py+1,px+3,py+5);
    line(px+1,py+6,px+2,py+6);line(px+2,py+4,px+4,py+6);
   end;
if (retezec='R') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+2);
    line(px+1,py+3,px+3,py+3);line(px+2,py+4,px+4,py+6);
   end;
if (retezec='S') then
   begin
    line(px+1,py,px+4,py);line(px,py+1,px,py+2);line(px+1,py+3,px+3,py+3);
    line(px+4,py+4,px+4,py+5);line(px,py+6,px+3,py+6);
   end;
if (retezec='T') then
   begin
    line(px,py,px+4,py);line(px+2,py+1,px+2,py+6);
   end;
if (retezec='U') then
   begin
    line(px,py,px,py+5);line(px+1,py+6,px+3,py+6);line(px+4,py,px+4,py+5);
   end;
if (retezec='V') then
   begin
    line(px,py,px,py+4);line(px+1,py+5,px+2,py+6);line(px+3,py+5,px+3,py+5);
    line(px+4,py,px+4,py+4);
   end;
if (retezec='W') then
   begin
    line(px,py,px,py+6);line(px+1,py+6,px+2,py+5);line(px+2,py+4,px+2,py+4);
    line(px+3,py+6,px+4,py+6);line(px+4,py,px+4,py+5);
   end;
if (retezec='X') then
   begin
    line(px,py,px,py+1);line(px+1,py+2,px+3,py+4);line(px+4,py+5,px+4,py+6);
    line(px+4,py,px+4,py+1);line(px+3,py+2,px+1,py+4);line(px,py+5,px,py+6);
   end;
if (retezec='Y') then
   begin
    line(px,py,px,py+1);line(px+1,py+2,px+2,py+3);line(px+3,py+2,px+4,py+1);
    line(px+4,py,px+4,py);line(px+2,py+4,px+2,py+6);
   end;
if (retezec='Z') then
   begin
    line(px,py,px+4,py);line(px,py+6,px+4,py+6);line(px,py+5,px+2,py+3);
    line(px+3,py+2,px+4,py+1);
   end;
if (retezec='0') then
   begin
    line(px,py+1,px,py+5);line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+5);
    line(px+1,py+6,px+3,py+6);
   end;
if (retezec='1') then
   begin
    line(px+2,py,px+2,py+5);line(px+1,py+6,px+3,py+6);
    line(px+1,py+1,px+1,py+1);
   end;
if (retezec='2') then
   begin
    line(px+1,py,px+3,py);line(px,py+1,px,py+1);line(px+4,py+1,px+4,py+2);
    line(px+2,py+3,px+3,py+3);line(px+1,py+4,px+1,py+4);
    line(px,py+5,px,py+6);line(px,py+6,px+4,py+6);
   end;
if (retezec='3') then
   begin
    line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+2);line(px+2,py+3,px+3,py+3);
    line(px+4,py+4,px+4,py+5);line(px,py+6,px+3,py+6);
   end;
if (retezec='4') then
   begin
    line(px,py+3,px+3,py);line(px+3,py,px+3,py+6);line(px,py+4,px+4,py+4);
   end;
if (retezec='5') then
   begin
    line(px,py,px+3,py);line(px,py+1,px,py+3);line(px,py+3,px+3,py+3);
    line(px+4,py+4,px+4,py+5);line(px,py+6,px+3,py+6);
   end;
if (retezec='6') then
   begin
    line(px+2,py,px+3,py);line(px+1,py+1,px+1,py+1);line(px,py+2,px,py+5);
    line(px+1,py+3,px+3,py+3);line(px+4,py+4,px+4,py+5);
    line(px+1,py+6,px+3,py+6);
   end;
if (retezec='7') then
   begin
    line(px,py,px+4,py);line(px,py+6,px+4,py+2);line(px+4,py+1,px+4,py+1);
   end;
if (retezec='8') then
   begin
    line(px+1,py,px+3,py);line(px,py+1,px,py+2);line(px+4,py+1,px+4,py+2);
    line(px+1,py+3,px+3,py+3);line(px,py+4,px,py+5);
    line(px+1,py+6,px+3,py+6);line(px+4,py+4,px+4,py+5);
   end;
if (retezec='9') then
   begin
    line(px+1,py,px+3,py);line(px+4,py+1,px+4,py+5);line(px,py+1,px,py+2);
    line(px+1,py+3,px+3,py+3);line(px+1,py+6,px+3,py+6);
   end;
if (retezec='a') then
   begin
    line(px,py+4,px+4,py);line(px+3,py+3,px+4,py+4);line(px,py+5,px+4,py+5);
    line(px,py+6,px,py+6);line(px+4,py+6,px+4,py+6);
   end;
if (retezec='c') then
   begin
    line(px,py+3,px,py+5);line(px+1,py+2,px+4,py+2);line(px+1,py+6,px+4,py+6);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='d') then
   begin
    line(px,py+2,px,py+6);line(px+1,py+2,px+3,py+2);line(px+4,py+3,px+4,py+5);
    line(px+1,py+6,px+3,py+6);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='e') then
   begin
    line(px,py+2,px,py+6);line(px+1,py+2,px+4,py+2);line(px+1,py+4,px+2,py+4);
    line(px+1,py+6,px+4,py+6);
    line(px+2,py+1,px+3,py);
   end;
if (retezec='@') then
   begin
    line(px,py+2,px,py+6);line(px+1,py+2,px+4,py+2);line(px+1,py+4,px+2,py+4);
    line(px+1,py+6,px+4,py+6);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='i') then
   begin
    line(px+1,py+2,px+3,py+2);line(px+2,py+3,px+2,py+5);
    line(px+1,py+6,px+3,py+6);
    line(px+2,py+1,px+3,py);
   end;
if (retezec='o') then
   begin
    line(px+1,py+2,px+3,py+2);line(px,py+3,px,py+5);line(px+4,py+3,px+4,py+5);
    line(px+1,py+6,px+3,py+6);
    line(px+2,py+1,px+3,py);
   end;
if (retezec='r') then
   begin
    line(px,py+2,px,py+6);line(px+1,py+2,px+3,py+2);line(px+3,py+5,px+4,py+6);
    line(px+4,py+3,px+4,py+3);line(px+1,py+4,px+3,py+4);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='s') then
   begin
    line(px+1,py+2,px+4,py+2);line(px,py+3,px,py+3);line(px+1,py+4,px+3,py+4);
    line(px+4,py+5,px+4,py+5);line(px,py+6,px+3,py+6);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='t') then
   begin
    line(px,py+2,px+4,py+2);line(px+2,py+3,px+2,py+6);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='u') then
   begin
    line(px,py+2,px,py+5);line(px+1,py+6,px+3,py+6);line(px+4,py+2,px+4,py+5);
    line(px+2,py+1,px+3,py);
   end;
if (retezec='"') then
   begin
    line(px,py+2,px,py+5);line(px+1,py+6,px+3,py+6);line(px+4,py+2,px+4,py+5);
    line(px+2,py,px+3,py);line(px+2,py+1,px+3,py+1);
   end;
if (retezec='y') then
   begin
    line(px,py+2,px+1,py+3);line(px+3,py+3,px+4,py+2);
    line(px+2,py+4,px+2,py+6);
    line(px+2,py+1,px+3,py);
   end;
if (retezec='z') then
   begin
    line(px,py+2,px+4,py+2);line(px,py+6,px+4,py+6);line(px,py+5,px,py+5);
    line(px+1,py+4,px+3,py+4);line(px+4,py+3,px+4,py+3);
    line(px+1,py,px+2,py+1);line(px+3,py,px+3,py);
   end;
if (retezec='[') then
   begin
    line(px,py,px,py+6);line(px+1,py,px+1,py);line(px+1,py+6,px+1,py+6);
   end;
if (retezec=']') then
   begin
    line(px+3,py,px+4,py);line(px+4,py+1,px+4,py+6);line(px+3,py+6,px+3,py+6);
   end;
if (retezec='(') then
   begin
    line(px+1,py,px+1,py);line(px,py+1,px,py+5);line(px+1,py+6,px+1,py+6);
   end;
if (retezec=')') then
   begin
    line(px+3,py,px+3,py);line(px+4,py+1,px+4,py+5);line(px+3,py+6,px+3,py+6);
   end;
if (retezec='!') then
   begin
     line(px+2,py,px+2,py+4);line(px+2,py+6,px+2,py+6);
   end;
if (retezec='?') then
   begin
    line(px,py,px+3,py);line(px+4,py+1,px+4,py+1);line(px+2,py+2,px+3,py+2);
    line(px+2,py+3,px+2,py+4);line(px+2,py+6,px+2,py+6);
   end;
if (retezec=',') then
   begin
    line(px+3,py+5,px+2,py+6);
   end;
if (retezec=':') then
   begin
    line(px+2,py+2,px+2,py+2);line(px+2,py+4,px+2,py+4);
   end;
if (retezec='=') then
   begin
    line(px+1,py+2,px+3,py+2);line(px+1,py+4,px+3,py+4);
   end;
if (retezec='+') then
   begin
    line(px+1,py+3,px+3,py+3);line(px+2,py+2,px+2,py+4);
   end;
if (retezec='-') then
   begin
    line(px+1,py+3,px+3,py+3);
   end;
if (retezec='*') then
   begin
    line(px+1,py+2,px+3,py+4);line(px+1,py+4,px+3,py+2);
   end;
if (retezec='/') then
   begin
    line(px,py+5,px+4,py+1);line(px,py+6,px+4,py+2);
   end;
if (retezec='.') then
   begin
    line(px+2,py+6,px+2,py+6);
   end;
if (retezec=' ') then
   begin
   end;
if (retezec='Ç') then {d}
   begin
    line(px,py,px,py+6);line(px+4,py,px+4,py+6);line(px+1,py+1,px+2,py+2);
    line(px+3,py+1,px+3,py+1);line(px+1,py+5,px+2,py+4);
    line(px+3,py+5,px+3,py+5);line(px+2,py+3,px+2,py+3);
   end;
if (retezec='É') then {c}
   begin
    line(px+1,py,px+1,py+6);line(px+2,py+2,px+4,py);
   end;
if (retezec='Ñ') then {t}
   begin
     line(px,py,px+1,py);line(px+2,py+1,px+4,py+1);line(px,py+6,px+1,py+3);
     line(px+3,py+3,px+4,py+6);line(px+2,py+2,px+2,py+2);
   end;
if (retezec='Ö') then {h}
   begin
    line(px,py,px,py+6);line(px+1,py+2,px+3,py+4);line(px+1,py+4,px+3,py+6);
    line(px+4,py,px+4,py+6);
   end;
if (retezec='Ü') then {e}
   begin
    line(px,py,px,py+6);line(px+1,py,px+2,py+1);line(px+1,py+2,px+2,py+3);
    line(px+3,py+1,px+4,py);line(px+3,py+3,px+4,py+2);
   end;
if (retezec='á') then {f}
   begin
    line(px+1,py,px+3,py);line(px,py+1,px,py+2);line(px+4,py+1,px+4,py+2);
    line(px+1,py+3,px+3,py+3);line(px+2,py+4,px+2,py+6);
    line(px+3,py+6,px+4,py+5);
   end;
if (retezec='à') then {a}
   begin
    line(px,py,px,py);line(px,py+1,px+4,py+5);line(px+1,py+4,px+1,py+5);
    line(px+2,py+6,px+3,py+6);
   end;
if (retezec='â') then {s}
   begin
    line(px,py+3,px+4,py+3);line(px,py+2,px+1,py+1);line(px+2,py+1,px+3,py);
    line(px+4,py,px+4,py);line(px+1,py+6,px+3,py+4);
   end;
if (retezec='ä') then {i}
   begin
    line(px,py+6,px+2,py);line(px+2,py+6,px+4,py);
   end;
if (retezec='ñ') then {cr_tm}
   begin
    line(px+4,py,px+4,py+6);line(px,py+1,px,py+3);line(px+1,py,px+2,py);
    line(px+1,py+4,px+2,py+4);line(px+5,py,px+5,py);line(px+5,py+2,px+5,py+3);
   end;
if (retezec='ó') then
   begin
    line(px,py+1,px,py+1);line(px,py+4,px,py+4);line(px+2,py,px+2,py+4);
    line(px+3,py,px+3,py);line(px+3,py+2,px+3,py+2);line(px+3,py+4,px+3,py+4);
    line(px+5,py,px+5,py+6);
   end;
if (retezec='ò') then
   begin
    line(px+1,py+1,px+1,py+4);line(px+3,py+1,px+3,py+4);line(px+5,py+1,px+5,py+4);
    line(px,py,px,py);line(px,py+2,px,py+2);line(px+2,py,px+4,py);
   end;
if (retezec='ô') then
   begin
    line(px+1,py,px+1,py+4);line(px+3,py,px+3,py+4);line(px+5,py,px+5,py+4);
    line(px+2,py+5,px+2,py+5);
   end;
if (retezec='ö') then
   begin
    line(px,py,px,py);line(px,py+2,px,py+2);line(px,py+4,px,py+4);
    line(px+4,py,px+5,py);line(px+5,py,px+5,py+6);
   end;
if (retezec='õ') then
   begin
    line(px,py,px,py);line(px+2,py,px+2,py+4);line(px+3,py,px+3,py);
    line(px+3,py+2,px+3,py+2);line(px+3,py+4,px+3,py+4);line(px+5,py+1,px+5,py+6);
   end;
if (retezec='ú') then
   begin
    line(px,py,px,py);line(px+1,py+1,px+1,py+4);line(px,py+2,px,py+2);
    line(px+3,py,px+3,py+6);line(px+4,py+1,px+5,py+2);
   end;
if (retezec='ù') then
   begin
    line(px+1,py,px+1,py+4);line(px,py+1,px,py+1);
   end;
if (retezec='†') then {copy}
   begin
    line(px+1,py,px+4,py);line(px,py+1,px,py+5);line(px+5,py+1,px+5,py+5);
    line(px+1,py+6,px+4,py+6);line(px+2,py+2,px+3,py+2);
    line(px+2,py+4,px+3,py+4);line(px+2,py+3,px+2,py+3);
   end;
if (retezec='°') then {ctverecek-obdelnicek}
   begin
    line(px,py,px+4,py);line(px,py+6,px+4,py+6);line(px,py+1,px,py+5);
    line(px+4,py+1,px+4,py+5);
   end;
end;

procedure pis(fx,fy,fcol:word;veta:string);
begin
xv:=5;
delka:=length(veta);
for cykl:= 1 to delka do
 begin
  xv:=xv+6;
  retez:='';
  retez:=copy(veta,cykl,1);
  vypisretezec(fx,fy,fcol,retez);
 end;
end;

begin
end.