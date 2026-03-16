{******************************************************}
{***        Cteni a zapis GIF format obrazku        ***}
{***  Graphics Interchange Format, CompuServe Inc.  ***}
{***     (c) 1993 J. Pelikan, KSVI MFF UK Praha     ***}
{******************************************************}

unit GIF;

interface


uses  Dos, VGA256, Bits, LZW;


{**********************************************}
{***              GIF format                ***}
{**********************************************}


{  <Signature> <GlobalDescriptor> <LocalDescriptor><data>
                                  <LocalDescriptor><data> ...
   <GifTerminator> }


type  GifSignature = packed array [ 1 .. 6 ] of char;

const Signature87a : GifSignature = 'GIF87a';

      Signature89a : GifSignature = 'STONET';


      GifBlockSeparator = $2c;
      GifTerminator     = $3b;
      GifExtensionSep   = $21;


type  GlobalDescriptor = record

                           Xres, Yres : word;
                             { horizontalni a vertikalni rozliseni }

                           Spec : byte; { flagy }

                           BackgColor : byte; { barva pozadi? }

                           AspectRatio : byte; { pomer velikosti pixelu }

                         end;


const GColormap   = $80; { globalni paleta }
      GSortFlag   = $08; { je paleta setridena? }
      GColorShift = 4;
      GColorMask  = $7;  { hloubka v bitech (1-8) zmensena o 1,
                           posunuti a maska }
      GSizeShift  = 0;
      GSizeMask   = $7;  { velikost palety 2^(1-8), exponent zmenseny o 1,
                           posunuti a maska }

      GAspect1    = 0;   { nejuzivanejsi hodnota pomeru }


type  LocalDescriptor = record

                          x0, y0 : word; { souradnice leveho horniho rohu }

                          Width, Height : word; { sirka a vyska }

                          Spec : byte; { flagy }

                        end;


const LColormap   = $80; { lokalni paleta }
      LInterleave = $40; { prokladany format }
      LSortFlag   = $20; { je paleta setridena? }
      LSizeShift  = 0;
      LSizeMask   = $7;  { velikost palety 2^(1-8), exponent zmenseny o 1,
                           posunuti a maska }


{**********************************************}
{***     GIF soubor v binarnim souboru      ***}
{**********************************************}


type GIFPicture = object ( LZWCode )


                    FN : PathStr; { jmeno GIF souboru }


                    GIFHeader : GlobalDescriptor;
                      { hlavicka GIF souboru }

                    Depth : byte; { barevne rozliseni v bitech (1 az 8) }

                    GPaletteSize : word; { velikost globalni palety (i 0) }

                    GPalette : RGBPaletteSegment;
                      { globalni paleta }


                    BlockHeader : LocalDescriptor;
                      { hlavicka prave zpracovavaneho bloku }

                    LPaletteSize : word; { velikost lokalni palety (i 0) }

                    LPalette : RGBPaletteSegment;
                      { lokalni paleta }


                    Ok : boolean;
                      { true, jestlize nedoslo k I/O chybe }


                      {***   cteni GIF obrazku:   ***}

                      {  pouziti: OpenPicture, ReadBlockHeader, ReadLine,
                                    ReadLine,... FinishBlock,
                                               ReadBlockHeader, ...
                                  ClosePicture }

                    constructor OpenPicture ( FName : PathStr );
                      { otevreni existujiciho obrazku v souboru FName, precte
                        rozliseni, format a pripadnou globalni paletu }

                    function ReadBlockHeader : boolean;
                      { precte hlavicku dalsiho bloku a jeho paletu, preskakuje
                        vsechny rozsirene bloky, vrati true, kdyz jeste neni
                        konec souboru }

                    procedure ReadLine ( var Line );
                      { nacte do bufferu dalsi radku obrazku (kazdy pixel do
                        jednoho bytu) }

                    procedure FinishBlock;
                      { ukonci cteni/zapis aktualniho bloku (preskoci
                        pripadne nedoctena data) }

                    destructor ClosePicture;
                      { zavreni obrazku (pri zapisu zakonci GIF soubor) }


                      {***   zapis noveho GIF obrazku:   ***}

                      {  pouziti: NewPicture, [SetGlobalPalette],
                                    WriteBlockHeader, WriteLine,
                                      WriteLine,... FinishBlock,
                                    WriteBlockHeader, ...
                                  ClosePicture }

                    constructor NewPicture ( FName : PathStr; Xr, Yr : word;
                                             Dept : byte; Rewr : boolean );
                      { vytvoreni noveho obrazku v souboru FName s danym
                        rozlisenim (zapise globalni deskriptor,
                        implicitne bez palety) }

                    procedure SetGlobalPalette ( var Palette );
                      { zapise do obrazku globalni paletu velikosti 2^Depth }

                    procedure SetLocalPalette ( var Palette );
                      { zapise do obrazku lokalni paletu velikosti 2^Depth }

                    procedure WriteBlockHeader;
                      { zapise hlavicku bloku podle udaju v BlockHeader
                        (implicitne: blok plne velikosti bez palety) }

                    procedure WriteLine ( var Line );
                      { zapise dalsi radku z bufferu Line (co pixel to byte) }


                  private

                    PicFile : BinaryFile; { I/O binarni soubor }

                  end;


     PGIFPicture = ^GIFPicture;


{*************************************************************************}

implementation


{**********************************************}
{***     GIF soubor v binarnim souboru      ***}
{**********************************************}

{$i-}

constructor GIFPicture.OpenPicture ( FName : PathStr );
  { otevreni existujiciho obrazku v souboru FName, precte
    rozliseni, format a pripadnou globalni paletu }
var  Test : GifSignature;
begin
  FN := FName;
  Assign(PicFile,FName);
  System.Reset(PicFile,1);
  Ok := false;
  if IOResult<>0 then fail;
  BitFile.AssignFile(@PicFile,false);
  BlockRead(PicFile,Test,Sizeof(Test));
  if (IOResult<>0) or ((Test<>Signature87a) and
      (Test<>Signature89a)) then fail;
  BlockRead(PicFile,GIFHeader,Sizeof(GIFHeader));
  if IOResult<>0 then fail;
  Depth := succ((GIFHeader.Spec shr GColorShift) and GColorMask);
  GPaletteSize := succ((GIFHeader.Spec shr GSizeShift) and GSizeMask);
  if GPaletteSize>Depth then Depth := GPaletteSize;
    { nektere GIFy maji hloubku spatne - ridim se spis podle velikosti palety }
  if GifHeader.Spec and GColormap>0 then
    begin { globalni paleta }
      GPaletteSize := 1 shl GPaletteSize;
      BlockRead(PicFile,GPalette,3*GPaletteSize);
      if IOResult<>0 then fail;
    end                             else
    GPaletteSize := 0; { bez globalni palety }
  Ok := true;
end; { GIFPicture.OpenPicture }


function GIFPicture.ReadBlockHeader : boolean;
  { precte hlavicku dalsiho bloku a jeho paletu, preskakuje
    vsechny rozsirene bloky, vrati true, kdyz jeste neni
    konec souboru }
var  Sep : byte; { separator }
begin
  Ok := false;
  ReadBlockHeader := false;
  BlockRead(PicFile,Sep,1);
  if IOResult<>0 then exit;
  while Sep=GifExtensionSep do
    begin { extension block preskocim... }
      BlockRead(PicFile,Sep,1); { identifikace bloku }
      if IOResult<>0 then exit;
      BitFile.FinishBlock; { preskocim blok }
      BlockRead(PicFile,Sep,1); { separator }
      if IOResult<>0 then exit;
    end;
  if Sep=GifTerminator then
    begin { konec GIF souboru }
      Ok := true;
      exit;
    end;
  ReadBlockHeader := true;
  if Sep=GifBlockSeparator then
    begin { nasel jsem blok }
      BlockRead(PicFile,BlockHeader,Sizeof(BlockHeader));
      if IOResult<>0 then exit;
      if BlockHeader.Spec and LColormap>0 then
        begin { lokalni paleta }
          LPaletteSize := 2 shl ((BlockHeader.Spec shr LSizeShift)
                                 and LSizeMask);
          BlockRead(PicFile,LPalette,3*LPaletteSize);
          if IOResult<>0 then exit;
        end                               else
        LPaletteSize := 0; { bez lokalni palety }
      BlockRead(PicFile,Sep,1); { pocatecni sirka kodu v bitech }
      if IOResult<>0 then exit;
      InitDecode(Sep,@PicFile); { inicializace LZW dekoderu }
      Ok := true;
    end;
end; { GIFPicture.ReadBlockHeader }


procedure GIFPicture.ReadLine ( var Line );
  { nacte do bufferu dalsi radku obrazku (kazdy pixel do
    jednoho bytu) }
begin
  Ok := GetValues(Line,BlockHeader.Width);
end; { GIFPicture.ReadLine }


procedure GIFPicture.FinishBlock;
  { ukonci cteni/zapis aktualniho bloku (preskoci pripadne
    nedoctena data) }
begin
  LZWCode.Done; { dokoncim rozdelany blok a uvolnim data LZW dekoderu }
end; { GIFPicture.FinishBlock }


destructor GIFPicture.ClosePicture;
  { zavreni obrazku (pri zapisu zakonci GIF soubor) }
var  Term : byte;
begin
  if Out then
    begin
      Term := GifTerminator;
      BlockWrite(PicFile,Term,1); { zakonceni GIFu }
      if IOResult=0 then;
    end;
  Close(PicFile);
  Ok := IOResult=0;
end; { GIFPicture.ClosePicture }



constructor GIFPicture.NewPicture ( FName : PathStr; Xr, Yr : word;
                                    Dept : byte; Rewr : boolean );
  { vytvoreni noveho obrazku v souboru FName s danym
    rozlisenim (zapise globalni deskriptor,
    implicitne bez palety) }
var  Je : boolean; { takovy soubor jiz existuje }
begin
  FN := FName;
  Ok := false;
  Assign(PicFile,FName);
  if not Rewr then
    begin
      System.Reset(PicFile,1);
      Je := IOResult=0;
      Close(PicFile);
      if (IOResult<>0) or Je then fail;
    end;
  Rewrite(PicFile,1);
  BitFile.AssignFile(@PicFile,true);
  BlockWrite(PicFile,Signature87a,Sizeof(GifSignature));
  if IOResult<>0 then fail;
  GIFHeader.Xres := Xr;
  GIFHeader.Yres := Yr;
  GIFHeader.Spec := (pred(Dept) and GColorMask) shl GColorShift;
    { zatim zadna paleta }
  GIFHeader.BackgColor := 0;
  GIFHeader.AspectRatio := GAspect1;
  BlockWrite(PicFile,GIFHeader,Sizeof(GIFHeader));
  if IOResult<>0 then fail;
  Depth := Dept;
  GPaletteSize := 0;
    { nastavim implicitni hlavicku bloku: }
  BlockHeader.x0 := 0;
  BlockHeader.y0 := 0;
  BlockHeader.Width := Xr;
  BlockHeader.Height := Yr;
  BlockHeader.Spec := 0; { bez lokalni palety, neprokladany format }
  LPaletteSize := 0;
  Ok := true;
end; { GIFPicture.NewPicture }


procedure GIFPicture.SetGlobalPalette ( var Palette );
  { zapise do obrazku globalni paletu velikosti 2^Depth }
begin
  GIFHeader.Spec := GIFHeader.Spec or GColormap or
                      ((pred(Depth) and GSizeMask) shl GSizeShift);
  GPaletteSize := 1 shl Depth;
  Move(Palette,GPalette,GPaletteSize*3);
  Seek(PicFile,Sizeof(GifSignature));
  BlockWrite(PicFile,GIFHeader,Sizeof(GIFHeader));
  BlockWrite(PicFile,GPalette,GPaletteSize*3);
  Ok := IOResult=0;
end; { GIFPicture.SetGlobalPalette }


procedure GIFPicture.SetLocalPalette ( var Palette );
  { zapise do obrazku lokalni paletu velikosti 2^Depth }
begin
  BlockHeader.Spec := BlockHeader.Spec or LColormap or
                      ((pred(Depth) and LSizeMask) shl LSizeShift);
  LPaletteSize := 1 shl Depth;
  Move(Palette,LPalette,LPaletteSize*3);
end; { GIFPicture.SetLocalPalette }


procedure GIFPicture.WriteBlockHeader;
  { zapise hlavicku bloku podle udaju v BlockHeader
    (implicitne: blok plne velikosti bez palety) }
var  Sep : byte;
begin
  Ok := false;
  Sep := GifBlockSeparator;
  BlockWrite(PicFile,Sep,1);
  BlockWrite(PicFile,BlockHeader,Sizeof(BlockHeader));
  if IOResult<>0 then exit;
  if BlockHeader.Spec and LColormap>0 then
    begin { lokalni paleta }
      LPaletteSize := 2 shl ((BlockHeader.Spec shr LSizeShift)
                             and LSizeMask);
      BlockWrite(PicFile,LPalette,3*LPaletteSize);
      if IOResult<>0 then exit;
    end                               else
    LPaletteSize := 0; { bez lokalni palety }
  BlockWrite(PicFile,Depth,1); { pocatecni sirka kodu v bitech }
  if IOResult<>0 then exit;
  InitEncode(Depth,@PicFile); { inicializace LZW koderu }
  Ok := true;
end; { GIFPicture.WriteBlockHeader }


procedure GIFPicture.WriteLine ( var Line );
  { zapise dalsi radku z bufferu Line (co pixel to byte) }
var  x : word;
     L : array [ 0 .. 2048 ] of byte absolute Line;
begin
  for x := 0 to pred(BlockHeader.Width) do
    PutValue(L[x]);
end; { GIFPicture.WriteLine }


end. { GIF }
