{$G+}

{^ 286 instructions [ Compiler options ] }

uses lostgfxx,crt,dos;



var f:file;
    buff1:pointer;
    buff2:pointer;{st2}
    ani:byte;{animace}
    pauza,qx,qy:word;
    ch:char;
    buff1s,buff2s:word;

    oldx,oldy,x,y,z:word;
    oldar,ar:array[1..400]of byte;
    P:pointer;
    oldcitx,oldcity:word;


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
begin
  assign(f,'mys.cel');
  reset(f,1);
  seek(f,800);
  blockread(f,ar,400);
  for x:=1 to 400 do if ar[x]=15 then ar[x]:=0;

  {************** je mys SVGA ? **************}
  asm
    mov ax,29h
    mov cx,101h
    int 33h
  end;
{************* ne - donut ji   :-) *********}
{  if mem[5272:65535]=0 then}
  begin
    asm
      mov ax,1bh
      int 33h
      mov oldcitx,bx
      mov oldcity,cx

      mov ax,1ah
      mov bx,100
      mov cx,100
      int 33h
      mov ax,7h
      mov cx,0
      mov dx,5119
      int 33h
      mov ax,8h
      mov cx,0
      mov dx,3839
      int 33h
    end;
    repeat
      z:=0;
      oldx:=x;
      oldy:=y;
      asm
        mov ax,03h
        int 33h
        mov x,cx
        mov y,dx
        mov z,bx
      end;
      if (oldx<>x) or (oldy<>y) then
      begin
        putico(oldx div 8 , oldy div 8 ,20,20,640,@oldar);
        getico(x div 8 , y div 8 ,20,20,640,@oldar);
        puticok(x div 8 , y div 8 ,20,20,640,@ar,0);
      end;
    until z<>0;
    asm
      mov ax,1ah
      mov bx,oldcitx
      mov cx,oldcity
      int 33h
    end;
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

 krysa;

end;

begin
  init;
  main;
  done;
  inittext;
end.