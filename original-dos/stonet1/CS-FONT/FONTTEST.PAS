{ fonttest.pas - jednoduch˜ test font– }

uses crt,graph;

const
     KONEC=chr(27);
     ZVETSI='+';
     ZMENSI='-';

procedure testgrapherror;
{ zjist¡, do¨lo-li k chybˆ grafick‚ho driveru }
var  i : integer;
begin
  i:=graphresult;
  if i<>grOk then begin
    closegraph;  { je nutn‚ ukon‡it pr ci v grafick‚m m¢du }
    writeln('Chyba grafick‚ho driveru ',grapherrormsg(i));
    halt(0);
  end
end;

{ hlavn¡ program }

var
  pathtodriver : string;
  argument,gd,i,gm,font,size : integer;

label 001;

begin
  pathtodriver:='c:\\tc';
  argument:=1;
  gd:=DETECT;
  size:=4;

  writeln('FontTest ver 1.0 (c) OCSoftware');
  writeln('         Created using Borland''s Turbo C');

  if copy(paramstr(1),1,1)='/' then begin  { je zad n adres © s BGI driverem }
    pathtodriver:=copy(paramstr(1),2,length(paramstr(1))-1);
       { pomoc¡ '+1' se p©esko‡¡ lom¡tko }
    inc(argument);           { parametr se po zpracov n¡ p©esko‡¡ }
  end;
  if paramcount<=argument then begin  { je-li p©¡li¨ m lo parametr– }
    writeln('Vol n¡ :   FONTTEST [/<adres © s BGI drivery>] <jm‚no souboru> <text>');
    writeln('Ovl d n¡ : |+|      zvˆt¨it text');
    writeln('           |-|      zmen¨it text');
    writeln('           |Esc|    konec');
  end else begin
    initgraph(gd,gm,pathtodriver);
    testgrapherror;
    font:=installuserfont(paramstr(argument)); { instalace po‘adovan‚ho fontu }
    testgrapherror;
    settextstyle(font,0,USERCHARSIZE); { ... a jeho nastaven¡ }
    while true do begin
      setusercharsize(size,4,size,4);  { nastaven¡ velikosti textu }
      testgrapherror;
      cleardevice;
      for i:=argument to paramcount do begin  { v¨echny zbyl‚ parametry ... }
        outtext(paramstr(i));            { ... se vyp¡¨¡ }
        outtext(' ');
      end;
001 :
      case readkey of
        KONEC : begin
          closegraph;
          testgrapherror;
          halt(0);
        end;
        ZVETSI :
          inc(size);
        ZMENSI :
          if size>1 then dec(size);
        else
          goto 001;
      end
    end
  end
end.

{ konec souboru fonttest.c }
