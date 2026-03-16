{**************************************************************}
{***                                                        ***}
{***    256-barevne rezimy pro standardni VGA (256KB)       ***}
{***            hardwarove zcela kompatibilni!              ***}
{***    256-barevne rezimy pro SVGA/VESA karty (256KB-1MB)  ***}
{***                                                        ***}
{***        (c) 1992 J.Pelikan, KSVI MFF UK Praha           ***}
{***                                                        ***}
{***   BGI drivers: (c) 1991, JORDAN HARGRAPHIX SOFTWARE,   ***}
{***                (c) 1991, PEZIK (368x350)               ***}
{***                                                        ***}
{**************************************************************}
{***                                                        ***}
{***   pouziti: InitVGA256(Mode);                           ***}
{***            ...                                         ***}
{***            CloseGraph;                                 ***}
{***                                                        ***}
{***   Mode : VGA320x200, VGA320x400, VGA320x480,           ***}
{***          VGA360x480, VGA376x564, VGA400x564,           ***}
{***          VGA400x600, VGA320x240, VGA368x350  (pro VGA) ***}
{***                                                        ***}
{***          SVGA640x400 (256KB), SVGA640x480 (512KB),     ***}
{***          SVGA800x600 (512KB), SVGA1024x768 (1MB)       ***}
{***                                                        ***}
{**************************************************************}
{$x+}


unit VGA256;

interface


type VGA256Modes = ( VGA320x200, VGA320x400, VGA320x480, VGA360x480,
                     VGA376x564, VGA400x564, VGA400x600, VGA320x240,
                     VGA368x350, { original VGA }
                     SVGA640x400, SVGA640x480, SVGA800x600,
                     SVGA1024x768 { Super VGA 256KB-1MB } );


procedure InitVGA256 ( Mode : VGA256Modes );


var   CurrentMode : VGA256Modes;


type  RGBPaletteEntry = record
                          R, G, B : byte;
                        end;

      RGBPaletteSegment = array [ 0 .. 255 ] of RGBPaletteEntry;


{************************************************************}
{***              Nastaveni cele RGB palety               ***}
{***   v poli PaletteSegment jsou trojice R,G,B z <0,63>  ***}
{************************************************************}

procedure SetRGBPaletteSegment ( First, Number : integer;
                                 var PaletteSegment );

procedure GetRGBPaletteSegment ( First, Number : integer;
                                 var PaletteSegment );


{************************************************************}
{***         Nastaveni sede skaly do RGB palety           ***}
{************************************************************}

procedure SetGrayPalette ( var Palette : RGBPaletteSegment );

procedure GetGrayTone ( Gr : byte; var R, G, B : byte );
 { vrati R,G,B pro sedy odstin Gr (pro 256 odstinu sedi ) }

procedure Border ( ba : shortint );

procedure SetGrayPalette16;
  { nastavi sedou paletu v 16-barevnem rezimu }


{*********************************************************}
{***  3-3-2 paleta pro rozptylovani barevnych obrazku  ***}
{*********************************************************}

procedure Set332Palette;


{************************************************************}

implementation

uses  Graph, Dos;

{$l TWK256.OBJ }
{$l VGA368.OBJ }
{$l SVGA256.OBJ }

procedure TWK256; external;
procedure VGA368; external;
procedure SVGA256; external;


procedure InitVGA256 ( Mode : VGA256Modes );
var  Dr, Mo : Integer;
begin
  case Mode of
    VGA320x200, SVGA640x400 .. SVGA1024x768 :
      begin { Driver SVGA256 - SuperVGA modes }
        Dr := InstallUserDriver('SVGA256',nil);
        RegisterBGIDriver(@SVGA256);
        if Mode=VGA320x200 then Mo := 0
                           else Mo := Succ(Ord(Mode)-Ord(SVGA640x400));
      end; { Driver SVGA256 }
    VGA320x400 .. VGA320x240 :
      begin { Driver TWK256 - Tweaked 256-color modes }
        Dr := InstallUserDriver('TWK256',nil);
        RegisterBGIDriver(@TWK256);
        Mo := Ord(Mode)-Ord(VGA320x400);
      end; { Driver TWK256 }
    else
      begin { Driver VGA368 - 368x350x256 VGA mode }
        Dr := InstallUserDriver('VGA368',nil);
        RegisterBGIDriver(@VGA368);
        Mo := 0;
      end; { Driver VGA368 }
    end; { case }
  InitGraph(Dr,Mo,'');
  CurrentMode := Mode;
end; { InitVGA256 }


procedure SetRGBPaletteSegment ( First, Number : integer;
                                 var PaletteSegment );
begin
  asm
            mov    dx,3DAh
  @vr:      in     al,dx
            test   al,8h
            jnz    @vr
  @nvr:     in     al,dx
            test   al,8h
            jz     @nvr
            mov    dx,3c8h
            mov    ax,First
            out    dx,al
            inc    dx
            mov    bx,Number
            mov    cx,bx
            add    cx,bx
            add    cx,bx
            les    si,PaletteSegment
            cld
  @loop:    seges lodsb
            out   dx,al
            loop  @loop
  end;
end; { SetRGBPaletteSegment }


procedure GetRGBPaletteSegment ( First, Number : integer;
                                 var PaletteSegment );
var  reg : registers;
begin
  reg.ah := $10; reg.al := $17;
  reg.es := Seg(PaletteSegment);
  reg.dx := Ofs(PaletteSegment);
  reg.bx := First;
  reg.cx := Number;
  Intr($10,reg);
end; { GetRGBPaletteSegment }


{************************************************************}
{***         Nastaveni sede skaly do RGB palety           ***}
{************************************************************}

const d = 0.24706; { 63/255 }

procedure SetGrayPalette ( var Palette : RGBPaletteSegment );
var   RR, GG, BB : real;
      x : byte;
begin
  RR := 0.0; GG := -0.3; BB := 0.3;
  for x := 0 to 255 do
    with Palette[x] do
      begin
        R := Round(RR); G := Round(GG); B := Round(BB);
        RR := RR + d; GG := GG + d; BB := BB + d;
      end;
  SetRGBPaletteSegment(0,256,Palette);
end; { SetGrayPalette }


procedure GetGrayTone ( Gr : byte; var R, G, B : byte );
var   delta : real;
begin
  delta := Gr*d;
  R := round(delta);
  G := round(delta-0.3);
  B := round(delta+0.3);
end; { GetGrayTone }


procedure Border ( ba : shortint );
var  reg : registers;
begin
 reg.ah:=$10; reg.al:=1;
 reg.bh:=ba;
 Intr($10,reg);
end; { Border }


procedure SetGrayPalette16;
var  P : PaletteType;
     i : byte;
     r, g, b : byte;
begin
  GetPalette(P);
  for i := 0 to 15 do
    begin
      GetGrayTone(17*i,r,g,b);
      SetRGBPalette(P.Colors[i],r,g,b);
    end;
end; { SetGrayPalette16 }


{*********************************************************}
{***  3-3-2 paleta pro rozptylovani barevnych obrazku  ***}
{*********************************************************}

procedure Set332Palette;
var  red, green, blue : byte;
     P : RGBPaletteSegment;
begin
  for red := 0 to 7 do
    for green := 0 to 7 do
      for blue := 0 to 3 do
        with P[red*32+green*4+blue] do
          begin
            R := red*9;
            G := green*9;
            B := blue*21;
          end;
  SetRGBPaletteSegment(0,256,P);
end; { Set332Palette }


end. { VGA256 }
