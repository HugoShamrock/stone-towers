program stcol_use;

uses crt,dos,graph,vga256,gif,snapshot,stfont,stcol;

var  text:string;
     G : GIFPicture;
     FN : PathStr;
     xres, yres : word;
     Pr : RGBPaletteSegment;
     x,y,k,l : word;
     Lines : array [ 0 .. 2048 ] of byte;


procedure gifshow;
begin
  G.OpenPicture(FN);
  if G.Ok then
    begin
     if G.GPaletteSize>0 then
       begin
          Pr := G.GPalette;
          for x := 0 to pred(G.GPaletteSize) do
            with Pr[x] do
              begin
                R := R shr 2;
                G := G shr 2;
                B := B shr 2;
              end;
          SetRGBPaletteSegment(0,G.GPaletteSize,Pr);
        end               else
        SetGrayPalette(Pr);
      while G.ReadBlockHeader do
        begin { jeden blok GIF obrazku }
          if G.LPaletteSize>0 then
            begin
              Pr := G.LPalette;
              for x := 0 to pred(G.LPaletteSize) do
                with Pr[x] do
                  begin
                    R := R shr 2;
                    G := G shr 2;
                    B := B shr 2;
                  end;
              SetRGBPaletteSegment(0,G.LPaletteSize,Pr);
            end;
          xres := succ(GetMaxx-G.BlockHeader.x0);
          if xres>G.BlockHeader.Width then xres := G.BlockHeader.Width;
          yres := succ(GetMaxy-G.BlockHeader.y0);
          if yres>G.BlockHeader.Height then yres := G.BlockHeader.Height;
          SetViewPort(G.BlockHeader.x0,G.BlockHeader.y0,GetMaxx,GetMaxy,true);
          for y := 0 to pred(yres) do
            begin { jedna radka }
              G.ReadLine(Lines);
              for x := 0 to pred(xres) do PutPixel(x,y,Lines[x]);
            end;
          G.FinishBlock; { doctu to, co jsem nedokreslil }
        end;
      G.ClosePicture;
      SetViewPort(0,0,GetMaxx,GetMaxy,true);
 end;
end;

BEGIN
initvga256(vga256modes(0));
fn:='glass.gif';
gifshow;
loadpal('game.col');
gwx1:=85;gwy1:=70;gwx2:=235;gwy2:=150;
get_back;
make_gwin(16,1);
pis(85,82,195,'TOTO JE UKaZKA POUzITi');
pis(85,92,193,' UNIT" STCOL A STFONT');
pis(85,102,191,'  UNIT STCOL POUzIVa ');
pis(85,112,189,'   PALETY GAME.COL. ');
pis(85,140,187,'               (C) WIZ');
readln;
put_back;
delay(300);
closegraph;
END.