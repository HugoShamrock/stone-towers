Unit SVGA;

INTERFACE

const MaxNumChars = 95;  { Maximum number of Characters }
      Width = 15;
      Height = 12;
      CharSetName = 'future.chr';

const
   ButtonL = 0; ButtonR = 1; ButtonM = 2;
   OFF      = 0;  ON       = 1;

Type
  RGB = record
        Red, Grn, Blu : byte
        end;
  PaletteRegister = array[0..255] of RGB;
  SetTypes = ( FutureFont, StandardFont );
  ResType = ( VGA, SVGA6440, SVGA6448, SVGA8060, SVGA1076 );
  Position = record
               BtnStatus,
               opCount,
               XPos, YPos : integer;
             end;
  EventRec = record
               Event,
               BtnStatus,
               XPos, YPos : word;
             end;
  YPtr = ^YType;
  YType = record
            Col1, Col2, Col3, Col4 : byte; { Due to TP's memory }
            NextY : YPtr;                  { memory management }
          end;                             { pointers are multiples}
   XPtr = ^XType;                           { of 8 bytes }
   XType = record
             NextX : XPtr;
             Y : YPtr;
           end;

  GenMouse = object
      procedure SetAccel( threshold : integer );
        { Set Acceleration of mouse }
      procedure Getposition( var BtnStatus, XPos, YPos : integer );
        { Gets the Position of the mouse and returns button status }
      procedure QueryBtnDn( button : integer; var mouse : Position );
        { Checks if queried button was pressed }
      procedure QueryBtnUp( button : integer; var mouse : Position );
        { Checks if queried button is released }
      procedure ReadMove( var XMove, YMove : integer );
        { Reports absolute mouse movement since last call to ReadMove }
      procedure Reset( var Status : boolean; var BtnCount : integer );
        { Resets the mouse to default conditions }
      procedure SetRatio( horPix, verPix : integer );
        { Sets speed of mouse }
      procedure SetLimits( XPosMin, YPosMin, XPosMax, YPosMax : integer );
        { Creates View Port for which mouse can operate in }
      procedure SetPosition( XPos, YPos : integer );
        { Puts mouse to desired point on screen }
   end;

  GraphicMouse = object( GenMouse )
    procedure Initialize;
      { Sets default conditons for graphics mouse }
    procedure Show( ShowM : boolean );
      { Either shows or hides the graphics mouse }
    procedure MPlot( xx, yy : integer );
    procedure CheckMouse;
      { Checks if mouse has been moved since last call and moves mouse accordingly }
    procedure ExitSVGA;
      { Exits Graphics mouse and resets it back to text mode }
  end;

procedure SetMode( Mode : Restype );
  { Sets Graphics card to desired mode }
function WhichBank( x, y : integer ): byte;

procedure LoadWriteBank( Segment : byte );
  { Loads particular bank for read/write operations }
procedure Plot( x, y : integer; Color : byte );
  { Plots a point to screen }
procedure PutImage( x, y : integer; Img : XPtr );
  { Puts an image in memory to screen at point (x,y), top left hand corner }
procedure LoadImage( ImageName : string; var ImagePtr : XPtr );
  { Loads image from disk and puts into memory }
procedure DisposeImage( var Img : XPtr );
  { Deletes image from memory }
procedure SetColor( PalNum: byte; Hue : RGB );
  { Sets Color of a particular pallette }
function  GetPixel( x, y : integer ) : byte;
  { Returns color of a pixel }
procedure SetPalette( Hue : PaletteRegister );
  { Sets all 256 pallette registers to desired pallette }
procedure CyclePalette;
  { Rotates all colors in the pallette in repetitive cycle }
procedure Circle( x, y, Radius : word; Color : byte );
  { Draws a circle }
procedure Line( xx1, yy1, xx2, yy2 : integer; Color : byte );
  { Draws a line }
procedure ClearDevice;

procedure ClearPort( x1, y1, x2, y2 : integer );
  { Clears a Section of the screen }
procedure Rectangle( x1, y1, x2, y2 : word; Color : byte );
  { Draws a rectangle outline i.e not solid }
procedure RectFill( x1, y1, x2, y2 : integer; Color : byte );
  { Draws a solid Rectangle }
procedure ExitGraphics;
  { Exits SVGA Graphics and returns to normal text mode }
procedure OutTextXY( x, y : integer; word : string );
  { Writes text to screen at point X, Y }
procedure LoadFont( CharSetName: SetTypes );
  { Loads a particular Font for use }
procedure SetFont( Font : SetTypes );
  { If two or more fonts are in memory this allows you to choose one }
procedure SetFontColor( Color, BackCol : byte; Trans : boolean );
  { Set forground & background color of text & transparent background or not }
  { i.e write background to screen or skip it and only write letter          }
procedure LoadPalette( PaletteName : string );
  { Loads a particular pallette from disk }

var  Color : PaletteRegister;
     Bytes_per_Line, GetMaxX, GetMaxY : integer;
     mEvent : EventRec;
     PresentSeg : byte;

IMPLEMENTATION

Uses Dos, Crt;

type  FCharType = array[ 0..15, 0..12 ] of boolean;
      FCharSetType = array[ 0..95 ] of FCharType;
      SCharType = array[ 0..7, 0..9 ] of boolean;
      SCharSetType = array[ 0..95 ] of SCharType;
      CardType = ( AheadA, AheadB, ATI, ChipsTech, Everex, Genoa,
                  Paradise, Trident, Tseng3000, Tseng4000, Video7 );
      NameType = string[30];

var
  Mxx, Mxy, Mnx, Mny, XRes, YRes, X, Y, OldX, OldY : integer;
  regs : registers;
  Future : ^FCharSetType;
  Standard : ^SCharSetType;
  Width, Height, FontColor, BackGroundColor : byte;
  PresentSet : SetTypes;
  ShowMouse, Transparent, Sused, Fused : boolean;
  Card : CardType;
  MP, ColOld : array[ 0..3, 0..3 ] of byte;


function Ahead : NameType;

  begin
    Portw[$3CE] := $200F;
    if Port[$3CF] = $20 then Ahead := 'Ahead A'
      else if Port[$3CF] = $21 then Ahead := 'Ahead B'
        else Ahead := 'False';
  end;

function AnATI : NameType;

  var s : NameType;
      Temp : string;

  begin
    s[0] := #9;
    move(mem[$C000:$31],s[1],9);
    if s = '761295520'then
      begin
        Temp := 'ATI';
        if memw[$C000:$40] = $3331 then
          begin
            Temp := Temp + ' Super VGA';
            Regs.AH := $12;
            Regs.BX := $5506;
            Regs.AL := $55;
            Regs.BP := $FFFF;
            Regs.SI := $0;
            intr( $10, Regs );
            if Regs.BP = $FFFF then Temp := Temp + ' Revision 1'
              else Temp := Temp + ' Revision 2/3';
          end
        else
          Temp := 'False';
        AnATI := Temp;
      end
    else AnATI := 'False';
  end;

function AChipsTech : Nametype;

  var OldValue, Value : byte;
      Temp : string;

  begin
    Port[$3C3] := Port[$3C3] or 16;
    if Port[$104] = $A5 then
      begin
        Temp:= 'Chips & Technologies';
        Port[$3C3] := Port[$3C3] and $EF;
        Port[$3D6] := 0;
        case Port[$3D7] shr 4 of
          2 : Temp := Temp + ' 82c455';
          3 : Temp := Temp + ' 82c453';
          5 : Temp := Temp + ' 82c456';
          1 : begin
                Port[$3D6] := $3A;
                OldValue := Port[$3D7];
                Port[$3D7] := $AA;
                Value := Port[$3D7];
                Port[$3D7] := OldValue;
                if Value = $AA then Temp := Temp + ' 82c452'
                  else Temp := Temp + ' 82c451';
              end;
          end;
        AChipsTech := Temp;
      end
    else AChipsTech := 'False';
  end;

function AnEverex : NameType;

  var Value : byte;
      s : NameType;

  begin
    Regs.AX := $7000;
    Regs.BX := 0;
    intr( $10, Regs );
    if Regs.AL = $70 then
      begin
        Value := Regs.DX shr 4;
        if Value = $678 then AnEverex := 'Everex Ev678'
          else if Value = $236 then AnEverex := 'Everex Ev236'
            else begin
                   str( Value, s );
                   AnEverex := 'Everex Ev'+ s;
                 end;
      end
    else AnEverex := 'False';
  end;

function AGenoa : Nametype;

  begin
    if (meml[$C000:mem[$C000:$37]] and $FFFF00FF) = $66990077 then
      begin
        case mem[$C000:mem[$C000:$37] + 1] of
          $33, $55 : AGenoa := 'Tseng ET3000';
               $22 : AGenoa := 'Genoa 6100';
                 0 : AGenoa := 'Genoa 6200/6300';
               $11 : AGenoa := 'Genoa 6400/6600';
          end;
      end
    else AGenoa := 'False';
  end;

function AParadise : NameType;

  var OldValue, NewValue, New1, New2 : byte;
      Base : word;
      Temp : string;

   begin
     if meml[$C000:$7D] = $3D414756 then
       begin
         Temp := 'Paradise';
         if odd(Port[$3CC]) then Base:= $3D4
           else Base := $3B4;
         Port[Base] := $2B;  OldValue := Port[Base+1];
         Port[Base+1] := $AA; NewValue := Port[Base+1];
         Port[Base+1] := OldValue;
         if NewValue <> $AA then Temp := Temp + ' PVGA1A'
           else
             begin
               Port[$3C4] := $12; OldValue := Port[$3C5];
               Port[$3C5] := OldValue and $BF; New1 := Port[$3C5] and 64;
               Port[$3C5] := OldValue or $40;  New2 := Port[$3C5] and 64;
               Port[$3C5] := OldValue;
               if (New1 <> 0) or (New2 = 0) then Temp := Temp + ' WD90C00'
                 else
                   begin
                     Port[$3C4] := $10; OldValue := Port[$3C5];
                     Port[$3C5] := OldValue and $FB; New1 := Port[$3C5] and 4;
                     Port[$3C5] := OldValue or 4;    New2 := Port[$3C5] and 4;
                     Port[$3C5] := OldValue;
                     if (New1 <> 0) or (New2 = 0) then Temp := Temp + ' WD90C10'
                       else Temp := Temp + ' WD90C11';
                   end;
             end;
         AParadise := Temp;
       end
     else AParadise := 'False';
   end;

function ATrident : NameType;

   var OldValue, Value : byte;
       Temp : string;

   begin
     Port[$03C4] := $E;
     OldValue := Port[$03C5];
     Port[$03C5] := 0;
     Value := Port[$03C5] AND $F;
     Port[$03C5] := OldValue;
     if Value = $2 then
       begin
         Temp := 'Trident';
         Port[$3C4] := 11;
         if Port[$3C5] = 35 then Temp := Temp + ' 9000'
          else if Port[$3C5] = 3 then Temp := Temp + ' 8900'
           else if Port[$3C5] = 2 then Temp := Temp + ' 8800CS'
            else if Port[$3C5] = 1 then Temp := Temp + ' 8800BR';
         ATrident := Temp;
       end
     else ATrident := 'False';
  end;

function ATseng : NameType;

  var OldValue, NewValue, Value : byte;
      Base : word;
      Temp : string;

  begin
    OldValue := Port[$3CD];
    Port[$3CD] := $55;
    NewValue := Port[$3CD];
    Port[$3CD] := OldValue;
    if NewValue = $55 then
      begin
        Temp := 'Tseng';
        if odd( Port[$3CC] ) then Base := $3C4
          else Base := $3B4;
        Port[Base] := $33; OldValue := Port[Base+1];
        NewValue := OldValue xor 15;
        Port[Base+1] := NewValue;
        Value := Port[Base+1];
        Port[Base+1] := OldValue;
        if Value = NewValue then Temp := Temp + ' ET4000'
          else Temp := Temp + ' ET3000';
        ATseng := Temp;
      end
    else ATseng := 'False';
  end;


function AVideo7 : NameType;

  var Value, OldValue, NewValue : byte;
      Base : word;
      Temp : string;

  begin
    if odd( Port[$3CC] ) then Base := $3D4
      else Base := $3B4;
    Port[Base] := 12; OldValue := Port[Base+1];
    Port[Base+1] := $55; NewValue := Port[Base+1];
    Port[Base] := $1F; Value := Port[Base+1];
    Port[Base] := 12; Port[Base+1] := OldValue;
    if Value = byte( $55 xor $EA ) then
      begin
        Temp := 'Video7';
        Port[$3C4] := $8E;
        case Port[$3C5] of
          $80..$FF : Temp := Temp + ' VEGA VGA';
          $70..$7F : Temp := Temp + ' V7VGA FASTWRITE/VRAM';
          $50..$59 : Temp := Temp + ' V7VGA Version 5';
          $41..$49 : Temp := Temp + ' 1024i';
        end;
        AVideo7 := Temp;
      end
    else AVideo7 := 'False';
  end;


procedure NoMode;

  begin
    writeln;
    write( ' Mode not supported.' );
    Halt(1);
  end;


procedure SetMode( Mode : ResType );

  var ModeNum, i : byte;
      Tp: NameType;
      Tmp : real;

  begin
    TextColor( LightRed );  writeln; writeln;
    if Ahead <> 'False' then
      begin
        Tp := Ahead;
        if Tp = 'Ahead A' then Card := AheadA
          else Card := AheadB;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $60;
          SVGA6448 : ModeNum := $61;
          SVGA8060 : ModeNum := $62;
          SVGA1076 : ModeNum := $63;
        end;
        if (ModeNum = $63) and (Card = AheadA) then NoMode;
      end
    else if AnATI <> 'False' then
      begin
        Tp := AnATI;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $61;
          SVGA6448 : ModeNum := $62;
          SVGA8060 : ModeNum := $63;
        end;
        if Mode=SVGA1076 then NoMode;
        Card := ATI;
      end
    else if AChipsTech <> 'False' then
      begin
        Tp := AChipsTech;
        if ((Tp='Chips & Technologies 82c452') or
            (Tp='Chips & Technologies 82c453')) then
           begin
             case Mode of
               VGA      : ModeNum := $13;
               SVGA6440 : ModeNum := $78;
               SVGA6448 : ModeNum := $79;
               SVGA8060 : ModeNum := $7C;
               SVGA1076 : ModeNum := $7E;
             end;
             if (Mode=SVGA1076) or ((Mode in [SVGA8060,SVGA1076]) and
                (Tp = 'Chips & Technologies 82c452')) then
                  NoMode;
             Card := ChipsTech;
           end
        else
          NoMode;
      end
    else if AnEverex <> 'False' then
      begin
        Tp := AnEverex;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $14;
          SVGA6448 : ModeNum := $30;
          SVGA8060 : ModeNum := $31;
          SVGA1076 : ModeNum := $32;
        end;                            { ??? How about Trident Chips }
        if (Tp = 'Everex Ev678') or (Tp = 'Everex Ev236') then
          Card := Trident   { 678, 236 Chips use Trident }
        else Card := Everex;
      end
    else if AGenoa <> 'False' then
      begin
        Tp := AGenoa;
        if Tp = 'Tseng 3000' then
          begin
            case Mode of
              VGA      : ModeNum := $13;
              SVGA6440 : ModeNum := $2F;
              SVGA6448 : ModeNum := $2E;
              SVGA8060 : ModeNum := $30;
            end;
            if Mode=SVGA1076 then NoMode;
            Card := Tseng3000;
          end
        else
          begin
            case Mode of
              VGA      : ModeNum := $13;
              SVGA6440 : ModeNum := $7E;
              SVGA6448 : ModeNum := $5C;
              SVGA8060 : ModeNum := $6C;
            end;
            if Mode=SVGA1076 then NoMode;
            Card := Genoa;
          end;
      end
    else if AParadise <> 'False' then
      begin
        Tp := AParadise;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $5E;
          SVGA6448 : ModeNum := $5F;
          SVGA8060 : ModeNum := $5C;
        end;
        if (Mode=SVGA1076) or ((Mode=SVGA8060) and not(Tp='Paradise WD90C11')) then
          NoMode;
        Card := Paradise;
      end
    else if ATrident <> 'False'then
      begin
        Tp := ATrident;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $5C;
          SVGA6448 : ModeNum := $5D;
          SVGA8060 : ModeNum := $5E;
          SVGA1076 : ModeNum := $62;
        end;
        if (Mode in [SVGA8060,SVGA1076]) and ((Tp='Trident 8800CS') or (Tp='Trident 8800CS')) then
          NoMode;
        Card := Trident;
      end
    else if ATseng <> 'False' then
      begin
        Tp := ATseng;
        case Mode of
          VGA      : ModeNum := $13;
          SVGA6440 : ModeNum := $2F;
          SVGA6448 : ModeNum := $2E;
          SVGA8060 : ModeNum := $30;
MZ€       ÿÿ  ¸       @                                   €   º ´	Í!¸LÍ!This program cannot be run in DOS mode.
$        LX            ‚                           î      *      Ä      Ü       ô       ô   ÿ                í      í       
                                                                  »!                                     a32spkr        `  {  İ   ¡‚ ‘„ j„ d! Y‚ 0! Òı ~m =í ßí ¨ÿ Ÿÿ  µÿ ” „ ï’ é  ã İ† Õ„ É  ¢* ›) “' Š% |  iœ `‚ N +’ %œ ' ğ † ü‚ ğ' è% Û% Ó% œ
c ˆ
À 
° z
Ğ s
ğ c
à I
ˆ A
† 6
‚ 
à ö	’ î	† å	‚ »	Ğ ±	  ¥	ğ œ	  ‹	À …	° 	ˆ ı õ† é‚ Ë„ » ´‚ ® ¦r šŒ ”ˆ Š …† q‚ W N‚ <à .† &Š ‚ ü’ ô˜ ë” Æ’ À  º ´† ¬„ [m Sh Kc CÉ ;¬ 3§ +Š #â  X  ß
 Ú
 ±
 û Ù ó @ ë  ã ¡ Û o Ó   Ë Ö Ã „ » ³ ³ Y «  £ † › å “ ™ ‹ K ƒ ñ { £ s ³ k ‘ c p [ S S Ö K ¦ C } ; + 3 ”
   /  o‹  ˜   ÿ† ô‚ Ğ’ Ä* ¾) ¤* œ) U O² B <² ! ² œ ÒŒ Ìˆ Á° ·À °† ›” ’’ ’ x’ e„ N„ G  A„ ; 5† $’ ³ÿ ªÿ eÿ \ÿ ^ ÿ
 P ä
 í Ãı ı 
ı r) _) - Òı Ÿ- ‘ÿ
 4ı .- Áı ¶½ ¢İ œÍ Æí o' ÿ ÿ  # ù# î ä# Ş' ²' sÿ ¦# ÿ Ü Òÿ ½ÿ ´ÿ y ÿ É
ÿ š
) |
) <
 
ÿ ó	 ã	 ¾	 	½ “	õ
 w	İ p	Í K	- C	ÿ
 6	í
 0	ä
 ıÿ
 ÷ä
 Úí Íı Àÿ ®ÿ
 ¡- “ ‹' çÿ ¬ÿ
 ™ÿ (ÿ Äÿ ›ÿ nÿ êÿ ¶ÿ €ÿ úÿ % ÿ İ †Í g½ Fä
 4- í ü ı ï ı É ı Â í ‚ í z í r ı                                                                                                                                                                                                                                                                                                                                                                                                                   ^  Copyright (C) 1991,1992 Miles Design, Inc.d   ( e   V f   ú0 g   L+ h   ¬3 –   ¦4 ½   à4 ¾   "5 —   f5 ˜   F7 ª   â7 «   –8 ­   29 ®   Ê9 ¯   = ±   .> °   ²< ²   f= ¶   ? ·   ¬? ¹    @ À   Ş: Â   B; ³   &: ´   €: µ   ²; º   b »   ´ ¼   ¾ ¿   °@ Á   ÄA ™    š   N ›   X œ   ’    Æ    Ğ Ÿ   Ú ÿÿÿÿÈ           ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿx       IBM PC or compatible internal speaker  ˆµN@AÍÄ=C|*ÖˆµÿÑ §âÎ¾òŠDAèccç_½¢ ¿ôH±1Çp/şàÑĞŞû$X˜ã9—ÿoèhï}¬LñœKÿ·t4÷¾ˆV&øÎ¥[:ûßÄ«“|gR?-†ığâÕÉ¾³© –†~wqjd_YTOKGC?;852/,*(%#!
		RUX[^adgjmpsvy|                                                                                                                                                                         U‹ìVWœúü¸   U‹ìöEútû]_^ÉÃVWœúäa$üæaU‹ìöEútû]_^ÃU‹ìÉÃU‹ìÉÃU‹ìVWœú¸   U‹ìöEútû]_^ÉÃU‹ìVWœú¸    U‹ìöEútû]_^ÉÃU‹ìÉÃU‹ìVWœú¸ÿÿÿÿU‹ìöEútû]_^ÉÃU‹ìÉÃVWfƒJ fƒ=J xs_^Ãfƒ-J xfƒ5N ¾    €¾  t6¶ °ö£à fƒ=N  tf÷Ø‹Şf‰„38 €$ Vè!  ƒÄFƒşu»_^ÃVWœúü¿    Æ‡   Gƒÿuó¿    Æ‡  fÇ}8   Gƒÿué¿    Æ‡@ ÿGƒÿuófÇJ   fÇN   ÆR ÿÆT ÿU‹ìöEútû]_^ÃU‹ìVW»ÿÿÿÿCƒût:€»@ ÿuñ‹uˆ ‹ûŠ şƒ  ˆŸ@ Æ†$ AVè]   ƒÄ_^ÉÃèÔ  _^ÉÃU‹ìVW‹u€¾ ÿt8€¦( ß€$ Vè(   ƒÄ¶ ş‹  Š Æƒ@ ÿÆ† ÿ_^ÉÃU‹ìƒÄèVW‹u¶ €ûÿt%ÿ   ‰]üö†$ @uö†$ u_^ÉÃëë	€¦$ ¿ëæö†(  uäa$üæaé!  ¶ ¶ƒ€ fÁà
ƒ` f‰Eğ¶ Š† f˜fØfƒëfƒÃfƒû |öfƒÃfƒëfƒû_öf‰]îVWÑæ·†8 f‰Eê·]îƒë»    ¶ƒd Š£$ ‹ğ·]îfƒÃfƒû_rf»_ ¶ƒd Š£$ ‹ø·]î¶ƒd Š£$ ‹Ğf‰Uì·Eğf-  fEêfƒø |f+úf‹×ëf+Öf÷ê¹    f÷ùfEìˆEóˆeò_^¶]óŠ}ò:R u:=T t°¶æCë ŠÃæBë ŠÇæBë ˆR ˆ=T äaæa€¦$ şé®şÿÿU‹ìƒÄôVWº    ¾ÿÿÿÿFƒştD€¾  tñB¶¾ ƒç¸ÿÿ  €¿  @}f‹u0 ¶  +Ás¸    f‰uB ë¶ƒú†   ‰Uü¸    ºÿÿ  ¾ÿÿÿÿFƒşt0€¾  tñ·<uB €¾ ÿu;ørÜ‹Ç‰uôëÕ;úwÑ‹×‰uøëÊ;ÂrR‹uø¶ SVènıÿÿƒÄÆ†  [‹uôˆ ‹ûŠ şƒ  ˆŸ@ Æ†$ AVè†ıÿÿƒÄÿMü…eÿÿÿ_^ÉÃU‹ìVW‹uÆ†(  fÇu0 ÿÆ†$ A_^ÉÃU‹ìVW¾ÿÿÿÿŠEŠ]FƒştC€¾ uñ8† ué8 uáãÿ   €»À @}VèÁüÿÿƒÄÆ†  ëºÆ†  ë±_^ÉÃU‹ìVW‹}¾    €¾  tFƒşuñëY‹Eˆ† ‹Uˆ– ˆ– Æ†  ‹EÀè»ä .×ˆ† Æ† Æ†   VèÿÿÿƒÄÆ† ÿVèáûÿÿƒÄ_^ÉÃU‹ìVW¾    €¾  t#ŠE8† u€¾   tÿ¶ WèõşÿÿƒÄFƒşuÎ_^ÉÃU‹ìVW‹uæÿ   ‹}‹Çƒç%ğ   ¶M=°   tP=à   t7=€   t"=   u%ƒÿr ƒÿwãQVWèöşÿÿƒÄ_^ÉÃVWè‹şÿÿƒÄ_^ÉÃ‹Æˆ‡` ˆ€ °ëIƒşptëˆ  ëÛ° »à ƒşt+°@»@ ƒşt»  ƒştƒş@tIƒşy„   ƒş{tXë¤ˆ‹ß¾    €¾  t8 u†$ PSVèUûÿÿƒÄ[XFƒşuÖékÿÿÿˆÀ €ù@\ÿÿÿWè¶şÿÿƒÄéNÿÿÿ¾    €¾ u‹ß8 uÿ¶ Wè²ıÿÿƒÄFƒşuØéÿÿÿÆ‡À  WèoşÿÿƒÄÆ‡à  Æ‡  Æ‡`  Æ‡€ @°AéHÿÿÿU‹ìVWœú¸Æ U‹ìöEútû]_^ÉÃU‹ìVWœúÿuÿuÿuèWşÿÿƒÄU‹ìöEútû]_^ÉÃU‹ìÉÃU‹ìÉÃ
@rnop @     D0_N)nzÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ                                                                                                                                                                                                                                                                                U‹ìƒÄüVW‹MA‹u>CAT t>FORMut~XMIDtf‹F†ÄÁàf‹F†ÄƒÀÆ‹ğëÏf‹F†ÄÁàf‹F†Äƒè‰Eü>FORMuƒùt-ë/ƒÆ~XMIDtf‹F†ÄÁàf‹F†ÄƒÀ)Eü|Æ‹ğëÚâá‹Æë¸    _^ÉÃU‹ìVW‹u‹¶ş ¹   »    fÇD3pÿÿƒÃâô»   ˆ\3xÆ„3ˆ   ÿÆ„3˜   ÿÆ„3¨   ÿÆ„3¸   ÿK}Ù»   Æ„3È   ÿK}õ»   Æ„3X  ÿK}õÇFÿÿÿÿfÇF"  fÇF$  ÇF*d   ÇF.d   ÇF>d   ÇFBd   ÇF:    fÇFN  fÇFPÿÿÇFX    ÇFT    fÇFR ÇF\ z _^ÉÃU‹ìƒÄøVWÇEü    ‹> ‰Møãm‹}üƒEüƒ¿ş  tğ‹·ş fƒ~$ tK»    Š„3X  :Eu4Æ„3X  ÿŠŒ3x  ‹ûŠØ· Š\3xş‹Ú €Ë€j QSè.úÿÿƒÄfÿN$‹ßCƒû rºÿMøu“_^ÉÃU‹ìVW‹u»    Š„3X  <ÿt3Æ„3X  ÿŠŒ3x  ‹û»    ŠØŠ\3xş‹Ú €Ë€j QSèĞùÿÿƒÄ‹ßCƒû r¼fÇF$  _^ÉÃU‹ìVW‹u¿    ‹ßŠ„3  <@|ÆƒÚ  Ë°   j j@SèŠùÿÿƒÄ‹ßŠ„3(  <@|"WèÓşÿÿƒÄ‹ß¶\3xCSj è&  ƒÄ‹ßˆ\3xŠ„38  <@|€£ú ¿Š„3H  <@|Ë°   j jpSè+ùÿÿƒÄ‹ßGƒÿ…nÿÿÿ_^ÉÃU‹ìƒÄôVW‹u¿    ‹ßŠ„3(  <ÿt<@|j è+  ƒÄHƒøÿu‹Ç‹ßˆD3xGƒÿuÑÇEü    ‹]üŠ›È €ûnt5‰]øŠ›ş ‰]ô¿    ‹ß]ôŠ„3È   <ÿtPÿuøWVè×   ƒÄGƒÿuÜÿEü}ü	   u±¿    ‹ßŠ„3˜   <ÿt"Š”3¨   €úÿtŠ\3xfËà RPSèTøÿÿƒÄ‹ßŠ”3ˆ   €úÿtŠ\3xËÀ   j RSè0øÿÿƒÄGƒÿu©_^ÉÃU‹ìVW‹u»    ¶„3È   <ÿt?·N*÷á¹d   ÷ñƒør¸   ‹ûˆƒZ öƒú €u‹ûŠ\3x€Ë°PjSèĞ÷ÿÿƒÄ‹ßCƒûu¯_^ÉÃU‹ìƒÄüVWü‹u¶]¶UŠ„3¸   <ÿtÆ„3¸   ÿŠØ‹~Š;¶]Š›ş €ûÿt]ˆ“Z ˆ”3È   ŠEŠ]<t@<vth<wtf<ttd<utb<otc<ntd<steöƒú €uŠ\3x€Ë°RPSè5÷ÿÿƒÄ¸   _^ÉÃ‹N*ƒùdtÔ‹Â÷á¹d   ÷ñ‹Ğ¸   ƒúrº   ˆ“Z ë°ëë7ëeé   éØ   éï   ë ˆ”3¸   ë«fÇFN  fÇFP  ÇFX    ‹FT)FXë‰V¡R ƒø tƒœ‰eüRÿvÿR ‹eüU‹ìöEútû]é`ÿÿÿ»    ¹   fƒ|3pÿt
ƒÃâóéDÿÿÿf‰T3pÑã‹~‰|3`é1ÿÿÿ€ú@Œ(ÿÿÿ»   ¹   fƒ|3pÿu
ƒëâóéÿÿÿfƒ|3p tfÿL3pufÇD3pÿÿéñşÿÿÑã‹|3`‰~éãşÿÿ€‹ú @€ú@Óşÿÿ€£ú ¿éÇşÿÿ‹û€ú@|j è&  ƒÄHƒøÿu‹Ç‹ßˆD3xé£şÿÿWè.ûÿÿƒÄ‹ßŠ\3xCSj è‚  ƒÄ‹ßˆ\3xé}şÿÿU‹ìƒÄôVW‹u‹~·$‰Eü¶G‰Eø‹ÇƒÇ»    º    ë	¹   ÑãâüŠGŠé€á
Ù
íxé+ø‰}ô‹}üƒçö‡ú €ua¾X  ¹    °ÿò®‹Çu
fÿF$†Y  +ø‹Ã‹ßƒè‹MüˆŒ3X  ˆ¬3x  ‰„˜  »    ŠÙŠ\3xşƒÚ €ËŠÍÿuøQSèõôÿÿƒÄ‹Eô_^ÉÃU‹ìƒÄøVW‹u‹~ŠGˆEû‹ßƒÇ¸    º    ë	¹   ÑàâüŠGŠé€á
Á
íxé‹Ï+ËÁ‰EüŠEû</t<Xt3<Qty‹Eü_^ÉÃVèÎúÿÿƒÄfÇF fƒ~  tãÿ5F j èò  ƒÄëÑ¶f‰NRŠOƒés÷Ù¸Õ Ñèâüë¸   Óà‹È¸    Õ âù‰FTÇFX    )FXfÇFN  fÿFPë‡´ ŠÁàŠgŠGÁà‰F\éoÿÿÿU‹ìƒÄøVW‹u‹~¶‰Eø‹ßG¸    ëfÁàŠGŠé€á
Á
íxî‹Ï+ËÈ‰Mü‹Eü_^ÉÃU‹ìVW‹E‹]÷ó_^ÉÃU‹ìVW‹u‹¶ş ·FN·VP¿   ‹^X^T;^\|+^\@f;FRr¸    BOuå_^ÉÃU‹ìƒÄüVWüfƒ=N  t"éµ   +F\fÿFN·NNf;NRrxfÇFN  fÿFPëlfÿN ÇF üÿÿÿ‹> ‰MüãpƒF ‹=F ƒ¿ş  tê‹·ş fƒ~uH‹F:F>‰F:ƒèd|*‰F:fƒ~$ uQfÿN"~I‹FXFT;F\wÿÿÿ‰FX‹F:ƒèd}Ö‹F>;FBu‹F*;F.uÿMüuèbíÿÿfÿN _^ÉÃéo  é®  ëu¾X  ‹×¹    fŒØfÀ°ÿó®t–‹ß+ÚKƒ¬˜  }íQ°ÿ†„3X  ŠŒ3x  ¶Ø¶\3xş‹Ú €Ë€j QSèGòÿÿƒÄY–X  fÿN$uªéGÿÿÿƒFf‰F"é@ÿÿÿ‹~¶=€   ræ‹Ø%ğ   ƒãŠOŠW=ğ   s>=à   si¿   =Ğ   ƒŒ   =À   ss=°   s8¿   =    srVèüÿÿƒÄ‹øë}€ûtVè³ıÿÿƒÄ‹øëkVèÁüÿÿƒÄ‹øë^RQSVèÚùÿÿƒÄ¿   ëKˆŒ3˜   ˆ”3¨   ˆ‹š ˆ“º ¿   ëˆŒ3ˆ   ˆ‹z ¿   öƒú €u
D3xRQPèIñÿÿƒÄ~fƒ~uéÿÿÿéwşÿÿœ‹FFƒÀS¹ÿÿÿÿA‰FF+FJ}÷U‹ìöEútû]ã‹^B‹F>|+Á;Ã}
ëÁ;Ã~‹Ã‰F>é+şÿÿœ‹F2ƒÀS¹ÿÿÿÿA‰F2+F6}÷U‹ìöEútû]gã$‹^.‹F*|+Á;Ã}
ëÁ;Ã~‹Ã‰F*Vè…øÿÿƒÄéåıÿÿU‹ìVWœúüfÇN   Ç>     ¸ÿÿÿÿ¿Z ¹`   óf«¿ş ¹€   óf«¸    ¿ş ¹   óf«¿ú ¹   óf«¿Ú ¹   óf«¾    ¸    »    ŠÈ ˆƒş ƒÀFş	   uèè7êÿÿè+ëÿÿèu  ¾    ¿   ‹Ç°   ¶È ŠÚ €ùÿt!‹ÓŠ›ş ßˆ‹Z QRPèÆïÿÿƒÄGƒÿvÆFş   v¸¿   Æ‡š  Æ‡º @‹Çà   j@j PèïÿÿƒÄŠ=ê €ûÿtˆŸz ‹ÇÀ   j SPèkïÿÿƒÄGƒÿv³fÇ  U‹ìöEútû]_^ÉÃU‹ìƒÄøVWœúfƒ=  tXÇEü    ‹> ‰Møã+‹}üƒEüƒ¿ş  tğWj è7  ƒÄWj è„  ƒÄÿMøuÕèéÿÿÿuj è©ğÿÿƒÄfÇ   U‹ìöEútû]_^ÉÃU‹ìVWœú¸  U‹ìöEútû]_^ÉÃU‹ìVWœú‹}‰=R U‹ìöEútû]_^ÉÃU‹ìVWœúÇR     U‹ìöEútû]_^ÉÃU‹ìƒÄøVWœú»    ¹   ƒ»ş  tƒÃâò¸ÿÿÿÿé³   ‰]üÿuÿuè"òÿÿƒÄƒø „”   ‹øÇEø   ‹u‰³ş fÇF  fÇF  fÇF
  }øf‹G†ÄÁàf‹G†ÄƒÀ‰Eø?TIMBu‰>ëÜ?RBRNu‰~ëÏ?EVNTuÇ‹Eü‰F‰~‹}‰~fÇF   fÇF  fÇF  ÿ> ÿuüè&òÿÿƒÄ‹Eüë¸ÿÿÿÿU‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt.ƒ¾ş  t%‹¾ş fƒufÇG  ëÇ†ş     ÿ> U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt:‹¶ş fƒ~uÿuj è4   ƒÄÿuè‰ñÿÿƒÄ‹FƒÀ‰FfÇF fÇF U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt.ƒ¾ş  t%‹¶ş fƒ~uVè‘òÿÿƒÄVèãòÿÿƒÄfÇF  U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt,ƒ¾ş  t#‹¶ş fƒ~ ufƒ~ tVè:óÿÿƒÄfÇF U‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt
‹¶ş ·FU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt	Vè=øÿÿƒÄU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğtVèøÿÿƒÄ‹ÂU‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt‹¶ş ‹]K‹EHˆD3xU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt‹¶ş ‹]K¸    ŠD3x@U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt`‹¶ş fƒ~ tS‹~?RBRNuH·OƒÇ
ŠE8tƒÇâ÷ë3‹GƒÀ‹~ø‰~fÇF"  VèØğÿÿƒÄ¹   »    fÇD3pÿÿƒÃâôU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt	‹¶ş ‹F>U‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt	‹¶ş ‹F*U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿtD‹¶ş ‹E‰FBƒ} t/‹FB+F>t*™3Â+Â‹È¸
   ÷e÷ñƒø u¸   ‰FJÇFF    ë‰F>U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿtM‹¶ş ‹E‰F.ƒ} t/‹F.+F*t3™3Â+Â‹È¸
   ÷e÷ñƒø u¸   ‰F6ÇF2    ë‰F*VèŠñÿÿƒÄU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt.‹¶ş ‹]ƒûwu‹FëŠ›ş €ûÿt]K¸    Š„3È   U‹ìöEútû]_^ÉÃU‹ìVWœú‹uƒşÿt‹¶ş ‹EHÿuÿuPVè`ñÿÿƒÄU‹ìöEútû]_^ÉÃU‹ìVWœú‹u¸ÿÿÿÿ;ğt$‹¶ş ¸    »    ‹MI8Œ3X  u@Cƒû uğU‹ìöEútû]_^ÉÃU‹ìVWœú¹ÿÿÿÿ‹ñ¸À   ¿   „‡ú u8Ú sŠÚ ‹÷Oƒÿ}âƒşÿu=€   t4¸€   ëÊÎ°   j j@VèlèÿÿƒÄƒæVè¿íÿÿƒÄÆ†Ú  €ú €‹Æ@U‹ìöEútû]_^ÉÃU‹ìVWœú‹uNö†ú €„°   €¦ú Æ†Ú  Î°   j j@VèèÿÿƒÄj j{VèøçÿÿƒÄƒæ‹Ş¿    Š“Z €úÿtS€ã€Ë°Š‡È RPSèËçÿÿƒÄ[ƒÃGÿ	   uĞƒæŠ†z <ÿtÎÀ   j PVèŸçÿÿƒÄƒæŠ†š <ÿtŠ–º €úÿtÎà   RPVèvçÿÿƒÄU‹ìöEútû]_^ÉÃ                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ™IÙèÖ”óÎ@($tğ¯£=)‡Éò½#7ÆQ#¯µ“}ÅZõª€)9E4	¹40}½€3rQ¤ÇÁp:ôŞĞŞıô{ŠÿÈV 7ßÈÂØŞ7º&uDŠS‚\Ã_Ğ­ÍY:Ô T—"&Á2ÿK»ĞA/±"öAL©‘JnŸ²ú7¦ Š(™÷äH™ONà%‘MÎ‡JY7´?·xÔÑ¼Å2lnÒ7Ñ	 +ÉÕ‡Çôõ|»‡¦z€òCcñ+‹S=€¬OUÿßÁÛ h?¬ 7äHQ&éaaFğ î” *jĞ2şš;rMÕ$Ãx˜i“}÷ğÙ›¦äèèQr‹tXêÙÉ¶ì Cä‚œaÜ Gƒ+;×ô²è`U0"Ç¥3ZØØ	ølUQ fAÛ›Ê·Uö·‚Î²q)òŞ
¢4>C¯hÍù¼ÊÎpSñq6w„~Ù‡Ãç­j†]æymÓ
UïãÃ£‹ğ®ï•õf‚“å&ôŒßÊÿƒÃÖ!Ç¬upc†yQõAPc±+éëÎ´ïÅaÄ›Sß+%\Œ5¼h#C<¼4²Ğç¢…ƒğX§ï/´ÛÀMÇÙC†RnÚ‹=—µOpÚûB
0[CóØ!X„§4:ÜÎÅœHœà	6hhÑãD“	–'”B©
—.€¨yƒTéy¿ßT^&hûqû¨™1&v”62!OYLÊ$Uw2¿¹¾Qxó« A4§2‘Fª°9>¸z6Vqb™ ÈÃ˜@]ù¡=œœ)‘! t¡·K+Oâ	ï¢C¤²gtƒô	eXC,fª‡?Je622û]a¸hMèÕ7U£4”ºuUã@àËşâ:¤49PyQ¢ˆQ"NÑÃ“İ«ÀõèT³@–	 A¦†ÎGÃ·×pŠ‚…@Íœ
´Tş3Ù8K!æã£
—Tb¤À–¢Â™Nyâ¸
Î+W€Xà‰S"{ÿ¯r¼(šô/")±_ğ|ñã8!'ˆ!fĞ?”*İ¦•8œ.©ùT¸æÁRËª}ù{vú©Úb:1WáÌ÷Âí¼L	ÈZdÕq`ÊÏÂ£Ş‹ä #ÒUåúTĞ×ÅÙ´® ibmhI„ËnÒ¦»´Y Y´ÖsJÄphá$yÔà@“4´Ü¥MŒN×+äÎ:"ü;gı¿›î®²†>‹ù(Wï/Õ	«¡Â—Oæm"ŒCŒ¾xaúhPÚÔ÷ıÁRüo-…
«ªPå'>¥KÜÉÈ.x–#i#U9øªYòÀ¨¤ó::¸ÿná€*Tç5‚’šëª
[7şyV#»=¨ZP*HşMĞÆh££Ğ?‹q<)t ÃKg#NÎD6ÀJ`%ú†nV6¹?[¤:T
ˆæÒ{cŠûH!¥b?ãÏ÷¯f6wJç,ĞyğÈ—ô&u±·ìÂÄ`Y ~*8·rólüELÊ¹¢! qCõ¡ m•Ó#ùH'(Ælšùğ¸?•ŞÎù˜sÁ 
—ãeyâÔÚâĞ÷ÂìÂ‚??’ÜBÄœ
èP§j|9;MC`«ÇSø_•bí¼¼ŞÅ€#†¡Íç?“2uJTä@ì°v¦Øk[å·ÛÚ%
«Ä™2‹w76Æ¼51ÈØĞ~ƒ ’…i:q:Åæ|¤Œ¬“=+óˆw½±ùÖÆ³\ÅbnM ÔË¡Q1-¡ F	×NØ§€±%!T·ˆèÂĞ´Ö^Ÿf@öŞ_”ŒÒDçâÅ»íüÜúú~ÙSQ)¶ñP/äüj‘“LÙ1P,:kñf4˜gö”ÿ ş´'Yøzƒæ2>`öStadîÛP•’şNiçø°(¾gV"h®ú€?§ˆQ‡2S<dî¨Ò4œéæšè*‚ğfhnØó¥ Š±Â|¯¡PÕÎê”¨4è4Œºø†ÚqŸÎ$c®!®"###Ş"!!!$####¬!!!!"#!#!İÜº»#"!!®Ş­­®"#¼###®"­½Ş#!######­®®!!!!­##­!¼####­"»®!!¼"##¼Ş­"»Œ!®®#$#®!!¼®!!##!!­®!®¼###¼`!!!!­"#"#¼!®®º"¼##¼!!¼#####¼®®##»Œ¼"#­"­###®¼®­®¼Ş¼##Œ!¼!Œ»#®Ş!®"##¼Ş»"­®$"­!#!!!####­®#¼®###"»"!®$##"!­###!!¼"Œ##¼­######"»###"!Ş$######­#"Ş­Ş¼!®Ş!!###‹"##»®¼!!Ş!Œ¼!!!İ#$"­¼®!­½`!!!!­#¼!®##»Œ"¼"¼`!®####!!!##­"»Œ#"Ü¬#¼"®"Ü®Ş!!¼"##­İ¬"»###‹#¼!!®#$­Ş!"º#İ#İ#Œ!¼!Ş®®##!¼##»"!­#¼!!®!­İº"#­###!!##®!®!##¼Ş!!"##"!#­!Ş­"!#!#"®Ş¼"#Œ"#!!Ş#»#Œ!!®#¼##!"¼!#®¼##‹"¼®ŞŞ­!#»!!"»"®­!®##¼»!Ş"#­!º"#!##»"Œ#»İ!###"®!!$®¼!!»Œ"¼­#"!İº##‹¼!!###®#®®!»Ş"Œ!!»#!­"""!"#!¼""»""»#"Œ!#®!"city5_1 3  /???K@   @   (   (  (  (  tttttss`astscdddccccdcccccdccTTc``acccbcbccbcbbbbbbbabaaabbacbbscr`abbaa`abacccbbbbbabbbbabbbaadbbawstcwabbbaaaabbcbcbcbbbabbbabcbbabtdabasttw`bbbbaaaaabbbbbaaaabbaabcbaabscbbbstt`aabbbaabccbaatcabbbccbbccccabscaasttccbb`aabbaabbbbbca`````abaababaaas``asa``w````aaa`bba```tttttttttcwcsssstbbdcdcdctdccccbbcccwwccbcctbcdddcdaaaaaaa`ca`aabbaabaacbbaabbabbbaabaaascbbababawaaaabaababababbabbbtdbdbcbcwwwbaabbbbbabbbbbaabbatdbdcbccbbbabababbaabbabtdcccwbbbbcca``a`aatacuwbabbbwwcacbtdbbwwcccatcbbbwwcaaatcbbbwa`tbabcwcwwwwwvwvwwwwccwtwwwccvtwvctwwttwwtstwswucsvvuTccvssvvrvsscswwvsss`vswT`aaaaaaaa`uwww`aba`ccccbcaa`u``w3`aabaa`scabbbbbba`r``w2abcbcb`daaaabbbba`cwwww`cbbbcb`dbbaabbbbba``dcbbbab`tcbcbaaaabcb``aabaaaa``taaa`a`B``aaaTsssssdascccccccccccbbaaccxaaaaa`a`cbaabbaabbbbba`cw`bb`tcab`wa`bbaabbaaaabbbaa`acatcbaawwa`sdbaacabbaaaaaaacbbcbebbccwa`scbbaabbbaaaaaa`ucbbebbabaaaaaaaaaabbba3uacwcwa`a````B```aaaattttssttr```ccccddedddcccccccbwc``dddcbbaababbtdwww`cccbbaababbccbtdbd6b`eccaaaaaabbccccdaaabcabbbab`aabcccbeaabaabbtcbababaaababaaadbbaaabwcbbccbcbbc````a`aatbaa```awwaat`````aactcccttstttT`bccbbbababcbtutttuTtbaabbcbabbabbbcbusttttabb`bbbbacabcabutTubut`aaababtcdcscututbccbaaaababutut;uutaatababbabdcbuubbab`aaactuutWubbbu9utu7tsttWuutrrttttTdbbauttut8vtutbutusstututsVtVtuutVuuwWtuUtttttvVdVtttuttttutvtVbtutuTcttttuVtttsttusutUuttVtutvttutVtbtuVtttt```tttttttsuaaabcbbatuVttub5bcadaabbttutuu9tutabba`baErbsuttscbcbtvtttttbbababbavabcStdtVfbabaaaastttubebutVtuu`a``babtttVtttactttutbctuut5bbabbbdtuttu9ucbaabcbeabsuttscrbaaaaab`a`tuttuVtbbabbbbbctbbbbbabtVbubaabbbbcbabcttbbut;ttttttctutttusttttttttttr`aatttsbacaatrbbbtuatutaaauuuabctttbrabcatttbbbctubtuubttttut9tttttbasutbbsttbttdswindow03 1 /???K   À   (   (À  (ğ  (ü  11112222qqv««©qqqrqqqqsqrqqqqsw©ªwqrqqqqsqrqqqqsssqrqqrsssqrqqr«3wy©«ª¨¦z¦zz¦¦§¨ª«©wssqrqqrsssqrqqrsssssqqsssssqq3tvy©ª«©¨zy¦§§¨xx¨§¦z¦y©«ªyw3ssqqsssssqqssssssqqrssssssssqqrs3tv§x©©¨¦¨©«©©ª©©«ª©x¨x©§¨©¨zwsssqqrssssssssqqrsssssssqtssssqt3ª©§xw¨©vª§©uª«««ª©©©ª¨§ª3sssqtssssqtsstssssssstssss3«w©§©ªw©ªv«uª««uªv©ªv§xªtsstssssstsssssttssttuuuus3t«ª¦§y©vv©ª¨©©§¨ªuªª©v©ªt®tttuvvussttsssssssssuvwxwvuss®r¨¨§©ªª«««««ªª©©¨¥§ª3stuvwxxwussssssssstssssssssstsstuwxzxwutt®tr««ªv¨«¬®«ªª¨y©«tu3ttvwyzywvu