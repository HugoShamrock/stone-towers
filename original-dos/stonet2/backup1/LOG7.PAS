uses lostgfxx,crt,dos;

var f:file;
    buff1:pointer;
    buff2:pointer;{st2}
    ani:byte;{animace}
    y,pauza,qx,qy:word;
    ch:char;

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

procedure loadni(co:string;kamx,kamy:word);
begin
  assign(f,co);
  reset(f,1);{proc 1}
  seek(f,800);
  blockread(f,buff1^,64000,y);{proc y}
  close(f);
  putico(kamx,kamy,320,200,640,buff1);{proc 255}
  {delay(pauza);}
end;

procedure chb;
begin
  loadni('chb1.cel',0,0);
  loadni('chb2.cel',320,0);
  loadni('chb3.cel',0,200);
  loadni('chb4.cel',320,200);
end;

procedure chf;
begin
  loadni('chf11.cel',0,0);
  loadni('chf12.cel',320,0);
  loadni('chf13.cel',0,200);
  loadni('chf14.cel',320,200);
  delay(pauza);
  loadni('chf21.cel',0,0);
  loadni('chf22.cel',320,0);
  loadni('chf23.cel',0,200);
  loadni('chf24.cel',320,200);
end;

procedure chbf;
begin
  loadni('chf11.cel',0,0);
  loadni('chf12.cel',320,0);
  loadni('chf13.cel',0,200);
  loadni('chf14.cel',320,200);
  delay(pauza);
  chb;
end;

procedure chl;
begin
  loadni('chl1.cel',0,0);
  loadni('chl2.cel',320,0);
  loadni('chl3.cel',0,200);
  loadni('chl4.cel',320,200);
end;

procedure chr;
begin
  loadni('chr1.cel',0,0);
  loadni('chr2.cel',320,0);
  loadni('chr3.cel',0,200);
  loadni('chr4.cel',320,200);
end;

procedure animace;
var sr:string;
begin
  ani:=ani+1;
  if ani>7 then ani:=1;
  str(ani,sr);
  assign(f,'cha'+sr+'.cel');
  reset(f,1);
  seek(f,800);
  blockread(f,buff1^,64000,y);
  close(f);
  putico(320,200,320,200,640,buff2);
  putico(320,200,320,200,640,buff1);
  pockej;
end;

procedure getit;
begin
  sgetico(320,200,320,200,640,buff2);
end;

procedure init;
begin
  getmem(buff1,64000); {zaloha}
  getmem(buff2,64000); {ob}
  init640x480x256;
  naspal('ch.col');
  qx:=1;qy:=1;ani:=0;
  loadni('pan1.cel',0,400);
  loadni('pan2.cel',320,400);

  chb;
  sgetico(320,200,320,200,640,buff2);
  inittext;
  init640x480x256;
  naspal('ch.col');
  putico(320,200,320,200,640,buff2);

end;

procedure main;
begin
  repeat
    if keypressed then ch:=readkey;
    if ch=#0 then
    begin
      ch:=readkey;
      if (ch=#75)and(qx=1)and(qy=1) then
      begin qx:=0;chl;getit;end;
      if (ch=#75)and(qx=2)and(qy=1) then
      begin qx:=1;chb;getit;end;
      if (ch=#77)and(qx=1)and(qy=1) then
      begin qx:=2;chr;getit;end;
      if (ch=#77)and(qx=0)and(qy=1) then
      begin qx:=1;chb;getit;end;
      if (ch=#72)and(qy=1)and(qx=1) then
      begin qy:=0;chf;getit;end;
      if (ch=#72)and(qy=1)and(qx=0) then
      begin qy:=0;qx:=1;chb;delay(pauza);chf;getit;end;
      if (ch=#72)and(qy=1)and(qx=2) then
      begin qy:=0;qx:=1;chb;delay(pauza);chf;getit;end;
      if (ch=#80)and(qy=0)and(qx=1) then
      begin qy:=1;chbf;getit;end;
    end;
    animace;
  until ch=#27;
end;

procedure done;
begin
  freemem(buff1,64000);
  freemem(buff2,64000);
  inittext;
end;

begin
  init;
  readkey;
  main;
  done;
end.