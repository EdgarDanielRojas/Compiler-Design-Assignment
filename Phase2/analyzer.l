  /* This is the declaration section */
  /* This is the rule definition */
%{

%}

%option yylineno

%%
  /* This is the exact same file from the previous assignment, with the exception that it returns the value of the Token instead of incrementing counters */

  /* These are the definitions for reserved symbols, we could combine them in one with various | but I decided to seperate them. */
int					{return INTEGER;}
float				{return FLOAT;}
if					{return IF;}
then				{return THEN;}
else				{return ELSE;}
while				{return WHILE;}
read				{return READ;}
write				{return WRITE;}
do          {return DO;}
  /* These are the definitions for puntuation symbols, we could combine them in one with various | but I decided to seperate them. */
\(					{return LPAREN;}						
\)					{return RPAREN;}						
\{					{return LBRACE;}	
\}					{return RBRACE;}	
,					{return NOTUSED;}
;					{return SEMI;}
  /* These are the definitions for relational symbols, we could combine them in one with various | but I decided to seperate them. */
\<					{return LT;}
=					{return EQ;}
\<=					{return LTEQ;}
\>=					{return MTEQ;}
!=					{return NEQ;}
  /* These are the definitions for arithmetic and logical symbols, we could combine them in one with various | but I decided to seperate them. */
\+					{return PLUS;}						
-					{return MINUS;} 						
\*					{return TIMES;} 						
\/					{return DIV;}
  /* These are the definitions for assignment symbols, we could combine them in one with various | but I decided to seperate them. */ 							
:=					{return ASSIGN;}
  /* These are the definitions for number symbols, we could combine them in one with various | but I decided to seperate them. */
[0-9][0-9]*			{return INT_NUM;}
0(c|C)[0-7]+		{return OCT_NUM;}
0(x|X)[0-9A-Fa-f]+  {return HEX_NUM;}
[+-]?[0-9]*"."[0-9]+([eE][-+]?[0-9]+)?		{return FLOAT_NUM;}
  /* These are the definitions for Identifier symbols, we could combine them in one with various | but I decided to seperate them. */
[A-Za-z_][A-Za-z0-9_]*						{yylval.stringVal = strdup(yytext);return ID;}
  /* These are the definitions for comment symbols, we could combine them in one with various | but I decided to seperate them. */
"/*"((("*"[^/])?)|[^*])*"*/"				{for(int i = 0; i<strlen(yytext);i++){if(yytext[i]=='\n')yylineno++;}}
"//".*										
  /* Expresions for blank spaces in the files*/
\n  { }
\t
\r
\v
\f
" "
  /* Last rule that indicates no other rule was met and thus the token is an error */
. 											{return yytext[0];}

%%