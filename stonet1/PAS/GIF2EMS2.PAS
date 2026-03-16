
program GIF_TO_EMS;
{WIZ}

uses  Dos, Graph, VGA256, GIF, Snapshot,ems;

var   G : GIFPicture;
      FN : PathStr;
      xres, yres ,fr,frx,fry: word;
      P : RGBPaletteSegment;
      x, y : word;
      Lines : array [ 0 .. 320 ] of byte;
      radek:array [0 .. 319] of integer;
      Error:Word;
      Total,Free:Word;
      Handle:Word;
      Address:Word;
      A,B:longint;
      pomdata,strana,pocstr:word;
      data: Array [1..16000] of byte;

procedure Page(Number:Word);
begin
  Error:=MapPages(Handle,Number,0);CheckError(Error); {namapuje stranku}
end;

procedure checking;{vypis a kontrola volne pameti}
begin
  If not EMSInstalled then EMSError('neni nainstalovan ovladac EMS pameti!');{otestuje ovladac EMS pameti}
  Error:=GetFreePages(Total,Free);CheckError(Error); {jen jednou}
  A:=Total;B:=Free;
  Writeln('Celkova pamet : ',A*16000);
  Writeln('Volna pamet   : ',B*16000);
end;

procedure alokujems;
begin
  Error:=AllocatePages(8,Handle);CheckError(Error);{alokuje 4 ems stranky (64000)}
  Error:=GetAddress(Address);CheckError(Error); {jen jednou}
end;


procedure piszems;{vypise obsah stranek z EMS}
begin
page(2);
Move(Mem[Address:0],data[1],16000);
for fry:=1 to 50 do
 begin
  for frx:=1 to 320 do
   begin
    putpixel(frx,fry,data[frx]);
   end;
 end;
page(3);
Move(Mem[Address:0],Mem[$a000:16000],16000);
page(4);
Move(Mem[Address:0],Mem[$a000:32000],16000);
page(5);
Move(Mem[Address:0],Mem[$a000:48000],16000);

end;

procedure dealokujems;
begin
Error:=DeallocatePages(Handle);CheckError(Error); {dealokuje EMS (uvolni)}
end;

procedure strana0;
begin
Page(2); {nastavi nulovou stranku (Cislo=0)}
Move(Data[1],Mem[Address:0],16000); {presune do EMS promennou data}
end;     {^odkud}
procedure strana1;
begin
Page(3);
Move(Data[1],Mem[Address:0],16000);
end;
procedure strana2;
begin
Page(4);
Move(Data[1],Mem[Address:0],16000);
end;
procedure strana3;
begin
Page(5);
Move(Data[1],Mem[Address:0],16000);
end;

procedure gifshowtoems(fn:pathstr);
begin
  G.OpenPicture(FN);
  if G.Ok then
    begin
      InitVGA256(VGA256Modes(0));
      if G.GPaletteSize>0 then
        begin
          P := G.GPalette;
          for x := 0 to pred(G.GPaletteSize) do
            with P[x] do
              begin
                R := R shr 2;
                G := G shr 2;
                B := B shr 2;
              end;
          SetRGBPaletteSegment(0,G.GPaletteSize,P);
        end               else
        SetGrayPalette(P);
      while G.ReadBlockHeader do
        begin
          if G.LPaletteSize>0 then
            begin
              P := G.LPalette;
              for x := 0 to pred(G.LPaletteSize) do
                with P[x] do
                  begin
                    R := R shr 2;
                    G := G shr 2;
                    B := B shr 2;
                  end;
              SetRGBPaletteSegment(0,G.LPaletteSize,P);
            end;
          xres := succ(GetMaxx-G.BlockHeader.x0);
          if xres>G.BlockHeader.Width then xres := G.BlockHeader.Width;
          yres := succ(GetMaxy-G.BlockHeader.y0);
          if yres>G.BlockHeader.Height then yres := G.BlockHeader.Height;
          pomdata:=0;strana:=0;
          for y := 0 to pred(yres) do
            begin
              G.ReadLine(Lines);
              for x := 0 to pred(xres) do
               begin
                pomdata:=pomdata+1;

                if (strana=0) and (pomdata=16000) then
                 begin
                  strana0;
                  pomdata:=0;
                  strana:=1;
                 end;
                if (strana=1) and (pomdata=16000) then
                 begin
                  strana1;
                  pomdata:=0;
                  strana:=2;
                 end;
                if (strana=2) and (pomdata=16000) then
                 begin
                  strana2;
                  pomdata:=0;
                  strana:=3;
                 end;
                if (strana=3) and (pomdata=16000) then
                 begin
                  strana3;
                  pomdata:=0;
                  exit;
                 end;
                data[pomdata]:=lines[x];
                {PutPixel(x,y,Lines[x]);}
               end;
            end;
          G.FinishBlock;
        end;
      G.ClosePicture;
      SetViewPort(0,0,GetMaxx,GetMaxy,true);
    end;
   end;


BEGIN
checking;
alokujems;
gifshowtoems('agmtit.gif');
readln;
piszems;
readln;
dealokujems;
END.