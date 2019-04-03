%{
#include <string.h>
#include <stdio.h>
#include "UserDefined.h"

  /* Function definitions */
void yyerror (char *string);
extern int yylineno;

 /* Removes the warning of yylex() not defined when using C99 */
#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be integer yylex(union YYSTYPE *, void *);
#endif

%}

%union {
  int     intVal;
  float   floatVal;
  char *  stringVal;
  entry_p tableEntry;
}

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
%token <stringVal> ID

%type <intVal> type
%type <tableEntry> variable 
%type <tableEntry> factor term simple_exp exp stmt_seq block stmt
%type <floatVal> FLOAT_NUM
%type <intVal> INT_NUM

%%
   /* include all of the grammar so that bison can parse correctly*/
program: var_dec stmt_seq   {printf("Good Grammar\n");}
            ;
            
var_dec: var_dec single_dec  
            |                {}
            ;

single_dec: type ID SEMI { if(NewItem($2,$1,yylineno)){
                                printf("Duplicate variable '%s' on line %d",$2,yylineno);
                            } 
                        }
            ;

type: INTEGER { $$ = integer;}
    | FLOAT   { $$ = real;}
            ;


stmt_seq: stmt_seq stmt  
    |           {}
            ;

stmt:  IF exp THEN stmt                                 {}
                    | IF exp THEN stmt ELSE stmt        {}
                    | WHILE exp DO stmt                 {}
                    | variable ASSIGN exp SEMI          {
                                                        if(($1->type == real) && ($3->type == real)) {
                                                             uVal value;
                                                             value.r_value = 0;
                                                             $$ = createTempConstant(value, real);
                                                            // Do sth
                                                        }
                                                        else if(($1->type == integer)&& ($3->type == integer)) {
                                                            uVal value;
                                                            value.r_value = 0;
                                                            $$ = createTempConstant(value, integer);
                                                            // ASSIGN to
                                                        }
                                                        else {
                                                            printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                            exit(EXIT_FAILURE);
                                                        }

                                                        }
                    | READ LPAREN variable RPAREN SEMI  {}
                    | WRITE LPAREN exp RPAREN SEMI      {}
                    | block                             {}
            ;

block: LBRACE stmt_seq RBRACE           {}
            ;


exp: simple_exp LT simple_exp           {}
            | simple_exp EQ simple_exp  {} 
            | simple_exp                {}
            ;


simple_exp: simple_exp PLUS term    {
                                        if(($1->type==integer) && ($3->type==integer)) {
                                            uVal value;
                                            value.i_value = 0;
                                            $$ = createTempConstant(value, integer);
                                        }
                                        else if(($1->type==real) && ($3->type==real)) {
                                            uVal value;
                                            value.r_value = 0;
                                            $$ = createTempConstant(value, real);
                                        }
                                          // Coersion
                                        else {
                                            if($$->type == real) {
                                                if(($1->type==real) && ($3->type==integer)) {
                                                    uVal value;
                                                    value.r_value = 0;
                                                    $$ = createTempConstant(value, real);
                                                }
                                                else if(($1->type==integer) && ($3->type==real)) {
                                                    uVal value;
                                                    value.r_value = 0;
                                                    $$ = createTempConstant(value, real);
                                                }
                                                else {
                                                    printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                    exit(EXIT_FAILURE);
                                                }
                                            }
                                            else {
                                                printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                exit(EXIT_FAILURE);
                                            }
                                        }
                                    }
            | simple_exp MINUS term {
                                        if(($1->type==integer) && ($3->type==integer)) {
                                            uVal value;
                                            value.i_value = 0;
                                            $$ = createTempConstant(value, integer);
                                        }
                                        else if(($1->type==real) && ($3->type==real)) {
                                            uVal value;
                                            value.r_value = 0;
                                            $$ = createTempConstant(value, real);
                                        }
                                        else {
                                            if($$->type == real) {
                                                if(($1->type==real) && ($3->type==integer)){
                                                    uVal value;
                                                    value.r_value = 0;
                                                    $$ = createTempConstant(value, real);
                                                }
                                                else if(($1->type==integer) && ($3->type==real)){
                                                    uVal value;
                                                    value.r_value = 0;
                                                    $$ = createTempConstant(value, real);
                                                }
                                                else{
                                                    printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                    exit(EXIT_FAILURE);
                                                }
                                            }
                                        }
                                    }
            | term                  {$$ = $1;}
            ;


term: term TIMES factor         {
                                    if(($1->type==integer) && ($3->type==integer)) {
                                        uVal value;
                                        //value.i_value = 0;
                                        value.i_value = $1->value.i_value * $3->value.i_value;
                                        $$ = createTempConstant(value, integer);
                                    }
                                    else if(($1->type==real) && ($3->type==real)) {
                                        uVal value;
                                        //value.r_value = 0;
                                        value.r_value = $1->value.r_value * $3->value.r_value;
                                        $$ = createTempConstant(value, real);
                                    }
                                    else {
                                        if(($1->type==real) && ($3->type==integer)){
                                            uVal value;
                                            //value.r_value = 0;
                                            value.r_value = $1->value.r_value * $3->value.i_value;
                                            $$ = createTempConstant(value, real);
                                        }
                                        else if(($1->type==integer) && ($3->type==real)){
                                            uVal value;
                                            value.r_value = 0;
                                            value.r_value = $1->value.i_value * $3->value.r_value;
                                            $$ = createTempConstant(value, real);
                                        }
                                        else{
                                            printf("Error Line %d: Non compatible types\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                    }
                                }
            | term DIV factor   {
                                    if(($1->type==integer) && ($3->type==integer)) {
                                        uVal value;
                                        value.i_value = 0;
                                        if($3->value.i_value == 0){
                                            printf("Error Line %d: Division by zero\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                        $$ = createTempConstant(value, integer);
                                    }
                                    else if(($1->type==real) && ($3->type==real)) {
                                        uVal value;
                                        value.r_value = 0;
                                        if($3->value.r_value == 0.0){
                                            printf("Error Line %d: Division by zero\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                        $$ = createTempConstant(value, real);
                                    }
                                    else {
                                        if(($1->type==real) && ($3->type==integer)){
                                            uVal value;
                                            value.r_value = 0;
                                            if($3->value.i_value == 0){
                                                printf("Error Line %d: Division by zero\n" ,yylineno);
                                                exit(EXIT_FAILURE);
                                            }
                                            $$ = createTempConstant(value, real);
                                        }
                                        else if(($1->type==integer) && ($3->type==real)){
                                            uVal value;
                                            value.r_value = 0;
                                            if($3->value.r_value == 0.0){
                                                printf("Error Line %d: Division by zero\n" ,yylineno);
                                                exit(EXIT_FAILURE);
                                            }
                                            $$ = createTempConstant(value, real);
                                        }
                                        else{
                                            printf("Error Line %d: Non compatible types\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                      }
                                }
            | factor            {}
            ;


factor: LPAREN exp RPAREN {}
            | INT_NUM       {
                                uVal value;
                                value.i_value = $1;
                                $$ = createTempConstant(value,integer);
                            }
            | FLOAT_NUM     {
                                uVal value;
                                value.r_value = $1;
                                $$ = createTempConstant(value,real);
                            }
            | variable      {$$ = $1;}
            ; 


variable: ID {
                entry_p temp = FindItem($1);
                if(temp == NULL){
                    printf("Error Line %d: Variable '%s' is undeclared\n" ,yylineno, $1);
                    exit(EXIT_FAILURE);
                }
                else{
                    $$ = temp;
                }
            }
            ;


%%

/* Function prototype for yylex() */
int yylex();

#include "lex.yy.c"
/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("Syntax error %s on line %d\n",yytext,yylineno);
}

/* Bison does NOT define the main entry point so define it here */
int main (void){
    SymbolTable = g_hash_table_new_full(g_str_hash, g_str_equal,NULL,(GDestroyNotify)FreeItem);
    yyparse();
    PrintTable(SymbolTable);
    DestroyTable(SymbolTable);
}
