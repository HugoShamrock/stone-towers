program little_animation;

uses dos,Crt,graph,vga256,ggif,snapshot;

var G : GIFPicture;
    FN : PathStr;
    xres, yres : word;
    Pr : RGBPaletteSegment;
    x,y,k,l,rych : word;
    Lines : array [ 0 .. 2048 ] of byte;
    rx1,rx2,ry1,ry2: word;

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

           for y := ry1 to ry2 do
            begin
              G.ReadLine(Lines);
              for x := rx1 to rx2 do
               begin
                  PutPixel(x+k-rx1,y+l-ry1,Lines[x]);
              end;
            end;
          G.FinishBlock; { doctu to, co jsem nedokreslil }
        end;
      G.ClosePicture;
      SetViewPort(0,0,GetMaxx,GetMaxy,true);
 end;
end;

procedure jdivpravoohnivce;
begin
k:=50;l:=50;
rx1:=291;rx2:=318;
fn:='anim5.gif';gifshow;
rx1:=1;rx2:=28;
fn:='anim2.gif';gifshow;
delay(rych);
k:=52;l:=50;
rx1:=30;rx2:=57;
fn:='anim2.gif';gifshow;
delay(rych);
k:=54;l:=50;
rx1:=59;rx2:=86;
fn:='anim2.gif';gifshow;
delay(rych);
k:=56;l:=50;
rx1:=1;rx2:=28;
fn:='anim2.gif';gifshow;
delay(rych);
k:=58;l:=50;
rx1:=30;rx2:=57;
fn:='anim2.gif';gifshow;
delay(rych);
k:=60;l:=50;
rx1:=59;rx2:=86;
fn:='anim2.gif';gifshow;
delay(rych);
k:=62;l:=50;
rx1:=1;rx2:=28;
fn:='anim2.gif';gifshow;
delay(rych);
k:=64;l:=50;
rx1:=30;rx2:=57;
fn:='anim2.gif';gifshow;
delay(rych);
k:=66;l:=50;
rx1:=59;rx2:=86;
fn:='anim2.gif';gifshow;
delay(rych);
end;

procedure jdivlevoohnivce;
begin
k:=66;l:=50;
rx1:=291;rx2:=318;
fn:='anim5.gif';gifshow;
rx1:=88;rx2:=115;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=117;rx2:=144;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=146;rx2:=173;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=88;rx2:=115;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=117;rx2:=144;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=146;rx2:=173;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=88;rx2:=115;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=117;rx2:=144;
fn:='anim2.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=146;rx2:=173;
fn:='anim2.gif';gifshow;
delay(rych);
end;

procedure otocsevlevoohnivce;
begin
k:=66;l:=50;
rx1:=233;rx2:=260;
fn:='anim2.gif';gifshow;
delay(rych);
rx1:=233;rx2:=260;
fn:='anim1.gif';gifshow;
delay(rych);
rx1:=204;rx2:=231;
fn:='anim2.gif';gifshow;
delay(rych);
end;

procedure vystrelohnivce;
begin
rx1:=1;rx2:=28;
fn:='anim1.gif';gifshow;
delay(rych);
rx1:=30;rx2:=57;
fn:='anim1.gif';gifshow;
delay(rych);
rx1:=59;rx2:=86;
fn:='anim1.gif';gifshow;
delay(rych);
rx1:=88;rx2:=115;
fn:='anim1.gif';gifshow;
delay(rych);
rx1:=1;rx2:=28;
fn:='anim2.gif';gifshow;
k:=k+23;
repeat
 k:=k+2;
 rx1:=117;rx2:=144;
 fn:='anim5.gif';gifshow;
 delay(rych);
 k:=k+2;
 rx1:=146;rx2:=173;
 fn:='anim5.gif';gifshow;
 delay(rych);
until k>200;
delay(50);
rx1:=233;rx2:=260;
fn:='anim5.gif';gifshow;
delay(rych+20);
rx1:=262;rx2:=290;
fn:='anim5.gif';gifshow;
delay(rych+20);
rx1:=291;rx2:=318;
fn:='anim5.gif';gifshow;
k:=210;l:=50;
rx1:=1;rx2:=28;
fn:='anim4.gif';gifshow;
end;

procedure ukazsezelence;
begin
k:=210;l:=50;
rx1:=175;rx2:=292;
fn:='anim3.gif';gifshow;
delay(rych);
rx1:=146;rx2:=173;
fn:='anim4.gif';gifshow;
delay(rych);
rx1:=1;rx2:=28;
fn:='anim4.gif';gifshow;
end;

procedure jdivlevozelence;
begin
k:=210;l:=50;
rx1:=233;rx2:=260;
fn:='anim5.gif';gifshow;
rx1:=1;rx2:=28;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=30;rx2:=57;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=59;rx2:=86;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=88;rx2:=115;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=117;rx2:=144;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=1;rx2:=28;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=30;rx2:=57;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=59;rx2:=86;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=88;rx2:=115;
fn:='anim4.gif';gifshow;
delay(rych);
k:=k-2;
rx1:=117;rx2:=144;
fn:='anim4.gif';gifshow;
delay(rych);
end;

BEGIN
writeln('rychlost:');read(rych);
initvga256(vga320x200);
ry1:=0;ry2:=28;
 ukazsezelence;
 jdivpravoohnivce;
 vystrelohnivce;
 otocsevlevoohnivce;
 jdivlevoohnivce;
 jdivlevozelence;
readln;
closegraph;
END.