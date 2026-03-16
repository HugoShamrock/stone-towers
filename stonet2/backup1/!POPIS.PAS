{ lostGFX v1.3 640x480x256 | (c)1998 WIZard Raist  }

{$G+}

var virtx,virty:word; {nastaveni (rozpalu) virt.obrazovky}
    F16ofs,F16seg,F8Seg,F8Ofs  : word; {pro bios font}

  procedure Init640x480x256;   {prepne grafarnu do modu 640x480x256 (4f02h)}
  procedure InitText;          {prepne na text rezim}
  {procedure SetVirtObr(x:word);{rozpal pixelu}
  {procedure SetBank(w:word);   {nastaveni akt.banky}
  Procedure Wait4Retrace;            {waitforretrace pro monitor}
  procedure LoadPal(jm:PathStr;posuns:word); {nacte paletu; posuns=0 pro COL,
                                                            posuns=32 pro CEL}

  procedure Paint(x,y:word;src:pointer); {vykresli bufr na screen (pointer)}
  {procedure PutIcoK(x,y,vx,vy,r:word;src:pointer;t:byte); {universalni}
  {procedure GetIco(x,y,vx,vy,r:word;src:pointer); {vezme ico}
  Procedure PutTrans(odkud,kam:pointer);{vykresli vyklicovany odkud do kam bufru (pointer)}
  Procedure PutTransCFG(PixelX,PixelY,sizex,sizey,keycolor:word;odkud,kam:pointer);
            {vykresli vyklicovany odkud do kam bufru (pointer) konfigurovatelne}
            {pixelx,pixely:pozice leveho horniho rohu(proste kam se to vykresli)
             sizex,sizey:velikost buffru, keycolor: barva pro transparenci(vyklicovani)}
  procedure cls (Where:word;Col : Byte); {smaze where (seg bufru) barvou}
  procedure Flip(Source, Dest : Word); {zkopiruje obsah source do dest (seg bufru)}

  procedure PutPixel(X,Y:Integer;Col:Byte;Where:Word); {pixel(do bufru)}
  function Getpixel (X,Y : Integer; where:word):byte; {vezme pixel(z bufru)}
  procedure getfont8x16; {grabne font 8x16 do promenych (zatim do wordu,tudiz kazi bufry)}
  procedure getfont8x8; {grabne font 8x8 do promenych   (  --"-- )}
  procedure outtext(x,y:integer;color,font:byte;retezec:string;kamasi:word);
            {vypise (do bufru) retezec textu na x,y barvy color velikosti font (8,16)}




