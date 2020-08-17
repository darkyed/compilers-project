program main( input, output );
  var a: integer;
begin
  a := 0;
  b := 20;
  c := 10;
  r := 0;
  while (a < b) do {
    while (c<a) do{
       r := a+c;
       c := c+1;
    };
    a := a + 2;
  };
  r := r+0;
end