{$G+}

{^ 286 instructions [ Compiler options ] }

uses lostgfxx,crt,dos;



var f:file;
    buff1:pointer;
    buff2:pointer;{st2}
    ani:byte;{animace}
    y,pauza,qx,qy:word;
    ch:char;
    buff1s,buff2s:word;



procedure loadni(co:string;kamx,kamy:word);
begin
  assign(f,co);
  reset(f,1);
  seek(f,800);
  blockread(f,buff1^,64000,y);
  close(f);
  delay(pauza);
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

  LoadPal('pict001.cel',32);

  qx:=1;qy:=1;ani:=0;

  chb;



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

procedure done;
begin
  freemem(buff1,64000);
  freemem(buff2,64000);
  inittext;
end;

begin
  init;

  main;
  done;
end.