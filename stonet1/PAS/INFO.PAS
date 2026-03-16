program navod;

uses crt,graph,vga256;


var a,b,list:word;
    kl:char;
    x1,y1,y2,x2:word; {pozice okna}
    ox1,oy1,oy2,ox2:word; {pozice obrysu}

procedure okno;
begin
setfillstyle(1,25);bar(x1,y1,x2,y2);
setcolor(28);line(x1,y1,x2,y1);line(x1,y1,x1,y2);line(x1,y1+1,x2,y1+1);line(x1+1,y1,x1+1,y2);
setcolor(23);line(x1,y2,x2,y2);line(x2,y2,x2,y1);line(x1,y2-1,x2,y2-1);line(x2-1,y2,x2-1,y1);
end;

procedure obrys;
begin
setcolor(28);line(ox1,oy1,ox2,oy1);line(ox1,oy1,ox1,oy2);
setcolor(23);line(ox1,oy2,ox2,oy2);line(ox2,oy2,ox2,oy1);
end;

procedure revobrys;
begin
setcolor(23);line(ox1,oy1,ox2,oy1);line(ox1,oy1,ox1,oy2);
setcolor(28);line(ox1,oy2,ox2,oy2);line(ox2,oy2,ox2,oy1);
end;

procedure clinka;
begin
setcolor(0);rectangle(ox1-1,oy1-1,ox2+1,oy2+1);
end;

procedure stiskup;
begin
ox1:=270;oy1:=178;ox2:=285;oy2:=188;
revobrys;clinka;setcolor(20);
outtextxy(274,180,'');setcolor(0);
delay(200);
ox1:=270;oy1:=178;ox2:=285;oy2:=188;
obrys;clinka;
outtextxy(274,180,'');
end;

procedure stiskdown;
begin
ox1:=290;oy1:=178;ox2:=305;oy2:=188;
revobrys;clinka;setcolor(20);
outtextxy(294,180,'');setcolor(0);
delay(200);
ox1:=290;oy1:=178;ox2:=305;oy2:=188;
obrys;clinka;
outtextxy(294,180,'');
end;

procedure stiskesc;
begin
ox1:=235;oy1:=178;ox2:=265;oy2:=188;
revobrys;clinka;setcolor(22);
outtextxy(239,180,'ESC');setcolor(0);
delay(500);
ox1:=235;oy1:=178;ox2:=265;oy2:=188;
obrys;clinka;
outtextxy(239,180,'ESC');
end;

procedure stiskenter;
begin
ox1:=20;oy1:=10;ox2:=300;oy2:=25;
revobrys;clinka;
setcolor(30);bar(25,12,295,24);
outtextxy(35,14,'[c]1995 ');outtextxy(109,14,'Techno');outtextxy(157,14,char(115));
outtextxy(165,14,char(111));outtextxy(173,14,char(102));outtextxy(180,14,char(116));
outtextxy(188,14,',');outtextxy(195,14,char(87));outtextxy(203,14,char(73));
outtextxy(210,14,char(90));outtextxy(218,14,',');outtextxy(226,14,'Pave');
outtextxy(258,14,char(108));outtextxy(274,14,char(77));
delay(2500);
bar(25,12,295,24);
ox1:=20;oy1:=10;ox2:=300;oy2:=25;
obrys;clinka;
setcolor(23);
outtextxy(45,14,'Informace ke hre Stone Towers');
setcolor(30);
outtextxy(44,14,'Informace ke hre Stone Towers');
end;

procedure list1;
begin
setcolor(0);
bar(20,32,307,176);
moveto(20,39);outtext('Minimalni konfigurace:');line(20,47,194,47);
moveto(20,50);outtext('PC 386, 16Mhz, 8MB HDD, 3.5" FDD,');
moveto(20,60);outtext('VGA color, 2MB RAM, mys .');
moveto(20,80);outtext('Instalace hry:');line(20,88,130,88);
moveto(20,90);outtext('Spustenim programu INSTAL.BAT se hra');
moveto(20,100);outtext('nainstaluje do aktualniho adresare');
moveto(20,110);outtext('na disku C: . Hru spustite programem');
moveto(20,120);outtext('START.BAT .');
bar(20,180,230,189);
moveto(20,180);outtext(' 1 ze 4');
end;

procedure list2;
begin
setcolor(0);
bar(20,32,307,176);
moveto(20,39);outtext('Popis obrazovky:');line(20,47,144,47);
rectangle(20,50,200,150);
rectangle(22,52,52,72);rectangle(22,74,52,84);rectangle(22,86,52,120);
rectangle(22,122,52,148);rectangle(24,88,50,98);rectangle(24,102,50,112);
rectangle(198,52,168,62);rectangle(198,64,168,100);rectangle(198,102,168,120);
rectangle(198,122,168,148);
rectangle(54,122,166,134);rectangle(54,136,166,148);
rectangle(54,52,166,120);
setcolor(28);outtextxy(102,80,'1');outtextxy(34,60,'2');
outtextxy(34,76,'3');outtextxy(34,90,'4');outtextxy(34,104,'5');
outtextxy(34,133,'6');  outtextxy(180,54,'7');outtextxy(180,78,'8');
outtextxy(180,108,'9');outtextxy(175,133,'10');outtextxy(100,124,'11');
outtextxy(100,138,'12');setcolor(0);
moveto(206,40);outtext('1- Vyhled');
moveto(206,50);outtext('2- Oblicej');
moveto(206,60);outtext('3- Jmeno');
moveto(206,70);outtext('4- Magie');
moveto(206,80);outtext('5- Energie');
moveto(206,90);outtext('6- Deska pro');moveto(206,100);outtext('   diamanty');
moveto(206,110);outtext('7- Menu');
moveto(206,120);outtext('8- Kouzla');
moveto(206,130);outtext('9- Ovladani');
moveto(206,140);outtext('10- Mapa');
moveto(206,150);outtext('11- Texty');
moveto(206,160);outtext('12- Predmety');

bar(20,180,230,189);
moveto(20,180);outtext(' 2 ze 4');
end;

procedure list3;
begin
setcolor(0);
bar(20,32,307,176);
moveto(20,39);outtext('Greetings to:');line(20,47,122,47);
moveto(20,50);outtext('Dvorakovo Gymnazium Kralupy n Vl.');
moveto(20,70);outtext('Fric a spol. software');
moveto(20,60);outtext('SOU Steti');
moveto(20,80);outtext('S.K.T s.r.o. Melnik');
bar(20,180,230,189);
moveto(20,180);outtext(' 3 ze 4');
end;

procedure list4;
begin
setcolor(0);
bar(20,32,307,176);
moveto(20,39);outtext('Dotazy a pripominky zasilejte na ');
moveto(20,50);outtext('tyto adresy:');
moveto(20,70);outtext('Petr Mirejovsky    Petr Stastny');
moveto(20,80);outtext('Straznicka 1534    Straznicka 3259');
moveto(20,90);outtext('Melnik  27601      Melnik  27601');
moveto(20,100);outtext('tel.:0206/670 406  ');
bar(20,180,230,189);
moveto(20,180);outtext(' 4 ze 4');
line(47,80,48,79);line(53,79,54,80);line(55,79,55,79);line(95,80,96,79);
line(199,80,200,79);line(205,79,206,80);line(207,79,207,79);line(247,80,248,79);
line(79,69,80,70);line(81,69,81,69);line(135,70,136,69);
line(263,70,264,69);line(214,68,215,69);line(216,68,216,68);
line(223,68,224,69);line(225,68,225,68);
line(30,89,31,90);line(32,89,32,89);line(182,89,183,90);line(184,89,184,89);
line(55,89,56,89);line(207,89,208,89);
ox1:=21;oy1:=120;ox2:=299;oy2:=137;revobrys;clinka;
b:=0;
moveto(110,140);outtext('VGA color test');
repeat
 b:=b+1;
 if b=240 then b:=1;
 for a:= 0 to 15 do
  begin
   setcolor(a+b);
   line(22,121+a,298,121+a);
  end;
until keypressed;
if kl=#27 then exit;
kl:=#97;
end;


BEGIN
write(' ok ...  info');
initvga256(vga256modes(vga320x200));
settextstyle(0,0,1);
x1:=10;y1:=5;x2:=310;y2:=194;
okno;
ox1:=20;oy1:=10;ox2:=300;oy2:=25;
obrys;clinka;
setcolor(23);
outtextxy(45,14,'Informace ke hre Stone Towers');
setcolor(30);
outtextxy(44,14,'Informace ke hre Stone Towers');
setcolor(0);settextstyle(0,0,1);
ox1:=235;oy1:=178;ox2:=265;oy2:=188;
obrys;clinka;
outtextxy(239,180,'ESC');
ox1:=270;oy1:=178;ox2:=285;oy2:=188;
obrys;clinka;
outtextxy(274,180,'');
ox1:=290;oy1:=178;ox2:=305;oy2:=188;
obrys;clinka;
outtextxy(294,180,'');
list:=1;list1;

repeat
 kl:=readkey;
 if kl=#13 then stiskenter;
 if kl=#0 then
  begin
   kl:=readkey;
   if kl=#72 then
    begin
     list:=list-1;
     stiskup;
    end;
   if kl=#80 then
    begin
     list:=list+1;
    stiskdown;
    end;
  end;
if list<1 then list:=1;
if list>4 then list:=4;

if list=1 then list1;
if list=2 then list2;
if list=3 then list3;
if list=4 then list4;

until kl=#27;
stiskesc;


closegraph;
textcolor(7);
writeln;writeln;
write(' STONE TOWERS - The First Echantment                            - Informace');writeln;

END.