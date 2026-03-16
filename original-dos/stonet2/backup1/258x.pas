uses crt,dos,ems,lostgfxx;

const pages=64;
      buffs=5;

type  pr=0..pages;
      ri=0..buffs;
      xr=0..320;
      yr=0..200;
      sr=0..5; {0nic, 1sever, 2vychod, 3jih, 4zapad, 5nic}

var {main}
    x,xtmp:xr;
    y,ytmp:yr;
    s:sr;
    rk:char;
    {ems}
    address,error,free,handle,total:word;
    {buffers}
    zbuffer:array[0..buffs] of pointer;
    buffseg:array[0..buffs] of word;
    {ani}
    ani:byte;

procedure page(number:word);
begin
  error:=mappages(handle,number,0);
  checkerror(error);
end;

procedure inpage(p:pr;i:ri);
begin
  p:=p*4+1;
  page(p+0);move(mem[buffseg[i]:    0],mem[address:0],16000);
  page(p+1);move(mem[buffseg[i]:16000],mem[address:0],16000);
  page(p+2);move(mem[buffseg[i]:32000],mem[address:0],16000);
  page(p+3);move(mem[buffseg[i]:48000],mem[address:0],16000);
end;

procedure inbuff(p:pr;i:ri);
begin
  p:=p*4+1;
  page(p+0);move(mem[address:0],mem[buffseg[i]:    0],16000);
  page(p+1);move(mem[address:0],mem[buffseg[i]:16000],16000);
  page(p+2);move(mem[address:0],mem[buffseg[i]:32000],16000);
  page(p+3);move(mem[address:0],mem[buffseg[i]:48000],16000);
end;

procedure naspalCEL(jm:string);
var f : file;
    kolik  : integer;
    paleta:array[0..767] of byte;
    segm:word;
    ofsm:word;
begin
  assign(f,jm);
  reset(f,1);
  seek(f,32);
  blockread(f,paleta,768,kolik);
  segm:=seg(paleta);
  ofsm:=ofs(paleta);
  asm
    mov ax,1012h
    mov bx,0h
    mov cx,100h
    mov es, segm
    mov dx, ofsm
    int 10h
  end;
  close(f);
end;

procedure sGetIco(xx,yy,vx,vy,r:word;dst:pointer); {universalni}
label L1,L2,L3,L4,L5,L6;
var a,b:word;
begin
  a:=seg(dst^);
  b:=ofs(dst^);
  asm
    push ds
    push es
    mov di,b
    mov ax,0a000h
    mov ds,ax
    mov ax,a
    mov es,ax
    mov ax,yy
    mov bx,r
    mul bx
    add ax,xx
    jnc L1
    inc dx
  L1:
    { Banka }
    push ax
    push bx
    mov ax, 4f05h
    mov bx, 0001h
    int 10h
    pop bx
    pop ax
    { Banka }
    mov cx,vy
  L2:
    push cx
    mov si,ax
    mov cx,vx
    rep movsb
    add ax,r
    jnc L3
    { Banka+}
    inc dx
    pusha
    mov ax, 4f05h
    mov bx, 0001h
    int 10h
    popa
    { Banka+}
  L3:
    pop cx
    loop L2
    pop es
    pop ds
  end;
end;

procedure loadni(p:pr;fn:pathstr);
{predelat aby to slo z disku primo do ems, vynechat zbuffur[0]}
var f:file;
begin
  assign(f,fn);
  reset(f,1);
  seek(f,800);
  blockread(f,zbuffer[0]^,64000);
  close(f);
  inpage(p,0);
end;

procedure getit(co,i:ri);
begin
  sgetico(0,(co-1)*100,640,100,640,zbuffer[i]);
end;

procedure view(p1,p2,p3,p4:pr);
begin
  if p1<>0 then inbuff(p1,1);{nerovnosti na zk}
  if p2<>0 then inbuff(p2,2);
  if p3<>0 then inbuff(p3,3);
  if p4<>0 then inbuff(p4,4);
  if p1<>0 then putico(0,  0,640,100,640,zbuffer[1]);
  if p2<>0 then putico(0,100,640,100,640,zbuffer[2]);
  if p3<>0 then putico(0,200,640,100,640,zbuffer[3]);
  if p4<>0 then putico(0,300,640,100,640,zbuffer[4]);
end;

procedure keys72;
begin
  view(1,2,3,4);
  case s of
    1:ytmp:=ytmp-1;
    2:xtmp:=xtmp+1;
    3:ytmp:=ytmp+1;
    4:xtmp:=xtmp-1;
  end;
end;

procedure keys75;
begin
  view(2,3,4,1);
  case s of
    1:xtmp:=xtmp-1;
    2:ytmp:=ytmp-1;
    3:xtmp:=xtmp+1;
    4:ytmp:=ytmp+1;
  end;
end;

procedure keys77;
begin
  view(3,4,1,2);
  case s of
    1:xtmp:=xtmp+1;
    2:ytmp:=ytmp+1;
    3:xtmp:=xtmp-1;
    4:ytmp:=ytmp-1;
  end;
end;

procedure keys80;
begin
  view(4,1,2,3);
  case s of
    1:ytmp:=ytmp+1;
    2:xtmp:=xtmp-1;
    3:ytmp:=ytmp-1;
    4:xtmp:=xtmp+1;
  end;
end;

procedure test;
begin
  if s=0 then s:=4;
  if s=5 then s:=1;
  x:=xtmp;
  y:=ytmp;
end;

procedure init;
begin
  {ems}
  if not emsinstalled then emserror('Neni nainstalovan ovladac EMS pameti!');
  error:=getfreepages(total,free);checkerror(error);
  error:=allocatepages(pages,handle);checkerror(error);
  error:=getaddress(address);checkerror(error);
  {buffers}
  getmem(zbuffer[0],64000);buffseg[0]:=seg(zbuffer[0]^);
  getmem(zbuffer[1],64000);buffseg[1]:=seg(zbuffer[1]^);
  getmem(zbuffer[2],64000);buffseg[2]:=seg(zbuffer[2]^);
  getmem(zbuffer[3],64000);buffseg[3]:=seg(zbuffer[3]^);
  getmem(zbuffer[4],64000);buffseg[4]:=seg(zbuffer[4]^);
{  getmem(zbuffer[5],64000);buffseg[4]:=seg(zbuffer[4]^);
  getmem(zbuffer[6],64000);buffseg[4]:=seg(zbuffer[4]^);
  getmem(zbuffer[7],64000);buffseg[4]:=seg(zbuffer[4]^);}
  {vga}
  Init640x480x256;
  {textures}
  loadni(1,'ut1.cel');
  loadni(2,'ut2.cel');
  loadni(3,'ut3.cel');
  loadni(4,'ut4.cel');
  {paleta}
  naspalCEL('ut2.cel');
  ani:=1;
  view(2,0,0,0);
  naspalCEL('ut2.cel');
  sgetico(0,0,640,100,640,zbuffer[0]);
  putico(0,100,640,100,640,zbuffer[0]);
{  getit(1,0);}
{  readkey;
  putico(0,100,640,100,640,zbuffer[0]);}
  {kurzor}
  x:=0;
  y:=0;
  s:=2;
end;

procedure main;
begin
  repeat
    rk:=readkey;
    if (rk=#71) or (rk=#72) or (rk=#73) or
       (rk=#75) or (rk=#77) or (rk=#80) then
    begin
      xtmp:=x;
      ytmp:=y;
      case rk of
        #71: s:=s-1;   #72: keys72;   #73: s:=s+1;
        #75: keys75;   #77: keys77;   #80: keys80;
      end;
      test;
      {schovej_mysku;}
      {view(1,2,3,4);}
      {ukaz_mysku;}
    end;
  until rk=#27;
end;

procedure done;
begin
  {vga}
  InitText;
  {buffer}
  freemem(zbuffer[0],64000);
  freemem(zbuffer[1],64000);
  freemem(zbuffer[2],64000);
  freemem(zbuffer[3],64000);
  freemem(zbuffer[4],64000);
  {ems}
  error:=deallocatepages(handle);checkerror(error);
end;

begin
  init;
  main;
  done;
end.

