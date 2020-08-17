program main( input, output );
var Fibonacci1, Fibonacci2 : integer;
var   temp : integer;
var   n : integer;
var   count : integer;

begin
   n := 10;
   Fibonacci1 := 0;
   Fibonacci2 := 1;
   count := 2;
   sum := 1;
   while (count<n) do{
      temp := Fibonacci2;
      Fibonacci2 := Fibonacci1 + Fibonacci2;
      Fibonacci1 := temp;
      sum := sum + Fibonacci2;
      count := count + 1;
    };
    sum := sum + 0;

end