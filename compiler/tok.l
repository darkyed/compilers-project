%{
#include "calc.tab.h"
#include "calc.h"
#include <stdlib.h>

int Adr=0;
symrec *sym_table = (symrec *)0;

%}
 /* regular expressions */
id	[a-zA-Z][a-zA-Z0-9]*
integer		[0-9]+
relation_op "<"|">"|"="|">="|"<="|"!="
whitespace 	[ \t]+
endline		[\r\n]

%%
":="				{
					fprintf( stderr, " [ASSOP]"); 
					return ASSOP;
				}
"<"				{
					yylval.ival=2;
					return RELOP;
				}

">"				{
					yylval.ival=3;
					return RELOP;
				}
"+"|"-"|"*"|"/" {return yytext[0];}

{integer}			{ 
					fprintf( stderr, " [integer:%d]", yylval.ival = atoi(yytext) ); 
					return integer; 
				}

 /* operator tokens */


 /* general keyword tokens */
"program"			{
					fprintf( stderr, " [PROGRAM]" );
					return PROGRAM;
				}


 /* variable and array keyword tokens */
"var"				{
					fprintf( stderr, " [VAR]" );
					return VAR;
				}

"integer"			{
					fprintf( stderr, " [INTEGER]" );
					return INTEGER;
				}


 /* control-flow keyword tokens */
"do"				{
					fprintf( stderr, " [DO]" );
					return DO;
				}
"while"			{
					fprintf( stderr, " [WHILE]" );
					return WHILE;
				}

"begin"			{
					fprintf( stderr, " [BEGIN]" );
					return BEG;
				}
"end"				{
					fprintf( stderr, " [END]" );
					return END;
				}

 /* identifier tokens */
{id}	{fprintf(stderr,"%s ",yytext);
	symrec *s;s=getsym(yytext); if(s==0) s=putsym(yytext,IDENT);yylval.tptr=s;return IDENT;

				}

 /* ignore whitespace and set default */
{whitespace} 	{ ; }
{endline} 		{
					fprintf( stderr, "\n");
				}
.				{
					fprintf( stderr, "{%c}", yytext[0] );
					return yytext[0];
				}

%%

/* The symbol table: a chain of struct symrec.  */


symrec * putsym (char *sym_name,int sym_type){
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  sprintf(ptr->addr,"%d",Adr); /* set value to 0 even if fctn.  */
  Adr=Adr+4;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char *sym_name){
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}