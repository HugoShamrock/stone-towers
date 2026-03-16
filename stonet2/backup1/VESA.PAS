UNIT VESA;   { by ¯The Faker® in 1993 }

INTERFACE

TYPE
    String0=ARRAY[1..255] OF Char;
    String0Ptr=^String0;
    WordArray=ARRAY[0..255] OF Word;
    VESABlockType=RECORD
                        VESASignature:ARRAY[0..3] OF Char;
                        VESAVersion:Word;
                        OEMStringPtr:String0Ptr;
                        Capabilities:ARRAY[0..3] OF Byte;
                        VideoModePtr:^WordArray;
                        Dummy:ARRAY[0..237] OF Byte;
                  END;
    VESAInfoType=RECORD
                       ModeAttr:Word;
                       WinAAttr:Byte;
                       WinBAttr:Byte;
                       WinGranularity:Word;
                       WinSize:Word;
                       WinASegment:Word;
                       WinBSegment:Word;
                       WinFuncPtr:Pointer;
                       BytesPerScanLine:Word;
                       XRes:Word;
                       YRes:Word;
                       XCharSize:Byte;
                       YCharSize:Byte;
                       NumberOfPlanes:Byte;
                       BitsPerPixel:Byte;
                       NumberOfBanks:Byte;
                       MemoryModel:Byte;
                       BankSize:Byte;
                       Dummy:ARRAY[0..226] OF Byte;
                 END;
VAR
   VESABlock:^VESABlockType;

FUNCTION VESAInstalled:Boolean;

FUNCTION VESAVersion:Word;

FUNCTION OEMString:String;

FUNCTION VESAModeExist(ModeNr:Word):Boolean;

PROCEDURE VESAGetModeInfo(ModeNr:Word; VAR VESAInfo:VESAInfoType);

PROCEDURE VESASetBank(BankNr:Word);

PROCEDURE VESASetMode(ModeNr:Word);

IMPLEMENTATION

FUNCTION VESAInstalled:Boolean;
VAR
   Status:Word;
BEGIN
     GetMem(VESABlock,256);
     ASM
        mov di,word ptr vesablock
        mov es,word ptr vesablock+2
        mov ax,$4f00
        int $10
        mov status,ax
     END;
     VESAInstalled:=Status=$4F;
END;

FUNCTION VESAVersion:Word;
BEGIN
     VESAVersion:=VESABlock^.VESAVersion;
END;

FUNCTION OEMString:String;
VAR
   I:Word;
   S:String;
BEGIN
     I:=0;
     REPEAT
           Inc(I);
           S[I]:=VESABlock^.OEMStringPtr^[I];
     UNTIL (S[I]=#0) OR (I=255);
     S[0]:=Chr(I-1);
     OEMString:=S;
END;

FUNCTION VESAModeExist(ModeNr:Word):Boolean;
VAR
   I:Byte;
BEGIN
     VESAModeExist:=TRUE;
     I:=0;
     WITH VESABlock^ DO
     BEGIN
          WHILE VideoModePtr^[I]<>$FFFF DO
          BEGIN
               IF VideoModePtr^[I]=ModeNr THEN
                  Exit;
               Inc(I);
          END;
     END;
     VESAModeExist:=FALSE;
END;

PROCEDURE VESAGetModeInfo(ModeNr:Word; VAR VESAInfo:VESAInfoType);
BEGIN
     ASM
        les di,vesainfo
        mov cx,modenr
        mov ax,$4f01
        int $10
    END;
END;

PROCEDURE VESASetBank(BankNr:Word);
BEGIN
     ASM
        mov ax,$4f05
        xor bx,bx
        mov dx,banknr
        int $10
     END;
END;

PROCEDURE VESASetMode(ModeNr:Word);
BEGIN
     ASM
        mov ax,$4f02
        mov bx,modenr
        int $10
     END;
END;

END.
