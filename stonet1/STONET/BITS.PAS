{************************************************}
{***           bitovy vstup/vystup            ***}
{***  (c) 1993 J. Pelikan, KSVI MFF UK Praha  ***}
{************************************************}

unit Bits;

interface


{******************************************************}
{***   bitovy vstup/vystup z/do binarniho souboru   ***}
{******************************************************}

type
     BinaryFile = file;

     PBinaryFile = ^BinaryFile;


     BitFile = object

                 Out : boolean; { vystup? }


                 constructor AssignFile ( PFile : PBinaryFile;
                                          Output : boolean );
                   { vstupni/vystupni soubor (jiz otevreny) a priznak,
                     jedna-li se o vystup }


                 function GetBits ( var B : word; Len : byte ) : boolean;
                   { precte ze vstupu 'Len' bitu a vrati je ve slove 'B',
                     vrati true, jestlize jsou data platna (nebyl EOF=blok
                     nulove delky) }

                 procedure Reset;
                   { nastavi pocatecni stav pro cteni }


                 procedure PutBits ( B : Word; Len : byte );
                   { zapise na vystup 'Len' bitu ze slova 'B' }

                 procedure Flush;
                   { ukonci rozdelany blok a zapise ho na vystup.
                     Pokud je blok prazdny, zapise ho take! }


                 procedure FinishBlock;
                   { preskoci vsechny bloky az po blok nulove delky }


                 destructor DoneFile;
                   { ukoncuje praci se souborem, ale nezavira ho
                     (pri vystupu zapise posledni nulovy blok) }


               private

                 PF : PBinaryFile; { I/O soubor }

                 Buffer : array [ byte ] of byte;
                 BufferLen : byte; { pocet bytu v Bufferu }
                 BufferPtr : byte; { dalsi nezpracovany byte z Bufferu }
                 BPtr : ^word; { -> dalsi nezpracovane slovo }

                 Buf : word; { zpracovavane slovo }
                 BufLen : byte; { pocet bitu odzdola v Buf }


                 procedure FlushBuffer;
                   { zapise do souboru obsah Bufferu }

               end;


{*********************************************************************}

implementation


{******************************************************}
{***   bitovy vstup/vystup z/do binarniho souboru   ***}
{******************************************************}


constructor BitFile.AssignFile ( PFile : PBinaryFile;
                                 Output : boolean );
  { vstupni/vystupni soubor (jiz otevreny) a priznak,
    jedna-li se o vystup }
begin
  PF := PFile;
  Out := Output;
  Reset;
end; { BitFile.AssignFile }


procedure BitFile.Reset;
begin
  BufferLen := 0; BufferPtr := 0; BPtr := @Buffer;
  Buf := 0; BufLen := 0;
end; { BitFile.Reset }


function BitFile.GetBits ( var B : word; Len : byte ) : boolean;
  { precte ze vstupu 'Len' bitu a vrati je ve slove 'B',
    vrati true, jestlize jsou data platna (nebyl EOF=blok
    nulove delky) }
var  BLen : byte;
     Re : byte;
     BPtrOffset : word absolute BPtr;
begin
  B := 0; BLen := 0;
  repeat { ctu z jednoho vstupniho bytu }
    if BufLen=0 then
      begin { dalsi vstupni byte }
        if BufferPtr=BufferLen then
          begin { dalsi blok }
            BlockRead(PF^,BufferLen,1); { prectu delku }
            if BufferLen=0 then
              begin { prazdny blok => konec }
                GetBits := false;
                exit;
              end;
            BlockRead(PF^,Buffer,BufferLen); { prectu blok }
            BufferPtr := 0; BPtr := @Buffer;
          end;
        Buf := BPtr^;
        Inc(BufferPtr);
        if BufferPtr=BufferLen then
          begin
            BufLen := 8;
            Buf := Buf and $ff;
          end                  else
          begin
            Inc(BufferPtr);
            BufLen := 16;
          end;
        Inc(BPtrOffset,2);
      end; { dalsi vstupni byte }
    Re := Len-BLen;
    if BufLen<Re then Re := BufLen;
    Inc(B,word(Buf) shl BLen);
    Inc(BLen,Re);
    Dec(BufLen,Re);
    if BufLen>0 then Buf := Buf shr Re;
  until BLen=Len;
  B := B and pred(1 shl Len);
  GetBits := true;
end; { BitFile.GetBits }


procedure BitFile.FlushBuffer;
begin
  BlockWrite(PF^,BufferLen,1);
  if BufferLen>0 then
    BlockWrite(PF^,Buffer,BufferLen);
  BufferLen := 0; BPtr := @Buffer;
end; { BitFile.FlushBuffer }


procedure BitFile.PutBits ( B : Word; Len : byte );
  { zapise na vystup 'Len' bitu ze slova 'B' }
var  BPtrOffset : word absolute BPtr;
     Wr : byte;
begin
  repeat { zapis do jednoho vystupniho bytu }
    if BufLen=16 then
      begin { zapis slova }
        if BufferLen=254 then FlushBuffer;
        BPtr^ := Buf;
        Buf := 0;
        Inc(BufferLen,2);
        Inc(BPtrOffset,2);
        BufLen := 0;
      end;
    Inc(Buf,B shl BufLen);
    Wr := 16-BufLen;
    if Len>Wr then
      begin
        Dec(Len,Wr);
        B := B shr Wr;
        BufLen := 16;
      end     else
      begin
        Inc(BufLen,Len);
        Len := 0;
      end;
  until Len=0;
end; { BitFile.PutBits }


procedure BitFile.Flush;
  { ukonci rozdelany blok a zapise ho na vystup.
    Pokud je blok prazdny, zapise ho take! }
begin
  if (BufferLen=254) and (BufLen>0) then FlushBuffer;
  if BufLen>0 then
    begin
      BPtr^ := Buf;
      Inc(BufferLen);
      if BufLen>8 then Inc(BufferLen);
    end;
  Buf := 0;
  BufLen := 0;
  FlushBuffer;
end; { BitFile.Flush }


procedure BitFile.FinishBlock;
  { preskoci vsechny bloky az po blok nulove delky }
begin
  BlockRead(PF^,BufferLen,1); { delka bloku }
  while BufferLen>0 do
    begin
      Seek(PF^,FilePos(PF^)+BufferLen);
      BlockRead(PF^,BufferLen,1);
    end;
end; { BitFile.FinishBlock }


destructor BitFile.DoneFile;
  { ukoncuje praci se souborem, ale nezavira ho
    (pri vystupu zapise posledni nulovy blok) }
begin
  if Out then
    begin
      Flush; Flush;
    end;
  PF := nil;
end; { BitFile.DoneFile }


end. { Bits }
