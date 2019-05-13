%{
#include <string.h>
#include <stdio.h>
//#include "UserDefined.h"
#include "CodeGen.h"
  /* Function definitions */
void yyerror (char *string);
extern int yylineno;
void warningW (char *string);
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
  stmt_p stmtEntry;
  exp_p expEntry;
  mn_p  mnEntry;
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
%type <expEntry> factor term simple_exp exp
%type <stmtEntry> stmt_seq block stmt
%type <mnEntry> N M
%type <floatVal> FLOAT_NUM
%type <intVal> INT_NUM

%%
   /* include all of the grammar so that bison can parse correctly*/
program: var_dec stmt_seq   {printf("Good Grammar\n");}
            ;

var_dec: var_dec single_dec
            |                {}
            ;

single_dec: type ID SEMI { if(NewItem($2,$1,yylineno) == NULL){
                                printf("Duplicate variable '%s' on line %d",$2,yylineno);
                            }
                        }
            ;

type: INTEGER { $$ = integer;}
    | FLOAT   { $$ = real;}
            ;


stmt_seq: stmt_seq stmt {
                          $$ = createStmt(mergeList($1->next,$2->next));
                        }
    |                   {
                          $$ = createStmt(NULL);
                        }
            ;

stmt:  IF exp THEN M stmt                                     {
                                                                backPatch($2->true,$4->quad);
                                                                $$ = createStmt(mergeList($2->false,$5->next));
                                                              }
                    | IF exp THEN M stmt N ELSE M stmt        {
                                                                backPatch($2->true,$4->quad);
                                                                backPatch($2->false,$8->quad);
                                                                $$ = createStmt(mergeList($5->next,mergeList($6->next,$9->next)));
                                                              }
                    | WHILE M exp DO M stmt                       {
                                                                backPatch($3->true,$5->quad);
                                                                backPatch($3->false,cline+1);
                                                                $$ = createStmt($3->false);
                                                                createCodeEntry(NULL,GOTO,NULL,NULL,$2->quad);
                                                              }
                    | variable ASSIGN exp SEMI          {
                                                        if($1->type == $3->place->type) {
                                                             /*union val value;
                                                             value.r_value = 0;
                                                             $$ = createTempConstant(value, real);*/
                                                             $$ = createStmt(NULL);
                                                             createCodeEntry($1,ASSIGNOP,$3->place,NULL,0);
                                                            // Do sth
                                                        }
                                                        else{
                                                            warningW("Incompatible types, posible loss of precision");
                                                            $$ = createStmt(NULL);
                                                            createCodeEntry($1,ASSIGNOP,$3->place,NULL,0);
                                                            /*union val value;
                                                            value.i_value = 0;
                                                            $$ = createTempConstant(value, integer);*/
                                                            // ASSIGN to
                                                        }
                                                        /*else {
                                                            warningW("Incompatible types, posible loss of precision");
                                                        }*/

                                                        }
                    | READ LPAREN variable RPAREN SEMI  {
                                                          $$ = createStmt(NULL);
                                                          createCodeEntry($3,READOP,NULL,NULL,0);
                                                        }
                    | WRITE LPAREN exp RPAREN SEMI      {
                                                          $$ = createStmt(NULL);
                                                          createCodeEntry(NULL,WRITEOP,$3->place,NULL,0);
                                                        }
                    | block                             {
                                                          $$ = createStmt($1->next);
                                                        }
            ;

block: LBRACE stmt_seq RBRACE           {
                                          $$ = createStmt($2->next);
                                        }
            ;


exp: simple_exp LT simple_exp           {
                                          $$ = createExp(cline,cline+1,NULL);
                                          createCodeEntry(NULL,LTOP,$1->place,$3->place,0);
                                          createCodeEntry(NULL,GOTO,NULL,NULL,0);
                                        }
            | simple_exp EQ simple_exp  {
                                        $$ = createExp(cline,cline+1,NULL);
                                        createCodeEntry(NULL,EQOP,$1->place,$3->place,0);
                                        createCodeEntry(NULL,GOTO,NULL,NULL,0);
                                        }
            | simple_exp                {
                                          $$ = $1;
                                        }
            ;


simple_exp: simple_exp PLUS term    {
                                        entry_p temp;
                                        if(($1->place->type==integer) && ($3->place->type==integer)) {
                                            union val value;
                                            value.i_value = 0;
                                            temp = createTempConstant(value, integer);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else if(($1->place->type==real) && ($3->place->type==real)) {
                                            union val value;
                                            value.r_value = 0.0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else {
                                            warningW("Incompatible types, posible loss of precision");
                                                if(($1->place->type==real) && ($3->place->type==integer)) {
                                                    union val value;
                                                    value.r_value = 0.0;
                                                    temp = createTempConstant(value, real);
                                                    $$ = createExp(-1,-1,temp);
                                                }
                                                else if(($1->place->type==integer) && ($3->place->type==real)) {
                                                    union val value;
                                                    value.r_value = 0.0;
                                                    temp = createTempConstant(value, real);
                                                    $$ = createExp(-1,-1,temp);
                                                    printf("Created temporal %d",yylineno);
                                                }
                                                else {
                                                    printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                    exit(EXIT_FAILURE);
                                                }
                                        }
                                        createCodeEntry(temp,ADDOP,$1->place,$3->place,0);
                                    }
            | simple_exp MINUS term {
                                        entry_p temp;
                                        if(($1->place->type==integer) && ($3->place->type==integer)) {
                                            union val value;
                                            value.i_value = 0;
                                            temp = createTempConstant(value, integer);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else if(($1->place->type==real) && ($3->place->type==real)) {
                                            union val value;
                                            value.r_value = 0.0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else {
                                          warningW("Incompatible types, posible loss of precision");
                                            if(($1->place->type==real) && ($3->place->type==integer)){
                                                union val value;
                                                value.r_value = 0.0;
                                                temp = createTempConstant(value, real);
                                                $$ = createExp(-1,-1,temp);
                                            }
                                            else if(($1->place->type==integer) && ($3->place->type==real)){
                                                union val value;
                                                value.r_value = 0.0;
                                                temp = createTempConstant(value, real);
                                                $$ = createExp(-1,-1,temp);
                                            }
                                            else{
                                                printf("Error Line %d: Non compatible types\n" ,yylineno);
                                                exit(EXIT_FAILURE);
                                            }
                                        }
                                        createCodeEntry(temp,SUBOP,$1->place,$3->place,0);
                                    }
            | term                  {$$ = $1;}
            ;


term: term TIMES factor         {
                                    entry_p temp;
                                    if(($1->place->type==integer) && ($3->place->type==integer)) {
                                        union val value;
                                        //value.i_value = 0;
                                        value.i_value = 0;
                                        temp = createTempConstant(value, integer);
                                        $$ = createExp(-1,-1,temp);
                                    }
                                    else if(($1->place->type==real) && ($3->place->type==real)) {
                                        union val value;
                                        //value.r_value = 0;
                                        value.r_value = 0.0;
                                        temp = createTempConstant(value, real);
                                        $$ = createExp(-1,-1,temp);
                                    }
                                    else {
                                      warningW("Incompatible types, posible loss of precision");
                                        if(($1->place->type==real) && ($3->place->type==integer)){
                                            union val value;
                                            //value.r_value = 0;
                                            value.r_value = 0.0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else if(($1->place->type==integer) && ($3->place->type==real)){
                                            union val value;
                                            value.r_value = 0.0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else{
                                            printf("Error Line %d: Non compatible types\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                    }
                                    createCodeEntry(temp,MULOP,$1->place,$3->place,0);
                                }
            | term DIV factor   {
                                    entry_p temp;
                                    if(($1->place->type==integer) && ($3->place->type==integer)) {
                                        union val value;
                                        value.i_value = 0;
                                        temp = createTempConstant(value, integer);
                                        $$ = createExp(-1,-1,temp);
                                    }
                                    else if(($1->place->type==real) && ($3->place->type==real)) {
                                        union val value;
                                        value.r_value = 0.0;
                                        temp = createTempConstant(value, real);
                                        $$ = createExp(-1,-1,temp);
                                    }
                                    else {
                                        if(($1->place->type==real) && ($3->place->type==integer)){
                                            union val value;
                                            value.r_value = 0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else if(($1->place->type==integer) && ($3->place->type==real)){
                                            union val value;
                                            value.r_value = 0;
                                            temp = createTempConstant(value, real);
                                            $$ = createExp(-1,-1,temp);
                                        }
                                        else{
                                            printf("Error Line %d: Non compatible types\n" ,yylineno);
                                            exit(EXIT_FAILURE);
                                        }
                                      }
                                      createCodeEntry(temp,DIVOP,$1->place,$3->place,0);
                                }
            | factor            { $$ = $1; }
            ;


factor: LPAREN exp RPAREN { $$ = $2; }
            | INT_NUM       {
                                entry_p temp;
                                union val value;
                                value.i_value = $1;
                                temp = createTempConstant(value,integer);
                                $$ = createExp(-1,-1,temp);
                            }
            | FLOAT_NUM     {
                                entry_p temp;
                                union val value;
                                value.r_value = $1;
                                temp = createTempConstant(value,real);
                                $$ = createExp(-1,-1,temp);
                            }
            | variable      {
                            //$$ = $1;
                            $$ = createExp(-1,-1,$1);
                            }
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
M: %empty                                 {
                                               // Add the quad address
                                               // Code:
                                               //    M.quad = cline
                                               $$ = createMN(0,cline);
                                           }
        ;

 N: %empty                                 {
                                               // Code:
                                               //    N.next_list = newList(cline)
                                               //    gen('goto _')
                                               $$ = createMN(cline,0);
                                               createCodeEntry(NULL,GOTO,NULL,NULL,-1);

                                           };


%%

/* Function prototype for yylex() */
int yylex();

#include "lex.yy.c"
/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("Syntax error %s on line %d\n",yytext,yylineno);
}

void warningW(char *string){
    printf("WARNING : %s on line %d\n",string,yylineno);
}

/* Bison does NOT define the main entry point so define it here */
int main (void){
    SymbolTable = g_hash_table_new_full(g_str_hash, g_str_equal,NULL,(GDestroyNotify)FreeItem);
    codeArray = g_ptr_array_new();
    cline=0;
    yyparse();
    PrintTable(SymbolTable);
    printCode(codeArray);
    interpretCode(codeArray);
    printf("\n Final SymbolTable\n");
    PrintTable(SymbolTable);
    DestroyTable(SymbolTable);
}
