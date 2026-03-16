{*********************************************************}
{***    porizovani a prehravani "Snapshot" sekvenci    ***}
{***       (c) 1993 J.Pelikan, KSVI MFF UK Praha       ***}
{*********************************************************}
{$i-,x+}

unit  Snapshot;

interface


uses  Dos, VGA256, GIF;


{******************************}
{***      VGA grafika       ***}
{******************************}

const ActiveModes : set of VGA256Modes =
      [ VGA320x200, VGA368x350 ];
        { pouzitelne 256-barevne rezimy VGA karty
          (pro 16-barevnou grafiku se pouziva rezim 640x480) }

const ModeResolutions : array [ VGA256Modes ] of record
                                                   X, Y : integer;
                                                 end =
      ( (x:320;y:200), (x:320;y:400), (x:320;y:480), (x:360;y:480),
        (x:376;y:564), (x:400;y:564), (x:400;y:600), (x:320;y:240),
        (x:368;y:350), (x:640;y:400), (x:640;y:480), (x:800;y:600),
        (x:1024;y:768) );


const ActualXres : integer = 0; { parametry prave nastaveneho grafickeho rezimu }
      ActualYres : integer = 0;
      ActualColors : integer = 0;


procedure SetBestGraphics ( Xres, Yres : integer; Colors : integer );


{********************************************************************}
{***   jeden snimek ulozeny v pameti (obrazek je v GIF souboru)   ***}
{********************************************************************}

type  PSnapshot = ^TSnapshot;

      TSnapshot = object

                    Next, Prev : PSnapshot;
                      { dalsi a predchozi snimek sekvence }

                    Num : word;
                      { poradove cislo snimku }

                    Name : PathStr;
                      { jmeno GIF souboru s obrazkem }


                    constructor Init ( FN : PathStr; Numb : word );
                      { dosadi jako jmeno GIFu FN }

                    constructor ReadName ( var F : text; Numb : word );
                      { precte jmeno obrazku z textoveho souboru }


                    constructor GrabRectangle ( FN : PathStr;
                                                x1, y1, x2, y2 : integer );
                      { ulozi do obrazku se zadanym jmenem obdelnik z obrazovky }


                    constructor GrabScreen ( FN : PathStr );
                      { ulozi do obrazku se zadanym jmenem celou obrazovku }


                    procedure DrawScreen ( Number : boolean );
                      { obnovi celou obrazovku a pripadne napise do rohu
                        poradove cislo }

                  end;


{***********************************************************************}

implementation


uses  Graph;


{******************************}
{***      VGA grafika       ***}
{******************************}

{$l egavga.obj }

procedure egavga; external; { EGA/VGA BGI driver }


procedure SetBestGraphics ( Xres, Yres : integer; Colors : integer );
var  Dr, Mo : integer;
     Mode, Best : VGA256Modes;
     ActErrorx, ActErrory, Error : integer;
begin
  if Colors<=16 then
    begin
      if ActualColors<>16 then
        begin
          CloseGraph;
          Dr := VGA; Mo := VGAHi;
          InitGraph(Dr,Mo,'');
          ActualXres := 640;
          ActualYres := 480;
          ActualColors := 16;
        end;
    end         else
    begin
      Mode := VGA320x200;
      while (Mode<SVGA1024x768) and ( not (Mode in ActiveModes) or
            (ModeResolutions[Mode].X<>Xres) or
            (ModeResolutions[Mode].Y<>Yres) ) do Inc(Mode);
      if not (Mode in ActiveModes) or (ModeResolutions[Mode].X<>Xres) or
         (ModeResolutions[Mode].Y<>Yres) then
        begin { vyberu si nejblizsi }
          Error := Xres+Yres;
          Mode := VGA320x200;
          repeat 
            if Mode in ActiveModes then { zkusim ho }
              if (ModeResolutions[Mode].X>=Xres) and
                 (ModeResolutions[Mode].Y>=Yres) then
                begin { to je on! }
                  Best := Mode;
                  Mode := SVGA1024x768;
                end                              else
                begin
                  ActErrorx := Xres-ModeResolutions[Mode].X;
                  if ActErrorx<0 then ActErrorx := 0;
                  ActErrory := Yres-ModeResolutions[Mode].Y;
                  if ActErrory<0 then ActErrory := 0;
                  if Error>ActErrorx+ActErrory then
                    begin
                      Error := ActErrorx+ActErrory;
                      Best := Mode;
                    end;
                end;
            Inc(Mode);
          until Mode>SVGA1024x768;
          Mode := Best;
        end; { vyberu si nejblizsi }
      if (ActualColors<>256) or (ModeResolutions[Mode].X<>ActualXres) or
         (ModeResolutions[Mode].Y<>ActualYres) then
        begin { novy rezim }
          CloseGraph;
          InitVGA256(Mode);
          ActualXres := succ(GetMaxx);
          ActualYres := succ(GetMaxy);
          ActualColors := 256;
        end;
    end;
end; { SetBestGraphics }


{********************************************************************}
{***   jeden snimek ulozeny v pameti (obrazek je v GIF souboru)   ***}
{********************************************************************}


constructor TSnapshot.Init ( FN : PathStr; Numb : word );
  { dosadi jako jmeno GIFu FN }
begin
  Name := FN;
  Num := Numb;
  Next := @Self;
  Prev := @Self;
end; { TSnapshot.Init }


constructor TSnapshot.ReadName ( var F : text; Numb : word );
  { precte jmeno obrazku z textoveho souboru }
var  FN : PathStr;
begin
  repeat
    if EOF(F) then fail;
    ReadLn(F,FN);
    if FN<>'' then
      begin
        while (FN<>'') and (FN[Length(FN)]=' ') do Dec(FN[0]);
        while (FN<>'') and (FN[1]=' ') do FN := Copy(FN,2,255);
      end;
  until FN<>'';
  TSnapshot.Init(FN,Numb);
end; { TSnapshot.ReadName }


constructor TSnapshot.GrabRectangle ( FN : PathStr;
                                      x1, y1, x2, y2 : integer );
  { ulozi do obrazku se zadanym jmenem obdelnik z obrazovky }
var  PG : PGIFPicture;
     Xres, Yres : integer;
     Depth : byte; { pocet bitu - 16 nebo 256 }
     Line : array [ 0 .. 1023 ] of byte; { radka obrazovky }
     Pal, P : RGBPaletteSegment;
     EGAPal : PaletteType;
     x, y : integer;
begin
  Name := FN;
  Num := 0;
  Xres := succ(x2-x1);
  Yres := succ(y2-y1);
  if GetMaxColor>15 then Depth := 8
                    else Depth := 4;
  New(PG,NewPicture(FN,Xres,Yres,Depth,true));
  GetRGBPaletteSegment(0,256,Pal);
  if Depth=4 then
    begin
      GetPalette(EGAPal);
      for x := 0 to 15 do
        with Pal[EGAPal.Colors[x]] do
          begin
            P[x].R := R shl 2;
            P[x].G := G shl 2;
            P[x].B := B shl 2;
          end;
    end      else
    for x := 0 to 255 do
      with Pal[x] do
        begin
          P[x].R := R shl 2;
          P[x].G := G shl 2;
          P[x].B := B shl 2;
        end;
  PG^.SetGlobalPalette(P);
  PG^.WriteBlockHeader;
  SetViewPort(x1,y1,x2,y2,true);
  for y := 0 to pred(Yres) do
    begin { jedna radka obrazovky }
      for x := 0 to pred(Xres) do Line[x] := GetPixel(x,y);
      PG^.WriteLine(Line);
    end;
  PG^.FinishBlock;
  Dispose(PG,ClosePicture);
  SetViewPort(0,0,GetMaxx,GetMaxy,true);
end; { TSnapshot.GrabRectangle }


constructor TSnapshot.GrabScreen ( FN : PathStr );
  { ulozi do obrazku se zadanym jmenem celou obrazovku }
begin
  TSnapshot.GrabRectangle(FN,0,0,GetMaxx,GetMaxy);
end; { TSnapshot.GrabScreen }


procedure TSnapshot.DrawScreen ( Number : boolean );
  { obnovi celou obrazovku a pripadne napise do rohu
    poradove cislo }
var  PG : PGIFPicture;
     Xres, Yres : integer;
     Depth : byte; { pocet bitu - 16 nebo 256 }
     Line : array [ 0 .. 1023 ] of byte; { radka obrazovky }
     x, x1, y : integer;
     StrNum : string[3];
     pix : byte;
     EGAPal : PaletteType;

  procedure SetPal ( Size : word; P : RGBPaletteSegment );
  var  x : word;
       R : Registers;
  begin
    for x := 0 to pred(Size) do
      with P[x] do
        begin
          R := R shr 2;
          G := G shr 2;
          B := B shr 2;
        end;
    R.ax := $1012;
    R.es := Seg(P);
    R.dX := Ofs(P);
    R.bx := 0;
    R.cx := 256;
    Intr($10,R);
  end; { SetPal }

begin { TSnapshot.DrawScreen }
  New(PG,OpenPicture(Name));
  Xres := PG^.GIFHeader.Xres;
  Yres := PG^.GIFHeader.Yres;
  Depth := PG^.Depth;
  SetBestGraphics(Xres,Yres,1 shl Depth);
  if GetMaxColor<16 then
    begin
      EGAPal.Size := 16;
      for x := 0 to 15 do EGAPal.Colors[x] := x;
      SetAllPalette(EGAPal);
    end;
  if PG^.GPaletteSize>0 then SetPal(PG^.GPaletteSize,PG^.GPalette);
  while PG^.ReadBlockHeader do
    begin { jeden blok GIF obrazku }
      if PG^.LPaletteSize>0 then SetPal(PG^.LPaletteSize,PG^.LPalette);
      xres := succ(GetMaxx-PG^.BlockHeader.x0);
      if xres>PG^.BlockHeader.Width then xres := PG^.BlockHeader.Width;
      yres := succ(GetMaxy-PG^.BlockHeader.y0);
      if yres>PG^.BlockHeader.Height then yres := PG^.BlockHeader.Height;
      SetViewPort(PG^.BlockHeader.x0,PG^.BlockHeader.y0,GetMaxx,GetMaxy,true);
      for y := 0 to pred(yres) do
        begin { jedna radka }
          PG^.ReadLine(Line);
          x := 0;
          repeat
            pix := Line[x];
            x1 := succ(x);
            while (x1<xres) and (Line[x1]=pix) do Inc(x1);
            if x1=succ(x) then PutPixel(x,y,pix)
                          else
              begin
                SetColor(pix);
                Graph.Line(x,y,pred(x1),y);
              end;
            x := x1;
          until x=xres;
        end;
      PG^.FinishBlock; { doctu to, co jsem nedokreslil }
    end;
  SetViewPort(0,0,GetMaxx,GetMaxy,true);
  Dispose(PG,ClosePicture);
  If Number then
    begin { napisu cislo }
      SetColor(0);
      SetFillStyle(SolidFill,0);
      Bar(0,GetMaxY-9,19,GetMaxY);
      SetColor(GetMaxColor);
      Str(Num,StrNum);
      OutTextXY(2,GetMaxY-8,StrNum);
    end;
end; { TSnapshot.DrawScreen }


begin
  RegisterBGIDriver(@egavga);
end. { Snapshot }
