unit VesaType;
interface

type  VesaInf=record
                Napis:array [1..4] of char;
                verze:word;
                oem1:word;
                oem2:word;
                schop:array [1..4] of char;
                rezim1:word;
                rezim2:word;
                rezererva:array [1..238] of char;
              end;

      ModeInf=record
                Atr:word;{ atributy re§imu}
                         {     bit 0: re§im podporov n}
                         {     bit 1: dodateŸn‚ informace k dispozici (od ofsetu 18)}
                         {     bit 2: podporov ny standardn¡ slu§by BIOSu (vìstup znaku,...)}
                         {     bit 3: 1=barevnì, 0=monochromatickì}
                         {     bit 4: 1=grafickì, 0=textovì}
                AtrOkA:byte;{ atributy okna A}
                            {     bit 0: existuje}
                            {     bit 1: Ÿiteln‚}
                            {     bit 2: zapisovateln‚}
                            {     bity 3-7 rezervov ny}
                AtrOkB:byte;{ atributy okna B (jako okno A)}
                Granularita:word;{ granularita okna v KB (nejmenç¡ ofset, o kterì m…§e bìt mØnØn}
                                 {  ofset poŸ tku okna)}
                VelOk:word;{ velikost okna v KB (nejvØtç¡ ofset, ke kter‚mu m…§e procesor pıi-}
                           { stupovat v r mci okna)}
                PocSegOkA:word;{ poŸ teŸn¡ segment okna A (obvykle A000h)}
                PocSegOkB:word;{ poŸ teŸn¡ segment okna B}
                OfsFunc:word;
                SegFunc:word;{ FAR adresa funkce pro um¡stØn¡ okna (ekvivalent AX=4F05h)}
                             { Slou§¡ pro rychlejç¡ vol n¡ ne§ pıes BIOS. Nevrac¡ status v AX.}
                PocBytuNaR:word;{ byt… na scanovì ı dek}
                                { ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
                                { ³  dalç¡ blok pou§¡vaj¡ vìrobci k popisu re§im…, kter‚ nejsou}
                                { ³  pı¡mou souŸ st¡ VESA standardu (plat¡, je-li bit 1 na ofsetu 0}
                                { ³  nastaven)}
                                { ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
                Sirka:word;{ ç¡ıka v pixelech (grafick‚ re§imy) nebo znac¡ch (textov‚ re§imy)}
                Vyska:word;{ vìçka v pixelech (grafick‚ re§imy) nebo znac¡ch (textov‚ re§imy)}
                SirkaZnaku:byte;{ ç¡ıka znakov‚ buåky v pixelech}
                VyskaZnaku:byte;{ vìçka znakov‚ buåky v pixelech}
                PocPamRovin:byte;{ poŸet pamØœovìch rovin}
                PocBitNaPix:byte;{ poŸet bit… na pixel (urŸuje poŸet mo§nìch barev)}
                PocBank:byte;{ poŸet bank… (v neobvyklìch re§imech jsou po sobØ jdouc¡ ı dky}
                             { ulo§eny v r…znìch pamØœovìch bank ch (napı. CGA stı¡d  sud‚-lich‚).}
                             { Pro tento mod tedy plat¡ hodnota 2. VØtçina bØ§nìch mod… m  0}
                             { (= banky se nepou§¡vaj¡).}
                PamModel:byte;{ typ pamØœov‚ho modelu:}
                              {     0 text}
                              {      1 CGA grafika (2 banky)}
                              {      2 Hercules grafika (4 banky)}
                              {      3 EGA 16 barev (4 bitov‚ roviny)}
                              {      4 pakovan‚ pixely (1 bit=1 pixel)}
                               {      5 256 barev - 4 nezıetØzen‚ roviny}
                              {      6 pı¡mì 15/16/24 bit…}
                              {      7 YUV}
                              {      8-0Fh rezervov no pro VESA}
                VelBank:byte;{ velikost banku v K}
                {-------- Vesa BIOS rozç¡ıen¡ 1.1  ---------------}
                PocStranek:byte;{ poŸet obrazovìch str nek}
                rez1:byte;{ rezervov no (0)}
                {-------- Vesa BIOS rozç¡ıen¡ 1.2+ ---------------}
                VelMaskR:byte;{ velikost masky Ÿerven‚}
                PozMaskR:byte;{ pozice masky Ÿerven‚}
                VelMaskG:byte;{ velikost masky zelen‚}
                PozMaskG:byte;{ pozice masky zelen‚}
                VelMaskB:byte;{ velikost masky modr‚}
                PozMaskB:byte;{ pozice masky modr‚}
                VelMaskRez:byte;{ velikost rezervovan‚ masky}
                PozMaskRez:byte;{ pozice rezervovan‚ masky}
                InfDirScr:byte;{ informace o re§imu direct-screen}
                rez2:byte;{ rezervov no (0)}
                rez3:array [1..216] of byte;
              end;

const ON=$0;
      STAND=$1;
      SUSP=$2;
      OFF=$4;
      REDON=$8;

implementation
end.
