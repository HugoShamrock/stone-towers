program speeddisk;

uses crt,dos;

var f:file;
    ob:pointer;
    cnt,trp:longint;
    y:word;
    h,m,s,s0:word;
    oh,om,os,os0:word;


procedure loadni(co:string);
begin
 gettime(oh,om,os,os0);
 assign(f,co);
  reset(f,1);
  repeat
    blockread(f,ob^,64000,y);
    cnt:=cnt+64000;trp:=trp+1;
    gotoxy(1,1);write('            ');
    gotoxy(1,1);write(trp);
    gotoxy(1,2);write('                 ');
    gotoxy(1,2);write(cnt);
  until (eof(f)) or (cnt>9000000);
  close(f);
 gettime(h,m,s,s0);
end;


begin
clrscr;

writeln('>');

readln;

getmem(ob,64000);

loadni('file.big');

writeln;writeln('<');
writeln('h:',h-oh,' m:',m-om,' s:',s-os,' s0:',s0-os0);
readln;

end.
