%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "calc.h"  /* Contains definition of `symrec'        */
int  yylex(void);
void yyerror (char  *);
int whileStart=0,nextJump=0; /*two separate variables not necessary for this application*/
int count=0;
int labelCount=0;
FILE *fp;
struct StmtsNode *final;
void StmtsTrav(stmtsptr ptr);
void StmtTrav(stmtptr ptr);
%}
%union {
  int ival;
  struct symrec  *tptr;   /* For returning symbol-table pointers      */
  char c[1000];
  char nData[100];
  struct StmtNode *stmtptr;
  struct StmtsNode *stmtsptr;
}

/* The above will cause a #line directive to come in calc.tab.h.  The #line directive is typically used by program 
generators to cause error messages to refer to the original source file instead of to the generated program. */

/* number tokens */
%token <ival> integer

/* operator tokens */
%token <ival> RELOP	
%token ASSOP	/* 	:= 	*/

%token  PROGRAM


%token <tptr> IDENT
%token VAR
%token  INTEGER


%token  WHILE/* count statements for assembly jumps */
%token  BEG END
%token  DO

%type <tptr> ident_list
%type <stmtsptr> decls

%type  <tptr>compound_stmt
%type <stmtsptr> opt_stmts

%type <stmtptr> stmt
%type <nData> x

%type <nData> expr

%type <tptr> id


/* order here specifies precedence */
%right ASSOP
%left '*' '/'
%left '+' '-'


%start program
/* Grammar follows */

%%

program: PROGRAM IDENT '(' ident_list ')' ';' decls compound_stmt ;


ident_list: IDENT	| ident_list ',' IDENT;

decls: decls VAR ident_list ':' INTEGER ';'	| {;}	;

compound_stmt: BEG opt_stmts END	{final = $2;}; 

opt_stmts: {$$=NULL;}
  | stmt {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=1;$$->left=$1,$$->right=NULL;}
	| stmt ';' opt_stmts {$$=(struct StmtsNode *) malloc(sizeof(struct StmtsNode));
   $$->singl=0;$$->left=$1,$$->right=$3;}
	;

stmt: 

  id ASSOP expr{fprintf(stderr,"Test1\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=0;
	    sprintf($$->bodyCode,"%s\nsw $t0,%s($t8)\n", $3, $1->addr);
	    $$->down=NULL;
      fprintf(stderr,"1");}
  

  | WHILE '(' IDENT RELOP IDENT ')' DO '{' opt_stmts '}' { // While statements
      // printf("%d",);
      printf("%s","While Loop\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=1;
	    sprintf($$->initCode,"lw $t0, %s($t8)\nlw $t1, %s($t8)\n", $3->addr,$5->addr);
      if($<ival>4 == 2){
        sprintf($$->initJumpCode,"bge $t0, $t1,");
      } else if($<ival>4 == 3){
        sprintf($$->initJumpCode,"ble $t0, $t1,");
      }
	    $$->down=$9;}
  
  | WHILE '(' IDENT RELOP integer ')' DO '{' opt_stmts '}' { // While statements
      // printf("%d",);
      printf("%s","While Loop\n");$$=(struct StmtNode *) malloc(sizeof(struct StmtNode));
	    $$->isWhile=1;
	    sprintf($$->initCode,"lw $t0, %s($t8)\nli $t1, %d\n", $3->addr,$5);
      if($<ival>4 == 2){
        sprintf($$->initJumpCode,"bge $t0, $t1,");
      } else if($<ival>4 == 3){
        sprintf($$->initJumpCode,"ble $t0, $t1,");

      }
	    $$->down=$9;}
  ;

expr:      x                { sprintf($$,"%s",$1);count=(count+1)%2;}
        | x '+' x  { sprintf($$,"%s\n%s\nadd $t0, $t0, $t1",$1,$3);}
        | x '-' x        { sprintf($$,"%s\n%s\nsub $t0, $t0, $t1",$1,$3);}
        | x '*' x        { sprintf($$,"%s\n%s\nmul $t0, $t0, $t1",$1,$3);}
        | x '/' x        { sprintf($$,"%s\n%s\ndiv $t0, $t0, $t1",$1,$3);}
        
        
;
x:  integer {sprintf($$,"li $t%d, %d",count,$1);count=(count+1)%2;}
| IDENT {sprintf($$, "lw $t%d, %s($t8)",count,$1->addr);count=(count+1)%2;}
   ;



id
	: IDENT	;



%%

void StmtsTrav(stmtsptr ptr){
  // printf("stmts\n");
  if(ptr==NULL) {/*printf("empty")*/;return;}
	  if(ptr->singl==1){printf("single");StmtTrav(ptr->left);}
	  else{
	  StmtTrav(ptr->left);
	  StmtsTrav(ptr->right);
	  }
	  }
 void StmtTrav(stmtptr ptr){
   int ws,nj;
  //  printf("stmt\n");
   if(ptr==NULL) {/*printf("hehe")*/;return;}
   if(ptr->isWhile==0){fprintf(fp,"%s\n",ptr->bodyCode);}
   else{ws=whileStart; whileStart++;nj=nextJump;nextJump++;
     fprintf(fp,"LabStartWhile%d:%s\n%s NextPart%d\n",ws,ptr->initCode,ptr->initJumpCode,nj);StmtsTrav(ptr->down);
     fprintf(fp,"j LabStartWhile%d\nNextPart%d:\n",ws,nj);}
	  
}
   


int main ()
{
   fp=fopen("asmb.asm","w");
   fprintf(fp,".data\n\n.text\nli $t8,268500992\n");
   yyparse ();
   StmtsTrav(final);
   fprintf(fp,"\nli $v0,1\nmove $a0,$t0\nsyscall\n");
   fclose(fp);
}
int yywrap()
{
        return 1;
} 
void yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("%s\n", s);
}