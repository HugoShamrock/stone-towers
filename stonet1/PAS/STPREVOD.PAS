{WIZ}
Unit stprevod;
{$R+}

INTERFACE

procedure prevod(zsoust,vsoust:byte;zadani:string;var vysledek:string);
{zsoust-z jake soustavy;vsoust-do jake soustavy;zadani-prevest [zadani] }
{vysledek-vraci se [vysledek]    (typy soustav:2,10,16)                 }

IMPLEMENTATION
uses crt;

const maxsoust=16;
      digits:string[maxsoust]='0123456789ABCDEF';
var volba:char;
    tmpkey:char;
    poprev:string;

function mocnina(cislo:longint;mocn:longint):longint;
var vysl:longint;
    ckl:longint;
begin
if mocn<0 then
 begin
  writeln(#7'chyba pri umocnovani');
  mocnina:=-1;
 end
 else begin
  vysl:=1;
  for ckl:= 0 to mocn-1 do vysl:=vysl*cislo;
  mocnina:=vysl
 end;
end;

function z10soustavy(cislo:longint;zaklad:byte):string;
const ranbuf=255;
var index,zb,cele:word;
    buffer,pombuf:array[0..ranbuf] of char;
    nula:boolean;
    bufftostr:string;
begin
if (zaklad>16) or (zaklad<=0) then
 begin
  write('soustava mimo rozsah');halt(1);
 end;
index:=ranbuf;
nula:=false;
fillchar(buffer,sizeof(buffer),#0);
fillchar(pombuf,sizeof(pombuf),#0);
buffer[0]:=chr(ranbuf);
pombuf[0]:=chr(ranbuf);
while not nula do
 begin
  cele:=cislo div zaklad;
  zb:=cislo mod zaklad;
  buffer[index]:=digits[zb+1];
  if cele=0 then nula:=true
  else begin
   cislo:=trunc(cislo/zaklad);
   index:=index-1;
  end;
 end;
move(ptr(seg(buffer),ofs(buffer)+index)^,ptr(seg(pombuf),ofs(pombuf)+1)^,ranbuf+1-index);
pombuf[0]:=chr(ranbuf+1-index);
move(pombuf,bufftostr,sizeof(pombuf));
z10soustavy:=bufftostr;
end;

function do10soustavy(cislo:string;zaklad:byte):longint;
var index,pomind,orglen,rad:byte;
    pomstr:string;
    descis:longint;
begin
if (zaklad>16) or (zaklad<=0) then
 begin
  write('soustava mimo rozsah');halt(1);
 end;
for index:=1 to length(cislo) do
cislo[index]:=upcase(cislo[index]);
orglen:=length(cislo);
rad:=0;
descis:=0;
pomstr:='';
for index:=0 to orglen-1 do
 begin
  pomstr:=copy(cislo,orglen-index,1);
  pomind:=pos(pomstr,digits);
  if pomind>0 then
   begin
    descis:=descis+(pomind-1)*mocnina(zaklad,rad);
    rad:=rad+1;
   end
   else begin
    write('nepripustne znaky v zadani');halt(1);
   end;
 end;
do10soustavy:=descis;
end;

function zoldtonew(cislo:string;old,new:byte):string;
begin
zoldtonew:=z10soustavy(do10soustavy(cislo,old),new);
end;

procedure prevod(zsoust,vsoust:byte;zadani:string;var vysledek:string);
begin
poprev:=zoldtonew(zadani,zsoust,vsoust);
vysledek:=poprev;
end;

BEGIN
END.
