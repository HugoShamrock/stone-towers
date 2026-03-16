unit EMS;

interface

function EmsInstalled: Boolean;
function GetFreePages(var Allpages,FreePages:Word) : Byte;
procedure EMSError(Error:String);
procedure CheckError(A:Byte);
function AllocatePages(Pages:Word;var Handle:Word):Byte;
function MapPages(Handle,LogicalPage:Word;PhysicalPage:Byte):Byte;
function DeAllocatePages(Handle:Word):Byte;
function GetAddress(var Address:Word):Byte;

implementation
uses DOS;



procedure EMSError(Error:String);
begin
  asm mov ax,3h;int 10h;end;
  Writeln(#7+'Chyba EMS : '+Error);
  Halt(1);
end;






function EmsInstalled: Boolean;
var Emm_Device_Name   : string[8];
    Int_67_Device_Name: string[8];
    Position          : integer;
    Regs              : registers;

begin
  Int_67_Device_Name := '';
  Emm_Device_Name    := 'EMMXXXX0';
  with Regs do
    begin
      AH := $35;
      AL := $67;
      Intr ($21, Regs);
      For Position := 0 to 7 do
                      Int_67_Device_Name :=
                        Int_67_Device_Name + Chr (mem[ES:Position + $0A]);
      EmsInstalled := True;
      If Int_67_Device_Name <> Emm_Device_Name
                      then EmsInstalled := False;
    end;
end;

function GetFreePages(var Allpages,FreePages:Word) : Byte;
var A:byte;
    C,D:Word;
begin

asm
  mov ah,42h
  xor al,al
  int 67h
  mov c,dx
  mov d,bx
  mov a,ah
end;
AllPages:=C;
FreePages:=D;
GetFreePages:=A;
end;

function AllocatePages(Pages:Word;var Handle:Word):Byte;
var A:Byte;
    C:Word;
begin
  asm
    mov ah,43h
    mov bx,pages
    int 67h
    mov a,ah
    mov C,dx
  end;
  Handle:=C;
  AllocatePages:=A;
end;

function MapPages(Handle,LogicalPage:Word;PhysicalPage:Byte):Byte;
var A:Byte;
begin
  asm
    mov al,PhysicalPage
    mov dx,handle
    mov bx,logicalpage
    mov ah,44h
    int 67h
    mov a,ah
  end;
  MapPages:=A;
end;

function GetAddress(var Address:Word):Byte;
var A:Byte;
    B:Word;
begin
  asm
    mov ah,41h
    int 67h
    mov b,bx
  end;
  Address:=B;
  GetAddress:=A;
end;

function DeAllocatePages(Handle:Word):Byte;
var A:Byte;
begin
  asm
    mov ah,45h
    xor al,al
    mov dx,handle
    int 67h
    mov a,ah
  end;
  DeAllocatePages:=A;
end;

procedure CheckError(A:Byte);
begin
  If A<>0 then
    begin
      If A=$80 then EMSError('vnitrni chyba driveru EMS!');
      If A=$81 then EMSError('problem s pametovou deskou EMS!');
      If A=$82 then EMSError('emm je zamestnan!');
      If A=$83 then EMSError('spatna rukojet!');
      If A=$84 then EMSError('pozadovana spatne funkce!');
      If A=$85 then EMSError('vice rukojeti EMM jiz neni dostupnych!');
      If A=$86 then EMSError('chyba pri ukladani nebo vybirani informaci o primapovani pameti!');
      If A=$87 then EMSError('pozadavek na alokaci byl vetsi, nez fyzicky existuje!');
      If A=$88 then EMSError('nedostatek volne EMS pameti!');
      If A=$89 then EMSError('neda se otevrit obsluha s nulovym poctem stranek!');
      If A=$8a then EMSError('neplatne cislo logicke stranky!');
      If A=$8b then EMSError('neplatne cislo fyzicke stranky (plati jen 0-3)!');
      If A=$8c then EMSError('hardwarova oblast ulozeni mapovani stranek je plna!');
      If A=$8d then EMSError('neuspesne ulozeni stavu mapovani!');
      If A=$8e then EMSError('neda se obnovit mapa (nebyla ulozena)!');
      If A=$8f then EMSError('nedefinovany parametr podfunkce!');
    end;
end;


end.