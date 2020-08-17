a.out: calc.tab.o lex.yy.o
	gcc -g calc.tab.o lex.yy.o -lfl

calc.tab.o: calc.tab.h calc.tab.c
	gcc -g -c calc.tab.c

lex.yy.o: calc.tab.h lex.yy.c
	gcc -g -c lex.yy.c

lex.yy.c: tok.l
	flex tok.l

calc.tab.h: calc.y
	bison -d calc.y

clean:
	rm calc.tab.c calc.tab.o lex.yy.o a.out calc.tab.h lex.yy.c
