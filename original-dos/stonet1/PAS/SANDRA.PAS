{ SANDRA GRAPHICS SYSTEM }
{      (c)  1993 A.D     }
{      full  version     }
unit Sandra;
interface
uses Crt,Dos;
type xxxxx  = Array[1..64000] of Byte;
     Charac = String[100];
     Picture= ^xxxxx;
     Prom   = record B:Array[1..64000] of Byte; end;
const GetMaxX = 319;
      GetMaxY = 199;
var Pamet   : Array[1..320] of Byte;
    Line    : Array[1..320] of Byte;
    Pro     : ^Prom;
    OldY,A,C: Word;
    Col:Byte;
procedure Eye;
procedure LP(Name:String;X,Y,A,B:Word;Skok:LongInt);
procedure GraphInit;
procedure WriXY(X,Y:Byte;Text:String);
procedure About_Sandra;
procedure LText(Path,Slovo:String;X,Y:Byte);
procedure SetRGBColor(Register,Red,Green,Blue:Byte);
procedure Pixel(X,Y:Word;Color:Byte);
function  GetPixel(X,Y:word):Byte;
procedure Bar(X,Y,X2,Y2:word);
procedure SetColor(Color:Byte);
procedure Circle(Xc,Yc:Integer; Radious:Word);
procedure Linka(X,Y,X2,Y2:Integer);
procedure GetImage(var a:Picture;X:Word);{do pameti}
procedure PutImage(a:Picture;X:Word);    {z pameti}
procedure SavePicture(Name:String;X,Y,X2,Y2:Word);
procedure LPict(Name:String;X,Y,X2,Y2,P,Q,Size:LongInt);
procedure FastLP(Name:String;X,Y,X2,Y2,P,Q,Size:LongInt);
procedure AAColor(Jmeno:String;Od:LongInt);
procedure AAPalette(Jmeno:String;Skok:LongInt);
procedure Cls;
procedure AAPicture(Jmeno:String);
procedure Paused;
procedure GraphDone;
procedure TestFile(Name:String;Size:LongInt);
procedure FileTest(Name:String;Pos:LongInt;Typ:Byte);
procedure LPMem(Name:String;X,Y,A,B:Word;Adress:Word;Skok:LongInt);
procedure LPPix(Name:String;X,Y,A,B:Word;Skok:LongInt);
procedure InfoSandra;
procedure GetBar(X,Y,X2,Y2:Word;Skok:Word);
procedure PutBar(X,Y,X2,Y2:Word;Skok:Word);
procedure NewProm;
procedure DelProm;
procedure PG256(Mode:Byte);
procedure LPCompiler(Name:String;Skok:LongInt;Pocet2:Word);
procedure LPPCX(Name:String;Skok:LongInt);
function InKey:Charac;
implementation
var Temp:array[0..319] of Byte;
procedure SetPaletteRegister(Register,Value:byte);
begin asm mov ax,1000h; mov bh,Value; mov bl,Register;
      int 10h;end;
end;

procedure LPPix(Name:String;X,Y,A,B:Word;Skok:LongInt);
var Soubor : File;
    Pocet,
    Delka  : Word;
begin
  Assign(Soubor,Name);Reset(Soubor,1);Seek(Soubor,Skok);
  For Delka:=0 to Y do begin 
    BlockRead(Soubor,Pamet,X);
    For Pocet:=0 to X do begin 
    If Pamet[Pocet]<>0 then Mem[$A000:(Pocet+((Delka+(B))*320)-320-1+A)*2]:=Pamet[Pocet];end;
  end;
  Close(Soubor);
end;
procedure SetRGBColor(Register,Red,Green,Blue:Byte);
begin
     asm mov ax,1010h; mov bl,Register; Mov bh,0;Mov dh,Red;
         mov ch,Green; mov cl,Blue; int 10h; end;
end;

procedure PG256(Mode:Byte);
var Reg : Registers;
begin
  reg.ah:=0;
  reg.al:=Mode;
  intr($10,reg);
end;
procedure GraphInit;
begin
  PG256($13);
end;

procedure Pixel(X,Y:Word;Color:Byte);
var OffSet:Word;
begin If (X<0) or (X>319) or (Y<0) or (Y>199) then Exit;
Offset:= (Y shl 2+y) shl 6+X;
Mem[$A000:Offset]:=Color;
end;


function GetPixel(X,Y:Word):byte;
var Offset:Word;
begin
  Offset:=(Y shl 2+Y) shl 6+X;
  GetPixel:=Mem[$A000:Offset];
end;


procedure Bar(X,Y,X2,Y2:word);
var I,J:Word;
begin
  if (X<0) or (X>319) or (Y<0) or (Y>199)
  or (X2<0) or (X2>319) or (Y2<0) or (Y2>199) then exit;
  FillChar(Temp,SizeOf(Temp),Col);
  I:=X2-X+1;
  For J:=Y to Y2 do Move(Temp,Mem[$A000:0+X+(J shl 2 + J) shl 6],I);
end;


procedure SetColor(Color:Byte);begin Col:=Color;end;

procedure Swap(var A,B:Integer);var P:Integer;begin P:=A;A:=B;B:=P;end;

function Sign(X:Integer):Integer;
begin
  if X<0 then sign:=-1
         else Sign:= 1;
end;

procedure Circle(Xc,Yc:Integer; Radious:Word);
var X,Y,D: Integer;
begin
  X:=0;  Y:=Radious;D:= 2*(1-Radious);
  while Y>X do begin
    Pixel(xc+x,yc+y,Col);
    Pixel(xc+x,yc-y,Col);
    Pixel(xc-x,yc+y,Col);
    Pixel(xc-x,yc-y,Col);
    Pixel(xc+y,yc+x,Col);
    Pixel(xc+y,yc-x,Col);
    Pixel(xc-y,yc+x,Col);
    Pixel(xc-y,yc-x,Col);
    If D+Y>0 then begin
      Dec(Y);
      D:=D-2*y+1;
  end;
  If X>D then begin Inc(X);D:=D+2*X+1;end;
end;
end;


procedure Linka(X,Y,X2,Y2:integer);
var I,Steps,Sx,Sy,Dx,Dy,E:Integer;
    Steep:Boolean;
begin
  Dx:= abs(X2-X); Sx:= sign(X2-X);
  DY:= abs(Y2-Y); Sy:= sign(Y2-Y);
  Steep:=(Dy > Dx);
  If Steep then begin
    swap(X,Y); swap(Dx,Dy);swap(Sx,Sy);end;
  E:=2*Dy-Dx;
  For I:=1 to Dx do begin
                 If Steep then Pixel(Y,X,Col)
                          else Pixel(X,y,Col);
                 While E >= 0 do begin
                       Y:=Y+Sy;
                       E:=E-2*Dx;
                 end;
                 X:=X+Sx;
                 E:=E+2*dy;
                 end;
                 Pixel(X2,Y2,Col);
  end;


procedure GetImage(var A:Picture; X:Word);
begin
  New(A);
  Move(Mem[$A000:$0000],A^,X);
end;
procedure PutImage(A:Picture;X:Word);
begin
  Move(A^,Mem[$A000:$0000],X);
  Dispose(A);
end;

procedure SavePicture(Name:String;X,Y,X2,Y2:Word);
var OldX:Word;Fil:File of Byte;D:Byte;
begin
  D:=1;OldX:=X;Assign(Fil,Name);
               ReWrite(Fil);
                 Repeat
                   D:=GetPixel(X,Y);
                   Write(Fil,D);
                   X:=X+1;D:=D+1;
                   If X=X2 then begin Y:=Y+1;X:=OldX;end;
                 Until Y=Y2;
  Close(Fil);
end;

procedure LPict(Name:String;X,Y,X2,Y2,P,Q,Size:LongInt);
var E,OldX,OldY:Word;D:Byte;
    Fil:File of Byte;
begin
  D:=1;OldX:=X;OldY:=Y;
  Assign(Fil,Name);
  {$I-} Reset(Fil); {$I+}
  If IOResult>0 then begin GraphDone;WriteLn(' File ',Name,' not found!');Halt(1);end;
  Seek(Fil,Size);
  Repeat
    Read(Fil,D);
    If D>0 then Pixel(X+P,Y+Q,D);
    D:=D+1;X:=X+1;
    If X=X2 then begin Y:=Y+1;X:=OldX;end;
  Until Y=Y2;
  Close(Fil);
end;

procedure FastLP(Name:String;X,Y,X2,Y2,P,Q,Size:LongInt);
var Soubor1:File;Velikost:Word;Pamet:Array[1..640] of Byte;
    Bajty:Word;OldX:Word;Pocet:Word;
begin
  Velikost:=X2*Y2;Bajty:=640;OldX:=X;Assign(Soubor1,Name);
  Reset(Soubor1,1);Seek(Soubor1,Size);
  Repeat BlockRead(Soubor1,Pamet,SizeOf(Pamet),Bajty);Pocet:=1;
    Velikost:=Velikost-Bajty;If Velikost<640 then Bajty:=Velikost;
    Repeat If Pamet[Pocet]<>0 then Pixel(X+P,Y+Q,Pamet[Pocet]);X:=X+1;If X=X2 then begin X:=OldX;Y:=Y+1;end;
      Pocet:=Pocet+1;Until (Pocet-1=Bajty) or (Bajty=0);
  Until (Velikost=0) or (Velikost>64000);Close(Soubor1);
end;
procedure GraphDone;
begin
  PG256(3);
end;
function InKey:Charac;
var Znak:char;
    Input:string;
begin If KeyPressed then
      begin Znak:=ReadKey;
            InPut:=Znak;
            If Znak=#0 then
            begin Znak:=ReadKey;
                  Input:=Input+Znak;
            end;
            InKey:=Input;
      end
      else InKey:='';
end;
procedure AAColor(Jmeno:String;Od:LongInt);
type RGB_entry = record R,G,B : byte; end;
     RGB_palette = array [0..255] of RGB_entry;
var A : File of RGB_Palette;B : RGB_Palette;
    R : Registers;
begin
  Assign(A,Jmeno);
  If IOResult<0 then begin GraphDone;WriteLn(' Soubor s paletou poskozen.');Halt(1);end;
  Reset(A);
  Seek(A,Od);
  Read(A,B);
  Close(A);
  begin with R do begin ah := $10;al := $12;bx := 0;cx := 256;dx := ofs(B);es := seg(B);end;
  intr($10, R);end;
end;
procedure AAPalette(Jmeno:String;Skok:LongInt);
var A : File;
    C : Array[1..768] of Byte;
    R : Registers;
begin
  Assign(A,Jmeno);
  {$I-}Reset(A,1);{$I+}
  If IOResult>0 then begin GraphDone;WriteLn(' FILE ',Jmeno,' DAMAGED OR NOT FOUND.');Halt(1);end;
  Seek(A,Skok);
  BlockRead(A,C,768);
  Close(A);
  begin with R do begin ah := $10;al := $12;bx := 0;cx := 256;dx := ofs(C);es := seg(C);end;
  intr($10, R);end;
end;
procedure Cls;begin SetColor(Black);Bar(0,0,GetMaxX,GetMaxY);end;
procedure AAPicture(Jmeno:String);
type Desktop = Array[1..64000] of Byte;
var Soubor2  : File of Desktop;
    Mapa     : ^Desktop;
begin
  New(Mapa);
  Assign(Soubor2,Jmeno);{$I-}Reset(Soubor2);{$I+}
  If IOResult>0 then begin GraphDone;Write('SOUBOR ',Jmeno,' NEEXISTUJE.');Halt(1);end;
  Read(Soubor2,Mapa^);Close(Soubor2);Move(Mapa^,Mem[$A000:$0000],64000);
  Dispose(Mapa);
end;
procedure Paused;
var Key:Charac;
begin
  Repeat
    Key:=InKey;
  Until (Key=#27) or (Key=#13) or (Key=' ');
end;
procedure TestFile(Name:String;Size:LongInt);
var Soubor:File of Byte;
    Velikost:LongInt;
begin
  Velikost:=0;
  Assign(Soubor,Name);
  {$I-}Reset(Soubor);{$I+}
  If IOResult>0 then
  begin GraphDone;ClrScr;TextColor(White);
        WriteLn(' CARADOC & Sandra sytem ERROR !!');TextColor(LightGray);
        WriteLn(' File ',Name,' damaged or no exist.');Halt(1);
  end;
  Velikost:=FileSize(Soubor);
  If Velikost<>Size then
  begin GraphDone;ClrScr;TextColor(White);
        WriteLn(' CARADOC & Sandra sytem ERROR !!');TextColor(LightGray);
        WriteLn(' File ',Name,' damaged.');Halt(1);
  end;
  Close(Soubor);
end;
procedure FileTest(Name:String;Pos:LongInt;Typ:Byte);
const Prom  :Array[1..1] of Byte=(0);
var Soubor:File of Byte;
begin
  Assign(Soubor,Name);
  {$I-}Reset(Soubor);{$I+}
  If IOResult>0 then begin GraphDone;ClrScr;TextColor(White);
     WriteLn(' CARADOC & Sandra sytem ERROR !!');TextColor(LightGray);
     WriteLn(' File ',Name,' damaged or no exist.');Halt(1);end;
  Seek(Soubor,Pos-1);
  Read(Soubor,Prom[1]);
  Close(Soubor);
  If Prom[1]<>Typ then begin GraphDone;ClrScr;TextColor(White);
                             WriteLn(' CARADOC & Sandra sytem ERROR !!');TextColor(LightGray);
                             WriteLn(' Fila ',Name,' damaged.');Halt(1);
                       end;
end;
procedure WriXY(X,Y:Byte;Text:String);begin GoToXY(X,Y);Write(Text);end;
procedure LText(Path,Slovo:String;X,Y:Byte);
var Fille : Text ;Num:Char;F:File of Byte;A:Integer;Slovo2:String;S:String;
label Zacatek;
begin
  A:=1;Assign(Fille,Path);Assign(F,Path);{$I-} Reset(Fille); {$I+}
  If IOResult>0 then begin ClrScr;Writeln('File not found ! ',Path);Halt(2);end;
  GoToXY(X,Y);TextColor(30);repeat ReadLn(Fille,Path);If Pos(Slovo,Path)>0 then
                                   begin TextColor(White);Delete(Path,43,255);Delete(Path,1,2);
                                         WriteLn(Path);Inc(Num);end;
                                   until  EOF(Fille);Close(Fille);
end;

procedure About_Sandra;
var Pocet:Byte;
begin
        Cls;Pocet:=63;
        TextColor(White);
        GoToXY(13,5);Write(' C A R A D O C ');
        GoToXY(13,7);Write('       &');
        LPict('SANDRA',0,0,157,20,77,57,768);
        LPict('SANDRA',0,0,29,31,65,81,3908);
        LPict('SANDRA',0,0,32,34,214,79,4807);
        Repeat Pocet:=Pocet-1;Delay(10);SetRGBColor(15,Pocet,Pocet,Pocet);
          Until Pocet=0;Pocet:=63;
        Repeat Pocet:=Pocet-1;Delay(40);
               SetRGBColor(0,Pocet,Pocet,Pocet);
          Until Pocet=0;
end;
procedure LP(Name:String;X,Y,A,B:Word;Skok:LongInt);
var Soubor : File;
    Pocet,
    Delka  : Word;
begin
  Assign(Soubor,Name);{$I-}Reset(Soubor,1);{$I+}
  If IOResult>0 then begin GraphDone;WriteLn('FILE ',Name,' DAMAGED OR NOT FOUND.');Halt(1);end;
  Seek(Soubor,Skok);
  For Delka:=1 to Y do begin
    BlockRead(Soubor,Pamet,X);
    For Pocet:=1 to X do
    If Pamet[Pocet]<>0 then Mem[$A000:Pocet+((Delka+B)*320)-320-1+A]:=Pamet[Pocet];
  end;
  Close(Soubor);
end;
procedure LPMem(Name:String;X,Y,A,B:Word;Adress:Word;Skok:LongInt);
var Soubor : File;
    Pocet,
    Delka  : Word;
    Nula   : Word;
    Prom   : Array[1..16000] of Byte;
    X2,Y2  : Word;
    A2     : Word;
    Tupec  : Word;
begin
  X2:=1;Y2:=1;A2:=1;Tupec:=1;
  Assign(Soubor,Name);Reset(Soubor,1);Nula:=1;Seek(Soubor,Skok);
  For Delka:=1 to Y do begin
    BlockRead(Soubor,Pamet,X);
{    For Pocet:=1 to X do Move(Pamet,Prom[Nula],320);Nula:=Nula+320;}
  For Pocet:=1 to X do begin Tupec:=Tupec+1;Prom[Tupec]:=Pamet[Pocet];end;
  end;

(*  For Pocet:=1 to X*Y do
  begin
    Pixel(X2,Y2,Prom[Pocet]);
    X2:=X2+1;
    If X2=X then begin Y2:=Y2+1;X2:=0;end;
  end;
  Paused;*)
  Move(Prom,Mem[40000:40000],X*Y);
  Nula:=0;
  For Pocet:=1 to 16000 do begin Prom[Pocet]:=0;end;
  Move(Mem[40000:40000],Prom,X*Y);
  For Delka:=1 to Y do begin
    
    For Pocet:=1 to X do begin
    If Prom[A2]<>0 then Mem[$A000:Pocet+((Delka+B)*320)-320-1+A]:=Prom[A2];
    A2:=A2+1;end;
  end;
  Close(Soubor);
end;
procedure InfoSandra;
begin Cls;AAColor('SANDRA',0);LP('SANDRA',320,200,0,0,768);end;
procedure GetBar(X,Y,X2,Y2:Word;Skok:Word);
begin OldY:=Y;A:=1;
  for OldY:=1 to Y2 do
  begin
    A:=A+1;
    Move(Mem[$A000:(Y*320+OldY*320+X)],Line,X2);
    With Pro^ do
    begin
      For C:=1 to X2 do B[Skok+(A*X2)+C]:=Line[C];
    end;
  end;
end;
procedure PutBar(X,Y,X2,Y2:Word;Skok:Word);
begin
  OldY:=Y;A:=1;
  For OldY:=1 to Y2 do
  begin A:=A+1;
    With Pro^ do
      begin  
        for C:=1 to X2 do begin
        Line[C]:=B[Skok+(A*X2)+C];
      end;
    Move(Line,Mem[$A000:(Y*320+OldY*320)+X],X2); end;
  end;
end;
procedure NewProm;begin New(Pro); end;
procedure DelProm;begin Dispose(Pro); end;
procedure LPCompiler(Name:String;Skok:LongInt;Pocet2:Word);
var Soubor : File;
    Soubor2: File of Byte;
    W      : Prom;
    Pocet  : Word;
    Typ    : Byte;
    PP     : Byte;
    OTyp   : Byte;
    OK     : Word;
    C      : Word;
    D      : Word;
procedure Pis;
begin
  Write(Soubor2,PP);
  Write(Soubor2,OTyp);
  OTyp:=Typ;PP:=0;
end;
begin
  With W do
  begin
    Pocet:=0;
    Assign(Soubor,Name);
    {$I-}Reset(Soubor,1);{$I+}
    If IOResult>0 then begin GraphDone;Write(' SOUBOR ');TextColor(White);Write(Name);
      TextColor(LightGray);Write(' NEEXISTUJE NEBO JE POSKOZEN!');Paused;Halt(1);end;
    Seek(Soubor,Skok);
      Blockread(Soubor,B,Pocet2);
      OK:=Pocet2;
    Close(Soubor);C:=1;D:=1;
  Repeat
    PP:=B[D];
    Typ:=B[D+1];
    for C:=1 to PP do begin Mem[$A000:Pocet-1]:=Typ; Pocet:=Pocet+1;end;
    D:=D+2;
  Until D>=OK;
  Mem[$A000:63999]:=Typ;
  end;
end;
procedure Eye;
begin
  WriteLn('                                                            ');
  WriteLn(' SANDRA system  copyright (c) 1994  lcd technology sound and graphics system ');
  WriteLn('                                                                             ');
  WriteLn(' @ Copyright 1992 Aztech Systems Pte Ltd         All Rights reserved.');
  WriteLn(' AZTECH LABS, INC    AZTECH SYSTEMS PTE LTD      ');
  WriteLn('                   ~~~~~~~~~~~~~~~                                   ');
end;
procedure LPPCX(Name:String;Skok:LongInt);
var RozmerObrazku : record
                      X1,Y1,X2,Y2 : Word;
                    end;
type UByte = ^Byte;
const DelkaBafru = 768;
var Bafr       : Array[1..DelkaBafru] of Byte;
    PozVBafru  : Word;
    KolikJeste,
    Barva      : Byte;
    SouborPCX  : File;
procedure NastavVideoModaPaletu;
var X : Word;
begin
  Seek(SouborPCX,FileSize(SouborPCX)-768);
  BlockRead(SouborPCX,Bafr,3*256);
  For X:=1 to 3*256 do Bafr[X]:=Bafr[X] shr 2;
  asm
    MOV  AX,0013h
    INT  10h
    XOR  BX,BX
    MOV  CX,256
    MOV  AX,DS
    MOV  ES,AX
    MOV  DX,OFFSET Bafr
    MOV  AX,1012h
    INT  10h
  end;
end;
procedure NahrajBafr;
begin
  BlockRead(SouborPCX,Bafr,DelkaBafru);PozVBafru:=1;
end;
procedure Dekompresuj(Kam:UByte;Kolik:Word);
begin
  while (Kolik>0) do
  begin
    If PozVBafru>DelkaBafru then NahrajBafr;
    If KolikJeste>0 then
      while(Kolik>0) and (KolikJeste>0) do
      begin
        Kam^:=Barva;
        Dec(Kolik);Dec(KolikJeste);
        asm
          INC  word ptr kam
        end;
      end
    else
      begin
        Barva:=Bafr[PozVBafru];
        Inc(PozVBafru);
        If Barva<$C0 then begin Kam^:=Barva;Dec(Kolik);
                                asm
                                  INC word ptr kam
                                end;
                          end
                            else begin KolikJeste:=Barva and 63;
                                       If PozVBafru>DelkaBafru
                                         then NahrajBafr;
                                       Barva:=Bafr[PozVBafru];
                                       Inc(PozVBafru);
                                 end;
      end;
  end;
end;
var Y,ZnackaAVerze:Word;
begin
  Assign(SouborPCX,Name);
  {$I-}Reset(SouborPCX,1+Skok);{$I+}
  If IOResult>0 then begin Halt(1);end;
  BlockRead(SouborPCX,ZnackaAVerze,SizeOf(ZnackaAVerze));
  Seek(SouborPCX,4+Skok);
  BlockRead(SouborPCX,RozmerObrazku,SizeOF(RozmerObrazku));
  with RozmerObrazku do
    If (X2<320) and (Y2<200) and (ZnackaAVerze=$050a) then
      begin
        NastavVideoModAPaletu;
        PozVBafru:=DelkaBafru+1;KolikJeste:=0;
        Seek(SouborPCX,128+Skok);
        For Y:=Y1 to Y2 do Dekompresuj(Ptr($a000,Y*320-X1),X2-X1+1);
      end;
  Close(SouborPCX);
end;
begin
DirectVideo:=False;CheckBreak:=False;Col:=255;
(*WriteLn(' SANDRA system (c) 1994                       CARADOC ver 3.1a');
Write(' LCD TECHNOLOGY PROTECTED MODE   ');Delay(3000);
WriteLn('  initialized.... OK');Sound(800);Delay(60);NoSound;Delay(1000);*)
end.