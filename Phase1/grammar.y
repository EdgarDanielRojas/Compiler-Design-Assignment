%{
#include <string.h>
#include <stdio.h>

  /* Function definitions */
void yyerror (char *string);

 /* Removes the warning of yylex() not defined when using C99 */
#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be int yylex(union YYSTYPE *, void *);
#endif

%}

 /* Here the declaration of all the tokens used is made */
%token INTEGER
%token FLOAT
%token IF
%token THEN
%token ELSE
%token WHILE
%token READ
%token WRITE
%token DO
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token NOTUSED
%token SEMI
%token LT
%token EQ
%token LTEQ
%token MTEQ
%token NEQ
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token ASSIGN
%token INT_NUM
%token OCT_NUM
%token HEX_NUM
%token FLOAT_NUM
%token ID

%%
   /* include all of the grammar so that bison can parse correctly*/
program: var_dec stmt_seq   {printf("Good Grammar\n");}
            ;
            
var_dec: var_dec single_dec  | epsilon
            ;

single_dec: type ID SEMI
            ;

type: INTEGER | FLOAT
            ;


stmt_seq: stmt_seq stmt  | epsilon
            ;

stmt:  IF exp THEN stmt  
                    | IF exp THEN stmt ELSE stmt
                    | WHILE exp DO stmt  
                    | variable ASSIGN exp SEMI
                    | READ LPAREN variable RPAREN SEMI
                    | WRITE LPAREN exp RPAREN SEMI
                    | block
            ;

block: LBRACE stmt_seq RBRACE
            ;


exp: simple_exp LT simple_exp | simple_exp EQ simple_exp  | simple_exp
            ;


simple_exp: simple_exp PLUS term | simple_exp MINUS term | term
            ;


term: term TIMES factor  | term DIV factor  | factor
            ;


factor: LPAREN exp RPAREN | INT_NUM  | FLOAT_NUM  | variable
            ;


variable: ID 
            ;

epsilon:
;
%%

/* Function prototype for yylex() */
int yylex();

#include "lex.yy.c"

/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("Syntax error %s\n",yytext);
}

/* Bison does NOT define the main entry point so define it here */
int main (void){
  yyparse();
}
