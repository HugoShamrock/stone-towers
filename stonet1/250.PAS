uses engine;

const path='c:\er!nie\engine';  {adresar}
      page=32; {c}              {pocet alokovanych stranek}
      text='text'; {c,old:name}  {jmeno textury}
      mids='cmf'; {old:prc}
      jpgs='gif'; {old:prg}
      scrx=58; {old:xc}
      scry=6;  {old:yc}

type smery=(s,v,j,z);

type pozice=record
              x:integer; {c}
              y:integer; {c}
              s:smery;
            end;

const start:pozice(5,18,s); {c,old:xs,ys,sms}


procedure init2;

begin
end;

procedure run2;

begin
end;

procedure done2;

begin
end;

begin
  init;
  run;
  done;
end.