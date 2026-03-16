uses crt,dos,ems,lostgfxx;

const pages=64;

type  pr=0..pages;
      xr=0..320;
      yr=0..200;
      sr=0..5; {0nic, 1sever, 2vychod, 3jih, 4zapad, 5nic}
      ri=0..4; {buffery 0tmp 1,2,3,4screen}

var {main}
    x,xtmp:xr;
    y,ytmp:yr;
    s:sr;
    rk:char;
    {ems}
    address,error,free,handle,total:word;
    {buffers}
    zbuffer:array[0..4] of pointer;
    buffseg:array[0..4] of word;

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

procedure view(p1,p2,p3,p4:pr);
begin
  inbuff(p1,1);
  inbuff(p2,2);
  inbuff(p3,3);
  inbuff(p3,4);
  putico(0,  0,640,100,640,zbuffer[1]);
  putico(0,100,640,100,640,zbuffer[2]);
  putico(0,200,640,100,640,zbuffer[3]);
  putico(0,300,640,100,640,zbuffer[4]);
end;

procedure keys72;
begin
  case s of
    1:ytmp:=ytmp-1;
    2:xtmp:=xtmp+1;
    3:ytmp:=ytmp+1;
    4:xtmp:=xtmp-1;
  end;
end;

procedure keys75;
begin
  case s of
    1:xtmp:=xtmp-1;
    2:ytmp:=ytmp-1;
    3:xtmp:=xtmp+1;
    4:ytmp:=ytmp+1;
  end;
end;

procedure keys77;
begin
  case s of
    1:xtmp:=xtmp+1;
    2:ytmp:=ytmp+1;
    3:xtmp:=xtmp-1;
    4:ytmp:=ytmp-1;
  end;
end;

procedure keys80;
begin
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
  {vga}
  Init640x480x256;
  {textures}

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
      view(1,2,3,4);
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

