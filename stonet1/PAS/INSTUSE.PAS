program xxx;

uses crt,dos,instaluj;

var  st:string;

BEGIN
writeln;
i_informace;
writeln('cestaEXE:',aktualni_cestaEXE);
writeln('FD:',pocet_FD,' HD:',pocet_HD);
writeln('FD:',nazev_FD,' HD:',nazev_HD);
writeln('Aktualni HD:',aktualni_HD);
writeln('Typ procesoru:',typ_procesoru);
write('cesta:',aktualni_cesta);
readln;
END.