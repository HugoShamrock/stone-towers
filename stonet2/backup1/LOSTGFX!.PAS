{ lostGFX v1.3 640x480x256 | (c)1998 WIZard Raist  }

var virtx,virty:word; {nastaveni (rozpalu) virt.obrazovky}
    F16ofs,F16seg,F8Seg,F8Ofs  : word; {pro bios font}

  procedure Init640x480x256;   {prepne grafarnu do modu 640x480x256 (4f02h)}
  procedure InitText;          {prepne na text rezim}
  procedure SetVirtObr(x:word);{rozpal pixelu}
  procedure SetBank(w:word);   {nastaveni akt.banky}
  Procedure Pockej;            {waitforretrace pro monitor}
  procedure naspal(jm:string); {nacte paletu}

  procedure PutIco(x,y,vx,vy,r:word;src:pointer); {vykresli ico}
  procedure PutIcoK(x,y,vx,vy,r:word;src:pointer;kam:word;t:byte);
           {vykresli ico s klicovanim barvy t do kam ($a000 nebo seg na bufr)}
  procedure GetIco(x,y,vx,vy,r:word;src:pointer); {vezme ico}

  procedure puttrans(x,y,odkud,kam:word);
  {vykresli klicovane obsah odkud do kam}

  procedure Flip(Source, Dest : Word); {zkopiruje obsah mezi source a dest (bufry)}
  procedure PutPixel(X,Y:Integer;Col:Byte;Where:Word); {pixel(do bufru)}
  function Getpixel (X,Y : Integer; where:word):byte; {vezme pixel(z bufru)}
  procedure cls (Where:word;Col : Byte); {smaze (bufr)}
  procedure getfont8x16; {grabne font 8x16 do promenych}
  procedure getfont8x8; {grabne font 8x8 do promenych}
  procedure outtext(x,y:integer;color,font:byte;retezec:string;kamasi:word);
            {vypise (do bufru) retezec textu na x,y barvy color velikosti font (8,16)}




