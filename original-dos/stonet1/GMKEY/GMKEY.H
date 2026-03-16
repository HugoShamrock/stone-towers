/******************************************************************
 *  GMKEY.H  :  Rozsireni funkci "ReadKey" a "KeyPressed"         *
 *              na rizeni pomoci mysi ovladane ovladacem          *
 *              GMOUSE (Mouse Systems, Genius Mouse).             *
 *                                                                *
 *  ing.Jiri ZARA, CSc.                                   29.9.91 *
 ******************************************************************


Informace:
---------
 Funkce "ReadKey" a "KeyPressed" lze pouzivat jak pro vstup z klavesnice
 tak pro mys. Pohyb mysi je prezentovan jako stisk klaves se sipkami (vlevo,
 vpravo, nahoru, dolu). Navratove kody tlacitek mysi lze programove definovat,
 stejne jako rychlost generovani kodu odpovidajicich klavesam se sipkami. Pri
 soucasnem pohybu mysi a stisku klavesnice ma klavesnice prednost. V pripade
 nepritomnosti mysi ovladaji uvedene dve funkce pouze klavesnici.

/************************************************************************/


extern int kazdaakce;          /* Je-li 1, pak i pohyb mysi je chapan funkci
                                  "keypressed" jako stisk klaves, jinak
                                  jsou na mysi akceptovana pouze tlacitka */

extern int z_klaves;           /* 1, pokud byla stisknuta klavesnice */

extern int mys_zije;           /* 1, pokud je pripojen ovladac mysi,
                                  0, pokud neni */

unsigned char readkey(void);   /* Vraci bud kod stisknute klavesy na klaves-
                                  nici, nebo kod generovany tlacitkem mysi,
                                  nebo kod klaves se sipkami, byla-li mys
                                  posunuta.*/

int keypressed(void);          /* Nabyva hodnoty 1, byla-li stisknuta kla-
                                  vesa na klavesnici, nebo tlacitko mysi.
                                  Pohyb mysi je touto funkci registrovan, jen
                                  kdyz je nastavena promenna "kazdakce"
                                  na nenulovou hodnotu. */

void tlacitko  ( int cislo_tlacitka,
                 unsigned char prvni_ASCII_kod,
                 unsigned char druhy_ASCII_kod);
                               /* Funkce pro programove definovani kodu,
                                  ktere budou generovany pri stisku tlacitka
                                  mysi. Parametr "druhy_ASCII_kod" ma vyznam
                                  jen tehdy, kdyz parametr "prvni_ASCII_kod"
                                  je roven nule. V takovem pripade jsou pri
                                  stisku tlacitka postupne generovany oba
                                  kody (podobne jako u klaves F1 - F10
                                  na klavesnici, apod.). */

void krokovani ( int pocet_kroku_vodorovne,
                 int pocet_kroku_svisle);
                               /* Funkce pro nastaveni rychlosti generova-
                                  ni kodu klaves se sipkami pri pohybu mysi.
                                  Pocet_kroku_na 1 znak musi byt kladny a
                                  mensi nez 100.
                                  Tato funkce zaroven nuluje vnitrni
                                  citace polohy mysi, je tedy jakousi
                                  inicializaci polohy mysi */

/* Poznamka:
   --------

 Impicitni nastaveni promennych v GMKEY je nasledujici:
                   tlacitko  (1, 13, 0);    // leve tlacitko    =  ENTER
                   tlacitko  (2,' ', 0);    // stredni tlacitko =  SPACE
                   tlacitko  (3, 27, 0);    // prave tlacitko   =  ESCAPE
                   krokovani (8,16);
                   kazdaakce = 0;

/*********************** End of GMKEY.H ***********************************/