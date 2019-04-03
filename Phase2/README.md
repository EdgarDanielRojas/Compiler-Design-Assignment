# Semantic Analysis

 In this course we will use syntax-oriented translation to generate intermediate code for the interpreter, thus the semantic analysis and code generation are done at the same time.

The semantic analysis is responsible for type checking and type conversion as well as checking for correct declaration of identifiers.
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
