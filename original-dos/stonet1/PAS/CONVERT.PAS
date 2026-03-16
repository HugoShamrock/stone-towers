program Convert;
uses DFLI,Sandra,Crt;
var Fil,Fil2:File;
    A,B:Word;
    MinX,MinY,MaxX,MaxY:Word;
    Bod:Word;
    C:String;
    X,Y,Y2:Word;
    Buf:Array[1..320] of Byte;
    Name:String;
    Key:charac;
    Filer:File;
begin
  FileName:='c:\bp\strobo\strobo.fli';
  asm mov ax,13h; int 10h; end;
  Speed:=-1;Counter:=1;
  GetMem(Buffer,BUFFERSIZE);
  Assign(inputfile,'c:\bp\strobo\strobo.fli');
  Reset(inputfile,1);
  Seek(inputfile,0);
  Cls;
  if IOResult<>0 then
  begin
    GraphDone;WriteLn('Error! Can not open File ''',FileName,'''.');Halt(0);
  end;
  BlockRead(InputFile,Header,128);
  Frames:=Header[6]+Header[7]*256;
  If Speed=-1 then Speed:=(Header[16]+Integer(Header[17])*256)*CLOCK_SCALE;
  BlockRead(InputFile,Header,16);
  FrameSize:=Header[0]+256*(LongInt(Header[1])+256*(LongInt(Header[2])+256*LongInt(Header[3])))-16;
  SecondPos:=128+16+FrameSize;
  Chunks:=Header[6]+Header[7]*256;
  BlockRead(InputFile,Buffer^,FrameSize);
  TreatFrame(Buffer,Chunks);
  FrameNumber:=1;
  Repeat
    If Framenumber=1 then begin Name:='strobo1.gra';X:=320;Y:=200;end;
    If Framenumber=2 then begin Name:='strobo2.gra';X:=320;Y:=200;end;
    If Framenumber=3 then begin Name:='strobo3.gra';X:=320;Y:=200;end;
    If Framenumber=4 then begin Name:='strobo4.gra';X:=320;Y:=200;end;
    If Framenumber=5 then begin Name:='strobo5.gra';X:=320;Y:=200;end;
{    SavePicture(Name,0,0,X,Y);}
    Assign(Fil,Name);
    ReWrite(Fil,1);
      for Y2:=1 to Y do BlockWrite(Fil,Mem[$A000:Y2*320-320],X);
    Close(Fil);

    Key:=Inkey;
    BlockRead(InputFile,Header,16);
    FrameSize:=Header[0]+256*(LongInt(Header[1])+256*(LongInt(Header[2])+256*LongInt(Header[3])))-16;  { size of frame }
    If FrameSize<>0 then
    begin
      Chunks:=Header[6]+Header[7]*256;
      BlockRead(InputFile,Buffer^,FrameSize);
      TreatFrame(Buffer,Chunks);
    end;
    Inc(FrameNumber);
  Until (FrameNumber>Frames) or (Key=#27);
  Close(InputFile);
  FreeMem(Buffer,BUFFERSIZE);
  asm mov ax,3h; int 10h; end;
end.
end.



