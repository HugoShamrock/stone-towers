uses Graph,myska,crt;

var
 grDriver: Integer;
 grMode: Integer;
 ErrCode: Integer;
 label 1;
begin
 grDriver := Detect;
 InitGraph(grDriver, grMode,' ');
 ErrCode := GraphResult;
 if ErrCode = grOk then
 begin  { Do graphics }
  Line(0, 0, GetMaxX, GetMaxY);
  ukaz_mysku;
  repeat


  until keypressed;
  schovej_mysku;
   CloseGraph;
 end
 else
   Writeln('Graphics error:', GraphErrorMsg(ErrCode));
 writeln(grDriver,' ',grMode,' ',GetMaxX,' ',GetMaxY);
end.

