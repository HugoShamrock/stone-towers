procedure init_begin;

begin
  {begin of 3ddeska}
  fn:='c:\gameska2\textures\3ddeska';
  {in_to ems}
  initgif(1,1,0,0,0,320,50,0,0);
  initgif(1,2,0,0,50,320,50,0,50);
  initgif(1,3,0,0,100,320,50,0,100);
  initgif(1,4,0,0,150,320,50,0,150);
  {in_to buffer}
  gifshow(1,1,0,0,0,320,50,0,0);
  gifshow(1,2,0,0,50,320,50,0,50);
  gifshow(1,3,0,0,100,320,50,0,100);
  gifshow(1,4,0,0,150,320,50,0,150);

  page(5);move(mem[bufferseg:0],mem[address:0],16000);
  page(6);move(mem[bufferseg:16000],mem[address:0],16000);
  page(7);move(mem[bufferseg:32000],mem[address:0],16000);
  page(8);move(mem[bufferseg:48000],mem[address:0],16000);
  clearbuffer;
  page(5);move(mem[address:0],mem[bufferseg:0],16000);
  page(6);move(mem[address:0],mem[bufferseg:16000],16000);
  page(7);move(mem[address:0],mem[bufferseg:32000],16000);
  page(8);move(mem[address:0],mem[bufferseg:48000],16000);
  putbuffer;
end;

