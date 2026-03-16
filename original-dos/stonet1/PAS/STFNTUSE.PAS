program stfontuse;

uses crt,graph,vga256,stfont;

var frc:word;
    ch:char;

begin
initvga256(vga256modes(0));
pis(50,150,2,'A B C D ABCDEFGHIJKLMNOPQRST ‚ƒ„…†‡ˆ‰Š');
pis(50,158,2,'QRSTUVWXYZ0 1234567890zcd');
pis(50,166,2,'acde@iorstu"yz /!?+-*/.,:[]()¡ –—˜™š›œ');
pis(11,75,4,'  CREATIVE TEAM UVaDi NOVOU POciTAcOVOU HRU');
pis(10,74,12,'  CREATIVE TEAM UVaDi NOVOU POciTAcOVOU HRU');
pis(70,100,1,'STONE TOWERS');pis(69,100,1,'STONE TOWERS');
pis(71,100,1,'STONE TOWERS');pis(70,101,1,'STONE TOWERS');
pis(70,99,1,'STONE TOWERS');pis(70,100,11,'STONE TOWERS');
repeat
for  frc:=16 to 30 do
  begin
   delay(50);
   pis(120,192,frc,'STISKNI LIBOVOLNOU KLaVESU...');
  end;
for  frc:=30 downto 16 do
  begin
   delay(50);
   pis(120,192,frc,'STISKNI LIBOVOLNOU KLaVESU...');
  end;
until keypressed;
repeat
ch:=readkey;
for  frc:=16 to 30 do
  begin
   delay(50);
   pis(121+frc,192,0,'  –—˜™š›œ');pis(119+frc,192,0,'  –—˜™š›œ');
   pis(120+frc,193,0,'  –—˜™š›œ');pis(120+frc,191,0,'  –—˜™š›œ');
   pis(120+frc,192,frc,'  –—˜™š›œ');
  end;
for  frc:=30 downto 16 do
  begin
   delay(50);
   pis(121+frc,192,0,'  –—˜™š›œ');pis(119+frc,192,0,'  –—˜™š›œ');
   pis(120+frc,193,0,'  –—˜™š›œ');pis(120+frc,191,0,'  –—˜™š›œ');
   pis(120+frc,192,frc,'  –—˜™š›œ');
  end;
until ch=#27;

closegraph;
end.