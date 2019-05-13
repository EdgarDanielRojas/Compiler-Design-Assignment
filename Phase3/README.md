# Semantic Analysis and Code generation

In this course we will use syntax-oriented translation to generate intermediate code for the interpreter, thus the semantic analysis and code generation are done at the same time.

The semantic analysis is responsible for type checking and type conversion as well as checking for correct declaration of identifiers. This will require extensive symbol table management so make sure you have implemented your symbol table management routines before you start working on the semantic analysis.

The intermediate code generation is the most time-consuming part of the project so please don’t underestimate it. This part of the project will generate quadruples for each of the code segments analyzed so far. You can use back patching to generate correct jump addresses or you can generate an output file and then process the jump targets separately. The output file of this process should contain a list of valid quadruples, defined by you, and serve as input to the interpreter. The class notes propose a format for the quadruples, but feel free to modify them to suit your own needs.



# Interpreter

This is the final stage of your project. You must execute the output of the intermediate code generation in a pseudo virtual machine. This virtual machine must be capable of reading from the keyboard and displaying the information on the screen. Rudimentary memory management should also be implemented.

This part of the project is not that complex and can be done in a short time, provided you fully understand what your quadruples do. Unfortunately in past projects this portion is rarely done because teams start the project late.
# How to Compile
### Windows Users
1. Use a real OS

### Linux Users
1. Compile the calc_grammar.y file using  ```bison -d grammar.y```
2. Compile the analyzer.l file using ```flex analyzer.l```
3. Files named lex.yy.c,calc_grammar.tab.c and calc_grammar.tab.h are generated, that is compiled using gcc with the following command ```gcc `pkg-config glib-2.0 --cflags --libs` -O2 UserDefined.c grammar.tab.c -o calc -lfl```
4. An output file is generated named a.out, or if using the -o flag, it will have the name indicated.

### Mac Users
1. Compile the calc_grammar.y file using  ```bison -v grammar.y```
2. Compile the analyzer.l file using ```flex analyzer.l```
3. Files named lex.yy.c,calc_grammar.tab.c and calc_grammar.tab.h are generated, that is compiled using gcc with the following command ```gcc `pkg-config glib-2.0 --cflags --libs` -O2 UserDefined.c grammar.tab.c -o calc -ll```
4. An output file is generated named a.out, or if using the -o flag, it will have the name indicated.

# How to Run
### Windows Users
1. Use a real OS

### Linux Users
1. To input a file to analyze use ```./name < filename.*```


### Mac Users
1. To input a file to analyze use ```./name.out < filename.*```

# Output generated
The Program will indicate if the syntax is correct with the message "Good Grammar" or if there is a syntax error it will indicate the string where it was found. It will also print out the symbol table and the instructions it executes.
