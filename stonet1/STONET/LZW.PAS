{*************************************************}
{***    LZW kodovani pro GIF format obrazku    ***}
{***  (c) 1993 J. Pelikan, KSVI MFF UK Praha   ***}
{*************************************************}
{$undef asm}

unit LZW;

interface


uses  Bits;


const MaxLZWBits = 12; { maximalni velikost adresy v kodovaci tabulce }

      MaxLZWSize = 1 shl MaxLZWBits; { maximalni velikost kodovaci tabulky }


{***************************************************************}
{***   tabulka retezcu pro komprimaci (Lempel, Ziv, Welch)   ***}
{***************************************************************}

type  LZWItem = record

                  Val : byte;
                    { posledni znak retezce }

                  Dalsi : integer;
                    { ukazatel na dalsi zakonceni (vystup) nebo predchozi
                      znak (vstup) }

                  Delsi : integer;
                    { ukazatel na prvni delsi retezec (jehoz je tento prefixem) }

                end;

      LZWTable = array [ 0 .. pred(MaxLZWSize) ] of LZWItem;


{******************************************}
{***   zasobnik pro rychle dekodovani   ***}
{******************************************}

type  Stack = array [ 0 .. pred(MaxLZWSize) ] of byte;

      PStack = ^Stack;



{**********************************************************}
{***   LZW kodovani/dekodovani do/z binarniho souboru   ***}
{**********************************************************}


type  LZWCode = object ( BitFile )


                  constructor InitEncode ( BitsPerVal : byte;
                                           PFile : PBinaryFile );
                    { inicializuje LZW koder pro zadanou sirku dat (max 8)
                      a s vystupem do binarniho souboru (jiz otevreneho) }


                  constructor InitDecode ( BitsPerVal : byte;
                                           PFile : PBinaryFile );
                    { inicializuje LZW dekoder pro zadanou sirku dat (max 8)
                      a se vstupem z binarniho souboru (jiz otevreneho) }


                  procedure Reset;
                    { reset (de)koderu }


                  procedure PutValue ( Value : byte );
                    { zakoduje jeden znak }


                  procedure Flush;
                    { vyprazdni vystupni buffery }


                  function GetValue ( var Value : byte ) : boolean;
                    { dekoduje jeden znak a vrati true, je-li to OK,
                      pri EOF (prazdny vstupni blok) vrati false }


                  function GetValues ( var Values; Count : integer ) : boolean;
                    { nacte najednou 'Count' hodnot do bufferu 'Values',
                      vrati true, nebylo-li EOF }


                  destructor Done;
                    { skonci kodovani/dekodovani (nezavre soubor) }


                private

                    { spolecne promenne: }

                  Table : LZWTable; { tabulka retezcu }

                  IC : integer; { inicializacni kod }

                  FirstFree : integer; { prvni volna polozka tabulky }

                  Position : integer; { aktualni polozka tabulky }

                  StartWidth, Width : byte; { pocatecni a aktualni sirka }

                  State : byte; { stav koderu/dekoderu }


                    { jen pro dekodovani: }

                  PSt : PStack;

                  SP : integer;

                  FirstVal : byte;

                  Code, OldCode : word;


                  procedure InitTable;
                    { nastavi pocatecni tabulku (jednoznakove retezce) }


                  function ReadCode : boolean;
                    { cte IC (init code), IC+1 (exit code), pri jinem vstupu se odzadu
                      prohledava tabulka a hodnoty se zapisuji do zasobniku. Vraci true, je-li
                        vse OK }

                  procedure AddItem;

                end;


{**************************************************************************}

implementation


const INil = -1; { nil pro indexy v tabulce }


{**********************************************************}
{***   LZW kodovani/dekodovani do/z binarniho souboru   ***}
{**********************************************************}


constructor LZWCode.InitEncode ( BitsPerVal : byte;
                                 PFile : PBinaryFile );
  { inicializuje LZW koder pro zadanou sirku dat (max 8)
    a s vystupem do binarniho souboru (jiz otevreneho) }
begin
  BitFile.AssignFile(PFile,true);
  IC := word(1) shl BitsPerVal; { init code, exit code = IC + 1 }
  StartWidth := succ(BitsPerVal);
  InitTable;
  PSt := nil;
  State := 1; { cekam na prvni znak }
end; { LZWCode.InitEncode }


procedure LZWCode.InitTable;
var  i : integer;
begin
  FirstFree := IC+2;
  Width := StartWidth;
  for i := 0 to pred(IC) do
    with Table[i] do
      begin
        Val := i;
        Dalsi := INil; Delsi := INil;
      end;
  SP := MaxLZWSize; { prazdny buffer }
  FirstVal := 0;    { to by se nemelo pouzit }
  State := State or $80; { poprve nemuzu udelat AddItem }
end; { LZWCode.InitTable }


constructor LZWCode.InitDecode ( BitsPerVal : byte;
                                 PFile : PBinaryFile );
  { inicializuje LZW dekoder pro zadanou sirku dat (max 8)
    a se vstupem z binarniho souboru (jiz otevreneho) }
begin
  BitFile.AssignFile(PFile,false);
  New(PSt);
  IC := 1 shl BitsPerVal; { init code, exit code = IC + 1 }
  StartWidth := succ(BitsPerVal);
  State := 0; { OK }
  Reset;
end; { LZWCode.InitDecode }


procedure LZWCode.Reset;
  { reset (de)koderu }
begin
  if Out then Flush
         else BitFile.Reset;
  InitTable;
end; { LZWCode.Reset }


procedure LZWCode.PutValue ( Value : byte );
  { zakoduje jeden znak }
var  NewPos, PrevPos : integer;
begin
  Value := Value and byte(pred(IC));
  if Odd(State) then
    begin { uplne prvni znak }
      State := 0;
      Position := Value;
      PutBits(IC,Width); { slusnost }
      exit;
    end;
  NewPos := Table[Position].Delsi;
  PrevPos := INil;
  while NewPos<>INil do
    begin { hledam prodlouzeni }
      if Table[NewPos].Val=Value then
        begin { nasel }
          Position := NewPos;
          exit;
        end;
      PrevPos := NewPos;
      NewPos := Table[NewPos].Dalsi;
    end;
  { nenasel jsem ho => poslu akt.pozici a ten retezec pridam }
  PutBits(Position,Width);
  if FirstFree>=MaxLZWSize then
    begin { preplnena tabulka }
      PutBits(IC,Width);
      InitTable;
    end                    else
    begin { pridam novy retezec }
      with Table[FirstFree] do
        begin
          Val := Value;
          Dalsi := INil; Delsi := INil;
        end;
      if Table[Position].Delsi<>INil then
        Table[PrevPos].Dalsi := FirstFree { pokracovani retizku }
                                     else
        Table[Position].Delsi := FirstFree; { prvni prodlouzeni }
      Inc(FirstFree);
      if FirstFree>1 shl Width then Inc(Width);
        { vetsi delka kodu i velikost tabulky }
    end; { pridam novy retezec }
  Position := Value;
end; { LZWCode.PutValue }


procedure LZWCode.Flush;
  { vyprazdni vystupni buffery }
begin
  PutBits(Position,Width);
  PutBits(succ(IC),Width); { exit code }
  BitFile.Flush;
end; { LZWCode.Flush }


function LZWCode.ReadCode : boolean;
  { cte IC (init code), IC+1 (exit code), pri jinem vstupu se odzadu
    prohledava tabulka a hodnoty se zapisuji do zasobniku. Vraci true, je-li
    vse OK }
var  i : integer;
begin
  ReadCode := false;
  repeat
    OldCode := Code;
    if not GetBits(Code,Width) then exit;
    if Code=succ(IC) then
      begin
        State := State or 1;
        ReadCode := true;
        exit;
      end;
    if Code=IC then InitTable;
  until Code<>IC;
  {$ifdef asm}
  asm
       push ds
       lds si,[bp+6]         { ds:si -> Self }
       les di,[si+PSt]
       add di,MaxLZWSize     { es:di -> PSt^[SP] }
       mov ax,[si+Code]      { ax := Code }
       cmp ax,[si+FirstFree] { ax = i }
       jc @UzJe
       dec di                { dec(SP) }
       mov al,[si+FirstVal]
       mov [di],al           { PSt^[SP] := FirstVal }
       mov ax,[si+OldCode]   { ax = i }
@UzJe: and ax,ax
       js @Konec
       dec di                { dec(SP) }
       lea bx,[si+Table]
       add bx,ax             { bx := Offs(Table)+i }
       shl ax,2
       add bx,ax             { bx := Offs(Table)+5*i }
       mov al,[bx]
       mov es:[di],al        { PSt^[SP] := Table[i].Val }
       mov ax,[bx+1]         { i := Table[i].Dalsi }
       jmp @UzJe

@Konec:mov al,es:[di]
       mov [si+FirstVal],al  { FirstVal := PSt^[SP] }
       mov ax,word ptr [si+PSt] { ax := Offs(PSt^) }
       sub di,ax             { di := SP }
       mov word ptr [si+FirstVal-2],di { SP := SP }
       pop ds
       mov @Result,true
  end;
  {$else}
  SP := MaxLZWSize;
  if Code<FirstFree then i := Code { uz je v tabulce }
                    else
    begin
      Dec(SP);
      PSt^[SP] := FirstVal;
      i := OldCode;
    end;
  while i>=0 do { tenhle cyklus je kritickej na cas }
    begin
      Dec(SP);
      PSt^[SP] := Table[i].Val;
      i := Table[i].Dalsi;
    end;
  FirstVal := PSt^[SP];
  ReadCode := true;
  {$endif}
end; { LZWCode.ReadCode }


function LZWCode.GetValue ( var Value : byte ) : boolean;
  { dekoduje jeden znak a vrati true, je-li to OK,
    pri EOF (prazdny vstupni blok) vrati false }
begin
  GetValue := false;
  if State and $7f>0 then exit;
  repeat
    if SP<MaxLZWSize then
      begin { zbylo neco na stacku }
        State := State and $7f; { ted uz muzu udelat AddItem }
        Value := PSt^[SP];
        Inc(SP);
        GetValue := true;
        exit;
      end;
    if not ReadCode then exit;
    if FirstFree>=MaxLZWSize then
      begin
        State := State or 2;
        exit;
      end;
  until State and $80=0;
  AddItem;
  Value := PSt^[SP];
  Inc(SP);
  GetValue := true;
end; { LZWCode.GetValue }


procedure LZWCode.AddItem;
begin
  Table[FirstFree].Val := FirstVal;
  Table[FirstFree].Dalsi := OldCode;
  Inc(FirstFree);
  if FirstFree>=1 shl Width then Inc(Width);
  if FirstFree>=MaxLZWSize then Dec(Width); { tabulka je preplnena }
end; { LZWCode.AddItem }


function LZWCode.GetValues ( var Values; Count : integer ) : boolean;
  { nacte najednou 'Count' hodnot do bufferu 'Values',
    vrati true, nebylo-li EOF }
var  Re : integer;
     ValPtr : ^byte;
     PtrOffset : word absolute ValPtr;
begin
  GetValues := false;
  if State and $7f>0 then exit;
  ValPtr := @Values;
  repeat
    repeat
      if SP<MaxLZWSize then
        begin { neco mam na stacku }
          State := State and $7f; { dovolim AddItem }
          Re := MaxLZWSize-SP;
          if Re>Count then Re := Count;
          Move(PSt^[SP],ValPtr^,Re);
          Inc(SP,Re);
          Inc(PtrOffset,Re);
          Dec(Count,Re);
          if Count=0 then
            begin
              GetValues := true;
              exit;
            end;
        end; { neco mam na stacku }
      if not ReadCode then exit;
      if FirstFree>=MaxLZWSize then
        begin
          State := State or 2;
          exit;
        end;
    until State and $80=0;
    AddItem;
  until false;
end; { LZWCode.GetValues }


destructor LZWCode.Done;
  { skonci kodovani/dekodovani (nezavre soubor) }
begin
  if Out then
    begin
      Flush;
      BitFile.Flush; { posledni blok nulove delky }
    end  else
    begin
      FinishBlock; { doctu az po blok nulove delky }
      Dispose(PSt);
    end;
end; { LZWCode.Done }


end. { LZW }
