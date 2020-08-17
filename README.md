# compilers-project
### CS327: Compilers Course Project
A simple compiler for a subset of Pascal Language

## Features
- While Loop
- Nested While Loop
- Releational Operations (`<`, `>` and `:=`)

## Major Tests
- Simple While Loop
- Nested While Loop
- Fibonacci Number


## Instructions
The main program is distributed across the files `tok.l`, `calc.y`, and `calc.h`

To compile the program you would require `flex` and `bison` to be installed on your machine, and to simulate the output assembly file you would need the `MARS Simulator`.

Compile as follows

```
cd ./compiler
make
```
This generates the file `a.out`.

The tests are inside the directory `tests`. To run any of the tests, let's say `while_do.pas`, do as follows:

```
./a.out < ./tests/while_do.p
```

This generates an assembly file named `asmb.asm` in the `compiler` directory. You can load this file in MARS to simulate it.


### Note
Condition inside the while loop should be of atomic nature (var relop var).

## Group Members
- Nidhin Harilal
- Saumitra Sharma
- Rushil Shah

