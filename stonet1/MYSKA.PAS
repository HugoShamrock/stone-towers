{$o-,f-,d-}
{********************************************}
{***            ovladani mysky            ***}
{*** (c) Josef Pelikan, KSVI MFF UK Praha ***}
{********************************************}

unit myska;

interface

{*****************************}
{***      mysi preruseni   ***}
{*****************************}

const int_mysky = 51;

{********************************}
{***          instalace       ***}
{********************************}

var  je_myska : boolean;
     pocet_tlacitek : word;

{**************************************}
{***       graficky mysi kurzor     ***}
{**************************************}

type  g_kurzor = array [ 0 .. 1, 0 .. 15 ] of word;

{***********************************}
{***       inicializace mysky    ***}
{***********************************}

procedure init_mysky ( karta : integer );

{***********************************}
{***         ukazani mysky       ***}
{***********************************}

procedure ukaz_mysku;

{***********************************}
{***          skryti mysky       ***}
{***********************************}

procedure schovej_mysku;

{***********************************}
{***         pozice mysky        ***}
{***********************************}

procedure pozice_mysky ( var x, y : word; var tl1, tl2, tl3 : boolean );

{***********************************}
{***         nastav mysku        ***}
{***********************************}

procedure nastav_mysku ( x, y : word );

{***********************************}
{***    cisla mysich tlacitek    ***}
{***********************************}

const leve_tlacitko = 0;
      prave_tlacitko = 1;
      prostredni_tlacitko = 2;

{***********************************}
{***         stisk mysky         ***}
{***********************************}

procedure stisk_mysky ( co : word; var kolik, x, y : word );

procedure reset_stisku;

{***********************************}
{***        pusteni mysky        ***}
{***********************************}

procedure pusteni_mysky ( co : word; var kolik, x, y : word );

{***********************************}
{***       hranice pro mysku     ***}
{***********************************}

procedure hranice_mysky ( x1, y1, x2, y2 : word );

{***********************************************}
{***       nastaveni grafickeho kurzoru      ***}
{***********************************************}

procedure nastav_g_kurzor ( hsx, hsy : integer; var c );

procedure nastav_sipku;

procedure nastav_hodinky;

procedure nastav_ihodinky;

procedure nastav_kriz;

procedure nastav_xkriz;

procedure nastav_otaznik;

{*****************************************}
{***      relativni pozice mysky       ***}
{*****************************************}

procedure relativni_pozice_mysky ( var x, y : integer );

{*****************************************}
{***           mickey/mouse            ***}
{*****************************************}

procedure mickey_mouse ( x, y : word );

{*************************************************}
{***       skryti mysky v zadane oblasti       ***}
{*************************************************}

procedure schovej_mysku_v ( x1, x2, y1, y2 : word );

{*******************************************}
{***      dvojnasobna rychlost mysky     ***}
{*******************************************}

{procedure dvoj_rychlost_mysky ( k : word );}

{*******************************************}
{***               preruseni             ***}
{*******************************************}

procedure cli;
inline($fa);

procedure sti;
inline($fb);

{**********************************************************************}

implementation

uses  Dos, Graph;

{*************************}
{***        sipka      ***}
{*************************}

const k_sipka : g_kurzor = ( ( $3fff, $1fff, $0fff, $07ff,
                               $03ff, $01ff, $00ff, $007f,
                               $003f, $001f, $001f, $00ff,
                               $30ff, $f87f, $f87f, $fc7f ),

                             ( $0000, $4000, $6000, $7000,
                               $7800, $7c00, $7e00, $7f00,
                               $7f80, $7fc0, $7c00, $4600,
                               $0600, $0300, $0300, $0000 ) );
      x_sipka = 0; y_sipka = 0; { 'hot spot' }

{*************************}
{***        kriz       ***}
{*************************}

const k_kriz : g_kurzor = ( ( $ffff, $ffff, $ffff, $ffff,
                              $ffff, $ffff, $ffff, $ffff,
                              $ffff, $ffff, $ffff, $ffff,
                              $ffff, $ffff, $ffff, $ffff ),

                            ( $0100, $0100, $0100, $0100,
                              $0100, $0000, $0000, $f93e,
                              $0000, $0000, $0100, $0100,
                              $0100, $0100, $0100, $0000 ) );
      x_kriz = 7; y_kriz = 7; { 'hot spot' }

{*************************}
{***      x-kriz       ***}
{*************************}

const k_xkriz : g_kurzor = ( ( $ffff, $ffff, $ffff, $ffff,
                               $ffff, $ffff, $ffff, $ffff,
                               $ffff, $ffff, $ffff, $ffff,
                               $ffff, $ffff, $ffff, $ffff ),

                             ( $0000, $4004, $2008, $1010,
                               $0820, $0000, $0000, $0100,
                               $0000, $0000, $0820, $1010,
                               $2008, $4004, $0000, $0000 ) );
      x_xkriz = 7; y_xkriz = 7; { 'hot spot' }

{*************************}
{***      hodinky      ***}
{*************************}

const k_hodinky : g_kurzor = ( ( $f839, $e008, $c004, $8003,
                                 $8003, $0001, $0001, $0001,
                                 $0001, $0001, $8003, $8003,
                                 $c007, $e00f, $f83f, $ffff ),

                               ( $07c6, $1ff7, $383b, $600c,
                                 $600c, $c006, $c006, $df06,
                                 $c106, $c106, $610c, $610c,
                                 $3838, $1ff0, $07c0, $0000 ) );
      x_hodinky = 8; y_hodinky = 8; { 'hot spot' }

{*********************************}
{***     inverzni hodinky      ***}
{*********************************}

const k_ihodinky : g_kurzor = ( ( $f839, $e008, $c004, $8003,
                                  $8003, $0001, $0001, $0001,
                                  $0001, $0001, $8003, $8003,
                                  $c007, $e00f, $f83f, $ffff ),

                                ( $0000, $0000, $07c0, $1ff0,
                                  $1ff0, $3ff8, $3ff8, $20f8,
                                  $3ef8, $3ef8, $1ef0, $1ef0,
                                  $07c0, $0000, $0000, $0000 ) );

{************************}
{***     otazn¡k      ***}
{************************}

const k_otaznik : g_kurzor =  ( ( $ffff, $c0ff, $807f, $987f,
                                  $fc7f, $f87f, $e0ff, $c3ff,
                                  $c7ff, $c7ff, $c7ff, $ffff,
                                  $c7ff, $c7ff, $c7ff, $ffff ),

                                ( $0000, $3e00, $6700, $0300,
                                  $0300, $0600, $1800, $3000,
                                  $3000, $3000, $0000, $0000,
                                  $3000, $3000, $0000, $0000 ) );
      x_otaznik = 5; y_otaznik = 5; { 'hot spot' }

{***********************************}
{***      volani mysi sluzby     ***}
{***********************************}

procedure volani_mysky ( sluzba : byte; var par1, par2, par3, par4 : word );
var  r : registers;
begin
 r.ax:=sluzba; r.bx:=par2;
 r.cx:=par3; r.dx:=par4;
 intr(int_mysky,r);
 par1:=r.ax; par2:=r.bx;
 par3:=r.cx; par4:=r.dx;
end; { volani_mysky }

{***********************************}
{***       inicializace mysky    ***}
{***********************************}

procedure init_mysky ( karta : integer );
var  ok, dummy : word;
begin
 if karta=HercMono then mem[$0:$449]:=6;
  { kvuli mysce (A.C.Novak na MOPu) }
 je_myska:=(memw[0:int_mysky*2] or memw[0:int_mysky*2+1])>0;
 if je_myska then
  volani_mysky(0,ok,pocet_tlacitek,dummy,dummy);
 je_myska:=je_myska and (ok>0);
end; { init_mysky }

{***********************************}
{***         ukazani mysky       ***}
{***********************************}

procedure ukaz_mysku;
var d : word;
begin
 volani_mysky(1,d,d,d,d);
end; { ukaz_mysku }

{***********************************}
{***          skryti mysky       ***}
{***********************************}

procedure schovej_mysku;
var d : word;
begin
 volani_mysky(2,d,d,d,d);
end; { schovej_mysku }

{***********************************}
{***         pozice mysky        ***}
{***********************************}

procedure pozice_mysky ( var x, y : word; var tl1, tl2, tl3 : boolean );
var d, tl : word;
begin
 volani_mysky(3,d,tl,x,y);
 tl1:=odd(tl); tl2:=odd(tl shr 1); tl3:=odd(tl shr 2);
end; { pozice_mysky }

{***********************************}
{***         nastav mysku        ***}
{***********************************}

procedure nastav_mysku ( x, y : word );
var d : word;
begin
 volani_mysky(4,d,d,x,y);
end; { nastav_mysku }

{***********************************}
{***         stisk mysky         ***}
{***********************************}

procedure stisk_mysky ( co : word; var kolik, x, y : word );
var tl : word;
begin
 kolik:=co;
 volani_mysky(5,tl,kolik,x,y);
end; { stisk_mysky }

procedure reset_stisku;
var d : word;
begin
 stisk_mysky(leve_tlacitko,d,d,d);
 pusteni_mysky(leve_tlacitko,d,d,d);
 stisk_mysky(prave_tlacitko,d,d,d);
 pusteni_mysky(prave_tlacitko,d,d,d);
end; { reset_stisku }

{***********************************}
{***        pusteni mysky        ***}
{***********************************}

procedure pusteni_mysky ( co : word; var kolik, x, y : word );
var tl : word;
begin
 kolik:=co;
 volani_mysky(6,tl,kolik,x,y);
end; { pusteni_mysky }

{***********************************}
{***       hranice pro mysku     ***}
{***********************************}

procedure hranice_mysky ( x1, y1, x2, y2 : word );
var d : word;
begin
 volani_mysky(7,d,d,x1,x2);
 volani_mysky(8,d,d,y1,y2);
end; { hranice_mysky }

{***********************************************}
{***       nastaveni grafickeho kurzoru      ***}
{***********************************************}

procedure nastav_g_kurzor ( hsx, hsy : integer; var c );
var r : registers;
begin
 r.ax:=9; r.bx:=word(hsx);
 r.cx:=word(hsy); r.dx:=ofs(c); r.es:=seg(c);
 intr(int_mysky,r);
end; { nastav_g_kurzor }

procedure nastav_sipku;
begin
 nastav_g_kurzor(x_sipka,y_sipka,k_sipka);
end; { nastav_sipku }

procedure nastav_hodinky;
begin
 nastav_g_kurzor(x_hodinky,y_hodinky,k_hodinky);
end; { nastav_hodinky }

procedure nastav_ihodinky;
begin
 nastav_g_kurzor(x_hodinky,y_hodinky,k_ihodinky);
end; { nastav_ihodinky }

procedure nastav_kriz;
begin
 nastav_g_kurzor(x_kriz,y_kriz,k_kriz);
end; { nastav_kriz }

procedure nastav_xkriz;
begin
 nastav_g_kurzor(x_xkriz,y_xkriz,k_xkriz);
end; { nastav_kriz }

procedure nastav_otaznik;
begin
 nastav_g_kurzor(x_otaznik,y_otaznik,k_otaznik);
end; { nastav_otaznik }

{*****************************************}
{***      relativni pozice mysky       ***}
{*****************************************}

procedure relativni_pozice_mysky ( var x, y : integer );
var d : word;
    xx : word absolute x;
    yy : word absolute y;
begin
 volani_mysky(11,d,d,xx,yy);
end; { relativni_pozice_mysky }

{*****************************************}
{***           mickey/mouse            ***}
{*****************************************}

procedure mickey_mouse ( x, y : word );
var d : word;
begin
 volani_mysky(15,d,d,x,y);
end; { mickey_mouse }

{*************************************************}
{***       skryti mysky v zadane oblasti       ***}
{*************************************************}

procedure schovej_mysku_v ( x1, x2, y1, y2 : word );
var r : registers;
begin
 r.ax:=16;
 r.cx:=x1; r.si:=x2;
 r.dx:=y1; r.di:=y2;
 intr(int_mysky,r);
end; { schovej_mysku_v }

{*******************************************}
{***      dvojnasobna rychlost mysky     ***}
{*******************************************}

procedure dvoj_rychlost_mysky ( k : word );
var d : word;
begin
 volani_mysky(19,d,d,d,k);
end; { dvoj_rychlost_mysky }

end. { myska }
