program brighte;

uses dos,crt,graph,vga256,brighten;

var x,y,op:word;

procedure LoadPicture(Name:String;X,Y,X2,Y2,Size:LongInt);
var E,OldX,OldY:Word;D:Byte;
    Fil:File of Byte;
begin
  D:=1;OldX:=X;OldY:=Y;
  Assign(Fil,Name);
  {$I-} Reset(Fil); {$I+}
  If IOResult>0 then begin closegraph;WriteLn(' Soubor ',Name,' nenalezen!');Halt(1);end;
  Seek(Fil,Size);
  Repeat
    Read(Fil,D);
     putpixel(x,y,d);
     D:=D+1;X:=X+1;
     If X=X2 then begin Y:=Y+1;X:=OldX;end;
  Until (Y=Y2) or (Eof(Fil));
  Close(Fil);
end;

Procedure Pal(Col,R,G,B : Byte);
Begin
   asm
      mov    dx,3c8h
      mov    al,[col]
      out    dx,al
      inc    dx
      mov    al,[r]
      out    dx,al
      mov    al,[g]
      out    dx,al
      mov    al,[b]
      out    dx,al
   end;
End;


procedure LoadPal (FileName : string);
type DACType = array [0..250] of record
                                R, G, B : byte;
                                end;
var Dac:dactype;
    Fil : file of DACType;
    I : integer;
BEGIN
  assign (Fil, FileName);
  reset (Fil);
  read (Fil, DAC);
  close (Fil);
  for i:=0 to 255 do
   begin
    Pal(i,Dac[i].R,Dac[i].G,Dac[i].B);
   end;
end;





BEGIN
initvga256(vga256modes(0));
loadpal('stgame.col');
loadpicture('stgame.pic',0,0,320,199,800);
op:=0;
for y:=0 to 15 do
 begin
  for x:=0 to 15 do
   begin
   op:=op+1;
    setcolor(op-1);
    line(x*3,y*3,x*3+3,y*3);line(x*3,y*3+1,x*3+3,y*3+1);line(x*3,y*3+2,x*3+3,y*3+2);
   end;
 end;
readln;
for y:=1 to 15 do
 begin
  brightbox(10,10,20,40);
  brightelipse(20,60,20,10);
 end;

repeat until keypressed;
closegraph;
END.









