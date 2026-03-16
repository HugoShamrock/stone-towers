{$G+}

{^ 286 instructions [ Compiler options ] }

uses lostgfxx,crt,dos,rat;


var f:file;
    buff1:pointer;
    buff2:pointer;{st2}
    ani:byte;{animace}
    pauza,qx,qy:word;
    ch:char;
    buff1s,buff2s:word;

    bitik: byte;
    ppx,ppy:word;

function Exist(FileName: string): Boolean;
var fle: file;
begin
  {$I-}
  Assign(fle, FileName);
  Reset(fle);
  Close(fle);
  {$I+}
  Exist := (IOResult = 0) and
   (FileName <> '');
end;

procedure done;
begin
  freemem(buff1,64000);
  freemem(buff2,64000);
end;

procedure _error(errmsg:string);
begin
 inittext;
 writeln('[!] ',errmsg);writeln;
 done;
 writeln('program halted');
 halt(1);
end;

procedure loadni(co:string;kamx,kamy:word);
begin
  if not exist(co) then _error('Soubor '+co+' nenalezen.');
  {$I-}
  assign(f,co);
  reset(f,1);
  seek(f,800);
  blockread(f,buff1^,64000);
  close(f);
  {$I+}
  if (IOResult <> 0) then _error('Chyba v souboru '+co);
end;

procedure chb;
begin
  loadni('pict000.cel',0,0);

  paint(0,0,buff1);{procedura paint je puvodni put ico, proste vykresli obsah pointru na obrazovku}

  loadni('pict001.cel',0,100);
  paint(0,100,buff1);
  loadni('pict002.cel',0,200);
  paint(0,200,buff1);
  loadni('pict003.cel',0,300);
  paint(0,300,buff1);
end;


procedure init;
begin
  getmem(buff1,64000); {zaloha}
  getmem(buff2,64000); {ob}

  buff1s:=seg(buff1^);
  buff2s:=seg(buff2^);

  init640x480x256;

  if not exist('pict001.cel') then _error('Soubor pict001.cel nenalezen.');
  LoadPal('pict001.cel',32);

  qx:=1;qy:=1;ani:=0;

  chb;

end;




procedure krysa;
var hn:integer;
begin

 initmysak;

  asm
  mov ax,0
  int $33    { mouse ? }
  mov ax,1
  int $33    { Show Mouse }
  mov ax,2
  int $33    { Hide Mouse }
  mov ax,7
  mov cx,0
  mov dx,mxmax
  int $33
  mov ax,8
  mov cx,0
  mov dx,ymax  { Set YMAX for mouse windows }
  int $33
  mov ax,20
  mov cx,newmask
  mov es,newseg
  mov dx,newofs
  int $33      { Active USER Mouse Routine }
  mov ax,$000f
  mov cx,4
  mov dx,4
  int $33
 end;

repeat

if keypressed then
 begin
  ch:=readkey;
  hidemouse;setposition(0,480);
  paint(0,100,buff1);
  showmouse;

 end;




until (ch=#27) or (mb=1);


hidemouse;



  asm
  mov ax,20
  mov cx,oldmask
  mov es,oldseg
  mov dx,oldofs
  int $33   { Restore old Mouse Routine }
 end;

end;

procedure main;
begin
 readln;
 loadni('anim1.cel',0,0);
 paint(0,0,buff1);{procedura paint je puvodni put ico, proste vykresli obsah pointru na obrazovku}
 loadni('anim2.cel',0,0);
 paint(0,100,buff1);
 readln;
 loadni('pict002.cel',0,0); {nahraju pozadi (002 - treti cast obrazku)}
 flip(buff1s,buff2s);       {ulozim si jako pozadi do zalozniho bufru}
 loadni('anim1.cel',0,0);   {nahraju si obr k vyklicovani (do buff1)}
 puttrans(buff1,buff2);     {vykreslim transparentne buff1 na buff2(pozadi)}
 paint(0,200,buff2);        {vykreslim slozeny buff2 na obrazovku(na pozici treti casti obrazku)}
 readln;


end;

procedure tricx;
begin


  readln;

end;

begin

  init;
{  main;}


  krysa;

  {tricx;}

  done;
  inittext;
  writeln('x:',xmax);
  writeln('y:',ymax);
end.