# Syntatic-Analyzer
Systantic Analyzer for Programming Languages Class. This program acts as a complement to the previous Lexical Analyzer, as this program takes tokens and compares it to a defined grammar.

## Tokens Detected

* Reserved words: “int” “float” “if” “then” “else” "while" “read” “write”
* Punctuation tokens: “,” “;” “(” “)” “{” “}”
* Relational tokens: “<” “=” "<=" ">=" "!="
* Arithmetic and Logic operations: “+” “-” “*” “/”
* Assignment operation: “:=”
* Numbers are expressed by the following regular expression:
[1-9][0-9]* | 0(c|C)[0-7]+ | 0(x|X)[0-9A-Fa-f]+ | [+-]?[0-9]*”.”[0-9]+([eE][-+]?[0-9]+)?
* Identifiers are expressed by the following regular expression: [A-Za-z_][A-Za-z0-9_]*
* Comments are similar to those in C "/* comment */"and can span multiple lines.

## Grammar Detected
* program     -> var_dec stmt_seq
* var_dec     -> var_dec single_dec  | epsilon
* single_dec  -> type ID SEMI
* type        -> INTEGER | FLOAT
* stmt_seq    -> stmt_seq stmt  | epsilon
* stmt        -> IF exp THEN stmt  | IF exp THEN stmt ELSE stmt| WHILE exp DO stmt  | variable ASSIGN exp SEMI| READ LPAREN variable RPAREN SEMI| WRITE LPAREN exp RPAREN SEMI | block
* block       -> LBRACE stmt_seq RBRACE
* exp         -> simple_exp LT simple_exp | simple_exp EQ simple_exp  | simple_exp
* simple_exp  -> simple_exp PLUS term | simple_exp MINUS term | term
* term        -> term TIMES factor  | term DIV factor  | factor
* factor      -> LPAREN exp RPAREN | INT_NUM  | FLOAT_NUM  | variable
* variable    -> ID
* epsilon     -> 

# How to Compile
### Windows Users
1. Use a real OS

### Linux Users
1. Compile the calc_grammar.y file using  ```bison -d grammar.y```
2. Compile the analyzer.l file using ```flex analyzer.l```
3. Files named lex.yy.c,calc_grammar.tab.c and calc_grammar.tab.h are generated, that is compiled using gcc with the following command ```gcc `pkg-config gtk+-2.0 --cflags --libs` -O2 UserDefined.c grammar.tab.c -o calc -lfl```
4. An output file is generated named a.out, or if using the -o flag, it will have the name indicated.

### Mac Users
1. Compile the calc_grammar.y file using  ```bison -v grammar.y```
2. Compile the analyzer.l file using ```flex analyzer.l```
3. Files named lex.yy.c,calc_grammar.tab.c and calc_grammar.tab.h are generated, that is compiled using gcc with the following command ```gcc `pkg-config gtk+-2.0 --cflags --libs` -O2 UserDefined.c grammar.tab.c -o calc -ll```
4. An output file is generated named a.out, or if using the -o flag, it will have the name indicated.

# How to Run
### Windows Users
1. Use a real OS

### Linux Users
1. To input a file to analyze use ```./name < filename.*```


### Mac Users
1. To input a file to analyze use ```./name.out < filename.*```

# Output generated
The Program will indicate if the syntax is correct with the message "Good Grammar" or if there is a syntax error it will indicate the string where it was found
